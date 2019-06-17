DECLARE @CreateJobs nvarchar(max)
DECLARE @BackupDirectory nvarchar(max)
DECLARE @CleanupTime int
DECLARE @OutputFileDirectory nvarchar(max)
DECLARE @LogToTable nvarchar(max)
DECLARE @Version numeric(18,10)
DECLARE @Error int

SET @CleanupTime         = NULL         -- Time in hours, after which backup files are deleted. If no time is specified, then no backup files are deleted.
SET @OutputFileDirectory = NULL         -- Specify the output file directory. If no directory is specified, then the SQL Server error log directory is used.
SET @LogToTable          = 'Y'          -- Log commands to a table.

SET @Error = 0

SET @Version = CAST(LEFT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)),CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - 1) + '.' + REPLACE(RIGHT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)), LEN(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)))),'.','') AS numeric(18,10))

IF IS_SRVROLEMEMBER('sysadmin') = 0
BEGIN
  RAISERROR('You need to be a member of the SysAdmin server role to install the solution.',16,1)
  SET @Error = @@ERROR
END

IF OBJECT_ID('tempdb..#Config') IS NOT NULL DROP TABLE #Config

CREATE TABLE #Config ([Name] nvarchar(max),
                      [Value] nvarchar(max))

IF @CreateJobs = 'Y' AND @OutputFileDirectory IS NULL AND SERVERPROPERTY('EngineEdition') <> 4 AND @Version < 12
BEGIN
  IF @Version >= 11
  BEGIN
    SELECT @OutputFileDirectory = [path]
    FROM sys.dm_os_server_diagnostics_log_configurations
  END
  ELSE
  BEGIN
    SELECT @OutputFileDirectory = LEFT(CAST(SERVERPROPERTY('ErrorLogFileName') AS nvarchar(max)),LEN(CAST(SERVERPROPERTY('ErrorLogFileName') AS nvarchar(max))) - CHARINDEX('\',REVERSE(CAST(SERVERPROPERTY('ErrorLogFileName') AS nvarchar(max)))))
  END
END

IF RIGHT(@OutputFileDirectory,1) = '\' AND SERVERPROPERTY('EngineEdition') <> 4
BEGIN
  SET @OutputFileDirectory = LEFT(@OutputFileDirectory, LEN(@OutputFileDirectory) - 1)
END

INSERT INTO #Config ([Name], [Value])
VALUES('CreateJobs', @CreateJobs)

INSERT INTO #Config ([Name], [Value])
VALUES('BackupDirectory', @BackupDirectory)

INSERT INTO #Config ([Name], [Value])
VALUES('CleanupTime', @CleanupTime)

INSERT INTO #Config ([Name], [Value])
VALUES('OutputFileDirectory', @OutputFileDirectory)

INSERT INTO #Config ([Name], [Value])
VALUES('LogToTable', @LogToTable)

INSERT INTO #Config ([Name], [Value])
VALUES('DatabaseName', DB_NAME(DB_ID()))

INSERT INTO #Config ([Name], [Value])
VALUES('Error', CAST(@Error AS nvarchar))


   DECLARE @DatabaseName nvarchar(max)


  DECLARE @TokenServer nvarchar(max)
  DECLARE @TokenJobID nvarchar(max)
  DECLARE @TokenStepID nvarchar(max)
  DECLARE @TokenDate nvarchar(max)
  DECLARE @TokenTime nvarchar(max)
  DECLARE @TokenLogDirectory nvarchar(max)

  DECLARE @JobDescription nvarchar(max)
  DECLARE @JobCategory nvarchar(max)
  DECLARE @JobOwner nvarchar(max)

  DECLARE @JobName01 nvarchar(max)
  DECLARE @JobName02 nvarchar(max)
  DECLARE @JobName03 nvarchar(max)
  DECLARE @JobName04 nvarchar(max)
  DECLARE @JobName05 nvarchar(max)
  DECLARE @JobName06 nvarchar(max)
  DECLARE @JobName07 nvarchar(max)

  DECLARE @JobCommand01 nvarchar(max)
  DECLARE @JobCommand02 nvarchar(max)
  DECLARE @JobCommand03 nvarchar(max)
  DECLARE @JobCommand04 nvarchar(max)
  DECLARE @JobCommand05 nvarchar(max)
  DECLARE @JobCommand06 nvarchar(max)
  DECLARE @JobCommand07 nvarchar(max)

  DECLARE @OutputFile01 nvarchar(max)
  DECLARE @OutputFile02 nvarchar(max)
  DECLARE @OutputFile03 nvarchar(max)
  DECLARE @OutputFile04 nvarchar(max)
  DECLARE @OutputFile05 nvarchar(max)
  DECLARE @OutputFile06 nvarchar(max)
  DECLARE @OutputFile07 nvarchar(max)

  SET @Version = CAST(LEFT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)),CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - 1) + '.' + REPLACE(RIGHT(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)), LEN(CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max))) - CHARINDEX('.',CAST(SERVERPROPERTY('ProductVersion') AS nvarchar(max)))),'.','') AS numeric(18,10))

  IF @Version >= 9.002047
  BEGIN
    SET @TokenServer = '$' + '(ESCAPE_SQUOTE(SRVR))'
    SET @TokenJobID = '$' + '(ESCAPE_SQUOTE(JOBID))'
    SET @TokenStepID = '$' + '(ESCAPE_SQUOTE(STEPID))'
    SET @TokenDate = '$' + '(ESCAPE_SQUOTE(STRTDT))'
    SET @TokenTime = '$' + '(ESCAPE_SQUOTE(STRTTM))'
  END
  ELSE
  BEGIN
    SET @TokenServer = '$' + '(SRVR)'
    SET @TokenJobID = '$' + '(JOBID)'
    SET @TokenStepID = '$' + '(STEPID)'
    SET @TokenDate = '$' + '(STRTDT)'
    SET @TokenTime = '$' + '(STRTTM)'
  END

  IF @Version >= 12
  BEGIN
    SET @TokenLogDirectory = '$' + '(ESCAPE_SQUOTE(SQLLOGDIR))'
  END

  SELECT @BackupDirectory = Value
  FROM #Config
  WHERE [Name] = 'BackupDirectory'

  SELECT @CleanupTime = Value
  FROM #Config
  WHERE [Name] = 'CleanupTime'

  SELECT @OutputFileDirectory = Value
  FROM #Config
  WHERE [Name] = 'OutputFileDirectory'

  SELECT @LogToTable = Value
  FROM #Config
  WHERE [Name] = 'LogToTable'

  SELECT @DatabaseName = Value
  FROM #Config
  WHERE [Name] = 'DatabaseName'

  SET @JobDescription = 'Source: https://ola.hallengren.com'
  SET @JobCategory = 'Database Maintenance'
  SET @JobOwner = SUSER_SNAME(0x01)

  

  SET @JobName05 = 'DatabaseIntegrityCheck - SYSTEM_DATABASES'
  SET @JobCommand05 = 'use ' + DB_NAME() + ' exec ssp_DMIntegrityCheck @Databases = ''SYSTEM_DATABASES'''
  SET @OutputFile05 = COALESCE(@OutputFileDirectory,@TokenLogDirectory) + '\' + 'DatabaseIntegrityCheck_' + @TokenJobID + '_' + @TokenStepID + '_' + @TokenDate + '_' + @TokenTime + '.txt'
  IF LEN(@OutputFile05) > 200 SET @OutputFile05 = COALESCE(@OutputFileDirectory,@TokenLogDirectory) + '\' + @TokenJobID + '_' + @TokenStepID + '_' + @TokenDate + '_' + @TokenTime + '.txt'
  IF LEN(@OutputFile05) > 200 SET @OutputFile05 = NULL

  SET @JobName06 = 'DatabaseIntegrityCheck - USER_DATABASES'
  SET @JobCommand06 = 'use ' + DB_NAME() + ' exec ssp_DMIntegrityCheck @Databases = ''' + DB_NAME() + ''''
  SET @OutputFile06 = COALESCE(@OutputFileDirectory,@TokenLogDirectory) + '\' + 'DatabaseIntegrityCheck_' + @TokenJobID + '_' + @TokenStepID + '_' + @TokenDate + '_' + @TokenTime + '.txt'
  IF LEN(@OutputFile06) > 200 SET @OutputFile06 = COALESCE(@OutputFileDirectory,@TokenLogDirectory) + '\' + @TokenJobID + '_' + @TokenStepID + '_' + @TokenDate + '_' + @TokenTime + '.txt'
  IF LEN(@OutputFile06) > 200 SET @OutputFile06 = NULL

  SET @JobName07 = 'IndexOptimize - USER_DATABASES'
  SET @JobCommand07 = 'use ' + DB_NAME() + ' exec ssp_DMOptimizeIndexJob'
  SET @OutputFile07 = COALESCE(@OutputFileDirectory,@TokenLogDirectory) + '\' + 'IndexOptimize_' + @TokenJobID + '_' + @TokenStepID + '_' + @TokenDate + '_' + @TokenTime + '.txt'
  IF LEN(@OutputFile07) > 200 SET @OutputFile07 = COALESCE(@OutputFileDirectory,@TokenLogDirectory) + '\' + @TokenJobID + '_' + @TokenStepID + '_' + @TokenDate + '_' + @TokenTime + '.txt'
  IF LEN(@OutputFile07) > 200 SET @OutputFile07 = NULL
 

  IF EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = @JobName05)
  AND NOT EXISTS( SELECT * FROM msdb.dbo.sysjobs AS a
					JOIN msdb.dbo.sysjobsteps AS b ON b.job_id = a.job_id
					WHERE a.name = @JobName05
					AND b.step_name = @JobName05
					)
  AND NOT EXISTS( SELECT * FROM msdb.dbo.sysjobs AS a
					JOIN msdb.dbo.sysjobsteps AS b ON b.job_id = a.job_id
					WHERE a.name = @JobName05
					)
  BEGIN
    EXECUTE msdb.dbo.sp_add_jobstep @job_name = @JobName05, @step_name = @JobName05, @subsystem = 'TSQL', @command = @JobCommand05, @output_file_name = @OutputFile05
  END

  IF EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = @JobName06)
    AND NOT EXISTS( SELECT * FROM msdb.dbo.sysjobs AS a
					JOIN msdb.dbo.sysjobsteps AS b ON b.job_id = a.job_id
					WHERE a.name = @JobName06
					AND b.step_name = @JobName06
					)
  AND NOT EXISTS( SELECT * FROM msdb.dbo.sysjobs AS a
					JOIN msdb.dbo.sysjobsteps AS b ON b.job_id = a.job_id
					WHERE a.name = @JobName06
					)
  BEGIN
    EXECUTE msdb.dbo.sp_add_jobstep @job_name = @JobName06, @step_name = @JobName06, @subsystem = 'TSQL', @command = @JobCommand06, @output_file_name = @OutputFile06
  END

  IF EXISTS (SELECT * FROM msdb.dbo.sysjobs WHERE [name] = @JobName07)
    AND NOT EXISTS( SELECT * FROM msdb.dbo.sysjobs AS a
					JOIN msdb.dbo.sysjobsteps AS b ON b.job_id = a.job_id
					WHERE a.name = @JobName07
					AND b.step_name = @JobName07
					)
  AND NOT EXISTS( SELECT * FROM msdb.dbo.sysjobs AS a
					JOIN msdb.dbo.sysjobsteps AS b ON b.job_id = a.job_id
					WHERE a.name = @JobName07
					)
  BEGIN
    EXECUTE msdb.dbo.sp_add_jobstep @job_name = @JobName07, @step_name = @JobName07, @subsystem = 'TSQL', @command = @JobCommand07, @output_file_name = @OutputFile07
  END

