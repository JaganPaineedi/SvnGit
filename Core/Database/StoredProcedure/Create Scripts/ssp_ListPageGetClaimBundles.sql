/****** Object:  StoredProcedure [dbo].[ssp_ListPageGetClaimBundles]    Script Date: 06/03/2014 11:56:55 ******/ 
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = OBJECT_ID(N'[dbo].[ssp_ListPageGetClaimBundles]' 
                              ) 
                  AND type in ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_ListPageGetClaimBundles] 

GO 

/****** Object:  StoredProcedure [dbo].[ssp_ListPageGetClaimBundles]    Script Date: 06/03/2014 11:56:55 ******/ 
SET ANSI_NULLS ON 

GO 

SET QUOTED_IDENTIFIER ON 

GO
CREATE PROCEDURE [dbo].[ssp_ListPageGetClaimBundles]      
 @PageNumber     INT,       
 @PageSize       INT,       
 @SortExpression VARCHAR(100),       
 --@InsurerId      INT,       
 @ProviderId     INT,       
 @SiteId         INT,       
 --@ClientId       INT,       
 @StartDate  DATETIME,       
 @EndDate DATETIME,      
 --@CreateDate DATETIME,       
 --@OtherFilter    INT,       
 --@ClaimBundlePeriod INT,      
 @CodeName       VARCHAR(100),      
 @Active   VARCHAR(2)       
AS       
  /************************************************************************************************                                            
  -- Stored Procedure: dbo.ssp_ListPageGetClaimBundles                    
  -- Copyright: Streamline Healthcate Solutions                    
  -- Purpose: ClaimBundles List Page                  
  -- Updates:                    
  -- Date        Author            Purpose       
  /*09-Oct-2015	SuryaBalan	Claim Bundles List Page Network 180 - Customizations Task #608*/
  /*09-Oct-2015	SuryaBalan	Added Condition for StartDate and EndDate Filter*/ 
  /*05-APR-2016	Suneel N	Added Conditions for getting BundleName,BillingCodeId, BundleCodes - Network180 - Customizations Task #608.6*/              
       
  *************************************************************************************************/      
  BEGIN       
      BEGIN try       
          SET nocount ON;        
CREATE TABLE #ClaimBundles        
 (        
  ClaimBundleId  INT        
 )        
         
 --        
 --Get custom filters         
 --                                                    
  --IF @OtherFilter > 10000                                       
  -- BEGIN                                  
                                      
  --   INSERT INTO #ClaimBundles (ClaimBundleId)                                                        
  --   EXEC scsp_ListPageClaimBundles @OtherFilter = @OtherFilter                                           
  -- END          
         
 --                                       
 --Insert data in to temp table which is fetched below by appling filter.           
 --          
    ;WITH TotalBundles  AS         
 (        
   SELECT   Distinct C.ClaimBundleId,      
   --C.CreatedBy,      
   --CONVERT(VARCHAR, C.CreatedDate, 101) AS CreatedDate,      
   C.ModifiedBy,      
   C.ProviderId,      
   --C.BillingCodeModifierId,      
   C.ProviderSiteId,      
   C.BundleName,      
   C.Active,      
   CONVERT(VARCHAR, C.StartDate, 101) AS StartDate,      
   CONVERT(VARCHAR, C.EndDate, 101) AS EndDate,      
   C.Period, 
   C.DateOfService,      
   C.PlaceOfService,      
   --gc1.CodeName as PeriodText, 
	--05-APR-2016	Suneel N
   C.BillingCodeId,     
   BC1.BillingCode as Bundlecode, 
   ISNULL(STUFF((SELECT ', ' + ISNULL(CBCG.BillingCodeGroupName, '')
      FROM ClaimBundleBillingCodeGroups CBCG 
      where CBCG.ClaimBundleId=C.ClaimBundleId AND ISNULL(CBCG.RecordDeleted, 'N') = 'N'        
      FOR XML PATH('')
      ,type ).value('. ', 'nvarchar(max)'), 1, 2, ' '), '') AS BillingCode
   ,Case P.ProviderType When 'I' then P.ProviderName + ', ' + P.FirstName When 'F' then P.ProviderName End as ProviderName        
   --C.ClientOrganization       
   ,S.SiteName as SiteName      
       
   --,STUFF((      
   --  SELECT ', ' + S.SiteName      
   --  FROM Sites S      
   --   JOIN ClaimBundleSites CBS on S.SiteId=CBS.SiteId  and CBS.ClaimBundleId=C.ClaimBundleId and ISNULL(CBS.RecordDeleted, 'N') = 'N'           
   --  WHERE (      
   --    CBS.SiteId = @SiteId      
   --    OR @SiteId = -1    
   --    )      
   --   AND ISNULL(S.RecordDeleted, 'N') = 'N'      
   --   AND ISNULL(CBS.RecordDeleted, 'N') = 'N'      
   --  FOR XML PATH('')      
   --   ,TYPE      
   --  ).value('.[1]', 'nvarchar(max)'), 1, 2, '') AS SiteName      
   FROM CLAIMBUNDLES C      
   --Left OUTER JOIN  GlobalCodes gc1 ON  gc1.GlobalCodeId=C.Period and gc1.Category like 'CLAIMBUNDLEPERIOD' AND ISNULL(gc1.RecordDeleted, 'N') = 'N'      
   Left JOIN Providers P on P.ProviderId=C.ProviderId AND ISNULL(P.RecordDeleted, 'N') = 'N' 
   Left JOIN Sites S ON S.SiteId = C.ProviderSiteId AND ISNULL(S.RecordDeleted, 'N') = 'N'
   --05-APR-2016	Suneel N 
   --Left JOIN BillingCodes BC1 ON BC1.BillingCodeId = C.BillingCodeId AND ISNULL(BC1.RecordDeleted, 'N') = 'N'   
   --Left JOIN BillingCodes BC2 ON BC2.BillingCodeId in (Select BillingCodeId from ClaimBundleBillingCodes CBBC WHERE CBBC.ClaimBundleId = C.ClaimBundleId AND ISNULL(CBBC.RecordDeleted, 'N') = 'N') 
   --AND ISNULL(BC2.RecordDeleted, 'N') = 'N'
   
   LEFT JOIN BillingCodes BC1 ON BC1.BillingCodeId = C.BillingCodeId AND ISNULL(BC1.RecordDeleted, 'N') = 'N' 
   --LEFT JOIN ClaimBundleBillingCodes CBBC ON CBBC.ClaimBundleId = C.ClaimBundleId AND ISNULL(CBBC.RecordDeleted, 'N') = 'N'
   --LEFT JOIN BillingCodes BC2 ON BC2.BillingCodeId = CBBC.BillingCodeId AND ISNULL(BC2.RecordDeleted, 'N') = 'N'
   --LEFT JOIN BillingCodes BC3 ON BC3.BillingCodeId = CBBC.BillingCodeId AND ISNULL(BC3.RecordDeleted, 'N') = 'N' 
    LEFT JOIN ClaimBundleBillingCodeGroups CBC ON CBC.ClaimBundleId = C.ClaimBundleId AND ISNULL(CBC.RecordDeleted, 'N') = 'N'     
   --LEFT JOIN ClaimBundleSites CBS on CBS.ClaimBundleId=C.ClaimBundleId and ISNULL(CBS.RecordDeleted, 'N') = 'N'      
   --Left JOIN Sites S on S.SiteId=CBS.SiteId AND ISNULL(S.RecordDeleted, 'N') = 'N'         
         
   WHERE (C.ProviderId = @ProviderId      
       OR @ProviderId = -1)       
       --AND (      
     --C.Period = @ClaimBundlePeriod      
     --OR (@ClaimBundlePeriod = -1)      
     --)      
      AND (      
     ISNULL(C.Active,'N') = @Active      
     OR (@Active is NULL)      
     )      
     AND      
     (C.ProviderSiteId = @SiteId      
      OR @SiteId = -1)      
      
     --AND (      
     --C.CreatedDate = @CreateDate      
     --OR (@CreateDate IS NULL)      
     --)      
     --AND (CBS.SiteId = @SiteId      
     --  OR @SiteId = -1)       
       AND (    @StartDate IS NULL OR  (  C.StartDate >=@StartDate and C.EndDate >= @StartDate  
       ))  
       AND (@EndDate IS NULL OR   (  C.StartDate <=@EndDate and C.EndDate <= @EndDate) )  
       AND ISNULL(C.RecordDeleted,'N')='N'  
     -- and ( (C.StartDate <=@StartDate and C.EndDate >=@EndDate)              
     --or (@StartDate between C.StartDate  and C.EndDate)               
     --or (@EndDate between C.StartDate and C.EndDate)  or isnull(@StartDate, '') = '' or isnull(@EndDate, '') = '')      
      AND (ISNULL(@CodeName,'') = '' OR BC1.BillingCode like '%'+@CodeName+'%' OR CBC.BillingCodeGroupName like '%'+@CodeName+'%') 
      
          
           
           
                         
        
  ),        
 counts AS         
 (         
  SELECT COUNT(*) AS totalrows FROM TotalBundles        
 ),                    
    ListBundles AS         
    (         
  SELECT DISTINCT         
    ClaimBundleId
   ,ProviderName      
   ,StartDate      
   ,EndDate 
   --05-APR-2016	Suneel N
   ,BundleName 
   ,ProviderId
   ,Bundlecode
   ,BillingCode     
   ,CASE WHEN ISNULL(Active,'N') = 'Y' THEN 'Active' else 'Inactive' end as Active   --Text changed In Active to Inactive #608.8 Network180 Env.Issues
   --,PeriodText      
   --,CreatedDate      
   --,CreatedBy      
   ,SiteName        
   ,COUNT(*) OVER ( ) AS TotalCount ,        
    Rank() OVER ( order by        
        
           
     case when @SortExpression= 'ClaimBundleId' then ClaimBundleId end ,                                       
     case when @SortExpression= 'ClaimBundleId desc' then ClaimBundleId end desc,
     case when @SortExpression= 'ProviderName' then ProviderName end ,                                       
     case when @SortExpression= 'ProviderName desc' then ProviderName end desc,       
           
     case when @SortExpression= 'StartDate' then StartDate end ,                                       
     case when @SortExpression= 'StartDate desc' then StartDate end desc,       
     case when @SortExpression= 'EndDate' then EndDate end ,                                       
     case when @SortExpression= 'EndDate desc' then EndDate end desc, 
     --05-APR-2016	Suneel N
     case when @SortExpression = 'BundleName' then BundleName end,
     case when @SortExpression = 'BundleName desc' then BundleName end desc,
     case when @SortExpression= 'Bundlecode' then Bundlecode end , 
     case when @SortExpression= 'Bundlecode desc' then Bundlecode end desc,
     case when @SortExpression= 'BillingCode' then BillingCode end , 
     case when @SortExpression= 'BillingCode desc' then BillingCode end desc,     
     case when @SortExpression= 'Active' then Active end ,                                       
     case when @SortExpression= 'Active desc' then Active end desc,       
     --case when @SortExpression= 'PeriodText' then PeriodText end ,                                       
     --case when @SortExpression= 'PeriodText desc' then PeriodText end desc ,      
     --case when @SortExpression= 'CreatedDate' then CreatedDate end ,                                       
     --case when @SortExpression= 'CreatedDate desc' then CreatedDate end desc ,      
     --case when @SortExpression= 'CreatedBy' then CreatedBy end ,                                       
     --case when @SortExpression= 'CreatedBy desc' then CreatedBy end desc ,      
     case when @SortExpression= 'SiteName' then SiteName end ,                                       
     case when @SortExpression= 'SiteName desc' then SiteName end desc ,      
           
         ClaimBundleId
            ) as RowNumber        
            FROM TotalBundles         
    )        
    SELECT TOP ( Case WHEN (@PageNumber = -1) THEN (SELECT ISNULL(totalrows,0) from counts) ELSE (@PageSize) END)
	--05-APR-2016	Suneel N        
    ClaimBundleId  
   ,BundleName 
   ,ProviderId 
   ,Bundlecode  
   ,BillingCode   
   ,ProviderName      
   ,StartDate      
   ,EndDate 
   ,Active      
   --,PeriodText      
   --,CreatedDate      
   --,CreatedBy      
   ,SiteName        
                        ,TotalCount         
                        ,RowNumber        
                INTO    #FinalResultSet        
                FROM    ListBundles        
                WHERE   RowNumber > ( ( @PageNumber - 1 ) * @PageSize )          
                        
    IF (SELECT     ISNULL(COUNT(*),0) FROM   #FinalResultSet)<1        
  BEGIN        
   SELECT 0 AS PageNumber ,        
   0 AS NumberOfPages ,        
   0 NumberOfRows        
  END        
  ELSE        
  BEGIN        
   SELECT TOP 1        
   @PageNumber AS PageNumber,        
   CASE (TotalCount % @PageSize) WHEN 0 THEN         
   ISNULL(( TotalCount / @PageSize ), 0)        
   ELSE ISNULL(( TotalCount / @PageSize ), 0) + 1 END AS NumberOfPages,        
   ISNULL(TotalCount, 0) AS NumberOfRows        
   FROM    #FinalResultSet             
  END         
         
 SELECT 
		--05-APR-2016	Suneel N              
        ClaimBundleId 
        ,BundleName 
        ,ProviderId
        ,ProviderName 
        ,SiteName
        ,StartDate
        ,EndDate
        ,BillingCode 
		,Bundlecode
		,Active    
   --,ProviderName      
   --,StartDate      
   --,EndDate 
   --,Active      
   --,PeriodText      
   --,CreatedDate      
   --,CreatedBy      
   --,SiteName       
         
 FROM #FinalResultSet                                          
 ORDER BY RowNumber          
         
 DROP TABLE #FinalResultSet        
 DROP Table #ClaimBundles          
         
END try       
      
    BEGIN catch       
       DECLARE @Error VARCHAR(8000)       
      
        SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'       
                    + CONVERT(VARCHAR(4000), ERROR_MESSAGE())       
                    + '*****'       
                    + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),       
                    'ssp_ListPageGetClaimBundles')       
                    + '*****' + CONVERT(VARCHAR, ERROR_LINE())       
                    + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY())       
                    + '*****' + CONVERT(VARCHAR, ERROR_STATE())       
      
        RAISERROR ( @Error,       
                    -- Message text.                                                                                                                
                    16,       
                    -- Severity.                                                                                                                
                    1       
        -- State.                                                                                                         
        );       
    END catch       
END   

go 