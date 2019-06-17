--Katta Sharath Kumar Copied from Newayago  06/11/2014 With ref to task#281-Allegan 3.5 Implementation 
--created by shikha for ref task 60 in Newaygo Bugs
--What:-Inserting Data in Master table "CustomASAMLevelOfCares"
--Why:- As no data is shown in Assessment ASAM Popups
	SET IDENTITY_INSERT [dbo].[CustomASAMLevelOfCares] ON
IF not exists (Select 1 from CustomASAMLevelOfCares where ASAMLevelOfCareId=1)
	Begin
	INSERT [dbo].[CustomASAMLevelOfCares] ([ASAMLevelOfCareId], [LevelOfCareName], [LevelNumber], [Dimension1Description], [Dimension2Description], [Dimension3Description], [Dimension4Description], [Dimension5Description], [Dimension6Description], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]) VALUES (1, N'Level 0.5 Early Intervention', NULL, N'The patient is not at risk of withdrawal', N'None or very stable', N'None or very stable', N'The patient is willing to explore how current alcohol or drug use  may affect personal goals.', N'The patient needs an understanding of, or skills to change,  His or her current alcohol and drug use pattern.', N'The patient’s social support system or significant others increase the risk Of personal conflict about alcohol or srug use.', N'b64c499f-2810-4d3c-9e5b-b22f898b556d', N'VTC\rn1', CAST(0x00009A16012C8B95 AS DateTime), N'VTC\rn1', CAST(0x00009A16012C8B95 AS DateTime), NULL, NULL, NULL)
	END
IF not exists (Select 1 from CustomASAMLevelOfCares where ASAMLevelOfCareId=2)
	Begin
	INSERT [dbo].[CustomASAMLevelOfCares] ([ASAMLevelOfCareId], [LevelOfCareName], [LevelNumber], [Dimension1Description], [Dimension2Description], [Dimension3Description], [Dimension4Description], [Dimension5Description], [Dimension6Description], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]) VALUES (2, N'Opioid Maintenance Therapy', NULL, N'The patient is physiologically dependent on opiates and requires OMT to prevent withdrawal', N'None or manageable with outpatient medical monitoring', N'None or manageable in an outpatient structured enviornment', N'The patient is ready to change the negative effects of opiate use, but is not ready for total abstinence.', N'The patient is at high risk of relapse or continued use without  OMT and structured therapy to promote treatment progress.', N'The patient’s recovery environment is supportive and/or the Patient has skills to cope.', N'ac30dfd8-73a4-423f-9b2d-9b35080e11e6', N'VTC\rn1', CAST(0x00009A16012C8B95 AS DateTime), N'VTC\rn1', CAST(0x00009A16012C8B95 AS DateTime), NULL, NULL, NULL)
	END

IF not exists (Select 1 from CustomASAMLevelOfCares where ASAMLevelOfCareId=3)
	Begin
	INSERT [dbo].[CustomASAMLevelOfCares] ([ASAMLevelOfCareId], [LevelOfCareName], [LevelNumber], [Dimension1Description], [Dimension2Description], [Dimension3Description], [Dimension4Description], [Dimension5Description], [Dimension6Description], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]) VALUES (3, N'Level I OP Tx', NULL, N'The patient is not experiencing significant withdrawal or is at   minimal risk of severe withdrawal', N'None or very stable, or the patient is receiving concurrent medical Monitoring', N'None or very stable, or the patient is receiving concurrent  Mental health monitoring.', N'The patient is ready for recovery, but needs motivating and monitoring Strategies to strengthen readiness. Or there is high severity in this Dimension but not in other dimensions. The patient therefore needs a   Level I motivational enhancement program.', N'The patient is able to maintain abstinence or control use and   Pursue recovery or motivational goals with minimal support.', N'The patient’s recovery environment is supportive and/or the patient has skills to cope.', N'c26db8e9-2de7-4dbb-8226-30e77fdb551c', N'VTC\rn1', CAST(0x00009A16012C8B95 AS DateTime), N'VTC\rn1', CAST(0x00009A16012C8B95 AS DateTime), NULL, NULL, NULL)
	END
IF not exists (Select 1 from CustomASAMLevelOfCares where ASAMLevelOfCareId=4)
	Begin
	INSERT [dbo].[CustomASAMLevelOfCares] ([ASAMLevelOfCareId], [LevelOfCareName], [LevelNumber], [Dimension1Description], [Dimension2Description], [Dimension3Description], [Dimension4Description], [Dimension5Description], [Dimension6Description], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]) VALUES (4, N'Level II.1 IOP', NULL, N'The patient is at minimal risk of severe withdrawal', N'None or not a distraction from treatment. Such problems are manageable at Level II.1', N'Mild severity, with the potential to distract from recovery;  The patient needs monitoring.', N'The patient has variable engagement in treatment, ambivalence or   lack of awareness of the substance use or mental health problem,  and requires a structured program several times a week to promote  progress through the stages of change.', N'Intensification of the patient’s addiction or mental health symptoms indicate a high likelihood of relapse or continued use or continued  problems without close monitoring and support several times a week.', N'The patient’s recovery environment is not supportive but, with structure and support, the patient can cope.', N'e630a728-0c14-4964-a3bc-2b1c9fa5bcda', N'VTC\rn1', CAST(0x00009A16012C8B95 AS DateTime), N'VTC\rn1', CAST(0x00009A16012C8B95 AS DateTime), NULL, NULL, NULL)
	END
IF not exists (Select 1 from CustomASAMLevelOfCares where ASAMLevelOfCareId=5)
	Begin
	INSERT [dbo].[CustomASAMLevelOfCares] ([ASAMLevelOfCareId], [LevelOfCareName], [LevelNumber], [Dimension1Description], [Dimension2Description], [Dimension3Description], [Dimension4Description], [Dimension5Description], [Dimension6Description], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]) VALUES (5, N'Level II. 5 Partial', NULL, N'The patient is at moderate risk of severe withdrawal', N'None or not sufficient to distract from treatment. Such problems are manageable at Level II.5', N'Mild to moderate severity, with the potential to distract from  Recovery; the patient needs stabilization.', N'The patient has poor engagement in treatment, significant ambivalence, or lack of awareness of the substance use or mental health problem,requiring a near-daily structured program or intensive engagement   services to promote progress through the stages of change.', N'Intensification of the patient’s addiction or mental health symptoms, Despite active participation in a Level I ro II.1 program, indicates a High likelihood of relapse or continued use or continued use or  Continued problems without near-daily monitoring and support.', N'The patient’s recovery environment is not supportive but, with structure and support and relief from the home environment, the patient can cope.', N'5f514213-be66-4691-a245-dcced2df6606', N'VTC\rn1', CAST(0x00009A16012C8B95 AS DateTime), N'VTC\rn1', CAST(0x00009A16012C8B95 AS DateTime), NULL, NULL, NULL)
	END
IF not exists (Select 1 from CustomASAMLevelOfCares where ASAMLevelOfCareId=6)
	Begin
	INSERT [dbo].[CustomASAMLevelOfCares] ([ASAMLevelOfCareId], [LevelOfCareName], [LevelNumber], [Dimension1Description], [Dimension2Description], [Dimension3Description], [Dimension4Description], [Dimension5Description], [Dimension6Description], [RowIdentifier], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate], [RecordDeleted], [DeletedDate], [DeletedBy]) VALUES (6, N'Level III.1 Res (low)', NULL, N'The patient is not at risk of withdrawal, or is experiencing minimal or stable withdrawal.  The patient is concurrently receiving   Level I-D (minimal) or Level II-D (moderate) services', N'None or stable, or the patient is receiving concurrent medical monitoring', N'None or minimal; not distracting to recovery.  If stable, a Dual  Diagnosis Capable program. If not a Dual Diagnosis Enhanced  Program is required.', N'The patient is open to recovery, but needs a structured environment To maintain therapeutic gains.', N'The patient understands relapse but needs structure to maintain  therapeutic gains.', N'The patient’s environment is dangerous, but recovery is achievable if Level III.1 24-hour structure is available.', N'b6a79185-0f68-4fff-9848-2f92c829cad8', N'VTC\rn1', CAST(0x00009A16012C8B95 AS DateTime), N'VTC\rn1', CAST(0x00009A16012C8B95 AS DateTime), NULL, NULL, NULL)
ENd
	SET IDENTITY_INSERT [dbo].[CustomASAMLevelOfCares] OFF
	
IF EXISTS (Select * FROM CustomASAMLevelOfCares WHERE Dimension6Description = 'The patient’s social support system or significant others increase the risk Of personal conflict about alcohol or srug use.' 
			AND ASAMLevelOfCareId =1)
BEGIN
	UPDATE CustomASAMLevelOfCares SET Dimension6Description='The patient’s social support system or significant others increase the risk of personal conflict about alcohol or drug use.'
	WHERE ASAMLevelOfCareId =1
END
GO

IF EXISTS (Select * FROM CustomASAMLevelOfCares WHERE Dimension5Description = 'Intensification of the patient’s addiction or mental health symptoms, Despite active participation in a Level I ro II.1 program, indicates a High likelihood of relapse or continued use or continued use or  Continued problems without near-daily monitoring and support.'
			AND ASAMLevelOfCareId =5)
BEGIN
	UPDATE CustomASAMLevelOfCares SET Dimension5Description='Intensification of the patient’s addiction or mental health symptoms, Despite active participation in a Level I or II.1 program, indicates a High likelihood of relapse or continued use or continued use or  Continued problems without near-daily monitoring and support.'
	WHERE ASAMLevelOfCareId =5
END
GO

IF EXISTS (Select * FROM CustomASAMLevelOfCares WHERE Dimension3Description = 'None or manageable in an outpatient structured enviornment'
			AND ASAMLevelOfCareId =2)
BEGIN
	UPDATE CustomASAMLevelOfCares SET Dimension3Description='None or manageable in an outpatient structured environment'
	WHERE ASAMLevelOfCareId =2
END	