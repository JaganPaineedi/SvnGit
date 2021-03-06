/****** Object:  StoredProcedure [dbo].[csp_InitCustomAFCStatusChangeStandardInitialization]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomAFCStatusChangeStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomAFCStatusChangeStandardInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomAFCStatusChangeStandardInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create PROCEDURE  [dbo].[csp_InitCustomAFCStatusChangeStandardInitialization]        
(                      
@ClientID int ,  
@StaffID int,        
 @CustomParameters xml                     
)                                              
As                                                
                  
                                                       
 Begin                                                        
 /*********************************************************************/                                                          
 /* Stored Procedure: [csp_InitCustomAFCStatusChangeStandardInitialization]               */                                                 
                                                 
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
 /*********************************************************************/                                                           
                        
                   
                  
              
                                                                          
if(exists(Select * from CustomAFCStatusChange C,Documents D                          
   -- before modify where C.DocumentId=D.DocumentId and D.ClientId=@ClientID                              
    where C.DocumentVersionId =D.CurrentDocumentVersionId and D.ClientId=@ClientID                              
and D.Status=22 and IsNull(C.RecordDeleted,''N'')=''N'' and IsNull(D.RecordDeleted,''N'')=''N''))                          
BEGIN               
        
        
                
Select TOP 1 ''CustomAFCStatusChange'' AS TableName,                
-- query berfore modify C.DocumentId as DocumentId,C.Version as Version,              
C.DocumentVersionId  as DocumentVersionId,--C.Version as Version,              
FormDate,ClientDeceased,DeceasedDate,ClientWasAdmitted,AdmittedHospital,AdmittedDate,ClientWasDischarged        
,DischargedHospital,DischargedPlacedIn,DischargedPlacedDate,ClientMovedOut,MovedOutHome,MovedOutDate,ClientMovedIn        
,MovedInHome,MovedInDate,TypeAContract,ContractApproved,ContractStopped,ContractDate,ClientWasArrested,ArrestedDate        
,ClientHasLOA,LOADate01,LOADate02,LOADate03,LOADate04,LOADate05,LOADate06,LOADate07,LOADate08,LOADate09,LOADate10        
,ClientCaseClosed,CaseClosedDate,AFCLicenseStatusChanged,LicenseStatusComment,AFCStatusOther,StatusOtherComment,             
C.CreatedBy,C.CreatedDate,C.ModifiedBy,C.ModifiedDate              
from CustomAFCStatusChange C,Documents D                              
where  
-- C.DocumentId=D.DocumentId and D.ClientId=@ClientID                              
 C.DocumentVersionId =D.CurrentDocumentVersionId  and D.ClientId=@ClientID                              
and D.Status=22   and IsNull(C.RecordDeleted,''N'')=''N'' and IsNull(D.RecordDeleted,''N'')=''N''                          
order by D.EffectiveDate Desc,D.ModifiedDate Desc                          
END                          
else                          
BEGIN                          
Select TOP 1 ''CustomAFCStatusChange'' AS TableName,              
-1 as   DocumentVersionId      ,  
           
--Custom data          
        
--Custom Data          
                       
'''' as CreatedBy,            
getdate() as CreatedDate,            
'''' as ModifiedBy,            
getdate() as ModifiedDate      
from systemconfigurations s left outer join CustomAFCStatusChange 
           
on s.Databaseversion = -1     
        
            
                         
                
END                        
                          
                           
                              
 END                
              
              
--Checking For Errors                   
                  
If (@@error!=0)                   
                  
Begin                   
                  
RAISERROR 20006 ''csp_InitCustomAFCStatusChangeStandardInitialization : An Error Occured''                   
                  
Return                   
                  
End
' 
END
GO
