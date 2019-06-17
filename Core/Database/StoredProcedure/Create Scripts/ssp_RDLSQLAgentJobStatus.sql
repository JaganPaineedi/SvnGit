IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_RDLSQLAgentJobStatus')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE ssp_RDLSQLAgentJobStatus;
    END;
GO

CREATE PROCEDURE ssp_RDLSQLAgentJobStatus
AS /******************************************************************************
**		File: 
**		Name: ssp_RDLSQLAgentJobStatus
**		Desc: 
**
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**
**		Auth: jcarlson
**		Date: 2/14/2017
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**      02/14/2017      jcarlson                created
**      02/21/2017      jcarlson			    limit to just the jobs/steps that are for the current DB, only show TSQL steps
*******************************************************************************/
    BEGIN TRY
        SELECT  SERVERPROPERTY('Servername') AS ServerName, categories.name AS CategoryName, jobs.name, SUSER_SNAME(jobs.owner_sid) AS OwnerID,
                CASE jobs.enabled
                  WHEN 1 THEN 'Yes'
                  ELSE 'No'
                END AS Enabled, CASE schedule.enabled
                                  WHEN 1 THEN 'Yes'
                                  ELSE 'No'
                                END AS Scheduled, jobs.description,
                CASE WHEN jobs.description = 'This job is owned by a report server process. Modifying this job could result in database incompatibilities. Use Report Manager or Management Studio to update this job.'
                     THEN 'Yes'
                     ELSE 'No'
                END AS ReportServerJob, CASE schedule.freq_type
                                          WHEN 1 THEN 'Once'
                                          WHEN 4 THEN 'Daily'
                                          WHEN 8 THEN 'Weekly'
                                          WHEN 16 THEN 'Monthly'
                                          WHEN 32 THEN 'Monthly relative'
                                          WHEN 64 THEN 'When SQL Server Agent starts'
                                          WHEN 128 THEN 'Start whenever the CPU(s) become idle'
                                          ELSE ''
                                        END AS FequencyType,
                CASE schedule.freq_type
                  WHEN 1 THEN 'O'
                  WHEN 4 THEN 'Every ' + CONVERT(VARCHAR, schedule.freq_interval) + ' day(s)'
                  WHEN 8
                  THEN 'Every ' + CONVERT(VARCHAR, schedule.freq_recurrence_factor) + ' weeks(s) on '
                       + LEFT(CASE WHEN schedule.freq_interval & 1 = 1 THEN 'Sunday, '
                                   ELSE ''
                              END + CASE WHEN schedule.freq_interval & 2 = 2 THEN 'Monday, '
                                         ELSE ''
                                    END + CASE WHEN schedule.freq_interval & 4 = 4 THEN 'Tuesday, '
                                               ELSE ''
                                          END + CASE WHEN schedule.freq_interval & 8 = 8 THEN 'Wednesday, '
                                                     ELSE ''
                                                END + CASE WHEN schedule.freq_interval & 16 = 16 THEN 'Thursday, '
                                                           ELSE ''
                                                      END + CASE WHEN schedule.freq_interval & 32 = 32 THEN 'Friday, '
                                                                 ELSE ''
                                                            END + CASE WHEN schedule.freq_interval & 64 = 64 THEN 'Saturday, '
                                                                       ELSE ''
                                                                  END,
                              LEN(CASE WHEN schedule.freq_interval & 1 = 1 THEN 'Sunday, '
                                       ELSE ''
                                  END + CASE WHEN schedule.freq_interval & 2 = 2 THEN 'Monday, '
                                             ELSE ''
                                        END + CASE WHEN schedule.freq_interval & 4 = 4 THEN 'Tuesday, '
                                                   ELSE ''
                                              END + CASE WHEN schedule.freq_interval & 8 = 8 THEN 'Wednesday, '
                                                         ELSE ''
                                                    END + CASE WHEN schedule.freq_interval & 16 = 16 THEN 'Thursday, '
                                                               ELSE ''
                                                          END + CASE WHEN schedule.freq_interval & 32 = 32 THEN 'Friday, '
                                                                     ELSE ''
                                                                END + CASE WHEN schedule.freq_interval & 64 = 64 THEN 'Saturday, '
                                                                           ELSE ''
                                                                      END) - 1)
                  WHEN 16
                  THEN 'Day ' + CONVERT(VARCHAR, schedule.freq_interval) + ' of every ' + CONVERT(VARCHAR, schedule.freq_recurrence_factor) + ' month(s)'
                  WHEN 32 THEN 'The ' + CASE schedule.freq_relative_interval
                                          WHEN 1 THEN 'First'
                                          WHEN 2 THEN 'Second'
                                          WHEN 4 THEN 'Third'
                                          WHEN 8 THEN 'Fourth'
                                          WHEN 16 THEN 'Last'
                                        END + CASE schedule.freq_interval
                                                WHEN 1 THEN ' Sunday'
                                                WHEN 2 THEN ' Monday'
                                                WHEN 3 THEN ' Tuesday'
                                                WHEN 4 THEN ' Wednesday'
                                                WHEN 5 THEN ' Thursday'
                                                WHEN 6 THEN ' Friday'
                                                WHEN 7 THEN ' Saturday'
                                                WHEN 8 THEN ' Day'
                                                WHEN 9 THEN ' Weekday'
                                                WHEN 10 THEN ' Weekend Day'
                                              END + ' of every ' + CONVERT(VARCHAR, schedule.freq_recurrence_factor) + ' month(s)'
                  ELSE ''
                END AS Occurence,
                CASE schedule.freq_subday_type
                  WHEN 1 THEN 'Occurs once at ' + STUFF(STUFF(RIGHT('000000' + CONVERT(VARCHAR(8), schedule.active_start_time), 6), 5, 0, ':'), 3, 0, ':')
                  WHEN 2
                  THEN 'Occurs every ' + CONVERT(VARCHAR, schedule.freq_subday_interval) + ' Seconds(s) between ' + STUFF(STUFF(RIGHT('000000'
                                                                                                                                      + CONVERT(VARCHAR(8), schedule.active_start_time),
                                                                                                                                      6), 5, 0, ':'), 3, 0, ':')
                       + ' and ' + STUFF(STUFF(RIGHT('000000' + CONVERT(VARCHAR(8), schedule.active_end_time), 6), 5, 0, ':'), 3, 0, ':')
                  WHEN 4
                  THEN 'Occurs every ' + CONVERT(VARCHAR, schedule.freq_subday_interval) + ' Minute(s) between ' + STUFF(STUFF(RIGHT('000000'
                                                                                                                                     + CONVERT(VARCHAR(8), schedule.active_start_time),
                                                                                                                                     6), 5, 0, ':'), 3, 0, ':')
                       + ' and ' + STUFF(STUFF(RIGHT('000000' + CONVERT(VARCHAR(8), schedule.active_end_time), 6), 5, 0, ':'), 3, 0, ':')
                  WHEN 8
                  THEN 'Occurs every ' + CONVERT(VARCHAR, schedule.freq_subday_interval) + ' Hour(s) between ' + STUFF(STUFF(RIGHT('000000'
                                                                                                                                   + CONVERT(VARCHAR(8), schedule.active_start_time),
                                                                                                                                   6), 5, 0, ':'), 3, 0, ':')
                       + ' and ' + STUFF(STUFF(RIGHT('000000' + CONVERT(VARCHAR(8), schedule.active_end_time), 6), 5, 0, ':'), 3, 0, ':')
                  ELSE ''
                END AS Frequency, CONVERT(DECIMAL(10, 2), jobhistory.AverageDurationInSeconds) AverageDurationSeconds,
                CONVERT(VARCHAR, DATEADD(s, ISNULL(CONVERT(DECIMAL(10, 2), jobhistory.AverageDurationInSeconds), 0), 0), 108) AS AverageDuration,
                CASE jobschedule.next_run_date
                  WHEN 0 THEN CONVERT(DATETIME, '1900/1/1')
                  ELSE CONVERT(DATETIME, CONVERT(CHAR(8), jobschedule.next_run_date, 112) + ' ' + STUFF(STUFF(RIGHT('000000'
                                                                                                                    + CONVERT(VARCHAR(8), jobschedule.next_run_time),
                                                                                                                    6), 5, 0, ':'), 3, 0, ':'))
                END NextScheduledRunDate, lastrunjobhistory.LastRunDate, ISNULL(lastrunjobhistory.run_status_desc, 'Unknown') AS run_status_desc,
                ISNULL(lastrunjobhistory.RunTimeInSeconds, 0) AS RunTimeInSeconds,
                CONVERT(VARCHAR, DATEADD(s, ISNULL(lastrunjobhistory.RunTimeInSeconds, 0), 0), 108) AS RunTime, lastrunjobhistory.message, jobs.job_id
        FROM    msdb.dbo.sysjobs AS jobs
        LEFT JOIN msdb.dbo.sysjobschedules AS jobschedule ON jobs.job_id = jobschedule.job_id
        LEFT JOIN msdb.dbo.sysschedules AS schedule ON jobschedule.schedule_id = schedule.schedule_id
        INNER JOIN msdb.dbo.syscategories categories ON jobs.category_id = categories.category_id
        LEFT OUTER JOIN ( SELECT    sysjobhist.job_id,
                                    ( SUM(( ( sysjobhist.run_duration / 10000 * 3600 ) + ( ( sysjobhist.run_duration % 10000 ) / 100 * 60 )
                                            + ( sysjobhist.run_duration % 10000 ) % 100 )) * 1.0 ) / COUNT(sysjobhist.job_id) AS AverageDurationInSeconds
                          FROM      msdb.dbo.sysjobhistory AS sysjobhist
                          WHERE     sysjobhist.step_id = 0
                          GROUP BY  sysjobhist.job_id
                        ) AS jobhistory ON jobhistory.job_id = jobs.job_id  -- to get the average duration
        LEFT OUTER JOIN ( SELECT    sysjobhist.job_id,
                                    CASE sysjobhist.run_date
                                      WHEN 0 THEN CONVERT(DATETIME, '1900/1/1')
                                      ELSE CONVERT(DATETIME, CONVERT(CHAR(8), sysjobhist.run_date, 112) + ' ' + STUFF(STUFF(RIGHT('000000'
                                                                                                                                  + CONVERT(VARCHAR(8), sysjobhist.run_time),
                                                                                                                                  6), 5, 0, ':'), 3, 0, ':'))
                                    END AS LastRunDate, sysjobhist.run_status, CASE sysjobhist.run_status
                                                                                 WHEN 0 THEN 'Failed'
                                                                                 WHEN 1 THEN 'Succeeded'
                                                                                 WHEN 2 THEN 'Retry'
                                                                                 WHEN 3 THEN 'Canceled'
                                                                                 WHEN 4 THEN 'In Progress'
                                                                                 ELSE 'Unknown'
                                                                               END AS run_status_desc, sysjobhist.retries_attempted, sysjobhist.step_id,
                                    sysjobhist.step_name, sysjobhist.run_duration AS RunTimeInSeconds, sysjobhist.message,
                                    ROW_NUMBER() OVER ( PARTITION BY sysjobhist.job_id ORDER BY CASE sysjobhist.run_date
                                                                                                  WHEN 0 THEN CONVERT(DATETIME, '1900/1/1')
                                                                                                  ELSE CONVERT(DATETIME, CONVERT(CHAR(8), sysjobhist.run_date, 112)
                                                                                                       + ' ' + STUFF(STUFF(RIGHT('000000'
                                                                                                                                 + CONVERT(VARCHAR(8), sysjobhist.run_time),
                                                                                                                                 6), 5, 0, ':'), 3, 0, ':'))
                                                                                                END DESC ) AS RowOrder
                          FROM      msdb.dbo.sysjobhistory AS sysjobhist
                          WHERE     sysjobhist.step_id = 0  --to get just the job outcome and not all steps
                        ) AS lastrunjobhistory ON lastrunjobhistory.job_id = jobs.job_id  -- to get the last run details
                                                  AND lastrunjobhistory.RowOrder = 1
	  --limit jobs returned to just jobs that act on the database this is running in
	  -- if one step in the job touches another Database do not should that job
	  WHERE NOT EXISTS (SELECT 1
					FROM msdb.dbo.sysjobsteps AS jobsteps
					WHERE jobs.job_id = jobsteps.job_id
					AND ISNULL(jobsteps.database_name,'') <> DB_NAME()
					)


    END TRY
    BEGIN CATCH
        DECLARE @Error VARCHAR(8000);
        SELECT  @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLSQLAgentJobStatus') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());		
        RAISERROR(@Error,		16,1 );

    END CATCH;