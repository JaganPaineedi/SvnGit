/****** Object:  StoredProcedure [dbo].[SSP_GetClientInformationToolTip]    Script Date: 08/31/2017 15:57:43 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[SSP_GetClientInformationToolTip]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[SSP_GetClientInformationToolTip]
GO

/****** Object:  StoredProcedure [dbo].[SSP_GetClientInformationToolTip]   Script Date: 08/31/2017 15:57:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SSP_GetClientInformationToolTip] --1103490,13463 --13324  -- 2107829,13463  
@ClientId INT,
@StaffId INT = NULL   
AS
-- =============================================        
-- Author:  Pradeep        
-- Create date: Jun 02, 2015        
-- Description: Get the Information for the Client Information Tooltip
/*        
 Author		Modified Date   Reason        
 Pradeep.A	Jun-10-2015		Primary Program Issue has fixed.
 Pradeep.A	Jun-11-2015		Medication StartDate, EndDate and Discontinued check is added.    
 Pradeep.A  Jun-25-2015		Added SSN,MedicaidId,ResidentialBedUnit in the tooltip based on the SystemConfigurationKey
 Pradeep.A  Jun-29-2015		Added COBOrder in the MedicaidId get.
 Akwinass.D Aug-03-2015		Added Coverage Plan,Address,Phone Number and Removed Client Name and Created SystemConfigurationKey for each of them (Task #227 in Valley Client Acceptance Testing Issues)
 Shilpa.S   Sep-09-2015     Created SystemConfigurationKey for ShowRecentCoveragePlan P2W (Proviso): Business Process Review #25 
 Shankha.B  Oct-26-2015     Added Client Name back per Engineering Improvement Initiatives- NBL(I)# 239 
 Neelima N	Nov-18-2015		Added DateOfEnrollment,Modified COB Order and added a custom 'SCSP_SCGetClientInformationToolTip' which have custom logic added
							as per task Woods - Customizations #49
 Jayashree Feb-03-2016      Added ISNULL(CE.DischargeDate,'')='' ORDER BY CE.RegistrationDate DESC for getting the date of enrolment of current episode and modified logic for getting only that bed for which client is admitted	
						    w.r.t Woods - Environment Issues Tracking  #85	
 Veena S Mani May-03-2016   Added the logic by Veena on 05/03/16  to display the beds in comma separated values if there are multiple beds are occupied by the client,also added status "on leave" with occuplied in the status check,Also added recorddeleted check Woods Support Go live #10 
 Veena S Mani May-03-2016   Added on leave condition for ClientInPatientVisits table also Woods Support Go live #10 
 Chita Ranjan Nov-11-2016   Added Top 1 to temporary variable @MedicaidId to return only one record. Network180 Support Go Live #1020
 Dasari Sunil Dec-19-2016   Increased the column length PlanName VARCHAR(50)  to VARCHAR(100)  in the table @Plans. why: Length of 'DisplayAs' column in table DisplayAs is 100. Task Network180 Support Go Live #541
 Munish Sood  Mar-31-2017	What: Added missing @ClientId condition in where clause with Date of Enrollment
							Why: Date of Enrollment was not displaying as per Wood - Support Go Live Task #287
 Shankah B    Aug-31-2017	What: Added Order By ClientEpisodeId DESC while fetching @ClientStatus
							Why : Wood - Support Go Live Task #681	
 Neelima	Sept-24-2017	What: Added code to get first 25 charecters in Coverage Plan name 
							Why : Offshore QA Bugs Task #601	
 RK 20 Feb 2018             What: Client Hover: Enhancements being requested
							Why: MHP-Customizations - Task 121
 esova      2018-08-22      What: guardian spelling fixed
                            Why:  old spelling was Gaurdian fixed to Guardian  didn't fix all the variable misspellings
							KCMHSAS Support #1182
*/
-- =============================================   
BEGIN TRY
	BEGIN
		DECLARE @Medication VARCHAR(max)
		DECLARE @PrimaryProgram VARCHAR(MAX)
		DECLARE @ClientName VARCHAR(100)
		DECLARE @DOB VARCHAR(100)
		DECLARE @Sex VARCHAR(100)
		DECLARE @PrimaryClinicianName VARCHAR(MAX)
		DECLARE @SSN VARCHAR(100)
		DECLARE @ResidentialBedUnit VARCHAR(MAX)
		DECLARE @MedicaidId VARCHAR(100)
		DECLARE @ClientInformation VARCHAR(MAX)
		DECLARE @ClientInformationToolTipRequired CHAR(1)
		DECLARE @ClientAddressRequired CHAR(1)
		DECLARE @PhoneNumberRequired CHAR(1)
		DECLARE @DOBRequired CHAR(1)
		DECLARE @SexRequired CHAR(1)
		DECLARE @SSNRequired CHAR(1)
		DECLARE @ClientPlansRequired CHAR(1)
		DECLARE @MedicaidIDRequired CHAR(1)
		DECLARE @PrimaryClinicianNameRequired CHAR(1)
		DECLARE @PrimaryProgramRequired CHAR(1)
		DECLARE @ResidentialBedUnitRequired CHAR(1)
		DECLARE @MedicationRequired CHAR(1)
		DECLARE @ClientRecentCoverageplanRequired CHAR(1)
		DECLARE @DateOfEnrollmentRequired CHAR(1)
		DECLARE @PrimaryPharmacyRequired CHAR(1)
		
		---RK MHP-Customizations - Task 121-------------------------------------    
		DECLARE @GuardianToolTipRequired CHAR(1)      
		DECLARE @AllergiesToolTipRequired CHAR(1)      
		DECLARE @OutstandingBalanceToolTipRequired CHAR(1)      
		DECLARE @AliasToolTipRequired CHAR(1)      
		DECLARE @GenderIdentityToolTipRequired CHAR(1)      
		DECLARE @PrimaryLanguageToolTipRequired CHAR(1)      
		DECLARE @ProviderToolTipRequired CHAR(1) 
		  
		DECLARE @PrimaryLanguage VARCHAR(100)      
		DECLARE @GenderIdentity VARCHAR(100)      
		DECLARE @CurrentBalance VARCHAR(100)
		
		DECLARE @Gaurdian VARCHAR(MAX)       
		DECLARE @ClientAliases VARCHAR(MAX)       
		DECLARE @CurrentClientAllergies varchar(max)    
		DECLARE @Providers VARCHAR(MAX)       
		--RK MHP-Customizations - Task 121----------------------------------    
		
  --IF EXISTS (      
  -- SELECT TOP 1 * FROM StaffRoles SR      
  -- INNER JOIN PermissionTemplates PT ON PT.RoleId=SR.RoleId       
  -- WHERE PT.PermissionTemplateType=5930 AND SR.StaffId =@StaffId ANd ISNULL(SR.RecordDeleted,'N') ='N'      
  --  )      
  --BEGIN      
  --------start-RK- MHP-Customizations - Task 121-----  
  
  		SELECT @ClientInformationToolTipRequired = dbo.ssf_GetIsToolTipRequired('ClientInformation',@StaffId)

		SELECT @ClientAddressRequired = dbo.ssf_GetIsToolTipRequired('ClientAddress',@StaffId)

		SELECT @PhoneNumberRequired = dbo.ssf_GetIsToolTipRequired('PhoneNumber',@StaffId)

		SELECT @DOBRequired = dbo.ssf_GetIsToolTipRequired('DOB',@StaffId)

		SELECT @SexRequired = dbo.ssf_GetIsToolTipRequired('Sex',@StaffId)

		SELECT @SSNRequired = dbo.ssf_GetIsToolTipRequired('SSN',@StaffId)

		SELECT @ClientPlansRequired = dbo.ssf_GetIsToolTipRequired('ClientPlans',@StaffId)

		SELECT @MedicaidIDRequired = dbo.ssf_GetIsToolTipRequired('MedicaidID',@StaffId)

		SELECT @PrimaryClinicianNameRequired = dbo.ssf_GetIsToolTipRequired('PrimaryClinicianName',@StaffId)

		SELECT @PrimaryProgramRequired = dbo.ssf_GetIsToolTipRequired('PrimaryProgram',@StaffId)

		SELECT @ResidentialBedUnitRequired = dbo.ssf_GetIsToolTipRequired('ResidentialUnitBed',@StaffId)

		SELECT @MedicationRequired = dbo.ssf_GetIsToolTipRequired('Medication',@StaffId)

		SELECT @ClientRecentCoverageplanRequired = dbo.ssf_GetIsToolTipRequired('RecentCoveragePlan',@StaffId)

		SELECT @DateOfEnrollmentRequired = dbo.ssf_GetIsToolTipRequired('ClientDateOfEnrollment',@StaffId) --Added by Neelima as per task Woods - Customizations #49

		SELECT @PrimaryPharmacyRequired = dbo.ssf_GetIsToolTipRequired('PrimaryPharmacy',@StaffId) --Added by Neelima as per task Woods - Customizations #49


	   SELECT @GuardianToolTipRequired =dbo.ssf_GetIsToolTipRequired('Guardian',@StaffId)  
	   SELECT @AllergiesToolTipRequired =dbo.ssf_GetIsToolTipRequired('Allergies',@StaffId)   
	   SELECT @OutstandingBalanceToolTipRequired =dbo.ssf_GetIsToolTipRequired('OutstandingBalance',@StaffId) 
	   SELECT @AliasToolTipRequired =dbo.ssf_GetIsToolTipRequired('Alias',@StaffId) 
	   SELECT @GenderIdentityToolTipRequired=dbo.ssf_GetIsToolTipRequired('GenderIdentity',@StaffId) 
	   SELECT @PrimaryLanguageToolTipRequired =dbo.ssf_GetIsToolTipRequired('PrimaryLanguage',@StaffId)
	   SELECT @ProviderToolTipRequired =dbo.ssf_GetIsToolTipRequired('Provider',@StaffId) 
    
      
	 if @GuardianToolTipRequired = 'Y'
	 Begin
			 ----Guardion-----------------------------    
			 SET @Gaurdian = ''    
			 SELECT   @Gaurdian = @Gaurdian + ( CC.LastName + ' ' + CC.Firstname  )  + ', '     
			 FROM    Clients C          
			  LEFT OUTER JOIN ClientContacts CC ON C.ClientID = CC.ClientID          
			 WHERE   C.ClientID = @ClientId 
			 AND CC.guardian = 'Y'                 
			  AND ISNULL(cc.RecordDeleted, 'N') <> 'Y'           
			  AND ISNULL(C.RecordDeleted, 'N') = 'N'            
			 AND ISNULL(CC.Active,'Y') = 'Y' ORDER BY C.ClientId        
			      
			 SET @Gaurdian = SUBSTRING(@Gaurdian, 0, LEN(@Gaurdian))    
			 ----End Guardion-----------------------------    
	 End   
 
 	 if @AliasToolTipRequired = 'Y'
	 Begin
  
		  ----ClientAliases-----------------------------    
		 SET @ClientAliases = ''    
		 SELECT   @ClientAliases = @ClientAliases + ( CA.LastName + ', ' + CA.Firstname + ' '  )  + ', '     
		 FROM Clients C          
		 INNER JOIN ClientAliases CA ON CA.ClientID = C.ClientID           
		 WHERE   C.ClientID = @ClientId          
		 AND ISNULL(C.RecordDeleted, 'N') = 'N'            
		 AND ISNULL(CA.RecordDeleted, 'N') = 'N'            
		      
		 SET @ClientAliases = SUBSTRING(@ClientAliases, 0, LEN(@ClientAliases))    
		 ----End ClientAliases-----------------------------    
    End
    
	if @AllergiesToolTipRequired = 'Y'
	Begin
		     
		  ----Allergies-------------------------------757810 ---    
	  
		 SET @CurrentClientAllergies = ''    
		 --SELECT @CurrentClientAllergies = COALESCE(@CurrentClientAllergies + ', ', '') + MDA.ConceptDescription    
		 SELECT   @CurrentClientAllergies = @CurrentClientAllergies + MDA.ConceptDescription  + ', '          
		 FROM MDAllergenConcepts MDA          
		 INNER join ClientAllergies CA ON CA.AllergenConceptId=MDA.AllergenConceptId AND        
				  CA.ClientId=@ClientId AND         
				  IsNull(CA.RecordDeleted,'N')='N' AND         
				  IsNull(MDA.RecordDeleted,'N')='N' AND         
				  IsNull(CA.Active,'Y')='Y' AND CA.AllergyType='A'            
		 ORDER BY MDA.ConceptDescription       
		     
		 SET @CurrentClientAllergies = SUBSTRING(@CurrentClientAllergies, 0, LEN(@CurrentClientAllergies))    

		 ----End Allergies-----------------------------    
	End
	
	if @ProviderToolTipRequired = 'Y'
    Begin

		 --Start Provider Name-----------------    
		 SET @Providers = ''    
		 SELECT   @Providers = @Providers +  P.ProviderName  + ', '     
		  FROM Providers P      
		  INNER JOIN StaffProviders SP ON SP.ProviderId = P.ProviderId      
		  INNER JOIN  ProviderClients PC ON PC.ProviderId = P.ProviderId    
		  INNER JOIN  Clients C ON C.ClientId = PC.ClientId     
		  WHERE PC.ClientId=@ClientId AND SP.STAFFID = @StaffId        
		  AND Isnull(P.RECORDDELETED, 'N') = 'N'      
		  AND Isnull(SP.RECORDDELETED, 'N') = 'N'    
		  AND Isnull(PC.RECORDDELETED, 'N') = 'N'   
		  AND Isnull(C.RECORDDELETED, 'N') = 'N' 
		       
		  SET @Providers = SUBSTRING(@Providers, 0, LEN(@Providers))    
	End	    

	--END MHP-Customizations - Task 121 RK-------------------------------------  
  SET @MedicaidId = (      
    SELECT TOP 1 ccp.InsuredId --Added by Chita Ranjan Network180 Support Go Live #1020      
    FROM ClientcoveragePlans AS ccp      
    INNER JOIN ClientCoverageHistory AS cch ON cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId      
    WHERE ccp.ClientId = @ClientId      
     AND datediff(day, cch.StartDate, getdate()) >= 0      
     AND (      
      cch.EndDate IS NULL      
      OR datediff(day, cch.EndDate, getdate()) <= 0      
      )      
     AND isnull(ccp.RecordDeleted, 'N') = 'N'      
     AND isnull(cch.RecordDeleted, 'N') = 'N'      
    ORDER BY cch.StartDate DESC      
     ,cch.COBOrder      
    )      
      
  SELECT @PrimaryProgram = ISNULL(ProgramName, '')      
  FROM Programs      
  WHERE ProgramId = (      
    SELECT TOP 1 ProgramId      
    FROM ClientPrograms      
    WHERE clientid = @ClientId      
     AND PrimaryAssignment = 'Y'      
     AND STATUS <> 5      
     AND ISNULL(RecordDeleted, 'N') = 'N'      
    )      
   AND ISNULL(RecordDeleted, 'N') = 'N'      
      
  SELECT @Medication = REPLACE(REPLACE(STUFF((      
       SELECT DISTINCT ', ' + MDM.MedicationName + ' ' + MM.Strength + ' ' + MM.StrengthUnitOfMeasure      
       FROM ClientMedications CM      
       INNER JOIN MDMedicationNames MDM ON MDM.MedicationNameId = CM.MedicationNameId      
        AND ISNULL(MDM.RecordDeleted, 'N') = 'N'           INNER JOIN ClientMedicationInstructions AS CMI ON CM.ClientMedicationId = CMI.ClientMedicationId      
        AND ISNULL(CMI.RecordDeleted, 'N') = 'N'      
       INNER JOIN MdMedications MM ON CMI.StrengthId = MM.MedicationId      
        AND ISNULL(MM.RecordDeleted, 'N') = 'N'      
       WHERE CM.ClientId = @ClientId      
        AND ISNULL(CM.RecordDeleted, 'N') = 'N'      
        AND ISNULL(CM.MedicationEndDate, getdate()) >= GetDate()      
        AND ISNULL(CM.MedicationStartDate, getdate()) <= GetDate()      
        AND ISNULL(CM.Discontinued, 'N') = 'N'      
       FOR XML PATH('')      
       ), 1, 1, ''), '&lt;', '<'), '&gt;', '>')      
      
  --Added the logic by Veena on 05/03/16  to display the beds in comma separated values if there are multiple beds are occupied by the client,also added status "on leave" with occuplied in the status check,Woods Support Go live #10       
  SELECT @ResidentialBedUnit = REPLACE(REPLACE(STUFF((      
       SELECT DISTINCT ', ' + B.BedName      
       FROM BedAssignments BA      
       JOIN ClientInPatientVisits CIV ON BA.ClientInpatientVisitId = CIV.ClientInpatientVisitId      
       JOIN Beds B ON B.BedId = BA.BedId      
       JOIN Rooms R ON B.RoomId = R.RoomId      
       JOIN Units U ON R.UnitId = U.UnitId      
       JOIN Programs AS PS ON BA.ProgramId = PS.ProgramId      
       WHERE CIV.ClientId = @ClientId      
        AND CIV.DischargedDate IS NULL      
        AND CIV.STATUS IN (      
         4982      
         ,4983      
         ) --Added on leave condition for ClientInPatientVisits table also Woods Support Go live #10       
        AND ISNULL(BA.RecordDeleted, 'N') = 'N'      
        AND ISNULL(CIV.RecordDeleted, 'N') = 'N'      
        AND BA.STATUS IN (      
         5002      
         ,5006      
         ) --Added status on leave for Woods Support Go live #10      
        AND BA.Disposition IS NULL      
        AND BA.EndDate IS NULL      
        AND ISNULL(PS.ResidentialProgram, '') = 'Y' -- Added by Jayashree w.r.t Woods - Environment Issues Tracking  #85        
       FOR XML PATH('')      
       ), 1, 1, ''), '&lt;', '<'), '&gt;', '>')      
  
  --Updated for MHP-Customizations - Task 121 RK
  SELECT @ClientName = (C.LastName + ', ' + C.FirstName)      
   ,@DOB = (CONVERT(VARCHAR(10), C.DOB, 101) + ' ' + CONVERT(VARCHAR(10), DATEDIFF(hour, C.DOB, GETDATE()) / 8766) + ' years old')      
   ,@Sex = (      
    CASE C.Sex      
     WHEN 'M'      
      THEN 'Male'      
     WHEN 'F'      
      THEN 'Female'      
     WHEN 'U'      
      THEN 'Unknown'      
     WHEN 'Male'  
      THEN 'Male'  
     WHEN 'Female'  
      THEN 'Female'  
     WHEN 'Transmale/Transman/FTM'  
      THEN 'Transmale/Transman/FTM'  
     WHEN 'Transfemale/Transwoman/MTF'  
      THEN 'Transfemale/Transwoman/MTF'  
     WHEN 'Genderqueer/Gender-Non-Conforming'  
      THEN 'Genderqueer/Gender-Non-Conforming'  
     WHEN 'Different Identity'  
      THEN 'Different Identity'  
     WHEN 'Other'  
      THEN 'Other'  
     ELSE ''  
     END      
    )      
   ,@PrimaryClinicianName = (ISNULL(COALESCE(S.LastName + ', ' + S.FirstName, S.LastName, S.FirstName), ''))      
   ,@SSN = ISNULL(C.SSN, '')      
   ,@PrimaryLanguage =GC.codename     
   ,@GenderIdentity = GI.codename     
   ,@CurrentBalance = c.CurrentBalance     
       
  FROM Clients C      
  LEFT JOIN Staff S ON S.StaffId = C.PrimaryClinicianId      
  LEFT JOIN Programs P ON P.ProgramId = C.PrimaryProgramId      
  LEFT JOIN ClientMedications CM ON CM.ClientId = C.ClientId      
  --RK --Updated for MHP-Customizations - Task 121 RK
  LEFT JOIN GlobalCodes GC on GC.GlobalCodeId=c.PrimaryLanguage     
  LEFT JOIN GlobalCodes GI on GI.GlobalCodeId=c.GenderIdentity     
  -------------------------    
  WHERE C.ClientId = @ClientId      
      
  DECLARE @SSNContent VARCHAR(MAX)      
  DECLARE @BedContent VARCHAR(MAX)      
  DECLARE @MedicaidContent VARCHAR(MAX)      
  DECLARE @ClientAddress VARCHAR(MAX)      
  DECLARE @Address VARCHAR(150)      
  DECLARE @City VARCHAR(50)      
  DECLARE @State VARCHAR(2)      
  DECLARE @Zip VARCHAR(25)      
  DECLARE @PhoneNumber VARCHAR(100)      
  DECLARE @ClientPlans VARCHAR(500)      
  DECLARE @ClientDateOfEnrollment VARCHAR(500)      
  DECLARE @ClientStatus VARCHAR(500)      
  DECLARE @PrimaryPharmacy VARCHAR(500)      
      
  SELECT TOP 1 @Address = ISNULL(CA.[Address], '')      
   ,@City = ISNULL(CA.[City], '')      
   ,@State = ISNULL(CA.[State], '')      
   ,@Zip = ISNULL(CA.[Zip], '')      
  FROM ClientAddresses CA      
  JOIN GlobalCodes GC ON CA.AddressType = GC.GlobalCodeId      
  WHERE CA.ClientId = @ClientId      
   AND ISNULL(CA.RecordDeleted, 'N') = 'N'      
 AND ISNULL(GC.RecordDeleted, 'N') = 'N'      
  ORDER BY GC.GlobalCodeId ASC      
      
  IF @Address IS NOT NULL      
  BEGIN      
   SET @ClientAddress = '<span>' + @Address + '</span>'      
  END      
      
  IF @City IS NOT NULL      
  BEGIN      
   IF @ClientAddress IS NOT NULL      
   BEGIN      
    SET @ClientAddress += '<span>, ' + @City + '</span>'      
   END      
   ELSE      
   BEGIN      
    SET @ClientAddress = '<span>' + @City + '</span>'      
   END      
  END      
      
  IF @State IS NOT NULL      
  BEGIN      
   IF @ClientAddress IS NOT NULL      
   BEGIN      
    SET @ClientAddress += '<span>, ' + @State + '</span>'      
   END      
   ELSE      
   BEGIN      
    SET @ClientAddress = '<span>' + @State + '</span>'      
   END      
  END      
      
  IF @Zip IS NOT NULL      
  BEGIN      
   IF @ClientAddress IS NOT NULL      
   BEGIN      
    SET @ClientAddress += '<span> ' + @Zip + '</span>'      
   END      
   ELSE      
   BEGIN      
    SET @ClientAddress = '<span>' + @Zip + '</span>'      
   END      
  END      
      
  SELECT TOP 1 @PhoneNumber = CP.PhoneNumber      
  FROM ClientPhones CP      
  JOIN GlobalCodes GC ON CP.PhoneType = GC.GlobalCodeId      
  WHERE CP.ClientId = @ClientId      
   AND ISNULL(CP.RecordDeleted, 'N') = 'N'      
   AND ISNULL(GC.RecordDeleted, 'N') = 'N'      
   AND ISNULL(CP.PhoneNumber, '') <> ''      
  ORDER BY GC.GlobalCodeId ASC      
      
  IF @ClientRecentCoverageplanRequired ='Y'      
  BEGIN      
   SELECT TOP 1 @ClientPlans = CP.DisplayAs      
   FROM ClientcoveragePlans AS ccp      
   INNER JOIN ClientCoverageHistory AS cch ON cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId      
   INNER JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId      
   WHERE ccp.ClientId = @ClientId      
    AND datediff(day, cch.StartDate, getdate()) >= 0      
    AND (      
     cch.EndDate IS NULL      
     OR datediff(day, cch.EndDate, getdate()) <= 0      
     )      
    AND isnull(ccp.RecordDeleted, 'N') = 'N'      
    AND isnull(cch.RecordDeleted, 'N') = 'N'      
   ORDER BY cch.StartDate DESC      
    ,cch.COBOrder      
  END      
  ELSE      
  BEGIN      
   DECLARE @Plans TABLE (      
    RowNumber INT identity(1, 1)      
    ,PlanName VARCHAR(100) --Added by sunil.d as per task Offshore QA Bugs #541      
    ,COBOrder INT      
    )      
      
   INSERT INTO @Plans (      
    PlanName      
    ,COBOrder      
    )      
   SELECT DISTINCT CP.DisplayAs      
    ,cch.COBOrder --Added by Neelima as per task Woods - Customizations #49      
   FROM ClientCoveragePlans CCP      
   INNER JOIN ClientCoverageHistory CCH ON CCH.ClientCoveragePlanId = CCP.ClientCoveragePlanId      
   INNER JOIN CoveragePlans CP ON CP.CoveragePlanId = CCP.CoveragePlanId      
   WHERE CCP.ClientId = @ClientId      
    AND ISNULL(CCP.RecordDeleted, 'N') = 'N'      
    AND ISNULL(CCH.RecordDeleted, 'N') = 'N'      
    AND ISNULL(CP.RecordDeleted, 'N') = 'N'      
    AND CAST(CONVERT(VARCHAR(10), CCH.StartDate, 101) AS DATETIME) <= CAST(CONVERT(VARCHAR(10), GETDATE(), 101) AS DATETIME)      
    AND CAST(ISNULL(CONVERT(VARCHAR(10), EndDate, 101), '01/01/2070') AS DATETIME) >= CAST(CONVERT(VARCHAR(10), GETDATE(), 101) AS DATETIME)      
   ORDER BY --CP.DisplayAs ASC  --Commented by Neelima as per task Woods - Customizations #49      
    cch.COBOrder ASC      
      
   SELECT @ClientPlans = ISNULL(@ClientPlans + ',', '') + CASE WHEN LEN(PlanName) > 25      
   THEN LTRIM(SUBSTRING(PlanName, 1, 25))  + '...'                                           
   ELSE PlanName END      
   FROM @Plans      
   WHERE RowNumber <= 2      
      
   IF (      
     SELECT COUNT(1)      
     FROM @Plans      
     ) > 2      
   BEGIN      
    SET @ClientPlans = @ClientPlans + ' etc'      
   END      
  END      
      
  SELECT TOP 1 @ClientStatus = GC.ExternalCode1      
  FROM ClientEpisodes AS CE --Logic Added by Neelima as per task Woods - Customizations #49      
  LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = CE.STATUS      
  WHERE Category = 'EPISODESTATUS'      
   AND ISNULL(GC.RecordDeleted, 'N') = 'N'      
   AND ISNULL(CE.RecordDeleted, 'N') = 'N'      
   AND Active = 'Y'      
   AND CE.ClientId = @ClientId -- Munish Sood 3/31/2017      
  ORDER BY ce.EpisodeNumber DESC      
      
  IF @DateOfEnrollmentRequired = 'Y' --Logic Added by Neelima as per task Woods - Customizations #49      
  BEGIN      
   IF (      
     @ClientStatus = 'REGISTERED'      
     OR @ClientStatus = 'INTREATMENT'      
     )      
   BEGIN      
    SELECT TOP 1 @ClientDateOfEnrollment = CONVERT(VARCHAR(10), CE.TxStartDate, 101)      
    FROM ClientEpisodes AS CE      
    LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = CE.STATUS      
    WHERE CE.ClientId = @ClientId      
     AND ISNULL(GC.RecordDeleted, 'N') = 'N'      
     AND ISNULL(CE.RecordDeleted, 'N') = 'N'      
     AND ISNULL(CE.DischargeDate, '') = ''      
    ORDER BY CE.RegistrationDate DESC -- Added by Jayashree w.r.t Woods - Environment Issues Tracking  #85      
   END      
   ELSE      
   BEGIN      
    SELECT TOP 1 @ClientDateOfEnrollment = ''      
   END      
  END      
      
  IF @PrimaryPharmacyRequired = 'Y' --Logic Added by Neelima as per task Woods - Customizations #49      
  BEGIN      
   SELECT TOP 1 @PrimaryPharmacy = Ph.PharmacyName      
   FROM ClientPharmacies CP --Added by Neelima as per task Woods - Customizations #49      
   LEFT JOIN Pharmacies Ph ON CP.PharmacyId = Ph.PharmacyId      
   WHERE CP.ClientId = @ClientId      
    AND ISNULL(CP.RecordDeleted, 'N') = 'N'      
    AND ISNULL(Ph.RecordDeleted, 'N') = 'N'      
  END      
      
  SET @ClientName = '<div >Name: ' + ISNULL(@ClientName, '') + '</div>'      
  SET @ClientAliases = '<div>Alias(es): ' + ISNULL(@ClientAliases, '') + '</div>'     
  SET @ClientAddress = '<div>Address: ' + ISNULL(@ClientAddress, '') + '</div>'      
  SET @PhoneNumber = '<div>Phone: ' + ISNULL(@PhoneNumber, '') + '</div>'      
  SET @DOB = '<div>Date of Birth: ' + ISNULL(@DOB, '') + '</div>'      
  SET @Sex = '<div>Gender: ' + ISNULL(@Sex, '') + '</div>'      
  SET @GenderIdentity = '<div>GenderIdentity: ' + ISNULL(@GenderIdentity, '') + '</div>'  --RK    
  SET @PrimaryLanguage = '<div>PrimaryLanguage: ' + ISNULL(@PrimaryLanguage, '') + '</div>'  --RK    
  SET @SSNContent = '<div>SSN: ' + SUBSTRING(@SSN, 1, 3) + '-' + SUBSTRING(@SSN, 4, 2) + '-' + SUBSTRING(@SSN, 6, 4) + '</div>';      
  SET @Gaurdian = '<div>Guardian: ' + ISNULL(@Gaurdian, '') + '</div>'  --RK     
  SET @CurrentBalance = '<div>Outstanding Balance: ' + ISNULL(@CurrentBalance, '') + '</div>'  --RK    
  SET @ClientPlans = '<div>Coverage Plan: ' + ISNULL(@ClientPlans, '') + '</div>'      
  SET @MedicaidContent = '<div>Medicaid ID: ' + ISNULL(@MedicaidId, '') + ' </div>'      
  SET @PrimaryClinicianName = '<div>Primary Clinician: ' + ISNULL(@PrimaryClinicianName, '') + '</div>'      
  SET @PrimaryProgram = '<div>Primary Program: ' + ISNULL(@PrimaryProgram, '') + '</div>'      
  SET @BedContent = '<div>Residential Unit(Bed): ' + ISNULL(@ResidentialBedUnit, '') + '</div>'      
  SET @CurrentClientAllergies = '<div>Allergy: ' + ISNULL(@CurrentClientAllergies, '') + '</div>'      
  SET @Medication = '<div>Medications: ' + ISNULL(@Medication, '') + '</div>'      
  SET @ClientDateOfEnrollment = '<div>Date Of Enrollment: ' + ISNULL(@ClientDateOfEnrollment, '') + '</div>' --Added by Neelima as per task Woods - Customizations #49      
  SET @PrimaryPharmacy = '<div>Pharmacy: ' + ISNULL(@PrimaryPharmacy, '') + '</div>' --Added by Neelima as per task Woods - Customizations #49      
  SET @Providers = '<div>Providers: ' + ISNULL(@Providers, '') + '</div>' --RK--  
  SET @ClientInformation = '<div style="background:#F8F8F8;border-radius:5px;width:400px;border:solid 1px darkblue;" ><table width="400px"><tr><td >'      
  --Added by Shankha per Engineering Improvement Initiatives- NBL(I)# 239       
  SET @ClientInformation = @ClientInformation + @ClientName     
  
  IF ISNULL(@AliasToolTipRequired , 'N') = 'Y'      --Added for MHP-Customizations - Task 121 RK   
  SET @ClientInformation = @ClientInformation + @ClientAliases      
      
  --IF ISNULL(@ClientAddressRequired, 'N') = 'Y'      
  IF @ClientAddressRequired= 'Y'    
   SET @ClientInformation = @ClientInformation + @ClientAddress      
      
  IF ISNULL(@PhoneNumberRequired, 'N') = 'Y'      
   SET @ClientInformation = @ClientInformation + @PhoneNumber      
      
  IF ISNULL(@DOBRequired, 'N') = 'Y'      
   SET @ClientInformation = @ClientInformation + @DOB      
      
  IF ISNULL(@SexRequired, 'N') = 'Y'      
   SET @ClientInformation = @ClientInformation + @Sex      
  
  IF ISNULL(@GenderIdentityToolTipRequired , 'N') = 'Y'     --Added for MHP-Customizations - Task 121 RK  
   SET @ClientInformation = @ClientInformation + @GenderIdentity     
       
  IF ISNULL(@PrimaryLanguageToolTipRequired , 'N') = 'Y'     --Added for MHP-Customizations - Task 121 RK   
   SET @ClientInformation = @ClientInformation + @PrimaryLanguage     
      
  IF ISNULL(@SSNRequired, 'N') = 'Y'        --Added for MHP-Customizations - Task 121 RK  
   SET @ClientInformation = @ClientInformation + @SSNContent      
  
  IF ISNULL(@GuardianToolTipRequired , 'N') = 'Y'      
   SET @ClientInformation = @ClientInformation + @Gaurdian   --Added for MHP-Customizations - Task 121 RK 
      
  IF ISNULL(@OutstandingBalanceToolTipRequired , 'N') = 'Y'      
   SET @ClientInformation = @ClientInformation + @CurrentBalance     --Added for MHP-Customizations - Task 121 RK 
       
  IF ISNULL(@ClientPlansRequired, 'N') = 'Y'      
   SET @ClientInformation = @ClientInformation + @ClientPlans      
      
  IF ISNULL(@MedicaidIDRequired, 'N') = 'Y'      
   SET @ClientInformation = @ClientInformation + @MedicaidContent      
      
  IF ISNULL(@PrimaryClinicianNameRequired, 'N') ='Y'      
   SET @ClientInformation = @ClientInformation + @PrimaryClinicianName      
      
  IF ISNULL(@PrimaryProgramRequired, 'N') = 'Y'      
   SET @ClientInformation = @ClientInformation + @PrimaryProgram      
      
  IF ISNULL(@ResidentialBedUnitRequired, 'N') = 'Y'      
   SET @ClientInformation = @ClientInformation + @BedContent      
       
  IF ISNULL(@AllergiesToolTipRequired , 'N') = 'Y'      
   SET @ClientInformation = @ClientInformation + @CurrentClientAllergies   --Added for MHP-Customizations - Task 121 RK    
      
  IF ISNULL(@MedicationRequired, 'N') = 'Y'      
   SET @ClientInformation = @ClientInformation + @Medication      
      
  IF ISNULL(@DateOfEnrollmentRequired, 'N') ='Y' --Added by Neelima as per task Woods - Customizations #49      
   SET @ClientInformation = @ClientInformation + @ClientDateOfEnrollment      
      
  IF ISNULL(@PrimaryPharmacyRequired, 'N') = 'Y' --Added by Neelima as per task Woods - Customizations #49      
   SET @ClientInformation = @ClientInformation + @PrimaryPharmacy      
      
  IF ISNULL(@ProviderToolTipRequired , 'N') = 'Y'   --Added for MHP-Customizations - Task 121 RK 
   SET @ClientInformation = @ClientInformation + @Providers
       
  --   Added by Deej--       
  IF EXISTS (      
    SELECT *      
    FROM sys.objects      
    WHERE object_id = OBJECT_ID(N'[dbo].[SCSP_SCGetClientInformationToolTip]')      
     AND type IN (      
      N'P'      
      ,N'PC'      
      )      
    )      
  BEGIN      
   EXEC SCSP_SCGetClientInformationToolTip @ClientId,@ClientInformation OUTPUT ,@StaffId 
  END      
      
  --      
  SET @ClientInformation = @ClientInformation + '</td><td valign="top" align="right"><img style="width:100px;height:100px;" src="##imageURL##" alt="Alternate Text" /></td></tr></table></div>'      
      
  IF ISNULL(@ClientInformationToolTipRequired, 'Y') = 'N'      
   SET @ClientInformation = '';      
      
  IF ISNULL(@ClientAddressRequired, 'N') = 'N'      
   AND ISNULL(@PhoneNumberRequired, 'N') = 'N'      
   AND ISNULL(@DOBRequired, 'N') = 'N'      
   AND ISNULL(@SexRequired, 'N') = 'N'      
   AND ISNULL(@SSNRequired, 'N') = 'N'      
   AND ISNULL(@ClientPlansRequired, 'N') = 'N'      
   AND ISNULL(@MedicaidIDRequired, 'N') = 'N'      
   AND ISNULL(@PrimaryClinicianNameRequired, 'N') = 'N'      
   AND ISNULL(@PrimaryProgramRequired, 'N') = 'N'      
   AND ISNULL(@ResidentialBedUnitRequired, 'N') = 'N'      
   AND ISNULL(@MedicationRequired, 'N') = 'N'      
   AND ISNULL(@DateOfEnrollmentRequired, 'N') = 'N' --Added by Neelima as per task Woods - Customizations #49      
   AND ISNULL(@PrimaryPharmacyRequired, 'N') = 'N' --Added by Neelima as per task Woods - Customizations #49      
  BEGIN      
   SET @ClientInformation = ''      
  END      
      
  SELECT @ClientInformation AS ClientInfo;        
  --print @Gaurdian    
    
  --------End--------      
  END      
      
      
      
      
 --END      
END TRY      
      
BEGIN CATCH      
 DECLARE @Error VARCHAR(8000)      
      
 SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_GetClientInformationToolTip') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()      
  ) + '*****' + Convert(VARCHAR, ERROR_STATE())      
      
 RAISERROR (      
   @Error      
   ,-- Message text.               
   16      
   ,-- Severity.               
   1 -- State.                                                                 
   );      
END CATCH 
GO


