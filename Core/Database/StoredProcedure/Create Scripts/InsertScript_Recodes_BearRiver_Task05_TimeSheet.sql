DECLARE @StaffPersonalLeave INT
DECLARE @StaffLongTermSickLeave INT
DECLARE @StaffHoliday INT

IF NOT EXISTS(SELECT 1 FROM RecodeCategories WHERE CategoryCode='StaffPersonalLeave')
 INSERT INTO RecodeCategories (CategoryCode)
 VALUES ('StaffPersonalLeave')
 
IF NOT EXISTS(SELECT 1 FROM RecodeCategories WHERE CategoryCode='StaffLongTermSickLeave')
 INSERT INTO RecodeCategories (CategoryCode)
 VALUES ('StaffLongTermSickLeave')
 
IF NOT EXISTS(SELECT 1 FROM RecodeCategories WHERE CategoryCode='Holiday')
 INSERT INTO RecodeCategories (CategoryCode)
 VALUES ('Holiday')
 
SET @StaffPersonalLeave = (SELECT RecodeCategoryId FROM RecodeCategories WHERE CategoryCode='StaffPersonalLeave')
SET @StaffLongTermSickLeave = (SELECT RecodeCategoryId FROM RecodeCategories WHERE CategoryCode='StaffLongTermSickLeave')
SET @StaffHoliday = (SELECT RecodeCategoryId FROM RecodeCategories WHERE CategoryCode='Holiday') 
 
/******************************************************************/
/*****************Recodes********************************/


IF EXISTS (SELECT 1 FROM Recodes WHERE RecodeCategoryId=@StaffPersonalLeave)
	DELETE FROM Recodes WHERE RecodeCategoryId=@StaffPersonalLeave
	

INSERT INTO Recodes (CharacterCodeId,CodeName,RecodeCategoryId)
VALUES
('PERSONALLEAVE','PersonalLeave',@StaffPersonalLeave)
,('LEAVEWITHPAY','LeaveWithPay',@StaffPersonalLeave)



IF EXISTS (SELECT 1 FROM Recodes WHERE RecodeCategoryId=@StaffLongTermSickLeave)
	DELETE FROM Recodes WHERE RecodeCategoryId=@StaffLongTermSickLeave
INSERT INTO Recodes (CharacterCodeId,CodeName,RecodeCategoryId)
VALUES
('LONGTERMSICKLEAVE','LongTermSickLeave',@StaffLongTermSickLeave)



IF EXISTS (SELECT 1 FROM Recodes WHERE RecodeCategoryId=@StaffHoliday)
	DELETE FROM Recodes WHERE RecodeCategoryId=@StaffHoliday
INSERT INTO Recodes (CharacterCodeId,CodeName,RecodeCategoryId)
VALUES
('HOLIDAY','Holiday',@StaffHoliday)
 