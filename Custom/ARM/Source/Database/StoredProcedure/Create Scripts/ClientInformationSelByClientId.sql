/****** Object:  StoredProcedure [dbo].[ClientInformationSelByClientId]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ClientInformationSelByClientId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ClientInformationSelByClientId]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ClientInformationSelByClientId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'  
  
CREATE Procedure [dbo].[ClientInformationSelByClientId]                  
 @ClientId INT                    
AS            
/******************************************************************************                    
**  File: dbo.ClientInformationSelByClientId                    
**  Name: dbo.ClientInformationSelByClientId.prc                    
**  Desc: This SP returns all the data from tables required by Client information functionality                    
**                    
**  This template can be customized:                    
**                                  
**  Return values:                    
**                     
**  Called by:                       
**                                  
**  Parameters:                    
**  Input       Output                    
**     ----------       -----------                    
**                    
**  Auth: Yogesh                    
**  Date: 17-May-06                    
*******************************************************************************                    
**  Change History                    
*******************************************************************************                    
**  Date:        Author:    Description:                    
**  --------    --------    -------------------------------------------                    
**  02-Jan-2007  Vikrant    To add CustomTimeliness                  
*******************************************************************************/                    
--Clients                            
SELECT                            
 CL.ClientId,                             
 CL.ExternalClientId,                             
 CL.Active,                             
 CL.MRN,                             
 CL.LastName,                             
 CL.FirstName,                             
 CL.MiddleName,                             
 CL.Prefix,                             
 CL.Suffix,                             
 CL.SSN,                             
 CL.Sex,                             
 CONVERT(VARCHAR,CL.DOB,101) AS DOB,                            
 case when convert(int,datediff(Year,CL.DOB,getdate()))=0  then null                             
 else convert(int,datediff(Year,CL.DOB,getdate()))end as [Age],                            
 CL.PrimaryClinicianId,                             
 CL.CountyOfResidence,                             
 CL.CorrectionStatus,                          
 CL.CountyOfTreatment,                             
 CL.Email,                             
 CL.Comment,                             
 CL.LivingArrangement,                             
 CL.NumberOfBeds,                             
 CL.MinimumWage,                             
 CL.FinanciallyResponsible,                             
 case when CL.AnnualHouseholdIncome is not null then ''$''+ convert(varchar,CL.AnnualHouseholdIncome) else                             
 convert(varchar,CL.AnnualHouseholdIncome) end as AnnualHouseholdIncomeStr,                            
 CL.AnnualHouseholdIncome,                            
 CL.NumberOfDependents,                             
 CL.MaritalStatus,                             
 CL.EmploymentStatus,                             
 CL.EmploymentInformation,                             
 CL.MilitaryStatus,                             
 CL.EducationalStatus,                             
 CL.DoesNotSpeakEnglish,                             
 CL.PrimaryLanguage,                             
 CL.CurrentEpisodeNumber,                             
 CL.AssignedAdminStaffId,                             
 CL.InformationComplete,                             
 CL.PrimaryProgramId,                             
 CL.LastNameSoundex,                             
 CL.FirstNameSoundex,                             
 CL.CurrentBalance,                             
 CL.CareManagementId,                             
 CL.HispanicOrigin,                             
 CONVERT(VARCHAR,CL.DeceasedOn,101) AS DeceasedOn,                              
 CL.LastStatementDate,                            
 CL.DoNotSendStatement,                            
 CL.DoNotSendStatementReason,                            
 CL.AccountingNotes,                            
 CL.InformationComplete,                            
 CL.LastPaymentId,                            
 CL.RowIdentifier,                        
 CL.ExternalReferenceId,                             
 CL.CreatedBy,                             
 CL.CreatedDate,                             
 CL.ModifiedBy,                  
 CL.ModifiedDate,                             
 CL.RecordDeleted,                             
 CL.DeletedDate,                             
 CL.DeletedBy,            
 CL.Disposition,          
 CL.HasAlternateTreatmentOrder,          
 CL.AlternateTreatmentOrderType,          
 CL.AlternateTreatmentOrderExpirationDate,                            
 GC1.codename as [Marital Status],                            
 GC2.codename as [Hispanic Origin],                             
 GC7.codename as [Living Arrangement],                            
 GC3.codename as [Primary Language],                            
 GC4.codename as [Educational Status],                            
 GC5.codename as [Military Status],                            
 GC6.codename as [Employment Status],                            
 case when S.degree is null then (S.LastName + '', '' + S.FirstName)                             
 else (S.LastName + '', '' + S.FirstName + '' '' + CONVERT(VARCHAR,GC8.CodeName))                             
 end AS [Primary Clinician],                             
 CC.CountyName as [County Of Residence],                            
 CC1.CountyName as [County Of Treatment]                            
FROM                            
 clients CL                            
LEFT JOIN                   
 GlobalCodes GC1                            
ON                            
 GC1.GlobalCodeId=CL.MaritalStatus                            
LEFT JOIN                             
 GlobalCodes GC2                            
ON                            
 GC2.GlobalCodeId=CL.HispanicOrigin                            
LEFT JOIN                             
 GlobalCodes GC3                            
ON                            
 GC3.GlobalCodeId=CL.PrimaryLanguage                            
LEFT JOIN                             
 GlobalCodes GC4                            
ON                            
 GC4.GlobalCodeId=CL.EducationalStatus                            
LEFT JOIN                             
 GlobalCodes GC5                            
ON                            
 GC5.GlobalCodeId=CL.MilitaryStatus                            
LEFT JOIN                             
 GlobalCodes GC6                            
ON                            
 GC6.GlobalCodeId=CL.EmploymentStatus                             
LEFT JOIN                             
 GlobalCodes GC7                            
ON                            
 GC7.GlobalCodeId=CL.LivingArrangement                            
LEFT JOIN                             
 staff S                            
ON                             
 S.StaffId=CL.PrimaryClinicianId                            
LEFT JOIN                            
 GlobalCodes GC8                            
ON                            
 GC8.GlobalCodeId=S.degree                            
LEFT JOIN                             
 Counties CC                            
ON                            
 CC.CountyFIPS=CL.CountyOfResidence                            
LEFT JOIN                             
 Counties CC1                            
ON                            
 CC1.CountyFIPS=CL.CountyOfTreatment                            
WHERE                             
 ClientId=@ClientId                            
                              
--ClientPhones Commented on 27 April 2007 for using PhoneControl                           
/*SELECT                             
  CP.ClientPhoneId                            
 ,CP.ClientId                            
 ,CP.PhoneType                            
 ,CP.PhoneNumber,                            
 (cp.PhoneNumber + '' '' + CP.PhoneNumberText) as phone                            
 ,CP.PhoneNumberText                            
 ,CP.IsPrimary                            
 ,CP.RowIdentifier                            
 ,CP.ExternalReferenceId                
 ,CP.CreatedBy                            
 ,CP.CreatedDate                            
 ,CP.ModifiedBy                            
 ,CP.ModifiedDate                            
 ,CP.RecordDeleted                            
 ,CP.DeletedDate                            
 ,CP.DeletedBy                            
 ,GC.CodeName AS Type                       
FROM                             
 ClientPhones CP                            
INNER JOIN                            
 GlobalCodes GC                            
ON                             
 CP.PhoneType = GC.GlobalCodeId                            
WHERE                             
 ClientId=@ClientId                            
AND                             
 (CP.RecordDeleted = ''N'' OR CP.RecordDeleted IS NULL)  */                           
                             
                            
/*SELECT * FROM ClientPhones                             
WHERE                             
 ClientId=@ClientId                            
AND                             
 (RecordDeleted = ''N'' OR RecordDeleted IS NULL) */                            
                --ClientPhones  Added on 27 April 2007 for using PhoneControl               
SELECT     ClientPhones.*, GlobalCodes.SortOrder              
FROM         ClientPhones INNER JOIN                
                      GlobalCodes ON ClientPhones.PhoneType = GlobalCodes.GlobalCodeId                
WHERE     (ClientPhones.ClientId = @ClientId) AND (ISNULL(ClientPhones.RecordDeleted, ''N'') = ''N'') AND (GlobalCodes.Active = ''Y'') AND                 
                      (ISNULL(GlobalCodes.RecordDeleted, ''N'') = ''N'')                
              
--ClientAddresses  Commented on 27 April 2007 for using AddressControl                          
/*SELECT                             
 CA.ClientAddressId,                             
 CA.ClientId,                             
 CA.AddressType,                             
 CA.Address,                             
 CA.City,                             
 CA.State,                             
 CA.Zip,                             
 CA.Display,                             
 CA.Display as Addresses,                             
 CA.Billing,                             
 CA.RowIdentifier,                             
 CA.ExternalReferenceId,                             
 CA.CreatedBy,                             
 CA.CreatedDate,                             
 CA.ModifiedBy,                             
 CA.ModifiedDate,                             
 CA.RecordDeleted,                             
 CA.DeletedDate,                             
 CA.DeletedBy,                            
 GC.CodeName,                            
 GC.GlobalCodeId,                            
 GC.CodeName as Type                            
FROM                            
 ClientAddresses AS CA                            
                            
INNER JOIN                            
 GlobalCodes GC                            
ON                             
 CA.AddressType = GC.GlobalCodeId                            
WHERE                             
 CA.ClientId=@ClientId                            
AND                             
 (CA.RecordDeleted = ''N'' OR CA.RecordDeleted IS NULL)  */            
--ClientAddresses Added on 27 April 2007 for using AddressControl                    
SELECT     ClientAddresses.*, GlobalCodes.SortOrder               
FROM         ClientAddresses INNER JOIN                
                      GlobalCodes ON ClientAddresses.AddressType = GlobalCodes.GlobalCodeId                
WHERE     (ClientAddresses.ClientId = @ClientId) AND (ISNULL(ClientAddresses.RecordDeleted, ''N'') = ''N'') AND (GlobalCodes.Active = ''Y'') AND                 
                      (ISNULL(GlobalCodes.RecordDeleted, ''N'') = ''N'')                              
                             
                             
--ClientEpisodes                            
SELECT                             
 CE.ClientEpisodeId,                             
 CE.ClientId,                             
 CE.EpisodeNumber,                            
 --CONVERT(VARCHAR,CE.RegistrationDate) AS RegistrationDate ,     
 CE.RegistrationDate,                           
 Status,                             
-- CONVERT(VARCHAR,CE.DischargeDate) AS DischargeDate ,                             
 CE.DischargeDate,                    
 --CONVERT(VARCHAR,CE.InitialRequestDate) AS InitialRequestDate ,                             
 CE.InitialRequestDate,                    
 CE.IntakeStaff,                            
-- CONVERT(VARCHAR,CE.AssessmentDate) AS AssessmentDate ,                             
 CE.AssessmentDate,         
 --CONVERT(VARCHAR,CE.AssessmentFirstOffered) AS AssessmentFirstOffered ,                            
 CE.AssessmentFirstOffered,                    
 CE.AssessmentDeclinedReason,                            
 --CONVERT(VARCHAR,CE.TxStartDate) AS TxStartDate ,                      
 CE.TxStartDate,                          
-- CONVERT(VARCHAR,CE.TxStartFirstOffered) AS TxStartFirstOffered,                        
 CE.TxStartFirstOffered,                         
 CE.TxStartDeclinedReason,                             
 CE.RegistrationComment,                  
 CE.ReferralSource,                             
 CE.ReferralType,                             
 CE.ReferralComment,                            
 CE.RowIdentifier,                             
 CE.ExternalReferenceId,                             
 CE.CreatedBy,                            
 CE.CreatedDate,                             
 CE.ModifiedBy,                             
 CE.ModifiedDate,                            
 CE.RecordDeleted,                             
 CE.DeletedDate,                             
 CE.DeletedBy,                            
 LastName + '', '' + FirstName AS [Intake Staff],                   
 GC1.codename as [Assessment Declined Reason],                            
 GC2.codename as [TxStart Declined Reason],                            
 GC3.codename as [Referral Source],                            
 GC4.codename as [Referral Type],                            
 GC5.codename as [Episode Status]                              
FROM                            
 ClientEpisodes CE                            
LEFT JOIN                            
 Staff S                            
ON                             
 CE.IntakeStaff=S.StaffId                            
LEFT JOIN                             
 GlobalCodes GC1                            
ON                            
 GC1.GlobalCodeId=CE.AssessmentDeclinedReason                             
LEFT JOIN                             
 GlobalCodes GC2                         
ON                            
 GC2.GlobalCodeId=CE.TxStartDeclinedReason                             
LEFT JOIN                             
 GlobalCodes GC3                            
ON                            
 GC3.GlobalCodeId=CE.ReferralSource                            
LEFT JOIN                             
 GlobalCodes GC4                            
ON                            
 GC4.GlobalCodeId=CE.ReferralType                            
LEFT JOIN                             
 GlobalCodes GC5                            
ON                            
 GC5.GlobalCodeId=CE.Status                            
WHERE                             
 ClientId=@ClientId                            
AND                             
 (CE.RecordDeleted = ''N'' OR CE.RecordDeleted IS NULL)                            
                            
                            
--Audit Event Category                            
SELECT                                
  GlobalCodeId,                            
  CodeName                
FROM                                     
  GlobalCodes                            
WHERE                             
  Category = ''AUDITEVENT''                             
  AND                             
  Active = ''Y''                            
  AND                            
  (RecordDeleted=''N'' OR RecordDeleted IS NULL)                            
ORDER BY CodeName                            
                            
--Client MedicaidID                            
SELECT                             
 CCP.InsuredId,CCP.ClientId,CCP.ClientCoveragePlanId, CCH.COBOrder                            
FROM            
 ClientCoveragePlans CCP                            
INNER JOIN                             
 CoveragePlans CP                            
ON                            
 CCP.CoveragePlanId = CP.CoveragePlanId                            
INNER JOIN                             
 ClientCoverageHistory CCH                            
ON                            
 CCP.ClientCoveragePlanId=CCH.ClientCoveragePlanId                            
                            
WHERE                            
 CP.MedicaidPlan=''Y''                   
AND                            
 (CP.RecordDeleted = ''N'' OR CP.RecordDeleted IS NULL)                            
AND                              
 (CCP.RecordDeleted = ''N'' OR CCP.RecordDeleted IS NULL)                            
AND                              
 (CCH.RecordDeleted = ''N'' OR CCH.RecordDeleted IS NULL)                            
AND                              
 ((CCH.StartDate <= GetDate() AND GetDate() <= CCH.EndDate)                             
OR                            
 (CCH.StartDate <= GetDate() AND CCH.EndDate IS NULL))                            
AND                             
 CCP.ClientId =@ClientId                            
                            
ORDER BY CCH.COBOrder                            
                             
--Alias Type                            
SELECT                            
 CA.ClientAliasId,                             
 CA.ClientId,         
 CA.LastName,                             
 CA.FirstName,                             
 CA.MiddleName,                             
 CA.AliasType,                            
 CA.allowsearch,                             
 case CA.allowsearch when ''Y'' then ''Yes'' else ''No'' end as allowsrch,                             
 CA.RowIdentifier,                             
 CA.CreatedBy,                             
 CA.CreatedDate,                             
 CA.ModifiedBy,                             
 CA.ModifiedDate,                             
 CA.RecordDeleted,                             
 CA.DeletedDate,                             
 CA.DeletedBy,                            
 GC.CodeName,                            
 GC.CodeName as Type,                            
 ''N'' AS RadioButton --For ClientAliasId Radio Button - TOBE Removed                    
FROM                            
 ClientAliases CA                            
                             
INNER JOIN                            
 GlobalCodes GC                            
ON                             
 CA.AliasType = GC.GlobalCodeId                            
WHERE                             
 CA.ClientId=@ClientId                            
AND                             
 (CA.RecordDeleted = ''N'' OR CA.RecordDeleted IS NULL)                            
                            
                            
--RaceBind Category                            
SELECT                            
 GlobalCodeId,                            
 CodeName,                            
 ''1'' AS Assigned, --''Y'' AS Assigned                            
 CR.ClientRaceId,                             
 CR.ClientId,                             
 CR.RaceId                             
FROM                             
 GlobalCodes AS GC                            
INNER JOIN                             
 ClientRaces AS CR                            
on                             GC.GlobalcodeId=CR.RaceId                 
WHERE                            
 (CR.RecordDeleted=''N'' OR CR.RecordDeleted IS NULL)                            
AND                            
 (GC.RecordDeleted=''N'' OR GC.RecordDeleted IS NULL)                            
--AND                            
-- GC.Active=''Y''                            
AND                            
 CR.ClientId=@ClientId                            
UNION                            
SELECT                            
 GlobalCodeId,                            
 CodeName,                            
 ''0'' AS Assigned, --''N'' AS UnAssigned                            
 '''' as ClientRaceId,                            
 '''' as ClientId,                            
 '''' as RaceId                             
FROM                             
 GlobalCodes                             
WHERE                            
 GlobalCodeId                            
NOT IN                            
(                            
 SELECT                             
  RaceId                            
 FROM                            
  ClientRaces                             
 WHERE                            
  ClientId=@ClientId                            
 AND                            
  (RecordDeleted=''N'' OR RecordDeleted IS NULL)                            
)                            
AND                             
 Category=''RACE''                            
AND                             
 Active=''Y''                            
AND                            
 (RecordDeleted=''N'' OR RecordDeleted IS NULL)                            
ORDER BY CodeName                            
                            
--ClientRaces                            
SELECT                         
 CR.ClientRaceId,                             
 CR.ClientId,                             
 CR.RaceId,                              
 CR.RowIdentifier,                             
 CR.CreatedBy,                             
 CR.CreatedDate,                             
 CR.ModifiedBy,                             
 CR.ModifiedDate,                             
 CR.RecordDeleted,                             
 CR.DeletedDate,                             
 CR.DeletedBy,                            
 GC.CodeName,                            
 GC.CodeName as Race                            
FROM                            
 ClientRaces CR                              
INNER JOIN                            
 GlobalCodes GC                            
ON                             
 CR.RaceId = GC.GlobalCodeId                            
WHERE                             
 CR.ClientId=@ClientId                            
AND                             
 (CR.RecordDeleted = ''N'' OR CR.RecordDeleted IS NULL)                            
                            
--Clientcontacts                            
/*SELECT                            
 CC.ClientContactId,                             
 CC.ClientId,                             
 CC.Relationship,                             
 CC.FirstName,                             
 CC.LastName,                             
 CC.MiddleName,                             
 CC.Prefix,                             
 CC.Suffix,                             
 CC.FinanciallyResponsible,                             
 CC.Organization,                             
 CONVERT(VARCHAR,CC.DOB,101) AS DOB,        CC.Guardian,                             
 CC.EmergencyContact,                             
 CC.ListAs,                             
 CC.Email,                             
 CC.Comment,                             
 CC.RowIdentifier,                             
 CC.ExternalReferenceId,                             
 CC.CreatedBy,                             
 CC.CreatedDate,                             
 CC.ModifiedBy,                             
 CC.ModifiedDate,              
 CC.RecordDeleted,                             
 CC.DeletedDate,                             
 CC.DeletedBy,                            
 GC.CodeName,          
 ''N'' AS RadioButton --For ClientContactId Radio Button - TOBE Removed                             
 ,'''' AS Phone                            
 ,'''' AS Address                            
FROM                            
 clientcontacts CC                            
INNER JOIN                            
 GlobalCodes GC                            
ON                             
 CC.Relationship = GC.GlobalCodeId                            
WHERE                             
 CC.ClientId=@ClientId                            
AND                             
 (CC.RecordDeleted = ''N'' OR CC.RecordDeleted IS NULL)*/                            
                            
--ClientHospitalizations                            
SELECT                            
 CH.HospitalizationId,                             
 CH.ClientId,                             
 CONVERT(VARCHAR,CH.PreScreenDate,101) AS PreScreenDate,                            
 CH.ThreeHourDisposition,                             
 CH.PerformedBy,                             
 CH.Hospitalized,                             
 CH.Hospital,                             
 CONVERT(VARCHAR,CH.AdmitDate,101) AS AdmitDate,               
 CONVERT(VARCHAR,CH.DischargeDate,101) AS DischargeDate,                             
 CH.SevenDayFollowUp,                             
 CH.DxCriteriaMet,                             
 CH.CancellationOrNoShow,                             
 CH.ClientRefusedService,                 
 CH.FollowUpException,                
 CH.FollowUpExceptionReason,                            
 CH.Comment,                          
 CH.ClientWasTransferred,                          
 CH.DeclinedServicesReason,                             
 CH.RowIdentifier,                             
 CH.ExternalReferenceId,                             
 CH.CreatedBy,                             
 CH.CreatedDate,                             
 CH.ModifiedBy,                             
 CH.ModifiedDate,                             
 CH.RecordDeleted,                             
 CH.DeletedDate,                             
 CH.DeletedBy,                    
 P.SiteName,                            
 ''N'' AS RadioButton, --For ClientContactId Radio Button - TOBE Removed                            
 P.SiteName as HospitalName                             
FROM                            
 ClientHospitalizations CH                            
                            
left JOIN                            
 sites P                            
ON                             
 CH.Hospital = P.SiteId                            
WHERE                             
 CH.ClientId=@ClientId                            
AND                             
 (CH.RecordDeleted = ''N'' OR CH.RecordDeleted IS NULL)                            
              
            
--ClientContactAddresses    Commented for adding controls                          
/*SELECT                            
 CCA.ContactAddressId,                             
 (CC.Lastname + '' '' + CC.Firstname)as Clientcontactname ,                            
 CCA.ClientContactId,                             
 CCA.AddressType,                             
 CCA.Address,                             
 CCA.City,                             
 CCA.State,                             
 CCA.Zip,             
 CCA.Display,                             
 CCA.Display as Addresses,                             
 CCA.Mailing,                             
 CCA.RowIdentifier,                             
 CCA.ExternalReferenceId,                             
 CCA.CreatedBy,                             
 CCA.CreatedDate,                             
 CCA.ModifiedBy,                             
 CCA.ModifiedDate,                             
 CCA.RecordDeleted,                             
 CCA.DeletedDate,                             
 CCA.DeletedBy,                            
 GC.CodeName,                            
 GC.GlobalCodeId,                            
 GC.CodeName as Type                          
FROM         
 ClientContactAddresses CCA                            
INNER JOIN                            
 GlobalCodes GC                            
ON                             
 CCA.AddressType = GC.GlobalCodeId                            
INNER JOIN                             
 ClientContacts CC                            
ON                            
 CC.ClientContactId=CCA.ClientContactId                            
INNER JOIN                            
 clients CL                            
ON                            
 CL.ClientId=CC.ClientId                            
WHERE                             
 CL.ClientId=@ClientId                            
AND                             
 (CCA.RecordDeleted = ''N'' OR CCA.RecordDeleted IS NULL)*/                            
  --ClientContactaddresses    Added for adding controls              
SELECT     ClientContactAddresses.*, GlobalCodes.SortOrder              
FROM         ClientContactAddresses INNER JOIN                
                      ClientContacts ON ClientContacts.ClientContactId = ClientContactAddresses.ClientContactId AND ClientContacts.ClientId = @ClientId AND                 
      ISNULL(ClientContacts.RecordDeleted, ''N'') = ''N'' INNER JOIN                
                      GlobalCodes ON ClientContactAddresses.AddressType = GlobalCodes.GlobalCodeId                
WHERE     (ISNULL(ClientContactAddresses.RecordDeleted, ''N'') = ''N'') AND (GlobalCodes.Active = ''Y'') AND (ISNULL(GlobalCodes.RecordDeleted, ''N'') = ''N'')                                            
--ClientContactPhones  Commented for adding controls                          
/* CCP.ContactPhoneId,                            
 (CC.Lastname + '' '' + CC.Firstname)as Clientcontactname ,                            
 CCP.ClientContactId,                            
 CCP.PhoneType,                            
 CCP.PhoneNumber,                            
 CCP.PhoneNumberText,                             
 (CCP.PhoneNumber + '' '' + CCP.PhoneNumberText) as phone,                            
 CCP.RowIdentifier,                            
 CCP.ExternalReferenceId,                            
 CCP.CreatedBy,                            
 CCP.CreatedDate,                            
 CCP.ModifiedBy,                            
 CCP.ModifiedDate,                            
 CCP.RecordDeleted,                            
 CCP.DeletedDate,                            
 CCP.DeletedBy,                            
 GC.CodeName AS Type                            
FROM                             
 ClientContactPhones CCP                            
INNER JOIN                            
 clientcontacts  CC                            
ON                            
 CC.ClientContactId=CCP.ClientContactId                            
INNER JOIN                              
 clients c                            
ON                             
 C.ClientId=CC.ClientId                            
INNER JOIN                             
 GlobalCodes GC                            
ON                             
 CCP.PhoneType = GC.GlobalCodeId                            
WHERE                             
 C.ClientId=@ClientId                            
AND                             
 (CCP.RecordDeleted = ''N'' OR CCP.RecordDeleted IS NULL) */                           
              
 --clientcontactphones    Added for adding controls               
SELECT     ClientContactPhones.*, GlobalCodes.SortOrder              
FROM         ClientContactPhones INNER JOIN                
                      ClientContacts ON ClientContacts.ClientContactId = ClientContactPhones.ClientContactId AND ClientContacts.ClientId = @ClientId AND                 
                      ISNULL(ClientContacts.RecordDeleted, ''N'') = ''N'' INNER JOIN            
                      GlobalCodes ON ClientContactPhones.PhoneType = GlobalCodes.GlobalCodeId                
WHERE     (ISNULL(ClientContactPhones.RecordDeleted, ''N'') = ''N'') AND (GlobalCodes.Active = ''Y'') AND (ISNULL(GlobalCodes.RecordDeleted, ''N'') = ''N'')                
                             
--CustomTimeliness                           
select *                        
 from CustomTimeliness where ClientEpisodeid IN (Select  ClientEpisodeID from ClientEpisodes where                             
ClientId =@ClientId  and isnull(RecordDeleted,''N'')=''N'') and isnull(RecordDeleted,''N'')=''N''                            
            
 --CustomStateReporting                         
select * from CustomStateReporting where ClientId=@ClientId and isnull(RecordDeleted,''N'')=''N''                   
            
--ClientContacts Added on 27 April 2007 for using Controls                  
Select ClientContacts.ClientContactId,ClientContacts.ClientId,ClientContacts.Relationship,ClientContacts.FirstName, ClientContacts.LastName, ClientContacts.MiddleName, ClientContacts.Prefix,ClientContacts.Suffix,             
ClientContacts.Organization,substring(ClientContacts.SSN,6,9)SSNDisplay,ClientContacts.SSN,ClientContacts.SEX,Convert(VARCHAR,ClientContacts.DOB,101) AS DOB ,ClientContacts.FinanciallyResponsible,ClientContacts.Guardian, ClientContacts.EmergencyContact, 
  
    
      
        
          
           
CASE when ClientContacts.FinanciallyResponsible=''Y'' then ''Yes'' else ''No'' end as FinanResp,            
CASE when ClientContacts.Guardian=''Y'' then ''Yes'' else ''No'' end as Gurdian,            
CASE when ClientContacts.EmergencyContact=''Y'' then ''Yes'' else ''No'' end as EmrgncyContact,            
CASE when ClientContacts.Sex=''M'' then ''Male'' when ClientContacts.Sex=''F'' then ''Female'' else ''''  end as ContactSex                
 ,ClientContacts.ListAs,ClientContacts.Email,ClientContacts.Comment,ClientContacts.RowIdentifier,ClientContacts.ExternalReferenceId                  
 ,ClientContacts.CreatedBy,ClientContacts.CreatedDate,ClientContacts.ModifiedBy,ClientContacts.ModifiedDate,ClientContacts.RecordDeleted,ClientContacts.DeletedDate,ClientContacts.DeletedBy              
 ,(Select top 1 PhoneNumber from ClientContactPhones where ClientContactPhones.ClientContactId = ClientContacts.ClientContactId and phonenumber is not null and IsNull(RecordDeleted,''N'')=''N'' order by phonetype ) as PhoneNumber            
 ,(Select top 1 PhoneNumberText from ClientContactPhones where ClientContactPhones.ClientContactId = ClientContacts.ClientContactId and phonenumber is not null and IsNull(RecordDeleted,''N'')=''N'' order by phonetype ) as PhoneNumberText            
,(Select top 1 Address from clientcontactAddresses where clientcontactAddresses.ClientContactId = ClientContacts.ClientContactId and Address is not null order by AddressType) as Address            
,''N'' as ''RadioButton''                  
 ,GlobalCodes.CodeName            
,GlobalCodes.CodeName as Relation                
  from ClientContacts                  
  inner join Globalcodes on GlobalCodes.GlobalCodeId = ClientContacts.Relationship and isNull(Globalcodes.RecordDeleted,''N'')<>''Y'' and category=''RELATIONSHIP''                      
  Where isNull(ClientContacts.RecordDeleted,''N'')<>''Y'' and ClientContacts.ClientId=@ClientId            
        
Select *,GCPurposeOfRequest.CodeName as ''PurposeOfRequestCode'',GCCurrentStatus.CodeName as ''CurrentStatusCode'' from ClientInformationReleases                       
 left outer join Globalcodes GCPurposeOfRequest on GCPurposeOfRequest.GlobalCodeId = ClientInformationReleases.PurposeOfRelease and isNull(GCPurposeOfRequest.RecordDeleted,''N'')<>''Y'' and GCPurposeOfRequest.category=''XROIPURPOSE''                            
  --Where isNull(ClientContacts.RecordDeleted,''N'')<>''Y'' and ClientInformationReleases.ClientId=@ClientID                            
left outer join  Globalcodes GCCurrentStatus on GCCurrentStatus.GlobalCodeId = ClientInformationReleases.CurrentStatus and isNull(GCCurrentStatus.RecordDeleted,''N'')<>''Y'' and GCCurrentStatus.category=''XROISTATUS''                           
  Where isNull(ClientInformationReleases.RecordDeleted,''N'')<>''Y'' and ClientInformationReleases.ClientId=@ClientID                  
              
     
--CustomFields                
Select * from CustomFieldsData where primarykey1=@ClientId     


' 
END
GO
