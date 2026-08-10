import { Global, Module } from '@nestjs/common';
import { PrismaService } from './prisma.service';

/**
 * Global module that makes PrismaService available for injection
 * anywhere in the application, without needing to import this
 * module explicitly in every other module that needs database access.
 */
@Global()
@Module({
  providers: [PrismaService],
  exports: [PrismaService],
})
export class PrismaModule {}
