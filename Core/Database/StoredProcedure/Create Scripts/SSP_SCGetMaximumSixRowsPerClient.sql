IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetMaximumSixRowsPerClient]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_SCGetMaximumSixRowsPerClient]
GO

CREATE PROCEDURE [dbo].[SSP_SCGetMaximumSixRowsPerClient] @GroupServiceID INT
	,@StaffId INT
	/****************************************************************************/
	/* Stored Procedure:SSP_SCGetMaximumSixRowsPerClient                        */
	/* Copyright: 2006 Streamlin Healthcare Solutions                           */
	/* Creation Date:  May 8, 2009												 */
	/* Purpose: Its purpose is to return maximum 6 services for each client	 */
	/* Input Parameters: @GroupId ,@GroupServiceId                              */
	/* Output Parameters:None                                                   */
	/* Return:    it will return a Table with each client maximum 6 services    */
	/* Calls:From [ssp_SCGetGroupServiceDetail]								 */
	/* Data Modifications:                                                      */
	/* Updates:																 */
	/*  Date			Author				Purpose                                       */
	/*  ------------------------------------------------------------------------*/
	/*  16 Jan 2015		Avi Goyal			What : Changed NoteType Join to FlagTypes & applied Permissioned & display checks   */
	/*										Why : Task # 600 Securiry Alerts ; Project : Network-180 Customizations   */
	/*  20 Oct 2015		Revathi				what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */
/*											why:task #609, Network180 Customization   */
	/*********************************************************************/
AS
WITH CTE
AS (
	SELECT ROW_NUMBER() OVER (
			PARTITION BY S.ClientId ORDER BY S.ClientId DESC
			) AS 'RowNo'
		,'D' AS DeleteButton
		,'R' AS RadioButton
		
		-- Modified by  Revathi 20 Oct 2015 
		,case when  ISNULL(C.ClientType,'I')='I' then ISNULL(C.LastName,'') + ', ' + ISNULL(C.FirstName,'') else ISNULL(C.OrganizationName,'') end  AS ClientName
		,GS.GroupId
		,CN.NoteType
		,
		--GC.Bitmap,			-- Commented by Avi Goyal, on 16 Jan 2015 
		FT.Bitmap
		,-- Added by Avi Goyal, on 16 Jan 2015                                                                                        
		S.ServiceId
		,S.ClientId
		,S.GroupServiceId
		,S.ProcedureCodeId
		,S.DateOfService
		,S.DateTimeIn
		,S.DateTimeOut
		,S.EndDateOfService
		,S.Unit
		,S.UnitType
		,S.STATUS
		,S.CancelReason
		,S.ProviderId
		,S.ClinicianId
		,S.AttendingId
		,S.ProgramId
		,s.LocationId
		,S.Billable
		--,S.DiagnosisCode1
		--,S.DiagnosisNumber1
		--,S.DiagnosisVersion1
		--,S.DiagnosisCode2
		--,S.DiagnosisNumber2
		--,s.DiagnosisVersion2
		--,S.DiagnosisCode3
		--,S.DiagnosisNumber3
		--,S.DiagnosisVersion3
		,S.ClientWasPresent
		,S.OtherPersonsPresent
		,S.AuthorizationsApproved
		,S.AuthorizationsNeeded
		,S.AuthorizationsRequested
		,S.NumberOfTimesCancelled
		,S.Charge
		,S.NumberOfTimeRescheduled
		,S.ProcedureRateId
		,S.DoNotComplete
		,S.Comment
		,--S.RowIdentifier ,S.ExternalReferenceId ,                                                                                            
		S.CreatedBy
		,S.CreatedDate
		,S.ModifiedBy
		,S.ModifiedDate
		,S.RecordDeleted
		,S.DeletedDate
		,s.DeletedBy
		,ServiceErrors.ServiceErrorId
		,ServiceErrors.ErrorMessage
		,Documents.DocumentId
		,Documents.[Status] AS DocStatus
		--,GC.CodeName as CodeName      -- Commented by Avi Goyal, on 16 Jan 2015 
		,FT.FlagType AS CodeName -- Added by Avi Goyal, on 16 Jan 2015 
		,Documents.CurrentDocumentVersionId AS CurrentVersion
		,Documents.DocumentCodeId AS DocumentCodeId
		,DocumentVersions.DocumentVersionId AS DocumentVersionId
	FROM services S
	LEFT JOIN groupservices GS ON S.GroupServiceId = GS.GroupServiceId
	LEFT JOIN Groups ON GS.GroupId = Groups.GroupId
	LEFT JOIN Clients C ON S.ClientID = C.ClientID
	LEFT JOIN ServiceErrors ON S.ServiceId = ServiceErrors.ServiceId
	LEFT JOIN ClientNotes CN ON S.ClientId = CN.ClientID
	--left outer join GlobalCodes GC on CN.notetype=GC.globalcodeid     -- Commented by Avi Goyal, on 16 Jan 2015
	-- Added by Avi Goyal, on 16 Jan 2015
	LEFT JOIN FlagTypes FT ON FT.FlagTypeId = CN.NoteType
		AND ISNULL(FT.RecordDeleted, 'N') = 'N'
		AND ISNULL(FT.DoNotDisplayFlag, 'N') = 'N'
		AND (
			ISNULL(FT.PermissionedFlag, 'N') = 'N'
			OR (
				ISNULL(FT.PermissionedFlag, 'N') = 'Y'
				AND (
					(
						EXISTS (
							SELECT 1
							FROM PermissionTemplateItems PTI
							INNER JOIN PermissionTemplates PT ON PT.PermissionTemplateId = PTI.PermissionTemplateId
								AND ISNULL(PT.RecordDeleted, 'N') = 'N'
								AND dbo.ssf_GetGlobalCodeNameById(PT.PermissionTemplateType) = 'Flags'
							INNER JOIN StaffRoles SR ON SR.RoleId = PT.RoleId
								AND ISNULL(SR.RecordDeleted, 'N') = 'N'
							WHERE ISNULL(PTI.RecordDeleted, 'N') = 'N'
								AND PTI.PermissionItemId = FT.FlagTypeId
								AND SR.StaffId = @StaffId
							)
						OR EXISTS (
							SELECT 1
							FROM StaffPermissionExceptions SPE
							WHERE SPE.StaffId = @StaffId
								AND ISNULL(SPE.RecordDeleted, 'N') = 'N'
								AND dbo.ssf_GetGlobalCodeNameById(SPE.PermissionTemplateType) = 'Flags'
								AND SPE.PermissionItemId = FT.FlagTypeId
								AND SPE.Allow = 'Y'
								AND (
									SPE.StartDate IS NULL
									OR CAST(SPE.StartDate AS DATE) <= CAST(GETDATE() AS DATE)
									)
								AND (
									SPE.EndDate IS NULL
									OR CAST(SPE.EndDate AS DATE) >= CAST(GETDATE() AS DATE)
									)
							)
						)
					AND NOT EXISTS (
						SELECT 1
						FROM StaffPermissionExceptions SPE
						WHERE SPE.StaffId = @StaffId
							AND ISNULL(SPE.RecordDeleted, 'N') = 'N'
							AND dbo.ssf_GetGlobalCodeNameById(SPE.PermissionTemplateType) = 'Flags'
							AND SPE.PermissionItemId = FT.FlagTypeId
							AND SPE.Allow = 'N'
							AND (
								SPE.StartDate IS NULL
								OR CAST(SPE.StartDate AS DATE) <= CAST(GETDATE() AS DATE)
								)
							AND (
								SPE.EndDate IS NULL
								OR CAST(SPE.EndDate AS DATE) >= CAST(GETDATE() AS DATE)
								)
						)
					)
				)
			)
	LEFT JOIN Documents ON Documents.ServiceId = S.ServiceId
	LEFT JOIN DocumentVersions ON Documents.DocumentId = DocumentVersions.DocumentId
	WHERE S.groupserviceid = @GroupServiceID
		AND ISNULL(GS.RecordDeleted, 'N') = 'N'
		AND ISNULL(S.RecordDeleted, 'N') = 'N'
		AND ISNULL(C.RecordDeleted, 'N') = 'N'
		AND ISNULL(Groups.RecordDeleted, 'N') = 'N'
	)
SELECT DeleteButton
	,RadioButton
	,ClientName
	,GroupId
	,NoteType
	,Bitmap
	,ServiceId
	,ClientId
	,GroupServiceId
	,ProcedureCodeId
	,DateOfService
	,DateTimeIn
	,DateTimeOut
	,EndDateOfService
	,Unit
	,UnitType
	,STATUS
	,CancelReason
	,ProviderId
	,ClinicianId
	,AttendingId
	,ProgramId
	,LocationId
	,Billable
	--,DiagnosisCode1
	--,DiagnosisNumber1
	--,DiagnosisVersion1
	--,DiagnosisCode2
	--,DiagnosisNumber2
	--,DiagnosisVersion2
	--,DiagnosisCode3
	--,DiagnosisNumber3
	--,DiagnosisVersion3
	,ClientWasPresent
	,OtherPersonsPresent
	,AuthorizationsApproved
	,AuthorizationsNeeded
	,AuthorizationsRequested
	,NumberOfTimesCancelled
	,Charge
	,NumberOfTimeRescheduled
	,ProcedureRateId
	,DoNotComplete
	,Comment
	,
	--RowIdentifier ,ExternalReferenceId ,                                                                                          
	CreatedBy
	,CreatedDate
	,ModifiedBy
	,ModifiedDate
	,RecordDeleted
	,DeletedDate
	,DeletedBy
	,ServiceErrorId
	,ErrorMessage
	,DocumentId
	,DocStatus
	,CodeName
	,CurrentVersion
	,DocumentCodeId
	,DocumentVersionId
FROM CTE
WHERE RowNo <= 6
GO

