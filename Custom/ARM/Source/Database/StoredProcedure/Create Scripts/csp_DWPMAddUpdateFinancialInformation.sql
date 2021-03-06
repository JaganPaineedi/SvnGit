/****** Object:  StoredProcedure [dbo].[csp_DWPMAddUpdateFinancialInformation]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DWPMAddUpdateFinancialInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_DWPMAddUpdateFinancialInformation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_DWPMAddUpdateFinancialInformation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/********************************************************************  */            
/* Stored Procedure: dbo.[csp_DWPMAddUpdateFinancialInformation]      */            
/* Copyright: 2007 Provider Access Application        */            
/* Creation Date:  10th-Aug-2007            */            
/*                   */            
/* Purpose: This Stored procedure is used to add and update the data of   
CustomRiverwoodAccessCenter from Access Center - Financial Information  */           
/*                    */          
/* Input Parameters:   
@UserId,@DataWizardInstanceId,@PreviousDataWizardInstanceId,  
@NextStepId,@NextWizardId,@EventId,@ClientID,@ClientSearchGUID,@Validate  

@Val0, @Val1 ,@Val2, @Val3, @Val4, @Val5, @Val6,   
@Val7,  @Val8, @Val9, @Val10, @Val11, @Val12, @Val13, @Val14, @Val15, @Val16,  
@Val17, @Val18, @Val19, @Val20, @Val21  
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
/*  Date           Author       Purpose                                    */            
/*  10th-Aug-2007   Pramod Prakash            Created                                    */            
/*********************************************************************/  */            

CREATE PROCEDURE [dbo].[csp_DWPMAddUpdateFinancialInformation]  
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
    @Finish bit=0,--this will use to set status to finish
	--Params for the HTML Parameters  
	@Val1 CHAR(1),-- ClientHasNoCoverage  
	@Val2 INT,-- FirstInsuranceType  
	@Val3 VARCHAR(100),--FirstInsuranceName  
	@Val4 VARCHAR(50),--FirstPolicyHolderName  
	@Val5 VARCHAR(50), --FirstGroupNumber  
	@Val6 VARCHAR(50), --FirstInsuredId  
	@Val7 VARCHAR(50), --FirstInsuredPhone  

	@Val8 TEXT, -- To confirm the field in Database table for the previous information  

	@Val9 int, --SecondInsuranceType  
	@Val10 VARCHAR(100),--SecondInsuranceName  
	@Val11 VARCHAR(50),--SecondPolicyHolderName  
	@Val12 VARCHAR(50),-- SecondPolicyHolderName  
	@Val13 VARCHAR(50),--SecondInsuredId   
	@Val14 VARCHAR(50),-- SecondInsuredPhone  
	@Val15 INT,   --ThirdnsuranceType  
	@Val16 VARCHAR(100),--ThirdInsuranceName  
	@Val17 VARCHAR(50),--FirstInsuredId  
	@Val18 VARCHAR(50), --ThirdGroupNumber  
	@Val19 VARCHAR(50), --ThirdInsuredId  
	@Val20 VARCHAR(50),--ThirdInsuredPhone  
	@Val21 CHAR(1)=Null  -- EligibleForTreatment(This belogs to EventScreen)  
	--@Val22 VARCHAR(30)--CreatedBy  
)  
AS  
	Declare @NextStepIdOutPut int  
	Declare @CreatedBy varchar(100)  
BEGIN TRY  
	if(@Val21='''')
		set @Val21=Null

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


	--Checking @EventId if it is null or 0 rasing error  
	IF(isnull(@EventId,0)=0)  
	begin  
		RAISERROR   
		(  
			''EventId can not be null'', -- Message text.  
			16, -- Severity.  
			1 -- State.  
		);  
	end  

	--Checking @DataWizardInstanceId if it is null or 0 rasing error  
	IF(isnull(@DataWizardInstanceId,0)=0)  
	begin  
		RAISERROR   
		(  
			''DataWizardInstanceId can not be null'', -- Message text.  
			16, -- Severity.  
			1 -- State.  
		);  
	end  

	--if there no record related to EventId then inserting record  
	IF (NOT EXISTS( SELECT EventId FROM CustomRiverwoodAccessCenter WHERE EventId = @EventId))  
	BEGIN     
		--Add the record     
		INSERT INTO CustomRiverwoodAccessCenter  
		(  
			EventId,ClientHasNoCoverage,   
			FirstInsuranceType, FirstInsuranceName,   
			FirstPolicyHolderName,  FirstGroupNumber,   
			FirstInsuredId, FirstInsuredPhone,   
			SecondInsuranceType, SecondInsuranceName,   
			SecondPolicyHolderName, SecondGroupNumber,     
			SecondInsuredId, SecondInsuredPhone,   
			ThirdnsuranceType, ThirdInsuranceName,  
			ThirdPolicyHolderName, ThirdGroupNumber,   
			ThirdInsuredId,  ThirdInsuredPhone,   
			CreatedBy, createdDate  
		)    
		VALUES  
		(  
			@EventId,--EventId  
			@Val1, --ClientHasNoCoverage  
			@Val2,--FirstInsuranceType  
			@Val3,--FirstInsuranceName   
			@Val4,--FirstPolicyHolderName  
			@Val5,-- FirstGroupNumber  
			@Val6,--FirstInsuredId  
			@Val7, --FirstInsuredPhone  
			@Val9,--SecondInsuranceType  
			@Val10,-- SecondInsuranceName  
			@Val11,--SecondPolicyHolderName  
			@Val12,--SecondGroupNumber   
			@Val13,--SecondInsuredId  
			@Val14,-- SecondInsuredPhone  
			@Val15,--ThirdnsuranceType  
			@Val16, --ThirdInsuranceName  
			@Val17,--ThirdPolicyHolderName  
			@Val18, --ThirdGroupNumber   
			@Val19,--ThirdInsuredId  
			@Val20,--ThirdInsuredPhone   
			@CreatedBy,--CreatedBy  
			getdate()--createdDate  
		)    
	END    

	ELSE  
	BEGIN --If record related to Eventid is already deleted then generation error  
		IF  EXISTS( SELECT EventId FROM CustomRiverwoodAccessCenter WHERE EventId = @EventId AND ISNULL(RecordDeleted,''N'')=''Y'')    
		Begin  
			RAISERROR   
			(  
				''Record Has been Deleted.'', -- Message text.  
				16, -- Severity.  
				1 -- State.  
			);  
		end  

		--Update the record   
		UPDATE  CustomRiverwoodAccessCenter    
		SET   
		ClientHasNoCoverage = @Val1,   
		FirstInsuranceType = @Val2,   
		FirstInsuranceName = @Val3,   
		FirstPolicyHolderName= @Val4,  
		FirstGroupNumber = @Val5,   
		FirstInsuredId = @Val6,   
		FirstInsuredPhone = @Val7,   
		SecondInsuranceType = @Val9,   
		SecondInsuranceName = @Val10,   
		SecondPolicyHolderName = @Val11,   
		SecondGroupNumber = @Val12,   
		SecondInsuredId= @Val13,   
		SecondInsuredPhone = @Val14,   
		ThirdnsuranceType = @Val15,   
		ThirdInsuranceName = @Val16,   
		ThirdPolicyHolderName = @Val17,   
		ThirdGroupNumber = @Val18,   
		ThirdInsuredId = @Val19,   
		ThirdInsuredPhone = @Val20,   
		ModifiedBy = @CreatedBy,   
		ModifiedDate = GetDate()   
		WHERE EventId = @EventId   

	END  
	
--	if(@val21=''Y'' and isnull(@ClientId,0)=0 and (not exists(Select ClientId from Events where EventId=@EventId)))
--	Begin
--		Insert into Clients
--		(
--			Active,
--			FirstName,
--			LastName,
--			SSN,
--			DOB,
--			Sex
--		)
--		Select 
--			''Y'',
--			ClientFirstName,
--			ClientLastName,
--			ClientSSN,
--			ClientDOB,
--			ClientSex
--		from EventScreens
--		where EventId=@EventId 
--		
--		set @ClientId=@@identity    
--	End

	--Updating EventScreens table with EligibleForTreatMent (Y or No) 
	Update EventScreens set EligibleForTreatment=@Val21  
	where EventId=@EventId  


	--Getting NextStepId  
	if(@Validate=1)  
	begin  
		EXEC [ssp_PAGetNextStepId]  
		@DataWizardInstanceId = @DataWizardInstanceId,  
		@NextStepId =@NextStepId,  
		@NextStepIdOutPut = @NextStepIdOutPut OUTPUT  

		set @NextStepId= @NextStepIdOutPut
	end  
--	else  
--	Begin  
--		select @NextStepId as NextStepId  
--	End  

	if(@val21=''N'') 
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
	+ ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_DWPMAddUpdateFinancialInformation'')   
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
