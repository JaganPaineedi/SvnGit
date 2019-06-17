
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetCAT1FileInformation]    Script Date: 06/09/2015 02:36:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetCAT1FileInformation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetCAT1FileInformation]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_GetCAT1FileInformation]    Script Date: 06/09/2015 02:36:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetCAT1FileInformation] @ClientId BIGINT
	,@StaffId BIGINT
AS
-- =============================================      
-- Author:  Pradeep      
-- Create date: Sept 23, 2014      
-- Description: Retrieves ClientInformation and CAT1 components data
/*      
 Author			Modified Date			Reason      
   
      
*/
-- =============================================      
BEGIN
	BEGIN TRY
		--Main
		SELECT CAST(NEWID() AS VARCHAR(50)) AS CCRDocumentObjectID
			,'English' AS LANGUAGE
			,'V1.0' AS Version
			,'CCR Creation DateTime' AS [DateTime_Type]
			,replace(replace(replace(convert(VARCHAR(19), getdate(), 126), '-', ''), 'T', ''), ':', '') AS DateTime_ApproximateDateTime
			,'Patient.' + CAST(@ClientId AS VARCHAR(100)) AS ActorID
			,'Patient' AS ActorRole
			,'For the patient' AS Purpose_Description;

		--FromStaff
		SELECT 'Staff.' + CAST(@StaffId AS VARCHAR(100)) AS ActorID
			,CAST(@StaffId AS VARCHAR(100)) AS ID1_ActorID
			,'Provider' AS ActorRole
			,ISNULL(LastName, '') AS Current_Family
			,ISNULL(FirstName, '') AS Current_Given
			,ISNULL(MiddleName, '') AS Current_Middle
			,CASE 
				WHEN lastname IS NULL
					THEN ''
				ELSE ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '')
				END AS Current_DisplayName
			,'' AS From_Actor_Title
			,ISNULL(CONVERT(VARCHAR(10), DOB, 21), '') AS DOB_ApproximateDateTime
			,CASE sex
				WHEN 'F'
					THEN 'Female'
				WHEN 'M'
					THEN 'Male'
				ELSE 'Unknown'
				END AS Gender
			,ISNULL(Email, '') AS CT1_Email_Value
			,'' AS ActorSpecialty
			,'Staff ID' AS ID1_IDType
			,'SmartCareEHR4.0' AS ID1_Source_ActorID
			,'SmartCareEHR4.0' AS SLRCGroup_Source_ActorID
			,'EHR' AS ID1_Source_ActorRole
		FROM staff
		WHERE StaffId = @StaffId;

		--FromOrganization
		SELECT TOP (1) REPLACE(A.AgencyName, ' ', '_') AS ActorID
			,A.AgencyName AS DisplayName
			,'Organization' AS ActorRole
			,'SmartCareEHR4.0' AS SLRCGroup_Source_ActorID
			,A.Address AS SLRCGroup_Source_ActorAddress
			,A.City AS SLRCGroup_Source_ActorCity
			,A.STATE AS SLRCGroup_Source_ActorState
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
		
		--(PatientInfo)
		EXEC ssp_CCRCSGetClientInfo @ClientId 

		-- Componets
		SELECT TOP 1 Components As ComponentXML
		FROM CAT1FileComponents
		WHERE ClientId = @ClientId
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetCAT1FileInformation') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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

