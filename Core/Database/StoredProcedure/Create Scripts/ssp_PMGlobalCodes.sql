
/****** Object:  StoredProcedure [dbo].[ssp_PMGlobalCodes]    Script Date: 04/15/2011 08:49:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[ssp_PMGlobalCodes]') AND TYPE IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMGlobalCodes]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PMGlobalCodes]    Script Date: 04/15/2011 08:49:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_PMGlobalCodes]    
/********************************************************************************                                                  
-- Stored Procedure: ssp_PMGlobalCodes
-- File			   : ssp_PMGlobalCodes.sql
-- Copyright: Streamline Healthcate Solutions
--
-- Purpose: Procedure to return data for the global codes list page.
--
-- Author:  Girish Sanaba
-- Date:    16 Apr 2011
--
-- *****History****
--				MAry Suma			Fixed Record Deleted on GlobalCodeCategories
--				Shruthi				Added one more column GlobalCodeCategoryName in ListPagePMGlobalCodes(table) getting from globalcodecategories table
-- 14/11/2011	MSuma				Modified GlobalCodeCategoryName to VARCHAR(250)
-- 12.03.2012	Ponnin Selvan		Removed default @PageNumber 
-- 4.04.2012	Ponnin Selvan		Conditions added for Export 
-- 12.04.2012   MSuma				Dropped temp table 
-- 13.04.2012    PSelvan            Added Conditions for NumberOfPages.
-- 18-May-2012	Rachna Singh		Add parameter @CodeName for partial Search
-- 17-Dec-2012	gkumar      		Moved the condition to display the category with no global codes
-- 08-04-2013  Pselvan(Modified by javed)  In case there are no global code ids  
*********************************************************************************/
                                                  
@SessionId    VARCHAR(30),  
@InstanceId    INT,  
@PageNumber    INT,  
@PageSize    INT,  
@SortExpression   VARCHAR(100),  
@CategoryName   VARCHAR(100),  
@ActiveCategory   INT,  
@ActiveCode    INT,  
@CategoryType   INT,  
@CodeName VARCHAR(250),
@OtherFilter   INT,  
@StaffId    INT  
AS       
BEGIN                                                                
 BEGIN TRY  
CREATE TABLE #CustomFilters
                (
                  GlobalCodeId INT NOT NULL 
                )                                                   
                                                   
  DECLARE @ApplyFilterClicked  CHAR(1)  
  DECLARE @CustomFiltersApplied CHAR(1)  
    
  SET @SortExpression = RTRIM(LTRIM(@SortExpression))  
  IF ISNULL(@SortExpression, '') = ''  
   SET @SortExpression= 'CategoryName'  
    
 
    
  --   
  -- New retrieve - the request came by clicking on the Apply Filter button                     
  --  
  SET @ApplyFilterClicked = 'Y'   
  SET @CustomFiltersApplied = 'N'                                                   
  --SET @PageNumber = 1  
    
  IF @OtherFilter > 10000                                      
  BEGIN  
   SET @CustomFiltersApplied = 'Y'  
     
   INSERT INTO #CustomFilters (GlobalCodeId)   
   EXEC scsp_PMGlobalCodes   
    @CategoryName   = @CategoryName,  
    @ActiveCategory   = @ActiveCategory,  
    @ActiveCode    = @ActiveCode,  
    @CategoryType   = @CategoryType,  
    @CodeName	=	@CodeName, 
    @OtherFilter   = @OtherFilter,  
    @StaffId    = @StaffId  
  END   
  
	 --ALTER TABLE #CustomFilters ADD  CONSTRAINT [CustomerFilters_PK] PRIMARY KEY CLUSTERED 
  --          (
  --          [GlobalCodeId] ASC
  --          ) 
            
	;WITH PMGlobalCodes  
 AS   
  ( SELECT      
      ISNULL(c.GlobalCodeId,0) AS GlobalCodeId    
     ,GCC.GlobalCodeCategoryId    
     ,RTRIM(LTRIM(gcc.Category)) AS CategoryName    
     ,ISNULL(RTRIM(LTRIM(c.CodeName)),'') AS CodeName    
     ,ISNULL(c.SortOrder,'') AS SortOrder  
     ,RTRIM(LTRIM(gcc.CategoryName)) AS GlobalCodeCategoryName   
        
   FROM GlobalCodes AS c RIGHT JOIN GlobalCodeCategories AS gcc ON c.Category = gcc.Category    
   -- Added by gkumar for display category with no global codes  
   and ISNULL(c.RecordDeleted,'N') = 'N'  
   WHERE     
   (     
    -- Commented by gkumar  
    --ISNULL(c.RecordDeleted,'N') = 'N'    
     ISNULL(gcc.RecordDeleted,'N') = 'N'    
    AND ((@CustomFiltersApplied = 'Y' AND EXISTS(SELECT * FROM #CustomFilters cf WHERE cf.GlobalCodeId = c.GlobalCodeId
    -- JHB 4/6/2013 In case there are no global code ids    
    or c.GlobalCodeId is null)) OR    
     (@CustomFiltersApplied = 'N'    
      -- AND filters checks    
      AND (ISNULL(@CategoryName,'$All Categories$') = '$All Categories$'     
      OR gcc.Category=RTRIM(LTRIM(@CategoryName)))    
      AND ( @ActiveCategory = -1 OR          -- All Category states      
       (@ActiveCategory = 1 AND ISNULL(gcc.Active,'N') = 'Y') OR   -- Active                   
       (@ActiveCategory = 2 AND ISNULL(gcc.Active,'N') = 'N'))  -- InActive    
      AND ( @ActiveCode = -1 OR          -- All Code states  
		c.GlobalCodeId is null OR -- JHB 4/6/2013 In case there are no global code ids    
       (@ActiveCode = 1 AND ISNULL(c.Active,'N') = 'Y' ) OR  -- Active                   
       (@ActiveCode = 2 AND ISNULL(c.Active,'N') = 'N'))   --InActive    
           
      AND ( @CategoryType = -1 OR             -- All     
       (@CategoryType = 1 AND ISNULL(gcc.UserDefinedCategory,'N') = 'N') OR -- System Defined                   
       (@CategoryType = 2 AND ISNULL(gcc.UserDefinedCategory,'N') = 'Y'))  -- User Defined    
          AND (@CodeName='' OR c.CodeName LIKE '%' + @CodeName + '%')  
     )    
         
    )    
        
   )      
  )  ,  
  
        counts as ( 
    select count(*) as totalrows from PMGlobalCodes
    ),
    
    
  --ORDER BY CategoryName,SortOrder,CodeName,GlobalCodeCategoryName  
  --  
  --If User selected show all code statuses, delete categories that don't have codes  
  --  
  --IF (@ActiveCode != -1)  
   --DELETE #ResultSet  
   --WHERE GlobalCodeId =0  
    RankResultSet
as
(                                             
			SELECT
	GlobalCodeId,   
   GlobalCodeCategoryId,  
   CategoryName,  
   CodeName,  
   SortOrder,
   GlobalCodeCategoryName     ,     
		 COUNT(*) OVER ( ) AS TotalCount ,
                                    RANK() OVER ( ORDER BY 
    CASE WHEN @SortExpression= 'CategoryName'   THEN CategoryName END,                                    
    CASE WHEN @SortExpression= 'CategoryName DESC'  THEN CategoryName END DESC,                                          
    CASE WHEN @SortExpression= 'CodeName'    THEN CodeName END,                                              
    CASE WHEN @SortExpression= 'CodeName DESC'   THEN CodeName END DESC,  
    CASE WHEN @SortExpression= 'SortOrder'    THEN SortOrder END,                                    
    CASE WHEN @SortExpression= 'SortOrder DESC'   THEN SortOrder END DESC,  
    CASE WHEN @SortExpression= 'GlobalCodeCategoryName'    THEN GlobalCodeCategoryName END,                                    
    CASE WHEN @SortExpression= 'GlobalCodeCategoryName DESC'   THEN GlobalCodeCategoryName END DESC,  
   
   GlobalCodeId
				)  AS RowNumber
                           FROM     PMGlobalCodes  
                   )
                   
                   SELECT TOP ( Case WHEN (@PageNumber = -1) THEN (SELECT ISNULL(totalrows,0) from counts) ELSE (@PageSize) END)
							GlobalCodeId,   
   GlobalCodeCategoryId,  
   CategoryName,  
   CodeName,  
   SortOrder,
   GlobalCodeCategoryName,
							TotalCount ,
							RowNumber
					INTO    #FinalResultSet
					FROM    RankResultSet
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
					@PageNumber AS PageNumber ,
					CASE (TotalCount % @PageSize) WHEN 0 THEN 
                    ISNULL(( TotalCount / @PageSize ), 0)
                    ELSE ISNULL(( TotalCount / @PageSize ), 0) + 1 END AS NumberOfPages,
					ISNULL(TotalCount, 0) AS NumberOfRows
				FROM    #FinalResultSet  
				END                       

            SELECT GlobalCodeId,   
   GlobalCodeCategoryId,  
   CategoryName,  
   CodeName,  
   SortOrder,
   GlobalCodeCategoryName
            FROM    #FinalResultSet
            ORDER BY RowNumber                    
  DROP TABLE #CustomFilters
 END TRY  
   
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)         
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                              
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_PMGlobalCodes')                                                                                               
   + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                
   + '*****' + CONVERT(VARCHAR,ERROR_STATE())  
  RAISERROR  
  (  
   @Error, -- Message text.  
   16,  -- Severity.  
   1  -- State.  
  );  
 END CATCH  
END  