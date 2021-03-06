/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCReminderType]    Script Date: 11/18/2011 16:25:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageSCReminderType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPageSCReminderType]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO         

CREATE procedure [dbo].[ssp_ListPageSCReminderType]          
(          
@SessionId varchar(30),                                                          
@InstanceId int,                                                          
@PageNumber int,                                                              
@PageSize int,                                                              
@SortExpression varchar(100),                                                          
@LoggedInStaffId int,                 
@StaffId int,           
@ReminderTypeStatus CHAR(1)      
        
)          
/********************************************************************************                                                          
-- Stored Procedure: dbo.ssp_ListPageSCReminderType                                                            
--                                                          
-- Copyright: Streamline Healthcate Solutions                                                          
--                                                          
-- Purpose: used by Reminder Type List Page                                                  
--                                                          
-- Updates:                                                                                                                 
-- Date          Author			Purpose                                                          
-- 12 July 2010  Karan Garg		Created.      
-- 16 JUN,2016 Ravichandra		Removed the physical table ListPageSCClientReminderTypes from SP
								Why:Task #108, Engineering Improvement Initiatives- NBL(I)	
								108 - Do NOT use list page tables for remaining list pages (refer #107)	 							 
*********************************************************************************/           
          
AS          
BEGIN
SET NOCOUNT ON; 
BEGIN TRY        
CREATE TABLE #ResultSet           
(                
	ListPageSCReminderTypeId int,                                                                  
	ClientReminderTypeId  int,                                  
	ReminderTypeName   varchar(250),                                                        
	Active      varchar(3)          
)            
          
    
          
INSERT INTO #ResultSet(                    
 ClientReminderTypeId,           
 ReminderTypeName,            
 Active               
 )           
 SELECT crt.ClientReminderTypeId,          
		crt.ReminderTypeName,          
            
		Case when crt.Active = 'Y' then 'Yes' else 'No' end as Active          
  FROM ClientReminderTypes crt          
  WHERE isnull(crt.RecordDeleted, 'N') = 'N'       
  and ((ISNULL(crt.Active,'N') = @ReminderTypeStatus) or (@reminderTypeStatus = '0'))    
     
   ;WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
		AS (SELECT	 ClientReminderTypeId,           
					 ReminderTypeName,            
					 Active              
				,Count(*) OVER () AS TotalCount
				,row_number() over (order by	case when @SortExpression= 'ReminderTypeName' then ReminderTypeName end,                                          
                                                case when @SortExpression= 'ReminderTypeName desc' then ReminderTypeName end desc,                                                
                                                case when @SortExpression= 'Active' then Active end,                                                    
                                                case when @SortExpression= 'Active desc' then Active end desc ,                                 
                                                ClientReminderTypeId            
												) as RowNumber                                                
			FROM #ResultSet	)
		SELECT TOP (CASE WHEN (@PageNumber = - 1)
						THEN (SELECT Isnull(TotalRows, 0) FROM Counts)
					ELSE ISNULL((@PageSize),0)
					END
				)	  ClientReminderTypeId,           
					 ReminderTypeName,            
					 Active      
			,TotalCount
			,RowNumber
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

		SELECT	ClientReminderTypeId,                                             
			   ReminderTypeName,          
			   Active   
		FROM #FinalResultSet
		ORDER BY RowNumber
  
  
        END TRY              
        BEGIN CATCH              
            DECLARE @Error VARCHAR(8000)                                                             
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
                + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                         'ssp_ListPageSCReminderType') + '*****'
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
         
           
                     
 
