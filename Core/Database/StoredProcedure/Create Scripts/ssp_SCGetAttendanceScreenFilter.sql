/****** Object:  StoredProcedure [dbo].[ssp_SCGetAttendanceScreenFilter]    Script Date: 03/12/2015 18:17:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetAttendanceScreenFilter]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetAttendanceScreenFilter]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetAttendanceScreenFilter]    Script Date: 03/12/2015 18:17:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCGetAttendanceScreenFilter]
@StaffId INT,
@ScreenId INT
AS
/****************************************************************************/
/* Stored Procedure: ssp_SCGetAttendanceScreenFilter                        */
/* Copyright: 2006 Streamline Healthcare Solutions                           */
/* Author: Akwinass                                                         */
/* Creation Date:  April 29,2015                                            */
/* Purpose: To Get Attendance Screen Filter                                 */
/* Input Parameters:@StaffId, @ScreenId                                     */
/* Output Parameters:None                                                   */
/* Return:                                                                  */
/* Calls:                                                                   */
/* Called From:                                                             */
/* Data Modifications:                                                      */
/*                                                                          */
/*-------------Modification History--------------------------               */
/*-------Date-----------Author------------Purpose---------------------------*/
/*       29-APRIL-2015  Akwinass          Created(Task #829 in Woods - Customizations).*/
/****************************************************************************/
BEGIN
	BEGIN TRY
		SELECT StaffId AS StaffId
			,ScreenId AS ScreenId
			,ClientId AS ClientId
			,FiltersXML
		FROM StaffScreenFilters
		WHERE StaffId = @StaffId
			AND ISNULL(RecordDeleted, 'N') = 'N' 
			AND ISNULL(ScreenId,0) = @ScreenId
	END TRY

	BEGIN CATCH
		IF (@@error != 0)
		BEGIN
			RAISERROR 20006 'ssp_SCGetAttendanceScreenFilter: An Error Occured'

			RETURN
		END
	END CATCH
END

GO


