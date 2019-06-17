/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions  
-- "Discharge"
-- Purpose: Global Code Entries to Bind Drop Down for for Task #929 - Valley - Customizations.
--  
-- Author:  Anto
-- Date:    17-FEB-2015

*********************************************************************************/
-- Transition/Discharge --
IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xPROGDISCHARGEREASON' AND Category = 'xPROGDISCHARGEREASON')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xPROGDISCHARGEREASON','xPROGDISCHARGEREASON','Y','Y','Y','Y','Valley - Customizations #929','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xPROGDISCHARGEREASON' ,CategoryName = 'xPROGDISCHARGEREASON',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'Valley - Customizations #929',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xPROGDISCHARGEREASON' AND Category = 'xPROGDISCHARGEREASON'
END

DELETE FROM GlobalCodes WHERE Category = 'xPROGDISCHARGEREASON'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('xPROGDISCHARGEREASON','Administrative discharge','Valley - Customizations #929','Y','N',1),
('xPROGDISCHARGEREASON','Client moved out of catchment area','Valley - Customizations #929','Y','N',2),

('xPROGDISCHARGEREASON','Treatment completed','Valley - Customizations #929','Y','N',3),
('xPROGDISCHARGEREASON','Left against professional advice/drop out','Valley - Customizations #929','Y','N',4),

('xPROGDISCHARGEREASON','Terminated by facility','Valley - Customizations #929','Y','N',5),


('xPROGDISCHARGEREASON','Transferred to another program or facility','Valley - Customizations #929','Y','N',7),
('xPROGDISCHARGEREASON','Incarcerated','Valley - Customizations #929','Y','N',8),

('xPROGDISCHARGEREASON','Aged out','Valley - Customizations #929','Y','N',9),
('xPROGDISCHARGEREASON','Death','Valley - Customizations #929','Y','N',10)

-- Referral --

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xReferralOut' AND Category = 'xReferralOut')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xReferralOut','xReferralOut','Y','Y','Y','Y','Valley - Customizations #929','N','Y','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xReferralOut' ,CategoryName = 'xReferralOut',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'Valley - Customizations #929',UserDefinedCategory = 'N',HasSubcodes = 'Y',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xReferralOut' AND Category = 'xReferralOut'
END
DELETE FROM GlobalSubCodes where GlobalCodeId in (select GlobalCodeId from GlobalCodes where Category='xReferralOut')
DELETE FROM GlobalCodes WHERE Category = 'xReferralOut'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('xReferralOut','Acute or sub-acute psychiatric facility','Valley - Customizations #929','Y','N',1),
('xReferralOut','Aging and people with disabilities','Valley - Customizations #929','Y','N',2),
('xReferralOut','Attorney','Valley - Customizations #929','Y','N',3),
('xReferralOut','Child welfare','Valley - Customizations #929','Y','N',4),
('xReferralOut','Community housing','Valley - Customizations #929','Y','N',5),
('xReferralOut','Community public health department','Valley - Customizations #929','Y','N',6),
('xReferralOut','Community-based mental health and/or substance abuse provider within service area','Valley - Customizations #929','Y','N',7),
('xReferralOut','Community-based mental health and/or substance abuse provider outside service area','Valley - Customizations #929','Y','N',8),
('xReferralOut','Coordinate care organization (CCO)','Valley - Customizations #929','Y','N',9),
('xReferralOut','Criminal justice entities','Valley - Customizations #929','Y','N',10),
('xReferralOut','Developmental disabilities','Valley - Customizations #929','Y','N',11),
('xReferralOut','Employer/Employee assistance program (EAP)','Valley - Customizations #929','Y','N',12),
('xReferralOut','Employment services','Valley - Customizations #929','Y','N',13),
('xReferralOut','Fully capitated health plan (FCHP)','Valley - Customizations #929','Y','N',14),
('xReferralOut','Local mental health authority/community mental health program','Valley - Customizations #929','Y','N',15),
('xReferralOut','Mental health organization (MHO)','Valley - Customizations #929','Y','N',16),
('xReferralOut','Oregon health plan (OHP)','Valley - Customizations #929','Y','N',17),
('xReferralOut','Private health professional (Primary care provider, hospital, physician, psychiatrist, etc.)','Valley - Customizations #929','Y','N',18),
('xReferralOut','School','Valley - Customizations #929','Y','N',19),
('xReferralOut','Self-help groups or programs','Valley - Customizations #929','Y','N',21),
('xReferralOut','State psychiatric facility (OSH or BMRC)','Valley - Customizations #929','Y','N',22),
('xReferralOut','TANF/Food stamps','Valley - Customizations #929','Y','N',23),
('xReferralOut','Vocational rehabilitation','Valley - Customizations #929','Y','N',24),
('xReferralOut','Youth/child social services agencies, centers or teams','Valley - Customizations #929','Y','N',25),
('xReferralOut','Other community agencies','Valley - Customizations #929','Y','N',26),
('xReferralOut','Other mental health and/or addiction service providers','Valley - Customizations #929','Y','N',27),
('xReferralOut','Other referral','Valley - Customizations #929','Y','N',28),
('xReferralOut','None','Valley - Customizations #929','Y','N',29)

-- Treatment Completion --

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XTreatmentCompletion' AND Category = 'XTreatmentCompletion')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XTreatmentCompletion','XTreatmentCompletion','Y','Y','Y','Y','Valley - Customizations #929','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XTreatmentCompletion' ,CategoryName = 'XTreatmentCompletion',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'Valley - Customizations #929',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XTreatmentCompletion' AND Category = 'XTreatmentCompletion'
END

DELETE FROM GlobalCodes WHERE Category = 'XTreatmentCompletion'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('XTreatmentCompletion','Completed/substantially completed','Valley - Customizations #929','Y','N',1),
('XTreatmentCompletion','Mostly Completed','Valley - Customizations #929','Y','N',2),
('XTreatmentCompletion','Only partially completed','Valley - Customizations #929','Y','N',3),
('XTreatmentCompletion','Mostly not completed','Valley - Customizations #929','Y','N',4),
('XTreatmentCompletion','Does not apply (Evaluations Only)','Valley - Customizations #929','Y','N',5)



-- Referral at Discharge  --

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'XReferralDischarge ' AND Category = 'XReferralDischarge')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('XReferralDischarge','XReferralDischarge','Y','Y','Y','Y','Valley - Customizations #929','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XReferralDischarge' ,CategoryName = 'XReferralDischarge',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'Valley - Customizations #929',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XReferralDischarge' AND Category = 'XReferralDischarge'
END

DELETE FROM GlobalCodes WHERE Category = 'XReferralDischarge'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('XReferralDischarge','Not yet discharged/discontinued','Valley - Customizations #929','Y','N',1),
('XReferralDischarge','Self (Coded as 14-not referred)','Valley - Customizations #929','Y','N',2),
('XReferralDischarge','Family or Friend (Coded as 14-not referred)','Valley - Customizations #929','Y','N',3),
('XReferralDischarge','Physician, medical facility','Valley - Customizations #929','Y','N',4),
('XReferralDischarge','Social or community agency','Valley - Customizations #929','Y','N',5),
('XReferralDischarge','Educational system','Valley - Customizations #929','Y','N',6),
('XReferralDischarge','Courts, law enforcement, correctional agency','Valley - Customizations #929','Y','N',7),
('XReferralDischarge','Private psychiatric or private mental health program','Valley - Customizations #929','Y','N',8),
('XReferralDischarge','Public psychiatric or public mental health program','Valley - Customizations #929','Y','N',9),
('XReferralDischarge','Clergy','Valley - Customizations #929','Y','N',10),
('XReferralDischarge','Private practice mental health professional','Valley - Customizations #929','Y','N',11),
('XReferralDischarge','Other person or organization','Valley - Customizations #929','Y','N',12),
('XReferralDischarge','Deceased','Valley - Customizations #929','Y','N',13),
('XReferralDischarge','Dropped out of treatment/administrative discharge','Valley - Customizations #929','Y','N',14),
('XReferralDischarge','Not referred (see notes to 1 and 2)','Valley - Customizations #929','Y','N',15),
('XReferralDischarge','Unknown ','Valley - Customizations #929','Y','N',16)

IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE CategoryName = 'xDisSchoolAttend' AND Category = 'xDisSchoolAttend')
BEGIN
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInPracticeManagement)
	VALUES ('xDisSchoolAttend','xDisSchoolAttend','Y','Y','Y','Y','Valley - Customizations #929','N','N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'xDisSchoolAttend' ,CategoryName = 'xDisSchoolAttend',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = 'Valley - Customizations #929',UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'xDisSchoolAttend' AND Category = 'xDisSchoolAttend'
END

DELETE FROM GlobalCodes WHERE Category = 'xDisSchoolAttend'

INSERT INTO GlobalCodes (Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
VALUES 
('xDisSchoolAttend','Attending school regularly: 5 days or less absent','Valley - Customizations #929','Y','N',1),
('xDisSchoolAttend','Home schooled','Valley - Customizations #929','Y','N',2),

('xDisSchoolAttend','Not applicable','Valley - Customizations #929','Y','N',3),
('xDisSchoolAttend','Not attending school regularly: 6 days or more absent','Valley - Customizations #929','Y','N',4),

('xDisSchoolAttend','Not available','Valley - Customizations #929','Y','N',5)