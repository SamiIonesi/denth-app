import { Injectable, ConflictException } from '@nestjs/common';
import * as argon2 from 'argon2';
import * as crypto from 'crypto';
import { PrismaService } from '../prisma/prisma.service';
import { RegisterPatientDto } from './dto/register-patient.dto';

/**
 * Handles authentication-related business logic: registration,
 * login, and (later) email verification, password reset, and
 * account invitations for doctors/assistants.
 */
@Injectable()
export class AuthService {
  constructor(private readonly prisma: PrismaService) {}

  /**
   * Registers a new patient account. Creates both the User row
   * (login credentials) and the linked Patient row (profile data)
   * in a single atomic operation.
   */
  async registerPatient(dto: RegisterPatientDto) {
    const existingUser = await this.prisma.user.findUnique({
      where: { email: dto.email },
    });

    if (existingUser) {
      throw new ConflictException('An account with this email already exists.');
    }

    const passwordHash = await argon2.hash(dto.password);

    const emailVerificationToken = crypto.randomBytes(32).toString('hex');
    const emailVerificationExpiresAt = new Date(
      Date.now() + 24 * 60 * 60 * 1000,
    );

    const user = await this.prisma.user.create({
      data: {
        email: dto.email,
        passwordHash,
        role: 'PATIENT',
        emailVerificationToken,
        emailVerificationExpiresAt,
        patient: {
          create: {
            firstName: dto.firstName,
            lastName: dto.lastName,
            phoneNo: dto.phoneNo,
          },
        },
      },
      include: { patient: true },
    });

    // TODO: send verification email once EmailService exists

    return {
      id: user.id,
      email: user.email,
    };
  }
}
