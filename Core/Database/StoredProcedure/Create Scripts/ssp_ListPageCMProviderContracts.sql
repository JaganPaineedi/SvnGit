IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_ListPageCMProviderContracts]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_ListPageCMProviderContracts] 

GO 
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE ssp_ListPageCMProviderContracts
 @PageNumber     INT,
 @PageSize       INT, 
 @SortExpression VARCHAR(100), 
 @LoginStaffId   INT, 
 @OtherFilter    INT, 
 @ProviderName   VARCHAR(250), 
 @Statuses       INT, 
 @Insurers       INT, 
 @Contracts      INT, 
 @CapLimits      INT,
 @ShowRenderingProviders      char(1)  = 'N'
AS 
  /************************************************************************************************                                
  -- Stored Procedure: dbo.ssp_ListPageCMProviderContracts        
  -- Copyright: Streamline Healthcate Solutions        
  -- Purpose: Used by Clients list page        
  -- Updates:        
  -- Date        Author            Purpose        
  -- 04.03.2014  Vichee Humane     Created     
  --14/07/2014   Shruthi.S         Added and c.Status='A'for   6151-status.Ref #2.1 Dashboard to match the count for current contract hyperlink. 
  --08.19.2014	Vichee Humane	   Added condition to with StaffProviders to show only those providers who are associated with loggin staff.
  --30-Sept-2014 SuryaBalan	       Care Management to SmartCare Env. Issues Tracking Task 10 Fixed Provider Contracts freezes system 
  --12-Jan-2015 SuryaBalan	       Care Management to SmartCare Env. Issues Tracking Task 331 Fixed Dashboard : Widget sp's needs to be changed to include StaffInsu StaffProv 	
 
-- 12-Nov-2015	Ponnin				Added alias as c for Enddate column of 'contracts' table. (Sites table is also using the same column name) -  to avoid Ambiguous column name 'Enddate'. Why : SWMBH Support - #751
-- 22.Feb.2016	Rohith Uppin		Staff provider issue fixed and ProviderId > 0 condition added. SWMBH Support #855
-- 04.JAN.2017	Basudev Sahu		Modified for Rendering Provider FOR CEI SGL Task #364
-- 12.Jun.2017  PradeepT            What: Changed the data type of temp table #Providers.ContractCapital from INT To money
--                                  Why:Task:KCMHAS_900.55--The ContractCapital field is being calculated from  field Contracts.ClaimsApprovedAndPaid and Contracts.TotalAmountCap which  itself are  money type. 
-- 13 June 2017 PradeepT            What: Added ANSI_NULLS and QUOTED_IDENTIFIER ON
--                                  Why:As per suggested by DB Team
   ************************************************************************************************* */
  BEGIN
      BEGIN try 
          SET nocount ON; 

          --DECLATE TABLE TO GET DATA IF OTHER FILTER EXISTS -------             
          DECLARE @CustomFiltersApplied CHAR(1)  
		
          CREATE TABLE #CustomFilters 
            ( 
               ContractID INT 
            ) 

          DECLARE @str NVARCHAR(4000) 
          DECLARE @ContractID INT 
          DECLARE @InsurerID INT 
          

          SET @CustomFiltersApplied = 'N' 

          CREATE TABLE #Providers 
            ( 
               ContractID          INT, 
               [ID]                INT, 
               Active              CHAR(1), 
               DataEntryComplete   CHAR(1), 
               Provider            VARCHAR(500), 
               [Contract Name]     VARCHAR(500), 
               [Primary Site Type] VARCHAR(500), 
               TYPE                VARCHAR(100), 
               [Phone #]           VARCHAR(100), 
               --RecordDeleted       CHAR(1), 
               --DeletedDate         DATETIME, 
               --DeletedBy           VARCHAR(100), 
               StartDate           DATETIME, 
               [Contract]          VARCHAR(20),         
               PendingDays         INT, 
               ContractCapital     MONEY, ---12.Jun.2017, PradeepT
               PrimarySite         INT, 
              -- InsurerId           VARCHAR(8000), 
               SiteId              INT, 
               [License #]         VARCHAR(50), 
               RenderingProvider   CHAR(3) --04.JAN.2017	Basudev Modified for Rendering Provider FOR CEI SGL Task #364
            ) 

          --GET CUSTOM FILTERS             
          IF @OtherFilter > 10000 
            BEGIN 
                SET @CustomFiltersApplied = 'Y' 

                INSERT INTO #CustomFilters(ContractID) 
                EXEC scsp_ListPageCMProviderContracts 
                  @SortExpression, 
                  @LoginStaffId, 
                  @OtherFilter, 
                  @ProviderName, 
                  @Statuses, 
				  @Insurers, 
				  @Contracts, 
				  @CapLimits      
            END 

          --INSERT DATE INTO TEMP TABLE WHICH IS FETCHED BELOW BY APPLYING FILTER.  
          Declare @AllProviders varchar(1)               
          select TOP 1 @AllProviders =  allproviders from staff where staffid=@LoginStaffId   
          Declare @AllInsurers varchar(1)
          select top 1 @AllInsurers =allinsurers from staff where staffid=@LoginStaffId  
              
          IF @CustomFiltersApplied = 'N' 
            BEGIN 
                INSERT INTO #Providers 
                SELECT Distinct c.ContractId, 
                       p.ProviderId AS ID , 
                       p.Active, 
                       DataEntryComplete, 
                       CASE p.ProviderType 
                         WHEN 'I' THEN p.providername + ', ' + p.firstname 
                         WHEN 'F' THEN p.providername 
                       END AS Provider, 
                       c.ContractName AS 'Contract Name', 
                       s.SiteName AS  'Primary Site Type', 
                       (SELECT CodeName  FROM   GlobalCodes  WHERE  GlobalCodeId = s.SiteType 
						AND Isnull(recorddeleted, 'N') = 'N') AS  Type, 
                       dbo.GetSitePhone(s.SiteId) AS 'Phone #', 
                       --c.RecordDeleted, 
                       --c.DeletedDate, 
                       --c.DeletedBy, 
                       c.StartDate AS StartDate, 
                       convert(varchar(10),c.EndDate,101) AS  [Contract],                   
                       Datediff(d, Getdate(), c.Enddate)  AS PendingDays, 
                       Isnull(ClaimsApprovedAndPaid, 0) / Isnull(TotalAmountCap, -1) *  100 AS  'ContractCapital', 
                       --Isnull((SELECT PrimarySiteId  FROM   providers WHERE  ProviderId = p.PrimarySiteId  AND 
                       --s.SiteId = Providers.PrimarySiteId), 0) AS  Primarysite,
                       --','  AS 'InsurerID', 
                       P.PrimarySiteId,
                       s.SiteId, 
                       s.LicenseNumber AS  'License #',
                       CASE 
                         WHEN Isnull(P.RenderingProvider,'N')='N' THEN 'No' 
                         WHEN Isnull(P.RenderingProvider,'Y')='Y' THEN 'Yes'
                       END AS RenderingProvider                  --04.JAN.2017	Basudev Modified for Rendering Provider FOR CEI SGL Task #364
                       FROM   Providers p 
                       LEFT JOIN Sites s  ON p.ProviderId = s.ProviderId   AND p.PrimarySiteId = s.SiteId 
                       --JOIN StaffProviders SP ON ( ISNULL( @AllProviders,'N')='N' and p.ProviderId= sp.ProviderId AND sp.StaffId=@LoginStaffId  ) or @AllProviders='Y'  
                       --JOIN Staff ON (ISNULL( @AllProviders,'N')='N' and SP.StaffId = Staff.StaffId AND Staff.StaffId=@LoginStaffId )  or @AllProviders='Y'  
                       LEFT JOIN contracts c  ON c.ProviderId = p.ProviderId AND Isnull(c.RecordDeleted, 'N') = 'N' 
                       AND ( (c.InsurerId IN (SELECT InsurerId FROM  StaffInsurers WHERE  StaffId = @LoginStaffId  AND Isnull(RecordDeleted,'N') = 'N')) OR @AllInsurers='Y')
                       WHERE  Isnull(p.recorddeleted, 'N') = 'N'  AND Isnull(s.recorddeleted, 'N') = 'N' 
                       AND ( @ProviderName = '' OR ( p.ProviderName LIKE '%' + @ProviderName + '%' ) ) 
                       AND ((@Statuses = 6151 AND  p.Active='Y' and c.[Status]='A') OR (@Statuses=6152 AND p.Active='Y' AND p.DataEntryComplete='Y')
                       OR  (@Statuses=6153 AND p.Active='Y' and p.DataEntryComplete='N') OR (@Statuses = 6154 AND  p.DataEntryComplete='Y')
                       OR  (@Statuses = 6155 AND  p.Active='N') OR (@Statuses=-1))
                       
                       AND ((@Contracts = 6156 AND c.EndDate < Convert(varchar(30),Getdate(),101) AND ContractId IS NOT NULL )
                       OR (@Contracts = 6157 AND c.StartDate <= Convert(varchar(30),Getdate(),101) AND c.EndDate >= Convert(varchar(30),Getdate(),101) AND ContractId IS NOT NULL ) 
                       OR (@Contracts = 6158 AND (Datediff(d, Getdate(), c.EndDate) <=7 ) AND (Datediff(d, Getdate(), c.Enddate) > 0) AND ContractId IS NOT NULL )
                       OR (@Contracts = 6159 AND (Datediff(d, Getdate(), c.Enddate) <=14 ) AND (Datediff(d, Getdate(), c.Enddate) > 0) AND ContractId IS NOT NULL )
                       OR (@Contracts = 6160 AND (Datediff(d, Getdate(), c.Enddate) <=30 ) AND (Datediff(d, Getdate(), c.Enddate) > 0) AND ContractId IS NOT NULL ) 
                       OR (@Contracts = 6161 AND (Datediff(d, Getdate(), c.Enddate) <=60 ) and (Datediff(d, Getdate(), c.Enddate) > 0) and ContractId IS NOT NULL )
                       OR (@Contracts = 6162 AND (Datediff(d, Getdate(), c.Enddate) <=90 ) and (Datediff(d, Getdate(), c.Enddate) > 0) and ContractId IS NOT NULL )
                       OR (@Contracts=-1))
                        
                       AND ((@CapLimits = 6163 AND (ISNULL(ClaimsApprovedAndPaid, 0) / ISNULL(TotalAmountCap, -1) *  100)>=100) 
                       OR  (@CapLimits = 6164 AND (ISNULL(ClaimsApprovedAndPaid, 0) / ISNULL(TotalAmountCap, -1) *  100)>=95) 
                       OR  (@CapLimits = 6165 AND (ISNULL(ClaimsApprovedAndPaid, 0) / ISNULL(TotalAmountCap, -1) *  100)>=90) 
                       OR  (@CapLimits = 6166 AND (ISNULL(ClaimsApprovedAndPaid, 0) / ISNULL(TotalAmountCap, -1) *  100)>=85)
                       OR  (@CapLimits = 6167 AND (ISNULL(ClaimsApprovedAndPaid, 0) / ISNULL(TotalAmountCap, -1) *  100)>=80)
                       OR  (@CapLimits = 6168 AND (ISNULL(ClaimsApprovedAndPaid, 0) / ISNULL(TotalAmountCap, -1) *  100)>=75)
                       OR  (@CapLimits = 6169))             
                       AND (@AllProviders='Y'  OR  C.ProviderId IN (SELECT SP.ProviderId FROM  StaffProviders SP WHERE p.ProviderId= sp.ProviderId AND sp.StaffId=@LoginStaffId AND isnull(SP.RecordDeleted,'N')='N'))
                       AND (InsurerId=@Insurers OR @Insurers=-1) 
                       AND (P.RenderingProvider=@ShowRenderingProviders OR @ShowRenderingProviders='N') 
                       AND P.ProviderId > 0                      
                         

					  --DECLARE cur CURSOR FOR 
       --           SELECT c.ContractId,c.InsurerId FROM  Contracts c  JOIN StaffInsurers si ON
							--  c.InsurerId = si.InsurerId 
       --                       AND si.Staffid = @LoginStaffId 
       --                       AND Isnull(c.RecordDeleted, 'N') = 'N' 
       --                       AND Isnull(si.RecordDeleted, 'N') = 'N' ORDER  BY c.ContractId 
       --           OPEN cur 
       --               FETCH FROM cur INTO @ContractID, @InsurerID 
       --               WHILE ( @@FETCH_STATUS = 0 ) 
       --                BEGIN 
       --                  UPDATE #Providers  SET   InsurerId = InsurerId + Cast(@InsurerID AS VARCHAR(15)) + ',' 
       --                  WHERE  contractid = @ContractID 
       --                  FETCH FROM cur INTO @ContractID, @InsurerID 
       --                END 
       --          CLOSE cur 
       --         DEALLOCATE cur 
         
            END; 
 
           WITH counts 
               AS (SELECT Count(*) AS TotalRows 
                   FROM   #Providers), 
               ListBanners 
               AS (SELECT [ID],
						  ContractID,	 
                          Provider, 
                          [Contract Name], 
                          [Primary Site Type], 
                          TYPE, 
                          [Phone #], 
                          [Contract],         
                          [License #], 
                          [RenderingProvider],    
                          Count(*) 
                          OVER ()  AS 
                          TotalCount, 
                          Rank() 
                          OVER( ORDER BY 
                                    CASE WHEN @SortExpression='ProviderId' THEN ID END,         
                                    CASE WHEN @SortExpression='ProviderId DESC' THEN ID END DESC,         
									CASE WHEN @SortExpression='Provider' THEN Provider END, 
                                    CASE WHEN @SortExpression='Provider DESC' THEN Provider END DESC,        
									CASE WHEN @SortExpression='Contract Name' THEN [Contract Name] END, 
									CASE WHEN @SortExpression='Contract Name DESC' THEN [Contract Name] END DESC,
									CASE WHEN @SortExpression='Primary Site Type' THEN [Primary Site Type] END,
									CASE WHEN @SortExpression='Primary Site Type DESC' THEN [Primary Site Type] END DESC,
									CASE WHEN @SortExpression='Type' THEN [Type] END, 
									CASE WHEN @SortExpression='Type DESC' THEN [Type] END DESC, 
                                    CASE WHEN @SortExpression='Phone' THEN [Phone #] END,         
                                    CASE WHEN @SortExpression='Phone DESC' THEN [Phone #] END DESC,         
									CASE WHEN @SortExpression='Contract'  THEN Contract END, 
									CASE WHEN @SortExpression='Contract DESC' THEN Contract END DESC,
                                    CASE WHEN @SortExpression='License' THEN [License #] END,         
                                    CASE WHEN @SortExpression='License DESC' THEN [License #] END DESC,
                                    CASE WHEN @SortExpression='RenderingProvider' THEN [RenderingProvider] END,         
                                    CASE WHEN @SortExpression='RenderingProvider DESC' THEN [RenderingProvider] END DESC     --04.JAN.2017	Basudev Modified for Rendering Provider FOR CEI SGL Task #364
                                    ,ID ) AS  RowNumber         
                   FROM   #Providers)         
          SELECT TOP (CASE WHEN (@PageNumber = -1) THEN (SELECT Isnull(TotalRows,0)         
          FROM         
          Counts ) ELSE (@PageSize) END) 
          [ID],         
           Provider,  
           ContractID,       
           [Contract Name],         
           [Primary Site Type],         
           TYPE,         
              [Phone #],         
           Contract,         
           [License #],
           [RenderingProvider],         --04.JAN.2017	Basudev Modified for Rendering Provider FOR CEI SGL Task #364
           RowNumber,         
           TotalCount         
          INTO   #FinalResultSet         
          FROM   ListBanners         
          WHERE  RowNumber > ( ( @PageNumber - 1 ) * @PageSize )         
        
              
        
          SELECT [ID], 
                Provider,  
                ContractID,       
                 [Contract Name],         
                 [Primary Site Type],         
                 TYPE,         
                 [Phone #],         
                [Contract],         
                 [License #],   
                 [RenderingProvider],               --04.JAN.2017	Basudev Modified for Rendering Provider FOR CEI SGL Task #364
                 RowNumber         
          FROM   #FinalResultSet         
          ORDER  BY Rownumber      
              
          IF (SELECT Isnull(COUNT(*), 0)         
              FROM   #FinalResultSet) < 1         
            BEGIn        
                SELECT 0 AS PageNumber,         
                       0 AS NumberOfPages,         
                       0 NumberOfRows         
   END         
          ELSE         
            BEGIN         
                SELECT TOP 1 @PageNumber AS PageNumber,         
                             CASE ( TotalCount % @PageSize )         
                             WHEN 0 THEN Isnull(( TotalCount / @PageSize ), 0)         
                             ELSE Isnull(( totalcount / @PageSize ), 0) + 1         
                             END  AS NumberOfPages,         
                             Isnull(TotalCount, 0) AS NumberOfRows         
                FROM   #FinalResultSet         
            END         
                 
      END TRY         
        
      BEGIN CATCH         
          DECLARE @Error VARCHAR(8000)         
        
          SET @Error= CONVERT(VARCHAR, Error_number()) + '*****'         
                      + CONVERT(VARCHAR(4000), Error_message())         
                      + '*****'         
                      + Isnull(CONVERT(VARCHAR, Error_procedure()),         
                      'ssp_ListPageCMProviderContracts')         
                      + '*****' + CONVERT(VARCHAR, Error_line())         
                      + '*****' + CONVERT(VARCHAR, Error_severity())         
                      + '*****' + CONVERT(VARCHAR, Error_state())         
        
          RAISERROR ( @Error,         
                      -- Message text.                                                                                                    
                      16,         
                      -- Severity.                                                                                                    
                      1         
          -- State.                                                                                                    
          );         
      END catch         
  END 
