/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCProviderRatesDetails]    Script Date: 08/14/2014 17:48:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageSCProviderRatesDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPageSCProviderRatesDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCProviderRatesDetails]    Script Date: 08/14/2014 17:48:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE  [dbo].[ssp_ListPageSCProviderRatesDetails]
(    
 @InsurerId    INT,   
 @Sites     INT,  
 @Member     INT,  
 @Contracts    INT,  
 @EffectiveAsOf   DATE = null,  
 @providerID    INT,  
 @SortExpression   VARCHAR(100),  
 @PageNumber    INT,  
 @PageSize    INT,  
 @OtherFilter   INT,  
 @StaffId INT = NULL
)    
As      
/********************************************************************/                            
/* Stored Procedure: dbo.ssp_ProviderRatesDetails     */                            
/* Copyright: 2005 Provider Claim Management System     */                            
/* Creation Date:  16 April 2014         */                            
/* Author: Rohith Uppin           */                            
/* Purpose: Used in the provider rates screen to fill Datagrid      */  
/*                 */  
/* Updates:                                                         */                            
/* Date          Author       Purpose                               */  
/* 7/13/2016  MD Hussain K    Added @StaffId parameter and StaffInsurers association. Ref : #881 SWMBH - Support  */  
/********************************************************************/     
  
BEGIN  
 BEGIN TRY  
  DECLARE @CustomFiltersApplied CHAR(1)  
  CREATE TABLE #CustomFilters(ContractRateId Int)  
  SET @CustomFiltersApplied = 'N'  
  
  -- Added on 7/13/2016 by MD Hussain
  Declare @AllInsurers varchar(1)             
  select TOP 1 @AllInsurers = AllInsurers from staff where staffid=@StaffId   and ISNULL(RecordDeleted,'N') <> 'Y' 
  ------End---------------------------
    
  CREATE TABLE #ResultSet  
  (  ContractRateId  INT,  
	ContractId INT,
    Code    VARCHAR(100),  
    Name    VARCHAR(100),  
    RateUnit   VARCHAR(100),  
    ContractRate  VARCHAR(100),  
    StartDate   DATE,  
    EndDate    DATE,  
    Site    VARCHAR(10),  
    Client    VARCHAR(10),  
    InsurerName   VARCHAR(100)    
  )  
    
  --GET CUSTOM FILTERS             
                                                                  
 IF @OtherFilter > 10000         
 BEGIN    
    
  SET @CustomFiltersApplied = 'Y'  
   
  INSERT INTO #CustomFilters(ContractRateId)  
    
  EXEC scsp_ListPageSCProviderRatesDetails  
    @InsurerId   = @InsurerId,  
    @Sites    = @Sites,  
    @Member    = @Member,  
    @Contracts   = @Contracts,  
    @EffectiveAsOf  = @EffectiveAsOf,  
    @providerID   = @providerID,  
    @OtherFilter  = @OtherFilter  
 END  
  
 INSERT INTO #ResultSet  
   ( ContractRateId  
    ,Code  
    ,Name  
    ,RateUnit  
    ,ContractRate  
    ,StartDate  
    ,EndDate  
    ,SITE  
    ,Client  
    ,InsurerName  
    ,ContractId
   )  
   
 SELECT  CR.ContractRateId  
   ,BLC.BillingCode+' '+ISNULL(CR.Modifier1, '')+ ' '+ISNULL(CR.Modifier2, '') as Code  
   ,BLC.CodeName as Name  
   ,CAST(CAST(BLC.Units as DECIMAL(18,0)) as VARCHAR(20))+ ' ' + GC.CodeName as RateUnit  
   ,'$'+CONVERT(VARCHAR,CR.ContractRate ,1) as ContractRate     
   ,ISNULL(CR.StartDate,CT.StartDate) as StartDate  
   ,IsNull(CR.EndDate,CT.EndDate) as EndDate   
   ,CASE ISNULL(CR.SiteId, 0) WHEN 0 THEN 'No' ELSE 'Yes' END SITE  
   ,CASE ISNULL(CR.ClientId ,0) WHEN 0 THEN 'No' ELSE 'Yes' END Client  
   ,IR.InsurerName
   ,CT.ContractId
     
 FROM ContractRates CR  
  INNER JOIN BillingCodes BLC ON BLC.BillingCodeId = CR.BillingCodeId  
  INNER JOIN Contracts CT ON CT.ContractId = CR.ContractId  
  INNER JOIN Insurers IR ON IR.InsurerId = CT.InsurerId  
  INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = BLC.UnitType  
  INNER JOIN Providers PR ON PR.ProviderId = CT.ProviderId  
 WHERE (@CustomFiltersApplied = 'Y' AND EXISTS(select * from #CustomFilters cf where cf.ContractRateId = CR.ContractRateId)) OR   
  (@CustomFiltersApplied = 'N'  
  AND (PR.ProviderId = @providerID OR @providerID = -1)  
  AND (IR.InsurerId = @InsurerId OR @InsurerId = -1)  
  AND (CR.SiteId = @Sites OR @Sites = -1)  
  AND (CR.ClientId = @Member OR @Member = -1)  
  AND (CT.ContractId = @Contracts OR @Contracts = -1)  
  AND (CAST(CONVERT(varchar, ISNULL(CR.StartDate,CT.StartDate), 101) AS DATE) <= @EffectiveAsOf OR @EffectiveAsOf IS NULL)  
  AND (CAST(CONVERT(varchar, ISNULL(CR.EndDate,CT.EndDate), 101) AS DATE) >= @EffectiveAsOf OR @EffectiveAsOf IS NULL)  
  AND ISNULL(CT.RecordDeleted,'N') = 'N' AND ISNULL(BLC.RecordDeleted,'N') = 'N'  
  AND ISNULL(CR.RecordDeleted,'N') = 'N' AND ISNULL(IR.RecordDeleted,'N') = 'N'  
  AND ISNULL(GC.RecordDeleted,'N') = 'N' AND ISNULL(PR.RecordDeleted,'N') = 'N')
  -- Added on 7/13/2016 by MD Hussain  
  AND (Exists(Select 1 from StaffInsurers SI where SI.InsurerId= CT.InsurerId and SI.StaffId = @StaffId AND Isnull(SI.RecordDeleted,'N') = 'N') OR @AllInsurers='Y') 
    
 ;With counts   
       AS (SELECT Count(*) AS TotalRows FROM   #ResultSet),   
       RankResultSet AS (SELECT ContractRateId 
       ,ContractId 
       ,Code  
       ,Name  
       ,RateUnit  
       ,ContractRate  
       ,StartDate  
       ,EndDate  
       ,SITE  
       ,Client  
       ,InsurerName  
       , Count(*)   
         OVER ( )   AS TotalCount   
       , Rank()   
        OVER( ORDER BY                                
          CASE WHEN @SortExpression = 'ContractRateId' THEN ContractRateId END,   
          CASE WHEN @SortExpression = 'ContractRateId desc' THEN ContractRateId END DESC,  
          CASE WHEN @SortExpression = 'Code' THEN Code END,   
          CASE WHEN @SortExpression = 'Code desc' THEN Code END DESC,  
          CASE WHEN @SortExpression = 'Name' THEN Name END,   
          CASE WHEN @SortExpression = 'Name desc' THEN Name END DESC,  
          CASE WHEN @SortExpression = 'RateUnit' THEN RateUnit END,   
          CASE WHEN @SortExpression = 'RateUnit desc' THEN RateUnit END DESC,  
          CASE WHEN @SortExpression = 'ContractRate' THEN ContractRate END,   
          CASE WHEN @SortExpression = 'ContractRate desc' THEN ContractRate END DESC,  
          CASE WHEN @SortExpression = 'StartDate' THEN StartDate END,   
          CASE WHEN @SortExpression = 'StartDate desc' THEN StartDate END DESC,  
          CASE WHEN @SortExpression = 'EndDate' THEN EndDate END,   
          CASE WHEN @SortExpression = 'EndDate desc' THEN EndDate END DESC,  
          CASE WHEN @SortExpression = 'SITE' THEN SITE END,   
          CASE WHEN @SortExpression = 'SITE desc' THEN SITE END DESC,  
          CASE WHEN @SortExpression = 'Client' THEN Client END,   
          CASE WHEN @SortExpression = 'Client desc' THEN Client END DESC,  
          CASE WHEN @SortExpression = 'InsurerName' THEN InsurerName END,   
          CASE WHEN @SortExpression = 'InsurerName desc' THEN InsurerName END DESC,  
         ContractRateId )   
         AS RowNumber   
      FROM   #ResultSet)  
        
 SELECT TOP (CASE WHEN (@PageNumber = -1) THEN (SELECT Isnull(Totalrows, 0) FROM Counts) ELSE (@PageSize) END)  
   ContractRateId  
   ,ContractId
   ,Code  
   ,Name  
   ,RateUnit  
   ,ContractRate  
   ,StartDate  
   ,EndDate  
   ,SITE  
   ,Client  
   ,InsurerName  
   ,TotalCount   
   ,RowNumber   
   INTO   #FinalResultSet   
   FROM   RankResultSet   
   WHERE  RowNumber > ( ( @PageNumber - 1 ) * @PageSize )   
  
   IF (SELECT Isnull(Count(*), 0)   
   FROM   #FinalResultSet) < 1   
   BEGIN   
    SELECT 0   AS PageNumber   
        , 0 AS NumberOfPages   
        , 0 NumberOfRows   
   END   
   ELSE   
   BEGIN   
    SELECT TOP 1 @PageNumber AS PageNumber   
        , CASE ( TotalCount % @PageSize )   
         WHEN 0 THEN Isnull(( TotalCount / @PageSize ),0)   
         ELSE Isnull(( TotalCount / @PageSize ), 0) + 1   
          END NumberOfPages   
        , Isnull(TotalCount, 0) AS NumberOfRows   
    FROM   #FinalResultSet   
   END  
     
 SELECT ContractRateId  
	,ContractId
   ,Code  
   ,Name  
   ,RateUnit  
   ,ContractRate  
   ,CONVERT(varchar, StartDate,101) as StartDate  
   ,CONVERT(varchar, EndDate,101) as EndDate  
   ,SITE  
   ,Client  
   ,InsurerName  
  FROM   #FinalResultSet   
  ORDER  BY Rownumber  
   
END TRY  
  
BEGIN CATCH  
 DECLARE @Error VARCHAR(8000)   
  
      SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'   
                  + CONVERT(VARCHAR(4000), ERROR_MESSAGE())   
                  + '*****'   
                  + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),   
                  'ssp_ListPageSCProviderRatesDetails' )   
                  + '*****' + CONVERT(VARCHAR, ERROR_LINE())   
                  + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY())   
                  + '*****' + CONVERT(VARCHAR, ERROR_STATE())   
  
      RAISERROR ( @Error,-- Message text.                
                  16,-- Severity.                
                  1 -- State.                
      );  
END CATCH  
END  
GO


