IF NOT EXISTS (SELECT * FROM dbo.GlobalCodeCategories WHERE Category = 'VACCINE') 
BEGIN 
	INSERT INTO dbo.GlobalCodeCategories ( Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, Description, UserDefinedCategory, HasSubcodes, UsedInPracticeManagement, UsedInCareManagement) 
	VALUES('VACCINE','Vaccine','Y','Y','Y','Y',NULL,'N','N','Y','N') 
END

IF NOT EXISTS (SELECT * FROM dbo.GlobalCodes WHERE Category = 'VACCINE' and CodeName='Chicken pox (VZV)' ) BEGIN INSERT INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1,ExternalCode2) values('VACCINE','Chicken pox (VZV)','Chicken pox (VZV)',NULL,'Y','Y',1,'21','CVX') END ELSE BEGIN UPDATE GlobalCodes  set Code='Chicken pox (VZV)',Description=NULL,Active='Y',CannotModifyNameOrDelete='Y',SortOrder=1, ExternalCode1='21', ExternalCode2='CVX' Where Category='VACCINE' and CodeName='Chicken pox (VZV)' END 
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodes WHERE Category = 'Vaccine' and CodeName='DTap-IPV (KINRIX)' ) BEGIN INSERT INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1,ExternalCode2) values('Vaccine','DTap-IPV (KINRIX)','KINRIX',NULL,'Y','Y',2,'58160-0812-01','NDC') END ELSE BEGIN UPDATE GlobalCodes  set Code='KINRIX',Description=NULL,Active='Y',CannotModifyNameOrDelete='Y',SortOrder=2, ExternalCode1='58160-0812-01', ExternalCode2='NDC' Where Category='Vaccine' and CodeName='DTap-IPV (KINRIX)' END 
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodes WHERE Category = 'VACCINE' and CodeName='GARDASIL 9' ) BEGIN INSERT INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1,ExternalCode2) values('VACCINE','GARDASIL 9','GARDASIL 9',NULL,'Y','Y',3,'00006-4119-01','NDC') END ELSE BEGIN UPDATE GlobalCodes  set Code='GARDASIL 9',Description=NULL,Active='Y',CannotModifyNameOrDelete='Y',SortOrder=3, ExternalCode1='00006-4119-01', ExternalCode2='NDC' Where Category='VACCINE' and CodeName='GARDASIL 9' END 
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodes WHERE Category = 'VACCINE' and CodeName='H influenza type B (HiB)' ) BEGIN INSERT INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder) values('VACCINE','H influenza type B (HiB)','H influenza type B (HiB)',NULL,'Y','Y',4) END ELSE BEGIN UPDATE GlobalCodes  set Code='H influenza type B (HiB)',Description=NULL,Active='Y',CannotModifyNameOrDelete='Y',SortOrder=4 Where Category='VACCINE' and CodeName='H influenza type B (HiB)' END 
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodes WHERE Category = 'Vaccine' and CodeName='Hep A (VAQTA)' ) BEGIN INSERT INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1,ExternalCode2) values('Vaccine','Hep A (VAQTA)','VAQTA',NULL,'Y','Y',5,'00006-4095-01','NDC') END ELSE BEGIN UPDATE GlobalCodes  set Code='VAQTA',Description=NULL,Active='Y',CannotModifyNameOrDelete='Y',SortOrder=5, ExternalCode1='00006-4095-01', ExternalCode2='NDC' Where Category='Vaccine' and CodeName='Hep A (VAQTA)' END 
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodes WHERE Category = 'Vaccine' and CodeName='Hep B (ENGERIX-B)' ) BEGIN INSERT INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1,ExternalCode2) values('Vaccine','Hep B (ENGERIX-B)','ENGERIX-B',NULL,'Y','Y',6,'58160-0820-01','NDC') END ELSE BEGIN UPDATE GlobalCodes  set Code='ENGERIX-B',Description=NULL,Active='Y',CannotModifyNameOrDelete='Y',SortOrder=6, ExternalCode1='58160-0820-01', ExternalCode2='NDC' Where Category='Vaccine' and CodeName='Hep B (ENGERIX-B)' END 
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodes WHERE Category = 'VACCINE' and CodeName='Hepatitis A (Hep A)' ) BEGIN INSERT INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder) values('VACCINE','Hepatitis A (Hep A)','Hepatitis A (Hep A)',NULL,'Y','Y',7) END ELSE BEGIN UPDATE GlobalCodes  set Code='Hepatitis A (Hep A)',Description=NULL,Active='Y',CannotModifyNameOrDelete='Y',SortOrder=7 Where Category='VACCINE' and CodeName='Hepatitis A (Hep A)' END 
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodes WHERE Category = 'VACCINE' and CodeName='Hepatitis B (Hep B)' ) BEGIN INSERT INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1,ExternalCode2) values('VACCINE','Hepatitis B (Hep B)','Hep B',NULL,'Y','Y',8,'45','CVX') END ELSE BEGIN UPDATE GlobalCodes  set Code='Hep B',Description=NULL,Active='Y',CannotModifyNameOrDelete='Y',SortOrder=8, ExternalCode1='45', ExternalCode2='CVX' Where Category='VACCINE' and CodeName='Hepatitis B (Hep B)' END 
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodes WHERE Category = 'VACCINE' and CodeName='HIBERIX' ) BEGIN INSERT INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1,ExternalCode2) values('VACCINE','HIBERIX','HIBERIX',NULL,'Y','Y',9,'58160-0806-01','NDC') END ELSE BEGIN UPDATE GlobalCodes  set Code='HIBERIX',Description=NULL,Active='Y',CannotModifyNameOrDelete='Y',SortOrder=9, ExternalCode1='58160-0806-01', ExternalCode2='NDC' Where Category='VACCINE' and CodeName='HIBERIX' END 
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodes WHERE Category = 'VACCINE' and CodeName='Influenza (flu)' ) BEGIN INSERT INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1,ExternalCode2) values('VACCINE','Influenza (flu)','influenza',NULL,'Y','Y',10,'88','CVX') END ELSE BEGIN UPDATE GlobalCodes  set Code='influenza',Description=NULL,Active='Y',CannotModifyNameOrDelete='Y',SortOrder=10, ExternalCode1='88', ExternalCode2='CVX' Where Category='VACCINE' and CodeName='Influenza (flu)' END 
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodes WHERE Category = 'VACCINE' and CodeName='Measles, mumps and rubella (MMR)' ) BEGIN INSERT INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1,ExternalCode2) values('VACCINE','Measles, mumps and rubella (MMR)','M-M-R II',NULL,'Y','Y',11,'00006-4681-01','NDC') END ELSE BEGIN UPDATE GlobalCodes  set Code='M-M-R II',Description=NULL,Active='Y',CannotModifyNameOrDelete='Y',SortOrder=11, ExternalCode1='00006-4681-01', ExternalCode2='NDC' Where Category='VACCINE' and CodeName='Measles, mumps and rubella (MMR)' END 
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodes WHERE Category = 'Vaccine' and CodeName='MMRV (ProQuad)' ) BEGIN INSERT INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1,ExternalCode2) values('Vaccine','MMRV (ProQuad)','ProQuad',NULL,'Y','Y',12,'00006-4171-01','NDC') END ELSE BEGIN UPDATE GlobalCodes  set Code='ProQuad',Description=NULL,Active='Y',CannotModifyNameOrDelete='Y',SortOrder=12, ExternalCode1='00006-4171-01', ExternalCode2='NDC' Where Category='Vaccine' and CodeName='MMRV (ProQuad)' END 
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodes WHERE Category = 'VACCINE' and CodeName='Pentacel' ) BEGIN INSERT INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1,ExternalCode2) values('VACCINE','Pentacel','Pentacel',NULL,'Y','Y',13,'49281-0560-05','NDC') END ELSE BEGIN UPDATE GlobalCodes  set Code='Pentacel',Description=NULL,Active='Y',CannotModifyNameOrDelete='Y',SortOrder=13, ExternalCode1='49281-0560-05', ExternalCode2='NDC' Where Category='VACCINE' and CodeName='Pentacel' END 
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodes WHERE Category = 'Vaccine' and CodeName='Pneumococcal' ) BEGIN INSERT INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1,ExternalCode2) values('Vaccine','Pneumococcal','Prevnar 13',NULL,'Y','Y',14,'00005-1971-01','NDC') END ELSE BEGIN UPDATE GlobalCodes  set Code='Prevnar 13',Description=NULL,Active='Y',CannotModifyNameOrDelete='Y',SortOrder=14, ExternalCode1='00005-1971-01', ExternalCode2='NDC' Where Category='Vaccine' and CodeName='Pneumococcal' END 
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodes WHERE Category = 'VACCINE' and CodeName='Pneumococcal conjugate (PCV)' ) BEGIN INSERT INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1,ExternalCode2) values('VACCINE','Pneumococcal conjugate (PCV)','Pneumococcal Conjugate',NULL,'Y','Y',15,'152','CVX') END ELSE BEGIN UPDATE GlobalCodes  set Code='Pneumococcal Conjugate',Description=NULL,Active='Y',CannotModifyNameOrDelete='Y',SortOrder=15, ExternalCode1='152', ExternalCode2='CVX' Where Category='VACCINE' and CodeName='Pneumococcal conjugate (PCV)' END 
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodes WHERE Category = 'VACCINE' and CodeName='Polio (IPV)' ) BEGIN INSERT INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder) values('VACCINE','Polio (IPV)','Polio (IPV)',NULL,'Y','Y',16) END ELSE BEGIN UPDATE GlobalCodes  set Code='Polio (IPV)',Description=NULL,Active='Y',CannotModifyNameOrDelete='Y',SortOrder=16 Where Category='VACCINE' and CodeName='Polio (IPV)' END 
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodes WHERE Category = 'VACCINE' and CodeName='Rotavirus (RV)' ) BEGIN INSERT INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1,ExternalCode2) values('VACCINE','Rotavirus (RV)','RotaTeq',NULL,'Y','Y',17,'00006-4047-20','NDC') END ELSE BEGIN UPDATE GlobalCodes  set Code='RotaTeq',Description=NULL,Active='Y',CannotModifyNameOrDelete='Y',SortOrder=17, ExternalCode1='00006-4047-20', ExternalCode2='NDC' Where Category='VACCINE' and CodeName='Rotavirus (RV)' END 
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodes WHERE Category = 'VACCINE' and CodeName='TENIVAC' ) BEGIN INSERT INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1,ExternalCode2) values('VACCINE','TENIVAC','TENIVAC',NULL,'Y','Y',18,'49281-0215-88','NDC') END ELSE BEGIN UPDATE GlobalCodes  set Code='TENIVAC',Description=NULL,Active='Y',CannotModifyNameOrDelete='Y',SortOrder=18, ExternalCode1='49281-0215-88', ExternalCode2='NDC' Where Category='VACCINE' and CodeName='TENIVAC' END 
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodes WHERE Category = 'Vaccine' and CodeName='Varicella' ) BEGIN INSERT INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1,ExternalCode2) values('Vaccine','Varicella','Varicella',NULL,'Y','Y',19,'21','CVX') END ELSE BEGIN UPDATE GlobalCodes  set Code='Varicella',Description=NULL,Active='Y',CannotModifyNameOrDelete='Y',SortOrder=19, ExternalCode1='21', ExternalCode2='CVX' Where Category='Vaccine' and CodeName='Varicella' END 
IF NOT EXISTS (SELECT * FROM dbo.GlobalCodes WHERE Category = 'VACCINE' and CodeName='Zoster' ) BEGIN INSERT INTO GlobalCodes (Category, CodeName, Code, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1,ExternalCode2) values('VACCINE','Zoster','Zoster',NULL,'Y','Y',20,'121','CVX') END ELSE BEGIN UPDATE GlobalCodes  set Code='Zoster',Description=NULL,Active='Y',CannotModifyNameOrDelete='Y',SortOrder=20, ExternalCode1='121', ExternalCode2='CVX' Where Category='VACCINE' and CodeName='Zoster' END 

------------------------------------------------------------------------------------

DECLARE @GlobalCodeId INT

SELECT @GlobalCodeId = GlobalCodeId FROM dbo.GlobalCodes WHERE Category = 'Vaccine' and CodeName='DTap-IPV (KINRIX)'

IF NOT EXISTS (SELECT * FROM GlobalSubCodes where SubCodeName='Polio VIS' AND GlobalCodeId = @GlobalCodeId) 
BEGIN 
	INSERT INTO GlobalSubCodes (GlobalCodeId, SubCodeName, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1, ExternalSource1, ExternalCode2, ExternalSource2, Bitmap) 
	VALUES(@GlobalCodeId,'Polio VIS',NULL,'Y','Y',1,'253088698300017211160720',NULL,'cdcgs1vis',NULL,NULL)
END 
ELSE 
BEGIN 
Update GlobalSubCodes 
	SET GlobalCodeId= @GlobalCodeId, SubCodeName='Polio VIS', Description=NULL, Active='Y', 
	CannotModifyNameOrDelete='Y', SortOrder=1, ExternalCode1= '253088698300017211160720', 
	ExternalSource1=NULL, ExternalCode2='cdcgs1vis', ExternalSource2=NULL, Bitmap=NULL 
	WHERE SubCodeName='Polio VIS'  AND GlobalCodeId = @GlobalCodeId
END

IF NOT EXISTS (SELECT * FROM GlobalSubCodes where SubCodeName='Diphtheria/Tetanus/Pertussis (DTaP) VIS' AND GlobalCodeId = @GlobalCodeId) 
BEGIN 
	INSERT INTO GlobalSubCodes (GlobalCodeId, SubCodeName, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1, ExternalSource1, ExternalCode2, ExternalSource2, Bitmap) 
	VALUES(@GlobalCodeId,'Diphtheria/Tetanus/Pertussis (DTaP) VIS',NULL,'Y','Y',2,'253088698300003511070517',NULL,'cdcgs1vis',NULL,NULL)
END 
ELSE 
BEGIN 
	Update GlobalSubCodes 
	SET GlobalCodeId= @GlobalCodeId, SubCodeName='Diphtheria/Tetanus/Pertussis (DTaP) VIS', Description=NULL, 
	Active='Y', CannotModifyNameOrDelete='Y', SortOrder=2, ExternalCode1= '253088698300003511070517', 
	ExternalSource1=NULL, ExternalCode2='cdcgs1vis', ExternalSource2=NULL, Bitmap=NULL 
	WHERE SubCodeName='Diphtheria/Tetanus/Pertussis (DTaP) VIS'  AND GlobalCodeId = @GlobalCodeId
END

--------------------------------------------------------------------------------------------------------------

SELECT @GlobalCodeId = GlobalCodeId FROM dbo.GlobalCodes WHERE Category = 'Vaccine' and CodeName='GARDASIL 9'

IF NOT EXISTS (SELECT * FROM GlobalSubCodes where SubCodeName='HPV Vaccine VIS' AND GlobalCodeId = @GlobalCodeId) 
BEGIN 
	INSERT INTO GlobalSubCodes (GlobalCodeId, SubCodeName, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1, ExternalSource1, ExternalCode2, ExternalSource2, Bitmap) 
	VALUES(@GlobalCodeId,'HPV Vaccine VIS','Sub Category of Tetanus/Diphtheria ','Y','Y',1,'253088698300029511161202',NULL,'cdcgs1vis',NULL,NULL)
END 
ELSE 
BEGIN 
	Update GlobalSubCodes 
	SET GlobalCodeId= @GlobalCodeId, SubCodeName='HPV Vaccine VIS', Description='Sub Category of Tetanus/Diphtheria ', 
	Active='Y', CannotModifyNameOrDelete='Y', SortOrder=1, ExternalCode1= '253088698300029511161202', 
	ExternalSource1=NULL, ExternalCode2='cdcgs1vis', ExternalSource2=NULL, Bitmap=NULL 
	WHERE SubCodeName='HPV Vaccine VIS'  AND GlobalCodeId = @GlobalCodeId
END

-------------------------------------------------------------------------------------------------------------

SELECT @GlobalCodeId = GlobalCodeId FROM dbo.GlobalCodes WHERE Category = 'Vaccine' and CodeName='Hep A (VAQTA)'


IF NOT EXISTS (SELECT * FROM GlobalSubCodes where SubCodeName='Hepatitis A VIS' AND GlobalCodeId = @GlobalCodeId) 
BEGIN 
	INSERT INTO GlobalSubCodes (GlobalCodeId, SubCodeName, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1, ExternalSource1, ExternalCode2, ExternalSource2, Bitmap) 
	VALUES(@GlobalCodeId,'Hepatitis A VIS','Hepatitis A VIS ','Y','Y',2,'253088698300004211160720',NULL,'cdcgs1vis',NULL,NULL)
END 
ELSE 
BEGIN 
	Update GlobalSubCodes 
	SET GlobalCodeId= @GlobalCodeId, SubCodeName='Hepatitis A VIS', Description='Hepatitis A VIS ', Active='Y', 
	CannotModifyNameOrDelete='Y', SortOrder=2, ExternalCode1= '253088698300004211160720', ExternalSource1=NULL, 
	ExternalCode2='cdcgs1vis', ExternalSource2=NULL, Bitmap=NULL 
	WHERE SubCodeName='Hepatitis A VIS'  AND GlobalCodeId = @GlobalCodeId
END

-------------------------------------------------------------------------------------------------------------

SELECT @GlobalCodeId = GlobalCodeId FROM dbo.GlobalCodes WHERE Category = 'Vaccine' and CodeName='Hep B (ENGERIX-B)'

IF NOT EXISTS (SELECT * FROM GlobalSubCodes where SubCodeName='Hepatitis B VIS' AND GlobalCodeId = @GlobalCodeId) 
BEGIN 
	INSERT INTO GlobalSubCodes (GlobalCodeId, SubCodeName, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1, ExternalSource1, ExternalCode2, ExternalSource2, Bitmap) 
	VALUES(@GlobalCodeId,'Hepatitis B VIS',NULL,'Y','Y',1,'253088698300005911160720',NULL,'cdcgs1vis',NULL,NULL)
END 
ELSE 
BEGIN 
	Update GlobalSubCodes SET GlobalCodeId= @GlobalCodeId, SubCodeName='Hepatitis B VIS', Description=NULL, 
	Active='Y', CannotModifyNameOrDelete='Y', SortOrder=1, ExternalCode1= '253088698300005911160720', 
	ExternalSource1=NULL, ExternalCode2='cdcgs1vis', ExternalSource2=NULL, Bitmap=NULL 
	WHERE SubCodeName='Hepatitis B VIS'  AND GlobalCodeId = @GlobalCodeId
END

-------------------------------------------------------------------------------------------------------------

SELECT @GlobalCodeId = GlobalCodeId FROM dbo.GlobalCodes WHERE Category = 'Vaccine' and CodeName='HIBERIX'

IF NOT EXISTS (SELECT * FROM GlobalSubCodes where SubCodeName='Multi Pediatric Vaccines VIS' AND GlobalCodeId = @GlobalCodeId) 
BEGIN 
	INSERT INTO GlobalSubCodes (GlobalCodeId, SubCodeName, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1, ExternalSource1, ExternalCode2, ExternalSource2, Bitmap) 
	VALUES(@GlobalCodeId,'Multi Pediatric Vaccines VIS','Sub Category of Tetanus/Diphtheria ','Y','Y',1,'253088698300026411151105',NULL,'cdcgs1vis',NULL,NULL)
END 
ELSE 
BEGIN 
	Update GlobalSubCodes 
	SET GlobalCodeId= @GlobalCodeId, SubCodeName='Multi Pediatric Vaccines VIS', Description='Sub Category of Tetanus/Diphtheria ', 
	Active='Y', CannotModifyNameOrDelete='Y', SortOrder=1, ExternalCode1= '253088698300026411151105', 
	ExternalSource1=NULL, ExternalCode2='cdcgs1vis', ExternalSource2=NULL, Bitmap=NULL 
	WHERE SubCodeName='Multi Pediatric Vaccines VIS'  AND GlobalCodeId = @GlobalCodeId
END

-------------------------------------------------------------------------------------------------------------

SELECT @GlobalCodeId = GlobalCodeId FROM dbo.GlobalCodes WHERE Category = 'Vaccine' and CodeName='Measles, mumps and rubella (MMR)'

IF NOT EXISTS (SELECT * FROM GlobalSubCodes where SubCodeName='Measles/Mumps/Rubella VIS' AND GlobalCodeId = @GlobalCodeId) 
BEGIN 
	INSERT INTO GlobalSubCodes (GlobalCodeId, SubCodeName, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1, ExternalSource1, ExternalCode2, ExternalSource2, Bitmap) 
	VALUES(@GlobalCodeId,'Measles/Mumps/Rubella VIS',NULL,'Y','Y',1,'253088698300012711120420',NULL,'cdcgs1vis',NULL,NULL)
END 
ELSE 
BEGIN 
	Update GlobalSubCodes 
	SET GlobalCodeId= @GlobalCodeId, SubCodeName='Measles/Mumps/Rubella VIS', Description=NULL, Active='Y', 
	CannotModifyNameOrDelete='Y', SortOrder=1, ExternalCode1= '253088698300012711120420', ExternalSource1=NULL, 
	ExternalCode2='cdcgs1vis', ExternalSource2=NULL, Bitmap=NULL 
	WHERE SubCodeName='Measles/Mumps/Rubella VIS'  AND GlobalCodeId = @GlobalCodeId
END

-------------------------------------------------------------------------------------------------------------

SELECT @GlobalCodeId = GlobalCodeId FROM dbo.GlobalCodes WHERE Category = 'Vaccine' and CodeName='MMRV (ProQuad)'

IF NOT EXISTS (SELECT * FROM GlobalSubCodes where SubCodeName='Measles/Mumps/Rubella/Varicella VIS' AND GlobalCodeId = @GlobalCodeId) 
BEGIN 
	INSERT INTO GlobalSubCodes (GlobalCodeId, SubCodeName, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1, ExternalSource1, ExternalCode2, ExternalSource2, Bitmap) 
	VALUES(@GlobalCodeId,'Measles/Mumps/Rubella/Varicella VIS',NULL,'Y','Y',1,'253088698300013411100521',NULL,'cdcgs1vis',NULL,NULL)
END 
ELSE 
BEGIN 
	Update GlobalSubCodes 
	SET GlobalCodeId= @GlobalCodeId, SubCodeName='Measles/Mumps/Rubella/Varicella VIS', Description=NULL, Active='Y', 
	CannotModifyNameOrDelete='Y', SortOrder=1, ExternalCode1= '253088698300013411100521', ExternalSource1=NULL, 
	ExternalCode2='cdcgs1vis', ExternalSource2=NULL, Bitmap=NULL 
	WHERE SubCodeName='Measles/Mumps/Rubella/Varicella VIS'  AND GlobalCodeId = @GlobalCodeId
END

-------------------------------------------------------------------------------------------------------------

SELECT @GlobalCodeId = GlobalCodeId FROM dbo.GlobalCodes WHERE Category = 'Vaccine' and CodeName='Pentacel'

IF NOT EXISTS (SELECT * FROM GlobalSubCodes where SubCodeName='Polio VIS' AND GlobalCodeId = @GlobalCodeId) 
BEGIN 
	INSERT INTO GlobalSubCodes (GlobalCodeId, SubCodeName, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1, ExternalSource1, ExternalCode2, ExternalSource2, Bitmap) 
	VALUES(@GlobalCodeId,'Polio VIS','Sub Category of Pentacel ','Y','Y',1,'253088698300017211160720',NULL,'cdcgs1vis',NULL,NULL)
END 
ELSE 
BEGIN 
	Update GlobalSubCodes 
	SET GlobalCodeId= @GlobalCodeId, SubCodeName='Polio VIS', Description='Sub Category of Pentacel ', Active='Y', 
	CannotModifyNameOrDelete='Y', SortOrder=1, ExternalCode1= '253088698300017211160720', ExternalSource1=NULL, 
	ExternalCode2='cdcgs1vis', ExternalSource2=NULL, Bitmap=NULL 
	WHERE SubCodeName='Polio VIS'  AND GlobalCodeId = @GlobalCodeId
END

IF NOT EXISTS (SELECT * FROM GlobalSubCodes where SubCodeName='Haemophilus Influenzae type b VIS' AND GlobalCodeId = @GlobalCodeId) 
BEGIN 
	INSERT INTO GlobalSubCodes (GlobalCodeId, SubCodeName, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1, ExternalSource1, ExternalCode2, ExternalSource2, Bitmap) 
	VALUES(@GlobalCodeId,'Haemophilus Influenzae type b VIS','Sub Category of Pentacel ','Y','Y',2,'253088698300006611150402',NULL,'cdcgs1vis',NULL,NULL)
END 
ELSE 
BEGIN 
	Update GlobalSubCodes 
	SET GlobalCodeId= @GlobalCodeId, SubCodeName='Haemophilus Influenzae type b VIS', Description='Sub Category of Pentacel ', 
	Active='Y', CannotModifyNameOrDelete='Y', SortOrder=2, ExternalCode1= '253088698300006611150402', ExternalSource1=NULL, 
	ExternalCode2='cdcgs1vis', ExternalSource2=NULL, Bitmap=NULL 
	WHERE SubCodeName='Haemophilus Influenzae type b VIS'  AND GlobalCodeId = @GlobalCodeId
END

IF NOT EXISTS (SELECT * FROM GlobalSubCodes where SubCodeName='Diphtheria/Tetanus/Pertussis (DTaP) VIS' AND GlobalCodeId = @GlobalCodeId) 
BEGIN 
	INSERT INTO GlobalSubCodes (GlobalCodeId, SubCodeName, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1, ExternalSource1, ExternalCode2, ExternalSource2, Bitmap) 
	VALUES(@GlobalCodeId,'Diphtheria/Tetanus/Pertussis (DTaP) VIS','Sub Category of Pentacel ','Y','Y',3,'253088698300003511070517',NULL,'cdcgs1vis',NULL,NULL)
END 
ELSE 
BEGIN 
	Update GlobalSubCodes 
	SET GlobalCodeId= @GlobalCodeId, SubCodeName='Diphtheria/Tetanus/Pertussis (DTaP) VIS', Description='Sub Category of Pentacel ', 
	Active='Y', CannotModifyNameOrDelete='Y', SortOrder=3, ExternalCode1= '253088698300003511070517', ExternalSource1=NULL, 
	ExternalCode2='cdcgs1vis', ExternalSource2=NULL, Bitmap=NULL 
	WHERE SubCodeName='Diphtheria/Tetanus/Pertussis (DTaP) VIS'  AND GlobalCodeId = @GlobalCodeId
END

-------------------------------------------------------------------------------------------------------------

SELECT @GlobalCodeId = GlobalCodeId FROM dbo.GlobalCodes WHERE Category = 'Vaccine' and CodeName='Pneumococcal'

IF NOT EXISTS (SELECT * FROM GlobalSubCodes where SubCodeName='Pneumococcal Conjugate (PCV13) VIS' AND GlobalCodeId = @GlobalCodeId) 
BEGIN 
	INSERT INTO GlobalSubCodes (GlobalCodeId, SubCodeName, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1, ExternalSource1, ExternalCode2, ExternalSource2, Bitmap) 
	VALUES(@GlobalCodeId,'Pneumococcal Conjugate (PCV13) VIS',NULL,'Y','Y',1,'253088698300015811151105',NULL,'cdcgs1vis',NULL,NULL)
END 
ELSE 
BEGIN 
	Update GlobalSubCodes 
	SET GlobalCodeId= @GlobalCodeId, SubCodeName='Pneumococcal Conjugate (PCV13) VIS', Description=NULL, Active='Y', 
	CannotModifyNameOrDelete='Y', SortOrder=1, ExternalCode1= '253088698300015811151105', ExternalSource1=NULL, 
	ExternalCode2='cdcgs1vis', ExternalSource2=NULL, Bitmap=NULL 
	WHERE SubCodeName='Pneumococcal Conjugate (PCV13) VIS'  AND GlobalCodeId = @GlobalCodeId
END

-------------------------------------------------------------------------------------------------------------

SELECT @GlobalCodeId = GlobalCodeId FROM dbo.GlobalCodes WHERE Category = 'Vaccine' and CodeName='Rotavirus (RV)'

IF NOT EXISTS (SELECT * FROM GlobalSubCodes where SubCodeName='Rotavirus VIS' AND GlobalCodeId = @GlobalCodeId) 
BEGIN 
	INSERT INTO GlobalSubCodes (GlobalCodeId, SubCodeName, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1, ExternalSource1, ExternalCode2, ExternalSource2, Bitmap) 
	VALUES(@GlobalCodeId,'Rotavirus VIS',NULL,'Y','Y',1,'253088698300019611150415',NULL,'cdcgs1vis',NULL,NULL)
END 
ELSE 
BEGIN 
	Update GlobalSubCodes 
	SET GlobalCodeId= @GlobalCodeId, SubCodeName='Rotavirus VIS', Description=NULL, Active='Y', CannotModifyNameOrDelete='Y', 
	SortOrder=1, ExternalCode1= '253088698300019611150415', ExternalSource1=NULL, ExternalCode2='cdcgs1vis', 
	ExternalSource2=NULL, Bitmap=NULL 
WHERE SubCodeName='Rotavirus VIS'  AND GlobalCodeId = @GlobalCodeId
END

-------------------------------------------------------------------------------------------------------------

SELECT @GlobalCodeId = GlobalCodeId FROM dbo.GlobalCodes WHERE Category = 'Vaccine' and CodeName='TENIVAC'

IF NOT EXISTS (SELECT * FROM GlobalSubCodes where SubCodeName='Tetanus/Diphtheria (Td) Vaccine VIS' AND GlobalCodeId = @GlobalCodeId) 
BEGIN 
	INSERT INTO GlobalSubCodes (GlobalCodeId, SubCodeName, Description, Active, CannotModifyNameOrDelete, SortOrder,ExternalCode1, ExternalSource1, ExternalCode2, ExternalSource2, Bitmap) 
	VALUES(@GlobalCodeId,'Tetanus/Diphtheria (Td) Vaccine VIS','Sub Category of Tetanus/Diphtheria ','Y','Y',1,'253088698300028811170411',NULL,'cdcgs1vis',NULL,NULL)
END 
ELSE 
BEGIN 
	Update GlobalSubCodes 
	SET GlobalCodeId= @GlobalCodeId, SubCodeName='Tetanus/Diphtheria (Td) Vaccine VIS', Description='Sub Category of Tetanus/Diphtheria ',
	Active='Y', CannotModifyNameOrDelete='Y', SortOrder=1, ExternalCode1= '253088698300028811170411', ExternalSource1=NULL, 
	ExternalCode2='cdcgs1vis', ExternalSource2=NULL, Bitmap=NULL 
	WHERE SubCodeName='Tetanus/Diphtheria (Td) Vaccine VIS'  AND GlobalCodeId = @GlobalCodeId
END

-------------------------------------------------------------------------------------------------------------