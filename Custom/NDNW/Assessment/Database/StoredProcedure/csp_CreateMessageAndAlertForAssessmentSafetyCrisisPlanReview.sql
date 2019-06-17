  /****** Object:  StoredProcedure [dbo].[csp_CreateMessageAndAlertForAssessmentSafetyCrisisPlanReview]    Script Date: 12/08/2014 12:45:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_CreateMessageAndAlertForAssessmentSafetyCrisisPlanReview]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_CreateMessageAndAlertForAssessmentSafetyCrisisPlanReview]
GO

/****** Object:  StoredProcedure [dbo].[csp_CreateMessageAndAlertForAssessmentSafetyCrisisPlanReview]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_CreateMessageAndAlertForAssessmentSafetyCrisisPlanReview] --  11                         
 (@DocumentVersionId INT,@CurrentUserId INT)  
AS  
/******************************************************************** */      
/* Stored Procedure: [CreateMessageAndAlertForSafetyCrisisPlanReview]               */      
/* Creation Date:  03/MAR/2015                                    */      
/* Purpose: To Initialize */      
/* Input Parameters:  */      
/* Output Parameters:                                */      
/* Return:   */      
     
/*                                                                   */      
/* Data Modifications:                                               */      
/*   Updates:                                                          */      
/*  19/MAR/2015  Revathi  Post update SP for CreateMessageAndAlertForSafetyCrisisPlanReview
     Task 969 Valley Customizations */   
/*  19/MAR/2015  SuryaBalan Fixed Alert and Messages Description for Task 969 */   
/***********************************************************************/   
BEGIN  
 BEGIN TRY  
  DECLARE @ClientId INT  
  DECLARE @AssignedTo INT    
  DECLARE @DocumentCodeId INT  
  DECLARE @EffectiveDate DATETIME  
  DECLARE @DocumentId INT    
  DECLARE @ClientName VARCHAR(MAX)  
  DECLARE @CarePlanDocumentVersionId INT  
  DECLARE @NextCrisisPlanReviewDate DATETIME  
  DECLARE @NextSafetyPlanReviewDate DATETIME  
  DECLARE @CrisisPlanReviewDays INT  
  DECLARE @SafetyPlanReviewDays INT  
    
  CREATE TABLE #StaffTable   
  (StaffId INT)  
   
  
  
  SELECT @ClientId = ClientId  
   ,@EffectiveDate = EffectiveDate  
   ,@DocumentCodeId = DocumentCodeId  
   ,@AssignedTo = AuthorId  
   ,@DocumentId = DocumentId  
  FROM Documents  
  WHERE CurrentDocumentVersionid = @DocumentVersionId AND ISNULL(RecordDeleted,'N')='N'  
       
  SELECT TOP 1 @ClientName = LastName + ', ' + FirstName  
  FROM Clients  
  WHERE ClientId = @ClientId  
    
  SELECT TOP 1 @CarePlanDocumentVersionId=CurrentDocumentVersionId from Documents where DocumentcodeId =1620 AND Status=22 AND ClientId=@ClientId AND ISNULL(RecordDeleted,'N')='N' Order BY EffectiveDate desc  
  
  INSERT INTO #StaffTable (StaffId)  
  SELECT StaffId  
  FROM CarePlanPrograms  
  WHERE DocumentVersionId = @CarePlanDocumentVersionId     
   AND ISNULL(RecordDeleted,'N') = 'N'  
    
    
  SELECT @NextCrisisPlanReviewDate=NextCrisisPlanReviewDate FROM   
  CustomDocumentStandAloneSafetyCrisisPlans WHERE DocumentVersionId=@DocumentVersionId  
  AND ISNULL(RecordDeleted,'N')='N'  
    
    
  SELECT @NextSafetyPlanReviewDate=NextSafetyPlanReviewDate FROM   
  CustomSafetyCrisisPlanReviews WHERE DocumentVersionId=@DocumentVersionId  
  AND ISNULL(RecordDeleted,'N')='N'  
    
    
  SET @CrisisPlanReviewDays=DATEDIFF(HH, @NextCrisisPlanReviewDate,GETDATE())  
    
    
  SET @SafetyPlanReviewDays=DATEDIFF(HH, @NextSafetyPlanReviewDate,GETDATE())  
    
--select  top 10 ReviewCrisisPlanXDays,NextCrisisPlanReviewDate,* from CustomDocumentStandAloneSafetyCrisisPlans order by 1 desc--crisis  
  
--select  top 10 ReviewEveryXDays, SafetyCrisisPlanReviewed,NextSafetyPlanReviewDate, * from CustomSafetyCrisisPlanReviews order by 1 desc--safety  40033  
     
        IF(@CrisisPlanReviewDays  IS NOT NULL AND @CrisisPlanReviewDays<=7)  
        BEGIN  
  INSERT INTO [Messages] (  
   [FromStaffId]  
   ,[ToStaffId]  
   ,[ClientId]  
   ,[Unread]  
   ,[DateReceived]  
   ,[Subject]  
   ,[Message]  
   ,[DocumentId]  
   ,[Priority]  
   ,[ReferenceType]  
   ,[ReferenceId]  
   ,[Reference]  
   ,[ReferenceLink]  
   )  
   SELECT @CurrentUserId  
   ,StaffId  
   ,@ClientId  
   ,'Y'  
   ,GETDATE()  
   ,'Safety Crisis Plan Document'  
   ,'Review Crisis Plan is due ' + CONVERT(varchar,@NextCrisisPlanReviewDate,101)    
   ,@DocumentId  
   ,60  
      ,5854  
      ,@DocumentId  
      ,(SELECT TOP 1 (DocumentName) FROM DocumentCodes WHERE DocumentCodeId = 10018)  
      ,@DocumentId  
  FROM #StaffTable    
  
  INSERT INTO [Alerts] (  
    [ToStaffId]  
   ,[ClientId]  
   ,[Unread]  
   ,[DateReceived]  
   ,[Subject]  
   ,[Message]  
   ,[DocumentId]  
   ,[AlertType]  
   ,[Reference]  
   ,[ReferenceLink]  
   )  
  SELECT StaffId  
   ,@ClientId  
   ,'Y'  
   ,GETDATE()  
   ,'Safety Crisis Plan Document'  
   ,'Review Crisis Plan is due ' + CONVERT(varchar,@NextCrisisPlanReviewDate,101)    
   ,@DocumentId  
   ,81  
      ,(SELECT TOP 1 (DocumentName) FROM DocumentCodes WHERE DocumentCodeId = 10018)  
      ,@DocumentId  
  FROM #StaffTable  
    
  END  
  IF(@SafetyPlanReviewDays  IS NOT NULL AND @SafetyPlanReviewDays<=7)  
        BEGIN  
  INSERT INTO [Messages] (  
   [FromStaffId]  
   ,[ToStaffId]  
   ,[ClientId]  
   ,[Unread]  
   ,[DateReceived]  
   ,[Subject]  
   ,[Message]  
   ,[DocumentId]  
   ,[Priority]  
   ,[ReferenceType]  
   ,[ReferenceId]  
   ,[Reference]  
   ,[ReferenceLink]  
   )  
   SELECT @CurrentUserId  
   ,StaffId  
   ,@ClientId  
   ,'Y'  
   ,GETDATE()  
   ,'Safety Crisis Plan Document'  
   ,'Review Safety Plan is due ' + CONVERT(varchar,@NextSafetyPlanReviewDate,101)    
   ,@DocumentId  
   ,60  
      ,5854  
      ,@DocumentId  
      ,(SELECT TOP 1 (DocumentName) FROM DocumentCodes WHERE DocumentCodeId = 10018)  
      ,@DocumentId  
  FROM #StaffTable    
  
  INSERT INTO [Alerts] (  
    [ToStaffId]  
   ,[ClientId]  
   ,[Unread]  
   ,[DateReceived]  
   ,[Subject]  
   ,[Message]  
   ,[DocumentId]  
   ,[AlertType]  
   ,[Reference]  
   ,[ReferenceLink]  
   )  
  SELECT StaffId  
   ,@ClientId  
   ,'Y'  
   ,GETDATE()  
   ,'Safety Crisis Plan Document'  
   ,'Review Safety Plan is due ' + CONVERT(varchar,@NextSafetyPlanReviewDate,101)    
   ,@DocumentId  
   ,81  
      ,(SELECT TOP 1 (DocumentName) FROM DocumentCodes WHERE DocumentCodeId = 10018)  
      ,@DocumentId  
  FROM #StaffTable  
    
  END  
    
  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_CreateMessageAndAlertForCarePlanProgram') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****'
 + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.                                                                                                    
    16  
    ,-- Severity.                                                                                                    
    1 -- State.                                                                                                    
    );  
 END CATCH  
END  