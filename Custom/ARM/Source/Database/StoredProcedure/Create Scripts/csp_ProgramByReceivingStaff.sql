/****** Object:  StoredProcedure [dbo].[csp_ProgramByReceivingStaff]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ProgramByReceivingStaff]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ProgramByReceivingStaff]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ProgramByReceivingStaff]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE Procedure [dbo].[csp_ProgramByReceivingStaff]
(
	@StaffID int
)
AS
/************************************************************************/
/* Stored Procedure: csp_ProgramByReceivingStaff						*/
/* Copyright: 2006 Streamline SmartCare									*/
/* Creation Date:  Aug 30, 2012											*/
/*																		*/
/* Purpose: Gets Program By Receiving Staff	On Recomended Serivices		*/
/*																		*/
/* Input Parameters: StaffID											*/
/* Output Parameters:													*/
/* Calls:																*/
/* Author: AmitSr														*/
/************************************************************************/
begin	
	select Programs.Programid,ProgramCode, ProgramName  
	from StaffPrograms  inner join Programs
	on StaffPrograms.Programid= Programs.Programid
	where staffid=@StaffID
end
' 
END
GO
