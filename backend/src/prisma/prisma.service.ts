import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { PrismaClient } from '../../generated/prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';

/**
 * Injectable service that extends PrismaClient and manages the
 * database connection for the entire lifetime of the application.
 *
 * Uses the PrismaPg adapter (required in Prisma 7) to connect to
 * PostgreSQL, using the connection string from .env.
 */
@Injectable()
export class PrismaService
  extends PrismaClient
  implements OnModuleInit, OnModuleDestroy
{
  constructor() {
    const adapter = new PrismaPg({
      connectionString: process.env.DATABASE_URL,
    });
    super({ adapter });
  }

  /**
   * Called automatically by NestJS when the application starts.
   * Opens the actual database connection.
   */
  async onModuleInit() {
    await this.$connect();
  }

  /**
   * Called automatically by NestJS when the application shuts down.
   * Closes the connection cleanly, avoiding leaked resources.
   */
  async onModuleDestroy() {
    await this.$disconnect();
  }
}
