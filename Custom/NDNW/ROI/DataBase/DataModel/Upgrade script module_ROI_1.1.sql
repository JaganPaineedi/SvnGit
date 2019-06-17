----- STEP 1 ----------

------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins


--Part2 Ends

-----End of Step 2 -------

------ STEP 3 ------------
---------------------The CustomInquiries table is not part of this upgrade but in some db this upgrade raise error as invalid table customInquiry and it should be in the db which is for newyago as it comes in kalamazoo custom data model version 1.1 and base data model for newyago is kalamazoo 1.30 
--IF Not EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomInquiries')
-- BEGIN
   
--/* 
-- * TABLE: CustomInquiries 
-- */

--CREATE TABLE CustomInquiries(
--    InquiryId                           int                     IDENTITY(1,1),
--    CreatedBy                           type_CurrentUser        NOT NULL,
--    CreatedDate                         type_CurrentDatetime    NOT NULL,
--    ModifiedBy                          type_CurrentUser        NOT NULL,
--    ModifiedDate                        type_CurrentDatetime    NOT NULL,
--    RecordDeleted                       type_YOrN               NULL
--                                        CHECK (RecordDeleted in ('Y','N')),
--    DeletedBy                           type_UserId             NULL,
--    DeletedDate                         datetime                NULL,
--    ClientId                            int                     NULL,
--    InquirerFirstName                   type_FirstName          NULL,
--    InquirerMiddleName                  type_MiddleName         NULL,
--    InquirerLastName                    type_LastName           NULL,
--    InquirerRelationToMember            type_GlobalCode         NULL,
--    InquirerPhone                       varchar(25)             NULL,
--    InquirerPhoneExtension              varchar(10)             NULL,
--    InquirerEmail                       varchar(100)            NULL,
--    InquiryStartDateTime                datetime                NULL,
--    InquiryEventId                      int                     NULL,
--    MemberFirstName                     type_FirstName          NULL,
--    MemberMiddleName                    type_MiddleName         NULL,
--    MemberLastName                      type_LastName           NULL,
--    SSN                                 char(9)                 NULL,
--    Sex                                 type_Sex                NULL
--                                        CHECK (Sex in ('M','F','U')),
--    DateOfBirth                         datetime                NULL,
--    MemberPhone                         varchar(25)             NULL,
--    MemberEmail                         varchar(100)            NULL,
--    MaritalStatus                       type_GlobalCode         NULL,
--    Address1                            type_Address            NULL,
--    Address2                            type_Address            NULL,
--    City                                type_City               NULL,
--    [State]                             type_State              NULL,
--    Race                                type_GlobalCode         NULL,
--    ZipCode                             type_ZipCode            NULL,
--    MedicaidId                          varchar(25)             NULL,
--    PresentingProblem                   type_Comment2           NULL,
--    UrgencyLevel                        type_GlobalCode         NULL,
--    InquiryType                         type_GlobalCode         NULL,
--    ContactType                         type_GlobalCode         NULL,
--    Location                            type_GlobalCode         NULL,
--    ClientCanLegalySign                 type_YOrN               NULL
--                                        CHECK (ClientCanLegalySign in ('Y','N')),
--    EmergencyContactFirstName           type_FirstName          NULL,
--    EmergencyContactMiddleName          type_MiddleName         NULL,
--    EmergencyContactLastName            type_LastName           NULL,
--    EmergencyContactRelationToClient    type_GlobalCode         NULL,
--    EmergencyContactHomePhone           varchar(25)             NULL,
--    EmergencyContactCellPhone           varchar(25)             NULL,
--    EmergencyContactWorkPhone           varchar(25)             NULL,
--    PopulationDD                        type_YesNoUnknown       NULL
--                                        CHECK (PopulationDD in('Y','N','U')),
--    PopulationMI                        type_YesNoUnknown       NULL
--                                        CHECK (PopulationMI in('Y','N','U')),
--    PopulationSA                        type_YesNoUnknown       NULL
--                                        CHECK (PopulationSA in('Y','N','U')),
--    SAType                              type_GlobalCode         NULL,
--    PrimarySpokenLanguage               type_GlobalCode         NULL,
--    LimitedEnglishProficiency           type_YesNoUnknown       NULL
--                                        CHECK (LimitedEnglishProficiency in('Y','N','U')),
--    SchoolName                          varchar(50)             NULL,
--    AccomodationNeeded                  varchar(5)              NULL,
--    Pregnant                            char(1)                 NULL
--                                        CONSTRAINT CustomInquiries_Pregnant_Chk CHECK (Pregnant in  ('Y','N','U','A')),
--    PresentingPopulation                type_GlobalCode         NULL,
--    InjectingDrugs                      type_YesNoUnknown       NULL
--                                        CHECK (InjectingDrugs in('Y','N','U')),
--    RecordedBy                          int                     NULL,
--    GatheredBy                          int                     NULL,
--    ProgramId                           int                     NULL,
--    GatheredByOther                     varchar(50)             NULL,
--    DispositionComment                  type_Comment2           NULL,
--    InquiryDetails                      type_Comment2           NULL,
--    InquiryEndDateTime                  datetime                NULL,
--    InquiryStatus                       type_GlobalCode         NULL,
--    ReferralDate                        datetime                NULL,
--    ReferralType                        type_GlobalCode         NULL,
--    ReferralSubtype                     type_GlobalSubcode      NULL,
--    ReferralName                        varchar(100)            NULL,
--    ReferralAdditionalInformation       type_Comment2           NULL,
--    Living                              type_GlobalCode         NULL,
--    NoOfBeds                            type_GlobalCode         NULL,
--    CountyOfResidence                   char(5)                 NULL,
--    COFR                                char(5)                 NULL,
--    CorrectionStatus                    type_GlobalCode         NULL,
--    EducationalStatus                   type_GlobalCode         NULL,
--    VeteranStatus                       type_YesNoUnknown       NULL
--                                        CHECK (VeteranStatus in('Y','N','U')),
--    EmploymentStatus                    type_GlobalCode         NULL,
--    EmployerName                        varchar(100)            NULL,
--    MinimumWage                         type_YOrNOrNA           NULL
--                                        CHECK (MinimumWage in ('Y','N','A')),
--    DHSStatus                           type_YOrNOrNA           NULL
--                                        CHECK (DHSStatus in ('Y','N','A')),
--    AssignedToStaffId                   int                     NULL,
--    GuardianSameAsCaller                type_YOrN               NULL
--                                        CHECK (GuardianSameAsCaller in ('Y','N')),
--    GuardianFirstName                   varchar(50)             NULL,
--    GuardianLastName                    varchar(50)             NULL,
--    GuardianPhoneNumber                 varchar(25)             NULL,
--    GuardianPhoneType                   type_GlobalCode         NULL,
--    GuardianDOB                         datetime                NULL,
--    GuardianRelation                    type_GlobalCode         NULL,
--    EmergencyContactSameAsCaller        type_YOrN               NULL
--                                        CHECK (EmergencyContactSameAsCaller in ('Y','N')),
--    MemberCell                          varchar(25)             NULL,
--    GurdianDPOAStatus                   char(1)                 NULL,
--    GardianComment                      type_Comment            NULL,
--    SSNUnknown                          type_YOrN               NULL
--                                        CHECK (SSNUnknown in ('Y','N')),
--    ReferralArrivalTime                 datetime                NULL,
--    CONSTRAINT CustomInquiries_PK PRIMARY KEY CLUSTERED (InquiryId)
--)




--IF OBJECT_ID('CustomInquiries') IS NOT NULL
--    PRINT '<<< CREATED TABLE CustomInquiries >>>'
--ELSE
--    PRINT '<<< FAILED CREATING TABLE CustomInquiries >>>'


--/* 
-- * TABLE: CustomInquiries 
-- */

--ALTER TABLE CustomInquiries ADD CONSTRAINT Clients_CustomInquiries_FK 
--    FOREIGN KEY (ClientId)
--    REFERENCES Clients(ClientId)


--ALTER TABLE CustomInquiries ADD CONSTRAINT Programs_CustomInquiries_FK 
--    FOREIGN KEY (ProgramId)
--    REFERENCES Programs(ProgramId)


--ALTER TABLE CustomInquiries ADD CONSTRAINT Staff_CustomInquiries_FK 
--    FOREIGN KEY (AssignedToStaffId)
--    REFERENCES Staff(StaffId)


--ALTER TABLE CustomInquiries ADD CONSTRAINT Staff_CustomInquiries_FK2 
--    FOREIGN KEY (RecordedBy)
--    REFERENCES Staff(StaffId)


-- END
-- GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[DocumentVersions_CustomDocumentReleaseOfInformations_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomDocumentReleaseOfInformations] DROP CONSTRAINT [DocumentVersions_CustomDocumentReleaseOfInformations_FK]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomDoc__Asses__4CE157A5]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomDocumentReleaseOfInformations] DROP CONSTRAINT [CK__CustomDoc__Asses__4CE157A5]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomDoc__Disch__538E5534]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomDocumentReleaseOfInformations] DROP CONSTRAINT [CK__CustomDoc__Disch__538E5534]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomDoc__Educa__529A30FB]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomDocumentReleaseOfInformations] DROP CONSTRAINT [CK__CustomDoc__Educa__529A30FB]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomDoc__GetIn__4A04EAFA]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomDocumentReleaseOfInformations] DROP CONSTRAINT [CK__CustomDoc__GetIn__4A04EAFA]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomDoc__Infor__5482796D]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomDocumentReleaseOfInformations] DROP CONSTRAINT [CK__CustomDoc__Infor__5482796D]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomDoc__Perso__4DD57BDE]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomDocumentReleaseOfInformations] DROP CONSTRAINT [CK__CustomDoc__Perso__4DD57BDE]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomDoc__Progr__4EC9A017]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomDocumentReleaseOfInformations] DROP CONSTRAINT [CK__CustomDoc__Progr__4EC9A017]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomDoc__Psych__4FBDC450]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomDocumentReleaseOfInformations] DROP CONSTRAINT [CK__CustomDoc__Psych__4FBDC450]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomDoc__Psych__50B1E889]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomDocumentReleaseOfInformations] DROP CONSTRAINT [CK__CustomDoc__Psych__50B1E889]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomDoc__Recor__4910C6C1]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomDocumentReleaseOfInformations] DROP CONSTRAINT [CK__CustomDoc__Recor__4910C6C1]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomDoc__Relea__4AF90F33]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomDocumentReleaseOfInformations] DROP CONSTRAINT [CK__CustomDoc__Relea__4AF90F33]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomDoc__Relea__566AC1DF]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomDocumentReleaseOfInformations] DROP CONSTRAINT [CK__CustomDoc__Relea__566AC1DF]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomDoc__Trans__575EE618]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomDocumentReleaseOfInformations] DROP CONSTRAINT [CK__CustomDoc__Trans__575EE618]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomDoc__Trans__58530A51]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomDocumentReleaseOfInformations] DROP CONSTRAINT [CK__CustomDoc__Trans__58530A51]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomDoc__Trans__59472E8A]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomDocumentReleaseOfInformations] DROP CONSTRAINT [CK__CustomDoc__Trans__59472E8A]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomDoc__Trans__5A3B52C3]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomDocumentReleaseOfInformations] DROP CONSTRAINT [CK__CustomDoc__Trans__5A3B52C3]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomDoc__Trans__5B2F76FC]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomDocumentReleaseOfInformations] DROP CONSTRAINT [CK__CustomDoc__Trans__5B2F76FC]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomDoc__Trans__5C239B35]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomDocumentReleaseOfInformations] DROP CONSTRAINT [CK__CustomDoc__Trans__5C239B35]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomDoc__Trans__5D17BF6E]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomDocumentReleaseOfInformations] DROP CONSTRAINT [CK__CustomDoc__Trans__5D17BF6E]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomDoc__Trans__5E0BE3A7]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomDocumentReleaseOfInformations] DROP CONSTRAINT [CK__CustomDoc__Trans__5E0BE3A7]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomDoc__Trans__5F0007E0]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomDocumentReleaseOfInformations] DROP CONSTRAINT [CK__CustomDoc__Trans__5F0007E0]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomDoc__Trans__5FF42C19]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomDocumentReleaseOfInformations] DROP CONSTRAINT [CK__CustomDoc__Trans__5FF42C19]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomDoc__Treat__51A60CC2]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomDocumentReleaseOfInformations] DROP CONSTRAINT [CK__CustomDoc__Treat__51A60CC2]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomDoc__WorkR__55769DA6]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomDocumentReleaseOfInformations] DROP CONSTRAINT [CK__CustomDoc__WorkR__55769DA6]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CustomDocumentReleaseOfInformations_AIDSRelatedComplex_CHK]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomDocumentReleaseOfInformations] DROP CONSTRAINT [CustomDocumentReleaseOfInformations_AIDSRelatedComplex_CHK]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CustomDocumentReleaseOfInformations_AlcoholDrugAbuse_CHK]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomDocumentReleaseOfInformations] DROP CONSTRAINT [CustomDocumentReleaseOfInformations_AlcoholDrugAbuse_CHK]
GO

IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CustomDocumentReleaseOfInformations_ReleaseContactType_CHK]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentReleaseOfInformations]'))
ALTER TABLE [dbo].[CustomDocumentReleaseOfInformations] DROP CONSTRAINT [CustomDocumentReleaseOfInformations_ReleaseContactType_CHK]
GO


/****** Object:  Table [dbo].[CustomDocumentReleaseOfInformations]    Script Date: 01/22/2013 16:45:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomDocumentReleaseOfInformations]') AND type in (N'U'))
DROP TABLE [dbo].[CustomDocumentReleaseOfInformations]
GO




PRINT 'STEP 3 COMPLETED'
------ END OF STEP 3 -----

------ STEP 4 ----------

/* 
 * TABLE: CustomDocumentReleaseOfInformations 
 */

CREATE TABLE CustomDocumentReleaseOfInformations(
    ReleaseOfInformationId                         int                     IDENTITY(1,1),
    CreatedBy                                      type_CurrentUser        NOT NULL,
    CreatedDate                                    type_CurrentDatetime    NOT NULL,
    ModifiedBy                                     type_CurrentUser        NOT NULL,
    ModifiedDate                                   type_CurrentDatetime    NOT NULL,
    RecordDeleted                                  type_YOrN               NULL
                                                   CHECK (RecordDeleted in ('Y','N')),
    DeletedDate                                    datetime                NULL,
    DeletedBy                                      type_UserId             NULL,
    DocumentVersionId                              int                     NOT NULL,
    OldDocumentVersionId                           int                     NULL,
    ReleaseOfInformationOrder                      int                     NULL,
    GetInformationFrom                             type_YOrN               NULL
                                                   CHECK (GetInformationFrom in ('Y','N')),
    ReleaseInformationFrom                         type_YOrN               NULL
                                                   CHECK (ReleaseInformationFrom in ('Y','N')),
    ReleaseToReceiveFrom                           type_GlobalCode         NULL,
    ReleaseEndDate                                 datetime                NULL,
    ReleaseContactType                             char(1)                 NULL
                                                   CONSTRAINT CustomDocumentReleaseOfInformations_ReleaseContactType_CHK CHECK (ReleaseContactType in ('O', 'C')),
    ReleaseName                                    varchar(100)            NULL,
    ReleaseAddress                                 type_Address            NULL,
    ReleaseCity                                    type_City               NULL,
    ReleasedState                                  type_State              NULL,
    ReleasePhoneNumber                             type_PhoneNumber        NULL,
    ReleasedZip                                    type_ZipCode            NULL,
    AssessmentEvaluation                           type_YOrN               NULL
                                                   CHECK (AssessmentEvaluation in ('Y','N')),
    PersonPlan                                     type_YOrN               NULL
                                                   CHECK (PersonPlan in ('Y','N')),
    ProgressNote                                   type_YOrN               NULL
                                                   CHECK (ProgressNote in ('Y','N')),
    PsychologicalTesting                           type_YOrN               NULL
                                                   CHECK (PsychologicalTesting in ('Y','N')),
    PsychiatricTreatment                           type_YOrN               NULL
                                                   CHECK (PsychiatricTreatment in ('Y','N')),
    TreatmentServiceRecommendation                 type_YOrN               NULL
                                                   CHECK (TreatmentServiceRecommendation in ('Y','N')),
    EducationalDevelopmental                       type_YOrN               NULL
                                                   CHECK (EducationalDevelopmental in ('Y','N')),
    DischargeTransferRecommendation                type_YOrN               NULL
                                                   CHECK (DischargeTransferRecommendation in ('Y','N')),
    InformationBenefitInsurance                    type_YOrN               NULL
                                                   CHECK (InformationBenefitInsurance in ('Y','N')),
    WorkRelatedInformation                         type_YOrN               NULL
                                                   CHECK (WorkRelatedInformation in ('Y','N')),
    ReleasedInfoOther                              type_YOrN               NULL
                                                   CHECK (ReleasedInfoOther in ('Y','N')),
    ReleasedInfoOtherComment                       type_Comment2           NULL,
    TransmissionModesWritten                       type_YOrN               NULL
                                                   CHECK (TransmissionModesWritten in ('Y','N')),
    TransmissionModesVerbal                        type_YOrN               NULL
                                                   CHECK (TransmissionModesVerbal in ('Y','N')),
    TransmissionModesElectronic                    type_YOrN               NULL
                                                   CHECK (TransmissionModesElectronic in ('Y','N')),
    TransmissionModesAudio                         type_YOrN               NULL
                                                   CHECK (TransmissionModesAudio in ('Y','N')),
    TransmissionModesPhoto                         type_YOrN               NULL
                                                   CHECK (TransmissionModesPhoto in ('Y','N')),
    TransmissionModesReleaseInOther                type_YOrN               NULL
                                                   CHECK (TransmissionModesReleaseInOther in ('Y','N')),
    TransmissionModesReleaseInOtherComment         type_Comment2           NULL,
    TransmissionModesToProvideCaseCoordination     type_YOrN               NULL
                                                   CHECK (TransmissionModesToProvideCaseCoordination in ('Y','N')),
    TransmissionModesToDetermineEligibleService    type_YOrN               NULL
                                                   CHECK (TransmissionModesToDetermineEligibleService in ('Y','N')),
    TransmissionModesAtRequestIndividual           type_YOrN               NULL
                                                   CHECK (TransmissionModesAtRequestIndividual in ('Y','N')),
    TransmissionModesInOther                       type_YOrN               NULL
                                                   CHECK (TransmissionModesInOther in ('Y','N')),
    TransmissionModesOtherComment                  type_Comment2           NULL,
    AlcoholDrugAbuse                               char(1)                 NULL
                                                   CONSTRAINT CustomDocumentReleaseOfInformations_AlcoholDrugAbuse_CHK CHECK (AlcoholDrugAbuse in('A','P')),
    AIDSRelatedComplex                             char(1)                 NULL
                                                   CONSTRAINT CustomDocumentReleaseOfInformations_AIDSRelatedComplex_CHK CHECK (AIDSRelatedComplex in ('A', 'P')),
    CONSTRAINT CustomDocumentReleaseOfInformations_PK PRIMARY KEY CLUSTERED (ReleaseOfInformationId)
)
go



IF OBJECT_ID('CustomDocumentReleaseOfInformations') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentReleaseOfInformations >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE CustomDocumentReleaseOfInformations >>>'
go

if exists (select * from ::fn_listextendedproperty('Newyago_Description_1.02', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'OldDocumentVersionId'))
BEGIN
    exec sys.sp_dropextendedproperty 'Newyago_Description_1.02', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'OldDocumentVersionId'
END
exec sys.sp_addextendedproperty 'Newyago_Description_1.02', 'This will maintain the old document version ID for reference', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'OldDocumentVersionId'
go
if exists (select * from ::fn_listextendedproperty('Newyago_Description_1.02', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'ReleaseOfInformationOrder'))
BEGIN
    exec sys.sp_dropextendedproperty 'Newyago_Description_1.02', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'ReleaseOfInformationOrder'
END
exec sys.sp_addextendedproperty 'Newyago_Description_1.02', 'This will maintain the order of release of information', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'ReleaseOfInformationOrder'
go
if exists (select * from ::fn_listextendedproperty('Newyago_Description_1.02', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'ReleaseToReceiveFrom'))
BEGIN
    exec sys.sp_dropextendedproperty 'Newyago_Description_1.02', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'ReleaseToReceiveFrom'
END
exec sys.sp_addextendedproperty 'Newyago_Description_1.02', 'will contain the current contact from the client information contacts', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'ReleaseToReceiveFrom'
go
if exists (select * from ::fn_listextendedproperty('Newyago_Description_1.02', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'ReleaseContactType'))
BEGIN
    exec sys.sp_dropextendedproperty 'Newyago_Description_1.02', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'ReleaseContactType'
END
exec sys.sp_addextendedproperty 'Newyago_Description_1.02', 'O-Organisation, C-Contact', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'ReleaseContactType'
go
if exists (select * from ::fn_listextendedproperty('Newyago_Description_1.02', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'ReleaseName'))
BEGIN
    exec sys.sp_dropextendedproperty 'Newyago_Description_1.02', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'ReleaseName'
END
exec sys.sp_addextendedproperty 'Newyago_Description_1.02', 'Will Contain the Name of Organisation', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'ReleaseName'
go
if exists (select * from ::fn_listextendedproperty('Newyago_Description_1.02', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'ReleaseAddress'))
BEGIN
    exec sys.sp_dropextendedproperty 'Newyago_Description_1.02', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'ReleaseAddress'
END
exec sys.sp_addextendedproperty 'Newyago_Description_1.02', 'Will Contain the Address of Contact/Organisation', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'ReleaseAddress'
go
if exists (select * from ::fn_listextendedproperty('Newyago_Description_1.02', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'ReleaseCity'))
BEGIN
    exec sys.sp_dropextendedproperty 'Newyago_Description_1.02', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'ReleaseCity'
END
exec sys.sp_addextendedproperty 'Newyago_Description_1.02', 'Will Contain the City of Contact/Organisation', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'ReleaseCity'
go
if exists (select * from ::fn_listextendedproperty('Newyago_Description_1.02', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'ReleasedState'))
BEGIN
    exec sys.sp_dropextendedproperty 'Newyago_Description_1.02', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'ReleasedState'
END
exec sys.sp_addextendedproperty 'Newyago_Description_1.02', 'Will Contain the State of Contact/Organisation', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'ReleasedState'
go
if exists (select * from ::fn_listextendedproperty('Newyago_Description_1.02', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'ReleasePhoneNumber'))
BEGIN
    exec sys.sp_dropextendedproperty 'Newyago_Description_1.02', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'ReleasePhoneNumber'
END
exec sys.sp_addextendedproperty 'Newyago_Description_1.02', 'Will Contain the Phone Number of Contact/Organisation', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'ReleasePhoneNumber'
go
if exists (select * from ::fn_listextendedproperty('Newyago_Description_1.02', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'ReleasedZip'))
BEGIN
    exec sys.sp_dropextendedproperty 'Newyago_Description_1.02', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'ReleasedZip'
END
exec sys.sp_addextendedproperty 'Newyago_Description_1.02', 'Will Contain the Zip of Contact/Organisation', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'ReleasedZip'
go
if exists (select * from ::fn_listextendedproperty('Newyago_Description_1.02', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'AlcoholDrugAbuse'))
BEGIN
    exec sys.sp_dropextendedproperty 'Newyago_Description_1.02', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'AlcoholDrugAbuse'
END
exec sys.sp_addextendedproperty 'Newyago_Description_1.02', 'A-Authorized, P-Probhited', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'AlcoholDrugAbuse'
go
if exists (select * from ::fn_listextendedproperty('Newyago_Description_1.02', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'AIDSRelatedComplex'))
BEGIN
    exec sys.sp_dropextendedproperty 'Newyago_Description_1.02', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'AIDSRelatedComplex'
END
exec sys.sp_addextendedproperty 'Newyago_Description_1.02', 'A-Authorized, P-Probhited', 'schema', 'dbo', 'table', 'CustomDocumentReleaseOfInformations', 'column', 'AIDSRelatedComplex'
go
/* 
 * TABLE: CustomDocumentReleaseOfInformations 
 */

ALTER TABLE CustomDocumentReleaseOfInformations ADD CONSTRAINT DocumentVersions_CustomDocumentReleaseOfInformations_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
go




--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

PRINT 'STEP 7 COMPLETED'
Update SystemConfigurations set CustomDataBaseVersion=1.02

Go


