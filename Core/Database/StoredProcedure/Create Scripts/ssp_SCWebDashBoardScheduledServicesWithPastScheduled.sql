/****** Object:  StoredProcedure [dbo].[ssp_SCWebDashBoardScheduledServicesWithPastScheduled]    Script Date: 08/08/2014 08:09:10 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebDashBoardScheduledServicesWithPastScheduled]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCWebDashBoardScheduledServicesWithPastScheduled]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCWebDashBoardScheduledServicesWithPastScheduled] --3,3,'Y'    
	@StaffId INT
	,@LoggedInStaffId INT
	,@RefreshData CHAR(1) = NULL
	/********************************************************************************                                            
-- Stored Procedure: ssp_SCWebDashBoardScheduledServicesWithPastScheduled                                             
--                                            
-- Copyright: Streamline Healthcate Solutions                                            
--                                            
-- Purpose: used by dashboard Documents widget                                            
--                                            
-- Updates:                                                                                                   
-- /ate				Author				Purpose                  
-- 08/20/2015    MD Hussain Khusro      Created - Copied from Threshold Services for Services for Today with Past Scheduled Widget     
--  21 Oct 2015    Revathi				what:Changed code to display Clients LastName and FirstName when ClientType='I' else  OrganizationName.  /   
--										why:task #609, Network180 Customization  /
-- 10/Oct/2015   MD Hussain Khusro	    Modify - Added condition to check for the start date of the flag (client note) w.r.t task #263 Allegan Support	
--  21/ Dec /2015    Revathi				what:reverted Changed code to display Clients LastName and FirstName when ClientType='I' else  OrganizationName.  /   
--										why:task #1982, Core Bugs  / 
-- 11/Aug/2016        Vamsi             What: Added to show  services with GroupserviceId as null.
--                                      why : MFS Customization Issue Tracking #237 
****************************************************************************************/
AS
BEGIN
	BEGIN TRY
		CREATE TABLE #Services (
			ServiceId INT
			,ClientId INT
			)

		CREATE TABLE #Notes (
			NoteId INT identity NOT NULL
			,ClientId INT NULL
			,ClientNoteId INT NULL
			,GlobalCodeId INT NULL
			,NoteType INT NULL
			,Bitmap VARCHAR(200) NULL
			,NoteNumber INT NULL
			,Note VARCHAR(100) NULL
			)

		/*Past Scheduled Services*/
		DECLARE @PastServiceCount INT = 0;

		SELECT @PastServiceCount = COUNT(S.ServiceId)
		FROM Services AS S
		INNER JOIN Clients C ON S.ClientId = C.ClientId
		INNER JOIN StaffClients SC ON SC.ClientId = S.ClientId
			AND SC.StaffId = @LoggedInStaffId
		INNER JOIN ProcedureCodes PC ON S.ProcedureCodeId = PC.ProcedureCodeId
		INNER JOIN Programs P ON P.ProgramId = S.ProgramId
		LEFT JOIN Documents D ON D.ServiceId = S.ServiceId
			AND isNull(D.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN GroupServices ON S.GroupServiceId = GroupServices.GroupServiceId
		LEFT JOIN Groups ON GroupServices.GroupId = Groups.GroupId
		LEFT JOIN DocumentCodes DC ON D.DocumentCodeID = Dc.DocumentCodeID
			AND DC.DocumentCodeID IN (
				SELECT DocumentCodeId
				FROM DocumentCodes
				WHERE ServiceNote = 'Y'
				)
		WHERE S.STATUS = 70
			--AND ISNULL(S.DateOfService,'1/1/1900') >= DATEADD(DAY,-1, GETDATE())                   
			--AND CONVERT(DATE,ISNULL(S.DateOfService,'1/1/1900'))<= CONVERT(DATE,GETDATE())                   
			AND CAST(ISNULL(S.DateOfService, '1/1/1900') AS DATE) < CAST(GETDATE() AS DATE)
			AND S.ClinicianId = @StaffId
			AND ISNULL(S.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(C.RecordDeleted, 'N') <> 'Y'
			AND isnull(Groups.RecordDeleted, 'N') <> 'Y'
			AND isnull(GroupServices.RecordDeleted, 'N') <> 'Y'

		INSERT INTO #Services (
			ServiceId
			,ClientId
			)
		SELECT s.ServiceId
			,s.ClientId
		FROM Services s
		INNER JOIN StaffClients sc ON sc.ClientId = s.ClientId
			AND sc.StaffId = @LoggedInStaffId
		WHERE s.STATUS IN (
				70
				,71
				,72
				,73
				)
			AND datediff(dd, s.DateofService, getdate()) = 0
			AND s.ClinicianId = @StaffId
			AND s.GroupServiceId IS NULL -- 11/Aug/2016        Vamsi  
			AND isnull(s.RecordDeleted, 'N') <> 'Y'

		INSERT INTO #Notes (
			ClientId
			,ClientNoteId
			,GlobalCodeId
			,NoteType
			,Bitmap
			,Note
			)
		SELECT cn.ClientId
			,cn.ClientNoteId
			,gc.GlobalCodeId
			,cn.NoteType
			,gc.Bitmap
			,cn.Note
		FROM ClientNotes cn
		LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = cn.NoteType
			AND isnull(gc.RecordDeleted, 'N') = 'N'
		WHERE cn.Active = 'Y'
			AND DATEDIFF(dd, cn.StartDate, getdate()) >= 0 -- Added on 10/29/2015 by MD Hussain
			AND (
				dateDiff(dd, cn.EndDate, getdate()) <= 0
				OR cn.EndDate IS NULL
				)
			AND isnull(cn.RecordDeleted, 'N') = 'N'
			AND EXISTS (
				SELECT *
				FROM #Services s
				WHERE s.ClientId = cn.ClientId
				)
		ORDER BY cn.clientid
			,cn.ClientNoteId

		UPDATE n
		SET NoteNumber = n.NoteId - fn.FirstNoteId + 1
		FROM #Notes n
		INNER JOIN (
			SELECT ClientId
				,min(NoteId) AS FirstNoteId
			FROM #Notes
			GROUP BY ClientId
			) fn ON fn.ClientId = n.ClientId

		CREATE TABLE #MainTable (
			ClientLastName VARCHAR(150) NULL
			,ClientFirstName VARCHAR(150) NULL
			,DateOfService DATETIME NULL
			,DocumentName VARCHAR(10) NULL
			,DisplayAs VARCHAR(150) NULL
			,ProgramCode VARCHAR(200) NULL
			,AuthorizationsNeeded INT NULL
			,ServiceId INT NULL
			,DocumentId INT NULL
			,ClientId INT NULL
			,STATUS VARCHAR(100) NULL
			,BitmapNo INT NULL
			,ClientNoteId1 INT NULL
			,NoteType1 INT NULL
			,Bitmap1 VARCHAR(200) NULL
			,Note1 VARCHAR(200) NULL
			,BitmapId1 INT NULL
			,ClientNoteId2 INT NULL
			,NoteType2 INT NULL
			,Bitmap2 VARCHAR(200) NULL
			,Note2 VARCHAR(200) NULL
			,BitmapId2 INT NULL
			,ClientNoteId3 INT NULL
			,NoteType3 INT NULL
			,Bitmap3 VARCHAR(200) NULL
			,Note3 VARCHAR(200) NULL
			,BitmapId3 INT NULL
			,ClientNoteId4 INT NULL
			,NoteType4 INT NULL
			,Bitmap4 VARCHAR(200) NULL
			,Note4 VARCHAR(200) NULL
			,BitmapId4 INT NULL
			,ClientNoteId5 INT NULL
			,NoteType5 INT NULL
			,Bitmap5 VARCHAR(200) NULL
			,Note5 VARCHAR(200) NULL
			,BitmapId5 INT NULL
			,ClientNoteId6 INT NULL
			,NoteType6 INT NULL
			,Bitmap6 VARCHAR(200) NULL
			,Note6 VARCHAR(200) NULL
			,BitmapId6 INT NULL
			,ClientId1 INT NULL
			,ClientDisplayName VARCHAR(200) NULL
			,Comment VARCHAR(max) NULL
			,GroupServiceId INT NULL
			,GroupName VARCHAR(200) NULL
			,GroupId INT NULL
			,PastServiceCount INT NULL
			,Flag CHAR(1)
			)

		INSERT INTO #MainTable (
			ClientLastName
			,ClientFirstName
			,DateOfService
			,DocumentName
			,DisplayAs
			,ProgramCode
			,AuthorizationsNeeded
			,ServiceId
			,DocumentId
			,Clientid
			,STATUS
			,BitmapNo
			,ClientNoteId1
			,NoteType1
			,Bitmap1
			,Note1
			,BitmapId1
			,ClientNoteId2
			,NoteType2
			,Bitmap2
			,Note2
			,BitmapId2
			,ClientNoteId3
			,NoteType3
			,Bitmap3
			,Note3
			,BitmapId3
			,ClientNoteId4
			,NoteType4
			,Bitmap4
			,Note4
			,BitmapId4
			,ClientNoteId5
			,NoteType5
			,Bitmap5
			,Note5
			,BitmapId5
			,ClientNoteId6
			,NoteType6
			,Bitmap6
			,Note6
			,BitmapId6
			,clientid1
			,ClientDisplayName
			,Comment
			,GroupServiceId
			,GroupName
			,GroupId
			,PastServiceCount
			,Flag
			)
		SELECT rtrim(c.LastName) AS ClientLastName
			,rtrim(c.FirstName) AS ClientFirstName
			,sv.DateOfService
			,
			--Case ISNULL(G.GroupId,0)     
			--When 0 Then sv.DateOfService  Else GS.DateOfService END 'DateOfService',    
			'Note' AS DocumentName
			,pc.DisplayAs
			,p.ProgramCode
			,sv.AuthorizationsNeeded
			,sv.ServiceId
			,isnull(d.DocumentId, 0) AS DocumentId
			,c.Clientid
			,
			--CASE WHEN sv.GroupServiceId IS NULL     
			--THEN CASE WHEN d.CurrentVersionStatus = 22 AND sv.Status = 71 THEN GC.CodeName ELSE gcs.CodeName END  -- If d.Status=Signed and sv.Status=Show    
			--ELSE dbo.SCGetGroupServiceStatusName(sv.GroupServiceId)    
			--END AS Status,       
			CASE 
				WHEN d.CurrentVersionStatus = 22
					AND sv.STATUS = 71
					THEN GC.CodeName
				ELSE gcs.CodeName
				END AS STATUS
			,n.BitmapNo
			,ISNULL(n.ClientNoteId1, 0) AS ClientNoteId1
			,ISNULL(n.NoteType1, 0) AS NoteType1
			,ISNULL(n.Bitmap1, 0) AS Bitmap1
			,ISNULL(n.Note1, 0) AS Note1
			,ISNULL(n.BitmapId1, 0) AS BitmapId1
			,ISNULL(n.ClientNoteId2, 0) AS ClientNoteId2
			,ISNULL(n.NoteType2, 0) AS NoteType2
			,ISNULL(n.Bitmap2, 0) AS Bitmap2
			,ISNULL(n.Note2, 0) AS Note2
			,ISNULL(n.BitmapId2, 0) AS BitmapId2
			,ISNULL(n.ClientNoteId3, 0) AS ClientNoteId3
			,ISNULL(n.NoteType3, 0) AS NoteType3
			,ISNULL(n.Bitmap3, 0) AS Bitmap3
			,ISNULL(n.Note3, 0) AS Note3
			,ISNULL(n.BitmapId3, 0) AS BitmapId3
			,ISNULL(n.ClientNoteId4, 0) AS ClientNoteId4
			,ISNULL(n.NoteType4, 0) AS NoteType4
			,ISNULL(n.Bitmap4, 0) AS Bitmap4
			,ISNULL(n.Note4, 0) AS Note4
			,ISNULL(n.BitmapId4, 0) AS BitmapId4
			,ISNULL(n.ClientNoteId5, 0) AS ClientNoteId5
			,ISNULL(n.NoteType5, 0) AS NoteType5
			,ISNULL(n.Bitmap5, 0) AS Bitmap5
			,ISNULL(n.Note5, 0) AS Note5
			,ISNULL(n.BitmapId5, 0) AS BitmapId5
			,ISNULL(n.ClientNoteId6, 0) AS ClientNoteId6
			,ISNULL(n.NoteType6, 0) AS NoteType6
			,ISNULL(n.Bitmap6, 0) AS Bitmap6
			,ISNULL(n.Note6, 0) AS Note6
			,ISNULL(n.BitmapId6, 0) AS BitmapId6
			,
			/*                                 
       n.ClientNoteId1, n.NoteType1, n.Bitmap1,n.Note1,n.BitmapId1,                                      
       n.ClientNoteId2, n.NoteType2, n.Bitmap2,n.Note2,n.BitmapId2,                                       
       n.ClientNoteId3, n.NoteType3, n.Bitmap3,n.Note3,n.BitmapId3,                                        
       n.ClientNoteId4, n.NoteType4, n.Bitmap4,n.Note4,n.BitmapId4 ,                                       
       n.ClientNoteId5, n.NoteType5, n.Bitmap5,n.Note5,n.BitmapId5,                                        
       n.ClientNoteId6, n.NoteType6, n.Bitmap6,n.Note6,n.BitmapId6,    
       */
			n.clientid
			--Reverted by Revathi  21/ Dec /2015 
			,rtrim(ISNULL(c.Lastname, '')) + ', ' + rtrim(ISNULL(c.FirstName, '')) AS ClientDisplayName
			--Added by Revathi 21 Oct 2015    
			--CASE 
			--	WHEN ISNULL(C.ClientType, 'I') = 'I'
			--		THEN rtrim(ISNULL(c.Lastname, '')) + ', ' + rtrim(ISNULL(c.FirstName, ''))
			--	ELSE ISNULL(C.OrganizationName, '')
			--	END AS ClientDisplayName
			,ISNULL(sv.Comment, '') AS Comment
			,
			--ISNULL(sv.GroupServiceId,0) AS GroupServiceId,
			'' AS GroupServiceId
			,
			-- ISNULL(G.GroupName,'') AS GroupName,
			'' AS GroupName
			,
			--ISNULL(G.GroupId,0) AS GroupId,
			'' AS GroupId
			,@PastServiceCount AS PastServiceCount
			,'S'
		FROM #Services s
		INNER JOIN Services sv ON sv.ServiceId = s.ServiceId
		INNER JOIN Clients c ON c.ClientId = sv.ClientId
			AND isnull(c.RecordDeleted, 'N') <> 'Y'
		INNER JOIN ProcedureCodes pc ON pc.ProcedureCodeId = sv.ProcedureCodeId
			AND isnull(pc.RecordDeleted, 'N') <> 'Y'
		INNER JOIN Programs p ON p.ProgramId = sv.ProgramId
			AND isnull(p.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN Documents d ON d.ServiceId = sv.ServiceId
			AND isnull(d.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN GlobalCodes gcs ON gcs.GlobalCodeId = sv.STATUS
			AND isnull(gcs.RecordDeleted, 'N') <> 'Y'
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = D.CurrentVersionStatus
			AND isnull(GC.RecordDeleted, 'N') <> 'Y'
		--    Left Join GroupServices AS GS ON GS.GroupServiceId in(Select distinct top 1 GroupServiceId From Services as SS Where GroupServiceId is not null and SS.GroupServiceId = sv.GroupServiceId AND isnull(SS.RecordDeleted, 'N') <> 'Y' )    
		--            AND isnull(GS.RecordDeleted, 'N') <> 'Y'    
		-- Left Join Groups AS G On G.GroupId=GS.GroupId AND G.Active='Y' AND isnull(G.RecordDeleted, 'N') <> 'Y'    
		LEFT JOIN (
			SELECT ClientId
				,max(NoteNumber) AS BitmapNo
				,max(CASE NoteNumber
						WHEN 1
							THEN ClientNoteId
						ELSE NULL
						END) AS ClientNoteId1
				,max(CASE NoteNumber
						WHEN 1
							THEN NoteType
						ELSE NULL
						END) AS NoteType1
				,max(CASE NoteNumber
						WHEN 1
							THEN Bitmap
						ELSE NULL
						END) AS Bitmap1
				,max(CASE NoteNumber
						WHEN 1
							THEN Note
						ELSE NULL
						END) AS Note1
				,max(CASE NoteNumber
						WHEN 1
							THEN GlobalCodeId
						ELSE NULL
						END) AS BitmapId1
				,max(CASE NoteNumber
						WHEN 2
							THEN ClientNoteId
						ELSE NULL
						END) AS ClientNoteId2
				,max(CASE NoteNumber
						WHEN 2
							THEN NoteType
						ELSE NULL
						END) AS NoteType2
				,max(CASE NoteNumber
						WHEN 2
							THEN Bitmap
						ELSE NULL
						END) AS Bitmap2
				,max(CASE NoteNumber
						WHEN 2
							THEN Note
						ELSE NULL
						END) AS Note2
				,max(CASE NoteNumber
						WHEN 2
							THEN GlobalCodeId
						ELSE NULL
						END) AS BitmapId2
				,max(CASE NoteNumber
						WHEN 3
							THEN ClientNoteId
						ELSE NULL
						END) AS ClientNoteId3
				,max(CASE NoteNumber
						WHEN 3
							THEN NoteType
						ELSE NULL
						END) AS NoteType3
				,max(CASE NoteNumber
						WHEN 3
							THEN Bitmap
						ELSE NULL
						END) AS Bitmap3
				,max(CASE NoteNumber
						WHEN 3
							THEN Note
						ELSE NULL
						END) AS Note3
				,max(CASE NoteNumber
						WHEN 3
							THEN GlobalCodeId
						ELSE NULL
						END) AS BitmapId3
				,max(CASE NoteNumber
						WHEN 4
							THEN ClientNoteId
						ELSE NULL
						END) AS ClientNoteId4
				,max(CASE NoteNumber
						WHEN 4
							THEN NoteType
						ELSE NULL
						END) AS NoteType4
				,max(CASE NoteNumber
						WHEN 4
							THEN Bitmap
						ELSE NULL
						END) AS Bitmap4
				,max(CASE NoteNumber
						WHEN 4
							THEN Note
						ELSE NULL
						END) AS Note4
				,max(CASE NoteNumber
						WHEN 4
							THEN GlobalCodeId
						ELSE NULL
						END) AS BitmapId4
				,max(CASE NoteNumber
						WHEN 5
							THEN ClientNoteId
						ELSE NULL
						END) AS ClientNoteId5
				,max(CASE NoteNumber
						WHEN 5
							THEN NoteType
						ELSE NULL
						END) AS NoteType5
				,max(CASE NoteNumber
						WHEN 5
							THEN Bitmap
						ELSE NULL
						END) AS Bitmap5
				,max(CASE NoteNumber
						WHEN 5
							THEN Note
						ELSE NULL
						END) AS Note5
				,max(CASE NoteNumber
						WHEN 5
							THEN GlobalCodeId
						ELSE NULL
						END) AS BitmapId5
				,max(CASE NoteNumber
						WHEN 6
							THEN ClientNoteId
						ELSE NULL
						END) AS ClientNoteId6
				,max(CASE NoteNumber
						WHEN 6
							THEN NoteType
						ELSE NULL
						END) AS NoteType6
				,max(CASE NoteNumber
						WHEN 6
							THEN Bitmap
						ELSE NULL
						END) AS Bitmap6
				,max(CASE NoteNumber
						WHEN 6
							THEN Note
						ELSE NULL
						END) AS Note6
				,max(CASE NoteNumber
						WHEN 6
							THEN GlobalCodeId
						ELSE NULL
						END) AS BitmapId6
			FROM #Notes
			WHERE NoteNumber <= 6
			GROUP BY ClientId
			) n ON n.ClientId = sv.ClientId
		WHERE isnull(sv.RecordDeleted, 'N') <> 'Y'
		ORDER BY sv.DateOfService
			,c.LastName
			,c.FirstName;

		WITH ServiceAndGroupServiceDetails
		AS (
			SELECT *
			FROM #MainTable
			
			UNION ALL
			
			SELECT '' AS ClientLastName
				,'' AS ClientFirstName
				,GS.DateOfService AS DateOfService
				,'' AS DocumentName
				,'' AS DisplayAs
				,'' AS ProgramCode
				,'' AS AuthorizationsNeeded
				,'' AS ServiceId
				,'' AS DocumentId
				,'' AS Clientid
				,dbo.SCGetGroupServiceStatusName(GS.GroupServiceId) AS STATUS
				,'' AS BitmapNo
				,'' AS ClientNoteId1
				,'' AS NoteType1
				,'' AS Bitmap1
				,'' AS Note1
				,'' AS BitmapId1
				,'' AS ClientNoteId2
				,'' AS NoteType2
				,'' AS Bitmap2
				,'' AS Note2
				,'' AS BitmapId2
				,'' AS ClientNoteId3
				,'' AS NoteType3
				,'' AS Bitmap3
				,'' AS Note3
				,'' AS BitmapId3
				,'' AS ClientNoteId4
				,'' AS NoteType4
				,'' AS Bitmap4
				,'' AS Note4
				,'' AS BitmapId4
				,'' AS ClientNoteId5
				,'' AS NoteType5
				,'' AS Bitmap5
				,'' AS Note5
				,'' AS BitmapId5
				,'' AS ClientNoteId6
				,'' AS NoteType6
				,'' AS Bitmap6
				,'' AS Note6
				,'' AS BitmapId6
				,'' AS clientid1
				,
				--'' AS ClientDisplayName,-Vishant Garg
				ISNULL(G.GroupName, '') AS ClientDisplayName
				,
				--  Vishant Garg
				ISNULL(GS.Comment, '') AS Comment
				,ISNULL(GS.GroupServiceId, 0) AS GroupServiceId
				,ISNULL(G.GroupName, '') AS GroupName
				,ISNULL(G.GroupId, 0) AS GroupId
				,@PastServiceCount AS PastServiceCount
				,'G'
			FROM GroupServices AS GS
			INNER JOIN GroupServiceStaff AS GSS ON GSS.GroupServiceId = GS.GroupServiceId
				AND ISNULL(GSS.RecordDeleted, 'N') <> 'Y'
			INNER JOIN Groups AS G ON G.GroupId = GS.GroupId
				AND G.Active = 'Y'
				AND ISNULL(G.RecordDeleted, 'N') <> 'Y'
			WHERE CONVERT(DATE, GS.DateOfService) = CONVERT(DATE, GETDATE())
				AND ISNULL(GS.RecordDeleted, 'N') <> 'Y'
				AND GS.STATUS IN (
					70
					,71
					,72
					,73
					)
				AND GSS.StaffId = @StaffId
			)
		SELECT *
		FROM ServiceAndGroupServiceDetails
		ORDER BY DateOfService

		SELECT @PastServiceCount AS PastServiceCount;
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCWebDashBoardScheduledServicesWithPastScheduled') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****ERROR_STATE=' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error /* Message text*/
				,16 /*Severity*/
				,1 /*State*/
				)
	END CATCH
END
GO

