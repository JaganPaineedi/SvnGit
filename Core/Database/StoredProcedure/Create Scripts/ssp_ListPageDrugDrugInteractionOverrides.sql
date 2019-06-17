  
 /****** Object:  StoredProcedure [dbo].[scsp_PMServices]    Script Date: 04/16/2011 17:34:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[ssp_ListPageDrugDrugInteractionOverrides]') AND TYPE IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPageDrugDrugInteractionOverrides]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_ListPageDrugDrugInteractionOverrides]  
      
/*********************************************************************/                                                                              
 /* Stored Procedure: [ssp_ListPageDrugDrugInteractionOverrides]      */                                                                     
 /* Creation Date:  May 17,2011          */                                                                              
 /* Purpose: To get the DrugDrugInteractionOverrides  */                                                                            
 /* Input Parameters: @SessionId ,@InstanceId,@PageNumber,@PageSize,@SortExpression ,@OtherFilter                  */                                                                            
 /* Output Parameters:   Returns The Two Table, One have the apge Information and second table Contain the List Page Data  */                                                                              
 /* Called By: Admin List Page ClientDrugDrugInteractionOverrides              */                                                                    
 /* Data Modifications:																									  */                                                                              
 /*   Updates:																											 */                                                                              
 /*   Date              Author																							 */                                                                              
 /*   02/Aug/2011       Jagdeep Hundal																					 */    
 /*   20Jan2012         Rakesh Garg		Modified Table Name ListPageDrugDrugInteractionOverrides to ListPageSCDrugDrugInteractionOverrides   
										As in DataModel  ListPageDrugDrugInteractionOverrides rename to ListPageSCDrugDrugInteractionOverrides & Some Column  */                                                                            
/*   20 JUN,2016        Ravichandra		Removed the physical table  ListPageSCDrugDrugInteractionOverrides from SP
										Why:Task #108, Engineering Improvement Initiatives- NBL(I)	
										108 - Do NOT use list page tables for remaining list pages (refer #107)	 	*/	
/*   04 JUL,2016        Ravichandra		Increased the length of Degree and Specialty column(s) from varchar(20) to varchar(250) and changed the prescriber length to varchar(70) in temp table #ResultSet 
										Why:Task #108, Engineering Improvement Initiatives- NBL(I)	
										108 - Do NOT use list page tables for remaining list pages (refer #107)	 	*/								  
 /*********************************************************************/           
          
 @SessionId varchar(30),                                                        
 @InstanceId int,                                                        
 @PageNumber int,                                                            
 @PageSize int,                                                            
 @SortExpression varchar(100),                
 @ClientId Int ,                
 @OtherFilter int                
                     
AS                
BEGIN  
              
 -- SET NOCOUNT ON added to prevent extra result sets from                
 -- interfering with SELECT statements.                
 SET NOCOUNT ON;                
                
 BEGIN TRY            
                
  CREATE TABLE #ResultSet                
  (                                
		--- Below field are which you have to show i	n the grid                 
		--- and exists in the table which you have created for List.                
   Degree VARCHAR(250),  --04 JUL,2016  Ravichandra                       
   Prescriber VARCHAR(70),  --04 JUL,2016  Ravichandra                           
   Specialty VARCHAR(250), --04 JUL,2016 Ravichandra                        
   MedicationName1 VARCHAR(100),                        
   MedicationName2 VARCHAR(100),                        
   AdjustedSeverityLevel int,                        
   DefaultSeverityLevel int,                        
   DrugDrugInteractionOverrideId   int                  
  )                        
       
                  
		--Insert data in to temp table which is fetched below by appling filter.                
	  INSERT INTO #ResultSet                 
	  (                
	   --- Write all fields (comma separated exclude PageNumber,RowNumber)                          
	   Degree ,                        
	   Prescriber,                        
	   Specialty ,                        
	   MedicationName1 ,                        
	   MedicationName2 ,                        
	   AdjustedSeverityLevel ,                        
	   DefaultSeverityLevel,                        
	   DrugDrugInteractionOverrideId                                  
	   )                  
		SELECT       
		isnull(gc.CodeName, 'All') as Degree,        
		isnull(rtrim(ltrim(s.LastName)) + ', ' + rtrim(s.FirstName), 'All') as Prescriber,        
		isnull(gc2.CodeName, 'All') as Specialty,       
		--gc.CodeName as Degree,           
		-- rtrim(ltrim(s.LastName)) + ', ' + rtrim(s.FirstName) as Prescriber,                  
		--  isnull(s.UserCode,'NA') as Prescriber,          
		--  gc2.CodeName as Specialty,              
		dbo.GetMedicationName(dd.MedicationNameId1) as MedicationName1,
		dbo.GetMedicationName(dd.MedicationNameId2) as MedicationName2,
		dd.AdjustedSeverityLevel,                     
		dd.DefaultSeverityLevel,
		dd.DrugDrugInteractionOverrideId 
		FROM DrugDrugInteractionOverrides dd               
		LEFT JOIN GlobalCodes gc On dd.Degree=gc.GlobalCodeId AND gc.Category='Degree'                
		LEFT JOIN GlobalCodes gc2 On dd.Specialty =gc2.GlobalCodeId AND gc2.Category='TAXONOMYCODE'                 
		LEFT JOIN  Staff s on dd.PrescriberId=s.StaffId             
		WHERE ISNULL(dd.RecordDeleted, 'N') = 'N'               
               
  ;WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
			AS (SELECT Degree ,                        
					   Prescriber,                        
					   Specialty ,                        
					   MedicationName1 ,                        
					   MedicationName2 ,                        
					   AdjustedSeverityLevel ,                        
					   DefaultSeverityLevel,                        
					   DrugDrugInteractionOverrideId
				,Count(*) OVER () AS TotalCount
				,row_number() over(order by case when @SortExpression= 'Degree' then  Degree end,                                            
										  case when @SortExpression= 'Degree desc' then Degree end desc ,                                            
										  case when @SortExpression= 'Prescriber' then Prescriber end ,                                            
										  case when @SortExpression= 'Prescriber desc' then Prescriber end desc,                                            
										  case when @SortExpression= 'Specialty' then Specialty end,                                            
										  case when @SortExpression= 'Specialty desc' then Specialty end desc ,                        
										  case when @SortExpression= 'MedicationName1' then MedicationName1 end,                                            
										  case when @SortExpression= 'MedicationName1 desc' then MedicationName1 end desc,                          
										  case when @SortExpression= 'MedicationName2' then MedicationName2 end,                                            
										  case when @SortExpression= 'MedicationName2 desc' then MedicationName2 end desc  ,                                               
										  case when @SortExpression= 'AdjustedSeverityLevel' then AdjustedSeverityLevel end,           
										  case when @SortExpression= 'AdjustedSeverityLevel desc' then AdjustedSeverityLevel end desc,                         
										  case when @SortExpression= 'DefaultSeverityLevel' then DefaultSeverityLevel end,                                            
										  case when @SortExpression= 'DefaultSeverityLevel desc' then DefaultSeverityLevel end desc ,
										  DrugDrugInteractionOverrideId                                    
										  ) as RowNumber             
												FROM #ResultSet	)
		SELECT TOP (CASE WHEN (@PageNumber = - 1)
						THEN (SELECT ISNULL(TotalRows, 0) FROM Counts)
					ELSE (@PageSize)
					END
					)  Degree ,                        
					   Prescriber,                        
					   Specialty ,                        
					   MedicationName1 ,                        
					   MedicationName2 ,                        
					   AdjustedSeverityLevel ,                        
					   DefaultSeverityLevel,                        
					   DrugDrugInteractionOverrideId   
			,TotalCount
			,RowNumber
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

				SELECT Degree ,                        
					   Prescriber,                        
					   Specialty ,                        
					   MedicationName1 ,                        
					   MedicationName2 ,                        
					   AdjustedSeverityLevel ,                        
					   DefaultSeverityLevel,                        
					   DrugDrugInteractionOverrideId 
		FROM #FinalResultSet
		ORDER BY RowNumber
                      
                 
  END TRY
	
	 BEGIN CATCH
          DECLARE @error VARCHAR(8000)

          SET @error= CONVERT(VARCHAR, Error_number()) + '*****'
                      + CONVERT(VARCHAR(4000), Error_message())
                      + '*****'
                      + Isnull(CONVERT(VARCHAR, Error_procedure()),
                      'ssp_ListPageDrugDrugInteractionOverrides')
                      + '*****' + CONVERT(VARCHAR, Error_line())
                      + '*****' + CONVERT(VARCHAR, Error_severity())
                      + '*****' + CONVERT(VARCHAR, Error_state())

          RAISERROR (@error,-- Message text.
                     16,-- Severity.
                     1 -- State.
          );
      END CATCH
  END 
               
          
  
  
  
  