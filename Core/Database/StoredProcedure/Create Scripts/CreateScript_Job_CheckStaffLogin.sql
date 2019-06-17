DECLARE @JobDescription NVARCHAR(MAX);
DECLARE @JobCategory NVARCHAR(MAX);
DECLARE @JobOwner NVARCHAR(MAX);
DECLARE @DatabaseName NVARCHAR(MAX) = DB_NAME();
DECLARE @JobName01 NVARCHAR(MAX);

DECLARE @JobCommand01 NVARCHAR(MAX);

SET @JobDescription = 'Manages Staff Logout time based on last request datetime';
SET @JobCategory = '[Uncategorized (Local)]';
SET @JobOwner = SUSER_SNAME(0x01);

SET @JobName01 = DB_NAME() + ' - Check Staff Login';
SET @JobCommand01 = 'exec ssp_SCCheckStaffLoginActive;';
   
IF NOT EXISTS ( SELECT  *
                FROM    msdb.dbo.sysjobs
                WHERE   [name] = @JobName01 )
    BEGIN
        EXECUTE msdb.dbo.sp_add_job @job_name = @JobName01, @description = @JobDescription, @category_name = @JobCategory, @owner_login_name = @JobOwner;
        EXECUTE msdb.dbo.sp_add_jobstep @job_name = @JobName01, @step_name = @JobName01, @subsystem = 'TSQL', @command = @JobCommand01,
            @database_name = @DatabaseName;
        EXECUTE msdb.dbo.sp_add_jobschedule @job_name = @JobName01, @name = N'Every Minute', @enabled = 1, @freq_type = 4, @freq_interval = 1,
            @freq_subday_type = 4, @freq_subday_interval = 1, @freq_relative_interval = 0, @freq_recurrence_factor = 0, @active_start_date = 20180306,
            @active_end_date = 99991231, @active_start_time = 0, @active_end_time = 235959;
        EXECUTE msdb.dbo.sp_add_jobserver @job_name = @JobName01;
    END;
