/****** Object:  StoredProcedure [dbo].[ssp_RDLDocumentRegistrationDemographics]    Script Date: 08/20/2018 16:23:57 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLDocumentRegistrationDemographics]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLDocumentRegistrationDemographics]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLDocumentRegistrationDemographics]    Script Date: 08/20/2018 16:23:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].ssp_RDLDocumentRegistrationDemographics (@DocumentVersionId INT)
AS
/******************************************************************************                                  
**  File: ssp_RDLDocumentRegistrationDemographics.sql                
**  Name: ssp_RDLDocumentRegistrationDemographics           
**  Desc:  Get data for Demographics tab Sub report                         
**  Return values: <Return Values>                                                                 
**  Called by: <Code file that calls>                                                                                
**  Parameters:    @DocumentVersionId                              
**  Input   Output                                  
**  ----    -----------                                                                
**  Created By: Ravi                
**  Date:  Aug 06 2018                
*******************************************************************************                                  
**  Change History                                  
*******************************************************************************                                  
**  Date:			Author:    Description: 
	-----			-------		-----------
	Aug 06 2018		Ravi		Get data for Demographics tab Sub report
								Engineering Improvement Initiatives- NBL(I) > Tasks #618> Registration Document	                                     
*******************************************************************************/
BEGIN
	BEGIN TRY
			DECLARE @DOB Datetime
		SELECT TOP 1 @DOB = C.DOB
		FROM Documents D
		JOIN DocumentVersions DV ON D.DocumentId = DV.DocumentId
		JOIN Clients C ON C.ClientId = D.ClientId
		WHERE Dv.DocumentVersionId = @DocumentVersionId
			AND ISNULL(D.RecordDeleted, 'N') = 'N'
			AND ISNULL(DV.RecordDeleted, 'N') = 'N'
		
		
		Declare @age varchar(max)  
 --Declare @age varchar(10)  
      
  Select @age = Cast(DateDIFF(yy,@DOB,GETDATE()) - CASE WHEN GETDATE()>=DateAdd(yy,DateDIFF(yy,@DOB,GETDATE()), @DOB) THEN 0 ELSE 1 END as varchar(10))                                           
  
  if(@age = '0')      
   Begin      
    Select @age = Cast(DateDIFF(MM,@DOB,GETDATE()) - CASE WHEN GETDATE()>=DateAdd(MM,DateDIFF(MM,@DOB,GETDATE()), @DOB) THEN 0 ELSE 1 END as varchar(10))                                           
    
    if(@age = '0')    
  Begin    
   Select @age = Cast(DateDIFF(DD,@DOB,GETDATE()) - CASE WHEN GETDATE()>=DateAdd(DD,DateDIFF(DD,@DOB,GETDATE()), @DOB) THEN 0 ELSE 1 END as varchar(10))                                           
       
   Set @age = Cast(Cast(@age as int) - 1 as varchar) + ' Days'    
  End    
 Else    
  Begin     
   Set @age = @age + ' Months'     
  End    
   End      
  Else      
  Begin      
   Set @age = @age + ' Years'      
  End        
    
   
		
		SELECT @age AS Age
			,CONVERT(VARCHAR(10), RD.DOB, 101) AS DOB
			,RD.Comment
			,CASE 
				WHEN ISNULL(RD.Sex, '') = 'M'
					THEN 'Male'
				WHEN ISNULL(RD.Sex, '') = 'F'
					THEN 'Female'
				WHEN ISNULL(RD.Sex, '') = 'U'
					THEN 'Unknown'
				ELSE ''
				END AS Sex
			,dbo.ssf_GetGlobalCodeNameById(RD.MaritalStatus) AS MaritalStatus
			,dbo.ssf_GetGlobalCodeNameById(RD.GenderIdentity) AS GenderIdentity
			,dbo.ssf_GetGlobalCodeNameById(RD.SexualOrientation) AS SexualOrientation
			,CONVERT(VARCHAR(10), RD.DeceasedOn, 101) AS DeceasedOn
			,dbo.ssf_GetGlobalCodeNameById(RD.CauseOfDeath) AS CauseOfDeath
			,dbo.ssf_GetGlobalCodeNameById(RD.PreferredGenderPronoun) AS PreferredGenderPronoun
			,RD.FinanciallyResponsible
			,'$'+replace(convert(varchar,cast(floor(RD.AnnualHouseholdIncome) as money),1), '.00', '')  AS AnnualHouseholdIncome
			,RD.NumberOfDependents
			,dbo.ssf_GetGlobalCodeNameById(RD.LivingArrangement) AS LivingArrangement
			,ltrim(rtrim(C1.CountyName))+' - '+S1.StateAbbreviation as CountyOfResidence
			,ltrim(rtrim(C2.CountyName))+' - '+S2.StateAbbreviation as CountyOfTreatment
			,dbo.ssf_GetGlobalCodeNameById(RD.EducationalStatus) AS EducationalStatus
			,dbo.ssf_GetGlobalCodeNameById(RD.MilitaryStatus) AS MilitaryStatus
			,dbo.ssf_GetGlobalCodeNameById(RD.EmploymentStatus) AS EmploymentStatus
			,RD.EmploymentInformation
			,dbo.ssf_GetGlobalCodeNameById(RD.PrimaryLanguage) AS PrimaryLanguage
			,RD.DoesNotSpeakEnglish
			,dbo.ssf_GetGlobalCodeNameById(RD.HispanicOrigin) AS HispanicOrigin
			,dbo.ssf_GetGlobalCodeNameById(RD.ReminderPreference) AS ReminderPreference
			,dbo.ssf_GetGlobalCodeNameById(RD.MobilePhoneProvider) AS MobilePhoneProvider
			,RD.SchedulingPreferenceMonday
			,RD.SchedulingPreferenceTuesday
			,RD.SchedulingPreferenceWednesday
			,RD.SchedulingPreferenceThursday
			,RD.SchedulingPreferenceFriday
			,RD.GeographicLocation
			,RD.SchedulingComment
			,RD.ClientDoesNotHavePCP
			,EP.Name AS PrimaryCarePhysician
			,EP.OrganizationName
			,EP.PhoneNumber
			,EP.Email
			,(SELECT ISNULL(STUFF((
								SELECT CHAR(13) + CHAR(10) + ISNULL(dbo.csf_GetGlobalCodeNameBYId(CE.EthnicityId), '')
								FROM DocumentRegistrationClientEthnicities CE
								WHERE RD.DocumentVersionId = CE.DocumentVersionId
								AND ISNULL(CE.RecordDeleted, 'N') = 'N'
								GROUP BY ISNULL(dbo.csf_GetGlobalCodeNameBYId(CE.EthnicityId), '')
								ORDER BY ISNULL(dbo.csf_GetGlobalCodeNameBYId(CE.EthnicityId), '')
								FOR XML PATH('')
									,type
								).value('.', 'nvarchar(max)'), 1, 2, ''), '')) AS Ethnicities
			,(SELECT ISNULL(STUFF((
								SELECT CHAR(13) + CHAR(10) + ISNULL(dbo.csf_GetGlobalCodeNameBYId(CR.RaceId), '')
								FROM DocumentRegistrationClientRaces CR
								WHERE RD.DocumentVersionId = CR.DocumentVersionId
								AND ISNULL(CR.RecordDeleted, 'N') = 'N'
								GROUP BY ISNULL(dbo.csf_GetGlobalCodeNameBYId(CR.RaceId), '')
								ORDER BY ISNULL(dbo.csf_GetGlobalCodeNameBYId(CR.RaceId), '')
								FOR XML PATH('')
									,type
								).value('.', 'nvarchar(max)'), 1, 2, ''), '')) AS Races
								
		 ,(SELECT ISNULL(STUFF((
								SELECT CHAR(13) + CHAR(10) + ISNULL(dbo.csf_GetGlobalCodeNameBYId(CD.ClientDeclinedToProvide), '')
								FROM DocumentRegistrationDemographicDeclines CD
								WHERE RD.DocumentVersionId = CD.DocumentVersionId
								AND ISNULL(CD.RecordDeleted, 'N') = 'N'
								GROUP BY ISNULL(dbo.csf_GetGlobalCodeNameBYId(CD.ClientDeclinedToProvide), '')
								ORDER BY ISNULL(dbo.csf_GetGlobalCodeNameBYId(CD.ClientDeclinedToProvide), '')
								FOR XML PATH('')
									,type
								).value('.', 'nvarchar(max)'), 1, 2, ''), '')) AS ClientDeclinedToProvide
		FROM DocumentRegistrationDemographics RD
		LEFT JOIN ExternalReferralProviders EP ON EP.ExternalReferralProviderId = RD.ExternalReferralProviderId
			AND ISNULL(EP.RecordDeleted, 'N') = 'N'
		LEFT JOIN Counties C1 on C1.CountyFIPS=RD.CountyOfResidence  
		LEFT JOIN Counties C2 on C2.CountyFIPS=RD.CountyOfTreatment
		LEFT JOIN States S1 ON S1.StateFIPS = C1.StateFIPS 
		LEFT JOIN States S2 ON S2.StateFIPS = C2.StateFIPS 
		WHERE RD.DocumentVersionId = @DocumentVersionId
			AND ISNULL(RD.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLDocumentRegistrationDemographics') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,16
				,- 1
				);
	END CATCH
END
