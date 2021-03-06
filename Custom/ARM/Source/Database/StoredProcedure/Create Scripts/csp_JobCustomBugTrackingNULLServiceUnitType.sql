/****** Object:  StoredProcedure [dbo].[csp_JobCustomBugTrackingNULLServiceUnitType]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobCustomBugTrackingNULLServiceUnitType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_JobCustomBugTrackingNULLServiceUnitType]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobCustomBugTrackingNULLServiceUnitType]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE    PROCEDURE [dbo].[csp_JobCustomBugTrackingNULLServiceUnitType]      
      
as      
/******************************************************************************    
csp_JobCustomBugTrackingNULLServiceUnitType

Date		User		Decription
----------	---------	----------------------------------------------------
07/29/2010	dharvey		created to track services created with no UnitType.  
02/06/2011	dharvey		Changed insert to CustomBugTracking to keep in 
						consolidated bug tracking table with DocumentVersionId
*******************************************************************************/    
    
BEGIN TRY

BEGIN TRAN

	INSERT into CustomBugTracking
		(ClientId, ServiceId, Description, CreatedDate, DocumentVersionId)
	SELECT 
		s.ClientId, s.ServiceId
		, ''Service UnitType is NULL - Updated record with UnitType=''+convert(varchar(20),pc.EnteredAs)
		, s.CreatedDate, d.CurrentDocumentVersionId
		From Services s with(nolock)
		Join ProcedureCodes pc with(nolock) on s.ProcedureCodeId=pc.ProcedureCodeId
		Left Join Documents d with(nolock) on d.ServiceId=s.ServiceId and ISNULL(d.RecordDeleted,''N'')=''N''
		Where s.UnitType is null
		and isnull(s.RecordDeleted,''N'')=''N''
		and s.Status in (70,71)

	UPDATE s
		SET s.UnitType = pc.EnteredAs
		From Services s with(nolock)
		Join ProcedureCodes pc with(nolock) on s.ProcedureCodeId=pc.ProcedureCodeId
		Where s.UnitType is null
		and isnull(s.RecordDeleted,''N'')=''N''
		and s.Status in (70,71)

COMMIT

END TRY
BEGIN CATCH
	ROLLBACK;
	DECLARE @Error varchar(8000)                                                   
	SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                 
		+ ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomDischargeStandardInitialization'')                                                                                 
		+ ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                  
		+ ''*****'' + Convert(varchar,ERROR_STATE())                              
	 RAISERROR                                                                                 
	 (                                                   
	  @Error, -- Message text.                                                                                
	  16, -- Severity.                                                                                
	  1 -- State.                                                                                
	 );          
END CATCH
' 
END
GO
