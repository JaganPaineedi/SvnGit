

IF NOT EXISTS(SELECT Category from GlobalCodeCategories WHERE Category='CLAIMSTATUSCATEGORY' and ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInCareManagement)
	VALUES('CLAIMSTATUSCATEGORY','CLAIM STATUS CATEGORY','Y','Y','Y','Y','CLAIM STATUS CATEGORY','N','N','Y') 
END
GO 
		
IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3001) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3001,
				 'CLAIMSTATUSCATEGORY', 
                  'Acknowledgement/Forwarded-The claim/encounter has been forwarded to another entity.', 
                  'A0',
                  'Y', 
                  'N',
                  1) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  

		
		
IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3002) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3002,
				 'CLAIMSTATUSCATEGORY', 
                  'Acknowledgement/Receipt-The claim/encounter has been received. This does not mean that the claim has been accepted for adjudication.', 
                  'A1',
                  'Y', 
                  'N',
                  2) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  

  IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3003) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3003,
				 'CLAIMSTATUSCATEGORY', 
                  'Acknowledgement/Acceptance into adjudication system-The claim/encounter has been accepted into the adjudication system.', 
                  'A2',
                  'Y', 
                  'N',
                  3) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
  
  
  IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3004) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3004,
				 'CLAIMSTATUSCATEGORY', 
                  'Acknowledgement/Returned as unprocessable claim-The claim/encounter has been rejected and has not been entered into the adjudication system.', 
                  'A3',
                  'Y', 
                  'N',
                  4) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
  
  IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3005) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3005,
				 'CLAIMSTATUSCATEGORY', 
                  'Acknowledgement/Not Found-The claim/encounter can not be found in the adjudication system.', 
                  'A4',
                  'Y', 
                  'N',
                  5) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
  
  
 IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3006) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3006,
				 'CLAIMSTATUSCATEGORY', 
                  'Acknowledgement/Split Claim-The claim/encounter has been split upon acceptance into the adjudication system.', 
                  'A5',
                  'Y', 
                  'N',
                  6) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  

  
  IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3007) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3007,
				 'CLAIMSTATUSCATEGORY', 
                  'Acknowledgement/Rejected for Missing Information - The claim/encounter is missing the information specified in the Status details and has been rejected.', 
                  'A6',
                  'Y', 
                  'N',
                  7) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
  
 IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3008) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3008,
				 'CLAIMSTATUSCATEGORY', 
                  'Acknowledgement/Rejected for Invalid Information - The claim/encounter has invalid information as specified in the Status details and has been rejected.', 
                  'A7',
                  'Y', 
                  'N',
                  8) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
  
  
 IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3009) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3009,
				 'CLAIMSTATUSCATEGORY', 
                  'Acknowledgement / Rejected for relational field in error.', 
                  'A8',
                  'Y', 
                  'N',
                  9) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
 
  
  IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3010) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3010,
				 'CLAIMSTATUSCATEGORY', 
                  'Pending: Adjudication/Details-This is a generic message about a pended claim. A pended claim is one for which no remittance advice has been issued, or only part of the claim has been paid.', 
                  'P0',
                  'Y', 
                  'N',
                  10) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
  
  
 IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3011) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3011,
				 'CLAIMSTATUSCATEGORY', 
                  'Pending/In Process-The claim or encounter is in the adjudication system.', 
                  'P1',
                  'Y', 
                  'N',
                  11) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
  
  
  IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3012) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3012,
				 'CLAIMSTATUSCATEGORY', 
                  'Pending/Payer Review-The claim/encounter is suspended and is pending review (e.g. medical review, repricing, Third Party Administrator processing).', 
                  'P2',
                  'Y', 
                  'N',
                  12) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
 
   IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3013) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3013,
				 'CLAIMSTATUSCATEGORY', 
                  'Pending/Provider Requested Information - The claim or encounter is waiting for information that has already been requested from the provider. (Note: A Claim Status Code identifying the type of information requested, must be reported)', 
                  'P3',
                  'Y', 
                  'N',
                  13) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
  
   IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3014) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3014,
				 'CLAIMSTATUSCATEGORY', 
                  'Pending/Patient Requested Information - The claim or encounter is waiting for information that has already been requested from the patient. (Note: A status code identifying the type of information requested must be sent)', 
                  'P4',
                  'Y', 
                  'N',
                  14) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
  
  IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3015) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3015,
				 'CLAIMSTATUSCATEGORY', 
                  'Pending/Payer Administrative/System hold', 
                  'P5',
                  'Y', 
                  'N',
                  15) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  

 IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3016) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3016,
				 'CLAIMSTATUSCATEGORY', 
                  'Finalized-The claim/encounter has completed the adjudication cycle and no more action will be taken.', 
                  'F0',
                  'Y', 
                  'N',
                  16) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  

  IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3017) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3017,
				 'CLAIMSTATUSCATEGORY', 
                  'Finalized/Payment-The claim/line has been paid.', 
                  'F1',
                  'Y', 
                  'N',
                  17) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
 
  
  IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3018) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3018,
				 'CLAIMSTATUSCATEGORY', 
                  'Finalized/Denial-The claim/line has been denied.', 
                  'F2',
                  'Y', 
                  'N',
                  18) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
  
   IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3019) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3019,
				 'CLAIMSTATUSCATEGORY', 
                  'Finalized/Revised - Adjudication information has been changed', 
                  'F3',
                  'Y', 
                  'N',
                  19) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
  
  
  IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3020) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3020,
				 'CLAIMSTATUSCATEGORY', 
                  'Finalized/Forwarded-The claim/encounter processing has been completed. Any applicable payment has been made and the claim/encounter has been forwarded to a subsequent entity as identified on the original claim or in this payer''s records.', 
                  'F3F',
                  'Y', 
                  'N',
                  20) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
  
  
   IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3021) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3021,
				 'CLAIMSTATUSCATEGORY', 
                  'Finalized/Not Forwarded-The claim/encounter processing has been completed. Any applicable payment has been made. The claim/encounter has NOT been forwarded to any subsequent entity identified on the original claim.', 
                  'F3N',
                  'Y', 
                  'N',
                  21) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
  
  
   IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3022) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3022,
				 'CLAIMSTATUSCATEGORY', 
                  'Finalized/Adjudication Complete - No payment forthcoming-The claim/encounter has been adjudicated and no further payment is forthcoming.', 
                  'F4',
                  'Y', 
                  'N',
                  22) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  

   IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3023) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3023,
				 'CLAIMSTATUSCATEGORY', 
                  'Requests for additional Information/General Requests-Requests that don''t fall into other R-type categories.', 
                  'R0',
                  'Y', 
                  'N',
                  23) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
 
  
   IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3024) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3024,
				 'CLAIMSTATUSCATEGORY', 
                  'Requests for additional Information/Entity Requests-Requests for information about specific entities (subscribers, patients, various providers).', 
                  'R1',
                  'Y', 
                  'N',
                  24) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
 

   IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3025) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3025,
				 'CLAIMSTATUSCATEGORY', 
                  'Requests for additional Information/Claim/Line-Requests for information that could normally be submitted on a claim.', 
                  'R3',
                  'Y', 
                  'N',
                  25) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
 
  
  IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3026) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3026,
				 'CLAIMSTATUSCATEGORY', 
                  'Requests for additional Information/Documentation-Requests for additional supporting documentation. Examples: certification, x-ray, notes.', 
                  'R4',
                  'Y', 
                  'N',
                  26) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
  
  
   IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3027) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3027,
				 'CLAIMSTATUSCATEGORY', 
                  'Request for additional information/more specific detail-Additional information as a follow up to a previous request is needed. The original information was received but is inadequate. More specific/detailed information is requested.', 
                  'R5',
                  'Y', 
                  'N',
                  27) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
  
  
   IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3028) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3028,
				 'CLAIMSTATUSCATEGORY', 
                  'Requests for additional information – Regulatory requirements', 
                  'R6',
                  'Y', 
                  'N',
                  28) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
 
  IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3029) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3029,
				 'CLAIMSTATUSCATEGORY', 
                  'Requests for additional information – Confirm care is consistent with Health Plan policy coverage', 
                  'R7',
                  'Y', 
                  'N',
                  29) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
  
   IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3030) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3030,
				 'CLAIMSTATUSCATEGORY', 
                  'Requests for additional information – Confirm care is consistent with health plan coverage exceptions', 
                  'R8',
                  'Y', 
                  'N',
                  30) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
  
  
  
   IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3031) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3031,
				 'CLAIMSTATUSCATEGORY', 
                  'Requests for additional information – Determination of medical necessity', 
                  'R9',
                  'Y', 
                  'N',
                  31) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
  
  
   IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3032) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3032,
				 'CLAIMSTATUSCATEGORY', 
                  'Requests for additional information – Support a filed grievance or appeal', 
                  'R10',
                  'Y', 
                  'N',
                  32) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
 
  
   IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3033) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3033,
				 'CLAIMSTATUSCATEGORY', 
                  'Requests for additional information – Pre-payment review of claims', 
                  'R11',
                  'Y', 
                  'N',
                  33) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
 
  IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3034) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3034,
				 'CLAIMSTATUSCATEGORY', 
                  'Requests for additional information – Clarification or justification of use for specified procedure code', 
                  'R12',
                  'Y', 
                  'N',
                  34) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
 
   IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3035) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3035,
				 'CLAIMSTATUSCATEGORY', 
                  'Requests for additional information – Original documents submitted are not readable. Used only for subsequent request(s).', 
                  'R13',
                  'Y', 
                  'N',
                  35) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
  
  
   IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3036) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3036,
				 'CLAIMSTATUSCATEGORY', 
                  'Requests for additional information – Original documents received are not what was requested. Used only for subsequent request(s).', 
                  'R14',
                  'Y', 
                  'N',
                  36) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
 
    IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3037) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3037,
				 'CLAIMSTATUSCATEGORY', 
                  'Requests for additional information – Workers Compensation coverage determination.', 
                  'R15',
                  'Y', 
                  'N',
                  37) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
 
   IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3038) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3038,
				 'CLAIMSTATUSCATEGORY', 
                  'Requests for additional information – Eligibility determination', 
                  'R16',
                  'Y', 
                  'N',
                  38) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
 
  IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3039) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3039,
				 'CLAIMSTATUSCATEGORY', 
                  'Replacement of a Prior Request. Used to indicate that the current attachment request replaces a prior attachment request.', 
                  'R17',
                  'Y', 
                  'N',
                  39) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
 
  
   IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3040) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3040,
				 'CLAIMSTATUSCATEGORY', 
                  'Response not possible - error on submitted request data', 
                  'E0',
                  'Y', 
                  'N',
                  40) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
 
  
   IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3041) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3041,
				 'CLAIMSTATUSCATEGORY', 
                  'Response not possible - System Status', 
                  'E1',
                  'Y', 
                  'N',
                  41) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
 
   IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3042) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3042,
				 'CLAIMSTATUSCATEGORY', 
                  'Information Holder is not responding; resubmit at a later time.', 
                  'E2',
                  'Y', 
                  'N',
                  42) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
 
  
   IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3043) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3043,
				 'CLAIMSTATUSCATEGORY', 
                  'Correction required - relational fields in error.', 
                  'E3',
                  'Y', 
                  'N',
                  43) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
  

   IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3044) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3044,
				 'CLAIMSTATUSCATEGORY', 
                  'Trading partner agreement specific requirement not met: Data correction required. (Note: A status code identifying the type of information requested must be sent)', 
                  'E4',
                  'Y', 
                  'N',
                  44) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
 
  
   IF NOT EXISTS(SELECT * FROM  GlobalCodes WHERE  GlobalcodeId=3045) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,
                   Category, 
                   CodeName, 
                   ExternalCode1,
                   Active, 
                   CannotModifyNameOrDelete,
                   SortOrder) 
      VALUES     (3045,
				 'CLAIMSTATUSCATEGORY', 
                  'Data Search Unsuccessful - The payer is unable to return status on the requested claim(s) based on the submitted search criteria.', 
                  'D0',
                  'Y', 
                  'N',
                  45) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END  
 