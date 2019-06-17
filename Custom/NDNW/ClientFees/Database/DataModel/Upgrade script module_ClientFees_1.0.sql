----- STEP 1 ----------

------ STEP 2 ----------
--Part1 Begin
--Part1 Ends

--Part2 Begins


--Part2 Ends
-----End of Step 2 -------

------ STEP 3 ------------
------ END OF STEP 3 -----

------ STEP 4 ----------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomClientFees')
BEGIN
/* 
 * TABLE: CustomClientFees 
 */
 CREATE TABLE CustomClientFees( 
		ClientFeeId						int	identity(1,1)	 NOT NULL,
		CreatedBy						type_CurrentUser     NOT NULL,
		CreatedDate						type_CurrentDatetime NOT NULL,
		ModifiedBy						type_CurrentUser     NOT NULL,
		ModifiedDate					type_CurrentDatetime NOT NULL,
		RecordDeleted					type_YOrN			 NULL
										CHECK (RecordDeleted in ('Y','N')),
		DeletedBy						type_UserId          NULL,
		DeletedDate						datetime             NULL,	
        ClientId						int					 NULL,
		StartDate						datetime			 NULL,
		EndDate							datetime			 NULL,
		StandardRatePercentage			decimal(10, 2)		 NULL,
		Rate							money				 NULL,
		Locations						varchar(max)		 NULL,
		Programs						varchar(max)		 NULL,  
		Comment							type_Comment2		 NULL,
		CONSTRAINT CustomClientFees_PK PRIMARY KEY CLUSTERED (ClientFeeId) 
 )
 
  IF OBJECT_ID('CustomClientFees') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomClientFees >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomClientFees >>>', 16, 1)
/* 
 * TABLE: CustomClientFees 
 */
   
ALTER TABLE CustomClientFees ADD CONSTRAINT Clients_CustomClientFees_FK
    FOREIGN KEY (ClientId)
    REFERENCES Clients(ClientId)  
        
      PRINT 'STEP 4 COMPLETED'
 END            
 
   ---------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF NOT EXISTS (SELECT [key] FROM SystemConfigurationKeys WHERE [key] = 'CDM_ClientFees')
	BEGIN
		INSERT INTO SystemConfigurationKeys
				   (CreatedBy
				   ,CreateDate 
				   ,ModifiedBy
				   ,ModifiedDate
				   ,[key]
				   ,Value
				   )
			 VALUES    
				   ('SHSDBA'
				   ,GETDATE()
				   ,'SHSDBA'
				   ,GETDATE()
				   ,'CDM_ClientFees'
				   ,'1.0'
				   )
		PRINT 'STEP 7 COMPLETED'
	END
 GO

 