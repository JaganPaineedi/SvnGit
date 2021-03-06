/****** Object:  StoredProcedure [dbo].[csp_WarningStoredProcedureCompleteTreatmentPlan]    Script Date: 06/19/2013 17:49:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_WarningStoredProcedureCompleteTreatmentPlan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_WarningStoredProcedureCompleteTreatmentPlan]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_WarningStoredProcedureCompleteTreatmentPlan]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[csp_WarningStoredProcedureCompleteTreatmentPlan] 
@DocumentVersionId	int
AS

-- Table schema below is from scsp_SCValidateDocument.  This is due to common functionality
-- between the validation and warning interfaces.
Declare @WarningReturnTable table
(TableName  varchar(200),                              
ColumnName  varchar(200),                              
ErrorMessage    varchar(max),                              
PageIndex       int,  
TabOrder int,  
ValidationOrder int                          
)

--
-- The following code is for testing and should be removed for production use.
--

DECLARE @HitCase	CHAR(1)
SELECT @HitCase = case when SUBSTRING(CONVERT(VARCHAR(max),RAND()),3,1) < 5 THEN ''Y'' ELSE ''N'' end


IF (@HitCase = ''Y'')
Begin
	INSERT INTO @WarningReturnTable
	(TableName,
	ColumnName,
	ErrorMessage,
	ValidationOrder)
	SELECT ''TPGeneral'',''DeletedBy'',''Warning unit test case.  Random warning hit. First entry (Sort test.  This should be listed first.).'', 2
	UNION
	SELECT ''TPGeneral'',''DeletedBy'',''Warning unit test case.  Random warning hit. Second entry (Sort test.  This should be listed first.).'', 1
End

--
-- End Random Test Code
--

Select 
	TableName,
	ColumnName,
	ErrorMessage,
	PageIndex,
	TabOrder,
	ValidationOrder
FROM @WarningReturnTable
ORDER BY TabOrder, ValidationOrder, PageIndex, ErrorMessage
' 
END
GO
