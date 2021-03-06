/****** Object:  StoredProcedure [dbo].[csp_DWPMAddUpdateCallInformation]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DWPMAddUpdateCallInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_DWPMAddUpdateCallInformation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DWPMAddUpdateCallInformation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/********************************************************************  */                
/* Stored Procedure: dbo.csp_DWPMAddUpdateCallInformation      */                
/* Copyright: 2007 Provider Access Application        */                
/* Creation Date:  9th-Aug-2007            */                
/*                   */                
/* Purpose: This Stored procedure is used to add and update the data of       
EventScreens from Access Center - Call Information                */               
/*                    */              
/* Input Parameters:     
@UserId,@DataWizardInstanceId,@PreviousDataWizardInstanceId,    
@NextStepId,@NextWizardId,@EventId,@ClientID,@ClientSearchGUID    

@Val0, @Val1, @Val2, @Val3, @Val4, @Val5, @Val6, @Val7,      
@Val8, @Val9, @Val10, @Val11, @Val12, @Val13, @Val14, @Val15, @Val16,      
@Val17, @Val18, @Val19, @Val20, @Val21, @Val22, @CreatedBy       
/*                      */                
/* Output Parameters:              */                
/*                   */                
/* Return:                 */                
/*                      */                
/* Called By:                */                
/*                      */                
/* Calls:                    */                
/*                      */                
/* Data Modifications:                                                      */                
/*                      */                
/* Updates:                    */                
/*  Date           Author     Purpose                                    */                
/*  9th-Aug-2007   Pramod Prakash            Created                                    */                
/*  30th-Aug-2007  Jatinder Singh           Modified for the Changed HTML, Changed the Order of val parameters */                
/*********************************************************************/  */                

CREATE PROCEDURE [dbo].[csp_DWPMAddUpdateCallInformation]      
(      
	--Common parameters for all update SP    
	@UserId int,    
	@DataWizardInstanceId int,    
	@PreviousDataWizardInstanceId int,    
	@NextStepId int,    
	@NextWizardId int,    

	--3 specific params for Access Center    
	@EventId int,    
	@ClientID int,    
	@ClientSearchGUID type_GUID,    
	--This will be pass to procdure named ssp_getNextStepId to get NextStepId    
	@Validate bit=0,  
    @Finish bit=0,
	@Val1 VARCHAR(20),   -- map to CallerFirstName     
	@Val2 VARCHAR(30),	 -- map to CallerLastName    
	@Val3 VARCHAR(50),	 -- map to CallBackPhoneNumber    
	@Val4 INT,		     --CallerRelation    
	@Val5 VARCHAR(100),  /* Previous information */      
	@Val6 VARCHAR(20),   -- map to ClientFirstName    
	@Val7 VARCHAR(30),   -- map to  ClientLastName     	
	@Val8 VARCHAR(100),  -- map to  Address1    
	@Val9 VARCHAR(100),  --map to Address2      
	@Val10 VARCHAR(50),  --City
	@Val11 CHAR(2),		 --State  
	@Val12 VARCHAR(12),  --Zip
	@Val13 CHAR(5),		 --CountyOfResidence
	@Val14 CHAR(1),		 --ClientSex
	@Val15 DATETIME,	 --ClientDOB    
	@Val16 VARCHAR(9),	 -- map to ClientSSN      
	@Val17 VARCHAR(50),  --ClientHomePhone    
	@Val18 VARCHAR(50),  --ClientWorkPhone      
	@Val19 VARCHAR(50),  --ClientCellPhone      
	@Val20 int,			 --CallReason    
	@Val21 text,		 --CallReasonDescription    
	@Val22 CHAR(1)=Null  --Eligible for Treatment  
  

)      
AS      
	declare @NextStepIdOutPut int    
	Declare @CreatedBy varchar(100)    
BEGIN TRY    
	if (@val14<>''M'' or @Val14<>''F'')  
	Begin  
		Select @val14=''M'' 
	End  

	if @val22 =''''  
	Begin  
		Set @val22=Null  
	End  

	--Getting usercode     
	set @CreatedBy=(select usercode from staff where staffid=@userid and isnull(RecordDeleted,''N'')=''N'')    

	if @CreatedBy is null    
	Begin    
		RAISERROR     
		(    
			''UserId Does Not exist or Deleted'', -- Message text.    
			16, -- Severity.    
			1 -- State.    
		);     
	end    

	--checking DataWizardInstanceId if null return error    
	if(isnull(@DataWizardInstanceId,0)=0)    
	begin    
		RAISERROR     
		(    
			''DataWizardInstanceId Must not be null'', -- Message text.    
			16, -- Severity.    
			1 -- State.    
		);    
	end    

	--This is to ensure that if country is 0 then we put null into it  
	if(@Val13='''' or @Val13=''0'' )  
		set @Val13=null  

	if(@val22=''Y'' and isnull(@ClientId,0)=0 and (not exists(Select ClientId from Events where EventId=@EventId)))
	Begin
		Insert into Clients
		(
			Active,
			FirstName,
			LastName,
			SSN,
			DOB,
			Sex
		)
		Values
		(
			''Y'',
			@Val6,
			@Val7,
			@Val16,
			@Val15,
			@Val14
		)
		
		set @ClientId=@@identity    
	End
	
	if(isnull(@ClientId,0)=0)
		Set @ClientId=Null

	--Checking @EventId if it is null or 0 then inserting record into event table    
	if(isnull(@EventId,0)=0)    
	begin    
		--insert into events    
		insert into Events     
		(    
			--UserID,    
			StaffId,    
			ClientId,    
			EventTypeId,    
			EventDateTime,    
			Status,    
			CreatedBy,    
			CreatedDate    
		)    
		values    
		(    
			--Null,    
			@UserId,    
			@ClientId,    
			1000,--this has to be asked to the client    
			getdate(),    
			2062,--this is for in-progress where category=''EventStatus''  
			@CreatedBy,--CreatedBy    
			getdate()    
		)    

		--Storing Event Id    
		set @EventId=@@identity    

		--insert into events screen    
		INSERT INTO EventScreens    
		(    
			EventId,CallerFirstName,     
			CallerLastName,			
			CallBackPhoneNumber,    
			CallerRelation,     
			
			ClientFirstName,     
			ClientLastName, 
			Address1,     
    		Address2,     
			City,    
			State,   
			Zip,    
			CountyOfResidence,    
			ClientSex,   			
			ClientDOB,  
			ClientSSN,     
			ClientHomePhone,     
			ClientWorkPhone,
			ClientCellPhone,     
			CallReason,     
			CallReasonDescription,    
			EligibleForTreatment,     
			CreatedBy,    
			createdDate    
		)      
		VALUES    
		(    
			@EventId,     
			@Val1, --CallerFirstName    
			@Val2, --CallerLastName    
			@Val3,--CallBackPhoneNumber    
			@Val4,--CallerRelation    
			
			@Val6, --ClientFirstName    
			@Val7, --ClientLastName    
			@Val8,--Address1    
			@Val9,--Address2    
			@Val10,--City    
			@Val11,--State   
			@Val12,--Zip    
			@Val13,--CountyOfResidence    
			@Val14,--ClientSex     
			@Val15,--ClientDOB     			
			@Val16, --ClientSSN    
			@Val17,--ClientHomePhone    
			@Val18,  --ClientWorkPhone  
			@Val19, --ClientCellPhone    
			@Val20, --CallReason    
			@Val21,--CallReasonDescription    
			@Val22,--EligibleForTreatment     
			@CreatedBy,--CreatedBy    
			getdate()--createdDate    
		)      

	End    
	Else IF  NOT EXISTS( SELECT EventId FROM EventScreens WHERE EventId = @EventId)      
	BEGIN    

		--Updating the Events table with the latest ClientId  
		if(isnull(@ClientId,0)<>0)  
		Begin  
			Update Events   
			Set   
			ClientId=@ClientId  
			where  
			EventId=@EventId  
		End    

		INSERT INTO EventScreens    
		(    
			EventId,CallerFirstName,     
			CallerLastName,			
			CallBackPhoneNumber,    
			CallerRelation,     
			
			ClientFirstName,     
			ClientLastName, 
			Address1,     
    		Address2,     
			City,    
			State,   
			Zip,    
			CountyOfResidence,    
			ClientSex,   			
			ClientDOB,  
			ClientSSN,     
			ClientHomePhone,     
			ClientWorkPhone,
			ClientCellPhone,     
			CallReason,     
			CallReasonDescription,    
			EligibleForTreatment,       
			CreatedBy,    
			createdDate    
		)      
		VALUES    
		(    
			@EventId,     
			@Val1, --CallerFirstName    
			@Val2, --CallerLastName    
			@Val3,--CallBackPhoneNumber    
			@Val4,--CallerRelation    
			
			@Val6, --ClientFirstName    
			@Val7, --ClientLastName    
			@Val8,--Address1    
			@Val9,--Address2    
			@Val10,--City    
			@Val11,--State   
			@Val12,--Zip    
			@Val13,--CountyOfResidence    
			@Val14,--ClientSex     
			@Val15,--ClientDOB     			
			@Val16, --ClientSSN    
			@Val17,--ClientHomePhone    
			@Val18,  --ClientWorkPhone  
			@Val19, --ClientCellPhone    
			@Val20, --CallReason    
			@Val21,--CallReasonDescription    
			@Val22,--EligibleForTreatment    
			@CreatedBy,--CreatedBy    
			getdate()--createdDate    
		)      
	End    
	ELSE      
	BEGIN      
		IF  EXISTS(SELECT EventId FROM EventScreens WHERE EventId = @EventId and isnull(RecordDeleted,''N'')=''Y'')     
		begin    
			RAISERROR     
			(    
				''Record Has been Deleted.'', -- Message text.    
				16, -- Severity.    
				1 -- State.    
			);    
		end    

		--Updating the Events table with the latest ClientId  
		if(isnull(@ClientId,0)<>0)  
		Begin  
			Update Events   
			Set   
			ClientId=@ClientId  
			where  
			EventId=@EventId  
		End   
--select * from eventScreens where callerlastname = ''williams'' and callerfirstname like ''samant%''
--select * from events where eventId = 24078

		--Update the record       
		UPDATE EventScreens     
		SET     
			CallerFirstName = @Val1,     
			CallerLastName = @Val2,       
			CallBackPhoneNumber = @Val3,     
			CallerRelation = @Val4,     
			ClientFirstName= @Val6,     
			ClientLastName = @Val7,     			
			Address1= @Val8,      
			Address2 = @Val9,     
			City = @Val10,
			State = @Val11,           			
			Zip = @Val12,     
			CountyOfResidence = @Val13,     
			ClientSex = @Val14,     
			ClientDOB = @Val15,     
			ClientSSN = @Val16,     
			ClientHomePhone = @Val17,
			ClientWorkPhone = @Val18,      			
			ClientCellPhone = @Val19,     
			CallReason = @Val20,     
			CallReasonDescription = @Val21,      
			EligibleForTreatment = @Val22,     
			ModifiedBy = @CreatedBy,     
			ModifiedDate = GetDate()     
		WHERE     
			EventId = @EventId      
	END  

	if(@Validate=1)  
	Begin  
		EXEC [ssp_PAGetNextStepId]    
		@DataWizardInstanceId = @DataWizardInstanceId,    
		@NextStepId =@NextStepId,    
		@NextStepIdOutPut = @NextStepIdOutPut OUTPUT    

		set @NextStepId=@NextStepIdOutPut
	End  
--	Else  
--	Begin  
--		select @NextStepId as NextStepId    
--	End  

	if(@Val22=''N'') 
	Begin
		set @NextStepId=(SELECT DataWizards.LastStep
			FROM DataWizards INNER JOIN
            DataWizardInstances ON DataWizards.DataWizardId = DataWizardInstances.DataWizardId 
			where DataWizardInstanceId=@DataWizardInstanceId)
	End
	
	select @NextStepId as NextStepId    
	select @EventId as EventId,@ClientId as ClientId    

END TRY    
BEGIN CATCH    

	declare @Error varchar(8000)    
	set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())     
	+ ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_DWPMAddUpdateCallInformation'')     
	+ ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())      
	+ ''*****'' + Convert(varchar,ERROR_STATE())    

	RAISERROR     
	(    
		@Error, -- Message text.    
		16, -- Severity.    
		1 -- State.    
	);    

END CATCH
' 
END
GO
