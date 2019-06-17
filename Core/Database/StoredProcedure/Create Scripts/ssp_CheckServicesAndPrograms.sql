/****** Object:  StoredProcedure [dbo].[ssp_CheckServicesAndPrograms]    Script Date: 12/07/2015 10:12:34 ******/
IF EXISTS (SELECT *
	FROM sys.objects
	WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CheckServicesAndPrograms]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ssp_CheckServicesAndPrograms]
GO

/****** Object:  StoredProcedure [dbo].[ssp_CheckServicesAndPrograms]    Script Date: 12/07/2015 10:12:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[ssp_CheckServicesAndPrograms]
/* Param List */ @ClientId INT
AS

	/******************************************************************************
	**  File:
	**  Name: ssp_CheckServicesAndPrograms
	**  Desc:
	**
	**  This template can be customized:
	**
	**  Return values:
	**  0 - No Scheduled service(s) Or Requested/Enrolled program(s) exist
	**  1 - Scheduled service(s) and Requested/Enrolled program(s) exist
	**  2 - Only Enrolled/Requested Programs exist
	**  3 - Only scheduled services exist
	**  Called by:  ClientInformation(When the user tries to uncheck the active flag.)
	**
	**  Parameters:
	**  Input       Output
	** ----------   -----------
	**  @ClientId
	**  Auth: Jaspreet Singh
	**  Date: 03-Dec-2007
	*******************************************************************************
	**  Change History
	*******************************************************************************
	**  Date:  Author:    Description:
	**  --------  --------    -------------------------------------------
	**  10/30/2015		praorane		Added logic to allow for clients to continue to stay enrolled in certain programs even when discharged. This was requested by Riverwood because their client search permissions are based on Programs. If a client needs to be discharged from all programs to be discharged from an episode, they lose the ability to look up a client after discharge.
	*******************************************************************************/

	BEGIN TRY
	DECLARE @countClientPrograms INT
	DECLARE @countScheduledServices INT

	SELECT @countClientPrograms=(
	SELECT Count(*)
	FROM       ClientPrograms CP
	INNER JOIN Programs       P  ON CP.ProgramId=P.ProgramId
	WHERE ClientId=@ClientId
		AND (Status=1 or Status=4)
		AND (P.RecordDeleted = 'N' OR P.RecordDeleted IS NULL)
		AND (CP.RecordDeleted='N' OR CP.RecordDeleted IS NULL)
		and not exists(select 1
		from dbo.ssf_RecodeValuesCurrent('XProgramEnrollment') pe
		where pe.IntegerCodeId = cp.ProgramId) -- 10/30/2015 praorane
	)

	SELECT @countScheduledServices=(
	SELECT Count(*)
	FROM Services
	WHERE ClientId=@ClientId
		AND Status=70
		AND (RecordDeleted='N' OR RecordDeleted IS NULL)
	)

	if @countClientPrograms > 0 and @countScheduledServices > 0
		Select 1
	else if @countClientPrograms > 0
			Select 2
		else if @countScheduledServices > 0
				Select 3
			else
				Select 0

	END TRY
	BEGIN CATCH
	declare @Error varchar(8000)
	set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())
	+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_CheckServicesAndPrograms')
	+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())
	+ '*****' + Convert(varchar,ERROR_STATE())

	RAISERROR
	(
	@Error, -- Message text.
	16, -- Severity.
	1 -- State.
	);

	END CATCH


GO
