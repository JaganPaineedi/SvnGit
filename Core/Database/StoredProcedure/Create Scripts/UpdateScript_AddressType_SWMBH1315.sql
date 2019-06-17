
--CC3	2017-09-17 02:06:18.547

UPDATE GlobalCodes 
SET RecordDeleted = NULL,DeletedBy = NULL,DeletedDate = NULL
WHERE Category = 'AddressType'
AND GlobalCodeId IN (
90
,91
,92
,93)
