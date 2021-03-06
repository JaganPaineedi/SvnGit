IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentSUAdmissions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentSUAdmissions]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[csp_RDLCustomDocumentSUAdmissions]                                          
(                                                            
 @DocumentVersionId as int                                                            
)                                            
AS          
                                                       
                                                          
/*********************************************************************                        
-- Stored Procedure: dbo.[csp_RDLCustomDocumentSUAdmissions]                                                           
                          
-- Creation Date:    28.11.2014                       
--                         
-- Purpose:  Return Tables for CustomDocumentSUAdmissions and fill the type Dataset                        
--                        
-- Create:                        
--   Date       Author    Purpose                        
--  03.FEB.2015  SuryaBalan     To fetch CustomDocumentSUAdmissions  
--Copied from valley to New Directions Customization Task 4   
-- 25-March-2015 SuryaBalan Added New columns         
--        
*********************************************************************/     
BEGIN                                                      
  BEGIN TRY  

	DECLARE @ClientId INT
	DECLARE @SSN Varchar(20)
	DECLARE @TitleXXNo Varchar(50)
	DECLARE @SamhisId Varchar(50)
	DECLARE @OrganizationName VARCHAR(250)
	DECLARE @DocumentName  VARCHAR(100)

	select @ClientId = ClientId from documents where InProgressDocumentVersionId = @DocumentVersionId
	SELECT @SSN = SUBSTRING(SSN,1,4) from clients where ClientId = @ClientID
	
	SELECT @TitleXXNo = TitleXXNo,@SamhisId = SamhisId  from CustomClients where ClientId = @ClientID
	
	SELECT TOP 1 @OrganizationName = OrganizationName FROM SystemConfigurations
	
	SELECT @DocumentName = DocumentCodes.DocumentName 
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
	
			
		SELECT CS.DocumentVersionId,
		CS.CreatedBy,
		CS.CreatedDate,
		CS.ModifiedBy,
		CS.ModifiedDate,
		CS.RecordDeleted,
		CS.DeletedBy,
		CS.DeletedDate,
		CS.ProgramId,
		--,dbo.csf_GetGlobalCodeNameById([ProgramId])as ProgramName,
		P.ProgramName as ProgramName,
		@ClientId as ClientId,
		CS.AdmissionEntryDate, 
		CS.AssessmentDate,
		CS.AdmissionType,
		dbo.csf_GetGlobalCodeNameById(CS.AdmissionType)as AdmissionTypeName,
		CS.AdmissionProgramType,
		dbo.csf_GetGlobalCodeNameById(CS.AdmissionProgramType)as AdmissionProgramTypeName,
		CS.ReferralSource, 
		dbo.csf_GetGlobalCodeNameById(CS.ReferralSource)as ReferralSourceName,
		CS.SourceOfPayment, 
		dbo.csf_GetGlobalCodeNameById(CS.SourceOfPayment)as SourceOfPaymentName,
		CS.PregnantAdmission, 
		CS.PriorEpisode,
		dbo.csf_GetGlobalCodeNameById(CS.PriorEpisode)as PriorEpisodeName,    
		CS.SocialSupports, 
		dbo.csf_GetGlobalCodeNameById(CS.SocialSupports)as SocialSupportsName, 
		CS.VeteransStatus,
		dbo.csf_GetGlobalCodeNameById(CS.VeteransStatus)as VeteransStatusName,
		CS.AdmittedPopulation, 
		dbo.csf_GetGlobalCodeNameById(CS.AdmittedPopulation)as AdmittedPopulationName,
		CS.AdmittedASAM,
		dbo.csf_GetGlobalCodeNameById(CS.AdmittedASAM)as AdmittedASAMName,
		CS.ReferredASAM,
		dbo.csf_GetGlobalCodeNameById(CS.ReferredASAM)as ReferredASAMName,
		CS.StateCode,
		dbo.csf_GetGlobalCodeNameById(CS.StateCode)as StateCodeName,
		CS.NumberOfArrests, 
		CS.DrugCourtParticipation, 
		dbo.csf_GetGlobalCodeNameById(CS.DrugCourtParticipation)as DrugCourtParticipationName,
		--DoraStatus, 
		--dbo.csf_GetGlobalCodeNameById(DoraStatus)as DoraStatusName,
		CS.CurrentlyOnProbation,
		CS.Jurisdiction, 
		CS.CurrentlyOnParole,  
		CS.LivingArrangement,
		dbo.csf_GetGlobalCodeNameById(CS.LivingArrangement)as LivingArrangementName, 
		CS.Household, 
		CS.HouseholdIncome,
		CS.MaritalStatus,
		dbo.csf_GetGlobalCodeNameById(CS.MaritalStatus)as MaritalStatusName,
		CS.EmploymentStatus,   
		dbo.csf_GetGlobalCodeNameById(CS.EmploymentStatus)as EmploymentStatusName, 
		CS.PrimarySourceOfIncome,  
		dbo.csf_GetGlobalCodeNameById(CS.PrimarySourceOfIncome)as PrimarySourceOfIncomeName, 
		CS.EnrolledEducation,
		dbo.csf_GetGlobalCodeNameById(CS.EnrolledEducation)as EnrolledEducationName, 
		CS.Gender,
		dbo.csf_GetGlobalCodeNameById(CS.Gender)as GenderName,
		CS.Race,
		dbo.csf_GetGlobalCodeNameById(CS.Race)as RaceName,
		CS.Ethnicity,
		dbo.csf_GetGlobalCodeNameById(CS.Ethnicity)as EthnicityName,
		CoDependent, 
		--OpioidReplacementTherapy,  
		CS.TobaccoUse,  
		dbo.csf_GetGlobalCodeNameById(CS.TobaccoUse)as TobaccoUseName, 
		CS.AgeOfFirstTobaccoText,
		CS.AgeOfFirstTobacco,
		CS.PreferredUsage1,
		dbo.csf_GetGlobalCodeNameById(CS.PreferredUsage1)as PreferredUsage1Name, 
		DrugName1, 
		dbo.csf_GetGlobalCodeNameById(DrugName1)as DrugName1Name, 
		CS.Frequency1,
		dbo.csf_GetGlobalCodeNameById(CS.Frequency1)as Frequency1Name,   
		CS.Route1,
		dbo.csf_GetGlobalCodeNameById(CS.Route1)as Route1Name,  
		CS.AgeOfFirstUseText1,		
		CS.AgeOfFirstUse1,
		CS.PreferredUsage2,
		dbo.csf_GetGlobalCodeNameById(CS.PreferredUsage2)as PreferredUsage2Name,  
		CS.DrugName2,
		dbo.csf_GetGlobalCodeNameById(CS.DrugName2)as DrugName2Name,    
		Frequency2,
		dbo.csf_GetGlobalCodeNameById(CS.Frequency2)as Frequency2Name,      
		CS.Route2,  
		dbo.csf_GetGlobalCodeNameById(CS.Route2)as Route2Name,  
		CS.AgeOfFirstUseText2,
		CS.AgeOfFirstUse2,
		CS.PreferredUsage3,
		dbo.csf_GetGlobalCodeNameById(CS.PreferredUsage3)as PreferredUsage3Name,  
		CS.DrugName3,  
		dbo.csf_GetGlobalCodeNameById(CS.DrugName3)as DrugName3Name,  
		CS.Frequency3,  
		dbo.csf_GetGlobalCodeNameById(CS.Frequency3)as Frequency3Name,   
		Route3,
		dbo.csf_GetGlobalCodeNameById(CS.Route3)as Route3Name,    
		CS.AgeOfFirstUseText3,
		CS.AgeOfFirstUse3,
		@SSN as SSN,
		@TitleXXNo as TitleXXNo,
		@SamhisId as SamhisId,
		@OrganizationName AS OrganizationName,
		@DocumentName AS DocumentName,
		CS.NumberOfArrestsLast12Months,
		CS.EducationCompleted,		
		dbo.csf_GetGlobalCodeNameById(CS.EducationCompleted)as EducationCompletedName,
		CS.CoOccurringMentalHealth,
		CS.PharmocotherapyPlanned,
		CS.Severity1,
		CS.Severity2,
		CS.Severity3,
		dbo.csf_GetGlobalCodeNameById(CS.Severity1)as Severity1Name,  
		dbo.csf_GetGlobalCodeNameById(CS.Severity2)as Severity2Name,  
		dbo.csf_GetGlobalCodeNameById(CS.Severity3)as Severity3Name ,
		CS.GenderOther

		FROM CustomDocumentSUAdmissions CS
			LEFT JOIN Programs P ON P.ProgramId=CS.ProgramId  AND ISNULL (P.RecordDeleted,'N') = 'N'
		 Where CS.DocumentVersionId = @DocumentVersionId	
		 AND ISNULL (CS.RecordDeleted,'N') = 'N'		  
	END TRY	                                             
   
 BEGIN CATCH  
  DECLARE @Error varchar(8000)                             
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                           
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLCustomDocumentSUAdmissions')                                                           
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