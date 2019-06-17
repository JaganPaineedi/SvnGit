SET IDENTITY_INSERT [dbo].[CustomLOCCategories] ON

IF(NOT(EXISTS(SELECT [LOCCategoryId] FROM CustomLOCCategories WHERE [LOCCategoryId] = 1)))
      BEGIN   
		INSERT [dbo].[CustomLOCCategories] ([LOCCategoryId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedBy], [DeletedDate], [LOCCategoryName], [ManualDetermination], [DeterminationDescription]) VALUES 
		(1, N'shcqa', CAST(0x00009F7400CEDC56 AS DateTime), N'shcqa', CAST(0x00009F7400CEDC56 AS DateTime), 'N', NULL, NULL, N'Adult-MI', N'Y', N'[DeterminationDescription] - 1266')
    END
ELSE
    BEGIN
        Update CustomLOCCategories  set ModifiedBy=N'shcqa',[ModifiedDate]= CAST(0x00009F7400CEDC56 AS DateTime),[RecordDeleted]='N',[LOCCategoryName]=N'Adult-MI',[ManualDetermination]=N'Y',[DeterminationDescription]=N'[DeterminationDescription] - 1266' where [LOCCategoryId] = 1
    END
    
IF(NOT(EXISTS(SELECT [LOCCategoryId] FROM CustomLOCCategories WHERE [LOCCategoryId] = 2)))
      BEGIN   
	INSERT [dbo].[CustomLOCCategories] ([LOCCategoryId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedBy], [DeletedDate], [LOCCategoryName], [ManualDetermination], [DeterminationDescription]) VALUES 
	(2, N'shcqa', CAST(0x00009F7400CEDC58 AS DateTime), N'shcqa', CAST(0x00009F7400CEDC58 AS DateTime), 'N', NULL, NULL, N'Adult-DD', N'Y', N'[DeterminationDescription] - 1266')
    END
ELSE
    BEGIN
        Update CustomLOCCategories  set ModifiedBy=N'shcqa',[ModifiedDate]= CAST(0x00009F7400CEDC56 AS DateTime),[RecordDeleted]='N',[LOCCategoryName]=N'Adult-DD',[ManualDetermination]=N'Y',[DeterminationDescription]=N'[DeterminationDescription] - 1266' where [LOCCategoryId] = 2
    END  

IF(NOT(EXISTS(SELECT [LOCCategoryId] FROM CustomLOCCategories WHERE [LOCCategoryId] = 3)))
      BEGIN   
	INSERT [dbo].[CustomLOCCategories] ([LOCCategoryId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedBy], [DeletedDate], [LOCCategoryName], [ManualDetermination], [DeterminationDescription]) VALUES (3, N'shcqa', CAST(0x00009F7400CEDC5B AS DateTime), N'shcqa', CAST(0x00009F7400CEDC5B AS DateTime), 'N', NULL, NULL, N'Child-MI', N'Y', N'[DeterminationDescription] - 1266')
    END
ELSE
    BEGIN
        Update CustomLOCCategories  set ModifiedBy=N'shcqa',[ModifiedDate]= CAST(0x00009F7400CEDC56 AS DateTime),[RecordDeleted]='N',[LOCCategoryName]=N'Child-MI',[ManualDetermination]=N'Y',[DeterminationDescription]=N'[DeterminationDescription] - 1266' where [LOCCategoryId] = 3
    END  

IF(NOT(EXISTS(SELECT [LOCCategoryId] FROM CustomLOCCategories WHERE [LOCCategoryId] = 4)))
      BEGIN   
	INSERT [dbo].[CustomLOCCategories] ([LOCCategoryId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedBy], [DeletedDate], [LOCCategoryName], [ManualDetermination], [DeterminationDescription]) VALUES (4, N'shcqa', CAST(0x00009F7400CEDC5D AS DateTime), N'shcqa', CAST(0x00009F7400CEDC5D AS DateTime), 'N', NULL, NULL, N'Child-DD', N'Y', N'[DeterminationDescription] - 1266')
    END
ELSE
    BEGIN
        Update CustomLOCCategories  set ModifiedBy=N'shcqa',[ModifiedDate]= CAST(0x00009F7400CEDC56 AS DateTime),[RecordDeleted]='N',[LOCCategoryName]=N'Child-DD',[ManualDetermination]=N'Y',[DeterminationDescription]=N'[DeterminationDescription] - 1266' where [LOCCategoryId] = 4
    END      
IF(NOT(EXISTS(SELECT [LOCCategoryId] FROM CustomLOCCategories WHERE [LOCCategoryId] = 5)))
      BEGIN   
	INSERT [dbo].[CustomLOCCategories] ([LOCCategoryId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedBy], [DeletedDate], [LOCCategoryName], [ManualDetermination], [DeterminationDescription]) VALUES (5, N'shcqa', CAST(0x00009F7400CEDC60 AS DateTime), N'shcqa', CAST(0x00009F7400CEDC60 AS DateTime), 'N', NULL, NULL, N'Med Mgt Only', N'Y', NULL)
    END
ELSE
    BEGIN
        Update CustomLOCCategories  set ModifiedBy=N'shcqa',[ModifiedDate]= CAST(0x00009F7400CEDC56 AS DateTime),[RecordDeleted]='N',[LOCCategoryName]=N'Med Mgt Only',[ManualDetermination]=N'Y',[DeterminationDescription]=NULL where [LOCCategoryId] = 5
    END 
IF(NOT(EXISTS(SELECT [LOCCategoryId] FROM CustomLOCCategories WHERE [LOCCategoryId] = 6)))
      BEGIN   
INSERT [dbo].[CustomLOCCategories] ([LOCCategoryId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedBy], [DeletedDate], [LOCCategoryName], [ManualDetermination], [DeterminationDescription]) VALUES (6, N'shcqa', CAST(0x00009F7400CEDC62 AS DateTime), N'shcqa', CAST(0x00009F7400CEDC62 AS DateTime), 'N', NULL, NULL, N'Child Under 7', N'Y', N'[DeterminationDescription] - 1266')
    END
ELSE
    BEGIN
        Update CustomLOCCategories  set ModifiedBy=N'shcqa',[ModifiedDate]= CAST(0x00009F7400CEDC56 AS DateTime),[RecordDeleted]='N',[LOCCategoryName]=N'Child Under 7',[ManualDetermination]=N'Y',[DeterminationDescription]=N'[DeterminationDescription] - 1266' where [LOCCategoryId] = 6
    END
IF(NOT(EXISTS(SELECT [LOCCategoryId] FROM CustomLOCCategories WHERE [LOCCategoryId] = 7)))
      BEGIN   
	INSERT [dbo].[CustomLOCCategories] ([LOCCategoryId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedBy], [DeletedDate], [LOCCategoryName], [ManualDetermination], [DeterminationDescription]) VALUES (7, N'shcqa', CAST(0x00009F7400CEDC65 AS DateTime), N'shcqa', CAST(0x00009F7400CEDC65 AS DateTime), 'N', NULL, NULL, N'SA only', N'Y', NULL)
    END
ELSE
    BEGIN
        Update CustomLOCCategories  set ModifiedBy=N'shcqa',[ModifiedDate]= CAST(0x00009F7400CEDC56 AS DateTime),[RecordDeleted]='N',[LOCCategoryName]=N'SA only',[ManualDetermination]=N'Y',[DeterminationDescription]=NULL where [LOCCategoryId] = 6
    END
GO


SET IDENTITY_INSERT [dbo].[CustomLOCCategories] OFF

SET IDENTITY_INSERT [dbo].[CustomLOCs] ON
IF(NOT(EXISTS(SELECT [LOCId] FROM CustomLOCs WHERE [LOCId] = 1)))
      BEGIN   
	INSERT [dbo].[CustomLOCs] ([LOCId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedBy], [DeletedDate], [LOCCategoryId], [LOCType], [MinDeterminatorScore], [MaxDeterminatorScore], [Description], [ADTCriteria], [ProviderQualifications], [LOCName]) VALUES 
		(1, N'shcqa', CAST(0x00009F7400CEDC67 AS DateTime), N'shcqa', CAST(0x00009F7400CEDC67 AS DateTime), NULL, NULL, NULL, 1, NULL, CAST(0.00 AS Decimal(10, 2)), CAST(30.00 AS Decimal(10, 2)), N'[Description] - 1267', NULL, NULL, N'Adult MH Level 5')
    END
ELSE
    BEGIN
        Update [CustomLOCs]  set ModifiedBy=N'shcqa',[ModifiedDate]= CAST(0x00009F7400CEDC56 AS DateTime),[RecordDeleted]='N',[LOCCategoryId]=1,[MinDeterminatorScore]=CAST(0.00 AS Decimal(10, 2)),[MaxDeterminatorScore]=CAST(30.00 AS Decimal(10, 2)),[Description]= N'[Description] - 1267',[LOCName]= N'Adult MH Level 5' where [LOCId] = 1
END

IF(NOT(EXISTS(SELECT [LOCId] FROM CustomLOCs WHERE [LOCId] = 2)))
      BEGIN   
	INSERT [dbo].[CustomLOCs] ([LOCId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedBy], [DeletedDate], [LOCCategoryId], [LOCType], [MinDeterminatorScore], [MaxDeterminatorScore], [Description], [ADTCriteria], [ProviderQualifications], [LOCName]) VALUES 
	(2, N'shcqa', CAST(0x00009F7400CEDC6A AS DateTime), N'shcqa', CAST(0x00009F7400CEDC6A AS DateTime), NULL, NULL, NULL, 1, NULL, CAST(31.00 AS Decimal(10, 2)), CAST(40.00 AS Decimal(10, 2)), N'[Description] - 1267', NULL, NULL, N'Adult MH Level 4')
    END
ELSE
    BEGIN
        Update [CustomLOCs]  set ModifiedBy=N'shcqa',[ModifiedDate]= CAST(0x00009F7400CEDC56 AS DateTime),[RecordDeleted]='N',[LOCCategoryId]=1,[MinDeterminatorScore]=CAST(31.00 AS Decimal(10, 2)),[MaxDeterminatorScore]=CAST(40.00 AS Decimal(10, 2)),[Description]= N'[Description] - 1267',[LOCName]= N'Adult MH Level 4' where [LOCId] = 2
END
IF(NOT(EXISTS(SELECT [LOCId] FROM CustomLOCs WHERE [LOCId] = 3)))
      BEGIN   
	INSERT [dbo].[CustomLOCs] ([LOCId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedBy], [DeletedDate], [LOCCategoryId], [LOCType], [MinDeterminatorScore], [MaxDeterminatorScore], [Description], [ADTCriteria], [ProviderQualifications], [LOCName]) VALUES 
	(3, N'shcqa', CAST(0x00009F7400CEDC6C AS DateTime), N'shcqa', CAST(0x00009F7400CEDC6C AS DateTime), NULL, NULL, NULL, 1, NULL, CAST(41.00 AS Decimal(10, 2)), CAST(50.00 AS Decimal(10, 2)), N'[Description] - 1267', NULL, NULL, N'Adult MH Level 3')
    END
ELSE
    BEGIN
        Update [CustomLOCs]  set ModifiedBy=N'shcqa',[ModifiedDate]= CAST(0x00009F7400CEDC56 AS DateTime),[RecordDeleted]='N',[LOCCategoryId]=1,[MinDeterminatorScore]=CAST(41.00 AS Decimal(10, 2)),[MaxDeterminatorScore]=CAST(50.00 AS Decimal(10, 2)),[Description]= N'[Description] - 1267',[LOCName]= N'Adult MH Level 3' where [LOCId] = 3
END

IF(NOT(EXISTS(SELECT [LOCId] FROM CustomLOCs WHERE [LOCId] = 4)))
      BEGIN   
	INSERT [dbo].[CustomLOCs] ([LOCId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedBy], [DeletedDate], [LOCCategoryId], [LOCType], [MinDeterminatorScore], [MaxDeterminatorScore], [Description], [ADTCriteria], [ProviderQualifications], [LOCName]) VALUES 
	(4, N'shcqa', CAST(0x00009F7400CEDC6F AS DateTime), N'shcqa', CAST(0x00009F7400CEDC6F AS DateTime), NULL, NULL, NULL, 1, NULL, CAST(51.00 AS Decimal(10, 2)), CAST(60.00 AS Decimal(10, 2)), N'[Description] - 1267', NULL, NULL, N'Adult MH Level 2')
    END
ELSE
    BEGIN
        Update [CustomLOCs]  set ModifiedBy=N'shcqa',[ModifiedDate]= CAST(0x00009F7400CEDC56 AS DateTime),[RecordDeleted]='N',[LOCCategoryId]=1,[MinDeterminatorScore]=CAST(51.00 AS Decimal(10, 2)),[MaxDeterminatorScore]=CAST(60.00 AS Decimal(10, 2)),[Description]= N'[Description] - 1267',[LOCName]= N'Adult MH Level 2' where [LOCId] = 4
END
IF(NOT(EXISTS(SELECT [LOCId] FROM CustomLOCs WHERE [LOCId] = 5)))
      BEGIN   
INSERT [dbo].[CustomLOCs] ([LOCId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedBy], [DeletedDate], [LOCCategoryId], [LOCType], [MinDeterminatorScore], [MaxDeterminatorScore], [Description], [ADTCriteria], [ProviderQualifications], [LOCName]) VALUES
 (5, N'shcqa', CAST(0x00009F7400CEDC71 AS DateTime), N'shcqa', CAST(0x00009F7400CEDC71 AS DateTime), NULL, NULL, NULL, 1, NULL, CAST(61.00 AS Decimal(10, 2)), CAST(100.00 AS Decimal(10, 2)), N'[Description] - 1267', NULL, NULL, N'Adult MH Level 1')
    END
ELSE
    BEGIN
        Update [CustomLOCs]  set ModifiedBy=N'shcqa',[ModifiedDate]= CAST(0x00009F7400CEDC56 AS DateTime),[RecordDeleted]='N',[LOCCategoryId]=1,[MinDeterminatorScore]=CAST(61.00 AS Decimal(10, 2)),[MaxDeterminatorScore]=CAST(100.00 AS Decimal(10, 2)),[Description]= N'[Description] - 1267',[LOCName]= N'Adult MH Level 1' where [LOCId] = 5
END

IF(NOT(EXISTS(SELECT [LOCId] FROM CustomLOCs WHERE [LOCId] = 6)))
      BEGIN   
	INSERT [dbo].[CustomLOCs] ([LOCId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedBy], [DeletedDate], [LOCCategoryId], [LOCType], [MinDeterminatorScore], [MaxDeterminatorScore], [Description], [ADTCriteria], [ProviderQualifications], [LOCName]) VALUES 
	(6, N'shcqa', CAST(0x00009F7400CEDC74 AS DateTime), N'shcqa', CAST(0x00009F7400CEDC74 AS DateTime), NULL, NULL, NULL, 2, NULL, CAST(141.00 AS Decimal(10, 2)), CAST(500.00 AS Decimal(10, 2)), N'[Description] - 1267', NULL, NULL, N'Adult DD Level 5')
    END
ELSE
    BEGIN
        Update [CustomLOCs]  set ModifiedBy=N'shcqa',[ModifiedDate]= CAST(0x00009F7400CEDC56 AS DateTime),[RecordDeleted]='N',[LOCCategoryId]=2,[MinDeterminatorScore]=CAST(141.00 AS Decimal(10, 2)),[MaxDeterminatorScore]=CAST(500.00 AS Decimal(10, 2)),[Description]= N'[Description] - 1267',[LOCName]= N'Adult DD Level 5' where [LOCId] = 6
END
IF(NOT(EXISTS(SELECT [LOCId] FROM CustomLOCs WHERE [LOCId] = 7)))
      BEGIN   
	INSERT [dbo].[CustomLOCs] ([LOCId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedBy], [DeletedDate], [LOCCategoryId], [LOCType], [MinDeterminatorScore], [MaxDeterminatorScore], [Description], [ADTCriteria], [ProviderQualifications], [LOCName]) VALUES 
	(7, N'shcqa', CAST(0x00009F7400CEDC76 AS DateTime), N'shcqa', CAST(0x00009F7400CEDC76 AS DateTime), NULL, NULL, NULL, 2, NULL, CAST(111.00 AS Decimal(10, 2)), CAST(140.00 AS Decimal(10, 2)), N'[Description] - 1267', NULL, NULL, N'Adult DD Level 4')
    END
ELSE
    BEGIN
        Update [CustomLOCs]  set ModifiedBy=N'shcqa',[ModifiedDate]= CAST(0x00009F7400CEDC56 AS DateTime),[RecordDeleted]='N',[LOCCategoryId]=2,[MinDeterminatorScore]=CAST(111.00 AS Decimal(10, 2)),[MaxDeterminatorScore]=CAST(140.00 AS Decimal(10, 2)),[Description]= N'[Description] - 1267',[LOCName]= N'Adult DD Level 4' where [LOCId] = 7
END
IF(NOT(EXISTS(SELECT [LOCId] FROM CustomLOCs WHERE [LOCId] = 8)))
      BEGIN   
	INSERT [dbo].[CustomLOCs] ([LOCId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedBy], [DeletedDate], [LOCCategoryId], [LOCType], [MinDeterminatorScore], [MaxDeterminatorScore], [Description], [ADTCriteria], [ProviderQualifications], [LOCName]) VALUES 
	(8, N'shcqa', CAST(0x00009F7400CEDC79 AS DateTime), N'shcqa', CAST(0x00009F7400CEDC79 AS DateTime), NULL, NULL, NULL, 2, NULL, CAST(81.00 AS Decimal(10, 2)), CAST(110.00 AS Decimal(10, 2)), N'[Description] - 1267', NULL, NULL, N'Adult DD Level 3')
    END
ELSE
    BEGIN
        Update [CustomLOCs]  set ModifiedBy=N'shcqa',[ModifiedDate]= CAST(0x00009F7400CEDC56 AS DateTime),[RecordDeleted]='N',[LOCCategoryId]=2,[MinDeterminatorScore]=CAST(81.00 AS Decimal(10, 2)),[MaxDeterminatorScore]=CAST(110.00 AS Decimal(10, 2)),[Description]= N'[Description] - 1267',[LOCName]= N'Adult DD Level 3' where [LOCId] = 8
END
IF(NOT(EXISTS(SELECT [LOCId] FROM CustomLOCs WHERE [LOCId] = 9)))
      BEGIN   
	INSERT [dbo].[CustomLOCs] ([LOCId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedBy], [DeletedDate], [LOCCategoryId], [LOCType], [MinDeterminatorScore], [MaxDeterminatorScore], [Description], [ADTCriteria], [ProviderQualifications], [LOCName]) VALUES 
	(9, N'shcqa', CAST(0x00009F7400CEDC7B AS DateTime), N'shcqa', CAST(0x00009F7400CEDC7B AS DateTime), NULL, NULL, NULL, 2, NULL, CAST(51.00 AS Decimal(10, 2)), CAST(80.00 AS Decimal(10, 2)), N'[Description] - 1267', NULL, NULL, N'Adult DD Level 2')
    END
ELSE
    BEGIN
        Update [CustomLOCs]  set ModifiedBy=N'shcqa',[ModifiedDate]= CAST(0x00009F7400CEDC56 AS DateTime),[RecordDeleted]='N',[LOCCategoryId]=2,[MinDeterminatorScore]=CAST(51.00 AS Decimal(10, 2)),[MaxDeterminatorScore]=CAST(80.00 AS Decimal(10, 2)),[Description]= N'[Description] - 1267',[LOCName]= N'Adult DD Level 2' where [LOCId] = 9
END
IF(NOT(EXISTS(SELECT [LOCId] FROM CustomLOCs WHERE [LOCId] = 10)))
      BEGIN   
	INSERT [dbo].[CustomLOCs] ([LOCId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedBy], [DeletedDate], [LOCCategoryId], [LOCType], [MinDeterminatorScore], [MaxDeterminatorScore], [Description], [ADTCriteria], [ProviderQualifications], [LOCName]) VALUES 
	(10, N'shcqa', CAST(0x00009F7400CEDC7E AS DateTime), N'shcqa', CAST(0x00009F7400CEDC7E AS DateTime), NULL, NULL, NULL, 2, NULL, CAST(0.00 AS Decimal(10, 2)), CAST(50.00 AS Decimal(10, 2)), N'[Description] - 1267', NULL, NULL, N'Adult DD Level 1')
    END
ELSE
    BEGIN
        Update [CustomLOCs]  set ModifiedBy=N'shcqa',[ModifiedDate]= CAST(0x00009F7400CEDC56 AS DateTime),[RecordDeleted]='N',[LOCCategoryId]=2,[MinDeterminatorScore]=CAST(0.00 AS Decimal(10, 2)),[MaxDeterminatorScore]=CAST(50.00 AS Decimal(10, 2)),[Description]= N'[Description] - 1267',[LOCName]= N'Adult DD Level 1' where [LOCId] = 10
END
IF(NOT(EXISTS(SELECT [LOCId] FROM CustomLOCs WHERE [LOCId] = 11)))
      BEGIN   
	INSERT [dbo].[CustomLOCs] ([LOCId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedBy], [DeletedDate], [LOCCategoryId], [LOCType], [MinDeterminatorScore], [MaxDeterminatorScore], [Description], [ADTCriteria], [ProviderQualifications], [LOCName]) VALUES 
	(11, N'shcqa', CAST(0x00009F7400CEDC80 AS DateTime), N'shcqa', CAST(0x00009F7400CEDC80 AS DateTime), NULL, NULL, NULL, 3, NULL, CAST(141.00 AS Decimal(10, 2)), CAST(500.00 AS Decimal(10, 2)), N'[Description] - 1267', NULL, NULL, N'Child SED Level 4')
    END
ELSE
    BEGIN
        Update [CustomLOCs]  set ModifiedBy=N'shcqa',[ModifiedDate]= CAST(0x00009F7400CEDC56 AS DateTime),[RecordDeleted]='N',[LOCCategoryId]=3,[MinDeterminatorScore]=CAST(141.00 AS Decimal(10, 2)),[MaxDeterminatorScore]=CAST(500.00 AS Decimal(10, 2)),[Description]= N'[Description] - 1267',[LOCName]= N'Child SED Level 4' where [LOCId] = 11
END
IF(NOT(EXISTS(SELECT [LOCId] FROM CustomLOCs WHERE [LOCId] = 12)))
      BEGIN   
	INSERT [dbo].[CustomLOCs] ([LOCId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedBy], [DeletedDate], [LOCCategoryId], [LOCType], [MinDeterminatorScore], [MaxDeterminatorScore], [Description], [ADTCriteria], [ProviderQualifications], [LOCName]) VALUES 
	(12, N'shcqa', CAST(0x00009F7400CEDC83 AS DateTime), N'shcqa', CAST(0x00009F7400CEDC83 AS DateTime), NULL, NULL, NULL, 3, NULL, CAST(101.00 AS Decimal(10, 2)), CAST(140.00 AS Decimal(10, 2)), N'[Description] - 1267', NULL, NULL, N'Child SED Level 3')
    END
ELSE
    BEGIN
        Update [CustomLOCs]  set ModifiedBy=N'shcqa',[ModifiedDate]= CAST(0x00009F7400CEDC56 AS DateTime),[RecordDeleted]='N',[LOCCategoryId]=3,[MinDeterminatorScore]=CAST(101.00 AS Decimal(10, 2)),[MaxDeterminatorScore]=CAST(140.00 AS Decimal(10, 2)),[Description]= N'[Description] - 1267',[LOCName]= N'Child SED Level 3' where [LOCId] = 12
END
IF(NOT(EXISTS(SELECT [LOCId] FROM CustomLOCs WHERE [LOCId] = 13)))
      BEGIN   
	INSERT [dbo].[CustomLOCs] ([LOCId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedBy], [DeletedDate], [LOCCategoryId], [LOCType], [MinDeterminatorScore], [MaxDeterminatorScore], [Description], [ADTCriteria], [ProviderQualifications], [LOCName]) VALUES 
	(13, N'shcqa', CAST(0x00009F7400CEDC85 AS DateTime), N'shcqa', CAST(0x00009F7400CEDC85 AS DateTime), NULL, NULL, NULL, 3, NULL, CAST(61.00 AS Decimal(10, 2)), CAST(100.00 AS Decimal(10, 2)), N'[Description] - 1267', NULL, NULL, N'Child SED Level 2')
    END
ELSE
    BEGIN
        Update [CustomLOCs]  set ModifiedBy=N'shcqa',[ModifiedDate]= CAST(0x00009F7400CEDC56 AS DateTime),[RecordDeleted]='N',[LOCCategoryId]=3,[MinDeterminatorScore]=CAST(61.00 AS Decimal(10, 2)),[MaxDeterminatorScore]=CAST(100.00 AS Decimal(10, 2)),[Description]= N'[Description] - 1267',[LOCName]= N'Child SED Level 2' where [LOCId] = 13
END
IF(NOT(EXISTS(SELECT [LOCId] FROM CustomLOCs WHERE [LOCId] = 14)))
      BEGIN   
	INSERT [dbo].[CustomLOCs] ([LOCId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedBy], [DeletedDate], [LOCCategoryId], [LOCType], [MinDeterminatorScore], [MaxDeterminatorScore], [Description], [ADTCriteria], [ProviderQualifications], [LOCName]) VALUES
	(14, N'shcqa', CAST(0x00009F7400CEDC88 AS DateTime), N'shcqa', CAST(0x00009F7400CEDC88 AS DateTime), NULL, NULL, NULL, 3, NULL, CAST(0.00 AS Decimal(10, 2)), CAST(60.00 AS Decimal(10, 2)), N'[Description] - 1267', NULL, NULL, N'Child SED Level 1')
    END
ELSE
    BEGIN
        Update [CustomLOCs]  set ModifiedBy=N'shcqa',[ModifiedDate]= CAST(0x00009F7400CEDC56 AS DateTime),[RecordDeleted]='N',[LOCCategoryId]=3,[MinDeterminatorScore]=CAST(0.00 AS Decimal(10, 2)),[MaxDeterminatorScore]=CAST(60.00 AS Decimal(10, 2)),[Description]= N'[Description] - 1267',[LOCName]= N'Child SED Level 1' where [LOCId] = 14
END
IF(NOT(EXISTS(SELECT [LOCId] FROM CustomLOCs WHERE [LOCId] = 15)))
      BEGIN   
	INSERT [dbo].[CustomLOCs] ([LOCId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedBy], [DeletedDate], [LOCCategoryId], [LOCType], [MinDeterminatorScore], [MaxDeterminatorScore], [Description], [ADTCriteria], [ProviderQualifications], [LOCName]) VALUES 
	(15, N'shcqa', CAST(0x00009F7400CEDC8A AS DateTime), N'shcqa', CAST(0x00009F7400CEDC8A AS DateTime), NULL, NULL, NULL, 4, NULL, CAST(141.00 AS Decimal(10, 2)), CAST(500.00 AS Decimal(10, 2)), N'[Description] - 1267', NULL, NULL, N'Child DD Level 5')
    END
ELSE
    BEGIN
        Update [CustomLOCs]  set ModifiedBy=N'shcqa',[ModifiedDate]= CAST(0x00009F7400CEDC56 AS DateTime),[RecordDeleted]='N',[LOCCategoryId]=4,[MinDeterminatorScore]=CAST(141.00 AS Decimal(10, 2)),[MaxDeterminatorScore]=CAST(500.00 AS Decimal(10, 2)),[Description]= N'[Description] - 1267',[LOCName]= N'Child DD Level 5' where [LOCId] = 15
END
IF(NOT(EXISTS(SELECT [LOCId] FROM CustomLOCs WHERE [LOCId] = 16)))
      BEGIN   
	INSERT [dbo].[CustomLOCs] ([LOCId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedBy], [DeletedDate], [LOCCategoryId], [LOCType], [MinDeterminatorScore], [MaxDeterminatorScore], [Description], [ADTCriteria], [ProviderQualifications], [LOCName]) VALUES
	(16, N'shcqa', CAST(0x00009F7400CEDC8D AS DateTime), N'shcqa', CAST(0x00009F7400CEDC8D AS DateTime), NULL, NULL, NULL, 4, NULL, CAST(111.00 AS Decimal(10, 2)), CAST(140.00 AS Decimal(10, 2)), N'[Description] - 1267', NULL, NULL, N'Child DD Level 4')
    END
ELSE
    BEGIN
        Update [CustomLOCs]  set ModifiedBy=N'shcqa',[ModifiedDate]= CAST(0x00009F7400CEDC56 AS DateTime),[RecordDeleted]='N',[LOCCategoryId]=4,[MinDeterminatorScore]=CAST(111.00 AS Decimal(10, 2)),[MaxDeterminatorScore]=CAST(140.00 AS Decimal(10, 2)),[Description]= N'[Description] - 1267',[LOCName]= N'Child DD Level 4' where [LOCId] = 16
END
IF(NOT(EXISTS(SELECT [LOCId] FROM CustomLOCs WHERE [LOCId] = 17)))
      BEGIN   
	INSERT [dbo].[CustomLOCs] ([LOCId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedBy], [DeletedDate], [LOCCategoryId], [LOCType], [MinDeterminatorScore], [MaxDeterminatorScore], [Description], [ADTCriteria], [ProviderQualifications], [LOCName]) VALUES 
	(17, N'shcqa', CAST(0x00009F7400CEDC8F AS DateTime), N'shcqa', CAST(0x00009F7400CEDC8F AS DateTime), NULL, NULL, NULL, 4, NULL, CAST(81.00 AS Decimal(10, 2)), CAST(110.00 AS Decimal(10, 2)), N'[Description] - 1267', NULL, NULL, N'Child DD Level 3')
    END
ELSE
    BEGIN
        Update [CustomLOCs]  set ModifiedBy=N'shcqa',[ModifiedDate]= CAST(0x00009F7400CEDC56 AS DateTime),[RecordDeleted]='N',[LOCCategoryId]=4,[MinDeterminatorScore]=CAST(81.00 AS Decimal(10, 2)),[MaxDeterminatorScore]=CAST(110.00 AS Decimal(10, 2)),[Description]= N'[Description] - 1267',[LOCName]= N'Child DD Level 3' where [LOCId] = 17
END
IF(NOT(EXISTS(SELECT [LOCId] FROM CustomLOCs WHERE [LOCId] = 18)))
      BEGIN   
	INSERT [dbo].[CustomLOCs] ([LOCId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedBy], [DeletedDate], [LOCCategoryId], [LOCType], [MinDeterminatorScore], [MaxDeterminatorScore], [Description], [ADTCriteria], [ProviderQualifications], [LOCName]) VALUES 
	(18, N'shcqa', CAST(0x00009F7400CEDC92 AS DateTime), N'shcqa', CAST(0x00009F7400CEDC92 AS DateTime), NULL, NULL, NULL, 4, NULL, CAST(51.00 AS Decimal(10, 2)), CAST(80.00 AS Decimal(10, 2)), N'[Description] - 1267', NULL, NULL, N'Child DD Level 2')
    END
ELSE
    BEGIN
        Update [CustomLOCs]  set ModifiedBy=N'shcqa',[ModifiedDate]= CAST(0x00009F7400CEDC56 AS DateTime),[RecordDeleted]='N',[LOCCategoryId]=4,[MinDeterminatorScore]=CAST(70.00 AS Decimal(10, 2)),[MaxDeterminatorScore]=CAST(89.00 AS Decimal(10, 2)),[Description]= N'[Description] - 1267',[LOCName]= N'Child DD Level 2' where [LOCId] = 18
END
IF(NOT(EXISTS(SELECT [LOCId] FROM CustomLOCs WHERE [LOCId] = 19)))
      BEGIN   
	INSERT [dbo].[CustomLOCs] ([LOCId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedBy], [DeletedDate], [LOCCategoryId], [LOCType], [MinDeterminatorScore], [MaxDeterminatorScore], [Description], [ADTCriteria], [ProviderQualifications], [LOCName]) VALUES 
	(19, N'shcqa', CAST(0x00009F7400CEDC94 AS DateTime), N'shcqa', CAST(0x00009F7400CEDC94 AS DateTime), NULL, NULL, NULL, 4, NULL, CAST(0.00 AS Decimal(10, 2)), CAST(50.00 AS Decimal(10, 2)), N'[Description] - 1267', NULL, NULL, N'Child DD Level 1')
    END
ELSE
    BEGIN
        Update [CustomLOCs]  set ModifiedBy=N'shcqa',[ModifiedDate]= CAST(0x00009F7400CEDC56 AS DateTime),[RecordDeleted]='N',[LOCCategoryId]=4,[MinDeterminatorScore]=CAST(0.00 AS Decimal(10, 2)),[MaxDeterminatorScore]=CAST(50.00 AS Decimal(10, 2)),[Description]= N'[Description] - 1267',[LOCName]= N'Child DD Level 1' where [LOCId] = 19
END
IF(NOT(EXISTS(SELECT [LOCId] FROM CustomLOCs WHERE [LOCId] = 20)))
      BEGIN   
	INSERT [dbo].[CustomLOCs] ([LOCId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedBy], [DeletedDate], [LOCCategoryId], [LOCType], [MinDeterminatorScore], [MaxDeterminatorScore], [Description], [ADTCriteria], [ProviderQualifications], [LOCName]) VALUES 
	(20, N'sa', CAST(0x00009F5D010DB727 AS DateTime), N'sa', CAST(0x00009F5D010DB727 AS DateTime), NULL, NULL, NULL, 3, NULL, CAST(140.00 AS Decimal(10, 2)), CAST(240.00 AS Decimal(10, 2)), N'[Description] - 1267', NULL, NULL, N'Child SED Level 5')
    END
ELSE
    BEGIN
        Update [CustomLOCs]  set ModifiedBy=N'shcqa',[ModifiedDate]= CAST(0x00009F7400CEDC56 AS DateTime),[RecordDeleted]='N',[LOCCategoryId]=3,[MinDeterminatorScore]=CAST(140.00 AS Decimal(10, 2)),[MaxDeterminatorScore]=CAST(240.00 AS Decimal(10, 2)),[Description]= N'[Description] - 1267',[LOCName]= N'Child SED Level 5' where [LOCId] = 20
END
SET IDENTITY_INSERT [dbo].[CustomLOCs] OFF






