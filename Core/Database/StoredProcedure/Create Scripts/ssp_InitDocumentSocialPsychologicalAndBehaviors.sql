/****** Object:  StoredProcedure [dbo].[ssp_InitDocumentSocialPsychologicalAndBehaviors]    Script Date: 07/04/2017 17:40:09 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitDocumentSocialPsychologicalAndBehaviors]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_InitDocumentSocialPsychologicalAndBehaviors]
GO

/****** Object:  StoredProcedure [dbo].[ssp_InitDocumentSocialPsychologicalAndBehaviors]    Script Date: 07/04/2017 17:40:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_InitDocumentSocialPsychologicalAndBehaviors] (
	@ClientID INT
	,@StaffID INT
	,@CustomParameters XML
	)
AS
/******************************************************************************                                                
**  File: ssp_InitDocumentSocialPsychologicalAndBehaviors.sql                                       
**  Name: ssp_InitDocumentSocialPsychologicalAndBehaviors                        
**  Desc: Creating new document page(Social, Psychological, And Behaviors)                                              
**  Auth:  Vijay                             
**  Date:  Jul 04 2017
*******************************************************************************                                                
**  Change History                                          
*******************************************************************************/                                       
 
BEGIN
	BEGIN TRY	

	-- DocumentSocialPsychologicalAndBehaviors
		SELECT 'DocumentSocialPsychologicalAndBehaviors' AS TableName
			,- 1 AS 'DocumentVersionId'
			,DSPAB.CreatedBy
			,DSPAB.CreatedDate
			,DSPAB.ModifiedBy
			,DSPAB.ModifiedDate
			,DSPAB.RecordDeleted
			,DSPAB.DeletedDate
			,DSPAB.DeletedBy
		FROM systemconfigurations SC
		LEFT JOIN DocumentSocialPsychologicalAndBehaviors DSPAB ON SC.DatabaseVersion = - 1
		
		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_InitDocumentSocialPsychologicalAndBehaviors') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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

