DELETE FROM ManageModuleDefinitions
SET IDENTITY_INSERT [dbo].[ManageModuleDefinitions] ON
INSERT [dbo].[ManageModuleDefinitions] ([ManageModuleDefinitionId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedBy], [DeletedDate]) VALUES (1, N'EII-561', GETDATE(), N'EII-561', GETDATE(), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[ManageModuleDefinitions] OFF