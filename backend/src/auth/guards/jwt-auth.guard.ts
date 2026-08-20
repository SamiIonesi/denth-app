import { Injectable } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

/**
 * Guard that protects routes by requiring a valid JWT access token.
 * Attach with @UseGuards(JwtAuthGuard) on any controller or route
 * that should only be accessible to logged-in users.
 */
@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {}
