/****** Object:  StoredProcedure [dbo].[csp_ParametersGetReceptionViews]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ParametersGetReceptionViews]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ParametersGetReceptionViews]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ParametersGetReceptionViews]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_ParametersGetReceptionViews]
As

select ViewName, ReceptionViewId from ReceptionViews
where isnull(recorddeleted, ''N'') = ''N''
order by viewname
' 
END
GO
