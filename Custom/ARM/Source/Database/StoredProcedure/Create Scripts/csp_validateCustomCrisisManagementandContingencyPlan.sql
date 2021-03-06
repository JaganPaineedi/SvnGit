/****** Object:  StoredProcedure [dbo].[csp_validateCustomCrisisManagementandContingencyPlan]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomCrisisManagementandContingencyPlan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomCrisisManagementandContingencyPlan]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomCrisisManagementandContingencyPlan]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_validateCustomCrisisManagementandContingencyPlan]
@DocumentVersionId	Int
as

Create Table #validationReturnTable
(TableName varchar(300),
 ColumnName varchar(200),
 ErrorMessage varchar(500),
 PageIndex int
)


--Insert into #validationReturnTable
--(TableName,
--ColumnName,
--ErrorMessage,
--PageIndex
--)
--This validation returns three fields
--Field1 = TableName
--Field2 = ColumnName
--Field3 = ErrorMessage

select * from #validationReturnTable
if @@error <> 0 goto error

return

error:
raiserror 50000 ''csp_validateCustomCrisisManagementandContingencyPlan failed.  Contact your system administrator.''
' 
END
GO
