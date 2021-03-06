/****** Object:  StoredProcedure [dbo].[csp_InitCustomAdvanceAdequateNoticesStandardInitialization]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomAdvanceAdequateNoticesStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomAdvanceAdequateNoticesStandardInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomAdvanceAdequateNoticesStandardInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitCustomAdvanceAdequateNoticesStandardInitialization]    
(                                  
 @ClientID int,              
 @StaffID int,            
 @CustomParameters xml                                        
)                                                                
As                                  
                                                                         
 /*********************************************************************/                                                                            
 /* Stored Procedure: [csp_InitCustomAdvanceAdequateNoticesStandardInitialization]               */                                                                   
                                                                   
 /* Copyright: 2006 Streamline SmartCare*/                                                                            
                                                                   
 /* Creation Date:  10/09/2009                                    */                                                                            
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
 /*       14/Jan/2008        Ankesh Bharati         To Retrieve Data      */                                                                            
 /*       16/Sep/2009        Ankesh Bharati         Modify According to Data Model 3.0     */              
 /*       Nov18,2009         Ankesh Made changes as paer dataModel SCWebVenture3.0  */                                           
 /*    July 17, 2010   Davinder Kumar     Modified query regarding Medicaid.*/    
 /*       Aug 25, 2010                             Modification to solved the Task# 372 at StreamlineTesting    
 
		1/09/2011		avoss		corrected mediciad plan logic
  */          
 /*********************************************************************/                                                                             
Begin                                                        
              
Begin try                                                                           
DECLARE @GuardianName AS VARCHAR(110)                
DECLARE @MedicaidCustomer AS CHAR(1)          
                
SET @GuardianName = (SELECT   DISTINCT TOP 1               
     case when ClientContacts.LastName IS NULL OR ClientContacts.LastName = ''''               
      AND ClientContacts.MiddleName IS NULL OR ClientContacts.MiddleName = ''''               
      AND ClientContacts.FirstName IS NULL OR ClientContacts.FirstName = ''''               
     THEN ''''               
     ELSE               
      ISNULL(ClientContacts.LastName, '''') + '', '' + ISNULL(ClientContacts.MiddleName, '''') + '' '' + ISNULL(ClientContacts.FirstName, '''')               
     END              
FROM ClientContactAddresses                   
RIGHT OUTER JOIN ClientContacts ON ClientContactAddresses.ClientContactId = ClientContacts.ClientContactId                   
   and (ClientContactAddresses.RecordDeleted is null or ClientContactAddresses.RecordDeleted =''N'')                   
   and isnull(clientcontacts.recorddeleted, ''N'') = ''N''                    
RIGHT OUTER JOIN Clients ON ClientContacts.ClientId = Clients.ClientId                   
   and clientcontacts.guardian=''Y''                   
   and (clientcontacts.Recorddeleted is null or clientcontacts.Recorddeleted =''N'')                   
   and isnull(clients.recorddeleted, ''N'') = ''N''                  
LEFT  OUTER JOIN ClientAddresses ON Clients.ClientId = ClientAddresses.ClientId                    
   and ( Clients.Recorddeleted is null  or Clients.Recorddeleted =''N'')                   
   and isnull(ClientAddresses.recorddeleted, ''N'') = ''N''                  
WHERE (Clients.ClientId = @ClientID))           
                
                          
                                     
SET @MedicaidCustomer = (SELECT DISTINCT TOP 1 ISNULL(CoveragePlans.MedicaidPlan,''N'')            
FROM ClientCoveragePlans  
INNER JOIN CoveragePlans   ON ClientCoveragePlans.CoveragePlanId = CoveragePlans.CoveragePlanId     
and ISNULL(ClientCoveragePlans.RecordDeleted, ''N'') =''N'' and ISNULL(CoveragePlans.RecordDeleted, ''N'') = ''N''     
Join ClientCoverageHistory CH on ch.ClientCoveragePlanId = ClientCoveragePlans.ClientCoveragePlanId and ISNULL(ch.RecordDeleted, ''N'') = ''N''      
join Clients on Clients.ClientId = ClientCoveragePlans.ClientId and ISNULL(Clients.RecordDeleted, ''N'') = ''N''    
WHERE (Clients.ClientId = @ClientID)    
and coveragePlans.MedicaidPlan = ''Y''  --av
and ch.StartDate <= convert(datetime, convert(varchar(12), getdate(), 101))      
and (ch.EndDate >= convert(datetime, convert(varchar(12), getdate(), 101))  or          
ch.EndDate is null))    

   
                                                                     
-- Note: All the Null fields/columns are not requried to add in the following select statement      
Select TOP 1 ''CustomAdvanceAdequateNotices'' AS TableName, -1 as ''DocumentVersionId''                
                
--Custom data    
--,NULL as DateOfNotice              
,IsNull(@MedicaidCustomer, ''N'') AS MedicaidCustomer              
,@GuardianName AS GuardianName              
--,NULL AS ActionRequestedServicesEffectiveDate              
--,NULL AS ActionCurrentServicesEffectiveDate                
--,NULL AS MedicalNecessityReasonAttendanceDate                
--,NULL AS NoticeProvidedDate   
--Custom Data                            
                                         
,'''' as CreatedBy,                              
getdate() as CreatedDate,              
'''' as ModifiedBy,                              
getdate() as ModifiedDate                                
from systemconfigurations s left outer join CustomAdvanceAdequateNotices                                                                                
on s.Databaseversion = -1           
         
end try                                                        
                                                                                                 
BEGIN CATCH      
DECLARE @Error varchar(8000)                                                         
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                       
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomAdvanceAdequateNoticesStandardInitialization'')                                                                                       
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
