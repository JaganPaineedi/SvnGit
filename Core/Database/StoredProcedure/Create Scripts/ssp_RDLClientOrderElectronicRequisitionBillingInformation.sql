/****** Object:  StoredProcedure [dbo].[ssp_RDLClientOrderElectronicRequisitionBillingInformation]    Script Date: 01/29/2019 10:51:17 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClientOrderElectronicRequisitionBillingInformation]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE dbo.ssp_RDLClientOrderElectronicRequisitionBillingInformation
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLClientOrderElectronicRequisitionBillingInformation]    Script Date: 01/29/2019 10:51:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLClientOrderElectronicRequisitionBillingInformation] (@DocumentVersionId INT)
	/********************************************************************************************************     
    Report Request:     
     Details ... Gulf Bend - Enhancements > Tasks #211 > CPL - Add Lab  
  
             
    Purpose:  
    Parameters: DocumentVersionId  
    Modified Date   Modified By   Reason     
    ----------------------------------------------------------------     
    Ravi      21/11/2018   Created  Gulf Bend - Enhancements > Tasks #211> CPL - Add Lab  
    ************************************************************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @ClientId INT
			,@EffectiveDate DATETIME
			,@DOB DATETIME
			,@ClientName VARCHAR(100)

		SELECT @ClientId = D.ClientId
			,@EffectiveDate = D.EffectiveDate
			,@DOB = C.DOB
			,@ClientName = C.LastName + ', ' + C.FirstName
		FROM Documents D
		JOIN DocumentVersions DV ON DV.DocumentId = D.DocumentId
		JOIN Clients C ON C.ClientId = D.ClientId
		WHERE DV.DocumentVersionId = @DocumentVersionId
			AND ISNULL(D.RecordDeleted, 'N') = 'N'
			AND ISNULL(DV.RecordDeleted, 'N') = 'N'

		DECLARE @PrimaryNameOfInsurance VARCHAR(250)
			,@PrimaryInsuranceAddress VARCHAR(500)
			,@PrimaryInsuranceCityStateZip VARCHAR(max)
			,@PrimaryInsuredId VARCHAR(25)
			,@PrimaryGroupName VARCHAR(100)
			,@PrimaryGroupNumber VARCHAR(35)
			,@PrimaryClientIsSubscriber CHAR(1)
			,@PrimarySubscriberContactId INT
		DECLARE @SecondaryNameOfInsurance VARCHAR(250)
			,@SecondaryInsuranceAddress VARCHAR(500)
			,@SecondaryInsuranceCityStateZip VARCHAR(max)
			,@SecondaryInsuredId VARCHAR(25)
			,@SecondaryGroupName VARCHAR(100)
			,@SecondaryGroupNumber VARCHAR(35)
			,@SecondaryClientIsSubscriber CHAR(1)
			,@SecondarySubscriberContactId INT
		DECLARE @InsuranceInformation TABLE (
			NameOfInsurance VARCHAR(250)
			,InsuranceAddress VARCHAR(500)
			,CityStateZip VARCHAR(max)
			,Insured VARCHAR(25)
			,GroupNumber VARCHAR(35)
			,GroupName VARCHAR(100)
			,ClientIsSubscriber CHAR(1)
			,SubscriberContactId INT
			,Row INT
			);

		WITH InsuranceDetail
		AS (
			SELECT TOP 2 CP.DisplayAs AS NameOfInsurance
				,CP.AddressDisplay AS InsuranceAddress
				,ISNULL(CP.City + ', ', '') + ISNULL(CP.STATE + ', ', '') + ISNULL(CP.ZipCode, '') AS CityStateZip
				,CCP.InsuredId AS Insured
				,CCP.GroupNumber
				,GroupName
				,ClientIsSubscriber
				,SubscriberContactId
				,ROW_NUMBER() OVER (
					PARTITION BY CCH.COBOrder ORDER BY CCH.COBOrder
					) AS ROW
			FROM ClientCoverageHistory CCH
			JOIN ClientCoveragePlans CCP ON CCP.ClientCoveragePlanId = CCH.ClientCoveragePlanId
			JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId
			WHERE ClientId = @ClientId
				AND IsNull(CCP.RecordDeleted, 'N') = 'N'
				AND IsNull(CP.RecordDeleted, 'N') = 'N'
				AND IsNull(CCH.RecordDeleted, 'N') = 'N'
				AND CP.Active = 'Y'
				AND DATEDIFF(day, cch.StartDate, GETDATE()) >= 0
				AND (
					cch.EndDate IS NULL
					OR DATEDIFF(day, cch.EndDate, GETDATE()) <= 0
					)
			ORDER BY CCH.COBOrder ASC
			)
		INSERT INTO @InsuranceInformation (
			NameOfInsurance
			,InsuranceAddress
			,CityStateZip
			,Insured
			,GroupNumber
			,GroupName
			,ClientIsSubscriber
			,SubscriberContactId
			,Row
			)
		SELECT NameOfInsurance
			,InsuranceAddress
			,CityStateZip
			,Insured
			,GroupNumber
			,GroupName
			,ClientIsSubscriber
			,SubscriberContactId
			,Row
		FROM InsuranceDetail

		SELECT @PrimaryNameOfInsurance = NameOfInsurance
			,@PrimaryInsuranceAddress = InsuranceAddress
			,@PrimaryInsuredId = Insured
			,@PrimaryGroupName = GroupName
			,@PrimaryClientIsSubscriber = ClientIsSubscriber
			,@PrimarySubscriberContactId = SubscriberContactId
			,@PrimaryInsuranceCityStateZip = CityStateZip
			,@PrimaryGroupNumber = GroupNumber
		FROM @InsuranceInformation
		WHERE ROw = 1

		SELECT @SecondaryNameOfInsurance = NameOfInsurance
			,@SecondaryInsuranceAddress = InsuranceAddress
			,@SecondaryInsuredId = Insured
			,@SecondaryGroupName = GroupName
			,@SecondaryClientIsSubscriber = ClientIsSubscriber
			,@SecondarySubscriberContactId = SubscriberContactId
			,@SecondaryInsuranceCityStateZip = CityStateZip
			,@SecondaryGroupNumber = GroupNumber
		FROM @InsuranceInformation
		WHERE ROw = 2

		DECLARE @PrimaryInsured VARCHAR(150)
			,@SecondaryInsured VARCHAR(150)
			,@PrimaryInsuredAddress VARCHAR(500)
			,@PrimaryInsuredCityStateZip VARCHAR(500)
			,@SecondaryInsuredAddress VARCHAR(500)
			,@SecondaryInsuredCityStateZip VARCHAR(500)
			,@PrimaryInsuredRelation VARCHAR(250)
			,@SecondaryInsuredRelation VARCHAR(250)

		IF ISNULL(@PrimaryClientIsSubscriber, 'N') = 'Y'
		BEGIN
			SET @PrimaryInsured = @ClientName
			SET @PrimaryInsuredRelation = 'Self'

			SELECT TOP 1 @PrimaryInsuredAddress = CA.Display
			FROM ClientAddresses CA
			WHERE CA.ClientId = @ClientId
				AND ISNULL(CA.RecordDeleted, 'N') = 'N'
			ORDER BY AddressType ASC
		END
		ELSE IF ISNULL(@PrimaryClientIsSubscriber, 'N') = 'N'
		BEGIN
			SELECT @PrimaryInsured = CC.LastName + ', ' + CC.FirstName
				,@PrimaryInsuredRelation = dbo.GetGlobalCodeName(CC.Relationship)
			FROM ClientContacts CC
			WHERE CC.ClientContactId = @PrimarySubscriberContactId
				AND ISNULL(CC.RecordDeleted, 'N') = 'N'

			SELECT TOP 1 @PrimaryInsuredAddress = Display
			FROM ClientContactAddresses CCA
			WHERE CCA.ClientContactId = @PrimarySubscriberContactId
				AND ISNULL(CCA.RecordDeleted, 'N') = 'N'
			ORDER BY AddressType ASC
		END

		IF ISNULL(@SecondaryClientIsSubscriber, 'N') = 'Y'
		BEGIN
			SET @SecondaryInsured = @ClientName
			SET @SecondaryInsuredRelation = 'Self'

			SELECT @SecondaryInsuredAddress = CA.Display
			FROM ClientAddresses CA
			WHERE CA.ClientId = @ClientId
				AND ISNULL(CA.RecordDeleted, 'N') = 'N'
			ORDER BY AddressType ASC
		END
		ELSE IF ISNULL(@SecondaryClientIsSubscriber, 'N') = 'N'
		BEGIN
			SELECT @SecondaryInsured = CC.LastName + ', ' + CC.FirstName
				,@SecondaryInsuredRelation = dbo.GetGlobalCodeName(CC.Relationship)
			FROM ClientContacts CC
			WHERE CC.ClientContactId = @SecondarySubscriberContactId
				AND ISNULL(CC.RecordDeleted, 'N') = 'N'

			SELECT @SecondaryInsuredAddress = Display
			FROM ClientContactAddresses CCA
			WHERE CCA.ClientContactId = @SecondarySubscriberContactId
				AND ISNULL(CCA.RecordDeleted, 'N') = 'N'
			ORDER BY AddressType ASC
		END

		SELECT DISTINCT @ClientId AS ClientId
			,@ClientName AS ClientName
			,CONVERT(VARCHAR(10), @EffectiveDate, 101) AS EffectiveDate
			,CONVERT(VARCHAR(10), @DOB, 101) AS DOB
			,@PrimaryNameOfInsurance AS PrimaryNameOfInsurance
			,@PrimaryInsuranceAddress AS PrimaryInsuranceAddress
			,@PrimaryInsuranceCityStateZip AS PrimaryInsuranceCityStateZip
			,@PrimaryInsuredId AS PrimaryInsuredId
			,ISNULL(@PrimaryGroupName, @ClientName) AS PrimaryGroupName
			,@PrimaryGroupNumber AS PrimaryGroupNumber
			,@PrimaryInsuredAddress AS PrimaryInsuredAddress
			,@PrimaryInsuredCityStateZip AS PrimaryInsuredCityStateZip
			,@SecondaryNameOfInsurance AS SecondaryNameOfInsurance
			,@SecondaryInsuranceAddress AS SecondaryInsuranceAddress
			,@SecondaryInsuranceCityStateZip AS SecondaryInsuranceCityStateZip
			,@SecondaryInsuredId AS SecondaryInsuredId
			,ISNULL(@SecondaryGroupName, @ClientName) AS SecondaryGroupName
			,@SecondaryGroupNumber AS SecondaryGroupNumber
			,@PrimaryInsured AS PrimaryInsured
			,@SecondaryInsured AS SecondaryInsured
			,@SecondaryInsuredAddress AS SecondaryInsuredAddress
			,@SecondaryInsuredCityStateZip AS SecondaryInsuredCityStateZip
			,@PrimaryInsuredRelation AS PrimaryInsuredRelation
			,@SecondaryInsuredRelation AS SecondaryInsuredRelation
			,SC.OrganizationName
		FROM ClientOrders CO
		INNER JOIN Orders O ON CO.OrderId = O.OrderId
		INNER JOIN Clients C ON C.ClientId = CO.ClientId
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
		INNER JOIN DocumentS Dv ON Dv.InProgressDocumentVersionId = CO.DocumentVersionId
			AND ISNULL(Dv.RecordDeleted, 'N') = 'N'
		CROSS JOIN SystemConfigurations SC
		WHERE ISNULL(O.RecordDeleted, 'N') = 'N'
			--AND ISNULL(CO.RecordDeleted,'N')='N'      
			AND CO.DocumentVersionId = @DocumentVersionId
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLClientOrderElectronicRequisitionBillingInformation') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****ERROR_STATE=' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error /* Message text*/
				,16 /*Severity*/
				,1 /*State*/
				)
	END CATCH
END
