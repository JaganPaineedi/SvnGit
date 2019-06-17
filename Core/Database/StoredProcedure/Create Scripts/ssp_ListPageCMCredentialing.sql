IF OBJECT_ID('ssp_ListPageCMCredentialing','P') IS NOT NULL
DROP PROCEDURE [dbo].[ssp_ListPageCMCredentialing]
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[ssp_ListPageCMCredentialing]
    @PageNumber INT ,
    @PageSize INT ,
    @SortExpression VARCHAR(100) ,
    @ReviewerId INT ,
    @Status INT ,
    @Type INT ,
    @ProviderId INT ,
    @SiteId INT ,
    @EffectiveOn DATETIME ,
    @ExpireInDays INT ,
    @ApproachingExpiration CHAR(1) ,
    @LoggedinStaffId INT ,
    @OtherFilter INT 
/*********************************************************************                   
-- Stored Procedure: ssp_ListPageCMCredentialing         
-- Copyright: Streamline Healthcare Solutions        
-- Creation Date:  20 Feb 2014                               
--                                                          
-- Purpose: returns data for the Credentialing list page.  
--                                                      
-- Date				Modified By         Purpose  
-- 20 Feb 2014      Md Hussain Khusro   Created.       
-- 14/07/2014       Shruthi.S           Commenting this condition 'CredentialApproachingExpiration' .Ref #2.1 CM to SC.    
-- 19 Jul 2014		Rohith Uppin		new column Credential Id added in select statement. Task#6 CM to SC
-- 30 July 2014		Rohith Uppin		Two more columns are added in select statement. Task#6 CM to SC
-- 11/08/2014       Shruthi.S           Removed Recorddeleted check for Providers table(Master table).Since, it was not pulling few records for credentialing.Ref #2.1 CM to SC.
-- 29-12-2014       Shruthi.S           Added staffproviders association.Ref #287 Env Issues.
-- MAY-5-2015		dharvey				Added ISNULL to c.CredentialApproachingExpiration to correct logic
****************************************************************************/
AS 
    BEGIN 

        BEGIN TRY 
            CREATE TABLE #ResultSet
                (
                  RowNumber INT ,
                  PageNumber INT ,
                  ProviderId INT ,
                  CredentialingId INT ,
                  ProviderName VARCHAR(250) ,
                  [Site] VARCHAR(250) ,
                  PerformedBy VARCHAR(250) ,
                  EffectiveFrom DATETIME ,
                  [Status] VARCHAR(250) ,
                  Share CHAR(1) ,
                  InsurerId INT
                ) 

            DECLARE @AllStaffProvider VARCHAR(1)
            SELECT  @AllStaffProvider = AllProviders
            FROM    staff
            WHERE   staffid = @LoggedinStaffId
            DECLARE @CustomFiltersApplied CHAR(1) 
            DECLARE @OrganizationName VARCHAR(250) 
          
            CREATE TABLE #CustomFilters ( ProviderId INT )
           
            SELECT  @OrganizationName = OrganizationName
            FROM    SystemConfigurations 

            SET @CustomFiltersApplied = 'N' 
     
          -- Run custom logic if any custom filter passed       
          --           
            IF @OtherFilter > 10000 
                BEGIN 
                    SET @CustomFiltersApplied = 'Y' 

                    INSERT  INTO #CustomFilters
                            ( ProviderId
                            )
                            EXEC scsp_ListPageCMCredentialing @ReviewerId = @ReviewerId, @Status = @Status, @Type = @Type, @ProviderId = @ProviderId, @SiteId = @SiteId, @EffectiveOn = @EffectiveOn, @ExpireInDays = @ExpireInDays, @ApproachingExpiration = @ApproachingExpiration, @OtherFilter = @OtherFilter       
                END 

            INSERT  INTO #ResultSet
                    ( ProviderId ,
                      CredentialingId ,
                      ProviderName ,
                      [Site] ,
                      PerformedBy ,
                      EffectiveFrom ,
                      [Status] ,
                      Share ,
                      InsurerId
                    )
                    SELECT  c.ProviderId AS ProviderId ,
                            C.CredentialingId AS CredentialingId ,
                            P.ProviderName AS ProviderName ,
                            CASE WHEN s.SiteName IS NULL THEN ''
                                 ELSE S.SiteName
                            END AS [Site] ,
                            ISNULL(i.InsurerName, @OrganizationName) AS 'PerformedBy' ,
                            c.EffectiveFrom AS EffectiveFrom ,
                            gcs.CodeName AS [Status] ,
                            C.Share ,
                            i.InsurerId
                    FROM    Credentialing c
                            JOIN Providers P ON P.ProviderId = C.ProviderId
                                                AND ISNULL(P.RecordDeleted, 'N') = 'N'
                            JOIN GlobalCodes gcs ON c.[Status] = gcs.GlobalCodeId
                                                    AND ISNULL(gcs.RecordDeleted, 'N') = 'N'
                            LEFT JOIN Insurers i ON c.performedBy = i.InsurerId
                                                    AND ISNULL(i.RecordDeleted, 'N') = 'N'
                            LEFT JOIN Sites s ON c.SiteId = s.SiteId
                                                 AND ISNULL(s.RecordDeleted, 'N') = 'N'
                    WHERE   ISNULL(c.RecordDeleted, 'N') = 'N'
                            AND ( ( @CustomFiltersApplied = 'Y'
                                    AND EXISTS ( SELECT *
                                                 FROM   #CustomFilters cf
                                                 WHERE  cf.ProviderId = c.ProviderId )
                                  )
                                  OR ( @CustomFiltersApplied = 'N'
                                       AND ( c.Status <> 2642 -- not completed    
                                             OR ( c.Status = 2642
                                                  AND NOT EXISTS ( SELECT   *
                                                                   FROM     Credentialing c2
                                                                   WHERE    c2.Status = c.Status
                                                                            AND c2.ProviderId = c.ProviderId
                                                                            AND ISNULL(c2.SiteId, 0) = ISNULL(c.SiteId, 0)
                                                                            AND ISNULL(c2.EffectiveFrom, '1/1/1900') > ISNULL(c.EffectiveFrom, '1/1/1900')
                                                                            AND ISNULL(c2.RecordDeleted, 'N') = 'N' )
                                                )
                                           )
                                       AND ( c.ProviderId = @ProviderId
                                             OR ISNULL(@ProviderId, -1) <= 0
                                           )
                                       AND ( c.Status = @Status
                                             OR ISNULL(@Status, -1) <= 0
                                           )
                                       AND ( c.CredentialingType = @Type
                                             OR ISNULL(@Type, -1) <= 0
                                           )
                                       AND ( c.SiteId = @SiteId
                                             OR ISNULL(@SiteId, -1) <= 0
                                           )
                                       AND ( c.PerformedBy = @ReviewerId
                                             OR ISNULL(@ReviewerId, -1) = -1
                                             OR ( @ReviewerId = 0
                                                  AND c.PerformedBy IS NULL
                                                )
                                           )
                                       AND ( @ApproachingExpiration IS NULL
                                             --OR c.CredentialApproachingExpiration = @ApproachingExpiration
                                             OR ISNULL(c.CredentialApproachingExpiration,'N') = @ApproachingExpiration
                                           )
                                       AND ( ISNULL(@ExpireInDays, 0) = 0
                                             OR ( p.Active = 'Y'
                                                  AND ( c.ExpirationDate >= CAST(GETDATE() AS DATE)
                                                        AND c.ExpirationDate <= CAST(DATEADD(d, @ExpireInDays, GETDATE()) AS DATE)
                                                      )
                                                )
                                           )
                                       AND ( ISNULL(@EffectiveOn, '') = ''
                                             OR CAST(c.EffectiveFrom AS DATE) >= CAST(@EffectiveOn AS DATE)
                                           )
                                     )
                                )
                            AND ( @ProviderId = -1
                                  OR C.ProviderId = @ProviderId
                                )
                            AND ( @AllStaffProvider = 'Y'
                                  OR EXISTS ( SELECT    SI.ProviderId
                                              FROM      StaffProviders SI
                                              WHERE     ISNULL(SI.RecordDeleted, 'N') <> 'Y'
                                                        AND SI.StaffId = @LoggedinStaffId
                                                        AND C.ProviderId = SI.ProviderId
                                                        AND @AllStaffProvider = 'N' )
                                )
                    ORDER BY p.ProviderName
                    
                    ;
                WITH    Counts
                          AS ( SELECT   COUNT(*) AS TotalRows
                               FROM     #ResultSet
                             ) ,
                        ListBanners
                          AS ( SELECT DISTINCT
                                        ProviderId ,
                                        CredentialingId ,
                                        ProviderName ,
                                        [Site] ,
                                        PerformedBy ,
                                        EffectiveFrom ,
                                        [Status] ,
                                        Share ,
                                        InsurerId ,
                                        COUNT(*) OVER ( ) AS TotalCount ,
                                                        RANK() OVER ( ORDER BY CASE WHEN @SortExpression = 'ProviderId' THEN ProviderId
                                                                               END, CASE WHEN @SortExpression = 'ProviderId desc' THEN ProviderId
                                                                                    END DESC, CASE WHEN @SortExpression = 'ProviderName' THEN ProviderName
                                                                                              END, CASE WHEN @SortExpression = 'ProviderName desc' THEN ProviderName
                                                                                                   END DESC, CASE WHEN @SortExpression = 'Site' THEN [Site]
                                                                                                             END, CASE WHEN @SortExpression = 'Site desc' THEN [Site]
                                                                                                                  END DESC, CASE WHEN @SortExpression = 'PerformedBy' THEN PerformedBy
                                                                                                                            END, CASE WHEN @SortExpression = 'PerformedBy desc' THEN PerformedBy
                                                                                                                                 END DESC, CASE WHEN @SortExpression = 'EffectiveFrom' THEN EffectiveFrom
                                                                                                                                           END, CASE WHEN @SortExpression = 'EffectiveFrom desc' THEN EffectiveFrom
                                                                                                                                                END DESC, CASE WHEN @SortExpression = 'Status' THEN [Status]
                                                                                                                                                          END, CASE WHEN @SortExpression = 'Status desc' THEN [Status]
                                                                                                                                                               END DESC, ProviderId ) AS RowNumber
                               FROM                     #ResultSet
                             )
                
                
                SELECT TOP ( CASE WHEN ( @PageNumber = -1 ) THEN ( SELECT   ISNULL(TotalRows, 0)
                                                                   FROM     Counts
                                                                 )
                                  ELSE ( @PageSize )
                             END )
                        ProviderId ,
                        CredentialingId ,
                        ProviderName ,
                        [Site] ,
                        PerformedBy ,
                        CONVERT(VARCHAR(10), EffectiveFrom, 101) AS EffectiveFrom ,
                        [Status] ,
                        Share ,
                        InsurerId ,
                        TotalCount ,
                        RowNumber
                INTO    #FinalResultSet
                FROM    ListBanners
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
                            END AS NumberOfPages ,
                            ISNULL(totalcount, 0) AS NumberOfRows
                    FROM    #FinalResultSet 
                END 

            SELECT  ProviderId ,
                    CredentialingId ,
                    ProviderName ,
                    [Site] ,
                    PerformedBy ,
                    EffectiveFrom ,
                    [Status] ,
                    Share ,
                    InsurerId
            FROM    #FinalResultSet
            ORDER BY RowNumber           
        END TRY 

        BEGIN CATCH 
            DECLARE @Error VARCHAR(8000) 

            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_ListPageCMCredentialing') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 

            RAISERROR ( @Error,-- Message text.       
                      16,-- Severity.       
                      1 -- State.       
          ); 
        END CATCH 
    END 
GO


