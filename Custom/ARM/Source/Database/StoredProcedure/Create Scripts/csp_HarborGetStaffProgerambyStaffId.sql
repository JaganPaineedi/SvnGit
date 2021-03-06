/****** Object:  StoredProcedure [dbo].[csp_HarborGetStaffProgerambyStaffId]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_HarborGetStaffProgerambyStaffId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_HarborGetStaffProgerambyStaffId]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_HarborGetStaffProgerambyStaffId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[csp_HarborGetStaffProgerambyStaffId]
	/* Param List */
@staffId Int
AS
BEGIN
/******************************************************************************
**		File: 
**		Name: GetStaffProgeram
**		Desc: 
**
**		This template can be customized:
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**		Input							Output
**     ----------							-----------
**
**		Auth: 
**		Date: 
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		Author:				Description:
**		--------		--------				-------------------------------------------
**    
*******************************************************************************/
Select pr.ProgramName AS Program ,CAST(pr.ProgramId AS VARCHAR(10)) AS StaffProgramId from Staff AS St INNER JOIN StaffPrograms AS stp ON st.StaffId=stp.StaffId 
			INNER JOIN Programs AS pr ON pr.ProgramId =stp.ProgramId WHERE St.StaffId=@staffId 
END
' 
END
GO
