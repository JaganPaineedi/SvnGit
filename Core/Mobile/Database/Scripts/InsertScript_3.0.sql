
DECLARE @Category int
DECLARE @KPIType int
SELECT
  @Category = GlobalCodeId
FROM GlobalCodes
WHERE Category = 'KPICategory'
AND CodeName = 'Performance Log'
SELECT
  @KPIType = GlobalCodeId
FROM GlobalCodes
WHERE Category = 'KPIType'
AND CodeName = 'Count'

IF NOT EXISTS (SELECT
    *
  FROM [KPIMaster]
  WHERE [KPIName] = 'IISLogs'
  AND Active = 'Y')
BEGIN
  INSERT INTO KPIMaster (KPIName, Category, [Type], CollectionPeriod, RetentionPeriod, Active, RawData,
  RawDataTableName)
    VALUES ('IISLogs', @Category, @KPIType, 0, 0, 'Y', 'Y', 'MetricDataPerformanceLogs')
END

IF NOT EXISTS (SELECT
    *
  FROM [KPIMaster]
  WHERE [KPIName] = 'KPIReporting'
  AND Active = 'Y')
BEGIN
  INSERT INTO KPIMaster (KPIName, Category, [Type], CollectionPeriod, RetentionPeriod, Active, RawData,
  RawDataTableName)
    VALUES ('KPIReporting', @Category, @KPIType, 0, 0, 'Y', 'Y', 'IISLogFiles')
END
