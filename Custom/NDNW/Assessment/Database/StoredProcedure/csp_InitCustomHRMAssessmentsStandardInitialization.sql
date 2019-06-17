
/****** Object:  StoredProcedure [dbo].[csp_InitCustomHRMAssessmentsStandardInitialization]    Script Date: 01/16/2015 17:06:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomHRMAssessmentsStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomHRMAssessmentsStandardInitialization]
GO


/****** Object:  StoredProcedure [dbo].[csp_InitCustomHRMAssessmentsStandardInitialization]    Script Date: 01/16/2015 17:06:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[csp_InitCustomHRMAssessmentsStandardInitialization] (  
  @ClientID INT  
 ,@StaffID INT  
 ,@CustomParameters XML  
 )  
AS  
/*********************************************************************/  
/* Stored Procedure: [[csp_InitCustomHRMAssessmentsStandardInitialization]]                */  
/* Copyright: 2006 Streamline SmartCare*/  
/* Creation Date:  24/Feb/2010                                    */  
/*                                                                   */  
/* Purpose: To Initialize CustomPAAssessments Documents*/  
/*                                                                   */  
/* Input Parameters: @ClientID, @StaffID, @CustomParameters    eg:- 14309,92,'N' */  
/*    */  
/* Output Parameters: */  
/*  */  
/* Return:                                                                                                                 
 /* Called By:CustomDocuments Class Of DataService    */                       
 /* Calls:   */                            
 /*                            */       
 /* Data Modifications:                                   */                                                                                                                                                                                              
 /*   Updates:                                        */                                                                                                                                                                         
 /*       Date              Author                Purpose  */                                                                                                                                                                        
          3/5/2015          Hemant       Added csp_InitDocumentCSSRSAdultSinceLT,csp_InitDocumentCSSRSChildAdolescentSinceLT,csp_InitDocumentCSSRSAdultScreeners  why:955.2 Valley - Customizations                                
 /*       Sandeep Singh   */     
 /* SuryaBalan 22-April-2015 Task 955.3 Valley Customizations Created seperate CSP to init safety Crisis plan which is taken from stand alone document Safety/Crisis Plan[task 969]*/   
 
 /* SuryaBalan 28-April-2015 Task 955.3 Valley Customizations Initialization process should work only when we select Initial/Update in First tab of Assessment*/ 
 /* SuryaBalan 28-April-2015 Task 955.3 Valley Customizations Moved the condition part for initialization of Safety Crisis Plan tab under Assessment*/                                                                                                                                                                    
 /*********************************************************************/                                                                                                                                                                                       
 
    
      
         
          
    */  
BEGIN  
 BEGIN TRY  
  --Declare Default Variables                                          
  DECLARE @later DATETIME  
  
  SET @later = GETDATE()  
  
  DECLARE @LatestDocumentVersionID INT  
  DECLARE @clientName VARCHAR(100)  
  DECLARE @clientDOB VARCHAR(50)  
  DECLARE @clientAge VARCHAR(50)  
  DECLARE @InitialRequestDate DATETIME  
  DECLARE @SAFETYPLANINITORREVIEW VARCHAR(10)   
  DECLARE @CRISISPLANINITORREVIEW VARCHAR(10)
  
  SET @clientName = (  
    SELECT C.LastName + ', ' + C.FirstName AS ClientName  
    FROM Clients C  
    WHERE C.ClientId = @ClientID  
     AND IsNull(C.RecordDeleted, 'N') = 'N'  
    )  
  SET @clientDOB = (  
    SELECT CONVERT(VARCHAR(10), DOB, 101)  
    FROM Clients  
    WHERE ClientId = @ClientID  
     AND IsNull(RecordDeleted, 'N') = 'N'  
    )  
  
  --set @clientAge = (Select Cast(DateDIFF(yy,DOB,@later)-CASE WHEN @later>=DateAdd(yy,DateDIFF(yy,DOB,@later), DOB) THEN 0 ELSE 1 END as varchar(10))  AS Age from Clients C                                                   
  --where C.ClientId=@ClientID and IsNull(C.RecordDeleted,'N')='N')      
  EXEC csp_CalculateAge @ClientID  
   ,@clientAge out  
  
  SET @InitialRequestDate = (  
    SELECT TOP 1 InitialRequestDate  
    FROM ClientEpisodes CP  
    WHERE CP.ClientId = @ClientID  
     AND IsNull(Cp.RecordDeleted, 'N') = 'N'  
     AND IsNull(CP.RecordDeleted, 'N') = 'N'  
    ORDER BY CP.InitialRequestDate DESC  
    )  
  
  --Get AxisI and AxisII for Initial Tab                                                                                               
  DECLARE @AxisIAxisIIOut NVARCHAR(1100)  
  
  --EXEC [dbo].[csp_HRMGetAxisIAxisII] @ClientID  
  -- ,@AxisIAxisIIOut OUTPUT  
  
  --End declaration of Default variables                                          
  SET ARITHABORT ON  
  
  DECLARE @AssessmentTypeCheck VARCHAR(10)  
  DECLARE @CurrentAuthorId INT  
  DECLARE @SafetyInitialorReview VARCHAR(10)
  DECLARE @CrisisInitialorReview VARCHAR(10)
  
  
  SET @AssessmentTypeCheck = @CustomParameters.value('(/Root/Parameters/@ScreenType)[1]', 'varchar(10)')  
  SET @CurrentAuthorId = @CustomParameters.value('(/Root/Parameters/@CurrentAuthorId)[1]', 'int')  
  --SET @SafetyInitialorReview = @CustomParameters.value('(/Root/Parameters/@SafetyInitialorReview)[1]', 'varchar(10)')
  --SET @CrisisInitialorReview = @CustomParameters.value('(/Root/Parameters/@CrisisInitialorReview)[1]', 'varchar(10)') 
  
   
  SET @LatestDocumentVersionID = - 1  
  SET @LatestDocumentVersionID = (  
    SELECT TOP 1 CurrentDocumentVersionId  
    FROM CustomHRMAssessments C  
     ,Documents D  
    WHERE C.DocumentVersionId = D.CurrentDocumentVersionId  
     AND D.ClientId = @ClientID  
     AND D.STATUS = 22  
     AND IsNull(C.RecordDeleted, 'N') = 'N'  
     AND IsNull(D.RecordDeleted, 'N') = 'N'  
     AND DocumentCodeId IN (  
      10018  
      ,349  
      )  
    ORDER BY D.EffectiveDate DESC  
     ,D.ModifiedDate DESC  
    )  
  
  IF (  
    (  
     @AssessmentTypeCheck = 'U'  
     OR @AssessmentTypeCheck = 'I'  
     OR @AssessmentTypeCheck = 'A'  
     AND @AssessmentTypeCheck != ''  
     )  
    AND @LatestDocumentVersionID > 0  
    )  
   --Execute Store Procedure based on Assessment Type                                          
  BEGIN  
   EXEC scsp_SCHRMGetRecentSignedAssessment @ClientId  
    ,@AssessmentTypeCheck  
    ,@LatestDocumentVersionID  
    ,@clientAge  
    ,@AxisIAxisIIOut  
    ,@InitialRequestDate  
    ,@clientDOB  
    ,@CurrentAuthorId  
    
    exec csp_InitCustomDocumentDLA20  @ClientID, @StaffID, @CustomParameters 
    exec csp_InitDocumentFamilyHistory @ClientID, @StaffID, @CustomParameters
  exec ssp_InitCustomDiagnosisStandardInitializationNew @ClientID, @StaffID, @CustomParameters
  --exec csp_InitDocumentCSSRSAdultSinceLT @ClientID, @StaffID, @CustomParameters   
  --exec csp_InitDocumentCSSRSChildAdolescentSinceLT @ClientID, @StaffID, @CustomParameters 
  --exec csp_InitDocumentCSSRSAdultScreeners @ClientID, @StaffID, @CustomParameters 
   IF(@AssessmentTypeCheck = 'I' )
		BEGIN
		
			EXEC csp_InitCustomAssessmentSafetyCrisisPlan @ClientID,@StaffID,'','Y','Y'
		END
  ELSE IF(@AssessmentTypeCheck = 'U' )
		
		BEGIN
			EXEC csp_InitCustomAssessmentSafetyCrisisPlan @ClientID,@StaffID,'','N','N'
		END	
   ELSE 
		BEGIN
			EXEC csp_InitCustomAssessmentSafetyCrisisPlan @ClientID,@StaffID,'','Y','Y'
		END	   
   RETURN  
  END  
  ELSE  
  BEGIN  
  --select @AxisIAxisIIOut,@clientAge,@AssessmentTypeCheck,@InitialRequestDate,@clientDOB
   EXEC csp_InitCustomHRMAssessmentDefaultIntialization @ClientID  
    ,@AxisIAxisIIOut  
    ,@clientAge  
    ,@AssessmentTypeCheck  
    ,@InitialRequestDate  
    ,@LatestDocumentVersionID  
    ,@clientDOB  
    ,@CurrentAuthorId 
    --,@SafetyInitialorReview 
    --,@CrisisInitialorReview 
   
		
		
    exec csp_InitDocumentFamilyHistory @ClientID, @StaffID, @CustomParameters
    exec ssp_InitCustomDiagnosisStandardInitializationNew @ClientID, @StaffID, @CustomParameters  
    --exec csp_InitDocumentCSSRSAdultSinceLT @ClientID, @StaffID, @CustomParameters   
   --exec csp_InitDocumentCSSRSChildAdolescentSinceLT @ClientID, @StaffID, @CustomParameters 
   --exec csp_InitDocumentCSSRSAdultScreeners @ClientID, @StaffID, @CustomParameters  
  END 
  		
			
 END TRY
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_InitCustomHRMAssessmentsStandardInitialization') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())  
  
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


