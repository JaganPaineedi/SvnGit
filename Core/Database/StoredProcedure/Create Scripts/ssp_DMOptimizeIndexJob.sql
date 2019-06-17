IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_DMOptimizeIndexJob')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE ssp_DMOptimizeIndexJob;
    END;
GO

CREATE PROCEDURE ssp_DMOptimizeIndexJob @Debug CHAR(1) = 'N'
AS /******************************************************************************
**		File: 
**		Name: ssp_DMOptimizeIndexJob
**		Desc: 
**
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**
**		Auth: jcarlson
**		Date: 3/10/2017
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**      3/10/2017          jcarlson             created
*******************************************************************************/
    BEGIN TRY


	  --Get values from system configurations
        DECLARE @Databases NVARCHAR(MAX) = NULLIF(dbo.ssf_GetSystemConfigurationKeyValue('DBMaintenanceDatabases'), '')
          , @FragmentationLow NVARCHAR(MAX) = NULLIF(dbo.ssf_GetSystemConfigurationKeyValue('DBMaintenanceFragmentationLow'), '')
          , @FragmentationMedium NVARCHAR(MAX) = NULLIF(dbo.ssf_GetSystemConfigurationKeyValue('DBMaintenanceFragmentationMedium'), '')
          , @FragmentationHigh NVARCHAR(MAX) = NULLIF(dbo.ssf_GetSystemConfigurationKeyValue('DBMaintenanceFragmentationHigh'), '')
          , @FragmentationLevel1 INT = CONVERT(INT, NULLIF(dbo.ssf_GetSystemConfigurationKeyValue('DBMaintenanceFragmentationLevel1'), ''))
          , @FragmentationLevel2 INT = CONVERT(INT, NULLIF(dbo.ssf_GetSystemConfigurationKeyValue('DBMaintenanceFragmentationLevel2'), ''))
          , @PageCountLevel INT = CONVERT(INT, NULLIF(dbo.ssf_GetSystemConfigurationKeyValue('DBMaintenancePageCountLevel'), ''))
          , @SortInTempdb NVARCHAR(MAX) = NULLIF(dbo.ssf_GetSystemConfigurationKeyValue('DBMaintenanceSortInTempdb'), '')
          , @MaxDOP INT = CONVERT(INT, NULLIF(dbo.ssf_GetSystemConfigurationKeyValue('DBMaintenanceMaxDOP'), ''))
          , @FillFactor INT = CONVERT(INT, NULLIF(dbo.ssf_GetSystemConfigurationKeyValue('DBMaintenanceFillFactor'), ''))
          , @PadIndex NVARCHAR(MAX) = NULLIF(dbo.ssf_GetSystemConfigurationKeyValue('DBMaintenancePadIndex'), '')
          , @LOBCompaction NVARCHAR(MAX) = NULLIF(dbo.ssf_GetSystemConfigurationKeyValue('DBMaintenanceLOBCompaction'), '')
          , @UpdateStatistics NVARCHAR(MAX) = NULLIF(dbo.ssf_GetSystemConfigurationKeyValue('DBMaintenanceUpdateStatistics'), '')
          , @OnlyModifiedStatistics NVARCHAR(MAX) = NULLIF(dbo.ssf_GetSystemConfigurationKeyValue('DBMaintenanceOnlyModifiedStatistics'), '')
          , @StatisticsSample INT = CONVERT(INT, NULLIF(dbo.ssf_GetSystemConfigurationKeyValue('DBMaintenanceStatisticsSample'), ''))
          , @StatisticsResample NVARCHAR(MAX) = NULLIF(dbo.ssf_GetSystemConfigurationKeyValue('DBMaintenanceStatisticsResample'), '')
          , @PartitionLevel NVARCHAR(MAX) = NULLIF(dbo.ssf_GetSystemConfigurationKeyValue('DBMaintenancePartitionLevel'), '')
          , @MSShippedObjects NVARCHAR(MAX) = NULLIF(dbo.ssf_GetSystemConfigurationKeyValue('DBMaintenanceMSShippedObjects'), '')
          , @Indexes NVARCHAR(MAX) = NULLIF(dbo.ssf_GetSystemConfigurationKeyValue('DBMaintenanceIndexes'), '')
          , @TimeLimit INT = CONVERT(INT, NULLIF(dbo.ssf_GetSystemConfigurationKeyValue('DBMaintenanceTimeLimit'), ''))
          , @Delay INT = CONVERT(INT, NULLIF(dbo.ssf_GetSystemConfigurationKeyValue('DBMaintenanceDelay'), ''))
          , @WaitAtLowPriorityMaxDuration INT = CONVERT(INT, NULLIF(dbo.ssf_GetSystemConfigurationKeyValue('DBMaintenanceWaitAtLowPriorityMaxDuration'), ''))
          , @WaitAtLowPriorityAbortAfterWait NVARCHAR(MAX) = NULLIF(dbo.ssf_GetSystemConfigurationKeyValue('DBMaintenanceWaitAtLowPriorityAbortAfterWait'), '')
          , @AvailabilityGroups NVARCHAR(MAX) = NULLIF(dbo.ssf_GetSystemConfigurationKeyValue('DBMaintenanceAvailabilityGroups'), '')
          , @LockTimeout INT = CONVERT(INT, NULLIF(dbo.ssf_GetSystemConfigurationKeyValue('DBMaintenanceLockTimeout'), ''))
          , @LogToTable NVARCHAR(MAX) = LEFT(NULLIF(dbo.ssf_GetSystemConfigurationKeyValue('DBMaintenanceLogToTable'), ''), 1)
          , @Execute NVARCHAR(MAX) = LEFT(NULLIF(dbo.ssf_GetSystemConfigurationKeyValue('DBMaintenanceExecute'), ''), 1);
		--Set Defaults if no value provided from system configurations
        SELECT  @FragmentationMedium = CASE WHEN @FragmentationMedium IS NULL THEN 'INDEX_REORGANIZE,INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE'
                                            ELSE @FragmentationMedium
                                       END, @FragmentationHigh = CASE WHEN @FragmentationHigh IS NULL THEN 'INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE'
                                                                      ELSE @FragmentationHigh
                                                                 END, @FragmentationLevel1 = CASE WHEN @FragmentationLevel1 IS NULL THEN 5
                                                                                                  ELSE @FragmentationLevel1
                                                                                             END,
                @FragmentationLevel2 = CASE WHEN @FragmentationLevel2 IS NULL THEN 30
                                            ELSE @FragmentationLevel2
                                       END, @PageCountLevel = CASE WHEN @PageCountLevel IS NULL THEN 50
                                                                   ELSE @PageCountLevel
                                                              END, @SortInTempdb = CASE WHEN @SortInTempdb IS NULL THEN 'N'
                                                                                        ELSE @SortInTempdb
                                                                                   END, @LOBCompaction = CASE WHEN @LOBCompaction IS NULL THEN 'Y'
                                                                                                              ELSE @LOBCompaction
                                                                                                         END,
                @UpdateStatistics = CASE WHEN @UpdateStatistics IS NULL THEN 'ALL'
                                         ELSE @UpdateStatistics
                                    END, @OnlyModifiedStatistics = CASE WHEN @OnlyModifiedStatistics IS NULL THEN 'N'
                                                                        ELSE @OnlyModifiedStatistics
                                                                   END, @StatisticsResample = CASE WHEN @StatisticsResample IS NULL THEN 'N'
                                                                                                   ELSE @StatisticsResample
                                                                                              END, @PartitionLevel = CASE WHEN @PartitionLevel IS NULL THEN 'Y'
                                                                                                                          ELSE @PartitionLevel
                                                                                                                     END,
                @MSShippedObjects = CASE WHEN @MSShippedObjects IS NULL THEN 'N'
                                         ELSE @MSShippedObjects
                                    END, @LogToTable = CASE WHEN @LogToTable IS NULL THEN 'Y'
                                                            ELSE @LogToTable
                                                       END, @Execute = CASE WHEN @Execute IS NULL THEN 'Y'
                                                                            ELSE @Execute
                                                                       END, @FillFactor = CASE WHEN @FillFactor IS NULL THEN 90
                                                                                               ELSE @FillFactor
                                                                                          END, @Databases = CASE WHEN ISNULL(@Databases,'') = ''
																												THEN DB_NAME()
																												ELSE @Databases
																												END;
        IF @Debug = 'Y'
            BEGIN

                SELECT  @Databases AS [Databases], @FragmentationLow AS FragmentationLow, @FragmentationMedium AS FragmentationMedium,
                        @FragmentationHigh AS FragmentationHigh, @FragmentationLevel1 AS FragmentationLevel1, @FragmentationLevel2 AS FragmentationLevel2,
                        @PageCountLevel AS PageCountLevel, @SortInTempdb AS SortInTempdb, @MaxDOP AS [MaxDOP], @FillFactor AS [FillFactor],
                        @PadIndex AS PadIndex, @LOBCompaction AS LOBCompaction, @UpdateStatistics AS UpdateStatistics,
                        @OnlyModifiedStatistics AS OnlyModifiedStatistics, @StatisticsSample AS StatisticsSample, @StatisticsResample AS StatisticsResample,
                        @PartitionLevel AS PartitionLevel, @MSShippedObjects AS MSShippedObjects, @Indexes AS [Indexes], @TimeLimit AS TimeLimit,
                        @Delay AS [Delay], @WaitAtLowPriorityMaxDuration AS WaitAtLowPriorityMaxDuration,
                        @WaitAtLowPriorityAbortAfterWait AS WaitAtLowPriorityAbortAfterWait, @AvailabilityGroups AS AvailabilityGroups,
                        @LockTimeout AS LockTimeout, @LogToTable AS LogToTable, @Execute AS [Execute];                        
            END;											

        EXEC dbo.ssp_DMOptimizeIndexes @Databases = @Databases, -- nvarchar(max)
            @FragmentationLow = @FragmentationLow, -- nvarchar(max)
            @FragmentationMedium = @FragmentationMedium, -- nvarchar(max)
            @FragmentationHigh = @FragmentationHigh, -- nvarchar(max)
            @FragmentationLevel1 = @FragmentationLevel1, -- int
            @FragmentationLevel2 = @FragmentationLevel2, -- int
            @PageCountLevel = @PageCountLevel, -- int
            @SortInTempdb = @SortInTempdb, -- nvarchar(max)
            @MaxDOP = @MaxDOP, -- int
            @FillFactor = @FillFactor, -- int
            @PadIndex = @PadIndex, -- nvarchar(max)
            @LOBCompaction = @LOBCompaction, -- nvarchar(max)
            @UpdateStatistics = @UpdateStatistics, -- nvarchar(max)
            @OnlyModifiedStatistics = @OnlyModifiedStatistics, -- nvarchar(max)
            @StatisticsSample = @StatisticsSample, -- int
            @StatisticsResample = @StatisticsResample, -- nvarchar(max)
            @PartitionLevel = @PartitionLevel, -- nvarchar(max)
            @MSShippedObjects = @MSShippedObjects, -- nvarchar(max)
            @Indexes = @Indexes, -- nvarchar(max)
            @TimeLimit = @TimeLimit, -- int
            @Delay = @Delay, -- int
            @WaitAtLowPriorityMaxDuration = @WaitAtLowPriorityMaxDuration, -- int
            @WaitAtLowPriorityAbortAfterWait = @WaitAtLowPriorityAbortAfterWait, -- nvarchar(max)
            @AvailabilityGroups = @AvailabilityGroups, -- nvarchar(max)
            @LockTimeout = @LockTimeout, -- int
            @LogToTable = @LogToTable, -- nvarchar(max)
            @Execute = @Execute; -- nvarchar(max)
		
		--Clean up command log, remove anything more then 30 days old
        DELETE  FROM dbo.CommandLog
        WHERE   CONVERT(DATE, StartTime) < DATEADD(DAY, -30, GETDATE());


        RETURN;


    END TRY
    BEGIN CATCH
        DECLARE @Error VARCHAR(8000);
        SELECT  @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_DMOptimizeIndexJob') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());		
        RAISERROR(@Error,		16,1 );

    END CATCH;