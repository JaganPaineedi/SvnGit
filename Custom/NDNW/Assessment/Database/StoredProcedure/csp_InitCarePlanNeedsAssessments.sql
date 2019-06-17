IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'csp_InitCarePlanNeedsAssessments')
	BEGIN
		DROP  Procedure  csp_InitCarePlanNeedsAssessments --139,444,0
	END

GO  
CREATE PROCEDURE [dbo].[csp_InitCarePlanNeedsAssessments] (  
 @ClientID INT  
 ,@CarePlanDocumentVersionID INT  
 ,@EffectiveDateDifference INT -- Difference is in years    
 )  
AS  
-- ======================================k=======  
-- Author:  Veena S Mani 
-- Create date: 02/05/2015  
-- Description: Initializae Needs  
-- =============================================  
BEGIN TRY  
 BEGIN  
  -- Storing CustomDocumentNeeds into temp table against (CarePlan and MHA) to set "Source" value conditionally    
  DECLARE @CustomDocumentNeeds TABLE (  
   TableName VARCHAR(30)  
   ,DocumentVersionId INT  
   ,CarePlanNeedId INT  
   ,CreatedBy VARCHAR(30)  
   ,CreatedDate DATETIME  
   ,ModifiedBy VARCHAR(30)  
   ,ModifiedDate DATETIME  
   ,RecordDeleted CHAR(1)  
   ,DeletedBy VARCHAR(30)  
   ,DeletedDate DATETIME  
   ,CarePlanDomainNeedId INT  
   ,AddressOnCarePlan CHAR(1)  
   ,NeedName VARCHAR(500)  
   ,CarePlanDomainId INT  
   ,Source CHAR(1)  
   ,SourceName VARCHAR(10)  
   ,NeedDescription VARCHAR(MAX)  
   )  
   DECLARE @LatestASAMDocumentVersionID INT
  -- Stores "DomainNeedId" against CarePlan and MHA    
 
  -- If Care Plan recent signed documentversionid is >5 years then CustomDocumentNeeds will initialize from MHA only  
  --IF (@EffectiveDateDifference > 5)  
  -- SET @CarePlanDocumentVersionID = 0  
  -- Set most recently signed MHA Document VersionId    
  SET @LatestASAMDocumentVersionID = (  
    SELECT TOP 1 D.CurrentDocumentVersionId  
    FROM CustomHRMAssessments C  
     ,Documents D  
    WHERE C.DocumentVersionId = D.CurrentDocumentVersionId  
     AND D.ClientId = @ClientID  
     AND D.STATUS = 22  
     AND IsNull(C.RecordDeleted, 'N') = 'N'  
     AND IsNull(D.RecordDeleted, 'N') = 'N'  
     AND DocumentCodeId IN (10018)  
    ORDER BY D.EffectiveDate DESC  
     ,D.ModifiedDate DESC  
    )  
  

  
   INSERT INTO @CustomDocumentNeeds  
   SELECT 'CarePlanNeeds' AS TableName  
    ,ISNULL(CDN.DocumentVersionId, - 1) AS DocumentVersionId  
    ,CDN.CarePlanNeedId  
    ,CDN.CreatedBy  
    ,CDN.CreatedDate  
    ,CDN.ModifiedBy  
    ,CDN.ModifiedDate  
    ,CDN.RecordDeleted  
    ,CDN.DeletedBy  
    ,CDN.DeletedDate  
    ,CDN.CarePlanDomainNeedId  
    ,CDN.AddressOnCarePlan  
    ,CPDN.NeedName  
    ,CPDN.CarePlanDomainId  
    ,CDN.Source  
    ,CASE CDN.Source  
     WHEN 'C' THEN 'Care Plan'  
     WHEN 'M' THEN 'MHA' END AS SourceName  
    ,CDN.NeedDescription  
   FROM CarePlanNeeds AS CDN  
   LEFT JOIN CarePlanDomainNeeds AS CPDN ON CDN.CarePlanDomainNeedId = CPDN.CarePlanDomainNeedId  
   WHERE ISNULL(CDN.RecordDeleted, 'N') = 'N'  
    AND ISNULL(CPDN.RecordDeleted, 'N') = 'N'  
    AND CDN.DocumentVersionId = @CarePlanDocumentVersionID  
  END  
  
  SELECT CDN.*  
  FROM @CustomDocumentNeeds CDN  

END TRY  
  
BEGIN CATCH  
 DECLARE @Error VARCHAR(8000)  
  
 SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_InitCustomDocumentCarePlanNeeds') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())  
  
 RAISERROR (  
   @Error  
   ,-- Message text.         
   16  
   ,-- Severity.         
   1 -- State.                                                           
   );  
END CATCH  