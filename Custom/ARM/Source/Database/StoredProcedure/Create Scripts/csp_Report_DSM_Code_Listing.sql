/****** Object:  StoredProcedure [dbo].[csp_Report_DSM_Code_Listing]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_DSM_Code_Listing]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_DSM_Code_Listing]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_DSM_Code_Listing]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE	PROCEDURE	[dbo].[csp_Report_DSM_Code_Listing]

AS
--*/

SELECT	d.DSMCode,
		d.DSMNumber,
		d.DSMDescription
FROM	DiagnosisDSMDescriptions d
ORDER	BY
		d.DSMCode,
		d.DSMNumber,
		d.DSMDescription
' 
END
GO
