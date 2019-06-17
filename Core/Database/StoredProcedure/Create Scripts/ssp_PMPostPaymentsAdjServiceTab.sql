
/****** Object:  StoredProcedure [dbo].[ssp_PMPostPaymentsAdjServiceTab]    Script Date: 06/10/2016 15:42:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PMPostPaymentsAdjServiceTab]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMPostPaymentsAdjServiceTab]
GO



/****** Object:  StoredProcedure [dbo].[ssp_PMPostPaymentsAdjServiceTab]    Script Date: 06/10/2016 15:42:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_PMPostPaymentsAdjServiceTab]    
 /******************************************************************************     
** File: ssp_PMPostPaymentsAdjServiceTab.sql    
** Name: ssp_PMPostPaymentsAdjServiceTab    
** Desc: This SP returns the drop down values for posting Payments    
**     
** This template can be customized:     
**     
** Return values:     
**     
** Called by:     
**     
** Parameters:     
** Input Output     
** ---------- -----------     
**     
** Auth: Mary Suma    
** Date: 10/05/2011    
*******************************************************************************     
** Change History     
*******************************************************************************     
** Date:    Author:    Description:     
**     
--------    --------    ---------------     
-- 24 Aug 2011  Girish   Removed References to Rowidentifier and/or ExternalReferenceId    
-- 27 Aug 2011  Girish   Readded References to Rowidentifier and ExternalReferenceId    
-- 05 Sep 2011  Msuma   Included additional filter to remove Deleted Records from Ledger    
-- 06 Sep 2011  Msuma   Included Paging for PostingPayments services Tab    
-- 12 Sep 2011      MSuma   Fix for Paging    
-- 21 Sep 2011     Girish   Changed criteria for set parentid and created new resultset for separation of parent and child data    
-- 23 Sep 2011     Girish           Added HasChild column to the final parent select    
-- 28 Sep 2011     Girish   Changed detail page to listpage as per Suma and Slavik     
-- 28 Sep 2011     Girish   Added Style column for nested grid in the final selects     
-- 08 Dec 2011     Msuma   Formatted Date      
-- 16 May 2012     Msuma   Modified Date for Parent       
-- JAN-16-2014  dharvey   Modified Row sorting based on conditional logic with secondary Name, DateOfService sorting    
--DEC -18-2015    Basudev Sahu      Modified For Task #609 Network180 Customization to Get Organisation  As ClientName
--June -10 -2016  Deej/Pradeep Kumar Yadav   Modified the SP Check the condition when page number is -1 For Task #583 Thresholds - Support  
--02/10/2017      jcarlson       Keystone Customizations 69 - increased documentname length to 500 to handle procedure code display as increasing to 75 
*******************************************************************************/    
 @SessionId VARCHAR(30)    
 ,@InstanceId INT    
 ,@PageNumber INT    
 ,@PageSize INT    
 ,@SortExpression VARCHAR(100)    
 ,@ParamFinancialActivityId INT    
AS    
BEGIN    
 BEGIN TRY    
  CREATE TABLE #FinancialActivitySummary (    
   RowNumber INT    
   ,PageNumber INT    
   ,Identity1 INT IDENTITY(1, 1) NOT NULL    
   ,EditImage BINARY NULL    
   ,EditButton CHAR(1) NULL    
   ,ParentId INT NULL    
   ,ServiceId INT NULL    
   ,ChargeId INT NULL    
   ,FinancialActivityId INT NULL    
   ,FinancialActivityLineId INT NULL    
   ,CurrentVersion INT NULL    
   ,FinancialActivityVersion INT NULL    
   ,[Name] VARCHAR(100) NULL    
   ,DateOfService DATETIME NULL    
   ,ProcedureUnit VARCHAR(500) NULL    
   ,Balance MONEY NULL    
   ,Charge MONEY NULL    
   ,Payment MONEY NULL    
   ,PaymentID INT NULL    
   ,Adjustment MONEY NULL    
   ,LedgerType VARCHAR(10) NULL    
   ,Transfer MONEY NULL    
   ,BitmapPresent VARCHAR(10) NULL    
   ,Bitmap BINARY NULL    
   ,Comment VARCHAR(100) NULL    
   )    
    
  CREATE TABLE #FinancialActivitySummaryFirst (    
   RowNumber INT    
   ,PageNumber INT    
   ,Identity1 INT NOT NULL    
   ,EditImage BINARY NULL    
   ,EditButton CHAR(1) NULL    
   ,ParentId INT NULL    
   ,ServiceId INT NULL    
   ,ChargeId INT NULL    
   ,FinancialActivityId INT NULL    
   ,FinancialActivityLineId INT NULL    
   ,CurrentVersion INT NULL    
   ,FinancialActivityVersion INT NULL    
   ,[Name] VARCHAR(100) NULL    
   ,DateOfService DATETIME NULL    
   ,ProcedureUnit VARCHAR(500) NULL    
   ,Balance MONEY NULL    
   ,Charge MONEY NULL    
   ,Payment MONEY NULL    
   ,PaymentID INT NULL    
   ,Adjustment MONEY NULL    
   ,LedgerType VARCHAR(10) NULL    
   ,Transfer MONEY NULL    
   ,BitmapPresent VARCHAR(10) NULL    
   ,Bitmap BINARY NULL    
   ,Comment VARCHAR(100) NULL    
   )    
    
  CREATE TABLE #FinancialActivitySummaryRest (    
   Identity1 INT NOT NULL    
   ,ParentId INT NULL    
   ,ServiceId INT NULL    
   ,ChargeId INT NULL    
   ,FinancialActivityId INT NULL    
   ,FinancialActivityLineId INT NULL    
   ,CurrentVersion INT NULL    
   ,FinancialActivityVersion INT NULL    
   ,[Name] VARCHAR(100) NULL    
   ,DateOfService DATETIME NULL    
   ,ProcedureUnit VARCHAR(500) NULL    
   ,Balance MONEY NULL    
   ,Charge MONEY NULL    
   ,Payment MONEY NULL    
   ,PaymentID INT NULL    
   ,Adjustment MONEY NULL    
   ,LedgerType VARCHAR(10) NULL    
   ,Transfer MONEY NULL    
   ,BitmapPresent VARCHAR(10) NULL    
   ,Bitmap BINARY NULL    
   ,Comment VARCHAR(100) NULL    
   )    
    
  DECLARE @ApplyFilterClicked CHAR(1)    
    
  SET @SortExpression = RTRIM(LTRIM(@SortExpression))    
    
  IF ISNULL(@SortExpression, '') = ''    
   --SET @SortExpression= 'CoveragePlanName'    
   SET @SortExpression = 'Name'    
    
  DECLARE @strSQL NVARCHAR(MAX) = ''    
    
  --     
  -- If a specific page was requested, goto GetPage and retrieve this page of the previously selected data                                                      
  --                                                      
  IF (@PageNumber = -1 OR @PageNumber > 0)    --June -10 -2016  Deej/Pradeep Kumar Yadav
   AND EXISTS (    
    SELECT *    
    FROM ListPagePMPostPaymentsAdjServicesTabs    
    WHERE SessionId = @SessionId    
     AND InstanceId = @InstanceId    
    )    
  BEGIN    
   SET @ApplyFilterClicked = 'N'    
    
   GOTO GetPage    
  END    
    
  --     
  -- New retrieve - the request came by clicking on the Apply Filter button                       
  --    
  SET @ApplyFilterClicked = 'Y'    
  SET @PageNumber = 1    
    
  INSERT INTO #FinancialActivitySummary (    
   ServiceId    
   ,ChargeId    
   ,FinancialActivityId    
   ,FinancialActivityLineId    
   ,CurrentVersion    
   ,FinancialActivityVersion    
   ,[Name]    
   ,DateOfService    
   ,ProcedureUnit    
   ,Balance    
   ,Charge    
   ,Payment    
   ,PaymentId    
   ,Adjustment    
   ,LedgerType    
   ,Transfer    
   ,ParentId    
   ,BitmapPresent    
   ,EditButton    
   ,Comment    
   )    
  SELECT s.ServiceId    
   ,MAX(CASE     
     WHEN ch.ChargeId = fal.ChargeId    
      THEN ch.ChargeId    
     ELSE 0    
     END)    
   ,fal.FinancialActivityId    
   ,fal.FinancialActivityLineId    
   ,fal.CurrentVersion    
   ,arl.FinancialActivityVersion    
   ,MAX(    
   CASE         
      WHEN ISNULL(C.ClientType, 'I') = 'I'    
       THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')    
      ELSE ISNULL(C.OrganizationName, '')    
      END     
   --c.LastName + ', ' + c.FirstName    
   ) AS [Name]    
   ,    
   --Modified by MSuma    
   MAX(arl.DateOfService) AS DateOfService    
   ,MAX(pc.DisplayAs + ' ' + CONVERT(VARCHAR, s.Unit) + ' ' + gc.CodeName) AS ProcedureUnit    
   ,MAX(oc.Balance)    
   ,MAX(s.Charge)    
   ,SUM(CASE     
     WHEN arl.LedgerType = 4202    
      THEN arl.Amount    
     ELSE 0    
     END)    
   ,MAX(arl.PaymentId)    
   ,SUM(CASE     
     WHEN arl.LedgerType = 4203    
      THEN arl.Amount    
     ELSE 0    
     END)    
   ,MAX(arl.LedgerType)    
   ,SUM(CASE     
     WHEN arl.LedgerType = 4204    
      AND ch.ChargeId = fal.ChargeId    
      THEN arl.Amount    
     ELSE 0    
     END)    
   ,    
   --sum(case when arl.LedgerType = 4204 and arl.Amount < 0 then arl.Amount else 0 end),            
   0    
   ,CASE     
    WHEN MAX(ch.Flagged) = 'Y'    
     THEN 'Yes'    
    ELSE NULL    
    END    
   ,CASE     
    WHEN fal.CurrentVersion = arl.FinancialActivityVersion    
     THEN 'E'    
    ELSE NULL    
    END    
   ,MAX(CONVERT(VARCHAR(100), fal.Comment))    
  FROM Arledger arl    
  JOIN FinancialActivityLines fal ON fal.FinancialActivityLineId = arl.FinancialActivityLineId    
  JOIN Charges ch ON ch.ChargeId = arl.ChargeId    
  JOIN Services s ON s.ServiceId = ch.ServiceId    
  JOIN Clients c ON c.ClientId = s.ClientId    
  LEFT JOIN OpenCharges oc ON oc.ChargeId = ch.ChargeId    
  JOIN ProcedureCodes pc ON pc.ProcedurecodeId = s.ProcedureCodeId    
  LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = s.UnitType    
  WHERE ISNULL(arl.ErrorCorrection, 'N') = 'N'    
   AND fal.FinancialActivityId = @ParamFinancialActivityId    
  GROUP BY s.ServiceId    
   ,fal.FinancialActivityId    
   ,fal.FinancialActivityLineId    
   ,fal.CurrentVersion    
   ,arl.FinancialActivityVersion    
  ORDER BY s.ServiceId    
   ,fal.FinancialActivityId    
   ,fal.FinancialActivityLineId    
   ,CASE     
    WHEN fal.CurrentVersion = arl.FinancialActivityVersion    
     THEN 1    
    ELSE 2    
    END    
   ,arl.FinancialActivityVersion DESC    
    
  -- Set parent Id             
  UPDATE fas    
  SET ParentId = fas2.Identity1    
  FROM #FinancialActivitySummary fas    
  JOIN #FinancialActivitySummary fas2 ON fas2.ServiceId = fas.ServiceId    
   AND fas2.FinancialActivityLineId = fas.FinancialActivityLineId    
   AND fas2.EditButton = 'E'    
  WHERE ISNULL(fas.EditButton, '') <> 'E'    
    
  --Suma: Included additional filter to remove Deleted Records from Ledger    
  DELETE    
  FROM #FinancialActivitySummary    
  WHERE FinancialActivityLineId NOT IN (    
    SELECT fs.FinancialActivityLineId    
    FROM #FinancialActivitySummary fs    
    JOIN ARLedger ar ON fs.FinancialActivityLineId = ar.FinancialActivityLineId    
    WHERE fs.CurrentVersion = ar.FinancialActivityVersion    
    )    
    
  --Parent data    
  INSERT INTO #FinancialActivitySummaryFirst    
  SELECT *    
  FROM #FinancialActivitySummary    
  WHERE ParentId = 0    
    
  --Child data    
  INSERT INTO #FinancialActivitySummaryRest (    
   Identity1    
   ,ServiceId    
   ,ChargeId    
   ,FinancialActivityId    
   ,FinancialActivityLineId    
   ,CurrentVersion    
   ,FinancialActivityVersion    
   ,[Name]    
   ,DateOfService    
   ,ProcedureUnit    
   ,Balance    
   ,Charge    
   ,Payment    
   ,PaymentId    
   ,Adjustment    
   ,LedgerType    
   ,Transfer    
   ,ParentId    
   ,BitmapPresent    
   ,Comment    
   )    
  SELECT Identity1    
   ,ServiceId    
   ,ChargeId    
   ,FinancialActivityId    
   ,FinancialActivityLineId    
   ,CurrentVersion    
   ,FinancialActivityVersion    
   ,[Name]    
   ,DateOfService    
   ,ProcedureUnit    
   ,Balance    
   ,Charge    
   ,Payment    
   ,PaymentId    
   ,Adjustment    
   ,LedgerType    
   ,Transfer    
   ,ParentId    
   ,BitmapPresent    
   ,Comment    
  FROM #FinancialActivitySummary    
  WHERE ParentId != 0    
    
  GetPage:    
    
  IF @ApplyFilterClicked = 'N'    
   AND EXISTS (    
    SELECT *    
    FROM ListPagePMPostPaymentsAdjServicesTabs    
    WHERE SessionId = @SessionId    
     AND InstanceId = @InstanceId    
     AND SortExpression = @SortExpression    
    )    
   GOTO Final    
    
  SET @PageNumber = 1    
    
  IF @ApplyFilterClicked = 'N'    
  BEGIN    
   INSERT INTO #FinancialActivitySummaryFirst (    
    Identity1    
    ,ServiceId    
    ,ChargeId    
    ,FinancialActivityId    
    ,FinancialActivityLineId    
    ,CurrentVersion    
    ,FinancialActivityVersion    
    ,[Name]    
    ,DateOfService    
    ,ProcedureUnit    
    ,Balance    
    ,Charge    
    ,Payment    
    ,PaymentId    
    ,Adjustment    
    ,LedgerType    
    ,Transfer    
    ,ParentId    
    ,BitmapPresent    
    ,EditButton    
    ,Comment    
    )    
   SELECT Identity1    
    ,ServiceId    
    ,ChargeId    
    ,FinancialActivityId    
    ,FinancialActivityLineId    
    ,CurrentVersion    
    ,FinancialActivityVersion    
    ,[Name]    
    ,DateOfService    
    ,ProcedureUnit    
    ,Balance    
    ,Charge    
    ,Payment    
    ,PaymentId    
    ,Adjustment    
    ,LedgerType    
    ,Transfer    
    ,ParentId    
    ,BitmapPresent    
    ,EditButton    
    ,Comment    
   FROM ListPagePMPostPaymentsAdjServicesTabs    
   WHERE SessionId = @SessionId    
    AND InstanceId = @InstanceId    
    
   INSERT INTO #FinancialActivitySummaryRest (    
    Identity1    
    ,ServiceId    
    ,ChargeId    
    ,FinancialActivityId    
    ,FinancialActivityLineId    
    ,CurrentVersion    
    ,FinancialActivityVersion    
    ,[Name]    
    ,DateOfService    
    ,ProcedureUnit    
    ,Balance    
    ,Charge    
    ,Payment    
    ,PaymentId    
    ,Adjustment    
    ,LedgerType    
    ,Transfer    
    ,ParentId    
    ,BitmapPresent    
    ,Comment    
    )    
   SELECT Identity1    
    ,ServiceId    
    ,ChargeId    
    ,FinancialActivityId    
    ,FinancialActivityLineId    
    ,CurrentVersion    
    ,FinancialActivityVersion    
    ,[Name]    
    ,DateOfService    
    ,ProcedureUnit    
    ,Balance    
    ,Charge    
    ,Payment    
    ,PaymentId    
    ,Adjustment    
    ,LedgerType    
    ,Transfer    
    ,ParentId    
    ,BitmapPresent    
    ,Comment    
   FROM ListPagePMPostPaymentsAdjServicesTabDrillDowns    
   WHERE SessionId = @SessionId    
    AND InstanceId = @InstanceId    
  END    
    
  /****** NEW Logic ******/    
  SET @strSQL = '    
            UPDATE  d    
            SET     RowNumber = rn.RowNumber ,    
                    PageNumber = ( rn.RowNumber / ' + CONVERT(VARCHAR(100), @PageSize) + ' )     
      + CASE WHEN rn.RowNumber % ' + CONVERT(VARCHAR(100), @PageSize) + ' = 0 THEN 0    
                                                                     ELSE 1    
                                                                END    
            FROM    #FinancialActivitySummaryFirst d    
                    JOIN ( SELECT   Identity1 ,    
                                    ROW_NUMBER() OVER ( ORDER BY      
           '    
    
  IF @SortExpression = 'Name'    
  BEGIN    
   SET @strSQL = @strSQL + ' Name,DateOfService'    
  END    
  ELSE IF @SortExpression = 'Name desc'    
  BEGIN    
   SET @strSQL = @strSQL + ' Name DESC,DateOfService'    
  END    
  ELSE IF @SortExpression = 'FinancialActivityLineId'    
  BEGIN    
   SET @strSQL = @strSQL + ' FinancialActivityLineId,Name,DateOfService'    
  END    
  ELSE IF @SortExpression = 'FinancialActivityLineId desc'    
  BEGIN    
   SET @strSQL = @strSQL + ' FinancialActivityLineId DESC,Name,DateOfService'    
  END    
  ELSE IF @SortExpression = 'DateOfService'    
  BEGIN    
   SET @strSQL = @strSQL + ' DateOfService,Name'    
  END    
  ELSE IF @SortExpression = 'DateOfService desc'    
  BEGIN    
   SET @strSQL = @strSQL + ' DateOfService DESC,Name'    
  END    
  ELSE IF @SortExpression = 'ProcedureUnit'    
  BEGIN    
   SET @strSQL = @strSQL + ' ProcedureUnit,Name,DateOfService'    
  END    
  ELSE IF @SortExpression = 'ProcedureUnit desc'    
  BEGIN    
   SET @strSQL = @strSQL + ' ProcedureUnit DESC,Name,DateOfService'    
  END    
  ELSE IF @SortExpression = 'Balance'    
  BEGIN    
   SET @strSQL = @strSQL + ' Balance,Name,DateOfService'    
  END    
  ELSE IF @SortExpression = 'Balance desc'    
  BEGIN    
   SET @strSQL = @strSQL + ' Balance DESC,Name,DateOfService'    
  END    
  ELSE IF @SortExpression = 'BitmapPresent'    
  BEGIN    
   SET @strSQL = @strSQL + ' BitmapPresent,Name,DateOfService'    
  END    
  ELSE IF @SortExpression = 'BitmapPresent desc'    
  BEGIN    
   SET @strSQL = @strSQL + ' BitmapPresent DESC,Name,DateOfService'    
  END    
  ELSE IF @SortExpression = 'Charge'    
  BEGIN    
   SET @strSQL = @strSQL + ' Charge,Name,DateOfService'    
  END    
  ELSE IF @SortExpression = 'Charge desc'    
  BEGIN    
   SET @strSQL = @strSQL + ' Charge DESC,Name,DateOfService'    
  END    
  ELSE IF @SortExpression = 'Payment'    
  BEGIN    
   SET @strSQL = @strSQL + ' Payment,Name,DateOfService'    
  END    
  ELSE IF @SortExpression = 'Payment desc'    
  BEGIN    
   SET @strSQL = @strSQL + ' Payment DESC,Name,DateOfService'    
  END    
  ELSE IF @SortExpression = 'Adjustment'    
  BEGIN    
   SET @strSQL = @strSQL + ' Adjustment,Name,DateOfService'    
  END    
  ELSE IF @SortExpression = 'Adjustment desc'    
  BEGIN    
   SET @strSQL = @strSQL + ' Adjustment DESC,Name,DateOfService'    
  END    
  ELSE IF @SortExpression = 'Transfer'    
  BEGIN    
   SET @strSQL = @strSQL + ' Transfer,Name,DateOfService'    
  END    
  ELSE IF @SortExpression = 'Transfer desc'    
  BEGIN    
   SET @strSQL = @strSQL + '  Transfer DESC,Name,DateOfService'    
  END    
  ELSE IF @SortExpression = 'Comment'    
  BEGIN    
   SET @strSQL = @strSQL + '  Comment,Name,DateOfService'    
  END    
  ELSE IF @SortExpression = 'Comment desc'    
  BEGIN    
   SET @strSQL = @strSQL + '  Comment DESC,Name,DateOfService'    
  END    
  ELSE    
  BEGIN    
   SET @strSQL = @strSQL + '  ServiceId'    
  END    
    
  SET @strSQL = @strSQL + ' ) AS RowNumber    
                           FROM     #FinancialActivitySummaryFirst    
                         ) rn ON rn.Identity1 = d.Identity1       '    
    
  EXEC sp_executeSQL @strSQL    
    
  /*       
   UPDATE d     
   SET RowNumber = rn.RowNumber,                             
    PageNumber = (rn.RowNumber/@PageSize) + CASE WHEN rn.RowNumber % @PageSize = 0 THEN 0 ELSE 1 END                                            
   FROM #FinancialActivitySummaryFirst d JOIN (SELECT Identity1, ROW_NUMBER() OVER (ORDER BY     
    CASE WHEN @SortExpression= 'FinancialActivityLineId'  THEN FinancialActivityLineId END,                                      
    CASE WHEN @SortExpression= 'FinancialActivityLineId desc' THEN FinancialActivityLineId END DESC,    
    CASE WHEN @SortExpression= 'Name'       THEN Name END,                                      
    CASE WHEN @SortExpression= 'Name desc'      THEN Name END DESC,    
    CASE WHEN @SortExpression= 'DateOfService'     THEN DateOfService END,                                      
    CASE WHEN @SortExpression= 'DateOfService desc'    THEN DateOfService END DESC,    
    CASE WHEN @SortExpression= 'ProcedureUnit'     THEN ProcedureUnit END,                                      
    CASE WHEN @SortExpression= 'ProcedureUnit desc'    THEN ProcedureUnit END DESC,    
    CASE WHEN @SortExpression= 'Balance'      THEN Balance END,                                      
    CASE WHEN @SortExpression= 'Balance desc'     THEN Balance END DESC,    
    CASE WHEN @SortExpression= 'BitmapPresent'     THEN BitmapPresent END,                                      
    CASE WHEN @SortExpression= 'BitmapPresent desc'    THEN BitmapPresent END DESC,    
    CASE WHEN @SortExpression= 'Charge'       THEN Charge END,                                      
    CASE WHEN @SortExpression= 'Charge desc'     THEN Charge END DESC,    
    CASE WHEN @SortExpression= 'Payment'      THEN Payment END,                                      
    CASE WHEN @SortExpression= 'Payment desc'     THEN Payment END DESC,    
    CASE WHEN @SortExpression= 'Adjustment'      THEN Adjustment END,                                      
    CASE WHEN @SortExpression= 'Adjustment desc'    THEN Adjustment END DESC,    
    CASE WHEN @SortExpression= 'Transfer'      THEN [Transfer] END,                                      
    CASE WHEN @SortExpression= 'Transfer desc'     THEN [Transfer] END DESC,    
    CASE WHEN @SortExpression= 'Comment'      THEN Comment END,                                      
    CASE WHEN @SortExpression= 'Comment desc'     THEN Comment END DESC,        
     Identity1    
    ) AS RowNumber FROM #FinancialActivitySummaryFirst) rn ON rn.Identity1 = d.Identity1     
    
*/    
  DELETE    
  FROM ListPagePMPostPaymentsAdjServicesTabDrillDowns    
  WHERE SessionId = @SessionId    
   AND InstanceId = @InstanceId    
    
  DELETE    
  FROM ListPagePMPostPaymentsAdjServicesTabs    
  WHERE SessionId = @SessionId    
   AND InstanceId = @InstanceId    
    
  INSERT INTO ListPagePMPostPaymentsAdjServicesTabs (    
   SessionId    
   ,InstanceId    
   ,RowNumber    
   ,PageNumber    
   ,SortExpression    
   ,Identity1    
   ,ServiceId    
   ,ChargeId    
   ,FinancialActivityId    
   ,FinancialActivityLineId    
   ,CurrentVersion    
   ,FinancialActivityVersion    
   ,[Name]    
   ,DateOfService    
   ,ProcedureUnit    
   ,Balance    
   ,Charge    
   ,Payment    
   ,PaymentId    
   ,Adjustment    
   ,LedgerType    
   ,Transfer    
   ,ParentId    
   ,BitmapPresent    
   ,EditButton    
   ,Comment    
   )    
  SELECT @SessionId    
   ,@InstanceId    
   ,RowNumber    
   ,PageNumber    
   ,@SortExpression    
   ,Identity1    
   ,ServiceId    
   ,ChargeId    
   ,FinancialActivityId    
   ,FinancialActivityLineId    
   ,CurrentVersion    
   ,FinancialActivityVersion    
   ,[Name]    
   ,DateOfService    
   ,ProcedureUnit    
   ,Balance    
   ,Charge    
   ,Payment    
   ,PaymentId    
   ,Adjustment    
   ,LedgerType    
   ,Transfer    
   ,ParentId    
   ,BitmapPresent    
   ,EditButton    
   ,Comment    
  FROM #FinancialActivitySummaryFirst    
    
  INSERT INTO ListPagePMPostPaymentsAdjServicesTabDrillDowns (    
   SessionId    
   ,InstanceId    
   ,Identity1    
   ,ServiceId    
   ,ChargeId    
   ,FinancialActivityId    
   ,FinancialActivityLineId    
   ,CurrentVersion    
   ,FinancialActivityVersion    
   ,[Name]    
   ,DateOfService    
   ,ProcedureUnit    
   ,Balance    
   ,Charge    
   ,Payment    
   ,PaymentId    
   ,Adjustment    
   ,LedgerType    
   ,Transfer    
   ,ParentId    
   ,BitmapPresent    
   ,Comment    
   )    
  SELECT @SessionId    
   ,@InstanceId    
   ,Identity1    
   ,ServiceId    
   ,ChargeId    
   ,FinancialActivityId    
   ,FinancialActivityLineId    
   ,CurrentVersion    
   ,FinancialActivityVersion    
   ,[Name]    
   ,DateOfService    
   ,ProcedureUnit    
   ,Balance    
   ,Charge    
   ,Payment    
   ,PaymentId    
   ,Adjustment    
   ,LedgerType    
   ,Transfer    
   ,ParentId    
   ,BitmapPresent    
   ,Comment    
  FROM #FinancialActivitySummaryRest    
  ORDER BY [Name]    
   ,DateOfService    
    
  Final:    
    
  SELECT @PageNumber AS PageNumber    
   ,ISNULL(MAX(PageNumber), 0) AS NumberOfPages    
   ,ISNULL(MAX(RowNumber), 0) AS NumberOfRows    
  FROM ListPagePMPostPaymentsAdjServicesTabs    
  WHERE SessionId = @SessionId    
   AND InstanceId = @InstanceId    
    
  SELECT Identity1    
   ,EditImage    
   ,EditButton    
   ,ParentId    
   ,ServiceId    
   ,ChargeId    
   ,FinancialActivityId    
   ,FinancialActivityLineId    
   ,CurrentVersion    
   ,FinancialActivityVersion    
   ,[Name]    
   ,    
   --Convert(VARCHAR,DateOfService,101) AS DateOfService,           
   CONVERT(VARCHAR(19), DateOfService, 101) + ' ' + LTRIM(SUBSTRING(CONVERT(VARCHAR(19), DateOfService, 100), 12, 6)) + ' ' + LTRIM(SUBSTRING(CONVERT(VARCHAR(19), DateOfService, 100), 18, 2)) AS DateOfService    
   ,ProcedureUnit    
   ,'$' + CONVERT(VARCHAR, Balance, 1) AS Balance    
   ,'$' + CONVERT(VARCHAR, Charge, 1) AS Charge    
   ,'$' + CONVERT(VARCHAR, - Payment, 1) AS Payment    
   ,PaymentID    
   ,'$' + CONVERT(VARCHAR, - Adjustment, 1) AS Adjustment    
   ,LedgerType    
   ,'$' + CONVERT(VARCHAR, - Transfer, 1) AS Transfer    
   ,BitmapPresent    
   ,Bitmap    
   ,Comment    
   ,(    
    SELECT CASE COUNT(*)    
      WHEN 0    
       THEN 'none'    
      ELSE 'block'    
      END    
    FROM ListPagePMPostPaymentsAdjServicesTabDrillDowns A    
    WHERE A.SessionId = @SessionId    
     AND A.InstanceId = @InstanceId    
     AND A.ParentId = ListPagePMPostPaymentsAdjServicesTabs.Identity1    
    ) AS HasChild    
   ,CASE     
    WHEN ISNULL(BitmapPresent, 'N') = 'N'    
     THEN 'none'    
    ELSE 'block'    
    END AS Style    
  FROM ListPagePMPostPaymentsAdjServicesTabs    
  WHERE SessionId = @SessionId    
   AND InstanceId = @InstanceId    
   AND (PageNumber = @PageNumber OR   @PageNumber =-1)   --June -10 -2016  Deej/Pradeep Kumar Yadav
  --ORDER BY dbo.ListPagePMPostPaymentsAdjServicesTabs.Name    
  ORDER BY PageNumber    
   ,RowNumber    
    
  SELECT Identity1    
   ,ParentId    
   ,ServiceId    
   ,ChargeId    
   ,FinancialActivityId    
   ,FinancialActivityLineId    
   ,CurrentVersion    
   ,FinancialActivityVersion    
   ,[Name]    
   ,    
   --Convert(VARCHAR,DateOfService,101) AS DateOfService,       
   CONVERT(VARCHAR(19), DateOfService, 101) + ' ' + LTRIM(SUBSTRING(CONVERT(VARCHAR(19), DateOfService, 100), 12, 6)) + ' ' + LTRIM(SUBSTRING(CONVERT(VARCHAR(19), DateOfService, 100), 18, 2)) AS DateOfService    
   ,ProcedureUnit    
   ,'$' + CONVERT(VARCHAR, Balance, 1) AS Balance    
   ,'$' + CONVERT(VARCHAR, Charge, 1) AS Charge    
   ,'$' + CONVERT(VARCHAR, - Payment, 1) AS Payment    
   ,PaymentID    
   ,'$' + CONVERT(VARCHAR, - Adjustment, 1) AS Adjustment    
   ,LedgerType    
   ,'$' + CONVERT(VARCHAR, - Transfer, 1) AS Transfer    
   ,BitmapPresent    
   ,Bitmap    
   ,Comment    
   ,CASE     
    WHEN ISNULL(BitmapPresent, 'N') = 'N'    
     THEN 'none'    
    ELSE 'block'    
    END AS Style    
  FROM ListPagePMPostPaymentsAdjServicesTabDrillDowns A    
  WHERE A.SessionId = @SessionId    
   AND A.InstanceId = @InstanceId    
   AND EXISTS (    
    SELECT *    
    FROM ListPagePMPostPaymentsAdjServicesTabs B    
    WHERE B.SessionId = @SessionId    
     AND B.InstanceId = @InstanceId    
     AND (@PageNumber=-1 OR B.PageNumber = @PageNumber )     --June -10 -2016  Deej/Pradeep Kumar Yadav
     AND A.ParentId = B.Identity1    
    )    
 END TRY    
    
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)    
    
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMPostPaymentsAdjServiceTab') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(
  
VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @Error    
    ,-- Message text.    
    16    
    ,-- Severity.    
    1 -- State.    
    );    
 END CATCH    
    
 SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
END 
GO


