--Delete from CustomSUDrugs where SUDrugId in (1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27) 
GO
/****** Object:  Table [dbo].[CustomSUDrugs]    Script Date: 08/13/2013 15:52:39 ******/
if not exists(Select 1 from CustomSUDrugs where SUDrugId=1)
Begin
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] ON
INSERT [dbo].[CustomSUDrugs] ([SUDrugId], [DrugName], [DrugDescription], [CanBePrescribed], [Active], [CommonStreetNames], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]) VALUES (1, N'Alcohol', N'Alcohol', NULL, N'Y', N'[CommonStreetNames] - 172671F5-870B-4189-9824-705D61452776', N'172671f5-870b-4189-9824-705d61452776', N'KCMHSAS\streamline', CAST(0x0000A03D0104D510 AS DateTime), N'KCMHSAS\streamline', CAST(0x0000A03D0104D510 AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] OFF
End
Else
Begin
Update CustomSUDrugs set DrugName = 'Alcohol',DrugDescription = 'Alcohol' where SUDrugId = 1
End
if not exists(Select 1 from CustomSUDrugs where SUDrugId=2)
Begin
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] ON
INSERT [dbo].[CustomSUDrugs] ([SUDrugId], [DrugName], [DrugDescription], [CanBePrescribed], [Active], [CommonStreetNames], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]) VALUES (2, N'Heroin', N'Heroin', NULL, N'Y', N'[CommonStreetNames] - 05F04AE3-AB81-422A-82C5-DD14D6AE2F1E', N'05f04ae3-ab81-422a-82c5-dd14d6ae2f1e', N'KCMHSAS\streamline', CAST(0x0000A03D0104D512 AS DateTime), N'KCMHSAS\streamline', CAST(0x0000A03D0104D512 AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] OFF
End
Else
Begin
Update CustomSUDrugs set DrugName = 'Heroin',DrugDescription = 'Heroin' where SUDrugId = 2
End
if not exists(Select 1 from CustomSUDrugs where SUDrugId=3)
Begin
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] ON
INSERT [dbo].[CustomSUDrugs] ([SUDrugId], [DrugName], [DrugDescription], [CanBePrescribed], [Active], [CommonStreetNames], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]) VALUES (3, N'Methadone (illicit)', N'Methadone (illicit)', N'Y', N'Y', N'[CommonStreetNames] - 6C8C095D-3E35-476D-8F5A-611663EBB3F5', N'6c8c095d-3e35-476d-8f5a-611663ebb3f5', N'KCMHSAS\streamline', CAST(0x0000A03D0104D512 AS DateTime), N'KCMHSAS\streamline', CAST(0x0000A03D0104D512 AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] OFF
End
Else
Begin
Update CustomSUDrugs set DrugName = 'Methadone (illicit)',DrugDescription = 'Methadone (illicit)' where SUDrugId = 3
End
if not exists(Select 1 from CustomSUDrugs where SUDrugId=4)
Begin
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] ON
INSERT [dbo].[CustomSUDrugs] ([SUDrugId], [DrugName], [DrugDescription], [CanBePrescribed], [Active], [CommonStreetNames], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]) VALUES (4, N'Other Opiates or synthetics', N'Other Opiates or synthetics', N'Y', N'Y', N'[CommonStreetNames] - 5A97B714-B845-471D-A5D9-6BDF05B409A0', N'5a97b714-b845-471d-a5d9-6bdf05b409a0', N'KCMHSAS\streamline', CAST(0x0000A03D0104D512 AS DateTime), N'KCMHSAS\streamline', CAST(0x0000A03D0104D512 AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] OFF
End
Else
Begin
Update CustomSUDrugs set DrugName = 'Other Opiates or synthetics',DrugDescription = 'Other Opiates or synthetics' where SUDrugId = 4
End

if not exists(Select 1 from CustomSUDrugs where SUDrugId=6)
Begin
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] ON
INSERT [dbo].[CustomSUDrugs] ([SUDrugId], [DrugName], [DrugDescription], [CanBePrescribed], [Active], [CommonStreetNames], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]) VALUES (6, N'Other sedatives or hypnotics', N'Other sedatives or hypnotics', N'Y', N'Y', N'[CommonStreetNames] - 539BC5AE-AD93-40DE-88E6-F4211BEE9187', N'539bc5ae-ad93-40de-88e6-f4211bee9187', N'KCMHSAS\streamline', CAST(0x0000A03D0104D513 AS DateTime), N'KCMHSAS\streamline', CAST(0x0000A03D0104D513 AS DateTime), 'Y', NULL, NULL)
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] OFF
End
Else
Begin
Update CustomSUDrugs set DrugName = 'Other sedatives or hypnotics',DrugDescription = 'Other sedatives or hypnotics' where SUDrugId = 6
End
if not exists(Select 1 from CustomSUDrugs where SUDrugId=7)
Begin
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] ON
INSERT [dbo].[CustomSUDrugs] ([SUDrugId], [DrugName], [DrugDescription], [CanBePrescribed], [Active], [CommonStreetNames], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]) VALUES (7, N'Other tranquilizers', N'Other tranquilizers', N'Y', N'Y', N'[CommonStreetNames] - 9E1240F6-6139-4ECC-B7C5-DBB37A39EB97', N'9e1240f6-6139-4ecc-b7c5-dbb37a39eb97', N'KCMHSAS\streamline', CAST(0x0000A03D0104D513 AS DateTime), N'KCMHSAS\streamline', CAST(0x0000A03D0104D513 AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] OFF
End
Else
Begin
Update CustomSUDrugs set DrugName = 'Other tranquilizers',DrugDescription = 'Other tranquilizers' where SUDrugId = 7
End
if not exists(Select 1 from CustomSUDrugs where SUDrugId=8)
Begin
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] ON
INSERT [dbo].[CustomSUDrugs] ([SUDrugId], [DrugName], [DrugDescription], [CanBePrescribed], [Active], [CommonStreetNames], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]) VALUES (8, N'Benzodiazepines', N'Benzodiazepines', N'Y', N'Y', N'[CommonStreetNames] - 47E11EB4-9A68-4D9A-AE29-098BF92CC96B', N'47e11eb4-9a68-4d9a-ae29-098bf92cc96b', N'KCMHSAS\streamline', CAST(0x0000A03D0104D513 AS DateTime), N'KCMHSAS\streamline', CAST(0x0000A03D0104D513 AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] OFF
End
Else
Begin
Update CustomSUDrugs set DrugName = 'Benzodiazepines',DrugDescription = 'Benzodiazepines' where SUDrugId =8
End
if not exists(Select 1 from CustomSUDrugs where SUDrugId=9)
Begin
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] ON
INSERT [dbo].[CustomSUDrugs] ([SUDrugId], [DrugName], [DrugDescription], [CanBePrescribed], [Active], [CommonStreetNames], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]) VALUES (9, N'GHB,GBL', N'GHB,GBL', N'Y', N'Y', N'[CommonStreetNames] - 16E7BC0F-32AC-46FE-AF51-4DD1D56974F5', N'16e7bc0f-32ac-46fe-af51-4dd1d56974f5', N'KCMHSAS\streamline', CAST(0x0000A03D0104D513 AS DateTime), N'KCMHSAS\streamline', CAST(0x0000A03D0104D513 AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] OFF
End
Else
Begin
Update CustomSUDrugs set DrugName = 'GHB,GBL',DrugDescription = 'GHB,GBL' where SUDrugId = 9
End
if not exists(Select 1 from CustomSUDrugs where SUDrugId=10)
Begin
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] ON
INSERT [dbo].[CustomSUDrugs] ([SUDrugId], [DrugName], [DrugDescription], [CanBePrescribed], [Active], [CommonStreetNames], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]) VALUES (10, N'Cocaine', N'Cocaine', NULL, N'Y', N'[CommonStreetNames] - 1EE278E4-E7FD-407E-9F78-693620E71FEE', N'1ee278e4-e7fd-407e-9f78-693620e71fee', N'KCMHSAS\streamline', CAST(0x0000A03D0104D513 AS DateTime), N'KCMHSAS\streamline', CAST(0x0000A03D0104D513 AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] OFF
End
Else
Begin
Update CustomSUDrugs set DrugName = 'Cocaine',DrugDescription = 'Cocaine' where SUDrugId = 10
End
if not exists(Select 1 from CustomSUDrugs where SUDrugId=11)
Begin
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] ON
INSERT [dbo].[CustomSUDrugs] ([SUDrugId], [DrugName], [DrugDescription], [CanBePrescribed], [Active], [CommonStreetNames], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]) VALUES (11, N'Crack Cocaine', N'Crack Cocaine', NULL, N'Y', N'[CommonStreetNames] - 95E42591-16FC-427E-B13F-5F866DA88A40', N'95e42591-16fc-427e-b13f-5f866da88a40', N'KCMHSAS\streamline', CAST(0x0000A03D0104D513 AS DateTime), N'KCMHSAS\streamline', CAST(0x0000A03D0104D513 AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] OFF
End
Else
Begin
Update CustomSUDrugs set DrugName = 'Crack Cocaine',DrugDescription = 'Crack Cocaine' where SUDrugId = 11
End
if not exists(Select 1 from CustomSUDrugs where SUDrugId=12)
Begin
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] ON
INSERT [dbo].[CustomSUDrugs] ([SUDrugId], [DrugName], [DrugDescription], [CanBePrescribed], [Active], [CommonStreetNames], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]) VALUES (12, N'Methamphetamines', N'Methamphetamines', N'Y', N'Y', N'[CommonStreetNames] - E708CAD3-9B11-4605-860E-250E1F4D30F5', N'e708cad3-9b11-4605-860e-250e1f4d30f5', N'KCMHSAS\streamline', CAST(0x0000A03D0104D513 AS DateTime), N'KCMHSAS\streamline', CAST(0x0000A03D0104D513 AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] OFF
End
Else
Begin
Update CustomSUDrugs set DrugName = 'Methamphetamines',DrugDescription = 'Methamphetamines' where SUDrugId = 12
End
if not exists(Select 1 from CustomSUDrugs where SUDrugId=13)
Begin
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] ON
INSERT [dbo].[CustomSUDrugs] ([SUDrugId], [DrugName], [DrugDescription], [CanBePrescribed], [Active], [CommonStreetNames], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]) VALUES (13, N'Other Amphetamines', N'Other Amphetamines', N'Y', N'Y', N'[CommonStreetNames] - 28E03903-6A5C-4E86-A164-9D546CCBFF14', N'28e03903-6a5c-4e86-a164-9d546ccbff14', N'KCMHSAS\streamline', CAST(0x0000A03D0104D513 AS DateTime), N'KCMHSAS\streamline', CAST(0x0000A03D0104D513 AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] OFF
End
Else
Begin
Update CustomSUDrugs set DrugName = 'Other Amphetamines',DrugDescription = 'Other Amphetamines' where SUDrugId = 13
End
if not exists(Select 1 from CustomSUDrugs where SUDrugId=14)
Begin
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] ON
INSERT [dbo].[CustomSUDrugs] ([SUDrugId], [DrugName], [DrugDescription], [CanBePrescribed], [Active], [CommonStreetNames], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]) VALUES (14, N'Methcathinone', N'Methcathinone', NULL, N'Y', N'[CommonStreetNames] - 603D26CA-31AB-4545-A78B-A757F53EC2A6', N'603d26ca-31ab-4545-a78b-a757f53ec2a6', N'KCMHSAS\streamline', CAST(0x0000A03D0104D513 AS DateTime), N'KCMHSAS\streamline', CAST(0x0000A03D0104D513 AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] OFF
End
Else
Begin
Update CustomSUDrugs set DrugName = 'Methcathinone',DrugDescription = 'Methcathinone' where SUDrugId = 14
End
if not exists(Select 1 from CustomSUDrugs where SUDrugId=15)
Begin
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] ON
INSERT [dbo].[CustomSUDrugs] ([SUDrugId], [DrugName], [DrugDescription], [CanBePrescribed], [Active], [CommonStreetNames], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]) VALUES (15, N'Hallucinogens', N'Hallucinogens', NULL, N'Y', N'[CommonStreetNames] - 313A7FA1-D74F-44BA-B7AD-8998D9C03EAE', N'313a7fa1-d74f-44ba-b7ad-8998d9c03eae', N'KCMHSAS\streamline', CAST(0x0000A03D0104D514 AS DateTime), N'KCMHSAS\streamline', CAST(0x0000A03D0104D514 AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] OFF
End
Else
Begin
Update CustomSUDrugs set DrugName = 'Hallucinogens',DrugDescription = 'Hallucinogens' where SUDrugId = 15
End
if not exists(Select 1 from CustomSUDrugs where SUDrugId=16)
Begin
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] ON
INSERT [dbo].[CustomSUDrugs] ([SUDrugId], [DrugName], [DrugDescription], [CanBePrescribed], [Active], [CommonStreetNames], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]) VALUES (16, N'PCP', N'PCP', NULL, N'Y', N'[CommonStreetNames] - 7A89C3D5-E1E8-4CF8-A71F-3031E2E3B471', N'7a89c3d5-e1e8-4cf8-a71f-3031e2e3b471', N'KCMHSAS\streamline', CAST(0x0000A03D0104D514 AS DateTime), N'KCMHSAS\streamline', CAST(0x0000A03D0104D514 AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] OFF
End
Else
Begin
Update CustomSUDrugs set DrugName = 'PCP',DrugDescription = 'PCP' where SUDrugId = 16
End
if not exists(Select 1 from CustomSUDrugs where SUDrugId=17)
Begin
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] ON
INSERT [dbo].[CustomSUDrugs] ([SUDrugId], [DrugName], [DrugDescription], [CanBePrescribed], [Active], [CommonStreetNames], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]) VALUES (17, N'Marijuana/hashish', N'Marijuana/hashish', NULL, N'Y', N'[CommonStreetNames] - A5481CCF-469B-4562-AD43-645AF94EC367', N'a5481ccf-469b-4562-ad43-645af94ec367', N'KCMHSAS\streamline', CAST(0x0000A03D0104D514 AS DateTime), N'KCMHSAS\streamline', CAST(0x0000A03D0104D514 AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] OFF
End
Else
Begin
Update CustomSUDrugs set DrugName = 'Marijuana/hashish',DrugDescription = 'Marijuana/hashish' where SUDrugId = 17
End
if not exists(Select 1 from CustomSUDrugs where SUDrugId=18)
Begin
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] ON
INSERT [dbo].[CustomSUDrugs] ([SUDrugId], [DrugName], [DrugDescription], [CanBePrescribed], [Active], [CommonStreetNames], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]) VALUES (18, N'Ecstasy (MDMA,MDA)', N'Ecstasy (MDMA,MDA)', N'Y', N'Y', N'[CommonStreetNames] - 4283BBFD-8954-4452-A651-21652D03866E', N'4283bbfd-8954-4452-a651-21652d03866e', N'KCMHSAS\streamline', CAST(0x0000A03D0104D514 AS DateTime), N'KCMHSAS\streamline', CAST(0x0000A03D0104D514 AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] OFF
End
Else
Begin
Update CustomSUDrugs set DrugName = 'Ecstasy (MDMA,MDA)',DrugDescription = 'Ecstasy (MDMA,MDA)' where SUDrugId = 18
End
if not exists(Select 1 from CustomSUDrugs where SUDrugId=19)
Begin
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] ON
INSERT [dbo].[CustomSUDrugs] ([SUDrugId], [DrugName], [DrugDescription], [CanBePrescribed], [Active], [CommonStreetNames], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]) VALUES (19, N'Ketamine', N'Ketamine', N'Y', N'Y', N'[CommonStreetNames] - 9BBA3D8C-D414-4C6B-8A84-B7457267C10C', N'9bba3d8c-d414-4c6b-8a84-b7457267c10c', N'KCMHSAS\streamline', CAST(0x0000A03D0104D514 AS DateTime), N'KCMHSAS\streamline', CAST(0x0000A03D0104D514 AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] OFF
End
Else
Begin
Update CustomSUDrugs set DrugName = 'Ketamine',DrugDescription = 'Ketamine' where SUDrugId = 19
End
if not exists(Select 1 from CustomSUDrugs where SUDrugId=20)
Begin
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] ON
INSERT [dbo].[CustomSUDrugs] ([SUDrugId], [DrugName], [DrugDescription], [CanBePrescribed], [Active], [CommonStreetNames], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]) VALUES (20, N'Inhalants', N'Inhalants', N'Y', N'Y', N'[CommonStreetNames] - 793617D3-9EEF-4A2D-8B80-A0BACB186687', N'793617d3-9eef-4a2d-8b80-a0bacb186687', N'KCMHSAS\streamline', CAST(0x0000A03D0104D514 AS DateTime), N'KCMHSAS\streamline', CAST(0x0000A03D0104D514 AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] OFF
End
Else
Begin
Update CustomSUDrugs set DrugName = 'Inhalants',DrugDescription = 'Inhalants' where SUDrugId = 20
End
if not exists(Select 1 from CustomSUDrugs where SUDrugId=21)
Begin
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] ON
INSERT [dbo].[CustomSUDrugs] ([SUDrugId], [DrugName], [DrugDescription], [CanBePrescribed], [Active], [CommonStreetNames], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]) VALUES (21, N'Antidepressants', N'Antidepressants', N'Y', N'Y', N'[CommonStreetNames] - 64AC3AB7-03C6-4DD8-8151-3090C5573A8D', N'64ac3ab7-03c6-4dd8-8151-3090c5573a8d', N'KCMHSAS\streamline', CAST(0x0000A03D0104D514 AS DateTime), N'KCMHSAS\streamline', CAST(0x0000A03D0104D514 AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] OFF
End
Else
Begin
Update CustomSUDrugs set DrugName = 'Antidepressants',DrugDescription = 'Antidepressants' where SUDrugId = 21
End
if not exists(Select 1 from CustomSUDrugs where SUDrugId=22)
Begin
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] ON
INSERT [dbo].[CustomSUDrugs] ([SUDrugId], [DrugName], [DrugDescription], [CanBePrescribed], [Active], [CommonStreetNames], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]) VALUES (22, N'Over-the-counter', N'Over-the-counter', N'Y', N'Y', N'[CommonStreetNames] - 53A6AC92-0765-484B-BF42-80FDC8F1A239', N'53a6ac92-0765-484b-bf42-80fdc8f1a239', N'KCMHSAS\streamline', CAST(0x0000A03D0104D515 AS DateTime), N'KCMHSAS\streamline', CAST(0x0000A03D0104D515 AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] OFF
End
Else
Begin
Update CustomSUDrugs set DrugName = 'Over-the-counter',DrugDescription = 'Over-the-counter' where SUDrugId = 22
End
if not exists(Select 1 from CustomSUDrugs where SUDrugId=23)
Begin
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] ON
INSERT [dbo].[CustomSUDrugs] ([SUDrugId], [DrugName], [DrugDescription], [CanBePrescribed], [Active], [CommonStreetNames], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]) VALUES (23, N'Steroids', N'Steroids', N'Y', N'Y', N'[CommonStreetNames] - 3DA97ED8-3CC8-4111-A3AB-64C85994A5B3', N'3da97ed8-3cc8-4111-a3ab-64c85994a5b3', N'KCMHSAS\streamline', CAST(0x0000A03D0104D515 AS DateTime), N'KCMHSAS\streamline', CAST(0x0000A03D0104D515 AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] OFF
End
Else
Begin
Update CustomSUDrugs set DrugName = 'Steroids',DrugDescription = 'Steroids' where SUDrugId = 23
End
if not exists(Select 1 from CustomSUDrugs where SUDrugId=24)
Begin
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] ON
INSERT [dbo].[CustomSUDrugs] ([SUDrugId], [DrugName], [DrugDescription], [CanBePrescribed], [Active], [CommonStreetNames], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]) VALUES (24, N'Talwin and PBZ', N'Talwin and PBZ', N'Y', N'Y', N'[CommonStreetNames] - B70884CA-7C65-480C-A145-2618840CBACF', N'b70884ca-7c65-480c-a145-2618840cbacf', N'KCMHSAS\streamline', CAST(0x0000A03D0104D515 AS DateTime), N'KCMHSAS\streamline', CAST(0x0000A03D0104D515 AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] OFF
End
Else
Begin
Update CustomSUDrugs set DrugName = 'Talwin and PBZ',DrugDescription = 'Talwin and PBZ' where SUDrugId = 24
End
if not exists(Select 1 from CustomSUDrugs where SUDrugId=25)
Begin
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] ON
INSERT [dbo].[CustomSUDrugs] ([SUDrugId], [DrugName], [DrugDescription], [CanBePrescribed], [Active], [CommonStreetNames], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]) 
VALUES (25, N'Bath Salts', N'Bath Salts', N'Y', N'Y', N'[CommonStreetNames] - 14CC9F53-D3A8-4FBD-A4E7-1B3D7249F9AD', N'14cc9f53-d3a8-4fbd-a4e7-1b3d7249f9ad', N'KCMHSAS\streamline', CAST(0x0000A03D0104D515 AS DateTime), N'KCMHSAS\streamline', CAST(0x0000A03D0104D515 AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] OFF
End
Else
Begin
Update CustomSUDrugs set DrugName = 'Bath Salts',DrugDescription = 'Bath Salts' where SUDrugId = 25
End
if not exists(Select 1 from CustomSUDrugs where SUDrugId=26)
Begin
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] ON
INSERT [dbo].[CustomSUDrugs] ([SUDrugId], [DrugName], [DrugDescription], [CanBePrescribed], [Active], [CommonStreetNames], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]) VALUES (26, N'Spice', N'Spice', N'Y', N'Y', N'[CommonStreetNames] - 14CC9F53-D3A8-4FBD-A4E7-1B3D7249F9AD', N'14cc9f53-d3a8-4fbd-a4e7-1b3d7249f9ad', N'KCMHSAS\streamline', CAST(0x0000A03D0104D515 AS DateTime), N'KCMHSAS\streamline', CAST(0x0000A03D0104D515 AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] OFF
End
Else
Begin
Update CustomSUDrugs set DrugName = 'Spice',DrugDescription = 'Spice' where SUDrugId = 26
End
if not exists(Select 1 from CustomSUDrugs where SUDrugId=27)
Begin
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] ON
INSERT [dbo].[CustomSUDrugs] ([SUDrugId], [DrugName], [DrugDescription], [CanBePrescribed], [Active], [CommonStreetNames], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]) VALUES (27, N'Other', N'Other', N'Y', N'Y', N'[CommonStreetNames] - 14CC9F53-D3A8-4FBD-A4E7-1B3D7249F9AD', N'14cc9f53-d3a8-4fbd-a4e7-1b3d7249f9ad', N'KCMHSAS\streamline', CAST(0x0000A03D0104D515 AS DateTime), N'KCMHSAS\streamline', CAST(0x0000A03D0104D515 AS DateTime), NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[CustomSUDrugs] OFF
End
Else
Begin
Update CustomSUDrugs set DrugName = 'Other',DrugDescription = 'Other' where SUDrugId = 27
End
