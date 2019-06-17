/****** Object:  StoredProcedure [dbo].[scsp_validateClientOrders]    Script Date: 04/04/2017 10:38:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_validateClientOrders]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_validateClientOrders]
GO


/****** Object:  StoredProcedure [dbo].[scsp_validateClientOrders]    Script Date: 04/04/2017 10:38:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[scsp_validateClientOrders] @DocumentVersionId INT
AS
/*********************************************************************/
/* Stored Procedure: dbo.scsp_validateClientOrders            */
/* Creation Date:    11/Dec/2015                */
/* Purpose:  To validate client order for LabSoft                */
/*    Exec scsp_validateClientOrders 637  --658                                           */
/* Input Parameters:                           */
/*  Date  Author   Purpose              */
/* 11/Dec/2015  Gautam   Created    Streamline Administration, 153 - LabSoft          */
/* 1/19/2017	Pradeep	 Dont show subscriber validation if ClientIsSubscriber field from ClientCoverageplans is set to Y*/
/* Feb/06/2018	 Pradeep	   Included missing validation for Ordering Physician's NPI,License Number,SigningSuffix,FirstName,LastName, Client's Address */
/* 03/Oct/2018	 Irfan	 What: Removed these validation 'Client Plan - Client is a Subscriber and coverage plan Group# must be specified' from Client Orders
						 Why:  Customer donot want these validation for Client Orders as per the task Aurora-Support Go Live-#61 */
/*********************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @SubScriberContactId INT
		DECLARE @ClientIsSubscriber CHAR(1)
			,@GroupNumber VARCHAR(100)
			,@InsuredId VARCHAR(25)

		CREATE TABLE #ClientOrderTest (
			ClientId INT
			,ClientOrderId INT
			,OrderingPhysician INT
			)

		CREATE TABLE #Validation(
			TableName VARCHAR(100),
			ColumnName VARCHAR(100),
			ErrorMessage VARCHAR(500)
			)

		INSERT INTO #ClientOrderTest
		SELECT CO.ClientId
			,CO.ClientOrderId
			,CO.OrderingPhysician
		FROM ClientOrders CO
		INNER JOIN Orders OS ON CO.OrderId = OS.OrderId
		INNER JOIN Clients C ON C.ClientId = CO.ClientId
		WHERE ISNULL(CO.RecordDeleted, 'N') = 'N'
			AND ISNULL(OS.RecordDeleted, 'N') = 'N'
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
			AND CO.DocumentVersionId = @DocumentVersionId

		--GET COVERAGE PLAN DETAILS
		SELECT TOP 1 @SubScriberContactId = CCP.SubscriberContactId
			,@ClientIsSubscriber = ISNULL(CCP.ClientIsSubscriber, 'N')
			,@GroupNumber = CCP.GroupNumber
			,@InsuredId = CCP.InsuredId
		FROM ClientCoverageHistory CCH
		JOIN ClientCoveragePlans CCP ON CCP.ClientCoveragePlanId = CCH.ClientCoveragePlanId
		JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId
		JOIN #ClientOrderTest CO ON CCP.ClientId = CO.ClientId
		WHERE CCP.ClientId = Co.ClientId
			AND DATEDIFF(day, cch.StartDate, GETDATE()) >= 0
			AND (
				cch.EndDate IS NULL
				OR DATEDIFF(day, cch.EndDate, GETDATE()) <= 0
				)
			AND ISNULL(CCH.RecordDeleted, 'N') = 'N'
			AND ISNULL(CCP.RecordDeleted, 'N') = 'N'
		ORDER BY CCH.COBOrder

		IF @@ROWCOUNT = 0 -- SINCE THERE ARE NO COVERAGE PLANS, CHECK IF THERE IS A CLIENT CONTACTS WHO IS FINANCIALLY RESPONSIBLE
		BEGIN
			IF NOT EXISTS (
					SELECT 1
					FROM ClientContacts C
					JOIN #ClientOrderTest CO ON CO.ClientId = c.ClientId
					WHERE C.FinanciallyResponsible = 'Y'
						AND ISNULL(C.RecordDeleted, 'N') = 'N'
					)
			BEGIN
				-- SINCE THERE ARE NO CLIENT CONTACTS WHO IS FINANCIALLY RESPONSIBLE
				Insert Into #Validation(TableName
					,ColumnName
					,ErrorMessage)
				(
					SELECT DISTINCT 'Clients' AS TableName
						,'Sex' AS ColumnName
						,'Client is the Insurer and Client''s Sex must be specified' AS ErrorMessage
					FROM #ClientOrderTest CO
					JOIN Clients C ON CO.ClientId = C.ClientId
						AND ISNULL(C.RecordDeleted, 'N') = 'N'
						AND ISNULL(C.Sex, '') = ''
					
					UNION
					
					SELECT DISTINCT 'Clients' AS TableName
						,'DOB' AS ColumnName
						,'Client is the Insurer and Client''s Date Of Birth must be specified' AS ErrorMessage
					FROM #ClientOrderTest CO
					JOIN Clients C ON CO.ClientId = C.ClientId
						AND ISNULL(C.RecordDeleted, 'N') = 'N'
						AND ISNULL(C.DOB, '') = ''
					
					UNION
					
					SELECT DISTINCT 'Clients' AS TableName
						,'Address' AS ColumnName
						,'Client is the Insurer and Client''s Home Address, City, State and Zip must be specified' AS ErrorMessage
					FROM #ClientOrderTest CO
					JOIN Clients C ON CO.ClientId = C.ClientId
						AND ISNULL(C.RecordDeleted, 'N') = 'N'
						AND NOT EXISTS (
							SELECT 1
							FROM ClientAddresses CA
							WHERE CA.ClientId = CO.ClientId
								AND CA.AddressType = 90
								AND ISNULL(CA.Address, '') <> ''
								AND ISNULL(CA.City, '') <> ''
								AND ISNULL(CA.Zip, '') <> ''
								AND ISNULL(CA.STATE, '') <> ''
							)
					)
				--RETURN
			END
			ELSE
			BEGIN
				Insert Into #Validation(TableName
					,ColumnName
					,ErrorMessage)
				(
					SELECT DISTINCT 'ClientContacts' AS TableName
						,'DOB' AS ColumnName
						,'Client Contact is financially responsible. Contact''s Last Name must be specified' AS ErrorMessage
					FROM #ClientOrderTest CO
					JOIN ClientContacts C ON CO.ClientId = C.ClientId
						AND ISNULL(C.RecordDeleted, 'N') = 'N'
						AND ISNULL(C.LastName, '') = ''
						AND ISNULL(C.FinanciallyResponsible, '') = 'Y'
					
					UNION
					
					SELECT DISTINCT 'ClientContacts' AS TableName
						,'DOB' AS ColumnName
						,'Client Contact is financially responsible. Contact''s First Name must be specified' AS ErrorMessage
					FROM #ClientOrderTest CO
					JOIN ClientContacts C ON CO.ClientId = C.ClientId
						AND ISNULL(C.RecordDeleted, 'N') = 'N'
						AND ISNULL(C.FirstName, '') = ''
						AND ISNULL(C.FinanciallyResponsible, '') = 'Y'
					
					UNION
					
					SELECT DISTINCT 'ClientContacts' AS TableName
						,'DOB' AS ColumnName
						,'Client Contact is financially responsible. Contact''s Relationship with Client must be specified' AS ErrorMessage
					FROM #ClientOrderTest CO
					JOIN ClientContacts C ON CO.ClientId = C.ClientId
						AND ISNULL(C.RecordDeleted, 'N') = 'N'
						AND ISNULL(C.Relationship, '') = ''
						AND ISNULL(C.FinanciallyResponsible, '') = 'Y'
					
					UNION
					
					SELECT DISTINCT 'ClientContacts' AS TableName
						,'Sex' AS ColumnName
						,'Client Contact is financially responsible. Contact''s Sex must be specified' AS ErrorMessage
					FROM #ClientOrderTest CO
					JOIN ClientContacts C ON CO.ClientId = C.ClientId
						AND ISNULL(C.RecordDeleted, 'N') = 'N'
						AND ISNULL(C.Sex, '') = ''
						AND ISNULL(C.FinanciallyResponsible, '') = 'Y'
					
					UNION
					
					SELECT DISTINCT 'ClientContacts' AS TableName
						,'DOB' AS ColumnName
						,'Client Contact is financially responsible. Contact''s Date Of Birth must be specified' AS ErrorMessage
					FROM #ClientOrderTest CO
					JOIN ClientContacts C ON CO.ClientId = C.ClientId
						AND ISNULL(C.RecordDeleted, 'N') = 'N'
						AND ISNULL(C.DOB, '') = ''
						AND ISNULL(C.FinanciallyResponsible, '') = 'Y'
					
					UNION
					
					SELECT DISTINCT 'ClientContacts' AS TableName
						,'Address' AS ColumnName
						,'Client Contact is financially responsible. Contact''s Home Address, City, State and Zip must be specified' AS ErrorMessage
					FROM #ClientOrderTest CO
					JOIN ClientContacts C ON CO.ClientId = C.ClientId
						AND ISNULL(C.RecordDeleted, 'N') = 'N'
						AND ISNULL(C.FinanciallyResponsible, '') = 'Y'
						AND NOT EXISTS (
							SELECT 1
							FROM ClientContactAddresses CA
							WHERE CA.ClientContactId = C.ClientContactId
								AND CA.AddressType = 90
								AND ISNULL(CA.Address, '') <> ''
								AND ISNULL(CA.City, '') <> ''
								AND ISNULL(CA.Zip, '') <> ''
								AND ISNULL(CA.STATE, '') <> ''
							)
					)
				--RETURN
			END
		END

		IF @SubScriberContactId IS NULL
			AND @ClientIsSubscriber = 'Y'
		BEGIN
			Insert Into #Validation(TableName
					,ColumnName
					,ErrorMessage)
			(
				SELECT DISTINCT 'Clients' AS TableName
					,'Sex' AS ColumnName
					,'Client Plan - Client is a Subscriber and Client''s Sex must be specified' AS ErrorMessage
				FROM #ClientOrderTest CO
				JOIN Clients C ON CO.ClientId = C.ClientId
					AND ISNULL(C.RecordDeleted, 'N') = 'N'
					AND ISNULL(C.Sex, '') = ''
				
				UNION
				
				SELECT DISTINCT 'Clients' AS TableName
					,'DOB' AS ColumnName
					,'Client Plan - Client is a Subscriber and Client''s Date Of Birth must be specified' AS ErrorMessage
				FROM #ClientOrderTest CO
				JOIN Clients C ON CO.ClientId = C.ClientId
					AND ISNULL(C.RecordDeleted, 'N') = 'N'
					AND ISNULL(C.DOB, '') = ''
				
				UNION
				
				SELECT DISTINCT 'Clients' AS TableName
					,'Address' AS ColumnName
					,'Client Plan - Client is a Subscriber and Client''s Home Address, City, State and Zip must be specified' AS ErrorMessage
				FROM #ClientOrderTest CO
				JOIN Clients C ON CO.ClientId = C.ClientId
					AND ISNULL(C.RecordDeleted, 'N') = 'N'
					AND NOT EXISTS (
						SELECT 1
						FROM ClientAddresses CA
						WHERE CA.ClientId = CO.ClientId
							AND CA.AddressType = 90
							AND ISNULL(CA.Address, '') <> ''
							AND ISNULL(CA.City, '') <> ''
							AND ISNULL(CA.Zip, '') <> ''
							AND ISNULL(CA.STATE, '') <> ''
						)
				
				
				
				UNION
				
				SELECT DISTINCT 'Clients' AS TableName
					,'Address' AS ColumnName
					,'Client Plan - Client is a Subscriber and coverage plan Insured Id must be specified' AS ErrorMessage
				FROM #ClientOrderTest CO
				WHERE @InsuredId IS NULL
				) 

			--RETURN
		END

		IF @SubScriberContactId > 0
		BEGIN
			Insert Into #Validation(TableName
					,ColumnName
					,ErrorMessage)
			(
				SELECT DISTINCT 'ClientContacts' AS TableName
					,'LastName' AS ColumnName
					,'Client Plan - Subscriber''s LastName must be Specified' AS ErrorMessage
				FROM #ClientOrderTest CO
				WHERE @SubScriberContactId IS NOT NULL
					AND EXISTS (
						SELECT 1
						FROM ClientContacts CC
						WHERE CO.ClientId = CC.ClientId
							AND ISNULL(CC.RecordDeleted, 'N') = 'N'
							AND CC.ClientContactId = @SubScriberContactId
							AND ISNULL(CC.LastName, '') = ''
						)
				
				UNION
				
				SELECT DISTINCT 'ClientContacts' AS TableName
					,'FirstName' AS ColumnName
					,'Client Plan - Subscriber''s FirstName must be Specified' AS ErrorMessage
				FROM #ClientOrderTest CO
				WHERE @SubScriberContactId IS NOT NULL
					AND EXISTS (
						SELECT 1
						FROM ClientContacts CC
						WHERE CO.ClientId = CC.ClientId
							AND ISNULL(CC.RecordDeleted, 'N') = 'N'
							AND CC.ClientContactId = @SubScriberContactId
							AND ISNULL(CC.FirstName, '') = ''
						)
				
				UNION
				
				SELECT DISTINCT 'ClientContacts' AS TableName
					,'Sex' AS ColumnName
					,'Client Plan - Subscriber''s Sex must be Specified' AS ErrorMessage
				FROM #ClientOrderTest CO
				WHERE @SubScriberContactId IS NOT NULL
					AND EXISTS (
						SELECT 1
						FROM ClientContacts CC
						WHERE CO.ClientId = CC.ClientId
							AND ISNULL(CC.RecordDeleted, 'N') = 'N'
							AND CC.ClientContactId = @SubScriberContactId
							AND ISNULL(CC.Sex, '') = ''
						)
				
				UNION
				
				SELECT DISTINCT 'ClientContacts' AS TableName
					,'DOB' AS ColumnName
					,'Client Plan - Subscriber''s Date of Birth must be Specified' AS ErrorMessage
				FROM #ClientOrderTest CO
				WHERE @SubScriberContactId IS NOT NULL
					AND EXISTS (
						SELECT 1
						FROM ClientContacts CC
						WHERE CO.ClientId = CC.ClientId
							AND ISNULL(CC.RecordDeleted, 'N') = 'N'
							AND CC.ClientContactId = @SubScriberContactId
							AND ISNULL(CC.DOB, '') = ''
						)
				
				UNION
				
				SELECT DISTINCT 'ClientContactAddresses' AS TableName
					,'Display' AS ColumnName
					,'Client Plan - Subscriber''s Address, City, State and Zip must be Specified' AS ErrorMessage
				FROM #ClientOrderTest CO
				WHERE @SubScriberContactId IS NOT NULL
					AND NOT EXISTS (
						SELECT 1
						FROM ClientContacts CC
						JOIN ClientContactAddresses CCA ON CCA.ClientContactId = CC.ClientContactId
						WHERE CO.ClientId = CC.ClientId
							AND ISNULL(CC.RecordDeleted, 'N') = 'N'
							AND ISNULL(CCA.RecordDeleted, 'N') = 'N'
							AND CC.ClientContactId = @SubScriberContactId
							AND ISNULL(CCA.Address, '') <> ''
							AND ISNULL(CCA.City, '') <> ''
							AND ISNULL(CCA.Zip, '') <> ''
							AND ISNULL(CCA.STATE, '') <> ''
						)
				)
		END

		Insert Into #Validation(TableName
					,ColumnName
					,ErrorMessage)
		(	
			SELECT DISTINCT 'Clients' AS TableName
				,'Address' AS ColumnName
				,'Clients address must be Specified' AS ErrorMessage
			FROM #ClientOrderTest CO
			JOIN Clients C ON CO.ClientId = C.ClientId
				AND ISNULL(C.RecordDeleted, 'N') = 'N'
				AND (EXISTS (
					SELECT TOP 1 1
					FROM ClientAddresses CA
					WHERE CO.ClientId = CA.ClientId
						AND CA.AddressType = 90
						AND ISNULL(CA.Address, '') = ''
						AND ISNULL(CA.RecordDeleted, 'N') = 'N'
					)
				 or 
				 not exists(SELECT  1
					FROM ClientAddresses CA
					WHERE CO.ClientId = CA.ClientId
						AND CA.AddressType = 90
						AND ISNULL(CA.RecordDeleted, 'N') = 'N'
					))
			
			UNION
			
			SELECT DISTINCT 'Clients' AS TableName
				,'City' AS ColumnName
				,'Clients City must be specified' AS ErrorMessage
			FROM #ClientOrderTest CO
			JOIN Clients C ON CO.ClientId = C.ClientId
				AND ISNULL(C.RecordDeleted, 'N') = 'N'
				AND (EXISTS (
					SELECT TOP 1 1
					FROM ClientAddresses CA
					WHERE CO.ClientId = CA.ClientId
						AND CA.AddressType = 90
						AND ISNULL(CA.city, '') = ''
						AND ISNULL(CA.RecordDeleted, 'N') = 'N'
					)
				 or 
				 not exists(SELECT  1
					FROM ClientAddresses CA
					WHERE CO.ClientId = CA.ClientId
						AND CA.AddressType = 90
						AND ISNULL(CA.RecordDeleted, 'N') = 'N'
					))
			
			UNION
			
			SELECT DISTINCT 'Clients' AS TableName
				,'State' AS ColumnName
				,'Clients State must be specified' AS ErrorMessage
			FROM #ClientOrderTest CO
			JOIN Clients C ON CO.ClientId = C.ClientId
				AND ISNULL(C.RecordDeleted, 'N') = 'N'
				AND (EXISTS (
					SELECT TOP 1 1
					FROM ClientAddresses CA
					WHERE CO.ClientId = CA.ClientId
						AND CA.AddressType = 90
						AND ISNULL(CA.State, '') = ''
						AND ISNULL(CA.RecordDeleted, 'N') = 'N'
					)
				 or 
				 not exists(SELECT  1
					FROM ClientAddresses CA
					WHERE CO.ClientId = CA.ClientId
						AND CA.AddressType = 90
						AND ISNULL(CA.RecordDeleted, 'N') = 'N'
					))
			
			UNION
			
			SELECT DISTINCT 'Clients' AS TableName
				,'Zip' AS ColumnName
				,'Clients Zip must be specified' AS ErrorMessage
			FROM #ClientOrderTest CO
			JOIN Clients C ON CO.ClientId = C.ClientId
				AND ISNULL(C.RecordDeleted, 'N') = 'N'
				AND (EXISTS (
					SELECT TOP 1 1
					FROM ClientAddresses CA
					WHERE CO.ClientId = CA.ClientId
						AND CA.AddressType = 90
						AND ISNULL(CA.Zip, '') = ''
						AND ISNULL(CA.RecordDeleted, 'N') = 'N'
					)
				 or 
				 not exists(SELECT  1
					FROM ClientAddresses CA
					WHERE CO.ClientId = CA.ClientId
						AND CA.AddressType = 90
						AND ISNULL(CA.RecordDeleted, 'N') = 'N'
					))
				  UNION						
			SELECT DISTINCT 'Staff' AS TableName
				,'LastName' AS ColumnName
				,'Client Order - Ordering Physician Last name  must be Specified' AS ErrorMessage
			FROM #ClientOrderTest CO
			JOIN Staff S ON CO.OrderingPhysician = S.StaffId
			WHERE ISNULL(S.RecordDeleted, 'N') = 'N'
				AND ISNULL(S.LastName, '') = ''
			
			UNION
			
			SELECT DISTINCT 'Staff' AS TableName
				,'FirstName' AS ColumnName
				,'Client Order - Ordering Physician First name  must be Specified' AS ErrorMessage
			FROM #ClientOrderTest CO
			JOIN Staff S ON CO.OrderingPhysician = S.StaffId
			WHERE ISNULL(S.RecordDeleted, 'N') = 'N'
				AND ISNULL(S.FirstName, '') = ''
			
			UNION
			
			SELECT DISTINCT 'Staff' AS TableName
				,'SigningSuffix' AS ColumnName
				,'Client Order - Ordering Physician Suffix  must be Specified' AS ErrorMessage
			FROM #ClientOrderTest CO
			JOIN Staff S ON CO.OrderingPhysician = S.StaffId
			WHERE ISNULL(S.RecordDeleted, 'N') = 'N'
				AND ISNULL(S.SigningSuffix, '') = ''
			
			UNION
			
			SELECT DISTINCT 'Staff' AS TableName
				,'LicenseNumber' AS ColumnName
				,'Client Order - Ordering Physician LicenseNumber  must be specified' AS ErrorMessage
			FROM #ClientOrderTest CO
			JOIN Staff S ON CO.OrderingPhysician = S.StaffId
			WHERE ISNULL(S.RecordDeleted, 'N') = 'N'
				AND ISNULL(S.LicenseNumber, '') = ''
			
			UNION

			 SELECT DISTINCT
				   'Staff' AS TableName,
				   'NationalProviderId' AS ColumnName,
				   'Client Order - Ordering Physician NationalProviderId  must be specified' AS ErrorMessage
			 FROM #ClientOrderTest CO
				 JOIN Staff S ON CO.OrderingPhysician = S.StaffId
			 WHERE ISNULL(S.RecordDeleted, 'N') = 'N'
				  AND S.StaffId NOT IN
			 (
				SELECT SL.StaffId
				FROM StaffLicenseDegrees SL
					JOIN GlobalCodes GL ON GL.GlobalCodeId = SL.LicenseTypeDegree
				WHERE RTRIM(LTRIM(GL.Code)) = 'NPI'
					 AND ISNULL(SL.RecordDeleted, 'N') = 'N'
					 AND ISNULL(GL.RecordDeleted, 'N') = 'N'
					 AND ISNULL(SL.LicenseNumber, '') <> ''
					 AND SL.StaffId = s.staffid
			 ))

		SELECT * FROM #Validation
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'scsp_validateClientOrders') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + 
			'*****' + Convert(VARCHAR, ERROR_STATE())
	END CATCH
END

GO


