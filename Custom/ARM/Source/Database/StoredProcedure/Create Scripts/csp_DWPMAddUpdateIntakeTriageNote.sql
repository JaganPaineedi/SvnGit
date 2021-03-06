/****** Object:  StoredProcedure [dbo].[csp_DWPMAddUpdateIntakeTriageNote]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DWPMAddUpdateIntakeTriageNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_DWPMAddUpdateIntakeTriageNote]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DWPMAddUpdateIntakeTriageNote]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/********************************************************************  */            
/* Stored Procedure: dbo.[csp_DWPMAddUpdateIntakeTriageNote]      */            
/* Copyright: 2007 Provider Access Application        */            
/* Creation Date:  10th-Aug-2007            */            
/*                   */            
/* Purpose: This Stored procedure is used to add and update the data of   
CustomRiverwoodAccessCenter from Access Center - Intake-TriageNote  */           
/*                    */          
/* Input Parameters: @Val0, @Val4, @Val5, @Val6, @Val7, @Val8, @Val9,@Val10, @Val11,  

/*                      */            
/* Output Parameters:              */            
/*                   */            
/* Return:                 */            
/*                      */            
/* Called By:                */            
/*                      */            
/* Calls:                    */            
/*                      */            
/* Data Modifications:  24-Aug-2007 By Pramod for Adding Update EventScren Table*/            
/*                      */            
/* Updates:                    */            
/* Date           Author       Purpose                                    */            
/* 10th-Aug-2007   Ranjeet Prasad             Created       */
/* 5-2-2008			avoss				update client address state with state abreviation                     */
/* 5-16-2008		avoss				added permissions table logic to update client Info				*/            
/*********************************************************************/  */            

CREATE PROCEDURE [dbo].[csp_DWPMAddUpdateIntakeTriageNote]  
(  
	@UserId int,  
	@DataWizardInstanceId int,  
	@PreviousDataWizardInstanceId int,  
	@NextStepId int,  
	@NextWizardId int,  
	@EventId int,  
	@ClientID int,  
	@ClientSearchGUID type_GUID,  
	@Validate bit=0,  
    @Finish bit=0,--this will use for set status to finish
	@Val1 int, -- map with EventScreens.CallReason  
	@Val2 TEXT,  -- map with EventScreens.CallReasonDescription  
	@Val3 TEXT, ---- To map with Previous Information of the Client  
	@Val4 TEXT, -- map with ReasonForRequest  
	@Val5 TEXT, --map with RiskIndicators  
	@Val6 TEXT, --map with SubstanceAbuseConcerns  
	@Val7 TEXT, --map with PreviousMedications  
	@Val8 TEXT, --map with CaseManagementIndicators  
	@Val9 TEXT, --map with  CourtDHSWorker  
	@Val10 TEXT,--map with ReferralInternalExternal  
	@Val11 char(1)=Null ---- This value will be used to update EventScreens.EligibleForTreatment  
)  
AS
Declare @NextStepIdOutPut int  
	Declare @CreatedBy varchar(100)  
BEGIN TRY   
	if(@Val11='''')
		set @Val11=Null

	--Getting usercode   
	set @CreatedBy=(select usercode from staff where staffid=@userid and isnull(RecordDeleted,''N'')=''N'')  
	
	--Checking for null  
	if @CreatedBy is null  
	Begin  
		RAISERROR   
		(  
			''UserId Does Not exist or Deleted'', -- Message text.  
			16, -- Severity.  
			1 -- State.  
		);
	end  


	--Checking for Event id if it is null or 0 throw error  
	IF(isnull(@EventId,0)=0)  
	begin  
		RAISERROR   
		(  
			''EventId can not be null'', -- Message text.  
			16, -- Severity.  
			1 -- State.  
		);  
	end  

	--Checking if @DataWizardInstanceId is null or 0 rasing Error  
	IF(isnull(@DataWizardInstanceId,0)=0)  
	begin  
		RAISERROR   
		(  
			''DataWizardInstanceId can not be null'', -- Message text.  
			16, -- Severity.  
			1 -- State.  
		);  

	end  
	--Checking for event existence in customRiverwoodAccessCessnter  
	--if it is not there then insert into CustomRiverwoodAccessCenter  
	IF NOT EXISTS( SELECT EventId FROM CustomRiverwoodAccessCenter WHERE EventId = @EventId)  

	BEGIN     
		--Add the record     
		INSERT INTO CustomRiverwoodAccessCenter  
		(  
			EventId,  
			ReasonForRequest,  
			RiskIndicators,  
			SubstanceAbuseConcerns,  
			PreviousMedications,  
			CaseManagementIndicators,  
			CourtDHSWorker,  
			ReferralInternalExternal,  
			CreatedBy,  
			CreatedDate  
		)    
		VALUES  
		(  
			@EventId,--EventId   
			@Val4,--ReasonForRequest   
			@Val5, --RiskIndicators  
			@Val6, --SubstanceAbuseConcerns  
			@Val7, --PreviousMedications  
			@Val8, --CaseManagementIndicators  
			@Val9, --CourtDHSWorker   
			@Val10, --ReferralInternalExternal  
			@CreatedBy, --CreatedBy  
			getdate()--CreatedDate  
		)    
	END    

	ELSE  
	BEGIN  
		--If EventId already Deleted Then Rasing Error  
		IF  EXISTS( SELECT EventId FROM CustomRiverwoodAccessCenter WHERE EventId = @EventId AND ISNULL(RecordDeleted,''N'')=''Y'')    
		begin  
			RAISERROR   
			(  
				''Record Allready Deleted'', -- Message text.  
				16, -- Severity.  
				1 -- State.  
			);  
		end  
		--Update the record   
		UPDATE  CustomRiverwoodAccessCenter    
		SET   
		ReasonForRequest=@Val4,  
		RiskIndicators=@Val5,  
		SubstanceAbuseConcerns=@Val6,  
		PreviousMedications=@Val7,  
		CaseManagementIndicators=@Val8,  
		CourtDHSWorker=@Val9,  
		ReferralInternalExternal=@Val10,  
		ModifiedBy = @CreatedBy,   
		ModifiedDate = GetDate()   
		WHERE EventId = @EventId   

	END   

	--Updating EventScreens   
	Update EventScreens   
	set   
		CallReason = @Val1,  
		CallReasonDescription = @Val2,  
		EligibleForTreatment=@val11  
	where   
	EventId=@EventId  

	--Calling Procedure that return NextStepId  
	if(@Validate=1)  
	Begin  
		EXEC [ssp_PAGetNextStepId]  
		@DataWizardInstanceId = @DataWizardInstanceId,  
		@NextStepId =@NextStepId,  
		@NextStepIdOutPut = @NextStepIdOutPut OUTPUT  

		set @NextStepId=@NextStepIdOutPut
	End  


	--Update active status on inactive client
	if(@Val11=''Y'' and @UserId in (select StaffId from CustomAccessCenterStaffUpdatePermissions) 
				and (exists(Select e.ClientId from 
							Events e 
							join Clients ce on ce.clientId = e.clientid
							where e.eventid = @EventId
							and e.clientid = @Clientid
							and isnull(ce.Active, ''N'') = ''N''
							and isnull(ce.RecordDeleted, ''N'')= ''N''
							and isnull(e.RecordDeleted, ''N'')= ''N'')))
				 --added client id check srf 9-27-2007
	Begin 
	Update Clients
	Set Active = ''Y''
	Where ClientId = @ClientId
	End	 

--select top 1 * from clients
--select top 1 * from clientEpisodes
--select * from globalCodes	
	--Create Episode for Clients  
	if(@Val11=''Y'' and @UserId in (select StaffId from CustomAccessCenterStaffUpdatePermissions)
					and (exists(Select e.ClientId from 
							Events e 
							join Clients c on c.ClientId = e.ClientId and isnull(c.RecordDeleted, ''N'')= ''N''
							join ClientEpisodes ce on c.ClientId=ce.clientId and c.CurrentEpisodeNumber = ce.EpisodeNumber 
							and isnull(ce.RecordDeleted, ''N'')= ''N''
							where e.eventId = @EventId
							and e.ClientId = @ClientId
							and ce.Status in (102)					
							and isnull(e.RecordDeleted, ''N'')= ''N'')
						)		)
	Begin
		insert into ClientEpisodes
		(
		ClientId,
		EpisodeNumber,
		RegistrationDate,
		Status,
		InitialRequestDate,
		IntakeStaff,
		CreatedBy,  
		CreatedDate,
		ModifiedBy,
		ModifiedDate
		)
		select 
			e.ClientId,
			c.CurrentEpisodeNumber+1,
			Getdate(),
			100,
			GetDate(),
			e.StaffId,
			''Access Center'',
			GetDate(),
			''Access Center'',
			GetDate()
		from Events e 
		join Clients c on c.clientId = e.clientid and isnull(c.RecordDeleted, ''N'')= ''N''
		join ClientEpisodes ce on c.clientId=ce.clientId and c.CurrentEpisodeNumber = ce.EpisodeNumber and isnull(ce.RecordDeleted, ''N'')= ''N''
		where e.eventid = @EventId
		and e.clientid = @Clientid
		and isnull(e.RecordDeleted, ''N'')= ''N''

		--Update Client Current Episode to reflect New Episode av 
			update Clients
			set	CurrentEpisodeNumber= (Select CurrentEpisodeNumber+1 from Clients c2 where c2.ClientId=@ClientId),
			ModifiedBy = ''Access Center'',
			ModifiedDate=Getdate()
			where ClientId=@ClientId

	End	 


	--CReate Client
	if(@Val11=''Y'' and isnull(@ClientId,0)=0 
			and @UserId in (select StaffId from CustomAccessCenterStaffUpdatePermissions)
			and (not exists(Select e.ClientId from 
							Events e 
							join Clients ce on ce.clientId = e.clientid
							where e.eventid = @EventId
							and e.clientid = @Clientid
							and isnull(ce.RecordDeleted, ''N'')= ''N''
							and isnull(e.RecordDeleted, ''N'')= ''N'')))
				 --added client id check srf 9-27-2007
	Begin
		Insert into Clients
		(
			Active,
			FirstName,
			LastName,
			SSN,
			DOB,
			Sex,
			CountyOfResidence,
			CreatedBy,  --av for created info
			CreatedDate,
			ModifiedBy,
			ModifiedDate
		)
		Select 
			''Y'',
			ClientFirstName,
			ClientLastName,
			ClientSSN,
			ClientDOB,
			ClientSex,
			CountyOfResidence,
			''Access Center'',  --av for created info
			GetDate(),
			''Access Center'',
			GetDate()
		from EventScreens
		where EventId=@EventId 
		
		set @ClientId=@@identity  


		--Update Events table with new client id
		Update Events
		Set ClientId = @ClientId
		Where EventId = @EventId
		and isnull(ClientId, 0) = 0


	--Insert into ClientPhones home
	Insert into ClientPhones
		(ClientId,
		PhoneType,
		PhoneNumber,
		PhoneNumberText,
		IsPrimary)

	Select e.ClientId,
		30, --Home
       case len(rtrim(es.ClientHomePhone))
            when 10 
            then ''('' +  substring(es.ClientHomePhone, 1, 3) + '') '' + substring(es.ClientHomePhone, 4, 3) + ''-'' + substring(es.ClientHomePhone, 7, 4)
            when 7 
            then ''() '' + substring(es.ClientHomePhone, 1, 3) + ''-'' + substring(es.ClientHomePhone, 4, 4)
            else ltrim(rtrim(es.ClientHomePhone)) end,
		es.ClientHomePhone,
		''Y''		
	From Events e
	Join EventScreens es on es.EventId = e.EventId
	Where e.EventId = @EventId
	and isnull(ClientHomePhone, '''') <> ''''
	and isnull(e.RecordDeleted, ''N'')= ''N''
	and isnull(es.RecordDeleted, ''N'')= ''N''


	--Insert into ClientPhones business
	Insert into ClientPhones
		(ClientId,
		PhoneType,
		PhoneNumber,
		PhoneNumberText,
		IsPrimary)
	Select e.ClientID,
		31, --Business 1
       case len(rtrim(es.ClientWorkPhone))
            when 10 
            then ''('' +  substring(es.ClientWorkPhone, 1, 3) + '') '' + substring(es.ClientWorkPhone, 4, 3) + ''-'' + substring(es.ClientWorkPhone, 7, 4)
            when 7 
            then ''() '' + substring(es.ClientWorkPhone, 1, 3) + ''-'' + substring(es.ClientWorkPhone, 4, 4)
            else ltrim(rtrim(es.ClientWorkPhone)) end,
		es.ClientWorkPhone,
		''N''
	From Events e
	Join EventScreens es on es.EventId = e.EventId
	Where e.EventId = @EventId
	and isnull(ClientWorkPhone, '''') <> ''''
	and isnull(e.RecordDeleted, ''N'')= ''N''
	and isnull(es.RecordDeleted, ''N'')= ''N''



	--Insert into ClientPhones Mobile
	Insert into ClientPhones
		(ClientId,
		PhoneType,
		PhoneNumber,
		PhoneNumberText,
		IsPrimary)
	Select e.ClientId,
		34, --Mobile 1
       case len(rtrim(es.ClientCellPhone))
            when 10 
            then ''('' +  substring(es.ClientCellPhone, 1, 3) + '') '' + substring(es.ClientCellPhone, 4, 3) + ''-'' + substring(es.ClientCellPhone, 7, 4)
            when 7 
            then ''() '' + substring(es.ClientCellPhone, 1, 3) + ''-'' + substring(es.ClientCellPhone, 4, 4)
            else ltrim(rtrim(es.ClientCellPhone)) end,
		es.ClientCellPhone,
		''N''
	From Events e
	Join EventScreens es on es.EventId = e.EventId
	Where e.EventId = @EventId
	and isnull(ClientCellPhone, '''') <> ''''
	and isnull(e.RecordDeleted, ''N'')= ''N''
	and isnull(es.RecordDeleted, ''N'')= ''N''


	Insert Into ClientAddresses
	(ClientId, AddressType, Address, City, State, Zip, Display, Billing)
	Select e.ClientId, 90, -- Home
	case when isnull(es.Address1, '''') = '''' then '''' else es.Address1 + char(13) + char(10) end +
	case when isnull(es.Address2, '''') = '''' then '''' else es.Address2 + char(13) + char(10) end,
	es.City, s.StateAbbreviation, es.Zip, 
	Case when isnull(es.Address1, '''') = '''' then '''' else es.Address1 + char(13) + char(10) end +
	case when isnull(es.Address2, '''') = '''' then '''' else es.Address2 + char(13) + char(10) end +
	case when isnull(es.City, '''') = '''' then '''' else es.City + '', '' end +
	case when isnull(es.State, '''') = '''' then '''' else s.StateAbbreviation + '' '' end +
	case when isnull(es.Zip, '''') = '''' then '''' else es.ZIP end,
	''Y''
	From Events e
	Join EventScreens es on es.EventId = e.EventId
	Left Join States s on s.StateFIPS = es.State
	Where e.EventId = @EventId
	and (isnull(es.address1, '''') <> ''''
			or isnull(es.address2, '''') <> ''''
			or isnull(es.City, '''') <> ''''
			or isnull(es.State, '''') <> ''''
			or isnull(es.zip, '''') <> '''')	
	and isnull(e.RecordDeleted, ''N'')= ''N''
	and isnull(es.RecordDeleted, ''N'')= ''N''	

	--Create Episode for New Client av
	insert into ClientEpisodes
		(
		ClientId,
		EpisodeNumber,
		RegistrationDate,
		Status,
		InitialRequestDate,
		createdBy,
		CreatedDate,
		ModifiedBy,
		ModifiedDate
		)
	select 
		e.ClientId,
		1,
		Getdate(),
		100,
		GetDate(),
		''Access Center'',
		GetDate(),
		''Access Center'',
		GetDate()
	from Events e 
	where e.eventid = @EventId
	and isnull(e.RecordDeleted, ''N'')= ''N''

		--Update Client Current Episode to reflect New Episode av
		update Clients
		set	CurrentEpisodeNumber=1,
			ModifiedBy=''Access Center'',
			ModifiedDate=Getdate()
		where ClientId=@ClientId



	end	





	if(@Val11=''N'') 
	Begin
		set @NextStepId=(SELECT DataWizards.LastStep
			FROM DataWizards INNER JOIN
            DataWizardInstances ON DataWizards.DataWizardId = DataWizardInstances.DataWizardId 
			where DataWizardInstanceId=@DataWizardInstanceId)
	End
	if(@NextStepId = NULL)
	     Begin  
      RAISERROR   
      (  
       ''Next StepId Does Not Exist.'', -- Message text.  
        16, -- Severity.  
       1 -- State.  
      );  
    end  


	select @NextStepId as NextStepId  
	select @EventId as EventId,@ClientId as ClientId  

END TRY  
BEGIN CATCH  
declare @Error varchar(8000)  
set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())   
+ ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_DWPMAddUpdateIntakeTriageNote'')   
+ ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())    
+ ''*****'' + Convert(varchar,ERROR_STATE())  

RAISERROR   
(  
@Error, -- Message text.  
16, -- Severity.  
1 -- State.  
);  
--SELECT    
--    ERROR_NUMBER() AS ErrorNumber,    
--    ERROR_SEVERITY() AS ErrorSeverity,    
--    ERROR_STATE() AS ErrorState,    
--    ERROR_PROCEDURE() AS ErrorProcedure,    
--    ERROR_LINE() AS ErrorLine,    
--    ERROR_MESSAGE() AS ErrorMessage;    
END CATCH
' 
END
GO
