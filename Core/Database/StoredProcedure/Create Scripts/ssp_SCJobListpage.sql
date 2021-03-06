/****** Object:  StoredProcedure [dbo].[ssp_joblistpage]    Script Date: 01/11/2018 12:46:40 ******/ 
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = Object_id(N'[dbo].[ssp_joblistpage]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_joblistpage] 

go 

/****** Object:  StoredProcedure [dbo].[ssp_joblistpage]    Script Date: 01/11/2018 12:46:40 ******/ 
SET ansi_nulls ON 

go 

SET quoted_identifier ON 

go 

CREATE PROC [dbo].[ssp_joblistpage] 
/*************************************************************/ 
/* Stored Procedure: dbo.[[ssp_joblistpage]]              */ 
/* Creation Date:  05/03/2013                                */ 
/* Purpose: To display the SQL jobs in list page     */ 
/*  Date                  Author                 Purpose     */ 
/* 13/12/2017          Rajeshwari           Created     */ 
/*************************************************************/ 
(@PageNumber     INT, 
 @PageSize       INT, 
 @SortExpression VARCHAR(100), 
 @JobName        VARCHAR(100), 
 @Occurence      VARCHAR(100)) 
AS 
  BEGIN 
      SET @SortExpression = Rtrim(Ltrim(@SortExpression)) 

      IF Isnull(@SortExpression, '') = '' 
        SET @SortExpression = 'CategoryCode'; 

      WITH recodeslistresultset 
           AS (SELECT [sJOB].[name] AS [Name], 
                      CASE [sSCH].[freq_type] 
                        WHEN 4 THEN 'Occurs every ' + ' day' + ' at ' 
                                    + Stuff( Stuff(RIGHT('000000' + Cast( 
                                    [active_start_time] 
                                    AS 
                                    VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':') 
                                    + '.Schedule will be used starting on ' 
                                    + Stuff( Stuff(Cast([active_start_date] AS 
                                    VARCHAR 
                                    (8)), 
                                    5, 
                                    0, '-') 
                                    , 8, 0, '-') 
                        WHEN 8 THEN 'Occurs every ' + ' week on ' + CASE WHEN 
                                    [freq_interval] 
                                    & 1 = 1 
                                    THEN 'Sunday' 
                                    ELSE '' END + CASE WHEN [freq_interval] & 2 
                                    = 
                                    2 
                                    THEN 
                                    ', Monday' 
                                    ELSE '' END + CASE WHEN [freq_interval] & 4 
                                    = 
                                    4 
                                    THEN 
                                    ', Tuesday' 
                                    ELSE '' END + CASE WHEN [freq_interval] & 8 
                                    = 
                                    8 
                                    THEN 
                                    ', Wednesday' 
                                    ELSE '' END 
                                    + CASE WHEN [freq_interval] & 16 = 16 THEN 
                                    ', Thursday' 
                                    ELSE '' 
                                    END + CASE WHEN [freq_interval] & 32 = 32 
                                    THEN 
                                    ', Friday' 
                                    ELSE '' 
                                    END + CASE WHEN [freq_interval] & 64 = 64 
                                    THEN 
                                    ', Saturday' ELSE 
                                    '' END + ' at ' 
                                    + Stuff(Stuff(RIGHT('000000' + Cast( 
                                    [active_start_time] 
                                    AS 
                                    VARCHAR 
                                    (6)), 6), 3, 0, ':'), 6, 0, ':') 
                                    + '.Schedule will be used starting on ' 
                                    + Stuff( Stuff(Cast([active_start_date] AS 
                                    VARCHAR 
                                    (8)), 
                                    5, 
                                    0, '-') 
                                    , 8, 0, '-') 
                        WHEN 16 THEN 'Occurs on Day ' + ' of every ' 
                                     + Cast([freq_recurrence_factor] AS VARCHAR( 
                                     3) 
                                     ) 
                                     + ' month' + ' at ' 
                                     + Stuff(Stuff(RIGHT('000000' + Cast( 
                                     [active_start_time] 
                                     AS 
                                     VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':') 
                                     + '.Schedule will be used starting on ' 
                                     + Stuff( Stuff(Cast([active_start_date] AS 
                                     VARCHAR(8)) 
                                     , 5 
                                     , 0, '-' 
                                     ), 8, 0, '-') 
                      END           AS ScheduleDetail, 
                      CASE [sSCH].[enabled] 
                        WHEN 1 THEN 'Yes' 
                        ELSE 'No' 
                        END  AS [Enabled] 
               FROM   [msdb].[dbo].[sysjobs] AS [sJOB] 
                      LEFT JOIN [msdb].[dbo].[sysjobschedules] AS [sJOBSCH] 
                             ON [sJOB].[job_id] = [sJOBSCH].[job_id] 
                      LEFT JOIN [msdb].[dbo].[sysschedules] AS [sSCH] 
                             ON [sJOBSCH].[schedule_id] = [sSCH].[schedule_id] 
                      LEFT JOIN [msdb].[dbo].[sysjobsteps] AS [sJSTP] 
                             ON [sJOB].[job_id] = [sJSTP].[job_id] 
               WHERE  ( [sJOB].[name] LIKE '%' + @jobname + '%' 
                         OR Isnull(@JobName, '') = '' ) 
                      AND ( [sSCH].freq_type = @Occurence 
                             OR Isnull(@Occurence, '') = '' ) 
                      AND [sJSTP].database_name = (SELECT Db_name())
                      ), 
           counts 
           AS (SELECT Count(*) AS totalrows 
               FROM   recodeslistresultset), 
           rankresultset 
           AS (SELECT NAME, 
                      ScheduleDetail, 
                      Enabled, 
                      Count(*) 
                        OVER ( )           AS TotalCount, 
                      Rank() 
                        OVER ( 
                          ORDER BY CASE WHEN @SortExpression= 'Name' THEN NAME 
                        END 
                        , 
                        CASE 
                        WHEN 
                        @SortExpression= 'Name DESC' THEN NAME END DESC, CASE 
                        WHEN 
                        @SortExpression= 
                        'ScheduleDetail' THEN ScheduleDetail END, CASE WHEN 
                        @SortExpression 
                        = 
                        'ScheduleDetail DESC' THEN ScheduleDetail END DESC, CASE 
                        WHEN 
                        @SortExpression= 
                        'Enabled' THEN Enabled END, CASE WHEN @SortExpression= 
                        'Enabled DESC' 
                        THEN 
                        Enabled END DESC ) AS RowNumber 
               FROM   recodeslistresultset) 
      SELECT TOP ( CASE WHEN (@PageNumber = -1) THEN (SELECT Isnull(totalrows, 0 
      ) 
      FROM counts 
      ) ELSE (@PageSize) END) NAME, 
                              ScheduleDetail, 
                              Enabled, 
                              TotalCount, 
                              RowNumber 
      INTO   #finalresultset 
      FROM   rankresultset 
      WHERE  RowNumber > ( ( @PageNumber - 1 ) * @PageSize ) 

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
                         CASE ( TotalCount % @PageSize ) 
                           WHEN 0 THEN Isnull(( TotalCount / @PageSize ), 0) 
                           ELSE Isnull(( TotalCount / @PageSize ), 0) + 1 
                         END                   AS NumberOfPages, 
                         Isnull(TotalCount, 0) AS NumberOfRows 
            FROM   #finalresultset 
        END 

      SELECT NAME, 
             ScheduleDetail, 
             Enabled 
      FROM   #finalresultset 
  END 

go 