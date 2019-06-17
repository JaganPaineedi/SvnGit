DECLARE @CurrentDate DATETIME = GETDATE();

SELECT StaffId,
       StaffLoginHistoryId,
       LoginTime,
       LogoutTime,
       ROW_NUMBER() OVER (PARTITION BY StaffId ORDER BY LoginTime) AS rowNumber
INTO   #SessionBadData1
  FROM dbo.StaffLoginHistory
 WHERE ISNULL(RecordDeleted, 'N') = 'N';

SELECT a.StaffId,
       a.StaffLoginHistoryId,
       a.LoginTime,
       ISNULL(a.LogoutTime, DATEADD(SECOND, -1, b.LoginTime)) AS LogoutTime,
       a.rowNumber
INTO   #SeedSessions
  FROM #SessionBadData1 AS a
  LEFT JOIN #SessionBadData1 AS b
    ON a.StaffId   = b.StaffId
   AND b.rowNumber = a.rowNumber + 1;

UPDATE a
   SET a.ModifiedBy = 'EII542',
       a.ModifiedDate = @CurrentDate,
       a.LogoutTime = b.LogoutTime
  FROM dbo.StaffLoginHistory AS a
  JOIN #SeedSessions AS b
    ON b.StaffLoginHistoryId = a.StaffLoginHistoryId
   AND a.LogoutTime IS NULL;

DROP TABLE #SessionBadData1;
DROP TABLE #SeedSessions;

GO