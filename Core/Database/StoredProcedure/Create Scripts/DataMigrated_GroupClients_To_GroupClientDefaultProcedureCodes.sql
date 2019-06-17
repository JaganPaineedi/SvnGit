/*--Data Migrated from GroupClients to GroupClientDefaultProcedureCodes*/
/*--Author: Manjunath K*/
/*--Task: Woods Suppport Go Live #444*/
/*--11 May 2017*/
IF OBJECT_ID('GroupClientDefaultProcedureCodes') IS NOT NULL
 BEGIN
 
 INSERT INTO GroupClientDefaultProcedureCodes(
 CreatedBy
 ,CreatedDate
 ,ModifiedBy
 ,ModifiedDate
 ,GroupId
 ,ClientId
 )
 SELECT 
 'SHSDBA'
 ,GETDATE()
 ,'SHSDBA'
 ,GETDATE()
 ,GroupId
 ,ClientId
 FROM GroupClients C
 WHERE ISNULL(C.RecordDeleted,'N')='N'
 AND NOT EXISTS (SELECT 1 FROM GroupClientDefaultProcedureCodes P WHERE P.GroupId=C.GroupId AND P.ClientId=C.ClientId)
END 