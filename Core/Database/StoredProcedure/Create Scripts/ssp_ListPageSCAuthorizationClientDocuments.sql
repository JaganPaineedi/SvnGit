IF EXISTS (SELECT 1 FROM sys.procedures WHERE name = 'ssp_ListPageSCAuthorizationClientDocuments')
DROP PROCEDURE [dbo].[ssp_ListPageSCAuthorizationClientDocuments]
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
  
CREATE PROCEDURE [dbo].[ssp_ListPageSCAuthorizationClientDocuments]
    @SessionId VARCHAR(30) ,
    @InstanceId INT ,
    @PageNumber INT ,
    @PageSize INT ,
    @SortExpression VARCHAR(100) ,
    @ClientId INT ,
    @ClientCoveragePlanFilter INT                                                                                      
	--@OtherFilter int,        
	--@StaffId int    
/********************************************************************************************/                                                    
/* Stored Procedure: ssp_ListPageSCClientAuthorizationDocument        */                                           
/* Copyright: 2009 Streamline Healthcare Solutions           */                                                    
/* Creation Date:  15 Nov 2010                */                                                    
/* Purpose: used by  Authorization Document List page          */  
/* Input Parameters: @ClientUMNoteId              */                                                  
/* Output Parameters:                  */                                                    
/* Return:                     */                                                    
/* Called By: GetClientAuthorizationDocumentList() Method in AuthorizationDetail Class Of DataService     */                                                    
/* Calls:                     */                                                    
/* Data Modifications:                  */                                                    
/*       Date              Author			Purpose       
		-----------		---------------		----------------------------                                                    
		15 Nov 2010          Jitender		Created   
		20 April 2011        Rakesh			Modified        
		05/11/2012			dharvey			Added 1469 & 352 to document list
		JUN-02-2014			dharvey			Merged changes to Core script with Recode to specify documents to include */
/*		SEP-27-2016			Ravichandra		Removed the physical table ListPageSCAuthorizationClientDocuments from SP
											Why:Task #108, Engineering Improvement Initiatives- NBL(I)	
											108 - Do NOT use list page tables for remaining list pages (refer #107) */     
/********************************************************************************************/
AS 
    BEGIN                             
        BEGIN TRY                                                                                                                                  
            CREATE TABLE #ResultSet
                (
                  DocumentId INT ,
                  DocumentCodeId INT ,
                  DocumentName VARCHAR(100) ,
                  EffectiveDate DATETIME ,
                  CurrentDocumentVersionId INT
                )                                                                
                                                                             
            INSERT  INTO #ResultSet
                    ( DocumentId ,
                      DocumentCodeId ,
                      DocumentName ,
                      EffectiveDate ,
                      CurrentDocumentVersionId                         
                    )
                    SELECT  Documents.DocumentId ,
                            DocumentCodes.DocumentCodeId ,
                            DocumentCodes.DocumentName ,
                            Documents.EffectiveDate ,
                            Documents.CurrentDocumentVersionId
                    FROM    ClientCoveragePlans
                            INNER JOIN AuthorizationDocuments 
								ON AuthorizationDocuments.ClientCoveragePlanId = ClientCoveragePlans.ClientCoveragePlanId
                                AND ISNULL(AuthorizationDocuments.RecordDeleted, 'N') = 'N' 
                            INNER JOIN Documents 
								ON AuthorizationDocuments.DocumentId = Documents.DocumentID
                                AND ISNULL(Documents.RecordDeleted, 'N') = 'N'
                            INNER JOIN DocumentCodes 
								ON Documents.DocumentCodeId = DocumentCodes.DocumentCodeId
                                AND ISNULL(DocumentCodes.RecordDeleted, 'N') = 'N'                          
                    WHERE   Documents.ClientId = @ClientId
                            AND ( ClientCoveragePlans.ClientCoveragePlanId = @ClientCoveragePlanFilter
                                  OR ISNULL(@ClientCoveragePlanFilter, 0) = 0
                                )    
                               
/* Added to retrieve Additional documents to be listed - DJH 5/11/2012 */
--order by EffectiveDate desc  
                    UNION
                    SELECT  d.DocumentId ,
                            d.DocumentCodeId ,
                            dc.DocumentName ,
                            d.EffectiveDate ,
                            d.CurrentDocumentVersionId
                    FROM    Documents d
                            JOIN DocumentCodes dc ON dc.DocumentCodeId = d.DocumentCodeId
                    WHERE   d.ClientId = @ClientId
                            AND d.Status = 22
                            AND d.DocumentCodeId IN ( SELECT IntegerCodeId 
														FROM dbo.ssf_RecodeValuesCurrent('AuthDetailsListAdditionalDocumentCodes') )
                            AND ISNULL(d.RecordDeleted, 'N') = 'N'
                            AND NOT EXISTS (SELECT 1 FROM Documents d2
											WHERE d2.ClientId = d.ClientId
											AND d2.DocumentCodeId = d.DocumentCodeId
											AND d2.Status = 22
											AND ISNULL(d2.RecordDeleted,'N')='N'
											AND ( d2.EffectiveDate > d.EffectiveDate
												OR (d2.EffectiveDate = d.EffectiveDate
														AND d2.DocumentId > d.DocumentId
														)
												)
											)
                    ORDER BY 4 DESC
     
            ;WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
			AS (SELECT 			
					  DocumentId ,
                      DocumentCodeId ,
                      DocumentName ,
                      EffectiveDate ,
                      CurrentDocumentVersionId           
				,Count(*) OVER () AS TotalCount
				,ROW_NUMBER() OVER ( ORDER BY 
										CASE WHEN @SortExpression = 'DocumentId' THEN DocumentId END,
										CASE WHEN @SortExpression = 'DocumentId desc' THEN DocumentId END DESC,
										CASE WHEN @SortExpression = 'DocumentName' THEN DocumentName END,
										CASE WHEN @SortExpression = 'DocumentName desc' THEN DocumentName END DESC,
										CASE WHEN @SortExpression = 'EffectiveDate' THEN EffectiveDate END,
										CASE WHEN @SortExpression = 'EffectiveDate desc' THEN EffectiveDate END DESC,
										DocumentName,
										DocumentId ) AS RowNumber         
               from #ResultSet)
               
		SELECT TOP (CASE WHEN (@PageNumber = - 1)
						THEN (SELECT ISNULL(TotalRows, 0) FROM Counts)
					ELSE (@PageSize)
					END
				)  	
					  DocumentId ,
                      DocumentCodeId ,
                      DocumentName ,
                      EffectiveDate ,
                      CurrentDocumentVersionId  ,                             
				TotalCount,
				RowNumber
		INTO #FinalResultSet
		FROM RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

		IF (SELECT ISNULL(Count(*), 0)	FROM #FinalResultSet) < 1
		BEGIN
			SELECT 0 AS PageNumber
				,0 AS NumberOfPages
				,0 NumberofRows
		END
		ELSE
		BEGIN
			SELECT TOP 1 @PageNumber AS PageNumber
				,CASE (Totalcount % @PageSize)
					WHEN 0
						THEN ISNULL((Totalcount / @PageSize), 0)
					ELSE ISNULL((Totalcount / @PageSize), 0) + 1
					END AS NumberOfPages
				,ISNULL(Totalcount, 0) AS NumberofRows
			FROM #FinalResultSet
		END

		SELECT	DocumentId ,
                DocumentCodeId ,
                DocumentName ,
                EffectiveDate ,
                CurrentDocumentVersionId  as DocumentVersionId   
		FROM #FinalResultSet
		ORDER BY RowNumber, EffectiveDate DESC                                                    
                                                                                                                       
           
        END TRY  
BEGIN CATCH                                                                             
 DECLARE @Error varchar(8000)                                    
         SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                                             
         + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_ListPageSCAuthorizationClientDocuments')                                                                                                                                             
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
