IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCGetPrimaryStaffClients]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_SCGetPrimaryStaffClients]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetPrimaryStaffClients]    Script Date: 07/20/2015 22:36:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[scsp_SCGetPrimaryStaffClients]
@LoggedInStaffId int,
@StaffId INT
--Created By Deej on Aug-28-2015
AS
BEGIN
PRINT 'Stub scsp'
END