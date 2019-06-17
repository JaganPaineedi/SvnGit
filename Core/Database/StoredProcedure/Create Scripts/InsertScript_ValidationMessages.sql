
DELETE
FROM DocumentValidations
WHERE DocumentCodeId = 2701

--Dimension 1
INSERT [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	N'Y'
	,2701
	,NULL
	,'Dimension 1'
	,1
	,N'DocumentASAMs'
	,N'Dimension1LevelOfCare'
	,N'FROM DocumentASAMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Dimension1LevelOfCare,0) <= 0 '
	,N'Acute Intoxication and/or Withdrawal Potential - At least one option must be selected '
	,CAST(1 AS DECIMAL(18, 0))
	,N'Acute Intoxication and/or Withdrawal Potential - At least one option must be selected '
	)
	
INSERT [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	N'Y'
	,2701
	,NULL
	,'Dimension 1'
	,1
	,N'DocumentASAMs'
	,N'Dimension1Level'
	,N'FROM DocumentASAMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Dimension1Level,0) <= 0 '
	,N'General - Level must be specified'
	,CAST(2 AS DECIMAL(18, 0))
	,N'General - Level must be specified'
	)
	

	INSERT [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	N'Y'
	,2701
	,NULL
	,'Dimension 1'
	,1
	,N'DocumentASAMs'
	,N'Dimension1DocumentedRisk'
	,N'FROM DocumentASAMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Dimension1DocumentedRisk,0) <= 0 '
	,N'General - Documented Risk must be specified'
	,CAST(3 AS DECIMAL(18, 0))
	,N'General – Documented Risk must be specified'
	)
	
	INSERT [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	N'Y'
	,2701
	,NULL
	,'Dimension 1'
	,1
	,N'DocumentASAMs'
	,N'Dimension1Comments'
	,N'FROM DocumentASAMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Dimension1Comments,'''') = '''' '
	,N'General - Comments must be specified'
	,CAST(4 AS DECIMAL(18, 0))
	,N'General – Comments must be specified'
	)
	

--Dimension 2

INSERT [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	N'Y'
	,2701
	,NULL
	,'Dimension 2'
	,2
	,N'DocumentASAMs'
	,N'Dimension2LevelOfCare'
	,N'FROM DocumentASAMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Dimension2LevelOfCare,0) <= 0 '
	,N'Biomedical Conditions and Complications - At least one option must be selected '
	,CAST(5 AS DECIMAL(18, 0))
	,N'Biomedical Conditions and Complications - At least one option must be selected '
	)
	
INSERT [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	N'Y'
	,2701
	,NULL
	,'Dimension 2'
	,2
	,N'DocumentASAMs'
	,N'Dimension2Level'
	,N'FROM DocumentASAMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Dimension2Level,0) <= 0 '
	,N'General - Level must be specified'
	,CAST(6 AS DECIMAL(18, 0))
	,N'General - Level must be specified'
	)
	

	INSERT [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	N'Y'
	,2701
	,NULL
	,'Dimension 2'
	,2
	,N'DocumentASAMs'
	,N'Dimension2DocumentedRisk'
	,N'FROM DocumentASAMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Dimension2DocumentedRisk,0) <= 0 '
	,N'General - Documented Risk must be specified'
	,CAST(7 AS DECIMAL(18, 0))
	,N'General – Documented Risk must be specified'
	)
	
	INSERT [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	N'Y'
	,2701
	,NULL
	,'Dimension 2'
	,2
	,N'DocumentASAMs'
	,N'Dimension2Comments'
	,N'FROM DocumentASAMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Dimension2Comments,'''') = '''' '
	,N'General - Comments must be specified'
	,CAST(8 AS DECIMAL(18, 0))
	,N'General – Comments must be specified'
	)
	
--Dimension 3

INSERT [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	N'Y'
	,2701
	,NULL
	,'Dimension 3'
	,3
	,N'DocumentASAMs'
	,N'Dimension3LevelOfCare'
	,N'FROM DocumentASAMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Dimension3LevelOfCare,0) <= 0 '
	,N'Emotional, Behavioral or Cognitive conditions and Complications - At least one option must be selected '
	,CAST(9 AS DECIMAL(18, 0))
	,N'Emotional, Behavioral or Cognitive conditions and Complications - At least one option must be selected '
	)
	
INSERT [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	N'Y'
	,2701
	,NULL
	,'Dimension 3'
	,3
	,N'DocumentASAMs'
	,N'Dimension3Level'
	,N'FROM DocumentASAMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Dimension3Level,0) <= 0 '
	,N'General - Level must be specified'
	,CAST(10 AS DECIMAL(18, 0))
	,N'General - Level must be specified'
	)
	

	INSERT [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	N'Y'
	,2701
	,NULL
	,'Dimension 3'
	,3
	,N'DocumentASAMs'
	,N'Dimension3DocumentedRisk'
	,N'FROM DocumentASAMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Dimension3DocumentedRisk,0) <= 0 '
	,N'General - Documented Risk must be specified'
	,CAST(11 AS DECIMAL(18, 0))
	,N'General – Documented Risk must be specified'
	)
	
	INSERT [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	N'Y'
	,2701
	,NULL
	,'Dimension 3'
	,3
	,N'DocumentASAMs'
	,N'Dimension3Comments'
	,N'FROM DocumentASAMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Dimension3Comments,'''') = '''' '
	,N'General - Comments must be specified'
	,CAST(12 AS DECIMAL(18, 0))
	,N'General – Comments must be specified'
	)
	
--Dimension 4

INSERT [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	N'Y'
	,2701
	,NULL
	,'Dimension 4'
	,4
	,N'DocumentASAMs'
	,N'Dimension4LevelOfCare'
	,N'FROM DocumentASAMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Dimension4LevelOfCare,0) <= 0 '
	,N'Readiness to Change - At least one option must be selected '
	,CAST(13 AS DECIMAL(18, 0))
	,N'Readiness to Change - At least one option must be selected '
	)
	
INSERT [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	N'Y'
	,2701
	,NULL
	,'Dimension 4'
	,4
	,N'DocumentASAMs'
	,N'Dimension4Level'
	,N'FROM DocumentASAMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Dimension4Level,0) <= 0 '
	,N'General - Level must be specified'
	,CAST(14 AS DECIMAL(18, 0))
	,N'General - Level must be specified'
	)
	

	INSERT [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	N'Y'
	,2701
	,NULL
	,'Dimension 4'
	,4
	,N'DocumentASAMs'
	,N'Dimension4DocumentedRisk'
	,N'FROM DocumentASAMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Dimension4DocumentedRisk,0) <= 0 '
	,N'General - Documented Risk must be specified'
	,CAST(15 AS DECIMAL(18, 0))
	,N'General – Documented Risk must be specified'
	)
	
	INSERT [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	N'Y'
	,2701
	,NULL
	,'Dimension 4'
	,4
	,N'DocumentASAMs'
	,N'Dimension4Comments'
	,N'FROM DocumentASAMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Dimension4Comments,'''') = '''' '
	,N'General - Comments must be specified'
	,CAST(16 AS DECIMAL(18, 0))
	,N'General – Comments must be specified'
	)
	
	--Dimension 5

INSERT [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	N'Y'
	,2701
	,NULL
	,'Dimension 5'
	,5
	,N'DocumentASAMs'
	,N'Dimension5LevelOfCare'
	,N'FROM DocumentASAMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Dimension5LevelOfCare,0) <= 0 '
	,N'Relapse, Continued Use, Continued Problem Potential - At least one option must be selected '
	,CAST(17 AS DECIMAL(18, 0))
	,N'Relapse, Continued Use, Continued Problem Potential - At least one option must be selected '
	)
	
INSERT [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	N'Y'
	,2701
	,NULL
	,'Dimension 5'
	,5
	,N'DocumentASAMs'
	,N'Dimension5Level'
	,N'FROM DocumentASAMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Dimension5Level,0) <= 0 '
	,N'General - Level must be specified'
	,CAST(18 AS DECIMAL(18, 0))
	,N'General - Level must be specified'
	)
	

	INSERT [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	N'Y'
	,2701
	,NULL
	,'Dimension 5'
	,5
	,N'DocumentASAMs'
	,N'Dimension5DocumentedRisk'
	,N'FROM DocumentASAMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Dimension5DocumentedRisk,0) <= 0 '
	,N'General - Documented Risk must be specified'
	,CAST(19 AS DECIMAL(18, 0))
	,N'General – Documented Risk must be specified'
	)
	
	INSERT [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	N'Y'
	,2701
	,NULL
	,'Dimension 5'
	,5
	,N'DocumentASAMs'
	,N'Dimension5Comments'
	,N'FROM DocumentASAMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Dimension5Comments,'''') = '''' '
	,N'General - Comments must be specified'
	,CAST(20 AS DECIMAL(18, 0))
	,N'General – Comments must be specified'
	)
	
	
--Dimension 6

INSERT [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	N'Y'
	,2701
	,NULL
	,'Dimension 6'
	,6
	,N'DocumentASAMs'
	,N'Dimension6LevelOfCare'
	,N'FROM DocumentASAMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Dimension6LevelOfCare,0) <= 0 '
	,N'Recovery Environment - At least one option must be selected '
	,CAST(21 AS DECIMAL(18, 0))
	,N'Recovery Environment - At least one option must be selected '
	)
	
INSERT [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	N'Y'
	,2701
	,NULL
	,'Dimension 6'
	,6
	,N'DocumentASAMs'
	,N'Dimension6Level'
	,N'FROM DocumentASAMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Dimension6Level,0) <= 0 '
	,N'General - Level must be specified'
	,CAST(22 AS DECIMAL(18, 0))
	,N'General - Level must be specified'
	)
	

	INSERT [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	N'Y'
	,2701
	,NULL
	,'Dimension 6'
	,6
	,N'DocumentASAMs'
	,N'Dimension6DocumentedRisk'
	,N'FROM DocumentASAMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Dimension6DocumentedRisk,0) <= 0 '
	,N'General - Documented Risk must be specified'
	,CAST(23 AS DECIMAL(18, 0))
	,N'General – Documented Risk must be specified'
	)
	
	INSERT [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	N'Y'
	,2701
	,NULL
	,'Dimension 6'
	,6
	,N'DocumentASAMs'
	,N'Dimension6Comments'
	,N'FROM DocumentASAMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(Dimension6Comments,'''') = '''' '
	,N'General - Comments must be specified'
	,CAST(24 AS DECIMAL(18, 0))
	,N'General – Comments must be specified'
	)
	
--Final
		
INSERT [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	N'Y'
	,2701
	,NULL
	,'Final Determination'
	,7
	,N'DocumentASAMs'
	,N'IndicatedReferredLevel'
	,N'FROM DocumentASAMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(IndicatedReferredLevel,0) <= 0 '
	,N'Indicated/Referred Level must be specified'
	,CAST(25 AS DECIMAL(18, 0))
	,N'Indicated/Referred Level must be specified'
	)
	
			
INSERT [dbo].[DocumentValidations] (
	[Active]
	,[DocumentCodeId]
	,[DocumentType]
	,[TabName]
	,[TabOrder]
	,[TableName]
	,[ColumnName]
	,[ValidationLogic]
	,[ValidationDescription]
	,[ValidationOrder]
	,[ErrorMessage]
	)
VALUES (
	N'Y'
	,2701
	,NULL
	,'Final Determination'
	,7
	,N'DocumentASAMs'
	,N'ProvidedLevel'
	,N'FROM DocumentASAMs WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(ProvidedLevel,0) <= 0 '
	,N'Provided Level must be specified'
	,CAST(26 AS DECIMAL(18, 0))
	,N'Provided Level must be specified'
	)