/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomClientDemographics]    Script Date: 06/30/2014 18:07:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCommercialIndividualServiceNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCommercialIndividualServiceNote] 

/****** Object:  StoredProcedure [dbo].[csp_SCGetCommercialIndividualServiceNote]    Script Date: 06/30/2014 18:07:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_SCGetCommercialIndividualServiceNote] @DocumentVersionId INT
AS
/**************************************************************  
Created By   : Vamsi
Created Date : 06Mar 2015 
Description  : Used to Retrive Data for Commercial Individual Service Note
Called From  : Commercial Assessment
/*  Date			  Author				  Description */
/*  06 Mar 2015		  Vamsi				  Created    */

**************************************************************/
BEGIN
	BEGIN TRY
		 SELECT  CCISA.DocumentVersionId
				,CCISA.CreatedBy
				,CCISA.CreatedDate
				,CCISA.ModifiedBy
				,CCISA.ModifiedDate
				,CCISA.RecordDeleted
				,CCISA.DeletedBy
				,CCISA.DeletedDate
				,CCISA.SituationInterventionPlan
				,CCISA.AddressProgressToGoal
		FROM CustomDocumentCommercialIndividualServiceNotes  as  CCISA
		WHERE CCISA.DocumentVersionId = @DocumentVersionId
		AND isnull(CCISA.RecordDeleted, 'N') = 'N'		

	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_SCGetCommercialIndividualServiceNote') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


