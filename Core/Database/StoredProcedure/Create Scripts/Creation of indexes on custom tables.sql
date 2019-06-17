
IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE4_CustomInquiries' AND object_id = OBJECT_ID('[dbo].[CustomInquiries]'))
	DROP INDEX [XIE4_CustomInquiries] ON [dbo].[CustomInquiries]

IF EXISTS (SELECT *  FROM sys.tables WHERE object_id = OBJECT_ID('[dbo].[CustomInquiries]'))
	CREATE NONCLUSTERED INDEX [XIE4_CustomInquiries] ON [dbo].[CustomInquiries]
	(
		[ClientId] ASC
	)
	INCLUDE ( 	[RecordDeleted])


IF EXISTS (SELECT *  FROM sys.indexes  WHERE name='XIE1_CustomDispositions' AND object_id = OBJECT_ID('[dbo].[CustomDispositions]'))
	DROP INDEX [XIE1_CustomDispositions] ON [dbo].[CustomDispositions]

IF EXISTS (SELECT *  FROM sys.tables WHERE object_id = OBJECT_ID('[dbo].[CustomDispositions]'))
	CREATE NONCLUSTERED INDEX [XIE1_CustomDispositions] ON [dbo].[CustomDispositions]
	(
		[InquiryId] ASC,
		[Disposition] ASC
	)
	INCLUDE ( 	[RecordDeleted])
