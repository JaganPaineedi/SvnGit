IF OBJECT_ID('ssp_ListPageCMClientAuthorizations','P') IS NOT NULL
DROP PROCEDURE [dbo].[ssp_ListPageCMClientAuthorizations]
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO                                           


CREATE PROCEDURE [dbo].[ssp_ListPageCMClientAuthorizations]
    @SessionId VARCHAR(30) ,
    @InstanceId INT ,
    @PageNumber INT ,
    @PageSize INT ,
    @SortExpression VARCHAR(100) ,
    @InsurerId INT ,
    @ProviderId INT ,
    @BillingCodeId INT ,
    @Status VARCHAR(5) ,
    @EffectiveAsOf DATE ,
    @ClientID INT ,
    @LoggedinStaffId INT ,
    @otherFilter INT
AS /*                              
*********************************************************************/
/* Stored Procedure: ssp_MembersAuthorizations            */
/* Copyright: 2005 Provider Claim Management System             */
/* Creation Date:  12/18/2005                                    */
/*                                                                   */
/* Purpose: it will returns detail of the user logged in             */
/*                                                                   */
/* Input Parameters:          */
/*                                                                   */
/* Output Parameters:                                */
/*                                                                   */
/* Return:Roles of the user  */
/*                                                                   */
/* Called By:                                                        */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:   04/25/2006                                                       */
/*                                  
/*Modified By Deep Kumar                                */                                      
/* 04/25/2008  Ryan Noble  Added conditional select for PA authorizations. */                              
/* As the authorizations utilize different fields from CM authorizations.   */                              
/* i.e. UnitsRequested for CM, TotalUnitsRequested for PA.       */                              
/* 09/17/2010  Shifali for adding master client relation. */                                
   /*27/4/2011  Priya Redesign */                   
/* 7 Sep 2011   Sourabh Get events according to master and clientid */                
/*12 Oct 2011 Pradeep  Made changes to remove ProviderAuthorizations.RowIdentifier and added Rational fielsd in select */                            
/*9 Dec 2012 Sourabh  Made changes to remove Rationale feild from ProviderAuthorizations and add Rowidentifier column*/              
/*12 July 2012 Sourabh  Made changes to display UnitsRequested instead of TotalUnitsRequested wrt#1807 Kalamazoo Bugs-Go Live*/              
/* 8th August Chnages made by Surinder to display Totalunits value in Cm Task # 1862 in Kalamazoo Go Live */            
/*8th Sept 2012 Vikesh ref task #1958 CM/PA: Auth amount different in PA than in CM*/            
--03/Jan/2013 Merged by sanjay w.r.t 24/Dec/2012 Modified By Mamta Gupta - Ref Task 333 - 3.x Issues - To get records according to MasterClientId      
--16-May-2014 Created by SuryaBalan for the task #35 CM to SC and the changed the Procedure Name to       
--28-May-2014 task #35 CM to SC Fixed Active filter dropdown issue        
--14-0702014 Appealed and Rowidentifier removed for task #15 CM to SC      
--05-Aug-2014 scsp call has been added for otherfilter and EffectiveAsOf used for start / end date condition ref to task #35 CM to SC      
-- 20.08.2014  Manju P   Removed the parameter Active         Ref #35 CM to SC.   
---09.10.2014  Vichee    Modified to get Checkbox column  CM to Sc #35   
--03-Nov-2014 SuryaBalan Task #35 Project:Woods - Customizations. CM Client Authorizations - Missing Insurer column
--18/11/2014  Shruthi.S  Added RequestedBillingCodeid for requested status.Ref #15.05 Care Management to SmartCare Env. Issues Tracking.
--26/12/2014  Arjun K R  Condition is removed which check ProviderAuthorization Endate with EffectiveAsOf date.
--01.Jan.2014	Rohith Uppin	StaffClients INNER Join added. Task#330 CM to SC issues tracking.
--26/02/2015   Shruthi.S  Modified as per discussion with Slavik.For both SA and MH providers if auth status is requested then TotalUnitsRequested will be units approved else TotalUnitsApproved. Ref #545 Env Issues.
--6/03/2015		RQuigley	Replaced PA.RequestedBillingCodeId with ISNULL(PA.BillingCodeId,PA.RequestedBillingCodeId)
--									to return approved MH authorizations
-- 22.May.2017  Msood		What: Replaced NULL values with 'N'  for @AllStaffInsurer and @AllStaffProvider
--							Why: Allegan - Support Task#1016 for not displaying the records in list page if Staff.AllProviders and Staff.AllInsurers is NULL

--------------------------------------------------------------------------- */
    BEGIN
        BEGIN TRY
            DECLARE @MasterClientId INT
            DECLARE @Insurers TABLE ( InsurerId INT )
            DECLARE @Clients TABLE ( ClientId INT )
            DECLARE @MasterRecord CHAR(1)

            DECLARE @AllStaffInsurer VARCHAR(1)
            DECLARE @AllStaffProvider VARCHAR(1)
           
		-- Msood 05/22/2017
		SELECT  @AllStaffInsurer = ISNULL(AllInsurers,'N') FROM staff WHERE staffid=@LoggedInStaffId
		SELECT  @AllStaffProvider = ISNULL(AllProviders, 'N') From Staff where staffid=@LoggedInStaffId
            SELECT  @MasterClientId = MasterClientId ,
                    @MasterRecord = ISNULL(MasterRecord, 'N')
            FROM    Clients --INNER JOIN StaffClients ON StaffClients.ClientId = Clients.ClientId and StaffClients.StaffID = @LoggedInStaffId
                    LEFT JOIN ProviderClients ON ProviderClients.ClientId = Clients.ClientId
            WHERE   Clients.ClientId = @ClientId
                    AND ISNULL(ProviderClients.RecordDeleted, 'N') = 'N'
                    AND EXISTS ( SELECT 1
                                 FROM   StaffClients sc
                                 WHERE  sc.ClientId = Clients.ClientId )

            IF @MasterClientId IS NULL 
                SET @MasterClientId = @ClientId

            INSERT  INTO @Insurers
                    ( InsurerId
                    )
                    SELECT  i.InsurerId
                    FROM    Insurers i
                            CROSS JOIN Staff u
                    WHERE   u.StaffId = @LoggedinStaffId
                            AND u.AllInsurers = 'Y'
                            AND ISNULL(i.RecordDeleted, 'N') = 'N'
                    UNION
                    SELECT  i.InsurerId
                    FROM    Insurers i
                            INNER JOIN StaffInsurers ui ON ui.InsurerId = i.InsurerId
                    WHERE   ui.StaffId = @LoggedinStaffId
                            AND ISNULL(i.RecordDeleted, 'N') = 'N'
                            AND ISNULL(ui.RecordDeleted, 'N') = 'N'

            IF ( @MasterRecord = 'Y' ) 
                BEGIN
                    INSERT  INTO @Clients
                            ( ClientId
                            )
                            SELECT  c.ClientId
                            FROM    Clients c
                                    INNER JOIN StaffClients SC ON SC.ClientId = c.ClientId
                                                                  AND SC.StaffID = @LoggedInStaffId
                                    INNER JOIN ProviderClients pc ON pc.ClientId = c.ClientId
                                    INNER JOIN ProviderInsurers pin ON pin.ProviderId = pc.ProviderId
                                    INNER JOIN @Insurers i ON i.InsurerId = pin.InsurerId
                            WHERE   pc.MasterClientId = @MasterClientId
                                    AND ISNULL(pc.RecordDeleted, 'N') = 'N'
                                    AND ISNULL(pin.RecordDeleted, 'N') = 'N'
                                    AND ISNULL(c.RecordDeleted, 'N') = 'N'
                            UNION
                            SELECT  @MasterClientId
                            UNION
                            SELECT  @ClientId
                END
            ELSE 
                BEGIN
                    INSERT  INTO @Clients
                            ( ClientId )
                            SELECT  @ClientId
                END

            CREATE TABLE #CustomFilters
                (
                  ProviderAuthorizationId INT NOT NULL
                )

            DECLARE @ApplyFilterClicked CHAR(1)
            DECLARE @CustomFiltersApplied CHAR(1)

            SET @SortExpression = RTRIM(LTRIM(@SortExpression))

            IF ISNULL(@SortExpression, '') = '' 
                SET @SortExpression = 'ProviderName'
            SET @ApplyFilterClicked = 'Y'
            SET @CustomFiltersApplied = 'N'

            IF @otherFilter > 10000 
                BEGIN
                    SET @CustomFiltersApplied = 'Y'

                    INSERT  INTO #CustomFilters
                            ( ProviderAuthorizationId
                            )
                            EXEC scsp_ListPageCMClientAuthorizations @InsurerId = @InsurerId, @ProviderId = @ProviderId, @BillingCodeId = @BillingCodeId, @Status = @Status, @EffectiveAsOf = @EffectiveAsOf, @ClientID = @ClientID, @LoggedinStaffId = @LoggedinStaffId, @otherFilter = @otherFilter
                END;

            WITH    CMClientAuthorizations
                      AS ( SELECT   '0' AS 'CheckBox' ,
                                    dbo.ProviderAuthorizations.ProviderAuthorizationId ,
                                    dbo.Providers.ProviderName ,
                                    dbo.Sites.SiteName ,
                                    dbo.BillingCodes.BillingCode + ' ' + ISNULL(dbo.ProviderAuthorizations.Modifier1, '') + ' ' + ISNULL(dbo.ProviderAuthorizations.Modifier2, '') + ' ' + ISNULL(dbo.ProviderAuthorizations.Modifier3, '') + ' ' + ISNULL(dbo.ProviderAuthorizations.Modifier4, '') AS BillingCode ,
                                    dbo.ProviderAuthorizations.AuthorizationNumber ,
                                    dbo.GlobalCodes.CodeName AS STATUS ,
                                    CASE WHEN ( ProviderAuthorizations.[Status] = 2041 ) THEN CONVERT(INT, ISNULL(ProviderAuthorizations.TotalUnitsRequested, 0))
                                         ELSE CONVERT(INT, ISNULL(ProviderAuthorizations.TotalUnitsApproved, 0))
                                    END AS UnitsApproved ,
                                    dbo.ProviderAuthorizations.UnitsUsed ,
                                    CASE WHEN ( ProviderAuthorizations.STATUS = 2041 ) THEN ProviderAuthorizations.StartDateRequested
                                         ELSE ProviderAuthorizations.StartDate
                                    END AS StartDate ,
                                    CASE WHEN ( ProviderAuthorizations.STATUS = 2041 ) THEN ProviderAuthorizations.EndDateRequested
                                         ELSE ProviderAuthorizations.EndDate
                                    END AS EndDate ,
                                    dbo.ProviderAuthorizations.ProviderId ,
                                    dbo.ProviderAuthorizations.SiteId ,
                                    dbo.ProviderAuthorizations.BillingCodeId ,
                                    dbo.ProviderAuthorizations.ClientId ,
                                    dbo.Clients.LastName ,
                                    dbo.Clients.FirstName ,
                                    dbo.ProviderAuthorizations.Active ,
                                    dbo.GlobalCodes.GlobalCodeId ,
                                    ProviderAuthorizations.InsurerId ,
                                    Insurers.InsurerName AS 'InsurerName' ,
                                    dbo.ProviderAuthorizations.STATUS AS StatusId ,
                                    dbo.ProviderAuthorizations.StartDateRequested ,
                                    dbo.ProviderAuthorizations.EndDateRequested ,
                                    dbo.ProviderAuthorizations.CreatedBy ,
                                    dbo.ProviderAuthorizations.CreatedDate ,
                                    dbo.ProviderAuthorizations.ModifiedBy ,
                                    dbo.ProviderAuthorizations.ModifiedDate ,
                                    dbo.ProviderAuthorizations.RecordDeleted ,
                                    dbo.ProviderAuthorizations.ProviderAuthorizationDocumentId ,
                                    dbo.ProviderAuthorizations.DeletedDate ,
                                    dbo.ProviderAuthorizations.DeletedBy ,
                                    dbo.ProviderAuthorizations.Reason ,
                                    CASE WHEN ProviderAuthorizations.InsurerId = @InsurerId THEN CONVERT(INT, ProviderAuthorizations.TotalUnitsRequested)
                                         ELSE dbo.ProviderAuthorizations.UnitsRequested
                                    END AS 'UnitsRequested' ,
                                    dbo.ProviderAuthorizations.Comment
                           FROM     dbo.ProviderAuthorizations
                                    INNER JOIN dbo.Clients ON dbo.ProviderAuthorizations.ClientId = dbo.Clients.ClientId
                                    INNER JOIN dbo.Providers ON dbo.ProviderAuthorizations.ProviderId = dbo.Providers.ProviderId
                                    LEFT JOIN dbo.Sites ON dbo.ProviderAuthorizations.SiteId = dbo.Sites.SiteId
                                                           AND ISNULL(Sites.recorddeleted, 'N') = 'N'
                                    INNER JOIN dbo.BillingCodes ON dbo.BillingCodes.BillingCodeId = ISNULL(ProviderAuthorizations.BillingCodeId, ProviderAuthorizations.RequestedBillingCodeId)
                                    INNER JOIN Insurers ON ProviderAuthorizations.InsurerId = Insurers.InsurerId
                                    LEFT JOIN dbo.GlobalCodes ON dbo.GlobalCodes.GlobalCodeId = dbo.ProviderAuthorizations.STATUS
                                                                 AND ISNULL(GlobalCodes.recorddeleted, 'N') = 'N'
                                    INNER JOIN @Clients c ON c.ClientId = ProviderAuthorizations.ClientId
                           WHERE    ISNULL(Clients.recorddeleted, 'N') = 'N'
                                    AND ISNULL(Providers.recorddeleted, 'N') = 'N'
                                    AND ISNULL(BillingCodes.recorddeleted, 'N') = 'N'
                                    AND ISNULL(Insurers.recorddeleted, 'N') = 'N'
                                    AND ISNULL(ProviderAuthorizations.recorddeleted, 'N') = 'N'
                                    AND ( ( @CustomFiltersApplied = 'Y'
                                            AND EXISTS ( SELECT *
                                                         FROM   #CustomFilters cf
                                                         WHERE  cf.ProviderAuthorizationId = ProviderAuthorizations.ProviderAuthorizationId )
                                          )
                                          OR ( @CustomFiltersApplied = 'N'
                                               AND ( @InsurerId = -1
                                                     OR ProviderAuthorizations.InsurerId = @InsurerId
                                                   )
                                               AND ( @ProviderId = -1
                                                     OR ProviderAuthorizations.ProviderId = @ProviderId
                                                   )
                                               AND ( EXISTS ( SELECT    SI.InsurerId
                                                              FROM      StaffInsurers SI
                                                              WHERE     ISNULL(RecordDeleted, 'N') <> 'Y'
                                                                        AND SI.StaffId = @LoggedinStaffId
                                                                        AND ProviderAuthorizations.InsurerId = SI.InsurerId
                                                                        AND @AllStaffInsurer = 'N' )
                                                     OR EXISTS ( SELECT InsurerId I
                                                                 FROM   Insurers I
                                                                 WHERE  ISNULL(RecordDeleted, 'N') <> 'Y'
                                                                        AND ProviderAuthorizations.InsurerId = I.InsurerId
                                                                        AND @AllStaffInsurer = 'Y' )
                                                   )
                                               AND ( EXISTS ( SELECT    SP.ProviderId
                                                              FROM      StaffProviders SP
                                                              WHERE     ISNULL(RecordDeleted, 'N') <> 'Y'
                                                                        AND SP.StaffId = @LoggedinStaffId
                                                                        AND ProviderAuthorizations.ProviderId = SP.ProviderId
                                                                        AND @AllStaffProvider = 'N' )
                                                     OR EXISTS ( SELECT ProviderId P
                                                                 FROM   Providers P
                                                                 WHERE  ISNULL(RecordDeleted, 'N') <> 'Y'
                                                                        AND ProviderAuthorizations.ProviderId = P.ProviderId
                                                                        AND @AllStaffProvider = 'Y' )
                                                   )
                                               AND ( @BillingCodeId = -1
                                                     OR CASE WHEN ProviderAuthorizations.STATUS = 2042 THEN dbo.ProviderAuthorizations.BillingCodeId
                                                             ELSE dbo.ProviderAuthorizations.RequestedBillingCodeId
                                                        END = @BillingCodeId
                                                   )
                                               AND ( @EffectiveAsOf = ''
                                                     OR ( ProviderAuthorizations.[StartDate] >= @EffectiveAsOf
								--AND ProviderAuthorizations.[EndDate] >= @EffectiveAsOf
                                                          )
                                                   )
                                               AND ( @Status = -1
                                                     OR ProviderAuthorizations.[Status] = @Status
                                                   )
                                             )
                                        )
                         ) ,
                    counts
                      AS ( SELECT   COUNT(*) AS totalrows
                           FROM     CMClientAuthorizations
                         ) ,
                    RankResultSet
                      AS ( SELECT   CheckBox ,
                                    ProviderAuthorizationId ,
                                    ProviderName ,
                                    SiteName ,
                                    BillingCode ,
                                    AuthorizationNumber ,
                                    STATUS ,
                                    UnitsApproved ,
                                    UnitsUsed ,
				--StartDate ,  
                                    CONVERT(VARCHAR(10), StartDate, 101) AS StartDate ,
				--EndDate, 
                                    CONVERT(VARCHAR(10), EndDate, 101) AS EndDate ,
                                    ProviderId ,
                                    SiteId ,
                                    BillingCodeId ,
                                    ClientId ,
                                    LastName ,
                                    FirstName ,
                                    Active ,
                                    GlobalCodeId ,
                                    InsurerId ,
                                    InsurerName ,
                                    StatusId ,
				--StartDateRequested,   
                                    CONVERT(VARCHAR(10), StartDateRequested, 101) AS StartDateRequested ,
				--EndDateRequested, 
                                    CONVERT(VARCHAR(10), EndDateRequested, 101) AS EndDateRequested ,
                                    CreatedBy ,
                                    CreatedDate ,
                                    ModifiedBy ,
                                    ModifiedDate ,
                                    RecordDeleted ,
                                    ProviderAuthorizationDocumentId ,
                                    DeletedDate ,
                                    DeletedBy ,
                                    Reason ,
                                    UnitsRequested ,
                                    Comment ,
                                    COUNT(*) OVER ( ) AS TotalCount ,
                                                    RANK() OVER ( ORDER BY CASE WHEN @SortExpression = 'ProviderAuthorizationId' THEN ISNULL(ProviderAuthorizationId, '')
                                                                           END
						, CASE WHEN @SortExpression = 'ProviderAuthorizationId DESC' THEN ISNULL(ProviderAuthorizationId, '')
                          END DESC
						, CASE WHEN @SortExpression = 'ProviderName' THEN ISNULL(ProviderName, '')
                          END
						, CASE WHEN @SortExpression = 'ProviderName DESC' THEN ISNULL(ProviderName, '')
                          END DESC
						, CASE WHEN @SortExpression = 'SiteName' THEN ISNULL(SiteName, '')
                          END
						, CASE WHEN @SortExpression = 'SiteName DESC' THEN ISNULL(SiteName, '')
                          END DESC
						, CASE WHEN @SortExpression = 'BillingCode' THEN ISNULL(BillingCode, '')
                          END
						, CASE WHEN @SortExpression = 'BillingCode DESC' THEN ISNULL(BillingCode, '')
                          END DESC
						, CASE WHEN @SortExpression = 'AuthorizationNumber' THEN ISNULL(BillingCode, '')
                          END
						, CASE WHEN @SortExpression = 'AuthorizationNumber DESC' THEN ISNULL(BillingCode, '')
                          END DESC
						, CASE WHEN @SortExpression = 'Status' THEN ISNULL(STATUS, '')
                          END
						, CASE WHEN @SortExpression = 'Status DESC' THEN ISNULL(STATUS, '')
                          END DESC
						, CASE WHEN @SortExpression = 'UnitsApproved' THEN ISNULL(UnitsApproved, '')
                          END
						, CASE WHEN @SortExpression = 'UnitsApproved DESC' THEN ISNULL(UnitsApproved, '')
                          END DESC
						, CASE WHEN @SortExpression = 'UnitsUsed' THEN ISNULL(UnitsUsed, '')
                          END
						, CASE WHEN @SortExpression = 'UnitsUsed DESC' THEN ISNULL(UnitsUsed, '')
                          END DESC
						, CASE WHEN @SortExpression = 'StartDate' THEN ISNULL(StartDate, '')
                          END
						, CASE WHEN @SortExpression = 'StartDate DESC' THEN ISNULL(StartDate, '')
                          END DESC
						, CASE WHEN @SortExpression = 'EndDate' THEN ISNULL(EndDate, '')
                          END
						, CASE WHEN @SortExpression = 'EndDate DESC' THEN ISNULL(EndDate, '')
                          END DESC
						, CASE WHEN @SortExpression = 'InsurerName' THEN ISNULL(InsurerName, '')
                          END
						, CASE WHEN @SortExpression = 'InsurerName DESC' THEN ISNULL(InsurerName, '')
                          END DESC
						, ProviderAuthorizationId ) AS RowNumber
                           FROM                     CMClientAuthorizations
                         )
                SELECT TOP ( CASE WHEN ( @PageNumber = -1 ) THEN ( SELECT   ISNULL(totalrows, 0)
                                                                   FROM     counts
                                                                 )
                                  ELSE ( @PageSize )
                             END )
                        CheckBox ,
                        ProviderAuthorizationId ,
                        ProviderName ,
                        SiteName ,
                        BillingCode ,
                        AuthorizationNumber ,
                        STATUS ,
                        UnitsApproved ,
                        UnitsUsed ,
                        StartDate ,
                        EndDate ,
                        ProviderId ,
                        SiteId ,
                        BillingCodeId ,
                        ClientId ,
                        LastName ,
                        FirstName ,
                        Active ,
                        GlobalCodeId ,
                        InsurerId ,
                        InsurerName ,
                        StatusId ,
			--StartDateRequested, 
                        CONVERT(VARCHAR(10), StartDateRequested, 101) AS StartDateRequested ,
			--EndDateRequested,      
                        CONVERT(VARCHAR(10), EndDateRequested, 101) AS EndDateRequested ,
                        CreatedBy ,
                        CreatedDate ,
                        ModifiedBy ,
                        ModifiedDate ,
                        RecordDeleted ,
                        ProviderAuthorizationDocumentId ,
                        DeletedDate ,
                        DeletedBy ,
                        Reason ,
                        UnitsRequested ,
                        Comment ,
                        TotalCount ,
                        RowNumber
                INTO    #FinalResultSet
                FROM    RankResultSet
                WHERE   RowNumber > ( ( @PageNumber - 1 ) * @PageSize )

            SELECT  dbo.ProviderAuthorizations.ProviderAuthorizationId
            INTO    #FinalResultSetids
            FROM    dbo.ProviderAuthorizations
                    INNER JOIN dbo.Clients ON dbo.ProviderAuthorizations.ClientId = dbo.Clients.ClientId
                    INNER JOIN dbo.Providers ON dbo.ProviderAuthorizations.ProviderId = dbo.Providers.ProviderId
                    LEFT JOIN dbo.Sites ON dbo.ProviderAuthorizations.SiteId = dbo.Sites.SiteId
                                           AND ISNULL(Sites.recorddeleted, 'N') = 'N'
                    INNER JOIN dbo.BillingCodes ON ISNULL(Providerauthorizations.BIllingCodeId, RequestedBillingCodeId) = BillingCodes.BillingCodeId --ProviderAuthorizations.STATUS = CASE WHEN ProviderAuthorizations.STATUS =2042 THEN dbo.ProviderAuthorizations.BillingCodeId   ELSE dbo.ProviderAuthorizations.RequestedBillingCodeId END
                    INNER JOIN Insurers ON ProviderAuthorizations.InsurerId = Insurers.InsurerId
                    LEFT JOIN dbo.GlobalCodes ON dbo.GlobalCodes.GlobalCodeId = dbo.ProviderAuthorizations.STATUS
                                                 AND ISNULL(GlobalCodes.recorddeleted, 'N') = 'N'
                    INNER JOIN @Clients c ON c.ClientId = ProviderAuthorizations.ClientId
            WHERE   ISNULL(Clients.recorddeleted, 'N') = 'N'
                    AND ISNULL(Providers.recorddeleted, 'N') = 'N'
                    AND ISNULL(BillingCodes.recorddeleted, 'N') = 'N'
                    AND ISNULL(Insurers.recorddeleted, 'N') = 'N'
                    AND ISNULL(ProviderAuthorizations.recorddeleted, 'N') = 'N'
                    AND ( ( @CustomFiltersApplied = 'Y'
                            AND EXISTS ( SELECT *
                                         FROM   #CustomFilters cf
                                         WHERE  cf.ProviderAuthorizationId = ProviderAuthorizations.ProviderAuthorizationId )
                          )
                          OR ( @CustomFiltersApplied = 'N'
                               AND ( @InsurerId = -1
                                     OR ProviderAuthorizations.InsurerId = @InsurerId
                                   )
                               AND ( @ProviderId = -1
                                     OR ProviderAuthorizations.ProviderId = @ProviderId
                                   )
                               AND ( EXISTS ( SELECT    SI.InsurerId
                                              FROM      StaffInsurers SI
                                              WHERE     ISNULL(RecordDeleted, 'N') <> 'Y'
                                                        AND SI.StaffId = @LoggedinStaffId
                                                        AND ProviderAuthorizations.InsurerId = SI.InsurerId
                                                        AND @AllStaffInsurer = 'N' )
                                     OR EXISTS ( SELECT InsurerId I
                                                 FROM   Insurers I
                                                 WHERE  ISNULL(RecordDeleted, 'N') <> 'Y'
                                                        AND ProviderAuthorizations.InsurerId = I.InsurerId
                                                        AND @AllStaffInsurer = 'Y' )
                                   )
                               AND ( EXISTS ( SELECT    SP.ProviderId
                                              FROM      StaffProviders SP
                                              WHERE     RecordDeleted <> 'Y'
                                                        AND SP.StaffId = @LoggedinStaffId
                                                        AND ProviderAuthorizations.ProviderId = SP.ProviderId
                                                        AND @AllStaffProvider = 'N' )
                                     OR EXISTS ( SELECT ProviderId P
                                                 FROM   Providers P
                                                 WHERE  ISNULL(RecordDeleted, 'N') <> 'Y'
                                                        AND ProviderAuthorizations.ProviderId = P.ProviderId
                                                        AND @AllStaffProvider = 'Y' )
                                   )
                               AND ( @BillingCodeId = -1
                                     OR CASE WHEN ProviderAuthorizations.STATUS = 2042 THEN dbo.ProviderAuthorizations.BillingCodeId
                                             ELSE dbo.ProviderAuthorizations.RequestedBillingCodeId
                                        END = @BillingCodeId
                                   )
                               AND ( @EffectiveAsOf = ''
                                     OR ( ProviderAuthorizations.[StartDate] <= @EffectiveAsOf
							--AND ProviderAuthorizations.[EndDate] >= @EffectiveAsOf
                                          )
                                   )
                               AND ( @Status = -1
                                     OR ProviderAuthorizations.[Status] = @Status
                                   )
                             )
                        )

            DECLARE @LetterIds VARCHAR(MAX);

            SELECT  @LetterIds = COALESCE(@LetterIds + ',', '') + CAST(fs.ProviderAuthorizationId AS VARCHAR)
            FROM    #FinalResultSetids fs

            IF ( SELECT ISNULL(COUNT(*), 0)
                 FROM   #FinalResultSet
               ) < 1 
                BEGIN
                    SELECT  0 AS PageNumber ,
                            0 AS NumberOfPages ,
                            0 NumberOfRows ,
                            '' AS LetterIds
                END
            ELSE 
                BEGIN
                    SELECT TOP 1
                            @PageNumber AS PageNumber ,
                            CASE ( TotalCount % @PageSize )
                              WHEN 0 THEN ISNULL(( TotalCount / @PageSize ), 0)
                              ELSE ISNULL(( TotalCount / @PageSize ), 0) + 1
                            END AS NumberOfPages ,
                            ISNULL(TotalCount, 0) AS NumberOfRows ,
                            @LetterIds AS LetterIds
                    FROM    #FinalResultSet
                END

            SELECT  Checkbox ,
                    ProviderAuthorizationId ,
                    ProviderName ,
                    SiteName ,
                    BillingCode ,
                    AuthorizationNumber ,
                    STATUS ,
                    UnitsApproved ,
                    UnitsUsed ,
                    StartDate ,
                    EndDate ,
                    ProviderId ,
                    SiteId ,
                    BillingCodeId ,
                    ClientId ,
                    LastName ,
                    FirstName ,
                    Active ,
                    GlobalCodeId ,
                    InsurerId ,
                    InsurerName ,
                    StatusId ,
			----StartDateRequested, 
                    CONVERT(VARCHAR(10), StartDateRequested, 101) AS StartDateRequested ,
			--EndDateRequested,  
                    CONVERT(VARCHAR(10), EndDateRequested, 101) AS EndDateRequested ,
                    CreatedBy ,
                    CreatedDate ,
                    ModifiedBy ,
                    ModifiedDate ,
                    RecordDeleted ,
                    ProviderAuthorizationDocumentId ,
                    DeletedDate ,
                    DeletedBy ,
                    Reason ,
                    UnitsRequested ,
                    Comment ,
                    '' AS CopyAuth
            FROM    #FinalResultSet
            ORDER BY RowNumber

            DROP TABLE #CustomFilters
        END TRY

        BEGIN CATCH
            DECLARE @Error VARCHAR(8000)

            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_ListPageMembersAuthorizations') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


