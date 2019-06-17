
-- Used CodeName in the If condition, Since the Code field was NULL in few environments
-- Modifications
-- Date                    Name                           Purpose
-- 10/23/2018              Vijay                          Need to update Staff table if GlobalCodeId's(1001, 1002, 1003, 1004, 1005, 1006) are deleted

If NOT EXISTS(Select 1 from GlobalCodes where GlobalCodeId =1001)
BEGIN
	update staff set SureScriptsServiceLevel = (Select GlobalCodeId from GlobalCodes where Category='SURESCRIPTSLEVEL' and CodeName = 'No Surescripts')
	where SureScriptsServiceLevel = 1001
END

If NOT EXISTS(Select 1 from GlobalCodes where GlobalCodeId =1002)
BEGIN
	update staff set SureScriptsServiceLevel = (Select GlobalCodeId from GlobalCodes where Category='SURESCRIPTSLEVEL' and CodeName = 'NewRx Only')
	where SureScriptsServiceLevel = 1002
END

If NOT EXISTS(Select 1 from GlobalCodes where GlobalCodeId =1003)
BEGIN
	update staff set SureScriptsServiceLevel = (Select GlobalCodeId from GlobalCodes where Category='SURESCRIPTSLEVEL' and CodeName = 'NewRx + Refill')
	where SureScriptsServiceLevel = 1003
END

If NOT EXISTS(Select 1 from GlobalCodes where GlobalCodeId =1004)
BEGIN
	update staff set SureScriptsServiceLevel = (Select GlobalCodeId from GlobalCodes where Category='SURESCRIPTSLEVEL' and CodeName = 'NewRx + CancelRx')
	where SureScriptsServiceLevel = 1004
END

If NOT EXISTS(Select 1 from GlobalCodes where GlobalCodeId =1005)
BEGIN
	update staff set SureScriptsServiceLevel = (Select GlobalCodeId from GlobalCodes where Category='SURESCRIPTSLEVEL' and CodeName = 'NewRx + Refill + CancelRx')
	where SureScriptsServiceLevel = 1005
END

If NOT EXISTS(Select 1 from GlobalCodes where GlobalCodeId =1006)
BEGIN
	update staff set SureScriptsServiceLevel = (Select GlobalCodeId from GlobalCodes where Category='SURESCRIPTSLEVEL' and CodeName = 'NewRx + Refill + EPCS')
	where SureScriptsServiceLevel = 1006
END