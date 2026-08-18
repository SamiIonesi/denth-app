-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('PATIENT', 'DOCTOR', 'ASSISTANT', 'ADMIN');

-- CreateEnum
CREATE TYPE "PreferredLanguage" AS ENUM ('ro', 'en');

-- CreateEnum
CREATE TYPE "AccountInvitationRole" AS ENUM ('DOCTOR', 'ASSISTANT', 'ADMIN');

-- CreateEnum
CREATE TYPE "Weekday" AS ENUM ('MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY');

-- CreateEnum
CREATE TYPE "AppointmentStatus" AS ENUM ('REQUESTED', 'CONFIRMED', 'CANCELLED', 'COMPLETED');

-- CreateEnum
CREATE TYPE "PaymentMethod" AS ENUM ('CASH', 'CARD', 'ONLINE');

-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('PENDING', 'COMPLETED', 'FAILED', 'REFUNDED');

-- CreateEnum
CREATE TYPE "StockItemCategory" AS ENUM ('INSTRUMENT', 'MATERIAL', 'MEDICATION', 'EQUIPMENT');

-- CreateEnum
CREATE TYPE "OrderStatus" AS ENUM ('SENT', 'CONFIRMED', 'DELIVERED');

-- CreateEnum
CREATE TYPE "NotificationType" AS ENUM ('APPOINTMENT_REMINDER', 'STOCK_ALERT', 'ACCOUNT', 'GENERAL');

-- CreateEnum
CREATE TYPE "NotificationChannel" AS ENUM ('IN_APP', 'EMAIL', 'BOTH');

-- CreateEnum
CREATE TYPE "MedicalDocumentType" AS ENUM ('X_RAY', 'PRESCRIPTION', 'CONSENT_FORM', 'LAB_RESULT', 'OTHER');

-- CreateEnum
CREATE TYPE "AuditLogAction" AS ENUM ('CREATE', 'UPDATE', 'DELETE');

-- CreateTable
CREATE TABLE "Country" (
    "_pk_CountryId" SERIAL NOT NULL,
    "CountryName" VARCHAR(100) NOT NULL,
    "CountryCode" CHAR(3) NOT NULL,

    CONSTRAINT "Country_pkey" PRIMARY KEY ("_pk_CountryId")
);

-- CreateTable
CREATE TABLE "County" (
    "_pk_CountyId" SERIAL NOT NULL,
    "_fk_CountryId" INTEGER NOT NULL,
    "CountyName" VARCHAR(100) NOT NULL,
    "CountyCode" VARCHAR(10) NOT NULL,

    CONSTRAINT "County_pkey" PRIMARY KEY ("_pk_CountyId")
);

-- CreateTable
CREATE TABLE "City" (
    "_pk_CityId" SERIAL NOT NULL,
    "_fk_CountyId" INTEGER NOT NULL,
    "CityName" VARCHAR(100) NOT NULL,

    CONSTRAINT "City_pkey" PRIMARY KEY ("_pk_CityId")
);

-- CreateTable
CREATE TABLE "Clinic" (
    "_pk_ClinicId" SERIAL NOT NULL,
    "_fk_CityId" INTEGER NOT NULL,
    "ClinicShortName" VARCHAR(10) NOT NULL,
    "ClinicName" VARCHAR(150) NOT NULL,
    "ClinicStreet" VARCHAR(150) NOT NULL,
    "ClinicStreetNo" VARCHAR(10) NOT NULL,
    "ClinicPostalCode" VARCHAR(10) NOT NULL,
    "ClinicPhoneNo" VARCHAR(20) NOT NULL,
    "ClinicEmail" VARCHAR(150) NOT NULL,

    CONSTRAINT "Clinic_pkey" PRIMARY KEY ("_pk_ClinicId")
);

-- CreateTable
CREATE TABLE "Specialization" (
    "_pk_SpecializationId" SERIAL NOT NULL,
    "SpecializationName" VARCHAR(100) NOT NULL,
    "SpecializationDescription" TEXT NOT NULL,

    CONSTRAINT "Specialization_pkey" PRIMARY KEY ("_pk_SpecializationId")
);

-- CreateTable
CREATE TABLE "User" (
    "_pk_UserId" SERIAL NOT NULL,
    "UserEmail" VARCHAR(150) NOT NULL,
    "UserPasswordHash" VARCHAR(255) NOT NULL,
    "UserRole" "UserRole" NOT NULL,
    "UserEmailVerified" BOOLEAN NOT NULL DEFAULT false,
    "UserEmailVerificationToken" VARCHAR(255),
    "UserEmailVerificationExpiresAt" TIMESTAMP(3),
    "UserPasswordResetToken" VARCHAR(255),
    "UserPasswordResetExpiresAt" TIMESTAMP(3),
    "UserGDPRConsent" BOOLEAN NOT NULL DEFAULT false,
    "UserGDPRConsentDate" TIMESTAMP(3),
    "UserPreferredLanguage" "PreferredLanguage" NOT NULL DEFAULT 'ro',
    "UserCreatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "UserActive" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "User_pkey" PRIMARY KEY ("_pk_UserId")
);

-- CreateTable
CREATE TABLE "AccountInvitation" (
    "_pk_AccountInvitationId" SERIAL NOT NULL,
    "_fk_ClinicId" INTEGER,
    "_fk_InvitedByUserId" INTEGER NOT NULL,
    "AccountInvitationEmail" VARCHAR(150) NOT NULL,
    "AccountInvitationRole" "AccountInvitationRole" NOT NULL,
    "AccountInvitationToken" VARCHAR(255) NOT NULL,
    "AccountInvitationExpiresAt" TIMESTAMP(3) NOT NULL,
    "AccountInvitationUsedAt" TIMESTAMP(3),

    CONSTRAINT "AccountInvitation_pkey" PRIMARY KEY ("_pk_AccountInvitationId")
);

-- CreateTable
CREATE TABLE "Patient" (
    "_pk_PatientId" SERIAL NOT NULL,
    "_fk_UserId" INTEGER NOT NULL,
    "_fk_PreferredClinicId" INTEGER,
    "_fk_CityId" INTEGER,
    "PatientLastName" VARCHAR(100) NOT NULL,
    "PatientFirstName" VARCHAR(100) NOT NULL,
    "PatientNationalId" CHAR(13),
    "PatientBirthDate" DATE,
    "PatientPhoneNo" VARCHAR(20) NOT NULL,
    "PatientStreet" VARCHAR(150),
    "PatientStreetNo" VARCHAR(10),
    "PatientPostalCode" VARCHAR(10),

    CONSTRAINT "Patient_pkey" PRIMARY KEY ("_pk_PatientId")
);

-- CreateTable
CREATE TABLE "Doctor" (
    "_pk_DoctorId" SERIAL NOT NULL,
    "_fk_UserId" INTEGER NOT NULL,
    "_fk_ClinicId" INTEGER NOT NULL,
    "_fk_SpecializationId" INTEGER NOT NULL,
    "DoctorLastName" VARCHAR(100) NOT NULL,
    "DoctorFirstName" VARCHAR(100) NOT NULL,
    "DoctorPhoneNo" VARCHAR(20) NOT NULL,
    "DoctorBirthDate" DATE,
    "DoctorActive" BOOLEAN NOT NULL DEFAULT true,
    "DoctorBio" TEXT,

    CONSTRAINT "Doctor_pkey" PRIMARY KEY ("_pk_DoctorId")
);

-- CreateTable
CREATE TABLE "Assistant" (
    "_pk_AssistantId" SERIAL NOT NULL,
    "_fk_UserId" INTEGER NOT NULL,
    "_fk_ClinicId" INTEGER NOT NULL,
    "AssistantLastName" VARCHAR(100) NOT NULL,
    "AssistantFirstName" VARCHAR(100) NOT NULL,
    "AssistantPhoneNo" VARCHAR(20) NOT NULL,
    "AssistantActive" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "Assistant_pkey" PRIMARY KEY ("_pk_AssistantId")
);

-- CreateTable
CREATE TABLE "MedicalService" (
    "_pk_MedicalServiceId" SERIAL NOT NULL,
    "_fk_SpecializationId" INTEGER,
    "MedicalServiceName" VARCHAR(150) NOT NULL,
    "MedicalServiceDescription" TEXT NOT NULL,
    "MedicalServiceEstimatedDurationMin" INTEGER NOT NULL,

    CONSTRAINT "MedicalService_pkey" PRIMARY KEY ("_pk_MedicalServiceId")
);

-- CreateTable
CREATE TABLE "ClinicMedicalService" (
    "_pk_ClinicMedicalServiceId" SERIAL NOT NULL,
    "_fk_ClinicId" INTEGER NOT NULL,
    "_fk_MedicalServiceId" INTEGER NOT NULL,
    "ClinicMedicalServicePrice" DECIMAL(10,2) NOT NULL,

    CONSTRAINT "ClinicMedicalService_pkey" PRIMARY KEY ("_pk_ClinicMedicalServiceId")
);

-- CreateTable
CREATE TABLE "ClinicSchedule" (
    "_pk_ClinicScheduleId" SERIAL NOT NULL,
    "_fk_ClinicId" INTEGER NOT NULL,
    "ClinicScheduleWeekday" "Weekday" NOT NULL,
    "ClinicScheduleOpenTime" TIME NOT NULL,
    "ClinicScheduleCloseTime" TIME NOT NULL,

    CONSTRAINT "ClinicSchedule_pkey" PRIMARY KEY ("_pk_ClinicScheduleId")
);

-- CreateTable
CREATE TABLE "DoctorAvailability" (
    "_pk_DoctorAvailabilityId" SERIAL NOT NULL,
    "_fk_DoctorId" INTEGER NOT NULL,
    "DoctorAvailabilityWeekday" "Weekday" NOT NULL,
    "DoctorAvailabilityStartTime" TIME NOT NULL,
    "DoctorAvailabilityEndTime" TIME NOT NULL,

    CONSTRAINT "DoctorAvailability_pkey" PRIMARY KEY ("_pk_DoctorAvailabilityId")
);

-- CreateTable
CREATE TABLE "DoctorTimeOff" (
    "_pk_DoctorTimeOffId" SERIAL NOT NULL,
    "_fk_DoctorId" INTEGER NOT NULL,
    "DoctorTimeOffStartDate" DATE NOT NULL,
    "DoctorTimeOffEndDate" DATE NOT NULL,
    "DoctorTimeOffReason" VARCHAR(150),

    CONSTRAINT "DoctorTimeOff_pkey" PRIMARY KEY ("_pk_DoctorTimeOffId")
);

-- CreateTable
CREATE TABLE "Appointment" (
    "_pk_AppointmentId" SERIAL NOT NULL,
    "_fk_PatientId" INTEGER NOT NULL,
    "_fk_DoctorId" INTEGER NOT NULL,
    "_fk_ClinicMedicalServiceId" INTEGER NOT NULL,
    "AppointmentDateTime" TIMESTAMP(3) NOT NULL,
    "AppointmentStatus" "AppointmentStatus" NOT NULL DEFAULT 'REQUESTED',
    "AppointmentCreatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Appointment_pkey" PRIMARY KEY ("_pk_AppointmentId")
);

-- CreateTable
CREATE TABLE "MedicalRecord" (
    "_pk_MedicalRecordId" SERIAL NOT NULL,
    "_fk_PatientId" INTEGER NOT NULL,
    "MedicalRecordMedicalHistory" TEXT NOT NULL,
    "MedicalRecordAllergies" TEXT NOT NULL,
    "MedicalRecordUpdatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "MedicalRecord_pkey" PRIMARY KEY ("_pk_MedicalRecordId")
);

-- CreateTable
CREATE TABLE "Treatment" (
    "_pk_TreatmentId" SERIAL NOT NULL,
    "_fk_MedicalRecordId" INTEGER NOT NULL,
    "_fk_AppointmentId" INTEGER,
    "_fk_DoctorId" INTEGER NOT NULL,
    "TreatmentDescription" TEXT NOT NULL,
    "TreatmentDate" DATE NOT NULL,

    CONSTRAINT "Treatment_pkey" PRIMARY KEY ("_pk_TreatmentId")
);

-- CreateTable
CREATE TABLE "TreatmentItem" (
    "_pk_TreatmentId" INTEGER NOT NULL,
    "_pk_ClinicMedicalServiceId" INTEGER NOT NULL,
    "TreatmentItemQuantity" INTEGER NOT NULL,
    "TreatmentItemUnitPrice" DECIMAL(10,2) NOT NULL,

    CONSTRAINT "TreatmentItem_pkey" PRIMARY KEY ("_pk_TreatmentId","_pk_ClinicMedicalServiceId")
);

-- CreateTable
CREATE TABLE "MedicalDocument" (
    "_pk_MedicalDocumentId" SERIAL NOT NULL,
    "_fk_TreatmentId" INTEGER NOT NULL,
    "_fk_UploadedByUserId" INTEGER NOT NULL,
    "MedicalDocumentType" "MedicalDocumentType" NOT NULL,
    "MedicalDocumentFilePath" VARCHAR(255) NOT NULL,
    "MedicalDocumentUploadedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "MedicalDocument_pkey" PRIMARY KEY ("_pk_MedicalDocumentId")
);

-- CreateTable
CREATE TABLE "Payment" (
    "_pk_PaymentId" SERIAL NOT NULL,
    "_fk_PatientId" INTEGER NOT NULL,
    "PaymentAmount" DECIMAL(10,2) NOT NULL,
    "PaymentMethod" "PaymentMethod" NOT NULL,
    "PaymentStatus" "PaymentStatus" NOT NULL DEFAULT 'PENDING',
    "PaymentDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Payment_pkey" PRIMARY KEY ("_pk_PaymentId")
);

-- CreateTable
CREATE TABLE "PaymentAllocation" (
    "_pk_PaymentId" INTEGER NOT NULL,
    "_pk_TreatmentId" INTEGER NOT NULL,
    "PaymentAllocationAmount" DECIMAL(10,2) NOT NULL,

    CONSTRAINT "PaymentAllocation_pkey" PRIMARY KEY ("_pk_PaymentId","_pk_TreatmentId")
);

-- CreateTable
CREATE TABLE "Supplier" (
    "_pk_SupplierId" SERIAL NOT NULL,
    "SupplierName" VARCHAR(150) NOT NULL,
    "SupplierPhoneNo" VARCHAR(20) NOT NULL,
    "SupplierEmail" VARCHAR(150) NOT NULL,
    "SupplierContactPerson" VARCHAR(150),

    CONSTRAINT "Supplier_pkey" PRIMARY KEY ("_pk_SupplierId")
);

-- CreateTable
CREATE TABLE "StockItem" (
    "_pk_StockItemId" SERIAL NOT NULL,
    "_fk_ClinicId" INTEGER NOT NULL,
    "StockItemName" VARCHAR(150) NOT NULL,
    "StockItemCategory" "StockItemCategory" NOT NULL,
    "StockItemQuantity" INTEGER NOT NULL DEFAULT 0,
    "StockItemMinimumQuantity" INTEGER NOT NULL,
    "StockItemUnit" VARCHAR(20) NOT NULL,

    CONSTRAINT "StockItem_pkey" PRIMARY KEY ("_pk_StockItemId")
);

-- CreateTable
CREATE TABLE "Order" (
    "_pk_OrderId" SERIAL NOT NULL,
    "_fk_SupplierId" INTEGER NOT NULL,
    "_fk_DoctorId" INTEGER NOT NULL,
    "OrderStatus" "OrderStatus" NOT NULL DEFAULT 'SENT',
    "OrderDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Order_pkey" PRIMARY KEY ("_pk_OrderId")
);

-- CreateTable
CREATE TABLE "OrderItem" (
    "_pk_OrderItemId" SERIAL NOT NULL,
    "_fk_OrderId" INTEGER NOT NULL,
    "_fk_StockItemId" INTEGER NOT NULL,
    "OrderItemQuantity" INTEGER NOT NULL,
    "OrderItemUnitPrice" DECIMAL(10,2) NOT NULL,

    CONSTRAINT "OrderItem_pkey" PRIMARY KEY ("_pk_OrderItemId")
);

-- CreateTable
CREATE TABLE "Notification" (
    "_pk_NotificationId" SERIAL NOT NULL,
    "_fk_UserId" INTEGER NOT NULL,
    "NotificationType" "NotificationType" NOT NULL,
    "NotificationChannel" "NotificationChannel" NOT NULL DEFAULT 'IN_APP',
    "NotificationMessage" TEXT NOT NULL,
    "NotificationRead" BOOLEAN NOT NULL DEFAULT false,
    "NotificationCreatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Notification_pkey" PRIMARY KEY ("_pk_NotificationId")
);

-- CreateTable
CREATE TABLE "ChatMessage" (
    "_pk_ChatMessageId" SERIAL NOT NULL,
    "_fk_SenderUserId" INTEGER NOT NULL,
    "_fk_ReceiverUserId" INTEGER NOT NULL,
    "ChatMessageContent" TEXT NOT NULL,
    "ChatMessageSentAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "ChatMessageRead" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "ChatMessage_pkey" PRIMARY KEY ("_pk_ChatMessageId")
);

-- CreateTable
CREATE TABLE "Review" (
    "_pk_ReviewId" SERIAL NOT NULL,
    "_fk_PatientId" INTEGER NOT NULL,
    "_fk_DoctorId" INTEGER NOT NULL,
    "_fk_AppointmentId" INTEGER NOT NULL,
    "ReviewScore" SMALLINT NOT NULL,
    "ReviewComment" TEXT,
    "ReviewApproved" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "Review_pkey" PRIMARY KEY ("_pk_ReviewId")
);

-- CreateTable
CREATE TABLE "AuditLog" (
    "_pk_AuditLogId" SERIAL NOT NULL,
    "_fk_UserId" INTEGER,
    "AuditLogAction" "AuditLogAction" NOT NULL,
    "AuditLogAffectedEntity" VARCHAR(100) NOT NULL,
    "AuditLogAffectedEntityId" INTEGER NOT NULL,
    "AuditLogOldValue" JSONB,
    "AuditLogNewValue" JSONB,
    "AuditLogTimestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AuditLog_pkey" PRIMARY KEY ("_pk_AuditLogId")
);

-- CreateIndex
CREATE UNIQUE INDEX "Clinic_ClinicShortName_key" ON "Clinic"("ClinicShortName");

-- CreateIndex
CREATE UNIQUE INDEX "User_UserEmail_key" ON "User"("UserEmail");

-- CreateIndex
CREATE UNIQUE INDEX "AccountInvitation_AccountInvitationToken_key" ON "AccountInvitation"("AccountInvitationToken");

-- CreateIndex
CREATE UNIQUE INDEX "Patient__fk_UserId_key" ON "Patient"("_fk_UserId");

-- CreateIndex
CREATE UNIQUE INDEX "Doctor__fk_UserId_key" ON "Doctor"("_fk_UserId");

-- CreateIndex
CREATE UNIQUE INDEX "Assistant__fk_UserId_key" ON "Assistant"("_fk_UserId");

-- CreateIndex
CREATE UNIQUE INDEX "ClinicMedicalService__fk_ClinicId__fk_MedicalServiceId_key" ON "ClinicMedicalService"("_fk_ClinicId", "_fk_MedicalServiceId");

-- CreateIndex
CREATE UNIQUE INDEX "MedicalRecord__fk_PatientId_key" ON "MedicalRecord"("_fk_PatientId");

-- CreateIndex
CREATE UNIQUE INDEX "Treatment__fk_AppointmentId_key" ON "Treatment"("_fk_AppointmentId");

-- CreateIndex
CREATE UNIQUE INDEX "Review__fk_AppointmentId_key" ON "Review"("_fk_AppointmentId");

-- AddForeignKey
ALTER TABLE "County" ADD CONSTRAINT "County__fk_CountryId_fkey" FOREIGN KEY ("_fk_CountryId") REFERENCES "Country"("_pk_CountryId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "City" ADD CONSTRAINT "City__fk_CountyId_fkey" FOREIGN KEY ("_fk_CountyId") REFERENCES "County"("_pk_CountyId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Clinic" ADD CONSTRAINT "Clinic__fk_CityId_fkey" FOREIGN KEY ("_fk_CityId") REFERENCES "City"("_pk_CityId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AccountInvitation" ADD CONSTRAINT "AccountInvitation__fk_ClinicId_fkey" FOREIGN KEY ("_fk_ClinicId") REFERENCES "Clinic"("_pk_ClinicId") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AccountInvitation" ADD CONSTRAINT "AccountInvitation__fk_InvitedByUserId_fkey" FOREIGN KEY ("_fk_InvitedByUserId") REFERENCES "User"("_pk_UserId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Patient" ADD CONSTRAINT "Patient__fk_UserId_fkey" FOREIGN KEY ("_fk_UserId") REFERENCES "User"("_pk_UserId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Patient" ADD CONSTRAINT "Patient__fk_PreferredClinicId_fkey" FOREIGN KEY ("_fk_PreferredClinicId") REFERENCES "Clinic"("_pk_ClinicId") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Patient" ADD CONSTRAINT "Patient__fk_CityId_fkey" FOREIGN KEY ("_fk_CityId") REFERENCES "City"("_pk_CityId") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Doctor" ADD CONSTRAINT "Doctor__fk_UserId_fkey" FOREIGN KEY ("_fk_UserId") REFERENCES "User"("_pk_UserId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Doctor" ADD CONSTRAINT "Doctor__fk_ClinicId_fkey" FOREIGN KEY ("_fk_ClinicId") REFERENCES "Clinic"("_pk_ClinicId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Doctor" ADD CONSTRAINT "Doctor__fk_SpecializationId_fkey" FOREIGN KEY ("_fk_SpecializationId") REFERENCES "Specialization"("_pk_SpecializationId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Assistant" ADD CONSTRAINT "Assistant__fk_UserId_fkey" FOREIGN KEY ("_fk_UserId") REFERENCES "User"("_pk_UserId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Assistant" ADD CONSTRAINT "Assistant__fk_ClinicId_fkey" FOREIGN KEY ("_fk_ClinicId") REFERENCES "Clinic"("_pk_ClinicId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MedicalService" ADD CONSTRAINT "MedicalService__fk_SpecializationId_fkey" FOREIGN KEY ("_fk_SpecializationId") REFERENCES "Specialization"("_pk_SpecializationId") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ClinicMedicalService" ADD CONSTRAINT "ClinicMedicalService__fk_ClinicId_fkey" FOREIGN KEY ("_fk_ClinicId") REFERENCES "Clinic"("_pk_ClinicId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ClinicMedicalService" ADD CONSTRAINT "ClinicMedicalService__fk_MedicalServiceId_fkey" FOREIGN KEY ("_fk_MedicalServiceId") REFERENCES "MedicalService"("_pk_MedicalServiceId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ClinicSchedule" ADD CONSTRAINT "ClinicSchedule__fk_ClinicId_fkey" FOREIGN KEY ("_fk_ClinicId") REFERENCES "Clinic"("_pk_ClinicId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DoctorAvailability" ADD CONSTRAINT "DoctorAvailability__fk_DoctorId_fkey" FOREIGN KEY ("_fk_DoctorId") REFERENCES "Doctor"("_pk_DoctorId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "DoctorTimeOff" ADD CONSTRAINT "DoctorTimeOff__fk_DoctorId_fkey" FOREIGN KEY ("_fk_DoctorId") REFERENCES "Doctor"("_pk_DoctorId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Appointment" ADD CONSTRAINT "Appointment__fk_PatientId_fkey" FOREIGN KEY ("_fk_PatientId") REFERENCES "Patient"("_pk_PatientId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Appointment" ADD CONSTRAINT "Appointment__fk_DoctorId_fkey" FOREIGN KEY ("_fk_DoctorId") REFERENCES "Doctor"("_pk_DoctorId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Appointment" ADD CONSTRAINT "Appointment__fk_ClinicMedicalServiceId_fkey" FOREIGN KEY ("_fk_ClinicMedicalServiceId") REFERENCES "ClinicMedicalService"("_pk_ClinicMedicalServiceId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MedicalRecord" ADD CONSTRAINT "MedicalRecord__fk_PatientId_fkey" FOREIGN KEY ("_fk_PatientId") REFERENCES "Patient"("_pk_PatientId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Treatment" ADD CONSTRAINT "Treatment__fk_MedicalRecordId_fkey" FOREIGN KEY ("_fk_MedicalRecordId") REFERENCES "MedicalRecord"("_pk_MedicalRecordId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Treatment" ADD CONSTRAINT "Treatment__fk_AppointmentId_fkey" FOREIGN KEY ("_fk_AppointmentId") REFERENCES "Appointment"("_pk_AppointmentId") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Treatment" ADD CONSTRAINT "Treatment__fk_DoctorId_fkey" FOREIGN KEY ("_fk_DoctorId") REFERENCES "Doctor"("_pk_DoctorId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TreatmentItem" ADD CONSTRAINT "TreatmentItem__pk_TreatmentId_fkey" FOREIGN KEY ("_pk_TreatmentId") REFERENCES "Treatment"("_pk_TreatmentId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "TreatmentItem" ADD CONSTRAINT "TreatmentItem__pk_ClinicMedicalServiceId_fkey" FOREIGN KEY ("_pk_ClinicMedicalServiceId") REFERENCES "ClinicMedicalService"("_pk_ClinicMedicalServiceId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MedicalDocument" ADD CONSTRAINT "MedicalDocument__fk_TreatmentId_fkey" FOREIGN KEY ("_fk_TreatmentId") REFERENCES "Treatment"("_pk_TreatmentId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "MedicalDocument" ADD CONSTRAINT "MedicalDocument__fk_UploadedByUserId_fkey" FOREIGN KEY ("_fk_UploadedByUserId") REFERENCES "User"("_pk_UserId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Payment" ADD CONSTRAINT "Payment__fk_PatientId_fkey" FOREIGN KEY ("_fk_PatientId") REFERENCES "Patient"("_pk_PatientId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PaymentAllocation" ADD CONSTRAINT "PaymentAllocation__pk_PaymentId_fkey" FOREIGN KEY ("_pk_PaymentId") REFERENCES "Payment"("_pk_PaymentId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PaymentAllocation" ADD CONSTRAINT "PaymentAllocation__pk_TreatmentId_fkey" FOREIGN KEY ("_pk_TreatmentId") REFERENCES "Treatment"("_pk_TreatmentId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StockItem" ADD CONSTRAINT "StockItem__fk_ClinicId_fkey" FOREIGN KEY ("_fk_ClinicId") REFERENCES "Clinic"("_pk_ClinicId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Order" ADD CONSTRAINT "Order__fk_SupplierId_fkey" FOREIGN KEY ("_fk_SupplierId") REFERENCES "Supplier"("_pk_SupplierId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Order" ADD CONSTRAINT "Order__fk_DoctorId_fkey" FOREIGN KEY ("_fk_DoctorId") REFERENCES "Doctor"("_pk_DoctorId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrderItem" ADD CONSTRAINT "OrderItem__fk_OrderId_fkey" FOREIGN KEY ("_fk_OrderId") REFERENCES "Order"("_pk_OrderId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OrderItem" ADD CONSTRAINT "OrderItem__fk_StockItemId_fkey" FOREIGN KEY ("_fk_StockItemId") REFERENCES "StockItem"("_pk_StockItemId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification__fk_UserId_fkey" FOREIGN KEY ("_fk_UserId") REFERENCES "User"("_pk_UserId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ChatMessage" ADD CONSTRAINT "ChatMessage__fk_SenderUserId_fkey" FOREIGN KEY ("_fk_SenderUserId") REFERENCES "User"("_pk_UserId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ChatMessage" ADD CONSTRAINT "ChatMessage__fk_ReceiverUserId_fkey" FOREIGN KEY ("_fk_ReceiverUserId") REFERENCES "User"("_pk_UserId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Review" ADD CONSTRAINT "Review__fk_PatientId_fkey" FOREIGN KEY ("_fk_PatientId") REFERENCES "Patient"("_pk_PatientId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Review" ADD CONSTRAINT "Review__fk_DoctorId_fkey" FOREIGN KEY ("_fk_DoctorId") REFERENCES "Doctor"("_pk_DoctorId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Review" ADD CONSTRAINT "Review__fk_AppointmentId_fkey" FOREIGN KEY ("_fk_AppointmentId") REFERENCES "Appointment"("_pk_AppointmentId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuditLog" ADD CONSTRAINT "AuditLog__fk_UserId_fkey" FOREIGN KEY ("_fk_UserId") REFERENCES "User"("_pk_UserId") ON DELETE SET NULL ON UPDATE CASCADE;
