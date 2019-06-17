
 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageSystemReports]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPageSystemReports]
GO

/* Object:  StoredProcedure [dbo].[ssp_ListPageSystemReports]   Script Date: 09/Feb/2016 */
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO               
CREATE PROCEDURE [dbo].[ssp_ListPageSystemReports]                                                                               
@PageNumber int,                                                                                    
@PageSize int,                                                                                    
@SortExpression varchar(100),                                                                                                                                                                                                                                                                               
@OtherFilter int,
@Active varchar(2),
@ReportDescription varchar(100),            
@StaffId   int            

AS
Begin
Begin Try
  /*********************************************************************/ 
  /* Stored Procedure: dbo.ssp_ListPageSystemReports                        */ 
  /* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */ 
  /* Creation Date:  12 October 2016                                        */ 
  /*                                                                   */ 
  /* Purpose: Gets SystemReports list                              */                                                                    
  /* Return: SystemReports row from SystemReports Table  */                                                                  
  /* Updates:                                                          */ 
  /*  Date   Author         Purpose                          */ 
  /* 10/12/2016  Vijeta       Created               */ 

/*********************************************************************/ 

CREATE TABLE #customfilters               
          (               
             SystemReportId INT NOT NULL               
          )
          
        DECLARE @ApplyFilterClicked CHAR(1)               
        DECLARE @CustomFilterApplied CHAR(1)
SET @SortExpression = RTRIM(LTRIM(@SortExpression))           
        IF Isnull(@SortExpression, '') = ''               
          BEGIN
SET @SortExpression = 'Name'
END


SET @ApplyFilterClicked = 'Y'              
        SET @CustomFilterApplied= 'N'    
        IF @OtherFilter > 10000               
          BEGIN               
              SET @CustomFilterApplied= 'Y'               
              
              INSERT INTO #customfilters               
                          (SystemReportId)               
              EXEC scsp_ListPageSystemReports                       
     @OtherFilter =@OtherFilter               
          END;               
              
        WITH listSystemReports              
             AS ( SELECT                      
  sr.SystemReportId,
  sr.ReportName,
  sr.Active,
  sr.ReportURL                                    
  FROM                      
  SystemReports sr                                                                          
 WHERE                 
  (                       
  ISNULL(sr.RecordDeleted,'N')='N'                                         
  AND ((sr.Active=@Active) OR @Active='') 
  and ((@CustomFilterApplied = 'Y' and exists(select * from #CustomFilters cf where cf.SystemReportId = sr.SystemReportId)) or
        (@CustomFilterApplied = 'N' AND
         (isnull(@ReportDescription, '') = '' --or sr.Description like '%' + @ReportDescription + '%' 
         or sr.ReportName like '%' + @ReportDescription + '%')
        )
       )                                                            
  )            ),               
             counts               
             AS (SELECT Count(*) AS TotalRows               
                 FROM   listSystemReports),               
             rankresultset               
             AS (SELECT SystemReportId,
       ReportName,                                  
       Active,                
       ReportURL,                                                                           
                        Count(*)               
                          OVER ( ) AS               
                        TotalCount,               
                        Rank()               
                          OVER(               
ORDER BY CASE WHEN @SortExpression= 'Name' THEN               
                          ReportName               
                          END,
                           CASE               
                          WHEN @SortExpression= 'Name desc' THEN ReportName               
                          END               
                          DESC,                                                    
                          CASE               
                          WHEN               
                          @SortExpression= 'Active' THEN Active END, CASE               
                          WHEN               
                          @SortExpression=               
                          'Active desc' THEN Active END DESC, 
                          CASE WHEN               
                          @SortExpression               
                          =               
                          'ReportURL' THEN ReportURL END, CASE WHEN               
                          @SortExpression=               
                          'ReportURL DESC' THEN ReportURL END DESC                                 
                           ) AS               
                        RowNumber               
              FROM   listSystemReports)               
        SELECT TOP (CASE WHEN (@PageNumber = -1) THEN (SELECT Isnull(totalrows,               
        0)               
        FROM counts)               
        ELSE (@PageSize) END) SystemReportId,
        ReportName,                                   
       Active,                
       ReportURL,                                      
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
              
        SELECT SystemReportId,
        ReportName,                                  
       Active,                
       ReportURL                          
        FROM   #finalresultset               
        ORDER  BY rownumber               
              
        DROP TABLE #customfilters 
          
END TRY

BEGIN CATCH
DECLARE @Error varchar(8000)                                                                            
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                         
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_ListPageSystemReports')                                                                                                             
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


