IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = OBJECT_ID(N'[dbo].[ssp_SCSearchASP]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_SCSearchASP] 

go 

SET ansi_nulls ON 

go

SET quoted_identifier ON 

go 
CREATE PROCEDURE ssp_SCSearchASP
   
	@ClientId			INT,
	@ProgramId			INT,
	@FrequencyValue		INT,
	@FrequencyCode		VARCHAR(50),
	@Monday				CHAR(1),      
	@Tuesday			CHAR(1),      
	@Wednesday			CHAR(1),      
	@Thursday			CHAR(1),      
	@Friday				CHAR(1),      
	@Saturday			CHAR(1),      
	@Sunday				CHAR(1),   
	@SearchStartDate	DATE,
	@SearchEndDate		DATE,
	@Reschedule         CHAR(1),
	@RescheduleDate		DATE,
	@ASPAdmissionSearch CHAR(1)=NULL
AS 

/*********************************************************************/ 
/* Stored Procedure: dbo.ssp_SCASPSearch            */ 
/* Creation Date:    25/Nov/2013                  */ 
/* Purpose:  Used to search ASP                 */ 
/*    Exec ssp_SCSearchASP @ClientId =18,@ProgramId	=81,@FrequencyValue	=2,@FrequencyCode='Weekly',@Monday ='Y',      
					@Tuesday='Y', @Wednesday='Y',@Thursday='Y',@Friday='Y' ,  @Saturday	='Y',@Sunday='Y',
					  @SearchStartDate	='2014-01-01',@SearchEndDate='2014-01-31',@Reschedule ='N',
					@RescheduleDate		='2013-12-17',@ASPAdmissionSearch=NULL
					select * from ProgramAppointments
					select * from ProgramDailyOccupancyRules
 Exec ssp_SCSearchASP @ClientId =18,@ProgramId	=81,@FrequencyValue	=2,@FrequencyCode='Weekly',@Monday ='N',      
					@Tuesday='Y', @Wednesday='Y',@Thursday='Y',@Friday='Y' ,  @Saturday	='N',@Sunday='N',
					  @SearchStartDate	='2013-12-04',@SearchEndDate='2013-12-22',@Reschedule ='Y',
					@RescheduleDate		='2014-02-27',@ASPAdmissionSearch=NULL					
 Input Parameters:                           */ 
/*  Date			Author			Purpose              */ 
/* 25/Nov/2013		Gautam			Created              */ 
/* 24/Jan/2014      Revathi         Modified to display available dates.                      */
/* 06/May/2014      Gautam          Added code to check NULL for EffectiveTo column in ProgramDailyOccupancyRules table */
/* 24/Sep/2014      Gautam          Added code for date casting  */
/* 17/Apr/2015		Revathi			what:Preference day condition removed
									why:task #235 Philhaven development	 */
  /*********************************************************************/ 
BEGIN   
    BEGIN TRY  
 DECLARE @ProgramName AS VARCHAR(250)   
 DECLARE @ErrorMsg AS NVARCHAR(max)   
  
   select @ErrorMsg=dbo.Ssf_GetMesageByMessageCode(921,'VALIDATEASPRESCHEDULEMESSAGE','There is no appointment for this client on selected date to reschedule. Please select another date and search again.')     
  
   -- Get Only those dates which is same as preferred days  
            
    CREATE TABLE #ConflictAvailableDates   
     (   
     ProgramName       VARCHAR(250),   
     ScheduledDate      DATE,   
     ScheduledDays      CHAR(2),   
     NextAvailableDate DATE,   
     AvailableDays  CHAR(2),   
     FrequencyEnddate DATE,  
     Conflict           CHAR(1)  
     )   
  
   CREATE TABLE #AvailableDates   
     (   
     ProgramName      VARCHAR(250),   
     AvailableDate    DATE,   
     AvailableDays    CHAR(2),   
     FrequencyEnddate DATE   
     )   
  
   CREATE TABLE #RescheduleMessage   
     (   
     MessageDtls VARCHAR(250)   
     )   
       
     CREATE TABLE #GetAllSearchDates   
     (   
     ClientId         INT,   
     ProgramId        INT,   
     SearchDate       DATETIME,   
     WeekDays         VARCHAR(max),   
     FrequencyEnddate DATE   
     )   
  
   CREATE TABLE #OccupancyCount   
     (   
     ClientId        INT,   
     ProgramId       INT,   
     OccupancyCount  INT,   
     AppointmentDate DATE   
     )   
  
   CREATE TABLE #DailyOccupancy   
     (   
     ClientId         INT,   
     ProgramId        INT,   
     DailyOccupancy   INT,   
     AppointmentDate  DATE,   
     FrequencyEnddate DATE,   
     ConfilctDate     DATE   
     )   
  
   CREATE TABLE #GetAllNextAvailableDates   
     (   
     ClientId         INT,   
     ProgramId        INT,   
     NextSearchDate   DATE,   
     WeekDays         VARCHAR(max),   
     ConfilctDate     DATE,   
     FrequencyEnddate DATE   
     )   
  
   CREATE TABLE #TempNextAvailableDate   
     (   
     NextAvailableDate DATE,   
     ConflictDate      DATE,   
     FrequencyEnddate  DATE,   
     RowFilter         INT   
     )   
   -- If its Reschedule and Appointment is not available on RescheduleDate then Simply Display message and return   
   -- all three temp tables empty  
   If @Reschedule='Y' and not exists(Select 1 from ProgramAppointments Where cast(AppointmentDate as date)=cast(@RescheduleDate as date) and ProgramId=@ProgramId  
            and ClientId=@ClientId And Isnull(RecordDeleted,'N')='N')  
    Begin  
     Insert Into #RescheduleMessage  
     Select @ErrorMsg  
       
      Select DISTINCT CF.ProgramName,CF.ScheduledDate,CF.ScheduledDays,CF.NextAvailableDate,CF.AvailableDays,CF.Conflict From #ConflictAvailableDates CF
    WHERE ( EXISTS(SELECT 1 FROM ProgramAppointments PA WHERE cast(PA.AppointmentDate as date)= cast(CF.ScheduledDate as date) AND PA.ClientId=@ClientId AND PA.ProgramId=@ProgramId) OR  Conflict='Y')
    order by CF.ScheduledDate     
     Select DISTINCT ProgramName,AvailableDate,AvailableDays From #AvailableDates order by AvailableDate          
     
     Select MessageDtls From #RescheduleMessage  
     Return  
    End   
     
   SELECT @ProgramName = ProgramName   
   FROM   Programs   
   WHERE  ProgramId = @ProgramId   
       AND ISNULL(RecordDeleted, 'N') = 'N'   
  
   /* Get All Search Dates between SearchStartDate and SearchEndDate*/   
   INSERT INTO #GetAllSearchDates   
      (ClientId,   
       ProgramId,   
       SearchDate,   
       weekdays,   
       frequencyenddate)   
   SELECT *   
   FROM   [dbo].[ssf_GetAllDatesforAppointmentSearch] (@ClientId, @ProgramId,   
        @SearchStartDate, @SearchEndDate, @Monday, @Tuesday, @Wednesday,   
        @Thursday, @Friday, @Saturday, @Sunday, @Reschedule,   
       @RescheduleDate)   
  
   /* Get OccupancyCount for All Search  Dates*/   
   INSERT INTO #OccupancyCount   
      (ClientId,   
       ProgramId,   
       OccupancyCount,   
       AppointmentDate)   
   SELECT @ClientId,   
       @ProgramId,   
       ISNULL(COUNT(*), 0) AS OccupancyCount,   
       PA.AppointmentDate   
   FROM   ProgramAppointments PA   
       INNER JOIN #GetAllSearchDates GD   
         ON cast(PA.AppointmentDate as date) = cast(GD.SearchDate as date)  
   WHERE  PA.ProgramId = @ProgramId  
       AND ISNULL(PA.RecordDeleted, 'N') = 'N'   
   GROUP  BY PA.AppointmentDate   
   ORDER BY PA.AppointmentDate  
  
   /* Get DailyOccupancy for All Search  Dates*/   
   INSERT INTO #DailyOccupancy   
      (ClientId,   
       ProgramId,   
       DailyOccupancy,   
       AppointmentDate,   
       FrequencyEnddate)   
   SELECT GD.ClientId,   
       GD.ProgramId,   
       ISNULL(PDO.DailyOccupancy, 0),   
       GD.SearchDate,   
       GD.FrequencyEnddate   
   FROM   ProgramDailyOccupancyRules PDO   
       INNER JOIN #GetAllSearchDates GD   
         ON GD.ProgramId = PDO.ProgramId   
   WHERE  GD.SearchDate >= cast(PDO.EffectiveFrom as date)   
       AND (GD.SearchDate <= cast(PDO.EffectiveTo as date) or PDO.EffectiveTo is null)  
       AND PDO.ProgramId = @ProgramId   
       AND ISNULL(PDO.RecordDeleted, 'N') = 'N'   
       AND ( ISNULL(Monday, 'N') = 'Y'   
       AND ( DATENAME(dw, GD.SearchDate) = 'Monday' )   
        OR ISNULL(Tuesday, 'N') = 'Y'   
        AND ( DATENAME(dw, GD.SearchDate) = 'Tuesday' )   
        OR ISNULL(Wednesday, 'N') = 'Y'   
        AND ( DATENAME(dw, GD.SearchDate) = 'Wednesday' )   
        OR ISNULL(Thursday, 'N') = 'Y'   
        AND ( DATENAME(dw, GD.SearchDate) = 'Thursday' )   
        OR ISNULL(Friday, 'N') = 'Y'   
        AND ( DATENAME(dw, GD.SearchDate) = 'Friday' )   
        OR ISNULL(Saturday, 'N') = 'Y'   
        AND ( DATENAME(dw, GD.SearchDate) = 'Saturday' )   
        OR ISNULL(Sunday, 'N') = 'Y'   
        AND ( DATENAME(dw, GD.SearchDate) = 'Sunday' ) )   
                  ORDER BY GD.SearchDate  
   /* Insert Available date into  #AvailableDates table*/   
   INSERT INTO #AvailableDates   
      (ProgramName,   
       AvailableDate,   
       AvailableDays,   
       FrequencyEnddate)   
   SELECT   
     --commented by Revathi 17/Apr/2015  
   --TOP (CASE WHEN @Reschedule = 'Y' THEN @@ROWCOUNT ELSE @@ROWCOUNT END)   
   ProgramName,   
   AppointmentDate,   
   Appointmentday,   
   FrequencyEnddate   
   FROM   (SELECT @ProgramName        AS ProgramName,   
         DO.AppointmentDate  AS AppointmentDate,   
         SUBSTRING(DATENAME(dw, DO.AppointmentDate), 1, 2) AS Appointmentday,   
         DO.FrequencyEnddate AS FrequencyEnddate,   
         ROW_NUMBER()   
        OVER (   
          PARTITION BY DO.FrequencyEnddate   
          ORDER BY DO.AppointmentDate) RowNumber   
     FROM   #DailyOccupancy DO   
     WHERE  DailyOccupancy > 0   
         AND NOT EXISTS (SELECT 1   
             FROM   ProgramAppointments PA   
             WHERE  cast(PA.AppointmentDate as date) = cast(DO.AppointmentDate as date)  
              AND PA.ProgramId = @ProgramId   
              AND PA.ClientId = @ClientId   
              AND ISNULL(PA.RecordDeleted, 'N') = 'N')   
         AND ISNULL((SELECT OccupancyCount   
            FROM   #OccupancyCount OC   
            WHERE  OC.AppointmentDate = do.AppointmentDate), 0) <   
          DO.DailyOccupancy  
          --commented by Revathi 17/Apr/2015  
  --          AND (ISNULL(@Monday, 'N') = 'Y' AND (DATENAME(dw, DO.AppointmentDate) = 'Monday') OR  
  --ISNULL(@Tuesday, 'N') = 'Y' AND (DATENAME(dw, DO.AppointmentDate) = 'Tuesday') OR  
  --ISNULL(@Wednesday, 'N') = 'Y' AND (DATENAME(dw, DO.AppointmentDate) = 'Wednesday') OR  
  --ISNULL(@Thursday, 'N') = 'Y' AND (DATENAME(dw, DO.AppointmentDate) = 'Thursday') OR  
  --ISNULL(@Friday, 'N') = 'Y' AND (DATENAME(dw, DO.AppointmentDate) = 'Friday') OR  
  --ISNULL(@Saturday, 'N') = 'Y' AND (DATENAME(dw, DO.AppointmentDate) = 'Saturday') OR  
  --ISNULL(@Sunday, 'N') = 'Y' AND (DATENAME(dw, DO.AppointmentDate) = 'Sunday'))  
    --Added by Revathi 17/Apr/2015  
    AND ( (DATENAME(dw, DO.AppointmentDate) = 'Monday') OR  
 (DATENAME(dw, DO.AppointmentDate) = 'Tuesday') OR  
  (DATENAME(dw, DO.AppointmentDate) = 'Wednesday') OR  
    (DATENAME(dw, DO.AppointmentDate) = 'Thursday') OR  
   (DATENAME(dw, DO.AppointmentDate) = 'Friday') OR  
  (DATENAME(dw, DO.AppointmentDate) = 'Saturday') OR  
  (DATENAME(dw, DO.AppointmentDate) = 'Sunday'))  
  ) GetAllAvailableDates   
   WHERE    
   --GetAllAvailableDates.RowNumber <= @FrequencyValue and   
   GetAllAvailableDates.AppointmentDate<=@SearchEndDate   
   order by GetAllAvailableDates.AppointmentDate  
     
     
     
   /* Insert Confilct date into  ##ConflictAvailableDates table*/   
   INSERT INTO #ConflictAvailableDates   
      (ProgramName,   
       ScheduledDate,   
       ScheduledDays,   
       FrequencyEnddate,  
       Conflict)   
   SELECT @ProgramName AS ProgramName,   
       AppointmentDate,   
       SUBSTRING(DATENAME(dw, AppointmentDate), 1, 2) AS AppointmentDay,   
       FrequencyEnddate  
       ,(case when ISNULL(@Monday, 'N') = 'Y' AND (DATENAME(dw, AppointmentDate) = 'Monday') then 'Y'          
          when ISNULL(@Tuesday, 'N') = 'Y' AND (DATENAME(dw, AppointmentDate) = 'Tuesday') then 'Y'  
           when ISNULL(@Wednesday, 'N') = 'Y' AND (DATENAME(dw, AppointmentDate) = 'Wednesday') then 'Y'             
       when ISNULL(@Thursday, 'N') = 'Y' AND (DATENAME(dw,AppointmentDate) = 'Thursday') then 'Y'   
       when ISNULL(@Friday, 'N') = 'Y' AND (DATENAME(dw, AppointmentDate) = 'Friday') then 'Y'  
        when ISNULL(@Saturday, 'N') = 'Y' AND (DATENAME(dw,AppointmentDate) = 'Saturday') then 'Y'  
       when ISNULL(@Sunday, 'N') = 'Y' AND (DATENAME(dw, AppointmentDate) = 'Sunday') then  'Y'   
       else 'N' END) as Conflict  
   FROM   (SELECT AppointmentDate,   
         FrequencyEnddate,   
         ROW_NUMBER()   
        OVER (   
          PARTITION BY FrequencyEnddate   
          ORDER BY AppointmentDate) AS RowNumber   
     FROM   (SELECT DO.AppointmentDate  AS AppointmentDate,   
           DO.FrequencyEnddate AS FrequencyEnddate   
       FROM   #DailyOccupancy DO   
       WHERE  DailyOccupancy > 0   
           AND ISNULL((SELECT OccupancyCount   
              FROM   #OccupancyCount OC   
              WHERE  OC.AppointmentDate =   
               do.AppointmentDate), 0)   
            >= DO.DailyOccupancy   
         OR EXISTS (SELECT 1   
              FROM   ProgramAppointments PA   
              WHERE  cast(PA.AppointmentDate as date) =   
               cast(DO.AppointmentDate  as date)  
               AND PA.ProgramId = @ProgramId   
               AND PA.ClientId = @ClientId   
               AND ISNULL(PA.RecordDeleted, 'N') = 'N')  
                 --commented by Revathi 17/Apr/2015  
          --AND (ISNULL(@Monday, 'N') = 'Y' AND (DATENAME(dw, DO.AppointmentDate) = 'Monday') OR  
          --ISNULL(@Tuesday, 'N') = 'Y' AND (DATENAME(dw, DO.AppointmentDate) = 'Tuesday') OR  
          --ISNULL(@Wednesday, 'N') = 'Y' AND (DATENAME(dw, DO.AppointmentDate) = 'Wednesday') OR  
          --ISNULL(@Thursday, 'N') = 'Y' AND (DATENAME(dw, DO.AppointmentDate) = 'Thursday') OR  
          --ISNULL(@Friday, 'N') = 'Y' AND (DATENAME(dw, DO.AppointmentDate) = 'Friday') OR  
          --ISNULL(@Saturday, 'N') = 'Y' AND (DATENAME(dw, DO.AppointmentDate) = 'Saturday') OR  
          --ISNULL(@Sunday, 'N') = 'Y' AND (DATENAME(dw, DO.AppointmentDate) = 'Sunday'))   
            --Added by Revathi 17/Apr/2015  
          AND ( (DATENAME(dw, DO.AppointmentDate) = 'Monday') OR  
          (DATENAME(dw, DO.AppointmentDate) = 'Tuesday') OR  
          (DATENAME(dw, DO.AppointmentDate) = 'Wednesday') OR  
          (DATENAME(dw, DO.AppointmentDate) = 'Thursday') OR  
           (DATENAME(dw, DO.AppointmentDate) = 'Friday') OR  
           (DATENAME(dw, DO.AppointmentDate) = 'Saturday') OR  
           (DATENAME(dw, DO.AppointmentDate) = 'Sunday'))   
           )   
         #tempconflict   
     WHERE    
     --#tempconflict.FrequencyEnddate NOT IN   
     --    (SELECT AD.FrequencyEnddate   
     --  FROM   #AvailableDates AD   
     --  WHERE  AD.FrequencyEnddate = #tempconflict.FrequencyEnddate   
     --  GROUP  BY AD.FrequencyEnddate   
     --  HAVING COUNT(ad.FrequencyEnddate) >= @FrequencyValue)   
     --    AND   
         @Reschedule = 'N') GetAllConflictAvailableDates   
   WHERE   
    --GetAllConflictAvailableDates.RowNumber <= @FrequencyValue and  
    GetAllConflictAvailableDates.AppointmentDate<=@SearchEndDate  
            ORDER BY GetAllConflictAvailableDates.AppointmentDate  
              
              
              
   /* Get All Next Available Search Dates  */   
   INSERT INTO #GetAllNextAvailableDates   
      (ClientId,   
       ProgramId,   
       NextSearchDate,   
       weekdays,   
       ConfilctDate,   
       FrequencyEnddate)   
   SELECT TempNextSearchDate.*   
   FROM   #ConflictAvailableDates CA   
       CROSS APPLY [dbo].[ssf_GetAllNextAvailableDates](@ClientId, @ProgramId,   
          CA.ScheduledDate,   
   CA.FrequencyEnddate)   
   TempNextSearchDate   
  
   DELETE FROM #OccupancyCount   
  
   DELETE FROM #DailyOccupancy   
  
   /*Insert OccupancyCount for Next Available Search Dates  */   
   INSERT INTO #OccupancyCount   
      (ClientId,   
       ProgramId,   
       OccupancyCount,   
       AppointmentDate)   
   SELECT @ClientId,   
       @ProgramId,   
       ISNULL(COUNT(*), 0) AS OccupancyCount,   
       PA.AppointmentDate   
   FROM   ProgramAppointments PA   
       INNER JOIN #GetAllNextAvailableDates GNA   
         ON cast( PA.AppointmentDate as date)= GNA.NextSearchDate   
         AND PA.ProgramId = GNA.ProgramId   
   WHERE  PA.ProgramId = @ProgramId   
       AND ISNULL(PA.RecordDeleted, 'N') = 'N'   
   GROUP  BY PA.AppointmentDate   
   ORDER BY PA.AppointmentDate   
   /*Insert DailyOccupancy for Next Available Search Dates  */   
   INSERT INTO #DailyOccupancy   
      (ClientId,   
       ProgramId,   
       DailyOccupancy,   
       AppointmentDate,   
       FrequencyEnddate,   
       ConfilctDate)   
   SELECT GNA.ClientId,   
       GNA.ProgramId,   
       ISNULL(PDO.DailyOccupancy, 0),   
       GNA.NextSearchDate,   
       GNA.FrequencyEnddate,   
       GNA.confilctdate   
   FROM   ProgramDailyOccupancyRules PDO   
       INNER JOIN #GetAllNextAvailableDates GNA   
         ON GNA.ProgramId = PDO.ProgramId   
   WHERE  GNA.NextSearchDate >= cast( PDO.EffectiveFrom  as date)  
       AND( GNA.NextSearchDate <= cast(PDO.EffectiveTo as date) OR PDO.EffectiveTo is NULL)  
       AND PDO.ProgramId = @ProgramId  
       AND ISNULL(PDO.RecordDeleted, 'N') = 'N'   
       AND ( ISNULL(Monday, 'N') = 'Y'   
       AND ( DATENAME(dw, GNA.NextSearchDate) = 'Monday' )   
        OR ISNULL(Tuesday, 'N') = 'Y'   
        AND ( DATENAME(dw, GNA.NextSearchDate) = 'Tuesday' )   
        OR ISNULL(Wednesday, 'N') = 'Y'   
        AND ( DATENAME(dw, GNA.NextSearchDate) = 'Wednesday' )   
        OR ISNULL(Thursday, 'N') = 'Y'   
        AND ( DATENAME(dw, GNA.NextSearchDate) = 'Thursday' )   
        OR ISNULL(Friday, 'N') = 'Y'   
        AND ( DATENAME(dw, GNA.NextSearchDate) = 'Friday' )   
        OR ISNULL(Saturday, 'N') = 'Y'   
        AND ( DATENAME(dw, GNA.NextSearchDate) = 'Saturday' )   
        OR ISNULL(Sunday, 'N') = 'Y'   
        AND ( DATENAME(dw, GNA.NextSearchDate) = 'Sunday' ) )   
                       ORDER BY GNA.NextSearchDate  
   /*Get Next Available Dates */   
   INSERT INTO #TempNextAvailableDate   
      (NextAvailableDate,   
       ConflictDate,   
       FrequencyEnddate,   
       RowFilter)   
   SELECT do.AppointmentDate AS AppointmentDate,   
       do.confilctdate,   
       do.FrequencyEnddate  AS FrequencyEnddate,   
       ROW_NUMBER()   
      OVER (   
        PARTITION BY do.confilctdate   
        ORDER BY do.AppointmentDate) AS RowFilter   
   FROM   #DailyOccupancy do   
   WHERE  DailyOccupancy > 0   
       AND NOT EXISTS (SELECT 1   
           FROM   ProgramAppointments   
           WHERE cast(AppointmentDate as date) = do.AppointmentDate   
            AND ProgramId = @ProgramId   
            AND ClientId = @ClientId   
            AND ISNULL(RecordDeleted, 'N') = 'N')   
       AND ISNULL((SELECT OccupancyCount   
          FROM   #OccupancyCount   
          WHERE  cast(AppointmentDate as date)  = do.AppointmentDate), 0) <   
        DailyOccupancy   
        and  
         do.AppointmentDate   
      NOT IN (SELECT AvailableDate   
          FROM   #AvailableDates)   
                    ORDER BY do.AppointmentDate,do.confilctdate  
   /*Update first Next Available Dates to respective Confilct Dates #ConflictAvailableDates table */   
   UPDATE #ConflictAvailableDates   
   SET    NextAvailableDate = NA.NextAvailableDate,   
       AvailableDays = SUBSTRING(DATENAME(dw, NA.NextAvailableDate), 1, 2)   
   FROM   #TempNextAvailableDate NA   
       JOIN #ConflictAvailableDates CA   
      ON CA.ScheduledDate = NA.ConflictDate        
   WHERE  RowFilter = 1       
  
   /*Insert Next Available Dates and Confilct Dates into #ConflictAvailableDates table */   
   INSERT INTO #ConflictAvailableDates   
      (ProgramName,   
       ScheduledDate,   
       ScheduledDays,   
       NextAvailableDate,   
       AvailableDays,   
       FrequencyEnddate,
       Conflict)   
   SELECT @ProgramName,   
       NA.ConflictDate,   
       SUBSTRING(DATENAME(dw, NA.ConflictDate), 1, 2),   
       NA.NextAvailableDate,   
       SUBSTRING(DATENAME(dw, NA.NextAvailableDate), 1, 2),   
       NA.FrequencyEnddate ,
       (case when ISNULL(@Monday, 'N') = 'Y' AND (DATENAME(dw, NA.ConflictDate) = 'Monday') then 'Y'            
          when ISNULL(@Tuesday, 'N') = 'Y' AND (DATENAME(dw, NA.ConflictDate) = 'Tuesday') then 'Y'    
           when ISNULL(@Wednesday, 'N') = 'Y' AND (DATENAME(dw, NA.ConflictDate) = 'Wednesday') then 'Y'               
       when ISNULL(@Thursday, 'N') = 'Y' AND (DATENAME(dw,NA.ConflictDate) = 'Thursday') then 'Y'     
       when ISNULL(@Friday, 'N') = 'Y' AND (DATENAME(dw, NA.ConflictDate) = 'Friday') then 'Y'    
        when ISNULL(@Saturday, 'N') = 'Y' AND (DATENAME(dw,NA.ConflictDate) = 'Saturday') then 'Y'    
       when ISNULL(@Sunday, 'N') = 'Y' AND (DATENAME(dw, NA.ConflictDate) = 'Sunday') then  'Y'     
       else 'N' END) as Conflict 
   FROM   #TempNextAvailableDate NA   
       JOIN #ConflictAvailableDates CA   
      ON CA.ScheduledDate = NA.ConflictDate   
   WHERE  NA.RowFilter > 1   
       AND NA.RowFilter <= 5         
     
        -- Remove available date from #ConflictAvailableDates if inserted  
        --Delete from #ConflictAvailableDates Where NextAvailableDate in(Select AvailableDate from #AvailableDates)  
        -- IF this SP is called from Admission Schedule Search  
        IF @ASPAdmissionSearch ='Y'      
   Begin           
    IF OBJECT_ID('tempdb..#AdmissionAvailableDates') IS NOT NULL      
    Begin      
     Insert into #AdmissionAvailableDates (AvailableDate)                                          
     select Distinct NextAvailableDate from #ConflictAvailableDates   
     union  
     Select AvailableDate From #AvailableDates                                                  
    End      
   End      
  Else      
   Begin      
    Select DISTINCT CF.ProgramName,CF.ScheduledDate,CF.ScheduledDays,CF.NextAvailableDate,CF.AvailableDays,CF.Conflict From #ConflictAvailableDates CF
    WHERE (EXISTS(SELECT 1 FROM ProgramAppointments PA WHERE cast(PA.AppointmentDate as date)= cast(CF.ScheduledDate as date) AND PA.ClientId=@ClientId AND PA.ProgramId=@ProgramId) OR  Conflict='Y')
    order by CF.ScheduledDate   
    Select DISTINCT ProgramName,AvailableDate,AvailableDays From #AvailableDates order by AvailableDate   
    Select MessageDtls From #RescheduleMessage  
   End   
        
      END try   
  
      BEGIN catch   
          DECLARE @Error VARCHAR(max)   
  
          SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'   
                      + CONVERT(VARCHAR(4000), ERROR_MESSAGE())   
                      + '*****'   
                      + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),   
                      'ssp_SCSearchASP'   
                      )   
                      + '*****' + CONVERT(VARCHAR, ERROR_LINE())   
                      + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY())   
                      + '*****' + CONVERT(VARCHAR, ERROR_STATE())   
  
          RAISERROR ( @Error,   
                      -- Message text.                                                                                   
                      16,   
                      -- Severity.                                                                                   
                      1   
          -- State.                                                                                   
          );   
      END catch   
  END   
  GO
  
