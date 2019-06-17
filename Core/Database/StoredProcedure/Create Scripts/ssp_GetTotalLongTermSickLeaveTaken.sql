IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetTotalLongTermSickLeaveTaken]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetTotalLongTermSickLeaveTaken]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
            
    
CREATE PROCEDURE dbo.ssp_GetTotalLongTermSickLeaveTaken --550,'12/08/2015'    
@StaffId INT    
,@EffectiveDate DATETIME    
AS    
-- =============================================    
-- Author      : Rajesh S
-- Date        : 22/12/2015
-- Purpose     : Get Count of Total longterm leave 
/* ModifiedDate          ModifiedBy                     Task*/          
/* 02/22/2017				Rajesh					 Bearriver support go live - task 188 -  Time Sheet:  StaffPersonalLeave Recode table not working as expected*/    
-- ============================================= 
BEGIN    
    
DECLARE @TotalLongTermTermLeaveTaken decimal(10,2)    
DECLARE @Duration decimal(10,2)   
SELECT    
  @Duration = SUM(DURATION)    
  FROM    
  (    
       
  SELECT     
    CONVERT(DECIMAL(10, 2), DATEDIFF(minute, STO.StartTime, STO.EndTime)/60.0)  DURATION   
  FROM     
   StaffTimeSheetEntries STE     
   JOIN StaffTimeSheetTimeOff STO ON STE.StaffTimeSheetEntryId = STO.StaffTimeSheetEntryId    
   LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = STO.LeaveType    
   LEFT JOIN Recodes RE ON GC.ExternalCode1 = RE.CharacterCodeId    
   JOIN RecodeCategories REC ON REC.RecodeCategoryId = RE.RecodeCategoryId    
  WHERE STE.StaffId = @StaffId    
   AND DATEADD(dd, DATEDIFF(dd, 0, STO.EndTime), 0)<= @EffectiveDate    
   AND ISNULL(STE.RecordDeleted,'N')!= 'Y'    
   AND ISNULL(STO.RecordDeleted,'N')!= 'Y'
   AND ISNULL(RE.RecordDeleted,'N')!= 'Y'   
   AND ISNULL(STO.Paid,'N')!='Y'    
   AND REC.CategoryCode= 'StaffLongTermSickLeave'    
      
  ) AS A    
      
  SELECT @TotalLongTermTermLeaveTaken = @Duration     
 SELECT ISNULL(@TotalLongTermTermLeaveTaken,0)     
END