/****** Object:  StoredProcedure [dbo].[csp_InitBasis32StandardInitialization]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitBasis32StandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitBasis32StandardInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitBasis32StandardInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitBasis32StandardInitialization]        
(                      
@ClientID int                      
)                                              
As                                                
                  
                                                       
 Begin                                                        
 /*********************************************************************/                                                          
 /* Stored Procedure: [csp_InitBasis32StandardInitialization]               */                                                 
                                                 
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
                        
                   
                  
              
              
              
                                                                          
if(exists(Select * from CustomBasis32 C,Documents D ,
	DocumentVersions V                           
    where C.DocumentVersionId=V.DocumentVersionId and D.DocumentId = V.DocumentId and D.ClientId=@ClientID                              
and D.Status=22 and IsNull(C.RecordDeleted,''N'')=''N'' and IsNull(D.RecordDeleted,''N'')=''N'' ))                          
BEGIN               
        
                
Select TOP 1 ''CustomBasis32'' AS TableName,                
C.DocumentVersionId,        
               
Basis32Interval,RelationToSelfOthers,DepressionAnxiety,DailyLivingFunctioning,ImpulsiveBehavior,Psychosis,TotalScore,                        
C.CreatedBy,C.CreatedDate,C.ModifiedBy,C.ModifiedDate              
from CustomBasis32 C,Documents D,
	DocumentVersions V        
where C.DocumentVersionId=V.DocumentVersionId and V.DocumentId=D.DocumentId and D.ClientId=@ClientID                              
and D.Status=22 and IsNull(C.RecordDeleted,''N'')=''N'' and IsNull(D.RecordDeleted,''N'')=''N''                            
order by D.EffectiveDate Desc,D.ModifiedDate Desc                          
END                          
else                          
BEGIN                          
Select TOP 1 ''CustomBasis32'' AS TableName, -1 as ''DocumentVersionId'',                
     
           
--Custom data          
          
--Custom Data          
                       
'''' as CreatedBy,            
getdate() as CreatedDate,            
'''' as ModifiedBy,            
getdate() as ModifiedDate              
from systemconfigurations s left outer join CustomBasis32
on s.Databaseversion = -1
                         
                
END                        
                          
                           
                              
 END                
              
              
--Checking For Errors                   
                  
If (@@error!=0)                   
                  
Begin                   
                  
RAISERROR 20006 ''csp_InitBasis32StandardInitialization : An Error Occured''                   
                  
Return                   
                  
End
' 
END
GO
