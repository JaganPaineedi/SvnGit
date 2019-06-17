/****** Object:  StoredProcedure [dbo].[ssp_SCVerifyTimelyAppointment]    Script Date: 03/12/2015 18:17:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCVerifyTimelyAppointment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCVerifyTimelyAppointment]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCVerifyTimelyAppointment]    Script Date: 03/12/2015 18:17:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCVerifyTimelyAppointment] @ClientId INT,
@SearchDate DATETIME,
@ClinicianId INT,
@DateOfServiceAppnt DATETIME,
@Mode VARCHAR(15)
AS
/****************************************************************************/
/* Stored Procedure: ssp_SCVerifyTimelyAppointment                          */
/* Copyright: 2006 Streamlin Healthcare Solutions                           */
/* Author: Akwinass                                                         */
/* Creation Date:  Mar 13,2015                                              */
/* Purpose: Verify Data for Unable to Offer Timely a Appointments  Page        */
/* Input Parameters:      @ClientId, @SearchDate, @ClinicianId, @DateOfServiceAppnt, @Mode*/
/* Output Parameters:None                                                   */
/* Return:                                                                  */
/* Calls:                                                                   */
/* Called From:                                                             */
/* Data Modifications:                                                      */
/*                                                                          */
/*-------------Modification History--------------------------               */
/*-------Date-----------Author------------Purpose---------------------------*/
/*       13-MAR-2015    Akwinass          Created(Task #906 in Valley - Customizations).*/
/*       18-MAR-2015    Akwinass          Unable to Offer a Timely Appt.(Task #906 in Valley - Customizations).*/
/*       26-May-2015    Venkatesh MR      Fixed the issue which always giving the exception pop up.(Task #70 in VCAT Issues).*/
/****************************************************************************/
BEGIN
	BEGIN TRY		
		CREATE TABLE #Inquiries(InquiryDateTime DATETIME,DateOfRequest DATETIME, UrgencyLevel INT)
		CREATE TABLE #TimelyAppointment(UrgencyLevel INT,InquiryDateTime DATETIME,IsCompleted VARCHAR(20))
					
		DECLARE @DateOfRequest DATETIME
		DECLARE @InquiryDateTime DATETIME
		DECLARE @UrgencyLevel INT	
			
		IF @Mode = 'Schedule'
		BEGIN
			DECLARE @NeverDisplay CHAR(1)
			DECLARE @DisplayAllTheTime CHAR(1)
			DECLARE @DisplayOneTime CHAR(1)
			
			SELECT TOP 1 @NeverDisplay = Value FROM SystemConfigurationKeys WHERE [key] = 'NeverDisplayTimelyAppointmentPopupAtAll'
			IF ISNULL(@NeverDisplay,'N') = 'Y'
			BEGIN
				GOTO NOTDisplay
			END
			
			SELECT TOP 1 @DisplayAllTheTime = Value FROM SystemConfigurationKeys WHERE [key] = 'DisplayTimelyAppointmentPopupAllTheTime'
			IF ISNULL(@DisplayAllTheTime,'N') = 'Y'
			BEGIN
				GOTO VerifyTimelyAppt
			END
			
			SELECT TOP 1 @DisplayOneTime = Value FROM SystemConfigurationKeys WHERE [key] = 'DoNotDisplayTheTimelyAppointmentPopupAfterFirstScheduledAppointment'
			IF ISNULL(@DisplayOneTime,'N') = 'Y'
			BEGIN
				DECLARE @Scheduled INT
				DECLARE @ScheduledCount INT
				
				SELECT TOP 1 @Scheduled = GlobalCodeId
				FROM GlobalCodes
				WHERE Category = 'SERVICESTATUS'
					AND CodeName = 'Scheduled'

				SELECT @ScheduledCount = COUNT(*)
				FROM Services
				WHERE ClientId = @ClientId
					AND ClinicianId = @ClinicianId
					AND ISNULL(RecordDeleted, 'N') = 'N'
					AND [Status] = @Scheduled
					AND CAST(DateOfService AS DATE) = CAST(@DateOfServiceAppnt AS DATE)

				IF @ScheduledCount = 0
				BEGIN
					GOTO VerifyTimelyAppt
				END
				ELSE
				BEGIN
					GOTO NOTDisplay
				END
			END
		
		
			VerifyTimelyAppt:
				
			DECLARE @RecodeCategoryId INT
			DECLARE @RecodeHours INT
			DECLARE @TimelyAppointmentHours INT        
	        
			SELECT TOP 1 @RecodeCategoryId = RecodeCategoryId
			FROM RecodeCategories
			WHERE CategoryCode = 'TimelyAppointment'
				AND ISNULL(RecordDeleted, 'N') = 'N'

			SELECT @RecodeHours = MAX(IntegerCodeId)
			FROM Recodes
			WHERE RecodeCategoryId = @RecodeCategoryId
				AND ISNULL(RecordDeleted, 'N') = 'N'
				
			IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCVerifyTimelyAppointment]') AND type in (N'P', N'PC'))
			BEGIN
				INSERT INTO #Inquiries(InquiryDateTime,DateOfRequest,UrgencyLevel)
				EXEC csp_SCVerifyTimelyAppointment @ClientId
				
			END
			
			SELECT TOP 1 @InquiryDateTime = InquiryDateTime, @DateOfRequest = DateOfRequest, @UrgencyLevel = UrgencyLevel FROM #Inquiries
			
			IF @UrgencyLevel IS NOT NULL
			BEGIN
				SELECT @RecodeHours = IntegerCodeId
				FROM Recodes R
				WHERE RecodeCategoryId = @RecodeCategoryId
					AND ISNULL(RecordDeleted, 'N') = 'N' AND CodeName =(select top 1 CodeName from GlobalCodes where GlobalCodeId = @UrgencyLevel AND Active='Y' AND ISNULL(RecordDeleted, 'N') = 'N')
			END
				
			IF @DateOfServiceAppnt IS NOT NULL AND @InquiryDateTime IS NOT NULL
			BEGIN	
				IF NOT EXISTS(SELECT * FROM ClientAppointmentsUnableToOfferTimely WHERE ClientId = @ClientId AND ISNULL(RecordDeleted,'N') = 'N' AND CONVERT(VARCHAR(20), DateOfRequest, 0) = CONVERT(VARCHAR(20), @DateOfRequest, 0))
				BEGIN	    
					IF @DateOfServiceAppnt > @InquiryDateTime
					BEGIN			
						SELECT @TimelyAppointmentHours = DATEDIFF(HOUR,@InquiryDateTime,@DateOfServiceAppnt)
						
						IF @TimelyAppointmentHours > @RecodeHours
						BEGIN
							INSERT INTO #TimelyAppointment(UrgencyLevel,InquiryDateTime,IsCompleted)
							VALUES(@UrgencyLevel,@DateOfRequest,'NOT COMPLETED')
						END
					END
				END	
				ELSE
				BEGIN
					INSERT INTO #TimelyAppointment(UrgencyLevel,InquiryDateTime,IsCompleted)
					VALUES(NULL,NULL,'COMPLETED')
				END		
			END
		END
		ELSE IF @Mode = 'Timely Appt'
		BEGIN
			IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCVerifyTimelyAppointment]') AND type in (N'P', N'PC'))
			BEGIN
				INSERT INTO #Inquiries(InquiryDateTime,DateOfRequest,UrgencyLevel)
				EXEC csp_SCVerifyTimelyAppointment @ClientId
			END
			SELECT TOP 1 @InquiryDateTime = InquiryDateTime, @DateOfRequest = DateOfRequest, @UrgencyLevel = UrgencyLevel FROM #Inquiries
			
			IF @DateOfRequest IS NOT NULL
			BEGIN
				INSERT INTO #TimelyAppointment(UrgencyLevel,InquiryDateTime,IsCompleted)
				VALUES(@UrgencyLevel,@DateOfRequest,'NOT COMPLETED')
			END
		END
		
		NOTDisplay:
		
		SELECT UrgencyLevel,InquiryDateTime,IsCompleted FROM #TimelyAppointment
		
		DROP TABLE #Inquiries
		DROP TABLE #TimelyAppointment
	END TRY

	BEGIN CATCH
		IF (@@error != 0)
		BEGIN
			RAISERROR 20006 'ssp_SCVerifyTimelyAppointment: An Error Occured'

			RETURN
		END
	END CATCH
END

GO


