IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetNonmappedICDCodes]') AND type in (N'P', N'PC'))
DROP PROCEDURE ssp_GetNonmappedICDCodes
GO

CREATE PROCEDURE [dbo].[ssp_GetNonmappedICDCodes]

@DocumentVersionId int = 0,
@ClientId int = 0

AS

BEGIN

BEGIN TRY
 DECLARE @ToolTip VARCHAR(MAX)
 DECLARE @MappedDSMCodesToolTip VARCHAR(MAX)
 DECLARE @MappedICDCodesToolTip VARCHAR(MAX)
 DECLARE @ICD10Diagnosis INT
 DECLARE @Status INT
 
 IF @DocumentVersionId = 0
 BEGIN
 Set @DocumentVersionId = (SELECT  Top 1 a.CurrentDocumentVersionId
FROM         Documents AS a INNER JOIN
                      DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId INNER JOIN
                      DiagnosesIII AS DIII ON a.CurrentDocumentVersionId = DIII.DocumentVersionId                                                      
where a.ClientId = @ClientId and a.EffectiveDate <= convert(datetime, convert(varchar, getDate(),101))                                                        
and a.Status = 22    and Dc.DiagnosisDocument='Y' and isNull(a.RecordDeleted,'N')<>'Y' and isNull(Dc.RecordDeleted,'N')<>'Y'                                                                                          
order by a.EffectiveDate desc,a.ModifiedDate desc)
 
 END
 
 SELECT @ICD10Diagnosis = DocumentCodeId,@Status = [Status]  FROM Documents WHERE CurrentDocumentVersionId = @DocumentVersionId
 
IF @Status = 22 AND @ICD10Diagnosis <> 1601
 BEGIN
 -- Non Mapped DSM Codes
SET @ToolTip = '' 
SELECT   @ToolTip = @ToolTip + DSMD.DSMCode +' - '+DSMD.DSMDescription+ '</br>'
FROM         DiagnosesIAndII IAndII INNER JOIN
                      DiagnosisDSMDescriptions DSMD ON (DSMD.DSMCode = IAndII.DSMCode AND DSMD.DSMNumber = IAndII.DSMNumber) 
                      LEFT JOIN DiagnosisICD10ICD9Mapping ICDMapping ON DSMD.DSMCode = ICDMapping.ICD9Code
                      
WHERE IAndII.DocumentVersionId = @DocumentVersionId  AND IAndII.DSMCode NOT IN (SELECT     DiagnosesIAndII.DSMCode
FROM         DiagnosesIAndII INNER JOIN
                      DiagnosisICD10ICD9Mapping ON DiagnosesIAndII.DSMCode = DiagnosisICD10ICD9Mapping.ICD9Code WHERE DiagnosesIAndII.DocumentVersionId = @DocumentVersionId)
-- Non Mapped ICD Codes
SELECT   @ToolTip = @ToolTip + DSMD.ICDCode +' - '+DSMD.ICDDescription+ '</br>'
FROM         DiagnosesIIICodes DIII INNER JOIN
                      DiagnosisICDCodes DSMD ON DSMD.ICDCode = DIII.ICDCode
                      LEFT JOIN DiagnosisICD10ICD9Mapping ICDMapping ON DSMD.ICDCode = ICDMapping.ICD9Code
                      
WHERE DIII.DocumentVersionId = @DocumentVersionId  AND DIII.ICDCode NOT IN (SELECT     DiagnosesIIICodes.ICDCode
FROM         DiagnosesIIICodes INNER JOIN
                      DiagnosisICD10ICD9Mapping ON DiagnosesIIICodes.ICDCode = DiagnosisICD10ICD9Mapping.ICD9Code WHERE DiagnosesIIICodes.DocumentVersionId = @DocumentVersionId)


--Select @ToolTip
IF @ToolTip <> ''
BEGIN
SELECT 'Non-mapped ICD codes</br></br>'+@ToolTip AS NonMappedICDCOdes
END

END
ELSE
BEGIN
 IF @Status = 21 AND @ICD10Diagnosis <> 1601
 BEGIN
  -- Non Mapped DSM Codes
SET @ToolTip = '' 
SELECT   @ToolTip = @ToolTip + DSMD.DSMCode +' - '+DSMD.DSMDescription+ '</br>'
FROM         DiagnosesIAndII IAndII INNER JOIN
                      DiagnosisDSMDescriptions DSMD ON (DSMD.DSMCode = IAndII.DSMCode AND DSMD.DSMNumber = IAndII.DSMNumber) 
                      LEFT JOIN DiagnosisICD10ICD9Mapping ICDMapping ON DSMD.DSMCode = ICDMapping.ICD9Code
                      
WHERE IAndII.DocumentVersionId = @DocumentVersionId  AND IAndII.DSMCode NOT IN (SELECT     DiagnosesIAndII.DSMCode
FROM         DiagnosesIAndII INNER JOIN
                      DiagnosisICD10ICD9Mapping ON DiagnosesIAndII.DSMCode = DiagnosisICD10ICD9Mapping.ICD9Code WHERE DiagnosesIAndII.DocumentVersionId = @DocumentVersionId)
 
 -- Non Mapped ICD Codes 
SELECT   @ToolTip = @ToolTip + DSMD.ICDCode +' - '+DSMD.ICDDescription+ '</br>'
FROM         DiagnosesIIICodes DIII INNER JOIN
                      DiagnosisICDCodes DSMD ON DSMD.ICDCode = DIII.ICDCode
                      LEFT JOIN DiagnosisICD10ICD9Mapping ICDMapping ON DSMD.ICDCode = ICDMapping.ICD9Code
                      
WHERE DIII.DocumentVersionId = @DocumentVersionId  AND DIII.ICDCode NOT IN (SELECT     DiagnosesIIICodes.ICDCode
FROM         DiagnosesIIICodes INNER JOIN
                      DiagnosisICD10ICD9Mapping ON DiagnosesIIICodes.ICDCode = DiagnosisICD10ICD9Mapping.ICD9Code WHERE DiagnosesIIICodes.DocumentVersionId = @DocumentVersionId)

--Mapped DSM Codes                      
SET @MappedDSMCodesToolTip = '' 
SET @MappedDSMCodesToolTip = isnull(REPLACE(REPLACE((SELECT DISTINCT  DSMD.DSMCode +' - '+DSMD.DSMDescription+ '</br>'
FROM         DiagnosesIAndII IAndII INNER JOIN
                      DiagnosisDSMDescriptions DSMD ON (DSMD.DSMCode = IAndII.DSMCode AND DSMD.DSMNumber = IAndII.DSMNumber) 
                      LEFT JOIN DiagnosisICD10ICD9Mapping ICDMapping ON DSMD.DSMCode = ICDMapping.ICD9Code
                      
WHERE IAndII.DocumentVersionId = @DocumentVersionId  AND IAndII.DSMCode IN (SELECT  DISTINCT   DiagnosesIAndII.DSMCode
FROM         DiagnosesIAndII INNER JOIN
                      DiagnosisICD10ICD9Mapping ON DiagnosesIAndII.DSMCode = DiagnosisICD10ICD9Mapping.ICD9Code WHERE DiagnosesIAndII.DocumentVersionId = @DocumentVersionId)
  FOR XML PATH('')  
        ), '&lt;', '<'), '&gt;', '>'), '') 
        
-- Mapped ICD Codes
SET @MappedICDCodesToolTip = ''
SET @MappedICDCodesToolTip = isnull(REPLACE(REPLACE((SELECT DISTINCT  DSMD.ICDCode +' - '+DSMD.ICDDescription+ '</br>'
FROM         DiagnosesIIICodes DIII INNER JOIN
                      DiagnosisICDCodes DSMD ON DSMD.ICDCode = DIII.ICDCode
                      LEFT JOIN DiagnosisICD10ICD9Mapping ICDMapping ON DSMD.ICDCode = ICDMapping.ICD9Code
                      
WHERE DIII.DocumentVersionId = @DocumentVersionId  AND DIII.ICDCode IN (SELECT  DISTINCT   DiagnosesIIICodes.ICDCode
FROM         DiagnosesIIICodes INNER JOIN
                      DiagnosisICD10ICD9Mapping ON DiagnosesIIICodes.ICDCode = DiagnosisICD10ICD9Mapping.ICD9Code WHERE DiagnosesIIICodes.DocumentVersionId = @DocumentVersionId)
FOR XML PATH('')  
        ), '&lt;', '<'), '&gt;', '>'), '') 

IF @ToolTip <> ''
BEGIN
SET @ToolTip = 'Non-mapped ICD codes</br></br>'+@ToolTip 
END
IF @MappedDSMCodesToolTip <> '' OR @MappedICDCodesToolTip <> ''
BEGIN
SELECT @ToolTip + '</br>Mapped ICD codes</br></br>'+ @MappedDSMCodesToolTip + @MappedICDCodesToolTip AS NonMappedICDCOdes
END

END

END

END TRY
BEGIN CATCH                    
   RAISERROR  20006  'ssp_GetNonmappedICDCodes: An Error Occured'                           
   Return                        
 END CATCH 
END