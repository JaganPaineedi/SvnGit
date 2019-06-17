-- Drop Table If Exist
If Exists (Select * From   sys.Objects 
           Where  Object_Id = Object_Id(N'dbo.csp_RDLCustomDocumentDischarges') 
                  And Type In ( N'P', N'PC' )) 
	Drop Procedure dbo.csp_RDLCustomDocumentDischarges
Go


/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentDischarges]    Script Date: 11/20/2015 10:49:12 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[csp_RDLCustomDocumentDischarges]                                          
(                                                            
 @DocumentVersionId as int                                                            
)                                            
AS          
                                                       
                                                          
/*********************************************************************                        
-- Stored Procedure: dbo.[csp_RDLCustomDocumentDischarges]                                                           
                          
-- Creation Date:    28.11.2014                       
--                         
-- Purpose:  Return Tables for CustomDocumentDischarge and fill the type Dataset                        
--                        
-- Create:                        
--   Date			 Author				 Purpose                        
--  03.FEB.2015		 Anto				 To fetch CustomDocumentDischarge               
/*	29/11/2018		Dasari Sunil			What:Removed code which is used check for the discharged client programs of the services.
											Why:Discharge document failing to pull forward services,Doing a discharge document, there is a section titled "summary of services provided.
											New Directions - Support Go Live #892 */  
*********************************************************************/     
BEGIN                                                      
  BEGIN TRY  

	DECLARE @ClientId INT
	DECLARE @OrganizationName VARCHAR(250)
	DECLARE @DocumentName  VARCHAR(100)
	
	
	DECLARE @SummaryOfServiceProvided VARCHAR(MAX)
	DECLARE @ProgramIDs VARCHAR(200)
	DECLARE @LatestAssessmentDocumentVersionID INT
	DECLARE @PresentingProblem VARCHAR(MAX)
	DECLARE @CountyResidence VARCHAR(200)
	DECLARE @CountyResponse VARCHAR(200)
	DECLARE @CountyResidenceId INT
	DECLARE @CountyResponseId INT
	DECLARE @AddressDetails VARCHAR(MAX)
	DECLARE @ClientName VarChar(75)

	select @ClientId = ClientId from documents where InProgressDocumentVersionId = @DocumentVersionId		
	SELECT TOP 1 @OrganizationName = OrganizationName FROM SystemConfigurations
	
	SELECT @DocumentName = DocumentCodes.DocumentName
		  ,@ClientName = c.LastName + ', ' + c.FirstName
		FROM Documents
		JOIN Staff S ON Documents.AuthorId = S.StaffId
		JOIN Clients C ON Documents.ClientId = C.ClientId
			AND isnull(C.RecordDeleted, 'N') <> 'Y'
		JOIN DocumentVersions dv ON dv.DocumentId = documents.DocumentId
		INNER JOIN DocumentCodes on DocumentCodes.DocumentCodeid= Documents.DocumentCodeId      
			AND ISNULL(DocumentCodes.RecordDeleted,'N')='N' 
		LEFT JOIN GlobalCodes GC ON S.Degree = GC.GlobalCodeId
		WHERE dv.DocumentVersionId = @DocumentVersionId
			AND isnull(Documents.RecordDeleted, 'N') = 'N'	
			
			
	SELECT @ProgramIDs = COALESCE(@ProgramIDs + ', ' + CONVERT(VARCHAR(20), ClientProgramId), CONVERT(VARCHAR(20), ClientProgramId))
		FROM ClientPrograms
		WHERE ClientId = @ClientID
			AND IsNull(RecordDeleted, 'N') = 'N'
			--AND [Status] <> 5   
	EXEC csp_SCGetSummaryServicesProvided @ClientId =@ClientId,@ProgramIdCSV=@ProgramIDs,@SummaryOfService=@SummaryOfServiceProvided OUTPUT        	
	
	
	--Assessment PresentingProblem--
	
	SELECT TOP 1 @LatestAssessmentDocumentVersionID = CurrentDocumentVersionId
	FROM CustomHRMAssessments CDCD
	INNER JOIN Documents Doc ON CDCD.DocumentVersionId = Doc.CurrentDocumentVersionId
	WHERE Doc.ClientId = @ClientID
		AND Doc.[Status] = 22
		AND ISNULL(CDCD.RecordDeleted, 'N') = 'N'
		AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
	ORDER BY Doc.EffectiveDate DESC
		,Doc.ModifiedDate DESC
	
	SELECT top 1 @PresentingProblem = PresentingProblem from CustomHRMAssessments where DocumentVersionId = @LatestAssessmentDocumentVersionID
	--END PresentingProblem	
	
	-- CountyResidence and CountyFinancialResponsibility --

	Select @CountyResidenceId = CountyResidence from CustomDocumentDischarges where  DocumentVersionId = @DocumentVersionId
	Select @CountyResponseId = CountyFinancialResponsibility from CustomDocumentDischarges where  DocumentVersionId = @DocumentVersionId
	
	IF @CountyResidenceId != ''
	BEGIN
	select @CountyResidence = CountyName from Counties where CountyFIPS = @CountyResidenceId
	END
	ELSE
	BEGIN
	SET @CountyResidence = ''
	END
	PRINT @CountyResidence
	
	IF @CountyResponseId != ''
	BEGIN
	select @CountyResponse = CountyName from Counties where CountyFIPS = @CountyResponseId
	END
	ELSE
	BEGIN
	SET @CountyResponse = ''
	END
	
	select @CountyResponse = CountyName from Counties where CountyFIPS = @CountyResponseId
	
	--	END CountyResidence		
	
	---Address
	
	SELECT  @AddressDetails = CA.[Address] + '' + CA.City + '' + CA.[State] + '' + CA.Zip  FROM ClientAddresses CA LEFT JOIN GlobalCodes GC ON CA.AddressType = GC.GlobalCodeId WHERE ClientId =  @ClientId
	
	AND ISNULL(CA.RecordDeleted, 'N') = 'N'
	
	
	--Discharge
	
	
	DECLARE @Discharge Char(2) = ''
	DECLARE @Count INT
	select @Count = Count(*) from CustomDischargePrograms where DocumentVersionId = @DocumentVersionId and recorddeleted = 'N'
	IF ( @Count >= 1)
	BEGIN
	SET @Discharge = 'D'
	END
	
	
	
		SELECT DocumentVersionId,
		CreatedBy,
		CreatedDate,
		ModifiedBy,
		ModifiedDate,
		RecordDeleted,
		DeletedBy,
		DeletedDate,
		@ClientId as ClientId,
		NewPrimaryClientProgramId,
		DischargeType,
		dbo.csf_GetGlobalCodeNameById([TransitionDischarge])as TransitionDischarge,
		DischargeDetails,
		OverallProgress, 
		StatusLastContact,
		dbo.csf_GetGlobalCodeNameById([EducationLevel])as  EducationLevel,
		dbo.csf_GetGlobalCodeNameById([MaritalStatus])as MaritalStatus,
		dbo.csf_GetGlobalCodeNameById([EducationStatus])as EducationStatus,
		dbo.csf_GetGlobalCodeNameById([EmploymentStatus])as EmploymentStatus,
		dbo.csf_GetGlobalCodeNameById([ForensicCourtOrdered])as ForensicCourtOrdered, 
		dbo.csf_GetGlobalCodeNameById([CurrentlyServingMilitary])as CurrentlyServingMilitary,
		dbo.csf_GetGlobalCodeNameById([Legal])as Legal,
		dbo.csf_GetGlobalCodeNameById([JusticeSystem])as JusticeSystem,
		dbo.csf_GetGlobalCodeNameById([LivingArrangement])as LivingArrangement, 
		Arrests,
		dbo.csf_GetGlobalCodeNameById([AdvanceDirective])as AdvanceDirective,
		dbo.csf_GetGlobalCodeNameById([TobaccoUse])as TobaccoUse,
		AgeOfFirstTobaccoUse,
		@CountyResidence as CountyResidence,
		@CountyResponse as CountyFinancialResponsibility,
		@AddressDetails as AddressDetails,
		NoReferral, 
		SymptomsReoccur, 
		ReferredTo, 
		Reason,
		DatesTimes,
		dbo.csf_GetGlobalCodeNameById([ReferralDischarge])as ReferralDischarge,
		dbo.csf_GetGlobalCodeNameById([Treatmentcompletion])as Treatmentcompletion,
		@OrganizationName AS OrganizationName,	
		@DocumentName AS DocumentName,
		ISNULL(@SummaryOfServiceProvided, 'No services have been providedd') AS 'SummaryOfServicesProvided'
		,ISNULL(@PresentingProblem, 'No formal assessment') AS 'PresentingProblems'
		,CoOccurringHealthProblem
		,dbo.csf_GetGlobalCodeNameById([ClientType])as ClientType 
		,HealthInsurance
		,VocationalRehab
		,dbo.csf_GetGlobalCodeNameById([SchoolAttendance])as SchoolAttendance 
		,StableHousing
		,NumberOfMonthsEmployed
		,NumberOfEmployers
		,ArrestsInLast12Months
		,IncarceratedInLast12Months
		,GrossAnnualHouseholdIncome
		,@ClientName as ClientName
		,(Select CONVERT (DATE,d.EffectiveDate,101) from Documents D where CurrentDocumentVersionId= @DocumentVersionId) as EffectiveDate
		,(Select CONVERT (DATE,C.DOB,101) from Clients C where ClientId=@ClientId) as DOB
		FROM CustomDocumentDischarges Where DocumentVersionId = @DocumentVersionId AND ISNULL (RecordDeleted,'N') = 'N'
		
		
		
		SELECT
		CR.DischargeReferralId,
		CR.CreatedBy,
		CR.CreatedDate,
		CR.ModifiedBy,
		CR.ModifiedDate,
		CR.RecordDeleted,
		CR.DeletedBy,
		CR.DeletedDate,
		CR.DocumentVersionId,
		CR.Referral,
		CR.Program,
		GC.CodeName as ReferralText,
		GSC.SubCodeName as ProgramText
	FROM CustomDischargeReferrals CR 
	  left join GlobalCodes GC 
	  ON CR.Referral = GC.GlobalCodeId  left join GlobalSubCodes GSC ON CR.Program = GSC.GlobalSubCodeId
	WHERE CR.DocumentVersionId = @DocumentVersionId
		
		
		
		
  
	END TRY	                                             
   
 BEGIN CATCH  
  DECLARE @Error varchar(8000)                             
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                           
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLCustomDocumentDischarges')                                                           
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                            
   + '*****' + Convert(varchar,ERROR_STATE())                                                          
  RAISERROR                                                           
  (                                                          
   @Error, -- Message text.                                                          
   16, -- Severity.                                                          
   1 -- State.                                                          
  )           
 END CATCH                                                
End  
GO


