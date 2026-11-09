-- CreateTable
CREATE TABLE "Framework" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "nameAm" TEXT NOT NULL,
    "issuer" TEXT NOT NULL,
    "instrument" TEXT NOT NULL,
    "instrumentNo" TEXT NOT NULL,
    "descriptionEn" TEXT NOT NULL,
    "descriptionAm" TEXT NOT NULL,
    "pillars" TEXT NOT NULL,
    "sectorScope" TEXT NOT NULL DEFAULT 'all',
    "sourceUrl" TEXT,
    "sortOrder" INTEGER NOT NULL DEFAULT 0,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Framework_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Organization" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "nameAm" TEXT NOT NULL DEFAULT '',
    "slug" TEXT,
    "sector" TEXT NOT NULL,
    "tier" TEXT NOT NULL DEFAULT 'mid-market',
    "contactEmail" TEXT,
    "status" TEXT NOT NULL DEFAULT 'onboarding',
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Organization_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Rule" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "frameworkId" TEXT,
    "sortOrder" INTEGER NOT NULL,
    "article" TEXT NOT NULL,
    "articleSubject" TEXT NOT NULL,
    "titleEn" TEXT NOT NULL,
    "titleAm" TEXT NOT NULL,
    "statementEn" TEXT NOT NULL,
    "statementAm" TEXT NOT NULL,
    "questionEn" TEXT NOT NULL,
    "questionAm" TEXT NOT NULL,
    "checkLogic" TEXT NOT NULL,
    "remediationEn" TEXT NOT NULL,
    "remediationAm" TEXT NOT NULL,
    "pillar" TEXT NOT NULL,
    "severity" TEXT NOT NULL,
    "priority" TEXT NOT NULL,
    "penaltyRef" TEXT NOT NULL,
    "weight" INTEGER NOT NULL,
    "version" TEXT NOT NULL DEFAULT '1.0',
    "isActive" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "Rule_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Scan" (
    "id" TEXT NOT NULL,
    "organizationId" TEXT NOT NULL,
    "frameworkId" TEXT,
    "name" TEXT NOT NULL,
    "mode" TEXT NOT NULL DEFAULT 'full',
    "status" TEXT NOT NULL DEFAULT 'in_progress',
    "auditorName" TEXT NOT NULL DEFAULT 'Adwa Compliance Engine',
    "overallScore" DOUBLE PRECISION,
    "pillarScores" TEXT,
    "findingsCount" INTEGER NOT NULL DEFAULT 0,
    "criticalFindings" INTEGER NOT NULL DEFAULT 0,
    "startedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completedAt" TIMESTAMP(3),
    "durationMinutes" DOUBLE PRECISION,

    CONSTRAINT "Scan_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ScanResult" (
    "id" TEXT NOT NULL,
    "scanId" TEXT NOT NULL,
    "ruleId" TEXT NOT NULL,
    "answer" TEXT NOT NULL,
    "evidenceNote" TEXT,
    "score" DOUBLE PRECISION NOT NULL,
    "riskRank" DOUBLE PRECISION,
    "findingEn" TEXT,
    "findingAm" TEXT,
    "status" TEXT NOT NULL DEFAULT 'open',
    "dueAt" TIMESTAMP(3),
    "remediatedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ScanResult_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "User" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "passwordHash" TEXT,
    "name" TEXT NOT NULL,
    "avatarUrl" TEXT,
    "role" TEXT NOT NULL,
    "organizationId" TEXT,
    "authProvider" TEXT NOT NULL DEFAULT 'LOCAL',
    "googleId" TEXT,
    "status" TEXT NOT NULL DEFAULT 'ACTIVE',
    "mfaEnabled" BOOLEAN NOT NULL DEFAULT false,
    "mfaSecret" TEXT,
    "mfaConfirmedAt" TIMESTAMP(3),
    "lastTotpCounter" INTEGER,
    "backupCodes" TEXT,
    "failedAttempts" INTEGER NOT NULL DEFAULT 0,
    "lockedUntil" TIMESTAMP(3),
    "sessionsRevokedAt" TIMESTAMP(3),
    "lastLoginAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RefreshToken" (
    "id" TEXT NOT NULL,
    "tokenHash" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "revokedAt" TIMESTAMP(3),
    "replacedBy" TEXT,
    "userAgent" TEXT,
    "ip" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "RefreshToken_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AuthEvent" (
    "id" TEXT NOT NULL,
    "userId" TEXT,
    "email" TEXT NOT NULL,
    "organizationId" TEXT,
    "type" TEXT NOT NULL,
    "ip" TEXT,
    "userAgent" TEXT,
    "detail" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AuthEvent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EvidenceDocument" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "category" TEXT NOT NULL DEFAULT 'OTHER',
    "tags" TEXT,
    "fileName" TEXT NOT NULL,
    "storedName" TEXT NOT NULL,
    "mimeType" TEXT NOT NULL,
    "fileSize" INTEGER NOT NULL,
    "checksum" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'ACTIVE',
    "version" INTEGER NOT NULL DEFAULT 1,
    "rootId" TEXT,
    "downloads" INTEGER NOT NULL DEFAULT 0,
    "lastVerifiedAt" TIMESTAMP(3),
    "organizationId" TEXT NOT NULL,
    "uploadedById" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "EvidenceDocument_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EvidenceLink" (
    "id" TEXT NOT NULL,
    "ruleId" TEXT NOT NULL,
    "evidenceId" TEXT NOT NULL,
    "linkType" TEXT NOT NULL DEFAULT 'SATISFIES',
    "source" TEXT NOT NULL DEFAULT 'MANUAL',
    "createdById" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "EvidenceLink_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ThreatIndicator" (
    "id" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "value" TEXT NOT NULL,
    "titleEn" TEXT NOT NULL,
    "titleAm" TEXT NOT NULL,
    "descriptionEn" TEXT,
    "descriptionAm" TEXT,
    "category" TEXT NOT NULL,
    "severity" TEXT NOT NULL,
    "tlp" TEXT NOT NULL DEFAULT 'TLP:AMBER',
    "source" TEXT NOT NULL DEFAULT 'ANALYST',
    "sourceRef" TEXT,
    "confidence" INTEGER NOT NULL DEFAULT 50,
    "sensitivity" INTEGER NOT NULL DEFAULT 3,
    "sharing" TEXT NOT NULL DEFAULT 'HUB',
    "organizationId" TEXT,
    "createdById" TEXT,
    "firstSeenAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastSeenAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "sightings" INTEGER NOT NULL DEFAULT 0,
    "expiresAt" TIMESTAMP(3),
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ThreatIndicator_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "IndicatorShare" (
    "id" TEXT NOT NULL,
    "indicatorId" TEXT NOT NULL,
    "mode" TEXT NOT NULL,
    "targetOrgId" TEXT,
    "sharedById" TEXT NOT NULL,
    "anonymised" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "IndicatorShare_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Incident" (
    "id" TEXT NOT NULL,
    "organizationId" TEXT NOT NULL,
    "ref" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "titleAm" TEXT NOT NULL DEFAULT '',
    "description" TEXT,
    "category" TEXT NOT NULL,
    "severity" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'detected',
    "source" TEXT NOT NULL DEFAULT 'SOC_MONITOR',
    "detectionMethod" TEXT NOT NULL DEFAULT 'signature',
    "priorityScore" DOUBLE PRECISION,
    "priorityLabel" TEXT,
    "assigneeId" TEXT,
    "detectedAt" TIMESTAMP(3) NOT NULL,
    "notifiedAt" TIMESTAMP(3),
    "triagedAt" TIMESTAMP(3),
    "containedAt" TIMESTAMP(3),
    "eradicatedAt" TIMESTAMP(3),
    "recoveredAt" TIMESTAMP(3),
    "closedAt" TIMESTAMP(3),
    "reportedToEthiocertAt" TIMESTAMP(3),
    "impactNote" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Incident_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "IncidentEvent" (
    "id" TEXT NOT NULL,
    "incidentId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "note" TEXT,
    "actorId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "IncidentEvent_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "IncidentIndicator" (
    "incidentId" TEXT NOT NULL,
    "indicatorId" TEXT NOT NULL,
    "matchedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "IncidentIndicator_pkey" PRIMARY KEY ("incidentId","indicatorId")
);

-- CreateTable
CREATE TABLE "SyncRun" (
    "id" TEXT NOT NULL,
    "direction" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'success',
    "source" TEXT NOT NULL DEFAULT 'FIXTURE',
    "endpoint" TEXT,
    "receiptId" TEXT,
    "ingested" INTEGER NOT NULL DEFAULT 0,
    "updated" INTEGER NOT NULL DEFAULT 0,
    "reported" INTEGER NOT NULL DEFAULT 0,
    "payloadHash" TEXT,
    "organizationId" TEXT,
    "triggeredById" TEXT NOT NULL,
    "detail" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "SyncRun_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CaptchaChallenge" (
    "id" TEXT NOT NULL,
    "answerHash" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "consumedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "CaptchaChallenge_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AwarenessSchool" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "nameAm" TEXT NOT NULL,
    "subCity" TEXT NOT NULL,
    "address" TEXT,
    "contactPerson" TEXT,
    "contactPhone" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AwarenessSchool_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AwarenessClass" (
    "id" TEXT NOT NULL,
    "schoolId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "grade" INTEGER NOT NULL,
    "groupType" TEXT NOT NULL,
    "joinCode" TEXT NOT NULL,
    "teacherName" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AwarenessClass_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AwarenessModule" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "sortOrder" INTEGER NOT NULL,
    "topic" TEXT NOT NULL,
    "titleEn" TEXT NOT NULL,
    "titleAm" TEXT NOT NULL,
    "summaryEn" TEXT NOT NULL,
    "summaryAm" TEXT NOT NULL,
    "contentEn" TEXT NOT NULL,
    "contentAm" TEXT NOT NULL,
    "durationMin" INTEGER NOT NULL DEFAULT 15,
    "gradeBand" TEXT NOT NULL DEFAULT '7-10',
    "audience" TEXT NOT NULL DEFAULT 'KIDS',
    "version" TEXT NOT NULL DEFAULT '1.0',
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AwarenessModule_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AwarenessQuestion" (
    "id" TEXT NOT NULL,
    "moduleId" TEXT NOT NULL,
    "sortOrder" INTEGER NOT NULL,
    "promptEn" TEXT NOT NULL,
    "promptAm" TEXT NOT NULL,
    "optionsEn" TEXT NOT NULL,
    "optionsAm" TEXT NOT NULL,
    "answerIdx" INTEGER NOT NULL,
    "explainEn" TEXT,
    "explainAm" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "AwarenessQuestion_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AwarenessLearner" (
    "id" TEXT NOT NULL,
    "classId" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "grade" INTEGER NOT NULL,
    "consent" TEXT NOT NULL DEFAULT 'PENDING',
    "consentAt" TIMESTAMP(3),
    "consentRef" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AwarenessLearner_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AwarenessAssessment" (
    "id" TEXT NOT NULL,
    "learnerId" TEXT NOT NULL,
    "kind" TEXT NOT NULL,
    "total" INTEGER NOT NULL,
    "correct" INTEGER NOT NULL,
    "score" DOUBLE PRECISION NOT NULL,
    "answers" TEXT NOT NULL,
    "takenAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AwarenessAssessment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AwarenessProgress" (
    "id" TEXT NOT NULL,
    "learnerId" TEXT NOT NULL,
    "moduleId" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'in_progress',
    "quizScore" DOUBLE PRECISION,
    "startedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completedAt" TIMESTAMP(3),

    CONSTRAINT "AwarenessProgress_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AwarenessToolPing" (
    "id" TEXT NOT NULL,
    "tool" TEXT NOT NULL,
    "lang" TEXT NOT NULL DEFAULT 'am',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "AwarenessToolPing_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ExpansionGate" (
    "id" TEXT NOT NULL,
    "phase" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "titleEn" TEXT NOT NULL,
    "titleAm" TEXT NOT NULL,
    "detailEn" TEXT NOT NULL,
    "detailAm" TEXT NOT NULL,
    "category" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'NOT_STARTED',
    "blocking" BOOLEAN NOT NULL DEFAULT true,
    "notes" TEXT,
    "targetDate" TIMESTAMP(3),
    "updatedById" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "ExpansionGate_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "GateEvidence" (
    "id" TEXT NOT NULL,
    "gateId" TEXT NOT NULL,
    "fileName" TEXT NOT NULL,
    "storedName" TEXT NOT NULL,
    "mimeType" TEXT NOT NULL,
    "fileSize" INTEGER NOT NULL,
    "checksum" TEXT NOT NULL,
    "description" TEXT,
    "uploadedById" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "GateEvidence_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "GateEvent" (
    "id" TEXT NOT NULL,
    "gateId" TEXT NOT NULL,
    "actorId" TEXT,
    "kind" TEXT NOT NULL,
    "fromStatus" TEXT,
    "toStatus" TEXT,
    "note" TEXT,
    "evidenceId" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "GateEvent_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Framework_code_key" ON "Framework"("code");

-- CreateIndex
CREATE UNIQUE INDEX "Organization_slug_key" ON "Organization"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "Rule_code_key" ON "Rule"("code");

-- CreateIndex
CREATE INDEX "ScanResult_dueAt_idx" ON "ScanResult"("dueAt");

-- CreateIndex
CREATE INDEX "ScanResult_status_idx" ON "ScanResult"("status");

-- CreateIndex
CREATE UNIQUE INDEX "ScanResult_scanId_ruleId_key" ON "ScanResult"("scanId", "ruleId");

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "User_googleId_key" ON "User"("googleId");

-- CreateIndex
CREATE UNIQUE INDEX "RefreshToken_tokenHash_key" ON "RefreshToken"("tokenHash");

-- CreateIndex
CREATE INDEX "AuthEvent_createdAt_idx" ON "AuthEvent"("createdAt");

-- CreateIndex
CREATE INDEX "AuthEvent_organizationId_idx" ON "AuthEvent"("organizationId");

-- CreateIndex
CREATE UNIQUE INDEX "EvidenceDocument_storedName_key" ON "EvidenceDocument"("storedName");

-- CreateIndex
CREATE INDEX "EvidenceDocument_organizationId_status_idx" ON "EvidenceDocument"("organizationId", "status");

-- CreateIndex
CREATE INDEX "EvidenceDocument_rootId_idx" ON "EvidenceDocument"("rootId");

-- CreateIndex
CREATE INDEX "EvidenceDocument_category_idx" ON "EvidenceDocument"("category");

-- CreateIndex
CREATE INDEX "EvidenceLink_evidenceId_idx" ON "EvidenceLink"("evidenceId");

-- CreateIndex
CREATE INDEX "EvidenceLink_ruleId_idx" ON "EvidenceLink"("ruleId");

-- CreateIndex
CREATE UNIQUE INDEX "EvidenceLink_ruleId_evidenceId_key" ON "EvidenceLink"("ruleId", "evidenceId");

-- CreateIndex
CREATE INDEX "ThreatIndicator_severity_idx" ON "ThreatIndicator"("severity");

-- CreateIndex
CREATE INDEX "ThreatIndicator_category_idx" ON "ThreatIndicator"("category");

-- CreateIndex
CREATE INDEX "ThreatIndicator_isActive_idx" ON "ThreatIndicator"("isActive");

-- CreateIndex
CREATE UNIQUE INDEX "ThreatIndicator_type_value_key" ON "ThreatIndicator"("type", "value");

-- CreateIndex
CREATE INDEX "IndicatorShare_indicatorId_idx" ON "IndicatorShare"("indicatorId");

-- CreateIndex
CREATE INDEX "IndicatorShare_targetOrgId_idx" ON "IndicatorShare"("targetOrgId");

-- CreateIndex
CREATE UNIQUE INDEX "Incident_ref_key" ON "Incident"("ref");

-- CreateIndex
CREATE INDEX "Incident_organizationId_status_idx" ON "Incident"("organizationId", "status");

-- CreateIndex
CREATE INDEX "Incident_severity_idx" ON "Incident"("severity");

-- CreateIndex
CREATE INDEX "Incident_detectedAt_idx" ON "Incident"("detectedAt");

-- CreateIndex
CREATE INDEX "IncidentEvent_incidentId_idx" ON "IncidentEvent"("incidentId");

-- CreateIndex
CREATE INDEX "SyncRun_createdAt_idx" ON "SyncRun"("createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "AwarenessSchool_name_key" ON "AwarenessSchool"("name");

-- CreateIndex
CREATE UNIQUE INDEX "AwarenessClass_joinCode_key" ON "AwarenessClass"("joinCode");

-- CreateIndex
CREATE INDEX "AwarenessClass_groupType_idx" ON "AwarenessClass"("groupType");

-- CreateIndex
CREATE UNIQUE INDEX "AwarenessClass_schoolId_name_key" ON "AwarenessClass"("schoolId", "name");

-- CreateIndex
CREATE UNIQUE INDEX "AwarenessModule_code_key" ON "AwarenessModule"("code");

-- CreateIndex
CREATE UNIQUE INDEX "AwarenessLearner_code_key" ON "AwarenessLearner"("code");

-- CreateIndex
CREATE INDEX "AwarenessAssessment_learnerId_kind_idx" ON "AwarenessAssessment"("learnerId", "kind");

-- CreateIndex
CREATE UNIQUE INDEX "AwarenessProgress_learnerId_moduleId_key" ON "AwarenessProgress"("learnerId", "moduleId");

-- CreateIndex
CREATE INDEX "AwarenessToolPing_tool_createdAt_idx" ON "AwarenessToolPing"("tool", "createdAt");

-- CreateIndex
CREATE UNIQUE INDEX "ExpansionGate_phase_code_key" ON "ExpansionGate"("phase", "code");

-- CreateIndex
CREATE UNIQUE INDEX "GateEvidence_storedName_key" ON "GateEvidence"("storedName");

-- CreateIndex
CREATE INDEX "GateEvidence_gateId_idx" ON "GateEvidence"("gateId");

-- CreateIndex
CREATE INDEX "GateEvent_gateId_createdAt_idx" ON "GateEvent"("gateId", "createdAt");

-- AddForeignKey
ALTER TABLE "Rule" ADD CONSTRAINT "Rule_frameworkId_fkey" FOREIGN KEY ("frameworkId") REFERENCES "Framework"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Scan" ADD CONSTRAINT "Scan_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Scan" ADD CONSTRAINT "Scan_frameworkId_fkey" FOREIGN KEY ("frameworkId") REFERENCES "Framework"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScanResult" ADD CONSTRAINT "ScanResult_scanId_fkey" FOREIGN KEY ("scanId") REFERENCES "Scan"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ScanResult" ADD CONSTRAINT "ScanResult_ruleId_fkey" FOREIGN KEY ("ruleId") REFERENCES "Rule"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "User" ADD CONSTRAINT "User_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RefreshToken" ADD CONSTRAINT "RefreshToken_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AuthEvent" ADD CONSTRAINT "AuthEvent_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EvidenceDocument" ADD CONSTRAINT "EvidenceDocument_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EvidenceDocument" ADD CONSTRAINT "EvidenceDocument_uploadedById_fkey" FOREIGN KEY ("uploadedById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EvidenceLink" ADD CONSTRAINT "EvidenceLink_ruleId_fkey" FOREIGN KEY ("ruleId") REFERENCES "Rule"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EvidenceLink" ADD CONSTRAINT "EvidenceLink_evidenceId_fkey" FOREIGN KEY ("evidenceId") REFERENCES "EvidenceDocument"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EvidenceLink" ADD CONSTRAINT "EvidenceLink_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ThreatIndicator" ADD CONSTRAINT "ThreatIndicator_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ThreatIndicator" ADD CONSTRAINT "ThreatIndicator_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IndicatorShare" ADD CONSTRAINT "IndicatorShare_indicatorId_fkey" FOREIGN KEY ("indicatorId") REFERENCES "ThreatIndicator"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IndicatorShare" ADD CONSTRAINT "IndicatorShare_targetOrgId_fkey" FOREIGN KEY ("targetOrgId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IndicatorShare" ADD CONSTRAINT "IndicatorShare_sharedById_fkey" FOREIGN KEY ("sharedById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Incident" ADD CONSTRAINT "Incident_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Incident" ADD CONSTRAINT "Incident_assigneeId_fkey" FOREIGN KEY ("assigneeId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IncidentEvent" ADD CONSTRAINT "IncidentEvent_incidentId_fkey" FOREIGN KEY ("incidentId") REFERENCES "Incident"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IncidentEvent" ADD CONSTRAINT "IncidentEvent_actorId_fkey" FOREIGN KEY ("actorId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IncidentIndicator" ADD CONSTRAINT "IncidentIndicator_incidentId_fkey" FOREIGN KEY ("incidentId") REFERENCES "Incident"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "IncidentIndicator" ADD CONSTRAINT "IncidentIndicator_indicatorId_fkey" FOREIGN KEY ("indicatorId") REFERENCES "ThreatIndicator"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SyncRun" ADD CONSTRAINT "SyncRun_organizationId_fkey" FOREIGN KEY ("organizationId") REFERENCES "Organization"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SyncRun" ADD CONSTRAINT "SyncRun_triggeredById_fkey" FOREIGN KEY ("triggeredById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AwarenessClass" ADD CONSTRAINT "AwarenessClass_schoolId_fkey" FOREIGN KEY ("schoolId") REFERENCES "AwarenessSchool"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AwarenessQuestion" ADD CONSTRAINT "AwarenessQuestion_moduleId_fkey" FOREIGN KEY ("moduleId") REFERENCES "AwarenessModule"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AwarenessLearner" ADD CONSTRAINT "AwarenessLearner_classId_fkey" FOREIGN KEY ("classId") REFERENCES "AwarenessClass"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AwarenessAssessment" ADD CONSTRAINT "AwarenessAssessment_learnerId_fkey" FOREIGN KEY ("learnerId") REFERENCES "AwarenessLearner"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AwarenessProgress" ADD CONSTRAINT "AwarenessProgress_learnerId_fkey" FOREIGN KEY ("learnerId") REFERENCES "AwarenessLearner"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AwarenessProgress" ADD CONSTRAINT "AwarenessProgress_moduleId_fkey" FOREIGN KEY ("moduleId") REFERENCES "AwarenessModule"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ExpansionGate" ADD CONSTRAINT "ExpansionGate_updatedById_fkey" FOREIGN KEY ("updatedById") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GateEvidence" ADD CONSTRAINT "GateEvidence_gateId_fkey" FOREIGN KEY ("gateId") REFERENCES "ExpansionGate"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GateEvidence" ADD CONSTRAINT "GateEvidence_uploadedById_fkey" FOREIGN KEY ("uploadedById") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GateEvent" ADD CONSTRAINT "GateEvent_gateId_fkey" FOREIGN KEY ("gateId") REFERENCES "ExpansionGate"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "GateEvent" ADD CONSTRAINT "GateEvent_actorId_fkey" FOREIGN KEY ("actorId") REFERENCES "User"("id") ON DELETE SET NULL ON UPDATE CASCADE;
