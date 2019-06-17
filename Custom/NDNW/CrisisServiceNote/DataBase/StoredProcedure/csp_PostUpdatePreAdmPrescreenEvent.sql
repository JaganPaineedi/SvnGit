/****** Object:  StoredProcedure [dbo].[csp_PostUpdatePreAdmPrescreenEvent]   ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostUpdatePreAdmPrescreenEvent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PostUpdatePreAdmPrescreenEvent]
GO


/****** Object:  StoredProcedure [dbo].[csp_PostUpdatePreAdmPrescreenEvent]  ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_PostUpdatePreAdmPrescreenEvent]  
( 
	@ScreenKeyId int,                              
	@StaffId int,                              
	@CurrentUser varchar(30) ,                             
	@CustomParameters xml             
)  
AS  
/******************************************************************************                                            
**  File:                                             
**  Name: csp_PostUpdatePreAdmPrescreenEvent                                            
**  Desc: This storeProcedure will create pre screen event in cm  
**  
**  Parameters:   
**  Input @ScreenKeyId INT  
 @StaffId int,                              
 @CurrentUser varchar(30) ,                             
 @CustomParameters xml     
**  Output     ----------       -----------   
**    
**  Auth:  Sudhir Singh  
**  Date:  Feb 27, 2012  
*******************************************************************************   
**  Change History    
*******************************************************************************   
**  Date:			Author:			Description:   
**  --------		--------		-------------------------------------------   
**					Saurav Pande	Send Message when service note is signed as Pre-Adm. Task #83, General Impelementation.
**	April 20, 2012	Pralyankar		Modified for getting Staff of PCM Database using StaffSystemAccess table.
**	July 13,2012	Mamta Gupta		Stop to create prescreen event in caremanagement if user not exist in caremanagement database
									Ref task No. 1814 - Kalamazoo Bugs - Go Live 
*******************************************************************************/  
BEGIN  
 BEGIN TRY  
	DECLARE @DocumentId int, @DocumentVersionID int  
	SELECT @Documentid = @ScreenKeyId   
	DECLARE @ClientID INT, @CareManagementId INT , 
	----Commented by Mamta Gupta - Ref task No. 1814 - Kalamazoo Bugs - Go Live 
	@AuthorId INT, @VersionId Int


	DECLARE @ValidationErrors table (
		TableName       varchar(200),
		ColumnName      varchar(200),
		ErrorMessage    varchar(2000),
		PageIndex       int,        
		TabOrder       int,        
		ValidationOrder int
	)  

	----> Get ClientID from document table  <----   
	SELECT @AuthorId=AuthorId, @ClientID = ClientId, @DocumentVersionID = InProgressDocumentVersionId FROM Documents   
	WHERE DocumentId = @DocumentId  and isnull(RecordDeleted,'N') = 'N'
		----Commented by Mamta Gupta - Ref task No. 1814 - Kalamazoo Bugs - Go Live
	Select @VersionId=Version from DocumentVersions where DocumentVersionId=@DocumentVersionID
		----Commented by Mamta Gupta - Ref task No. 1814 - Kalamazoo Bugs - Go Live
	if(@StaffId <> @AuthorId or @VersionId <> 1)
		return 
  
	declare @ServiceStartDate datetime  
	select top 1 @ServiceStartDate = se.DateOfService from Services se
		Join Documents d on se.ServiceId = d.ServiceId 
	where d.DocumentId = @DocumentId
   
	

	/*******************************************************************/
	DECLARE @DynamicQuery  NVARCHAR(4000), @MasterStaffId INT, @MasterStaffUserCode Varchar(100)

	----> Get PCM Master DB Name <----  
	DECLARE  @DBName VARCHAR(50)   
	SET @DBName = [dbo].[fn_GetPCMMasterDBName]() 
   
	------ Get ID of System Database ------
	DECLARE @CurrentDatabaseDatabaseId INT
	SELECT @CurrentDatabaseDatabaseId = SystemDatabaseId
	FROM  SystemConfigurations
	----------------------------------------

	------- Get User Code of Staff from CM/PA Database -------------->
	SET @DynamicQuery = 'SELECT @MasterStaffId = AccessStaffId FROM [' + @DBName + '].[dbo].[StaffDatabaseAccess] WHERE AccessfunctionalArea=5793 AND SystemDatabaseId = ' + cast(@CurrentDatabaseDatabaseId AS VARCHAR) + '  AND SystemStaffId = ' + cast(@StaffId as VARCHAR(10))
	EXEC sp_executesql @DynamicQuery, N'@MasterStaffId INT OUTPUT', @MasterStaffId output

	SET @DynamicQuery = 'SELECT @MasterStaffUserCode = UserCode FROM [' + @DBName + '].[dbo].[Staff] WHERE StaffId = ' + cast(@MasterStaffId as VARCHAR(10))
	EXEC sp_executesql @DynamicQuery, N'@MasterStaffUserCode VARCHAR(100) OUTPUT', @MasterStaffUserCode output
	/*******************************************************************/

	IF (isnull(@MasterStaffUserCode,'') = '')
	BEGIN
		---- Delete existing record and insert new row for expected error----
		Delete FROM @ValidationErrors
		insert into @ValidationErrors (TableName, ColumnName, ErrorMessage)        
		select 'StaffDatabaseAccess', 'StaffId', 'This Pre-screen Document is unable to signed because the information needed for Staff does not exist in the CareManagement system.  Please contact Technical Support to correct this problem.  Thank you'  
		-------------------------------------------------------------
		GOTO Error
	END    
	----> Create master client <-----  
	EXEC ssp_CreateMasterClient @MasterStaffUserCode, @ClientId, @CareManagementId OUTPUT  
    
	----> Update CamemanagementId <-----  
	IF (@CareManagementId >0)  
	BEGIN  
		Update Clients Set CareManagementId = @CareManagementId Where CLientId = @ClientId  
		----> Declare of dynamic quiry required variables <----  
		DECLARE @NewEventId INT, @NewDocumentVersionID INT,@CurrentDBName VARCHAR(50)  
		SELECT @CurrentDBName = DB_NAME()  
    
		Create Table #ReturnValues  
		(  
			EventId INT,  
			DocumentVersionId INT  
		)  
     
		----> Create event in cm for documentcodeid = 1048 <-----  
		SET @DynamicQuery = ' [' + @DBName + '].[dbo].csp_scCreateEvent '  
			+ cast(@MasterStaffId as varchar(10)) + ','''  
			+ @MasterStaffUserCode + ''','  
			+ cast(isnull(@CareManagementId,0) as varchar(10)) + ','   
			+ cast(0 as varchar(10))   
			+ ', 1048, 22 ,'''
			+cast(isnull(@ServiceStartDate,0) as varchar(20))  +''''
  
		INSERT INTO #ReturnValues  
		EXEC sp_executesql @DynamicQuery  
  
		----> Get new documentversion id from cm <-----  
		SELECT @NewDocumentVersionID = DocumentVersionID FROM #ReturnValues   
     
   
		----> inser the data into cm tables to create new event <-----  
		IF (isnull(@NewDocumentVersionID,0) > 0)  
		BEGIN  
			SET @DynamicQuery = 'EXEC [' + @DBName + '].[dbo].csp_PCMSaveCustomAcuteServicesPrescreensEventData '+cast(@DocumentVersionID  as varchar(10))+','+cast(@NewDocumentVersionID  as varchar(10) )+',''' + @CurrentUser + ''','''+@CurrentDBName+''''
			EXEC sp_executesql @DynamicQuery  
      
			SET @DynamicQuery = 'INSERT INTO ['+ @DBName +'].[dbo].[DiagnosesIAndII]('+  
				'DocumentVersionId  
				,Axis  
				,DSMCode  
				,DSMNumber  
				,DiagnosisType  
				,RuleOut  
				,Billable  
				,Severity  
				,DSMVersion  
				,DiagnosisOrder  
				,Specifier  
				,Remission  
				,Source  
				,RowIdentifier  
				,CreatedBy  
				,CreatedDate  
				,ModifiedBy  
				,ModifiedDate) '+  
			'select   
				 '+cast(@NewDocumentVersionID  as varchar(10))+'  
				 ,Axis  
				 ,DSMCode  
				 ,DSMNumber  
				 ,DiagnosisType  
				 ,RuleOut  
				 ,Billable  
				 ,Severity  
				 ,DSMVersion  
				 ,DiagnosisOrder  
				 ,Specifier  
				 ,Remission  
				 ,Source  
				 ,RowIdentifier  
				 ,''' + @MasterStaffUserCode + '''  
				 ,''' + cast(Getdate() as varchar(20)) + '''  
				 ,''' + @MasterStaffUserCode + '''  
				 ,''' + cast(Getdate() as varchar(20)) + '''' +  
				' From [dbo].[DiagnosesIAndII] where DocumentVersionId = '+cast(@DocumentVersionID  as varchar(10))     
			EXEC sp_executesql @DynamicQuery  
      
			SET @DynamicQuery = 'INSERT INTO ['+ @DBName +'].[dbo].[diagnosesIII]('+  
				'DocumentVersionId  
				,CreatedBy  
				,CreatedDate  
				,ModifiedBy  
				,ModifiedDate       
				,Specification) ' +  
				'select   
				'+cast(@NewDocumentVersionID  as varchar(10))+'  
				,''' + @MasterStaffUserCode + '''  
				,''' + cast(Getdate() as varchar(20)) + '''  
				,''' + @MasterStaffUserCode + '''  
				,''' + cast(Getdate() as varchar(20)) + '''      
				,Specification '+  
				' From [dbo].[diagnosesIII] where DocumentVersionId = '+cast(@DocumentVersionID  as varchar(10))  
			EXEC sp_executesql @DynamicQuery  
      
			SET @DynamicQuery = 'INSERT INTO ['+ @DBName +'].[dbo].[DiagnosesIV]('+  
				'DocumentVersionId  
				,PrimarySupport  
				,SocialEnvironment  
				,Educational  
				,Occupational  
				,Housing  
				,Economic  
				,HealthcareServices  
				,Legal  
				,Other  
				,Specification  
				,CreatedBy  
				,CreatedDate  
				,ModifiedBy  
				,ModifiedDate) '+  
			'select   
				'+cast(@NewDocumentVersionID  as varchar(10))+'  
				,PrimarySupport  
				,SocialEnvironment  
				,Educational  
				,Occupational  
				,Housing  
				,Economic  
				,HealthcareServices  
				,Legal  
				,Other  
				,Specification  
				,''' + @MasterStaffUserCode + '''  
				,''' + cast(Getdate() as varchar(20)) + '''  
				,''' + @MasterStaffUserCode + '''  
				,''' + cast(Getdate() as varchar(20)) + '''' +  
				' From [dbo].[DiagnosesIV] where DocumentVersionId = '+cast(@DocumentVersionID  as varchar(10))  
			EXEC sp_executesql @DynamicQuery  
      
			SET @DynamicQuery = 'INSERT INTO ['+ @DBName +'].[dbo].[DiagnosesV]('+  
				'DocumentVersionId  
				,AxisV  
				,CreatedBy  
				,CreatedDate  
				,ModifiedBy  
				,ModifiedDate) '+  
				'select   
				'+cast(@NewDocumentVersionID  as varchar(10))+'  
				,AxisV  
				,''' + @MasterStaffUserCode + '''  
				,''' + cast(Getdate() as varchar(20)) + '''  
				,''' + @MasterStaffUserCode + '''  
				,''' + cast(Getdate() as varchar(20)) + '''' +  
				' From [dbo].[DiagnosesV] where DocumentVersionId = '+cast(@DocumentVersionID  as varchar(10))   
			EXEC sp_executesql @DynamicQuery  
      
			SET @DynamicQuery = 'INSERT INTO ['+ @DBName +'].[dbo].[CustomMedicationHistory]('+  
				'DocumentVersionId  
				,MedicationName  
				,DosageFrequency  
				,Purpose  
				,PrescribingPhysician  
				,RowIdentifier  
				,CreatedBy  
				,CreatedDate  
				,ModifiedBy  
				,ModifiedDate) '+  
			'select   
				'+cast(@NewDocumentVersionID  as varchar(10))+'  
				,MedicationName  
				,DosageFrequency  
				,Purpose  
				,PrescribingPhysician  
				,RowIdentifier  
				,''' + @MasterStaffUserCode + '''  
				,''' + cast(Getdate() as varchar(20)) + '''  
				,''' + @MasterStaffUserCode + '''  
				,''' + cast(Getdate() as varchar(20)) + '''' +  
				' From [dbo].[CustomMedicationHistory] where DocumentVersionId = '+cast(@DocumentVersionID  as varchar(10))   
			EXEC sp_executesql @DynamicQuery  
      
			SET @DynamicQuery = 'INSERT INTO ['+ @DBName +'].[dbo].[CustomSUSubstances]('+  
				'DocumentVersionId  
				,SubstanceName  
				,Amount  
				,Frequency  
				,RowIdentifier  
				,CreatedBy  
				,CreatedDate  
				,ModifiedBy  
				,ModifiedDate) '+  
			'select   
				'+cast(@NewDocumentVersionID  as varchar(10))+'  
				,SubstanceName  
				,Amount  
				,Frequency  
				,RowIdentifier  
				,''' + @MasterStaffUserCode + '''  
				,''' + cast(Getdate() as varchar(20)) + '''  
				,''' + @MasterStaffUserCode + '''  
				,''' + cast(Getdate() as varchar(20)) + '''' +  
				' From [dbo].[CustomSUSubstances] where DocumentVersionId = '+cast(@DocumentVersionID  as varchar(10))   
			EXEC sp_executesql @DynamicQuery  
		END   
	END   



	--Added by Saurav Pande, to send message to Primary clinician of client.
	exec csp_SCNotificationOfContractedProviders @ClientID,@CurrentUser

	return
Error:  
	IF (SELECT count(*) FROM @ValidationErrors) > 0
	BEGIN
		SELECT * FROM @ValidationErrors     
		return
	END


END TRY  
BEGIN CATCH                              
	DECLARE @Error varchar(8000)                                                                           
	SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                     
		+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_PostUpdatePreAdmPrescreenEvent')                                                                                                         
		+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                          
		+ '*****' + Convert(varchar,ERROR_STATE())                                                      
	RAISERROR                                                                                                         
	(                                                                           
		@Error, -- Message text.                                                                                                        
		16, -- Severity.                                                                                                        
		1 -- State.                                                                                                        
	);                                                                                                      
END CATCH  

END
GO


