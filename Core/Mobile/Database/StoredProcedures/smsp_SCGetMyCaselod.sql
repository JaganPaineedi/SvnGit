/****** Object:  StoredProcedure [dbo].[smsp_SCGetMyCaselod]    Script Date: 10/29/2014 15:03:31 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[smsp_SCGetMyCaselod]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[smsp_SCGetMyCaselod]
GO

/****** Object:  StoredProcedure [dbo].[smsp_SCGetMyCaselod]    Script Date: 10/29/2014 15:03:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[smsp_SCGetMyCaselod] @StaffId INT
	,@JsonResult VARCHAR(max) OUTPUT
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Sept 23, 2014      
-- Description: Retrieves CCR Reson for Referral Data      
/*      
 Author			Modified Date			Reason      
Declare @JsonResult VARCHAR(MAX)
EXEC [smsp_SCGetMyCaselod] 550, @JsonResult OUTPUT
SELECT @JsonResult

1/18/2017	Pradeep		      Code cleanup. 
10/29/2018  Vishnu Narayanan  Passing StaffId as a Parametetr in smsf_GetDocuments function     
*/
-- =============================================      
BEGIN
	BEGIN TRY
		DECLARE @LoggedInStaffId INT = @StaffId
		DECLARE @PageNumber INT = 0
		DECLARE @PageSize INT = 100
		DECLARE @PrimaryProgramId INT
		DECLARE @Today DATETIME
		DECLARE @DetermineCaseloadBy INT
		DECLARE @PrimaryClinician VARCHAR(250)

		--drop table #ResultSet
		--drop table #FinalResultSet
		CREATE TABLE #ResultSet (
			ClientId INT
			,ClientName VARCHAR(100)
			,DateofBirth DATETIME
			,Gender VARCHAR(10)
			,LastName VARCHAR(100)
			,PhoneNumber VARCHAR(80)
			,PhoneTypeText VARCHAR(250)
			,[Address] VARCHAR(100)
			,AddressTypeText VARCHAR(250)
			,PrimaryProgramId INT
			,PrimaryProgramName VARCHAR(250)
			,PrimaryClinicianName VARCHAR(250)
			,PrimaryClinicianId INT
			,GeographicLocation VARCHAR(50)
			,Diagnosis VARCHAR(MAX)
			)

		SET @Today = CONVERT(CHAR(10), getdate(), 101)

		SELECT @PrimaryProgramId = s.PrimaryProgramId
			,@DetermineCaseloadBy = s.DetermineCaseLoadBy
			,@PrimaryClinician = S.FirstName + ' ' + S.LastName
		FROM Staff s
		WHERE s.Staffid = @StaffId

		--    
		INSERT INTO #ResultSet (
			ClientId
			,ClientName
			,Gender
			,DateofBirth
			,GeographicLocation
			,PrimaryClinicianName
			)
		SELECT DISTINCT c.ClientId
			,c.LastName + ', ' + c.FirstName
			,CASE c.Sex
				WHEN 'M'
					THEN 'Male'
				WHEN 'F'
					THEN 'Female'
				ELSE 'Unknown'
				END
			,c.DOB
			,c.GeographicLocation
			,@PrimaryClinician
		FROM Clients c
		INNER JOIN StaffClients sc ON sc.StaffId = @LoggedInStaffId
			AND sc.ClientId = c.ClientId
		INNER JOIN (
			SELECT c.ClientId
				,'Yes' AS PrimaryClient
			FROM Clients c
			WHERE c.PrimaryClinicianId = @StaffId
				AND @DetermineCaseloadBy = 8271
			
			UNION
			
			SELECT c.ClientId
				,'Yes' AS PrimaryClient
			FROM Clients c
			WHERE @DetermineCaseloadBy = 8272 --Primary Program   
				AND EXISTS (
					SELECT 1
					FROM ClientPrograms cp
					WHERE cp.ClientId = c.ClientId
						AND cp.ProgramId = @PrimaryProgramId
						AND cp.STATUS <> 5
						AND ISNULL(cp.RecordDeleted, 'N') = 'N'
					)
			
			UNION
			
			SELECT c.ClientId
				,'Yes' AS PrimaryClient
			FROM Clients c
			WHERE @DetermineCaseloadBy = 8273 --Assigned Programs   
				AND EXISTS (
					SELECT *
					FROM ClientPrograms cp
					INNER JOIN StaffPrograms sp ON sp.ProgramId = cp.ProgramId
						AND sp.StaffId = @StaffId
						AND ISNULL(sp.RecordDeleted, 'N') = 'N'
					WHERE cp.ClientId = c.ClientId
						AND cp.STATUS <> 5
						AND ISNULL(cp.RecordDeleted, 'N') = 'N'
					)
			
			UNION
			
			SELECT c.ClientId
				,'No' AS PrimaryClient
			FROM Clients c
			WHERE EXISTS (
					SELECT 1
					FROM Services s
					WHERE s.ClientId = c.ClientId
						AND s.ClinicianId = @StaffId
						AND (
							(
								s.STATUS = 70
								AND DATEDIFF(day, s.DateOfService, @today) <= 0
								)
							OR (
								s.DateOfService >= DATEADD(mm, - 3, @today)
								AND s.STATUS IN (
									71
									,75
									)
								)
							)
						AND s.STATUS NOT IN (
							72
							,73
							)
						AND ISNULL(s.RecordDeleted, 'N') = 'N'
						AND ISNULL(c.RecordDeleted, 'N') = 'N'
					)
				AND (
					(
						@DetermineCaseloadBy = 8271
						AND (
							c.PrimaryClinicianId <> @StaffId
							OR c.PrimaryClinicianId IS NULL
							)
						)
					OR (
						@DetermineCaseloadBy = 8272
						AND NOT EXISTS (
							SELECT *
							FROM ClientPrograms cp
							WHERE cp.ClientId = c.ClientId
								AND cp.ProgramId = @PrimaryProgramId
								AND cp.STATUS <> 5
								AND ISNULL(cp.RecordDeleted, 'N') = 'N'
							)
						)
					OR (
						@DetermineCaseloadBy = 8273
						AND NOT EXISTS (
							SELECT *
							FROM ClientPrograms cp
							INNER JOIN StaffPrograms sp ON sp.ProgramId = cp.ProgramId
								AND sp.StaffId = @StaffId
								AND ISNULL(sp.RecordDeleted, 'N') = 'N'
							WHERE cp.ClientId = c.ClientId
								AND cp.STATUS <> 5
								AND ISNULL(cp.RecordDeleted, 'N') = 'N'
							)
						)
					)
			) cl ON cl.ClientId = c.ClientId
		LEFT JOIN (
			SELECT DISTINCT CE1.ClientEpisodeId
				,CE1.ClientId
				,CE1.EpisodeNumber
				,CE1.STATUS
			FROM ClientEpisodes CE1
			INNER JOIN ClientEpisodes CE2 ON CE2.ClientID = CE1.ClientID
				AND (
					CE2.STATUS > CE1.STATUS
					OR (
						SELECT COUNT(Clientid)
						FROM ClientEpisodes
						WHERE ClientId = CE1.Clientid
						) = 1
					)
				AND ISNULL(CE2.RecordDeleted, 'N') = 'N'
				AND ISNULL(CE1.RecordDeleted, 'N') = 'N'
			) CE ON CE.ClientId = c.ClientId
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = CE.STATUS
		LEFT JOIN (
			SELECT Clientid
				,NoteType
			FROM ClientNotes
			WHERE ISNULL(RecordDeleted, 'N') = 'N'
			) CN ON CN.ClientId = C.ClientId
		LEFT JOIN ClientPrograms CPE ON CPE.ClientId = C.ClientId
			AND CPE.STATUS = 4
			AND (
				ISNULL(CPE.EnrolledDate, '1 January 1900') >= GETDATE()
				AND ISNULL(CPE.DischargedDate, '1 January 2100') <= GETDATE()
				)
		WHERE c.Active = 'Y'
			AND ISNULL(c.RecordDeleted, 'N') = 'N'
			AND ISNULL(CPE.RecordDeleted, 'N') = 'N'
		ORDER BY c.ClientId

		-- Get home phone         
		UPDATE r
		SET PhoneNumber = p.PhoneNumber
			,PhoneTypeText = gc.CodeName
		FROM #ResultSet r
		INNER JOIN ClientPhones p ON p.ClientId = r.ClientId
		LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = p.PhoneType
		WHERE p.PhoneType = 30
			AND ISNULL(p.RecordDeleted, 'N') = 'N'

		-- Get home phone         
		UPDATE r
		SET [Address] = a.Display
			,AddressTypeText = gc.CodeName
		FROM #ResultSet r
		INNER JOIN ClientAddresses a ON a.ClientId = r.ClientId
		LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = a.AddressType
		WHERE a.AddressType = 90
			AND ISNULL(a.RecordDeleted, 'N') = 'N'

		-- Get home phone         
		UPDATE r
		SET PrimaryProgramName = p.ProgramName
			,PrimaryProgramId = p.ProgramId
		FROM #ResultSet r
		INNER JOIN ClientPrograms c ON c.ClientId = r.ClientId
		INNER JOIN Programs p ON p.ProgramId = c.ProgramId
		WHERE c.PrimaryAssignment = 'Y'
			AND ISNULL(c.RecordDeleted, 'N') = 'N';

		SELECT @JsonResult = dbo.smsf_FlattenedJSON((
					SELECT clientId
						,clientName
						,gender
						,dateofBirth
						,phoneNumber
						,phoneTypeText
						,address
						,addressTypeText
						,primaryProgramId
						,primaryProgramName
						,primaryClinicianName
						,geographicLocation
						,dbo.smsf_IntializeServiceDiagnosis(clientId, NULL, NULL) AS diagnosis
						,dbo.smsf_GetUpcomingAppointments(clientId) AS appointments
						,dbo.smsf_GetCurrentMedications(clientId) AS currentmedications
						,dbo.smsf_GetCurrentGoals(clientId) AS currentGoals
						,dbo.smsf_GetCurrentObjectives(clientId) AS currentObjectives
						,dbo.smsf_GetDocuments(clientId,@StaffId) As currentDocuments
					FROM #ResultSet 
					FOR XML path
						,root
					))
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'smsp_SCGetMyCaselod') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


