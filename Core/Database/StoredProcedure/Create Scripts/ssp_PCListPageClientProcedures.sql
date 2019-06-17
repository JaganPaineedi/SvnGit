
/****** Object:  StoredProcedure [dbo].[ssp_PCListPageClientProcedures]    Script Date: 16-AUG-2012 17:34:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[ssp_PCListPageClientProcedures]') AND TYPE IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PCListPageClientProcedures]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

        
CREATE  PROCEDURE [dbo].[ssp_PCListPageClientProcedures]                                                                               
@PageNumber INT,    
@PageSize INT,    
@SortExpression VARCHAR(100),     
@FromDate DATETIME,     
@ToDate DATETIME,  
@IsCompleted char(1), 
@staffId INT, 
@ClientId INT, 
@OtherFilter INT     
    
    
/*********************************************************************************/              
/* Stored Procedure: ssp_PCListPageClientProcedures         */     
/* Copyright: Streamline Healthcare Solutions          */              
/* Creation Date:  16-AUG-2012               */              
/* Purpose: used by Client Procedures List Page For Staff        */             
/* Input Parameters:                */            
/* Output Parameters:PageNumber,PageSize,SortExpression,@From,@To,@IsComplete,@OrderBy  */    
/*      OtherFilter*/            
/* Return:                      */              
/* Called By:         */              
/* Calls:                   */              
/* Data Modifications:                */              
/* Updates:                   */              
/* Date              Author                  Purpose        */              
/* 24-AUG-2012       Davinder Kumar			 Created        */  
/*********************************************************************************/         
AS                                                            
BEGIN                  
BEGIN TRY         
    SET NOCOUNT ON;     
   --
	--Declare table to get data if Other filter exists -------
	--
	CREATE TABLE #ClientProcedures
	(
		ClientProcedureId INT
	)
	
	                                      
	                                                                 
 --Get custom filters                                                
 IF @OtherFilter > 10000                               
 BEGIN    
	 INSERT INTO #ClientProcedures                                                            
	 EXEC scsp_PCListPageClientProcedures @OtherFilter = @OtherFilter                                
 END      
                                                                            
                                                                     
 --	                              
	--Insert data in to temp table which is fetched below by appling filter.   
	-- 
;WITH TotalClientProcedures  AS 
(                                                                  
	SELECT    
    CP.ClientProcedureId,
	CP.OrderDate,
	CP.ProcedureDate,
	CP.OrderedBy,
	CP.IncludeInCommonList,
	CP.Completed,
	CP.ProcedureId,
	rtrim(S.LastName) + ', ' + rtrim(S.FirstName) as UserCode,
	PC.ProcedureCode,
	PC.Description    
	FROM       
	ClientProcedures AS CP 
	Left JOIN Staff AS S ON S.StaffId=CP.OrderedBy
	left join PCProcedureCodes PC on PC.PCProcedureCodeId=CP.ProcedureId
	WHERE    
	ISNULL(CP.RecordDeleted,'N') = 'N'     
	AND ISNULL(CP.Completed,'N') = CASE WHEN @IsCompleted='' OR @IsCompleted IS NULL THEN ISNULL(CP.Completed,'N') ELSE @IsCompleted END
	AND ISNULL(CP.OrderedBy,0) = CASE WHEN @staffId=0 OR @staffId IS NULL THEN ISNULL(CP.OrderedBy,0) ELSE @staffId END	 
	AND (CP.ClientId=@ClientId)
	AND((ISNULL(CONVERT(VARCHAR(10),CP.OrderDate,101),null)>= ISNULL(CONVERT(VARCHAR(10),@FromDate,101),CONVERT(VARCHAR(10),CP.OrderDate,101))) or CP.OrderDate is null)
	AND((ISNULL(CONVERT(VARCHAR(10),CP.OrderDate,101),null)<= ISNULL(CONVERT(VARCHAR(10),@ToDate,101),CONVERT(VARCHAR(10),CP.OrderDate,101)))  or CP.OrderDate is null)
	 
	--AND (CP.ProcedureDate = @To) 
	--AND (CP.OrderedBy = @staffId) 
	
),                                                                
 counts AS 
( 
	SELECT COUNT(*) AS totalrows FROM TotalClientProcedures
),
 LisClientProcedures AS 
( 
   select
	ClientProcedureId,	 
	OrderDate,
	ProcedureDate,
	OrderedBy,
	IncludeInCommonList,
	Completed,
	ProcedureId,
	UserCode,
	ProcedureCode,
	Description,                                                                  
   COUNT(*) OVER ( ) AS TotalCount ,
		ROW_NUMBER() OVER ( ORDER BY 
				CASE WHEN @SortExpression= 'ProcedureCode'    THEN ProcedureCode END,                                                                
				CASE WHEN @SortExpression= 'ProcedureCode desc'   THEN ProcedureCode END DESC,  
				CASE WHEN @SortExpression= 'Description'    THEN Description END,                                                                
				CASE WHEN @SortExpression= 'Description desc'   THEN Description END DESC,
				CASE WHEN @SortExpression= 'OrderDate'   THEN OrderDate END,                                                                          
				CASE WHEN @SortExpression= 'OrderDate desc'  THEN OrderDate END DESC,                                                                       
				CASE WHEN @SortExpression= 'ProcedureDate'   THEN ProcedureDate END,                                                                          
				CASE WHEN @SortExpression= 'ProcedureDate desc'  THEN ProcedureDate END DESC,         
				CASE WHEN @SortExpression= 'UserCode'      THEN UserCode END,                                                                
				CASE WHEN @SortExpression= 'UserCode desc'   THEN UserCode END DESC,    
				CASE WHEN @SortExpression= 'Completed'  THEN Completed END,                                                                
				CASE WHEN @SortExpression= 'Completed desc' THEN Completed END DESC    
			)AS RowNumber
		FROM TotalClientProcedures                   
)                                                      

        	SELECT TOP ( Case WHEN (@PageNumber = -1) THEN (SELECT ISNULL(totalrows,0) from counts) ELSE (@PageSize) END)
						ClientProcedureId,   
						OrderDate,    
						ProcedureDate,  
						Completed,     
						ProcedureId,  
                        UserCode,
                       ProcedureCode,
	Description, 
                        RowNumber,
                        TotalCount 
                INTO    #FinalResultSet
                FROM    LisClientProcedures
                WHERE   RowNumber > ( ( @PageNumber - 1 ) * @PageSize ) 
          
  IF (SELECT     ISNULL(COUNT(*),0) FROM   #FinalResultSet)<1
		BEGIN
			SELECT 0 AS PageNumber ,
			0 AS NumberOfPages ,
			0 NumberOfRows
		END
		ELSE
		BEGIN
			SELECT TOP 1
			@PageNumber AS PageNumber,
			CASE (TotalCount % @PageSize) WHEN 0 THEN 
			ISNULL(( TotalCount / @PageSize ), 0)
			ELSE ISNULL(( TotalCount / @PageSize ), 0) + 1 END AS NumberOfPages,
			ISNULL(TotalCount, 0) AS NumberOfRows
			FROM    #FinalResultSet     
		END         
                                         
                                                                
                                                 
                                                                    
	SELECT                                                                       
	ClientProcedureId,
	ProcedureId, 
	ProcedureCode,
	Description, 
	ISNULL(CONVERT(VARCHAR(10),OrderDate,101),'') AS OrderDate, 
	ISNULL(CONVERT(VARCHAR(10),ProcedureDate,101),'') AS ProcedureDate,  
	UserCode,
	case when (Completed is null or Completed='' or Completed='N') then 'No' else 'Yes' end as Completed  
	
 FROM #FinalResultSet                                  
	ORDER BY RowNumber  
	
	DROP TABLE #FinalResultSet
	DROP Table #ClientProcedures
    
    
END TRY                  
BEGIN CATCH                  
 DECLARE @Error varchar(8000)                                                                 
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                               
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_PCListPageClientProcedures')                                                                                               
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


 
     