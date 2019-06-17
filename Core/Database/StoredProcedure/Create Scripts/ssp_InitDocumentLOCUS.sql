/****** Object:  StoredProcedure [dbo].[ssp_InitDocumentLOCUS]    Script Date: 01/29/2015 17:40:09 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitDocumentLOCUS]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_InitDocumentLOCUS]
GO

/****** Object:  StoredProcedure [dbo].[ssp_InitDocumentLOCUS]    Script Date: 01/29/2015 17:40:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_InitDocumentLOCUS] (
	@ClientID INT
	,@StaffID INT
	,@CustomParameters XML
	)
AS
/******************************************************************************                                                
**  File: ssp_InitDocumentLOCUS                                            
**  Name: ssp_InitDocumentLOCUS                        
**  Desc: To Initialize Locus Document                                                             
**  Called by:                                                 
**  Parameters:                            
**  Auth:  Ponnin selvan                              
**  Date:  March 10 2016
/* What : created Locus Document		*/
/* whay : Task #41 Network 180 - Customizations                              */
*******************************************************************************                                                
**  Change History                                          
*******************************************************************************                                          
**  Date:			Author:			Description:                                    
	03 Nov 2016		Alok Kumar		Added three new fields to the DocumentLOCUS table for task#340 CEI - Support Go Live.
	
*******************************************************************************/ 
BEGIN
	BEGIN TRY
	
		
		
-------------------------------------------------------------------------
-- To get the latest DocumentVersionId 
--------------------------------------------------------------------------
 
  DECLARE @LatestDocumentVersionID int  
  DECLARE @ActualDisposition int
  DECLARE @CurrentLevelOfCare varchar(500)

	SET @LatestDocumentVersionID = (  
	SELECT TOP 1 CurrentDocumentVersionId  
	FROM DocumentLOCUS DL  
	INNER JOIN Documents Doc ON DL.DocumentVersionId = Doc.CurrentDocumentVersionId  
	WHERE Doc.ClientId = @ClientID AND Doc.[Status] = 22  
	AND ISNULL(DL.RecordDeleted, 'N') = 'N'  
	AND ISNULL(Doc.RecordDeleted, 'N') = 'N'  
	ORDER BY Doc.EffectiveDate DESC  
	,Doc.ModifiedDate DESC  
) 

	SELECT @ActualDisposition = ActualDisposition
		   FROM DocumentLOCUS  WHERE (ISNULL(RecordDeleted, 'N') = 'N') 
		   AND DocumentVersionId = @LatestDocumentVersionID	
	
	IF(@ActualDisposition >0)
		BEGIN
			Select @CurrentLevelOfCare= CodeName 
				from GlobalCodes where GlobalCodeId=@ActualDisposition AND ISNULL(RecordDeleted, 'N') = 'N'
		END
	ELSE 
		BEGIN
			SET @CurrentLevelOfCare='None'
		END
		
		
		
		SELECT 'DocumentLOCUS' AS TableName
			,- 1 AS 'DocumentVersionId'
			,CBTA.CreatedBy
			,CBTA.CreatedDate
			,CBTA.ModifiedBy
			,CBTA.ModifiedDate
			,CBTA.RecordDeleted
			,CBTA.DeletedDate
			,CBTA.DeletedBy
			,@CurrentLevelOfCare As CurrentLevelOfCare
		FROM systemconfigurations SC
		LEFT JOIN DocumentLOCUS CBTA ON SC.DatabaseVersion = - 1

		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_InitDocumentLOCUS') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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

