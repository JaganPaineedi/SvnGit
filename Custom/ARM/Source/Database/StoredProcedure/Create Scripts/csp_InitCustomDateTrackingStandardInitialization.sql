/****** Object:  StoredProcedure [dbo].[csp_InitCustomDateTrackingStandardInitialization]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDateTrackingStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomDateTrackingStandardInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDateTrackingStandardInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitCustomDateTrackingStandardInitialization]     
(                                
 @ClientID int,          
 @StaffID int,        
 @CustomParameters xml                                
)                                                        
As                          
                                                                 
 /*********************************************************************/                                                                    
 /* Stored Procedure: [csp_InitCustomDateTrackingStandardInitialization]               */                                                           
                                                           
 /* Copyright: 2006 Streamline SmartCare*/                                                                    
                                                           
 /* Creation Date:  14/Jan/2008                                    */                                                                    
 /*                                                                   */                                                                    
 /* Purpose: To Initialize */                                                                   
 /*                                                                   */                                                                  
 /* Input Parameters:  */                                                                  
 /*                                                                   */                                                                     
 /* Output Parameters:                                */                                                                    
 /*                                                                   */                                                                    
 /* Return:   */                                                                    
 /*                                                                   */                                                                    
 /* Called By:CustomDocuments Class Of DataService    */                                                          
 /*      */                                                          
                                                           
 /*                                                                   */                                                                    
 /* Calls:                                                            */                                                                    
 /*                                                                   */                                                                    
 /* Data Modifications:                                               */                                                                    
 /*                                                                   */                                                                    
 /*   Updates:                                                          */                                                                    
                                                       
 /*       Date              Author                  Purpose             */                                                                    
 /*       14/Sep/2009       Ankesh Bharti          To Retrieve Data     */     
 /*       Nov18,2009         Ankesh                Made changes as paer dataModel SCWebVenture3.0  */                                                                                                                                                          
  
    
 /*********************************************************************/                                                                     
                                  
  
Begin                                                  
        
Begin try                                                             
if(exists(Select * from CustomDateTracking C,Documents D ,        
 DocumentVersions V                         
    where C.DocumentVersionId=V.DocumentVersionId and D.DocumentId = V.DocumentId        
     and D.ClientId=@ClientID                                  
and D.Status=22 and IsNull(C.RecordDeleted,''N'')=''N'' and IsNull(D.RecordDeleted,''N'')=''N'' ))                                    
BEGIN                     
	SELECT     TOP (1) ''CustomDateTracking'' AS TableName, C.DocumentVersionId, C.DocumentationHealthHistoryDate, C.DocumentationAnnualCustomerInformation, 
						  C.DocumentationNext3803DueOn, C.DocumentationPrivacyNoticeGivenOn, C.DocumentationPcpLetter, C.DocumentationPcpRelease, C.DocumentationBasis32, 
						  C.MedicationConsentMedication1, C.MedicationConsentMedicationDate1, C.MedicationConsentMedication2, C.MedicationConsentMedicationDate2, 
						  C.MedicationConsentMedication3, C.MedicationConsentMedicationDate3, C.MedicationConsentMedication4, C.MedicationConsentMedicationDate4, 
						  C.MedicationConsentMedication5, C.MedicationConsentMedicationDate5, C.MedicationConsentMedication6, C.MedicationConsentMedicationDate6, 
						  C.MedicationConsentMedication7, C.MedicationConsentMedicationDate7, C.MedicationConsentMedication8, C.MedicationConsentMedicationDate8, 
						  C.CustomerSatisfactionSurvey, C.CreatedBy, C.CreatedDate, C.ModifiedBy, C.ModifiedDate
	FROM         CustomDateTracking AS C INNER JOIN
						  DocumentVersions AS V ON C.DocumentVersionId = V.DocumentVersionId INNER JOIN
						  Documents AS D ON V.DocumentId = D.DocumentId
	WHERE     (D.ClientId = @ClientID) AND (D.Status = 22) AND (ISNULL(C.RecordDeleted, ''N'') = ''N'') AND (ISNULL(D.RecordDeleted, ''N'') = ''N'')
	ORDER BY D.EffectiveDate DESC, D.ModifiedDate DESC,V.DocumentVersionId DESC
END                                    
else                                    
BEGIN                                    
Select TOP 1 ''CustomDateTracking'' AS TableName, -1 as ''DocumentVersionId''                       
--Custom data                    
--,'''' AS DocumentationHealthHistoryDate        
--,GETDATE() AS DocumentationAnnualCustomerInformation        
--,GETDATE() AS DocumentationNext3803DueOn        
--,GETDATE() AS DocumentationPrivacyNoticeGivenOn        
--,GETDATE()  AS DocumentationPcpLetter        
--,GETDATE()  AS DocumentationPcpRelease        
--,GETDATE()  AS DocumentationBasis32        
--,'''' AS MedicationConsentMedication1        
--,GETDATE()  AS MedicationConsentMedicationDate1        
--,'''' AS MedicationConsentMedication2        
--,GETDATE()  AS MedicationConsentMedicationDate2        
--,'''' AS MedicationConsentMedication3        
--,GETDATE()  AS MedicationConsentMedicationDate3        
--,'''' AS MedicationConsentMedication4        
--,GETDATE()  AS MedicationConsentMedicationDate4        
--,'''' AS MedicationConsentMedication5        
--,GETDATE()  AS MedicationConsentMedicationDate5        
--,'''' AS MedicationConsentMedication6        
--,GETDATE()  AS MedicationConsentMedicationDate6        
--,'''' AS MedicationConsentMedication7        
--,GETDATE()  AS MedicationConsentMedicationDate7        
--,'''' AS MedicationConsentMedication8        
--,GETDATE()  AS MedicationConsentMedicationDate8        
,''Y'' AS CustomerSatisfactionSurvey,        
--Custom Data                    
                                 
'''' as CreatedBy,                      
getdate() as CreatedDate,                      
'''' as ModifiedBy,                      
getdate() as ModifiedDate                        
from systemconfigurations s left outer join CustomDateTracking        
on s.Databaseversion = -1     
END                                  
end try                                                  
                                      
BEGIN CATCH      
DECLARE @Error varchar(8000)                                                   
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomDateTrackingStandardInitialization'')                                                                                 
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                  
    + ''*****'' + Convert(varchar,ERROR_STATE())                              
 RAISERROR                                                                                 
 (                                                   
  @Error, -- Message text.                                                                                
  16, -- Severity.                                                                                
  1 -- State.                                                                                
 );                                                                              
END CATCH                             
END
' 
END
GO
