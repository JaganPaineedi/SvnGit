
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageLetterTemplates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPageLetterTemplates]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO               
CREATE PROCEDURE [dbo].[ssp_ListPageLetterTemplates] ----- null,200,null,null,null,null,null                                                                  
@PageNumber int,                                                                                    
@PageSize int,                                                                                    
@SortExpression varchar(100),                                                                                                                                                                                                                                                                               
@OtherFilter int,
@LetterCategory int,
@TemplateName varchar(200),            
@StaffId   int            
 /********************************************************************************                                                  
-- Stored Procedure: dbo.ssp_ListPageLetterTemplates                                                 
--                                                  
-- Copyright: Streamline Healthcate Solutions                                                  
--                                                  
-- Purpose: used by LetterTemplates list page    
-- Called by: ssp_ListPageLetterTemplates  
--              
**  Date:       Author:       Description:                                    
**  1/3/2017  Vijeta Sinha    To get the list of all TemplateName of LetterTemplates tables in the database
                             for Engineering Improvement Initiatives- NBL(I)#410             
*********************************************************************************/  
AS
Begin
Begin Try
CREATE TABLE #customfilters               
          (               
             LetterTemplateId INT NOT NULL               
          )
          
        DECLARE @ApplyFilterClicked CHAR(1)               
        DECLARE @CustomFilterApplied CHAR(1)
SET @SortExpression = RTRIM(LTRIM(@SortExpression))           
        IF Isnull(@SortExpression, '') = ''               
          BEGIN
SET @SortExpression = 'LetterTemplateId desc'
END


SET @ApplyFilterClicked = 'Y'              
        SET @CustomFilterApplied= 'N'    
        IF @OtherFilter > 10000               
          BEGIN               
              SET @CustomFilterApplied= 'Y'               
              
              INSERT INTO #customfilters               
                          (LetterTemplateId)               
              EXEC scsp_ListPageLetterTemplates                      
					@OtherFilter =@OtherFilter,
					@LetterCategory = @LetterCategory,
					@TemplateName = @TemplateName,       
					@StaffId  = @StaffId             
          END;               
              
        WITH listLetterTemplates            
             AS ( SELECT                      
  lt.LetterTemplateId,
  lt.TemplateName,
  gc.CodeName  AS LetterCategoryName,
  lt.LetterTemplate                                    
  FROM                      
  LetterTemplates lt  
  LEFT JOIN GlobalCodes gc ON lt.LetterCategory =  gc.GlobalCodeId AND ISNULL(gc.RecordDeleted,'N')='N' 
  WHERE ((@CustomFilterApplied = 'Y'
      AND EXISTS (
       SELECT *
       FROM #CustomFilters cf
       WHERE cf.LetterTemplateId = lt.LetterTemplateId
       )
      )
      
     OR ((
      @CustomFilterApplied = 'N'
      AND (
       isnull(@TemplateName, '') = '' --or sr.Description like '%' + @ReportDescription + '%' 
       OR lt.TemplateName LIKE '%' + @TemplateName + '%'
       )
      )
     
    AND (
     (lt.LetterCategory = @LetterCategory)
     OR @LetterCategory = 0
     )
    AND ISNULL(lt.RecordDeleted, 'N') = 'N'
   )))
   ,counts                                                                                   
             AS (SELECT Count(*) AS TotalRows               
                 FROM   listLetterTemplates),               
             rankresultset               
             AS (SELECT LetterTemplateId,
       TemplateName,                                  
       LetterCategoryName,                
       LetterTemplate,                                                                           
                        Count(*)               
                          OVER ( ) AS               
                        TotalCount,               
                        Rank()               
                          OVER(               
ORDER BY CASE WHEN @SortExpression= 'LetterTemplateId' THEN               
                          LetterTemplateId               
                          END,
                           CASE               
                          WHEN @SortExpression= 'LetterTemplateId desc' THEN LetterTemplateId               
                          END               
                          DESC, 
                           CASE WHEN @SortExpression= 'TemplateName' THEN               
                          TemplateName               
                          END,
                          CASE               
                          WHEN @SortExpression= 'TemplateName desc' THEN TemplateName               
                          END               
                          DESC,                                                   
                          CASE               
                          WHEN               
                          @SortExpression= 'LetterCategoryName' THEN LetterCategoryName 
                          END, 
                          CASE               
                          WHEN               
                          @SortExpression= 'LetterCategoryName desc' THEN LetterCategoryName 
                          END DESC, 
                          CASE WHEN               
                          @SortExpression               
                          =               
                          'LetterTemplate' THEN LetterTemplate END, CASE WHEN               
                          @SortExpression=               
                          'LetterTemplate DESC' THEN LetterTemplate END DESC,
                          LetterTemplateId  DESC                               
                           ) AS               
                        RowNumber               
              FROM   listLetterTemplates)               
        SELECT TOP (CASE WHEN (@PageNumber = -1) THEN (SELECT Isnull(totalrows,               
        0)               
        FROM counts)               
        ELSE (@PageSize) END) LetterTemplateId,
        TemplateName,                                   
       LetterCategoryName,                
       LetterTemplate,                                      
       totalcount,               
       rownumber               
        INTO   #finalresultset               
        FROM   rankresultset               
        WHERE  rownumber > ( ( @PageNumber - 1 ) * @PageSize )               
              
        IF (SELECT Isnull(Count(*), 0)               
            FROM   #finalresultset) < 1               
          BEGIN               
              SELECT 0 AS PageNumber,               
                     0 AS NumberOfPages,               
                     0 NumberOfRows 
           END
           ELSE               
          BEGIN               
              SELECT TOP 1 @PageNumber           AS PageNumber,               
                           CASE ( totalcount % @PageSize )               
                             WHEN 0 THEN Isnull(( totalcount / @PageSize ), 0)               
                             ELSE Isnull(( totalcount / @PageSize ), 0) + 1               
                           END                   AS NumberOfPages,               
                           Isnull(totalcount, 0) AS NumberOfRows               
        FROM   #finalresultset               
          END               
              
        SELECT LetterTemplateId,
        TemplateName,                                  
       LetterCategoryName,                
       LetterTemplate                          
        FROM   #finalresultset               
        ORDER  BY rownumber               
              
        DROP TABLE #customfilters 
          
END TRY

BEGIN CATCH
DECLARE @Error varchar(8000)                                                                            
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                         
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_ListPageLetterTemplates')                                                                                                             
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


