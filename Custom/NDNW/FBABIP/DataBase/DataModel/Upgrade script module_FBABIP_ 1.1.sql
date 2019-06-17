----- STEP 1 ----------
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CustomDocumentFABIPs') AND type in (N'U'))     Exec sp_rename  CustomDocumentFABIPs,CustomDocumentFABIPs_Temp111

PRINT 'STEP 1 COMPLETED'
Go
--End of Step 1

IF EXISTS (SELECT * FROM sys.objects WHERE object_id=OBJECT_ID(N'ssp_DeleteTableChecks') AND type IN (N'P',N'PC')) 
DROP PROCEDURE ssp_DeleteTableChecks
GO
create proc [dbo].[ssp_DeleteTableChecks]  
@TableName varchar(128)   
as  
  
create table #temp1  
(ConstraintName varchar(128) null,  
ConstraintDefinition varchar(1000) null,  
Col1 int null,  
Col2 int null)  
  
declare @ConstraintName varchar(128)  
declare @DropSQLString varchar(1000)  
  
insert into #temp1  
exec sp_MStablechecks @TableName  
  
if @@error <> 0 return  
  
declare cur_DropCheck cursor for  
select ConstraintName  
from #temp1  
  
if @@error <> 0 return  
  
open cur_DropCheck  
  
if @@error <> 0 return  
  
fetch cur_DropCheck into @ConstraintName  
  
while @@Fetch_Status = 0  
begin  
  
set @DropSQLString = 'ALTER TABLE ' + @TableName + ' DROP CONSTRAINT ' + @ConstraintName  
  
if @@error <> 0 return  
  
print @DropSQLString  
execute(@DropSQLString)  
  
if @@error <> 0 return  
  
fetch cur_DropCheck into @ConstraintName  
  
if @@error <> 0 return  
  
end  
  
close cur_DropCheck  
  
if @@error <> 0 return  
  
deallocate cur_DropCheck  
  
if @@error <> 0 return  

GO
------ STEP 2 ----------
--Part1 Begin
exec ssp_DeleteTableChecks 'CustomDocumentFABIPs_Temp111'

--Part1 Ends

GO

--Part2 Begins
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'CustomDocumentFABIPs_Temp111') AND name = N'CustomDocumentFABIPs_PK')  Exec sp_rename  CustomDocumentFABIPs_PK,CustomDocumentFABIPs_PK_Temp111


--Part2 Ends
PRINT 'STEP 2 COMPLETED'
Go

-----End of Step 2 -------

------ STEP 3 ------------

------ END OF STEP 3 -----

------ STEP 4 ----------

/* 
 * TABLE: CustomDocumentFABIPs 
 */

CREATE TABLE CustomDocumentFABIPs(
    DocumentVersionId                     int                     NOT NULL,
    CreatedBy                             type_CurrentUser        NOT NULL,
    CreatedDate                           type_CurrentDatetime    NOT NULL,
    ModifiedBy                            type_CurrentUser        NOT NULL,
    ModifiedDate                          type_CurrentDatetime    NOT NULL,
    RecordDeleted                         type_YOrN               NULL
                                          CHECK (RecordDeleted in ('Y','N')),
    DeletedBy                             type_UserId             NULL,
    DeletedDate                           datetime                NULL,
    Type                                  type_GlobalCode         NULL,
    StaffParticipants                     type_Comment2           NULL,
    TargetBehavior1                       varchar(100)            NULL,
    Status1                               type_GlobalCode         NULL,
    FrequencyIntensityDuration1           type_Comment2           NULL,
    Settings1                             type_Comment2           NULL,
    Antecedent1                           type_Comment2           NULL,
    ConsequenceThatReinforcesBehavior1    type_Comment2           NULL,
    EnvironmentalConditions1              type_Comment2           NULL,
    HypothesisOfBehavioralFunction1       type_Comment2           NULL,
    ExpectedBehaviorChanges1              type_Comment2           NULL,
    MethodsOfOutcomeMeasurement1          type_Comment2           NULL,
    ScheduleOfOutcomeReview1              varchar(25)             NULL,
    QuarterlyReview1                      type_Comment2           NULL,
    FromLastDocument1                     type_YOrN               NULL
                                          CHECK (FromLastDocument1 in ('Y','N')),
    TargetBehavior2                       varchar(100)            NULL,
    Status2                               type_GlobalCode         NULL,
    FrequencyIntensityDuration2           type_Comment2           NULL,
    Settings2                             type_Comment2           NULL,
    Antecedent2                           type_Comment2           NULL,
    ConsequenceThatReinforcesBehavior2    type_Comment2           NULL,
    EnvironmentalConditions2              type_Comment2           NULL,
    HypothesisOfBehavioralFunction2       type_Comment2           NULL,
    ExpectedBehaviorChanges2              type_Comment2           NULL,
    MethodsOfOutcomeMeasurement2          type_Comment2           NULL,
    ScheduleOfOutcomeReview2              varchar(25)             NULL,
    QuarterlyReview2                      type_Comment2           NULL,
    FromLastDocument2                     type_YOrN               NULL
                                          CHECK (FromLastDocument2 in ('Y','N')),
    TargetBehavior3                       varchar(100)            NULL,
    Status3                               type_GlobalCode         NULL,
    FrequencyIntensityDuration3           type_Comment2           NULL,
    Settings3                             type_Comment2           NULL,
    Antecedent3                           type_Comment2           NULL,
    ConsequenceThatReinforcesBehavior3    type_Comment2           NULL,
    EnvironmentalConditions3              type_Comment2           NULL,
    HypothesisOfBehavioralFunction3       type_Comment2           NULL,
    ExpectedBehaviorChanges3              type_Comment2           NULL,
    MethodsOfOutcomeMeasurement3          type_Comment2           NULL,
    ScheduleOfOutcomeReview3              varchar(25)             NULL,
    QuarterlyReview3                      type_Comment2           NULL,
    FromLastDocument3                     type_YOrN               NULL
                                          CHECK (FromLastDocument3 in ('Y','N')),
    ConsequenceThatReinforcesBehavior4    type_Comment2           NULL,
    EnvironmentalConditions4              type_Comment2           NULL,
    HypothesisOfBehavioralFunction4       type_Comment2           NULL,
    ExpectedBehaviorChanges4              type_Comment2           NULL,
    MethodsOfOutcomeMeasurement4          type_Comment2           NULL,
    ScheduleOfOutcomeReview4              varchar(25)             NULL,
    QuarterlyReview4                      type_Comment2           NULL,
    TargetBehavior4                       varchar(100)            NULL,
    Status4                               type_GlobalCode         NULL,
    FrequencyIntensityDuration4           type_Comment2           NULL,
    Settings4                             type_Comment2           NULL,
    Antecedent4                           type_Comment2           NULL,
    FromLastDocument4                     type_YOrN               NULL
                                          CHECK (FromLastDocument4 in ('Y','N')),
    TargetBehavior5                       varchar(100)            NULL,
    Status5                               type_GlobalCode         NULL,
    FrequencyIntensityDuration5           type_Comment2           NULL,
    Settings5                             type_Comment2           NULL,
    Antecedent5                           type_Comment2           NULL,
    ConsequenceThatReinforcesBehavior5    type_Comment2           NULL,
    EnvironmentalConditions5              type_Comment2           NULL,
    HypothesisOfBehavioralFunction5       type_Comment2           NULL,
    ExpectedBehaviorChanges5              type_Comment2           NULL,
    MethodsOfOutcomeMeasurement5          type_Comment2           NULL,
    ScheduleOfOutcomeReview5              varchar(25)             NULL,
    QuarterlyReview5                      type_Comment2           NULL,
    FromLastDocument5                     type_YOrN               NULL
                                          CHECK (FromLastDocument5 in ('Y','N')),
    InterventionsAttempted                type_Comment2           NULL,
    ReplacementBehaviors                  type_Comment2           NULL,
    Motivators                            type_Comment2           NULL,
    NonrestrictiveInterventions           type_Comment2           NULL,
    RestrictiveInterventions              type_Comment2           NULL,
    StaffResponsible                      type_Comment2           NULL,
    ReceiveCopyOfPlan                     type_Comment2           NULL,
    WhoCoordinatePlan                     type_Comment2           NULL,
    HowCoordinatePlan                     type_Comment2           NULL,
    UseOfManualRestraints                 type_GlobalCode         NULL,
    CONSTRAINT CustomDocumentFABIPs_PK PRIMARY KEY CLUSTERED (DocumentVersionId)
)
go



IF OBJECT_ID('CustomDocumentFABIPs') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentFABIPs >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE CustomDocumentFABIPs >>>'
go

/* 
 * TABLE: CustomDocumentFABIPs 
 */

PRINT 'STEP 4 COMPLETED'
--END Of STEP 4

------ STEP 5 ----------------
INSERT INTO [CustomDocumentFABIPs]
           ([DocumentVersionId]
           ,[CreatedBy]
           ,[CreatedDate]
           ,[ModifiedBy]
           ,[ModifiedDate]
           ,[RecordDeleted]
           ,[DeletedBy]
           ,[DeletedDate]
           ,[Type]
           ,[StaffParticipants]
           ,[TargetBehavior1]
           ,[Status1]
           ,[FrequencyIntensityDuration1]
           ,[Settings1]
           ,[Antecedent1]
           ,[ConsequenceThatReinforcesBehavior1]
           ,[EnvironmentalConditions1]
           ,[HypothesisOfBehavioralFunction1]
           ,[ExpectedBehaviorChanges1]
           ,[MethodsOfOutcomeMeasurement1]
           ,[ScheduleOfOutcomeReview1]
           ,[QuarterlyReview1]
           ,[TargetBehavior2]
           ,[Status2]
           ,[FrequencyIntensityDuration2]
           ,[Settings2]
           ,[Antecedent2]
           ,[ConsequenceThatReinforcesBehavior2]
           ,[EnvironmentalConditions2]
           ,[HypothesisOfBehavioralFunction2]
           ,[ExpectedBehaviorChanges2]
           ,[MethodsOfOutcomeMeasurement2]
           ,[ScheduleOfOutcomeReview2]
           ,[QuarterlyReview2]
           ,[TargetBehavior3]
           ,[Status3]
           ,[FrequencyIntensityDuration3]
           ,[Settings3]
           ,[Antecedent3]
           ,[ConsequenceThatReinforcesBehavior3]
           ,[EnvironmentalConditions3]
           ,[HypothesisOfBehavioralFunction3]
           ,[ExpectedBehaviorChanges3]
           ,[MethodsOfOutcomeMeasurement3]
           ,[ScheduleOfOutcomeReview3]
           ,[QuarterlyReview3]
           ,[ConsequenceThatReinforcesBehavior4]
           ,[EnvironmentalConditions4]
           ,[HypothesisOfBehavioralFunction4]
           ,[ExpectedBehaviorChanges4]
           ,[MethodsOfOutcomeMeasurement4]
           ,[ScheduleOfOutcomeReview4]
           ,[QuarterlyReview4]
           ,[TargetBehavior4]
           ,[Status4]
           ,[FrequencyIntensityDuration4]
           ,[Settings4]
           ,[Antecedent4]
           ,[TargetBehavior5]
           ,[Status5]
           ,[FrequencyIntensityDuration5]
           ,[Settings5]
           ,[Antecedent5]
           ,[ConsequenceThatReinforcesBehavior5]
           ,[EnvironmentalConditions5]
           ,[HypothesisOfBehavioralFunction5]
           ,[ExpectedBehaviorChanges5]
           ,[MethodsOfOutcomeMeasurement5]
           ,[ScheduleOfOutcomeReview5]
           ,[QuarterlyReview5]
           ,[InterventionsAttempted]
           ,[ReplacementBehaviors]
           ,[Motivators]
           ,[NonrestrictiveInterventions]
           ,[RestrictiveInterventions]
           ,[StaffResponsible]
           ,[ReceiveCopyOfPlan]
           ,[WhoCoordinatePlan]
           ,[HowCoordinatePlan]
           ,[UseOfManualRestraints])
     SELECT [DocumentVersionId]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[ModifiedBy]
      ,[ModifiedDate]
      ,[RecordDeleted]
      ,[DeletedBy]
      ,[DeletedDate]
      ,[Type]
      ,[StaffParticipants]
      ,[TargetBehavior1]
      ,[Status1]
      ,[FrequencyIntensityDuration1]
      ,[Settings1]
      ,[Antecedent1]
      ,[ConsequenceThatReinforcesBehavior1]
      ,[EnvironmentalConditions1]
      ,[HypothesisOfBehavioralFunction1]
      ,[ExpectedBehaviorChanges1]
      ,[MethodsOfOutcomeMeasurement1]
      ,[ScheduleOfOutcomeReview1]
      ,[QuarterlyReview1]
      ,[TargetBehavior2]
      ,[Status2]
      ,[FrequencyIntensityDuration2]
      ,[Settings2]
      ,[Antecedent2]
      ,[ConsequenceThatReinforcesBehavior2]
      ,[EnvironmentalConditions2]
      ,[HypothesisOfBehavioralFunction2]
      ,[ExpectedBehaviorChanges2]
      ,[MethodsOfOutcomeMeasurement2]
      ,[ScheduleOfOutcomeReview2]
      ,[QuarterlyReview2]
      ,[TargetBehavior3]
      ,[Status3]
      ,[FrequencyIntensityDuration3]
      ,[Settings3]
      ,[Antecedent3]
      ,[ConsequenceThatReinforcesBehavior3]
      ,[EnvironmentalConditions3]
      ,[HypothesisOfBehavioralFunction3]
      ,[ExpectedBehaviorChanges3]
      ,[MethodsOfOutcomeMeasurement3]
      ,[ScheduleOfOutcomeReview3]
      ,[QuarterlyReview3]
      ,[ConsequenceThatReinforcesBehavior4]
      ,[EnvironmentalConditions4]
      ,[HypothesisOfBehavioralFunction4]
      ,[ExpectedBehaviorChanges4]
      ,[MethodsOfOutcomeMeasurement4]
      ,[ScheduleOfOutcomeReview4]
      ,[QuarterlyReview4]
      ,[TargetBehavior4]
      ,[Status4]
      ,[FrequencyIntensityDuration4]
      ,[Settings4]
      ,[Antecedent4]
      ,[TargetBehavior5]
      ,[Status5]
      ,[FrequencyIntensityDuration5]
      ,[Settings5]
      ,[Antecedent5]
      ,[ConsequenceThatReinforcesBehavior5]
      ,[EnvironmentalConditions5]
      ,[HypothesisOfBehavioralFunction5]
      ,[ExpectedBehaviorChanges5]
      ,[MethodsOfOutcomeMeasurement5]
      ,[ScheduleOfOutcomeReview5]
      ,[QuarterlyReview5]
      ,[InterventionsAttempted]
      ,[ReplacementBehaviors]
      ,[Motivators]
      ,[NonrestrictiveInterventions]
      ,[RestrictiveInterventions]
      ,[StaffResponsible]
      ,[ReceiveCopyOfPlan]
      ,[WhoCoordinatePlan]
      ,[HowCoordinatePlan]
      ,[UseOfManualRestraints]
  FROM [CustomDocumentFABIPs_Temp111]
GO
-------END STEP 5-------------


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_MoveForeignKeyConstraints]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_MoveForeignKeyConstraints]
go
  
create proc [dbo].[ssp_MoveForeignKeyConstraints]  
@FromTable varchar(128), @ToTable varchar(128)  
as  
  
create table #temp1  
(PKTable varchar(128) null,  
FKTable varchar(128) null,  
ConstraintName varchar(128) null,  
Status int null,  
cKeyCol1 varchar(128) null,  
cKeyCol2 varchar(128) null,  
cKeyCol3 varchar(128) null,  
cKeyCol4 varchar(128) null,  
cKeyCol5 varchar(128) null,  
cKeyCol6 varchar(128) null,  
cKeyCol7 varchar(128) null,  
cKeyCol8 varchar(128) null,  
cKeyCol9 varchar(128) null,  
cKeyCol10 varchar(128) null,  
cKeyCol11 varchar(128) null,  
cKeyCol12 varchar(128) null,  
cKeyCol13 varchar(128) null,  
cKeyCol14 varchar(128) null,  
cKeyCol15 varchar(128) null,  
cKeyCol16 varchar(128) null,  
cRefCol1 varchar(128) null,  
cRefCol2 varchar(128) null,  
cRefCol3 varchar(128) null,  
cRefCol4 varchar(128) null,  
cRefCol5 varchar(128) null,  
cRefCol6 varchar(128) null,  
cRefCol7 varchar(128) null,  
cRefCol8 varchar(128) null,  
cRefCol9 varchar(128) null,  
cRefCol10 varchar(128) null,  
cRefCol11 varchar(128) null,  
cRefCol12 varchar(128) null,  
cRefCol13 varchar(128) null,  
cRefCol14 varchar(128) null,  
cRefCol15 varchar(128) null,  
cRefCol16 varchar(128) null,  
PKTableOwner varchar(50) null,  
FKTableOwner varchar(50) null,  
DeleteCascade int null,  
UpdateCascade int null,  
)  
  
declare @CreateSQLString varchar(8000)  
declare @DropSQLString varchar(8000)  
  
declare @PKTable varchar(128),  
@FKTable varchar(128),  
@ConstraintName varchar(128),  
@Status int,  
@cKeyCol1 varchar(128),  
@cKeyCol2 varchar(128),  
@cKeyCol3 varchar(128),  
@cKeyCol4 varchar(128),  
@cKeyCol5 varchar(128),  
@cKeyCol6 varchar(128),  
@cKeyCol7 varchar(128),  
@cKeyCol8 varchar(128),  
@cKeyCol9 varchar(128),  
@cKeyCol10 varchar(128),  
@cKeyCol11 varchar(128),  
@cKeyCol12 varchar(128),  
@cKeyCol13 varchar(128),  
@cKeyCol14 varchar(128),  
@cKeyCol15 varchar(128),  
@cKeyCol16 varchar(128),  
@cRefCol1 varchar(128),  
@cRefCol2 varchar(128),  
@cRefCol3 varchar(128),  
@cRefCol4 varchar(128),  
@cRefCol5 varchar(128),  
@cRefCol6 varchar(128),  
@cRefCol7 varchar(128),  
@cRefCol8 varchar(128),  
@cRefCol9 varchar(128),  
@cRefCol10 varchar(128),  
@cRefCol11 varchar(128),  
@cRefCol12 varchar(128),  
@cRefCol13 varchar(128),  
@cRefCol14 varchar(128),  
@cRefCol15 varchar(128),  
@cRefCol16 varchar(128),  
@PKTableOwner varchar(50),  
@FKTableOwner varchar(50),  
@DeleteCascade int,  
@UpdateCascade int  
  
insert into #temp1  
exec sp_MStablerefs @FromTable, N'actualtables', N'both', null   
  
declare cur_ForeignKeys cursor for  
select PKTable,  
FKTable,  
ConstraintName,  
Status,  
cKeyCol1,  
cKeyCol2,  
cKeyCol3,  
cKeyCol4,  
cKeyCol5,  
cKeyCol6,  
cKeyCol7,  
cKeyCol8,  
cKeyCol9,  
cKeyCol10,  
cKeyCol11,  
cKeyCol12,  
cKeyCol13,  
cKeyCol14,  
cKeyCol15,  
cKeyCol16,  
cRefCol1,  
cRefCol2,  
cRefCol3,  
cRefCol4,  
cRefCol5,  
cRefCol6,  
cRefCol7,  
cRefCol8,  
cRefCol9,  
cRefCol10,  
cRefCol11,  
cRefCol12,  
cRefCol13,  
cRefCol14,  
cRefCol15,  
cRefCol16,  
PKTableOwner,  
FKTableOwner,  
DeleteCascade,  
UpdateCascade  
from #temp1  
  
if @@error <> 0 return  
  
open cur_ForeignKeys  
  
if @@error <> 0 return  
  
fetch cur_ForeignKeys into  
@PKTable,  
@FKTable,  
@ConstraintName,  
@Status,  
@cKeyCol1,  
@cKeyCol2,  
@cKeyCol3,  
@cKeyCol4,  
@cKeyCol5,  
@cKeyCol6,  
@cKeyCol7,  
@cKeyCol8,  
@cKeyCol9,  
@cKeyCol10,  
@cKeyCol11,  
@cKeyCol12,  
@cKeyCol13,  
@cKeyCol14,  
@cKeyCol15,  
@cKeyCol16,  
@cRefCol1,  
@cRefCol2,  
@cRefCol3,  
@cRefCol4,  
@cRefCol5,  
@cRefCol6,  
@cRefCol7,  
@cRefCol8,  
@cRefCol9,  
@cRefCol10,  
@cRefCol11,  
@cRefCol12,  
@cRefCol13,  
@cRefCol14,  
@cRefCol15,  
@cRefCol16,  
@PKTableOwner,  
@FKTableOwner,  
@DeleteCascade,  
@UpdateCascade  
  
if @@error <> 0 return  
  
while @@Fetch_Status = 0  
begin  
  
set @DropSQLString = 'ALTER Table ' + @FKTable + ' DROP CONSTRAINT ' + @ConstraintName  
  
if @FKTable = @FromTable set @FKTable = @ToTable  
else set @PKTable = @ToTable  
  
if @@error <> 0 return  
  
set @CreateSQLString = 'ALTER Table ' + @FKTable + ' ADD CONSTRAINT ' + @ConstraintName +  
' FOREIGN KEY (' + @cKeyCol1 +   
case when @cKeyCol2 is null then rtrim('') else ', ' + @cKeyCol2 end +   
case when @cKeyCol3 is null then rtrim('') else ', ' + @cKeyCol3 end +   
case when @cKeyCol4 is null then rtrim('') else ', ' + @cKeyCol4 end +   
case when @cKeyCol5 is null then rtrim('') else ', ' + @cKeyCol5 end +  
case when @cKeyCol6 is null then rtrim('') else ', ' + @cKeyCol6 end +  
case when @cKeyCol7 is null then rtrim('') else ', ' + @cKeyCol7 end +  
case when @cKeyCol8 is null then rtrim('') else ', ' + @cKeyCol8 end +  
case when @cKeyCol9 is null then rtrim('') else ', ' + @cKeyCol9 end +  
case when @cKeyCol10 is null then rtrim('') else ', ' + @cKeyCol10 end +  
') REFERENCES ' + replace(@PKTable, '_temp111', '') + '(' + @cRefCol1 +  
case when @cRefCol2 is null then rtrim('') else ', ' + @cRefCol2 end +   
case when @cRefCol3 is null then rtrim('') else ', ' + @cRefCol3 end +   
case when @cRefCol4 is null then rtrim('') else ', ' + @cRefCol4 end +   
case when @cRefCol5 is null then rtrim('') else ', ' + @cRefCol5 end +   
case when @cRefCol6 is null then rtrim('') else ', ' + @cRefCol6 end +   
case when @cRefCol7 is null then rtrim('') else ', ' + @cRefCol7 end +   
case when @cRefCol8 is null then rtrim('') else ', ' + @cRefCol8 end +   
case when @cRefCol9 is null then rtrim('') else ', ' + @cRefCol9 end +   
case when @cRefCol10 is null then rtrim('') else ', ' + @cRefCol10 end +   
')' + case  when @DeleteCascade = 1 then ' ON DELETE CASCADE' else rtrim('') end  
+ case  when @UpdateCascade = 1 then ' ON UPDATE CASCADE' else rtrim('') end  
  
   
if @@error <> 0 return  
  
print @DropSQLString  
execute(@DropSQLString)  
  
if @@error <> 0 return  
  
print @CreateSQLString  
execute(@CreateSQLString)  
  
  
if @@error <> 0 return  
  
fetch cur_ForeignKeys into  
@PKTable,  
@FKTable,  
@ConstraintName,  
@Status,  
@cKeyCol1,  
@cKeyCol2,  
@cKeyCol3,  
@cKeyCol4,  
@cKeyCol5,  
@cKeyCol6,  
@cKeyCol7,  
@cKeyCol8,  
@cKeyCol9,  
@cKeyCol10,  
@cKeyCol11,  
@cKeyCol12,  
@cKeyCol13,  
@cKeyCol14,  
@cKeyCol15,  
@cKeyCol16,  
@cRefCol1,  
@cRefCol2,  
@cRefCol3,  
@cRefCol4,  
@cRefCol5,  
@cRefCol6,  
@cRefCol7,  
@cRefCol8,  
@cRefCol9,  
@cRefCol10,  
@cRefCol11,  
@cRefCol12,  
@cRefCol13,  
@cRefCol14,  
@cRefCol15,  
@cRefCol16,  
@PKTableOwner,  
@FKTableOwner,  
@DeleteCascade,  
@UpdateCascade  
  
if @@error <> 0 return  
  
end  
  
close cur_ForeignKeys  
  
if @@error <> 0 return  
  
deallocate cur_ForeignKeys  
  
if @@error <> 0 return  

GO


------ STEP 6  ----------
exec ssp_MoveForeignKeyConstraints  'CustomDocumentFABIPs_Temp111','CustomDocumentFABIPs'

PRINT 'STEP 6 COMPLETED'
GO

------ STEP 7 -----------
Drop Table CustomDocumentFABIPs_Temp111

PRINT 'STEP 7 COMPLETED'
Update SystemConfigurations set CustomDataBaseVersion=1.30

Go


