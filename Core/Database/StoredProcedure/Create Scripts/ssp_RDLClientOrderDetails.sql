/****** Object:  StoredProcedure [dbo].[ssp_RDLClientOrderDetails]    Script Date: 11/19/2015 17:21:20 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClientOrderDetails]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLClientOrderDetails]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLClientOrderDetails]    Script Date: 11/19/2015 17:21:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLClientOrderDetails] (@DocumentVersionId INT = 0)
	/*************************************************
  Date:			Author:       Description:                            
  
  -------------------------------------------------------------------------            
 18-mar-2014    Revathi      What:Get Client and Order details
                             Why:Philhaven Development #26 Inpatient Order Management
 24-Apr-2014    Revathi      What:Added OrganizationName Why : required for the core report, Earlier it was showing Philhaven logo                            
 19-Nov-2014    Irfan		 What: Added AddressDisplay and MainPhone column's from Agency Table 
							 Why:  Required for the core report --  Task #133  New Directions - Support Go Live
21-June-2016    Manjunath	 What: Added FaxNumber column's from Agency Table 
							 Why:  For Allegan Support #555.
12-Seo-2016		Chethan N	 What: Removed RecordDeleted check as Discontinued medication will be mark as RecordDeleted = 'Y'.
							 Why:  Renaissance - Dev Items task #5.2.
19-Sep-2017		Ravichandra  What: Replaced CurrentDocumentVersionId with InProgressDocumentVersionId in where clause
							 Why:  Bear River - Support Go Live > Tasks #318.
************************************************/
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
			AND ISNULL(D.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(DV.RecordDeleted, 'N') <> 'Y'

		DECLARE @PrimaryNameOfInsurance VARCHAR(250)
			,@PrimaryInsuranceAddress VARCHAR(500)
			,@PrimaryInsuredId VARCHAR(25)
			,@PrimaryGroupName VARCHAR(100)
			,@PrimaryClientIsSubscriber CHAR(1)
			,@PrimarySubscriberContactId INT
		DECLARE @SecondaryNameOfInsurance VARCHAR(250)
			,@SecondaryInsuranceAddress VARCHAR(500)
			,@SecondaryInsuredId VARCHAR(25)
			,@SecondaryGroupName VARCHAR(100)
			,@SecondaryClientIsSubscriber CHAR(1)
			,@SecondarySubscriberContactId INT
		DECLARE @InsuranceInformation TABLE (
			NameOfInsurance VARCHAR(250)
			,InsuranceAddress VARCHAR(500)
			,Insured VARCHAR(25)
			,GroupName VARCHAR(100)
			,ClientIsSubscriber CHAR(1)
			,SubscriberContactId INT
			,Row INT
			);

		WITH InsuranceDetail
		AS (
			SELECT TOP 2 CP.DisplayAs AS NameOfInsurance
				,CCP.AddressDisplay AS InsuranceAddress
				,CCP.InsuredId AS Insured
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
				AND CP.MedicaidPlan = 'Y'
				AND CP.Active = 'Y'
				AND CCH.StartDate <= @EffectiveDate
				AND Cast(ISNULL(CCH.EndDate, '01-01-9999') AS DATE) >= @EffectiveDate
			ORDER BY CCH.COBOrder ASC
			)
		INSERT INTO @InsuranceInformation (
			NameOfInsurance
			,InsuranceAddress
			,Insured
			,GroupName
			,ClientIsSubscriber
			,SubscriberContactId
			,Row
			)
		SELECT NameOfInsurance
			,InsuranceAddress
			,Insured
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
		FROM @InsuranceInformation
		WHERE ROw = 1

		SELECT @SecondaryNameOfInsurance = NameOfInsurance
			,@SecondaryInsuranceAddress = InsuranceAddress
			,@SecondaryInsuredId = Insured
			,@SecondaryGroupName = GroupName
			,@SecondaryClientIsSubscriber = ClientIsSubscriber
			,@SecondarySubscriberContactId = SubscriberContactId
		FROM @InsuranceInformation
		WHERE ROw = 2

		DECLARE @PrimaryInsured VARCHAR(150)
			,@SecondaryInsured VARCHAR(150)

		IF ISNULL(@PrimaryClientIsSubscriber, 'N') = 'Y'
		BEGIN
			SET @PrimaryInsured = @ClientName
		END
		ELSE IF ISNULL(@PrimaryClientIsSubscriber, 'N') = 'Y'
		BEGIN
			SET @PrimaryInsured = (
					SELECT CC.LastName + ', ' + CC.FirstName
					FROM ClientContacts CC
					WHERE CC.ClientContactId = @SecondarySubscriberContactId
					)
		END

		IF ISNULL(@SecondaryClientIsSubscriber, 'N') = 'Y'
		BEGIN
			SET @SecondaryInsured = @ClientName
		END
		ELSE IF ISNULL(@SecondaryClientIsSubscriber, 'N') = 'Y'
		BEGIN
			SET @SecondaryInsured = (
					SELECT CC.LastName + ', ' + CC.FirstName
					FROM ClientContacts CC
					WHERE CC.ClientContactId = @SecondarySubscriberContactId
					)
		END

		SELECT DISTINCT @ClientId AS ClientId
			,@ClientName AS ClientName
			,CONVERT(VARCHAR(10), @EffectiveDate, 101) AS EffectiveDate
			,CONVERT(VARCHAR(10), @DOB, 101) AS DOB
			,@PrimaryNameOfInsurance AS PrimaryNameOfInsurance
			,@PrimaryInsuranceAddress AS PrimaryInsuranceAddress
			,@PrimaryInsuredId AS PrimaryInsuredId
			,@PrimaryGroupName AS PrimaryGroupName
			,@SecondaryNameOfInsurance AS SecondaryNameOfInsurance
			,@SecondaryInsuranceAddress AS SecondaryInsuranceAddress
			,@SecondaryInsuredId AS SecondaryInsuredId
			,@SecondaryGroupName AS SecondaryGroupName
			,@PrimaryInsured AS PrimaryInsured
			,@SecondaryInsured AS SecondaryInsured
			,SC.OrganizationName
		--21-June-2016    Manjunath
		FROM ClientOrders CO
		INNER JOIN Orders O ON CO.OrderId = O.OrderId
		INNER JOIN Clients C ON C.ClientId = CO.ClientId
			AND ISNULL(C.RecordDeleted, 'N') <> 'Y'
		INNER JOIN DocumentS Dv ON Dv.InProgressDocumentVersionId = CO.DocumentVersionId
			AND ISNULL(Dv.RecordDeleted, 'N') <> 'Y'
		CROSS JOIN SystemConfigurations SC
		WHERE ISNULL(O.RecordDeleted, 'N') <> 'Y'
			--AND ISNULL(CO.RecordDeleted,'N')<>'Y'
			AND CO.DocumentVersionId = @DocumentVersionId
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLClientOrderDetails') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,/* Message text.*/ 16
				,/* Severity.*/ 1 /*State.*/
				);
	END CATCH
END
GO


