import { Module } from '@nestjs/common';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';

/**
 * Groups everything related to authentication: the HTTP routes
 * (AuthController) and the business logic behind them (AuthService).
 */
@Module({
  controllers: [AuthController],
  providers: [AuthService],
})
export class AuthModule {}
