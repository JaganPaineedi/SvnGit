

/****** Object:  StoredProcedure [dbo].[ssp_schooDistrictListPage]    Script Date: 06/04/2018 16:01:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_schooDistrictListPage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_schooDistrictListPage]
GO



/****** Object:  StoredProcedure [dbo].[ssp_schooDistrictListPage]    Script Date: 06/04/2018 16:01:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 
Create PROC [dbo].[ssp_schooDistrictListPage]    
 @PageNumber INT  
 ,@PageSize INT  
 ,@SortExpression VARCHAR(100)  
 ,@Status CHAR(2)  
 ,@SchoolDistrictName VARCHAR(100)  
 ,@SchoolDistrictContact VARCHAR(100)  
 ,@OtherFilter  INT 
 /********************************************************************************                                                      
-- Stored Procedure: ssp_schooDistrictListPage                                                      
--                                                      
-- Copyright: Streamline Healthcare Solutions                                                      
--                                                      
-- Purpose: Used By School District List Page                                                    
--                                                      
-- Updates:                                                                                                             
-- Date         Author                  Purpose                                                      
-- 15.03.2018   Pradeep Kumar Yadav     CREATED.            
                       
*********************************************************************************/  
AS  
BEGIN  
 BEGIN TRY  
			DECLARE @CustomFiltersApplied CHAR(1) = 'N'    
    
  CREATE TABLE #CustomFilters   
                (ClassroomAssignmentId INT NOT NULL)  
                  
                 IF @OtherFilter > 10000    
  BEGIN    
   IF OBJECT_ID('dbo.scsp_schooDistrictListPage', 'P') IS NOT NULL    
   BEGIN    
    SET @CustomFiltersApplied = 'Y'    
        
    INSERT INTO #CustomFilters (ClassroomAssignmentId)    
     EXEC scsp_schooDistrictListPage @Status = @Status,    
                                  @SchoolDistrictName = @SchoolDistrictName,   
                                  @SchoolDistrictContact = @SchoolDistrictContact,  
                                  @OtherFilter = @OtherFilter    
    
   END    
  END;
  CREATE TABLE #ResultSET (  
   SchoolDistrictId INT  
   ,DistrictName VARCHAR(200)  
   ,DistrictAddress VARCHAR(200)  
   ,ContactName VARCHAR(200)  
   ,ContactEmailAddress VARCHAR(200)  
   ,ContactPhoneNumber VARCHAR(50)  
   ,[Status] CHAR(2)  
   )  
  
  INSERT INTO #ResultSET (  
   SchoolDistrictId  
   ,DistrictName  
   ,DistrictAddress  
   ,ContactName  
   ,ContactEmailAddress  
   ,ContactPhoneNumber  
   ,[Status]  
   )  
  SELECT SD.SchoolDistrictId  
   ,SD.DistrictName  
   ,SD.DistrictAddress  
   ,SDC.LastName + ',' + SDC.FirstName AS ContactName  
   ,SDC.Email AS ContactEmailAddress  
   ,SDC.Phone AS ContactPhoneNumber  
   ,SD.Active AS [Status]  
  FROM SchoolDistricts SD  
  LEFT JOIN SchoolDistrictContacts SDC ON SD.SchoolDistrictId = SDC.SchoolDistrictId AND SDC.PrimaryContact='Y'  
  WHERE (  
    @Status = '-1'  
    OR ISNULL(SD.Active, 'N') = @Status  
    )  
   AND (  
    @SchoolDistrictName = '-1'  
    OR SD.DistrictName LIKE '%' + @SchoolDistrictName + '%'  
    )  
   AND (  
    @SchoolDistrictContact = '-1' OR @SchoolDistrictContact=''
    OR (  
     (SDC.LastName + ' ' + SDC.FirstName) LIKE '%' + @SchoolDistrictContact + '%'  
     OR SDC.LastName LIKE '%' + @SchoolDistrictContact + '%'  
     OR SDC.FirstName LIKE '%' + @SchoolDistrictContact + '%'  
     OR (SDC.LastName + ',' + SDC.FirstName) LIKE '%' + @SchoolDistrictContact + '%'  
     )  
    )  
   AND ISNULL(SD.RecordDeleted, 'N') = 'N'  
   AND ISNULL(SDC.RecordDeleted, 'N') = 'N';  
  
  WITH Counts  
  AS (  
   SELECT Count(*) AS TotalRows  
   FROM #ResultSet  
   )  
   ,RankResultSet  
  AS (  
   SELECT SchoolDistrictId  
    ,DistrictName  
    ,DistrictAddress  
    ,ContactName  
    ,ContactEmailAddress  
    ,ContactPhoneNumber  
    ,[Status]  
    ,Count(*) OVER () AS TotalCount  
    ,row_number() OVER (  
     ORDER BY CASE   
       WHEN @SortExpression = 'DistrictName'  
        THEN DistrictName  
       END  
      ,CASE   
       WHEN @SortExpression = 'DistrictName DESC'  
        THEN DistrictName  
       END DESC  
      ,CASE   
       WHEN @SortExpression = 'DistrictAddress'  
        THEN DistrictAddress  
       END  
      ,CASE   
       WHEN @SortExpression = 'DistrictAddress DESC'  
        THEN DistrictAddress  
       END DESC  
      ,CASE   
       WHEN @SortExpression = 'ContactName'  
        THEN ContactName  
       END  
      ,CASE   
       WHEN @SortExpression = 'ContactName DESC'  
        THEN ContactName  
       END DESC  
      ,CASE   
       WHEN @SortExpression = 'ContactEmailAddress'  
        THEN ContactEmailAddress  
       END  
      ,CASE   
       WHEN @SortExpression = 'ContactEmailAddress DESC'  
        THEN ContactEmailAddress  
       END DESC  
      ,CASE   
       WHEN @SortExpression = 'ContactPhoneNumber'  
        THEN ContactPhoneNumber  
       END  
      ,CASE   
       WHEN @SortExpression = 'ContactPhoneNumber DESC'  
        THEN ContactPhoneNumber  
       END DESC  
      ,CASE   
       WHEN @SortExpression = 'Status'  
        THEN [Status]  
       END  
      ,CASE   
       WHEN @SortExpression = 'Status DESC'  
        THEN [Status]  
       END DESC  
     ) AS RowNumber  
   FROM #ResultSet  
   )  
  SELECT TOP (  
    CASE   
     WHEN (@PageNumber = - 1)  
      THEN (  
        SELECT ISNULL(TotalRows, 0)  
        FROM Counts  
        )  
     ELSE (@PageSize)  
     END  
    ) SchoolDistrictId  
   ,DistrictName  
   ,DistrictAddress  
   ,ContactName  
   ,ContactEmailAddress  
   ,ContactPhoneNumber  
   ,[Status]  
   ,TotalCount  
   ,RowNumber  
  INTO #FinalResultSet  
  FROM RankResultSet  
  WHERE RowNumber > ((@PageNumber - 1) * @PageSize)  
  
  IF (  
    SELECT ISNULL(Count(*), 0)  
    FROM #FinalResultSet  
    ) < 1  
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
  
  SELECT SchoolDistrictId  
   ,DistrictName  
   ,DistrictAddress  
   ,ContactName  
   ,ContactEmailAddress  
   ,ContactPhoneNumber  
   ,Case when [Status]='Y' Then 'Active' Else 'InActive' End As [Status]  
  FROM #FinalResultSet RS  
  ORDER BY RowNumber  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_ListPageClientReminders') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.                                                                                        
    16  
    ,-- Severity.                                                                                        
    1 -- State.                                                                                        
    );  
 END CATCH  
END   
GO


