--Validation scripts for Task #650 in Engineering Improvement Initiatives- NBL(I)
/******************************************************************************** 

-- *****History****  
/*       Date           Author				Purpose                   */
/*       15/MAY/2018	Akwinass			Created                   */
*********************************************************************************/
IF NOT EXISTS (
		SELECT *
		FROM DocumentValidations
		WHERE DocumentCodeId = 1653
			AND TabName = 'Quick Orders'
			AND TabOrder = 1
			AND TableName = 'ClientOrders'
			AND ColumnName = 'ClientOrders'
			AND ValidationLogic = 'FROM DocumentVersions DV WHERE DV.DocumentVersionId = @DocumentVersionId AND ISNULL(DV.RecordDeleted, ''N'') = ''N'' AND NOT EXISTS(SELECT ClientOrderId FROM ClientOrders CO WHERE CO.DocumentVersionId = DV.DocumentVersionId AND ISNULL(CO.RecordDeleted, ''N'') = ''N'')'
		)
BEGIN
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
		,1653
		,NULL
		,N'Quick Orders'
		,1
		,N'ClientOrders'
		,N'ClientOrders'
		,N'FROM DocumentVersions DV WHERE DV.DocumentVersionId = @DocumentVersionId AND ISNULL(DV.RecordDeleted, ''N'') = ''N'' AND NOT EXISTS(SELECT ClientOrderId FROM ClientOrders CO WHERE CO.DocumentVersionId = DV.DocumentVersionId AND ISNULL(CO.RecordDeleted, ''N'') = ''N'')'
		,N'Client Orders - Please add minimum one order to the Grid.'
		,CAST(1 AS DECIMAL(18, 0))
		,N'Client Orders - Please add minimum one order to the Grid.'
		)
END