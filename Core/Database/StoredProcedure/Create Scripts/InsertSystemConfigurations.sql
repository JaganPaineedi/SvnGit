/*  Date			Author			Purpose																							*/ 
/*  --------------------------------------------------------------------------------------------------------------------------------*/           
/*  07-APRIL-2015	Akwinass		Created.(Task #1419 in Engineering Improvement Initiatives- NBL(I))		                        */
/*  30-JUNE-2015	Akwinass		Added 'BILLINGDIAGNOSISDEFAULTBUTTON' key.(Task #147 in Valley Client Acceptance Testing Issues)*/
/*  --------------------------------------------------------------------------------------------------------------------------------*/ 
IF NOT EXISTS (SELECT * FROM SystemConfigurationKeys WHERE [key] = 'DEFAULTORDERTEMPLATEFREQUENCYID')
BEGIN
	INSERT INTO [SystemConfigurationKeys]([CreatedBy],[CreateDate],[ModifiedBy],[ModifiedDate],[Key],[Value])
	VALUES(SYSTEM_USER,GETDATE(),SYSTEM_USER,GETDATE(),'DEFAULTORDERTEMPLATEFREQUENCYID',NULL)
END

IF NOT EXISTS (SELECT * FROM SystemConfigurationKeys WHERE [key] = 'DEFAULTORDERPRIORITYID')
BEGIN
	INSERT INTO [SystemConfigurationKeys]([CreatedBy],[CreateDate],[ModifiedBy],[ModifiedDate],[Key],[Value])
	VALUES(SYSTEM_USER,GETDATE(),SYSTEM_USER,GETDATE(),'DEFAULTORDERPRIORITYID',NULL)
END

IF NOT EXISTS (SELECT * FROM SystemConfigurationKeys WHERE [key] = 'DEFAULTORDERSCHEDULEID')
BEGIN
	INSERT INTO [SystemConfigurationKeys]([CreatedBy],[CreateDate],[ModifiedBy],[ModifiedDate],[Key],[Value])
	VALUES(SYSTEM_USER,GETDATE(),SYSTEM_USER,GETDATE(),'DEFAULTORDERSCHEDULEID',NULL)
END

IF NOT EXISTS (SELECT * FROM SystemConfigurationKeys WHERE [key] = 'LABSOFTORGANIZATIONID')
BEGIN
	INSERT INTO [SystemConfigurationKeys]([CreatedBy],[CreateDate],[ModifiedBy],[ModifiedDate],[Key],[Value])
	VALUES(SYSTEM_USER,GETDATE(),SYSTEM_USER,GETDATE(),'LABSOFTORGANIZATIONID',NULL)
END

IF NOT EXISTS (SELECT * FROM SystemConfigurationKeys WHERE [key] = 'LABSOFTWEBSERVICEURL')
BEGIN
	INSERT INTO [SystemConfigurationKeys]([CreatedBy],[CreateDate],[ModifiedBy],[ModifiedDate],[Key],[Value])
	VALUES(SYSTEM_USER,GETDATE(),SYSTEM_USER,GETDATE(),'LABSOFTWEBSERVICEURL',NULL)
END

IF NOT EXISTS (SELECT * FROM SystemConfigurationKeys WHERE [key] = 'LABSOFTENABLED')
BEGIN
	INSERT INTO [SystemConfigurationKeys]([CreatedBy],[CreateDate],[ModifiedBy],[ModifiedDate],[Key],[Value])
	VALUES(SYSTEM_USER,GETDATE(),SYSTEM_USER,GETDATE(),'LABSOFTENABLED',NULL)
END

IF NOT EXISTS (SELECT * FROM SystemConfigurationKeys WHERE [key] = 'DISPLAYCLIENTINFORMATIONINCLIENTORDERS')
BEGIN
	INSERT INTO [SystemConfigurationKeys]([CreatedBy],[CreateDate],[ModifiedBy],[ModifiedDate],[Key],[Value])
	VALUES(SYSTEM_USER,GETDATE(),SYSTEM_USER,GETDATE(),'DISPLAYCLIENTINFORMATIONINCLIENTORDERS',NULL)
END