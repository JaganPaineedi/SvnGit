/****** Object:  StoredProcedure [dbo].[ssp_RDLTransitionCareFamilyHistory]     ******/
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.ROUTINES
		WHERE SPECIFIC_SCHEMA = 'dbo'
			AND SPECIFIC_NAME = 'ssp_RDLTransitionCareFamilyHistory'
		)
	DROP PROCEDURE [dbo].[ssp_RDLTransitionCareFamilyHistory]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLTransitionCareFamilyHistory]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLTransitionCareFamilyHistory] @DocumentVersionId INT
AS
/******************************************************************************                                        
**  File: ssp_RDLTransitionCareFamilyHistory.sql                      
**  Name: ssp_RDLTransitionCareFamilyHistory   3315108                   
**  Desc:                       
**                                        
**  Return values: <Return Values>                                       
**                                         
**  Called by: <Code file that calls>                                          
**                                                      
**  Parameters:   @DocumentVersionId                                     
                  
*******************************************************************************                                        
**  Change History                                        
*******************************************************************************                                        
**  Date:  Author:    Description:                                        
**  -------- --------   -------------------------------------------                   
            
** 17/08/2017 Ravichandra   why: get Family History of client        
         why: Meaningful Use - Stage 3 > Tasks #25.2 Transition of Care - PDF                        
*******************************************************************************/
BEGIN
	SET NOCOUNT ON;

	DECLARE @FromDate DATE
		,@ToDate DATE
	DECLARE @TransitionType CHAR(1)
	DECLARE @ClientId INT

	BEGIN TRY
		SELECT TOP 1 @FromDate = cast(FromDate AS DATE)
			,@ToDate = cast(ToDate AS DATE)
			,@TransitionType = TransitionType
			,@ClientId = D.ClientId
		FROM TransitionOfCareDocuments T
		JOIN Documents D ON D.InProgressDocumentVersionId = T.DocumentVersionId
		WHERE ISNULL(T.RecordDeleted, 'N') = 'N'
			AND DocumentVersionId = @DocumentVersionId
			AND ISNULL(D.RecordDeleted, 'N') = 'N'

		DECLARE @LatestDocumentVersionIdForFamilyHistory INT

		SELECT TOP 1 @LatestDocumentVersionIdForFamilyHistory = a.CurrentDocumentVersionid
		FROM Documents a
		INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeid = a.DocumentCodeid
		WHERE a.ClientId = @ClientId
			AND a.[Status] = 22
			AND Dc.DocumentCodeid = 1600 --Family History  
			AND CAST(a.EffectiveDate AS DATE) BETWEEN CAST(@FromDate AS DATE)
				AND CAST(@ToDate AS DATE)
			AND ISNULL(a.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(Dc.RecordDeleted, 'N') <> 'Y'
		ORDER BY a.EffectiveDate DESC
			,a.ModifiedDate DESC

		SELECT CFH.CurrentAge
			,GC.CodeName AS FamilyMemberTypeName
			,CFH.DiseaseConditionDXCodeDescription AS DiseaseCondition
			,CASE 
				WHEN CFH.IsLiving = 'Y'
					THEN 'Yes'
				WHEN CFH.IsLiving = 'N'
					THEN 'No'
				ELSE 'Unknown'
				END AS IsLivingDesc
			,CFH.ICD9Code
			,CFH.ICD10CodeId
			,CFH.SNOMEDCODE
			,SNC.SNOMEDCTDescription
		FROM DocumentFamilyHistory CFH
		LEFT JOIN GlobalCodes GC ON CFH.FamilyMemberType = GC.GlobalCodeId
			AND ISNull(GC.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes GCC ON CFH.CancerType = GCC.GlobalCodeId
			AND ISNull(GCC.RecordDeleted, 'N') = 'N'
		LEFT JOIN SNOMEDCTCodes AS SNC ON SNC.SNOMEDCTCode = CFH.SNOMEDCODE
		LEFT JOIN Documents D ON CFH.DocumentVersionId = D.CurrentDocumentVersionId
			AND ISNull(D.RecordDeleted, 'N') = 'N'
		WHERE DocumentVersionId = @LatestDocumentVersionIdForFamilyHistory
			AND ISNull(CFH.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLTransitionCareFamilyHistory') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                     
				16
				,-- Severity.                                                                         
				1 -- State.                                                                         
				);
	END CATCH
END
