
/****** Object:  Table [dbo].[BedBoardStatusChangeDropdowns]    Script Date: 08/23/2013 19:31:58 ******/

/*-------Date----Author-------Purpose---------------------------------------*/
/*       AUG 2013    Deej     Insert Records BedBoardStatusChangeDropdowns                                                             */
/*       13-09-2013  Akwinass Modified the TRANSFER to Transfer*/
/*       18-09-2013  Akwinass Modified Drop Down Options*/
/*       20-09-2013  Akwinass Modified Drop Down Options*/
/*       19-11-2013  Akwinass Included Bed Census Insert Script*/
/*       31-12-2013  Akwinass Updated Bed Census as per Bedboard Insert Script*/
/****************************************************************************/

DELETE FROM BedBoardStatusChangeDropdowns
GO

SET IDENTITY_INSERT [dbo].[BedBoardStatusChangeDropdowns] ON

INSERT [dbo].[BedBoardStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (1, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Admit,Schedule Admission')
INSERT [dbo].[BedBoardStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (2, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5002, NULL, NULL, NULL, N'Y', N'Y', N'Bed Change,Transfer,On Leave,Discharge,Schedule Bed Change,Schedule Transfer,Schedule On Leave,Schedule Discharge')
INSERT [dbo].[BedBoardStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (3, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5002, NULL, NULL, NULL, N'Y', N'N', N'Discharge')
INSERT [dbo].[BedBoardStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (4, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5006, NULL, NULL, NULL, N'Y', N'Y', N'Return From Leave,Schedule Return From Leave,Discharge')
INSERT [dbo].[BedBoardStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (5, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5001, NULL, NULL, NULL, N'Y', N'Y', N'Admit,Cancel Admission')
INSERT [dbo].[BedBoardStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (6, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5003, N'Y', NULL, NULL, N'Y', N'Y', N'Bed Change,Schedule Transfer,Schedule On Leave')
INSERT [dbo].[BedBoardStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (7, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5003, N'Y', NULL, NULL, N'Y', N'N', N'Bed Change')
INSERT [dbo].[BedBoardStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (8, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5003, N'N', NULL, NULL, N'Y', N'Y', N'Schedule Transfer,Schedule On Leave')
INSERT [dbo].[BedBoardStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (9, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5004, N'Y', NULL, NULL, N'Y', N'Y', N'Transfer,Schedule Bed Change,Schedule On Leave')
INSERT [dbo].[BedBoardStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (10, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5004, N'Y', NULL, NULL, N'Y', N'N', N'Transfer')
INSERT [dbo].[BedBoardStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (11, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5004, N'N', NULL, NULL, N'Y', N'Y', N'Schedule Bed Change,Schedule On Leave')
INSERT [dbo].[BedBoardStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (12, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5005, N'Y', NULL, NULL, N'Y', N'Y', N'On Leave,Schedule Return From Leave')
INSERT [dbo].[BedBoardStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (13, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5005, N'Y', NULL, NULL, N'Y', N'N', N'On Leave')
INSERT [dbo].[BedBoardStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (14, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5005, N'N', NULL, NULL, N'Y', N'Y', N'Schedule Return From Leave')
INSERT [dbo].[BedBoardStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (15, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5007, NULL, N'Y', NULL, N'Y', N'Y', N'Return From Leave,Schedule Bed Change,Schedule Transfer,Schedule On Leave')
INSERT [dbo].[BedBoardStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (16, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5007, NULL, N'Y', NULL, N'Y', N'N', N'Return From Leave')
INSERT [dbo].[BedBoardStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (17, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5007, NULL, NULL, N'Y', N'Y', N'Y', N'Schedule Bed Change,Schedule Transfer,Schedule On Leave')

SET IDENTITY_INSERT [dbo].[BedBoardStatusChangeDropdowns] OFF

DELETE FROM BedCensusStatusChangeDropdowns
GO

SET IDENTITY_INSERT [dbo].[BedCensusStatusChangeDropdowns] ON

--INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (1, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Admit,Schedule Admission')
--INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (2, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5002, NULL, NULL, NULL, N'Y', N'Y', N'Discharge,Bed Change,Transfer,On Leave,Schedule Bed Change,Schedule Transfer,Schedule On Leave')
--INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (3, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5002, NULL, NULL, NULL, N'Y', N'N', N'Discharge')
--INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (4, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5006, NULL, NULL, NULL, N'Y', N'Y', N'Return From Leave,Schedule Return From Leave,Discharge')
--INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (5, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5001, NULL, NULL, NULL, N'Y', N'Y', N'Admit')
--INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (6, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5003, N'Y', NULL, NULL, N'Y', N'Y', N'Bed Change,Schedule Bed Change,Schedule Transfer,Schedule On Leave')
--INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (7, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5003, N'Y', NULL, NULL, N'Y', N'N', N'Bed Change')
--INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (8, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5003, N'N', NULL, NULL, N'Y', N'Y', N'Schedule Bed Change,Schedule Transfer,Schedule On Leave')
--INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (9, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5004, N'Y', NULL, NULL, N'Y', N'Y', N'Transfer,Schedule Bed Change,Schedule Transfer,Schedule On Leave')
--INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (10, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5004, N'Y', NULL, NULL, N'Y', N'N', N'Transfer')
--INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (11, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5004, N'N', NULL, NULL, N'Y', N'Y', N'Schedule Bed Change,Schedule Transfer,Schedule On Leave')
--INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (12, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5005, N'Y', NULL, NULL, N'Y', N'Y', N'On Leave,Schedule Return From Leave')
--INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (13, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5005, N'Y', NULL, NULL, N'Y', N'N', N'On Leave')
--INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (14, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5005, N'N', NULL, NULL, N'Y', N'Y', N'Schedule Return From Leave')
--INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (15, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5007, NULL, N'Y', NULL, N'Y', N'Y', N'Return From Leave,Schedule Bed Change,Schedule Transfer,Schedule On Leave')
--INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (16, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5007, NULL, N'Y', NULL, N'Y', N'N', N'Return From Leave')
--INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (17, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5007, NULL, NULL, N'Y', N'Y', N'Y', N'Schedule Bed Change,Schedule Transfer,Schedule On Leave')

INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (1, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Admit,Schedule Admission')
INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (2, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5002, NULL, NULL, NULL, N'Y', N'Y', N'Bed Change,Transfer,On Leave,Discharge,Schedule Bed Change,Schedule Transfer,Schedule On Leave')
INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (3, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5002, NULL, NULL, NULL, N'Y', N'N', N'Discharge')
INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (4, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5006, NULL, NULL, NULL, N'Y', N'Y', N'Return From Leave,Schedule Return From Leave,Discharge')
INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (5, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5001, NULL, NULL, NULL, N'Y', N'Y', N'Admit,Cancel Admission')
INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (6, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5003, N'Y', NULL, NULL, N'Y', N'Y', N'Bed Change,Schedule Transfer,Schedule On Leave')
INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (7, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5003, N'Y', NULL, NULL, N'Y', N'N', N'Bed Change')
INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (8, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5003, N'N', NULL, NULL, N'Y', N'Y', N'Schedule Transfer,Schedule On Leave')
INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (9, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5004, N'Y', NULL, NULL, N'Y', N'Y', N'Transfer,Schedule Bed Change,Schedule On Leave')
INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (10, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5004, N'Y', NULL, NULL, N'Y', N'N', N'Transfer')
INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (11, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5004, N'N', NULL, NULL, N'Y', N'Y', N'Schedule Bed Change,Schedule On Leave')
INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (12, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5005, N'Y', NULL, NULL, N'Y', N'Y', N'On Leave,Schedule Return From Leave')
INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (13, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5005, N'Y', NULL, NULL, N'Y', N'N', N'On Leave')
INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (14, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5005, N'N', NULL, NULL, N'Y', N'Y', N'Schedule Return From Leave')
INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (15, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5007, NULL, N'Y', NULL, N'Y', N'Y', N'Return From Leave,Schedule Bed Change,Schedule Transfer,Schedule On Leave')
INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (16, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5007, NULL, N'Y', NULL, N'Y', N'N', N'Return From Leave')
INSERT [dbo].[BedCensusStatusChangeDropdowns] ([BedCensusStatusChangeDropdownId], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy], [BedAssignmentStatus], [PreviousAssignmentOccupied], [PreviousAssignmentOnLeave], [PreviousAssignmentScheduledOnLeave], [DispositionIsNull], [NextAssignmentIsNull], [DropdownOptions]) VALUES (17, N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), N'shstest', CAST(0x0000A13F00E7B12B AS DateTime), NULL, NULL, NULL, 5007, NULL, NULL, N'Y', N'Y', N'Y', N'Schedule Bed Change,Schedule Transfer,Schedule On Leave')

SET IDENTITY_INSERT [dbo].[BedCensusStatusChangeDropdowns] OFF

UPDATE screens SET HelpURL = '../Help/overview.htm' WHERE ScreenId = 148 AND ScreenName='Bed Search'
