
/****** Object:  StoredProcedure [dbo].[csp_validateCustomCommercialIndividualServiceNote]    Script Date: 08/06/2015 15:18:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomCommercialIndividualServiceNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomCommercialIndividualServiceNote]
GO

/****** Object:  StoredProcedure [dbo].[csp_validateCustomCommercialIndividualServiceNote]    Script Date: 08/06/2015 15:18:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_validateCustomCommercialIndividualServiceNote] 
 @DocumentVersionId int      
AS    
     
/**************************************************************    
Created By   : Vamsi  
Created Date : 10 Mar 2015   
Description  : Used to Validate Commercial Individual Service Note    
Called From  : Commercial Individual Service Note 
/*  Date     Author      Description */  
/*  10 Mar 2015    Vamsi      Created    */  
  
  -- 25/Nov/2015	jcarlson	  only apply validation if the client is not a legacy client
  -- 1/15/2015		jcarlson    change getDate() to the effective date of the document when counting goals
**************************************************************/  
BEGIN
	BEGIN TRY

DECLARE @DocumentType varchar(10)  
DECLARE @ClientId int   
DECLARE @EffectiveDate date    
DECLARE @StaffId int    
DECLARE @LatestGoalsDocumentVersionID int  
DECLARE @GoalCount int
  
  SELECT @ClientId = d.ClientId,
	   @EffectiveDate = CONVERT(DATE,d.EffectiveDate)    
FROM Documents d    
JOIN DocumentVersions dv ON d.DocumentId = dv.DocumentId
AND dv.DocumentVersionId = @DocumentVersionId
AND ISNULL(dv.RecordDeleted,'N')='N'
WHERE ISNULL(d.RecordDeleted,'N')='N'  


  SELECT TOP 1 @LatestGoalsDocumentVersionID = CurrentDocumentVersionId, @EffectiveDate = EffectiveDate    
 FROM DocumentCarePlans CPG    
 INNER JOIN Documents Doc ON CPG.DocumentVersionId = Doc.CurrentDocumentVersionId    
 WHERE Doc.ClientId = @ClientID   
  AND Doc.[Status] = 22    
  AND ISNULL(CPG.RecordDeleted, 'N') = 'N'    
  AND ISNULL(Doc.RecordDeleted, 'N') = 'N'    
  AND Doc.DocumentCodeId=1620 --care plan (service plan)
 ORDER BY Doc.EffectiveDate DESC    
  ,Doc.ModifiedDate DESC  
  

select @GoalCount= COUNT(*)  from CarePlanGoals c 
WHERE (c.GoalEndDate is Null or c.GoalEndDate >= @EffectiveDate) --effectivedate of the document being signed 
And c.DocumentVersionId=@LatestGoalsDocumentVersionID


  
CREATE TABLE #ValidationTable (
			TableName VARCHAR(500)
			,ColumnName VARCHAR(500)
			,ErrorMessage VARCHAR(MAX)
			,TabOrder INT
			,ValidationOrder DECIMAL
			)
INSERT INTO #ValidationTable
SELECT       'CarePlanGoals'
			,'GoalEndDate'
			,'Must have an active Treatment Plan with at least 1 goal'
			,1
			,1
		FROM CarePlanGoals c
		WHERE DocumentVersionId = @LatestGoalsDocumentVersionID
			AND @GoalCount=0
			AND ISNULL(RecordDeleted, 'N') = 'N'	
			AND EXISTS (
							 SELECT * FROM dbo.Clients c 
							 WHERE ISNULL(c.RecordDeleted,'N')='N'
							 AND c.ClientId = @ClientId 
							 AND (  c.ExternalClientId IS NULL --means client was not migrated in	
								OR ( c.ExternalClientId is NOT NULL AND CONVERT(DATE,GETDATE()) > '7/1/2016') 	
							 and c.clientid not in (3006,3009) )	
								
							 
							
						  )--only active for 1 year from go live-after that legacy clients need an active care plan
					  
			 
			
SELECT   distinct   TableName
			,ColumnName
			,ErrorMessage
			,TabOrder
			,ValidationOrder
			
		FROM #ValidationTable
		ORDER BY TabOrder
			,ValidationOrder
		    
	END TRY
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_validateCustomCommercialIndividualServiceNote') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


