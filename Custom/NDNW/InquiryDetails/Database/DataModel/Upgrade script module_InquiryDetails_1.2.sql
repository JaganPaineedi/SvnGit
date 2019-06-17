----- STEP 1 ----------
IF ((SELECT value FROM SystemConfigurationKeys WHERE [key] = 'CDM_InquiryDetails')  < 1.1 ) or
NOT EXISTS(SELECT 1 FROM SystemConfigurationKeys WHERE [key] = 'CDM_InquiryDetails')
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 1.1 for CDM_InquiryDetails update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
-------- STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 -------

------ STEP 3 ------------ 

declare @Cstname nvarchar(max), 
		 @sql nvarchar(1000)
-- find constraint name
SELECT @Cstname=COALESCE(@Cstname+',','')+SCO.name 
    FROM
        sys.Objects TB
        INNER JOIN sys.Columns TC on (TB.Object_id = TC.object_id)
        INNER JOIN sys.sysconstraints SC ON (TC.Object_ID = SC.id and TC.column_id = SC.colid)
        INNER JOIN sys.objects SCO ON (SC.Constid = SCO.object_id)
    where
        TB.name='CustomInquiries'
        AND TC.name='Pregnant'
       order by SCO.name 
 if not @Cstname is null
begin
    select @sql = 'ALTER TABLE [CustomInquiries] DROP CONSTRAINT ' + @Cstname + ''   
    execute sp_executesql @sql
end

IF COL_LENGTH('CustomInquiries','Pregnant')IS NOT NULL
BEGIN 	
	ALTER TABLE CustomInquiries	WITH CHECK ADD CHECK(Pregnant in ('A','U','N','Y','C'))
END

PRINT 'STEP 3 COMPLETED'

-----END Of STEP 3--------------------
------ STEP 4 ------------
----END Of STEP 4------------
------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------
------ STEP 7 -----------

IF ((SELECT cast(value as decimal(10,2)) FROM SystemConfigurationKeys WHERE [key] = 'CDM_InquiryDetails')  = 1.1 )
BEGIN
	UPDATE SystemConfigurationKeys SET value ='1.2' WHERE [key] = 'CDM_InquiryDetails'
	PRINT 'STEP 7 COMPLETED'
END
GO