/****** Object:  StoredProcedure [dbo].[csp_ReportClientSearchByMACUCI]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClientSearchByMACUCI]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportClientSearchByMACUCI]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClientSearchByMACUCI]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
-- =============================================
-- Author:		Chuck Blaine
-- Create date: 2012-07-31
-- Description:	Returns data set for MACUCI search report
-- =============================================
CREATE PROCEDURE [dbo].[csp_ReportClientSearchByMACUCI]
	-- Add the parameters for the stored procedure here
    @MACUCI NVARCHAR(35)
AS 
    BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
        SET NOCOUNT ON;

    -- Insert statements for procedure here
        SELECT  cc.MACUCI ,
                c.FirstName + '' '' + c.LastName AS ClientName ,
                c.DOB ,
                cc.ClientId ,
                s.FirstName + '' '' + s.LastName AS PrimaryClinician ,
                c.Active
        FROM    dbo.CustomClients cc
                JOIN dbo.Clients c ON c.ClientId = cc.ClientId
                LEFT OUTER JOIN dbo.Staff s ON s.StaffId = c.PrimaryClinicianId
        WHERE	cc.MACUCI = @MACUCI
    END

' 
END
GO
