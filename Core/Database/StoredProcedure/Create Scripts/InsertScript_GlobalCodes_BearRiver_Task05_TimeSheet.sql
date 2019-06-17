
IF NOT EXISTS (SELECT 1 FROM GlobalCodeCategories WHERE Category='AccrualType')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit)
	VALUES ('AccrualType','AccrualType','Y','Y','Y','Y')
END

IF NOT EXISTS (SELECT 1 FROM GlobalCodeCategories WHERE Category='AdjustmentType')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit)
	VALUES ('AdjustmentType','AdjustmentType','Y','Y','Y','Y')
END

IF NOT EXISTS (SELECT 1 FROM GlobalCodeCategories WHERE Category='StaffLeaveType')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit)
	VALUES ('StaffLeaveType','StaffLeaveType','Y','Y','Y','Y')
END

IF NOT EXISTS (SELECT 1 FROM GlobalCodeCategories WHERE Category='AccuralHistoryPer')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit)
	VALUES ('AccuralHistoryPer','AccuralHistoryPer','Y','Y','Y','Y')
END




/*********************************************************************************/
/*******************************GlobalCodes***************************************/

IF EXISTS (SELECT 1 FROM GlobalCodes WHERE Category ='AccuralHistoryPer')
 DELETE FROM GlobalCodes WHERE Category ='AccuralHistoryPer'
 GO
INSERT INTO GlobalCodes (Category,CodeName,Code,Description,Active,SortOrder,ExternalCode1)
VALUES ('AccuralHistoryPer','Weekly','Weekly','','Y',1,'WEEKLY')
,('AccuralHistoryPer','Every Other Week','Every Other Week','','Y',2,'EVERYOTHERWEEK')
,('AccuralHistoryPer','Monthly','Monthly','','Y',3,'MONTHLY')
,('AccuralHistoryPer','Annually','Annually','','Y',4,'ANNUALLY')


IF EXISTS (SELECT 1 FROM GlobalCodes WHERE Category ='StaffLeaveType')
 DELETE FROM GlobalCodes WHERE Category ='StaffLeaveType'
 GO
INSERT INTO GlobalCodes (Category,CodeName,Code,Description,Active,SortOrder,ExternalCode1)
VALUES ('StaffLeaveType','Personal Leave','PersonalLeave','','Y',1,'PERSONALLEAVE')
,('StaffLeaveType','Long Term Sick Leave','LongTermSickLeave','','Y',2,'LONGTERMSICKLEAVE')
,('StaffLeaveType','Holiday','Holiday','','Y',3,'HOLIDAY')
,('StaffLeaveType','Leave with Pay','LeaveWithPay','','Y',4,'LEAVEWITHPAY')




IF EXISTS (SELECT 1 FROM GlobalCodes WHERE Category ='AccrualType')
 DELETE FROM GlobalCodes WHERE Category ='AccrualType'
 GO
INSERT INTO GlobalCodes (Category,CodeName,Code,Description,Active,SortOrder,ExternalCode1)
VALUES ('AccrualType','Personal Leave','PersonalLeave','','Y',1,'PERSONALLEAVE')
,('AccrualType','Long Term Sick Leave','LongTermSickLeave','','Y',2,'LONGTERMSICKLEAVE')


IF EXISTS (SELECT 1 FROM GlobalCodes WHERE Category ='AdjustmentType')
 DELETE FROM GlobalCodes WHERE Category ='AdjustmentType'
 GO
INSERT INTO GlobalCodes (Category,CodeName,Code,Description,Active,SortOrder,ExternalCode1)
VALUES ('AdjustmentType','Add','Add','','Y',1,'ADD')
,('AdjustmentType','Minus','Minus','','Y',2,'MINUS')