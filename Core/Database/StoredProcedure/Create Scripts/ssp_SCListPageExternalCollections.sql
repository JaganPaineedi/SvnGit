
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPageExternalCollections]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCListPageExternalCollections]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCListPageExternalCollections]               
 @PageNumber INT              
 ,@PageSize INT              
 ,@SortExpression VARCHAR(100)            
 ,@StaffPrograms INT            
 ,@ExternalCollectionStatus INT             
 ,@ServiceArea INT            
 ,@ClientId INT            
 ,@SentFrom DATETIME            
 ,@SentTo DATETIME              
 ,@DOSFrom DATETIME              
 ,@DOSTo DATETIME            
 ,@CreatedFrom DATETIME              
 ,@CreatedTo DATETIME              
 ,@OtherFilter INT = NULL            
 ,@CollectionsAgencyId INT 
 ,@LoggedInStaffId INT= NULL           
 /********************************************************************************                                                      
-- Stored Procedure: ssp_SCListPageExternalCollections              
--                                                    
-- Copyright: Streamline Healthcare Solutions            
--                                                    
-- Purpose: Used By External Collections List Page          
--                                                    
-- Updates:                                                                   
-- Date				Author             Purpose            
-- 27.July.2018		Bibhu			   what:Added join with staffclients table to display associated clients for login staff  
          							   why:Engineering Improvement Initiatives- NBL(I) task #77 My office List Pages should always have StaffID as an input parameter                        
*********************************************************************************/            
AS            
BEGIN            
 BEGIN TRY   
 
 DECLARE @CustomFiltersApplied CHAR(1) = 'N'         
             
 IF @ServiceArea = 0              
    SET @ServiceArea = -1              
             
   CREATE TABLE #CustomFilters (ExternalCollectionChargeId INT)         
   CREATE TABLE #ResultSet (            
    ClientId INT            
   ,ClientName VARCHAR(200)            
   ,DOS datetime            
   ,ChargeId int            
   ,AgencyName varchar(250)            
   ,ProgramId int            
   ,ProgramName varchar(250)            
   ,ProcedureCodeId int            
   ,ProcedureCodeName varchar(250)            
   ,ChargeAmount money            
   ,ClientCharge money            
   ,Balance money            
   ,PaidAmount money            
   ,ExternalCollectionStauts varchar(250)            
   ,ExternalCollectionChargeId int           
   ,FinancialActivityLineId int         
   )            
   
   IF @OtherFilter > 10000
		BEGIN
			SET @CustomFiltersApplied = 'Y'

			INSERT INTO #CustomFilters (ExternalCollectionChargeId)
			EXEC scsp_SCListPageExternalCollections @PageNumber = @PageNumber
				,@PageSize = @PageSize
				,@SortExpression = @SortExpression
				,@StaffPrograms = @StaffPrograms
				,@ExternalCollectionStatus = @ExternalCollectionStatus
				,@ServiceArea = @ServiceArea
				,@ClientId = @ClientId
				,@SentFrom = @SentFrom
				,@SentTo = @SentTo
				,@DOSFrom = @DOSFrom
				,@DOSTo = @DOSTo
				,@CreatedFrom = @CreatedFrom
				,@CreatedTo = @CreatedTo
				,@OtherFilter = @OtherFilter
				,@CollectionsAgencyId = @CollectionsAgencyId
				
		END
               
   INSERT INTO #ResultSet             
   (            
    ClientId             
   ,ClientName            
   ,DOS             
   ,ChargeId             
   ,AgencyName             
   ,ProgramId            
   ,ProgramName            
   ,ProcedureCodeId             
   ,ProcedureCodeName             
   ,ChargeAmount             
   ,ClientCharge             
   ,Balance             
   ,PaidAmount             
   ,ExternalCollectionStauts             
   ,ExternalCollectionChargeId          
   ,FinancialActivityLineId        
   )            
   SELECT             
   C.ClientId            
   ,C.LastName+ ', ' +C.FirstName  AS ClientName            
   ,S.DateOfService            
   ,CH.ChargeId            
   ,CA.Name            
   ,P.ProgramId            
   ,P.ProgramName            
   ,PC.ProcedureCodeId            
   ,PC.ProcedureCodeName            
   ,S.Charge            
   ,(select SUM(CASE WHEN LedgerType IN ( 4201, 4204 ) THEN Amount ELSE 0 END) from ARLedger A WHERE A.ChargeId=CH.ChargeId AND ISNULL(A.RecordDeleted, 'N') = 'N')             
     ,OCH.Balance              
     ,TempPaidAmount.Amount              
     ,dbo.csf_GetGlobalCodeNameById(CH.ExternalCollectionStatus) AS ExteranlCollectionStatus            
     ,ECC.ExternalCollectionChargeId          
     ,ECC.FinancialActivityLineId        
   FROM Services S            
   INNER JOIN Clients C ON C.ClientId=S.ClientId            
   INNER JOIN  Charges CH ON CH.ServiceId=S.ServiceId            
   LEFT JOIN Programs P ON P.ProgramId=S.ProgramId AND ISNULL(P.RecordDeleted,'N')='N'            
   LEFT JOIN ServiceAreas SA ON SA.ServiceAreaId=P.ServiceAreaId AND ISNULL(SA.RecordDeleted,'N')='N'            
   LEFT JOIN ProcedureCodes PC ON PC.ProcedureCodeId=S.ProcedureCodeId AND ISNULL(PC.RecordDeleted,'N')='N'            
   LEFT JOIN dbo.OpenCharges OCH ON OCH.ChargeId = CH.ChargeId AND ISNULL(OCH.RecordDeleted,'N') = 'N'              
   LEFT JOIN (SELECT CG.ChargeId as NewChargeId, -SUM(ARL.Amount) as Amount FROM dbo.ARLedger ARL JOIN Charges CG ON CG.ChargeId=ARL.ChargeId               
     WHERE ARL.ChargeId = CG.ChargeId AND ARL.LedgerType = 4202 AND ISNULL(ARL.RecordDeleted, 'N') = 'N' GROUP BY CG.ChargeId)               
     AS TempPaidAmount on TempPaidAmount.NewChargeId = CH.ChargeId             
   JOIN ExternalCollectionCharges ECC ON ECC.ChargeId=CH.ChargeId  AND ISNULL(ECC.RecordDeleted,'N')='N'            
   JOIN ExternalCollections EC ON EC.ExternalCollectionId=ECC.ExternalCollectionId AND ISNULL(EC.RecordDeleted,'N')='N'
   INNER JOIN StaffClients sc ON   sc.StaffId = @LoggedInStaffId AND   sc.ClientId = C.ClientId ----- -- 27.July.2018		Bibhu	             
   LEFT JOIN CollectionAgencies CA ON CA.CollectionAgencyId=EC.CollectionAgencyId  AND ISNULL(CA.RecordDeleted,'N')='N'            
   LEFT JOIN (SELECT Distinct  ECBD.ExternalCollectionChargeId FROM  ExternalCollectionFileBatchDetails ECBD              
		JOIN ExternalCollectionFileBatches ECB ON ECB.ExternalCollectionFileBatchId=ECBD.ExternalCollectionFileBatchId AND ISNULL(ECB.RecordDeleted,'N')='N' 
			WHERE  ((Cast(ECB.SentDate  AS DATE)>= CAST(@SentFrom AS DATE )  OR  @SentFrom = ''  )            
			  and  (Cast(ECB.SentDate AS DATE) <=CAST (@SentTo AS DATE) OR @SentTo =''    ))            
					) AS t ON t.ExternalCollectionChargeId=ECC.ExternalCollectionChargeId       
   WHERE ((@CustomFiltersApplied = 'Y' AND EXISTS (SELECT * FROM #CustomFilters cf WHERE cf.ExternalCollectionChargeId = ECC.ExternalCollectionChargeId))
					OR (@CustomFiltersApplied = 'N' AND
		ISNULL(S.RecordDeleted,'N')='N'            
      AND ISNULL(C.RecordDeleted,'N')='N'            
      AND ISNULL(CH.RecordDeleted,'N')='N'           
      AND ( @CollectionsAgencyId = 0 OR        
   (@CollectionsAgencyId = CA.CollectionAgencyId))        
                   
    AND (            
     (P.ProgramId = @StaffPrograms )            
     OR (@StaffPrograms  = 0)            
     )            
    AND (            
     (CH.ExternalCollectionStatus= @ExternalCollectionStatus )            
     OR (@ExternalCollectionStatus  = 0)            
     )            
                 
    AND (            
     (SA.ServiceAreaId= @ServiceArea )            
     OR (@ServiceArea  = - 1)            
     )            
                 
     AND (            
     (C.ClientId= @ClientId )            
     OR (@ClientId  = 0)            
     )            
                 
    AND ((Cast(S.DateOfService  AS DATE)>= CAST(@DOSFrom AS DATE )  OR  @DOSFrom = ''  )          
      and  (Cast(S.DateOfService AS DATE) <=CAST (@DOSTo AS DATE) OR @DOSTo =''   )        
     )            
                 
      AND((Cast(ECC.CreatedDate  AS DATE)>= CAST(@CreatedFrom AS DATE )  OR  @CreatedFrom = '')            
      and  (Cast(ECC.CreatedDate AS DATE) <=CAST (@CreatedTo AS DATE) OR @CreatedTo ='')            
     )            
      ))          
;WITH Counts            
  AS (SELECT Count(*) AS TotalRows            
   FROM #ResultSet)            
   ,RankResultSet            
   AS (SELECT             
   ClientId             
   ,ClientName            
   ,DOS             
   ,ChargeId             
   ,AgencyName             
   ,ProgramId            
   ,ProgramName            
   ,ProcedureCodeId             
   ,ProcedureCodeName             
   ,ChargeAmount             
   ,ClientCharge             
   ,Balance             
   ,PaidAmount             
  ,ExternalCollectionStauts            
   ,ExternalCollectionChargeId            
   ,FinancialActivityLineId        
    ,Count(*) OVER () AS TotalCount            
    ,row_number() over (order by case when @SortExpression= 'ClientName' then ClientName end,                                            
      case when @SortExpression= 'ClientName desc' then ClientName end desc,                                                                                    
                                                case when @SortExpression= 'DOS' then DOS end,                                                                 
            case when @SortExpression= 'DOS desc' then DOS end desc,                                                                   
                                                case when @SortExpression= 'ChargeId' then ChargeId end,                                                                           
                                                case when @SortExpression= 'ChargeId desc' Then ChargeId end desc,                                                                                    
                                                                                                                                  
            case when @SortExpression= 'AgencyName' then AgencyName end,                                                                                        
                                                case when @SortExpression= 'AgencyName desc' then AgencyName end desc,              
                                                            
                                                case when @SortExpression= 'ProgramName' then ProgramName end,                                                           
                                                case when @SortExpression= 'ProgramName desc' then ProgramName end desc,              
                                                            
                                                case when @SortExpression= 'ProcedureCodeName' then ProcedureCodeName end,                                                                                        
                                                case when @SortExpression= 'ProcedureCodeName desc' then ProcedureCodeName end desc,             
                                                            
                                                case when @SortExpression= 'ChargeAmount' then ChargeAmount end,                                                                                        
                                                case when @SortExpression= 'ChargeAmount desc' then ChargeAmount end desc,             
                                                            
                                                case when @SortExpression= 'ClientCharge' then ClientCharge end,                                                                                        
                                                case when @SortExpression= 'ClientCharge desc' then ChargeAmount end desc,             
                                                                                                         
                                                case when @SortExpression= 'Balance' then Balance end,                                                                                        
                                                case when @SortExpression= 'Balance desc' then Balance end desc,            
                                                            
                                                case when @SortExpression= 'PaidAmount' then PaidAmount end,                                                                                        
                                                case when @SortExpression= 'PaidAmount desc' then PaidAmount end desc,            
                                                            
												case when @SortExpression= 'ExternalCollectionStauts' then ExternalCollectionStauts end,                                                                                        
                                                case when @SortExpression= 'ExternalCollectionStauts desc' then ExternalCollectionStauts end desc,                                                                        
                                                ChargeId) as RowNumber                  
            FROM #ResultSet )            
  SELECT TOP (CASE WHEN (@PageNumber = - 1)            
      THEN (SELECT ISNULL(TotalRows, 0) FROM Counts)            
     ELSE (@PageSize)            
     END            
    )  ClientId             
   ,ClientName            
   ,DOS             
   ,ChargeId             
   ,AgencyName             
   ,ProgramId            
   ,ProgramName            
   ,ProcedureCodeId             
   ,ProcedureCodeName             
   ,ChargeAmount             
   ,ClientCharge             
   ,Balance             
   ,PaidAmount             
   ,ExternalCollectionStauts            
   ,ExternalCollectionChargeId            
   ,FinancialActivityLineId        
   ,TotalCount            
   ,RowNumber            
  INTO #FinalResultSet            
  FROM RankResultSet            
  WHERE RowNumber > ((@PageNumber - 1) * @PageSize)            
            
  IF (SELECT ISNULL(Count(*), 0) FROM #FinalResultSet) < 1            
  BEGIN            
   SELECT 0 AS PageNumber            
    ,0 AS NumberOfPages            
    ,0 NumberofRows            
  END            
  ELSE            
  BEGIN            
   SELECT TOP 1 @PageNumber AS PageNumber            
    ,CASE (Totalcount % @PageSize)            
     WHEN 0            
      THEN ISNULL((Totalcount / @PageSize), 0)            
     ELSE ISNULL((Totalcount / @PageSize), 0) + 1            
     END AS NumberOfPages            
    ,ISNULL(Totalcount, 0) AS NumberofRows            
   FROM #FinalResultSet            
  END            
            
  SELECT ClientId             
   ,ClientName            
   ,CONVERT(varchar(10),DOS,101) AS DOS            
   ,ChargeId             
   ,AgencyName AS Agency            
   ,ProgramName AS Program            
   ,ProcedureCodeName AS ProcedureCode            
   ,ChargeAmount             
   ,ClientCharge             
,Balance             
   ,PaidAmount             
   ,ExternalCollectionStauts            
   ,ExternalCollectionChargeId            
   ,FinancialActivityLineId        
  FROM #FinalResultSet            
  ORDER BY RowNumber            
               
 END TRY            
            
 BEGIN CATCH            
  DECLARE @Error VARCHAR(8000)            
            
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCListPageExternalCollections') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())            
            
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


