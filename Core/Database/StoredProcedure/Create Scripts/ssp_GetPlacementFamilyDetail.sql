/****** Object:  StoredProcedure [dbo].[ssp_GetPlacementFamilyDetail]    Script Date: 02/03/2015 01:57:48 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetPlacementFamilyDetail]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetPlacementFamilyDetail]
GO

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[ssp_GetPlacementFamilyDetail] @PlacementFamilyID INT
	/*********************************************************************/
	/* Stored Procedure: dbo.ssp_GetPlacementFamilyDetail     */
	/* Creation Date:  30/10/2012                                            */
	/*                                                                       */
	/* Purpose: To Bind Foster Referral List Page            
                  */
	/*                                                                   */
	/* Input Parameters: @FosterReferralId        */
	/*                                                                   */
	/* Output Parameters:             */
	/*                                                                   */
	/*  Date                  Author                 Purpose             */
	/* 30/10/2012             PSelvan				 Created             */
	/* 15/10/2015             R.M.Manikandan         Modified what:Inserting Data in this two table,ImageRecordItems,ImageRecords why: Pathway - Customizations task #1*/
	/* 12-11-15               Veena                  Task #2 Family & Children Services Customization  Added  PlacementFamilyId,Family name to add a link to Placement Family  */  

	/*********************************************************************/
AS
BEGIN
	BEGIN TRY
		SELECT PlacementFamilyId
			,FamilyName
			,STATUS
			,DateOfInitialLicensure
			,License
			,DoNotPlace
			,NotContractedFamily
			,Address1
			,Address2
			,City
			,STATE
			,Zip
			,AddressDisplay
			,Phone1Type
			,Phone1Number
			,Phone2Type
			,Phone2Number
			,Phone3Type
			,Phone3Number
			,InterestedInFosterCare
			,AgeFrom
			,AgeTo
			,Teens
			,SibblingGroup
			,MedicalNeed
			,MaxChild
			,PF.Comment
			,PF.CreatedBy
			,PF.CreatedDate
			,PF.ModifiedBy
			,PF.ModifiedDate
			,PF.RecordDeleted
			,PF.DeletedDate
			,PF.DeletedBy
			,'CurrentPlacement' = (
				SELECT Count(CFC.FosterChildId)
				FROM FosterPlacements CFP
				INNER JOIN PlacementFamilies CPF ON CFP.PlacementFamilyId = CPF.PlacementFamilyId
				INNER JOIN FosterChildren AS CFC ON CFC.FosterChildId = CFP.FosterChildId
				WHERE CPF.PlacementFamilyId = @PlacementFamilyID
				)
	     --Added by Veena  #2 Family & Children Services Customization
			,PF.LinkedProviderId
			,P.ProviderName
		FROM dbo.PlacementFamilies PF
		LEFT JOIN Providers P on PF.LinkedProviderId=P.ProviderId 
		WHERE ISNULL(PF.RecordDeleted, 'N') = 'N'
			AND (PlacementFamilyId = @PlacementFamilyID)

		SELECT CPFC.PlacementFamilyCareGiverId
			,CPFC.LastName
			,CPFC.FirstName
			,CPFC.DOB
			,CPFC.Sex
			,CPFC.Race
			,CPFC.SSN
			,CPFC.Phone
			,CPFC.Relation
			,CPFC.IdentifiedAdoptiveParent
			,CPFC.PlacementFamilyId
			,CPFC.CreatedBy
			,CPFC.CreatedDate
			,CPFC.ModifiedBy
			,CPFC.ModifiedDate
			,CPFC.RecordDeleted
			,CPFC.DeletedDate
			,CPFC.DeletedBy
		FROM dbo.PlacementFamilies CPF
		INNER JOIN PlacementFamilyCareGivers CPFC ON CPF.PlacementFamilyId = CPFC.PlacementFamilyId
		WHERE (
				CPF.RecordDeleted = 'N'
				OR CPF.RecordDeleted IS NULL
				)
			AND (
				CPFC.RecordDeleted = 'N'
				OR CPFC.RecordDeleted IS NULL
				)
			AND (CPF.PlacementFamilyId = @PlacementFamilyId)

		SELECT CPFT.PlacementFamilyTypeId
			,CPFT.PlacementFamilyId
			,CPFT.FamilyType
			,CPFT.CreatedBy
			,CPFT.CreatedDate
			,CPFT.ModifiedBy
			,CPFT.ModifiedDate
			,CPFT.RecordDeleted
			,CPFT.DeletedBy
			,CPFT.DeletedDate
		FROM PlacementFamilies CPF
		INNER JOIN PlacementFamilyTypes CPFT ON CPF.PlacementFamilyId = CPFT.PlacementFamilyId
		WHERE (
				CPF.RecordDeleted = 'N'
				OR CPF.RecordDeleted IS NULL
				)
			AND (
				CPFT.RecordDeleted = 'N'
				OR CPFT.RecordDeleted IS NULL
				)
			AND (CPF.PlacementFamilyId = @PlacementFamilyID)

		SELECT CPFCA.PlacementFamilyChildAdoptionId
			,CPFCA.CreatedBy
			,CPFCA.CreatedDate
			,CPFCA.ModifiedBy
			,CPFCA.ModifiedDate
			,CPFCA.RecordDeleted
			,CPFCA.DeletedDate
			,CPFCA.DeletedBy
			,CPFCA.PlacementFamilyId
			,CPFCA.FosterChildId
			,CPFCA.FosterReferralId
			,CFC.LastName + ', ' + CFC.FirstName + ' ' + CASE CFC.DOB
				WHEN NULL
					THEN ''
				ELSE '(' + CONVERT(VARCHAR, CFC.DOB, 101) + ')'
				END AS ChildName
		FROM PlacementFamilies AS CPF
		INNER JOIN FosterPlacementFamilyChildAdoptions AS CPFCA ON CPF.PlacementFamilyId = CPFCA.PlacementFamilyId
		INNER JOIN FosterChildren CFC ON CFC.FosterChildId = CPFCA.FosterChildId
		WHERE (
				CPF.RecordDeleted = 'N'
				OR CPF.RecordDeleted IS NULL
				)
			AND (
				CPFCA.RecordDeleted = 'N'
				OR CPFCA.RecordDeleted IS NULL
				)
			AND (CPF.PlacementFamilyId = @PlacementFamilyID)

		SELECT CPFCR.PlacementFamilyChildRelationId
			,CPFCR.CreatedBy
			,CPFCR.CreatedDate
			,CPFCR.ModifiedBy
			,CPFCR.ModifiedDate
			,CPFCR.RecordDeleted
			,CPFCR.DeletedDate
			,CPFCR.DeletedBy
			,CPFCR.PlacementFamilyId
			,CPFCR.FosterChildId
			,CPFCR.FosterReferralId
			,CFC.LastName + ', ' + CFC.FirstName + ' ' + CASE CFC.DOB
				WHEN NULL
					THEN ''
				ELSE '(' + CONVERT(VARCHAR, CFC.DOB, 101) + ')'
				END AS ChildName
		FROM PlacementFamilies AS CPF
		INNER JOIN FosterPlacementFamilyChildRelations AS CPFCR ON CPF.PlacementFamilyId = CPFCR.PlacementFamilyId
		INNER JOIN FosterChildren CFC ON CFC.FosterChildId = CPFCR.FosterChildId
		WHERE (
				CPF.RecordDeleted = 'N'
				OR CPF.RecordDeleted IS NULL
				)
			AND (
				CPFCR.RecordDeleted = 'N'
				OR CPFCR.RecordDeleted IS NULL
				)
			AND (CPF.PlacementFamilyId = @PlacementFamilyID)

		-- 15/10/2015 R.M.Maniknadan Changes Start 
		/*ImageRecords For Placement Family Attachments*/
		SELECT IR.ImageRecordId
			,IR.CreatedBy
			,IR.CreatedDate
			,IR.ModifiedBy
			,IR.ModifiedDate
			,IR.RecordDeleted
			,IR.DeletedDate
			,IR.DeletedBy
			,IR.ScannedOrUploaded
			,IR.DocumentVersionId
			,IR.ImageServerId
			,IR.ClientId
			,IR.AssociatedId
			,IR.AssociatedWith
			,IR.RecordDescription
			,IR.EffectiveDate
			,IR.NumberOfItems
			,IR.AssociatedWithDocumentId
			,IR.AppealId
			,IR.StaffId
			,IR.EventId
			,IR.ProviderId
			,IR.TaskId
			,IR.AuthorizationDocumentId
			,IR.ScannedBy
			,IR.CoveragePlanId
			,IR.ClientDisclosureId
		FROM ImageRecords IR
		INNER JOIN PlacementFamilyImageRecords PF ON IR.ImageRecordId = PF.ImageRecordId
		WHERE PF.PlacementFamilyId = @PlacementFamilyID
			AND ISNULL(IR.RecordDeleted, 'N') = 'N'
			AND ISNULL(PF.RecordDeleted, 'N') <> 'Y'

		/*ImageRecordItems For Placement Family Attachments*/
		--SELECT IRI.ImageRecordItemId
		--	,IRI.ImageRecordId
		--	,IRI.ItemNumber
		--	,IRI.ItemImage
		--	,IRI.RowIdentifier
		--	,IRI.CreatedBy
		--	,IRI.CreatedDate
		--	,IRI.ModifiedBy
		--	,IRI.ModifiedDate
		--	,IRI.RecordDeleted
		--	,IRI.DeletedDate
		--	,IRI.DeletedBy
		--	,IR.ImageRecordId
		--	,IR.CreatedBy
		--	,IR.CreatedDate
		--	,IR.ModifiedBy
		--	,IR.ModifiedDate
		--	,IR.RecordDeleted
		--	,IR.DeletedDate
		--	,IR.DeletedBy
		--	,IR.ScannedOrUploaded
		--	,IR.DocumentVersionId
		--	,IR.ImageServerId
		--	,IR.ClientId
		--	,IR.AssociatedId
		--	,IR.AssociatedWith
		--	,IR.RecordDescription
		--	,IR.EffectiveDate
		--	,IR.NumberOfItems
		--	,IR.AssociatedWithDocumentId
		--	,IR.AppealId
		--	,IR.StaffId
		--	,IR.EventId
		--	,IR.ProviderId
		--	,IR.TaskId
		--	,IR.AuthorizationDocumentId
		--	,IR.ScannedBy
		--	,IR.CoveragePlanId
		--	,IR.ClientDisclosureId
		--FROM ImageRecordItems IRI
		--INNER JOIN ImageRecords IR ON IR.ImageRecordId = IRI.ImageRecordId
		--INNER JOIN PlacementFamilyImageRecords PFR ON IR.ImageRecordId = PFR.ImageRecordId
		--WHERE PFR.PlacementFamilyId = @PlacementFamilyID
		--	AND ISNULL(IR.RecordDeleted, 'N') = 'N'
		--	AND ISNULL(IR.RecordDeleted, 'N') <> 'Y'
		--	AND ISNULL(IRI.RecordDeleted, 'N') <> 'Y'
			-- 15/10/2015 Changes End 
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetPlacementFamilyDetail') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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

