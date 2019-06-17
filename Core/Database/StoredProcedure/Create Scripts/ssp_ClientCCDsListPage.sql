 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ClientCCDsListPage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ssp_ClientCCDsListPage]
GO

CREATE Procedure [dbo].[ssp_ClientCCDsListPage]        
 @SessionId varchar(30),                                                
 @InstanceId int,                                                
 @PageNumber int,                                                    
 @PageSize int,                                                    
 @SortExpression varchar(100),        
 @OtherFilter int,        
 @Direction varchar(50),         
 @FromDate  DateTime,                                                
 @ToDate DateTime    
 
/*********************************************************************/                                                                            
 /* Stored Procedure: [ssp_ClientCCDsListPage]      */                                                                   
 /* Creation Date:  19/DEC/2011               */                                                                            
 /* Purpose: To Get The Data on List Page of ContinuityofCareDocument Screen */                                                                          
 /* Input Parameters: @SessionId ,@InstanceId,@PageNumber,@PageSize,@SortExpression ,@OtherFilter                  */                                                                          
 /* Output Parameters:   Returns The Two Table, One have the apge Information and second table Contain the List Page Data  */                                                                            
 /* Called By: Client Tab for ContinuityofCareDocument List Page(Threshold)              */                                                                  
 /* Data Modifications:              */                                                                            
 /*   Updates:                */                                                                            
 /*   Date     Author           */                                                                            
 /*   19/DEC/2011       Saurav Pande          */    
 /*   27/DEC/2011       Saurav Pande    changed filter condition on basis of date      */       
 --   11/JAN/2012		MSuma			Formatted Received Date                                                                       
  --  13/JUNe/2012		Amit Kumar Srivastava	check for xmldata should not be null,#1775, Continuity of care Document :Throwing Exception on the page, PM Web Bugs
  --  31/Oct,2012       Rakesh-II  recordDeleted condition in where clause addded for table ClientCCDs Task 28 in Newaygo implementatin tasks
  --  10/Nov,2014       Vaibhav Khare  Added column File type
  --  05/JUN,2016		Ravichandra		Removed the physical table ListPageSCContinuityofCareDocuments from SP
  --									Why:Task #108, Engineering Improvement Initiatives- NBL(I)	
  --									108 - Do NOT use list page tables for remaining list pages (refer #107)	 	
 /*********************************************************************/ 
       
           
 AS        
BEGIN        
        
Begin TRY        
        
 DECLARE @ApplyFilterClick AS CHAR(1)        
 SET @ApplyFilterClick ='N'        
 DECLARE @CustomFiltersApplied CHAR(1)         
 DECLARE @CustomFilters table (ClientCCDId INT)    
 
          
 CREATE Table #ResultSet (       
 ClientCCDId int,        
 Direction Varchar(50),      
 Received  DateTime,                                                
 Src  Varchar(50),        
 Destination varchar(50),  
 XmlData varchar(max),
 FileType  Varchar(500)      
 )        
 --IF @TimePeriod!=5        
 --Begin        
 --SET @BeginDate=dbo.GetTimePeriod(@TimePeriod)        
 --SET @EndDate = GETDATE()        
 --End        
         
        
  INSERT INTO #ResultSet        
  (        
 ClientCCDId,       
 Received, 
 Src,       
 Direction,   
 XmlData,
 FileType  
  )        
  SELECT        
 ClntCCd.ClientCCDId,       
 ClntCCd.TransferDate, 
 null,     
 case when ClntCCd.IncomingOutGoing = 'I' then 'Incoming'   
   when ClntCCd.IncomingOutGoing = 'o' then 'Outgoing'   
   else ClntCCd.IncomingOutGoing end as IncomingOutGoing,        
 ClntCCd.XmlData,
 dbo.csf_GetGlobalCodeNameById(ClntCCd.FileType)
   FROM        
  ClientCCDs as ClntCCd      
  WHERE 
  ( @FromDate <> '' and (ClntCCd.CreatedDate  >=  @FromDate ) or isnull(@FromDate, '') = '')                                              
   and ( @ToDate <> ''  and (ClntCCd.CreatedDate <  convert(varchar(10), dateadd(dd, 1, @ToDate), 101))or isnull(@ToDate, '') = '')                                            
  --(@FromDate is null or cast(convert(varchar(10),ClntCCd.CreatedDate,101) as datetime) >= @FromDate)                                                                             
  --and (@ToDate is null or cast(convert(varchar(10),ClntCCd.CreatedDate,101) as datetime) <dateadd(dd, 1, @ToDate)) 
  and (RTRIM(LTrim(ISNULL(@Direction,''))) =''  or ClntCCd.IncomingOutgoing = cast(convert(varchar(50),@Direction) as CHAR)  )  
  and XMLData is not null  and isnull(RecordDeleted,'N')='N'          
        
         
            
 --Get custom filters                                                
 IF @OtherFilter > 10000                               
 BEGIN                          
 SET @CustomFiltersApplied = 'Y'                          
 INSERT INTO @CustomFilters (ClientCCDId)                                                
 EXEC scsp_ListPageMemberLifeEvent @OtherFilter = @OtherFilter                              
 END    
 
 ;
  
  WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
			AS (SELECT ClientCCDId,       
					 Received,       
					 Direction,
					 Src,      
					 XmlData,
					 FileType  
					,Count(*) OVER () AS TotalCount
					,row_number() over(                                                                  
										  order by case when @SortExpression= 'Received' then  Received end,                                                                  
										  case when @SortExpression= 'Received desc' then Received end desc ,                                                                  
										  case when @SortExpression= 'Direction' then Direction end ,                                                                  
										  case when @SortExpression= 'Direction desc' then Direction end desc,                                                                  
										  case when @SortExpression= 'Src' then Src end,                                                                  
										  case when @SortExpression= 'Src desc' then Src end desc,                                                
										  case when @SortExpression= 'Destination' then Destination end,              
										  case when @SortExpression= 'Destination desc' then Destination end desc, 
										  case when @SortExpression= 'FileType' then Destination end,              
										  case when @SortExpression= 'FileType desc' then Destination end desc ,                                                                      
										  ClientCCDId) as RowNumber   
												FROM #ResultSet	)
		SELECT TOP (CASE WHEN (@PageNumber = - 1)
						THEN (SELECT ISNULL(TotalRows, 0) FROM Counts)
					ELSE (@PageSize)
					END
				)  ClientCCDId,       
					 Received,       
					 Direction,
					 Src,      
					 XmlData,
					 FileType  
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

		SELECT ClientCCDId,    
					convert(varchar(19), Received, 101)+ ' '+  
				ltrim(substring(convert(varchar(19), Received, 100), 12, 6) )+ ' '+ 
				ltrim(substring(convert(varchar(19), Received, 100), 18, 2) )   AS Received   ,   
					 Direction, 
					  Src,     
					 XmlData,
					 FileType  
		FROM #FinalResultSet
		ORDER BY RowNumber
	END TRY  
 
 
     
  BEGIN CATCH
          DECLARE @error VARCHAR(8000)

          SET @error= CONVERT(VARCHAR, Error_number()) + '*****'
                      + CONVERT(VARCHAR(4000), Error_message())
                      + '*****'
                      + Isnull(CONVERT(VARCHAR, Error_procedure()),
                      'ssp_ClientCCDsListPage')
                      + '*****' + CONVERT(VARCHAR, Error_line())
                      + '*****' + CONVERT(VARCHAR, Error_severity())
                      + '*****' + CONVERT(VARCHAR, Error_state())

          RAISERROR (@error,-- Message text.
                     16,-- Severity.
                     1 -- State.
          );
      END CATCH
  END 

      
GO
