DELETE FROM FormItems WHERE FormSectionId in (SELECT FormSectionId FROM FormSections WHERE FormId = 84)
DELETE FROM FormSectionGroups WHERE FormSectionId in (SELECT FormSectionId FROM FormSections WHERE FormId = 84)
DELETE FROM FormSections WHERE FormId = 84
DELETE FROM Forms WHERE FormId = 84

/*-------Forms Start-------*/
IF NOT EXISTS (SELECT * FROM forms WHERE formid = 84) BEGIN SET IDENTITY_INSERT dbo.forms ON INSERT INTO forms(formid, formname, TableName, TotalNumberOfColumns, Active, RetrieveStoredProcedure) values(84,'Admission Document','CustomDocumentRegistrations',1,'Y','') SET IDENTITY_INSERT dbo.forms OFF END
/*-------Forms End-------*/
/*-------FormSections Start--------*/
IF NOT EXISTS (SELECT * FROM FormSections WHERE FormSectionId = 297) BEGIN SET IDENTITY_INSERT dbo.FormSections ON INSERT INTO dbo.FormSections(FormSectionId, formid, SortOrder, PlaceOnTopOfPage, SectionLabel, Active, SectionEnableCheckBox, SectionEnableCheckBoxText, SectionEnableCheckBoxColumnName, NumberOfColumns) values(297,84,1,NULL,'Case Information','Y','N',NULL,NULL,2) SET IDENTITY_INSERT dbo.FormSections OFF END
--IF NOT EXISTS (SELECT * FROM FormSections WHERE FormSectionId = 298) BEGIN SET IDENTITY_INSERT dbo.FormSections ON INSERT INTO dbo.FormSections(FormSectionId, formid, SortOrder, PlaceOnTopOfPage, SectionLabel, Active, SectionEnableCheckBox, SectionEnableCheckBoxText, SectionEnableCheckBoxColumnName, NumberOfColumns) values(298,84,2,NULL,'Referral Resource','Y','N',NULL,NULL,1) SET IDENTITY_INSERT dbo.FormSections OFF END
/*-------FormSections End--------*/
/*-------FormSectionGroups Start--------*/
IF NOT EXISTS (SELECT * FROM FormSectionGroups WHERE FormSectionGroupId = 763) BEGIN SET IDENTITY_INSERT dbo.FormSectionGroups ON INSERT INTO dbo.FormSectionGroups (FormSectionGroupId, formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName,  NumberOfItemsInRow) VALUES(763,297,1,NULL,'Y',NULL,NULL,NULL,2) SET IDENTITY_INSERT dbo.FormSectionGroups OFF END
IF NOT EXISTS (SELECT * FROM FormSectionGroups WHERE FormSectionGroupId = 764) BEGIN SET IDENTITY_INSERT dbo.FormSectionGroups ON INSERT INTO dbo.FormSectionGroups (FormSectionGroupId, formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName,  NumberOfItemsInRow) VALUES(764,297,2,NULL,'Y',NULL,NULL,NULL,1) SET IDENTITY_INSERT dbo.FormSectionGroups OFF END
--IF NOT EXISTS (SELECT * FROM FormSectionGroups WHERE FormSectionGroupId = 765) BEGIN SET IDENTITY_INSERT dbo.FormSectionGroups ON INSERT INTO dbo.FormSectionGroups (FormSectionGroupId, formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName,  NumberOfItemsInRow) VALUES(765,298,1,NULL,'Y',NULL,NULL,NULL,6) SET IDENTITY_INSERT dbo.FormSectionGroups OFF END
--IF NOT EXISTS (SELECT * FROM FormSectionGroups WHERE FormSectionGroupId = 13500) BEGIN SET IDENTITY_INSERT dbo.FormSectionGroups ON INSERT INTO dbo.FormSectionGroups (FormSectionGroupId, formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName,  NumberOfItemsInRow) VALUES(13500,298,2,NULL,'Y',NULL,NULL,NULL,4) SET IDENTITY_INSERT dbo.FormSectionGroups OFF END
--IF NOT EXISTS (SELECT * FROM FormSectionGroups WHERE FormSectionGroupId = 13501) BEGIN SET IDENTITY_INSERT dbo.FormSectionGroups ON INSERT INTO dbo.FormSectionGroups (FormSectionGroupId, formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName,  NumberOfItemsInRow) VALUES(13501,298,3,NULL,'Y',NULL,NULL,NULL,4) SET IDENTITY_INSERT dbo.FormSectionGroups OFF END
--IF NOT EXISTS (SELECT * FROM FormSectionGroups WHERE FormSectionGroupId = 13502) BEGIN SET IDENTITY_INSERT dbo.FormSectionGroups ON INSERT INTO dbo.FormSectionGroups (FormSectionGroupId, formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName,  NumberOfItemsInRow) VALUES(13502,298,4,NULL,'Y',NULL,NULL,NULL,4) SET IDENTITY_INSERT dbo.FormSectionGroups OFF END
--IF NOT EXISTS (SELECT * FROM FormSectionGroups WHERE FormSectionGroupId = 13503) BEGIN SET IDENTITY_INSERT dbo.FormSectionGroups ON INSERT INTO dbo.FormSectionGroups (FormSectionGroupId, formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName,  NumberOfItemsInRow) VALUES(13503,298,5,NULL,'Y',NULL,NULL,NULL,8) SET IDENTITY_INSERT dbo.FormSectionGroups OFF END
--IF NOT EXISTS (SELECT * FROM FormSectionGroups WHERE FormSectionGroupId = 13504) BEGIN SET IDENTITY_INSERT dbo.FormSectionGroups ON INSERT INTO dbo.FormSectionGroups (FormSectionGroupId, formsectionid, SortOrder, GroupLabel, Active, GroupEnableCheckBox, GroupEnableCheckBoxText, GroupEnableCheckBoxColumnName,  NumberOfItemsInRow) VALUES(13504,298,6,NULL,'Y',NULL,NULL,NULL,1) SET IDENTITY_INSERT dbo.FormSectionGroups OFF END
/*-------FormSectionGroups End--------*/
/*-------FormItems Start--------*/
IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 3296) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(3296,297,763,'5374','Status',1,'Y',NULL,NULL,'N',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END
IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 3297) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(3297,297,763,'5372','',2,'Y','EPISODESTATUS','Disposition','N',NULL,200,NULL,'G',NULL,NULL,NULL,NULL,NULL,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END
IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 3298) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(3298,297,763,'5374','Referral/Screening Date',3,'Y',NULL,NULL,'N',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END
IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 3299) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(3299,297,763,'5367','',4,'Y',NULL,'ReferralScreeningDate','N',NULL,50,10,NULL,NULL,NULL,NULL,NULL,NULL,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END
IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 3300) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(3300,297,763,'5374','Admit Date',5,'Y',NULL,NULL,'N',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END
IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 3301) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(3301,297,763,'5367','',6,'Y',NULL,'RegistrationDate','N',NULL,50,10,NULL,NULL,NULL,NULL,NULL,NULL,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END
IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 3306) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(3306,297,764,'5374','Information',1,'Y',NULL,NULL,'N',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END
IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 3307) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(3307,297,764,'5363','',2,'Y',NULL,'Information','N',NULL,350,NULL,NULL,NULL,NULL,NULL,NULL,100,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END

--IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 10500) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(10500,298,765,'5374','Referral Date&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;',1,'Y',NULL,NULL,'N',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END
--IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 10501) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(10501,298,765,'5367','',2,'Y',NULL,'ReferralDate','N',NULL,50,10,NULL,NULL,NULL,NULL,NULL,NULL,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END
--IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 10502) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(10502,298,765,'5374','&nbsp;Referral Type&nbsp;',3,'Y',NULL,NULL,'N',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END
--IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 10503) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(10503,298,765,'5372','',4,'Y','REFERRALTYPE','ReferralType','N',NULL,200,NULL,'G',NULL,NULL,NULL,NULL,NULL,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END
--IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 10504) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(10504,298,765,'5374','&nbsp;&nbsp;&nbsp;Referral Subtype',5,'Y',NULL,NULL,'N',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END
--IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 10505) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(10505,298,765,'5372','',6,'Y',NULL,'','N',NULL,190,100,NULL,NULL,NULL,NULL,NULL,NULL,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END
--IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 10506) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(10506,298,13500,'5374','Organization Name&nbsp;&nbsp;',1,'Y',NULL,NULL,'N',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END
--IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 10507) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(10507,298,13500,'5361','',2,'Y',NULL,'ReferralOrganization','N',NULL,300,100,NULL,NULL,NULL,NULL,NULL,NULL,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END
--IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 10508) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(10508,298,13500,'5374','<span style=''padding-left:95px''>Phone&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>',3,'Y',NULL,NULL,'N',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END
--IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 10509) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(10509,298,13500,'5361','',4,'Y',NULL,'ReferrralPhone','N',NULL,150,100,NULL,NULL,NULL,NULL,NULL,NULL,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END
--IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 10510) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(10510,298,13501,'5361','First Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;',2,'Y',NULL,'ReferrralFirstName','N',NULL,150,20,NULL,NULL,NULL,NULL,NULL,NULL,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END
--IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 10511) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(10511,298,13501,'5361','<span style=''padding-left:244px''>Last Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>',4,'Y',NULL,'ReferrralLastName','N',NULL,150,30,NULL,NULL,NULL,NULL,NULL,NULL,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END
--IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 10512) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(10512,298,13502,'5374','Address Line1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;',1,'Y',NULL,NULL,'N',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END
--IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 10513) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(10513,298,13502,'5361','',2,'Y',NULL,'ReferrralAddress1','N',NULL,210,100,NULL,NULL,NULL,NULL,NULL,NULL,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END
--IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 10514) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(10514,298,13502,'5374','<span style=''padding-left:185px''>Address Line2&nbsp;&nbsp;&nbsp;&nbsp;</span>',3,'Y',NULL,NULL,'N',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END
--IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 10515) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(10515,298,13502,'5361','',4,'Y',NULL,'ReferrralAddress2','N',NULL,210,100,NULL,NULL,NULL,NULL,NULL,NULL,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END
--IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 10516) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(10516,298,13503,'5374','City&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;',1,'Y',NULL,NULL,'N',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END
--IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 10517) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(10517,298,13503,'5361','',2,'Y',NULL,'ReferrralCity','N',NULL,80,30,NULL,NULL,NULL,NULL,NULL,NULL,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END
--IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 10518) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(10518,298,13503,'5374','<span style=''padding-left:95px''>State&nbsp;&nbsp;&nbsp;&nbsp;</span>',3,'Y',NULL,NULL,'N',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END
--IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 10519) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(10519,298,13503,'5372','',4,'Y',NULL,'ReferrralState','N',NULL,100,NULL,'T','States',NULL,'StateAbbreviation','StateName',NULL,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END
--IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 10520) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(10520,298,13503,'5374','<span style=''padding-left:30px''>ZIP</span>',5,'Y',NULL,NULL,'N',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END
--IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 10521) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(10521,298,13503,'5361','',6,'Y',NULL,'ReferrralZipCode','N',NULL,80,12,NULL,NULL,NULL,NULL,NULL,NULL,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END
--IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 10522) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(10522,298,13503,'5374','Email&nbsp;&nbsp;',7,'Y',NULL,NULL,'N',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END
--IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 10523) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(10523,298,13503,'5361','',8,'Y',NULL,'ReferrralEmail','N',NULL,200,100,NULL,NULL,NULL,NULL,NULL,NULL,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END
--IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 10524) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(10524,298,13504,'5374','Comments',1,'Y',NULL,NULL,'N',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END
--IF NOT EXISTS (SELECT * FROM Formitems WHERE FormItemId = 10525) BEGIN SET IDENTITY_INSERT dbo.Formitems ON INSERT INTO Formitems (FormItemId, formsectionid, FormSectionGroupId, ItemType, ItemLabel, SortOrder, active, GlobalCodeCategory, ItemColumnName, ItemRequiresComment, ItemCommentColumnName, ItemWidth, MaximumLength, DropdownType, SharedTableName, StoredProcedureName, ValueField, TextField, MultilineEditFieldHeight, EachRadioButtonOnNewLine) VALUES(10525,298,13504,'5363','',2,'Y',NULL,'ReferrralComment','N',NULL,750,NULL,NULL,NULL,NULL,NULL,NULL,100,NULL) SET IDENTITY_INSERT dbo.Formitems OFF END

/*-------FormItems End--------*/