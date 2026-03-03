PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS "User" (
  "id" TEXT NOT NULL PRIMARY KEY,
  "username" TEXT NOT NULL UNIQUE,
  "email" TEXT NOT NULL UNIQUE,
  "passwordHash" TEXT NOT NULL,
  "isAdmin" INTEGER NOT NULL DEFAULT 0,
  "emailVerifiedAt" DATETIME,
  "locale" TEXT NOT NULL DEFAULT 'en',
  "dayCutoffMinutes" INTEGER NOT NULL DEFAULT 0,
  "weekStartsOn" INTEGER NOT NULL DEFAULT 1,
  "scheduledDeletionAt" DATETIME,
  "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS "Session" (
  "id" TEXT NOT NULL PRIMARY KEY,
  "tokenHash" TEXT NOT NULL UNIQUE,
  "rememberDevice" INTEGER NOT NULL DEFAULT 1,
  "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "lastActiveAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "expiresAt" DATETIME NOT NULL,
  "recentAuthAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "userId" TEXT NOT NULL,
  FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX IF NOT EXISTS "Session_userId_idx" ON "Session"("userId");

CREATE TABLE IF NOT EXISTS "Goal" (
  "id" TEXT NOT NULL PRIMARY KEY,
  "userId" TEXT NOT NULL UNIQUE,
  "type" TEXT NOT NULL DEFAULT 'MAINTAIN_WEIGHT',
  "calorieFormula" TEXT NOT NULL DEFAULT 'MIFFLIN_ST_JEOR',
  "dailyCalorieTarget" INTEGER,
  "proteinGramsTarget" INTEGER,
  "carbsGramsTarget" INTEGER,
  "fatGramsTarget" INTEGER,
  "adaptiveSuggestions" INTEGER NOT NULL DEFAULT 1,
  "requiresApproval" INTEGER NOT NULL DEFAULT 1,
  "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS "UserSettings" (
  "id" TEXT NOT NULL PRIMARY KEY,
  "userId" TEXT NOT NULL UNIQUE,
  "waterGoalLiters" REAL NOT NULL DEFAULT 2,
  "useMetricDistance" INTEGER NOT NULL DEFAULT 1,
  "precisionMode" TEXT NOT NULL DEFAULT 'BASIC',
  "weekStartConfigurable" INTEGER NOT NULL DEFAULT 1,
  "remindersEnabled" INTEGER NOT NULL DEFAULT 1,
  "reminderQuietHoursStart" TEXT DEFAULT '22:00',
  "reminderQuietHoursEnd" TEXT DEFAULT '07:00',
  "pwaInstallPromptDismissed" INTEGER NOT NULL DEFAULT 0,
  "pwaUpdateToastEnabled" INTEGER NOT NULL DEFAULT 1,
  "aiPhotoEstimationEnabled" INTEGER NOT NULL DEFAULT 0,
  "aiPhotoConsentAt" DATETIME,
  "aiPhotoConsentPolicy" TEXT,
  "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS "Product" (
  "id" TEXT NOT NULL PRIMARY KEY,
  "ownerUserId" TEXT,
  "name" TEXT NOT NULL,
  "brand" TEXT,
  "barcode" TEXT,
  "qrCode" TEXT,
  "region" TEXT,
  "packageSizeLabel" TEXT,
  "servingSizeLabel" TEXT,
  "calories" REAL,
  "protein" REAL,
  "carbs" REAL,
  "fat" REAL,
  "source" TEXT NOT NULL DEFAULT 'MANUAL',
  "isAiEstimated" INTEGER NOT NULL DEFAULT 0,
  "isGlobal" INTEGER NOT NULL DEFAULT 0,
  "publicationStatus" TEXT NOT NULL DEFAULT 'LOCAL_ONLY',
  "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updatedAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "publishedAt" DATETIME,
  FOREIGN KEY ("ownerUserId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE
);
CREATE INDEX IF NOT EXISTS "Product_ownerUserId_idx" ON "Product"("ownerUserId");
CREATE INDEX IF NOT EXISTS "Product_isGlobal_publicationStatus_idx" ON "Product"("isGlobal", "publicationStatus");
CREATE INDEX IF NOT EXISTS "Product_barcode_brand_region_idx" ON "Product"("barcode", "brand", "region");

CREATE TABLE IF NOT EXISTS "ProductSubmission" (
  "id" TEXT NOT NULL PRIMARY KEY,
  "productId" TEXT NOT NULL,
  "submittedById" TEXT NOT NULL,
  "reviewedById" TEXT,
  "labelPhotoUrl" TEXT,
  "status" TEXT NOT NULL DEFAULT 'PENDING',
  "reason" TEXT,
  "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "reviewedAt" DATETIME,
  FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY ("submittedById") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY ("reviewedById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE
);
CREATE INDEX IF NOT EXISTS "ProductSubmission_productId_status_idx" ON "ProductSubmission"("productId", "status");

CREATE TABLE IF NOT EXISTS "ProductContribution" (
  "id" TEXT NOT NULL PRIMARY KEY,
  "productId" TEXT NOT NULL,
  "contributorId" TEXT NOT NULL,
  "payloadJson" TEXT NOT NULL,
  "status" TEXT NOT NULL DEFAULT 'PENDING',
  "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "reviewedAt" DATETIME,
  "reviewedById" TEXT,
  FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY ("contributorId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX IF NOT EXISTS "ProductContribution_productId_status_idx" ON "ProductContribution"("productId", "status");

CREATE TABLE IF NOT EXISTS "ModerationAuditLog" (
  "id" TEXT NOT NULL PRIMARY KEY,
  "actorUserId" TEXT NOT NULL,
  "targetType" TEXT NOT NULL,
  "targetId" TEXT NOT NULL,
  "action" TEXT NOT NULL,
  "reason" TEXT,
  "beforeJson" TEXT,
  "afterJson" TEXT,
  "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY ("actorUserId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX IF NOT EXISTS "ModerationAuditLog_targetType_targetId_idx" ON "ModerationAuditLog"("targetType", "targetId");

CREATE TABLE IF NOT EXISTS "MealEntry" (
  "id" TEXT NOT NULL PRIMARY KEY,
  "userId" TEXT NOT NULL,
  "productId" TEXT,
  "mealType" TEXT NOT NULL,
  "consumedAt" DATETIME NOT NULL,
  "quantityValue" REAL NOT NULL,
  "quantityUnit" TEXT NOT NULL,
  "calories" REAL NOT NULL,
  "protein" REAL NOT NULL,
  "carbs" REAL NOT NULL,
  "fat" REAL NOT NULL,
  "snapshotJson" TEXT NOT NULL,
  "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY ("productId") REFERENCES "Product"("id") ON DELETE SET NULL ON UPDATE CASCADE
);
CREATE INDEX IF NOT EXISTS "MealEntry_userId_consumedAt_idx" ON "MealEntry"("userId", "consumedAt");

CREATE TABLE IF NOT EXISTS "WaterEntry" (
  "id" TEXT NOT NULL PRIMARY KEY,
  "userId" TEXT NOT NULL,
  "amountMl" INTEGER NOT NULL,
  "consumedAt" DATETIME NOT NULL,
  "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX IF NOT EXISTS "WaterEntry_userId_consumedAt_idx" ON "WaterEntry"("userId", "consumedAt");

CREATE TABLE IF NOT EXISTS "ActivityEntry" (
  "id" TEXT NOT NULL PRIMARY KEY,
  "userId" TEXT NOT NULL,
  "name" TEXT NOT NULL,
  "method" TEXT NOT NULL,
  "durationMinutes" INTEGER,
  "distanceKm" REAL,
  "intensity" REAL,
  "caloriesBurned" REAL NOT NULL,
  "startedAt" DATETIME NOT NULL,
  "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE INDEX IF NOT EXISTS "ActivityEntry_userId_startedAt_idx" ON "ActivityEntry"("userId", "startedAt");
