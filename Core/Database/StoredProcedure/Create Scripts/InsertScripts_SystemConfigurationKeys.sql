--Waht : If any customer needs different calculation, then new Stored Procedure is created and the name of the new SP will be updated as a value for systemconfigurationkeys table for the key = 'CaseLoadReAssignStoredProcedure'. 
-- Why: Thresholds - Support #1087


IF NOT EXISTS (SELECT [KEY] FROM SystemConfigurationKeys WHERE [KEY] = 'CaseLoadReAssignStoredProcedure' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
  INSERT INTO SystemConfigurationKeys ([Key], Value, [Description], AcceptedValues, Modules)
    VALUES ('CaseLoadReAssignStoredProcedure', NULL ,'This value of this key is the name of the Stored Procedure used for custom Re-assignment. This Stored Procedure (SP) is called when re-assigning the staff from another staff using ReAssignment screen. If any customer needs different calculation, then new Stored Procedure is created and the name of the new SP will be updated as a value for this key. The primary input parameters for custom Re-Assignments are @ReAssignStaffId and @loggedInUserId. VALUE: For customers who would need different logic for Staff Re-assignment, a new SP can be created and the SP name is set as the value for this key.', 'Custom Stored procedure name', 'CaseLoad Re-Assignment')
END
GO
