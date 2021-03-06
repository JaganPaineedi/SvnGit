/****** Object:  StoredProcedure [dbo].[ssp_ListPagePlacementFamilies]    Script Date: 02/03/2015 01:57:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPagePlacementFamilies]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPagePlacementFamilies]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
    
      
    
CREATE PROCEDURE [dbo].[ssp_ListPagePlacementFamilies]       
  /******************************************************************************                   
  ** File: ssp_ListPagePlacementFamilies.sql                   
  ** Name: ssp_ListPagePlacementFamilies                   
  ** Desc:                     
  **                     
  ** Parameters:                    
  ** Input Output                    
  ** ---------- -----------                    
  ** N/A   Dropdown values                   
  ** Auth: MSuma                 
  ** Date: 30/08/2012                  
  *******************************************************************************                   
  ** Change History                    
  *******************************************************************************                   
  ** Date:  Author:    Description:                     
  ** 09-03-2012 MSuma  Procedure to retrieve all placement families      
  ** 03-20-2013 Gautam  Added Relative Placement Field to display family having   
      Relative Placements  
  ** 12-11-15   Veena   Task #2 Family & Children Services Customization  Added  PlacementFamilyId,Family name to add a link to Placement Family  *  

  *******************************************************************************/       
 @PageNumber          INT,         
  @PageSize            INT,         
  @SortExpression      VARCHAR (100),         
  @OpenStatus          INT,         
  @StartDate           DATETIME,         
  @EndDate             DATETIME,         
  @PlacementFamilyType VARCHAR (50),         
  @Placement           VARCHAR (50),         
  @Child               VARCHAR (50) ,      
  @ExcludeRelatives  CHAR(1),      
  @NotContractedFamily CHAR(1)       
AS         
  BEGIN         
      BEGIN try         
          DECLARE @ApplyFilterClicked AS CHAR (1);         
          DECLARE @FiltersApplied AS CHAR (1);         
        
IF @StartDate = ''        
  SET @StartDate = NULL         
 ELSE        
  SET @StartDate = CONVERT(DATETIME,@StartDate,10)        
          
                  
        
          SET @SortExpression = Rtrim(Ltrim(@SortExpression));         
        
          IF Isnull(@SortExpression, '') = ''         
            SET @SortExpression = 'PlacementFamilyId';         
        
          CREATE TABLE #placementcount         
            (         
               noofplacement     INT,         
               placementfamilyid INT         
            );         
        
          INSERT INTO #placementcount         
                      (noofplacement,         
                       placementfamilyid)         
          (SELECT Count(CFC.FosterChildId),         
      CPF.PlacementFamilyId         
   FROM  FosterPlacements CFP JOIN  PlacementFamilies CPF   
    ON CFP.PlacementFamilyId = CPF.PlacementFamilyId INNER JOIN         
     FosterChildren AS CFC   ON CFC.FosterChildId = CFP.FosterChildId   
   Where ISNULL(CFP.RecordDeleted,'N')='N' and ISNULL(CPF.RecordDeleted,'N')='N'  
    GROUP BY CPF.PlacementFamilyId );         
        
          WITH placementresult         
               AS (SELECT DISTINCT   
               CPF.placementfamilyid,         
               CPF.familyname,         
      GC.codename        AS [Status],         
               GCFT.codename       AS PlacementType,         
      ISNULL(PC.noofplacement,0)       AS noofplacement          ,--PC.noofplacement,         
               ''          AS OpenBeds,         
               CPF.dateofinitiallicensure    AS ActiveSince,         
               '0'         AS LastPayment,  
               ISNULL(CFPFCR.PlacementFamilyId,0)       AS RelativePlacement ,     
               PR.ProviderId,
               PR.ProviderName 
               
          FROM    PlacementFamilies AS CPF         
          LEFT OUTER JOIN GlobalCodes AS GC ON Gc.globalcodeid = CPF.status         
                                    AND GC.category LIKE 'XPLACEMENTFAMISTATUS'        
          LEFT OUTER JOIN GlobalCodes AS GCR ON --GCR.globalcodeid = CPF.status         
                                     GCR.category LIKE 'XPLACEMENTFAMILYTYPE'       
                                    AND GCR.Code = 'Relatives'       
          LEFT OUTER JOIN  FosterPlacements AS CFP         
                                       ON CFP.placementfamilyid = CPF.placementfamilyid         
                        
          LEFT OUTER JOIN  FosterChildren AS CFC ON CFC.fosterchildid =         
                                          CFP.fosterchildid         
          LEFT OUTER JOIN #placementcount AS PC ON PC.placementfamilyid =         
                                          CPF.PlacementFamilyId        
          LEFT OUTER JOIN  PlacementFamilyTypes AS CPFT         
         ON CPFT.placementfamilyid = CPF.placementfamilyid         
  --AND ( @PlacementFamilyType = 25687  OR CPFT.familytype = @PlacementFamilyType )        
  LEFT OUTER JOIN GlobalCodes AS GCFT  ON GCFT.globalcodeid = CPFT.familytype  AND GCFT.Category = 'XPLACEMENTFAMILYTYPE'        
  LEFT OUTER JOIN (Select Distinct PlacementFamilyId from  FosterPlacementFamilyChildRelations 
      Where  ISNULL(RecordDeleted,'N')='N' ) CFPFCR ON CFPFCR.PlacementFamilyId=CPF.PlacementFamilyId 
        LEFT OUTER JOIN Providers PR ON  CPF.LinkedProviderId=PR.ProviderId
    
         WHERE          
                   (ISNULL(@Placement,'')='' OR CPF.familyname like '%'+@Placement+'%')      
                   AND ( ISNULL(@Child,'') = '' OR CFC.lastname LIKE '%' + @Child + '%'         
                                     OR CFC.firstname LIKE '%' + @Child + '%' )           
                   AND ( @PlacementFamilyType = -1  OR CPFT.familytype = @PlacementFamilyType )       
                   AND ((@StartDate IS NULL OR  CFP.placementstart IS NULL OR CFP.placementstart >= @StartDate)          
                   AND ( @EndDate IS NULL OR CFP.placementstart <= @EndDate ) )        
                   AND (Isnull(@OpenStatus, -1) = -1 OR CPF.status = @OpenStatus )        
                   AND (CPFT.RecordDeleted = 'N'OR CPFT.RecordDeleted IS NULL)      
                   AND ((@NotContractedFamily = 'N' and ISNULL(CPF.NotContractedFamily,'N') ='N' )      
        OR (@NotContractedFamily = 'Y' and CPF.NotContractedFamily ='Y' ))      
                   AND (@ExcludeRelatives = 'N'       
      OR (@ExcludeRelatives = 'Y'        
     AND CFP.PlacementFamilyId NOT IN(      
     SELECT PlacementFamilyId from  PlacementFamilyTypes CPT WHERE       
     CPT.PlacementFamilyId = CPF.PlacementFamilyId AND ISNULL(CPT.RecordDeleted,'N')='N'      
     AND CPT.FamilyType = GCR.GlobalCodeId)      
           
     AND NOT EXISTS(       
     SELECT * from  FosterPlacementFamilyChildRelations CPFC WHERE       
     CPFC.PlacementFamilyId = CPF.PlacementFamilyId AND ISNULL(CPFC.RecordDeleted,'N')='N')      
     )       
     )      
     ),      
                                
               PlacementListResultset         
               AS (SELECT i.placementfamilyid,         
                          i.familyname,         
                          i.[status],         
                          Stuff(g.y, 1, 1, '') AS PlacementType,         
                          i.noofplacement,         
                          i.openbeds,         
                          i.activesince,         
                          i.lastpayment,  
                          i.RelativePlacement,
                          i.ProviderId,
               i.ProviderName      
                   FROM   (SELECT placementfamilyid,         
                                  familyname,         
                                  [status],         
        noofplacement,         
                                  openbeds,         
                                  activesince,         
                                  lastpayment,  
                                  RelativePlacement,  
                                  ProviderId,
                                  ProviderName        
                           FROM   placementresult         
                           GROUP  BY placementfamilyid,         
                       familyname,         
                                     [status],         
                                     noofplacement,         
                                     openbeds,         
                                     activesince,         
                                     lastpayment,  
             RelativePlacement,
             ProviderId,
                                  ProviderName  ) AS i         
                          CROSS apply (SELECT DISTINCT ', ' + ( placementtype )         
                                       FROM   placementresult AS s         
                                       WHERE  s.placementfamilyid =         
                                              i.placementfamilyid         
                                       ORDER  BY ', ' + ( placementtype )         
                                       FOR xml path ('')) AS g(y)),         
               counts         
               AS (SELECT Count(*) AS totalrows         
                   FROM   PlacementListResultset),         
               rankresultset         
               AS (SELECT placementfamilyid,         
                          familyname,         
                          [status],         
                          noofplacement,         
                          openbeds,         
                          activesince,         
                          lastpayment,         
                          placementtype,  
                          RelativePlacement,
                          ProviderId,
                                  ProviderName ,          
                          Count(*)         
                            OVER ()                  AS TotalCount,         
                          Rank()         
                            OVER (         
                              ORDER BY          
                            CASE WHEN @SortExpression = 'FamilyName' THEN FamilyName END,        
                            CASE WHEN @SortExpression = 'FamilyName DESC' THEN familyname END DESC,         
                            CASE WHEN @SortExpression = 'Status' THEN  status END,         
                            CASE WHEN @SortExpression = 'Status DESC' THEN status END DESC,         
                            CASE WHEN @SortExpression = 'Type' THEN  PlacementType END,         
                            CASE WHEN @SortExpression = 'Type DESC' THEN PlacementType END DESC,        
                            CASE WHEN @SortExpression = 'ShelterPlacement' THEN noofplacement END,         
                            CASE WHEN @SortExpression = 'ShelterPlacement DESC' THEN noofplacement END DESC,         
                            CASE WHEN @SortExpression = 'OpenBeds' THEN OpenBeds END,         
                            CASE WHEN @SortExpression = 'OpenBeds DESC' THEN OpenBeds END DESC,         
                            CASE WHEN @SortExpression = 'ACtiveSince ' THEN ACtiveSince END,         
                            CASE WHEN @SortExpression = 'ACtiveSince DESC' THEN ACtiveSince END DESC,         
                            CASE WHEN @SortExpression = 'LastPayment ' THEN LastPayment END,         
                            CASE WHEN @SortExpression = 'LastPayment DESC' THEN LastPayment END DESC,  
                            CASE WHEN @SortExpression = 'ProviderId ' THEN ProviderId END,         
                            CASE WHEN @SortExpression = 'ProviderId DESC' THEN ProviderId END DESC,         
                           
                            placementfamilyid) AS RowNumber         
                   FROM   PlacementListResultset)         
          SELECT TOP (CASE WHEN (@PageNumber = -1) THEN (SELECT Isnull(totalrows         
          ,         
          0)         
          FROM counts)         
          ELSE (@PageSize) END) placementfamilyid,         
                                familyname,         
                                [status],         
                                placementtype,         
                                noofplacement,         
                                openbeds,         
                                activesince,         
                                lastpayment AS lastpayment,
                                ProviderId,
                                ProviderName,      
                                TotalCount,        
                                rownumber,  
                                RelativePlacement         
          INTO   #finalresultset         
          FROM   rankresultset         
          WHERE  rownumber > ( ( @PageNumber - 1 ) * @PageSize );         
        
          IF (SELECT Isnull(Count(*), 0)         
              FROM   #finalresultset) < 1         
            BEGIN         
                SELECT 0 AS PageNumber,         
     0 AS NumberOfPages,         
                       0 AS NumberOfRows;         
            END         
          ELSE         
            BEGIN         
                SELECT TOP 1 @PageNumber           AS PageNumber,         
                             CASE ( totalcount % @PageSize )         
                               WHEN 0 THEN Isnull(( totalcount / @PageSize ), 0)         
                               ELSE Isnull((totalcount / @PageSize), 0) + 1         
                             END                   AS NumberOfPages,         
                             Isnull(totalcount, 0) AS NumberOfRows         
                FROM   #finalresultset;         
            END         
        
          SELECT placementfamilyid,         
                 familyname,         
                 placementtype,         
                 [status],         
                 noofplacement,         
                 openbeds,         
                 CONVERT(VARCHAR,activesince ,101) as activesince,  
                 RelativePlacement,
                 ProviderId,
                 ProviderName     
          FROM   #finalresultset;         
      END try         
        
      BEGIN catch         
          DECLARE @Error AS VARCHAR (8000);         
        
          SET @Error = CONVERT (VARCHAR, Error_number()) + '*****'         
                       + CONVERT (VARCHAR (4000), Error_message())         
                       + '*****'         
                       + Isnull(CONVERT (VARCHAR, Error_procedure()),         
                       'ssp_ListPagePlacementFamilies')         
                       + '*****' + CONVERT (VARCHAR, Error_line())         
                       + '*****' + CONVERT (VARCHAR, Error_severity())         
                       + '*****' + CONVERT (VARCHAR, Error_state());         
        
          RAISERROR (@Error,16,1);         
      -- Message text.           Severity.           State.                   
      END catch         
  END       

GO
