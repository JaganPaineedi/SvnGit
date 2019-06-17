 /****** Object:  StoredProcedure [dbo].[ssp_SCValidateInquiry]    Script Date: 06/11/2018 03:53:09 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCValidateInquiry]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCValidateInquiry]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCValidateInquiry]   Script Date: 06/11/2018 03:53:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 
 CREATE PROCEDURE [dbo].[ssp_SCValidateInquiry]        
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
** 6/12/2015 njain   Changed Eminent to Imminent       
*******************************************************************************/             
AS            
BEGIN TRY            
                
 DECLARE @RefferalTypeId int      
 SELECT @RefferalTypeId= IntegerCodeId FROM Recodes WHERE RecodeCategoryId = (SELECT RecodeCategoryId FROM RecodeCategories WHERE CategoryCode='RequireReferralDetails')      
      
  DECLARE  @DuplicatePlans TABLE      
      (CoveragePlanId INT ,CoveragePlanName VARCHAR(5000),InsureId VARCHAR(25))      
      INSERT INTO @DuplicatePlans      
      SELECT CCI.CoveragePlanId,CP.CoveragePlanName,CCI.InsuredId FROM dbo.InquiryCoverageInformations CCI      
      INNER JOIN dbo.Inquiries CI ON CI.InquiryId=@ScreenKeyId AND CI.InquiryId=CCI.InquiryId AND CCI.NewlyAddedplan='N'      
  INNER JOIN dbo.ClientCoveragePlans CCP ON CCP.ClientId=CI.ClientId        
      AND CCP.CoveragePlanId=CCI.CoveragePlanId AND CCP.InsuredId=CCI.InsuredId      
      AND ISNULL(CCP.RecordDeleted,'N')='N'      
      INNER JOIN dbo.CoveragePlans CP ON CP.CoveragePlanId=CCP.CoveragePlanId AND ISNULL(CP.RecordDeleted,'N')='N'           
          
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
								FROM   GlobalCodes        
								WHERE    Category = 'XINQUIRYSTATUS'   AND Code = 'COMPLETE'        
        
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
SELECT 'Inquiries', 'InquiryStartDate', 'Initial - Inquirer Information - Start date is required ' ,1       
FROM Inquiries        
WHERE isnull(InquiryStartDateTime,'') = ''   and InquiryId=@ScreenKeyId       
        
UNION      
      
      
SELECT 'Inquiries', 'MemberLastName', 'Initial - Client Information - Last name is required',2      
FROM Inquiries        
WHERE isnull(MemberLastName,'') = ''   and InquiryId=@ScreenKeyId       
        
UNION        
      
SELECT 'Inquiries', 'Sex', 'Initial - Client Information - Sex is required',3        
FROM Inquiries        
WHERE (isnull(Sex,'') = '' OR isnull(Sex,'') = 'U')    and InquiryId=@ScreenKeyId        
UNION      
      
SELECT 'Inquiries'        
  , 'SSN'        
  , 'Initial - Client Information - Please specify SSN or click on the SSN Unknown'        
  ,4      
FROM        
 Inquiries CI        
WHERE        
 (CI.SSN IS NULL        
 OR CI.SSN = ''        
 OR CI.SSN = '_________')        
 AND (isnull(CI.SSNUnknown, 'N') = 'N') and CI.InquiryId=@ScreenKeyId        
        
UNION       
      
SELECT 'Inquiries', 'DateOfBirth', 'Initial - Client Information - DOB is required.   ; Client DOB cannot be in the future; Client Age cannot be greater than 120' ,5       
FROM Inquiries        
WHERE isnull(DateOfBirth,'') = ''   and InquiryId=@ScreenKeyId      
      
UNION      
      
SELECT 'Inquiries', 'DateOfBirth', 'Client DOB cannot be in the future; Client Age cannot be greater than 120' ,6       
FROM Inquiries        
WHERE isnull(DATEDIFF(YY,DateOfBirth,GETDATE()),'') > 120 and InquiryId=@ScreenKeyId       
UNION      
      
SELECT 'Inquiries'        
  , 'DateOfBirth'        
  , 'Date of Birth can not be greater than current date.'       
  ,7       
FROM        
 Inquiries        
WHERE        
 DateOfBirth > GETDATE()  and InquiryId=@ScreenKeyId -- DateOfBirth           
UNION        
      
      
SELECT 'Inquiries', 'Homeless', 'Initial – Client Information – Please specify if the client is homeless' ,8      
FROM Inquiries        
WHERE isnull(Homeless,'') = ''    and InquiryId=@ScreenKeyId       
UNION       
      
SELECT 'Inquiries', 'Address1', 'Initial - Client Information - Address 1 is required' ,9      
FROM Inquiries        
WHERE isnull(Address1,'') = ''    and Homeless='Y' and InquiryId=@ScreenKeyId       
UNION       
      
SELECT 'Inquiries', 'City', 'Initial - Client Information - City is required'  ,10      
FROM Inquiries        
WHERE isnull(City,'') = ''     and Homeless='Y' and InquiryId=@ScreenKeyId       
UNION      
      
SELECT 'Inquiries', 'State', 'Initial - Client Information - State is required'  ,11      
FROM Inquiries        
WHERE isnull([State],'') = ''     and Homeless='Y' and InquiryId=@ScreenKeyId       
UNION      
      
SELECT 'Inquiries', 'ZipCode', 'Initial - Client Information - Zip Code is required' ,12       
FROM Inquiries        
WHERE isnull(ZipCode,'') = ''     and Homeless='Y' and InquiryId=@ScreenKeyId       
UNION      
      
SELECT 'Inquiries', 'UrgencyLevel', 'Initial - Client Information - Urgency level is required',13        
FROM Inquiries        
WHERE isnull(UrgencyLevel,'') = ''    and InquiryId=@ScreenKeyId        
UNION       
      
      
SELECT 'Inquiries', 'ClientCanLegalySign', 'Initial – Potential Client Information – Can client legally sign is required' ,14       
FROM Inquiries        
WHERE isnull(ClientCanLegalySign,'') = ''   and InquiryId=@ScreenKeyId        
UNION      
      
SELECT 'Inquiries', 'RiskAssessmentInDanger', 'Initial - Risk assessment - Did consumer indicate that they are in imminent danger of harming self or others is required' ,15       
FROM Inquiries        
WHERE isnull(RiskAssessmentInDanger,'') = ''  and InquiryId=@ScreenKeyId       
UNION      
      
SELECT 'Inquiries', 'RiskAssessmentInDangerComment', 'Initial - Risk assessment - If yes document action taken is required'  ,16      
FROM Inquiries        
WHERE isnull(RiskAssessmentInDangerComment,'') = ''    and RiskAssessmentInDanger='Y' and InquiryId=@ScreenKeyId       
UNION      
      
SELECT 'Inquiries', 'RiskAssessmentCounselorAvailability', 'Initial - Risk assessment - Was the consumer advised of the availability of a counselor is required', 17       
FROM Inquiries        
WHERE isnull(RiskAssessmentCounselorAvailability,'') = ''  and InquiryId=@ScreenKeyId       
UNION      
      
SELECT 'Inquiries', 'RiskAssessmentCounselorAvailabilityComment', 'Initial - Risk assessment - If no explain is required' ,18       
FROM Inquiries        
WHERE isnull(RiskAssessmentCounselorAvailabilityComment,'') = ''    and RiskAssessmentCounselorAvailability='N' and InquiryId=@ScreenKeyId       
UNION      
      
SELECT 'Inquiries', 'RiskAssessmentCrisisLine', 'Initial - Risk assessment - Was the consumer advised of the availability of 24/7 crisis line is required' ,19       
FROM Inquiries        
WHERE isnull(RiskAssessmentCrisisLine,'') = ''  and InquiryId=@ScreenKeyId       
UNION      
      
SELECT 'Inquiries', 'RiskAssessmentCrisisLineComment', 'Initial - Risk assessment - If no explain is required'  ,20      
FROM Inquiries        
WHERE isnull(RiskAssessmentCrisisLineComment,'') = ''    and RiskAssessmentCrisisLine='N' and InquiryId=@ScreenKeyId       
UNION      
      
SELECT 'Inquiries', 'RiskAssessmentCrisisInformation', 'Initial – Risk assessment – Crisis Information is required' ,21       
FROM Inquiries        
WHERE isnull(RiskAssessmentCrisisInformation,'') = ''   and InquiryId=@ScreenKeyId       
UNION      
      
SELECT 'Inquiries', 'ReferralDate', 'Initial – Referral Resource – Referral date is required' ,22       
FROM Inquiries        
WHERE isnull(ReferralDate,'') = ''   and InquiryId=@ScreenKeyId       
UNION      
      
SELECT 'Inquiries', 'ReferralType', 'Initial – Referral Resource – Referral type is required' ,23       
FROM Inquiries        
WHERE isnull(ReferralType,'') = ''   and InquiryId=@ScreenKeyId       
UNION      
      
SELECT 'Inquiries', 'ReferalOrganizationName', 'Initial-Referral Resource – Organization name or first/last name is required' ,24       
FROM Inquiries        
WHERE isnull(ReferalOrganizationName,'') = '' and isnull(ReferalFirstName,'') = '' and isnull(ReferalLastName,'') = ''  and InquiryId=@ScreenKeyId    and ReferralType = @RefferalTypeId       
UNION      
      
SELECT 'Inquiries', 'ReferalOrganizationName', 'Initial-Referral Resource – Organization name or first/last name is required',24        
FROM Inquiries        
WHERE isnull(ReferalFirstName,'') = '' and isnull(ReferalOrganizationName,'') = '' and InquiryId=@ScreenKeyId    and ReferralType = @RefferalTypeId        
UNION      
      
SELECT 'Inquiries', 'ReferalOrganizationName', 'Initial-Referral Resource – Organization name or first/last name is required'  ,24      
FROM Inquiries        
WHERE isnull(ReferalLastName,'') = '' and isnull(ReferalOrganizationName,'') = '' and InquiryId=@ScreenKeyId    and  ReferralType = @RefferalTypeId        
UNION      
      
SELECT 'Inquiries', 'GatheredBy', 'Initial - Inquiry handled by - Information gathered by is required'  ,27      
FROM Inquiries        
WHERE isnull(GatheredBy,'') = ''   and InquiryId=@ScreenKeyId       
UNION      
      
      
SELECT 'Inquiries', 'ProgramId', 'Initial - Inquiry handled by - Program is required'  ,28      
FROM Inquiries        
WHERE isnull(ProgramId,'') = ''   and InquiryId=@ScreenKeyId       
      
UNION        
        
SELECT 'Inquiries'        
  , 'ClientCanLegalySign'        
  , 'Initial - Disposition - Document cannot be ‘Complete’ until the user has Legally Sign selected ‘Yes’ or ‘No’ '  ,28      
FROM        
 Inquiries        
WHERE        
 [InquiryStatus] = @CompletedGlobalCodeId -- Status Completed            
 AND isnull(ClientCanLegalySign,'') = ''  and InquiryId=@ScreenKeyId      
UNION      
        
      
SELECT 'Inquiries', 'MemberFirstName', 'Invalid Member First Name.'  ,35      
FROM Inquiries        
WHERE isnull(MemberFirstName,'') = ''   and InquiryId=@ScreenKeyId       
----------------------------------------------------------------        
 
UNION        
SELECT 'Inquiries'        
  , 'Referraldate'        
  , 'Referral Date can not be greater than current date.' ,6       
FROM        
 Inquiries        
WHERE        
 Referraldate IS NOT NULL        
 AND Referraldate > GETDATE() AND InquiryId=@ScreenKeyId  -- Selected Population SA            

UNION        

 Select 'CoveragePlans', 'CoveragePlanId', 'Plan with InsuredId is already exists for ' + DP.CoveragePlanName + ' ,' + DP.InsureId  ,38                  
 FROM @DuplicatePlans DP       
        
------------------------------------------------------------------------------------------             
        
SELECT distinct TableName        
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
		DECLARE @Error VARCHAR(8000)                   
	              
		SET @Error= CONVERT(VARCHAR, Error_number()) + '*****'                   
					+ CONVERT(VARCHAR(4000), Error_message())                   
					+ '*****'                   
					+ Isnull(CONVERT(VARCHAR, Error_procedure()),                   
					'ssp_SCValidateInquiry' )                   
					+ '*****' + CONVERT(VARCHAR, Error_line())                   
					+ '*****' + CONVERT(VARCHAR, Error_severity())                   
					+ '*****' + CONVERT(VARCHAR, Error_state())                   
	              
		RAISERROR ( @Error,-- Message text.                                               
					16,-- Severity.                                               
					1 -- State.    
		);                
END CATCH 