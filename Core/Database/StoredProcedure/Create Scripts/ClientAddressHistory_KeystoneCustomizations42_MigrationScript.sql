
SELECT  ClientAddressId, ClientId, AddressType, CreatedDate, ModifiedDate,
        RANK() OVER ( PARTITION BY ClientId, AddressType ORDER BY CONVERT(DATE, CreatedDate), CONVERT(DATE, ModifiedDate) ) AS Rnum,
        ROW_NUMBER() OVER ( PARTITION BY a.ClientId, a.AddressType ORDER BY a.CreatedDate, a.ModifiedDate ) AS Num
INTO    #CientAddressHistoryTempRNum
FROM    dbo.ClientAddressHistory AS a
WHERE   ISNULL(a.RecordDeleted, 'N') = 'N';



DELETE  FROM a
FROM    #CientAddressHistoryTempRNum AS a
WHERE   a.ClientAddressId NOT IN ( SELECT   c.ClientAddressId
                                   FROM     #CientAddressHistoryTempRNum AS c
                                   JOIN     ( SELECT    b.ClientId, b.AddressType, MAX(b.Num) AS Num, b.Rnum
                                              FROM      #CientAddressHistoryTempRNum AS b
                                              GROUP BY  b.ClientId, b.AddressType, b.Rnum
                                            ) AS cc ON cc.AddressType = c.AddressType
                                                       AND cc.ClientId = c.ClientId
                                                       AND cc.Num = c.Num
                                                       AND cc.Rnum = c.Rnum );



--fix the Rnum know that we have cleaned up the data
SELECT a.ClientAddressId,
a.ClientId,
a.AddressType,
a.CreatedDate,
a.ModifiedDate,
ROW_NUMBER() OVER(PARTITION BY a.ClientId,a.AddressType ORDER BY a.Rnum ) AS RNum
INTO #ClientAddressHistoryNum 
FROM #CientAddressHistoryTempRNum AS a


SELECT  a.ClientAddressId, a.ClientId, a.AddressType, CONVERT(DATE, a.CreatedDate) AS StartDate, DATEADD(DAY, -1, CONVERT(DATE, b.ModifiedDate)) AS EndDate
INTO    #ClientAddressHistoryDates
FROM    #ClientAddressHistoryNum AS a
LEFT JOIN #ClientAddressHistoryNum AS b ON b.ClientId = a.ClientId
                                               AND b.AddressType = a.AddressType
                                               AND b.Rnum = a.Rnum + 1;


UPDATE  a
SET     a.StartDate = b.StartDate, a.EndDate = b.EndDate
FROM    dbo.ClientAddressHistory AS a
JOIN    #ClientAddressHistoryDates AS b ON b.ClientAddressId = a.ClientAddressId;


