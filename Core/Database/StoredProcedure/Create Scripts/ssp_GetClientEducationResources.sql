
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetClientEducationResources]    Script Date: 06/13/2015 16:48:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClientEducationResources]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetClientEducationResources]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_GetClientEducationResources]    Script Date: 06/13/2015 16:48:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************                    
**  File: ssp_GetClientEducationResources.sql  
**  Name: ssp_GetClientEducationResources  
**  Desc: Gets education resources relevant to passed ClientId  
**                    
**  Return values: Dataset  
**                     
**  Called by: <Code file that calls>                      
**                                  
**  Parameters:                    
**  Input   Output                    
**  ----------      -----------                    
**                    
**  Crated By: Chuck Blaine  
**  Date:  Feb 10 2014  
*******************************************************************************                    
**  Change History                    
*******************************************************************************                    
**  Date:   Author:    Description:                    
**  --------  --------    -------------------------------------------       
 09/July/2014    Gautam      Included RecordDeleted check in all tables Ref. Task no   
         Primary Care - Summit Pointe: #188 Education Resources Tag    
** 15/Oct/2014   PPOTNURU      Modified Table Names  
** 09/Jul/2017	 Chethan N		What : Changes to support ICD10.
								Why : Engineering Improvement Initiatives- NBL(I) task #654.
*******************************************************************************/
CREATE PROCEDURE [dbo].[ssp_GetClientEducationResources] @ClientId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from  
	-- interfering with SELECT statements.  
	SET NOCOUNT ON;

	BEGIN TRY
		-- Medications Type  
		SELECT cer.EducationResourceId AS ClientEducationResourceId
			,cer.Description
			,cer.DocumentType
			,CASE 
				WHEN cer.ResourcePDF IS NULL
					THEN 'N'
				ELSE 'Y'
				END AS HasResourcePDF
			,cer.ResourceURL
			,cer.ResourceReportId
		FROM dbo.EducationResources AS cer
		LEFT JOIN dbo.EducationResourceMedications AS cerm ON (cerm.EducationResourceId = cer.EducationResourceId)
			AND Isnull(cerm.RecordDeleted, 'N') = 'N'
		WHERE Isnull(cer.RecordDeleted, 'N') = 'N'
			AND cer.InformationType = 'M'
			AND (
				EXISTS (
					SELECT 1
					FROM dbo.ClientMedications AS cm
					WHERE ClientId = @ClientId
						AND cm.MedicationNameId = cerm.MedicationNameId
						AND Isnull(cm.RecordDeleted, 'N') = 'N'
					)
				OR cer.AllMedications = 'Y'
				)
		
		UNION ALL
		
		-- Diagnosis Type            
		SELECT cer.EducationResourceId AS ClientEducationResourceId
			,cer.Description
			,cer.DocumentType
			,CASE 
				WHEN cer.ResourcePDF IS NULL
					THEN 'N'
				ELSE 'Y'
				END AS HasResourcePDF
			,cer.ResourceURL
			,cer.ResourceReportId
		FROM dbo.EducationResources AS cer
		LEFT JOIN dbo.EducationResourceDiagnoses AS cerd ON (cerd.EducationResourceId = cer.EducationResourceId)
			AND Isnull(cerd.RecordDeleted, 'N') = 'N'
		WHERE Isnull(cer.RecordDeleted, 'N') = 'N'
			AND cer.InformationType = 'D'
			AND (
				EXISTS (
					SELECT 1
					FROM dbo.DiagnosesIAndII AS diai
					INNER JOIN dbo.DocumentVersions AS dv ON dv.DocumentVersionId = diai.DocumentVersionId
						AND Isnull(diai.RecordDeleted, 'N') = 'N'
						AND Isnull(dv.RecordDeleted, 'N') = 'N'
					INNER JOIN dbo.Documents AS d ON d.DocumentId = d.DocumentId
						AND Isnull(d.RecordDeleted, 'N') = 'N'
					WHERE d.ClientId = @ClientId
						AND diai.DSMCode = cerd.DSMCode
						AND diai.DSMNumber = cerd.DSMNumber
					)
				OR EXISTS (
					SELECT 1
					FROM dbo.DiagnosesIIICodes AS dic
					INNER JOIN dbo.DocumentVersions AS dv ON dv.DocumentVersionId = dic.DocumentVersionId
						AND Isnull(dic.RecordDeleted, 'N') = 'N'
						AND Isnull(dv.RecordDeleted, 'N') = 'N'
					INNER JOIN dbo.Documents AS d ON d.DocumentId = d.DocumentId
						AND Isnull(d.RecordDeleted, 'N') = 'N'
					WHERE d.ClientId = @ClientId
						AND dic.ICDCode = cerd.ICD9Code
					)
					
				OR EXISTS (
					SELECT 1
					FROM dbo.DocumentDiagnosisCodes AS ddc
					INNER JOIN dbo.DocumentVersions AS dv ON dv.DocumentVersionId = ddc.DocumentVersionId
						AND Isnull(ddc.RecordDeleted, 'N') = 'N'
						AND Isnull(dv.RecordDeleted, 'N') = 'N'
					INNER JOIN dbo.Documents AS d ON d.DocumentId = d.DocumentId
						AND Isnull(d.RecordDeleted, 'N') = 'N'
					WHERE d.ClientId = @ClientId
						AND ((ddc.ICD9Code = cerd.ICD9Code) OR (ddc.ICD10Code = cerd.ICD10Code))
					)	
				OR cer.AllDiagnoses = 'Y'
				)
		
		UNION ALL
		
		-- Health Data (Vitals) Type  
		SELECT cer.EducationResourceId AS ClientEducationResourceId
			,cer.Description
			,cer.DocumentType
			,CASE 
				WHEN cer.ResourcePDF IS NULL
					THEN 'N'
				ELSE 'Y'
				END AS HasResourcePDF
			,cer.ResourceURL
			,cer.ResourceReportId
		FROM dbo.EducationResources AS cer
		WHERE Isnull(cer.RecordDeleted, 'N') = 'N'
			AND cer.InformationType = 'H'
		ORDER BY Description
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetClientEducationResources') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                 
				16
				,-- Severity.                                                        
				1 -- State.                                                     
				);
	END CATCH
END
GO

