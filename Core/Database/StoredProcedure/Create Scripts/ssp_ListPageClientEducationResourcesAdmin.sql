/****** Object:  StoredProcedure [dbo].[ssp_ListPageClientEducationResourcesAdmin]    Script Date: 06/13/2015 16:50:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageClientEducationResourcesAdmin]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPageClientEducationResourcesAdmin]
GO



/****** Object:  StoredProcedure [dbo].[ssp_ListPageClientEducationResourcesAdmin]    Script Date: 06/13/2015 16:50:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[ssp_ListPageClientEducationResourcesAdmin]        
 -- Add the parameters for the stored procedure here        
         
 ---Mandatory to add the below 6 Parameters for each List Page         
         
 @SessionId varchar(30),                                                
 @InstanceId int,                                                
 @PageNumber int,                                                    
 @PageSize int,                                                    
 @SortExpression varchar(100),        
 @ClientId int,        
 @InformationType char(1),      
 @OtherFilter  int      
  
  
/*******************************************************************************************************/                                                        
/* Stored Procedure: dbo.ssp_ListPageClientEducationResourcesAdmin                                     */                                                        
/* Creation Date:   03/05/2011                                                                         */                                                        
/* Purpose: To get list of record ClientEducationResourcesAdmin list page                              */                                                        
/* Input Parameters:                                                                                   */                                                        
/* @SessionId,@InstanceId,@PageNumber,@PageSize,@SortExpression,@ClientId,@InformationType,@OtherFilter*/                                                        
/* Output Parameters:                                                                                  */                                                        
/*                                                                                                     */                                                        
/* Return Status:                                                                                      */                                                        
/* Calls:                                                                                              */                                                        
/* Data Modifications:                                                                                 */                                                        
/* Updates:                                                                                            */                                                        
/*   Date              Author             Purpose                                                        */      
/*   03/05/2011        Jagdeep Hundal     Created                                                        */      
/*   27/July/2011	   Karan			  ALTERED                 */  
/*   29/March/2012	   Maninder			  Added Column ListPageSCClientEducationResourceId to #ResultSet  */                                                             
/*   15/Oct/2014	   PPOTNURU			  Modified Table Name*/
/*   9/JUN/2016	       Ravichandra		  Removed the physical table ListPageSCClientEducationResources from SP
										  Why:Task #108, Engineering Improvement Initiatives- NBL(I)	
										  108 - Do NOT use list page tables for remaining list pages (refer #107) */	 	
/*********************************************************************/                                                     
          
 AS 
    BEGIN              
        BEGIN TRY        
    
 -- SET NOCOUNT ON added to prevent extra result sets from        
 
 SET NOCOUNT ON;        
        
 --@ApplyFilterClicked variable is used to store value 'Y' when user clicked on Filter Button otherwise its value    will be 'N'        
         
 DECLARE @ApplyFilterClicked char(1)        
 SET @ApplyFilterClicked='N'        
         
 CREATE TABLE #ResultSet        
 (           
   --Mandatory Field For All List Page Related Table Data 
   ListPageSCClientEducationResourceId [bigint] identity(1,1) NOT NULL,
             
   --- Below field are which you have to show in the grid         
   --- and exists in the table which you have created for List.        
   InformationType varchar(100),        
   Value  varchar(MAX),          
   DocumentDescription varchar(250),             
   DocumentType varchar(10),        
   ResourceURL  varchar(MAX),        
   ClientEducationResourceId INT    
 )                
         
   
  --Insert data in to temp table which is fetched below by appling filter.        
  INSERT INTO #ResultSet         
  (        
   InformationType,        
   Value,          
   DocumentDescription,             
   DocumentType,        
   ResourceURL,          
   ClientEducationResourceId    
  )     
    --case InformationType when 'M' then 'Medication' when 'H' then 'Lab/Vitals' when 'D' then 'Diagnosis'  end,    
        --case DocumentType when 'R' then 'Report' when 'U' then 'URL' when 'P' then 'PDF'  end         
  SELECT case InformationType when 'M' then 'Medication' when 'H' then 'Health Data Element' when 'D' then 'Diagnosis' when 'O' then 'Orders' when 'T' then 'Health Maintenance Template' end,
		[dbo].GetClientEducationValues(CER.InformationType,CER.EducationResourceId,CER.AllMedications,CER.AllDiagnoses,CER.ParameterType) ,
		[Description],
		case DocumentType when 'R' then 'Report' when 'U' then 'URL' when 'P' then 'PDF'  end,
		ResourceURL,
		EducationResourceId                            
  FROM EducationResources CER       
  WHERE (InformationType = @InformationType 
				OR @InformationType is null 
				OR @InformationType=''
		) 
		AND IsNull(RecordDeleted, 'N') = 'N'            
       
;WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
		AS (SELECT InformationType,        
				   Value,          
				   DocumentDescription,             
				   DocumentType,        
				   ResourceURL,          
				   ClientEducationResourceId    
				,Count(*) OVER () AS TotalCount
				,row_number() over(        
								   order by case when @SortExpression= 'InformationType' then  InformationType end,        
								   case when @SortExpression= 'InformationType desc' then InformationType end desc ,        
								   case when @SortExpression= 'Value' then Value end ,        
								   case when @SortExpression= 'Value desc' then Value end ,        
								   case when @SortExpression= 'DocumentDescription' then DocumentDescription end,        
								   case when @SortExpression= 'DocumentDescription desc' then DocumentDescription end desc ,        
								   case when @SortExpression= 'DocumentType' then DocumentType end desc ,        
								   case when @SortExpression= 'DocumentType desc' then DocumentType end desc ,       
																					ClientEducationResourceId,
									ListPageSCClientEducationResourceId ) as RowNumber                                                                
			FROM #ResultSet	)
		SELECT TOP (CASE WHEN (@PageNumber = - 1)
						THEN (SELECT Isnull(TotalRows, 0) FROM Counts)
					ELSE (@PageSize)
					END
				   )	 
					InformationType,        
					Value,          
					DocumentDescription,             
					DocumentType,        
					ResourceURL,          
					ClientEducationResourceId,        
					TotalCount,
					RowNumber
		INTO #FinalResultSet
		FROM RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

		IF (SELECT Isnull(Count(*), 0)	FROM #FinalResultSet) < 1
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
						THEN Isnull((Totalcount / @PageSize), 0)
					ELSE Isnull((Totalcount / @PageSize), 0) + 1
					END AS NumberOfPages
				,Isnull(Totalcount, 0) AS NumberofRows
			FROM #FinalResultSet
		END

	SELECT	InformationType,        
			Value,          
			DocumentDescription,             
			DocumentType,        
			ResourceURL,          
			ClientEducationResourceId    
		FROM #FinalResultSet
		ORDER BY RowNumber         
         
 
  END TRY              
        BEGIN CATCH              
            DECLARE @Error VARCHAR(8000)                                                             
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
                + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                         'ssp_ListPageClientEducationResourcesAdmin') + '*****'
                + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
                + CONVERT(VARCHAR, ERROR_STATE())                                        
            RAISERROR                                                                                           
 (                 
   @Error, -- Message text.                                                                                          
   16, -- Severity.                                                                                          
   1 -- State.                                                                                          
  );               
        END CATCH              
    END 


GO




