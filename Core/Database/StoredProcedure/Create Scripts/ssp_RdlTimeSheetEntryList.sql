IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RdlTimeSheetEntryList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RdlTimeSheetEntryList]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO    
CREATE PROCEDURE dbo.ssp_RdlTimeSheetEntryList    
@StartDate datetime       
,@EndDate datetime      
,@LeaveType INT        
,@SecondaryActivity INT        
,@PageNumber INT          
,@PageSize INT          
,@SortExpression VARCHAR(20)          
,@LoggedInStaffId INT     
,@StaffId INT         
AS 
-- =============================================    
-- Author      : Rajesh S
-- Date        : 22/12/2015
-- Purpose     : Get report data 
--History
-- Date          Author          Purpose
-- 10/17/2016    Vamsi		Modified to get Billable and Secondary Hours wrt Bear River - Support Go Live #97
-- =============================================    
BEGIN      
    
 BEGIN TRY       
   SET @SortExpression = RTRIM(LTRIM(@SortExpression))      
      
  IF ISNULL(@SortExpression, '') = ''      
   SET @SortExpression = 'TimeSheetDay'     
     
  ;WITH CTETimeSheetEntries    
  AS    
  (      
     SELECT      
       STE.StaffTimeSheetEntryId      
       ,STE.TimeSheetDay      
       ,ISNULL(A.HoursWorked,'0') HoursWorked      
       ,ISNULL(B.duration,'0') timeaway      
        ,ISNULL(C.StaffPersonalLeave,'0') PersonalLeave    
       ,ISNULL(C.StaffLongTermSickLeave,'0') LongTermSick    
       ,ISNULL(C.Holiday,'0') Holiday 
       ,ISNULL(T.Duration,'0') Billable  -- 10/17/2016	    Vamsi
       ,ISNULL(S.duration,'0') Secondary   -- 10/17/2016	    Vamsi       
       --,ISNULL(C.LEAVEWITHPAY,'0') LeaveWithPay       
       ,ISNULL(A.TotalHours,'0') TotalReportHours      
       ,ROW_NUMBER() OVER (ORDER BY STE.TimeSheetDay) AS rowNumber    
       ,ROW_NUMBER() OVER(ORDER BY STE.TimeSheetDay DESC) AS totalRows    
     FROM      
     StaffTimeSheetEntries STE      
      OUTER APPLY    
     (    
     SELECT Sum(ClinicalSupportHours) HoursWorked,SUM(TotalHours) TotalHours FROM StaffTimeSheetEntries WHERE  StaffTimeSheetEntryId = STE.StaffTimeSheetEntryId    
     AND ISNULL(RecordDeleted,'N')!='Y'  
     ) A    
     OUTER APPLY    
     (    
     SELECT Sum(Duration) duration FROM StaffTimeSheetTimeAway WHERE  StaffTimeSheetEntryId = STE.StaffTimeSheetEntryId    
     AND ISNULL(RecordDeleted,'N')!='Y'  
     ) B 
     ---- 10/17/2016	    Vamsi
     OUTER APPLY    
     (    
     SELECT Sum(Duration) duration FROM StaffTimeSheetSecondaryActivities WHERE  StaffTimeSheetEntryId = STE.StaffTimeSheetEntryId  
     AND ISNULL(RecordDeleted,'N')!='Y'  
     ) S    
     OUTER APPLY      
     (      
     SELECT     
			--PERSONALLEAVE,LONGTERMSICKLEAVE,HOLIDAY,LEAVEWITHPAY    
			StaffLongTermSickLeave,StaffPersonalLeave,Holiday  
       FROM    
       (    
				  SELECT    
					  --sum(Duration) Hours,GC.ExternalCode1
					  sum(Duration) Hours,REC.CategoryCode  
					  FROM     
					  StaffTimeSheetTimeOff STO    
					  LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = STO.LeaveType
					  LEFT JOIN Recodes RE ON GC.ExternalCode1 = RE.CharacterCodeId    
					  JOIN RecodeCategories REC ON REC.RecodeCategoryId = RE.RecodeCategoryId    
				  WHERE      
					  STO.StaffTimeSheetEntryId = STE.StaffTimeSheetEntryId  
					  --AND LeaveType = CASE WHEN @LeaveType =0 THEN LeaveType ELSE @LeaveType END 
					  AND 
					  ISNULL(STO.Paid,'N') = Case WHEN @LeaveType !=3 AND @LeaveType = 0 THEN  ISNULL(STO.Paid,'N') 
									WHEN @LeaveType !=3 AND @LeaveType = 1 THEN 'Y'
									WHEN @LeaveType !=3 AND @LeaveType = 2 THEN 'N'
									END
					  --AND GC.ExternalCode1!='HOLIDAY'
					  AND REC.CategoryCode IN('StaffLongTermSickLeave','StaffPersonalLeave')
					  AND ISNULL(STO.RecordDeleted,'N')!='Y'
					  group by REC.CategoryCode
				    --group by GC.ExternalCode1
			  UNION
				  SELECT    
					  --sum(Duration) Hours,GC.ExternalCode1
					  sum(Duration) Hours,REC.CategoryCode  
					  FROM     
					  StaffTimeSheetTimeOff STO    
					  LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = STO.LeaveType
					  LEFT JOIN Recodes RE ON GC.ExternalCode1 = RE.CharacterCodeId    
					  JOIN RecodeCategories REC ON REC.RecodeCategoryId = RE.RecodeCategoryId      
				  WHERE      
					  STO.StaffTimeSheetEntryId = STE.StaffTimeSheetEntryId  
					  AND ISNULL(STO.RecordDeleted,'N')!='Y' 
					  --AND GC.ExternalCode1= CASE WHEN @LeaveType=3 OR @LeaveType=0 THEN 'HOLIDAY' END
					  AND REC.CategoryCode= CASE WHEN @LeaveType=3 OR @LeaveType=0 THEN 'Holiday' END
					  group by REC.CategoryCode
				  --group by GC.ExternalCode1
		) E    
       PIVOT    
       (    
			--SUM(HOURS) FOR E.ExternalCode1 IN (PERSONALLEAVE,LONGTERMSICKLEAVE,HOLIDAY,LEAVEWITHPAY)    
			SUM(HOURS) FOR E.CategoryCode IN (StaffLongTermSickLeave,StaffPersonalLeave,Holiday)
       ) PIV      
            
     ) C  
     -- 10/17/2016	    Vamsi   
     OUTER APPLY
     (
      SELECT dbo.ssf_GetTotalServiceHours(@StaffId,STE.TimeSheetDay) as Duration     
     )  T
   WHERE    
    --STE.TimeSheetDay>=@StartDate BETWEEN @StartDate AND @EndDate    
    (STE.TimeSheetDay>=@StartDate OR ISNULL(@StartDate,'')='') AND (STE.TimeSheetDay<=@EndDate OR ISNULL(@EndDate,'')='')    
    AND ISNULL(STE.RecordDeleted,'N')!='Y' 
    AND STE.StaffId = @StaffId    
      
   )    
       
       
   SELECT    
  StaffTimeSheetEntryId      
  ,TimeSheetDay      
  , HoursWorked      
  ,timeaway      
  ,PersonalLeave      
  ,LongTermSick      
  ,Holiday  
  ,Billable
  ,Secondary    
  --,LeaveWithPay      
  ,TotalReportHours      
  ,rowNumber    
  ,totalRows    
  ,totalRows + rowNumber -1 AS TotalRecords    
  INTO #FinalResultSet      
 FROM    
  CTETimeSheetEntries    
 WHERE RowNumber > ((@PageNumber - 1) * @PageSize)     
     
IF @PageSize=0 OR @PageSize=-1      
  BEGIN      
   SELECT @PageSize=COUNT(*) FROM #FinalResultSet      
  END      
        
  --IF (SELECT ISNULL(COUNT(*), 0) FROM #FinalResultSet) < 1      
  --BEGIN      
  -- SELECT 0 AS PageNumber      
  --  ,0 AS NumberOfPages      
  --  ,0 NumberOfRows      
  --END      
  --ELSE      
  --BEGIN      
  -- SELECT TOP 1 @PageNumber AS PageNumber      
  --  ,CASE (TotalRecords % @PageSize)      
  --   WHEN 0      
  --    THEN ISNULL((TotalRecords / @PageSize), 0)      
  --   ELSE ISNULL((TotalRecords / @PageSize), 0) + 1      
  --   END AS NumberOfPages      
  --  ,ISNULL(TotalRecords, 0) AS NumberOfRows      
  -- FROM #FinalResultSet      
  --END      
      
      
      
  SELECT    
  StaffTimeSheetEntryId      
  ,TimeSheetDay      
  , HoursWorked      
  ,timeaway      
  ,PersonalLeave      
  ,LongTermSick      
  ,Holiday   
  ,Billable 
  ,Secondary   
  --,LeaveWithPay      
  ,TotalReportHours      
  ,rowNumber    
  ,totalRows    
  ,totalRows + rowNumber -1 AS TotalRecords    
 FROM #FinalResultSet     
 --ORDER BY --rowNumber    
 ORDER BY     
 CASE       
  WHEN @SortExpression = 'TimeSheetDay'      
  THEN TimeSheetDay      
 END    
 ,CASE       
  WHEN @SortExpression = 'TimeSheetDay DESC'      
  THEN TimeSheetDay     END DESC    
 ,CASE       
  WHEN @SortExpression = 'HoursWorked'      
  THEN HoursWorked      
 END     
 ,CASE       
  WHEN @SortExpression = 'HoursWorked DESC'      
  THEN HoursWorked      
 END DESC    
 ,CASE       
  WHEN @SortExpression = 'PersonalLeave '      
  THEN PersonalLeave      
 END     
 ,CASE       
  WHEN @SortExpression = 'PersonalLeave DESC'      
  THEN PersonalLeave      
 END DESC    
 ,CASE       
  WHEN @SortExpression = 'LongTermSick '      
  THEN LongTermSick      
 END     
 ,CASE       
  WHEN @SortExpression = 'LongTermSick DESC'      
  THEN LongTermSick      
 END DESC    
 ,CASE       
  WHEN @SortExpression = 'Holiday '      
  THEN Holiday      
 END     
 ,CASE       
  WHEN @SortExpression = 'Holiday DESC'      
  THEN Holiday      
 END DESC    
 --,CASE       
 -- WHEN @SortExpression = 'LeaveWithPay '      
 -- THEN LeaveWithPay      
 --END     
 --,CASE       
 -- WHEN @SortExpression = 'LeaveWithPay DESC'      
 -- THEN LeaveWithPay      
 --END DESC    
 ,CASE       
  WHEN @SortExpression = 'TotalReportHours '      
  THEN TotalReportHours      
 END     
 ,CASE       
  WHEN @SortExpression = 'TotalReportHours DESC'      
  THEN TotalReportHours      
 END DESC    
 END TRY
   BEGIN CATCH
   --Checking For Errors  
   DECLARE @Error varchar(8000)
    SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE())
    + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), 'ssp_RdlTimeSheetEntryList')
    + '*****' + CONVERT(varchar, ERROR_LINE()) + '*****' + CONVERT(varchar, ERROR_SEVERITY())
    + '*****' + CONVERT(varchar, ERROR_STATE())
    RAISERROR
    (
    @Error, -- Message text.  
    16,  -- Severity.  
    1  -- State.  
    );      
    
    END CATCH        
        
END 