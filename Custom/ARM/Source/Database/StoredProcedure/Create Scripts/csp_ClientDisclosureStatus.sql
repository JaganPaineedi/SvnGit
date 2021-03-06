/****** Object:  StoredProcedure [dbo].[csp_ClientDisclosureStatus]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ClientDisclosureStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ClientDisclosureStatus]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ClientDisclosureStatus]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[csp_ClientDisclosureStatus]

as

Select null as ''GlobalCode'', ''<ALL>'' as ''DisclosureStatus''
Union
select GlobalCodes.GlobalCodeId as ''GlobalCode'', GlobalCodes.CodeName as ''DisclosureStatus''
from GlobalCodes
	where ISNULL(globalcodes.recorddeleted, ''N'')<>''Y''
		and GlobalCodes.GlobalCodeId in (21549,21550,21551,21552,21553,21554,21555,21556,21557,21558,21559,21560)
		

' 
END
GO
