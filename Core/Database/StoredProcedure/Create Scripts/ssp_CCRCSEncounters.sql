/****** Object:  StoredProcedure [dbo].[ssp_CCRCSEncounters]    Script Date: 06/09/2015 03:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CCRCSEncounters]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[ssp_CCRCSEncounters] @ClientId BIGINT
	,@ServiceID INT = NULL
	,@DocumentVersionId INT = NULL
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Sept 23, 2014      
-- Description: Retrieves CCR Reson for Referral Data      
/*      
 Author			Modified Date			Reason      
   
      
*/
-- =============================================      
BEGIN
	BEGIN TRY
		DECLARE @DOS DATETIME

		CREATE TABLE #AppointmentData (
			AppointmentDate DATE
			,AppointmentTime TIME
			,ProcedureName VARCHAR(250)
			,LOCATION VARCHAR(250)
			,Provider VARCHAR(150)
			)

		CREATE TABLE #ServiceId (ServiceId INT)

		--Getting the Value for Behavioural Health (Serviceid is available)
		IF (@ServiceId IS NOT NULL)
		BEGIN
			SELECT TOP 1 @DOS = DateOfService
			FROM Services
			WHERE ServiceId = @ServiceId
				AND ISNULL(RecordDeleted, ''N'') = ''N''

			INSERT INTO #ServiceId
			SELECT ServiceId
			FROM Services
			WHERE Clientid = @ClientId
				AND DateOfService > @DOS
				--AND cast(DateOfService AS DATE) = cast(@DOS AS DATE)
				AND STATUS = 70
				AND ISNULL(RecordDeleted, ''N'') = ''N'' --Scheduled

			INSERT INTO #AppointmentData
			SELECT DISTINCT TOP 10 CONVERT(VARCHAR(10), A.starttime, 101) AS AppointmentDate
				,(
					SELECT Substring(CONVERT(VARCHAR(20), A.starttime, 9), 13, 5) + '' '' + Substring(CONVERT(VARCHAR(30), A.starttime, 9), 25, 2)
					) AS AppointmentTime
				,P.procedurecodename AS ProcedureName
				,L.locationname AS LOCATION
				,S.lastname + '', '' + S.firstname AS Provider
			FROM appointments A
			INNER JOIN #ServiceId SI ON SI.ServiceId = A.ServiceId
			INNER JOIN Services SS ON SS.ServiceId = SI.ServiceId
				AND ISNULL(SS.RecordDeleted, ''N'') = ''N''
			INNER JOIN staff S ON S.staffid = A.staffid
			INNER JOIN procedurecodes P ON P.procedurecodeid = SS.procedurecodeid
			INNER JOIN locations L ON L.locationid = SS.locationid
			WHERE ISNULL(A.RecordDeleted, ''N'') = ''N''
				AND A.starttime > @DOS -- A.STATUS = 8036  PCAPPOINTMENTSTATUS 	Scheduled

			INSERT INTO #AppointmentData
			SELECT DISTINCT TOP 10 CONVERT(VARCHAR(10), A.starttime, 101) AS AppointmentDate
				,(
					SELECT Substring(CONVERT(VARCHAR(20), A.starttime, 9), 13, 5) + '' '' + Substring(CONVERT(VARCHAR(30), A.starttime, 9), 25, 2)
					) AS AppointmentTime
				,GC.CodeName AS ProcedureName
				,L.locationname AS LOCATION
				,S.lastname + '', '' + S.firstname AS Provider
			FROM appointments A
			INNER JOIN staff S ON S.staffid = A.staffid
			INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = A.AppointmentType
			INNER JOIN locations L ON L.locationid = A.locationid
			WHERE A.ClientId = @ClientId
				AND ISNULL(A.RecordDeleted, ''N'') = ''N''
				AND A.STATUS = 8036 --PCAPPOINTMENTSTATUS 
				AND A.starttime > @DOS
				--AND cast(A.StartTime AS DATE) = cast(@DOS AS DATE)
		END

		----For PrimaryCare Appoinments,there is no serviceid associated.
		IF (
				@ServiceId IS NULL
				AND @DocumentVersionId IS NOT NULL
				)
		BEGIN
			SELECT TOP 1 @DOS = EffectiveDate
			FROM Documents
			WHERE InProgressDocumentVersionId = @DocumentVersionId
				AND ISNULL(RecordDeleted, ''N'') = ''N''

			INSERT INTO #AppointmentData
			SELECT DISTINCT TOP 10 CONVERT(VARCHAR(10), A.starttime, 101) AS AppointmentDate
				,(
					SELECT Substring(CONVERT(VARCHAR(20), A.starttime, 9), 13, 5) + '' '' + Substring(CONVERT(VARCHAR(30), A.starttime, 9), 25, 2)
					) AS AppointmentTime
				,GC.CodeName AS ProcedureName
				,L.locationname AS LOCATION
				,S.lastname + '', '' + S.firstname AS Provider
			FROM appointments A
			INNER JOIN staff S ON S.staffid = A.staffid
			INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = A.AppointmentType
			INNER JOIN locations L ON L.locationid = A.locationid
			WHERE A.ClientId = @ClientId
				AND ISNULL(A.RecordDeleted, ''N'') = ''N''
				AND A.STATUS = 8036 -- A.STATUS = 8036  PCAPPOINTMENTSTATUS 
				AND A.starttime > @DOS --and cast(A.StartTime as date)= cast(@DOS as Date)

			INSERT INTO #ServiceId
			SELECT ServiceId
			FROM Services
			WHERE clientid = @ClientId
				AND DateOfService > @DOS
				--AND cast(DateOfService AS DATE) = cast(@DOS AS DATE)
				AND STATUS = 70
				AND ISNULL(RecordDeleted, ''N'') = ''N'' --Scheduled

			INSERT INTO #AppointmentData
			SELECT DISTINCT TOP 10 CONVERT(VARCHAR(10), A.starttime, 101) AS AppointmentDate
				,(
					SELECT Substring(CONVERT(VARCHAR(20), A.starttime, 9), 13, 5) + '' '' + Substring(CONVERT(VARCHAR(30), A.starttime, 9), 25, 2)
					) AS AppointmentTime
				,P.procedurecodename AS ProcedureName
				,L.locationname AS LOCATION
				,S.lastname + '', '' + S.firstname AS Provider
			FROM appointments A
			INNER JOIN #ServiceId SI ON SI.ServiceId = A.ServiceId
			INNER JOIN Services SS ON SS.ServiceId = SI.ServiceId
				AND ISNULL(SS.RecordDeleted, ''N'') = ''N''
			INNER JOIN staff S ON S.staffid = A.staffid
			INNER JOIN procedurecodes P ON P.ProcedureCodeId = SS.ProcedureCodeId
			INNER JOIN locations L ON L.LocationId = SS.LocationId
			WHERE ISNULL(A.RecordDeleted, ''N'') = ''N''
				AND A.starttime > @DOS --and A.STATUS = 8036  -- PCAPPOINTMENTSTATUS 	Scheduled	
		END
		
		IF (
				@ServiceId IS NULL
				AND @DocumentVersionId IS NULL AND @ClientId IS NOT NULL
				)
		BEGIN
			SET @DOS = GETDATE()
			
			INSERT INTO #AppointmentData
			SELECT DISTINCT TOP 10 CONVERT(VARCHAR(10), A.starttime, 101) AS AppointmentDate
				,(
					SELECT Substring(CONVERT(VARCHAR(20), A.starttime, 9), 13, 5) + '' '' + Substring(CONVERT(VARCHAR(30), A.starttime, 9), 25, 2)
					) AS AppointmentTime
				,GC.CodeName AS ProcedureName
				,L.locationname AS LOCATION
				,S.lastname + '', '' + S.firstname AS Provider
			FROM appointments A
			INNER JOIN staff S ON S.staffid = A.staffid
			INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = A.AppointmentType
			INNER JOIN locations L ON L.locationid = A.locationid
			WHERE A.ClientId = @ClientId
				AND ISNULL(A.RecordDeleted, ''N'') = ''N''
				AND A.STATUS = 8036 -- A.STATUS = 8036  PCAPPOINTMENTSTATUS 
				AND A.starttime > @DOS --and cast(A.StartTime as date)= cast(@DOS as Date)

			INSERT INTO #ServiceId
			SELECT ServiceId
			FROM Services
			WHERE clientid = @ClientId
				AND DateOfService > @DOS
				--AND cast(DateOfService AS DATE) = cast(@DOS AS DATE)
				AND STATUS = 70
				AND ISNULL(RecordDeleted, ''N'') = ''N'' --Scheduled

			INSERT INTO #AppointmentData
			SELECT DISTINCT TOP 10 CONVERT(VARCHAR(10), A.starttime, 101) AS AppointmentDate
				,(
					SELECT Substring(CONVERT(VARCHAR(20), A.starttime, 9), 13, 5) + '' '' + Substring(CONVERT(VARCHAR(30), A.starttime, 9), 25, 2)
					) AS AppointmentTime
				,P.procedurecodename AS ProcedureName
				,L.locationname AS LOCATION
				,S.lastname + '', '' + S.firstname AS Provider
			FROM appointments A
			INNER JOIN #ServiceId SI ON SI.ServiceId = A.ServiceId
			INNER JOIN Services SS ON SS.ServiceId = SI.ServiceId
				AND ISNULL(SS.RecordDeleted, ''N'') = ''N''
			INNER JOIN staff S ON S.staffid = A.staffid
			INNER JOIN procedurecodes P ON P.ProcedureCodeId = SS.ProcedureCodeId
			INNER JOIN locations L ON L.LocationId = SS.LocationId
			WHERE ISNULL(A.RecordDeleted, ''N'') = ''N''
				AND A.starttime > @DOS --and A.STATUS = 8036  -- PCAPPOINTMENTSTATUS 	Scheduled	
		END

		SELECT TOP 10 A.ProcedureName
			,CONVERT(VARCHAR(10), A.AppointmentDate, 101) AS AppointmentDate
			,CONVERT(VARCHAR(15), CAST(A.AppointmentTime AS TIME), 100) AS AppointmentTime
			,LOCATION
			,Provider
		FROM #AppointmentData A
		ORDER BY A.AppointmentDate
			,A.AppointmentTime
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + ''*****'' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + ''*****'' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), ''ssp_CCRCSEncounters'') + ''*****'' + CONVERT(VARCHAR, ERROR_LINE()) + ''*****'' + CONVERT(VARCHAR, ERROR_SEVERITY()) + ''*****'' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				);
	END CATCH
END

' 
END
GO
