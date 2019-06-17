IF OBJECT_ID('ssp_ListPageSCClientAuthorizationList','P') IS NOT NULL
DROP PROCEDURE [dbo].[ssp_ListPageSCClientAuthorizationList]
GO


SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
   
CREATE PROCEDURE [dbo].[ssp_ListPageSCClientAuthorizationList]
    (
      @SessionId VARCHAR(30) ,
      @InstanceId INT ,
      @PageNumber INT ,
      @PageSize INT ,
      @SortExpression VARCHAR(100) ,
      @ClientId INT ,
      @RequestorsIdFilter INT ,
      @AuthorizationCodeIdFilter INT ,
      @PlansFilter INT ,
      @StatusFilter INT ,
      @ProvidersFilter INT ,
      @SitesFilter INT ,
      @StartDate VARCHAR(50) ,
      @EndDate VARCHAR(50) ,
      @OtherFilter INT ,
      @Payer int,
	  @PayerTypeId int,
      @StaffId INT,
      @ClinicianId INT
    )
AS /********************************************************************************/
-- Stored Procedure: dbo.[ssp_ListPageSCClientAuthorizationList]  
--                                                                                                               
-- Copyright: Streamline Healthcate Solutions                                                                                                               
--                                                                                                               
-- Purpose:  To fecth the data for the list page of List Page authorization                 
--    
--Author: Sudhir Singh  
--  
--Date: 26 JUN 2012 -- Updated the existing as for Threshold  
--                                                                                                             
-- Updates:         
-- Date				Author			Purpose     
/*	July 19,2012	Varinder Verma	Added check of RecordDeleted for 'GlobalCodes' regarding Authorization.Status	*/
/* March 5,2013		Sudhir Singh	Merge #221 Task in Venture Region Support from 2.x to 3.5x*/
/*	03.20.2013		dharvey			Modified logic to accommodate all statuses on date search 
									and show TotalUnitsRequested when TotalUnits is NULL */
/* 05/14/2013       Shruthi.S       Reverted changes related to #831 Centrawellness bugs and feature.
									Since its not a realtime scenario to create an authorization in
									approved or pending status without a startdate which was breaking
									listpage pulling logic.*/
/*	OCT-7-2013		dharvey			Merged 2x and 3.5x  and Changed AuthorizationId to AuthorizationDocumentId in results*/
/* 25/09/2014       Shruthi.S       As per discussion with Javed did changes for requested and denied.Ref #94 KCMHSAS 3.5 Implementation */ 
/* NOV-4-2014		dharvey			Merged and updated logic */
/*  May-18-2015     Arjun K R       Payers and PayerType, these two new filters are added to listpage.Task #97 CEI Environment Issues Tracking            */ 
/*  June-30-2015    SuryBalan       Added Clinician for Filter in Auth List Page, 935 Valley Customizations */ 
 
/*********************************************************************************/                                                             
    BEGIN            
        SET NOCOUNT ON;  
            
        IF @StartDate = '' 
            SET @StartDate = NULL  
        IF @EndDate = '' 
            SET @EndDate = NULL  
     
 --  
 --Declare table to get data if Other filter exists -------  
 --  
        CREATE TABLE #Authorizations ( AuthorizationId INT )  
   
 --  
 --Get custom filters   
 --                                              
        IF @OtherFilter > 10000 
            BEGIN     
                INSERT  INTO #Authorizations
                        EXEC scsp_ListPageSCClientAuthorization @OtherFilter = @OtherFilter   
            END   
   
 --                                 
 --Insert data in to temp table which is fetched below by appling filter.     
 --    
    ;
        WITH    TotalAuthorizations
                  AS ( SELECT DISTINCT
                                Authorizations.AuthorizationId ,
                                AuthorizationDocuments.AuthorizationDocumentId ,
                                Clients.ClientId ,
                                CoveragePlans.DisplayAs AS CoveragePlanName ,
                                CASE ISNULL(Providers.ProviderName, 'N')
                                  WHEN 'N' THEN ''
                                  ELSE Providers.ProviderName
                                END + CASE ISNULL(Authorizations.SiteId, '0')
                                        WHEN '0' THEN Ag.AgencyName
                                        ELSE Sites.SiteName
                                      END AS ProviderName ,
                                AuthorizationCodes.DisplayAs AS AuthorizationCodeName ,
                                Authorizations.AuthorizationNumber ,
                                GlobalCodes.CodeName AS StatusName ,
                                --CAST(CEILING(Authorizations.TotalUnits) AS VARCHAR) AS Units ,
                                --CAST(CEILING(Authorizations.UnitsUsed) AS VARCHAR) AS Used , 
                                Case when Authorizations.UnitType='D' then '$' + CAST(CEILING(ISNULL(Authorizations.TotalUnits, Authorizations.TotalUnitsRequested)) AS VARCHAR)+'.00' 
                                     else CAST(CEILING(ISNULL(Authorizations.TotalUnits, Authorizations.TotalUnitsRequested)) AS VARCHAR) end as Units
                                --,CAST(CEILING(ISNULL(Authorizations.TotalUnits, Authorizations.TotalUnitsRequested)) AS VARCHAR) AS Units ,
                                ,Case when Authorizations.UnitType='D' then
                                     '$' + CASE WHEN Authorizations.UnitsUsed IS NULL
                                          AND Authorizations.UnitsScheduled IS NULL THEN NULL
                                           ELSE ( CAST(CEILING(ISNULL(Authorizations.UnitsUsed, 0) + ISNULL(Authorizations.UnitsScheduled, 0)) AS VARCHAR) )+'.00' END
                                     ELSE 
										CASE WHEN Authorizations.UnitsUsed IS NULL
                                          AND Authorizations.UnitsScheduled IS NULL THEN NULL
                                     ELSE ( CAST(CEILING(ISNULL(Authorizations.UnitsUsed, 0) + ISNULL(Authorizations.UnitsScheduled, 0)) AS VARCHAR) )
                                END END AS Used,                   
  /* Sudhir singh updated as per Task Id #221 Venture Region Support */  
  --Sudhir Commented                   
   --CASE WHEN Authorizations.Status= 4243 THEN  Authorizations.StartDate ELSE  Authorizations.StartDateRequested END  AS FromDate,  
   --CASE  WHEN Authorizations.Status =4243 THEN Authorizations.EndDate ELSE Authorizations.EndDateRequested  END AS  ToDate,   
   --End Sudhir commented
                                --CASE WHEN ( Authorizations.Status = 4242
                                --            OR Authorizations.Status = 4244
                                --          ) THEN Authorizations.StartDateRequested
                                --     ELSE Authorizations.StartDate
                                --END AS FromDate ,
                                --CASE WHEN ( Authorizations.Status = 4242
                                --            OR Authorizations.Status = 4244
                                --          ) THEN Authorizations.EndDateRequested
                                --     ELSE Authorizations.EndDate
                                --END AS ToDate ,
                                ISNULL(Authorizations.StartDate, Authorizations.StartDateRequested) AS FromDate ,
                                ISNULL(Authorizations.EndDate, Authorizations.EndDateRequested) AS ToDate ,
                                Documents.DocumentId ,
                                DocumentCodes.DocumentCodeId ,
                                sr.ScreenId AS DocumentScreenId ,
                                DocumentCodes.DocumentName ,
                                
                                0 AS IsPopup,
                                case when (s.LastName + ', ' + s.FirstName) IS not NULL then (s.LastName + ', ' + s.FirstName)end AS Clinician
                       FROM     Agency AS Ag ,
                                ClientCoveragePlans
                                INNER JOIN AuthorizationDocuments ON AuthorizationDocuments.ClientCoveragePlanId = ClientCoveragePlans.ClientCoveragePlanId
                                                                     AND ISNULL(AuthorizationDocuments.RecordDeleted, 'N') = 'N'
                                                                     AND ISNULL(ClientCoveragePlans.RecordDeleted, 'N') = 'N'
                                INNER JOIN Authorizations ON Authorizations.AuthorizationDocumentId = AuthorizationDocuments.AuthorizationDocumentId
                                                             AND ISNULL(Authorizations.RecordDeleted, 'N') = 'N'
                                INNER JOIN Clients ON ClientCoveragePlans.ClientId = Clients.ClientId
                                                      AND ISNULL(Clients.RecordDeleted, 'N') = 'N'
                                INNER JOIN AuthorizationCodes ON Authorizations.AuthorizationCodeId = AuthorizationCodes.AuthorizationCodeId
                                                                 AND ISNULL(AuthorizationCodes.RecordDeleted, 'N') = 'N'
                                INNER JOIN CoveragePlans ON ClientCoveragePlans.CoveragePlanId = CoveragePlans.CoveragePlanId
                                                            AND ISNULL(CoveragePlans.RecordDeleted, 'N') = 'N'
                                --Added By Arjun K R  May-18-2015                           
                                INNER JOIN Payers F ON (F.PayerId = CoveragePlans.PayerId) AND ISNULL(F.RecordDeleted,'N')='N'
                                
                                LEFT JOIN Documents ON AuthorizationDocuments.DocumentId = Documents.DocumentID
                                                       AND ISNULL(Documents.RecordDeleted, 'N') = 'N'
                                LEFT JOIN DocumentCodes ON Documents.DocumentCodeId = DocumentCodes.DocumentCodeId
                                                           AND ISNULL(DocumentCodes.RecordDeleted, 'N') = 'N'
                                LEFT JOIN Screens sr ON sr.DocumentCodeId = Documents.DocumentCodeId
                                                        AND ISNULL(sr.RecordDeleted, 'N') = 'N'
                                LEFT JOIN Providers ON Authorizations.ProviderId = Providers.ProviderId
                                                       AND ISNULL(Providers.RecordDeleted, 'N') = 'N'
                                INNER JOIN GlobalCodes ON Authorizations.Status = GlobalCodes.GlobalCodeId
                                                          AND ISNULL(GlobalCodes.RecordDeleted, 'N') = 'N'
                                                          AND GlobalCodes.Active = 'Y'
                                LEFT JOIN GlobalCodes gl ON gl.GlobalCodeId = AuthorizationCodes.UnitType
                                LEFT JOIN Staff ON AuthorizationDocuments.StaffId = Staff.StaffId
                                                   AND ISNULL(Staff.RecordDeleted, 'N') = 'N'
                                LEFT JOIN Sites ON Authorizations.SiteId = Sites.SiteId
                                                   AND ISNULL(Sites.RecordDeleted, 'N') = 'N'
                                LEFT JOIN Staff s ON Authorizations.ClinicianId = s.StaffId
                                                   AND s.Clinician='Y' and s.Active='Y' and ISNULL(s.RecordDeleted,'N')<>'Y'
                       WHERE    ( @ClientId != -1
                                  AND Clients.ClientId = @ClientId
                                )
                                
                                
                                AND ( @RequestorsIdFilter = 0
                                      OR ( @RequestorsIdFilter != -1
                                           AND AuthorizationDocuments.StaffId = @RequestorsIdFilter
                                         )
                                    )
                                AND ( ( Providers.ProviderId = @ProvidersFilter
                                        OR ISNULL(@ProvidersFilter, 0) = 0
                                      )
                                      OR ( @ProvidersFilter = -1
                                           AND Authorizations.ProviderId IS NULL
                                         )
                                    )
                                AND ( Authorizations.SiteId = @SitesFilter
                                      OR ISNULL(@SitesFilter, 0) = 0
                                    )
                                 AND ( Authorizations.ClinicianId = @ClinicianId
                                      OR ISNULL(@ClinicianId, 0) = 0
                                    )
                                AND ( ClientCoveragePlans.ClientCoveragePlanId = @PlansFilter
                                      OR ISNULL(@PlansFilter, 0) = 0
                                    )
                                    
                                --Added By Arjun K R May-18-2015    
                                AND (@PayerTypeId = -1 OR F.PayerType = @PayerTypeId)       
	                            AND	(@Payer = -1 OR F.PayerId = @Payer) 
	                            
	                            
                                AND Authorizations.Status = CASE WHEN ISNULL(@StatusFilter, 0) = 0 THEN Authorizations.Status
                                                                 ELSE @StatusFilter
                                                            END   
/*   
   AND 
    CASE WHEN Authorizations.Status= 4243  THEN  Authorizations.StartDate WHEN Authorizations.DateRequested IS NULL   
          THEN Authorizations.StartDate ELSE  Authorizations.StartDateRequested  end>=@StartDate                        
   AND   
    CASE WHEN Authorizations.Status =4243 THEN Authorizations.EndDate WHEN Authorizations.EndDateRequested IS NULL   
          THEN Authorizations.EndDate else Authorizations.EndDateRequested end <=  @EndDate  
*/
    ---Sudhir COmmented
    --and case when Authorizations.Status= 4243  then  Authorizations.StartDate when Authorizations.StartDateRequested IS NULL THEN Authorizations.StartDate ELSE  Authorizations.StartDateRequested  end < dateadd(dd, 1, ISNULL(@EndDate,(CASE WHEN Authorizations.Status= 4243  THEN  Authorizations.StartDate 
			--																WHEN Authorizations.StartDateRequested IS NULL THEN Authorizations.StartDate 
			--																ELSE  Authorizations.StartDateRequested  END)))                          
    --And isnull(case when Authorizations.Status =4243 then Authorizations.EndDate when Authorizations.EndDateRequested IS NULL THEN Authorizations.EndDate else Authorizations.EndDateRequested end,ISNULL(@StartDate,'01/01/1900')) >=  ISNULL(@StartDate,'01/01/1900')                            
----End commented Sudhir
                                /*** Replaced Case statements with ISNULL functions - dharvey NOV-4-2014 ***/
                                --AND CASE WHEN Authorizations.StartDateRequested IS NULL THEN Authorizations.StartDate
                                --         ELSE Authorizations.StartDateRequested
                                --    END < DATEADD(dd, 1, ISNULL(@EndDate, CASE WHEN ( Authorizations.Status = 4242
                                --                                                      OR Authorizations.Status = 4244
                                --                                                      AND Authorizations.status NOT IN ( 304, 305, 4242, 4243, 4244, 4245, 6044, 6045 )
                                --                                                    ) THEN CASE WHEN Authorizations.StartDateRequested IS NULL THEN Authorizations.StartDate
                                --                                                                ELSE Authorizations.StartDateRequested
                                --                                                           END
                                --                                          END))
                                AND ISNULL(Authorizations.StartDate, Authorizations.StartDateRequested)
									< DATEADD(dd,1,ISNULL(@EndDate,ISNULL(Authorizations.StartDate, Authorizations.StartDateRequested)))
                                --AND ISNULL(CASE WHEN ( Authorizations.Status = 4242
                                --                       OR Authorizations.Status = 4244
                                --                       AND Authorizations.status NOT IN ( 304, 305, 4242, 4243, 4244, 4245, 6044, 6045 )
                                --                     ) THEN CASE WHEN Authorizations.EndDateRequested IS NULL THEN Authorizations.EndDate
                                --                                 ELSE Authorizations.EndDateRequested
                                --                            END
                                --           END, ISNULL(CASE WHEN Authorizations.EndDateRequested IS NULL THEN Authorizations.EndDate
                                --                            ELSE Authorizations.EndDateRequested
                                --                       END, '01/01/1900')) <= ISNULL(@EndDate, '01/01/1900')
                                AND ISNULL(ISNULL(Authorizations.EndDate, Authorizations.EndDateRequested),ISNULL(@StartDate, '01/01/1900')) 
									>= ISNULL(@StartDate, '01/01/1900')
								/*** Replaced Case statements with ISNULL functions - dharvey NOV-4-2014 ***/
                                AND ( NOT EXISTS ( SELECT   'X'
                                                   FROM     #Authorizations )
                                      OR Authorizations.AuthorizationId IN ( SELECT AuthorizationId
                                                                             FROM   #Authorizations )
                                    )
                                AND ( AuthorizationCodes.AuthorizationCodeId = @AuthorizationCodeIdFilter
                                      OR ISNULL(@AuthorizationCodeIdFilter, 0) = 0
                                    )
                     ) ,
                counts
                  AS ( SELECT   COUNT(*) AS totalrows
                       FROM     TotalAuthorizations
                     ) ,
                ListAuthorizations
                  AS ( SELECT DISTINCT
                                AuthorizationId ,
                                AuthorizationDocumentId ,
                                ClientId ,
                                CoveragePlanName ,
                                ProviderName ,
                                AuthorizationCodeName ,
                                AuthorizationNumber ,
                                StatusName ,
                                Units ,
                                Used ,
                                FromDate ,
                                ToDate ,
                                DocumentId ,
                                DocumentCodeId ,
                                DocumentScreenId ,
                                DocumentName ,
                                IsPopup ,
                                Clinician,
                                COUNT(*) OVER ( ) AS TotalCount ,
                                ROW_NUMBER() OVER ( ORDER BY CASE WHEN @SortExpression = 'AuthorizationId' THEN AuthorizationId
                                                             END, CASE WHEN @SortExpression = 'AuthorizationId desc' THEN AuthorizationId
                                                                  END DESC, CASE WHEN @SortExpression = 'ProviderName' THEN ProviderName
                                                                            END, CASE WHEN @SortExpression = 'ProviderName desc' THEN ProviderName
                                                                                 END DESC, CASE WHEN @SortExpression = 'CoveragePlanName' THEN CoveragePlanName
                                                                                           END, CASE WHEN @SortExpression = 'CoveragePlanName desc' THEN CoveragePlanName
                                                                                                END DESC, CASE WHEN @SortExpression = 'AuthorizationCodeName' THEN AuthorizationCodeName
                                                                                                          END, CASE WHEN @SortExpression = 'AuthorizationCodeName desc' THEN AuthorizationCodeName
                                                                                                               END DESC, CASE WHEN @SortExpression = 'AuthorizationNumber' THEN AuthorizationNumber
                                                                                                                         END, CASE WHEN @SortExpression = 'AuthorizationNumber desc' THEN AuthorizationNumber
                                                                                                                              END DESC, CASE WHEN @SortExpression = 'StatusName' THEN StatusName
                                                                                                                                        END, CASE WHEN @SortExpression = 'StatusName desc' THEN StatusName
                                                                                                                                             END DESC, CASE WHEN @SortExpression = 'Units' THEN Units
                                                                                                                                                       END, CASE WHEN @SortExpression = 'Units desc' THEN Units
                                                                                                                                                            END DESC, CASE WHEN @SortExpression = 'Used' THEN Used
                                                                                                                                                                      END, CASE WHEN @SortExpression = 'Used desc' THEN Used
                                                                                                                                                                           END DESC, CASE WHEN @SortExpression = 'FromDate' THEN FromDate
                                                                                                                                                                                     END, CASE WHEN @SortExpression = 'FromDate desc' THEN FromDate
                                                                                                                                                                                          END DESC, CASE WHEN @SortExpression = 'ToDate' THEN ToDate
                                                                                                                                                                                                    END, CASE WHEN @SortExpression = 'ToDate desc' THEN ToDate
                                                                                                                                                                                                         END DESC,CASE WHEN @SortExpression = 'Clinician' THEN Clinician
                                                                                                                                                                                                                  END, CASE WHEN @SortExpression = 'Clinician desc' THEN Clinician
                                                                                                                                                                                                                        END DESC, DocumentName, DocumentId ) AS RowNumber
                       FROM     TotalAuthorizations
                     )
            SELECT TOP ( CASE WHEN ( @PageNumber = -1 ) THEN ( SELECT   ISNULL(totalrows, 0)
                                                               FROM     counts
                                                             )
                              ELSE ( @PageSize )
                         END )
                    AuthorizationDocumentId AS AuthorizationId ,
                    AuthorizationDocumentId ,
                    ClientId ,
                    CoveragePlanName ,
                    ProviderName ,
                    AuthorizationCodeName ,
                    AuthorizationNumber ,
                    StatusName ,
                    Units ,
                    Used ,
                    FromDate ,
                    ToDate ,
                    DocumentId ,
                    DocumentCodeId ,
                    DocumentScreenId ,
                    DocumentName ,
                    IsPopup ,
                    Clinician,
                    TotalCount ,
                    RowNumber
            INTO    #FinalResultSet
            FROM    ListAuthorizations
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
                        ISNULL(TotalCount, 0) AS NumberOfRows
                FROM    #FinalResultSet       
            END   
   
        SELECT  AuthorizationDocumentId AS AuthorizationId ,
                AuthorizationDocumentId ,
                ClientId ,
                ProviderName ,
                CoveragePlanName ,
                AuthorizationCodeName ,
                AuthorizationNumber ,
                StatusName ,
                ISNULL(Units, 0) AS Units ,
                ISNULL(Used, 0) AS Used ,
                ISNULL(CONVERT(VARCHAR, FromDate, 101), '') AS FromDate ,
                ISNULL(CONVERT(VARCHAR, ToDate, 101), '') AS ToDate ,
                DocumentId ,
                DocumentCodeId ,
                DocumentScreenId ,
                DocumentName ,
                IsPopup,
                Clinician
        FROM    #FinalResultSet
        ORDER BY RowNumber    
   
        DROP TABLE #FinalResultSet  
        DROP TABLE #Authorizations    
    END  
GO


