----- STEP 1 ----------

------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins


--Part2 Ends

-----End of Step 2 -------

------ STEP 3 ------------
declare @Cstname nvarchar(50), 
    @sql nvarchar(1000)

-- find constraint name
select @Cstname = O.name 
from sysobjects AS O
left join sysobjects AS T
    on O.parent_obj = T.id
where isnull(objectproperty(O.id,'IsMSShipped'),1) = 0
    and O.name not like '%dtproper%'
    and O.name not like 'dt[_]%'
    and T.name = 'CustomDocumentUrinalysis'
    and O.name like 'CK__CustomDoc__Issue%'
   
    
  if not @Cstname is null
begin
    select @sql = 'ALTER TABLE [CustomDocumentUrinalysis] DROP CONSTRAINT [' + @Cstname + ']'
    execute sp_executesql @sql
end
GO

IF COL_LENGTH('CustomDocumentUrinalysis','IssuesPresentedToday') IS NOT NULL
BEGIN
	UPDATE CustomDocumentUrinalysis SET IssuesPresentedToday=NULL
END

IF COL_LENGTH('CustomDocumentUrinalysis','IssuesPresentedToday') IS NOT NULL
BEGIN
	ALTER TABLE CustomDocumentUrinalysis ALTER COLUMN IssuesPresentedToday char(1) NULL
	ALTER TABLE CustomDocumentUrinalysis WITH CHECK ADD CHECK  (([IssuesPresentedToday]='A' OR [IssuesPresentedToday]='N' OR [IssuesPresentedToday]='Y'))						
END

PRINT 'STEP 3 COMPLETED'
------ END OF STEP 3 -----

------ STEP 4 ----------

---------------------------------------------------------------
--PRINT 'STEP 4 COMPLETED'
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
If not exists (select [key] from SystemConfigurationKeys where [key] = 'CDM_Urinalysis')
	begin
		INSERT INTO [dbo].[SystemConfigurationKeys]
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
				   ,'CDM_Urinalysis'
				   ,'1.1'
				   )
            
	End

Else
	Begin
		Update SystemConfigurationKeys set value ='1.1' Where [key] = 'CDM_Urinalysis'
	End

Go
PRINT 'STEP 7 COMPLETED'


