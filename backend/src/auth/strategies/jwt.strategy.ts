import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';

interface JwtPayload {
  sub: number;
  role: string;
}

/**
 * Passport strategy that validates the JWT access token sent in the
 * Authorization header and extracts the user info it contains.
 */
@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor() {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: process.env.JWT_ACCESS_SECRET as string,
    });
  }

  /**
   * Called automatically by Passport after it verifies the token's
   * signature and expiration. Whatever this returns becomes
   * `request.user` in every route protected by this strategy.
   */
  validate(payload: JwtPayload) {
    return { userId: payload.sub, role: payload.role };
  }
}
