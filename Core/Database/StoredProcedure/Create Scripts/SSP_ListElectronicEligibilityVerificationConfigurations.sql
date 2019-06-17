/****** Object:  StoredProcedure [dbo].[SSP_ListElectronicEligibilityVerificationConfigurations]    Script Date: 03/02/2016 18:02:16 ******/

IF EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SSP_ListElectronicEligibilityVerificationConfigurations]')
          AND type IN(N'P', N'PC')
)
    DROP PROCEDURE [dbo].[SSP_ListElectronicEligibilityVerificationConfigurations];
GO

/****** Object:  StoredProcedure [dbo].[SSP_ListElectronicEligibilityVerificationConfigurations]    Script Date: 03/02/2016 18:02:16 ******/

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE [dbo].[SSP_ListElectronicEligibilityVerificationConfigurations]
	
/********************************************************************************                                                            
-- Stored Procedure: SSP_ListElectronicEligibilityVerificationConfigurations          
--          
-- Copyright: Streamline Healthcate Solutions          
--          
-- Purpose: Query to return List of Configurations
--          
-- Author:  PradeepA          
-- Date:    Sept 15 2017         
--           
-- *****History****          
-- Author:    Date			Reason          

*********************************************************************************/

@PageNumber                                       INT,
@PageSize                                         INT,
@SortExpression                                   VARCHAR(100),
@ElectronicEligibilityVerificationConfigurationId INT
AS
     BEGIN
         BEGIN TRY
             SET @SortExpression = RTRIM(LTRIM(@SortExpression));
             IF ISNULL(@SortExpression, '') = ''
                 SET @SortExpression = 'ProviderName';
             SET NOCOUNT ON;
             PRINT @SortExpression;
             CREATE TABLE #ElectronicEligibilityVerificationConfigurations(ElectronicEligibilityVerificationConfigurationId INT);
             
             WITH TotalConfigurations
                  AS (SELECT DISTINCT
                             EC.ElectronicEligibilityVerificationConfigurationId AS ElectronicEligibilityVerificationConfigurationId,
                             EC.ProviderName,
                             EC.SourceName
                      FROM ElectronicEligibilityVerificationConfigurations EC
                           LEFT JOIN ElectronicEligibilityVerificationPayers EP ON EP.ElectronicEligibilityVerificationConfigurationId = EC.ElectronicEligibilityVerificationConfigurationId
                      WHERE(EC.ElectronicEligibilityVerificationConfigurationId = @ElectronicEligibilityVerificationConfigurationId
                            OR ISNULL(@ElectronicEligibilityVerificationConfigurationId, -1) = -1)
                           AND ISNULL(EC.RecordDeleted, 'N') = 'N'
                           AND ISNULL(EP.RecordDeleted, 'N') = 'N'),
                  counts
                  AS (SELECT COUNT(*) AS totalrows
                      FROM TotalConfigurations),
                  ListConfigurations
                  AS (SELECT ElectronicEligibilityVerificationConfigurationId,
                             ProviderName,
                             SourceName,
                             COUNT(*) OVER() AS TotalCount,
                             ROW_NUMBER() OVER(ORDER BY CASE
                                                            WHEN @SortExpression = 'ElectronicEligibilityVerificationConfigurationId'
                                                            THEN ElectronicEligibilityVerificationConfigurationId
                                                        END,
                                                        CASE
                                                            WHEN @SortExpression = 'ElectronicEligibilityVerificationConfigurationId DESC'
                                                            THEN ElectronicEligibilityVerificationConfigurationId
                                                        END DESC,
                                                        CASE
                                                            WHEN @SortExpression = 'ProviderName'
                                                            THEN ProviderName
                                                        END,
                                                        CASE
                                                            WHEN @SortExpression = 'ProviderName DESC'
                                                            THEN ProviderName
                                                        END DESC,
                                                        CASE
                                                            WHEN @SortExpression = 'SourceName'
                                                            THEN SourceName
                                                        END,
                                                        CASE
                                                            WHEN @SortExpression = 'SourceName DESC'
                                                            THEN SourceName
                                                        END DESC) AS RowNumber
                      FROM TotalConfigurations)
                  SELECT TOP (CASE
                                  WHEN(@PageNumber = -1)
                                  THEN
                             (
                                 SELECT ISNULL(totalrows, 0)
                                 FROM counts
                             )
                                  ELSE(@PageSize)
                              END) ElectronicEligibilityVerificationConfigurationId,
                                   ProviderName,
                                   SourceName,
                                   TotalCount,
                                   RowNumber
                  INTO #FinalResultSet
                  FROM ListConfigurations
                  WHERE RowNumber > ((@PageNumber - 1) * @PageSize);
             IF
             (
                 SELECT ISNULL(COUNT(*), 0)
                 FROM #FinalResultSet
             ) < 1
                 BEGIN
                     SELECT 0 AS PageNumber,
                            0 AS NumberOfPages,
                            0 NumberOfRows;
                 END;
             ELSE
                 BEGIN
                     SELECT TOP 1 @PageNumber AS PageNumber,
                                  CASE(TotalCount % @PageSize)
                                      WHEN 0
                                      THEN ISNULL((TotalCount / @PageSize), 0)
                                      ELSE ISNULL((TotalCount / @PageSize), 0) + 1
                                  END AS NumberOfPages,
                                  ISNULL(TotalCount, 0) AS NumberOfRows
                     FROM #FinalResultSet;
                 END;
             SELECT ElectronicEligibilityVerificationConfigurationId,
                    ProviderName,
                    SourceName
             FROM #FinalResultSet;
             DROP TABLE #FinalResultSet;
             DROP TABLE #ElectronicEligibilityVerificationConfigurations;
         END TRY
         BEGIN CATCH
             DECLARE @Error VARCHAR(8000);
             SET @Error = CONVERT(VARCHAR, ERROR_NUMBER())+'*****'+CONVERT(VARCHAR(4000), ERROR_MESSAGE())+'*****'+ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'SSP_ListElectronicEligibilityVerificationConfigurations')+'*****'+CONVERT(VARCHAR, ERROR_LINE())+'*****'+CONVERT(VARCHAR, ERROR_SEVERITY())+'*****'+CONVERT(VARCHAR, ERROR_STATE());
             RAISERROR(@Error, -- Message text.          
             16, -- Severity.          
             1 -- State.          
             );
         END CATCH;
     END;
GO