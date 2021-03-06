/****** Object:  StoredProcedure [dbo].[csp_InitCustomDCH3803StandardInitialization]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDCH3803StandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomDCH3803StandardInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDCH3803StandardInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitCustomDCH3803StandardInitialization]                                                         
(                                      
 @ClientID int,      
 @StaffID int,    
 @CustomParameters xml                                      
)                                                              
As                                                                
 /*********************************************************************/                                                                          
 /* Stored Procedure: [csp_InitCustomDCH3803StandardInitialization]               */                                                                 
                                                                 
 /* Copyright: 2007 Streamline SmartCare*/                                                                          
                                                                 
 /* Creation Date:  8/September/2007                                    */                                                                          
 /*                                                                   */                                                                          
 /* Purpose: Gets Fields of DCH3803 last signed Document Corresponding to clientd */                                                                         
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
                                                                 
 /*       Date              Author                  Purpose                                    */                                                                          
 /*       08/Sep/2007       Sonia Dhamija     To Retrieve Data      */         
 /*       18/Nov/2009       Ankesh Bharti     Modify according to DataModel 3.0*/ 
 /*       15/Jul/2010       Mahesh S          Modification for set only those fields which are required on initili and avoaid blank / white space values*/
 /*       25/Aug/2010                         Modification to solved the Task# 477 at Venture  */
 /*********************************************************************/  
         
Begin                                              
    
Begin try         
if exists(Select 1 from CustomDCH3803 c
			Join DocumentVersions dv on dv.DocumentVErsionId=c.DocumentVersionId and ISNULL(dv.RecordDeleted,''N'')=''N''  
			Join Documents d on d.DocumentId=dv.DocumentId and ISNULL(d.RecordDeleted,''N'')=''N''                                    
			where d.ClientId=@ClientID                                                
			and D.Status=22 and IsNull(C.RecordDeleted,''N'')=''N'' 
			)                      
BEGIN                        
	SELECT     TOP (1) ''CustomDCH3803'' AS TableName, C.DocumentVersionId, C.InitialOrReview, C.MoveInDate, C.FIACaseNumber, C.MedicaidRecipientId, C.CurrentDiagnosis, 
						  C.GuardianshipType, C.CountyOfResidence, C.FacilityName, C.FacilityPhone, C.FacilityAddress, C.FacilityCity, C.FacilityState, C.FacilityZip, 
						  C.FacilityMedicaidProviderId, C.CurrentGAF, C.EndDateReason, C.GuardianName, C.GuardianPhone, C.GuardianAddress, C.GuardianCity, C.GuardianState, 
						  C.GuardianZip, C.TreatmentType, C.DesignationMI, C.DesignationDD, C.DesignationAISMR, C.FacilityType, C.ChildLicenseType, C.AdultLicenseType, 
						  C.PersonalCareLevelEating, C.PersonalCareLevelToileting, C.PersonalCareLevelBathing, C.PersonalCareLevelGrooming, C.PersonalCareLevelDressing, 
						  C.PersonalCareLevelTransferring, C.PersonalCareLevelAmbulation, C.PersonalCareLevelTakingMedication, C.CreatedBy, C.CreatedDate, C.ModifiedBy, 
						  C.ModifiedDate
	FROM         CustomDCH3803 AS C INNER JOIN
						  DocumentVersions AS V ON C.DocumentVersionId = V.DocumentVersionId INNER JOIN
						  Documents AS D ON V.DocumentId = D.DocumentId
	WHERE     (D.ClientId = @ClientID) AND (D.Status = 22) AND (ISNULL(C.RecordDeleted, ''N'') = ''N'') AND (ISNULL(D.RecordDeleted, ''N'') = ''N'')
	ORDER BY D.EffectiveDate DESC, D.ModifiedDate DESC ,V.DocumentVersionId DESC                     
END                        
else                        
BEGIN                        
Select TOP 1 

''CustomDCH3803'' AS TableName,
 -1 as ''DocumentVersionId'',    
  -- Modification for set only those fields which are required on initili and avoaid blank / white space values          
/*''I'' as InitialOrReview,  
''Y'' AS DesignationMI,                        
''Y'' AS DesignationDD,                        
''Y'' AS DesignationAISMR,   
''3'' AS FacilityType,
''H'' AS ChildLicenseType,                        
''C'' AS AdultLicenseType, */
0 AS CurrentGAF,    
/*''C'' AS TreatmentType,   
''N'' AS PersonalCareLevelEating,                        
''N'' AS PersonalCareLevelToileting,                            
''N'' AS PersonalCareLevelBathing,                        
''N'' AS PersonalCareLevelGrooming,                        
''N'' AS PersonalCareLevelDressing,                        
''N'' AS PersonalCareLevelTransferring,                            
''N'' AS PersonalCareLevelAmbulation,                        
''N'' AS PersonalCareLevelTakingMedication,      */                 
/*getdate() AS  MoveInDate,                        
'''' as FIACaseNumber,                        
'''' as MedicaidRecipientId,                        
'''' as CurrentDiagnosis,                        
0 as GuardianshipType,                            
''0'' as CountyOfResidence,                        
'''' as FacilityName,                        
'''' as FacilityPhone,                        
'''' as FacilityAddress,                        
'''' as FacilityCity,                        
'''' as FacilityState,                        
'''' as FacilityZip,                            
'''' as FacilityMedicaidProviderId,                        
0 AS CurrentGAF,                        
''Trial'' AS EndDateReason,                        
'''' AS GuardianName,                        
'''' AS GuardianPhone,                        
'''' AS GuardianAddress,                            
'''' AS GuardianCity,                        
'''' AS GuardianState,                        
'''' AS GuardianZip,                        
''C'' AS TreatmentType,                        
''Y'' AS DesignationMI,                        
''Y'' AS DesignationDD,                        
''Y'' AS DesignationAISMR,                            
''3'' AS FacilityType,                        
''H'' AS ChildLicenseType,                        
''C'' AS AdultLicenseType,                        
''N'' AS PersonalCareLevelEating,                        
''N'' AS PersonalCareLevelToileting,                            
''N'' AS PersonalCareLevelBathing,                        
''N'' AS PersonalCareLevelGrooming,                        
''N'' AS PersonalCareLevelDressing,                        
''N'' AS PersonalCareLevelTransferring,                            
''N'' AS PersonalCareLevelAmbulation,                        
''N'' AS PersonalCareLevelTakingMedication,   
*/         
'''' as CreatedBy,            
getdate() as CreatedDate,            
'''' as ModifiedBy,            
getdate() ModifiedDate                
from systemconfigurations s left outer join CustomDCH3803                          
on s.Databaseversion = -1   
END
end try                                              
                                                                                       
BEGIN CATCH  
DECLARE @Error varchar(8000)                                               
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                             
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomDCH3803StandardInitialization'')                                                                             
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
