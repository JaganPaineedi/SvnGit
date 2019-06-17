/****** Object:  StoredProcedure [dbo].[ssp_SCWebDashBoardCaseLoadSelShowProc]    Script Date: 12/04/2012 11:07:35 ******/
IF EXISTS (SELECT *
           FROM   sys.objects
           WHERE  object_id =
                  Object_id(N'[dbo].[scsp_SCWebDashBoardCaseLoadSelShowProc]')
                  AND type IN ( N'P', N'PC' ))
  DROP PROCEDURE [dbo].[scsp_SCWebDashBoardCaseLoadSelShowProc]

go

/****** Object:  StoredProcedure [dbo].[ssp_SCWebDashBoardCaseLoadSelShowProc]    Script Date: 12/04/2012 11:07:35 ******/
SET ansi_nulls ON

go

SET quoted_identifier ON

go

CREATE PROCEDURE [dbo].[scsp_SCWebDashBoardCaseLoadSelShowProc] (
@StaffId INT,
@LoggedInStaffId INT,
@RefreshData CHAR(1) = NULL)
/* Created By Deej 29th Aug-2015*/
AS
BEGIN
	PRINT 'SCSP Stub'
END