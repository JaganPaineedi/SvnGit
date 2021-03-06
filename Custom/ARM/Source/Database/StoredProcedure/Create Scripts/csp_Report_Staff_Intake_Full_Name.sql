/****** Object:  StoredProcedure [dbo].[csp_Report_Staff_Intake_Full_Name]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Staff_Intake_Full_Name]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_Staff_Intake_Full_Name]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Staff_Intake_Full_Name]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
--/*
CREATE PROCEDURE [dbo].[csp_Report_Staff_Intake_Full_Name]

AS
--*/
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

DECLARE @Intake_Staff TABLE
(
	StaffID		Int,
	StaffName	Varchar(50)
)

INSERT INTO @Intake_Staff 
VALUES (0,''All Intake Staff'')

INSERT INTO @Intake_Staff 
SELECT s.StaffId, s.LastName + '', '' + s.FirstName 
FROM dbo.Staff s
WHERE s.IntakeStaff =''Y''
ORDER BY s.LastName 

SELECT * FROM @Intake_Staff 
END
' 
END
GO
