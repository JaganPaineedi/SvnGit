/****** Object:  StoredProcedure [dbo].[ssp_SCGetProgramEnrolledClients]    Script Date: 11/05/2015 11:31:08 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetProgramEnrolledClients]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetProgramEnrolledClients]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetProgramEnrolledClients]    Script Date: 11/05/2015 11:31:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetProgramEnrolledClients] @ProgramId INT
	,@StaffId INT
	,@ClientsExclude VARCHAR(MAX)
AS
/****************************************************************************/
/* Stored Procedure: ssp_SCGetProgramEnrolledClients                        */
/* Copyright: 2006 Streamline Healthcare Solutions                           */
/* Author: Akwinass                                                         */
/* Creation Date:  April 29,2015                                            */
/* Purpose: To Get Program Enrolled Clients                                 */
/* Input Parameters:@ProgramId, @StaffId, @ClientsExclude                   */
/* Output Parameters:None                                                   */
/* Return:                                                                  */
/* Calls:                                                                   */
/* Called From:                                                             */
/* Data Modifications:                                                      */
/*                                                                          */
/*-------------Modification History--------------------------               */
/*-------Date-----------Author------------Purpose---------------------------*/
/*       29-APRIL-2015  Akwinass          Created(Task #829 in Woods - Customizations).*/
/* 02-Jul-2015 Deej	 commented the condition of "UsesAttendanceFunctions" and 
    AttendanceClientsEnrolledPrograms for Philhaven - Customization Issues Tracking #1327*/
/*       03-JULY-2015  Akwinass           Client Duplicating Bug is Fixed (Task #829 in Woods - Customizations).*/
/*       05-NOV-2015   Shankha            Sort Order of the result based on ClientName.*/
/****************************************************************************/
BEGIN
	BEGIN TRY
		SELECT c.ClientId
			,c.LastName + ', ' + c.FirstName AS ClientName
		FROM Clients AS c
		INNER JOIN ClientPrograms AS cp ON cp.ClientId = c.ClientId
			AND ISNULL(cp.RecordDeleted, 'N') = 'N'
			AND ISNULL(c.RecordDeleted, 'N') = 'N'
			AND ISNULL(c.Active, 'N') = 'Y'
		INNER JOIN Programs AS p ON p.ProgramId = cp.ProgramId
			AND ISNULL(p.RecordDeleted, 'N') = 'N'
			AND ISNULL(p.Active, 'N') = 'Y'
		--INNER JOIN Groups G ON G.ProgramId = p.ProgramId AND ISNULL(G.RecordDeleted, 'N') = 'N' AND ISNULL(G.Active,'N') = 'Y'
		--INNER JOIN StaffClients sc ON sc.StaffId = @StaffId AND sc.ClientId = c.ClientId 
		INNER JOIN GlobalCodes AS gc ON gc.GlobalCodeId = cp.[Status]
			AND ISNULL(gc.RecordDeleted, 'N') = 'N'
			AND gc.Active = 'Y'
		LEFT OUTER JOIN Staff AS s ON s.StaffId = c.PrimaryClinicianId
		LEFT JOIN Staff S2 ON cp.AssignedStaffId = S2.StaffId
		WHERE gc.CodeName = 'Enrolled'
			AND ISNULL(p.ProgramId, 0) = @ProgramId
			AND NOT EXISTS (
				SELECT 1
				FROM dbo.SplitString(@ClientsExclude, ';')
				WHERE Token = c.ClientId
				)
			AND EXISTS (
				SELECT 1
				FROM StaffClients sc
				WHERE sc.ClientId = c.ClientId
					AND sc.StaffId = @StaffId
				)
			AND EXISTS (
				SELECT 1
				FROM Groups G
				WHERE G.ProgramId = p.ProgramId
					AND ISNULL(G.RecordDeleted, 'N') = 'N'
					AND ISNULL(G.Active, 'N') = 'Y'
				)
		ORDER BY ClientName
	END TRY

	BEGIN CATCH
		IF (@@error != 0)
		BEGIN
			RAISERROR 20006 'ssp_SCGetProgramEnrolledClients: An Error Occured'

			RETURN
		END
	END CATCH
END
GO


