 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_SCListPageLaboratoriesClient')
    BEGIN
        DROP  Procedure  ssp_SCListPageLaboratoriesClient 
    END

GO
                                                                     
CREATE procedure [dbo].[ssp_SCListPageLaboratoriesClient]                                                                           
@SessionId varchar(30),                                                                  
@InstanceId int,                                                                  
@PageNumber int,                                                                      
@PageSize int,                                                                      
@SortExpression varchar(100),                                                                             
@LaboratoryIdFilter int,                                                                              
@ClientIdFilter int,                                 
@StatusFilter int,                                                                 
@FromDateFilter datetime,                                                                   
@ToDateFilter datetime,  
@OtherFilter int                                                            
AS                                                                  
 /******************************************************************************************************************/                                                      
/* Stored Procedure: [ssp_SCListPageLaboratoriesClient]															   */                                             
/* Copyright: 2011 Streamlin Healthcare Solutions																   */           
/* Author: Maninder																								   */                                                     
/* Creation Date:  Dec 14,2011																					   */                                                      
/* Purpose: Get Data for list page in Client Tab tab for LabResults												   */                                                     
                                                
/* Output Parameters:None																							*/                                                      
/* Return:																											*/                                                      
/* Calls:																											*/          
/* Called From:  Laboratories.GetLaboratoriesClientList() from Dataservice											*/                                                      
/* Data Modifications:																								*/                                                      
/*																													*/  
/*-------------Modification History--------------------------														*/  
/*       Date             Author		Purpose																		*/  
/*  14/12/2011      Maninder            Created																		*/   
/*  29/12/2011      Sudhir Singh        Updated																		*/  
/* 30.08.2016      Ravichandra			Removed the physical table ListPageSCLaboratoryClientResults from SP
										Why:Task #108, Engineering Improvement Initiatives- NBL(I)	
										108 - Do NOT use list page tables for remaining list pages (refer #107)		*/	   
/*****************************************************************************/   
BEGIN
BEGIN TRY                                                                                                                            
CREATE TABLE #ResultSet(                                                                                                                                 
			LaboratoryResultId  int,                                                                                 
			ClientId int,                                                                      
			[Status] int,                                                    
			DateReceived datetime,  
			StatusText varchar(100),  
			LaboratoryName varchar(250),  
			LaboratoryAddress varchar(200),  
			ClientOrderId int   
			)                                                                  
  
declare @CustomFilters table (LaboratoryResultId int)                                                                       
                                                                        
INSERT INTO #ResultSet(                                                                  
			  LaboratoryResultId,                                                                  
			  ClientId ,                                                                                 
			  [Status],                                                                  
			  DateReceived,                                                                  
			  StatusText,                                                                                   
			  LaboratoryName,                                                                  
			  LaboratoryAddress,                                                                  
			  ClientOrderId                      
			 )                                                                 
SELECT      DISTINCT  LR.LaboratoryResultId, 
			LR.ClientId, 
			GC.GlobalCodeId,
			LR.DateReceived,
			GC.CodeName,  
			LR.LaboratoryName, 
			isnull(LR.LaboratoryAddress,'')+', '+ISNULL(LR.LaboratoryCity,'')+', '+ISNULL(LR.LaboratoryState,'')+ ' '+ISNULL(LR.LaboratoryZip,'') as  LaboratoryAddress,  
			LR.ClientOrderId  
		FROM   dbo.LaboratoryResults LR 
		LEFT OUTER JOIN dbo.Laboratories LAB ON LR.LaboratoryId = LAB.LaboratoryId 
						AND ISNULL(LAB.RecordDeleted,'N')='N' --Updated by Sudhir Singh         
		LEFT OUTER JOIN  dbo.GlobalCodes GC ON LR.Status = GC.GlobalCodeId  
WHERE    (LR.LaboratoryId =@LaboratoryIdFilter or ISNULL(@LaboratoryIdFilter,0)=0)  
	AND (CAST((ISNULL(LR.DateReceived,@FromDateFilter)) as DATE ) BETWEEN CAST(@FromDateFilter AS DATE) and CAST(@ToDateFilter AS DATE))
   --AND (convert(datetime,convert(varchar,isnull(LR.DateReceived,@FromDateFilter),101)) between @FromDateFilter and @ToDateFilter)   
   AND (LR.ClientId=@ClientIdFilter)  
   AND (LR.Status=@StatusFilter OR ISNULL(@StatusFilter,0)=0)  
   AND ISNULL(LR.RecordDeleted,'N')='N' 
                                                                            
----                                                                  
---- Apply custom filters                                                                  
----                                                                  
                                           
if @OtherFilter > 10000                                                                  
begin                                               
  insert into @CustomFilters (LaboratoryResultId)                                                                  
   exec scsp_ListPageSCLaboratoriesResult @OtherFilter = @OtherFilter                                                                  
                                                                  
  delete d                                                                  
    from #ResultSet d  where not exists(select * from @CustomFilters f where f.LaboratoryResultId = d.LaboratoryResultId)                                                                  
end    

;WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
			AS (SELECT  LaboratoryResultId,                                                                  
				  ClientId ,                                                                                 
				  [Status],                                                                  
				  DateReceived,                                                                  
				  StatusText,                                                                                   
				  LaboratoryName,                                                                  
				  LaboratoryAddress,                                                                  
				  ClientOrderId          
				,Count(*) OVER () AS TotalCount
				,row_number() over (order by case when @SortExpression= 'DateReceived' then DateReceived end,                                                            
											case when @SortExpression= 'DateReceived desc' then DateReceived end desc,                                                                  
											case when @SortExpression= 'LaboratoryResultId' then LaboratoryResultId end,                                                                      
											case when @SortExpression= 'LaboratoryResultId desc' then LaboratoryResultId end desc,                                                           
											case when @SortExpression= 'StatusText' then StatusText end,                                                                      
											case when @SortExpression= 'StatusText desc' Then StatusText end desc,                                                                  
											case when @SortExpression= 'ClientId' then ClientId end,                                                            
											case when @SortExpression= 'ClientId desc' then ClientId end desc,                                                                   
											case when @SortExpression= 'LaboratoryName' then LaboratoryName end,                                                                      
											case when @SortExpression= 'LaboratoryName desc' Then LaboratoryName end desc,                                                                  
											case when @SortExpression= 'LaboratoryAddress' then LaboratoryAddress end,                                                                      
											case when @SortExpression= 'LaboratoryAddress desc' Then LaboratoryAddress end desc,                 
											case when @SortExpression= 'ClientOrderId' then ClientOrderId end,                                                                      
											case when @SortExpression= 'ClientOrderId desc' then ClientOrderId end desc,   
											LaboratoryResultId) as RowNumber                                                        
               from #ResultSet)
               
		SELECT TOP (CASE WHEN (@PageNumber = - 1)
						THEN (SELECT ISNULL(TotalRows, 0) FROM Counts)
					ELSE (@PageSize)
					END
				)   LaboratoryResultId,                                                                  
				  ClientId ,                                                                                 
				  [Status],                                                                  
				  DateReceived,                                                                  
				  StatusText,                                                                                   
				  LaboratoryName,                                                                  
				  LaboratoryAddress,                                                                  
				  ClientOrderId    ,                              
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

		SELECT		 LaboratoryResultId,                                                                  
				  ClientId ,                                                                                 
				  [Status],                                                                  
				  DateReceived,                                                                  
				  StatusText,                                                                                   
				  LaboratoryName,                                                                  
				  LaboratoryAddress,                                                                  
				  ClientOrderId             
		FROM #FinalResultSet
		ORDER BY RowNumber      

             
END TRY   
BEGIN CATCH                                            
                                          
DECLARE @Error varchar(8000)                                                                                         
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())         
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCListPageLaboratoriesClient')                                                                                                                       
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
