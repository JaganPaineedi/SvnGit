IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetBundledServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetBundledServices]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetBundledServices] 

@ProcedureCodeId INT,
@ServiceIds VARCHAR(max),
@PageNumber INT = 1,
@UnsavedChangeId INT,
@Mode VARCHAR(10) = NULL,
@IsJustSaved INT = NULL

AS
/****************************************************************************/
/* Stored Procedure: ssp_SCGetBundledServices								*/
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
		21 May 2018		Vithobha		 Vithobha Reused the logic of ssp_SCGetAttendanceServices for EII #302
		27 Sep 2018		Vithobha		 Vithobha Modified the logic for bundling services to bundle large services, PEP - Support Go Live: #45
		27 Sep 2018		Vithobha		 Merging the changes of Nimesh from ssp_SCSaveBundledServices.   */
/****************************************************************************/
BEGIN
	BEGIN TRY		
	
		CREATE TABLE #TempServiceIds (ServiceId INT)
		INSERT INTO #TempServiceIds (ServiceId)
		SELECT CONVERT(INT, item)
		FROM dbo.fnSplitWithIndex(@ServiceIds, ',')
	
		DECLARE @PageSize INT = 200
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
				,ServiceId INT
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
					@ProcedureCodeId AS ProcedureCodeId,
					S.DateOfService AS DateOfService,
					S.EndDateOfService AS EndDateOfService,
					S.Unit AS Duration,
					--CAST((DATEDIFF(MINUTE,S.DateTimeIn,S.DateTimeOut)) as int) AS Duration,
					ISNULL(S.LocationId,0) AS LocationId,
					ISNULL(S.ProgramId,0) AS ProgramId,
					'' AS Comment,
					ISNULL
					(
						(CASE   
							WHEN rtrim(ltrim(St.DisplayAs)) IS NULL  
							THEN rtrim(ltrim(St.LastName)) + ', ' + rtrim(St.FirstName)  
							ELSE rtrim(ltrim(St.DisplayAs))  
						END)
						,''
					) AS StaffName,
					(Select DisplayAs FROM ProcedureCodes WHERE ProcedureCodeId=@ProcedureCodeId)AS ProcedureCodeName,
					ISNULL(L.LocationCode,'') AS LocationCode,
					'N' AS ToSave
					,'N' AS RecordDeleted
					,S.ServiceId
					,ROW_NUMBER() OVER (
					PARTITION BY CAST(S.DateOfService AS DATE)
					,S.ClientId
					,S.ProcedureCodeId
					,S.ClinicianId
					,S.ProgramId
					,S.LocationId ORDER BY S.DateOfService,S.EndDateOfService
					) AS RowNum
					--INTO #AttendanceServicesResultSet 
				FROM Services S  
				INNER JOIN Clients C ON S.ClientId=C.ClientId AND ISNULL(C.RecordDeleted, 'N') = 'N' AND ISNULL(C.Active,'N') = 'Y'
				LEFT JOIN Staff St ON St.StaffId=S.ClinicianId
				LEFT JOIN Locations L ON L.LocationId=S.LocationId  AND ISNULL(L.RecordDeleted, 'N') = 'N'
				LEFT JOIN Staff SSer ON S.ClinicianId = SSer.StaffId AND ISNULL(S.RecordDeleted, 'N') = 'N' AND ISNULL(SSer.Active,'N') = 'Y'
				LEFT JOIN ProcedureCodes PP on PP.ProcedureCodeId = S.ProcedureCodeId AND ISNULL(PP.RecordDeleted, 'N') = 'N'
				JOIN #TempServiceIds T on S.ServiceId = T.ServiceId
 				WHERE ISNULL(S.RecordDeleted, 'N') = 'N' 
					--AND CAST(S.DateOfService AS DATE) = CAST(@Date AS DATE) 
					AND S.[Status] IN(70,71,75) --11-Aug-2016    Vamsi
					AND EXISTS ( SELECT 1 FROM  #TempServiceIds TP WHERE TP.ServiceId = S.ServiceId)
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
					,a.b.value('ServiceId[1]', 'INT') AS ServiceId
					,1
				FROM @UnsavedChangeXML.nodes('DataSetAttendanceServices/AttendanceServices') a(b)			
			END	
			
			-- Set Clinician to the one that has the service with the most duration										

		;WITH GetClinician
		AS (
			SELECT DISTINCT a.ClientId
				,a.ProgramId
				,a.ProcedureCodeId
				,a.LocationId
				,a.StaffId
				,CAST(a.DateOfService AS DATE) AS DateofService
				,MAX(a.ServiceId) AS MaxServiceId
				,SUM(DATEDIFF(MI, a.DateOfService, a.EndDateOfService)) AS DurationByClinician
			FROM #AttendanceServicesResultSet a
			GROUP BY a.ClientId
				,CAST(a.DateOfService AS DATE)
				,a.ProcedureCodeId
				,a.StaffId
				,a.ProgramId
				,a.LocationId
			)
		UPDATE a
		SET StaffId = b.StaffId
		FROM #AttendanceServicesResultSet a
		JOIN GetClinician b ON b.ClientId = a.ClientId
			AND CAST(b.DateofService AS DATE) = CAST(a.DateOfService AS DATE)
			AND b.ProgramId = a.ProgramId
			AND b.ProcedureCodeId = a.ProcedureCodeId
			AND b.LocationId = a.LocationId
		WHERE NOT EXISTS (
				SELECT 1
				FROM GetClinician c
				WHERE b.ClientId = c.ClientId
					AND CAST(b.DateofService AS DATE) = CAST(c.DateofService AS DATE)
					AND b.ProgramId = c.ProgramId
					AND b.ProcedureCodeId = c.ProcedureCodeId
					AND b.LocationId = c.LocationId
					AND c.DurationByClinician > b.DurationByClinician
				)
			--
			

			
			;WITH MinutesCal
			AS (
				SELECT a.ClientId
					,MIN(a.DateOfService) AS DateOfService
					,SUM(DATEDIFF(MI, a.DateOfService, a.EndDateOfService)) AS EndDateOfService
					,MIN(a.ProcedureCodeId) AS ProcedureCodeId
					,MIN(a.StaffId) AS StaffId
					,MIN(a.ProgramId) AS ProgramId
					,MIN(a.LocationId) AS LocationId
				FROM #AttendanceServicesResultSet a
				GROUP BY a.ClientId
					,CAST(a.DateOfService AS DATE)
					,a.ProcedureCodeId
					,a.StaffId
					,a.ProgramId
					,a.LocationId
				)
			UPDATE a
			SET a.EndDateOfService = DATEADD(MI, b.EndDateOfService, a.DateOfService)
				,Duration = b.EndDateOfService
			FROM #AttendanceServicesResultSet a
			JOIN MinutesCal b ON a.ClientId = b.ClientId
				AND a.ProcedureCodeId = b.ProcedureCodeId
				AND a.StaffId = b.StaffId
				AND a.ProgramId = b.ProgramId
				AND a.LocationId = b.LocationId
				AND CAST(a.DateOfService AS DATE) = CAST(b.DateOfService AS DATE)
			WHERE a.RowNum = 1
			
			-- Remove multiple Row = 1 entries
		DELETE a
		FROM #AttendanceServicesResultSet a
		JOIN #AttendanceServicesResultSet b ON b.ClientId = a.ClientId
			AND b.ProgramId = a.ProgramId
			AND b.ProcedureCodeId = a.ProcedureCodeId
			AND b.LocationId = a.LocationId
			AND CAST(b.DateOfService AS DATE) = CAST(a.DateOfService AS DATE)
			AND b.StaffId = a.StaffId
		WHERE a.DateOfService > b.DateOfService
	
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
				,ServiceId INT
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
					,ServiceId
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
				,S.ProcedureCodeId AS ProcedureCodeId
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
				,PC.DisplayAs AS ProcedureCodeName
				,ISNULL(L.LocationCode,'') AS LocationCode
				,'N' AS ToSave
				,'N' AS RecordDeleted
				,S.ServiceId AS ServiceId
				--INTO #tempASResultSet
			FROM Services S 
			INNER JOIN AttendanceServices ATS ON ATS.ServiceId=S.ServiceId AND ATS.GroupId is null AND ISNULL(ATS.RecordDeleted, 'N') = 'N'
			INNER JOIN Clients C ON S.ClientId=C.ClientId AND ISNULL(C.RecordDeleted, 'N') = 'N' AND ISNULL(C.Active,'N') = 'Y'
			INNER JOIN Staff St ON St.StaffId=S.ClinicianId
			INNER JOIN ProcedureCodes PC ON PC.ProcedureCodeId=S.ProcedureCodeId
			INNER JOIN Locations L ON L.LocationId=S.LocationId
			INNER JOIN #AttendanceServicesResultSet ASRS ON ASRS.ClientId=S.ClientId
			WHERE ISNULL(S.RecordDeleted, 'N') = 'N' 
			AND S.Status not in(76)
			--AND CAST(S.DateOfService AS DATE) = CAST(@Date AS DATE)
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
					ServiceId
					,Count(*) OVER () AS TotalCount
					,Rank() OVER (ORDER BY ServiceId) AS RowNumber
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
					ServiceId
					,TotalCount
					,RowNumber
				INTO #FinalResultSet
			FROM RankResultSet
			WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

			SELECT TOP 1 
				@PageNumber AS PageNumber
				,CASE (Totalcount % 200)
				WHEN 0
					THEN Isnull((Totalcount / 200), 0)
					ELSE Isnull((Totalcount / 200), 0) + 1
				END AS NumberOfPages
				,Isnull(Totalcount, 0) AS NumberofRows
			FROM #FinalResultSet
			
			SELECT 
				ROW_NUMBER() OVER (ORDER BY ClientName ASC ) AS ROWNUM ,  
				AttendanceServiceId, 
				ClientId,
				ClientName,
				StaffId,
				ProcedureCodeId,
				CONVERT(DATETIME,CONVERT(VARCHAR(16),DateOfService,120)+ ':00') as DateOfService,
				CONVERT(DATETIME,CONVERT(VARCHAR(16),EndDateOfService,120)+ ':00') as EndDateOfService,
				CAST (Duration AS INT) Duration,
				LocationId,
				ProgramId,
				Comment,
				StaffName,
				ProcedureCodeName,
				LocationCode,
				ToSave,
				RecordDeleted,
				ServiceId
			FROM #FinalResultSet		
			ORDER BY ClientName ASC
					
		END		
		ELSE
		BEGIN
			
			 SELECT DISTINCT
				-1 AS AttendanceServiceId, 
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
				0 AS ServiceId
			
		END	
		
	END TRY
	BEGIN CATCH
	
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetBundledServices') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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