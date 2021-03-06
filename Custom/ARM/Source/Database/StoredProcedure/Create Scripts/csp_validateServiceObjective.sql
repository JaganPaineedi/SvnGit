/****** Object:  StoredProcedure [dbo].[csp_validateServiceObjective]    Script Date: 06/19/2013 17:49:53 ******/
/* 2018-09-19   Neethu  What:  validation for objecive should trigger, even if there is no signed treatment plan
                        Why:  ARM Support #904 */
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateServiceObjective]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateServiceObjective]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateServiceObjective]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_validateServiceObjective]        
@ServiceId int       
As        
  
BEGIN  
  
BEGIN TRY      
-- do this the professional way and avoid query hints
set transaction isolation level read uncommitted
 
insert into #ValidationReturnTable (
	TableName,  
	ColumnName,  
	ErrorMessage,  
	TabOrder,  
	ValidationOrder  
)      

SELECT ''Services'', ''DeletedBy'',''Service  - Please specifiy 1 objective addressed for this service'' ,0,1
where Not exists ( 
	select 1 from  ServiceObjectives where ServiceId = @ServiceId
	and isnull(RecordDeleted,''N'')<>''Y''
)


        
END TRY  
  
BEGIN CATCH  
     DECLARE @Error varchar(8000)                                                     
     SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                   
      + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_validateServiceObjective'')                                                                                   
      + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                    
      + ''*****'' + Convert(varchar,ERROR_STATE())                                
     RAISERROR                                                                                   
     (                                                     
      @Error, -- Message text.                                                                                  
      16, -- Severity.                                                                                  
      1 -- State.                                                                                  
     );         
END CATCH  
  
RETURN   
END
' 
END
GO
