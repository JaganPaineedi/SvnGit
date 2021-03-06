/****** Object:  StoredProcedure [dbo].[csp_InitCustomMedsOnlyTxPlanStandardInitialization]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomMedsOnlyTxPlanStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomMedsOnlyTxPlanStandardInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomMedsOnlyTxPlanStandardInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitCustomMedsOnlyTxPlanStandardInitialization]      
(                                    
 @ClientID int,      
 @StaffID int,    
 @CustomParameters xml                                    
)                                                            
As                                                                   
                                                                  
 /*********************************************************************/                                                                        
 /* Stored Procedure: [csp_InitCustomMedsOnlyTxPlanStandardInitialization]               */                                                               
                                                               
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
                                                               
 /*       Date              Author                  Purpose                                    */                                                                        
 /*       14/Jan/2008        Rishu Chopra          To Retrieve Data      */          
 /*       Sept11,2009        Pradeep                Made changes as per database  SCWebVenture3.0 */  
 /*       Nov18,2009         Ankesh                 Made changes as per database  SCWebVenture3.0 */  
 /*********************************************************************/                                   
                               
Begin                                              
    
Begin try                               
if exists(Select 1 from CustomMedsOnlyTxPlan c
			Join DocumentVersions dv on dv.DocumentVErsionId=c.DocumentVersionId and ISNULL(dv.RecordDeleted,''N'')=''N''  
			Join Documents d on d.DocumentId=dv.DocumentId and ISNULL(d.RecordDeleted,''N'')=''N''                                    
			where d.ClientId=@ClientID                                                
			and D.Status=22 and IsNull(C.RecordDeleted,''N'')=''N'' 
			)                                        
BEGIN                            
                      
                              
	SELECT     TOP (1) ''CustomMedsOnlyTxPlan'' AS TableName, C.DocumentVersionId, C.AreasOfConcernSymptoms, C.MyGoalsTreatment, C.ClientMethod, C.ClinicianMethod, 
						  C.OtherComments, C.ClientReceivedCopy, C.ClientRefusedCopy, C.AuthorizationRequestorComment, C.Assigned, C.CreatedBy, C.CreatedDate, C.ModifiedBy, 
						  C.ModifiedDate
	FROM         CustomMedsOnlyTxPlan AS C INNER JOIN
						  DocumentVersions AS DV ON C.DocumentVersionId = DV.DocumentVersionId INNER JOIN
						  Documents AS D ON DV.DocumentId = D.DocumentId
	WHERE     (D.ClientId = @ClientID) AND (D.Status = 22) AND (ISNULL(C.RecordDeleted, ''N'') = ''N'') AND (ISNULL(D.RecordDeleted, ''N'') = ''N'')
	ORDER BY D.EffectiveDate DESC, D.ModifiedDate DESC  ,DV.DocumentVersionId DESC                                    
END                                        
else                                        
BEGIN                                        
Select TOP 1 ''CustomMedsOnlyTxPlan'' AS TableName,-1 as ''DocumentVersionId'',                            
      
--Custom data                        
(''1. I will take my medication as prescribed.''+char(13)+Char(10)+''2. I will keep my appointments with the psychiatrist.''+char(13)+Char(10)+''3. I will notify my psychiatrist or nurse if I have problems or questions regarding my medication or side effects.       
''+char(13)+Char(10)+''4. I will notify my psychiatrist or nurse of other medications and natural remedies or over-the-counter drugs I take and what medical conditions my medical doctor is treating me for.''+char(13)+Char(10)+''5. I will notify my psychiatrist
or nurse if I am taking illegal drugs or using alcohol.''+char(13)+Char(10)) as ClientMethod,                        
(''1. Assure that the medication and treatment are appropriate to my needs.''+char(13)+Char(10)+''2. Meet with me up to six times per year to review my medication, and review this plan yearly. If I experience problems with my medication or an increase in 
symptoms, I may see the doctor every one or two months until stable.''+char(13)+Char(10)+''3. Provide information on the medication and/or my psychiatric condition if I request it.''+char(13)+Char(10)+''4. Provide the administration of medication as ordered,
every two weeks.''+char(13)+Char(10)+''5. Order medical testing as needed to monitor health.''+char(13)+Char(10)+''6. Provide Health Assessments and Health Services when problems arise for health and medication needs, one to twelve times per year, as needed.
''+char(13)+Char(10)+''7. Provide coordination of care with medical physicians and other agencies as needed.''+char(13)+Char(10)) as  ClinicianMethod,                       
--Custom Data                        
                                     
'''' as CreatedBy,                          
getdate() as CreatedDate,                          
'''' as ModifiedBy,                          
getdate() as ModifiedDate                            
from systemconfigurations s left outer join CustomMedsOnlyTxPlan                                                                    
on s.Databaseversion = -1  
END                                          
end try                                              
                                                                                       
BEGIN CATCH  
DECLARE @Error varchar(8000)                                               
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                             
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomMedsOnlyTxPlanStandardInitialization'')                                                                             
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
