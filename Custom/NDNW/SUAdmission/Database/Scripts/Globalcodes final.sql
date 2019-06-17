/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions  
-- "SUAdmissions"
-- Purpose: Global Code Entries to Bind Drop Down for for Task New Directions-Customizations #5.
--  
-- Author:  SuryaBalan
-- Date:    9-March-2015

*********************************************************************************/
-- Admission type --
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xSUAdminType' AND Category = 'xSUAdminType')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xSUAdminType','xSUAdminType','Y','Y','Y','Y','New Directions-Customizations #5','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xSUAdminType' ,CategoryName = 'xSUAdminType',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions-Customizations #5',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xSUAdminType' AND Category = 'xSUAdminType'
END

DELETE FROM GlobalCodes WHERE Category = 'xSUAdminType'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('xSUAdminType','Initial Admission','New Directions-Customizations #5','Y','N',1),
('xSUAdminType','Transfer from other SU services','New Directions-Customizations #5','Y','N',2)


-- Admission program type --


IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xSUAdmissionProgram' AND Category = 'xSUAdmissionProgram')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xSUAdmissionProgram','xSUAdmissionProgram','Y','Y','Y','Y','New Directions-Customizations #5','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xSUAdmissionProgram' ,CategoryName = 'xSUAdmissionProgram',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions-Customizations #5',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xSUAdmissionProgram' AND Category = 'xSUAdmissionProgram'
END

DELETE FROM GlobalCodes WHERE Category = 'xSUAdmissionProgram'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,Code)
VALUES 
('xSUAdmissionProgram','Treatment not Recommended number','New Directions-Customizations #5','Y','N',1,0),
('xSUAdmissionProgram','Detox. Hospital Inpat. assessment ASAM','New Directions-Customizations #5','Y','N',2,1),
('xSUAdmissionProgram','Detox. Free Standing Cannot be left blank','New Directions-Customizations #5','Y','N',3,2),
('xSUAdmissionProgram','Rehab/Res. Hospital If not collected then default to 98','New Directions-Customizations #5','Y','N',4,3),
('xSUAdmissionProgram','Rehab./Res. Short Term','New Directions-Customizations #5','Y','N',5,4),
('xSUAdmissionProgram','Rehab./Res. Long Term','New Directions-Customizations #5','Y','N',6,5),
('xSUAdmissionProgram','Amb. Intensive Outpatient','New Directions-Customizations #5','Y','N',7,6),
('xSUAdmissionProgram','Amb. Outpatient','New Directions-Customizations #5','Y','N',8,7),
('xSUAdmissionProgram','Amb. Detox','New Directions-Customizations #5','Y','N',9,8),
('xSUAdmissionProgram','Limited Treatment','New Directions-Customizations #5','Y','N',10,9),
('xSUAdmissionProgram','Education Only / Treatment Not Recommended','New Directions-Customizations #5','Y','N',11,10),
('xSUAdmissionProgram','Not Collected','New Directions-Customizations #5','Y','N',12,98)


-- Referral Source --


IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'Referral Source' AND Category = 'REFERRALSOURCE')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('REFERRALSOURCE','Referral Source','Y','Y','Y','Y','New Directions-Customizations #5','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'REFERRALSOURCE' ,CategoryName = 'Referral Source',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions-Customizations #5',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'Referral Source' AND Category = 'REFERRALSOURCE'
END

DELETE FROM GlobalCodes WHERE Category = 'REFERRALSOURCE'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,Code)
VALUES 
('REFERRALSOURCE','Individual Includes Self','New Directions-Customizations #5','Y','N',1,1),
('REFERRALSOURCE','Alcohol/Drug Abuse Care Provider','New Directions-Customizations #5','Y','N',2,2),
('REFERRALSOURCE','Other Health Care Provider','New Directions-Customizations #5','Y','N',3,3),
('REFERRALSOURCE','School','New Directions-Customizations #5','Y','N',4,4),
('REFERRALSOURCE','Employer/EAP','New Directions-Customizations #5','Y','N',5,5),
('REFERRALSOURCE','Division of Workforce Services-Welfare','New Directions-Customizations #5','Y','N',6,6),
('REFERRALSOURCE','DCFS','New Directions-Customizations #5','Y','N',7,7),
('REFERRALSOURCE','Adult Court','New Directions-Customizations #5','Y','N',8,8),
('REFERRALSOURCE','Juvenile Court','New Directions-Customizations #5','Y','N',9,9),
('REFERRALSOURCE','Probation','New Directions-Customizations #5','Y','N',10,10),
('REFERRALSOURCE','Parole','New Directions-Customizations #5','Y','N',11,11),
('REFERRALSOURCE','Police','New Directions-Customizations #5','Y','N',12,12),
('REFERRALSOURCE','Prison','New Directions-Customizations #5','Y','N',13,13),
('REFERRALSOURCE','DUI/DWI','New Directions-Customizations #5','Y','N',14,14),
('REFERRALSOURCE','Other Community Referral','New Directions-Customizations #5','Y','N',15,15),
('REFERRALSOURCE','Unknown','New Directions-Customizations #5','Y','N',16,97)


-- Expected primary source of payment --

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xSourceofPayment' AND Category = 'xSourceofPayment')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xSourceofPayment','xSourceofPayment','Y','Y','Y','Y','New Directions-Customizations #5','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xSourceofPayment' ,CategoryName = 'xSourceofPayment',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions-Customizations #5',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xSourceofPayment' AND Category = 'xSourceofPayment'
END

DELETE FROM GlobalCodes WHERE Category = 'xSourceofPayment'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,Code)
VALUES 
('xSourceofPayment','Self Pay number','New Directions-Customizations #5','Y','N',1,1),
('xSourceofPayment','Blue Cross/ Blue Shield','New Directions-Customizations #5','Y','N',2,2),
('xSourceofPayment','Medicare','New Directions-Customizations #5','Y','N',3,3),
('xSourceofPayment','Medicaid','New Directions-Customizations #5','Y','N',4,4),
('xSourceofPayment','Other Government','New Directions-Customizations #5','Y','N',5,5),
('xSourceofPayment','Workers Compensation','New Directions-Customizations #5','Y','N',6,6),
('xSourceofPayment','Other Health Insurance Co','New Directions-Customizations #5','Y','N',7,7),
('xSourceofPayment','No Charge/Free/Charity','New Directions-Customizations #5','Y','N',8,8),
('xSourceofPayment','CHIP','New Directions-Customizations #5','Y','N',9,9),
('xSourceofPayment','Drug Court','New Directions-Customizations #5','Y','N',10,11),
('xSourceofPayment','Other','New Directions-Customizations #5','Y','N',11,20),
('xSourceofPayment','Unknown','New Directions-Customizations #5','Y','N',12,97)


-- Prior episode -- 

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xPriorEpisode' AND Category = 'xPriorEpisode')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xPriorEpisode','xPriorEpisode','Y','Y','Y','Y','New Directions-Customizations #5','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xPriorEpisode' ,CategoryName = 'xPriorEpisode',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions-Customizations #5',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xPriorEpisode' AND Category = 'xPriorEpisode'
END

DELETE FROM GlobalCodes WHERE Category = 'xPriorEpisode'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('xPriorEpisode','0','New Directions-Customizations #5','Y','N',1),
('xPriorEpisode','1','New Directions-Customizations #5','Y','N',2),
('xPriorEpisode','2','New Directions-Customizations #5','Y','N',3),
('xPriorEpisode','3','New Directions-Customizations #5','Y','N',4),
('xPriorEpisode','4','New Directions-Customizations #5','Y','N',5),
('xPriorEpisode','5 or more','New Directions-Customizations #5','Y','N',6)


-- Number of days in Social Supports  --


IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xDaysSocialSupports' AND Category = 'xDaysSocialSupports')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xDaysSocialSupports','xDaysSocialSupports','Y','Y','Y','Y','New Directions-Customizations #5','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xDaysSocialSupports' ,CategoryName = 'xDaysSocialSupports',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions-Customizations #5',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xDaysSocialSupports' AND Category = 'xDaysSocialSupports'
END

DELETE FROM GlobalCodes WHERE Category = 'xDaysSocialSupports'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,Code)
VALUES 
('xDaysSocialSupports','No attendance in the past month','New Directions-Customizations #5','Y','N',1,2),
('xDaysSocialSupports','1-3 times in past month','New Directions-Customizations #5','Y','N',2,3),
('xDaysSocialSupports','4-7 times in past month','New Directions-Customizations #5','Y','N',3,4),
('xDaysSocialSupports','8-15 times in past month','New Directions-Customizations #5','Y','N',4,5),
('xDaysSocialSupports','16-30 times in past month','New Directions-Customizations #5','Y','N',5,6),
('xDaysSocialSupports','Some attendance in past month but frequency unknown','New Directions-Customizations #5','Y','N',6,7),
('xDaysSocialSupports','Unknown','New Directions-Customizations #5','Y','N',7,97)


--Veterans status --


IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XVETERANSTATUS' AND Category = 'XVETERANSTATUS')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XVETERANSTATUS','XVETERANSTATUS','Y','Y','Y','Y','New Directions-Customizations #5','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XVETERANSTATUS' ,CategoryName = 'XVETERANSTATUS',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions-Customizations #5',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XVETERANSTATUS' AND Category = 'XVETERANSTATUS'
END

DELETE FROM GlobalCodes WHERE Category = 'XVETERANSTATUS'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('XVETERANSTATUS','Not a veteran','New Directions-Customizations #5','Y','N',1),
('XVETERANSTATUS','Veteran','New Directions-Customizations #5','Y','N',2),
('XVETERANSTATUS','Currently on active duty','New Directions-Customizations #5','Y','N',3),
('XVETERANSTATUS','Unknown, declined to answer','New Directions-Customizations #5','Y','N',4)


--Admitted population --

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xAdmittedPopulation' AND Category = 'xAdmittedPopulation')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xAdmittedPopulation','xAdmittedPopulation','Y','Y','Y','Y','New Directions-Customizations #5','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xAdmittedPopulation' ,CategoryName = 'xAdmittedPopulation',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions-Customizations #5',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xAdmittedPopulation' AND Category = 'xAdmittedPopulation'
END

DELETE FROM GlobalCodes WHERE Category = 'xAdmittedPopulation'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,Code)
VALUES 
('xAdmittedPopulation','Youth','New Directions-Customizations #5','Y','N',1,01),
('xAdmittedPopulation','Women’s','New Directions-Customizations #5','Y','N',2,02),
('xAdmittedPopulation','Children','New Directions-Customizations #5','Y','N',3,04),
('xAdmittedPopulation','Forensics','New Directions-Customizations #5','Y','N',4,05),
('xAdmittedPopulation','Jail/CATS','New Directions-Customizations #5','Y','N',5,06),
('xAdmittedPopulation','Med MGT','New Directions-Customizations #5','Y','N',6,07),
('xAdmittedPopulation','Gen Prog/Toole/Summit','New Directions-Customizations #5','Y','N',7,99),
('xAdmittedPopulation','Adult ASAM Level 1.0','New Directions-Customizations #5','Y','N',8,19),
('xAdmittedPopulation','Youth ASAM Level 1.0','New Directions-Customizations #5','Y','N',9,22),
('xAdmittedPopulation','Children’s ASAM Level 1.0','New Directions-Customizations #5','Y','N',10,24),
('xAdmittedPopulation','Adult Evaluation','New Directions-Customizations #5','Y','N',11,20),
('xAdmittedPopulation','Youth Evaluation','New Directions-Customizations #5','Y','N',12,21)


-- Admitted ASAM --


IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xAdmittedAsam' AND Category = 'xAdmittedAsam')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xAdmittedAsam','xAdmittedAsam','Y','Y','Y','Y','New Directions-Customizations #5','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xAdmittedAsam' ,CategoryName = 'xAdmittedAsam',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions-Customizations #5',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xAdmittedAsam' AND Category = 'xAdmittedAsam'
END

DELETE FROM GlobalCodes WHERE Category = 'xAdmittedAsam'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,Code)
VALUES 
('xAdmittedAsam','Outpatient','New Directions-Customizations #5','Y','N',1,10),
('xAdmittedAsam','Intensive Outpatient','New Directions-Customizations #5','Y','N',2,21),
('xAdmittedAsam','Amb. Day Treatment','New Directions-Customizations #5','Y','N',3,25),
('xAdmittedAsam','Low-Intensity Residential','New Directions-Customizations #5','Y','N',4,31),
('xAdmittedAsam','High-Int. Residential','New Directions-Customizations #5','Y','N',5,35)


-- Referred ASAM --
-- Category name was given as same as ReferredAsam ASAM from task 954 


IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XINDICATEDLEVEL' AND Category = 'XINDICATEDLEVEL')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XINDICATEDLEVEL','XINDICATEDLEVEL','Y','Y','Y','Y','New Directions-Customizations #5','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XINDICATEDLEVEL' ,CategoryName = 'XINDICATEDLEVEL',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions-Customizations #5',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XINDICATEDLEVEL' AND Category = 'XINDICATEDLEVEL'
END

DELETE FROM GlobalCodes WHERE Category = 'XINDICATEDLEVEL'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,Code)
VALUES 
('XINDICATEDLEVEL','Outpatient','New Directions-Customizations #5','Y','N',1,10),
('XINDICATEDLEVEL','Intensive Outpatient','New Directions-Customizations #5','Y','N',2,21),
('XINDICATEDLEVEL','Amb. Day Treatment','New Directions-Customizations #5','Y','N',3,25),
('XINDICATEDLEVEL','Low-Intensity Residential','New Directions-Customizations #5','Y','N',4,31),
('XINDICATEDLEVEL','High-Int. Residential','New Directions-Customizations #5','Y','N',5,35)


-- State code--




IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xStateCode' AND Category = 'xStateCode')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xStateCode','xStateCode','Y','Y','Y','Y','New Directions-Customizations #5','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xStateCode' ,CategoryName = 'xStateCode',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions-Customizations #5',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xStateCode' AND Category = 'xStateCode'
END

DELETE FROM GlobalCodes WHERE Category = 'xStateCode'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('xStateCode','Summit','New Directions-Customizations #5','Y','N',1),
('xStateCode','Tooele','New Directions-Customizations #5','Y','N',2),
('xStateCode','Salt Lake County','New Directions-Customizations #5','Y','N',3),
('xStateCode','Non Reportable to SLC','New Directions-Customizations #5','Y','N',4)


-- Drug Court Participation--



IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xDrugCourt' AND Category = 'xDrugCourt')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xDrugCourt','xDrugCourt','Y','Y','Y','Y','New Directions-Customizations #5','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xDrugCourt' ,CategoryName = 'xDrugCourt',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions-Customizations #5',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xDrugCourt' AND Category = 'xDrugCourt'
END

DELETE FROM GlobalCodes WHERE Category = 'xDrugCourt'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,Code)
VALUES 
('xDrugCourt','NOT APPLICABLE','New Directions-Customizations #5','Y','N',1,98),
('xDrugCourt','BEARRV FDC BRIG CTY-ALLEN','New Directions-Customizations #5','Y','N',2,11),
('xDrugCourt','BEARRV FDC LOGAN-WILLMORE','New Directions-Customizations #5','Y','N',3,12),
('xDrugCourt','CARBONCO FDC PRICE-THOMAS','New Directions-Customizations #5','Y','N',4,13),
('xDrugCourt','CARBCO FDDC PRICE-JOHANSN','New Directions-Customizations #5','Y','N',5,14),
('xDrugCourt','DAVIS FDC FARMGTN-MORRIS','New Directions-Customizations #5','Y','N',6,15),
('xDrugCourt','DAVIS FDDC FARMGTN-NOLAND','New Directions-Customizations #5','Y','N',7,16),
('xDrugCourt','EMERY FDC CASTLED-JOHANSN','New Directions-Customizations #5','Y','N',8,17),
('xDrugCourt','GRAND CO FDC MOAB-MANLEY','New Directions-Customizations #5','Y','N',9,18),
('xDrugCourt','GRAND CO FDDC MOAB-MANLEY','New Directions-Customizations #5','Y','N',10,19),
('xDrugCourt','IRONCO FDC CEDAR C-WALTON','New Directions-Customizations #5','Y','N',11,20),
('xDrugCourt','JUAB FDC NEPHI-BRADY','New Directions-Customizations #5','Y','N',12,21),

('xDrugCourt','KANE CO FDC KANAB-BAGLEY','New Directions-Customizations #5','Y','N',13,22),
('xDrugCourt','MILLARD FDC FILLMR-BRADY','New Directions-Customizations #5','Y','N',14,23),
('xDrugCourt','SANJUAN FDC MONTI-ANDRSON','New Directions-Customizations #5','Y','N',15,24),
('xDrugCourt','SANPETE FDC MANTI-BAGLEY','New Directions-Customizations #5','Y','N',16,25),
('xDrugCourt','SEVIERCO FDC RICHFD-BAGLY','New Directions-Customizations #5','Y','N',17,26),
('xDrugCourt','SEVIERCO FDC RICHFD-LEE','New Directions-Customizations #5','Y','N',18,27),
('xDrugCourt','SLCO FDC SLC-BERND-GOODMN','New Directions-Customizations #5','Y','N',19,28),
('xDrugCourt','SLC FDC SLC-SKANCHY','New Directions-Customizations #5','Y','N',20,29),
('xDrugCourt','SLCO FDC WJORDAN-KOURIS','New Directions-Customizations #5','Y','N',21,30),
('xDrugCourt','SLCO FDDC SLC-BEHRENS','New Directions-Customizations #5','Y','N',22,31),
('xDrugCourt','SLCO FDDC SLC-HORNAK','New Directions-Customizations #5','Y','N',23,32),
('xDrugCourt','SLCO FDDC SLC-LUND','New Directions-Customizations #5','Y','N',24,33),

('xDrugCourt','SLC FDDC WJORDAN-DECKER','New Directions-Customizations #5','Y','N',25,34),
('xDrugCourt','SLCO JDC SLC-HORNAK','New Directions-Customizations #5','Y','N',26,35),
('xDrugCourt','SLCO MISDEMNR SLC-ROBISON','New Directions-Customizations #5','Y','N',27,36),
('xDrugCourt','TOOELE FDC TOOELE-ATKINS','New Directions-Customizations #5','Y','N',28,37),
('xDrugCourt','TOOELE JDC TOOELE-MAY','New Directions-Customizations #5','Y','N',29,38),
('xDrugCourt','UINTAH FDC VERNAL-MCCLELN','New Directions-Customizations #5','Y','N',30,39),
('xDrugCourt','UTAH CO FDC PROVO-BRADY','New Directions-Customizations #5','Y','N',31,40),
('xDrugCourt','UTAH CO FDC PROVO-TAYLOR','New Directions-Customizations #5','Y','N',32,41),
('xDrugCourt','UTAHCO FDDC AMFRK-BAZZELE','New Directions-Customizations #5','Y','N',33,42),
('xDrugCourt','UTAH CO FDDC OREM-NOONAN','New Directions-Customizations #5','Y','N',34,43),
('xDrugCourt','UTAHCO FDDC PROVO-LINDSAY','New Directions-Customizations #5','Y','N',35,44),
('xDrugCourt','UTAHCO FDDC SP FRK-SMITH','New Directions-Customizations #5','Y','N',36,45),

('xDrugCourt','UTAH CO JDC PROVO-LINDSEY','New Directions-Customizations #5','Y','N',37,46),
('xDrugCourt','WASATCH FDC HEBER-PULLAN','New Directions-Customizations #5','Y','N',38,47),
('xDrugCourt','WA CO FDC STGEORG-SHUMATE','New Directions-Customizations #5','Y','N',39,48),
('xDrugCourt','WA CO FDDC STGERG-STAHELI','New Directions-Customizations #5','Y','N',40,49),
('xDrugCourt','WEBERCO FDC OGDEN-DECARIA','New Directions-Customizations #5','Y','N',41,50),
('xDrugCourt','WEBER CO FDDC OGDEN-FROST','New Directions-Customizations #5','Y','N',42,51),
('xDrugCourt','WEBERCO FDDC OGDEN-HEWARD','New Directions-Customizations #5','Y','N',43,52),
('xDrugCourt','WEBER MSDMNR RVDL-RENSTR','New Directions-Customizations #5','Y','N',44,53),
('xDrugCourt','WEBER JUV OGDEN-DILLON','New Directions-Customizations #5','Y','N',45,54),
('xDrugCourt','WEBER JUV OGDEN-NOLAND','New Directions-Customizations #5','Y','N',46,55),
('xDrugCourt','SUMMIT COUNTY-SHAUGHNESSY','New Directions-Customizations #5','Y','N',47,56)



-- DORA Status --


IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xDORAStatus' AND Category = 'xDORAStatus')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xDORAStatus','xDORAStatus','Y','Y','Y','Y','New Directions-Customizations #5','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xDORAStatus' ,CategoryName = 'xDORAStatus',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions-Customizations #5',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xDORAStatus' AND Category = 'xDORAStatus'
END

DELETE FROM GlobalCodes WHERE Category = 'xDORAStatus'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,Code)
VALUES 
('xDORAStatus','No DORA','New Directions-Customizations #5','Y','N',1,2),
('xDORAStatus','DORA','New Directions-Customizations #5','Y','N',2,3)


--Living Arrangement --


IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE (CategoryName = 'LIVINGARRANGEMENT' OR CategoryName = 'Living Arrangement') AND Category = 'LIVINGARRANGEMENT' )
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('LIVINGARRANGEMENT','LIVINGARRANGEMENT','Y','Y','Y','Y','New Directions-Customizations #5','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'LIVINGARRANGEMENT' ,CategoryName = 'LIVINGARRANGEMENT',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions-Customizations #5',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE (CategoryName = 'LIVINGARRANGEMENT' OR  CategoryName = 'Living Arrangement') AND Category = 'LIVINGARRANGEMENT'
END

DELETE FROM GlobalCodes WHERE Category = 'LIVINGARRANGEMENT'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,Code)
VALUES 
('LIVINGARRANGEMENT','On the street or in a homeless shelter','New Directions-Customizations #5','Y','N',1,1),
('LIVINGARRANGEMENT','Private residence - Independent','New Directions-Customizations #5','Y','N',2,2),
('LIVINGARRANGEMENT','Private residence - Dependent','New Directions-Customizations #5','Y','N',3,3),
('LIVINGARRANGEMENT','Jail or correctional facility','New Directions-Customizations #5','Y','N',4,4),
('LIVINGARRANGEMENT','Institutional setting','New Directions-Customizations #5','Y','N',5,5),
('LIVINGARRANGEMENT','24-hour residential care','New Directions-Customizations #5','Y','N',6,6),
('LIVINGARRANGEMENT','Adult or child','New Directions-Customizations #5','Y','N',7,7)


-- Marital Status --


IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'Marital Status' AND Category = 'MARITALSTATUS')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('MARITALSTATUS','Marital Status','Y','Y','Y','Y','New Directions-Customizations #5','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'MARITALSTATUS' ,CategoryName = 'Marital Status',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions-Customizations #5',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'Marital Status' AND Category = 'MARITALSTATUS'
END

DELETE FROM GlobalCodes WHERE Category = 'MARITALSTATUS'


INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,Code)
VALUES 
('MARITALSTATUS','Never Married','New Directions-Customizations #5','Y','N',1,1),
('MARITALSTATUS','Married','New Directions-Customizations #5','Y','N',2,2),
('MARITALSTATUS','Separated','New Directions-Customizations #5','Y','N',3,3),
('MARITALSTATUS','Divorced ','New Directions-Customizations #5','Y','N',4,4),
('MARITALSTATUS','Widowed ','New Directions-Customizations #5','Y','N',5,5),
('MARITALSTATUS','Unknown','New Directions-Customizations #5','Y','N',6,7)



-- Enrolled in Education --


IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xeducationlevel' AND Category = 'xeducationlevel')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xeducationlevel','xeducationlevel','Y','Y','Y','Y','New Directions-Customizations #5','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xeducationlevel' ,CategoryName = 'xeducationlevel',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions-Customizations #5',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xeducationlevel' AND Category = 'xeducationlevel'
END

DELETE FROM GlobalCodes WHERE Category = 'xeducationlevel'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,Code)
VALUES 
('xeducationlevel','Less than one grade completed','New Directions-Customizations #5','Y','N',1,'0'),
('xeducationlevel','Unknown','New Directions-Customizations #5','Y','N',2,'97'),
('xeducationlevel','Preschool/Nursery/Headstart','New Directions-Customizations #5','Y','N',3,'P'),
('xeducationlevel','Kindergarten','New Directions-Customizations #5','Y','N',4,'K'),
('xeducationlevel','1st Grade','New Directions-Customizations #5','Y','N',5,'01'),
('xeducationlevel','2nd Grade','New Directions-Customizations #5','Y','N',6,'02'),


('xeducationlevel','3rd Grade','New Directions-Customizations #5','Y','N',7,'03'),
('xeducationlevel','4th Grade','New Directions-Customizations #5','Y','N',8,'04'),
('xeducationlevel','5th Grade','New Directions-Customizations #5','Y','N',9,'05'),
('xeducationlevel','6th Grade','New Directions-Customizations #5','Y','N',10,'06'),
('xeducationlevel','7th Grade','New Directions-Customizations #5','Y','N',11,'07'),
('xeducationlevel','8th Grade','New Directions-Customizations #5','Y','N',12,'08'),


('xeducationlevel','9th Grade','New Directions-Customizations #5','Y','N',13,'09'),
('xeducationlevel','10th Grade','New Directions-Customizations #5','Y','N',14,'10'),
('xeducationlevel','11th Grade','New Directions-Customizations #5','Y','N',15,'11'),
('xeducationlevel','12th Grade','New Directions-Customizations #5','Y','N',16,'12'),
('xeducationlevel','High school graduate','New Directions-Customizations #5','Y','N',17,'A'),
('xeducationlevel','Post high school program','New Directions-Customizations #5','Y','N',18,'B'),



('xeducationlevel','College Graduate','New Directions-Customizations #5','Y','N',19,'C'),
('xeducationlevel','Some Graduate School','New Directions-Customizations #5','Y','N',20,'D'),
('xeducationlevel','Graduate School Graduate','New Directions-Customizations #5','Y','N',21,'E'),
('xeducationlevel','Never Attended School','New Directions-Customizations #5','Y','N',22,'N'),
('xeducationlevel','Special Education','New Directions-Customizations #5','Y','N',23,'S'),
('xeducationlevel','Vocational School','New Directions-Customizations #5','Y','N',24,'V')




--Tobacco Use   --
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xtobaccouse' AND Category = 'xtobaccouse')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xtobaccouse','xtobaccouse','Y','Y','Y','Y','New Directions-Customizations #5','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xtobaccouse' ,CategoryName = 'xtobaccouse',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions-Customizations #5',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xtobaccouse' AND Category = 'xtobaccouse'
END

DELETE FROM GlobalCodes WHERE Category = 'xtobaccouse'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,Code)
VALUES 
('xtobaccouse','Never Smoked','New Directions-Customizations #5','Y','N',1,1),
('xtobaccouse','Former Smoker','New Directions-Customizations #5','Y','N',2,2),
('xtobaccouse','Current Some Day Smoker','New Directions-Customizations #5','Y','N',3,3),
('xtobaccouse','Current Every day Smoker','New Directions-Customizations #5','Y','N',4,4),
('xtobaccouse','Use Smokeless tobacco Only (In last 30 days)','New Directions-Customizations #5','Y','N',5,6),
('xtobaccouse','Current Status Unknown','New Directions-Customizations #5','Y','N',6,97),
('xtobaccouse','Not Applicable','New Directions-Customizations #5','Y','N',7,98),
('xtobaccouse','Former Smoking Status Unknown','New Directions-Customizations #5','Y','N',8,99)


--Preferred Usage --


IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xPreferredUsage' AND Category = 'xPreferredUsage')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xPreferredUsage','xPreferredUsage','Y','Y','Y','Y','New Directions-Customizations #5','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xPreferredUsage' ,CategoryName = 'xPreferredUsage',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions-Customizations #5',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xPreferredUsage' AND Category = 'xPreferredUsage'
END

DELETE FROM GlobalCodes WHERE Category = 'xPreferredUsage'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('xPreferredUsage','Primary','New Directions-Customizations #5','Y','N',1),
('xPreferredUsage','Secondary','New Directions-Customizations #5','Y','N',2),
('xPreferredUsage','Tertiary  ','New Directions-Customizations #5','Y','N',3)


--Drug Name  --

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xSUdrugname' AND Category = 'xSUdrugname')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xSUdrugname','xSUdrugname','Y','Y','Y','Y','New Directions-Customizations #5','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xSUdrugname' ,CategoryName = 'xSUdrugname',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions-Customizations #5',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xSUdrugname' AND Category = 'xSUdrugname'
END

DELETE FROM GlobalCodes WHERE Category = 'xSUdrugname'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,Code)
VALUES 
('xSUdrugname','None','New Directions-Customizations #5','Y','N',1,1),
('xSUdrugname','Alcohol','New Directions-Customizations #5','Y','N',2,2),
('xSUdrugname','Cocaine/Crack','New Directions-Customizations #5','Y','N',3,3),
('xSUdrugname','Marijuana/Hashish','New Directions-Customizations #5','Y','N',4,4),
('xSUdrugname','Heroin','New Directions-Customizations #5','Y','N',5,5),
('xSUdrugname','Non-Prescription Methadone','New Directions-Customizations #5','Y','N',6,6),
('xSUdrugname','Other Opiates/Synthetics','New Directions-Customizations #5','Y','N',7,7),
('xSUdrugname','PCP','New Directions-Customizations #5','Y','N',8,8),


('xSUdrugname','Other Hallucinogens','New Directions-Customizations #5','Y','N',9,9),
('xSUdrugname','Methamphetamine','New Directions-Customizations #5','Y','N',10,10),
('xSUdrugname','Other Amphetamines','New Directions-Customizations #5','Y','N',11,11),
('xSUdrugname','Other Stimulants','New Directions-Customizations #5','Y','N',12,12),
('xSUdrugname','Other Benzodiazepines','New Directions-Customizations #5','Y','N',13,13),
('xSUdrugname','Other Tranquilizers','New Directions-Customizations #5','Y','N',14,14),
('xSUdrugname','Barbiturates','New Directions-Customizations #5','Y','N',15,15),
('xSUdrugname','Other Sedatives/Hypnotic','New Directions-Customizations #5','Y','N',16,16),



('xSUdrugname','Inhalants','New Directions-Customizations #5','Y','N',17,17),
('xSUdrugname','Over the Counter','New Directions-Customizations #5','Y','N',18,18),
('xSUdrugname','Oxycodone (Oxytocin, Percocet)','New Directions-Customizations #5','Y','N',19,30),
('xSUdrugname','LSD','New Directions-Customizations #5','Y','N',20,31),
('xSUdrugname','Methylphenidate (Ritalin)','New Directions-Customizations #5','Y','N',21,32),
('xSUdrugname','Alprazolam (Xanax)','New Directions-Customizations #5','Y','N',22,33),
('xSUdrugname','Diazepam (Valium)','New Directions-Customizations #5','Y','N',23,34),
('xSUdrugname','Lorazepam (Ativan)','New Directions-Customizations #5','Y','N',24,35),


('xSUdrugname','Hydrocodone (Vicodin, Lortab)','New Directions-Customizations #5','Y','N',25,36),
('xSUdrugname','Morphine (ms contin)','New Directions-Customizations #5','Y','N',26,37),
('xSUdrugname','MDMA (Ecstasy)','New Directions-Customizations #5','Y','N',27,38),
('xSUdrugname','Rohypnol','New Directions-Customizations #5','Y','N',28,39),
('xSUdrugname','GHB/GBL','New Directions-Customizations #5','Y','N',29,40),
('xSUdrugname','Ketamine (Special K)','New Directions-Customizations #5','Y','N',30,41),
('xSUdrugname','Clonazepam (Klonopin, Rivotril)','New Directions-Customizations #5','Y','N',31,42),
('xSUdrugname','Other','New Directions-Customizations #5','Y','N',32,20),
('xSUdrugname','Unknown','New Directions-Customizations #5','Y','N',33,97)



--Frequency    --

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xSUDrugFrequency' AND Category = 'xSUDrugFrequency')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xSUDrugFrequency','xSUDrugFrequency','Y','Y','Y','Y','New Directions-Customizations #5','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xSUDrugFrequency' ,CategoryName = 'xSUDrugFrequency',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions-Customizations #5',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xSUDrugFrequency' AND Category = 'xSUDrugFrequency'
END

DELETE FROM GlobalCodes WHERE Category = 'xSUDrugFrequency'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,Code)
VALUES 
('xSUDrugFrequency','No Use During Last 30 days','New Directions-Customizations #5','Y','N',1,1),
('xSUDrugFrequency','1-3 Times During Last 30 Days','New Directions-Customizations #5','Y','N',2,2),
('xSUDrugFrequency','1-2 Times Per Week','New Directions-Customizations #5','Y','N',3,3),
('xSUDrugFrequency','3-6 Times Per Week','New Directions-Customizations #5','Y','N',4,4),
('xSUDrugFrequency','Daily Use During Last 30 Days','New Directions-Customizations #5','Y','N',5,5),
('xSUDrugFrequency','Unknown','New Directions-Customizations #5','Y','N',6,7),
('xSUDrugFrequency','Not Applicable','New Directions-Customizations #5','Y','N',7,8)


--Route  --  



IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xRoute' AND Category = 'xRoute')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xRoute','xRoute','Y','Y','Y','Y','New Directions-Customizations #5','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xRoute' ,CategoryName = 'xRoute',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions-Customizations #5',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xRoute' AND Category = 'xRoute'
END

DELETE FROM GlobalCodes WHERE Category = 'xRoute'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,Code)
VALUES 
('xRoute','Other','New Directions-Customizations #5','Y','N',1,0),
('xRoute','Oral (Swallowed)','New Directions-Customizations #5','Y','N',2,1),
('xRoute','Smoking','New Directions-Customizations #5','Y','N',3,2),
('xRoute','Inhalation (Fumes)','New Directions-Customizations #5','Y','N',4,3),
('xRoute','Iv Injection','New Directions-Customizations #5','Y','N',5,4),
('xRoute','Non-Iv Injection','New Directions-Customizations #5','Y','N',6,5),
('xRoute','Nasal (Snorted, Sniffed)','New Directions-Customizations #5','Y','N',7,6),
('xRoute','Unknown','New Directions-Customizations #5','Y','N',8,7),
('xRoute','Not Applicable','New Directions-Customizations #5','Y','N',9,8)


--RACE --

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'RACE' AND Category = 'RACE')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('RACE','RACE','Y','Y','Y','Y','New Directions-Customizations #5','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'RACE' ,CategoryName = 'RACE',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions-Customizations #5',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'RACE' AND Category = 'RACE'
END

DELETE FROM GlobalCodes WHERE Category = 'RACE'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,Code)
VALUES 
('RACE','Alaskan Native number','New Directions-Customizations #5','Y','N',1,1),
('RACE','American Indian and Alaska Native','New Directions-Customizations #5','Y','N',2,2),
('RACE','Asian','New Directions-Customizations #5','Y','N',3,3),
('RACE','Native Hawaiian or Other Pacific Islander','New Directions-Customizations #5','Y','N',4,4),
('RACE','Black/African American','New Directions-Customizations #5','Y','N',5,5),
('RACE','White','New Directions-Customizations #5','Y','N',6,6),
('RACE','Unknown','New Directions-Customizations #5','Y','N',7,7),
('RACE','Two or more races','New Directions-Customizations #5','Y','N',8,8),
('RACE','Other single race','New Directions-Customizations #5','Y','N',9,0)

-- Primary Source of Income--

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XINQUIRYPSOURCE' AND Category = 'XINQUIRYPSOURCE')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XINQUIRYPSOURCE','XINQUIRYPSOURCE','Y','Y','Y','Y','New Directions-Customizations #5','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XINQUIRYPSOURCE' ,CategoryName = 'XINQUIRYPSOURCE',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions-Customizations #5',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XINQUIRYPSOURCE' AND Category = 'XINQUIRYPSOURCE'
END

DELETE FROM GlobalCodes WHERE Category = 'XINQUIRYPSOURCE'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,Code)
VALUES 
('XINQUIRYPSOURCE','Legal Employment','New Directions-Customizations #5','Y','N',1,1),
('XINQUIRYPSOURCE','Welfare, Public Assistance','New Directions-Customizations #5','Y','N',2,2),
('XINQUIRYPSOURCE','Pension, Retirement Benefits, Social Security','New Directions-Customizations #5','Y','N',3,3),
('XINQUIRYPSOURCE','Disability, Workers Compensation','New Directions-Customizations #5','Y','N',4,4),
('XINQUIRYPSOURCE','Other','New Directions-Customizations #5','Y','N',5,5),
('XINQUIRYPSOURCE','None','New Directions-Customizations #5','Y','N',6,6),
('XINQUIRYPSOURCE','Unknown','New Directions-Customizations #5','Y','N',7,7)


-- Employment Status   --

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'Employment Status' AND Category = 'EMPLOYMENTSTATUS')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('EMPLOYMENTSTATUS','Employment Status','Y','Y','Y','Y','New Directions-Customizations #5','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'EMPLOYMENTSTATUS' ,CategoryName = 'Employment Status',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions-Customizations #5',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'Employment Status' AND Category = 'EMPLOYMENTSTATUS'
END

DELETE FROM GlobalCodes WHERE Category = 'EMPLOYMENTSTATUS'


INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,Code)
VALUES 
('EMPLOYMENTSTATUS','Employed Full Time','New Directions-Customizations #5','Y','N',1,'1'),
('EMPLOYMENTSTATUS','Employed Part time','New Directions-Customizations #5','Y','N',2,'2'),
('EMPLOYMENTSTATUS','Unemployed Seeking Work','New Directions-Customizations #5','Y','N',3,'NA'),
('EMPLOYMENTSTATUS','Unemployed Not Seeking Work','New Directions-Customizations #5','Y','N',4,'3'),
('EMPLOYMENTSTATUS','Supported/Transitional Employment ','New Directions-Customizations #5','Y','N',5,'NA'),
('EMPLOYMENTSTATUS','Homemaker','New Directions-Customizations #5','Y','N',6,'4'),
('EMPLOYMENTSTATUS','Student','New Directions-Customizations #5','Y','N',7,'5'),

('EMPLOYMENTSTATUS','Retired','New Directions-Customizations #5','Y','N',8,'6'),
('EMPLOYMENTSTATUS','Disabled not in workforce','New Directions-Customizations #5','Y','N',9,'7'),
('EMPLOYMENTSTATUS','Ages 0-5','New Directions-Customizations #5','Y','N',10,'10'),
('EMPLOYMENTSTATUS','Other not in labor force','New Directions-Customizations #5','Y','N',11,'20'),
('EMPLOYMENTSTATUS','Unknown','New Directions-Customizations #5','Y','N',12,'97')



--Ethnicity  This is a custom update script -- 


UPDATE GlobalCodes set Code  = '4',SortOrder=4,CodeName = 'Other Hispanic' where Category = 'HISPANICORIGIN'and GlobalCodeId = 4301
UPDATE GlobalCodes set Code  = '5',SortOrder=5,CodeName = 'Not of Hispanic Origin' where Category = 'HISPANICORIGIN' and GlobalCodeId = 4302
UPDATE GlobalCodes set Code  = '7',SortOrder=6,CodeName = 'Unknown' where Category = 'HISPANICORIGIN' and GlobalCodeId = 4303


IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'Hispanic Origin' AND Category = 'HISPANICORIGIN')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('HISPANICORIGIN','Hispanic Origin','Y','Y','Y','Y','New Directions-Customizations #5','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'HISPANICORIGIN' ,CategoryName = 'Hispanic Origin',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions-Customizations #5',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'Hispanic Origin' AND Category = 'HISPANICORIGIN'
END

DELETE FROM GlobalCodes WHERE Category = 'HISPANICORIGIN' and GlobalCodeId > 10000

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,Code)
VALUES 
('HISPANICORIGIN','Puerto Rican','New Directions-Customizations #5','Y','N',1,'1'),
('HISPANICORIGIN','Mexican','New Directions-Customizations #5','Y','N',2,'2'),
('HISPANICORIGIN','Cuban','New Directions-Customizations #5','Y','N',3,'3')


--Gender--
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xGender' AND Category = 'xGender')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xGender','xGender','Y','Y','Y','Y','New Directions-Customizations #5','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xGender' ,CategoryName = 'xGender',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'New Directions-Customizations #5',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xGender' AND Category = 'xGender'
END

DELETE FROM GlobalCodes WHERE Category = 'xGender'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder,Code)
VALUES 
('xGender','Male','New Directions-Customizations #5','Y','N',1,'M'),
('xGender','Female','New Directions-Customizations #5','Y','N',2,'F'),
('xGender','Other','New Directions-Customizations #5','Y','N',3,'O')




      

