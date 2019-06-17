--GLOBALCODE SCRIPT FOR PSYCHO SOCIAL CHILD AND ADULT ADDED BY VEENA

DELETE FROM GLOBALCODES WHERE CATEGORY IN ('XPSDDRISKDUETO','XHHoptions1','XHHPHQ9')

INSERT INTO [GlobalCodes] ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1])VALUES('XPSDDRISKDUETO','Support Limitations',NULL,'Y','Y',NULL)
INSERT INTO [GlobalCodes] ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1])VALUES('XPSDDRISKDUETO','Behavioral Issues',NULL,'Y','Y',NULL)
INSERT INTO [GlobalCodes] ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1])VALUES('XPSDDRISKDUETO','Medical Issues',NULL,'Y','Y',NULL)


INSERT INTO [GlobalCodes] ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1])VALUES('XHHoptions1','Almost all of the time','1','Y','N',NULL)
INSERT INTO [GlobalCodes] ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1])VALUES('XHHoptions1','Most of the time','2','Y','N',NULL)
INSERT INTO [GlobalCodes] ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1])VALUES('XHHoptions1','Some of the time','3','Y','N',NULL)
INSERT INTO [GlobalCodes] ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1])VALUES('XHHoptions1','Almost Never','4','Y','N',NULL)

INSERT INTO [GlobalCodes] ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1])VALUES('XHHPHQ9','0 = Not at all','1','Y','N',NULL)
INSERT INTO [GlobalCodes] ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1])VALUES('XHHPHQ9','1 = Several Days','2','Y','N',NULL)
INSERT INTO [GlobalCodes] ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1])VALUES('XHHPHQ9','2 = More than half the days','3','Y','N',NULL)
INSERT INTO [GlobalCodes] ([Category],[CodeName],[Code],[Active],[CannotModifyNameOrDelete],[ExternalCode1])VALUES('XHHPHQ9','3 = Nearly every day','4','Y','N',NULL)