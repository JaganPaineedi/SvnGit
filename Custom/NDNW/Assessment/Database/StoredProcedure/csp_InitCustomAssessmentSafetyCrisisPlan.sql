IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'csp_InitCustomAssessmentSafetyCrisisPlan')
	BEGIN
		DROP  Procedure  csp_InitCustomAssessmentSafetyCrisisPlan --139,'','','I','',444,'',1
	END

GO
CREATE PROCEDURE [dbo].[csp_InitCustomAssessmentSafetyCrisisPlan] (  
 @ClientID INT  
 ,@StaffID INT  
 ,@CustomParameters XML  
 ,@SAFETYPLANINITORREVIEW VARCHAR(10) 
 ,@CRISISPLANINITORREVIEW VARCHAR(10)
 )  
AS  
/**************************************************************    
Created By   : SuryaBalan  
Created Date : 10 Feb 2015   
Description  : Used to Initialize Data for Custom Safety/CrisisPlan Document    
Called From  : Safety/CrisisPlan Screens  
/*  Date     Author      Description */  
/* SuryaBalan 22-April-2015 Task 955.3 Valley Customizations Created seperate CSP to init safety Crisis plan which is taken from stand alone document Safety/Crisis Plan[task 969]*/ 

/* SuryaBalan 28-April-2015 Task 955.3 Valley Customizations Initialization process should work only when we select Initial/Update in First tab of Assessment*/  
 
  
**************************************************************/  
BEGIN  
 BEGIN TRY  
 DECLARE @LatestDocumentVersionID INT  
 DECLARE @EffectiveDate DATETIME   
 DECLARE @NextSafetyPlanReviewDate DATETIME   
 DECLARE @NextCrisisPlanReviewDate DATETIME   
 DECLARE @Months DECIMAL(10,5)  
 --DECLARE @SAFETYPLANINITORREVIEW VARCHAR(10)   
 --DECLARE @CRISISPLANINITORREVIEW VARCHAR(10) 
 DECLARE @SafetyPlan VARCHAR(10)  
 DECLARE @CrisisPlan VARCHAR(10)       
   --SET @SAFETYPLANINITORREVIEW = @CustomParameters.value('(/Root/Parameters/@SafetyInitialorReview)[1]', 'varchar(10)')   
   --SET @CRISISPLANINITORREVIEW = @CustomParameters.value('(/Root/Parameters/@CrisisInitialorReview)[1]', 'varchar(10)')   
       
 SELECT TOP 1 @LatestDocumentVersionID = CurrentDocumentVersionId,
			   @SafetyPlan =InitialSafetyPlan,
	            @CrisisPlan=InitialCrisisPlan,	   
              @EffectiveDate = EffectiveDate,  
              @NextCrisisPlanReviewDate=NextCrisisPlanReviewDate                
 FROM CustomDocumentSafetyCrisisPlans CDCD  
 INNER JOIN Documents Doc ON CDCD.DocumentVersionId = Doc.CurrentDocumentVersionId  
 WHERE Doc.ClientId = @ClientID  
  AND Doc.[Status] = 22  
  AND ISNULL(CDCD.RecordDeleted, 'N') = 'N'  
  AND ISNULL(Doc.RecordDeleted, 'N') = 'N'  
   AND DocumentCodeId IN (      
      10018   
      ,349     
      )     
 ORDER BY Doc.EffectiveDate DESC  
  ,Doc.ModifiedDate DESC  
    
   SELECT TOP 1               
              @NextSafetyPlanReviewDate=NextSafetyPlanReviewDate  
                            
 FROM CustomSafetyCrisisPlanReviews CDCD  
 INNER JOIN Documents Doc ON CDCD.DocumentVersionId = Doc.CurrentDocumentVersionId  
 WHERE Doc.ClientId = @ClientID  
  AND Doc.[Status] = 22  
  AND ISNULL(CDCD.RecordDeleted, 'N') = 'N'  
  AND ISNULL(Doc.RecordDeleted, 'N') = 'N'  
   AND DocumentCodeId IN (      
      10018      
      )     
 ORDER BY Doc.EffectiveDate DESC  
  ,Doc.ModifiedDate DESC  
     
 SET @LatestDocumentVersionID = ISNULL(@LatestDocumentVersionID, - 1)  
 IF @EffectiveDate IS NOT NULL  
 BEGIN    
  SET @Months = CASE WHEN DATEDIFF(d,@EffectiveDate, GETDATE())>30 THEN DATEDIFF(d,@EffectiveDate, GETDATE())/30.0 ELSE 0 END  
  IF @Months > 6  
  BEGIN  
   SET @LatestDocumentVersionID = -1  
  END  
 END  
  IF (
		--(
		@SAFETYPLANINITORREVIEW = 'N'
		 AND @CRISISPLANINITORREVIEW ='N' 
		 --AND  @SafetyPlan='N' AND (GETDATE() < @NextSafetyPlanReviewDate )
		)
	--)
--AND @LatestDocumentVersionID > 0
	BEGIN
	SELECT 'CustomDocumentSafetyCrisisPlans' AS TableName  
		   ,ISNULL(CDSCP.DocumentVersionId, - 1) AS DocumentVersionId  
		   ,CDSCP.CreatedBy  
		   ,CDSCP.CreatedDate  
		   ,CDSCP.ModifiedBy  
		   ,CDSCP.ModifiedDate  
		   ,CDSCP.RecordDeleted  
		   ,CDSCP.DeletedBy  
		   ,CDSCP.DeletedDate  
		   ,ClientHasCurrentCrisis  
		   ,WarningSignsCrisis  
		   ,CopingStrategies  
		   ,ThreeMonths  
		   ,TwelveMonths  
		  ,DateOfCrisis    
		  ,(SELECT DOB FROM clients WHERE Clientid =  @ClientID) AS DOB   
		  ,ProgramId    
		  ,StaffId    
		  ,SignificantOther    
		  ,CurrentCrisisDescription    
		  ,CurrentCrisisSpecificactions    
		   ,'N' as [InitialSafetyPlan] 
		   ,'N' as [InitialCrisisPlan] 
		   ,SafetyPlanNotReviewed 
		   ,ReviewCrisisPlanXDays
		   --,[NextSafetyPlanReviewDate]
		   ,[NextCrisisPlanReviewDate]
		  -- ,[ReviewSafetyPlanXDays]
		  FROM SystemConfigurations AS s  
		  LEFT JOIN CustomDocumentSafetyCrisisPlans CDSCP ON CDSCP.DocumentVersionId = @LatestDocumentVersionID  
		  WHERE ISNULL(CDSCP.RecordDeleted, 'N') = 'N'
		  
		   SELECT 'CustomSupportContacts' AS TableName  
		   ,ISNULL(CSC.DocumentVersionId, - 1) AS DocumentVersionId  
		   ,'' AS CreatedBy  
		   ,GETDATE() AS CreatedDate  
		   ,'' AS ModifiedBy  
		   ,GETDATE() AS ModifiedDate  
		   ,CSC.ClientContactId  
		   ,CSC.NAME  
		   ,CSC.Relationship  
		   ,CSC.[Address]  
		   ,CSC.Phone  
		  FROM systemconfigurations s  
		  INNER JOIN CustomSupportContacts CSC ON CSC.DocumentVersionId = @LatestDocumentVersionID  
		  WHERE ISNULL(CSC.RecordDeleted, 'N') = 'N'  
		  ORDER BY CSC.SupportContactId ASC  
		  
		  SELECT 'CustomSafetyCrisisPlanReviews' AS TableName  
		   ,- 1 AS DocumentVersionId  
		   ,'' AS CreatedBy  
		   ,GETDATE() AS CreatedDate  
		   ,'' AS ModifiedBy  
		   ,GETDATE() AS ModifiedDate  
		   ,CSCPR.SafetyCrisisPlanReviewed  
		   ,CSCPR.DateReviewed  
		   ,CSCPR.ReviewEveryXDays  
		   ,CSCPR.DescribePlanReview  
		   ,CSCPR.CrisisDisposition  
		   ,CAST(CSCPR.ReviewEveryXDays AS VARCHAR(5)) + ' Days' AS ReviewEveryDaysText
		   ,CrisisResolved  
			,CASE WHEN CrisisResolved ='Y' THEN 'Yes' WHEN CrisisResolved ='N' THEN 'No' ELSE '' END AS CrisisResolvedText    
		  FROM systemconfigurations s  
		  INNER JOIN CustomSafetyCrisisPlanReviews CSCPR ON CSCPR.DocumentVersionId = @LatestDocumentVersionID  
		  WHERE ISNULL(CSCPR.RecordDeleted, 'N') = 'N'  
		  ORDER BY CSCPR.SafetyCrisisPlanReviewId ASC  
		  	
			  SELECT    'CustomCrisisPlanMedicalProviders' AS TableName, 
						--CCPMP.CrisisPlanMedicalProviderId,
						ISNULL(CCPMP.DocumentVersionId, - 1) AS DocumentVersionId , 
						'' AS CreatedBy  
						,GETDATE() AS CreatedDate  
						,'' AS ModifiedBy  
						,GETDATE() AS ModifiedDate,  
						CCPMP.RecordDeleted,
						CCPMP.DeletedBy,
						CCPMP.DeletedDate,
						CCPMP.Name,
						CCPMP.AddressType,
						CCPMP.[Address],
						CCPMP.Phone,
						(SELECT TOP 1 CodeName FROM GlobalCodes WHERE GlobalCodeId = CCPMP.AddressType) AS 'AddressTypeText'  
			  FROM SystemConfigurations AS s  
			  INNER JOIN CustomCrisisPlanMedicalProviders CCPMP ON  CCPMP.DocumentVersionId = @LatestDocumentVersionID  
				  WHERE ISNULL(CCPMP.RecordDeleted, 'N') = 'N'  
				  ORDER BY CCPMP.CrisisPlanMedicalProviderId ASC  
		 
			  SELECT 'CustomCrisisPlanNetworkProviders' AS TableName ,
					--CCPNP.CrisisPlanNetworkProviderId,
					ISNULL(CCPNP.DocumentVersionId, - 1) AS DocumentVersionId, 
					'' AS CreatedBy  
					,GETDATE() AS CreatedDate  
					,'' AS ModifiedBy  
					,GETDATE() AS ModifiedDate,
					CCPNP.RecordDeleted,
					CCPNP.DeletedBy,
					CCPNP.DeletedDate,
					CCPNP.Name,
					CCPNP.AddressType,
					CCPNP.[Address],
					CCPNP.Phone,
					(SELECT TOP 1 CodeName FROM GlobalCodes WHERE GlobalCodeId = CCPNP.AddressType) AS 'AddressTypeText'  
					FROM SystemConfigurations AS s  
					INNER JOIN CustomCrisisPlanNetworkProviders CCPNP ON  CCPNP.DocumentVersionId = @LatestDocumentVersionID  
				  WHERE ISNULL(CCPNP.RecordDeleted, 'N') = 'N'  
				  ORDER BY CCPNP.CrisisPlanNetworkProviderId ASC 
		  
		 
	END
    
 IF (
		--(
		@SAFETYPLANINITORREVIEW = 'Y'
		 AND @CRISISPLANINITORREVIEW ='Y' 
		 --AND  @SafetyPlan='Y' 
		)
	BEGIN
		SELECT 'CustomDocumentSafetyCrisisPlans' AS TableName
			,ISNULL(CDSCP.DocumentVersionId, - 1) AS DocumentVersionId
			,CDSCP.CreatedBy
			,CDSCP.CreatedDate
			,CDSCP.ModifiedBy
			,CDSCP.ModifiedDate
			,CDSCP.RecordDeleted
			,CDSCP.DeletedBy
			,CDSCP.DeletedDate
			,ClientHasCurrentCrisis
			,WarningSignsCrisis
			,CopingStrategies
			,ThreeMonths
			,TwelveMonths
			--,DateOfCrisis    
			,(SELECT DOB FROM clients WHERE Clientid = @ClientID) AS DOB   
			--,ProgramId    
			--,StaffId    
			--,SignificantOther    
			--,CurrentCrisisDescription    
			--,CurrentCrisisSpecificactions    
			,'Y' as [InitialSafetyPlan]
			,'Y' as [InitialCrisisPlan]
			,SafetyPlanNotReviewed
			,ReviewCrisisPlanXDays			
			,[NextCrisisPlanReviewDate]
			--,[ReviewSafetyPlanXDays]
		FROM SystemConfigurations AS s
		LEFT JOIN CustomDocumentSafetyCrisisPlans CDSCP ON s.DatabaseVersion = - 1

		SELECT 'CustomSupportContacts' AS TableName
			,- 1 AS DocumentVersionId
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate
			,CSC.ClientContactId
			,CSC.NAME
			,CSC.Relationship
			,CSC.[Address]
			,CSC.Phone
		FROM systemconfigurations s
		INNER JOIN CustomSupportContacts CSC ON s.DatabaseVersion = - 1
		WHERE ISNULL(CSC.RecordDeleted, 'N') = 'N'
		ORDER BY CSC.SupportContactId ASC

		SELECT 'CustomSafetyCrisisPlanReviews' AS TableName
			,- 1 AS DocumentVersionId
			,'' AS CreatedBy
			,GETDATE() AS CreatedDate
			,'' AS ModifiedBy
			,GETDATE() AS ModifiedDate
			,CSCPR.SafetyCrisisPlanReviewed
			,CSCPR.DateReviewed
			,CSCPR.ReviewEveryXDays
			,CSCPR.DescribePlanReview
			,CSCPR.CrisisDisposition
			,CSCPR.[NextSafetyPlanReviewDate]
			,CAST(CSCPR.ReviewEveryXDays AS VARCHAR(5)) + ' Days' AS ReviewEveryDaysText
			,CrisisResolved  
			 ,CASE WHEN CrisisResolved ='Y' THEN 'Yes' WHEN CrisisResolved ='N' THEN 'No' ELSE '' END AS CrisisResolvedText  
		FROM systemconfigurations s
		INNER JOIN CustomSafetyCrisisPlanReviews CSCPR ON s.DatabaseVersion = - 1
		WHERE ISNULL(CSCPR.RecordDeleted, 'N') = 'N'
		ORDER BY CSCPR.SafetyCrisisPlanReviewId ASC
		
		SELECT    'CustomCrisisPlanMedicalProviders' AS TableName ,  
             --CCPMP.CrisisPlanMedicalProviderId,  
             - 1 AS DocumentVersionId ,  
    CCPMP.CreatedBy,  
    CCPMP.CreatedDate,  
    CCPMP.ModifiedBy,  
    CCPMP.ModifiedDate,  
    CCPMP.RecordDeleted,  
    CCPMP.DeletedBy,  
    CCPMP.DeletedDate,  
    CCPMP.DocumentVersionId,  
    CCPMP.Name,  
    CCPMP.AddressType,  
    CCPMP.[Address],  
    CCPMP.Phone,
    (SELECT TOP 1 CodeName FROM GlobalCodes WHERE GlobalCodeId = CCPMP.AddressType) AS 'AddressTypeText'   
   FROM SystemConfigurations AS s    
   INNER JOIN CustomCrisisPlanMedicalProviders CCPMP ON s.DatabaseVersion = - 1   
     
   SELECT 'CustomCrisisPlanNetworkProviders' AS TableName ,  
         --CCPNP.CrisisPlanNetworkProviderId,  
         - 1 AS DocumentVersionId ,   
   CCPNP.CreatedBy,  
   CCPNP.CreatedDate,  
   CCPNP.ModifiedBy,  
   CCPNP.ModifiedDate,  
   CCPNP.RecordDeleted,  
   CCPNP.DeletedBy,  
   CCPNP.DeletedDate,  
   CCPNP.DocumentVersionId,  
   CCPNP.Name,  
   CCPNP.AddressType,  
   CCPNP.[Address],  
   CCPNP.Phone,
   (SELECT TOP 1 CodeName FROM GlobalCodes WHERE GlobalCodeId = CCPNP.AddressType) AS 'AddressTypeText'    
   FROM SystemConfigurations AS s    
   INNER JOIN CustomCrisisPlanNetworkProviders CCPNP ON s.DatabaseVersion = - 1   
  
	END
   
 END TRY  
  
 BEGIN CATCH  
 END CATCH  
  
END  
  