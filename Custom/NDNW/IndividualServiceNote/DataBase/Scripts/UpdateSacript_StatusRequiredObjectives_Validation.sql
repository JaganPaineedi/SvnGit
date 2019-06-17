--New Directions - Support Go Live 735  
--update script to remove the duplicate goals for individual service note as it was intializing from careplan 

With CTE_Duplicates(IndividualServiceNoteGoalId,documentversionid,Goalid,customgoalactive,rownumber) as
   (select IndividualServiceNoteGoalId,documentversionid,Goalid,customgoalactive, row_number() over(partition by goalid,documentversionid,customgoalactive order by goalid,documentversionid,modifieddate ) rownumber 
   from CustomIndividualServiceNoteGoals where isnull(recorddeleted,'N')<>'Y' and customgoalactive = 'Y' )
  
 
UPDATE CustomIndividualServiceNoteGoals 
SET CustomIndividualServiceNoteGoals.Recorddeleted='Y',CustomIndividualServiceNoteGoals.DeletedBy='Duplicate',CustomIndividualServiceNoteGoals.Deleteddate=getdate()
FROM 
CTE_Duplicates
WHERE CustomIndividualServiceNoteGoals.IndividualServiceNoteGoalId = CTE_Duplicates.IndividualServiceNoteGoalId and rownumber != 1

--update logic for the Status validation as the earlier validation checks for only objectives.
update documentvalidations set validationlogic='FROM CustomIndividualServiceNoteObjectives CO join
 CustomIndividualServiceNoteGoals CG on CG.GoalId=CO.Goalid WHERE CO.DocumentVersionId=@DocumentVersionId AND ISNULL(CO.RecordDeleted,''N'') = ''N'' AND CG.DocumentVersionId=@DocumentVersionId AND ISNULL(CG.RecordDeleted,''N'') = ''N'' AND CustomObjectiveActive = ''Y'' AND Status IS NULL'
where tablename='CustomIndividualServiceNoteObjectives' and columnname ='Status' and tabname='General' and validationdescription='Goals/Objectives – Objective status is required'
and documentcodeid=11145