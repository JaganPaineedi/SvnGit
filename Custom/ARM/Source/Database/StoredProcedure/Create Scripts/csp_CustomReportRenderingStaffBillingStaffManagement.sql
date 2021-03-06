/****** Object:  StoredProcedure [dbo].[csp_CustomReportRenderingStaffBillingStaffManagement]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomReportRenderingStaffBillingStaffManagement]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CustomReportRenderingStaffBillingStaffManagement]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CustomReportRenderingStaffBillingStaffManagement]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[csp_CustomReportRenderingStaffBillingStaffManagement] (
	  @Action int = NULL
	, @RenderingStaffId int = NULL
	, @BillingStaffId int = NULL
	, @FromDate date = NULL
	, @ToDate date = NULL
	, @CustomBillingStaffRenderingStaffId int = NULL
	)

AS
/****************************************************************************/
/* Procedure Name:	csp_CustomReportRenderingStaffBillingStaffManagement	*/
/* Parameters:	@Action - 0 = ViewOnly, 1 = Add, 2 = Delete					*/
/*		@RenderingStaffId, @BillingStaffId,									*/
/*		@FromDate, @ToDate													*/
/* Created By:	JJN															*/
/* Created Date:	2012-11-16												*/
/*																			*/
/* Change Log:																*/
/* Modified Date	Modified By		Purpose									*/
/*																			*/
/****************************************************************************/

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

BEGIN TRAN

DECLARE @Error int = 0, @Message varchar(250) = '''', @RenderingName varchar(200), @BillingName varchar(200)

SELECT @RenderingName = FirstName + '' '' + LastName FROM Staff WHERE StaffId = @RenderingStaffId
SELECT @BillingName = FirstName + '' '' + LastName FROM Staff WHERE StaffId = @BillingStaffId

IF @Action = 1 
begin
	if @FromDate is null
		SELECT @Message = @Message + ''From date is required when adding rows.'', @Error = 1
	else
	begin
		SELECT @Message = @Message + ''Add '' + @BillingName + '' as the billing staff for '' + @RenderingName + '' from '' + ISNULL(CONVERT(varchar,@FromDate,101),''No Date'') + '' to '' + ISNULL(CONVERT(varchar,@ToDate,101),''ongoing'')
		IF ISNULL(@RenderingStaffId,-1) <> -1
			AND ISNULL(@BillingStaffId,-1) <> -1
			AND @FromDate IS NOT NULL
			AND NOT EXISTS (
				SELECT * FROM CustomBillingStaffRenderingStaff 
				WHERE RenderingStaffId = @RenderingStaffId
				and (@ToDate is null or @ToDate >= FromDate)
				and (@FromDate < ToDate or ToDate is null)
		)
		BEGIN
			INSERT INTO CustomBillingStaffRenderingStaff (RenderingStaffId, BillingStaffId, FromDate, ToDate, CreatedBy, CreatedDate)
			SELECT @RenderingStaffId, @BillingStaffId, @FromDate, @ToDate, ''RSBSMGMT'', GETDATE()
			where NOT EXISTS (
				SELECT * FROM CustomBillingStaffRenderingStaff 
				WHERE RenderingStaffId = @RenderingStaffId
				and (@ToDate is null or @ToDate >= FromDate)
				and (@FromDate < ToDate or ToDate is null)
		)
			SELECT @Message = @Message + '' was successful.''
		END
		ELSE 
			SELECT @Message = @Message + '' failed.  Check for conflicts in from/to dates.'', @Error = 1
	end
END


IF @Action = 2
	AND @CustomBillingStaffRenderingStaffId IS NOT NULL
BEGIN

	UPDATE a SET
		RecordDeleted = ''Y'',
		DeletedBy = ''RSBSMGMT'',
		DeletedDate = GETDATE()
	FROM CustomBillingStaffRenderingStaff a
	WHERE CustomBillingStaffRenderingStaffId = @CustomBillingStaffRenderingStaffId

	SELECT @Message = ''Delete billing staff for '' + @RenderingName + '' during '' + ISNULL(CONVERT(varchar,@FromDate,101),''No Date'') + '' to '' + ISNULL(CONVERT(varchar,@ToDate,101),''ongoing'') + '' was successful!''
END

SELECT CustomBillingStaffRenderingStaffId
	, RenderingStaffId
	, RenderingStaffName = rs.LastName + '', '' + rs.FirstName
	, c.BillingStaffId
	, BillingStaffName = bs.LastName + '', '' + bs.FirstName
	, c.FromDate
	, c.ToDate
	, Error = @Error
	, Message = @Message
FROM CustomBillingStaffRenderingStaff AS c
JOIN Staff AS rs ON rs.StaffId = c.RenderingStaffId
	AND ISNULL(rs.RecordDeleted,''N'') <> ''Y''
JOIN Staff AS bs ON bs.StaffId = c.BillingStaffId
	AND ISNULL(bs.RecordDeleted,''N'') <> ''Y''
WHERE ISNULL(c.RecordDeleted,''N'') <> ''Y''
	--AND (ISNULL(@RenderingstaffId,-1) = -1 OR c.RenderingstaffId = @BillingStaffId)
	--AND (ISNULL(@BillingStaffId,-1) = -1 OR c.BillingStaffId = @BillingStaffId)
ORDER BY RenderingStaffName, FromDate

IF @@error = 0 COMMIT TRAN
ELSE ROLLBACK

SET TRANSACTION ISOLATION LEVEL READ COMMITTED

' 
END
GO
