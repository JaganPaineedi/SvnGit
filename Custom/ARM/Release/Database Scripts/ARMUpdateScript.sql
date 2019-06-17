 IF NOT EXISTS (SELECT * FROM SystemDatabases WHERE SystemDatabaseId = 1) INSERT INTO [SystemDatabases] ([SystemDatabaseId],[OrganizationName],[ConnectionString],[MasterDatabase],[RowIdentifier],[CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[RecordDeleted],[DeletedDate],[DeletedBy])VALUES(1,'ARM',NULL,'Y','6EC23937-310D-4BEE-AF1D-D90D8B301A5A','sa','Sep 28 2011  4:31:11:950PM','sa','Sep 28 2011  4:31:11:950PM',NULL,NULL,NULL)

-- STEP 1

UPDATE systemconfigurations
SET ServiceDetailsServicePagePath = '~/ActivityPages/Client/Detail/ServiceDetail/ServiceDetailUCHarbor.ascx'
, ServiceNoteServicePagePath = '~/ActivityPages/Client/Detail/ServiceNote/ServiceNoteUC2.ascx'
, SystemDatabaseId = 1

-- STEP 2
UPDATE servicedropdownconfigurations
SET 
  ProgramIdFilteredBy = 'ClinicianId'
, ProgramIdUsesSharedTable = 'N'
, ProgramIdStoredProcedure = 'csp_GetProgramForService'

, ClinicianIdUsesSharedTable = 'N'
, ClinicianIdStoredProcedure = 'csp_GetClinicianForService'

, ProcedureCodeIdUsesSharedTable = 'N'
, ProcedureCodeIdStoredProcedure = 'csp_GetProcedureCodesForService'

, LocationIdFilteredBy = 'ClinicianId'
, LocationIdUsesSharedTable = 'N'
, LocationIdStoredProcedure = 'csp_GetLocationForService'

, AttendingIdFilteredBy = 'ClinicianId'
, AttendingIdUsesSharedTable = 'N'
, AttendingIdStoredProcedure = 'csp_GetAttendingForService'



UPDATE DocumentCodes SET DocumentType = 10 Where DocumentCodeId = 2

UPDATE Screens SET CustomFieldFormId = 20008 WHERE ScreenId = 3

DELETE FROM ClientSearchCustomConfigurations

UPDATE Screens Set ValidationStoredProcedureComplete = Null where ScreenId = 10900
UPDATE Screens Set ValidationStoredProcedureComplete = Null Where ScreenId = 10941