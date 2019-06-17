IF OBJECT_ID('ssp_ListPageCMHospitalizations','P') IS NOT NULL
DROP PROCEDURE [dbo].[ssp_ListPageCMHospitalizations]
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[ssp_ListPageCMHospitalizations]
    @InsurerId INT ,
    @HospitalizationStatus INT ,
    @HospitalizationDays INT ,
    @CaseManagerId INT ,
    @PrescreenFrom DATETIME ,
    @SortExpression VARCHAR(100) ,
    @PrescreenTo DATETIME ,
    @LoggedInUserId INT ,
    @PageNumber INT ,
    @PageSize INT ,
    @OtherFilter INT 
/*********************************************************************             
** Stored Procedure: dbo.ssp_ListPageCMHospitalizations             
**
** Creation Date:  2/20/2014
**             
** Purpose: retrieves data for Hospitalizations screen.           
**             
** Updates:              
**  Date         Author			Purpose 
** 20 FEB 2014	 Rohith uppin	Created	What & why:  Task#5 - Care Management to SmartCare.
** 6  JUN 2014	Rohith Uppin	Column length increased for Status column in temp table to 250.   
** 10 Dec 2014	SuryaBalan      Task #196 CM to SC Issues Hospitalizations list page: Showing clients incorrectly 
** 21 Jan 2015	SuryaBalan      Reverted to Previous Changes Task #196 CM to SC Issues Hospitalizations list page: Showing clients incorrectly 
** FEB-10-2015	dharvey			Moved ViewConcurrentReviews to #ViewConcurrentReviews_Temp temp table to avoid multiple slow runs
** Mar-24-2017  Pradeep Y       Change the Providername column length to max from 100 
								For task #591 CEI- Support Go Live 
**********************************************************************/
AS 
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    BEGIN 
        BEGIN TRY 
            DECLARE @Admitted INT ,
                @Discharged INT ,
                @EventStatusScheduled INT 
			
            SET @Admitted = 2181									--Admitted Status
            SET @Discharged = 2183								--Discharged Status
            SET @EventStatusScheduled = 2061						--Scheduled
            DECLARE @AllStaffInsurer VARCHAR(1)
            SELECT  @AllStaffInsurer = AllInsurers
            FROM    staff
            WHERE   staffid = @LoggedInUserId
            DECLARE @CustomFiltersApplied CHAR(1)
            CREATE TABLE #CustomFilters ( DocumentId INT )
            SET @CustomFiltersApplied = 'N'
		
		 
		  
		  
		  
            CREATE TABLE #ResultSet
                (
                  PrescreenDocumentCodeId INT ,
                  PrescreenScreenId INT ,
                  PrescreenEventId INT ,
                  PrescreenDocumentId INT ,
                  DischargeEventId INT ,
                  DischargeEventTypeId INT ,
                  DischargeDocumentId INT ,
                  DischargeDocumentCodeId INT ,
                  DischargeScreenId INT ,
                  NextConcurrentReviewEventId INT ,
                  NextConcurrentReviewEventTypeId INT ,
                  NextConcurrentReviewDocumentId INT ,
                  NextConcurrentReviewDocumentCodeId INT ,
                  NextConcurrentReviewScreenId INT ,
                  Clientid INT ,
                  Clientname VARCHAR(100) ,
                  Status VARCHAR(250) ,
                  Prescreendatetime DATE ,
                  Providername VARCHAR(max) ,  --Pradeep Y
                  Dischargedatetime DATE ,
                  Nextconcurrentreviewdatetime DATE ,
                  StaffId INT ,
                  Casemanager VARCHAR(100),		  
		        )
		  
--GET CUSTOM FILTERS           
                                                                
            IF @OtherFilter > 10000 
                BEGIN   
                    SET @CustomFiltersApplied = 'Y'

                    INSERT  INTO #CustomFilters
                            ( DocumentId
                            )
                            EXEC scsp_ListPageCMHospitalizations @InsurerId = @InsurerId, @HospitalizationStatus = @HospitalizationStatus, @HospitalizationDays = @HospitalizationDays, @CaseManagerId = @CaseManagerId, @PrescreenFrom = @PrescreenFrom, @PrescreenTo = @PrescreenTo, @LoggedInUserId = @LoggedInUserId, @OtherFilter = @OtherFilter		   
                END		  

			/** dharvey - FEB-10-2015 moved to temp table to avoid multiple slow runs **/
            SELECT  PrescreenEventId ,
                    DateOfConcurrentReview ,
                    HospitalizationStatus ,
                    ConcurrentReviewStatus ,
                    ConcurrentReviewEventId ,
                    ConcurrentReviewEventTypeId ,
                    ConcurrentReviewDocumentId ,
                    ConcurrentReviewDocumentCodeId ,
                    ConcurrentReviewScreenId
            INTO    #ViewConcurrentReviews_Temp
            FROM    ViewConcurrentReviews  
            /** dharvey - FEB-10-2015 moved to temp table to avoid multiple slow runs **/


            INSERT  INTO #ResultSet
                    ( PrescreenDocumentCodeId ,
                      PrescreenScreenId ,
                      PrescreenEventId ,
                      PrescreenDocumentId ,
                      DischargeEventId ,
                      DischargeEventTypeId ,
                      DischargeDocumentId ,
                      DischargeDocumentCodeId ,
                      DischargeScreenId ,
                      NextConcurrentReviewEventId ,
                      NextConcurrentReviewEventTypeId ,
                      NextConcurrentReviewDocumentId ,
                      NextConcurrentReviewDocumentCodeId ,
                      NextConcurrentReviewScreenId ,
                      Clientid ,
                      ClientName ,
                      Status ,
                      PreScreenDateTime ,
                      ProviderName ,
                      DischargeDateTime ,
                      NextConcurrentReviewDateTime ,
                      StaffId ,
                      CaseManager
                    )
                    SELECT  p.PrescreenDocumentCodeId ,
                            p.PrescreenScreenId ,
                            P.PrescreenEventId ,
                            P.PrescreenDocumentId ,
                            p.DischargeEventId ,
                            p.DischargeEventTypeId ,
                            p.DischargeDocumentId ,
                            p.DischargeDocumentCodeId ,
                            p.DischargeScreenId ,
                            cr.ConcurrentReviewEventId AS NextConcurrentReviewEventId ,
                            cr.ConcurrentReviewEventTypeId AS NextConcurrentReviewEventTypeId ,
                            cr.ConcurrentReviewDocumentId AS NextConcurrentReviewDocumentId ,
                            cr.ConcurrentReviewDocumentCodeId AS NextConcurrentReviewDocumentCodeId ,
                            cr.ConcurrentReviewScreenId AS NextConcurrentReviewScreenId ,
                            p.Clientid ,
                            c.Lastname + ',  ' + c.Firstname AS ClientName ,
                            gc.Codename AS Status ,
                            CONVERT(VARCHAR, p.Dateofprescreen, 101) AS PreScreenDateTime ,
                            p.ProviderName ,
                            CASE WHEN p.Hospitalizationstatus = @Discharged THEN CONVERT(VARCHAR, p.Dateofdischarge, 101)
                                 ELSE NULL
                            END AS DischargeDateTime ,
                            CONVERT(VARCHAR, cr.Dateofconcurrentreview, 101) AS NextConcurrentReviewDateTime ,
                            u.StaffId ,
                            u.DisplayAs AS CaseManager
                    FROM    ViewPreScreens p
                            JOIN Clients c ON c.Clientid = p.Clientid
                            JOIN StaffClients SC ON SC.ClientId = C.ClientId
                                                    AND SC.StaffId = @LoggedInUserId
                            JOIN GlobalCodes gc ON p.Hospitalizationstatus = gc.Globalcodeid
                            LEFT JOIN Staff u ON u.StaffId = c.Inpatientcasemanager
                            LEFT JOIN ( SELECT  *
                                        FROM    #ViewConcurrentReviews_Temp cr
                                        WHERE   cr.Hospitalizationstatus = @Admitted
                                                AND cr.Concurrentreviewstatus = @EventStatusScheduled
                                                AND NOT EXISTS ( SELECT *
                                                                 FROM   #ViewConcurrentReviews_Temp cr2
                                                                 WHERE  cr2.Prescreeneventid = cr.Prescreeneventid
                                                                        AND cr2.Hospitalizationstatus = @Admitted
                                                                        AND cr2.Concurrentreviewstatus = @EventStatusScheduled
                                                                        AND cr2.Dateofconcurrentreview < cr.Dateofconcurrentreview )
                                      ) AS cr ON cr.Prescreeneventid = p.Prescreeneventid
                    WHERE   ( ( @CustomFiltersApplied = 'Y'
                                AND EXISTS ( SELECT *
                                             FROM   #CustomFilters cf
                                             WHERE  cf.DocumentId = p.PrescreenDocumentId )
                              )
                              OR ( @CustomFiltersApplied = 'N'
                                   AND ( p.Dateofadmission <= GETDATE()
                                         OR p.Dateofadmission IS NULL
                                       )
                                   AND ( @InsurerId = -1
                                         OR p.Insurerid = @InsurerId
                                       )
                                   AND ( ( p.InsurerId IS NULL
                                           AND @AllStaffInsurer = 'Y'
                                         )
                                         OR EXISTS ( SELECT SI.InsurerId
                                                     FROM   StaffInsurers SI
                                                     WHERE  SI.RecordDeleted <> 'Y'
                                                            AND SI.StaffId = @LoggedInUserId
                                                            AND ( p.InsurerId = SI.InsurerId )
                                                            AND @AllStaffInsurer = 'N' )
                                         OR EXISTS ( SELECT IU.InsurerId
                                                     FROM   Insurers IU
                                                     WHERE  ISNULL(IU.RecordDeleted, 'N') <> 'Y'
                                                            AND ( p.InsurerId = IU.InsurerId )
                                                            AND @AllStaffInsurer = 'Y' )
                                       )
                                   AND ( @HospitalizationStatus = -1
                                         OR p.Hospitalizationstatus = @HospitalizationStatus
                                       )
                                   AND ( @HospitalizationDays = -1
                                         OR CASE WHEN p.Hospitalizationstatus = @Admitted THEN DATEDIFF(dd, p.Dateofadmission, GETDATE())
                                                 WHEN p.Hospitalizationstatus = @Discharged THEN DATEDIFF(dd, p.Dateofadmission, p.Dateofdischarge)
                                                 ELSE 0
                                            END > @HospitalizationDays
                                       )
                                   AND ( @CaseManagerId = 0
                                         OR c.Inpatientcasemanager = @CaseManagerId
                                       )
                                   AND ( @PrescreenFrom IS NULL
                                         OR p.Dateofprescreen >= @PrescreenFrom
                                       )
                                   AND ( @PrescreenTo IS NULL
                                         OR p.Dateofprescreen < DATEADD(dd, 1, @PrescreenTo)
                                       )
                                 )
                            );
                WITH    counts
                          AS ( SELECT   COUNT(*) AS TotalRows
                               FROM     #ResultSet
                             ) ,
                        RankResultSet
                          AS ( SELECT   PrescreenDocumentCodeId ,
                                        PrescreenScreenId ,
                                        PrescreenEventId ,
                                        PrescreenDocumentId ,
                                        DischargeEventId ,
                                        DischargeEventTypeId ,
                                        DischargeDocumentId ,
                                        DischargeDocumentCodeId ,
                                        DischargeScreenId ,
                                        NextConcurrentReviewEventId ,
                                        NextConcurrentReviewEventTypeId ,
                                        NextConcurrentReviewDocumentId ,
                                        NextConcurrentReviewDocumentCodeId ,
                                        NextConcurrentReviewScreenId ,
                                        Clientid ,
                                        ClientName ,
                                        Status ,
                                        PreScreenDateTime ,
                                        ProviderName ,
                                        DischargeDateTime ,
                                        NextConcurrentReviewDateTime ,
                                        StaffId ,
                                        CaseManager ,
                                        COUNT(*) OVER ( ) AS TotalCount ,
                                        RANK() OVER ( ORDER BY CASE WHEN @SortExpression = 'Clientid' THEN Clientid
                                                               END, CASE WHEN @SortExpression = 'Clientid desc' THEN Clientid
                                                                    END DESC, CASE WHEN @SortExpression = 'ClientName' THEN ClientName
                                                                              END, CASE WHEN @SortExpression = 'ClientName desc' THEN ClientName
                                                                                   END DESC, CASE WHEN @SortExpression = 'Status' THEN Status
                                                                                             END, CASE WHEN @SortExpression = 'Status desc' THEN Status
                                                                                                  END DESC, CASE WHEN @SortExpression = 'PreScreenDateTime' THEN PreScreenDateTime
                                                                                                            END, CASE WHEN @SortExpression = 'PreScreenDateTime desc' THEN PreScreenDateTime
                                                                                                                 END DESC, CASE WHEN @SortExpression = 'ProviderName' THEN ProviderName
                                                                                                                           END, CASE WHEN @SortExpression = 'ProviderName desc' THEN ProviderName
                                                                                                                                END DESC, CASE WHEN @SortExpression = 'DischargeDateTime' THEN DischargeDateTime
                                                                                                                                          END, CASE WHEN @SortExpression = 'DischargeDateTime desc' THEN DischargeDateTime
                                                                                                                                               END DESC , CASE WHEN @SortExpression = 'NextConcurrentReviewDateTime' THEN NextConcurrentReviewDateTime
                                                                                                                                                          END, CASE WHEN @SortExpression = 'NextConcurrentReviewDateTime desc' THEN NextConcurrentReviewDateTime
                                                                                                                                                               END DESC, CASE WHEN @SortExpression = 'CaseManager desc' THEN CaseManager
                                                                                                                                                                         END DESC, CASE WHEN @SortExpression = 'CaseManager' THEN CaseManager
                                                                                                                                                                                   END, PrescreenDocumentId ) AS RowNumber
                               FROM     #ResultSet
                             )
                SELECT TOP ( CASE WHEN ( @PageNumber = -1 ) THEN ( SELECT   ISNULL(Totalrows, 0)
                                                                   FROM     Counts
                                                                 )
                                  ELSE ( @PageSize )
                             END )
                        PrescreenDocumentCodeId ,
                        PrescreenScreenId ,
                        PrescreenEventId ,
                        PrescreenDocumentId ,
                        DischargeEventId ,
                        DischargeEventTypeId ,
                        DischargeDocumentId ,
                        DischargeDocumentCodeId ,
                        DischargeScreenId ,
                        NextConcurrentReviewEventId ,
                        NextConcurrentReviewEventTypeId ,
                        NextConcurrentReviewDocumentId ,
                        NextConcurrentReviewDocumentCodeId ,
                        NextConcurrentReviewScreenId ,
                        Clientid ,
                        ClientName ,
                        Status ,
                        PreScreenDateTime ,
                        ProviderName ,
                        DischargeDateTime ,
                        NextConcurrentReviewDateTime ,
                        StaffId ,
                        CaseManager ,
                        TotalCount ,
                        RowNumber
                INTO    #FinalResultSet
                FROM    RankResultSet
                WHERE   RowNumber > ( ( @PageNumber - 1 ) * @PageSize ) 

            IF ( SELECT ISNULL(COUNT(*), 0)
                 FROM   #FinalResultSet
               ) < 1 
                BEGIN 
                    SELECT  0 AS PageNumber ,
                            0 AS NumberOfPages ,
                            0 NumberOfRows 
                END 
            ELSE 
                BEGIN 
                    SELECT TOP 1
                            @PageNumber AS PageNumber ,
                            CASE ( TotalCount % @PageSize )
                              WHEN 0 THEN ISNULL(( TotalCount / @PageSize ), 0)
                              ELSE ISNULL(( TotalCount / @PageSize ), 0) + 1
                            END NumberOfPages ,
                            ISNULL(TotalCount, 0) AS NumberOfRows
                    FROM    #FinalResultSet 
                END
	  
            SELECT  PrescreenDocumentCodeId ,
                    PrescreenScreenId ,
                    PrescreenEventId ,
                    PrescreenDocumentId ,
                    DischargeEventId ,
                    DischargeEventTypeId ,
                    DischargeDocumentId ,
                    DischargeDocumentCodeId ,
                    DischargeScreenId ,
                    NextConcurrentReviewEventId ,
                    NextConcurrentReviewEventTypeId ,
                    NextConcurrentReviewDocumentId ,
                    NextConcurrentReviewDocumentCodeId ,
                    NextConcurrentReviewScreenId ,
                    Clientid ,
                    ClientName ,
                    Status ,
                    CONVERT(VARCHAR, PreScreenDateTime, 101) AS PreScreenDateTime ,
                    ProviderName ,
                    CONVERT(VARCHAR, DischargeDateTime, 101) AS Dischargedatetime ,
                    CONVERT(VARCHAR, NextConcurrentReviewDateTime, 101) AS NextConcurrentReviewDateTime ,
                    StaffId ,
                    CaseManager
            FROM    #FinalResultSet
            ORDER BY Rownumber 
        END TRY 

        BEGIN CATCH 
            DECLARE @Error VARCHAR(8000) 

            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_ListPageCMHospitalizations') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 

            RAISERROR ( @Error, 
                      -- Message text.                                            
                      16,-- Severity.                                            
                      1 -- State.                                            
          ); 
        END CATCH 
    END 



GO


