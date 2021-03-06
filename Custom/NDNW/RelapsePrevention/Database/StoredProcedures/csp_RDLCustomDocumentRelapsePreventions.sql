IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentRelapsePreventions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentRelapsePreventions]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[csp_RDLCustomDocumentRelapsePreventions]                                          
(                                                            
 @DocumentVersionId as int                                                            
)                                            
AS          
                                                       
                                                          
/*********************************************************************                        
-- Stored Procedure: dbo.[csp_RDLCustomDocumentRelapsePreventions]                                                           
                          
-- Creation Date:    04/JUNE/2015                
--                         
-- Purpose:  Return Tables for RelapsePreventions and fill the type Dataset                        
--                        
-- Create:                        
--   Date       Author    Purpose                        
--  04/JUNE/2015  Anto   To fetch RelapsePreventions               
--        
*********************************************************************/     
BEGIN                                                      
  BEGIN TRY  
	    DECLARE @OrganizationName VARCHAR(250)		
		DECLARE @ClientID INT
		DECLARE @ClientName VARCHAR(100)
		DECLARE @EffectiveDate VARCHAR(10)
		DECLARE @DOB VARCHAR(10)
		DECLARE @DocumentName  VARCHAR(100)
		
	
		
	select @ClientId = ClientId from documents where InProgressDocumentVersionId = @DocumentVersionId		
	SELECT TOP 1 @OrganizationName = OrganizationName FROM SystemConfigurations
	
	SELECT @ClientName = C.LastName + ', ' + C.FirstName						
			,@EffectiveDate = CASE 
				WHEN Documents.EffectiveDate IS NOT NULL
					THEN CONVERT(VARCHAR(10), Documents.EffectiveDate, 101)
				ELSE ''
				END
			,@DOB = CASE 
				WHEN C.DOB IS NOT NULL
					THEN CONVERT(VARCHAR(10), C.DOB, 101)
				ELSE ''
				END			
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

	SELECT   PlanName,
			 PlanPeriod,
			 dbo.csf_GetGlobalCodeNameById(PlanStatus) as PlanStatus,
			 dbo.csf_GetGlobalCodeNameById(HighRiskSituations) as HighRiskSituations,
			 dbo.csf_GetGlobalCodeNameById(RecoveryActivities) as RecoveryActivities,
			 CONVERT(VARCHAR(10), PlanStartDate, 101) as PlanStartDate,		
			 CONVERT(VARCHAR(10), PlanEndDate, 101) as PlanEndDate,				
			 CONVERT(VARCHAR(10), NextReviewDate, 101) as NextReviewDate,							
			 ClientParticipated,
			 @OrganizationName AS OrganizationName,	
		     @DocumentName AS DocumentName,		
		     @ClientName as ClientName,
			 @EffectiveDate as EffectiveDate,
			 @DOB as DOB,
			 @ClientId as ClientId
		FROM [CustomDocumentRelapsePreventionPlans] CDRP	
		Where DocumentVersionId = @DocumentVersionId AND ISNULL (RecordDeleted,'N') = 'N'
		
									
				  
	END TRY	                                             
   
 BEGIN CATCH  
  DECLARE @Error varchar(8000)                             
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                           
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_RDLCustomDocumentRelapsePreventions')                                                           
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