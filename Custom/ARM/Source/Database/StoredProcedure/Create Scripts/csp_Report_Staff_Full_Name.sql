/****** Object:  StoredProcedure [dbo].[csp_Report_Staff_Full_Name]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Staff_Full_Name]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_Staff_Full_Name]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Staff_Full_Name]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE [dbo].[csp_Report_Staff_Full_Name]
AS
--*/
-- =============================================
-- Author:		<Michael R.>
-- Create date: <10/08/2012>
-- Description:	<Creates table of Staff Full Name ordered by Last Name to use in reports.>
-- =============================================

/*
--*/
DECLARE @Staff_Full_Name TABLE
(
	StaffID		char(7),
	StaffName	Varchar(50)
)

BEGIN
INSERT INTO @Staff_Full_Name
SELECT * FROM dbo.fn_Staff_Full_Name()
END

SELECT * FROM @Staff_Full_Name 

' 
END
GO
