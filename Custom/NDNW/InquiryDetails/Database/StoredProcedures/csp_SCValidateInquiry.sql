IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCValidateInquiry]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCValidateInquiry]
GO
CREATE PROCEDURE [dbo].[csp_SCValidateInquiry]  
 @CurrentUserId INT,      
 @ScreenKeyId INT    
/******************************************************************************                                                
**  File:                                                 
**  Name: csp_SCValidateInquiry                                                
**  Desc: Validation stored procedure of Inquiries Detail page      
**                                                              
**  Parameters:                                                
**  Input         
 @CurrentUserId INT,      
 @ScreenKeyId INT                         
    
**  Output     ----------       -----------    
**     
    
**  Auth:  Pralyankar Kumar Singh      
**  Date:  Jan 6, 2012     
*******************************************************************************                                                
**  Change History     
*******************************************************************************                                                
**  Date:   Author:  Description:                                                
**  --------  --------    -------------------------------------------                                                
**  18 March 2012 Sourabh  Modified to check if ClientId is not associated with Inquiry and not completed then validation should not come for sex w.r.t #545                                      
** 18 March 2012 Pralyankar  Modified to to clear SSN field value on check of Unknow checkbox.  
**  21 March 2012 Pralyankar Modified for not validating SSN if clientId is zero(0).  
**  02 April 2012 Pralyankar Modified to put condition for Fist/Last Name.  
** 08 Aug 2013 katta sharath kumar Pull this sp from Newaygo database from 3.5xMerged with task #3 in Ionia County CMH - Customizations.  
** 09 March 2014 SuryaBalan Modified Validation Message for Task 5 New Directions -Customizations   
** 17 March 2014 SuryaBalan Fixed Pregnant Validation Issue Validation Message for Task 5 New Directions -Customizations  
** 28 March 2016	Alok Kumar	Added two more valdations referral reason, source of referral for task #175 - New Directions - Support Go Live 
 
*******************************************************************************/       
AS      
BEGIN TRY      
     
-- DECLARE  @CustomInquiries Table      
-- (     
--   [InquiryId] INT   
--  , [ClientId] INT      
--  , [LimitedEnglishProficiency]  CHAR(1)      
--  , [AccomodationNeeded] VARCHAR(5)       
--  , [ClientCanLegalySign] CHAR(1)      
--  , [InquiryStatus] INT      
--  --, [PopulationSA] CHAR(1)      
--  , [SAType] INT      
--  , Referraldate datetime      
--  , DateOfBirth datetime  
--  , SSN char(9)  
--  , SSNUnknown char(1)   
--  , SEX CHAR(1)   
--  , MemberLastName Varchar(100)  
--  , MemberFirstName Varchar(100)  
-- )  
  
--INSERT  
--INTO  
-- @CustomInquiries  
--SELECT [InquiryId]  
--  , [ClientId]   
--  , [LimitedEnglishProficiency]  
--  , [AccomodationNeeded]  
--  , [ClientCanLegalySign]  
--  , [InquiryStatus]  
--  --, [PopulationSA]  
--  , [SAType]  
--  , Referraldate  
--  , DateOfBirth  
--  , SSN  
--  , SSNUnknown  
--  , SEX  
--  , MemberLastName   
--  , MemberFirstName  
--FROM  
-- CustomInquiries  
--WHERE  
-- [InquiryId] = @ScreenKeyId 
 DECLARE @RefferalTypeId int
 SELECT @RefferalTypeId= IntegerCodeId FROM Recodes WHERE RecodeCategoryId = (SELECT RecodeCategoryId FROM RecodeCategories WHERE CategoryCode='XRequireReferralDetails')

  DECLARE  @DuplicatePlans TABLE
      (CoveragePlanId INT ,CoveragePlanName VARCHAR(5000),InsureId VARCHAR(25))
      INSERT INTO @DuplicatePlans
      SELECT CCI.CoveragePlanId,CP.CoveragePlanName,CCI.InsuredId FROM dbo.CustomInquiriesCoverageInformations CCI
      INNER JOIN dbo.CustomInquiries CI ON CI.InquiryId=@ScreenKeyId AND CI.InquiryId=CCI.InquiryId AND CCI.NewlyAddedplan='N'
      INNER JOIN dbo.ClientCoveragePlans CCP ON CCP.ClientId=CI.ClientId  
      AND CCP.CoveragePlanId=CCI.CoveragePlanId AND CCP.InsuredId=CCI.InsuredId
      AND ISNULL(CCP.RecordDeleted,'N')='N'
      INNER JOIN dbo.CoveragePlans CP ON CP.CoveragePlanId=CCP.CoveragePlanId AND ISNULL(CP.RecordDeleted,'N')='N'     
  
 -- IF Unknown check box is checked then clear SSN field value  
 IF (Select SSNUnknown FROM CustomInquiries WHERE [InquiryId] = @ScreenKeyId ) = 'Y'     
 BEGIN  
  UPDATE CustomInquiries SET SSN = '' WHERE [InquiryId] = @ScreenKeyId  
 END  
 
 ------------------------------------------------------------  
   Declare @OtherGlobalcodeId int
   SET @OtherGlobalcodeId = (SELECT GlobalCodeId FROM GlobalCodes WHERE CodeName='other' and Category= 'LANGUAGE') 
 ---- Create Temp Table for Validation -----      
 DECLARE @validationReturnTable TABLE          
 (      
 TableName  VARCHAR(200),      
 ColumnName  VARCHAR(200),      
 ErrorMessage VARCHAR(1000),
 ValidationOrder Int      
 )      
 -------------------------------------------      
 DECLARE @CompletedGlobalCodeId INT  
  
SELECT @CompletedGlobalCodeId = GlobalCodeId  
FROM  
 GlobalCodes  
WHERE  
 Category = 'XINQUIRYSTATUS'  
 AND Code = 'COMPLETE'  
  
---- Inser row in Validation Table ------      
INSERT  
INTO  
 @validationReturnTable  
 (  
  TableName,  
  ColumnName,  
  ErrorMessage, 
  ValidationOrder 
 )  
  
---- Validate First/Last Name for Clients ---------  
SELECT 'CustomInquiries', 'InquiryStartDate', 'Initial - Inquirer Information - Start date is required ' ,1 
FROM CustomInquiries  
WHERE isnull(InquiryStartDateTime,'') = '' and ClientId > 0  and InquiryId=@ScreenKeyId 
  
UNION


SELECT 'CustomInquiries', 'MemberLastName', 'Initial - Client Information - Last name is required',2
FROM CustomInquiries  
WHERE isnull(MemberLastName,'') = '' and ClientId > 0  and InquiryId=@ScreenKeyId 
  
UNION  

SELECT 'CustomInquiries', 'Sex', 'Initial - Client Information - Sex is required',3  
FROM CustomInquiries  
--WHERE (isnull(Sex,'') = '' OR isnull(Sex,'') = 'U') and ClientId > 0   and InquiryId=@ScreenKeyId  
WHERE isnull(Sex,'') = '' and ClientId > 0   and InquiryId=@ScreenKeyId  
UNION

SELECT 'CustomInquiries'  
  , 'SSN'  
  , 'SSN must be 9 digits'  
  ,4
FROM  
 CustomInquiries CI  
WHERE  
 (CI.SSN IS NULL  
 OR CI.SSN = ''  
 OR CI.SSN = '_________')  
 AND (isnull(CI.SSNUnknown, 'N') = 'N') and [ClientId] >0  
  
UNION 

SELECT 'CustomInquiries', 'DateOfBirth', 'Initial - Client Information - DOB is required.   ; Client DOB cannot be in the future; Client Age cannot be greater than 120' ,5 
FROM CustomInquiries  
WHERE isnull(DateOfBirth,'') = ''   and InquiryId=@ScreenKeyId

UNION

SELECT 'CustomInquiries', 'DateOfBirth', 'Client DOB cannot be in the future; Client Age cannot be greater than 120' ,6 
FROM CustomInquiries  
WHERE isnull(DATEDIFF(YY,DateOfBirth,GETDATE()),'') > 120 and InquiryId=@ScreenKeyId 
UNION

SELECT 'CustomInquiries'  
  , 'DateOfBirth'  
  , 'Date of Birth can not be greater than current date.' 
  ,7 
FROM  
 CustomInquiries  
WHERE  
 DateOfBirth > GETDATE() -- DateOfBirth     
UNION  


SELECT 'CustomInquiries', 'Homeless', 'Initial – Client Information – Please specify if the client is homeless' ,8
FROM CustomInquiries  
WHERE isnull(Homeless,'') = '' and ClientId > 0   and InquiryId=@ScreenKeyId 
UNION 

SELECT 'CustomInquiries', 'Address1', 'Initial - Client Information - Address 1 is required' ,9
FROM CustomInquiries  
WHERE isnull(Address1,'') = '' and ClientId > 0   and Homeless='Y' and InquiryId=@ScreenKeyId 
UNION 

SELECT 'CustomInquiries', 'City', 'Initial - Client Information - City is required'  ,10
FROM CustomInquiries  
WHERE isnull(City,'') = '' and ClientId > 0   and Homeless='Y' and InquiryId=@ScreenKeyId 
UNION

SELECT 'CustomInquiries', 'State', 'Initial - Client Information - State is required'  ,11
FROM CustomInquiries  
WHERE isnull([State],'') = '' and ClientId > 0   and Homeless='Y' and InquiryId=@ScreenKeyId 
UNION

SELECT 'CustomInquiries', 'ZipCode', 'Initial - Client Information - Zip Code is required' ,12 
FROM CustomInquiries  
WHERE isnull(ZipCode,'') = '' and ClientId > 0   and Homeless='Y' and InquiryId=@ScreenKeyId 
UNION

SELECT 'CustomInquiries', 'UrgencyLevel', 'Initial - Client Information - Priority level is required',13  
FROM CustomInquiries  
WHERE isnull(UrgencyLevel,'') = '' and ClientId > 0   and InquiryId=@ScreenKeyId  
UNION 

SELECT 'CustomInquiries', 'InitialContact', 'Initial - Client Information - Initial Contact is required' ,14
FROM CustomInquiries  
WHERE isnull(InitialContact,'') = '' and ClientId > 0    and InquiryId=@ScreenKeyId 
UNION 

SELECT 'CustomInquiries', 'ClientCanLegalySign', 'Initial - Potential Client Information - Can client legally sign is required' ,15 
FROM CustomInquiries  
WHERE isnull(ClientCanLegalySign,'') = '' and ClientId > 0  and InquiryId=@ScreenKeyId  
UNION

SELECT 'CustomInquiries', 'RiskAssessmentInDanger', 'Initial - Risk assessment - Did consumer indicate that they are in eminent danger of harming self or others is required' ,16 
FROM CustomInquiries  
WHERE isnull(RiskAssessmentInDanger,'') = '' and ClientId > 0 and InquiryId=@ScreenKeyId 
UNION

SELECT 'CustomInquiries', 'RiskAssessmentInDangerComment', 'Initial - Risk assessment - If yes document action taken is required'  ,17
FROM CustomInquiries  
WHERE isnull(RiskAssessmentInDangerComment,'') = '' and ClientId > 0   and RiskAssessmentInDanger='Y' and InquiryId=@ScreenKeyId 
UNION

SELECT 'CustomInquiries', 'RiskAssessmentCounselorAvailability', 'Initial - Risk assessment - Was the consumer advised of the availability of a counselor is required', 18 
FROM CustomInquiries  
WHERE isnull(RiskAssessmentCounselorAvailability,'') = '' and ClientId > 0 and InquiryId=@ScreenKeyId 
UNION

SELECT 'CustomInquiries', 'RiskAssessmentCounselorAvailabilityComment', 'Initial - Risk assessment - If no explain is required' ,19 
FROM CustomInquiries  
WHERE isnull(RiskAssessmentCounselorAvailabilityComment,'') = '' and ClientId > 0   and RiskAssessmentCounselorAvailability='N' and InquiryId=@ScreenKeyId 
UNION

SELECT 'CustomInquiries', 'RiskAssessmentCrisisLine', 'Initial - Risk assessment - Was the consumer advised of the availability of 24/7 crisis line is required' ,20 
FROM CustomInquiries  
WHERE isnull(RiskAssessmentCrisisLine,'') = '' and ClientId > 0 and InquiryId=@ScreenKeyId 
UNION

SELECT 'CustomInquiries', 'RiskAssessmentCrisisLineComment', 'Initial - Risk assessment - If no explain is required'  ,21
FROM CustomInquiries  
WHERE isnull(RiskAssessmentCrisisLineComment,'') = '' and ClientId > 0   and RiskAssessmentCrisisLine='N' and InquiryId=@ScreenKeyId 
UNION

SELECT 'CustomInquiries', 'RiskAssessmentCrisisInformation', 'Initial - Risk assessment - Crisis information is required' ,22 
FROM CustomInquiries  
WHERE isnull(RiskAssessmentCrisisInformation,'') = '' and ClientId > 0  and InquiryId=@ScreenKeyId 
UNION

SELECT 'CustomInquiries', 'ReferralDate', 'Initial - Referral Resource - referral date is required' ,23 
FROM CustomInquiries  
WHERE isnull(ReferralDate,'') = '' and ClientId > 0  and InquiryId=@ScreenKeyId 
UNION

SELECT 'CustomInquiries', 'ReferralType', 'Initial - Referral Resource - source of referral is required' ,24 
FROM CustomInquiries  
WHERE isnull(ReferralType,'') = '' and isnull(ReferralDate,'') != '' and ClientId > 0  and InquiryId=@ScreenKeyId 
UNION

SELECT 'CustomInquiries', 'ReferralSubtype', 'Initial - Referral Resource - referral subtype is required' ,25 
FROM CustomInquiries  
WHERE isnull(ReferralSubtype,'') = '' and isnull(ReferralType,'') != '' and ClientId > 0  and InquiryId=@ScreenKeyId 
UNION

SELECT 'CustomInquiries', 'ReferralReason', 'Initial - Referral Resource - referral reason is required' ,26 
FROM CustomInquiries  
WHERE isnull(ReferralReason,'') = '' and ClientId > 0  and InquiryId=@ScreenKeyId 
UNION

SELECT 'CustomInquiries', 'ReferalOrganizationName', 'Initial - Referral Resource - organization name is required' ,27 
FROM CustomInquiries  
WHERE isnull(ReferalOrganizationName,'') = '' and InquiryId=@ScreenKeyId  and ClientId > 0  and exists(SELECT RecodeId
																			FROM Recodes
																			WHERE CodeName = 'Require Referral Details') 
UNION

SELECT 'CustomInquiries', 'ReferalFirstName', 'Initial - Referral Resource - first name is required',28  
FROM CustomInquiries  
WHERE isnull(ReferalFirstName,'') = '' and InquiryId=@ScreenKeyId  and ClientId > 0  and exists(SELECT RecodeId
																			FROM Recodes
																			WHERE CodeName = 'Require Referral Details') 
UNION

SELECT 'CustomInquiries', 'ReferalLastName', 'Initial - Referral Resource - last name is required'  ,29
FROM CustomInquiries  
WHERE isnull(ReferalLastName,'') = '' and InquiryId=@ScreenKeyId  and ClientId > 0  and exists(SELECT RecodeId
																			FROM Recodes
																			WHERE CodeName = 'Require Referral Details') 
UNION

SELECT 'CustomInquiries', 'GatheredBy', 'Initial - Inquiry Handled By - Information gathered by is required'  ,30
FROM CustomInquiries  
WHERE isnull(GatheredBy,'') = '' and ClientId > 0  and InquiryId=@ScreenKeyId 
UNION


SELECT 'CustomInquiries', 'ProgramId', 'Initial - Inquiry Handled By - Program is required'  ,31
FROM CustomInquiries  
WHERE isnull(ProgramId,'') = '' and ClientId > 0  and InquiryId=@ScreenKeyId 
UNION

SELECT 'CustomInquiries', 'Facility', 'Inquiry - Inquiry Handled By - Facility is required'  ,32
FROM CustomInquiries  
WHERE isnull(Facility,'') = '' and ClientId > 0  and InquiryId=@ScreenKeyId 
UNION

SELECT 'CustomInquiries', 'InjectingDrugs', 'Inquiry - Provisional Disability Designation - Injection Drug User is required',33 
FROM CustomInquiries  
WHERE isnull(InjectingDrugs,'') = '' and ClientId > 0  and InquiryId=@ScreenKeyId  
UNION

SELECT 'CustomInquiries', 'Pregnant', 'Initial – Provisional disability designation – Pregnant is required',34  
FROM CustomInquiries  
WHERE isnull(Pregnant,'') = '' and sex ='F' and ClientId > 0  and InquiryId=@ScreenKeyId  
UNION

SELECT 'CustomInquiries', 'IncomeGeneralHousehold', 'Insurance – Income/Fee General – Number in Household is required'  ,35
FROM CustomInquiries  
WHERE isnull(IncomeGeneralHousehold,'') = '' and ClientId > 0  and InquiryId=@ScreenKeyId 
UNION

SELECT 'CustomInquiries', 'IncomeGeneralDependents', 'Insurance – Income/Fee General – Number of Dependants is required' ,36 
FROM CustomInquiries  
WHERE isnull(IncomeGeneralDependents,'') = '' and ClientId > 0  and InquiryId=@ScreenKeyId 
UNION

SELECT 'CustomInquiries', 'IncomeGeneralAnnualIncome', 'Insurance – Income/Fee General – Client Annual Income is required',37 
FROM CustomInquiries  
WHERE isnull(IncomeGeneralAnnualIncome,'') = '' and ClientId > 0 and InquiryId=@ScreenKeyId 
UNION

SELECT 'CustomInquiries', 'IncomeGeneralHouseholdAnnualIncome', 'Insurance – Income/Fee General – Household Annual Income is required' ,38 
FROM CustomInquiries  
WHERE isnull(IncomeGeneralHouseholdAnnualIncome,'') = '' and ClientId > 0 and InquiryId=@ScreenKeyId 
UNION

SELECT 'CustomInquiries', 'IncomeGeneralMonthlyIncome', 'Insurance – Income/Fee General – Client Monthly Income is required',39  
FROM CustomInquiries  
WHERE isnull(IncomeGeneralMonthlyIncome,'') = '' and ClientId > 0 and InquiryId=@ScreenKeyId 
UNION

SELECT 'CustomInquiries', 'IncomeGeneralPrimarySource', 'Insurance – Income/Fee General – Primary Source is required' ,40 
FROM CustomInquiries  
WHERE isnull(IncomeGeneralPrimarySource,'') = '' and ClientId > 0 and InquiryId=@ScreenKeyId 
UNION

--SELECT 'CustomInquiries', 'PrimarySpokenLanguage', 'Additional Information – Other Demographics – Primary spoken language is required'  
--FROM CustomInquiries  
--WHERE isnull(PrimarySpokenLanguage,'') = '' and ClientId > 0 and InquiryId=@ScreenKeyId 
--UNION

--SELECT 'CustomInquiries', 'PrimarySpokenLanguageOther', 'Additional Information – Other Demographics – If other is specify is required'  
--FROM CustomInquiries  
--WHERE isnull(PrimarySpokenLanguage,'') = @OtherGlobalcodeId and ClientId > 0 and isnull(PrimarySpokenLanguageOther,'') = '' and InquiryId=@ScreenKeyId 
--UNION

SELECT 'CustomInquiries', 'MemberFirstName', 'Invalid Member First Name.'  ,41
FROM CustomInquiries  
WHERE isnull(MemberFirstName,'') = '' and ClientId > 0  and InquiryId=@ScreenKeyId 
----------------------------------------------------------------  
  
UNION  
  
SELECT 'CustomInquiries'  
  , 'ClientCanLegalySign'  
  , 'Document cannot be ‘Complete’ until the user has Legally Sign selected ‘Yes’ or ‘No’ '  ,42
FROM  
 CustomInquiries  
WHERE  
 [InquiryStatus] = @CompletedGlobalCodeId -- Status Completed      
 AND ClientCanLegalySign IS NULL  
   
UNION  
SELECT 'CustomInquiries'  
  , 'AccomodationNeeded'  
  , 'Select atleast one Accommodation for English Proficiency.'  ,43
FROM  
 CustomInquiries  
WHERE  
 LimitedEnglishProficiency = 'Y' -- Selected English      
 AND (AccomodationNeeded IS NULL  
 OR AccomodationNeeded = '')  
--UNION  
--SELECT 'CustomInquiries'  
--  , 'PopulationSA'  
--  , 'Please select Population SA type dropdown.'  
--FROM  
-- @CustomInquiries  
--WHERE  
-- PopulationSA = 'Y' -- Selected Population SA      
-- AND isnull(SAType, 0) = 0  
UNION  
SELECT 'CustomInquiries'  
  , 'Referraldate'  
  , 'Referral Date can not be greater than current date.' ,6 
FROM  
 CustomInquiries  
WHERE  
 Referraldate IS NOT NULL  
 AND Referraldate > GETDATE() -- Selected Population SA      
UNION  
--SELECT 'CustomInquiries'  
--  , 'Sex'  
--  , 'Please select Sex for Update.'  
--FROM  
-- @CustomInquiries  
--WHERE  
-- isnull(Sex, 'U') = 'U' -- SEX   
-- and [InquiryStatus] = @CompletedGlobalCodeId  
-- and ISNULL(ClientId,0) > 0  
---- If Status is completed then user much have to select atleast one Discomposition -----    
--UNION  
--SELECT 'CustomInquiries'  
--  , 'Disposition'  
--  , 'Please select atleast one disposition.'  
--FROM  
-- CustomInquiries CI  
--WHERE  
-- CI.[InquiryStatus] = @CompletedGlobalCodeId -- Completed    
-- AND NOT EXISTS (SELECT InquiryId  
--     FROM  
--      CustomDispositions CD  
--     WHERE  
--      CD.InquiryId = CI.InquiryId  
--      AND CD.Disposition IS NOT NULL  
--      AND isnull(CD.RecordDeleted, 'N') = 'N')  
  
--If SSNUnknown is Null or 'N' then user must enter SSN number in the client details  
  
--UNION  
 
--User cannot select same type of disposition in the Inquiry  
--SELECT 'CustomInquiries'  
--  , 'DISPOSITION'  
--  , 'Please specify different dispositions.'  
--FROM  
-- CustomInquiries CI  
--WHERE  
-- EXISTS (SELECT Disposition  
--   FROM  
--    customdispositions  
--   WHERE  
--    InquiryId = @ScreenKeyId  
--    AND isnull(RecordDeleted, 'N') <> 'Y'  
--   GROUP BY  
--    Disposition  
--   HAVING  
--    count(Disposition) > 1)  
  
--UNION  
  
--User cannot select same type of service for one disposition in the Inquiry  
--SELECT 'CustomInquiries'  
--  , 'DISPOSITION'  
--  , 'Please specify different service types under one disposition section'  
--FROM  
-- CustomInquiries CI  
--WHERE  
-- EXISTS (SELECT ServiceType  
--   FROM  
--    CustomServiceDispositions  
--   WHERE  
--    CustomDispositionId IN  
--    (SELECT CustomDispositionId  
--     FROM  
--      customdispositions  
--     WHERE  
--      inquiryId = @ScreenKeyId  
--      AND isnull(RecordDeleted, 'N') = 'N')  
--    AND isnull(RecordDeleted, 'N') = 'N'  
--   GROUP BY  
--    ServiceType  
--   HAVING  
--    count(ServiceType) > 1)  
  
/* Below Queru can re replaced with this commented code We will do it after release of Kalamazoo on Thursday ----  
SELECT CustomDispositionId, Disposition, CustomServiceDispositionId, ServiceType, ProgramId, COUNT(CustomProviderServiceId)  
FROM  
(  
 SELECT Distinct CD.CustomDispositionId, CD.Disposition, CSD.CustomServiceDispositionId, CSD.ServiceType, CPS.CustomProviderServiceId, CPS.ProgramId  
 FROM customdispositions CD   
  INNER JOIN  CustomServiceDispositions CSD ON CSD.CustomDispositionId = CD.CustomDispositionId  
  INNER JOIN CustomProviderServices CPS ON CPS.CustomServiceDispositionId = CSD.CustomServiceDispositionId  
 WHERE InquiryId = 13  
  AND isnull(CSD.RecordDeleted, 'N') = 'N'  
  AND isnull(CD.RecordDeleted, 'N') = 'N'  
  AND isnull(CPS.RecordDeleted, 'N') = 'N'  
) As InnerTable  
GROUP BY CustomDispositionId, Disposition, CustomServiceDispositionId, ServiceType, ProgramId   
HAVING COUNT(CustomProviderServiceId) > 1  
*/  
  
--UNION  
  
--User cannot select same type of provider for one service type in the Inquiry  
--SELECT 'CustomInquiries'  
--  , 'DISPOSITION'  
--  , 'Please specify different provider/agency type under one service type'  
--FROM  
-- CustomInquiries CI  
--WHERE  
-- EXISTS (  
--   SELECT ProgramId  
--   FROM  
--    CustomProviderServices  
--   WHERE  
--    CustomServiceDispositionId IN  
--    (SELECT CustomServiceDispositionId  
--     FROM  
--      CustomServiceDispositions  
--     WHERE  
--      CustomDispositionId  
--      IN (SELECT CustomDispositionId  
--       FROM  
--        customdispositions  
--       WHERE  
--        inquiryId = @ScreenKeyId  
--        AND isnull(RecordDeleted, 'N') <> 'Y')  
--      AND isnull(RecordDeleted, 'N') <> 'Y')  
--    AND isnull(RecordDeleted, 'N') <> 'Y'  
--   GROUP BY  
--    ProgramId  
--   HAVING  
--    count(ProgramId) > 1)  
  
--  UNION
 Select 'CoveragePlans', 'CoveragePlanId', 'Plan with InsuredId is already exists for ' + DP.CoveragePlanName + ' ,' + DP.InsureId  ,38            
 FROM @DuplicatePlans DP 
  
------------------------------------------------------------------------------------------       
  
SELECT TableName  
  , ColumnName  
  , ErrorMessage
  ,ValidationOrder  
FROM  
 @validationReturnTable    order by  ValidationOrder     
    
 IF EXISTS (SELECT *  
   FROM  
    @validationReturnTable)          
  BEGIN  
SELECT 1 AS ValidationStatus          
  END      
 ELSE      
  BEGIN  
SELECT 0 AS ValidationStatus          
  END      
END TRY      
    
BEGIN CATCH      
 DECLARE @ErrorMessage NVARCHAR(4000);      
    DECLARE @ErrorSeverity INT;      
    DECLARE @ErrorState INT;  
  
SELECT @ErrorMessage = ERROR_MESSAGE()  
  , @ErrorSeverity = ERROR_SEVERITY()  
  , @ErrorState = ERROR_STATE();      
    RAISERROR (@ErrorMessage, -- Message text.      
               @ErrorSeverity, -- Severity.      
               @ErrorState -- State.      
               );       
END CATCH 
GO


