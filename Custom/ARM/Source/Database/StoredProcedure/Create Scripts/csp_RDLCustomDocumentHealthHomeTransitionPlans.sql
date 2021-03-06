/****** Object:  StoredProcedure [dbo].[csp_RDLCustomDocumentHealthHomeTransitionPlans]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentHealthHomeTransitionPlans]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentHealthHomeTransitionPlans]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentHealthHomeTransitionPlans]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE   [dbo].[csp_RDLCustomDocumentHealthHomeTransitionPlans]         
(                               
@DocumentVersionId  int           
)                      
AS                      
                
Begin                
-- =============================================
-- Author:		Veena S Mani
-- Create date: 22/02/2013
-- Description:	To get data for csp_RDLCustomDocumentHealthHomeTransitionPlans.
-- ============================================= 

                    
   
	SELECT CDHHCP.DocumentVersionId,  
		CDHHCP.CreatedBy,  
		CDHHCP.CreatedDate,  
		CDHHCP.ModifiedBy,  
		CDHHCP.ModifiedDate,  
		CDHHCP.RecordDeleted,  
		CDHHCP.DeletedBy,  
		CDHHCP.DeletedDate,  
		(select staff.LastName + '', '' +staff.FirstName  from staff where staffid=ClinicianCoordinatingDischarge) as ClinicianCoordinatingDischarge,
		TransitionFromNA,
		TransitionFromReason,
		(select codename from globalcodes where globalcodeid=TransitionFromEntityType) as TransitionFromEntityType,
		TransitionFromEntityTypeComment,
		TransitionToNA,
		TransitionToReason,
		(select codename from globalcodes where globalcodeid=TransitionToEntityType) as TransitionToEntityType,
		TransitionToEntityTypeComment,
		ResidenceFollowingDischarge,
		ResidenceFollowingDischargeNA,
		ResidencePermanent,
		ResidencePlanForLongTerm,
		CONVERT(VARCHAR(10), NextScheduledHHServiceDate, 101) as NextScheduledHHServiceDate,
		CONVERT(VARCHAR(10), NextScheduledMHServiceDate, 101)  as NextScheduledMHServiceDate,
		NextScheduledMHServiceType,
		NextScheduledMHServiceTypeNA,
		CONVERT(VARCHAR(10), NextScheduledPCPVisitDate, 101)  as NextScheduledPCPVisitDate,
		HasRerralsToAdditionalProvider,
		RequiresAuthsForAdditionalProvider,
		PreventionPlan,
		CONVERT(VARCHAR(10), MedReconciliationCompletionDate, 101)  as MedReconciliationCompletionDate,
		MedReconciliationCompletionNA,
		ClientHasDemonstratedUnderstanding,
		CoordinationOfRecordsComplete,
		AdditionalComment,
		Clients.FirstName + '' '' + Clients.LastName AS ClientName,  
		Clients.ClientId  
 FROM CustomDocumentHealthHomeTransitionPlans CDHHCP INNER JOIN
                      DocumentVersions AS DV ON CDHHCP.DocumentVersionId = DV.DocumentVersionId  AND (CDHHCP.DocumentVersionId = @DocumentVersionId) 
                INNER JOIN  
                      Documents ON DV.DocumentId = Documents.DocumentId AND DV.DocumentVersionId = Documents.CurrentDocumentVersionId 
                        INNER JOIN  
                      Clients ON Documents.ClientId = Clients.ClientId 
                     
	  WHERE     (ISNULL(CDHHCP.RecordDeleted, ''N'') = ''N'') AND (CDHHCP.DocumentVersionId = @DocumentVersionId)       
               
If (@@error!=0)                                                          
 Begin                                                          
  RAISERROR  20006   ''[csp_RDLCustomDocumentHealthHomeTransitionPlans] : An Error Occured''                                                           
  Return                                                          
 End                                                                   
End
' 
END
GO
