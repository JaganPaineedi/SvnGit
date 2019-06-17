
GO

/****** Object:  StoredProcedure [dbo].[ssp_CCRSCMessageService]    Script Date: 06/09/2015 02:36:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CCRSCMessageService]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CCRSCMessageService]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_CCRSCMessageService]    Script Date: 06/09/2015 02:36:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================      
-- Author:  Pradeep      
-- Create date: Sept 19, 2014      
-- Description: Retrieves CCR Message      
/*      
 Author			Modified Date			Reason      
 Pradeep.A		09/26/2014				Added logic to update the ExportedDate in TransitionofCareDocuments table
      
*/
-- =============================================      
CREATE PROCEDURE [dbo].[ssp_CCRSCMessageService] @DocumentVersionId BIGINT
	,@StaffId BIGINT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ClientId BIGINT

	SELECT @ClientId = D.ClientId
	FROM DocumentVersions DV
	INNER JOIN Documents D ON D.InProgressDocumentVersionId = DV.DocumentVersionId
	WHERE DV.DocumentVersionId = @DocumentVersionId

	UPDATE TransitionOfCareDocuments
	SET ExportedDate = GetDate()
	WHERE DocumentVersionId = @DocumentVersionId
		AND ISNULL(RecordDeleted, 'N') = 'N'

	--Main
	SELECT CAST(NEWID() AS VARCHAR(50)) AS CCRDocumentObjectID
		,'English' AS LANGUAGE
		,'V1.0' AS Version
		,'CCR Creation DateTime' AS [DateTime_Type]
		,replace(replace(replace(convert(varchar(19), getdate(), 126),'-',''),'T',''),':','')AS DateTime_ApproximateDateTime
		,'Patient.' + CAST(@ClientId AS VARCHAR(100)) AS ActorID
		,'Patient' AS ActorRole
		,'For the patient' AS Purpose_Description;

	--FromStaff
	----SELECT 'Staff.' + CAST(@StaffId AS VARCHAR(100)) AS ActorID
	----	,CAST(@StaffId AS VARCHAR(100)) AS ID1_ActorID
	----	,'Provider' AS ActorRole
	----	,ISNULL(LastName, '') AS Current_Family
	----	,ISNULL(FirstName, '') AS Current_Given
	----	,ISNULL(MiddleName, '') AS Current_Middle
	----	,CASE 
	----		WHEN lastname IS NULL
	----			THEN ''
	----		ELSE ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '')
	----		END AS Current_DisplayName
	----	,'' AS From_Actor_Title
	----	,ISNULL(CONVERT(VARCHAR(10), DOB, 21), '') AS DOB_ApproximateDateTime
	----	,CASE sex
	----		WHEN 'F'
	----			THEN 'Female'
	----		WHEN 'M'
	----			THEN 'Male'
	----		ELSE 'Unknown'
	----		END AS Gender
	----	,ISNULL(Email, '') AS CT1_Email_Value
	----	,'' AS ActorSpecialty
	----	,'Staff ID' AS ID1_IDType
	----	,'SmartCareEHR4.0' AS ID1_Source_ActorID
	----	,'SmartCareEHR4.0' AS SLRCGroup_Source_ActorID
	----	,'EHR' AS ID1_Source_ActorRole
	----FROM staff
	----WHERE StaffId = @StaffId;

SELECT 'Staff.' + CAST(sa.staffid AS VARCHAR(100)) AS ActorID
		,CAST(sa.staffid AS VARCHAR(100)) AS ID1_ActorID
		,'Provider' AS ActorRole
		,ISNULL(sa.LastName, '') AS Current_Family
		,ISNULL(sa.FirstName, '') AS Current_Given
		,ISNULL(sa.MiddleName, '') AS Current_Middle
		,CASE 
			WHEN sa.lastname IS NULL
				THEN ''
			ELSE ISNULL(sa.FirstName, '') + ' ' + ISNULL(sa.LastName, '')
			END AS Current_DisplayName
		,'' AS From_Actor_Title
		,ISNULL(CONVERT(VARCHAR(10), sa.DOB, 21), '') AS DOB_ApproximateDateTime
		,CASE sa.sex
			WHEN 'F'
				THEN 'Female'
			WHEN 'M'
				THEN 'Male'
			ELSE 'Unknown'
			END AS Gender
		,ISNULL(sa.Email, '') AS CT1_Email_Value
		,'' AS ActorSpecialty
		,'Staff ID' AS ID1_IDType
		,'SmartCareEHR4.0' AS ID1_Source_ActorID
		,'SmartCareEHR4.0' AS SLRCGroup_Source_ActorID
		,'EHR' AS ID1_Source_ActorRole
		,ISNULL(sp.LastName, '') AS Staff1_Family
		,ISNULL(sp.FirstName, '') AS Staff1_Given
		,ISNULL(sp.Address, '') AS STAFF1ADDRESS
		,ISNULL(sp.City, '') AS STAFF1CITY
		,ISNULL(sp.Zip, '') AS Staff1ZIP
		,ISNULL(sp.State, '') AS STAFF1STATE
		
		,ISNULL(sc.LastName, '') AS Staff2_Family
		,ISNULL(sc.FirstName, '') AS Staff2_Given
		,ISNULL(sc.Address, '') AS STAFF2ADDRESS
		,ISNULL(sc.City, '') AS STAFF2CITY
		,ISNULL(sc.Zip, '') AS Staff2ZIP
		,ISNULL(sc.State, '') AS STAFF2STATE
		
	FROM clients C
	inner join staffclients s on s.clientid = c.clientid and s.staffid = 1
	left join staff sa on sa.staffid  = s.staffid 
	left join staff sc on sc.staffid = c.PrimaryClinicianId
	left join staff sp on sp.staffid = c.PrimaryPhysicianId
	WHERE c.clientid = @ClientId
	
	--FromOrganization
	SELECT TOP (1) REPLACE(A.AgencyName, ' ', '_') AS ActorID
		,A.AgencyName AS DisplayName
		,'Organization' AS ActorRole
		,'SmartCareEHR4.0' AS SLRCGroup_Source_ActorID
		,A.Address AS SLRCGroup_Source_ActorAddress
		,A.City AS SLRCGroup_Source_ActorCity
		,A.State AS SLRCGroup_Source_ActorState
		,A.ZipCode AS SLRCGroup_Source_PostalCode
		,'US' AS SLRCGroup_Source_CountryCode
		,A.BillingPhone AS SLRCGroup_Source_Telephone_Value
		
				
	FROM dbo.Agency A;
	--FromInfoSystem
	SELECT 'SmartCareEHR4.0' AS ActorID
		,'Client Medical Record' AS DisplayName
		,'InformationSystem' AS ActorRole
		,'SmartCareEHR4.0' AS SLRCGroup_Source_ActorID

	--To
	SELECT TOP (0) '' AS ActorID
		,'' AS ActorRole;

	--EXEC ssp_CCRCSGetClientInfo @ClientId --(PatientInfo)

	EXEC ssp_CCRCSGetMedicationAlertServiceSummary @ClientId --(Allergies)
		,NULL

	EXEC ssp_CCRSCGetMedicationListServiceSummary @ClientId -- (Medications)
		,NULL
		,NULL

	EXEC ssp_CCRCSGetProblemListSummary @ClientId -- (Problems)
		,NULL
		,@DocumentVersionId

	EXEC ssp_CCRCSGetProcedureListServiceSummary @ClientId --(Procedures)
		,NULL
		,@DocumentVersionId

	EXEC ssp_CCRCSGetResultReviewdVisit @ClientId -- (Results)
		,NULL
		,@DocumentVersionId

	EXEC ssp_CCRCSEncounters @ClientId -- (Encounters)
		,NULL
		,@DocumentVersionId

	--EXEC ssp_CCRCSGetLabResultsVitalsSmokeSummary @ClientId -- (ResultVitalsSmoke)
	--	,NULL
	--	,@DocumentVersionId

	EXEC ssp_CCRCSGetImmunizations @ClientId -- (Immunizations)
		,NULL
		,@DocumentVersionId

	EXEC ssp_CCRCSGetLabResultsServiceSummary @ClientId -- (ResultVitals)
		,NULL
		,@DocumentVersionId

	EXEC ssp_CCRCSReasonforVisit @ClientId -- (ReasonforVisit)
		,NULL
		,@DocumentVersionId

	EXEC ssp_CCRSCReasonforReferral @ClientId -- (ReasonforReferral)
		,NULL
		,@DocumentVersionId
	
	--EXEC ssp_CCRSCPlanofCare @ClientId -- (PlanofCare)
	--	,NULL
	--	,@DocumentVersionId

	EXEC ssp_CCRCSMedicationAdministrated @ClientId -- (MedicationAdministrated)
		,NULL
		,@DocumentVersionId

	--EXEC ssp_CCRCSInstructions @ClientId -- (Instructions)
	--	,NULL
	--	,@DocumentVersionId
END


GO

