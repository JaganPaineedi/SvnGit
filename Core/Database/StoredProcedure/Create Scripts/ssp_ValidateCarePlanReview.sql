IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ValidateCarePlanReview]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_ValidateCarePlanReview]
GO
CREATE PROCEDURE [dbo].[ssp_ValidateCarePlanReview] --1160 --475                  
	(@DocumentVersionId INT)
AS

/****************************************************************************** 
**  Change History                      
*******************************************************************************                      
**  Date:      Author:  Purpose:      Description:                      
**  ---------  --------  ----------    -------------------------------------------                      
**  22-Nov-2016	Bibhu	What: Calling SCSP_SCValidateDocumentEffectiveDatePlanReview  for Effective Date Validation         
**						Why:task #197 Bradford - Customizations
*******************************************************************************/   
BEGIN
	BEGIN TRY
		-- Declare Variables        
		DECLARE @DocumentType VARCHAR(10)
		-- Get ClientId        
		DECLARE @ClientId INT
		DECLARE @EffectiveDate DATETIME
		DECLARE @StaffId INT

		SELECT @ClientId = d.ClientId
		FROM Documents d
		WHERE d.InProgressDocumentVersionId = @DocumentVersionId

		SELECT @StaffId = d.AuthorId
			,@EffectiveDate = D.EffectiveDate
		FROM Documents d
		WHERE d.InProgressDocumentVersionId = @DocumentVersionId

		IF ISNULL(@EffectiveDate, '') = ''
			SET @EffectiveDate = CONVERT(DATETIME, convert(VARCHAR, getdate(), 101))

		CREATE TABLE #ValidationTable (
			TableName VARCHAR(500)
			,ColumnName VARCHAR(500)
			,ErrorMessage VARCHAR(MAX)
			,TabOrder INT
			,ValidationOrder DECIMAL
			,GoalNumber DECIMAL
			,ObjectiveNumber DECIMAL(8,2)
			)

		INSERT INTO #ValidationTable
		SELECT 'DocumentCarePlanReviews'
			,'ProgressTowardsObjective'
			,'Care Plan Review - Objective  #' + convert(VARCHAR, ObjectiveNumber) + '- Rating of progress towards objective is required'
			,1
			,1
			,GoalNumber
			,ObjectiveNumber
		FROM DocumentCarePlanReviews
		WHERE DocumentVersionId = @DocumentVersionId
			AND ISNULL(ProgressTowardsObjective, '') = ''
			AND ISNULL(ObjectiveNumber, - 1) <> - 1
			AND ISNULL(RecordDeleted, 'N') = 'N'
		
		UNION
		SELECT 'DocumentCarePlanReviews'
			,'ObjectiveReview'
			,'Care Plan Review - Objective  #' + convert(VARCHAR, ObjectiveNumber) + '- Objective Review is required'
			,1
			,2
			,GoalNumber
			,ObjectiveNumber
		FROM DocumentCarePlanReviews
		WHERE DocumentVersionId = @DocumentVersionId
			AND ISNULL(ObjectiveReview, '') = ''
			AND ISNULL(ObjectiveNumber, - 1) <> - 1
			AND ISNULL(RecordDeleted, 'N') = 'N'
	   -----22-Nov-2016	Bibhu		
			 IF EXISTS ( SELECT  *  
            FROM    sys.objects  
            WHERE   object_id = OBJECT_ID(N'SCSP_SCValidateDocumentEffectiveDatePlanReview')  
                    AND type IN ( N'P', N'PC' ) ) 
           BEGIN
		EXEC SCSP_SCValidateDocumentEffectiveDatePlanReview @DocumentVersionId  
		   END

		SELECT TableName
			,ColumnName
			,ErrorMessage
			,TabOrder
			,ValidationOrder
			,GoalNumber
			,ObjectiveNumber
		FROM #ValidationTable
		ORDER BY TabOrder
		    ,GoalNumber
			,ObjectiveNumber
			,ValidationOrder
		   
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_ValidateCarePlanReview') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                          
				16
				,-- Severity.                                                                                  
				1 -- State.                                                                                                          
				);
	END CATCH
END