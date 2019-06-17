 
 
 SELECT 'DBMaintenanceDatabases' AS KeyName,
 DB_NAME() AS KeyValue,
 'Name of the database the process will run against.' AS KeyDescription,
 '""' AS KeyAcceptedValues
 INTO #Keys
 UNION ALL
  SELECT 'DBMaintenanceFragmentationLow' AS KeyName,
 NULL AS KeyValue,
 'Type of index maintenance operation to perform' AS KeyDescription,
 'INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE,INDEX_REORGANIZE,"INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE","INDEX_REBUILD_ONLINE,INDEX_REORGANIZE","INDEX_REORGANIZE,INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE",""' AS KeyAcceptedValues
 UNION ALL
  SELECT 'DBMaintenanceFragmentationMedium' AS KeyName,
 'INDEX_REORGANIZE,INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE' AS KeyValue,
 'Type of index maintenance operation to perform' AS KeyDescription,
 'INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE,INDEX_REORGANIZE,"INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE","INDEX_REBUILD_ONLINE,INDEX_REORGANIZE","INDEX_REORGANIZE,INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE",""' AS KeyAcceptedValues
 UNION ALL
  SELECT 'DBMaintenanceFragmentationHigh' AS KeyName,
 'INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE' AS KeyValue,
 'Type of index maintenance operation to perform' AS KeyDescription,
 'INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE,INDEX_REORGANIZE,"INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE","INDEX_REBUILD_ONLINE,INDEX_REORGANIZE","INDEX_REORGANIZE,INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE",""' AS KeyAcceptedValues
 UNION ALL
  SELECT 'DBMaintenanceFragmentationLevel1' AS KeyName,
 '5' AS KeyValue,
 'Lower limit for medium fragmentation, value is a percentage' AS KeyDescription,
 '5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20' AS KeyAcceptedValues
 UNION ALL
  SELECT 'DBMaintenanceFragmentationLevel2' AS KeyName,
 '30' AS KeyValue,
 'Lower limit for high fragmentation, value is a percentage' AS KeyDescription,
 '21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50' AS KeyAcceptedValues
 UNION ALL
  SELECT 'DBMaintenancePageCountLevel' AS KeyName,
 '50' AS KeyValue,
 'Minimum number of pages an index needs to be considered by the process' AS KeyDescription,
 '50,100,150,200,250,300,350,400,450,500,550,600,750,800,850,900,950,1000' AS KeyAcceptedValues
 UNION ALL
  SELECT 'DBMaintenanceSortInTempdb' AS KeyName,
 'N' AS KeyValue,
 'Use tempdb for operations' AS KeyDescription,
 'Y,N' AS KeyAcceptedValues
 UNION ALL
  SELECT 'DBMaintenanceMaxDOP' AS KeyName,
 NULL AS KeyValue,
 'Max number of cpus to use' AS KeyDescription,
 '1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36' AS KeyAcceptedValues
 UNION ALL
   SELECT 'DBMaintenanceFillFactor' AS KeyName,
 '90' AS KeyValue,
 'How full each page should be, value is a percent' AS KeyDescription,
 '80,85,90' AS KeyAcceptedValues
 UNION ALL
   SELECT 'DBMaintenancePadIndex' AS KeyName,
 null AS KeyValue,
 '' AS KeyDescription,
 '""' AS KeyAcceptedValues
 UNION ALL
   SELECT 'DBMaintenanceLOBCompaction' AS KeyName,
 'Y' AS KeyValue,
 '' AS KeyDescription,
 'Y,N' AS KeyAcceptedValues
 UNION ALL
     SELECT 'DBMaintenanceUpdateStatistics' AS KeyName,
 'ALL' AS KeyValue,
 'Type of statistics update that should occur' AS KeyDescription,
 'ALL,INDEX,COLUMNS,""' AS KeyAcceptedValues
 UNION ALL
    SELECT 'DBMaintenanceOnlyModifiedStatistics' AS KeyName,
 'N' AS KeyValue,
 'Only update statistics if any rows have been modified since last update' AS KeyDescription,
 'Y,N' AS KeyAcceptedValues
 UNION ALL
    SELECT 'DBMaintenanceStatisticsSample' AS KeyName,
 NULL AS KeyValue,
 '' AS KeyDescription,
 '""' AS KeyAcceptedValues
 UNION ALL
    SELECT 'DBMaintenanceStatisticsResample' AS KeyName,
 'N' AS KeyValue,
 '' AS KeyDescription,
 'Y,N' AS KeyAcceptedValues
 UNION ALL
    SELECT 'DBMaintenancePartitionLevel' AS KeyName,
 'Y' AS KeyValue,
 '' AS KeyDescription,
 'Y,N' AS KeyAcceptedValues
 UNION ALL
     SELECT 'DBMaintenanceMSShippedObjects' AS KeyName,
 'N' AS KeyValue,
 '' AS KeyDescription,
 'Y,N' AS KeyAcceptedValues
 UNION ALL
     SELECT 'DBMaintenanceIndexes' AS KeyName,
 NULL AS KeyValue,
 '' AS KeyDescription,
 '""' AS KeyAcceptedValues
 UNION ALL
     SELECT 'DBMaintenanceTimeLimit' AS KeyName,
 NULL AS KeyValue,
 '' AS KeyDescription,
 '""' AS KeyAcceptedValues
 UNION ALL
     SELECT 'DBMaintenanceDelay' AS KeyName,
 NULL AS KeyValue,
 '' AS KeyDescription,
 '""' AS KeyAcceptedValues
 UNION ALL
     SELECT 'DBMaintenanceWaitAtLowPriorityMaxDuration' AS KeyName,
 NULL AS KeyValue,
 '' AS KeyDescription,
 '""' AS KeyAcceptedValues
 UNION ALL
     SELECT 'DBMaintenanceWaitAtLowPriorityAbortAfterWait' AS KeyName,
 NULL AS KeyValue,
 '' AS KeyDescription,
 '""' AS KeyAcceptedValues
 UNION ALL
      SELECT 'DBMaintenanceAvailabilityGroups' AS KeyName,
 NULL AS KeyValue,
 '' AS KeyDescription,
 '""' AS KeyAcceptedValues
 UNION ALL
      SELECT 'DBMaintenanceLogToTable' AS KeyName,
 'Y' AS KeyValue,
 'Log the commands to the table CommandLog' AS KeyDescription,
 'Y,N' AS KeyAcceptedValues
 UNION ALL
      SELECT 'DBMaintenanceExecute' AS KeyName,
 'Y' AS KeyValue,
 'Execute the commands against the target database' AS KeyDescription,
 'Y,N' AS KeyAcceptedValues


 --SELECT * FROM #Keys

 INSERT INTO dbo.SystemConfigurationKeys ( [Key], Value, Description,
                                            AcceptedValues, ShowKeyForViewingAndEditing, AllowEdit )
 SELECT KeyName, KeyValue, KeyDescription, KeyAcceptedValues, 'Y','N'
 FROM #Keys AS b
 WHERE NOT EXISTS ( SELECT 1
					FROM dbo.SystemConfigurationKeys AS a
					WHERE a.[Key] = b.KeyName
					AND ISNULL(a.RecordDeleted,'N')='N'
				  )

 DROP TABLE #Keys