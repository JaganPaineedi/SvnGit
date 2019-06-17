/****** Object:  StoredProcedure [dbo].[ssp_GetMemberDetailedInformation]    Script Date: 06/11/2018 03:53:09 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetMemberDetailedInformation]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetMemberDetailedInformation]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetMemberDetailedInformation]   Script Date: 06/11/2018 03:53:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

       
CREATE PROCEDURE [dbo].[ssp_GetMemberDetailedInformation] ( @ClientId INT )            
AS /******************************************************************************                                                            
**  File:                                                             
**  Name: csp_GetMemberDetailedInformation                                                            
**  Desc: This storeProcedure will return information regarding Client                                                          
**                                                                          
**  Parameters:                                                            
**  Input  ClientId                                           
                                                              
**  Output     ----------       -----------              
**  DocumentId               
    Version              
              
**  Auth:  Minakshi Varma                                                        
**  Date:  17 September 2011                                                          
*******************************************************************************                                                            
**  Change History              
*******************************************************************************              
**  Date:   Author:   Description:              
**  --------  --------  -------------------------------------------              
**  March 21, 2012  Pralyankar      Modified for returning Emergency Contact from this SP              
**  March 22, 2012  Pralyankar      Modified for Adding Addition Information field for Inquiry              
**  May 09,2013  Shikha Arora Pulled From Newaygo Dev Env and commit in SVN              
*   May   06, 2013  Shikha Arora    Changes made to remove space that is present at the begining and end of the column ZIP w.rf.t the task #81 "Newyago-Bugs/Features"              
**  March 10, 2015  Akwinass        NEW Emergency contact information pulled in as per Task #78 in Valley Client Acceptance Testing Issues            
** 4/30/2015  NJain   Updated per Valley #28            
*******************************************************************************/              
              
    BEGIN               
        BEGIN TRY              
   --Client General InforMation--              
 --- If Emergency Contact Exists then Pull only that row otherwise pull any other row from client contacts.              
            IF EXISTS ( SELECT  1            
                        FROM    ClientContacts            
                        WHERE   ClientId = @ClientId            
                                AND EmergencyContact = 'Y' )            
                BEGIN              
                    SELECT  C.ClientId AS ClientId ,            
                            C.FirstName AS FirstName ,            
                            C.MiddleName AS MiddleName ,            
                            C.LastName AS LastName ,            
                            C.SSN AS SSN ,            
                            C.DOB AS DOB ,            
                            C.Email AS Email ,            
                            CA.Address AS Address ,            
                            CA.City AS City ,            
                            CA.State AS State ,              
							 --Changes made by shikha against the task #81 "Newaygo-Bugs/Features"                
							--CA.Zip as Zip,              
                            RTRIM(LTRIM(CA.Zip)) AS Zip ,            
                            CP.PhoneNumberText AS PhoneNumber ,            
                            C.CareManagementId AS MasterId ,            
                            CASE WHEN ISNULL(C.Sex, '') = '' THEN 'U'            
                                 ELSE C.Sex            
                            END AS Sex ,            
                            ClientContect.FirstName AS EmergencyContactFirstName ,            
                            ClientContect.MiddleName AS EmergencyContactMiddleName ,            
                           ClientContect.LastName AS EmergencyContactLastName ,            
                            ClientContect.Relationship AS EmergencyContactRelationToClient ,            
                            ClientContect.HomePhone AS EmergencyContactHomePhone ,            
                            ClientContect.CellPhone AS EmergencyContactCellPhone ,            
                            ClientContect.WorkPhone AS EmergencyContactWorkPhone ,            
                            EpisodeNumber ,            
                            A.ReferralDate ,            
                            A.ReferralType ,            
                            A.ReferralSubtype ,            
                            A.ReferralName ,            
                            A.ReferralAdditionalInformation ,            
                            A.RegistrationDate ,            
                            A.Status ,            
                            A.DischargeDate ,            
                            LivingArrangement ,            
                            NumberOfBeds ,            
                            CountyOfResidence ,            
                            CorrectionStatus ,            
                            --NULL AS COFR ,            
                            EducationalStatus ,            
                            EmploymentStatus ,            
                            EmploymentInformation ,            
                            CASE WHEN RTRIM(LTRIM(MinimumWage)) = 'YES' THEN 'Y'            
                                 ELSE 'N'            
                            END AS 'MinimumWage' ,            
                            NULL AS 'DHSAbuseNeglect' ,            
                            NULL AS 'AreyouVeteran'            
                    FROM    Clients C            
                            LEFT OUTER JOIN ClientAddresses CA ON CA.ClientId = C.ClientId            
                                                                  AND CA.AddressType = 90            
                            LEFT OUTER JOIN ClientPhones CP ON CP.ClientId = C.ClientId            
                                                               AND CP.PhoneType = 30            
                            LEFT OUTER JOIN ( SELECT TOP 1            
                                                        ClientContacts.ClientId ,            
                                                        ClientContacts.FirstName ,            
                                                        ClientContacts.MiddleName ,            
                                                        ClientContacts.LastName ,            
                                                        ClientContacts.Relationship ,            
                                                        HomePhone.PhoneNumber AS HomePhone ,            
                                                        CellPhone.PhoneNumber AS CellPhone ,            
                                                        WorkPhone.PhoneNumber AS WorkPhone            
                                              FROM      ClientContacts            
                                                        LEFT OUTER JOIN ClientContactPhones HomePhone ON HomePhone.ClientContactId = ClientContacts.ClientContactId            
                                                                                                         AND HomePhone.PhoneType = 30            
                                                        LEFT OUTER JOIN ClientContactPhones CellPhone ON CellPhone.ClientContactId = ClientContacts.ClientContactId            
                                                                                                         AND CellPhone.PhoneType = 34            
                                                        LEFT OUTER JOIN ClientContactPhones WorkPhone ON WorkPhone.ClientContactId = ClientContacts.ClientContactId            
														AND WorkPhone.PhoneType = 31            
                                              WHERE     ClientContacts.ClientId = @ClientId            
                                                        AND EmergencyContact = 'Y'            
                                              ORDER BY  ClientContacts.CreatedDate DESC            
                                            ) AS ClientContect ON ClientContect.ClientId = C.ClientId            
                            LEFT OUTER JOIN ( SELECT TOP 1            
                                                        EpisodeNumber ,            
                                                        ClientId ,            
                                                  ReferralDate ,            
                                                        ReferralType ,            
                                                        ReferralSubtype ,            
                                             ReferralName ,            
                                                        ReferralAdditionalInformation ,            
                                                        RegistrationDate ,            
                                                        Status ,            
                                                        DischargeDate            
                                              FROM      clientepisodes            
                                              WHERE     ClientId = @ClientId            
                                              ORDER BY  EpisodeNumber DESC            
                                            ) AS a ON A.ClientId = C.ClientId            
                    WHERE   C.ClientId = @ClientId              
                END                   
            ELSE            
                BEGIN              
                    SELECT  C.ClientId AS ClientId ,            
                            C.FirstName AS FirstName ,            
                            C.MiddleName AS MiddleName ,            
                            C.LastName AS LastName ,            
                            C.SSN AS SSN ,            
                            C.DOB AS DOB ,            
                            C.Email AS Email ,            
                            CA.Address AS Address ,            
                            CA.City AS City ,            
                            CA.State AS State ,                          
							 --Changes made by Shikha against the task #81 "Newaygo-Bugs/Features"                
							--CA.Zip as Zip,              
                            RTRIM(LTRIM(CA.Zip)) AS Zip ,            
                            CP.PhoneNumberText AS PhoneNumber ,            
                            C.CareManagementId AS MasterId ,            
                            CASE WHEN ISNULL(C.Sex, '') = '' THEN 'U'            
                                 ELSE C.Sex            
                            END AS Sex ,            
                            ClientContect.FirstName AS EmergencyContactFirstName ,            
                            ClientContect.MiddleName AS EmergencyContactMiddleName ,            
                            ClientContect.LastName AS EmergencyContactLastName ,            
                            ClientContect.Relationship AS EmergencyContactRelationToClient ,            
                            ClientContect.HomePhone AS EmergencyContactHomePhone ,            
                            ClientContect.CellPhone AS EmergencyContactCellPhone ,            
                            ClientContect.WorkPhone AS EmergencyContactWorkPhone ,            
                            EpisodeNumber ,            
                            A.ReferralDate ,            
                            A.ReferralType ,            
                            A.ReferralSubtype ,        
                            A.ReferralName ,            
                            A.ReferralAdditionalInformation ,            
                            A.RegistrationDate ,            
							A.Status ,            
                            A.DischargeDate ,            
                            LivingArrangement ,            
                            NumberOfBeds ,            
                            CountyOfResidence ,            
                            CorrectionStatus ,            
                            --NULL AS COFR ,            
                            EducationalStatus ,            
                            EmploymentStatus ,            
                            EmploymentInformation ,            
                            CASE WHEN RTRIM(LTRIM(MinimumWage)) = 'YES' THEN 'Y'            
                                 ELSE 'N'            
								END AS 'MinimumWage' ,            
                            NULL AS 'DHSAbuseNeglect' ,            
                            NULL AS 'AreyouVeteran'            
                    FROM    Clients C            
                            LEFT OUTER JOIN ClientAddresses CA ON CA.ClientId = C.ClientId            
   AND CA.AddressType = 90            
                            LEFT OUTER JOIN ClientPhones CP ON CP.ClientId = C.ClientId            
                                                               AND CP.PhoneType = 30            
                            LEFT OUTER JOIN ( SELECT TOP 1            
                                                        ClientContacts.ClientId ,            
                                                        ClientContacts.FirstName ,            
                                                        ClientContacts.MiddleName ,            
                                                        ClientContacts.LastName ,            
                                                        ClientContacts.Relationship ,            
                                                        HomePhone.PhoneNumber AS HomePhone ,            
                                                        CellPhone.PhoneNumber AS CellPhone ,            
                                                        WorkPhone.PhoneNumber AS WorkPhone            
                                              FROM      ClientContacts            
                                                        LEFT OUTER JOIN ClientContactPhones HomePhone ON HomePhone.ClientContactId = ClientContacts.ClientContactId            
                                                                                                         AND HomePhone.PhoneType = 30            
                                                        LEFT OUTER JOIN ClientContactPhones CellPhone ON CellPhone.ClientContactId = ClientContacts.ClientContactId            
                                                                                                         AND CellPhone.PhoneType = 34            
                                                        LEFT OUTER JOIN ClientContactPhones WorkPhone ON WorkPhone.ClientContactId = ClientContacts.ClientContactId            
                                                                                                         AND WorkPhone.PhoneType = 31            
                                              WHERE     ClientContacts.ClientId = @ClientId            
                                            ) AS ClientContect ON ClientContect.ClientId = C.ClientId            
                            LEFT OUTER JOIN ( SELECT TOP 1            
                                                        EpisodeNumber ,            
                                                        ClientId ,            
                                                        ReferralDate ,            
                                                        ReferralType ,            
                                                        ReferralSubtype ,            
                                                        ReferralName ,            
                                                        ReferralAdditionalInformation ,            
                                                        RegistrationDate ,            
                                                        Status ,            
                                                        DischargeDate            
                                              FROM      clientepisodes            
                                              WHERE     ClientId = @ClientId            
                                              ORDER BY  EpisodeNumber DESC            
                     ) AS a ON A.ClientId = C.ClientId            
                    WHERE   C.ClientId = @ClientId                    
                END                
              
            SELECT TOP 1            
                    NULL AS ReferralDate ,            
                    -1 AS ReferralType ,            
                    NULL AS ReferralSubtype ,            
                    NULL AS ReferalOrganizationName ,            
					NULL AS ReferalPhone ,            
                    NULL AS ReferalFirstName ,            
                    NULL AS ReferalLastName ,            
                    NULL AS ReferalAddressLine1 ,            
                    NULL AS ReferalAddressLine2 ,            
                    NULL AS ReferalCity ,            
                    NULL AS ReferalState ,            
                    NULL AS ReferalZip ,            
                    NULL AS ReferalEmail ,            
                    NULL AS ReferalComments ,                      
                    c.PrimaryLanguage AS PrimarySpokenLanguage ,  
                    PriorityPopulation           
            FROM    Inquiries a            
                    LEFT JOIN dbo.CustomClients b ON b.ClientId = a.ClientId            
                                                     AND ISNULL(b.RecordDeleted, 'N') = 'N'            
                    LEFT JOIN dbo.Clients c ON c.ClientId = a.ClientId            
                                               AND ISNULL(c.RecordDeleted, 'N') = 'N'            
            WHERE   a.ClientId = @ClientId            
                    AND ISNULL(a.RecordDeleted, 'N') = 'N'            
            ORDER BY a.InquiryId DESC                 
                        
                        
       DECLARE @InquiryId INT            
            SET @InquiryId = ( SELECT TOP 1            
                                        InquiryId            
                               FROM     Inquiries            
                               WHERE    ClientId = @ClientId            
                               ORDER BY InquiryId DESC            
                             )            
            
            
            
            SELECT  CRCP.CreatedBy ,            
                    CRCP.CreatedDate ,            
                    CRCP.ModifiedBy ,            
                    CRCP.ModifiedDate ,            
                    CRCP.RecordDeleted ,            
                    CRCP.DeletedBy ,            
                    CRCP.DeletedDate ,            
                    -1 AS InquiryId ,            
                    CRCP.CoveragePlanId ,            
                    CRCP.InsuredId ,            
                    CRCP.GroupNumber AS GroupId ,            
                    CRCP.Comment            
        FROM    ClientCoveragePlans CRCP            
                    LEFT JOIN CoveragePlans CP ON CP.CoveragePlanId = CRCP.CoveragePlanId            
            WHERE   ISNULL(CRCP.RecordDeleted, 'N') = 'N'            
                    AND ISNULL(CP.RecordDeleted, 'N') = 'N'            
                    AND ClientId = @ClientID            
                
            SELECT  CoveragePlanId ,            
                    DisplayAs            
            FROM    CoveragePlans        
                  
                  
            ----Demographics Data RK------------------------------------------------------      
                  
            SELECT         
				C.Active      
				 ,C.Prefix      
				 ,C.Suffix      
				 ,C.PrimaryClinicianId      
				 ,C.Comment      
				 ,C.LivingArrangement      
				 ,C.FinanciallyResponsible      
				 ,C.AnnualHouseholdIncome      
				 ,C.NumberOfDependents      
				 ,C.EmploymentStatus      
				 ,C.EmploymentInformation      
				 ,C.MilitaryStatus      
				 ,C.EducationalStatus      
				 ,C.DoesNotSpeakEnglish      
				 ,C.PrimaryLanguage      
				 ,C.HispanicOrigin      
				 ,C.DeceasedOn      
				 ,C.ReminderPreference      
				 ,C.MobilePhoneProvider      
				 ,C.SchedulingPreferenceMonday      
				 ,C.SchedulingPreferenceTuesday      
				 ,C.SchedulingPreferenceWednesday      
				 ,C.SchedulingPreferenceThursday      
				 ,C.SchedulingPreferenceFriday      
				 ,C.GeographicLocation      
				 ,C.SchedulingComment      
				 ,C.CauseOfDeath      
				 ,C.GenderIdentity      
				 ,C.SexualOrientation      
				 ,C.PrimaryPhysicianId      
				 ,C.ProfessionalSuffix     
				 ,Ltrim(Rtrim(CF.CountyName)) + ' - ' + Ss.StateAbbreviation as CountyOfTreatmentText    
				 ,c.MaritalStatus                           
                               
            From Clients C   
              
            --below 2 stmts added by rk   
            left join Counties CF on CF.CountyFIPS = C.CountyOfTreatment       
            left join States Ss on Ss.StateFIPs = CF.StateFIPs                                  
         
             WHERE   C.ClientId = @ClientId        
            ----End of Demographics Data-----------------------------------------------      
                  
	END TRY                                          
	BEGIN CATCH                            
		DECLARE @Error VARCHAR(8000)                                                          
		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetMemberDetailedInformation') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
	   
	 + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())                                            
	                                              
	 END CATCH       
END 