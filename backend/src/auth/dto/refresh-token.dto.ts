import { IsString, IsNotEmpty } from 'class-validator';

/**
 * Shape of the data needed to request a new access token
 * using a previously issued refresh token.
 */
export class RefreshTokenDto {
  @IsString()
  @IsNotEmpty()
  refreshToken!: string;
}
