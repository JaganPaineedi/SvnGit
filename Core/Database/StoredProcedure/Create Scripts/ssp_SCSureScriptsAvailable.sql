
/****** Object:  StoredProcedure [dbo].[ssp_SCSureScriptsAvailable]    Script Date: 10/12/2015 18:09:06 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCSureScriptsAvailable]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCSureScriptsAvailable]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCSureScriptsAvailable]    Script Date: 10/12/2015 18:09:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[ssp_SCSureScriptsAvailable]
    (
      @PharmacyId INT ,
      @PrescriberId INT ,
      @LocationId INT
    )
AS 
    BEGIN TRY

/*********************************************************************/
/* Stored Procedure: dbo. ssp_SCSureScriptsAvailable                      */
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:  07 Sep 2010                                       */
/*                                                                   */
/* Purpose: Determine whether the script(s) can be sent via SureScripts.*/
/*                                                                   */
/* Input Parameters: @UserGuid           */
/*                                                                   */
/* Return:  Data set with one column (SureScriptsAvailable type_YOrN)*/
/*                                                                   */
/* Called By:                                                        */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*  Date        Author         Purpose         */
/* 09/07/2010   Loveena       Created       */
/* 10/31/2010   T Remisoski   Added actual logic.                    */
/* 01/10/2014   K Alpers      Added the "&" instead of hardcoding the service levels */
/* 1/10/2014	CBlaine			Removing Z and T character replacement from Surescripts active end time.  This was causing
								and issue when the active end time was in the month of October due to implicit conversion*/
/* 10/12/2015	T Remisoski	   Pharmacy must have an NPI defined in the SurescriptsPharmacyUpdate table. */
/* Jul/19/2016	Anto	       Modified the SureScriptsPharmacyUpdate.ActiveEndTime in the select query by converting it into MM/DD/YYYY format . */

/*********************************************************************/



        DECLARE @SurescriptsActiveEndTime VARCHAR(50)

        --SELECT  @SurescriptsActiveEndTime = REPLACE(REPLACE(b.ActiveEndTime, -- b.ACTIVE_END_TIME,
        --                                                    'Z', ''), 'T', ' ')
        SELECT  @SurescriptsActiveEndTime = REPLACE(REPLACE(Convert(varchar(50),b.ActiveEndTime,110), 
                                                          'Z', ''), 'T', ' ') + ' ' + CONVERT(CHAR( 5),b.ActiveEndTime,114) 
        
        FROM    Pharmacies AS a
                JOIN dbo.SureScriptsPharmacyUpdate AS b ON NCPDPID = -- SureScriptsDownloadedPharmacies AS b ON b.NCPDP_NO = 
				a.SureScriptsPharmacyIdentifier
        WHERE   a.PharmacyId = @PharmacyId

        IF @SurescriptsActiveEndTime IS NULL 
            BEGIN
				SELECT  'N' AS SureScriptsAvailable
            END
        ELSE 
            BEGIN
   --
   -- convert from UTC to local
   --
                DECLARE @PharmacyActiveEndTime DATETIME2
                SET @PharmacyActiveEndTime = SWITCHOFFSET(TODATETIMEOFFSET(@SurescriptsActiveEndTime,
                                                              0),
                                                          DATEPART(tzoffset,
                                                              SYSDATETIMEOFFSET()))


                IF NOT EXISTS ( SELECT  *
                                FROM    Pharmacies AS a
                                        JOIN dbo.SureScriptsPharmacyUpdate -- SureScriptsDownloadedPharmacies
                                        AS b ON b.NCPDPID = --b.NCPDP_NO = 
										a.SureScriptsPharmacyIdentifier
                                WHERE   PharmacyId = @PharmacyId
                                        AND a.Active = 'Y'
                                        -- 10/12/2015 - added requirement for NPI
                                        AND LEN(LTRIM(RTRIM(ISNULL(b.NPI, '')))) > 0
                                        AND DATEDIFF(minute,
                                                     @PharmacyActiveEndTime,
                                                     GETDATE()) < 0
                                        AND ( ( CAST(b.ServiceLevel -- b.SERVICE_LEVEL 
										AS INT)
                                                & POWER(2, 0) = 1 )
                                              OR ( CAST(b.ServiceLevel -- b.SERVICE_LEVEL 
											  AS INT)
                                                   & POWER(2, 1) = 2 )
                                            )
                                        AND ISNULL(a.RecordDeleted, 'N') <> 'Y' ) 
                    BEGIN
						SELECT  'N' AS SureScriptsAvailable
                    END
                ELSE 
                    IF NOT EXISTS ( SELECT  *
                                    FROM    Staff AS s
                                            JOIN GlobalCodes AS gc ON gc.GlobalCodeId = s.SureScriptsServiceLevel
                                    WHERE   s.StaffId = @PrescriberId
                                            AND s.SureScriptsPrescriberId IS NOT NULL
                                            AND s.SureScriptsLocationId IS NOT NULL
                                            --AND gc.ExternalCode1 IN ('1','3') -- NewRx + Refill Response
											AND ((CAST(gc.ExternalCode1 AS INT) & 1) > 0 OR (CAST(gc.ExternalCode1 AS INT) & 2) > 0)
                                            AND ISNULL(s.RecordDeleted, 'N') <> 'Y' ) 
                        BEGIN
							SELECT  'N' AS SureScriptsAvailable
                        END
                    ELSE 
                        IF NOT EXISTS ( SELECT  *
                                        FROM    Locations AS l
                                        WHERE   l.LocationId = @LocationId
                                                AND l.LocationName IS NOT NULL
                                                AND l.FaxNumber IS NOT NULL
                                                AND ISNULL(l.RecordDeleted,
                                                           'N') <> 'Y' ) 
                            BEGIN
								SELECT  'N' AS SureScriptsAvailable
                            END
                        ELSE 
                            BEGIN
                                SELECT  'Y' AS SureScriptsAvailable
                            END
            END



    END TRY
    BEGIN CATCH
        DECLARE @Error VARCHAR(8000)
        SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
            + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
            + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                     'ssp_SCSureScriptsAvailable') + '*****'
            + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
            + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
            + CONVERT(VARCHAR, ERROR_STATE())

        RAISERROR
 (
  @Error, -- Message text.
  16, -- Severity.
  1 -- State.
 );

    END CATCH










GO


