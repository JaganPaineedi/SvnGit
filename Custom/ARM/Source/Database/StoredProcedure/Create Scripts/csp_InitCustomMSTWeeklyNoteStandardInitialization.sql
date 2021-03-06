/****** Object:  StoredProcedure [dbo].[csp_InitCustomMSTWeeklyNoteStandardInitialization]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomMSTWeeklyNoteStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomMSTWeeklyNoteStandardInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomMSTWeeklyNoteStandardInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitCustomMSTWeeklyNoteStandardInitialization]                                           
(                                      
 @ClientID int,    
 @StaffID int,  
 @CustomParameters xml                                      
)                                           
As                                              
                                                      
 /*********************************************************************/                                                        
 /* Stored Procedure: [csp_InitCustomMSTWeeklyNoteStandardInitialization]               */                                               
                                               
 /* Copyright: 2006 Streamline SmartCare*/                                                        
                                               
 /* Creation Date:  20/Aug/2007                                    */                                                        
 /*                                                                   */                                                        
 /* Purpose: Gets ChildsAge, */                                                       
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
 /*       20/Aug/2007        Sonia Dhamija          To Retrieve Data      */
 /*       Nov18,2009         Ankesh                Made changes as paer dataModel venture3.0   */  
 /*********************************************************************/                                                         
                      
Begin                                              
    
Begin try                                
if exists(Select 1 from CustomMSTWeeklyNote C
			Join DocumentVersions dv on dv.DocumentVErsionId=c.DocumentVersionId and ISNULL(dv.RecordDeleted,''N'')=''N''  
			Join Documents d on d.DocumentId=dv.DocumentId and ISNULL(d.RecordDeleted,''N'')=''N''                                    
			where d.ClientId=@ClientID                                                
			and D.Status=22 and IsNull(C.RecordDeleted,''N'')=''N'' 
			)                                         
	BEGIN                                          
		Select TOP 1 ''CustomMSTWeeklyNote'' AS TableName,C.DocumentVersionId as DocumentVersionId                            
			  ,[ChildsAge]    
			  ,[IntakeDate]    
			  ,[FaceToFaceContacts]    
			  ,[PhoneContacts]    
			  ,[FaceToFaceCollateralContacts]    
			  ,[PhoneCollateralContacts]    
			  ,[SessionsCancelledOrMissed]    
			  ,[OverarchingGoals]    
			  ,[PreviousIntermediateSteps]    
			  ,[BarriersPreviousIntermediateSteps]    
			  ,[AdvancesInTreatment]    
			  ,[HowAssessmentChangedExpanded]    
			  ,[NewIntermediateSteps]    
			  ,[BarriersNewIntermediateSteps]    
			  ,[QuestionsSupervisionConsultation]    
			  ,[SupervisionFeedback]    
			  ,[ConsultationFeedback]    
			  ,C.[CreatedBy]    
			  ,C.[CreatedDate]    
			  ,C.[ModifiedBy]    
			  ,C.[ModifiedDate]    
			  ,C.[RecordDeleted]    
			  ,C.[DeletedDate]    
			  ,C.[DeletedBy]                              
		from CustomMSTWeeklyNote C
		Join DocumentVersions dv on dv.DocumentVErsionId=c.DocumentVersionId and ISNULL(dv.RecordDeleted,''N'')=''N''  
		Join Documents d on d.DocumentId=dv.DocumentId and ISNULL(d.RecordDeleted,''N'')=''N''                                    
		where d.ClientId=@ClientID                                                
		and D.Status=22 and IsNull(C.RecordDeleted,''N'')=''N''                                             
		order by D.EffectiveDate Desc,D.ModifiedDate Desc   ,DV.DocumentVersionId DESC                                    
	END                                          

ELSE
                                          
	BEGIN        
		Select ''CustomMSTWeeklyNote'' AS TableName,-1 as ''DocumentVersionId''
		, Convert(Varchar(10),dbo.GetAge(c.DOB,getdate())) as ChildsAge
		, isnull((select max(s.DateOfService) from services as s 
			where s.ClientId = @ClientId and s.Status=75 
			and s.ProcedureCodeId = 70 and isnull(s.RecordDeleted,''N'')<>''Y'' ),GETDATE())
			as IntakeDate  
		, isnull((select count(s2.ServiceId)	from services as s2
			join procedureCodes as pc on pc.ProcedureCodeId = s2.ProcedureCodeId
				and isnull(pc.RecordDeleted,''N'')<>''Y''
				and isnull(pc.FaceToFace, ''N'') = ''Y''	
			where s2.ClientId = @ClientId and s2.Status=75
			and isnull(s2.RecordDeleted,''N'')<>''Y'' ),0)
			as FaceToFaceContacts
		, 0 as  FaceToFaceCollateralContacts
		, isnull((select count(s3.ServiceId)	from services as s3
			join procedureCodes as pc2 on pc2.ProcedureCodeId = s3.ProcedureCodeId
				and isnull(pc2.RecordDeleted,''N'')<>''Y''
				and pc2.ProcedureCodeId = 145	--phone contact
			where s3.ClientId = @ClientId and s3.Status=75
			and isnull(s3.RecordDeleted,''N'')<>''Y'' ),0)
			as  PhoneContacts
		, 0 as PhoneCollateralContacts
		, isnull((select count(s4.ServiceId)	from services as s4
			where s4.ClientId = @ClientId and s4.Status in (72,73)
			and isnull(s4.RecordDeleted,''N'')<>''Y'' ),0)
			as SessionsCancelledOrMissed 
		----Custom Data
		, '''' as CreatedBy                    
		, getdate() as CreatedDate                            
		, '''' as ModifiedBy                       
		, getdate() as ModifiedDate                              
		from Clients as c
		where clientId = @ClientId   
	                                  
		--Select TOP 1 ''CustomMSTWeeklyNote'' AS TableName,-1 as ''DocumentVersionId''                               
		----Custom data 
		--, ''10'' as ChildsAge                              
		----CONVERT(datetime,getdate(),101) as IntakeDate,                
		--, getdate() as IntakeDate                                
		--, 2 as FaceToFaceContacts                               
		--, 2 as  FaceToFaceCollateralContacts                              
		--, 2 as  PhoneContacts                
		--, 2 as PhoneCollateralContacts                              
		--, 2 as SessionsCancelledOrMissed                          
		----Custom Data                          
		                       
		--, '''' as CreatedBy                           
		--, getdate() as CreatedDate                           
		--, '''' as ModifiedBy                          
		--, getdate() as ModifiedDate                              
		--from systemconfigurations s left outer join CustomMSTWeeklyNote                                                                      
		--on s.Databaseversion = -1          
	                                
	END                                        
end try                                              
                                                                                       
BEGIN CATCH  
DECLARE @Error varchar(8000)                                               
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                             
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomMSTWeeklyNoteStandardInitialization'')                                                                             
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
