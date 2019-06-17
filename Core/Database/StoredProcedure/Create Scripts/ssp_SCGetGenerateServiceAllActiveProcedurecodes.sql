/****** Object:  StoredProcedure [dbo].[ssp_SCGetGenerateServiceAllActiveProcedurecodes]    Script Date: 03/12/2015 18:17:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetGenerateServiceAllActiveProcedurecodes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetGenerateServiceAllActiveProcedurecodes]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetGenerateServiceAllActiveProcedurecodes] 14   Script Date: 03/12/2015 18:17:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetGenerateServiceAllActiveProcedurecodes]
@GroupId INT
AS
/****************************************************************************/
/* Stored Procedure: ssp_SCGetGenerateServiceAllActiveProcedurecodes        */
/* Copyright: 2006 Streamline Healthcare Solutions                          */
/* Author: Akwinass                                                         */
/* Creation Date:  FEB 01,2016                                            */
/* Purpose: To Get All Active Generate Service Procedurecodes               */
/*-------------Modification History--------------------------               */
/*-------Date-----------Author------------Purpose---------------------------*/
/*       01-FEB-2016  Akwinass          Created(Task #829.03 in Woods - Customizations).*/
-- 04/20/2017  jcarlson	   Keystone Customizations 55 - Modified to handle changes to ProgramProcedures table
-- 05/04/2017  Manjunath K   Selecting only AttendanceServiceProcedureCode type ProcedureCodes. For Woods Support Go Live #444
--10 July 2017	Manjunath K		Added Code to selected ClientSpecific procedure codes. For 	Woods SGL #444.2
/****************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @ProgramId INT

		SELECT TOP 1 @ProgramId = ProgramId
		FROM Groups
		WHERE GroupId = @GroupId
			AND ISNULL(RecordDeleted, 'N') = 'N'
		
		SELECT 
		PC.DisplayAs,PC.ProcedureCodeId
		FROM ProcedureCodes AS pc
		WHERE ISNULL(pc.RecordDeleted,'N')='N'
		AND pc.Active = 'Y'
		AND (PC.AttendanceServiceProcedureCode='Y' OR 
		exists(Select 1 from Groups GR where GR.AttendanceDefaultProcedureCodeId = PC.ProcedureCodeId 
		AND GR.GroupId= @GroupId AND isnull(GR.RecordDeleted, 'N') = 'N'))--10 July 2017 Manjunath K
		AND EXISTS ( SELECT 1
					FROM dbo.ProgramProcedures AS ppc
					WHERE isnull(PPC.RecordDeleted, 'N') = 'N'
					AND ( ( ppc.StartDate <= CONVERT(DATE,GETDATE()) OR ppc.StartDate IS NULL )
							 AND ( ppc.EndDate >= CONVERT(DATE,GETDATE()) OR ppc.EndDate IS NULL )
						)
					AND PPC.ProgramId = @ProgramId	
					AND ppc.ProcedureCodeId = pc.ProcedureCodeId
				)
		
		ORDER BY PC.DisplayAs ASC
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetGenerateServiceAllActiveProcedurecodes') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.       
				16
				,-- Severity.       
				1 -- State.       
				);
	END CATCH
END

GO


