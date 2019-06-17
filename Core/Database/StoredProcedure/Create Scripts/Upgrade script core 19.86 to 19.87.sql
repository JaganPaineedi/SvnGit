----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 19.86)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 19.86 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
-----
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------
	
----Add New Column in ClientOrders Table 	
IF OBJECT_ID('ClientOrders') IS NOT NULL
BEGIN
		IF COL_LENGTH('ClientOrders','ExternalClientOrderId')IS NULL
		BEGIN
		 ALTER TABLE ClientOrders ADD  ExternalClientOrderId  varchar(200)	NULL
		END
		
		
 PRINT 'STEP 3 COMPLETED'
END
go

If not exists(Select ExternalClientOrderId from ClientOrders where isnull(RecordDeleted,'N')='N' and ExternalClientOrderId is not null)
begin
	create table #tempClientOrderDtls(DocumentVersionId int,  AccessionId varchar(200))

	Insert into #tempClientOrderDtls
	select CO.documentVersionId,L.AccessionId
		 From ClientOrders CO Join LabSoftMessages L On CO.ClientOrderId= L.ClientOrderId
		 Where cast(L.ClientOrderId as varchar) <> L.AccessionId 
				and L.RequestMessage is null
				and isnull(CO.RecordDeleted,'N')='N' and isnull(L.RecordDeleted,'N')='N'
	     
     update CO
     set CO.ExternalClientOrderId= L.AccessionId, CO.Modifiedby='LabSoftDM', CO.ModifiedDate= getdate()
     From ClientOrders CO Join #tempClientOrderDtls L On CO.documentVersionId= L.documentVersionId
     Where isnull(CO.RecordDeleted,'N')='N'  and CO.ExternalClientOrderId is null 
	 
	 drop table #tempClientOrderDtls
end
	
------ END Of STEP 3 ------------

------ STEP 4 ---------------

 ----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 19.86)
BEGIN
Update SystemConfigurations set DataModelVersion=19.87
PRINT 'STEP 7 COMPLETED'
END

Go
