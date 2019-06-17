/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCStaffTarget]    Script Date: 03/07/2012 11:51:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageSCStaffTarget]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPageSCStaffTarget]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCStaffTarget]    Script Date: 03/07/2012 11:51:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create procedure [dbo].[ssp_ListPageSCStaffTarget]                                                                           
@SessionId VARCHAR(30),
@InstanceId INT,
@PageNumber INT,
@PageSize INT,
@SortExpression VARCHAR(100),  
@ProgramId INT, 
@OtherFilter INT, 
@EffectivDate DATETIME,
@LoggedInStaffId INT,
@StaffId INT
/*********************************************************************************/          
/* Stored Procedure: ssp_ListPageSCStaffTarget	 	       						 */ 
/* Copyright: Streamline Healthcare Solutions									 */          
/* Creation Date:  13-Feb-2012													 */          
/* Purpose: Used by Staff Target List Page For Admin							 */         
/* Input Parameters:															 */        
/* Output Parameters:SessionId,InstanceId,PageNumber,PageSize,SortExpression,	 */
/*					 OtherFilter,EffectivDate,userId,ProgramId					 */        
/* Return:																	     */          
/* Called By: 																	 */          
/* Calls:																		 */          
/* Data Modifications:															 */          
/* Updates:																		 */          
/* Date			 Author         Purpose											 */          
/* 07-March-2012 Vikas Kashyap	Created											 */
/* 23-Oct-2012	 Vikas Kashyap  What:@EffectivDate is future and PTD.EndDate is null then featching record not correct*/
/*								Why:When PTD.EndDate is null then set Enddate set as a @EffectiveDateFilter .,w.r.t. Task#2090 TH Bugs/Features*/         
/* 5 JUN,2016	  Vijay			Removed the physical table  ListPageSCStaffTargetTemplates from SP
								Why:Task #108, Engineering Improvement Initiatives- NBL(I)	
								108 - Do NOT use list page tables for remaining list pages (refer #107) */	 
/*********************************************************************************/     
AS                                                        
BEGIN   
SET NOCOUNT ON;            
BEGIN TRY     
                                                       
	CREATE TABLE #ResultSet(                                                                  
	RowNumber				INT,                                                                  
	PageNumber				INT,                                                                  
	StaffTargetTemplateId	INT,
	StaffId					INT,
	StaffName				VARCHAR(100),
	Team					VARCHAR(100),
	StartDate				DATETIME,
	Hours					VARCHAR(1000)
	)   
	                                         
	                                                 
	DECLARE @CustomFilters TABLE (StaffTargetTemplates INT)                                                                       
	                                                                 
                                                                          
                                          
 IF @OtherFilter > 10000                           
 BEGIN                                                      
 EXEC scsp_ListPageSCStaffTarget @OtherFilter = @OtherFilter                                 
 END  
 
 INSERT INTO #ResultSet(                                                                  
	StaffTargetTemplateId,
	StaffId,
	StaffName,
	Team,
	StartDate,
	Hours	     
	)                                                                 
	SELECT STT.StaffTargetTemplateId,
		S.StaffId,
		COALESCE(S.LastName,'') + ', ' + COALESCE(S.FirstName,'') As [StaffName],
		P.ProgramName,
		STT.StartDate,
		[dbo].[csfGetHoursCalculation](STT.StartDate
	   ,STT.EndDate
	   ,ISNULL(STT.ProductivityTargetId,0)
	   ,ISNULL(STT.OffsetId1,0)
	   ,ISNULL(STT.OffsetId2,0)
	   ,ISNULL(STT.OffsetId3,0)
	   ,ISNULL(STT.AdditionalOffset,0)
	   ,ISNULL(STT.MultiplierOffsetId,0)
	   ,ISNULL(STT.PercentageWorked,0)
	   ,ISNULL(STT.ProductivityTargetMultiplier,100)
	   ,ISNULL(STT.Offset1Multiplier,0)
	   ,ISNULL(STT.Offset2Multiplier,0)
	   ,ISNULL(STT.Offset3Multiplier,0)
	   ,'C')  AS [Hours]
	FROM StaffTargetTemplates AS STT
	LEFT JOIN Staff AS S ON S.StaffId=STT.StaffId 
	LEFT JOIN Programs AS P ON P.ProgramId=STT.ProgramId AND  ISNULL(STT.RecordDeleted,'N') = 'N' 
	WHERE  ISNULL(S.RecordDeleted,'N') = 'N' AND
	ISNULL(STT.RecordDeleted,'N') = 'N'
	--AND(((STT.EndDate is null And STT.StartDate >= @EffectivDate) OR (@EffectivDate BETWEEN STT.StartDate AND STT.EndDate))
	--OR ISNULL(@EffectivDate,'')='')
	AND (@EffectivDate>=STT.StartDate or isnull(@EffectivDate,'') = '')
    --AND (@EffectivDate<=isnull(STT.EndDate,getdate())  or isnull(@EffectivDate,'') = '')
    AND (@EffectivDate<=isnull(STT.EndDate,@EffectivDate)  or isnull(@EffectivDate,'') = '')
	AND (STT.ProgramId=@ProgramId OR @ProgramId=0);
	
	
	WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
			AS (SELECT StaffTargetTemplateId,
						StaffId,
						StaffName,
						Team,
						StartDate,
						Hours	  
				,Count(*) OVER () AS TotalCount
				,row_number() over (ORDER BY 
						CASE WHEN @SortExpression= 'StaffTargetTemplateId'		THEN StaffTargetTemplateId END,                                                            
						CASE WHEN @SortExpression= 'StaffTargetTemplateId desc'	THEN StaffTargetTemplateId END DESC,                                                                  
						CASE WHEN @SortExpression= 'StaffName'					THEN StaffName END,                                                            
						CASE WHEN @SortExpression= 'StaffName desc'				THEN StaffName END DESC,                                                               
						CASE WHEN @SortExpression= 'Team'						THEN Team END,                                                                      
						CASE WHEN @SortExpression= 'Team desc'					THEN Team END DESC,     
						CASE WHEN @SortExpression= 'StartDate'					THEN StartDate END,                                                            
						CASE WHEN @SortExpression= 'StartDate desc'				THEN StartDate END DESC,  
						CASE WHEN @SortExpression= 'Hours'						THEN Hours END,                                                            
						CASE WHEN @SortExpression= 'Hours desc'					THEN Hours END DESC,                                                                                                                    
						Hours,
                        StaffTargetTemplateId) as RowNumber                                                                  
               FROM #ResultSet) 
               
		SELECT TOP (CASE WHEN (@PageNumber = - 1)
						THEN (SELECT ISNULL(TotalRows, 0) FROM Counts)
					ELSE (@PageSize)
					END
				) StaffTargetTemplateId,
						StaffId,
						StaffName,
						Team,
						StartDate,
						Hours,    
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

		SELECT StaffTargetTemplateId,
				StaffId,
				StaffName,
				Team,
				StartDate,
				Hours   
		FROM #FinalResultSet
		ORDER BY RowNumber
		
		
	END TRY	                      
BEGIN CATCH              
 DECLARE @Error varchar(8000)                                                             
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                           
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_ListPageSCStaffTarget')                                                                                           
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
GO


