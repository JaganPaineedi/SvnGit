/****** Object:  StoredProcedure [dbo].[ssp_PMCompleteShowServices]    Script Date: 09/18/2015 16:08:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROC [dbo].[ssp_PMCompleteShowServices] @UserCode VARCHAR(30)
AS /*********************************************************************/
/* Stored Procedure: dbo.ssp_PMCompleteShowServices                         */
/* Creation Date:    9/25/06                                         */
/*                                                                   */
/* Purpose:           */
/*                                                                   *//* Input Parameters:						     */
/*                                                                   */
/* Output Parameters:                                                */
/*                                                                   */
/* Return Status:                                                    */
/*                                                                   */
/* Called By:       */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/* Date				Author				Purpose                              */
/* 9/25/06			JHB					Created                             */
/* 31/Jul/2012		Mamta Gupta			Ref Task No. 1861 - To avoid considering unsaved services */
/* 08/04/2015		NJain				Updated to use the Service Completion Lag Days System Configuration key*/
/* 09/18/2015		NJain				Removed the use of Do Not Complete Flag, instead added system config to service selection*/
/*********************************************************************/

    DECLARE @ServiceId INT ,
        @Charge MONEY
    DECLARE @ServiceCompleted CHAR(1)
    DECLARE @ServiceCompletionBatchId INT
    DECLARE @CurrentDate DATETIME

    SET @CurrentDate = GETDATE()

-- 08/04/2015 njain
    --UPDATE  a
    --SET     DoNotComplete = 'Y'
    --FROM    dbo.Services a
    --WHERE   a.Status <> 75
    --        AND DATEDIFF(DAY, a.DateOfService, GETDATE()) <= ( SELECT   Value
    --                                                           FROM     dbo.SystemConfigurationKeys
    --                                                           WHERE    [Key] = 'SERVICECOMPLETIONLAGDAYS'
    --                                                         )
    --        AND ISNULL(a.RecordDeleted, 'N') = 'N'
	
	
-- Mark Non Billable procedures as not billable
    UPDATE  a
    SET     Billable = 'N' ,
            ModifiedBy = @UserCode ,
            ModifiedDate = @CurrentDate
    FROM    Services a
            JOIN ProcedureCodes b ON ( a.ProcedureCodeId = b.ProcedureCodeId )
    WHERE   a.status = 71
            AND b.NotBillable = 'Y'
            AND ISNULL(a.RecordDeleted, 'N') = 'N'
            AND ISNULL(a.DoNotComplete, 'N') = 'N'

    IF @@error <> 0
        GOTO error

    INSERT  INTO ServiceCompletionBatches
            ( RunDate ,
              CreatedBy ,
              CreatedDate ,
              ModifiedBy ,
              ModifiedDate
            )
    VALUES  ( CONVERT(DATETIME, CONVERT(VARCHAR, @CurrentDate, 101)) ,
              @UserCode ,
              @CurrentDate ,
              @UserCode ,
              @CurrentDate
            ) 

    SET @ServiceCompletionBatchId = @@Identity

    IF @ServiceCompletionBatchId < 0
        BEGIN
            RAISERROR 30001 'Invalid Service Completion Batch Id'
            GOTO error
        END

    DECLARE cur_CompleteShowServices CURSOR
    FOR
        SELECT  s.ServiceId ,
                s.Charge
        FROM    Services s
        WHERE   status = 71
                AND ISNULL(s.RecordDeleted, 'N') = 'N'
                AND ISNULL(s.DoNotComplete, 'N') = 'N'
                AND DATEDIFF(DAY, s.DateOfService, GETDATE()) >= ( SELECT   Value
                                                                   FROM     dbo.SystemConfigurationKeys
                                                                   WHERE    [Key] = 'SERVICECOMPLETIONLAGDAYS'
                                                                 )
--Added by Mamta Gupta - Ref Task No. 1861 - To avoid considering unsaved services 
                AND NOT EXISTS ( SELECT UnsavedChangeid
                                 FROM   UnsavedChanges
                                 WHERE  ScreenId = 29
                                        AND ClientId = s.ClientId
                                        AND ScreenProperties LIKE '%<KeyFieldValue>' + CAST(s.ServiceId AS VARCHAR(50)) + '</KeyFieldValue>%' ) 

    IF @@error <> 0
        GOTO error

    OPEN cur_CompleteShowServices

    IF @@error <> 0
        GOTO error

    FETCH cur_CompleteShowServices INTO @ServiceId, @Charge

    IF @@error <> 0
        GOTO error

    WHILE @@fetch_status = 0
        BEGIN

            EXEC ssp_PMServiceComplete @UserCode = @UserCode, @ServiceId = @ServiceId, @ServiceCompleted = @ServiceCompleted OUTPUT
	
            IF @@error <> 0
                GOTO error

            IF @Charge IS NULL
                SELECT  @Charge = Charge
                FROM    Services
                WHERE   ServiceId = @ServiceId

            IF @@error <> 0
                GOTO error

            INSERT  INTO ServiceCompletionBatchServices
                    ( ServiceCompletionBatchId ,
                      ServiceId ,
                      Charge ,
                      CreatedBy ,
                      CreatedDate ,
                      ModifiedBy ,
                      ModifiedDate
                    )
            VALUES  ( @ServiceCompletionBatchId ,
                      @ServiceId ,
                      @Charge ,
                      @UserCode ,
                      @CurrentDate ,
                      @UserCode ,
                      @CurrentDate
                    )
			
            IF @@error <> 0
                GOTO error

            UPDATE  ServiceCompletionBatches
            SET     NumberOfServices = ISNULL(NumberOfServices, 0) + 1 ,
                    TotalCharges = ISNULL(TotalCharges, 0) + ISNULL(@Charge, 0) ,
                    CompletedServices = CASE WHEN @ServiceCompleted = 'Y' THEN ISNULL(CompletedServices, 0) + 1
                                             ELSE CompletedServices
                                        END ,
                    CompletedCharges = CASE WHEN @ServiceCompleted = 'Y' THEN ISNULL(CompletedCharges, 0) + ISNULL(@Charge, 0)
                                            ELSE CompletedCharges
                                       END ,
                    ModifiedDate = GETDATE()
            WHERE   ServiceCompletionBatchId = @ServiceCompletionBatchId

            IF @@error <> 0
                GOTO error

            FETCH cur_CompleteShowServices INTO @ServiceId, @Charge

        END

    CLOSE cur_CompleteShowServices

    IF @@error <> 0
        GOTO error

    DEALLOCATE cur_CompleteShowServices

    IF @@error <> 0
        GOTO error

    RETURN

    error:

    CLOSE cur_CompleteShowServices
    DEALLOCATE cur_CompleteShowServices

GO
