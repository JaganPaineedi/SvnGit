--------------------------------------------------------------------------
--Author : Suneel.N
--Date   : 20/06/2017
--Purpose: Added core globalcode for Plan->Rules.Ref #98 MHP - Implementation.
--------------------------------------------------------------------------

SET IDENTITY_INSERT [GlobalCodes] ON
GO
IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId = 4275 and Category = 'COVERAGEPLANRULE' AND CodeName = 'Only these degrees may provide billable services for these codes')
BEGIN
	INSERT INTO GlobalCodes(GlobalCodeId, Category, CodeName, Code, Active)
					VALUES(4275,'COVERAGEPLANRULE', 'Only these degrees may provide billable services for these codes', NULL, 'Y') 
END
SET IDENTITY_INSERT [GlobalCodes] OFF
