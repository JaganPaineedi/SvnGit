IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_ListPageSCProductivityTargets')
	BEGIN
		DROP  Procedure  ssp_ListPageSCProductivityTargets
	END

GO

CREATE PROCEDURE [dbo].[ssp_ListPageSCProductivityTargets]   
@SessionId varchar(30),                                          
@InstanceId int,                                          
@PageNumber int,                                              
@PageSize int,                                              
@SortExpression varchar(100),  
@StaffId int,          
@StatusFilter int,
@EffectiveDateFilter varchar (20),
@OtherFilter int  


/*+*/                                                                                    
/* Stored Procedure:  ssp_ListPageSCProductivityTargets              */                                                                                    
/* Copyright:         2010 Streamline Healthcare Solutions           */                                                                                    
/* Creation Date:     06 March 2012                                  */    
/* Creation By:       Jagdeep Hundal                                 */                                                                                       
/* Purpose:           Used by ProductivityTargets list page          */                                                                                   
/* Input Parameters:  @SessionId,@InstanceId,@PageNumber,            */
/*                    @PageSize,@SortExpression,@effectiveDateFilter */
/*                    @StaffId,@statusFilter,@otherFilter            */
/* Called By:         ProductivityTargets list page                  */                                                                                    
/* Updates:                                                          */                                                                                    
/*  Date         Author         Purpose								 */        
/* 26-Apr-2012   Jagdeep Hundal Modify for billing rate format		 */
/* 23-Oct-2012	 Vikas Kashyap  What:@EffectiveDateFilter is future and PTD.EndDate is null then featching record not correct*/
/*								Why:When PTD.EndDate is null then set Enddate set as a @EffectiveDateFilter .,w.r.t. Task#2090 TH Bugs/Features*/
/* 30-May-2016    vijay         Why:Task #108, Engineering Improvement Initiatives- NBL(I)	*/
/*								108 - Do NOT use list page tables for remaining list pages (refer #107)	  */          
/*********************************************************************/                                          
as                                                              
 Begin                                                                          
 Begin try     
  declare @StatusFilterText char(1)
  declare @ApplyFilterClicked char(1)
  set @ApplyFilterClicked = 'Y'
  
  
  if(@StatusFilter=0)
  set @StatusFilterText='N'
  if(@StatusFilter=1)
  set @StatusFilterText='Y' 
  if(@StatusFilter=-1)
  set @StatusFilterText=''         
                        
create table #ResultSet(                                                                  
   ProductivityTargetId Int,  
   TargetName varchar(100),      
   Active  char(1),        
   TargetOffset char(1),           
   HoursFraction  decimal(18,2),      
   BillingRate decimal(18,2)           
                         
)                                          
                                                  
insert into #ResultSet(                            
   ProductivityTargetId,  
   TargetName,      
   Active,        
   TargetOffset,     
   HoursFraction,        
   BillingRate                          
)   
  
 SELECT distinct PT.ProductivityTargetId,
        PT.TargetName,      
		PT.Active,        
		PT.TargetOrOffset,     
		PTD.HourOrFraction,        
		PTD.BillingRate  
 
 FROM ProductivityTargets PT  
 left join ProductivityTargetDates PTD ON PTD.ProductivityTargetId = PT.ProductivityTargetId  AND ISNULL(PTD.RecordDeleted, 'N') = 'N'   
 --left join GlobalCodes GV on PT.Active =GV.ExternalCode1
  where  case @StatusFilterText when '' then '' when 'N' then isnull(PT.Active,'N') when 'Y' then PT.Active end =@StatusFilterText

 --(PT.Active = @StatusFilterText or isnull(PT.Active,'N') = 'N')
 AND (@EffectiveDateFilter>=PTD.StartDate or isnull(@EffectiveDateFilter,'') = '')
 --AND (@EffectiveDateFilter<=isnull(PTD.EndDate,getdate())  or isnull(@EffectiveDateFilter,'') = '')
 AND (@EffectiveDateFilter<=isnull(PTD.EndDate,@EffectiveDateFilter)  or isnull(@EffectiveDateFilter,'') = '')
 --AND ISNULL(GV.RecordDeleted, 'N') = 'N'
 AND ISNULL(PT.RecordDeleted, 'N') = 'N'
 
   
 ;WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
			AS (SELECT ProductivityTargetId,                                      
			 TargetName,                                                                     
			 Active,                                                                          
			 TargetOffset,                                                  
			 HoursFraction,                      
			 BillingRate     
				,Count(*) OVER () AS TotalCount
				,row_number() over (order by case when @SortExpression= 'TargetName' then TargetName end,                                              
                                                case when @SortExpression= 'TargetName desc' then TargetName end desc,                                                    
                                                case when @SortExpression= 'Active' then Active end ,                                                        
                                                case when @SortExpression= 'Active desc' then Active end desc,                                        
                                                case when @SortExpression= 'TargetOffset' then TargetOffset end,                                                        
                                                case when @SortExpression= 'TargetOffset desc' then TargetOffset end desc,                                                    
                                                case when @SortExpression= 'HoursFraction' then HoursFraction end,                                                        
                                                case when @SortExpression= 'HoursFraction desc' then HoursFraction end desc,
                                                case when @SortExpression= 'BillingRate' then BillingRate end,                                                        
                                                case when @SortExpression= 'BillingRate desc' then BillingRate end desc,    
                                                ProductivityTargetId                                                 
                                               ) as RowNumber                                                    
               from #ResultSet)
               
		SELECT TOP (CASE WHEN (@PageNumber = - 1)
						THEN (SELECT ISNULL(TotalRows, 0) FROM Counts)
					ELSE (@PageSize)
					END
				)  ProductivityTargetId,  
				   TargetName,      
				   Active,        
				   TargetOffset,     
				   HoursFraction,        
				   BillingRate,                          
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

		SELECT ProductivityTargetId,  
			   TargetName,      
				case isnull(Active,'') when ''  then 'No' when 'Y' then 'Yes' when 'N' then 'No' end as  Active,        
				case TargetOffset when 'T'  then 'Target' when 'O' then 'Offset' end as  TargetOffset,  
				convert(numeric(18,2),HoursFraction) as HoursFraction,        
				'$'+ Convert(varchar,Convert(money,BillingRate),1)as BillingRate
		FROM #FinalResultSet
		ORDER BY RowNumber
	END TRY                                                                                                   
BEGIN CATCH                              
                            
DECLARE @Error varchar(8000)                                                                           
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                        
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_ListPageSCProductivityTargets')                                                                                                         
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