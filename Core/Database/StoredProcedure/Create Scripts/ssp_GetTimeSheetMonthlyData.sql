IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetTimeSheetMonthlyData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetTimeSheetMonthlyData]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
        
        
CREATE PROCEDURE dbo.ssp_GetTimeSheetMonthlyData        
@StaffId INT                
,@CurrentDate DATETIME                
,@DEBUG  INT =0                 
AS      
/*********************************************************************/              
/* Stored Procedure: [ssp_GetTimeSheetMonthlyData]               */              
/* Creation Date:  27/November/2015                                    */              
/* Input Parameters:  */        
/*Author:Rajesh S*/          
/*	ModifiedDate          ModifiedBy                        Task*/      
/*  08/29/2016				Rajesh							Bearriver support go live - task 64 -  Included PL and LT Adjustment while calculation Remainning balance*/
/*  04/11/2016				Rajesh							Bearriver support go live - task 85 -  Used AdjustmentDate while calculating Adjustment values*/ 
/*  29/11/2016				Anto							Bear River support go live - task 126 - Modified the logic to show the earned leaves from the effective date*/ 

/* 02/22/2017				Rajesh							Bearriver support go live - task 188 -  Time Sheet:  StaffPersonalLeave Recode table not working as expected*/    
/* 04/21/2017				Anto							Bearriver support go live - task 126 -  Modified the logic to display the earned leaves for the month*/ 
/* 08/Aug/2017				Anto							Bearriver support go live - task 126 -  Modified the logic as per the new requirment*/ 
/*********************************************************************/             
BEGIN                
                  
  DECLARE @PLAccruals DECIMAL(10,2)                
  DECLARE @PLWeeklyAccruals DECIMAL(10,2)                
  DECLARE @PLMonthlyAccruals DECIMAL(10,2)                
  DECLARE @PLYearlyAccruals DECIMAL(10,2)                
  DECLARE @PLBiWeeklyAccruals DECIMAL(10,2)                
  DECLARE @PersonalLeaveBeginningBalance DECIMAL(10,2)                
  DECLARE @LongTermLeaveBeginningBalance DECIMAL(10,2)                
  DECLARE @PersonalLeaveUsed DECIMAL(10,2)                
  DECLARE @LongTermLeaveUsed DECIMAL(10,2)                
            
            
DECLARE @PLAccrualsBeginning DECIMAL(10,2)                
DECLARE @PLWeeklyAccrualsBeginning DECIMAL(10,2)                
DECLARE @PLMonthlyAccrualsBeginning DECIMAL(10,2)                
DECLARE @PLYearlyAccrualsBeginning DECIMAL(10,2)                
DECLARE @PLBiWeeklyAccrualsBeginning DECIMAL(10,2)         
                
                
DECLARE @Nextmonthfirstday DATETIME 
DECLARE @StartOfMonth DATETIME
DECLARE @Nextmonthfirstdayformated varchar(100)   
SELECT @Nextmonthfirstday = CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,@CurrentDate))-1),DATEADD(mm,1,@CurrentDate)),101)
SELECT @Nextmonthfirstdayformated = CONVERT(CHAR(19), CONVERT(DATETIME, @Nextmonthfirstday, 3), 120)   

SELECT @StartOfMonth = DATEADD(month, DATEDIFF(month, 0, @CurrentDate), 0) 

DECLARE @LastDateOfMonth DATETIME
SELECT @LastDateOfMonth =  DATEADD(d, -1, DATEADD(m, DATEDIFF(m, 0, @CurrentDate) + 1, 0))

       
                
  --------------Beginning Balance Personal Leave                
                
   SELECT @PersonalLeaveBeginningBalance = ISNULL(PersonalLeave,0)                
   FROM                
   StaffTimeSheetGenerals ST                
   WHERE                
   StaffId=@StaffId                
  -- AND BeginningBalancePersonalLeaveDate<=@CurrentDate                
   AND @CurrentDate >= Case when BeginningBalancePersonalLeaveDate IS null then @CurrentDate else BeginningBalancePersonalLeaveDate end        
                   
  IF @DEBUG=1                
  BEGIN                
  SELECT @PersonalLeaveBeginningBalance AS PersonalLeaveBeginningBalance                
  END                
                   
  --------------Beginning Balance Long Term Leave                
                   
   SELECT @LongTermLeaveBeginningBalance = ISNULL(LongTermSick,0)                
   FROM                
   StaffTimeSheetGenerals ST                
   WHERE                
   StaffId=@StaffId                
   --AND BeginningBalanceLongTermSickDate<=@CurrentDate                
   AND @CurrentDate >= Case when  BeginningBalanceLongTermSickDate IS null then @CurrentDate else BeginningBalanceLongTermSickDate end        
                
                   
  IF @DEBUG=1                
  BEGIN                
  SELECT @LongTermLeaveBeginningBalance AS LongTermLeaveBeginningBalance                
  END                
                
  -------------PersonalLeave Used                
  SELECT @PersonalLeaveUsed = Sum(Duration)                
  FROM                    
  StaffTimeSheetEntries STE                    
  JOIN StaffTimeSheetTimeOff STO ON STE.StaffTimeSheetEntryId = STO.StaffTimeSheetEntryId                
  LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = STO.LeaveType            
  LEFT JOIN Recodes RE ON GC.ExternalCode1 = RE.CharacterCodeId          
  JOIN RecodeCategories REC ON REC.RecodeCategoryId = RE.RecodeCategoryId        
  WHERE                 
  STE.StaffId=@StaffId                
  --AND GC.ExternalCode1 =  'PERSONALLEAVE'                
  --AND GC.Category='StaffLeaveType'      
  AND REC.CategoryCode= 'StaffPersonalLeave'              
  AND STE.TimeSheetDay<= @LastDateOfMonth  
  AND STO.Paid ='Y'                 
  AND ISNULL(STO.RecordDeleted,'N') !='Y' 
  AND ISNULL(RE.RecordDeleted,'N') !='Y'              
  --AND (STE.TimeSheetDay=@CurrentDate AND  @CurrentDate>=DATEADD(dd, DATEDIFF(dd, 0, STO.StartTime), 0)  AND @CurrentDate>=DATEADD(dd, DATEDIFF(dd, 0, STO.EndTime),0))                
  --AND MONTH(@CurrentDate)=MONTH(STO.StartTime) AND MONTH(@CurrentDate)=MONTH(STO.EndTime)                
  --AND YEAR(@CurrentDate)=YEAR(STO.StartTime) AND YEAR(@CurrentDate)=YEAR(STO.EndTime)                
  AND MONTH(@CurrentDate)=MONTH(STE.TimeSheetDay)                
  AND YEAR(@CurrentDate)=YEAR(STE.TimeSheetDay)                
  -----------------------Long Term Leave Used                
  SELECT @LongTermLeaveUsed = Sum(Duration)                
  FROM                    
  StaffTimeSheetEntries STE                  
  JOIN StaffTimeSheetTimeOff STO ON STE.StaffTimeSheetEntryId = STO.StaffTimeSheetEntryId                
  LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = STO.LeaveType    
  LEFT JOIN Recodes RE ON GC.ExternalCode1 = RE.CharacterCodeId        
  JOIN RecodeCategories REC ON REC.RecodeCategoryId = RE.RecodeCategoryId                 
  WHERE                 
  STE.StaffId=@StaffId                
  --AND GC.ExternalCode1 = 'LONGTERMSICKLEAVE'                
  --AND GC.Category='StaffLeaveType'         
  AND REC.CategoryCode= 'StaffLongTermSickLeave'            
  AND STE.TimeSheetDay<= @LastDateOfMonth                   
  AND STO.Paid ='Y'                 
  AND ISNULL(STO.RecordDeleted,'N') !='Y' 
  AND ISNULL(RE.RecordDeleted,'N') !='Y'              
  --AND (STE.TimeSheetDay=@CurrentDate AND @CurrentDate>=DATEADD(dd, DATEDIFF(dd, 0, STO.StartTime), 0)  AND @CurrentDate>=DATEADD(dd, DATEDIFF(dd, 0, STO.EndTime),0))                
  --AND MONTH(@CurrentDate)=MONTH(STO.StartTime) AND MONTH(@CurrentDate)=MONTH(STO.EndTime)                
  --AND YEAR(@CurrentDate)=YEAR(STO.StartTime) AND YEAR(@CurrentDate)=YEAR(STO.EndTime)                
  AND MONTH(@CurrentDate)=MONTH(STE.TimeSheetDay)                
  AND YEAR(@CurrentDate)=YEAR(STE.TimeSheetDay)        
          
  IF @DEBUG=1                
  BEGIN                
  SELECT @PersonalLeaveUsed PersonalLeaveUsed,@LongTermLeaveUsed LongTermLeaveUsed        
  END              
                
  -----Beginning of the month        
  DECLARE @PersonalLeaveUsedBegMonth DECIMAL(10,2)        
  DECLARE @LongTermLeaveUsedBegMonth DECIMAL(10,2)         
  DECLARE @BeginningOfMonth DATETIME         
  SELECT @BeginningOfMonth =  DATEADD(month, DATEDIFF(month, 0, @CurrentDate), 0)           
  -------------PersonalLeave Used                
  SELECT @PersonalLeaveUsedBegMonth = Sum(Duration)                
  FROM                    
  StaffTimeSheetEntries STE                    
  JOIN StaffTimeSheetTimeOff STO ON STE.StaffTimeSheetEntryId = STO.StaffTimeSheetEntryId                
  LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = STO.LeaveType                
  WHERE                 
  STE.StaffId=@StaffId                
  AND GC.ExternalCode1 =  'PERSONALLEAVE'                
  AND GC.Category='StaffLeaveType'                
  AND STE.TimeSheetDay<@BeginningOfMonth              
  AND STO.Paid ='Y'                 
  AND ISNULL(STO.RecordDeleted,'N') !='Y'               
                 
                
  -----------------------Long Term Leave Used                
  SELECT @LongTermLeaveUsedBegMonth = Sum(Duration)                
  FROM                    
  StaffTimeSheetEntries STE                    
  JOIN StaffTimeSheetTimeOff STO ON STE.StaffTimeSheetEntryId = STO.StaffTimeSheetEntryId                
  LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = STO.LeaveType                
  WHERE                 
  STE.StaffId=@StaffId                
  AND GC.ExternalCode1 = 'LONGTERMSICKLEAVE'                
  AND GC.Category='StaffLeaveType'                
  AND STE.TimeSheetDay<@BeginningOfMonth                 
  AND STO.Paid ='Y'                 
  AND ISNULL(STO.RecordDeleted,'N') !='Y'             
          
  IF @DEBUG=1                
  BEGIN                
  SELECT @PersonalLeaveUsedBegMonth PersonalLeaveUsedBegMonth,@LongTermLeaveUsedBegMonth LongTermLeaveUsedBegMonth        
  END            
                 
 -----Beinning of the month leaves used               
                
    ---------------------------------Calculate Personal Leave Accruals For Current Month----------------------------------------                
                
  SELECT @PLMonthlyAccruals = SUM(MonthAccrual)                
  FROM                
  (                
    SELECT Months*AccrualRate AS MonthAccrual                
    FROM                
    (                
     SELECT                 
      STA.EffectiveDate                
      ,STA.EndDate                
      ,CASE                 
      WHEN @CurrentDate>=STA.EffectiveDate AND @CurrentDate<=STA.EndDate THEN 
      DATEDIFF(MM,@StartOfMonth,@Nextmonthfirstday)                
      --  DATEDIFF(MM,STA.EffectiveDate,@CurrentDate)              
      --WHEN @CurrentDate>=STA.EffectiveDate AND @CurrentDate>STA.EndDate  THEN               
      --  DATEDIFF(MM,STA.EffectiveDate,STA.EndDate)                
      END AS Months                
      ,AccrualRate                
                
                      
     FROM                
     StaffTimeSheetAccrualHistory STA                
     JOIN GlobalCodes GCA ON GCA.GlobalCodeId = STA.AccrualType                
     LEFT JOIN GlobalCodes GC ON STA.AccrualRatePer = GC.GlobalCodeId                
     WHERE                
  STA.StaffId=@StaffId                
  AND GCA.Category = 'AccrualType'                
  AND GCA.ExternalCode1='PERSONALLEAVE'                
  AND GC.Category='AccuralHistoryPer'                
  AND GC.ExternalCode1='MONTHLY'                
  AND @CurrentDate>=STA.EffectiveDate          
  --AND MONTH(@CurrentDate)= MONTH(STA.EffectiveDate)          
  --AND MONTH(@CurrentDate)= MONTH(STA.EndDate)                 
  --AND YEAR(@CurrentDate)= YEAR(STA.EffectiveDate)                   
     AND ISNULL(STA.RecordDeleted,'N')!='Y'                
    ) AS MonthlyAccruals                
  ) MONTHLY                
                
  IF @DEBUG=1                
  BEGIN               
   PRINT 'Personal Leave Monthly Accruals'                
   SELECT @PLMonthlyAccruals  [Personal Leave Monthly Accruals]                
  END                
                
  SELECT @PLWeeklyAccruals = SUM(WeekAccrual)                
  FROM                
  (                
     SELECT Weeks*AccrualRate AS WeekAccrual                
     FROM                
     (                
      SELECT                 
       STA.EffectiveDate                
       ,STA.EndDate                
       ,CASE                 
       WHEN @CurrentDate>=STA.EffectiveDate AND @CurrentDate<=STA.EndDate THEN 
       DATEDIFF(dd,@StartOfMonth,@Nextmonthfirstday)/7               
       --  DATEDIFF(dd,STA.EffectiveDate,@CurrentDate)/7               
       --WHEN @CurrentDate>=STA.EffectiveDate AND @CurrentDate>STA.EndDate THEN                
       --  DATEDIFF(dd,STA.EffectiveDate,STA.EndDate)/7                
       END AS Weeks                
       ,AccrualRate                
      FROM                
      StaffTimeSheetAccrualHistory STA                
      JOIN GlobalCodes GCA ON GCA.GlobalCodeId = STA.AccrualType                
      LEFT JOIN GlobalCodes GC ON STA.AccrualRatePer = GC.GlobalCodeId                
      WHERE                
  STA.StaffId=@StaffId                
  AND GCA.Category = 'AccrualType'                
  AND GCA.ExternalCode1='PERSONALLEAVE'                
  AND GC.Category='AccuralHistoryPer'                
  AND GC.ExternalCode1='WEEKLY'                
  AND @CurrentDate>=STA.EffectiveDate        
  --AND MONTH(@CurrentDate)= MONTH(STA.EffectiveDate)          
  --AND MONTH(@CurrentDate)= MONTH(STA.EndDate)                 
  --AND YEAR(@CurrentDate)= YEAR(STA.EffectiveDate)                
      AND ISNULL(STA.RecordDeleted,'N')!='Y'                
     ) WeeklyAccruals                
  ) WEEKLY                
                
  IF @DEBUG=1                
  BEGIN                
   PRINT 'Personal Leave Weekly Accruals'                
   SELECT @PLWeeklyAccruals  [Personal Leave Weekly Accruals]                
  END                
                
  SELECT @PLYearlyAccruals = SUM(YearAccrual)                
  FROM                
  (                
    SELECT Years*AccrualRate AS YearAccrual                
    FROM                
     (                
                      
      SELECT                 
       STA.EffectiveDate                
       ,STA.EndDate                
       ,CASE                 
       WHEN @CurrentDate>=STA.EffectiveDate AND @CurrentDate<=STA.EndDate THEN 
       DATEDIFF(YY,@StartOfMonth,@Nextmonthfirstday)                     
      --   DATEDIFF(YY,STA.EffectiveDate,@CurrentDate)                
      --WHEN @CurrentDate>=STA.EffectiveDate AND @CurrentDate>STA.EndDate THEN                
      --   DATEDIFF(YY,STA.EffectiveDate,STA.EndDate)                
       END AS Years                
       ,AccrualRate                
                       
      FROM                
      StaffTimeSheetAccrualHistory STA                
      JOIN GlobalCodes GCA ON GCA.GlobalCodeId = STA.AccrualType                
      LEFT JOIN GlobalCodes GC ON STA.AccrualRatePer = GC.GlobalCodeId                
      WHERE                
  STA.StaffId=@StaffId                
  AND GCA.Category = 'AccrualType'                
  AND GCA.ExternalCode1='PERSONALLEAVE'                
  AND GC.Category='AccuralHistoryPer'                
  AND GC.ExternalCode1='YEARLY'                
  AND @CurrentDate>=STA.EffectiveDate         
  --AND MONTH(@CurrentDate)= MONTH(STA.EffectiveDate)          
  --AND MONTH(@CurrentDate)= MONTH(STA.EndDate)                 
  --AND YEAR(@CurrentDate)= YEAR(STA.EffectiveDate)               
      AND ISNULL(STA.RecordDeleted,'N')!='Y'                
    ) YearlyAccruals                
  ) YEARLY                
                
  IF @DEBUG=1                
  BEGIN                
   PRINT 'Personal Leave Yearly Accruals'                
   SELECT @PLYearlyAccruals  [Personal Leave Yearly Accruals]                
  END                
                
  SELECT @PLBiWeeklyAccruals=SUM(BiWeekAccrual)                
  FROM             
  (                
    SELECT BiWeek*AccrualRate AS BiWeekAccrual                
    FROM                
     (                
      SELECT           
       STA.EffectiveDate                
       ,STA.EndDate                
       ,CASE                 
       WHEN @CurrentDate>=STA.EffectiveDate AND @CurrentDate<=STA.EndDate THEN   
       DATEDIFF(dd,@StartOfMonth,@Nextmonthfirstday)/14              
       --  DATEDIFF(dd,STA.EffectiveDate,@CurrentDate)/14                
       --WHEN @CurrentDate>=STA.EffectiveDate AND @CurrentDate>STA.EndDate THEN                
       --  DATEDIFF(dd,STA.EffectiveDate,STA.EndDate)/14                
       END AS BiWeek                
       ,AccrualRate              
                       
      FROM                
      StaffTimeSheetAccrualHistory STA                
      JOIN GlobalCodes GCA ON GCA.GlobalCodeId = STA.AccrualType                
      LEFT JOIN GlobalCodes GC ON STA.AccrualRatePer = GC.GlobalCodeId                
      WHERE                
  STA.StaffId=@StaffId                
  AND GCA.Category = 'AccrualType'                
  AND GCA.ExternalCode1='PERSONALLEAVE'                
  AND GC.Category='AccuralHistoryPer'                
  AND GC.ExternalCode1='EVERYOTHERWEEK'                
  AND @CurrentDate>=STA.EffectiveDate         
  --AND MONTH(@CurrentDate)= MONTH(STA.EffectiveDate)          
  --AND MONTH(@CurrentDate)= MONTH(STA.EndDate)                 
  --AND YEAR(@CurrentDate)= YEAR(STA.EffectiveDate)               
      AND ISNULL(STA.RecordDeleted,'N')!='Y'                
      ) BiWeeklyAccruals                
  ) EVERYOTHERWEEK                
                
  IF @DEBUG=1                
  BEGIN                
   PRINT 'Personal Leave BiWeekly Accruals'                
   SELECT @PLBiWeeklyAccruals  [Personal Leave BiWeekly Accruals]                
  END                
                
  SET @PLAccruals = ISNULL(@PLMonthlyAccruals,0)+ISNULL(@PLWeeklyAccruals,0)+ISNULL(@PLYearlyAccruals,0)+ISNULL(@PLBiWeeklyAccruals,0)                
                
  IF @DEBUG=1                
  BEGIN                
   PRINT 'Personal Leave Accruals'                
   SELECT @PLAccruals  [Personal Leave Accruals]                
  END                
                
                
                
                
                
        --        
---------------------------------Calculate Personal Leave Accruals Till beginning of the Month----------------------------------------                
              
  DECLARE @PreviousMonthLastDate DATETIME        
  SET @PreviousMonthLastDate = DATEADD(dd,-1, @BeginningOfMonth)              
  SELECT @PLMonthlyAccrualsBeginning = SUM(MonthAccrual)                
  FROM                
  (                
    SELECT Months*AccrualRate AS MonthAccrual                
    FROM                
    (                
     SELECT                 
      STA.EffectiveDate                
      ,STA.EndDate                
      ,CASE                 
      WHEN @PreviousMonthLastDate>=STA.EffectiveDate AND @PreviousMonthLastDate<=STA.EndDate THEN                
        DATEDIFF(MM,STA.EffectiveDate,DATEADD(dd,1,@PreviousMonthLastDate))              
      WHEN @PreviousMonthLastDate>=STA.EffectiveDate AND @PreviousMonthLastDate>STA.EndDate THEN                
        DATEDIFF(MM,STA.EffectiveDate,STA.EndDate +  1)                
      END AS Months                
      ,AccrualRate                 
                
                      
     FROM                
     StaffTimeSheetAccrualHistory STA                
     JOIN GlobalCodes GCA ON GCA.GlobalCodeId = STA.AccrualType                
     LEFT JOIN GlobalCodes GC ON STA.AccrualRatePer = GC.GlobalCodeId                
     WHERE                
  STA.StaffId=@StaffId                
  AND GCA.Category = 'AccrualType'                
  AND GCA.ExternalCode1='PERSONALLEAVE'                
  AND GC.Category='AccuralHistoryPer'                
  AND GC.ExternalCode1='MONTHLY'                
  AND @PreviousMonthLastDate>=STA.EffectiveDate          
                     
     AND ISNULL(STA.RecordDeleted,'N')!='Y'                
    ) AS MonthlyAccruals                
  ) MONTHLY                
                
  IF @DEBUG=1                
  BEGIN                
   PRINT 'Personal Leave Monthly Accruals'                
   SELECT @PLMonthlyAccrualsBeginning  [Personal Leave Monthly Accruals Beginning]                
  END                
                
  SELECT @PLWeeklyAccrualsBeginning = SUM(WeekAccrual)                
  FROM                
  (                
     SELECT Weeks*AccrualRate AS WeekAccrual                
     FROM                
     (                
      SELECT                 
       STA.EffectiveDate                
       ,STA.EndDate                
       ,CASE                 
       WHEN @PreviousMonthLastDate>=STA.EffectiveDate AND @PreviousMonthLastDate<=STA.EndDate THEN                
         DATEDIFF(dd,STA.EffectiveDate,@PreviousMonthLastDate)/7                
       WHEN @PreviousMonthLastDate>=STA.EffectiveDate AND @PreviousMonthLastDate>STA.EndDate THEN                
         DATEDIFF(dd,STA.EffectiveDate,STA.EndDate)/7                
       END AS Weeks                
       ,AccrualRate                
      FROM                
      StaffTimeSheetAccrualHistory STA                
      JOIN GlobalCodes GCA ON GCA.GlobalCodeId = STA.AccrualType                
      LEFT JOIN GlobalCodes GC ON STA.AccrualRatePer = GC.GlobalCodeId                
      WHERE                
  STA.StaffId=@StaffId                
  AND GCA.Category = 'AccrualType'                
  AND GCA.ExternalCode1='PERSONALLEAVE'                
  AND GC.Category='AccuralHistoryPer'                
  AND GC.ExternalCode1='WEEKLY'                
  AND @PreviousMonthLastDate>=STA.EffectiveDate        
                 
      AND ISNULL(STA.RecordDeleted,'N')!='Y'                
     ) WeeklyAccruals                
  ) WEEKLY                
                
  IF @DEBUG=1                
  BEGIN                
   PRINT 'Personal Leave Weekly Accruals'                
   SELECT @PLWeeklyAccrualsBeginning  [Personal Leave Weekly Accruals Beginning]                
  END                
                
  SELECT @PLYearlyAccrualsBeginning = SUM(YearAccrual)                
  FROM                
  (                
    SELECT Years*AccrualRate AS YearAccrual                
    FROM                
     (                
                      
      SELECT                 
       STA.EffectiveDate                
       ,STA.EndDate                
       ,CASE                 
       WHEN @PreviousMonthLastDate>=STA.EffectiveDate AND @PreviousMonthLastDate<=STA.EndDate THEN                
         DATEDIFF(YY,STA.EffectiveDate,@PreviousMonthLastDate)                
       WHEN @PreviousMonthLastDate>=STA.EffectiveDate AND @CurrentDate>STA.EndDate THEN                
         DATEDIFF(YY,STA.EffectiveDate,STA.EndDate)                
       END AS Years                
       ,AccrualRate                
                       
      FROM                
      StaffTimeSheetAccrualHistory STA                
      JOIN GlobalCodes GCA ON GCA.GlobalCodeId = STA.AccrualType                
      LEFT JOIN GlobalCodes GC ON STA.AccrualRatePer = GC.GlobalCodeId                
      WHERE                
  STA.StaffId=@StaffId                
  AND GCA.Category = 'AccrualType'                
  AND GCA.ExternalCode1='PERSONALLEAVE'                
  AND GC.Category='AccuralHistoryPer'                
  AND GC.ExternalCode1='YEARLY'                
  AND @PreviousMonthLastDate>=STA.EffectiveDate         
                
      AND ISNULL(STA.RecordDeleted,'N')!='Y'                
    ) YearlyAccruals                
  ) YEARLY                
                
  IF @DEBUG=1                
  BEGIN                
   PRINT 'Personal Leave Yearly Accruals'                
   SELECT @PLYearlyAccrualsBeginning  [Personal Leave Yearly Accruals Beginning]                
  END                
                
  SELECT @PLBiWeeklyAccrualsBeginning=SUM(BiWeekAccrual)                
  FROM                
  (                
    SELECT BiWeek*AccrualRate AS BiWeekAccrual                
    FROM                
     (                
      SELECT           
       STA.EffectiveDate                
       ,STA.EndDate                
       ,CASE                 
       WHEN @PreviousMonthLastDate>=STA.EffectiveDate AND @PreviousMonthLastDate<=STA.EndDate THEN                
         DATEDIFF(dd,STA.EffectiveDate,@PreviousMonthLastDate)/14                
       WHEN @PreviousMonthLastDate>=STA.EffectiveDate AND @PreviousMonthLastDate>STA.EndDate THEN                
         DATEDIFF(dd,STA.EffectiveDate,STA.EndDate)/14                
       END AS BiWeek                
       ,AccrualRate              
                       
      FROM              
      StaffTimeSheetAccrualHistory STA                
      JOIN GlobalCodes GCA ON GCA.GlobalCodeId = STA.AccrualType                
      LEFT JOIN GlobalCodes GC ON STA.AccrualRatePer = GC.GlobalCodeId                
      WHERE                
  STA.StaffId=@StaffId                
  AND GCA.Category = 'AccrualType'                
  AND GCA.ExternalCode1='PERSONALLEAVE'                
  AND GC.Category='AccuralHistoryPer'                
  AND GC.ExternalCode1='EVERYOTHERWEEK'                
  AND @PreviousMonthLastDate>=STA.EffectiveDate         
              
      AND ISNULL(STA.RecordDeleted,'N')!='Y'                
      ) BiWeeklyAccruals                
  ) EVERYOTHERWEEK                
                
  IF @DEBUG=1                
  BEGIN                
   PRINT 'Personal Leave BiWeekly Accruals'                
   SELECT @PLBiWeeklyAccrualsBeginning  [Personal Leave BiWeekly Accruals Beginning]                
  END                
                
  SET @PLAccrualsBeginning = ISNULL(@PLMonthlyAccrualsBeginning,0)+ISNULL(@PLWeeklyAccrualsBeginning,0)+ISNULL(@PLYearlyAccrualsBeginning,0)+ISNULL(@PLBiWeeklyAccrualsBeginning,0)                
                
  IF @DEBUG=1                
  BEGIN                
   PRINT 'Personal Leave Accruals Begiiing of themonth'                
   SELECT @PLAccrualsBeginning  [Personal Leave Accruals begininng of the month]                
  END                
                
                
                
  ---------------------------------Calculate Long Term Accruals ------------------------------------------                
                
  DECLARE @LTAccruals DECIMAL(10,2)                
  DECLARE @LTWeeklyAccruals DECIMAL(10,2)                
  DECLARE @LTMonthlyAccruals DECIMAL(10,2)                
  DECLARE @LTYearlyAccruals DECIMAL(10,2)                
  DECLARE @LTBiWeeklyAccruals DECIMAL(10,2)                
                
                
                
  SELECT @LTMonthlyAccruals = SUM(MonthAccrual)                
  FROM                
  (                
   SELECT Months*AccrualRate AS MonthAccrual                
    FROM                
    (                
     SELECT                 
      STA.EffectiveDate                
      ,STA.EndDate                
      ,CASE                 
      WHEN @CurrentDate>=STA.EffectiveDate AND @CurrentDate<=STA.EndDate THEN 
      DATEDIFF(MM,@StartOfMonth,@Nextmonthfirstday)                
      --  DATEDIFF(MM,STA.EffectiveDate,@CurrentDate)                
      --WHEN @CurrentDate>=STA.EffectiveDate AND @CurrentDate>STA.EndDate THEN                
      --  DATEDIFF(MM,STA.EffectiveDate,STA.EndDate)                
      END AS Months                
      ,AccrualRate                
                      
                      
     FROM                
     StaffTimeSheetAccrualHistory STA                
     JOIN GlobalCodes GCA ON GCA.GlobalCodeId = STA.AccrualType              
     LEFT JOIN GlobalCodes GC ON STA.AccrualRatePer = GC.GlobalCodeId                
     WHERE                
  STA.StaffId=@StaffId                
  AND GCA.Category = 'AccrualType'                
  AND GCA.ExternalCode1='LONGTERMSICKLEAVE'                
  AND GC.Category='AccuralHistoryPer'                
  AND GC.ExternalCode1='MONTHLY'                
  AND @CurrentDate>=STA.EffectiveDate         
  --AND MONTH(@CurrentDate)= MONTH(STA.EffectiveDate)          
  --AND MONTH(@CurrentDate)= MONTH(STA.EndDate)                 
  --AND YEAR(@CurrentDate)= YEAR(STA.EffectiveDate)               
  AND ISNULL(STA.RecordDeleted,'N')!='Y'                
    ) AS MonthlyAccruals                
  ) MONTHLY                
                
  IF @DEBUG=1                
  BEGIN                
   PRINT 'Long Term Sick Leave Monthly Accruals'                
   SELECT @LTMonthlyAccruals  [Long Term Sick Leave Monthly Accruals]                
  END                
                
  SELECT @LTWeeklyAccruals = SUM(WeekAccrual)                
  FROM                
  (                
   SELECT Weeks*AccrualRate AS WeekAccrual                
     FROM                
     (                
      SELECT                 
       STA.EffectiveDate                
       ,STA.EndDate                
       ,CASE                 
       WHEN @CurrentDate>=STA.EffectiveDate AND @CurrentDate<=STA.EndDate THEN    
        DATEDIFF(dd,@StartOfMonth,@Nextmonthfirstday)/7                  
       --  DATEDIFF(dd,STA.EffectiveDate,@CurrentDate)/7                
       --WHEN @CurrentDate>=STA.EffectiveDate AND @CurrentDate>STA.EndDate THEN                
       --  DATEDIFF(dd,STA.EffectiveDate,STA.EndDate)/7                
       END AS Weeks                
       ,AccrualRate              FROM                
      StaffTimeSheetAccrualHistory STA                
      JOIN GlobalCodes GCA ON GCA.GlobalCodeId = STA.AccrualType                
      LEFT JOIN GlobalCodes GC ON STA.AccrualRatePer = GC.GlobalCodeId                
      WHERE                
  STA.StaffId=@StaffId                
  AND GCA.Category = 'AccrualType'                
  AND GCA.ExternalCode1='LONGTERMSICKLEAVE'                
  AND GC.Category='AccuralHistoryPer'                
  AND GC.ExternalCode1='WEEKLY'                
  AND @CurrentDate>=STA.EffectiveDate        
  --AND MONTH(@CurrentDate)= MONTH(STA.EffectiveDate)          
  --AND MONTH(@CurrentDate)= MONTH(STA.EndDate)                 
  --AND YEAR(@CurrentDate)= YEAR(STA.EffectiveDate)                
  AND ISNULL(STA.RecordDeleted,'N')!='Y'                
     ) WeeklyAccruals                
  ) WEEKLY                
                
  IF @DEBUG=1                
  BEGIN                
   PRINT 'Long Term Sick Leave Weekly Accruals'                
   SELECT @LTWeeklyAccruals  [Long Term Sick Leave Weekly Accruals]                
 END                
                
  SELECT @LTYearlyAccruals =  SUM(YearAccrual)                
  FROM                
  (                
   SELECT Years*AccrualRate AS YearAccrual                
    FROM                
     (                
                      
      SELECT                 
       STA.EffectiveDate                
       ,STA.EndDate                
       ,CASE                 
       WHEN @CurrentDate>=STA.EffectiveDate AND @CurrentDate<=STA.EndDate THEN    
        DATEDIFF(YY,@StartOfMonth,@Nextmonthfirstday)              
       --  DATEDIFF(YY,STA.EffectiveDate,@CurrentDate)                
       --WHEN @CurrentDate>=STA.EffectiveDate AND @CurrentDate>STA.EndDate THEN                
       --  DATEDIFF(YY,STA.EffectiveDate,STA.EndDate)                
       END AS Years                
       ,AccrualRate                
                       
      FROM                
      StaffTimeSheetAccrualHistory STA                
      JOIN GlobalCodes GCA ON GCA.GlobalCodeId = STA.AccrualType                
      LEFT JOIN GlobalCodes GC ON STA.AccrualRatePer = GC.GlobalCodeId                
      WHERE                
  STA.StaffId=@StaffId                
  AND GCA.Category = 'AccrualType'                
  AND GCA.ExternalCode1='LONGTERMSICKLEAVE'                
  AND GC.Category='AccuralHistoryPer'                
  AND GC.ExternalCode1='YEARLY'                
  AND @CurrentDate>=STA.EffectiveDate        
  --AND MONTH(@CurrentDate)= MONTH(STA.EffectiveDate)          
  --AND MONTH(@CurrentDate)= MONTH(STA.EndDate)                 
  --AND YEAR(@CurrentDate)= YEAR(STA.EffectiveDate)                
  AND ISNULL(STA.RecordDeleted,'N')!='Y'                
    ) YearlyAccruals                
  ) YEARLY                
                
  IF @DEBUG=1                
  BEGIN                
   PRINT 'Long Term Sick Leave Yearly Accruals'                
   SELECT @LTYearlyAccruals  [Long Term Sick Leave Yearly Accruals]                
  END                
                
  SELECT @LTBiWeeklyAccruals=SUM(BiWeekAccrual)                
  FROM                
  (                
   SELECT BiWeek*AccrualRate AS BiWeekAccrual                
    FROM                
     (                
      SELECT                 
       STA.EffectiveDate         ,STA.EndDate                
       ,CASE                 
       WHEN @CurrentDate>=STA.EffectiveDate AND @CurrentDate<=STA.EndDate THEN 
       DATEDIFF(dd,@StartOfMonth,@Nextmonthfirstday) /14                    
       --  DATEDIFF(dd,STA.EffectiveDate,@CurrentDate)/14                
       --WHEN @CurrentDate>=STA.EffectiveDate AND @CurrentDate>STA.EndDate THEN                
       --  DATEDIFF(dd,STA.EffectiveDate,STA.EndDate)/14                
       END AS BiWeek                
       ,AccrualRate                
                       
      FROM                
      StaffTimeSheetAccrualHistory STA                
      JOIN GlobalCodes GCA ON GCA.GlobalCodeId = STA.AccrualType                
      LEFT JOIN GlobalCodes GC ON STA.AccrualRatePer = GC.GlobalCodeId                
      WHERE                
  STA.StaffId=@StaffId                
  AND GCA.Category = 'AccrualType'                
  AND GCA.ExternalCode1='LONGTERMSICKLEAVE'           
  AND GC.Category='AccuralHistoryPer'                
  AND GC.ExternalCode1='EVERYOTHERWEEK'                
  AND @CurrentDate>=STA.EffectiveDate        
  --AND MONTH(@CurrentDate)= MONTH(STA.EffectiveDate)          
  --AND MONTH(@CurrentDate)= MONTH(STA.EndDate)                 
  --AND YEAR(@CurrentDate)= YEAR(STA.EffectiveDate)                
  AND ISNULL(STA.RecordDeleted,'N')!='Y'                
      ) BiWeeklyAccruals                
  ) EVERYOTHERWEEK                
                
  IF @DEBUG=1                
  BEGIN                
   PRINT 'Long Term Sick Leave BiWeekly Accruals'                
   SELECT @LTBiWeeklyAccruals  [Long Term Sick Leave BiWeekly Accruals]                
  END                
                
  SET @LTAccruals = ISNULL(@LTMonthlyAccruals,0)+ISNULL(@LTWeeklyAccruals,0)+ISNULL(@LTYearlyAccruals,0)+ISNULL(@LTBiWeeklyAccruals,0)                
                
  IF @DEBUG=1                
  BEGIN                
   PRINT 'Long Term Sick Leave Accruals'                
   SELECT @LTAccruals  [Long Term Sick Leave Accruals]                
  END                
                
                
                
---------------------------------Calculate Long Term Accruals Till Beginning of the month------------------------------------------                
                
  DECLARE @LTAccrualsBeginning DECIMAL(10,2)                
  DECLARE @LTWeeklyAccrualsBeginning DECIMAL(10,2)                
  DECLARE @LTMonthlyAccrualsBeginning DECIMAL(10,2)                
  DECLARE @LTYearlyAccrualsBeginning DECIMAL(10,2)                
  DECLARE @LTBiWeeklyAccrualsBeginning DECIMAL(10,2)                
                
                
                
  SELECT @LTMonthlyAccrualsBeginning = SUM(MonthAccrual)                
  FROM                
  (                
   SELECT Months*AccrualRate AS MonthAccrual                
    FROM                
    (                
     SELECT                 
      STA.EffectiveDate                
      ,STA.EndDate                
      ,CASE                 
      WHEN @PreviousMonthLastDate>=STA.EffectiveDate AND @PreviousMonthLastDate<=STA.EndDate THEN                
        DATEDIFF(MM,STA.EffectiveDate,DATEADD(dd,1,@PreviousMonthLastDate))               
      WHEN @PreviousMonthLastDate>=STA.EffectiveDate AND @PreviousMonthLastDate>STA.EndDate THEN                
        DATEDIFF(MM,STA.EffectiveDate,STA.EndDate + 1)                
      END AS Months                
      ,AccrualRate                
                      
                      
     FROM                
     StaffTimeSheetAccrualHistory STA                
     JOIN GlobalCodes GCA ON GCA.GlobalCodeId = STA.AccrualType                
     LEFT JOIN GlobalCodes GC ON STA.AccrualRatePer = GC.GlobalCodeId                
     WHERE                
  STA.StaffId=@StaffId                
  AND GCA.Category = 'AccrualType'                
  AND GCA.ExternalCode1='LONGTERMSICKLEAVE'                
  AND GC.Category='AccuralHistoryPer'                
  AND GC.ExternalCode1='MONTHLY'                
  AND @PreviousMonthLastDate>=STA.EffectiveDate         
                
  AND ISNULL(STA.RecordDeleted,'N')!='Y'                
    ) AS MonthlyAccruals                
  ) MONTHLY                
                
  IF @DEBUG=1                
  BEGIN                
   PRINT 'Long Term Sick Leave Monthly Accruals'                
   SELECT @LTMonthlyAccrualsBeginning  [Long Term Sick Leave Monthly Accruals Beginning]                
  END                
                
  SELECT @LTWeeklyAccrualsBeginning = SUM(WeekAccrual)                
  FROM                
  (                
   SELECT Weeks*AccrualRate AS WeekAccrual                
     FROM                
     (                
      SELECT                 
       STA.EffectiveDate                
       ,STA.EndDate                
       ,CASE                 
       WHEN @PreviousMonthLastDate>=STA.EffectiveDate AND @PreviousMonthLastDate<=STA.EndDate THEN                
         DATEDIFF(dd,STA.EffectiveDate,@PreviousMonthLastDate)/7                
       WHEN @PreviousMonthLastDate>=STA.EffectiveDate AND @PreviousMonthLastDate>STA.EndDate THEN                
         DATEDIFF(dd,STA.EffectiveDate,STA.EndDate)/7                
       END AS Weeks                
       ,AccrualRate              FROM                
      StaffTimeSheetAccrualHistory STA          
      JOIN GlobalCodes GCA ON GCA.GlobalCodeId = STA.AccrualType                
      LEFT JOIN GlobalCodes GC ON STA.AccrualRatePer = GC.GlobalCodeId                
      WHERE                
  STA.StaffId=@StaffId                
  AND GCA.Category = 'AccrualType'                
  AND GCA.ExternalCode1='LONGTERMSICKLEAVE'                
  AND GC.Category='AccuralHistoryPer'                
  AND GC.ExternalCode1='WEEKLY'                
  AND @PreviousMonthLastDate>=STA.EffectiveDate        
                  
  AND ISNULL(STA.RecordDeleted,'N')!='Y'                
     ) WeeklyAccruals                
  ) WEEKLY                
                
  IF @DEBUG=1                
  BEGIN                
   PRINT 'Long Term Sick Leave Weekly Accruals'                
   SELECT @LTWeeklyAccrualsBeginning  [Long Term Sick Leave Weekly Accruals Beginning]                
  END                
                
  SELECT @LTYearlyAccrualsBeginning =  SUM(YearAccrual)                
  FROM                
  (                
   SELECT Years*AccrualRate AS YearAccrual                
    FROM                
     (                
                      
      SELECT                 
       STA.EffectiveDate                
       ,STA.EndDate                
       ,CASE                 
       WHEN @PreviousMonthLastDate>=STA.EffectiveDate AND @PreviousMonthLastDate<=STA.EndDate THEN                
         DATEDIFF(YY,STA.EffectiveDate,@PreviousMonthLastDate)                
       WHEN @PreviousMonthLastDate>=STA.EffectiveDate AND @PreviousMonthLastDate>STA.EndDate THEN                
         DATEDIFF(YY,STA.EffectiveDate,STA.EndDate)                
       END AS Years                
       ,AccrualRate                
               
      FROM                
      StaffTimeSheetAccrualHistory STA                
      JOIN GlobalCodes GCA ON GCA.GlobalCodeId = STA.AccrualType                
      LEFT JOIN GlobalCodes GC ON STA.AccrualRatePer = GC.GlobalCodeId                
      WHERE                
  STA.StaffId=@StaffId                
  AND GCA.Category = 'AccrualType'                
  AND GCA.ExternalCode1='LONGTERMSICKLEAVE'                
  AND GC.Category='AccuralHistoryPer'                
  AND GC.ExternalCode1='YEARLY'                
  AND @PreviousMonthLastDate>=STA.EffectiveDate        
                 
  AND ISNULL(STA.RecordDeleted,'N')!='Y'                
    ) YearlyAccruals                
  ) YEARLY                
                
  IF @DEBUG=1                
  BEGIN                
   PRINT 'Long Term Sick Leave Yearly Accruals'                
   SELECT @LTYearlyAccrualsBeginning  [Long Term Sick Leave Yearly Accruals Beginning]                
  END                
                
  SELECT @LTBiWeeklyAccrualsBeginning=SUM(BiWeekAccrual)                
  FROM                
  (                
   SELECT BiWeek*AccrualRate AS BiWeekAccrual                
    FROM                
     (                
      SELECT                 
       STA.EffectiveDate         ,STA.EndDate                
       ,CASE                 
       WHEN @PreviousMonthLastDate>=STA.EffectiveDate AND @PreviousMonthLastDate<=STA.EndDate THEN                
         DATEDIFF(dd,STA.EffectiveDate,@PreviousMonthLastDate)/14                
       WHEN @PreviousMonthLastDate>=STA.EffectiveDate AND @PreviousMonthLastDate>STA.EndDate THEN                
         DATEDIFF(dd,STA.EffectiveDate,STA.EndDate)/14                
       END AS BiWeek                
       ,AccrualRate                
                       
      FROM                
      StaffTimeSheetAccrualHistory STA                
      JOIN GlobalCodes GCA ON GCA.GlobalCodeId = STA.AccrualType                
      LEFT JOIN GlobalCodes GC ON STA.AccrualRatePer = GC.GlobalCodeId                
      WHERE                
  STA.StaffId=@StaffId                
  AND GCA.Category = 'AccrualType'                
  AND GCA.ExternalCode1='LONGTERMSICKLEAVE'                
  AND GC.Category='AccuralHistoryPer'                
  AND GC.ExternalCode1='EVERYOTHERWEEK'                
  AND @PreviousMonthLastDate>=STA.EffectiveDate        
              
  AND ISNULL(STA.RecordDeleted,'N')!='Y'                
      ) BiWeeklyAccruals                
  ) EVERYOTHERWEEK                
                
  IF @DEBUG=1                
  BEGIN                
   PRINT 'Long Term Sick Leave BiWeekly Accruals'           
   SELECT @LTBiWeeklyAccrualsBeginning  [Long Term Sick Leave BiWeekly Accruals Beginning]                
  END                
                
  SET @LTAccrualsBeginning = ISNULL(@LTMonthlyAccrualsBeginning,0)+ISNULL(@LTWeeklyAccrualsBeginning,0)+ISNULL(@LTYearlyAccrualsBeginning,0)+ISNULL(@LTBiWeeklyAccrualsBeginning,0)                
                
  IF @DEBUG=1                
  BEGIN                
   PRINT 'Long Term Sick Leave Accruals'                
   SELECT @LTAccrualsBeginning  [Long Term Sick Leave Accruals Beginning]                
  END                
                
                
                
                
                
  -------PL ADD Adjustment                
  DECLARE @PLAddAdjustment DECIMAL(10,2)                
  DECLARE @LTAddAdjustment DECIMAL(10,2)                
  DECLARE @PLMinusAdjustment DECIMAL(10,2)                
  DECLARE @LTMinusAdjustment DECIMAL(10,2)                
                
                
  SELECT                 
    @PLAddAdjustment = SUM(NumberOfHours)                
  FROM                
  StaffTimeSheetAdjustments STA                
  JOIN GlobalCodes GCA ON STA.AdjustmentType = GCA.GlobalCodeId                
  JOIN GlobalCodes GC ON STA.IncreaseOrDecrease = GC.GlobalCodeId                
  WHERE                
  STA.StaffId=@StaffId                
  AND GCA.Category = 'AccrualType'                
  AND GCA.ExternalCode1='PERSONALLEAVE'                
  AND GC.Category='AdjustmentType'                
  AND GC.ExternalCode1='ADD'                
  AND ISNULL(STA.RecordDeleted,'N')!='Y'                
  AND DATEADD(dd, DATEDIFF(dd, 0, STA.AdjustmentDate), 0)<= @LastDateOfMonth             
  AND MONTH(@CurrentDate)=MONTH(STA.AdjustmentDate)                 
  AND YEAR(@CurrentDate)=YEAR(STA.AdjustmentDate)                 
                
                
  IF @DEBUG=1                
  BEGIN                
   PRINT 'PL ADD Adjustment'                
   SELECT @PLAddAdjustment  [PL ADD Adjustment]                
  END                
                
  -------long term ADD Adjustment                
                
  SELECT                 
    @LTAddAdjustment = SUM(NumberOfHours)                
  FROM                
  StaffTimeSheetAdjustments STA                
  JOIN GlobalCodes GCA ON STA.AdjustmentType = GCA.GlobalCodeId                
  JOIN GlobalCodes GC ON STA.IncreaseOrDecrease = GC.GlobalCodeId                
  WHERE                
  STA.StaffId=@StaffId                
  AND GCA.Category = 'AccrualType'                
  AND GCA.ExternalCode1='LONGTERMSICKLEAVE'                
  AND GC.Category='AdjustmentType'                
  AND GC.ExternalCode1='ADD'                
  AND ISNULL(STA.RecordDeleted,'N')!='Y'                
  AND DATEADD(dd, DATEDIFF(dd, 0, STA.AdjustmentDate), 0)<= @LastDateOfMonth             
  AND MONTH(@CurrentDate)=MONTH(STA.AdjustmentDate)                 
  AND YEAR(@CurrentDate)=YEAR(STA.AdjustmentDate)                 
                
                
  IF @DEBUG=1                
  BEGIN                
   PRINT 'Long Term ADD Adjustment'                
   SELECT @LTAddAdjustment  [Long Term ADD Adjustment]                
  END                
                
                
                
                
  ------------------PL Minus Adjustment                
                
                
  SELECT                 
    @PLMinusAdjustment = SUM(NumberOfHours)                
  FROM                
  StaffTimeSheetAdjustments STA                
  JOIN GlobalCodes GCA ON STA.AdjustmentType = GCA.GlobalCodeId                
  JOIN GlobalCodes GC ON STA.IncreaseOrDecrease = GC.GlobalCodeId                
  WHERE                
  STA.StaffId=@StaffId                
  AND GCA.Category = 'AccrualType'                
  AND GCA.ExternalCode1='PERSONALLEAVE'                
  AND GC.Category='AdjustmentType'                
  AND GC.ExternalCode1='MINUS'                
  AND ISNULL(STA.RecordDeleted,'N')!='Y'                
  AND DATEADD(dd, DATEDIFF(dd, 0, STA.AdjustmentDate), 0)<=  @LastDateOfMonth                 
  AND MONTH(@CurrentDate)=MONTH(STA.AdjustmentDate)                 
  AND YEAR(@CurrentDate)=YEAR(STA.AdjustmentDate)                 
                
                
  IF @DEBUG=1                
  BEGIN                
   PRINT 'PL MINUS Adjustment'                
   SELECT @PLMinusAdjustment  [PL MINUS Adjustment]                
  END                
                
  -------long term MINUS Adjustment                
                
  SELECT                 
    @LTMinusAdjustment = SUM(NumberOfHours)                
  FROM                
  StaffTimeSheetAdjustments STA                
  JOIN GlobalCodes GCA ON STA.AdjustmentType = GCA.GlobalCodeId                
  JOIN GlobalCodes GC ON STA.IncreaseOrDecrease = GC.GlobalCodeId                
  WHERE                
  STA.StaffId=@StaffId                
  AND GCA.Category = 'AccrualType'                
  AND GCA.ExternalCode1='LONGTERMSICKLEAVE'                
  AND GC.Category='AdjustmentType'                
  AND GC.ExternalCode1='MINUS'                
  AND ISNULL(STA.RecordDeleted,'N')!='Y'                
  AND DATEADD(dd, DATEDIFF(dd, 0, STA.AdjustmentDate), 0)<= @LastDateOfMonth                 
  AND MONTH(@CurrentDate)=MONTH(STA.AdjustmentDate)                 
  AND YEAR(@CurrentDate)=YEAR(STA.AdjustmentDate)                 
                
  IF @DEBUG=1                
  BEGIN                
   PRINT 'Long Term MINUS Adjustment'                
   SELECT @LTMinusAdjustment  [Long Term MINUS Adjustment]                
  END                
            
                
  DECLARE @CashedOutBeginning DECIMAL(10,2)                
  DECLARE @CashedOut DECIMAL(10,2)          
          
  SELECT @CashedOutBeginning = SUM(AmountCashedOut)                
  FROM                
  StaffTimeSheetPersonalLeaveCashedOut                
  WHERE                
  StaffId = @StaffId                
  AND ISNULL(RecordDeleted,'N')!='Y'                
  AND DATEADD(dd, DATEDIFF(dd, 0, CreatedDate), 0)<@BeginningOfMonth                
                
                
  SELECT @CashedOut = SUM(AmountCashedOut)                
  FROM                
  StaffTimeSheetPersonalLeaveCashedOut                
  WHERE                
  StaffId = @StaffId                
  AND ISNULL(RecordDeleted,'N')!='Y'                
  AND DATEADD(dd, DATEDIFF(dd, 0, CreatedDate), 0)<=@LastDateOfMonth                 
  AND MONTH(@CurrentDate)=MONTH(CreatedDate)                 
  AND YEAR(@CurrentDate)=YEAR(CreatedDate)                 
                
  IF @DEBUG=1                
  BEGIN                
   PRINT 'Cashed Out'                
   SELECT @CashedOutBeginning as CashedOutBeginning,@CashedOut  [Cashed Out]                
  END                
                
                            
DECLARE @PLAdjustmentaddedsofar DECIMAL(10,2)      
DECLARE @PLAdjustmentsubsofar DECIMAL(10,2)      
DECLARE @PLTotalAdjsumsofar DECIMAL(10,2)      
      
DECLARE @LTAdjustmentaddedsofar DECIMAL(10,2)      
DECLARE @LTAdjustmentsubsofar DECIMAL(10,2)      
DECLARE @LTTotalAdjsumsofar DECIMAL(10,2)
        
SELECT                 
    @PLAdjustmentaddedsofar = SUM(NumberOfHours)                
  FROM                
  StaffTimeSheetAdjustments STA                
  JOIN GlobalCodes GCA ON STA.AdjustmentType = GCA.GlobalCodeId                
  JOIN GlobalCodes GC ON STA.IncreaseOrDecrease = GC.GlobalCodeId                
  WHERE                
  STA.StaffId=@StaffId                
  AND GCA.Category = 'AccrualType'                
  AND GCA.ExternalCode1='PERSONALLEAVE'                
  AND GC.Category='AdjustmentType'                
  AND GC.ExternalCode1='ADD'                
  AND ISNULL(STA.RecordDeleted,'N')!='Y'                
  AND DATEADD(dd, DATEDIFF(dd, 0, STA.AdjustmentDate), 0)< @StartOfMonth    
  
  
  SELECT                 
     @PLAdjustmentsubsofar = SUM(NumberOfHours)                
  FROM                
  StaffTimeSheetAdjustments STA                
  JOIN GlobalCodes GCA ON STA.AdjustmentType = GCA.GlobalCodeId                
  JOIN GlobalCodes GC ON STA.IncreaseOrDecrease = GC.GlobalCodeId                
  WHERE                
  STA.StaffId=@StaffId                
  AND GCA.Category = 'AccrualType'                
  AND GCA.ExternalCode1='PERSONALLEAVE'                
  AND GC.Category='AdjustmentType'                
  AND GC.ExternalCode1='MINUS'                
  AND ISNULL(STA.RecordDeleted,'N')!='Y'                
  AND DATEADD(dd, DATEDIFF(dd, 0, STA.AdjustmentDate), 0)<  @StartOfMonth                            

SET @PLTotalAdjsumsofar = ISNULL(@PLAdjustmentaddedsofar, 0) - ISNULL(@PLAdjustmentsubsofar, 0)

SELECT                 
    @LTAdjustmentaddedsofar = SUM(NumberOfHours)                
  FROM                
  StaffTimeSheetAdjustments STA                
  JOIN GlobalCodes GCA ON STA.AdjustmentType = GCA.GlobalCodeId                
  JOIN GlobalCodes GC ON STA.IncreaseOrDecrease = GC.GlobalCodeId                
  WHERE                
  STA.StaffId=@StaffId                
  AND GCA.Category = 'AccrualType'                
  AND GCA.ExternalCode1='LONGTERMSICKLEAVE'                
  AND GC.Category='AdjustmentType'                
  AND GC.ExternalCode1='ADD'                
  AND ISNULL(STA.RecordDeleted,'N')!='Y'                
  AND DATEADD(dd, DATEDIFF(dd, 0, STA.AdjustmentDate), 0)< @StartOfMonth             
  
  
  
   SELECT                 
    @LTAdjustmentsubsofar = SUM(NumberOfHours)                
  FROM                
  StaffTimeSheetAdjustments STA                
  JOIN GlobalCodes GCA ON STA.AdjustmentType = GCA.GlobalCodeId                
  JOIN GlobalCodes GC ON STA.IncreaseOrDecrease = GC.GlobalCodeId                
  WHERE                
  STA.StaffId=@StaffId                
  AND GCA.Category = 'AccrualType'                
  AND GCA.ExternalCode1='LONGTERMSICKLEAVE'                
  AND GC.Category='AdjustmentType'                
  AND GC.ExternalCode1='MINUS'                
  AND ISNULL(STA.RecordDeleted,'N')!='Y'                
  AND DATEADD(dd, DATEDIFF(dd, 0, STA.AdjustmentDate), 0)< @StartOfMonth                 
                    
                

  SET @LTTotalAdjsumsofar = ISNULL(@LTAdjustmentaddedsofar, 0) - ISNULL(@LTAdjustmentsubsofar, 0)                                                   
                   
  DECLARE @PersonalLeaveActualBeginningBalance DECIMAL(10,2)                
  DECLARE @LongTermsActualBeginningBalance DECIMAL(10,2)                
  DECLARE @PersonalLeaveActualRemaining DECIMAL(10,2)                
  DECLARE @LongTermLeaveActualRemaining DECIMAL(10,2)                
                
  SET @PersonalLeaveActualBeginningBalance = @PersonalLeaveBeginningBalance +@PLAccrualsBeginning - ISNULL(@PersonalLeaveUsedBegMonth,0) - ISNULL(@CashedOutBeginning,0)  + @PLTotalAdjsumsofar                
  SET @LongTermsActualBeginningBalance = @LongTermLeaveBeginningBalance +@LTAccrualsBeginning - ISNULL(@LongTermLeaveUsedBegMonth,0)  + @LTTotalAdjsumsofar               
                
  SET @PersonalLeaveActualRemaining = @PersonalLeaveActualBeginningBalance + @PLAccruals - ISNULL(@PersonalLeaveUsed,0) - ISNULL(@CashedOut,0)    + ISNULL(@PLAddAdjustment,0) - ISNULL(@PLMinusAdjustment,0)              
  SET @LongTermLeaveActualRemaining = @LongTermsActualBeginningBalance + @LTAccruals - ISNULL(@LongTermLeaveUsed,0)   + ISNULL(@LTAddAdjustment,0) - ISNULL(@LTMinusAdjustment,0)             
                
                
  --SET @PersonalLeaveActualRemaining = @PersonalLeaveBeginningBalance + @PLAccruals - ISNULL(@PersonalLeaveUsed,0) - ISNULL(@CashedOut,0)                
  --SET @LongTermLeaveActualRemaining = @LongTermLeaveBeginningBalance + @LTAccruals - ISNULL(@LongTermLeaveUsed,0)                
                
                
                
  DECLARE @LeaveDetails TABLE                
  (                
   LeaveName NVARCHAR(300)                
   ,LeaveCode NVARCHAR(300)                
   ,BeginningBalance DECIMAL(10,2)                
   ,Earned DECIMAL(10,2)                
   ,Used DECIMAL(10,2)                
   ,AddAdjustment DECIMAL(10,2)                
   ,MinusAdjustment DECIMAL(10,2)                
   ,CashedOut DECIMAL(10,2)                
   ,Remaining DECIMAL(10,2)                
  )                
                
                
  INSERT INTO @LeaveDetails(LeaveName,LeaveCode)                
  SELECT CodeName,ExternalCode1                 
  FROM                 
  GlobalCodes                 
  WHERE                
  Category='StaffLeaveType'                
  AND ExternalCode1 IN ('PERSONALLEAVE','LONGTERMSICKLEAVE')                
                
  ---------------Update values-------------------                
                
                
                
  UPDATE @LeaveDetails                 
  SET                 
  BeginningBalance = @PersonalLeaveActualBeginningBalance                 
  ,Remaining = @PersonalLeaveActualRemaining                
  ,Used = @PersonalLeaveUsed                
  ,Earned = @PLAccruals                   
  ,AddAdjustment = @PLAddAdjustment                
  ,MinusAdjustment = @PLMinusAdjustment                
  ,CashedOut = @CashedOut                
  WHERE LeaveCode = 'PERSONALLEAVE'                
                
  UPDATE @LeaveDetails                 
  SET                 
  BeginningBalance = @LongTermsActualBeginningBalance                 
  ,Remaining = @LongTermLeaveActualRemaining                
  ,Used = @LongTermLeaveUsed                
  ,Earned = @LTAccruals               
  ,AddAdjustment = @LTAddAdjustment                
  ,MinusAdjustment = @LTMinusAdjustment                
  WHERE LeaveCode = 'LONGTERMSICKLEAVE'                
                
                
                
                
  SELECT                 
  LeaveName                 
  ,LeaveCode                
  ,ISNULL(BeginningBalance,0) BeginningBalance               
  ,Earned                 
  ,ISNULL(Used,0) AS  Used                
  ,ISNULL(AddAdjustment,0) AddAdjustment                
  ,ISNULL(MinusAdjustment,0) MinusAdjustment                
  ,CASE WHEN LeaveCode='LONGTERMSICKLEAVE' THEN 'N/A' ELSE CAST(ISNULL(CashedOut,0) AS VARCHAR(10)) END CashedOut                
  ,ISNULL(Remaining,0)   Remaining             
   FROM @LeaveDetails                
                 
 END