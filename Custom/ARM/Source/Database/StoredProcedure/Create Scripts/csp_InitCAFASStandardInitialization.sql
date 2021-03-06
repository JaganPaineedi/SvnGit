/****** Object:  StoredProcedure [dbo].[csp_InitCAFASStandardInitialization]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCAFASStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCAFASStandardInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCAFASStandardInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitCAFASStandardInitialization] 
(                            
@ClientID int                            
)                                                    
As                                                      
                        
                                                             
 Begin                                                              
 /*********************************************************************/                                                                
 /* Stored Procedure: [csp_InitCAFASStandardInitialization]               */                                                       
                                                       
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
 /*       Sept 11,2009       Pradeep               Added documentVerssionId in select statement for CustomCAFAS table*/    
 /*       Sept11,2009       Pradeep                Made changes as paer dataModel SCWebVenture3.0  */                                                                                                                                                          
  
                                 
 /*********************************************************************/                                                                 
      
                         
                        
Declare @primaryClinicianId as int              
select  @primaryClinicianId=primaryClinicianId  from Clients where ClientID=@ClientID                
                    
                                                                                
if(exists(Select * from CustomCAFAS C,Documents D,DocumentVersions DV                            
    where C.DocumentVersionId=DV.DocumentVersionId and D.DocumentId = DV.DocumentId      
     and D.ClientId=@ClientID                                      
and D.Status=22 and IsNull(C.RecordDeleted,''N'')=''N'' and IsNull(D.RecordDeleted,''N'')=''N'' ))                               
BEGIN                     
Select TOP 1 ''CustomCAFAS'' AS TableName,C.DocumentVersionId as DocumentVersionId,                  
CAFASDate,RaterClinician,CAFASInterval,SchoolPerformance,HomePerformance,CommunityPerformance,BehaviourTowardsOther,  MoodsEmotion,SelfHarmfulBehavoiur,SubstanceUse,Thinkng,PrimaryFamilyMaterialNeeds,PrimaryFamilySocialSupport              
 ,NonCustodialMaterialNeeds,NonCustodialSocialSupport,SurrogateMaterialNeeds,SurrogateSocialSupport,                         
C.CreatedBy,C.CreatedDate,C.ModifiedBy,C.ModifiedDate                    
from CustomCAFAS C,Documents D,DocumentVersions DV                                
where C.DocumentVersionId=DV.DocumentVersionId and DV.DocumentId=D.DocumentId       
 and D.ClientId=@ClientID      
 and D.Status=22  and IsNull(C.RecordDeleted,''N'')=''N'' and IsNull(D.RecordDeleted,''N'')=''N''                                   
order by D.EffectiveDate Desc,D.ModifiedDate Desc                                
END                                
else                                
BEGIN                                
Select TOP 1 ''CustomCAFAS'' AS TableName,-1 as ''DocumentVersionId'',                      
--Custom data                
getdate() as   CAFASDate,              
@primaryClinicianId as RaterClinician,              
0 as SchoolPerformance,              
0 as HomePerformance,              
0 as CommunityPerformance,              
0 as BehaviourTowardsOther,              
0 as MoodsEmotion,              
0 as SelfHarmfulBehavoiur,              
0 as SubstanceUse,              
0 as Thinkng,              
0 as PrimaryFamilyMaterialNeeds,              
0 as PrimaryFamilySocialSupport,              
0 as NonCustodialMaterialNeeds,              
0 as NonCustodialSocialSupport,              
0 as SurrogateMaterialNeeds,              
0 as SurrogateSocialSupport,              
--Custom Data                
                             
'''' as CreatedBy,                  
getdate() as CreatedDate,                  
'''' as ModifiedBy,                  
getdate() as ModifiedDate                    
from systemconfigurations s left outer join CustomCAFAS
on s.Databaseversion = -1
                               
                      
END                              
                                
                                 
                                    
 END                      
                    
                    
--Checking For Errors                         
                        
If (@@error!=0)                         
                        
Begin                         
                        
RAISERROR 20006 ''csp_InitCAFASStandardInitialization : An Error Occured''                         
                        
Return                         
                        
End
' 
END
GO
