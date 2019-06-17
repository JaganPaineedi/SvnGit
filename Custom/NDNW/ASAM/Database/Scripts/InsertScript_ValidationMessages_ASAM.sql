--Validation scripts for Task #954 in  	Valley - Customizations (ASAM Document)
/******************************************************************************** 

-- *****History****  
/*       Date           Author				Purpose                   */
/*       02/DEC/2014	Akwinass			Created                   */
*********************************************************************************/
DELETE
FROM DocumentValidations
WHERE DocumentCodeId = 40034

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
	,40034
	,NULL
	,'Dimension 1'
	,1
	,N'CustomDocumentASAMs'
	,N'Dimension1'
	,N'FROM CustomDocumentASAMs WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(Dimension1,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'At least one option must be selected.'
	,CAST(1 AS DECIMAL(18, 0))
	,N'At least one option must be selected.'
	)
	,(
	N'Y'
	,40034
	,NULL
	,'Dimension 1'
	,1
	,N'CustomDocumentASAMs'
	,N'D1Level'
	,N'FROM CustomDocumentASAMs WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(D1Level,0) <= 0  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Level - must be specified.'
	,CAST(2 AS DECIMAL(18, 0))
	,N'Level - must be specified.'
	)
	,(
	N'Y'
	,40034
	,NULL
	,'Dimension 1'
	,1
	,N'CustomDocumentASAMs'
	,N'D1Risk'
	,N'FROM CustomDocumentASAMs WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(D1Risk,0) <= 0  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Documented Risk - must be specified.'
	,CAST(3 AS DECIMAL(18, 0))
	,N'Documented Risk - must be specified.'
	)
	,(
	N'Y'
	,40034
	,NULL
	,'Dimension 1'
	,1
	,N'CustomDocumentASAMs'
	,N'D1Comments'
	,N'FROM CustomDocumentASAMs ASAM JOIN GlobalCodes GC ON ASAM.D1Level = GC.GlobalCodeId LEFT JOIN GlobalCodes GC2 ON ASAM.D1Risk = GC2.GlobalCodeId WHERE DocumentVersionId = @DocumentVersionId AND GC.CodeName <> ''No treatment recommended'' AND ISNULL(GC2.CodeName,'''') = ''N/A'' AND ISNULL(ASAM.D1Risk,0) > 0 and ISNULL(ASAM.RecordDeleted,''N'') = ''N'''
	,N'"N/A" for the Documented Risk can only be selected when Level is "No Treatment Recommended".'
	,CAST(4 AS DECIMAL(18, 0))
	,N'"N/A" for the Documented Risk can only be selected when Level is "No Treatment Recommended".'
	)
	,(
	N'Y'
	,40034
	,NULL
	,'Dimension 1'
	,1
	,N'CustomDocumentASAMs'
	,N'D1Comments'
	,N'FROM CustomDocumentASAMs ASAM JOIN GlobalCodes GC ON ASAM.D1Risk = GC.GlobalCodeId WHERE ASAM.DocumentVersionId = @DocumentVersionId AND GC.CodeName IN (''Low'',''Moderate'',''High'') AND ISNULL(ASAM.D1Comments,'''') = ''''  and ISNULL(ASAM.RecordDeleted,''N'') = ''N'''
	,N'Comments - is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Comments - is required.'
	)
	,(
	N'Y'
	,40034
	,NULL
	,'Dimension 2'
	,2
	,N'CustomDocumentASAMs'
	,N'Dimension2'
	,N'FROM CustomDocumentASAMs WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(Dimension2,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'At least one option must be selected.'
	,CAST(1 AS DECIMAL(18, 0))
	,N'At least one option must be selected.'
	)
	,(
	N'Y'
	,40034
	,NULL
	,'Dimension 2'
	,2
	,N'CustomDocumentASAMs'
	,N'D2Level'
	,N'FROM CustomDocumentASAMs WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(D2Level,0) <= 0  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Level - must be specified.'
	,CAST(2 AS DECIMAL(18, 0))
	,N'Level - must be specified.'
	)
	,(
	N'Y'
	,40034
	,NULL
	,'Dimension 2'
	,2
	,N'CustomDocumentASAMs'
	,N'D2Risk'
	,N'FROM CustomDocumentASAMs WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(D2Risk,0) <= 0  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Documented Risk - must be specified.'
	,CAST(3 AS DECIMAL(18, 0))
	,N'Documented Risk - must be specified.'
	)
	,(
	N'Y'
	,40034
	,NULL
	,'Dimension 2'
	,2
	,N'CustomDocumentASAMs'
	,N'D2Comments'
	,N'FROM CustomDocumentASAMs ASAM JOIN GlobalCodes GC ON ASAM.D2Level = GC.GlobalCodeId LEFT JOIN GlobalCodes GC2 ON ASAM.D2Risk = GC2.GlobalCodeId WHERE DocumentVersionId = @DocumentVersionId AND GC.CodeName <> ''No treatment recommended'' AND ISNULL(GC2.CodeName,'''') = ''N/A'' AND ISNULL(ASAM.D2Risk,0) > 0 and ISNULL(ASAM.RecordDeleted,''N'') = ''N'''
	,N'"N/A" for the Documented Risk can only be selected when Level is "No Treatment Recommended".'
	,CAST(4 AS DECIMAL(18, 0))
	,N'"N/A" for the Documented Risk can only be selected when Level is "No Treatment Recommended".'
	)
	,(
	N'Y'
	,40034
	,NULL
	,'Dimension 2'
	,2
	,N'CustomDocumentASAMs'
	,N'D2Comments'
	,N'FROM CustomDocumentASAMs ASAM JOIN GlobalCodes GC ON ASAM.D2Risk = GC.GlobalCodeId WHERE ASAM.DocumentVersionId = @DocumentVersionId AND GC.CodeName IN (''Low'',''Moderate'',''High'') AND ISNULL(ASAM.D2Comments,'''') = ''''  and ISNULL(ASAM.RecordDeleted,''N'') = ''N'''
	,N'Comments - is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Comments - is required.'
	)
	,(
	N'Y'
	,40034
	,NULL
	,'Dimension 3'
	,3
	,N'CustomDocumentASAMs'
	,N'Dimension3'
	,N'FROM CustomDocumentASAMs WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(Dimension3,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'At least one option must be selected.'
	,CAST(1 AS DECIMAL(18, 0))
	,N'At least one option must be selected.'
	)
	,(
	N'Y'
	,40034
	,NULL
	,'Dimension 3'
	,3
	,N'CustomDocumentASAMs'
	,N'D3Level'
	,N'FROM CustomDocumentASAMs WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(D3Level,0) <= 0  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Level - must be specified.'
	,CAST(2 AS DECIMAL(18, 0))
	,N'Level - must be specified.'
	)
	,(
	N'Y'
	,40034
	,NULL
	,'Dimension 3'
	,3
	,N'CustomDocumentASAMs'
	,N'D3Risk'
	,N'FROM CustomDocumentASAMs WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(D3Risk,0) <= 0  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Documented Risk - must be specified.'
	,CAST(3 AS DECIMAL(18, 0))
	,N'Documented Risk - must be specified.'
	)
	,(
	N'Y'
	,40034
	,NULL
	,'Dimension 3'
	,3
	,N'CustomDocumentASAMs'
	,N'D3Comments'
	,N'FROM CustomDocumentASAMs ASAM JOIN GlobalCodes GC ON ASAM.D3Level = GC.GlobalCodeId LEFT JOIN GlobalCodes GC2 ON ASAM.D3Risk = GC2.GlobalCodeId WHERE DocumentVersionId = @DocumentVersionId AND GC.CodeName <> ''No treatment recommended'' AND ISNULL(GC2.CodeName,'''') = ''N/A'' AND ISNULL(ASAM.D3Risk,0) > 0 and ISNULL(ASAM.RecordDeleted,''N'') = ''N'''
	,N'"N/A" for the Documented Risk can only be selected when Level is "No Treatment Recommended".'
	,CAST(4 AS DECIMAL(18, 0))
	,N'"N/A" for the Documented Risk can only be selected when Level is "No Treatment Recommended".'
	)
	,(
	N'Y'
	,40034
	,NULL
	,'Dimension 3'
	,3
	,N'CustomDocumentASAMs'
	,N'D3Comments'
	,N'FROM CustomDocumentASAMs ASAM JOIN GlobalCodes GC ON ASAM.D3Risk = GC.GlobalCodeId WHERE ASAM.DocumentVersionId = @DocumentVersionId AND GC.CodeName IN (''Low'',''Moderate'',''High'') AND ISNULL(ASAM.D3Comments,'''') = ''''  and ISNULL(ASAM.RecordDeleted,''N'') = ''N'''
	,N'Comments - is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Comments - is required.'
	)
	,(
	N'Y'
	,40034
	,NULL
	,'Dimension 4'
	,4
	,N'CustomDocumentASAMs'
	,N'Dimension4'
	,N'FROM CustomDocumentASAMs WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(Dimension4,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'At least one option must be selected.'
	,CAST(1 AS DECIMAL(18, 0))
	,N'At least one option must be selected.'
	)
	,(
	N'Y'
	,40034
	,NULL
	,'Dimension 4'
	,4
	,N'CustomDocumentASAMs'
	,N'D4Level'
	,N'FROM CustomDocumentASAMs WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(D4Level,0) <= 0  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Level - must be specified.'
	,CAST(2 AS DECIMAL(18, 0))
	,N'Level - must be specified.'
	)
	,(
	N'Y'
	,40034
	,NULL
	,'Dimension 4'
	,4
	,N'CustomDocumentASAMs'
	,N'D4Risk'
	,N'FROM CustomDocumentASAMs WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(D4Risk,0) <= 0  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Documented Risk - must be specified.'
	,CAST(3 AS DECIMAL(18, 0))
	,N'Documented Risk - must be specified.'
	)
	,(
	N'Y'
	,40034
	,NULL
	,'Dimension 4'
	,4
	,N'CustomDocumentASAMs'
	,N'D4Comments'
	,N'FROM CustomDocumentASAMs ASAM JOIN GlobalCodes GC ON ASAM.D4Level = GC.GlobalCodeId LEFT JOIN GlobalCodes GC2 ON ASAM.D4Risk = GC2.GlobalCodeId WHERE DocumentVersionId = @DocumentVersionId AND GC.CodeName <> ''No treatment recommended'' AND ISNULL(GC2.CodeName,'''') = ''N/A'' AND ISNULL(ASAM.D4Risk,0) > 0 and ISNULL(ASAM.RecordDeleted,''N'') = ''N'''
	,N'"N/A" for the Documented Risk can only be selected when Level is "No Treatment Recommended".'
	,CAST(4 AS DECIMAL(18, 0))
	,N'"N/A" for the Documented Risk can only be selected when Level is "No Treatment Recommended".'
	)
	,(
	N'Y'
	,40034
	,NULL
	,'Dimension 4'
	,4
	,N'CustomDocumentASAMs'
	,N'D4Comments'
	,N'FROM CustomDocumentASAMs ASAM JOIN GlobalCodes GC ON ASAM.D4Risk = GC.GlobalCodeId WHERE ASAM.DocumentVersionId = @DocumentVersionId AND GC.CodeName IN (''Low'',''Moderate'',''High'') AND ISNULL(ASAM.D4Comments,'''') = ''''  and ISNULL(ASAM.RecordDeleted,''N'') = ''N'''
	,N'Comments - is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Comments - is required.'
	)
	,(
	N'Y'
	,40034
	,NULL
	,'Dimension 5'
	,5
	,N'CustomDocumentASAMs'
	,N'Dimension5'
	,N'FROM CustomDocumentASAMs WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(Dimension5,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'At least one option must be selected.'
	,CAST(1 AS DECIMAL(18, 0))
	,N'At least one option must be selected.'
	)
	,(
	N'Y'
	,40034
	,NULL
	,'Dimension 5'
	,5
	,N'CustomDocumentASAMs'
	,N'D5Level'
	,N'FROM CustomDocumentASAMs WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(D5Level,0) <= 0  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Level - must be specified.'
	,CAST(2 AS DECIMAL(18, 0))
	,N'Level - must be specified.'
	)
	,(
	N'Y'
	,40034
	,NULL
	,'Dimension 5'
	,5
	,N'CustomDocumentASAMs'
	,N'D5Risk'
	,N'FROM CustomDocumentASAMs WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(D5Risk,0) <= 0  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Documented Risk - must be specified.'
	,CAST(3 AS DECIMAL(18, 0))
	,N'Documented Risk - must be specified.'
	)
	,(
	N'Y'
	,40034
	,NULL
	,'Dimension 5'
	,5
	,N'CustomDocumentASAMs'
	,N'D5Comments'
	,N'FROM CustomDocumentASAMs ASAM JOIN GlobalCodes GC ON ASAM.D5Level = GC.GlobalCodeId LEFT JOIN GlobalCodes GC2 ON ASAM.D5Risk = GC2.GlobalCodeId WHERE DocumentVersionId = @DocumentVersionId AND GC.CodeName <> ''No treatment recommended'' AND ISNULL(GC2.CodeName,'''') = ''N/A'' AND ISNULL(ASAM.D5Risk,0) > 0 and ISNULL(ASAM.RecordDeleted,''N'') = ''N'''
	,N'"N/A" for the Documented Risk can only be selected when Level is "No Treatment Recommended".'
	,CAST(4 AS DECIMAL(18, 0))
	,N'"N/A" for the Documented Risk can only be selected when Level is "No Treatment Recommended".'
	)
	,(
	N'Y'
	,40034
	,NULL
	,'Dimension 5'
	,5
	,N'CustomDocumentASAMs'
	,N'D5Comments'
	,N'FROM CustomDocumentASAMs ASAM JOIN GlobalCodes GC ON ASAM.D5Risk = GC.GlobalCodeId WHERE ASAM.DocumentVersionId = @DocumentVersionId AND GC.CodeName IN (''Low'',''Moderate'',''High'') AND ISNULL(ASAM.D5Comments,'''') = ''''  and ISNULL(ASAM.RecordDeleted,''N'') = ''N'''
	,N'Comments - is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Comments - is required.'
	)
	,(
	N'Y'
	,40034
	,NULL
	,'Dimension 6'
	,6
	,N'CustomDocumentASAMs'
	,N'Dimension6'
	,N'FROM CustomDocumentASAMs WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(Dimension6,'''') = ''''  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'At least one option must be selected.'
	,CAST(1 AS DECIMAL(18, 0))
	,N'At least one option must be selected.'
	)
	,(
	N'Y'
	,40034
	,NULL
	,'Dimension 6'
	,6
	,N'CustomDocumentASAMs'
	,N'D6Level'
	,N'FROM CustomDocumentASAMs WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(D6Level,0) <= 0  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Level - must be specified.'
	,CAST(2 AS DECIMAL(18, 0))
	,N'Level - must be specified.'
	)
	,(
	N'Y'
	,40034
	,NULL
	,'Dimension 6'
	,6
	,N'CustomDocumentASAMs'
	,N'D6Risk'
	,N'FROM CustomDocumentASAMs WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(D6Risk,0) <= 0  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Documented Risk - must be specified.'
	,CAST(3 AS DECIMAL(18, 0))
	,N'Documented Risk - must be specified.'
	)
	,(
	N'Y'
	,40034
	,NULL
	,'Dimension 6'
	,6
	,N'CustomDocumentASAMs'
	,N'D6Comments'
	,N'FROM CustomDocumentASAMs ASAM JOIN GlobalCodes GC ON ASAM.D6Level = GC.GlobalCodeId LEFT JOIN GlobalCodes GC2 ON ASAM.D6Risk = GC2.GlobalCodeId WHERE DocumentVersionId = @DocumentVersionId AND GC.CodeName <> ''No treatment recommended'' AND ISNULL(GC2.CodeName,'''') = ''N/A'' AND ISNULL(ASAM.D6Risk,0) > 0 and ISNULL(ASAM.RecordDeleted,''N'') = ''N'''
	,N'"N/A" for the Documented Risk can only be selected when Level is "No Treatment Recommended".'
	,CAST(4 AS DECIMAL(18, 0))
	,N'"N/A" for the Documented Risk can only be selected when Level is "No Treatment Recommended".'
	)
	,(
	N'Y'
	,40034
	,NULL
	,'Dimension 6'
	,6
	,N'CustomDocumentASAMs'
	,N'D6Comments'
	,N'FROM CustomDocumentASAMs ASAM JOIN GlobalCodes GC ON ASAM.D6Risk = GC.GlobalCodeId WHERE ASAM.DocumentVersionId = @DocumentVersionId AND GC.CodeName IN (''Low'',''Moderate'',''High'') AND ISNULL(ASAM.D6Comments,'''') = ''''  and ISNULL(ASAM.RecordDeleted,''N'') = ''N'''
	,N'Comments - is required.'
	,CAST(5 AS DECIMAL(18, 0))
	,N'Comments - is required.'
	)
	,(
	N'Y'
	,40034
	,NULL
	,'Final Determination'
	,7
	,N'CustomDocumentASAMs'
	,N'IndicatedReferredLevel'
	,N'FROM CustomDocumentASAMs WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(IndicatedReferredLevel,0) <= 0  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Indicated/Referred Level - must be specified.'
	,CAST(1 AS DECIMAL(18, 0))
	,N'Indicated/Referred Level - must be specified.'
	)
	,(
	N'Y'
	,40034
	,NULL
	,'Final Determination'
	,7
	,N'CustomDocumentASAMs'
	,N'ProvidedLevel'
	,N'FROM CustomDocumentASAMs WHERE DocumentVersionId=@DocumentVersionId  AND ISNULL(ProvidedLevel,0) <= 0  and ISNULL(RecordDeleted,''N'') = ''N'''
	,N'Provided Level - must be specified.'
	,CAST(2 AS DECIMAL(18, 0))
	,N'Provided Level - must be specified.'
	)