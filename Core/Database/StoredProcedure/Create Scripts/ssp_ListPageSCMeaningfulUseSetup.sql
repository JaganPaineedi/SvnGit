

/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCMeaningfulUseSetup]    Script Date: 09/11/2014 20:09:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageSCMeaningfulUseSetup]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPageSCMeaningfulUseSetup]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCMeaningfulUseSetup]    Script Date: 09/11/2014 20:09:25 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_ListPageSCMeaningfulUseSetup]   
     @PageNumber INT  
 ,@PageSize INT  
 ,@SortExpression VARCHAR(100)  
 ,@StaffId INT  
 ,@Status INT  
 ,@MeasureType INT  
 ,@MeasureSubType INT  
 ,@OtherFilter INT  
 ,@Stage INT 
 /*********************************************************************                
-- Stored Procedure: ssp_ListPageSCMeaningfulUseSetup      
-- Copyright: Streamline Healthcare Solutions     
-- Creation Date:  22 April 2014                            
--                                                       
-- Purpose: returns data for the Programs list page.      
--                                                          
-- Modified Date    Modified By    Purpose      
-- 22 April 2014      Kirtee   Created.    
-- 12 Sept  2014	  Vithobha	Modified Datatype of Stage, Why : Meaningful Use: #25 Meaningful Use Setup Changes
-- 06 March 2016      Himmat    Meaningful Use-logic is hardcoded and missing Stage 2-Modified KCMHSAS - Support#606
****************************************************************************/  
AS  
BEGIN  
 BEGIN TRY  
  DECLARE @CustomFilterApplied CHAR(1) = 'N'  
  
  SET @SortExpression = Rtrim(Ltrim(@SortExpression))  
  
  IF Isnull(@SortExpression, '') = ''  
  BEGIN  
   SET @SortExpression = 'MeaningFulUseDetailId'  
  END;  
  
  CREATE TABLE #customfilters (MeaningFulUseDetailId INT NOT NULL)  
  
  IF @OtherFilter > 10000  
  BEGIN  
   SET @CustomFilterApplied = 'Y'  
     
            if object_id('dbo.scsp_ListSCMeaningfulUseSetup', 'P') is not null   
    Begin  
     INSERT INTO #customfilters (MeaningFulUseDetailId)  
     EXEC scsp_ListSCMeaningfulUseSetup @SortExpression  
      ,@StaffId  
      ,@Status  
      ,@MeasureType  
      ,@MeasureSubType  
      ,@OtherFilter  
      ,@Stage  
    End  
  END;  
  
  WITH listMeaningfulSetup  
  AS (  
   SELECT MeaningFulUseDetailId  
    ,Stage  
    ,[Status]  
    ,GC.CodeName MeasureType  
    ,GSC.SubCodeName MeasureSubType  
   FROM MeaningFulUseDetails MUD  
   LEFT JOIN GlobalCodes GC ON (  
     MUD.MeasureType = GC.GlobalCodeId  
     AND ISNULL(GC.RecordDeleted, 'N') = 'N'  
     )  
   LEFT JOIN GlobalSubCodes GSC ON MUD.MeasureSubType = GSC.GlobalSubCodeId  
   WHERE (ISNULL(MUD.RecordDeleted, 'N') = 'N')  
    AND (  
     (  
      @CustomFilterApplied = 'Y'  
      AND EXISTS (  
       SELECT *  
       FROM #customfilters CF  
       WHERE CF.MeaningFulUseDetailId = MUD.MeaningFulUseDetailId  
       )  
      )  
     OR (  
      @CustomFilterApplied = 'N'  
      AND (  
       isnull(@Status, - 1) = - 1  
       OR --   All Program states         
       (  
        @Status = 1  
        AND MUD.STATUS = 'Y'  
        )  
       OR --   Active                     
       (  
        @Status = 2  
        AND isnull(MUD.STATUS, 'N') = 'N'  
        )  
       ) --   InActive     
      )  
     AND (  
      MUD.MeasureType = @MeasureType  
      OR ISNULL(@MeasureType, -1) = -1  
      )  
     AND (  
      MUD.MeasureSubType = @MeasureSubType  
      OR ISNULL(@MeasureSubType, -1) = -1  
      )  
     AND (  
      ISNULL(@Stage, '-1') = '-1'  
      OR MUD.Stage = @Stage  
      )  
     )  
   )  
   ,counts  
  AS (  
   SELECT Count(*) AS TotalRows  
   FROM listMeaningfulSetup  
   )  
   ,rankresultset  
  AS (  
   SELECT MeaningFulUseDetailId  
    ,Stage  
    ,[Status]  
    ,MeasureType  
    ,MeasureSubType  
    ,Count(*) OVER () AS TotalCount  
    ,Rank() OVER (  
     ORDER BY CASE   
       WHEN @SortExpression = 'MeaningFulUseMeasureId'  
        THEN MeaningFulUseDetailId  
       END  
      ,CASE   
       WHEN @SortExpression = 'MeaningFulUseMeasureId desc'  
        THEN MeaningFulUseDetailId  
       END DESC  
      ,CASE   
       WHEN @SortExpression = 'Stage'  
        THEN Stage  
       END DESC  
      ,CASE   
       WHEN @SortExpression = 'Stage desc'  
        THEN Stage  
       END DESC  
      ,CASE   
       WHEN @SortExpression = 'Status'  
        THEN [Status]  
       END  
      ,CASE   
       WHEN @SortExpression = 'Status desc'  
        THEN [Status]  
       END DESC  
      ,CASE   
       WHEN @SortExpression = 'MeasureType'  
        THEN MeasureType  
       END  
      ,CASE   
       WHEN @SortExpression = 'MeasureType desc'  
        THEN MeasureType  
       END DESC  
      ,CASE   
       WHEN @SortExpression = 'MeasureSubType'  
        THEN MeasureSubType  
       END  
      ,CASE   
       WHEN @SortExpression = 'MeasureSubType desc'  
        THEN MeasureSubType  
       END DESC  
      ,MeaningFulUseDetailId  
     ) AS RowNumber  
   FROM listMeaningfulSetup  
   )  
  SELECT TOP (  
    CASE   
     WHEN (@PageNumber = - 1)  
      THEN (  
        SELECT Isnull(totalrows, 0)  
        FROM counts  
        )  
     ELSE (@PageSize)  
     END  
    ) MeaningFulUseDetailId  
   ,Stage  
   ,[Status]  
   ,MeasureType  
   ,MeasureSubType  
   ,totalcount  
   ,rownumber  
  INTO #finalresultset  
  FROM rankresultset  
  WHERE rownumber > ((@PageNumber - 1) * @PageSize)  
  
  IF (  
    SELECT Isnull(Count(*), 0)  
    FROM #finalresultset  
    ) < 1  
  BEGIN  
   SELECT 0 AS PageNumber  
    ,0 AS NumberOfPages  
    ,0 NumberOfRows  
  END  
  ELSE  
  BEGIN  
   SELECT TOP 1 @PageNumber AS PageNumber  
    ,CASE (totalcount % @PageSize)  
     WHEN 0  
      THEN Isnull((totalcount / @PageSize), 0)  
     ELSE Isnull((totalcount / @PageSize), 0) + 1  
     END AS NumberOfPages  
    ,Isnull(totalcount, 0) AS NumberOfRows  
   FROM #finalresultset  
  END  
  
  SELECT MeaningFulUseDetailId  
  ,CASE 
				WHEN Stage = 8766
					THEN 'Stage1'
				WHEN Stage = 8767
					THEN 'Stage2'
				WHEN Stage = 8768
					THEN 'Stage3'
----Date:-06-04-2017					
				WHEN Stage = 9373
					THEN 'Stage2-Modified' 
---Date:-06-04-2017 Himmat
				END Stage
   ,CASE   
    WHEN [Status] = 'Y'  
     THEN 'Active'  
    WHEN [Status] = 'N'  
     THEN 'Inactive'  
    END [Status]  
   ,MeasureType  
   ,MeasureSubType  
  FROM #finalresultset  
  ORDER BY rownumber  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_ListPageSCMeaningfulUseSetup') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(
VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())  
  
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


