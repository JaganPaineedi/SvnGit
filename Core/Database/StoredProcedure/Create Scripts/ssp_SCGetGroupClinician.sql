/****** Object:  StoredProcedure [dbo].[ssp_SCGetGroupClinician]    Script Date: 03/12/2015 18:17:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetGroupClinician]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetGroupClinician]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetGroupClinician]    Script Date: 03/12/2015 18:17:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetGroupClinician]
@ServiceId INT
AS
/****************************************************************************/
/* Stored Procedure: ssp_SCGetGroupClinician                                */
/* Copyright: 2006 Streamline Healthcare Solutions                           */
/* Author: Akwinass                                                         */
/* Creation Date:  April 29,2015                                            */
/* Purpose: To Get Group Clinician                                          */
/* Input Parameters:@ServiceId                                             */
/* Output Parameters:None                                                   */
/* Return:                                                                  */
/* Calls:                                                                   */
/* Called From:                                                             */
/* Data Modifications:                                                      */
/*                                                                          */
/*-------------Modification History--------------------------               */
/*-------Date-----------Author------------Purpose---------------------------*/
/*       29-MAY-2015  Akwinass          Created(Task #829 in Woods - Customizations).*/
/****************************************************************************/
BEGIN
	BEGIN TRY	
		DECLARE @GroupId INT = 0

		SELECT TOP 1 @GroupId = GS.GroupId
		FROM GroupServices GS
		JOIN Services S ON GS.GroupServiceId = S.GroupServiceId
		WHERE S.ServiceId = @ServiceId
			AND ISNULL(GS.RecordDeleted, 'N') = 'N'
			AND ISNULL(S.RecordDeleted, 'N') = 'N'

		SELECT ClinicianId
		FROM Groups
		WHERE GroupId = @GroupId
			AND ISNULL(RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		IF (@@error != 0)
		BEGIN
			RAISERROR 20006 'ssp_SCGetGroupClinician: An Error Occured'

			RETURN
		END
	END CATCH
END

GO


