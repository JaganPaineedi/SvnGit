/****** Object:  StoredProcedure [dbo].[ssp_SCPatientPortalSummaryInfo]    Script Date: 11/18/2011 16:25:44 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCPatientPortalSummaryInfo]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCPatientPortalSummaryInfo]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCPatientPortalSummaryInfo] @ClientId INT
AS
/**********************************************************************/
/* Stored Procedure: dbo.ssp_ClientSummaryInfoTest              */
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:    14/05/2014                      */
/*                                                                   */
/* Purpose:It is used in client Summary Page Information from various tables     */
/*                                                                   */
/* Input Parameters: @ClientId               */
/*                                                                   */
/* Output Parameters:   None                               */
/*                                                                   */
/* Return:  0=success, otherwise an error number                     */
/*                                                                   */
/* Called By:                                                        */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/* 14/05/2014    Veena S Mani        Created                         */
/* 21 Oct 2015    Revathi    what:Changed code to display Clients LastName and FirstName when ClientType='I' else  OrganizationName.  /   
							 why:task #609, Network180 Customization  */
/* 04 May 2017    Anto       What:Modified the logic to display Staff phone number instead of Agency Phone Number.  /   
							 Why: AspenPointe-Customizations #447.26  */	
/*12 oct 2017     K.Soujanya What:Modified the logic to display last 4 digits of SSN number instead of entire SSN number
                             Why:Harbor-Enhancements #16 */						 
/*********************************************************************/
BEGIN
BEGIN TRY
	-- Clients  
	DECLARE @later DATETIME

	SELECT @later = GETDATE()

	DECLARE @phoneNumber AS VARCHAR(200)
	DECLARE @StaffId AS VARCHAR(50)    
	DECLARE @StaffPhoneNumber AS VARCHAR(50)
	SELECT @phoneNumber = COALESCE(@phoneNumber + ', ', '') + CAST(GC.CodeName AS VARCHAR(50)) + '-' + CAST(PhoneNumber AS VARCHAR(50)) + CASE 
			WHEN DoNotContact = 'Y'
				THEN ' (DNC)'
			ELSE ''
			END
	FROM clientPhones CP
	INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = CP.PhoneType
	WHERE clientId = @ClientId
		AND ISNULL(CP.RecordDeleted, 'N') <> 'Y'
		AND ISNULL(GC.RecordDeleted, 'N') <> 'Y'
	ORDER BY (
			CASE 
				WHEN IsPrimary = 'Y'
					THEN 1
				ELSE 0
				END
			) DESC

	--DECLARE @AgencyPhoneNumber AS VARCHAR(200)

	--SELECT @AgencyPhoneNumber = A.MainPhone
	--FROM Agency A
	
	 
	 SELECT @StaffId = S.StaffId FROM Clients C 
	 JOIN Staff S ON S.StaffId = C.PrimaryClinicianId  
	 WHERE C.ClientId = @ClientId
         
	 SELECT @StaffPhoneNumber = CASE WHEN ISNULL(Phonenumber,'') <> ''  
	   THEN '('+SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(Phonenumber, '(', ''), ')', ''), '-', ''),' ', ''), 1, 3) +')' 
		+ ' ' 
		+ SUBSTRING(REPLACE(REPLACE(REPLACE(Phonenumber, '(', ''), ')', ''), '-', ''), 4, 3)  
		+ '-' 
		+ SUBSTRING(REPLACE(REPLACE(REPLACE(Phonenumber, '(', ''), ')', ''), '-', ''), 7, 4)  
		ELSE ''
	  END
	  FROM Staff Where Staffid = @StaffId
  

	--get the Details of the client  (--CONVERT(varchar(10),DATEDIFF(year,  C.dob, getdate())) +' Year'  as Age)    
	SELECT DISTINCT
		--Added by Revathi 21 Oct 2015
		CASE 
			WHEN ISNULL(C.ClientType, 'I') = 'I'
				THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
			ELSE ISNULL(C.OrganizationName, '')
			END AS Name
		,CONVERT(VARCHAR(10), C.dob, 101) AS DOB
		,CAST(DATEDIFF(yy, C.DOB, @later) - CASE 
				WHEN @later >= DATEADD(yy, DATEDIFF(yy, C.DOB, @later), C.DOB)
					THEN 0
				ELSE 1
				END AS VARCHAR(10)) + ' Year' AS Age
		,CASE 
			WHEN C.Sex = 'F'
				THEN 'Female'
			WHEN C.Sex = 'M'
				THEN 'Male'
			ELSE ''
			END AS Sex
		,CASE 
			WHEN (
					SELECT COUNT(ClientId)
					FROM ClientRaces
					WHERE ClientRaces.ClientId = @ClientId
						AND ISNULL(ClientRaces.RecordDeleted, 'N') = 'N'
					) > 1
				THEN 'Multi-Racial'
			ELSE LTRIM(RTRIM(GC.CodeName))
			END AS CodeName
			--K.Soujanya 10/12/2017 Start
		,CASE WHEN ISNULL(C.SSN,'') <> ''  
			    THEN SUBSTRING(C.SSN, 6, 4) 
			  ELSE ''
			  END AS SSN
			--K.Soujanya 10/12/2017 end
		,S.StaffId
		,(S.LastName + ', ' + S.FirstName) AS ClinicianName
		,@phoneNumber AS PhoneNumber
		,C.ClientId
		,dbo.csf_GetGlobalCodeNameById(C.HispanicOrigin) AS HispanicOrigin
		,dbo.csf_GetGlobalCodeNameById(C.primarylanguage) AS Primarylanguage
		,CA.ClientAddressId
		,CA.AddressType
		,CA.[Address]
		,CA.City
		,CA.[State]
		,CA.[Zip]
		,CA.Display
		,CA.Billing
		,CA.RecordDeleted
		,PR.ProgramName AS PrimaryProgram
		,@StaffPhoneNumber AS StaffPhone  
	FROM Clients C
	LEFT JOIN ClientRaces CR ON CR.Clientid = C.ClientId
		AND ISNULL(CR.RecordDeleted, 'N') = 'N'
	LEFT JOIN GlobalCodes GC ON GC.GlobalCodeID = CR.RaceId
	LEFT JOIN Staff S ON S.StaffId = C.PrimaryClinicianId
	LEFT JOIN ClientPrograms AS CP ON CP.ClientId = C.ClientId
		AND CP.STATUS <> 5
		AND CP.PrimaryAssignment = 'Y'
		AND ISNULL(CP.RecordDeleted, 'N') = 'N'
	LEFT JOIN Programs AS PR ON PR.ProgramId = CP.ProgramId
	LEFT JOIN ClientAddresses CA ON C.ClientId = CA.ClientId
		AND CA.Addresstype = 90
		AND ISNULL(CA.RecordDeleted, 'N') = 'N'
	WHERE ISNULL(C.RecordDeleted, 'N') <> 'Y'
		AND C.ClientId = @ClientId
END TRY
	BEGIN CATCH            
  DECLARE @Error VARCHAR(8000)				
            
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCPatientPortalSummaryInfo') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*** 
   
    **' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())            
            
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