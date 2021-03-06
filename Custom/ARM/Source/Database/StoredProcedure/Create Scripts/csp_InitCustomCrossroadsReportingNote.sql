/****** Object:  StoredProcedure [dbo].[csp_InitCustomCrossroadsReportingNote]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomCrossroadsReportingNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomCrossroadsReportingNote]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomCrossroadsReportingNote]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitCustomCrossroadsReportingNote]                       
(          
@ClientID int          
)                           
As    

/** Replaced by csp_InitCustomCrossroadsReportingNoteStandardInitialization **/

Return

/*                      
              
Begin Try              
                                  
 Begin                                  
 /*********************************************************************/                                    
 /* Stored Procedure: csp_InitCustomCrossroadsReportingNote               */                           
                           
 /* Copyright: 2006 Streamline SmartCare*/                                    
                           
 /* Creation Date:  14/Aug/2007                                    */                                    
 /*                                                                   */                                    
 /* Purpose: Gets Last Signed NumberOfServices, AssessmentDate, NextTxPlanDate, TxPlanDetails from CustomCrossroadsReportingNote */                                   
 /*                                                                   */                                  
 /* Input Parameters:  */                                  
 /*                                                                   */                                     
 /* Output Parameters:                                */                                    
 /*                                                                   */                                    
 /* Return:   */                                    
 /*                                                                   */                                    
 /* Called By: NumberOfServices, AssessmentDate, NextTxPlanDate, TxPlanDetails in CustomCrossroadsReportingNote Class Of DataService    */                          
 /*      */                          
                           
 /*                                                                   */                                    
 /* Calls:                                                            */                                    
 /*                                                                   */                                    
 /* Data Modifications:                                               */                                    
 /*                                                                   */                                    
 /*   Updates:                                                          */                                    
                           
 /*       Date              Author                  Purpose                                    */                                    
 /*       14/Aug/2007        RISHU               To Retrieve Data      */                                    
 /*********************************************************************/                                     
                     
                    
-- Select 10 as NumberOfServices, getdate() as AssessmentDate, getdate() as NextTxPlanDate, ''TxPlanDetails'' as TxPlanDetails     
Select	
--Find Crossroad services for the past month
isnull(
	(Select count(s.ServiceId) from Services s
	where isnull(s.RecordDeleted,''N'')<>''Y'' and s.ClientId=@ClientId 
	and s.Status in (75,71,70) 
	and (s.ProgramId in (25) OR s.ProcedureCodeId in (29))
	and s.DateOfService between dateadd(MM,-1,getdate()) and getdate()
	),0) as NumberOfServices, 
--Get Assessment Date
isnull(
	(Select Top 1 convert(varchar(10),d.EffectiveDate,101)
	from Documents d 
	where isnull(d.RecordDeleted,''N'')<>''Y''
	and d.Status=22 and d.ClientId=@ClientId
	and d.DocumentCodeId in (101,110,354)
	order by d.EffectiveDate Desc
	),NULL) as AssessmentDate,
--Get Next TX Plan Due Date
isnull((Select convert(varchar(10),dateAdd(yy, 1, d.EffectiveDate),101)
	from Documents d 
	where isnull(d.RecordDeleted,''N'')<>''Y''
	and d.Status=22 and d.ClientId=@ClientId
	and d.DocumentCodeId = 2
	and not exists
		(select * from documents as d2
		where d2.ClientId = d.ClientId and d2.EffectiveDate > d.EffectiveDate
		and isnull(d2.RecordDeleted, ''N'') <> ''Y'' and d2.status=22
		and d2.documentcodeid=d.documentcodeid)
	),convert(varchar(10),Getdate(),101)) as NextTxPlanDate, 
--Get Tx Plan Details associated with Crossroads
isnull((Select top 1 cast(''Need: '' + convert(varchar(8000),n.NeedText)+char(13)+char(10)+ ''Goal: '' +convert(varchar(8000),n.GoalText)as text) 
		from documents d 
			join tpNeeds n on n.documentid=d.documentid 
			and d.DocumentCodeId=2
			and n.version=d.CurrentVersion
			and isnull(n.RecordDeleted,''N'')<>''Y'' 
		where isnull(n.GoalHealthSafety,''N'')=''Y''
		and isnull(n.GoalActive,''N'')<>''N'' 
		and isnull(d.RecordDeleted,''N'')<>''Y''
		and d.Status=22 and d.ClientId=@ClientId 
		and not exists (select * from documents as d2
						where d2.ClientId = d.ClientId 
						and d2.EffectiveDate > d.EffectiveDate
						and isnull(d2.RecordDeleted, ''N'') <> ''Y'' and d2.status=22
						--and d2.documentcodeid=d.documentcodeid
						and d2.documentCodeId=2
						and d2.CurrentVersion=n.version
						) order by d.EffectiveDate desc
	), ''No Data Available'') as TxPlanDetails    
 

 END              
End Try              
              
Begin Catch                
                
    SELECT                
    ERROR_NUMBER() AS ErrorNumber,                
    ERROR_SEVERITY() AS ErrorSeverity,                
    ERROR_STATE() AS ErrorState,                
    ERROR_PROCEDURE() AS ErrorProcedure,                
    ERROR_LINE() AS ErrorLine,                
    ERROR_MESSAGE() AS ErrorMessage;                
                
End Catch 

*/
' 
END
GO
