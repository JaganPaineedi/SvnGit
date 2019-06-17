/****** Object:  StoredProcedure [dbo].[ssp_PostUpdateCarePlanProgramDocumentAssignedTasks]    Script Date: 04/20/2017 11:52:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PostUpdateCarePlanProgramDocumentAssignedTasks]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PostUpdateCarePlanProgramDocumentAssignedTasks]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PostUpdateCarePlanProgramDocumentAssignedTasks]    Script Date: 04/20/2017 11:52:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
 
     

 CREATE  PROCEDURE [dbo].[ssp_PostUpdateCarePlanProgramDocumentAssignedTasks]  
   
 @CurrentUserId INT,  
 @ScreenKeyId INT  
AS  
/**********************************************************************/                                                                                          
 /* Stored Procedure: [ssp_PostUpdateCarePlanProgramDocumentAssignedTasks]        */                                                                                 
 /* Creation Date:  23Jan2012                                        */                                                                                          
 /* Purpose: Post Update for Threshold Care Plan Document [Insertions/Updatioons in table DocumentAssignedTasks] */                                            
   /* Input Parameters:   @ScreenKeyId = DocumentId  
       
      @CurrentUserId = LoggedInUserId   */                                                                                      
                                                                                                                                             
 /* Date			Author    Purpose             */      
 /* 20 DEC 2016   Ravi       Created- Insertions/Updations in table DocumentAssignedTasks on Save of records in table CarePlanPrograms */   
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
   
 SELECT @DocumentVersionId = InProgressDocumentVersionId FROM Documents  
 WHERE DocumentId  = @ScreenKeyId  
   
 SELECT @CurrentUser = UserCode  
 FROM STAFF  
 WHERE StaffId = @CurrentUserId  
   
 SELECT @CarePlanProgramId = MIN(CarePlanProgramId)   
 FROM CarePlanPrograms CPT  
 WHERE DocumentVersionId = @DocumentVersionId  

DECLARE DocumentAssignedTask_cursor CURSOR
   FOR
    SELECT CarePlanProgramId  
				 FROM CarePlanPrograms CPT  
				 WHERE DocumentVersionId = @DocumentVersionId  
   
 OPEN DocumentAssignedTask_cursor

   FETCH NEXT FROM DocumentAssignedTask_cursor INTO @CarePlanProgramId
   WHILE @@FETCH_STATUS = 0
   BEGIN
    
   SET @CPTDocumentAssignedTaskId = NULL  
  SET @AssignForContribution = NULL  
    
  SELECT @CPTDocumentAssignedTaskId = DocumentAssignedTaskId  
  ,@AssignForContribution = AssignForContribution   
  FROM CarePlanPrograms CPT  
  WHERE CPT.CarePlanProgramId = @CarePlanProgramId   
    
  IF (@CPTDocumentAssignedTaskId IS NULL AND ISNULL(@AssignForContribution, 'N') = 'Y') 
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
  
   SET @CurrentDocumentAssignedTaskId = @@Identity  
  
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
   
    FETCH NEXT FROM DocumentAssignedTask_cursor INTO @CarePlanProgramId
   END

   CLOSE DocumentAssignedTask_cursor 
 DEALLOCATE DocumentAssignedTask_cursor
   
   
END TRY                                                                          
  
BEGIN CATCH                              
 DECLARE @Error varchar(8000)                                                                        
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                     
 + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_PostUpdateCarePlanProgramDocumentAssignedTasks')                                                                                                         
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


