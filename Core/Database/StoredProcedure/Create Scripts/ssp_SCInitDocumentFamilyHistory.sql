/****** Object:  StoredProcedure [dbo].[ssp_SCInitDocumentFamilyHistory]    Script Date: 08/28/2017 13:27:43 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCInitDocumentFamilyHistory]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCInitDocumentFamilyHistory]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCInitDocumentFamilyHistory]    Script Date: 08/28/2017 13:27:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCInitDocumentFamilyHistory] (
	@ClientID INT
	,@StaffID INT
	,@CustomParameters XML
	)
AS
/*************************************************************/
/* Stored Procedure: ssp_SCInitDocumentFamilyHistory	     */
/* Creation Date:	 14 Nov 2013						     */
/* Input Parameters: @ClientID,@StaffID,@CustomParameters    */
/* Author:			 Gayathri Naik							 */
/* Purpose:			 Used to initialize the Family History 
					 Health Documents						 */
/* Modified By		 Gayathri Naik			11/26/2013		 */
/*					 CancerType column included to bind the 
					 Cancer Dropdown					
					 	 
-- Aug 02 2018		Chethan N		What : Retrieving Comments. 
--									Why : Engineering Improvement Initiatives- NBL(I) task# 698.*/
/*************************************************************/
BEGIN TRY
	BEGIN
		--------------------FamilyHistory  ---------------- 
		DECLARE @LatestDocumentVersionID INT

		SET @LatestDocumentVersionID = (
				SELECT TOP 1 CurrentDocumentVersionId
				FROM Documents a
				INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeid = a.DocumentCodeid
				WHERE a.ClientId = @ClientID
					AND a.EffectiveDate <= convert(DATETIME, convert(VARCHAR, getDate(), 101))
					AND a.STATUS = 22
					AND a.DocumentCodeId = 1600
					AND isNull(a.RecordDeleted, 'N') <> 'Y'
					AND isNull(Dc.RecordDeleted, 'N') <> 'Y'
				ORDER BY a.EffectiveDate DESC
					,a.ModifiedDate DESC
				)

		SELECT 'DocumentFamilyHistory' AS TableName
			,CFH.DocumentFamilyHistoryId
			,CFH.CreatedBy
			,CFH.CreatedDate
			,CFH.ModifiedBy
			,CFH.ModifiedDate
			,CFH.RecordDeleted
			,CFH.DeletedBy
			,CFH.DeletedDate
			,CFH.DocumentVersionId
			,CFH.FamilyMemberType
			,CFH.IsLiving
			,CFH.CurrentAge
			,CFH.CauseOfDeath
			,CFH.Hypertension
			,CFH.Hyperlipidemia
			,CFH.Diabetes
			,CFH.DiabetesType1
			,CFH.DiabetesType2
			,CFH.Alcoholism
			,CFH.COPD
			,CFH.Depression
			,CFH.ThyroidDisease
			,CFH.CoronaryArteryDisease
			,CFH.Cancer
			,CFH.Other
			,CFH.CancerType
			--,STUFF((case when isnull(Hypertension,'N')='Y' then ',Hypertension' else '' end) 
			--+(case when isnull(Hyperlipidemia,'N')='Y' then ',Hyperlipidemia' else '' end)
			--+(case when isnull(Diabetes,'N')='Y' then ',Diabetes ' else '' end) 
			--+ (case when isnull(DiabetesType1,'N')='Y' then case when isnull(DiabetesType2,'N')='Y'then  '(Type1,Type2)' else '(Type1)' end  else  Case when isnull(DiabetesType2,'N')='Y' then  '(Type2)' else '' end  end)
			--+(case when isnull(Alcoholism,'N')='Y' then ',Alcoholism'  else '' end)
			--+(case when isnull(COPD,'N')='Y' then ',COPD'  else '' end)
			--+(case when isnull(Depression,'N')='Y' then ',Depression'  else '' end)
			--+(case when isnull(ThyroidDisease,'N')='Y' then ',ThyroidDisease'  else '' end)
			--+(case when isnull(CoronaryArteryDisease,'N')='Y' then ',CoronaryArteryDisease'  else '' end)
			--+(case when ISNULL(Cancer,'N')='y' then ',Cancer ('+(select CodeName from  GlobalCodes where Category = 'FamilyHistoryCancer' 
			--and GlobalCodeId = CancerType )+')'  else '' end)
			--+(case when isnull(Other,'N')='Y' then',Other'+'('+convert(varchar(max),OtherComment)+')'  else '' end),1,1,'') as DiseaseCondition
			,CFH.ICD9Code
			,I.ICD10Code AS DiseaseConditionDXCode
			,SNC.SNOMEDCTCode AS SNOMEDCODE
			,SNC.SNOMEDCTDescription AS SNOMEDCTDescription
			,I.ICDDescription AS DiseaseConditionDXCodeDescription
			,dbo.csf_GetGlobalCodeNameById(FamilyMemberType) AS 'FamilyMemberTypeText'
			,IsLivingValue = CASE CFH.IsLiving
				WHEN 'Y'
					THEN 'Yes'
				WHEN 'N'
					THEN 'No'
				WHEN 'U'
					THEN 'Unknown'
				END
			,CFH.OtherComment
			,CFH.ICD10CodeId
			,CFH.Comments
		FROM DocumentFamilyHistory CFH
		LEFT JOIN DiagnosisICD10Codes I ON I.ICD10CodeId = CFH.ICD10CodeId
			AND ISNull(I.RecordDeleted, 'N') = 'N'
		LEFT JOIN SNOMEDCTCodes AS SNC ON SNC.SNOMEDCTCode = CFH.SNOMEDCODE
		WHERE CFH.DocumentVersionId = @LatestDocumentVersionID
			AND ISNULL(CFH.RecordDeleted, 'N') = 'N'
	END
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCInitDocumentFamilyHistory') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(VARCHAR, 
			ERROR_SEVERITY()) + '*****ERROR_STATE=' + Convert(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error /* Message text*/
			,16 /*Severity*/
			,1 /*State*/
			)
END CATCH
GO


