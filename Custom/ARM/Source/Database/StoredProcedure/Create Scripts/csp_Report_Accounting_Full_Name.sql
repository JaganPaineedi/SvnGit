/****** Object:  StoredProcedure [dbo].[csp_Report_Accounting_Full_Name]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Accounting_Full_Name]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_Accounting_Full_Name]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Accounting_Full_Name]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE [dbo].[csp_Report_Accounting_Full_Name]

AS
--*/
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
BEGIN
DECLARE @Account_Name TABLE
(
	NameID		Varchar(15),
	Full_Name	Varchar(50)
)

INSERT INTO @Account_Name (NameID, Full_Name)
VALUES (''%'', ''All Staff'')

INSERT INTO @Account_Name
SELECT DISTINCT a.CreatedBy, s.LastName + '', '' +  s.FirstName AS ''NAME''
FROM dbo.ARLedger a
JOIN dbo.Staff s
ON a.CreatedBy = s.UserCode 
WHERE a.CreatedBy NOT LIKE ''123%''
ORDER BY a.CreatedBy ASC
END

SELECT * FROM @Account_Name 
' 
END
GO
