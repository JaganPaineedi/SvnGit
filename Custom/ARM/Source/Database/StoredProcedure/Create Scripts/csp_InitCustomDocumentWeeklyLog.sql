/****** Object:  StoredProcedure [dbo].[csp_InitCustomDocumentWeeklyLog]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentWeeklyLog]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomDocumentWeeklyLog]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomDocumentWeeklyLog]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[csp_InitCustomDocumentWeeklyLog]
(                                
 @ClientID INT,          
 @StaffID INT,        
 @CustomParameters XML                                
)                                                        
AS  
 /*********************************************************************/  
 /* Stored Procedure: [csp_InitClientActionPlans]               */    
 /*Date     Author      Purpose           */  
 /*JAN 28 2013        VISHANT GARG              Created with respect TO TASK #17 NEWYAGO CUSTOMIZATION */ 
 /*feb 01 2013        Atul Pandey               Modified w.r.t  TASK #17 NEWYAGO CUSTOMIZATION*/ 
 /*feb 07 2013        Atul Pandey               commented to get CustomDocumentWeeklyLogGoals and CustomDocumentWeeklyLogObjectives  */ 
 /*********************************************************************/  
BEGIN
BEGIN TRY


		SELECT 
		Placeholder.TableName
	  ,-1 AS [DocumentVersionId]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedBy]
      ,[DeletedDate]
      ,[ProcedureCodeId]
      ,[ProgramId]
      ,[LocationId]
      ,[InsurerId]
      ,[ProviderId]
      ,[SiteId]
      ,[Service1StartDate]
      ,[Service1EndDate]
      ,[Service1StartTime]
      ,[Service1EndTime]
      ,[Service1Duration]
      ,110 AS [Service1UnitType]
      ,[Service2StartDate]
      ,[Service2EndDate]
      ,[Service2StartTime]
      ,[Service2EndTime]
      ,[Service2Duration]
      ,110 AS [Service2UnitType]
      ,[Service3StartDate]
      ,[Service3EndDate]
      ,[Service3StartTime]
      ,[Service3EndTime]
      ,[Service3Duration]
      ,110 AS [Service3UnitType]
      ,[Service4StartDate]
      ,[Service4EndDate]
      ,[Service4StartTime]
      ,[Service4EndTime]
      ,[Service4Duration]
      ,110 AS [Service4UnitType]
      ,[Service5StartDate]
      ,[Service5EndDate]
      ,[Service5StartTime]
      ,[Service5EndTime]
      ,[Service5Duration]
      ,110 AS [Service5UnitType]
      ,[Service6StartDate]
      ,[Service6EndDate]
      ,[Service6StartTime]
      ,[Service6EndTime]
      ,[Service6Duration]
      ,110 AS [Service6UnitType]
      ,[Service7StartDate]
      ,[Service7EndDate]
      ,[Service7StartTime]
      ,[Service7EndTime]
      ,[Service7Duration]
      ,110 AS [Service7UnitType]
      ,[Comment]
      ,[GoalProgress]
      FROM (SELECT ''CustomDocumentWeeklyLog'' AS TableName) AS Placeholder  
      LEFT JOIN [CustomDocumentWeeklyLog] CDWL ON ( CDWL.DocumentVersionId = -1  ) 
      
  --SELECT 
		--Placeholder.TableName
	 -- ,-1 as WeeklyLogGoalId	
	 -- ,[CreatedBy]
  --    ,[CreatedDate]
  --    ,[ModifiedBy]
  --    ,[ModifiedDate]
  --    ,[RecordDeleted]
  --    ,[DeletedBy]
  --    ,[DeletedDate]
  --    ,-1 AS [DocumentVersionId]
  --    ,NeedId
  --    FROM (SELECT ''CustomDocumentWeeklyLogGoals'' AS TableName) AS Placeholder  
  --    LEFT JOIN CustomDocumentWeeklyLogGoals CDWG  ON ( CDWG.DocumentVersionId = -1  )  
      
      
  -- SELECT 
		--Placeholder.TableName
	 -- ,-1 as WeeklyLogObjectiveId
	 -- ,[CreatedBy]
  --    ,[CreatedDate]
  --    ,[ModifiedBy]
  --    ,[ModifiedDate]
  --    ,[RecordDeleted]
  --    ,[DeletedBy]
  --    ,[DeletedDate]
  --    ,-1 AS [DocumentVersionId]
  --    ,ObjectiveId
  --   FROM (SELECT ''CustomDocumentWeeklyLogObjectives'' AS TableName) AS Placeholder  
  --    LEFT JOIN CustomDocumentWeeklyLogObjectives CDWLO ON ( CDWLO.DocumentVersionId = -1  )       

    select  ''Programs'' AS TableName, b.ProgramId,b.ProgramCode,gc.CodeName as ProgramType,gc.Category,gc.CodeName,a.StaffId   
from staffPrograms a  join Programs b on a.ProgramId=b.ProgramId join GlobalCodes gc on b.ProgramType=gc.GlobalCodeId  
where  isNull(a.RecordDeleted,''N'')<>''Y''   and isNull(b.RecordDeleted,''N'')<>''Y'' 
END TRY
BEGIN CATCH      
DECLARE @Error varchar(8000)                                                   
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())  
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomDocumentWeeklyLog'')  
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
