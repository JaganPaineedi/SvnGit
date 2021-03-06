IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClinicalSummaryAppointments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLClinicalSummaryAppointments]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLClinicalSummaryAppointments] (
	@ServiceId INT = NULL
	,@ClientId INT
	,@DocumentVersionId INT = NULL
	)
AS
BEGIN
/****************************************************************************** 
**  File: ssp_RDLClinicalSummaryAppointments.sql 
**  Name: ssp_RDLClinicalSummaryAppointments 
**  Desc: 
** 
**  Return values:  
** 
**  Called by:  
** 
**  Parameters: 
**  Input   Output 
**  ServiceId      ----------- 
** 
**  Created By: Veena S Mani 
**  Date:  Feb 24 2014 
******************************************************************************* 
**  Change History 
******************************************************************************* 
**  Date:  Author:    Description: 
**  --------  --------    ------------------------------------------- 
**  23/05/2014   Gautham       Created
**  30/05/2014   Veena         modified status and Date check
**  10/07/2014   Veena         added distinct to avoid duplicates
**	03/09/2014	 Revathi	   what:Commentted checking DateOfService and Effective date equal to service created Date
							   why:task#36 MeaningfulUSe
 **  03/09/2015  Revathi			what:  Select GetDate() removed
								why:	task#18 Post Certification          							   
*******************************************************************************/
BEGIN TRY
		DECLARE @DOS DATETIME
        DECLARE @AppointmentRange INT
        
     
	set @AppointmentRange=(SELECT value
				FROM systemconfigurationkeys
				WHERE [key] = 'CSUpComingAppointmentRangeInMonths')
				
				
				
				
        
		CREATE TABLE #AppointmentData (
			AppointmentDate DATE
			,AppointmentTime TIME
			,ProcedureName VARCHAR(250)
			,LOCATION VARCHAR(250)
			,Provider VARCHAR(150))

		CREATE TABLE #ServiceId (
			ServiceId INT)

		--Getting the Value for Behavioural Health (Serviceid is available)
		IF (@ServiceId IS NOT NULL)
		BEGIN
			SELECT TOP 1 @DOS = DateOfService
			FROM Services
			WHERE ServiceId = @ServiceId AND ISNULL(RecordDeleted, 'N') = 'N'

			INSERT INTO #ServiceId
			SELECT ServiceId
			FROM Services
			WHERE	Clientid = @ClientId AND 
			DateOfService > @DOS
				--AND cast(DateOfService AS DATE) = cast(@DOS AS DATE)
				AND STATUS = 70
				AND ISNULL(RecordDeleted, 'N') = 'N' --Scheduled

			INSERT INTO #AppointmentData
			SELECT DISTINCT --TOP 10 
			CONVERT(VARCHAR(10), A.starttime, 101) AS AppointmentDate
				,(
					SELECT Substring(CONVERT(VARCHAR(20), A.starttime, 9), 13, 5) + ' ' + Substring(CONVERT(VARCHAR(30), A.starttime, 9), 25, 2)
					) AS AppointmentTime
				,P.procedurecodename AS ProcedureName
				,L.locationname AS LOCATION
				,S.lastname + ', ' + S.firstname AS Provider
			FROM appointments A
			INNER JOIN #ServiceId SI ON SI.ServiceId = A.ServiceId
			INNER JOIN Services SS ON SS.ServiceId = SI.ServiceId
				AND ISNULL(SS.RecordDeleted, 'N') = 'N'
			INNER JOIN staff S ON S.staffid = A.staffid
			INNER JOIN procedurecodes P ON P.procedurecodeid = SS.procedurecodeid
			INNER JOIN locations L ON L.locationid = SS.locationid
			WHERE ISNULL(A.RecordDeleted, 'N') = 'N'
				AND A.starttime > @DOS
				AND A.starttime <=case when @AppointmentRange is not null then dateadd(month,@AppointmentRange,@DOS) else dateadd(month,6,@DOS) end
				 -- A.STATUS = 8036  PCAPPOINTMENTSTATUS 	Scheduled

			INSERT INTO #AppointmentData
			SELECT DISTINCT --TOP 10 
			CONVERT(VARCHAR(10), A.starttime, 101) AS AppointmentDate
				,(
					SELECT Substring(CONVERT(VARCHAR(20), A.starttime, 9), 13, 5) + ' ' + Substring(CONVERT(VARCHAR(30), A.starttime, 9), 25, 2)
					) AS AppointmentTime
				,GC.CodeName AS ProcedureName
				,L.locationname AS LOCATION
				,S.lastname + ', ' + S.firstname AS Provider
			FROM appointments A
			INNER JOIN staff S ON S.staffid = A.staffid
			INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = A.AppointmentType
			INNER JOIN locations L ON L.locationid = A.locationid
			WHERE A.ClientId = @ClientId
				AND ISNULL(A.RecordDeleted, 'N') = 'N'
				AND A.STATUS = 8036 --PCAPPOINTMENTSTATUS 
				AND A.starttime > @DOS
				AND A.starttime <=case when @AppointmentRange is not null then dateadd(month,@AppointmentRange,@DOS) else dateadd(month,6,@DOS) end
				--AND cast(A.StartTime AS DATE) = cast(@DOS AS DATE)
		END

		----For PrimaryCare Appoinments,there is no serviceid associated.
		IF (@ServiceId IS NULL	AND @DocumentVersionId IS NOT NULL)
		BEGIN
			SELECT TOP 1 @DOS = EffectiveDate
			FROM Documents
			WHERE InProgressDocumentVersionId = @DocumentVersionId AND ISNULL(RecordDeleted, 'N') = 'N'

			INSERT INTO #AppointmentData
			SELECT DISTINCT --TOP 10
			 CONVERT(VARCHAR(10), A.starttime, 101) AS AppointmentDate
				,(SELECT Substring(CONVERT(VARCHAR(20), A.starttime, 9), 13, 5) + ' ' + Substring(CONVERT(VARCHAR(30), A.starttime, 9), 25, 2)
					) AS AppointmentTime
				,GC.CodeName AS ProcedureName
				,L.locationname AS LOCATION
				,S.lastname + ', ' + S.firstname AS Provider
			FROM appointments A
			INNER JOIN staff S ON S.staffid = A.staffid
			INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = A.AppointmentType
			INNER JOIN locations L ON L.locationid = A.locationid
			WHERE A.ClientId = @ClientId
				AND ISNULL(A.RecordDeleted, 'N') = 'N'
				AND A.STATUS = 8036 -- A.STATUS = 8036  PCAPPOINTMENTSTATUS 
				AND A.starttime > @DOS --and cast(A.StartTime as date)= cast(@DOS as Date)
				AND A.starttime <=case when @AppointmentRange is not null then dateadd(month,@AppointmentRange,@DOS) else dateadd(month,6,@DOS) end
				
			INSERT INTO #ServiceId
			SELECT ServiceId
			FROM Services
			WHERE clientid = @ClientId
				AND DateOfService > @DOS
				--AND cast(DateOfService AS DATE) = cast(@DOS AS DATE)
				AND STATUS = 70
				AND ISNULL(RecordDeleted, 'N') = 'N' --Scheduled

			INSERT INTO #AppointmentData
			SELECT DISTINCT --TOP 10
			 CONVERT(VARCHAR(10), A.starttime, 101) AS AppointmentDate
				,(SELECT Substring(CONVERT(VARCHAR(20), A.starttime, 9), 13, 5) + ' ' + Substring(CONVERT(VARCHAR(30), A.starttime, 9), 25, 2)
					) AS AppointmentTime
				,P.procedurecodename AS ProcedureName
				,L.locationname AS LOCATION
				,S.lastname + ', ' + S.firstname AS Provider
			FROM appointments A
			INNER JOIN #ServiceId SI ON SI.ServiceId = A.ServiceId
			INNER JOIN Services SS ON SS.ServiceId = SI.ServiceId
				AND ISNULL(SS.RecordDeleted, 'N') = 'N'
			INNER JOIN staff S ON S.staffid = A.staffid
			INNER JOIN procedurecodes P ON P.ProcedureCodeId = SS.ProcedureCodeId
			INNER JOIN locations L ON L.LocationId = SS.LocationId
			WHERE ISNULL(A.RecordDeleted, 'N') = 'N'
				AND A.starttime > @DOS
				AND A.starttime <=case when @AppointmentRange is not null then dateadd(month,@AppointmentRange,@DOS) else dateadd(month,6,@DOS) end
				 --and A.STATUS = 8036  -- PCAPPOINTMENTSTATUS 	Scheduled	
		END

		SELECT  --TOP 10 
			A.ProcedureName
			,CONVERT(VARCHAR(10), A.AppointmentDate, 101) as AppointmentDate			
			,CONVERT(VARCHAR(15), CAST(A.AppointmentTime AS TIME), 100) as  AppointmentTime			
			,LOCATION
			,Provider
		FROM #AppointmentData A
		ORDER BY  A.AppointmentDate 
			,A.AppointmentTime
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + 
		CONVERT(VARCHAR(4000), Error_message()) + '*****' +
		 Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_RDLClinicalSummaryAppointments') 
		 + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' 
		 + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

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