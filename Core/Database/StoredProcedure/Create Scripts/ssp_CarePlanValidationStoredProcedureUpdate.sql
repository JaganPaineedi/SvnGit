
/****** Object:  StoredProcedure [dbo].[ssp_CarePlanValidationStoredProcedureUpdate]    Script Date: 01/27/2012 09:32:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CarePlanValidationStoredProcedureUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CarePlanValidationStoredProcedureUpdate]
GO


/****** Object:  StoredProcedure [dbo].[ssp_CarePlanValidationStoredProcedureUpdate]    Script Date: 01/27/2012 09:32:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE  PROCEDURE [dbo].[ssp_CarePlanValidationStoredProcedureUpdate] 	
	@CurrentUserId INT,
	@ScreenKeyId INT
AS
/**********************************************************************/                                                                                        
 /* Stored Procedure: [csp_CarePlanPostUpdate]						  */                                                                               
 /* Creation Date:  23Jan2012                                        */                                                                                        
 /* Purpose: Post Update for Threshold Care Plan Document [Insertions/Updatioons in table DocumentAssignedTasks] */                                              /* Input Parameters:   @ScreenKeyId = DocumentId
						@StaffId     = AuthorId
						@CurrentUserId = LoggedInUserId	
						@CustomParameters = custom params from custom screens */                                                                                      
 /* Output Parameters:											      */                                                                                        
 /* Return:															  */                                                                                        
 /* Called By: Threshold Care Plan Document				              */                                                                              
 /* Calls:                                                            */                                                                                        
 /*                                                                   */                                                                                        
 /* Data Modifications:                                               */                                                                                        
 /* Updates:                                                          */                                                                                        
 /* Date		Author		  Purpose											  */    
 /* 23Jan2012   Shifali		  Created- Insertions/Updations in table DocumentAssignedTasks on Save of records in table CarePlanPrograms */ 
 /* 23Jan2012   Shifali		  Modified- Included @AssignForContribution ='N' while updations in DocumentAssignedTasks  */ 
 /* 27Jan2012   Shifali		  Modified- Updated DocumentAssignedTaskId to NULL when setting DocumentAssignedTasks.RecordDeleted = 'Y' */
 /* 07June2012  Vikas Kashyap Modified- Complete Status Changed According to condition w.r.t. Task#1158 Threshold */
 /*********************************************************************/  
BEGIN
BEGIN TRY
	DECLARE @DocumentVersionId INT
	DECLARE @RowCount INT
	DECLARE @CarePlanProgramId INT
	DECLARE @CurrentDocumentAssignedTaskId INT
	DECLARE @CPTDocumentAssignedTaskId INT
	DECLARE @CurrentUser VARCHAR(30)
	DECLARE @AssignForContribution CHAR(1)
	
	--Set DOc VersionId
	SELECT @DocumentVersionId = InProgressDocumentVersionId FROM Documents
	WHERE DocumentId  = @ScreenKeyId
	
	SELECT @CurrentUser = UserCode
	FROM STAFF
	WHERE StaffId = @CurrentUserId
	
	SELECT @CarePlanProgramId = MIN(CarePlanProgramId) 
	FROM CarePlanPrograms CPT
	WHERE DocumentVersionId = @DocumentVersionId
	--AND ISNULL(AssignForContribution, 'N') = 'Y'
	
	WHILE @CarePlanProgramId IS NOT NULL
	BEGIN	
		SET @CPTDocumentAssignedTaskId = NULL
		SET @AssignForContribution = NULL
		
		SELECT @CPTDocumentAssignedTaskId = DocumentAssignedTaskId
		,@AssignForContribution = AssignForContribution 
		FROM CarePlanPrograms CPT
		WHERE CPT.CarePlanProgramId = @CarePlanProgramId 
		
		IF (@CPTDocumentAssignedTaskId IS NULL AND ISNULL(@AssignForContribution, 'N') = 'Y') /*Insert into Table DocumentAssignedTasks*/
		BEGIN
			INSERT INTO DocumentAssignedTasks
			(DocumentVersionId,
			StaffId,
			AssignmentStatus,
			DateTimeAssigned,
			DateTimeCompleted,
			CreatedBy,
			CreatedDate,
			ModifiedBy,
			ModifiedDate,
			RecordDeleted)
			SELECT
			@DocumentVersionId,			
			StaffId,
			CASE WHEN ISNULL(Completed,'N') <> 'Y' THEN 6823 --Old 6822
				 WHEN ISNULL(Completed,'N') = 'Y' THEN 6822  --Old 6823
			END,
			GETDATE(),
			CASE WHEN ISNULL(Completed,'N') <> 'Y' THEN NULL
				 WHEN ISNULL(Completed,'N') = 'Y' THEN GETDATE()
			END,
			@CurrentUser,
			GETDATE(),
			@CurrentUser,
			GETDATE(),
			RecordDeleted			
			FROM CarePlanPrograms CPT
			WHERE CPT.CarePlanProgramId = @CarePlanProgramId 
			--Get newly inserted Pk
			SET @CurrentDocumentAssignedTaskId = @@Identity
			--Update Column DocumentAssignedTaskId in Care Plan Teams table
			UPDATE CarePlanPrograms
			SET DocumentAssignedTaskId = @CurrentDocumentAssignedTaskId		
			WHERE CarePlanProgramId = @CarePlanProgramId
			AND ISNULL(AssignForContribution, 'N') = 'Y' 
			 
		END		
		ELSE
		BEGIN
			IF(@AssignForContribution = 'N')
			BEGIN
				UPDATE DocumentAssignedTasks 
				SET RecordDeleted = 'Y'
				WHERE DocumentAssignedTaskId = @CPTDocumentAssignedTaskId
				
				UPDATE CarePlanPrograms 
				SET DocumentAssignedTaskId = NULL
				WHERE CarePlanProgramId = @CarePlanProgramId
				
			END
			ELSE
			BEGIN
				UPDATE DocumentAssignedTasks
				SET StaffId = CPT.StaffId,
				AssignmentStatus = CASE WHEN ISNULL(Completed,'N') <> 'Y' THEN 6823 --Old 6822
					 WHEN ISNULL(Completed,'N') = 'Y' THEN 6822 --Old 6823
				END,			
				DateTimeCompleted = CASE WHEN ISNULL(Completed,'N') <> 'Y' THEN NULL
					 WHEN ISNULL(Completed,'N') = 'Y' THEN GETDATE()
				END,
				ModifiedBy = CPT.ModifiedBy,
				ModifiedDate = CPT.ModifiedDate,
				RecordDeleted = CPT.RecordDeleted					
				FROM CarePlanPrograms CPT
				JOIN DocumentAssignedTasks DAT
				ON CPT.DocumentAssignedTaskId = DAT.DocumentAssignedTaskId
				WHERE CPT.CarePlanProgramId = @CarePlanProgramId 
			END
		END
		
		SELECT @CarePlanProgramId =  MIN(CPT.CarePlanProgramId) 
		FROM CarePlanPrograms CPT
		WHERE CPT.DocumentVersionId = @DocumentVersionId
		/*AND ISNULL(CPT.AssignForContribution, 'N') = 'Y'*/
		/*AND ISNULL(CPT.RecordDeleted,'N') <> 'Y'*/
		AND CPT.CarePlanProgramId > @CarePlanProgramId

	END
	
END TRY                                                                        

BEGIN CATCH                            
	DECLARE @Error varchar(8000)                                                                      
	SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                   
	+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_CarePlanPostUpdate')                                                                                                       
	+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                        
	+ '*****' + Convert(varchar,ERROR_STATE())                                                    
	RAISERROR                                                                                                       
	(                                                                         
	@Error, -- Message text.     
	16, -- Severity.     
	1 -- State.                                                       
	);                                                                                                    
END CATCH
END


GO


