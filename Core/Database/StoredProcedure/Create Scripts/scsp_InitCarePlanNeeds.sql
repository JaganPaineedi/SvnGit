/****** Object:  StoredProcedure [dbo].[scsp_InitCarePlanNeeds]    Script Date: 02/04/2015 20:00:37 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[scsp_InitCarePlanNeeds]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[scsp_InitCarePlanNeeds]
GO

/****** Object:  StoredProcedure [dbo].[scsp_InitCarePlanNeeds]    Script Date: 02/04/2015 20:00:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[scsp_InitCarePlanNeeds] (  
 @ClientID INT  
 ,@CarePlanDocumentVersionID INT  
 ,@EffectiveDateDifference INT -- Difference is in years      
 )  
AS  
-- =============================================    
-- Author:  Pradeep.A    
-- Create date: 01/19/2015    
-- Description: Initializae Needs    
-- jun 04 2015	Pradeep		Added 'S' Source column for Old ASAM Needs
/*01 July 2016	Vithobha	Added @ScreenName to get the screen name dynamically instead of hard code, Bradford - Support Go Live: #134  */
-- =============================================    
BEGIN TRY  
 BEGIN  
 
  DECLARE @LatestASAMDocumentVersionID INT  
  DECLARE @ScreenName varchar(100)
  
  Select @ScreenName=Screenname From Screens Where ScreenId=1077   
  -- Storing CustomDocumentNeeds into temp table against (CarePlan and MHA) to set "Source" value conditionally      
  DECLARE @CustomDocumentNeeds TABLE (  
   CarePlanNeedId INT --Identity(- 1, - 1)  
   ,TableName VARCHAR(30)  
   ,DocumentVersionId INT  
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
   ,SourceName VARCHAR(500)  
   ,NeedDescription VARCHAR(MAX)  
   )   
  IF (@EffectiveDateDifference > 5)  
   SET @CarePlanDocumentVersionID = 0  
  
  IF ISNULL(@CarePlanDocumentVersionID, 0) > 0
  BEGIN  
   INSERT INTO @CustomDocumentNeeds (  
     TableName  
    ,CarePlanNeedId
    ,DocumentVersionId  
    ,CreatedBy  
    ,CreatedDate  
    ,ModifiedBy  
    ,ModifiedDate  
    ,RecordDeleted  
    ,DeletedBy  
    ,DeletedDate  
    ,CarePlanDomainNeedId  
    ,AddressOnCarePlan  
    ,NeedName  
    ,CarePlanDomainId  
    ,Source  
    ,SourceName  
    ,NeedDescription  
    )  
   SELECT 'CarePlanNeeds' AS TableName  
    ,CDN.CarePlanNeedId
    ,ISNULL(CDN.DocumentVersionId, - 1) AS DocumentVersionId  
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
     WHEN 'C'  
      THEN @ScreenName  
     WHEN 'M'  
      THEN 'MHA'  
     WHEN 'A'  
      THEN 'ASAM'  
     WHEN 'O'  
      THEN 'Old MHA'   
     WHEN 'S'
      THEN 'Old ASAM'
     END AS SourceName  
    ,CDN.NeedDescription  
   FROM CarePlanNeeds AS CDN  
   LEFT JOIN CarePlanDomainNeeds AS CPDN ON CDN.CarePlanDomainNeedId = CPDN.CarePlanDomainNeedId  
   WHERE ISNULL(CDN.RecordDeleted, 'N') = 'N'  
    AND ISNULL(CPDN.RecordDeleted, 'N') = 'N'  
    AND CDN.DocumentVersionId =ISNULL(@CarePlanDocumentVersionID,-1)
  END  
  
	SELECT CDN.* FROM @CustomDocumentNeeds CDN  
	END
END TRY  
  
BEGIN CATCH  
 DECLARE @Error VARCHAR(8000)  
  
 SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'scsp_InitCarePlanNeeds') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + 
 Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())  
  
 RAISERROR (  
   @Error  
   ,-- Message text.           
   16  
   ,-- Severity.           
   1 -- State.                                                             
   );  
END CATCH 
GO 
