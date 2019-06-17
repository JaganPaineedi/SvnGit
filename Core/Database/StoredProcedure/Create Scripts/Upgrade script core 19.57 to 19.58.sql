----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 19.57)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 19.57 or update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin
--Part1 Ends

--Part2 Begins


--Part2 Ends
-----End of Step 2 -------

------ STEP 3 ------------

------ END OF STEP 3 -----

------ STEP 4 ----------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='NotificationQueues')
BEGIN
/*		 
 * TABLE: NotificationQueues 
 */
 CREATE TABLE NotificationQueues( 
		NotificationQueueId						int	IDENTITY(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,	
		ToStaffId								int					 NULL,
		NotificationId							int					 NULL,
		NotificationType						type_GlobalCode		 NULL,
		NotificationStatus						type_YOrN			 NULL
												CHECK (NotificationStatus in ('Y','N')),
		CONSTRAINT NotificationQueues_PK PRIMARY KEY CLUSTERED (NotificationQueueId) 
 )
 
 IF OBJECT_ID('NotificationQueues') IS NOT NULL
    PRINT '<<< CREATED TABLE NotificationQueues >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE NotificationQueues >>>', 16, 1)
    
     IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[NotificationQueues]') AND name = N'XIE1_NotificationQueues')
  BEGIN
   CREATE NONCLUSTERED INDEX [XIE1_NotificationQueues] ON [dbo].[NotificationQueues] 
   (
   [ToStaffId]  ASC
   )
   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('NotificationQueues') AND name='XIE1_NotificationQueues')
   PRINT '<<< CREATED INDEX NotificationQueues.XIE1_NotificationQueues >>>'
   ELSE
   RAISERROR('<<< FAILED CREATING INDEX NotificationQueues.XIE1_NotificationQueues >>>', 16, 1)  
  END  
    
/* 
 * TABLE: NotificationQueues 
 */   
    
ALTER TABLE NotificationQueues ADD CONSTRAINT Staff_NotificationQueues_FK
    FOREIGN KEY (ToStaffId)
    REFERENCES Staff(StaffId)
    
    EXEC sys.sp_addextendedproperty 'NotificationQueues_Description'
 ,'NotificationType Column stores GlobalCode of Category NOTIFICATIONTYPE'
 ,'schema'
 ,'dbo'
 ,'table'
 ,'NotificationQueues'
 ,'column'
 ,'NotificationType' 

 PRINT 'STEP 4(A) COMPLETED'
 END
 
 
---------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 19.57)
BEGIN
Update SystemConfigurations set DataModelVersion=19.58
PRINT 'STEP 7 COMPLETED'
END
Go