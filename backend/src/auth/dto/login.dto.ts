import { IsEmail, IsString, MinLength } from 'class-validator';

/**
 * Shape of the data a user must send to log in.
 */
export class LoginDto {
  @IsEmail()
  email!: string;

  @IsString()
  @MinLength(1)
  password!: string;
}
