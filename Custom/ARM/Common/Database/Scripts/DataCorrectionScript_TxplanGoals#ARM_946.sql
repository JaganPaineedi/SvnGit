IF EXISTS (select * from documents where currentdocumentversionid=1433583)
BEGIN
If NOT Exists (select * from CustomTPGoals where documentversionid=1433583)
BEGIN

Insert into CustomTPGoals(createdby, documentversionid,goalNumber,GoalText,TargeDate,active,ProgressTowardsGoal,Deletionnotallowed)
values('ARM#946',1433583, 1,'"help me focus"', '2019-08-08 00:00:00.000' ,'Y', 'N', 'Y')

insert into CustomTPGoals(createdby, documentversionid,goalNumber,GoalText,TargeDate,active,ProgressTowardsGoal,Deletionnotallowed)
values('ARM#946',1433583, 2,'"Getting help in school and improving my life"', '2019-08-08 00:00:00.000' ,'Y', 'S', 'Y')

END
END