import { IsEmail, IsNotEmpty, IsString, MinLength } from 'class-validator';

/**
 * Shape of the data a patient must send to self-register.
 * class-validator decorators below automatically check every
 * field before this data ever reaches our business logic code.
 */
export class RegisterPatientDto {
  @IsEmail()
  email!: string;

  @IsString()
  @MinLength(8)
  password!: string;

  @IsString()
  @IsNotEmpty()
  firstName!: string;

  @IsString()
  @IsNotEmpty()
  lastName!: string;

  @IsString()
  @IsNotEmpty()
  phoneNo!: string;
}
