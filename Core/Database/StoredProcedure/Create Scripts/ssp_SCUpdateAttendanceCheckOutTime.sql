/****** Object:  StoredProcedure [dbo].[ssp_SCUpdateAttendanceCheckOutTime]    Script Date: 06/02/2015 16:46:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCUpdateAttendanceCheckOutTime]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCUpdateAttendanceCheckOutTime]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCUpdateAttendanceCheckOutTime]    Script Date: 06/02/2015 16:46:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCUpdateAttendanceCheckOutTime] 
	@UserCode VARCHAR(30)
	,@ServiceId INT
	,@DateTimeOut VARCHAR(30)
AS
/****************************************************************************/
/* Stored Procedure: ssp_SCUpdateAttendanceCheckOutTime                     */
/* Copyright: 2006 Streamline Healthcare Solutions                          */
/* Author: Akwinass                                                         */
/* Creation Date:  April 29,2015                                            */
/* Purpose: To update Check Out Time in Services                            */
/* Input Parameters:@UserCode,@ServiceId                                    */
/* Output Parameters:None                                                   */
/* Return:                                                                  */
/* Calls:                                                                   */
/* Called From:                                                             */
/* Data Modifications:                                                      */
/*                                                                          */
/*-------------Modification History--------------------------               */
/*-------Date-----------Author------------Purpose---------------------------*/
/*       29-APRIL-2015  Akwinass          Created(Task #829.09 in Woods - Customizations).*/
/*       22-Feb-2016	Akwinass	      What: Update Script Included to update DateOfService and EndDateOfService.
							              Why:task #167 Valley - Support Go Live*/
/****************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @CheckedOut DATETIME
		DECLARE @ClientId INT
		DECLARE @GroupServiceId INT

		SELECT TOP 1 @ClientId=ClientId, @GroupServiceId=GroupServiceId, @CheckedOut = CAST(CONVERT(VARCHAR(10), DateTimeIn, 101) + ' ' + @DateTimeOut AS DATETIME)
		FROM Services
		WHERE ServiceId = @ServiceId
			AND isnull(RecordDeleted, 'N') = 'N'

		UPDATE Services
		SET DateTimeOut = @CheckedOut
			,ModifiedBy = @UserCode
			,ModifiedDate = GETDATE()
		WHERE ServiceId = @ServiceId
			AND isnull(RecordDeleted, 'N') = 'N'
		
		--22-Feb-2016	Akwinass	
		UPDATE Services
		SET DateOfService = DateTimeIn
			,EndDateOfService = DateTimeOut
			,Unit = dbo.[ssf_SCCalculateAttendanceUnits](DateTimeIn, DateTimeOut, Unit, UnitType)
			,ModifiedBy = @UserCode
			,ModifiedDate = GETDATE()
		WHERE ServiceId = @ServiceId
			AND isnull(RecordDeleted, 'N') = 'N'			
			
		DECLARE @DateOfService DATETIME ,
                @ClinicianId INT ,
                @ProcedureCodeId INT ,
                @Units INT ,
                @ProgramId INT ,
                @LocationId INT ,                
                @ProcedureRateId INT ,
                @Charge MONEY
                
		SELECT TOP 1 @ClientId = ClientId			
			,@DateOfService = DateOfService
			,@ClinicianId = ClinicianId
			,@ProcedureCodeId = ProcedureCodeId
			,@Units = Unit
			,@ProgramId = ProgramId
			,@LocationId = LocationId
		FROM Services
		WHERE ServiceId = @ServiceId
			AND isnull(RecordDeleted, 'N') = 'N'
			
		EXEC dbo.ssp_PMServiceCalculateCharge @ClientId = @ClientId
			,@DateOfService = @DateOfService
			,@ClinicianId = @ClinicianId
			,@ProcedureCodeId = @ProcedureCodeId
			,@Units = @Units
			,@ProgramId = @ProgramId
			,@LocationId = @LocationId
			,@ProcedureRateId = @ProcedureRateId OUTPUT
			,@Charge = @Charge OUTPUT
			
		UPDATE Services
		SET ProcedureRateId = @ProcedureRateId
			,Charge = @Charge
			,ModifiedBy = @UserCode
			,ModifiedDate = GETDATE()
		WHERE ServiceId = @ServiceId
			AND isnull(RecordDeleted, 'N') = 'N'		
			
		IF NOT EXISTS (
				SELECT TOP 1 S.DateOfService
				FROM Services S
				WHERE S.ClientId = @ClientId
					AND S.GroupServiceId = @GroupServiceId
					AND ISNULL(S.RecordDeleted, 'N') = 'N'
					AND S.DateTimeOut IS NULL
				)
		BEGIN
			SELECT TOP 1 S.DateTimeOut
			FROM Services S
			WHERE S.ClientId = @ClientId
				AND S.GroupServiceId = @GroupServiceId
				AND ISNULL(S.RecordDeleted, 'N') = 'N'
			ORDER BY S.DateTimeOut DESC
		END
		ELSE
		BEGIN
			SELECT TOP 0 NULL AS DateTimeOut
		END
		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' 
		+ Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' 
		+ isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCUpdateAttendanceCheckOutTime')
		 + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' 
		 + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


