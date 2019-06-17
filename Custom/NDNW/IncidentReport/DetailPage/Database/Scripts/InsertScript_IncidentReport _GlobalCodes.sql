--Location of incident-->XLOCATIONINCIDNET
IF NOT EXISTS (SELECT 1  FROM GlobalCodeCategories  WHERE Category = 'XLOCATIONINCIDNET' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
 INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes)
   VALUES ('XLOCATIONINCIDNET','XLOCATIONINCIDNET','Y','Y','Y','Y',NULL,'N','N')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XLOCATIONINCIDNET' ,CategoryName = 'XLOCATIONINCIDNET',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = Null,UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XLOCATIONINCIDNET' AND Category = 'XLOCATIONINCIDNET'
END
DELETE FROM GlobalCodes WHERE Category = 'XLOCATIONINCIDNET'

 INSERT INTO GlobalCodes (Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color) VALUES
('XLOCATIONINCIDNET','Community','COMMUNITY',NULL,'Y','Y',1,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XLOCATIONINCIDNET','Residence','RESIDENCE',NULL,'Y','Y',2,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XLOCATIONINCIDNET','Day Program','DAYPROGRAM',NULL,'Y','Y',3,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XLOCATIONINCIDNET','Place of employment','PLACEOFEMPLOYMENT',NULL,'Y','Y',4,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XLOCATIONINCIDNET','Other','OTHER',NULL,'Y','Y',5,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XLOCATIONINCIDNET','During Transport','DURINGTRANSPORT',NULL,'Y','Y',6,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XLOCATIONINCIDNET','Campus','CAMPUS',NULL,'Y','Y',7,'1',NULL,NULL,NULL,NULL,NULL,NULL)


--Incident Category-->XINCIDENTCATEGORY
IF NOT EXISTS (SELECT 1  FROM GlobalCodeCategories  WHERE Category = 'XINCIDENTCATEGORY' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
 INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes)
   VALUES ('XINCIDENTCATEGORY','XINCIDENTCATEGORY','Y','Y','Y','Y',NULL,'N','Y')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XINCIDENTCATEGORY' ,CategoryName = 'XINCIDENTCATEGORY',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = Null,UserDefinedCategory = 'N',HasSubcodes = 'Y',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XINCIDENTCATEGORY' AND Category = 'XINCIDENTCATEGORY'
END

IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE Category = 'XINCIDENTCATEGORY' AND Code='INCIDENT' And ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
 INSERT INTO GlobalCodes (Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color) VALUES
('XINCIDENTCATEGORY','Incident','INCIDENT',NULL,'Y','Y',1,'1',NULL,NULL,NULL,NULL,NULL,NULL)
End
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE Category = 'XINCIDENTCATEGORY' AND Code='INCIDENTOTHER' And ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
 INSERT INTO GlobalCodes (Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color) VALUES
('XINCIDENTCATEGORY','Fall & Seizure','INCIDENTOTHER',NULL,'Y','Y',4,'1',NULL,NULL,NULL,NULL,NULL,NULL)
End
else
begin
 update GlobalCodes  set SortOrder = 4,CodeName = 'Fall & Seizure'   WHERE Category = 'XINCIDENTCATEGORY' AND Code='INCIDENTOTHER' 
end
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE Category = 'XINCIDENTCATEGORY' AND Code='INCIDENTFALL' And ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
 INSERT INTO GlobalCodes (Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color) VALUES
('XINCIDENTCATEGORY','Fall','INCIDENTFALL',NULL,'Y','Y',2,'1',NULL,NULL,NULL,NULL,NULL,NULL)
End
else
begin
 update GlobalCodes  set SortOrder = 2,CodeName = 'Fall'   WHERE Category = 'XINCIDENTCATEGORY' AND Code='INCIDENTFALL' 
end

IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE Category = 'XINCIDENTCATEGORY' AND Code='INCIDENTSEIZURE' And ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
 INSERT INTO GlobalCodes (Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color) VALUES
('XINCIDENTCATEGORY','Seizure','INCIDENTSEIZURE',NULL,'Y','Y',3,'1',NULL,NULL,NULL,NULL,NULL,NULL)
end
else
begin
 update GlobalCodes  set SortOrder = 3,CodeName = 'Seizure'   WHERE Category = 'XINCIDENTCATEGORY' AND Code='INCIDENTSEIZURE' 
end

 
--Location details --> XINCIDENTLOCDETAILS
IF NOT EXISTS (SELECT 1  FROM GlobalCodeCategories  WHERE Category = 'XINCIDENTLOCDETAILS' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
 INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes)
   VALUES ('XINCIDENTLOCDETAILS','XINCIDENTLOCDETAILS','Y','Y','Y','Y',NULL,'N','N')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XINCIDENTLOCDETAILS' ,CategoryName = 'XINCIDENTLOCDETAILS',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = Null,UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XINCIDENTLOCDETAILS' AND Category = 'XINCIDENTLOCDETAILS'
END
DELETE FROM GlobalCodes WHERE Category = 'XINCIDENTLOCDETAILS'

 INSERT INTO GlobalCodes (Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color) VALUES
('XINCIDENTLOCDETAILS','Bedroom','BEDROOM',NULL,'Y','Y',1,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTLOCDETAILS','Activity Room/Lounge','ACTIVITYROOMLOUNGE',NULL,'Y','Y',2,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTLOCDETAILS','Outside Building','OUTSIDEBUILDING',NULL,'Y','Y',3,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTLOCDETAILS','Bathroom','BATHROOM',NULL,'Y','Y',4,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTLOCDETAILS','Dining Room','DININGROOM',NULL,'Y','Y',5,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTLOCDETAILS','Hallway','HALLWAY',NULL,'Y','Y',6,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTLOCDETAILS','On/Off Bus','ONOFFBUS',NULL,'Y','Y',7,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTLOCDETAILS','Community','COMMUNITY',NULL,'Y','Y',8,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTLOCDETAILS','Other','OTHER' ,NULL,'Y','Y',9,'1',NULL,NULL,NULL,NULL,NULL,NULL)


--Describe Incident--> XINCIDENTREPORTTYPE
IF NOT EXISTS (SELECT 1  FROM GlobalCodeCategories  WHERE Category = 'XINCIDENTREPORTTYPE' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
 INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes)
   VALUES ('XINCIDENTREPORTTYPE','XINCIDENTREPORTTYPE','Y','Y','Y','Y',NULL,'N','N')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XINCIDENTREPORTTYPE' ,CategoryName = 'XINCIDENTREPORTTYPE',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = Null,UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XINCIDENTREPORTTYPE' AND Category = 'XINCIDENTREPORTTYPE'
END
DELETE FROM GlobalCodes WHERE Category = 'XINCIDENTREPORTTYPE'

 INSERT INTO GlobalCodes (Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color) VALUES
('XINCIDENTREPORTTYPE','Found on the floor','FOUNDONTHEFLOOR',NULL,'Y','Y',1,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTREPORTTYPE','Near fall (client lowered to floor by staff or stabilized)','NEARFALL',NULL,'Y','Y',2,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTREPORTTYPE','Fall to the floor (witnessed)','FALLTOTHEFLOOR',NULL,'Y','Y',3,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTREPORTTYPE','Client reported fall','CLIENTREPORTEDFALL',NULL,'Y','Y',4,'1',NULL,NULL,NULL,NULL,NULL,NULL)


--Cause of Incident-->XINCIDENCAUSEINCDENT
IF NOT EXISTS (SELECT 1  FROM GlobalCodeCategories  WHERE Category = 'XINCIDENCAUSEINCDENT' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
 INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes)
   VALUES ('XINCIDENCAUSEINCDENT','XINCIDENCAUSEINCDENT','Y','Y','Y','Y',NULL,'N','N')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XINCIDENCAUSEINCDENT' ,CategoryName = 'XINCIDENCAUSEINCDENT',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = Null,UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XINCIDENCAUSEINCDENT' AND Category = 'XINCIDENCAUSEINCDENT'
END
DELETE FROM GlobalCodes WHERE Category = 'XINCIDENCAUSEINCDENT'

 INSERT INTO GlobalCodes (Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color) VALUES
 ('XINCIDENCAUSEINCDENT','Lost balance','LOSTBALANCE',NULL,'Y','Y',1,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENCAUSEINCDENT','Slipped ','SLIPPED',NULL,'Y','Y',2,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENCAUSEINCDENT','Lost strength/weakness','LOSTSTRENGTHWEAKNESS',NULL,'Y','Y',3,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENCAUSEINCDENT','Tripped','TRIPPED',NULL,'Y','Y',4,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENCAUSEINCDENT','Lost Consciousness','LOSTCONSCIOUSNESS',NULL,'Y','Y',5,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENCAUSEINCDENT','Seizure','SEIZURE',NULL,'Y','Y',6,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENCAUSEINCDENT','Equipment malfunction ','EQUIPMENTMALFUNCTION',NULL,'Y','Y',7,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENCAUSEINCDENT','Environmental factor ','ENVIRONMENTALFACTOR',NULL,'Y','Y',8,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENCAUSEINCDENT','Other','OTHER',NULL,'Y','Y',9,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENCAUSEINCDENT','Unknown','UNKNOWN',NULL,'Y','Y',10,'1',NULL,NULL,NULL,NULL,NULL,NULL)


--Incident Occurred While--> XINCIDENTOCCURWHILE
 IF NOT EXISTS (SELECT 1  FROM GlobalCodeCategories  WHERE Category = 'XINCIDENTOCCURWHILE' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
 INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes)
   VALUES ('XINCIDENTOCCURWHILE','XINCIDENTOCCURWHILE','Y','Y','Y','Y',NULL,'N','N')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XINCIDENTOCCURWHILE' ,CategoryName = 'XINCIDENTOCCURWHILE',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = Null,UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XINCIDENTOCCURWHILE' AND Category = 'XINCIDENTOCCURWHILE'
END
DELETE FROM GlobalCodes WHERE Category = 'XINCIDENTOCCURWHILE'

 INSERT INTO GlobalCodes (Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color) VALUES
('XINCIDENTOCCURWHILE','Walking to/from client room','WALKINGTOFROMCLIENTROOM',NULL,'Y','Y',1,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTOCCURWHILE','Walking to/from bathroom','WALKINGTOFROMBATHROOM',NULL,'Y','Y',2,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTOCCURWHILE','Transferring on/off toilet','TRANSFERRINGONOFFTOILET',NULL,'Y','Y',3,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTOCCURWHILE','Walking in hallway','WALKINGINHALLWAY',NULL,'Y','Y',4,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTOCCURWHILE','Getting up from wheelchair','GETTINGUPFROMWHEELCHAIR',NULL,'Y','Y',5,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTOCCURWHILE','Sliding out of the wheelchair','SLIDINGOUTOFTHEWHEELCHAIR',NULL,'Y','Y',6,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTOCCURWHILE','Changing clothes/other ADLs','CHANGINGCLOTHESOTHERADLS',NULL,'Y','Y',7,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTOCCURWHILE','Getting in/out of tub or shower','GETTINGINOUTOFTUBORSHOWER',NULL,'Y','Y',8,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTOCCURWHILE','Reaching for something','REACHINGFORSOMETHING',NULL,'Y','Y',9,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTOCCURWHILE','Getting on/off bus','GETTINGONOFFBUS',NULL,'Y','Y',10,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTOCCURWHILE','Getting in/out bed','GETTINGINOUTBED',NULL,'Y','Y',11,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTOCCURWHILE','None of the above','NONEOFTHEABOVE',NULL,'Y','Y',12,'1',NULL,NULL,NULL,NULL,NULL,NULL)


--Footwear at Time of Incident -->XINCIDENTFOOTWEAR
IF NOT EXISTS (SELECT 1  FROM GlobalCodeCategories  WHERE Category = 'XINCIDENTFOOTWEAR' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
 INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes)
   VALUES ('XINCIDENTFOOTWEAR','XINCIDENTFOOTWEAR','Y','Y','Y','Y',NULL,'N','N')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XINCIDENTFOOTWEAR' ,CategoryName = 'XINCIDENTFOOTWEAR',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = Null,UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XINCIDENTFOOTWEAR' AND Category = 'XINCIDENTFOOTWEAR'
END
DELETE FROM GlobalCodes WHERE Category = 'XINCIDENTFOOTWEAR'

 INSERT INTO GlobalCodes (Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color) VALUES
('XINCIDENTFOOTWEAR','Shoes/Sneakers','SHOESSNEAKERS',NULL,'Y','Y',1,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTFOOTWEAR','Flip Flops','FLIPFLOPS',NULL,'Y','Y',2,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTFOOTWEAR','Plain Socks','PLAINSOCKS',NULL,'Y','Y',3,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTFOOTWEAR','High/Narrow Heel','HIGHNARROWHEEL',NULL,'Y','Y',4,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTFOOTWEAR','Bare Feet','BAREFEET',NULL,'Y','Y',5,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTFOOTWEAR','Boots','BOOTS',NULL,'Y','Y',6,'1',NULL,NULL,NULL,NULL,NULL,NULL)


--Yes/No-->XINCIDENTYESNO
IF NOT EXISTS (SELECT 1  FROM GlobalCodeCategories  WHERE Category = 'XINCIDENTYESNO' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
 INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes)
   VALUES ('XINCIDENTYESNO','XINCIDENTYESNO','Y','Y','Y','Y',NULL,'N','N')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XINCIDENTYESNO' ,CategoryName = 'XINCIDENTYESNO',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = Null,UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XINCIDENTYESNO' AND Category = 'XINCIDENTYESNO'
END
DELETE FROM GlobalCodes WHERE Category = 'XINCIDENTYESNO'

 INSERT INTO GlobalCodes (Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color) VALUES
('XINCIDENTYESNO','Yes','YES',NULL,'Y','Y',1,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTYESNO','No','NO',NULL,'Y','Y',2,'1',NULL,NULL,NULL,NULL,NULL,NULL)

--Yes/No-->XINCIDENTYESNONA
IF NOT EXISTS (SELECT 1  FROM GlobalCodeCategories  WHERE Category = 'XINCIDENTYESNONA' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
 INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes)
   VALUES ('XINCIDENTYESNONA','XINCIDENTYESNONA','Y','Y','Y','Y',NULL,'N','N')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XINCIDENTYESNONA' ,CategoryName = 'XINCIDENTYESNONA',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = Null,UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XINCIDENTYESNONA' AND Category = 'XINCIDENTYESNONA'
END
DELETE FROM GlobalCodes WHERE Category = 'XINCIDENTYESNONA'

 INSERT INTO GlobalCodes (Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color) VALUES
('XINCIDENTYESNONA','Yes','YES',NULL,'Y','Y',1,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTYESNONA','No','NO',NULL,'Y','Y',2,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTYESNONA','NA','NA',NULL,'Y','Y',3,'1',NULL,NULL,NULL,NULL,NULL,NULL)

----------------------------Breathing-->XINCIDENTBREATHING--------------------------------------------

--Breathing-->XINCIDENTBREATHING
IF NOT EXISTS (SELECT 1  FROM GlobalCodeCategories  WHERE Category = 'XINCIDENTBREATHING' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
 INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes)
   VALUES ('XINCIDENTBREATHING','XINCIDENTBREATHING','Y','Y','Y','Y',NULL,'N','N')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XINCIDENTBREATHING' ,CategoryName = 'XINCIDENTBREATHING',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = Null,UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XINCIDENTBREATHING' AND Category = 'XINCIDENTBREATHING'
END
DELETE FROM GlobalCodes WHERE Category = 'XINCIDENTBREATHING'

 INSERT INTO GlobalCodes (Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color) VALUES
('XINCIDENTBREATHING','Rapid','RAPID',NULL,'Y','Y',1,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTBREATHING','Slow','SLOW',NULL,'Y','Y',2,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTBREATHING','Labored','LABORED',NULL,'Y','Y',3,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTBREATHING','None','NONE',NULL,'Y','Y',4,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTBREATHING','No Change','NoChange',NULL,'Y','Y',5,'1',NULL,NULL,NULL,NULL,NULL,NULL)


---------------------------Color-->XINCIDENTCOLOR------------------------------------------
IF NOT EXISTS (SELECT 1  FROM GlobalCodeCategories  WHERE Category = 'XINCIDENTCOLOR' AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
 INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes)
   VALUES ('XINCIDENTCOLOR','XINCIDENTCOLOR','Y','Y','Y','Y',NULL,'N','N')
END
ELSE
BEGIN
	UPDATE GlobalCodeCategories SET Category = 'XINCIDENTCOLOR' ,CategoryName = 'XINCIDENTCOLOR',Active = 'Y',AllowAddDelete = 'Y',AllowCodeNameEdit = 'Y',AllowSortOrderEdit = 'Y',[Description] = Null,UserDefinedCategory = 'N',HasSubcodes = 'N',UsedInPracticeManagement = 'Y'	WHERE CategoryName = 'XINCIDENTCOLOR' AND Category = 'XINCIDENTCOLOR'
END
DELETE FROM GlobalCodes WHERE Category = 'XINCIDENTCOLOR'

 INSERT INTO GlobalCodes (Category,CodeName,Code,[Description],Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,BitmapImage,Color) VALUES
('XINCIDENTCOLOR','Pale','PALE',NULL,'Y','Y',1,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTCOLOR','Flush','FLUSH',NULL,'Y','Y',2,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTCOLOR','Cyanotic (Blue)','CYANOTICBLUE',NULL,'Y','Y',3,'1',NULL,NULL,NULL,NULL,NULL,NULL),
('XINCIDENTCOLOR','No Change','NoChange',NULL,'Y','Y',4,'1',NULL,NULL,NULL,NULL,NULL,NULL)


--GlobalSubCodes Entry For Secondary Category

-------------------Incident Category-->Incident –Other------------------------------------
Declare @GlobalcodeId1 int
set @GlobalcodeId1=(Select GlobalCodeId from GlobalCodes Where Category = 'XINCIDENTCATEGORY' AND Code='INCIDENTOTHER')
IF EXISTS (SELECT 1  FROM GlobalSubCodes  WHERE GlobalCodeId =@GlobalcodeId1 AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
 delete FROM GlobalSubCodes  WHERE GlobalCodeId =@GlobalcodeId1
END

Declare @GlobalcodeId5 int
set @GlobalcodeId5=(Select GlobalCodeId from GlobalCodes Where Category = 'XINCIDENTCATEGORY' AND Code='INCIDENT')
IF NOT EXISTS (SELECT 1  FROM GlobalSubCodes  WHERE GlobalCodeId = @GlobalcodeId5 AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
 INSERT INTO GlobalSubCodes (GlobalCodeId,SubCodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder)
   VALUES 
   (@GlobalcodeId5,'Fall','FALL',Null,'Y','N',1),
   (@GlobalcodeId5,'Seizure','SEIZURE',Null,'Y','N',2),
   (@GlobalcodeId5,'Fall & Seizure','FALLSEIZURE',Null,'Y','N',3)
END

--Incident Category-->Incident – Fall
Declare @GlobalcodeId2 int
set @GlobalcodeId2=(Select GlobalCodeId from GlobalCodes Where Category = 'XINCIDENTCATEGORY' AND Code='INCIDENTFALL')
IF EXISTS (SELECT 1  FROM GlobalSubCodes  WHERE GlobalCodeId = @GlobalcodeId2 AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
 delete FROM GlobalSubCodes  WHERE GlobalCodeId = @GlobalcodeId2
END
--Incident Category-->Incident – Fall
Declare @GlobalcodeId3 int
set @GlobalcodeId3=(Select GlobalCodeId from GlobalCodes Where Category = 'XINCIDENTCATEGORY' AND Code='INCIDENTSEIZURE')
IF  EXISTS (SELECT 1  FROM GlobalSubCodes  WHERE GlobalCodeId =@GlobalcodeId3  AND ISNULL(RecordDeleted, 'N') = 'N')
BEGIN
  delete FROM GlobalSubCodes  WHERE GlobalCodeId =@GlobalcodeId3
END



 