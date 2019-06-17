/****** Object:  StoredProcedure [dbo].[ssp_GetPCScheduleAppointments]    Script Date: 02/25/2015 17:22:44 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetPCScheduleAppointments]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetPCScheduleAppointments]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetPCScheduleAppointments]    Script Date: 02/25/2015 17:22:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetPCScheduleAppointments] @StaffId INT
	,@CurrentDate VARCHAR(100)
	,@ScheduleStaffId INT
AS /*********************************************************************/
/* Stored Procedure: ssp_GetPCScheduleAppointments             */
/* Creation Date:  21 Spt, 2012                                    */
/*                                                                   */
/* Purpose: get the schedule appointments form primary care .             */
/*                                                                   */
/* Input Parameters:                                    */
/*                                                                   */
/* Output Parameters:                                */
/*                                                                   */
/*                                                                   */
/* Called By:  ScheduleAppointment.ascx                                                    */
/*                                                                   */
/* Calls:                                                                              
--   Date   Author     Purpose                                                                                            
--  21 spt 2012  Rahul Aneja      get the schedule appointments form primary care  */
--  03 oct 2012  Devinder k       Modify with current date data  */    
--  19- Nov -2012 Rakesh Garg      Modify Not to show 8044 Reshedule , 8045 - Error appointments on Widget    
--  05 March 2013 SunilKh         Show Client NAme as (LAstname +FirstName) for primary care bugs and features task 321    
--  5 MARCH 2013  VISHANT GARG    WITH REF TASK# 323    
--          wHAT AND WHY -aDDED A CASE TO GET THE STATUS IF EXAMROOM THEN ALSO SHOW EXAM ROOM TYPE     
-- 08-MAR-2013  Deejkumar    Added new logic to get the icons based on the availablity of the ProgressNotes  
-- Sep 19 2013  Munish		 Task # 1218 Core Bugs changes   
-- Jan 20 2014  Hussain Khusro    Added comma(,) in Client Name to show client name as LastName, FirstName and give white space after code name for stauts field 
--                                for primary care bugs and features task 336 
-- Feb 05 2014  Hussain Khusro    Added function "GetNoteTypeByClientId(ClientId))" to get Flags from ClientNotes table and to display on PC dashboard wrt task #120 Primary Care - Summit Pointe     
-- Mar 10 2014	Revathi			what:Added join with staffclients table to display associated clients for login staff 
--								why:Engineering Improvement Initiatives- NBL(I) task #77 My office List Pages should always have StaffID as an input parameter  
-- May 29 2014  Varun			Calling function "GetPCNoteTypeByClientId(ClientId))" to get only Finance related Flags from ClientNotes table to display in Schedule widget - task #143 Primary Care - Summit Pointe     
-- May 30 2014  Varun			Added NULL check for 'Sex' column task 1532- Core Bugs   
-- May 30 2014  Varun			Added NULL check for 'TypeId' column task 162- Primary Care - Summit Pointe   
-- June 30 2014	Wasif Butt		Added AppintmentId filter to match Documents.
-- July 07 2014 Gautam			Modify not to show cancelled appintments (Added 8042 (Cancelled) in status,
-- 04-02-2015		Vaibhav Khare   What added one more field "ScheduleWidgetStaff "for default Schedule widget 
--									Ref. to task Primary Care - Summit Pointe: #187 Calendar - Cancelled Appointments
-- 04-02-2015		Vaibhav Khare   What New ;logic for  widget staff setting
-- 20-08-2015		Varun   What: Commented the second select which was returning ScheduleWidgetStaff
-- 15.10.2015	 Revathi		  what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  
--									why:task #609, Network180 Customization 
/*********************************************************************/
BEGIN
	BEGIN TRY
		IF (@ScheduleStaffId = - 1)
		BEGIN
			SELECT @ScheduleStaffId = ISNULL(ScheduleWidgetStaff, -1)
			FROM staff
			WHERE StaffId = @StaffId
		END

		IF @ScheduleStaffId < 0
		BEGIN
			SET @ScheduleStaffId = @StaffId 
		END

		CREATE TABLE #StaffProxies(StaffId INT,
		ProxyForStaffId INT
		)

		INSERT INTO #StaffProxies
		SELECT StaffId, ProxyForStaffId FROM StaffProxies
		WHERE StaffId = @StaffId AND ISNULL(RecordDeleted, 'N') = 'N'

		UNION

		SELECT @StaffId, @StaffId

		SELECT AP.StartTime
			,CASE 
				WHEN AP.[Status] = 8038
					THEN GCS.CodeName + ' (' + GCFS.CodeName + ')'
				ELSE GCS.CodeName
				END AS STATUS
				--Added by Revathi  10/15/2015      
			,CASE 
				WHEN ISNULL(CL.ClientType, 'I') = 'I'
					THEN ISNULL(CL.LastName, '') + ', ' + ISNULL(CL.FirstName, '')
				ELSE ISNULL(CL.OrganizationName, '')
				END AS ClientName
			,CL.Sex AS Sex
			,CONVERT(VARCHAR, CL.DOB, 101) AS DOB
			,DATEDIFF(day, CL.DOB, GETDATE()) / 365 AS Age
			,ISNULL(GCAT.CodeName, ' ') AS AppointmentType
			,ISNULL(AP.[Description], '') AS Description
			,ISNULL(GCAT.Color, ' ') AS Color
			,ISNULL(ST.Initial, '') AS Initial
			,CL.ClientId
			,AP.AppointmentId
			,ISNULL((
					SELECT dbo.GetPCNoteTypeByClientId(AP.ClientId)
					), '') AS TypeId -- Added by Khusro wrt task #120 Primary Care - Summit Pointe
			,ISNULL(DOC.DocumentId, - 1) AS DocumentId
			,ISNULL(DOC.CurrentDocumentVersionId, - 1) AS CurrentDocumentVersionId
			,DOC.CurrentVersionStatus
			,DOC.EffectiveDate
			,CASE 
				WHEN DOC.CurrentVersionStatus = 21
					AND (DOC.AuthorId = @StaffId OR (SP.ProxyForStaffId = DOC.AuthorId AND SP.StaffId = @StaffId))
					--AND CAST(DOC.EffectiveDate AS DATE) = CAST(@CurrentDate AS DATE)
					THEN 'InProgress.png'
				WHEN DOC.CurrentVersionStatus = 21
					AND DOC.AuthorId != @StaffId
					--AND CAST(DOC.EffectiveDate AS DATE) = CAST(@CurrentDate AS DATE)
					THEN 'NonEditable.png'
				WHEN DOC.CurrentVersionStatus = 22 
					--AND CAST(DOC.EffectiveDate AS DATE) = CAST(@CurrentDate AS DATE)
					THEN 'signed.png'
				WHEN DOC.DocumentCodeId IS NULL AND (AP.StaffId = @StaffId OR (SP.ProxyForStaffId = AP.StaffId AND SP.StaffId = @StaffId))
					THEN 'New.png'
				ELSE 'NonEditable.png'
				END AS [Image]
			,CASE 
				WHEN DOC.CurrentVersionStatus = 21
					AND DOC.AuthorId != 1
					THEN 'Auto'
				ELSE 'hand'
				END AS [Cursor]
			,ISNULL(DP.TemplateID, - 1) AS TemplateID
			,CASE 
				WHEN DOC.CurrentVersionStatus = 21
					AND (DOC.AuthorId = @StaffId OR (SP.ProxyForStaffId = DOC.AuthorId AND SP.StaffId = @StaffId))
					--AND CAST(DOC.EffectiveDate AS DATE) = CAST(@CurrentDate AS DATE)
					--AND CAST(DOC.EffectiveDate AS DATE) = CAST(@CurrentDate AS DATE)
					THEN 'Quick Note- In Progress, click here to edit'
				WHEN DOC.CurrentVersionStatus = 21
					AND DOC.AuthorId != @StaffId
					--AND CAST(DOC.EffectiveDate AS DATE) = CAST(@CurrentDate AS DATE)
					THEN 'Quick Note- InProgress by Another Staff'
				WHEN DOC.CurrentVersionStatus = 22
					--AND CAST(DOC.EffectiveDate AS DATE) = CAST(@CurrentDate AS DATE)
					THEN 'Quick Note- Signed, click here to view'
				WHEN DOC.DocumentCodeId IS NULL AND (AP.StaffId = @StaffId OR (SP.ProxyForStaffId = AP.StaffId AND SP.StaffId = @StaffId))
					THEN 'Quick Note- click here to create'
				ELSE 'Quick Note'
				END AS [Title]
		FROM Appointments AP
		INNER JOIN clients CL ON CL.ClientId = AP.ClientId
		INNER JOIN Staff ST ON ST.StaffId = AP.StaffId
		INNER JOIN StaffClients SC ON SC.ClientId = cl.ClientId
			AND SC.StaffId = AP.StaffId
		LEFT JOIN GlobalCodes GCAT ON AP.AppointmentType = GCAT.GlobalCodeId
		LEFT JOIN GlobalCodes GCS ON AP.[Status] = GCS.GlobalCodeId
		LEFT JOIN GlobalCodes GCFS ON GCFS.GlobalCodeId = AP.ExamRoom
		LEFT JOIN Documents DOC ON DOC.AppointmentId = AP.AppointmentId
			AND CAST(DOC.EffectiveDate AS DATE) = CAST(GETDATE() AS DATE)
			AND ISNULL(DOC.RecordDeleted, 'N') = 'N'
		LEFT JOIN DocumentProgressNotes DP ON DP.DocumentVersionId = DOC.CurrentDocumentVersionId
		LEFT JOIN #StaffProxies SP ON SP.StaffId = @StaffId AND SP.ProxyForStaffId = AP.StaffId
		WHERE (AP.StaffId = CASE 
				WHEN @ScheduleStaffId = NULL
					OR @ScheduleStaffId = 0
					THEN ST.StaffId
				ELSE @ScheduleStaffId
				END 
				--OR
				--(SP.ProxyForStaffId = @ScheduleStaffId AND SP.StaffId = @StaffId)
				)
			AND CAST(AP.StartTime AS DATE) = CAST(@CurrentDate AS DATE)
			AND AP.STATUS NOT IN (
				8042
				,8044
				,8045
				) -- 8044 Reshedule , 8045 - Error ,8042 (Cancelled   )			
			AND ISNULL(AP.RecordDeleted, 'N') = 'N'
			--SELECT @ScheduleStaffId AS ScheduleWidgetStaff
			--FROM staff
			--WHERE StaffId = @StaffId
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
		+ CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' 
		+ ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetPCScheduleAppointments')
		 + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' 
		 + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' 
		 + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.    
				16
				,-- Severity.    
				1 -- State.    
				);
	END CATCH

	RETURN
END
GO

