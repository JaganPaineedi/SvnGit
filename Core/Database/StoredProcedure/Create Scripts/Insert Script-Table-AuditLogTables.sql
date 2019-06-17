/************************************ Audit Log Tables *********************************************/

	IF NOT EXISTS (SELECT * FROM dbo.AuditLogTables WHERE TableName = 'SystemConfigurationKeys')
BEGIN 
   -- SET IDENTITY_INSERT dbo.AuditLogTables ON 
		INSERT INTO AuditLogTables 
				(TableName 
				 ,Active) 
		VALUES	('SystemConfigurationKeys' 
				,'Y' 
		) 
	--SET IDENTITY_INSERT dbo.AuditLogTables OFF 
	 END 
/********************************* Audit Log Tables Update ***************************************/

/************************************ Audit Log Tables *********************************************/

	IF NOT EXISTS (SELECT * FROM dbo.AuditLogTables WHERE TableName = 'SystemConfigurations')
BEGIN 
   -- SET IDENTITY_INSERT dbo.AuditLogTables ON 
		INSERT INTO AuditLogTables 
				(TableName 
				 ,Active) 
		VALUES	('SystemConfigurations' 
				,'Y' 
		) 
	--SET IDENTITY_INSERT dbo.AuditLogTables OFF 
	 END 
/********************************* Audit Log Tables Update ***************************************/

/************************************ Audit Log Tables *********************************************/

	IF NOT EXISTS (SELECT * FROM dbo.AuditLogTables WHERE TableName = 'ReportServers')
BEGIN 
   -- SET IDENTITY_INSERT dbo.AuditLogTables ON 
		INSERT INTO AuditLogTables 
				(TableName 
				 ,Active) 
		VALUES	('ReportServers' 
				,'Y' 
		) 
	--SET IDENTITY_INSERT dbo.AuditLogTables OFF 
	 END 
/********************************* Audit Log Tables Update ***************************************/

/************************************ Audit Log Tables *********************************************/

	IF NOT EXISTS (SELECT * FROM dbo.AuditLogTables WHERE TableName = 'ImageServers')
BEGIN 
   -- SET IDENTITY_INSERT dbo.AuditLogTables ON 
		INSERT INTO AuditLogTables 
				(TableName 
				 ,Active) 
		VALUES	('ImageServers' 
				,'Y' 
		) 
	--SET IDENTITY_INSERT dbo.AuditLogTables OFF 
	 END 
/********************************* Audit Log Tables Update ***************************************/

/************************************ Audit Log Tables *********************************************/

	IF NOT EXISTS (SELECT * FROM dbo.AuditLogTables WHERE TableName = 'Agency')
BEGIN 
   -- SET IDENTITY_INSERT dbo.AuditLogTables ON 
		INSERT INTO AuditLogTables 
				(TableName 
				 ,Active) 
		VALUES	('Agency' 
				,'Y' 
		) 
	--SET IDENTITY_INSERT dbo.AuditLogTables OFF 
	 END 
/********************************* Audit Log Tables Update ***************************************/

/************************************ Audit Log Tables *********************************************/

	IF NOT EXISTS (SELECT * FROM dbo.AuditLogTables WHERE TableName = 'ServiceDropdownConfigurations')
BEGIN 
   -- SET IDENTITY_INSERT dbo.AuditLogTables ON 
		INSERT INTO AuditLogTables 
				(TableName 
				 ,Active) 
		VALUES	('ServiceDropdownConfigurations' 
				,'Y' 
		) 
	--SET IDENTITY_INSERT dbo.AuditLogTables OFF 
	 END 
/********************************* Audit Log Tables Update ***************************************/

/************************************ Audit Log Tables *********************************************/

	IF NOT EXISTS (SELECT * FROM dbo.AuditLogTables WHERE TableName = 'ClientSearchCustomConfigurations')
BEGIN 
   -- SET IDENTITY_INSERT dbo.AuditLogTables ON 
		INSERT INTO AuditLogTables 
				(TableName 
				 ,Active) 
		VALUES	('ClientSearchCustomConfigurations' 
				,'Y' 
		) 
	--SET IDENTITY_INSERT dbo.AuditLogTables OFF 
	 END 
/********************************* Audit Log Tables Update ***************************************/