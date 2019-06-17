IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_RDLSQLAgentJobStepStatus')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE ssp_RDLSQLAgentJobStepStatus;
    END;
GO

CREATE PROCEDURE ssp_RDLSQLAgentJobStepStatus
@Job_ID VARCHAR(MAX),
@Job_Start_DateTime SMALLDATETIME
AS
/******************************************************************************
**		File: 
**		Name: ssp_SCRDLSQLAgentJobStepStatus
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

     		SELECT         
			Steps.step_id, 
			Steps.step_name, 
			ISNULL(run_status,-1) AS run_status, 
			ISNULL(run_status_description,'Unknown') AS run_status_description, 
			Step_Start_DateTime,
			Step_Duration
		FROM            
			(SELECT        
				Jobstep.step_name, 
				Jobstep.step_id
			FROM	msdb.dbo.sysjobsteps AS Jobstep
			WHERE job_id = @Job_ID
				  --limit jobs returned to just jobs that act on the database this is running in
	              -- if one step in the job touches another Database do not should that job
			AND  NOT EXISTS (SELECT 1
					FROM msdb.dbo.sysjobsteps AS jobsteps
					WHERE Jobstep.job_id = jobsteps.job_id
					AND ISNULL(jobsteps.database_name,'') <> DB_NAME()
					)
			AND Jobstep.subsystem = 'TSQL'
			) AS Steps LEFT JOIN
			
			(SELECT
				 JobHistory.step_id, 
				 CASE --convert to the uniform status numbers we are using
					WHEN JobHistory.run_status = 0 THEN 0
					WHEN JobHistory.run_status = 1 THEN 1
					WHEN JobHistory.run_status = 2 THEN 2
					WHEN JobHistory.run_status = 4 THEN 2
					WHEN JobHistory.run_status = 3 THEN 3
					ELSE -1 
				 END AS run_status, 
				 CASE 
					WHEN JobHistory.run_status = 0 THEN 'Failed' 
					WHEN JobHistory.run_status = 1 THEN 'Success' 
					WHEN JobHistory.run_status = 2 THEN 'In Progress'
					WHEN JobHistory.run_status = 4 THEN 'In Progress' 
					WHEN JobHistory.run_status = 3 THEN 'Canceled' 
					ELSE 'Unknown' 
				 END AS run_status_description,
				 CAST(STR(run_date) AS DATETIME) + CAST(STUFF(STUFF(REPLACE(STR(run_time, 6, 0), ' ', '0'), 3, 0, ':'), 6, 0, ':') AS TIME) as Step_Start_DateTime,
				 
				 CAST(CAST(STUFF(STUFF(REPLACE(STR(JobHistory.run_duration % 240000, 6, 0), ' ', '0'), 3, 0, ':'), 6, 0, ':') AS DATETIME) AS TIME) AS Step_Duration
			FROM msdb..sysjobhistory as JobHistory WITH (NOLOCK) 
			WHERE job_id = @Job_ID and CAST(STR(run_date) AS DATETIME) + CAST(STUFF(STUFF(REPLACE(STR(run_time, 6, 0), ' ', '0'), 3, 0, ':'), 6, 0, ':') AS TIME) >= @Job_Start_DateTime
			) AS StepStatus ON Steps.step_id = StepStatus.step_id
				  
		ORDER BY Steps.step_id


    END TRY
    BEGIN CATCH
        DECLARE @Error VARCHAR(8000);
        SELECT  @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLSQLAgentJobStepStatus') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());		
        RAISERROR(@Error,		16,1 );

    END CATCH;