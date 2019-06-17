---- STEP 1 ----------

------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------
	
------ END OF STEP 3 -----

------ STEP 4 ----------

 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomClientPrograms')
BEGIN
/* 
  TABLE: CustomClientPrograms 
 */
 CREATE TABLE CustomClientPrograms( 
		ClientProgramId					int						NOT NULL, 
		CreatedBy						type_CurrentUser		NOT NULL,
		CreatedDate						type_Currentdatetime	NOT NULL,
		ModifiedBy						type_CurrentUser		NOT NULL,
		ModifiedDate					type_Currentdatetime	NOT NULL,
		RecordDeleted					type_YOrN				NULL
										CHECK (RecordDeleted in ('Y','N')),
		DeletedBy						type_UserId				NULL,	
		DeletedDate						datetime				NULL,	
		AppointmentRequestedDate		datetime				NULL,
		AppointmentFirstOfferedDate		datetime				NULL,			
 CONSTRAINT CustomClientPrograms_PK PRIMARY KEY CLUSTERED (ClientProgramId) 
 )
  IF OBJECT_ID('CustomClientPrograms') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomClientPrograms >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomClientPrograms >>>', 16, 1)
         
/* 
 * TABLE: CustomClientPrograms 
 */
   
  ALTER TABLE CustomClientPrograms ADD CONSTRAINT ClientPrograms_CustomClientPrograms_FK
    FOREIGN KEY (ClientProgramId)
    REFERENCES ClientPrograms(ClientProgramId)
         
	PRINT 'STEP 4(A) COMPLETED'
 END
-------END Of STEP 4-----

------ STEP 5 ---------------- 

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

If not exists (select [key] from SystemConfigurationKeys where [key] = 'CDM_StateReporting')
	begin
		INSERT intO [dbo].[SystemConfigurationKeys]
				   (CreatedBy
				   ,CreateDate 
				   ,ModifiedBy
				   ,ModifiedDate
				   ,[Key]
				   ,Value
				   )
			 VALUES    
				   ('SHSDBA'
				   ,GETDATE()
				   ,'SHSDBA'
				   ,GETDATE()
				   ,'CDM_StateReporting'
				   ,'1.0'
				   )
 PRINT 'STEP 7 COMPLETED'
 End

 