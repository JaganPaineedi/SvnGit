IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetAttendanceServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetAttendanceServices]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC ssp_SCGetAttendanceServices 0,0,1,'07/08/2015',1,0,'List',0
CREATE PROCEDURE [dbo].[ssp_SCGetAttendanceServices] 

@ProgramId INT,
@StaffId INT,
@GroupId INT,
@Date DATETIME = NULL,
@PageNumber INT = 1,
@UnsavedChangeId INT,
@Mode VARCHAR(10) = NULL,
@IsJustSaved INT = NULL

AS
/****************************************************************************/
/* Stored Procedure: ssp_SCGetAttendanceServices 0,0,29,'06/01/2015',1,0,'List' */
/* Copyright: 2006 Streamlin Healthcare Solutions                           */
/* Author: Avi Goyal                                                        */
/* Creation Date:  18 May 2015												*/
/* Purpose: To Get Attendance Services Screen Filter                        */
/* Input Parameters:@Date,@ProgramId,@GroupId,@StaffId,@ProcedureId,@PageNumber,@UnsavedChange,@Mode*/
/* Output Parameters:None                                                   */
/* Return:                                                                  */
/* Calls:                                                                   */
/* Called From:                                                             */
/* Data Modifications:                                                      */
/*                                                                          */
/*-------------Modification History--------------------------               */
/*-------Date-----------Author------------Purpose---------------------------*/
/*       18 May 2015	Avi Goyal		  Created(Task #829 in Woods - Customizations).*/
/*       01 Feb 2016	Akwinass		  Selecting "DisplayAs" instead of "ProcedureCodeName" for ProcedureCodes(Task #829.03 in Woods - Customizations).*/
/*       31 Mar 2016	Avi Goyal		  Corrected Page Size Issue (Task #38 in Woods - Support Go Live).*/
/*       28-JUNE-2016  Dhanil	         What:changed Groups.ProcedureCodeId to Groups.AttendanceDefaultProcedureCodeId and G.ClinicianId to use S.ClinicianId when genrate service through attendence        
							             Why:task #120 Woods - Support Go Live*/
/*       11-Aug-2016    Vamsi	         What:Added Condition to show Completed Services        
							             Why:task #201 Woods - Support Go Live*/
/*       19 Aug 2016    Vamsi            What: Modified logic to display one row for group if two staff are there.
                                         Why : task #195 Woods - Support Go Live*/ 		
/*		27 April 2017	Deej			 Added code to include GroupId as well in the select. Woods SGL #544*/
/*		09 May 2017		Manjunath K		Added Code to selected ClientSpecific procedure codes. For 	Woods SGL #444*/							             							             	
/*		10 July 2017	Manjunath K		Added Code to selecte ClientSpecific procedure codes. For 	Woods SGL #444.2*/	
/*		10 Nov	2017	Wasif Butt		Added record delete check for GroupClientDefaultProcedureCodes w.r.f: Woods SGL #789
        05/06/2018      Hemant          MandatoryValues/Initialization added for "GetData" mode to fix the error
                                        "Record Not found". For Boundless Build Cycle Tasks #34   
*/
/****************************************************************************/
BEGIN
	BEGIN TRY		
		--DECLARE @UserCode VARCHAR(30)
		--SELECT TOP 1 @UserCode = UserCode FROM Staff WHERE ISNULL(RecordDeleted,'N') = 'N' AND ISNULL(Active,'N') = 'Y'
	
		DECLARE @PageSize INT = 20
		IF @Mode = 'List'
		BEGIN
			IF OBJECT_ID('tempdb..#AttendanceServicesResultSet') IS NOT NULL
				DROP TABLE #AttendanceServicesResultSet
			
			CREATE TABLE #AttendanceServicesResultSet (
				AttendanceServiceId INT
				,ClientId INT
				,ClientName VARCHAR(500)
				,StaffId INT
				,ProcedureCodeId INT
				,DateOfService DATETIME
				,EndDateOfService DATETIME
				,Duration DECIMAL(18,2)
				,LocationId INT
				,ProgramId INT
				,Comment VARCHAR(MAX)
				,StaffName VARCHAR(500)
				,ProcedureCodeName VARCHAR(500)
				,LocationCode VARCHAR(500)
				,ToSave CHAR(1)
				,RecordDeleted CHAR(1)
				,GroupServiceId INT
				,RowNum INT
				)
				
					
				
			IF ISNULL(@UnsavedChangeId,0)<=0
			BEGIN
				
				INSERT INTO #AttendanceServicesResultSet
		
				SELECT 
					--ISNULL(AtS.AttendanceServiceId,-(CAST((ROW_NUMBER() OVER (ORDER BY C.ClientId)) AS INT))) AS AttendanceServiceId, 
					0 AS AttendanceServiceId, 
					C.ClientId,
					C.LastName + ', ' + C.FirstName as ClientName,
					--28-JUNE-2016  Dhanil
					ISNULL(S.ClinicianId,0) AS StaffId,
					ISNULL(CDP.ProcedureCodeId,ISNULL(G.AttendanceDefaultProcedureCodeId,0)) AS ProcedureCodeId,
					--CAST(NULL AS DATETIME) AS DateOfService,
					--CAST(NULL AS DATETIME) AS EndDateOfService,
					--dbo.ssf_GetAttendanceServicesTimeIn(S.GroupServiceId,S.ClientId) AS DateOfService,
					--dbo.ssf_GetAttendanceServicesTimeOut(S.GroupServiceId,S.ClientId) AS EndDateOfService,
					dbo.ssf_GetAttendanceServicesTimeIn(S.GroupServiceId,S.ClientId) AS DateOfService,
					dbo.ssf_GetAttendanceServicesTimeOut(S.GroupServiceId,S.ClientId) AS EndDateOfService,
					CAST(dbo.ssf_GetAttendanceServicesDuration(S.GroupServiceId,S.ClientId) AS decimal(18,2)) AS Duration,
					--CAST(dbo.ssf_GetAttendanceServicesDuration(S.GroupServiceId,S.ClientId) AS decimal(18,2)) AS Duration,
					ISNULL(G.LocationId,0) AS LocationId,
					ISNULL(G.ProgramId,0) AS ProgramId,
					'' AS Comment,
					--ISNULL(St.Initial,'') AS StaffName,
					ISNULL
					(
						(CASE   
							WHEN rtrim(ltrim(St.DisplayAs)) IS NULL  
							THEN rtrim(ltrim(St.LastName)) + ', ' + rtrim(St.FirstName)  
							ELSE rtrim(ltrim(St.DisplayAs))  
						END)
						,''
					) AS StaffName,
					--CASE 
					--	WHEN AtS.AttendanceServiceId IS NULL
					--		THEN ISNULL
					--			(
					--				(CASE   
					--					WHEN rtrim(ltrim(St.DisplayAs)) IS NULL  
					--					THEN rtrim(ltrim(St.LastName)) + ', ' + rtrim(St.FirstName)  
					--					ELSE rtrim(ltrim(St.DisplayAs))  
					--				END)
					--				,''
					--			)
					--	ELSE  ISNULL
					--			(
					--				(CASE   
					--					WHEN rtrim(ltrim(AtInSt.DisplayAs)) IS NULL  
					--					THEN rtrim(ltrim(AtInSt.LastName)) + ', ' + rtrim(AtInSt.FirstName)  
					--					ELSE rtrim(ltrim(AtInSt.DisplayAs))  
					--				END)
					--				,''
					--			)
					--END AS StaffName,
					--ISNULL
					--(
					--	(CASE   
					--		WHEN rtrim(ltrim(St.DisplayAs)) IS NULL  
					--		THEN rtrim(ltrim(St.LastName)) + ', ' + rtrim(St.FirstName)  
					--		ELSE rtrim(ltrim(St.DisplayAs))  
					--	END)
					--	,''
					--) AS StaffName,
					(select TOP 1 ISNULL(PP.DisplayAs,'') from ProcedureCodes PP where PP.ProcedureCodeId = ISNULL(CDP.ProcedureCodeId,ISNULL(G.AttendanceDefaultProcedureCodeId,0)))AS ProcedureCodeName,  --Manjunath 13/July/2017
					ISNULL(L.LocationCode,'') AS LocationCode,
					'N' AS ToSave
					,'N' AS RecordDeleted
					,S.GroupServiceId
					,ROW_NUMBER() OVER (PARTITION BY gs.GroupServiceId,s.ClientId ORDER BY s.ServiceId ASC) AS RowNum
					--INTO #AttendanceServicesResultSet 
				FROM Groups G
				INNER JOIN GroupServices GS ON GS.GroupId=G.GroupId AND ISNULL(GS.RecordDeleted,'N')='N'
				INNER JOIN Services S ON S.GroupServiceId = GS.GroupServiceId AND ISNULL(S.RecordDeleted, 'N') = 'N' 
																			AND CAST(S.DateOfService AS DATE) = CAST(@Date AS DATE) 
																			AND S.[Status] IN(70,71,75) --11-Aug-2016    Vamsi
																			AND (ISNULL(S.ClinicianId, -1) = @StaffId OR @StaffId = 0)
				INNER JOIN Clients C ON S.ClientId=C.ClientId AND ISNULL(C.RecordDeleted, 'N') = 'N' AND ISNULL(C.Active,'N') = 'Y'
				LEFT JOIN Staff St ON St.StaffId=S.ClinicianId
				LEFT JOIN GroupClientDefaultProcedureCodes CDP ON CDP.GroupId= G.GroupId AND CDP.ClientId=C.ClientId and isnull(CDP.RecordDeleted, 'N') = 'N'
				LEFT JOIN Locations L ON L.LocationId=G.LocationId
				LEFT JOIN Staff SSer ON S.ClinicianId = SSer.StaffId AND ISNULL(S.RecordDeleted, 'N') = 'N' AND ISNULL(SSer.Active,'N') = 'Y'

				WHERE 
					ISNULL(G.UsesAttendanceFunctions,'N')='Y' 
					AND ISNULL(G.RecordDeleted, 'N') = 'N'
					AND ISNULL(G.Active,'N') = 'Y'
					AND (G.ProgramId=@ProgramId OR ISNULL(@ProgramId,0)=0)
					--AND (G.ClinicianId=@StaffId OR ISNULL(@StaffId,0)=0)					
					AND G.GroupId=@GroupId
					
					
					
				--FROM Clients C
				--INNER JOIN GroupClients GC ON GC.ClientId=C.ClientId AND ISNULL(GC.RecordDeleted,'N')='N'
				--INNER JOIN Groups G ON  GC.GroupId=G.GroupId AND ISNULL(G.UsesAttendanceFunctions,'N')='Y' AND ISNULL(G.RecordDeleted, 'N') = 'N' AND ISNULL(G.Active,'N') = 'Y'
				--INNER JOIN GroupServices GS ON GS.GroupId=G.GroupId AND ISNULL(GS.RecordDeleted,'N')='N'
				--INNER JOIN Services S ON S.GroupServiceId = GS.GroupServiceId AND ISNULL(S.RecordDeleted, 'N') = 'N' AND S.ClientId=C.ClientId --AND S.[Status] = 70	
				--LEFT JOIN Staff St ON St.StaffId=G.ClinicianId
				--LEFT JOIN ProcedureCodes PC ON PC.ProcedureCodeId=G.ProcedureCodeId
				--LEFT JOIN Locations L ON L.LocationId=G.LocationId
				--LEFT JOIN Staff SSer ON S.ClinicianId = SSer.StaffId AND ISNULL(S.RecordDeleted, 'N') = 'N' AND ISNULL(SSer.Active,'N') = 'Y'
				
				--WHERE ISNULL(C.RecordDeleted, 'N') = 'N' AND ISNULL(C.Active,'N') = 'Y'
				--		AND (G.ProgramId=@ProgramId OR ISNULL(@ProgramId,0)=0)
				--		AND (G.ClinicianId=@StaffId OR ISNULL(@StaffId,0)=0)
				--		AND G.GroupId=@GroupId
				--		AND CAST(S.DateOfService AS DATE) = CAST(@Date AS DATE)
				--		AND EXISTS(SELECT 1 FROM StaffPrograms SP WHERE SP.ProgramId = s.ProgramId AND ISNULL(SP.RecordDeleted, 'N') = 'N')
				--		AND EXISTS(SELECT 1 FROM StaffClients sc WHERE sc.ClientId = s.ClientId AND (sc.StaffId = @StaffId OR ISNULL(@StaffId,0)=0))
			
			END
			ELSE
			BEGIN
			
				DECLARE @UnsavedChangeXML XML
				
				SET @UnsavedChangeXML=(SELECT TOP 1  CAST(REPLACE(REPLACE(CAST(UC.UnsavedChangesXML AS NVARCHAR(MAX)),'xmlns="http://tempuri.org/DataSetAttendanceServices.xsd"',''),'+05:30','') AS XML) FROM UnsavedChanges UC WHERE UC.UnsavedChangeId=@UnsavedChangeId)
				INSERT INTO #AttendanceServicesResultSet
				
				SELECT 
					a.b.value('AttendanceServiceId[1]', 'INT') AS AttendanceServiceId
					,a.b.value('ClientId[1]', 'INT') AS ClientId
					,a.b.value('ClientName[1]', 'VARCHAR(500)') AS ClientName
					,a.b.value('StaffId[1]', 'INT') AS StaffId
					,a.b.value('ProcedureCodeId[1]', 'INT') AS ProcedureCodeId
					,a.b.value('DateOfService[1]', 'DATETIME') AS DateOfService
					,a.b.value('EndDateOfService[1]', 'DATETIME') AS EndDateOfService
					,a.b.value('Duration[1]', 'DECIMAL(18,2)') AS Duration				
					,a.b.value('LocationId[1]', 'INT') AS LocationId
					,a.b.value('ProgramId[1]', 'INT') AS ProgramId
					,a.b.value('Comment[1]', 'VARCHAR(MAX)') AS Comment
					,a.b.value('StaffName[1]', 'VARCHAR(500)') AS StaffName
					,a.b.value('ProcedureCodeName[1]', 'VARCHAR(500)') AS ProcedureCodeName
					,a.b.value('LocationCode[1]', 'VARCHAR(500)') AS LocationCode
					,a.b.value('ToSave[1]', 'CHAR(1)') AS ToSave
					,a.b.value('RecordDeleted[1]', 'CHAR(1)') AS RecordDeleted
					,a.b.value('GroupServiceId[1]', 'INT') AS GroupServiceId
					,null
				FROM @UnsavedChangeXML.nodes('DataSetAttendanceServices/AttendanceServices') a(b)			
			END	
			
			--SELECT *
			--FROM #AttendanceServicesResultSet
	
			CREATE TABLE #tempASResultSetInitial (
				AttendanceServiceId INT
				,ClientId INT
				,ClientName VARCHAR(500)
				,StaffId INT
				,ProcedureCodeId INT
				,DateOfService DATETIME
				,EndDateOfService DATETIME
				,Duration DECIMAL(18,2)
				,LocationId INT
				,ProgramId INT
				,Comment VARCHAR(MAX)
				,StaffName VARCHAR(500)
				,ProcedureCodeName VARCHAR(500)
				,LocationCode VARCHAR(500)
				,ToSave CHAR(1)
				,RecordDeleted CHAR(1)
				,GroupServiceId INT
				)
		
			IF( ISNULL(@IsJustSaved,0) = 0)
			BEGIN
				INSERT INTO #tempASResultSetInitial
				SELECT  
					AttendanceServiceId
					,ClientId
					,ClientName
					,StaffId
					,ProcedureCodeId
					,DateOfService
					,EndDateOfService
					,Duration
					,LocationId
					,ProgramId
					,Comment
					,StaffName
					,ProcedureCodeName
					,LocationCode
					,ToSave
					,RecordDeleted
					,GroupServiceId
					--INTO #tempASResultSet
				FROM #AttendanceServicesResultSet
				WHERE RowNum = 1
			END
			
			INSERT INTO #tempASResultSetInitial
			
			SELECT 
				S.ServiceId AS AttendanceServiceId
				,S.ClientId
				,C.LastName + ', ' + C.FirstName as ClientName
				,S.ClinicianId AS StaffId
				,S.ProcedureCodeId
				,S.DateOfService
				,ISNULL(S.EndDateOfService,S.DateTimeOut) AS EndDateOfService
				--,S.EndDateOfService
				,S.Unit AS Duration
				,S.LocationId
				,S.ProgramId
				,S.Comment
				,ISNULL
				(
					(CASE   
						WHEN rtrim(ltrim(St.DisplayAs)) IS NULL  
						THEN rtrim(ltrim(St.LastName)) + ', ' + rtrim(St.FirstName)  
						ELSE rtrim(ltrim(St.DisplayAs))  
					END)
					,''
				) AS StaffName
				--,ISNULL(St.Initial,'') AS StaffName
				,ISNULL(PC.DisplayAs,'') AS ProcedureCodeName
				,ISNULL(L.LocationCode,'') AS LocationCode
				,'N' AS ToSave
				,'N' AS RecordDeleted
				,ISNULL(S.GroupServiceId,0) AS GroupServiceId
				--INTO #tempASResultSet
			FROM Services S 
			INNER JOIN AttendanceServices ATS ON ATS.ServiceId=S.ServiceId AND ATS.GroupId=@GroupId AND ISNULL(ATS.RecordDeleted, 'N') = 'N'
			INNER JOIN Clients C ON S.ClientId=C.ClientId AND ISNULL(C.RecordDeleted, 'N') = 'N' AND ISNULL(C.Active,'N') = 'Y'
			INNER JOIN Staff St ON St.StaffId=S.ClinicianId
			INNER JOIN ProcedureCodes PC ON PC.ProcedureCodeId=S.ProcedureCodeId
			INNER JOIN Locations L ON L.LocationId=S.LocationId
			INNER JOIN #AttendanceServicesResultSet ASRS ON ASRS.ClientId=S.ClientId
			WHERE ISNULL(S.RecordDeleted, 'N') = 'N' AND CAST(S.DateOfService AS DATE) = CAST(@Date AS DATE)
				AND (S.ProgramId=@ProgramId OR ISNULL(@ProgramId,0)=0)
				--AND S.ProcedureCodeId=(SELECT TOP 1 ProcedureCodeId FROM Groups WHERE GroupId=@GroupId)
				AND ISNULL(S.GroupServiceId,0)=0
			
			SELECT DISTINCT 
					* 
				INTO #tempASResultSet 
			FROM #tempASResultSetInitial
						
			SET @PageSize = (SELECT Count(*) FROM #tempASResultSet)
			
			;WITH Counts AS 
			(
				SELECT Count(*) AS TotalRows 
				FROM #tempASResultSet
			)
			,RankResultSet AS 
			(
				SELECT 
					CASE 
						WHEN AttendanceServiceId=0
						THEN -(CAST((ROW_NUMBER() OVER (ORDER BY ClientId)) AS INT))
						ELSE AttendanceServiceId
					END AS AttendanceServiceId
					,ClientId
					,ClientName					
					,StaffId,
					ProcedureCodeId,
					DateOfService,
					EndDateOfService,
					Duration,
					LocationId,
					ProgramId,
					Comment,
					StaffName,
					ProcedureCodeName,
					LocationCode,
					ToSave,
					RecordDeleted,
					GroupServiceId
					,Count(*) OVER () AS TotalCount
					,Rank() OVER (ORDER BY ClientName) AS RowNumber
				FROM #tempASResultSet
			)
			SELECT TOP (CASE WHEN (@PageNumber = - 1) THEN (SELECT Isnull(TotalRows, 0)	FROM Counts) ELSE (@PageSize)END) 
					AttendanceServiceId			
					,ClientId
					,ClientName,
					StaffId,
					ProcedureCodeId,
					DateOfService,
					EndDateOfService,
					Duration,
					LocationId,
					ProgramId,
					Comment,
					StaffName,
					ProcedureCodeName,
					LocationCode,
					ToSave,
					RecordDeleted,
					GroupServiceId
					,TotalCount
					,RowNumber
				INTO #FinalResultSet
			FROM RankResultSet
			WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

			SELECT TOP 1 
				@PageNumber AS PageNumber
				,CASE (Totalcount % @PageSize)
				WHEN 0
					THEN Isnull((Totalcount / @PageSize), 0)
					ELSE Isnull((Totalcount / @PageSize), 0) + 1
				END AS NumberOfPages
				,Isnull(Totalcount, 0) AS NumberofRows
			FROM #FinalResultSet
			
			SELECT 
				AttendanceServiceId, 
				ClientId,
				ClientName,
				StaffId,
				ProcedureCodeId,
				DateOfService,
				EndDateOfService,
				CAST (Duration AS INT) Duration,
				LocationId,
				ProgramId,
				Comment,
				StaffName,
				ProcedureCodeName,
				LocationCode,
				ToSave,
				RecordDeleted,
				GroupServiceId,
				@GroupId as GroupId
			FROM #FinalResultSet		
			ORDER BY ClientName ASC
					
		END		
		ELSE
		BEGIN
					
			If Not Exists(Select 1
			FROM Clients C
			INNER JOIN GroupClients GC ON GC.ClientId=C.ClientId AND ISNULL(GC.RecordDeleted,'N')='N'
			INNER JOIN Groups G ON  GC.GroupId=G.GroupId AND ISNULL(G.UsesAttendanceFunctions,'N')='Y' AND ISNULL(G.RecordDeleted, 'N') = 'N' AND ISNULL(G.Active,'N') = 'Y'
			INNER JOIN GroupServices GS ON GS.GroupId=G.GroupId AND ISNULL(GS.RecordDeleted,'N')='N'
			WHERE ISNULL(C.RecordDeleted, 'N') = 'N' AND ISNULL(C.Active,'N') = 'Y'
					AND (G.ProgramId=@ProgramId OR ISNULL(@ProgramId,0)=0)
					AND G.GroupId=@GroupId
					AND CAST(GS.DateOfService AS DATE) = CAST(@Date AS DATE)
			 )	
			 BEGIN
			 SELECT DISTINCT
				-1 AS AttendanceServiceId, 
				-1 AS ClientId,
				'' AS ClientName,
				0 AS StaffId,
				0 AS ProcedureCodeId,
				CAST(NULL AS DATETIME) AS DateOfService,
				CAST(NULL AS DATETIME) AS EndDateOfService,
				0 AS LocationId,
				0 AS ProgramId,
				'' AS Comment
			 END
			 Else
			 BEGIN
			 SELECT DISTINCT
				-(CAST((ROW_NUMBER() OVER (ORDER BY C.ClientId)) AS INT)) AS AttendanceServiceId, 
				-1 AS ClientId,--C.ClientId,
				'' AS ClientName,--C.LastName + ', ' + C.FirstName as ClientName,
				0 AS StaffId,
				0 AS ProcedureCodeId,
				CAST(NULL AS DATETIME) AS DateOfService,
				CAST(NULL AS DATETIME) AS EndDateOfService,
				CAST(CAST(NULL AS decimal(18,2)) AS INT) AS Duration,
				0 AS LocationId,
				0 AS ProgramId,
				'' AS Comment,
				'' AS StaffName,
				'' AS ProcedureCodeName,
				'' AS LocationCode,
				'N' AS ToSave,
				'N' AS RecordDeleted,
				0 AS GroupServiceId,
				@GroupId as GroupId
			
			FROM Clients C
			INNER JOIN GroupClients GC ON GC.ClientId=C.ClientId AND ISNULL(GC.RecordDeleted,'N')='N'
			INNER JOIN Groups G ON  GC.GroupId=G.GroupId AND ISNULL(G.UsesAttendanceFunctions,'N')='Y' AND ISNULL(G.RecordDeleted, 'N') = 'N' AND ISNULL(G.Active,'N') = 'Y'
			INNER JOIN GroupServices GS ON GS.GroupId=G.GroupId AND ISNULL(GS.RecordDeleted,'N')='N'
			WHERE ISNULL(C.RecordDeleted, 'N') = 'N' AND ISNULL(C.Active,'N') = 'Y'
					AND (G.ProgramId=@ProgramId OR ISNULL(@ProgramId,0)=0)
					--AND (G.ClinicianId=@StaffId OR ISNULL(@StaffId,0)=0)
					AND G.GroupId=@GroupId
					AND CAST(GS.DateOfService AS DATE) = CAST(@Date AS DATE)
			 END	
			
			
		END	
		
	
		
	END TRY
	BEGIN CATCH
	
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetAttendanceServices') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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