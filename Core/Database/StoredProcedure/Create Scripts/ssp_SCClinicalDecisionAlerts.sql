IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCClinicalDecisionAlerts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ssp_SCClinicalDecisionAlerts]
GO  
/****** Object:  StoredProcedure [dbo].[ssp_SCClinicalDecisionAlerts]    Script Date: 12/16/2011 16:43:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON                                                                        
GO

Create procedure [dbo].[ssp_SCClinicalDecisionAlerts]                                                                         
@SessionId varchar(30),                                                                
@InstanceId int,                                                                
@PageNumber int,                                                                    
@PageSize int,                                                                    
@SortExpression varchar(100),                                                                           
@OtherFilter INT     

/*********************************************************************/                                                                            
 /* Stored Procedure: [ssp_SCClinicalDecisionAlerts]      */ 
 /* Creation Date:  24/JUNE/2016               */                                                                            
 /* Purpose: To Get The Data on List Page of Clinical Decision Support Alerts Screen */
 /*		Date		Author			Purpose											 */	
 /*  24/JUN/2016	Vijay			Removed the physical table ListPageSCClinicalDecisionAlerts from SP				 */	
 /*									Why:Task #108, Engineering Improvement Initiatives- NBL(I)	 */	
 /*									108 - Do NOT use list page tables for remaining list pages (refer #107)	*/ 	
 /*********************************************************************/ 
                                                     
AS  

BEGIN
SET NOCOUNT ON;            

BEGIN TRY                                                              
                                                                                                                              
create table #ResultSet(                                                                
RowNumber      int,                                                                
PageNumber     int,                                                                
ClinicalDecisionAlertId INT,
AlertName VARCHAR(100)
)                                                                
                                                               
                                                                        
insert into #ResultSet(                                                                
  ClinicalDecisionAlertId,
	AlertName            
 )                                                               
SELECT ClinicalDecisionAlertId,
		AlertName
	   
FROM ClinicalDecisionAlerts as cda
where ISNULL(cda.RecordDeleted,'N') = 'N';


WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
			AS (SELECT ClinicalDecisionAlertId,
						AlertName 
				,Count(*) OVER () AS TotalCount
				, row_number() over (order by case when @SortExpression= 'AlertName' then AlertName end,                                                          
					case when @SortExpression= 'AlertName desc' then AlertName end desc,                                                                
                                                case when @SortExpression= 'ClinicalDecisionAlertId' then ClinicalDecisionAlertId end,                                                                    
                                                case when @SortExpression= 'ClinicalDecisionAlertId desc' then ClinicalDecisionAlertId end desc,                                                        
			                                    ClinicalDecisionAlertId) as RowNumber                                                                
               from #ResultSet) -- rn on rn.ClinicalDecisionAlertId = d.ClinicalDecisionAlertId  
               
		SELECT TOP (CASE WHEN (@PageNumber = - 1)
						THEN (SELECT ISNULL(TotalRows, 0) FROM Counts)
					ELSE (@PageSize)
					END
				)  ClinicalDecisionAlertId,
					AlertName,    
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

		SELECT ClinicalDecisionAlertId,
				AlertName
		FROM #FinalResultSet
		ORDER BY RowNumber    
END TRY		
	 BEGIN CATCH
          DECLARE @error VARCHAR(8000)

          SET @error= CONVERT(VARCHAR, Error_number()) + '*****'
                      + CONVERT(VARCHAR(4000), Error_message())
                      + '*****'
                      + Isnull(CONVERT(VARCHAR, Error_procedure()),
                      'ssp_SCClinicalDecisionAlerts')
                      + '*****' + CONVERT(VARCHAR, Error_line())
                      + '*****' + CONVERT(VARCHAR, Error_severity())
                      + '*****' + CONVERT(VARCHAR, Error_state())

          RAISERROR (@error,-- Message text.
                     16,-- Severity.
                     1 -- State.
          );
      END CATCH	                                                          
                                         
 END
