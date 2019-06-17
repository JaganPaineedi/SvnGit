----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.75)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.75 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END

------ STEP 2 ----------
--Part1 Begin


--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 ------- 

------ STEP 3 ------------

IF OBJECT_ID('Orders') IS NOT NULL
BEGIN	
	IF COL_LENGTH('Orders','DrawFromServiceCenter') IS NULL
	BEGIN
		ALTER TABLE Orders ADD DrawFromServiceCenter  type_YOrN	NULL
						   CHECK (DrawFromServiceCenter in ('Y','N'))			  
	END	
END

IF OBJECT_ID('ClientOrders') IS NOT NULL
BEGIN	
	IF COL_LENGTH('ClientOrders','DrawFromServiceCenter') IS NULL
	BEGIN
		ALTER TABLE ClientOrders ADD DrawFromServiceCenter  type_YOrN	NULL
								 CHECK (DrawFromServiceCenter in ('Y','N'))			  
	END
END
 PRINT 'STEP 3 COMPLETED'
-----END Of STEP 3--------------------

------ STEP 4 ------------
----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.75)
BEGIN
Update SystemConfigurations set DataModelVersion=15.76
PRINT 'STEP 7 COMPLETED'
END
Go