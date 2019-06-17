IF NOT EXISTS(SELECT Category from GlobalCodeCategories WHERE Category='CLAIMSTATUSCODES' and ISNULL(RecordDeleted,'N')='N')
BEGIN
	INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInCareManagement)
	VALUES('CLAIMSTATUSCODES','CLAIM STATUS CODES','Y','Y','Y','Y','CLAIM STATUS CODES','N','N','Y') 
END
GO 

IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3046)
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
      VALUES     (3046,
				 'CLAIMSTATUSCODES', 
                  'Cannot provide further status electronically.', 
                  '0',
                  'Y', 
                  'N',
                  1) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3047)
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
      VALUES     (3047,
				 'CLAIMSTATUSCODES', 
                  'For more detailed information, see remittance advice.', 
                  '1',
                  'Y', 
                  'N',
                  2) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3048)
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
      VALUES     (3048,
				 'CLAIMSTATUSCODES', 
                  'More detailed information in letter.', 
                  '2',
                  'Y', 
                  'N',
                  3) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3049)
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
      VALUES     (3049,
				 'CLAIMSTATUSCODES', 
                  'Claim has been adjudicated and is awaiting payment cycle.', 
                  '3',
                  'Y', 
                  'N',
                  4) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3050)
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
      VALUES     (3050,
				 'CLAIMSTATUSCODES', 
                  'Balance due from the subscriber.', 
                  '6',
                  'Y', 
                  'N',
                  5) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3051)
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
      VALUES     (3051,
				 'CLAIMSTATUSCODES', 
                  'One or more originally submitted procedure codes have been combined.', 
                  '12',
                  'Y', 
                  'N',
                  6) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3052)
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
      VALUES     (3052,
				 'CLAIMSTATUSCODES', 
                  'One or more originally submitted procedure code have been modified.', 
                  '15',
                  'Y', 
                  'N',
                  7) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3053)
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
      VALUES     (3053,
				 'CLAIMSTATUSCODES', 
                  'Claim/encounter has been forwarded to entity. Note: This code requires use of an Entity Code.', 
                  '16',
                  'Y', 
                  'N',
                  8) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3054)
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
      VALUES     (3054,
				 'CLAIMSTATUSCODES', 
                  'Claim/encounter has been forwarded by third party entity to entity. Note: This code requires use of an Entity Code.', 
                  '17',
                  'Y', 
                  'N',
                  9) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3055)
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
      VALUES     (3055,
				 'CLAIMSTATUSCODES', 
                  'Entity received claim/encounter, but returned invalid status. Note: This code requires use of an Entity Code.', 
                  '18',
                  'Y', 
                  'N',
                  10) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3056)
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
      VALUES     (3056,
				 'CLAIMSTATUSCODES', 
                  'Entity acknowledges receipt of claim/encounter. Note: This code requires use of an Entity Code.', 
                  '19',
                  'Y', 
                  'N',
                  11) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3057)
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
      VALUES     (3057,
				 'CLAIMSTATUSCODES', 
                  'Accepted for processing.', 
                  '20',
                  'Y', 
                  'N',
                  12) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3058)
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
      VALUES     (3058,
				 'CLAIMSTATUSCODES', 
                  'Missing or invalid information. Note: At least one other status code is required to identify the missing or invalid information.', 
                  '21',
                  'Y', 
                  'N',
                  13) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3059)
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
      VALUES     (3059,
				 'CLAIMSTATUSCODES', 
                  'Returned to Entity. Note: This code requires use of an Entity Code.', 
                  '23',
                  'Y', 
                  'N',
                  14) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3060)
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
      VALUES     (3060,
				 'CLAIMSTATUSCODES', 
                  'Entity not approved as an electronic submitter. Note: This code requires use of an Entity Code.', 
                  '24',
                  'Y', 
                  'N',
                  15) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3061)
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
      VALUES     (3061,
				 'CLAIMSTATUSCODES', 
                  'Entity not approved. Note: This code requires use of an Entity Code.', 
                  '25',
                  'Y', 
                  'N',
                  16) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3062)
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
      VALUES     (3062,
				 'CLAIMSTATUSCODES', 
                  'Entity not found. Note: This code requires use of an Entity Code.', 
                  '26',
                  'Y', 
                  'N',
                  17) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3063)
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
      VALUES     (3063,
				 'CLAIMSTATUSCODES', 
                  'Policy canceled.', 
                  '27',
                  'Y', 
                  'N',
                  18) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3064)
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
      VALUES     (3064,
				 'CLAIMSTATUSCODES', 
                  'Subscriber and policy number/contract number mismatched.', 
                  '29',
                  'Y', 
                  'N',
                  19) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3065)
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
      VALUES     (3065,
				 'CLAIMSTATUSCODES', 
                  'Subscriber and subscriber id mismatched.', 
                  '30',
                  'Y', 
                  'N',
                  20) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3066)
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
      VALUES     (3066,
				 'CLAIMSTATUSCODES', 
                  'Subscriber and policyholder name mismatched.', 
                  '31',
                  'Y', 
                  'N',
                  21) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3067)
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
      VALUES     (3067,
				 'CLAIMSTATUSCODES', 
                  'Subscriber and policy number/contract number not found.', 
                  '32',
                  'Y', 
                  'N',
                  22) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3068)
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
      VALUES     (3068,
				 'CLAIMSTATUSCODES', 
                  'Subscriber and subscriber id not found.', 
                  '33',
                  'Y', 
                  'N',
                  23) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3069)
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
      VALUES     (3069,
				 'CLAIMSTATUSCODES', 
                  'Subscriber and policyholder name not found.', 
                  '34',
                  'Y', 
                  'N',
                  24) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3070)
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
      VALUES     (3070,
				 'CLAIMSTATUSCODES', 
                  'Claim/encounter not found.', 
                  '35',
                  'Y', 
                  'N',
                  25) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3071)
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
      VALUES     (3071,
				 'CLAIMSTATUSCODES', 
                  'Predetermination is on file, awaiting completion of services.', 
                  '37',
                  'Y', 
                  'N',
                  26) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3072)
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
      VALUES     (3072,
				 'CLAIMSTATUSCODES', 
                  'Awaiting next periodic adjudication cycle.', 
                  '38',
                  'Y', 
                  'N',
                  27) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3073)
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
      VALUES     (3073,
				 'CLAIMSTATUSCODES', 
                  'Charges for pregnancy deferred until delivery.', 
                  '39',
                  'Y', 
                  'N',
                  28) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3074)
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
      VALUES     (3074,
				 'CLAIMSTATUSCODES', 
                  'Waiting for final approval.', 
                  '40',
                  'Y', 
                  'N',
                  29) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3075)
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
      VALUES     (3075,
				 'CLAIMSTATUSCODES', 
                  'Special handling required at payer site.', 
                  '41',
                  'Y', 
                  'N',
                  30) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3076)
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
      VALUES     (3076,
				 'CLAIMSTATUSCODES', 
                  'Awaiting related charges.', 
                  '42',
                  'Y', 
                  'N',
                  31) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3077)
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
      VALUES     (3077,
				 'CLAIMSTATUSCODES', 
                  'Charges pending provider audit.', 
                  '44',
                  'Y', 
                  'N',
                  32) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3078)
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
      VALUES     (3078,
				 'CLAIMSTATUSCODES', 
                  'Awaiting benefit determination.', 
                  '45',
                  'Y', 
                  'N',
                  33) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3079)
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
      VALUES     (3079,
				 'CLAIMSTATUSCODES', 
                  'Internal review/audit.', 
                  '46',
                  'Y', 
                  'N',
                  34) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3080)
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
      VALUES     (3080,
				 'CLAIMSTATUSCODES', 
                  'Internal review/audit - partial payment made.', 
                  '47',
                  'Y', 
                  'N',
                  35) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3081)
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
      VALUES     (3081,
				 'CLAIMSTATUSCODES', 
                  'Pending provider accreditation review.', 
                  '49',
                  'Y', 
                  'N',
                  36) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3082)
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
      VALUES     (3082,
				 'CLAIMSTATUSCODES', 
                  'Claim waiting for internal provider verification.', 
                  '50',
                  'Y', 
                  'N',
                  37) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3083)
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
      VALUES     (3083,
				 'CLAIMSTATUSCODES', 
                  'Investigating occupational illness/accident.', 
                  '51',
                  'Y', 
                  'N',
                  38) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3084)
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
      VALUES     (3084,
				 'CLAIMSTATUSCODES', 
                  'Investigating existence of other insurance coverage.', 
                  '52',
                  'Y', 
                  'N',
                  39) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3085)
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
      VALUES     (3085,
				 'CLAIMSTATUSCODES', 
                  'Claim being researched for Insured ID/Group Policy Number error.', 
                  '53',
                  'Y', 
                  'N',
                  40) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3086)
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
      VALUES     (3086,
				 'CLAIMSTATUSCODES', 
                  'Duplicate of a previously processed claim/line.', 
                  '54',
                  'Y', 
                  'N',
                  41) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3087)
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
      VALUES     (3087,
				 'CLAIMSTATUSCODES', 
                  'Claim assigned to an approver/analyst.', 
                  '55',
                  'Y', 
                  'N',
                  42) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3088)
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
      VALUES     (3088,
				 'CLAIMSTATUSCODES', 
                  'Awaiting eligibility determination.', 
                  '56',
                  'Y', 
                  'N',
                  43) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3089)
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
      VALUES     (3089,
				 'CLAIMSTATUSCODES', 
                  'Pending COBRA information requested.', 
                  '57',
                  'Y', 
                  'N',
                  44) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3090)
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
      VALUES     (3090,
				 'CLAIMSTATUSCODES', 
                  'Information was requested by a non-electronic method. Note: At least one other status code is required to identify the requested information.', 
                  '59',
                  'Y', 
                  'N',
                  45) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3091)
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
      VALUES     (3091,
				 'CLAIMSTATUSCODES', 
                  'Information was requested by an electronic method. Note: At least one other status code is required to identify the requested information.', 
                  '60',
                  'Y', 
                  'N',
                  46) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3092)
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
      VALUES     (3092,
				 'CLAIMSTATUSCODES', 
                  'Eligibility for extended benefits.', 
                  '61',
                  'Y', 
                  'N',
                  47) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3093)
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
      VALUES     (3093,
				 'CLAIMSTATUSCODES', 
                  'Re-pricing information.', 
                  '64',
                  'Y', 
                  'N',
                  48) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3094)
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
      VALUES     (3094,
				 'CLAIMSTATUSCODES', 
                  'Claim/line has been paid.', 
                  '65',
                  'Y', 
                  'N',
                  49) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3095)
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
      VALUES     (3095,
				 'CLAIMSTATUSCODES', 
                  'Payment reflects usual and customary charges.', 
                  '66',
                  'Y', 
                  'N',
                  50) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3096)
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
      VALUES     (3096,
				 'CLAIMSTATUSCODES', 
                  'Claim contains split payment.', 
                  '72',
                  'Y', 
                  'N',
                  51) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3097)
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
      VALUES     (3097,
				 'CLAIMSTATUSCODES', 
                  'Payment made to entity, assignment of benefits not on file. Note: This code requires use of an Entity Code.', 
                  '73',
                  'Y', 
                  'N',
                  52) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3098)
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
      VALUES     (3098,
				 'CLAIMSTATUSCODES', 
                  'Duplicate of an existing claim/line, awaiting processing.', 
                  '78',
                  'Y', 
                  'N',
                  53) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3099)
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
      VALUES     (3099,
				 'CLAIMSTATUSCODES', 
                  'Contract/plan does not cover pre-existing conditions.', 
                  '81',
                  'Y', 
                  'N',
                  54) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3100)
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
      VALUES     (3100,
				 'CLAIMSTATUSCODES', 
                  'No coverage for newborns.', 
                  '83',
                  'Y', 
                  'N',
                  55) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3101)
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
      VALUES     (3101,
				 'CLAIMSTATUSCODES', 
                  'Service not authorized.', 
                  '84',
                  'Y', 
                  'N',
                  56) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3102)
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
      VALUES     (3102,
				 'CLAIMSTATUSCODES', 
                  'Entity not primary. Note: This code requires use of an Entity Code.', 
                  '85',
                  'Y', 
                  'N',
                  57) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3103)
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
      VALUES     (3103,
				 'CLAIMSTATUSCODES', 
                  'Diagnosis and patient gender mismatch.', 
                  '86',
                  'Y', 
                  'N',
                  58) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3104)
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
      VALUES     (3104,
				 'CLAIMSTATUSCODES', 
                  'Entity not eligible for benefits for submitted dates of service. Note: This code requires use of an Entity Code.', 
                  '88',
                  'Y', 
                  'N',
                  59) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3105)
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
      VALUES     (3105,
				 'CLAIMSTATUSCODES', 
                  'Entity not eligible for dental benefits for submitted dates of service. Note: This code requires use of an Entity Code.', 
                  '89',
                  'Y', 
                  'N',
                  60) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3106)
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
      VALUES     (3106,
				 'CLAIMSTATUSCODES', 
                  'Entity not eligible for medical benefits for submitted dates of service. Note: This code requires use of an Entity Code.', 
                  '90',
                  'Y', 
                  'N',
                  61) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3107)
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
      VALUES     (3107,
				 'CLAIMSTATUSCODES', 
                  'Entity not eligible/not approved for dates of service. Note: This code requires use of an Entity Code.', 
                  '91',
                  'Y', 
                  'N',
                  62) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3108)
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
      VALUES     (3108,
				 'CLAIMSTATUSCODES', 
                  'Entity does not meet dependent or student qualification. Note: This code requires use of an Entity Code.', 
                  '92',
                  'Y', 
                  'N',
                  63) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3109)
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
      VALUES     (3109,
				 'CLAIMSTATUSCODES', 
                  'Entity is not selected primary care provider. Note: This code requires use of an Entity Code.', 
                  '93',
                  'Y', 
                  'N',
                  64) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3110)
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
      VALUES     (3110,
				 'CLAIMSTATUSCODES', 
                  'Entity not referred by selected primary care provider. Note: This code requires use of an Entity Code.', 
                  '94',
                  'Y', 
                  'N',
                  65) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3111)
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
      VALUES     (3111,
				 'CLAIMSTATUSCODES', 
                  'Requested additional information not received.', 
                  '95',
                  'Y', 
                  'N',
                  66) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3112)
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
      VALUES     (3112,
				 'CLAIMSTATUSCODES', 
                  'No agreement with entity. Note: This code requires use of an Entity Code.', 
                  '96',
                  'Y', 
                  'N',
                  67) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3113)
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
      VALUES     (3113,
				 'CLAIMSTATUSCODES', 
                  'Patient eligibility not found with entity. Note: This code requires use of an Entity Code.', 
                  '97',
                  'Y', 
                  'N',
                  68) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3114)
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
      VALUES     (3114,
				 'CLAIMSTATUSCODES', 
                  'Charges applied to deductible.', 
                  '98',
                  'Y', 
                  'N',
                  69) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3115)
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
      VALUES     (3115,
				 'CLAIMSTATUSCODES', 
                  'Pre-treatment review.', 
                  '99',
                  'Y', 
                  'N',
                  70) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3116)
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
      VALUES     (3116,
				 'CLAIMSTATUSCODES', 
                  'Pre-certification penalty taken.', 
                  '100',
                  'Y', 
                  'N',
                  71) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3117)
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
      VALUES     (3117,
				 'CLAIMSTATUSCODES', 
                  'Claim was processed as adjustment to previous claim.', 
                  '101',
                  'Y', 
                  'N',
                  72) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3118)
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
      VALUES     (3118,
				 'CLAIMSTATUSCODES', 
                  'Newborn''s charges processed on mother''s claim.', 
                  '102',
                  'Y', 
                  'N',
                  73) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3119)
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
      VALUES     (3119,
				 'CLAIMSTATUSCODES', 
                  'Claim combined with other claim(s).', 
                  '103',
                  'Y', 
                  'N',
                  74) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3120)
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
      VALUES     (3120,
				 'CLAIMSTATUSCODES', 
                  'Processed according to plan provisions (Plan refers to provisions that exist between the Health Plan and the Consumer or Patient)', 
                  '104',
                  'Y', 
                  'N',
                  75) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3121)
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
      VALUES     (3121,
				 'CLAIMSTATUSCODES', 
                  'Claim/line is capitated.', 
                  '105',
                  'Y', 
                  'N',
                  76) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3122)
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
      VALUES     (3122,
				 'CLAIMSTATUSCODES', 
                  'This amount is not entity''s responsibility. Note: This code requires use of an Entity Code.', 
                  '106',
                  'Y', 
                  'N',
                  77) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3123)
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
      VALUES     (3123,
				 'CLAIMSTATUSCODES', 
                  'Processed according to contract provisions (Contract refers to provisions that exist between the Health Plan and a Provider of Health Care Services)', 
                  '107',
                  'Y', 
                  'N',
                  78) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3124)
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
      VALUES     (3124,
				 'CLAIMSTATUSCODES', 
                  'Entity not eligible. Note: This code requires use of an Entity Code.', 
                  '109',
                  'Y', 
                  'N',
                  79) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3125)
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
      VALUES     (3125,
				 'CLAIMSTATUSCODES', 
                  'Claim requires pricing information.', 
                  '110',
                  'Y', 
                  'N',
                  80) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3126)
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
      VALUES     (3126,
				 'CLAIMSTATUSCODES', 
                  'At the policyholder''s request these claims cannot be submitted electronically.', 
                  '111',
                  'Y', 
                  'N',
                  81) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3127)
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
      VALUES     (3127,
				 'CLAIMSTATUSCODES', 
                  'Claim/service should be processed by entity. Note: This code requires use of an Entity Code.', 
                  '114',
                  'Y', 
                  'N',
                  82) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3128)
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
      VALUES     (3128,
				 'CLAIMSTATUSCODES', 
                  'Claim submitted to incorrect payer.', 
                  '116',
                  'Y', 
                  'N',
                  83) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3129)
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
      VALUES     (3129,
				 'CLAIMSTATUSCODES', 
                  'Claim requires signature-on-file indicator.', 
                  '117',
                  'Y', 
                  'N',
                  84) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3130)
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
      VALUES     (3130,
				 'CLAIMSTATUSCODES', 
                  'Service line number greater than maximum allowable for payer.', 
                  '121',
                  'Y', 
                  'N',
                  85) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3131)
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
      VALUES     (3131,
				 'CLAIMSTATUSCODES', 
                  'Additional information requested from entity. Note: This code requires use of an Entity Code.', 
                  '123',
                  'Y', 
                  'N',
                  86) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3132)
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
      VALUES     (3132,
				 'CLAIMSTATUSCODES', 
                  'Entity''s name, address, phone and id number. Note: This code requires use of an Entity Code.', 
                  '124',
                  'Y', 
                  'N',
                  87) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3133)
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
      VALUES     (3133,
				 'CLAIMSTATUSCODES', 
                  'Entity''s name. Note: This code requires use of an Entity Code.', 
                  '125',
                  'Y', 
                  'N',
                  88) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3134)
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
      VALUES     (3134,
				 'CLAIMSTATUSCODES', 
                  'Entity''s address. Note: This code requires use of an Entity Code.', 
                  '126',
                  'Y', 
                  'N',
                  89) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3135)
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
      VALUES     (3135,
				 'CLAIMSTATUSCODES', 
                  'Entity''s Communication Number. Note: This code requires use of an Entity Code.', 
                  '127',
                  'Y', 
                  'N',
                  90) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3136)
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
      VALUES     (3136,
				 'CLAIMSTATUSCODES', 
                  'Entity''s tax id. Note: This code requires use of an Entity Code.', 
                  '128',
                  'Y', 
                  'N',
                  91) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3137)
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
      VALUES     (3137,
				 'CLAIMSTATUSCODES', 
                  'Entity''s Blue Cross provider id. Note: This code requires use of an Entity Code.', 
                  '129',
                  'Y', 
                  'N',
                  92) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3138)
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
      VALUES     (3138,
				 'CLAIMSTATUSCODES', 
                  'Entity''s Blue Shield provider id. Note: This code requires use of an Entity Code.', 
                  '130',
                  'Y', 
                  'N',
                  93) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3139)
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
      VALUES     (3139,
				 'CLAIMSTATUSCODES', 
                  'Entity''s Medicare provider id. Note: This code requires use of an Entity Code.', 
                  '131',
                  'Y', 
                  'N',
                  94) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3140)
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
      VALUES     (3140,
				 'CLAIMSTATUSCODES', 
                  'Entity''s Medicaid provider id. Note: This code requires use of an Entity Code.', 
                  '132',
                  'Y', 
                  'N',
                  95) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3141)
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
      VALUES     (3141,
				 'CLAIMSTATUSCODES', 
                  'Entity''s UPIN. Note: This code requires use of an Entity Code.', 
                  '133',
                  'Y', 
                  'N',
                  96) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3142)
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
      VALUES     (3142,
				 'CLAIMSTATUSCODES', 
                  'Entity''s CHAMPUS provider id. Note: This code requires use of an Entity Code.', 
                  '134',
                  'Y', 
                  'N',
                  97) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3143)
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
      VALUES     (3143,
				 'CLAIMSTATUSCODES', 
                  'Entity''s commercial provider id. Note: This code requires use of an Entity Code.', 
                  '135',
                  'Y', 
                  'N',
                  98) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3144)
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
      VALUES     (3144,
				 'CLAIMSTATUSCODES', 
                  'Entity''s health industry id number. Note: This code requires use of an Entity Code.', 
                  '136',
                  'Y', 
                  'N',
                  99) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3145)
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
      VALUES     (3145,
				 'CLAIMSTATUSCODES', 
                  'Entity''s plan network id. Note: This code requires use of an Entity Code.', 
                  '137',
                  'Y', 
                  'N',
                  100) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3146)
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
      VALUES     (3146,
				 'CLAIMSTATUSCODES', 
                  'Entity''s site id . Note: This code requires use of an Entity Code.', 
                  '138',
                  'Y', 
                  'N',
                  101) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3147)
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
      VALUES     (3147,
				 'CLAIMSTATUSCODES', 
                  'Entity''s health maintenance provider id (HMO). Note: This code requires use of an Entity Code.', 
                  '139',
                  'Y', 
                  'N',
                  102) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3148)
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
      VALUES     (3148,
				 'CLAIMSTATUSCODES', 
                  'Entity''s preferred provider organization id (PPO). Note: This code requires use of an Entity Code.', 
                  '140',
                  'Y', 
                  'N',
                  103) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3149)
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
      VALUES     (3149,
				 'CLAIMSTATUSCODES', 
                  'Entity''s administrative services organization id (ASO). Note: This code requires use of an Entity Code.', 
                  '141',
                  'Y', 
                  'N',
                  104) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3150)
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
      VALUES     (3150,
				 'CLAIMSTATUSCODES', 
                  'Entity''s license/certification number. Note: This code requires use of an Entity Code.', 
                  '142',
                  'Y', 
                  'N',
                  105) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3151)
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
      VALUES     (3151,
				 'CLAIMSTATUSCODES', 
                  'Entity''s state license number. Note: This code requires use of an Entity Code.', 
                  '143',
                  'Y', 
                  'N',
                  106) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3152)
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
      VALUES     (3152,
				 'CLAIMSTATUSCODES', 
                  'Entity''s specialty license number. Note: This code requires use of an Entity Code.', 
                  '144',
                  'Y', 
                  'N',
                  107) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3153)
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
      VALUES     (3153,
				 'CLAIMSTATUSCODES', 
                  'Entity''s specialty/taxonomy code. Note: This code requires use of an Entity Code.', 
                  '145',
                  'Y', 
                  'N',
                  108) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3154)
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
      VALUES     (3154,
				 'CLAIMSTATUSCODES', 
                  'Entity''s anesthesia license number. Note: This code requires use of an Entity Code.', 
                  '146',
                  'Y', 
                  'N',
                  109) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3155)
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
      VALUES     (3155,
				 'CLAIMSTATUSCODES', 
                  'Entity''s qualification degree/designation (e.g. RN,PhD,MD). Note: This code requires use of an Entity Code.', 
                  '147',
                  'Y', 
                  'N',
                  110) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3156)
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
      VALUES     (3156,
				 'CLAIMSTATUSCODES', 
                  'Entity''s social security number. Note: This code requires use of an Entity Code.', 
                  '148',
                  'Y', 
                  'N',
                  111) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3157)
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
      VALUES     (3157,
				 'CLAIMSTATUSCODES', 
                  'Entity''s employer id. Note: This code requires use of an Entity Code.', 
                  '149',
                  'Y', 
                  'N',
                  112) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3158)
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
      VALUES     (3158,
				 'CLAIMSTATUSCODES', 
                  'Entity''s drug enforcement agency (DEA) number. Note: This code requires use of an Entity Code.', 
                  '150',
                  'Y', 
                  'N',
                  113) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3159)
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
      VALUES     (3159,
				 'CLAIMSTATUSCODES', 
                  'Pharmacy processor number.', 
                  '152',
                  'Y', 
                  'N',
                  114) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3160)
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
      VALUES     (3160,
				 'CLAIMSTATUSCODES', 
                  'Entity''s id number. Note: This code requires use of an Entity Code.', 
                  '153',
                  'Y', 
                  'N',
                  115) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3161)
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
      VALUES     (3161,
				 'CLAIMSTATUSCODES', 
                  'Relationship of surgeon & assistant surgeon.', 
                  '154',
                  'Y', 
                  'N',
                  116) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3162)
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
      VALUES     (3162,
				 'CLAIMSTATUSCODES', 
                  'Entity''s relationship to patient. Note: This code requires use of an Entity Code.', 
                  '155',
                  'Y', 
                  'N',
                  117) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3163)
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
      VALUES     (3163,
				 'CLAIMSTATUSCODES', 
                  'Patient relationship to subscriber', 
                  '156',
                  'Y', 
                  'N',
                  118) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3164)
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
      VALUES     (3164,
				 'CLAIMSTATUSCODES', 
                  'Entity''s Gender. Note: This code requires use of an Entity Code.', 
                  '157',
                  'Y', 
                  'N',
                  119) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3165)
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
      VALUES     (3165,
				 'CLAIMSTATUSCODES', 
                  'Entity''s date of birth. Note: This code requires use of an Entity Code.', 
                  '158',
                  'Y', 
                  'N',
                  120) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3166)
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
      VALUES     (3166,
				 'CLAIMSTATUSCODES', 
                  'Entity''s date of death. Note: This code requires use of an Entity Code.', 
                  '159',
                  'Y', 
                  'N',
                  121) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3167)
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
      VALUES     (3167,
				 'CLAIMSTATUSCODES', 
                  'Entity''s marital status. Note: This code requires use of an Entity Code.', 
                  '160',
                  'Y', 
                  'N',
                  122) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3168)
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
      VALUES     (3168,
				 'CLAIMSTATUSCODES', 
                  'Entity''s employment status. Note: This code requires use of an Entity Code.', 
                  '161',
                  'Y', 
                  'N',
                  123) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3169)
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
      VALUES     (3169,
				 'CLAIMSTATUSCODES', 
                  'Entity''s health insurance claim number (HICN). Note: This code requires use of an Entity Code.', 
                  '162',
                  'Y', 
                  'N',
                  124) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3170)
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
      VALUES     (3170,
				 'CLAIMSTATUSCODES', 
                  'Entity''s policy number. Note: This code requires use of an Entity Code.', 
                  '163',
                  'Y', 
                  'N',
                  125) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3171)
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
      VALUES     (3171,
				 'CLAIMSTATUSCODES', 
                  'Entity''s contract/member number. Note: This code requires use of an Entity Code.', 
                  '164',
                  'Y', 
                  'N',
                  126) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3172)
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
      VALUES     (3172,
				 'CLAIMSTATUSCODES', 
                  'Entity''s employer name, address and phone. Note: This code requires use of an Entity Code.', 
                  '165',
                  'Y', 
                  'N',
                  127) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3173)
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
      VALUES     (3173,
				 'CLAIMSTATUSCODES', 
                  'Entity''s employer name. Note: This code requires use of an Entity Code.', 
                  '166',
                  'Y', 
                  'N',
                  128) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3174)
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
      VALUES     (3174,
				 'CLAIMSTATUSCODES', 
                  'Entity''s employer address. Note: This code requires use of an Entity Code.', 
                  '167',
                  'Y', 
                  'N',
                  129) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3175)
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
      VALUES     (3175,
				 'CLAIMSTATUSCODES', 
                  'Entity''s employer phone number. Note: This code requires use of an Entity Code.', 
                  '168',
                  'Y', 
                  'N',
                  130) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3176)
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
      VALUES     (3176,
				 'CLAIMSTATUSCODES', 
                  'Entity''s employee id. Note: This code requires use of an Entity Code.', 
                  '170',
                  'Y', 
                  'N',
                  131) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3177)
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
      VALUES     (3177,
				 'CLAIMSTATUSCODES', 
                  'Other insurance coverage information (health, liability, auto, etc.).', 
                  '171',
                  'Y', 
                  'N',
                  132) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3178)
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
      VALUES     (3178,
				 'CLAIMSTATUSCODES', 
                  'Other employer name, address and telephone number.', 
                  '172',
                  'Y', 
                  'N',
                  133) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3179)
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
      VALUES     (3179,
				 'CLAIMSTATUSCODES', 
                  'Entity''s name, address, phone, gender, DOB, marital status, employment status and relation to subscriber. Note: This code requires use of an Entity Code.', 
                  '173',
                  'Y', 
                  'N',
                  134) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3180)
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
      VALUES     (3180,
				 'CLAIMSTATUSCODES', 
                  'Entity''s student status. Note: This code requires use of an Entity Code.', 
                  '174',
                  'Y', 
                  'N',
                  135) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3181)
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
      VALUES     (3181,
				 'CLAIMSTATUSCODES', 
                  'Entity''s school name. Note: This code requires use of an Entity Code.', 
                  '175',
                  'Y', 
                  'N',
                  136) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3182)
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
      VALUES     (3182,
				 'CLAIMSTATUSCODES', 
                  'Entity''s school address. Note: This code requires use of an Entity Code.', 
                  '176',
                  'Y', 
                  'N',
                  137) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3183)
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
      VALUES     (3183,
				 'CLAIMSTATUSCODES', 
                  'Transplant recipient''s name, date of birth, gender, relationship to insured.', 
                  '177',
                  'Y', 
                  'N',
                  138) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3184)
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
      VALUES     (3184,
				 'CLAIMSTATUSCODES', 
                  'Submitted charges.', 
                  '178',
                  'Y', 
                  'N',
                  139) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3185)
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
      VALUES     (3185,
				 'CLAIMSTATUSCODES', 
                  'Outside lab charges.', 
                  '179',
                  'Y', 
                  'N',
                  140) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3186)
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
      VALUES     (3186,
				 'CLAIMSTATUSCODES', 
                  'Hospital s semi-private room rate.', 
                  '180',
                  'Y', 
                  'N',
                  141) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3187)
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
      VALUES     (3187,
				 'CLAIMSTATUSCODES', 
                  'Hospital s room rate.', 
                  '181',
                  'Y', 
                  'N',
                  142) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3188)
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
      VALUES     (3188,
				 'CLAIMSTATUSCODES', 
                  'Allowable/paid from other entities coverage NOTE: This code requires the use of an entity code.', 
                  '182',
                  'Y', 
                  'N',
                  143) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3189)
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
      VALUES     (3189,
				 'CLAIMSTATUSCODES', 
                  'Amount entity has paid. Note: This code requires use of an Entity Code.', 
                  '183',
                  'Y', 
                  'N',
                  144) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3190)
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
      VALUES     (3190,
				 'CLAIMSTATUSCODES', 
                  'Purchase price for the rented durable medical equipment.', 
                  '184',
                  'Y', 
                  'N',
                  145) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3191)
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
      VALUES     (3191,
				 'CLAIMSTATUSCODES', 
                  'Rental price for durable medical equipment.', 
                  '185',
                  'Y', 
                  'N',
                  146) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3192)
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
      VALUES     (3192,
				 'CLAIMSTATUSCODES', 
                  'Purchase and rental price of durable medical equipment.', 
                  '186',
                  'Y', 
                  'N',
                  147) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3193)
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
      VALUES     (3193,
				 'CLAIMSTATUSCODES', 
                  'Date(s) of service.', 
                  '187',
                  'Y', 
                  'N',
                  148) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3194)
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
      VALUES     (3194,
				 'CLAIMSTATUSCODES', 
                  'Statement from-through dates.', 
                  '188',
                  'Y', 
                  'N',
                  149) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3195)
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
      VALUES     (3195,
				 'CLAIMSTATUSCODES', 
                  'Facility admission date', 
                  '189',
                  'Y', 
                  'N',
                  150) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3196)
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
      VALUES     (3196,
				 'CLAIMSTATUSCODES', 
                  'Facility discharge date', 
                  '190',
                  'Y', 
                  'N',
                  151) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3197)
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
      VALUES     (3197,
				 'CLAIMSTATUSCODES', 
                  'Date of Last Menstrual Period (LMP)', 
                  '191',
                  'Y', 
                  'N',
                  152) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3198)
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
      VALUES     (3198,
				 'CLAIMSTATUSCODES', 
                  'Date of first service for current series/symptom/illness.', 
                  '192',
                  'Y', 
                  'N',
                  153) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3199)
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
      VALUES     (3199,
				 'CLAIMSTATUSCODES', 
                  'First consultation/evaluation date.', 
                  '193',
                  'Y', 
                  'N',
                  154) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3200)
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
      VALUES     (3200,
				 'CLAIMSTATUSCODES', 
                  'Confinement dates.', 
                  '194',
                  'Y', 
                  'N',
                  155) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3201)
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
      VALUES     (3201,
				 'CLAIMSTATUSCODES', 
                  'Unable to work dates/Disability Dates.', 
                  '195',
                  'Y', 
                  'N',
                  156) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3202)
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
      VALUES     (3202,
				 'CLAIMSTATUSCODES', 
                  'Return to work dates.', 
                  '196',
                  'Y', 
                  'N',
                  157) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3203)
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
      VALUES     (3203,
				 'CLAIMSTATUSCODES', 
                  'Effective coverage date(s).', 
                  '197',
                  'Y', 
                  'N',
                  158) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3204)
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
      VALUES     (3204,
				 'CLAIMSTATUSCODES', 
                  'Medicare effective date.', 
                  '198',
                  'Y', 
                  'N',
                  159) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3205)
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
      VALUES     (3205,
				 'CLAIMSTATUSCODES', 
                  'Date of conception and expected date of delivery.', 
                  '199',
                  'Y', 
                  'N',
                  160) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3206)
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
      VALUES     (3206,
				 'CLAIMSTATUSCODES', 
                  'Date of equipment return.', 
                  '200',
                  'Y', 
                  'N',
                  161) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3207)
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
      VALUES     (3207,
				 'CLAIMSTATUSCODES', 
                  'Date of dental appliance prior placement.', 
                  '201',
                  'Y', 
                  'N',
                  162) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3208)
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
      VALUES     (3208,
				 'CLAIMSTATUSCODES', 
                  'Date of dental prior replacement/reason for replacement.', 
                  '202',
                  'Y', 
                  'N',
                  163) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3209)
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
      VALUES     (3209,
				 'CLAIMSTATUSCODES', 
                  'Date of dental appliance placed.', 
                  '203',
                  'Y', 
                  'N',
                  164) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3210)
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
      VALUES     (3210,
				 'CLAIMSTATUSCODES', 
                  'Date dental canal(s) opened and date service completed.', 
                  '204',
                  'Y', 
                  'N',
                  165) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3211)
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
      VALUES     (3211,
				 'CLAIMSTATUSCODES', 
                  'Date(s) dental root canal therapy previously performed.', 
                  '205',
                  'Y', 
                  'N',
                  166) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3212)
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
      VALUES     (3212,
				 'CLAIMSTATUSCODES', 
                  'Most recent date of curettage, root planing, or periodontal surgery.', 
                  '206',
                  'Y', 
                  'N',
                  167) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3213)
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
      VALUES     (3213,
				 'CLAIMSTATUSCODES', 
                  'Dental impression and seating date.', 
                  '207',
                  'Y', 
                  'N',
                  168) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3214)
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
      VALUES     (3214,
				 'CLAIMSTATUSCODES', 
                  'Most recent date pacemaker was implanted.', 
                  '208',
                  'Y', 
                  'N',
                  169) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3215)
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
      VALUES     (3215,
				 'CLAIMSTATUSCODES', 
                  'Most recent pacemaker battery change date.', 
                  '209',
                  'Y', 
                  'N',
                  170) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3216)
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
      VALUES     (3216,
				 'CLAIMSTATUSCODES', 
                  'Date of the last x-ray.', 
                  '210',
                  'Y', 
                  'N',
                  171) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3217)
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
      VALUES     (3217,
				 'CLAIMSTATUSCODES', 
                  'Date(s) of dialysis training provided to patient.', 
                  '211',
                  'Y', 
                  'N',
                  172) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3218)
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
      VALUES     (3218,
				 'CLAIMSTATUSCODES', 
                  'Date of last routine dialysis.', 
                  '212',
                  'Y', 
                  'N',
                  173) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3219)
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
      VALUES     (3219,
				 'CLAIMSTATUSCODES', 
                  'Date of first routine dialysis.', 
                  '213',
                  'Y', 
                  'N',
                  174) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3220)
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
      VALUES     (3220,
				 'CLAIMSTATUSCODES', 
                  'Original date of prescription/orders/referral.', 
                  '214',
                  'Y', 
                  'N',
                  175) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3221)
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
      VALUES     (3221,
				 'CLAIMSTATUSCODES', 
                  'Date of tooth extraction/evolution.', 
                  '215',
                  'Y', 
                  'N',
                  176) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3222)
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
      VALUES     (3222,
				 'CLAIMSTATUSCODES', 
                  'Drug information.', 
                  '216',
                  'Y', 
                  'N',
                  177) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3223)
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
      VALUES     (3223,
				 'CLAIMSTATUSCODES', 
                  'Drug name, strength and dosage form.', 
                  '217',
                  'Y', 
                  'N',
                  178) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3224)
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
      VALUES     (3224,
				 'CLAIMSTATUSCODES', 
                  'NDC number.', 
                  '218',
                  'Y', 
                  'N',
                  179) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3225)
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
      VALUES     (3225,
				 'CLAIMSTATUSCODES', 
                  'Prescription number.', 
                  '219',
                  'Y', 
                  'N',
                  180) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3226)
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
      VALUES     (3226,
				 'CLAIMSTATUSCODES', 
                  'Drug dispensing units and average wholesale price (AWP).', 
                  '222',
                  'Y', 
                  'N',
                  181) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3227)
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
      VALUES     (3227,
				 'CLAIMSTATUSCODES', 
                  'Route of drug/myelogram administration.', 
                  '223',
                  'Y', 
                  'N',
                  182) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3228)
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
      VALUES     (3228,
				 'CLAIMSTATUSCODES', 
                  'Anatomical location for joint injection.', 
                  '224',
                  'Y', 
                  'N',
                  183) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3229)
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
      VALUES     (3229,
				 'CLAIMSTATUSCODES', 
                  'Anatomical location.', 
                  '225',
                  'Y', 
                  'N',
                  184) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3230)
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
      VALUES     (3230,
				 'CLAIMSTATUSCODES', 
                  'Joint injection site.', 
                  '226',
                  'Y', 
                  'N',
                  185) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3231)
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
      VALUES     (3231,
				 'CLAIMSTATUSCODES', 
                  'Hospital information.', 
                  '227',
                  'Y', 
                  'N',
                  186) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3232)
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
      VALUES     (3232,
				 'CLAIMSTATUSCODES', 
                  'Type of bill for UB claim', 
                  '228',
                  'Y', 
                  'N',
                  187) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3233)
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
      VALUES     (3233,
				 'CLAIMSTATUSCODES', 
                  'Hospital admission source.', 
                  '229',
                  'Y', 
                  'N',
                  188) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3234)
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
      VALUES     (3234,
				 'CLAIMSTATUSCODES', 
                  'Hospital admission hour.', 
                  '230',
                  'Y', 
                  'N',
                  189) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3235)
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
      VALUES     (3235,
				 'CLAIMSTATUSCODES', 
                  'Hospital admission type.', 
                  '231',
                  'Y', 
                  'N',
                  190) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3236)
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
      VALUES     (3236,
				 'CLAIMSTATUSCODES', 
                  'Admitting diagnosis.', 
                  '232',
                  'Y', 
                  'N',
                  191) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3237)
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
      VALUES     (3237,
				 'CLAIMSTATUSCODES', 
                  'Hospital discharge hour.', 
                  '233',
                  'Y', 
                  'N',
                  192) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3238)
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
      VALUES     (3238,
				 'CLAIMSTATUSCODES', 
                  'Patient discharge status.', 
                  '234',
                  'Y', 
                  'N',
                  193) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3239)
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
      VALUES     (3239,
				 'CLAIMSTATUSCODES', 
                  'Units of blood furnished.', 
                  '235',
                  'Y', 
                  'N',
                  194) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3240)
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
      VALUES     (3240,
				 'CLAIMSTATUSCODES', 
                  'Units of blood replaced.', 
                  '236',
                  'Y', 
                  'N',
                  195) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3241)
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
      VALUES     (3241,
				 'CLAIMSTATUSCODES', 
                  'Units of deductible blood.', 
                  '237',
                  'Y', 
                  'N',
                  196) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3242)
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
      VALUES     (3242,
				 'CLAIMSTATUSCODES', 
                  'Separate claim for mother/baby charges.', 
                  '238',
                  'Y', 
                  'N',
                  197) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3243)
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
      VALUES     (3243,
				 'CLAIMSTATUSCODES', 
                  'Dental information.', 
                  '239',
                  'Y', 
                  'N',
                  198) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3244)
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
      VALUES     (3244,
				 'CLAIMSTATUSCODES', 
                  'Tooth surface(s) involved.', 
                  '240',
                  'Y', 
                  'N',
                  199) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3245)
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
      VALUES     (3245,
				 'CLAIMSTATUSCODES', 
                  'List of all missing teeth (upper and lower).', 
                  '241',
                  'Y', 
                  'N',
                  200) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3246)
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
      VALUES     (3246,
				 'CLAIMSTATUSCODES', 
                  'Tooth numbers, surfaces, and/or quadrants involved.', 
                  '242',
                  'Y', 
                  'N',
                  201) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3247)
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
      VALUES     (3247,
				 'CLAIMSTATUSCODES', 
                  'Months of dental treatment remaining.', 
                  '243',
                  'Y', 
                  'N',
                  202) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3248)
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
      VALUES     (3248,
				 'CLAIMSTATUSCODES', 
                  'Tooth number or letter.', 
                  '244',
                  'Y', 
                  'N',
                  203) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3249)
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
      VALUES     (3249,
				 'CLAIMSTATUSCODES', 
                  'Dental quadrant/arch.', 
                  '245',
                  'Y', 
                  'N',
                  204) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3250)
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
      VALUES     (3250,
				 'CLAIMSTATUSCODES', 
                  'Total orthodontic service fee, initial appliance fee, monthly fee, length of service.', 
                  '246',
                  'Y', 
                  'N',
                  205) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3251)
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
      VALUES     (3251,
				 'CLAIMSTATUSCODES', 
                  'Line information.', 
                  '247',
                  'Y', 
                  'N',
                  206) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3252)
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
      VALUES     (3252,
				 'CLAIMSTATUSCODES', 
                  'Place of service.', 
                  '249',
                  'Y', 
                  'N',
                  207) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3253)
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
      VALUES     (3253,
				 'CLAIMSTATUSCODES', 
                  'Type of service.', 
                  '250',
                  'Y', 
                  'N',
                  208) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3254)
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
      VALUES     (3254,
				 'CLAIMSTATUSCODES', 
                  'Total anesthesia minutes.', 
                  '251',
                  'Y', 
                  'N',
                  209) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3255)
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
      VALUES     (3255,
				 'CLAIMSTATUSCODES', 
                  'Entity''s authorization/certification number. Note: This code requires the use of an Entity Code.', 
                  '252',
                  'Y', 
                  'N',
                  210) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3256)
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
      VALUES     (3256,
				 'CLAIMSTATUSCODES', 
                  'Principal diagnosis code.', 
                  '254',
                  'Y', 
                  'N',
                  211) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3257)
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
      VALUES     (3257,
				 'CLAIMSTATUSCODES', 
                  'Diagnosis code.', 
                  '255',
                  'Y', 
                  'N',
                  212) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3258)
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
      VALUES     (3258,
				 'CLAIMSTATUSCODES', 
                  'DRG code(s).', 
                  '256',
                  'Y', 
                  'N',
                  213) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3259)
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
      VALUES     (3259,
				 'CLAIMSTATUSCODES', 
                  'ADSM-III-R code for services rendered.', 
                  '257',
                  'Y', 
                  'N',
                  214) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3260)
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
      VALUES     (3260,
				 'CLAIMSTATUSCODES', 
                  'Days/units for procedure/revenue code.', 
                  '258',
                  'Y', 
                  'N',
                  215) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3261)
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
      VALUES     (3261,
				 'CLAIMSTATUSCODES', 
                  'Frequency of service.', 
                  '259',
                  'Y', 
                  'N',
                  216) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3262)
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
      VALUES     (3262,
				 'CLAIMSTATUSCODES', 
                  'Length of medical necessity, including begin date.', 
                  '260',
                  'Y', 
                  'N',
                  217) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3263)
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
      VALUES     (3263,
				 'CLAIMSTATUSCODES', 
                  'Obesity measurements.', 
                  '261',
                  'Y', 
                  'N',
                  218) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3264)
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
      VALUES     (3264,
				 'CLAIMSTATUSCODES', 
                  'Type of surgery/service for which anesthesia was administered.', 
                  '262',
                  'Y', 
                  'N',
                  219) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3265)
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
      VALUES     (3265,
				 'CLAIMSTATUSCODES', 
                  'Length of time for services rendered.', 
                  '263',
                  'Y', 
                  'N',
                  220) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3266)
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
      VALUES     (3266,
				 'CLAIMSTATUSCODES', 
                  'Number of liters/minute & total hours/day for respiratory support.', 
                  '264',
                  'Y', 
                  'N',
                  221) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3267)
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
      VALUES     (3267,
				 'CLAIMSTATUSCODES', 
                  'Number of lesions excised.', 
                  '265',
                  'Y', 
                  'N',
                  222) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3268)
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
      VALUES     (3268,
				 'CLAIMSTATUSCODES', 
                  'Facility point of origin and destination - ambulance.', 
                  '266',
                  'Y', 
                  'N',
                  223) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3269)
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
      VALUES     (3269,
				 'CLAIMSTATUSCODES', 
                  'Number of miles patient was transported.', 
                  '267',
                  'Y', 
                  'N',
                  224) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3270)
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
      VALUES     (3270,
				 'CLAIMSTATUSCODES', 
                  'Location of durable medical equipment use.', 
                  '268',
                  'Y', 
                  'N',
                  225) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3271)
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
      VALUES     (3271,
				 'CLAIMSTATUSCODES', 
                  'Length/size of laceration/tumor.', 
                  '269',
                  'Y', 
                  'N',
                  226) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3272)
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
      VALUES     (3272,
				 'CLAIMSTATUSCODES', 
                  'Subluxation location.', 
                  '270',
                  'Y', 
                  'N',
                  227) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3273)
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
      VALUES     (3273,
				 'CLAIMSTATUSCODES', 
                  'Number of spine segments.', 
                  '271',
                  'Y', 
                  'N',
                  228) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3274)
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
      VALUES     (3274,
				 'CLAIMSTATUSCODES', 
                  'Oxygen contents for oxygen system rental.', 
                  '272',
                  'Y', 
                  'N',
                  229) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3275)
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
      VALUES     (3275,
				 'CLAIMSTATUSCODES', 
                  'Weight.', 
                  '273',
                  'Y', 
                  'N',
                  230) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3276)
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
      VALUES     (3276,
				 'CLAIMSTATUSCODES', 
                  'Height.', 
                  '274',
                  'Y', 
                  'N',
                  231) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3277)
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
      VALUES     (3277,
				 'CLAIMSTATUSCODES', 
                  'Claim.', 
                  '275',
                  'Y', 
                  'N',
                  232) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3278)
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
      VALUES     (3278,
				 'CLAIMSTATUSCODES', 
                  'UB04/HCFA-1450/1500 claim form', 
                  '276',
                  'Y', 
                  'N',
                  233) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3279)
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
      VALUES     (3279,
				 'CLAIMSTATUSCODES', 
                  'Paper claim.', 
                  '277',
                  'Y', 
                  'N',
                  234) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3280)
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
      VALUES     (3280,
				 'CLAIMSTATUSCODES', 
                  'Claim/service must be itemized', 
                  '279',
                  'Y', 
                  'N',
                  235) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3281)
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
      VALUES     (3281,
				 'CLAIMSTATUSCODES', 
                  'Related confinement claim.', 
                  '281',
                  'Y', 
                  'N',
                  236) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3282)
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
      VALUES     (3282,
				 'CLAIMSTATUSCODES', 
                  'Copy of prescription.', 
                  '282',
                  'Y', 
                  'N',
                  237) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3283)
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
      VALUES     (3283,
				 'CLAIMSTATUSCODES', 
                  'Medicare entitlement information is required to determine primary coverage', 
                  '283',
                  'Y', 
                  'N',
                  238) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3284)
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
      VALUES     (3284,
				 'CLAIMSTATUSCODES', 
                  'Copy of Medicare ID card.', 
                  '284',
                  'Y', 
                  'N',
                  239) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3285)
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
      VALUES     (3285,
				 'CLAIMSTATUSCODES', 
                  'Other payer''s Explanation of Benefits/payment information.', 
                  '286',
                  'Y', 
                  'N',
                  240) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3286)
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
      VALUES     (3286,
				 'CLAIMSTATUSCODES', 
                  'Medical necessity for service.', 
                  '287',
                  'Y', 
                  'N',
                  241) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3287)
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
      VALUES     (3287,
				 'CLAIMSTATUSCODES', 
                  'Hospital late charges', 
                  '288',
                  'Y', 
                  'N',
                  242) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3288)
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
      VALUES     (3288,
				 'CLAIMSTATUSCODES', 
                  'Pre-existing information.', 
                  '290',
                  'Y', 
                  'N',
                  243) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3289)
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
      VALUES     (3289,
				 'CLAIMSTATUSCODES', 
                  'Reason for termination of pregnancy.', 
                  '291',
                  'Y', 
                  'N',
                  244) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3290)
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
      VALUES     (3290,
				 'CLAIMSTATUSCODES', 
                  'Purpose of family conference/therapy.', 
                  '292',
                  'Y', 
                  'N',
                  245) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3291)
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
      VALUES     (3291,
				 'CLAIMSTATUSCODES', 
                  'Reason for physical therapy.', 
                  '293',
                  'Y', 
                  'N',
                  246) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3292)
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
      VALUES     (3292,
				 'CLAIMSTATUSCODES', 
                  'Supporting documentation. Note: At least one other status code is required to identify the supporting documentation.', 
                  '294',
                  'Y', 
                  'N',
                  247) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3293)
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
      VALUES     (3293,
				 'CLAIMSTATUSCODES', 
                  'Attending physician report.', 
                  '295',
                  'Y', 
                  'N',
                  248) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3294)
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
      VALUES     (3294,
				 'CLAIMSTATUSCODES', 
                  'Nurse''s notes.', 
                  '296',
                  'Y', 
                  'N',
                  249) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3295)
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
      VALUES     (3295,
				 'CLAIMSTATUSCODES', 
                  'Medical notes/report.', 
                  '297',
                  'Y', 
                  'N',
                  250) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3296)
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
      VALUES     (3296,
				 'CLAIMSTATUSCODES', 
                  'Operative report.', 
                  '298',
                  'Y', 
                  'N',
                  251) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3297)
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
      VALUES     (3297,
				 'CLAIMSTATUSCODES', 
                  'Emergency room notes/report.', 
                  '299',
                  'Y', 
                  'N',
                  252) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3298)
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
      VALUES     (3298,
				 'CLAIMSTATUSCODES', 
                  'Lab/test report/notes/results.', 
                  '300',
                  'Y', 
                  'N',
                  253) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END

/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3299)
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
      VALUES     (3299,
				 'CLAIMSTATUSCODES', 
                  'MRI report.', 
                  '301',
                  'Y', 
                  'N',
                  254) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3300)
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
      VALUES     (3300,
				 'CLAIMSTATUSCODES', 
                  'Radiology/x-ray reports and/or interpretation', 
                  '305',
                  'Y', 
                  'N',
                  255) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3301)
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
      VALUES     (3301,
				 'CLAIMSTATUSCODES', 
                  'Detailed description of service.', 
                  '306',
                  'Y', 
                  'N',
                  256) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3302)
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
      VALUES     (3302,
				 'CLAIMSTATUSCODES', 
                  'Narrative with pocket depth chart.', 
                  '307',
                  'Y', 
                  'N',
                  257) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3303)
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
      VALUES     (3303,
				 'CLAIMSTATUSCODES', 
                  'Discharge summary.', 
                  '308',
                  'Y', 
                  'N',
                  258) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3304)
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
      VALUES     (3304,
				 'CLAIMSTATUSCODES', 
                  'Progress notes for the six months prior to statement date.', 
                  '310',
                  'Y', 
                  'N',
                  259) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3305)
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
      VALUES     (3305,
				 'CLAIMSTATUSCODES', 
                  'Pathology notes/report.', 
                  '311',
                  'Y', 
                  'N',
                  260) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3306)
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
      VALUES     (3306,
				 'CLAIMSTATUSCODES', 
                  'Dental charting.', 
                  '312',
                  'Y', 
                  'N',
                  261) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3307)
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
      VALUES     (3307,
				 'CLAIMSTATUSCODES', 
                  'Bridgework information.', 
                  '313',
                  'Y', 
                  'N',
                  262) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3308)
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
      VALUES     (3308,
				 'CLAIMSTATUSCODES', 
                  'Dental records for this service.', 
                  '314',
                  'Y', 
                  'N',
                  263) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3309)
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
      VALUES     (3309,
				 'CLAIMSTATUSCODES', 
                  'Past perio treatment history.', 
                  '315',
                  'Y', 
                  'N',
                  264) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3310)
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
      VALUES     (3310,
				 'CLAIMSTATUSCODES', 
                  'Complete medical history.', 
                  '316',
                  'Y', 
                  'N',
                  265) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3311)
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
      VALUES     (3311,
				 'CLAIMSTATUSCODES', 
                  'X-rays/radiology films', 
                  '318',
                  'Y', 
                  'N',
                  266) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3312)
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
      VALUES     (3312,
				 'CLAIMSTATUSCODES', 
                  'Pre/post-operative x-rays/photographs.', 
                  '319',
                  'Y', 
                  'N',
                  267) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3313)
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
      VALUES     (3313,
				 'CLAIMSTATUSCODES', 
                  'Study models.', 
                  '320',
                  'Y', 
                  'N',
                  268) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3314)
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
      VALUES     (3314,
				 'CLAIMSTATUSCODES', 
                  'Recent Full Mouth X-rays', 
                  '322',
                  'Y', 
                  'N',
                  269) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3315)
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
      VALUES     (3315,
				 'CLAIMSTATUSCODES', 
                  'Study models, x-rays, and/or narrative.', 
                  '323',
                  'Y', 
                  'N',
                  270) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3316)
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
      VALUES     (3316,
				 'CLAIMSTATUSCODES', 
                  'Recent x-ray of treatment area and/or narrative.', 
                  '324',
                  'Y', 
                  'N',
                  271) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3317)
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
      VALUES     (3317,
				 'CLAIMSTATUSCODES', 
                  'Recent fm x-rays and/or narrative.', 
                  '325',
                  'Y', 
                  'N',
                  272) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3318)
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
      VALUES     (3318,
				 'CLAIMSTATUSCODES', 
                  'Copy of transplant acquisition invoice.', 
                  '326',
                  'Y', 
                  'N',
                  273) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3319)
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
      VALUES     (3319,
				 'CLAIMSTATUSCODES', 
                  'Periodontal case type diagnosis and recent pocket depth chart with narrative.', 
                  '327',
                  'Y', 
                  'N',
                  274) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3320)
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
      VALUES     (3320,
				 'CLAIMSTATUSCODES', 
                  'Exercise notes.', 
                  '329',
                  'Y', 
                  'N',
                  275) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3321)
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
      VALUES     (3321,
				 'CLAIMSTATUSCODES', 
                  'Occupational notes.', 
                  '330',
                  'Y', 
                  'N',
                  276) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3322)
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
      VALUES     (3322,
				 'CLAIMSTATUSCODES', 
                  'History and physical.', 
                  '331',
                  'Y', 
                  'N',
                  277) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3323)
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
      VALUES     (3323,
				 'CLAIMSTATUSCODES', 
                  'Patient release of information authorization.', 
                  '333',
                  'Y', 
                  'N',
                  278) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3324)
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
      VALUES     (3324,
				 'CLAIMSTATUSCODES', 
                  'Oxygen certification.', 
                  '334',
                  'Y', 
                  'N',
                  279) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3325)
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
      VALUES     (3325,
				 'CLAIMSTATUSCODES', 
                  'Durable medical equipment certification.', 
                  '335',
                  'Y', 
                  'N',
                  280) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3326)
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
      VALUES     (3326,
				 'CLAIMSTATUSCODES', 
                  'Chiropractic certification.', 
                  '336',
                  'Y', 
                  'N',
                  281) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3327)
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
      VALUES     (3327,
				 'CLAIMSTATUSCODES', 
                  'Ambulance certification/documentation.', 
                  '337',
                  'Y', 
                  'N',
                  282) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3328)
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
      VALUES     (3328,
				 'CLAIMSTATUSCODES', 
                  'Enteral/parenteral certification.', 
                  '339',
                  'Y', 
                  'N',
                  283) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3329)
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
      VALUES     (3329,
				 'CLAIMSTATUSCODES', 
                  'Pacemaker certification.', 
                  '340',
                  'Y', 
                  'N',
                  284) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3330)
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
      VALUES     (3330,
				 'CLAIMSTATUSCODES', 
                  'Private duty nursing certification.', 
                  '341',
                  'Y', 
                  'N',
                  285) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3331)
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
      VALUES     (3331,
				 'CLAIMSTATUSCODES', 
                  'Podiatric certification.', 
                  '342',
                  'Y', 
                  'N',
                  286) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3332)
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
      VALUES     (3332,
				 'CLAIMSTATUSCODES', 
                  'Documentation that facility is state licensed and Medicare approved as a surgical facility.', 
                  '343',
                  'Y', 
                  'N',
                  287) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3333)
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
      VALUES     (3333,
				 'CLAIMSTATUSCODES', 
                  'Documentation that provider of physical therapy is Medicare Part B approved.', 
                  '344',
                  'Y', 
                  'N',
                  288) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3334)
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
      VALUES     (3334,
				 'CLAIMSTATUSCODES', 
                  'Treatment plan for service/diagnosis', 
                  '345',
                  'Y', 
                  'N',
                  289) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3335)
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
      VALUES     (3335,
				 'CLAIMSTATUSCODES', 
                  'Proposed treatment plan for next 6 months.', 
                  '346',
                  'Y', 
                  'N',
                  290) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3336)
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
      VALUES     (3336,
				 'CLAIMSTATUSCODES', 
                  'Duration of treatment plan.', 
                  '352',
                  'Y', 
                  'N',
                  291) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3337)
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
      VALUES     (3337,
				 'CLAIMSTATUSCODES', 
                  'Orthodontics treatment plan.', 
                  '353',
                  'Y', 
                  'N',
                  292) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3338)
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
      VALUES     (3338,
				 'CLAIMSTATUSCODES', 
                  'Treatment plan for replacement of remaining missing teeth.', 
                  '354',
                  'Y', 
                  'N',
                  293) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3339)
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
      VALUES     (3339,
				 'CLAIMSTATUSCODES', 
                  'Benefits Assignment Certification Indicator', 
                  '360',
                  'Y', 
                  'N',
                  294) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3340)
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
      VALUES     (3340,
				 'CLAIMSTATUSCODES', 
                  'Possible Workers'' Compensation', 
                  '363',
                  'Y', 
                  'N',
                  295) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3341)
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
      VALUES     (3341,
				 'CLAIMSTATUSCODES', 
                  'Is accident/illness/condition employment related?', 
                  '364',
                  'Y', 
                  'N',
                  296) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3342)
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
      VALUES     (3342,
				 'CLAIMSTATUSCODES', 
                  'Is service the result of an accident?', 
                  '365',
                  'Y', 
                  'N',
                  297) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3343)
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
      VALUES     (3343,
				 'CLAIMSTATUSCODES', 
                  'Is injury due to auto accident?', 
                  '366',
                  'Y', 
                  'N',
                  298) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3344)
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
      VALUES     (3344,
				 'CLAIMSTATUSCODES', 
                  'Is prescribed lenses a result of cataract surgery?', 
                  '374',
                  'Y', 
                  'N',
                  299) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3345)
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
      VALUES     (3345,
				 'CLAIMSTATUSCODES', 
                  'Was refraction performed?', 
                  '375',
                  'Y', 
                  'N',
                  300) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3346)
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
      VALUES     (3346,
				 'CLAIMSTATUSCODES', 
                  'CRNA supervision/medical direction.', 
                  '380',
                  'Y', 
                  'N',
                  301) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3347)
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
      VALUES     (3347,
				 'CLAIMSTATUSCODES', 
                  'Did provider authorize generic or brand name dispensing?', 
                  '382',
                  'Y', 
                  'N',
                  302) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3348)
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
      VALUES     (3348,
				 'CLAIMSTATUSCODES', 
                  'Nerve block use (surgery vs. pain management)', 
                  '383',
                  'Y', 
                  'N',
                  303) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3349)
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
      VALUES     (3349,
				 'CLAIMSTATUSCODES', 
                  'Is prosthesis/crown/inlay placement an initial placement or a replacement?', 
                  '384',
                  'Y', 
                  'N',
                  304) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3350)
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
      VALUES     (3350,
				 'CLAIMSTATUSCODES', 
                  'Is appliance upper or lower arch & is appliance fixed or removable?', 
                  '385',
                  'Y', 
                  'N',
                  305) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3351)
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
      VALUES     (3351,
				 'CLAIMSTATUSCODES', 
                  'Orthodontic Treatment/Purpose Indicator', 
                  '386',
                  'Y', 
                  'N',
                  306) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3352)
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
      VALUES     (3352,
				 'CLAIMSTATUSCODES', 
                  'Date patient last examined by entity. Note: This code requires use of an Entity Code.', 
                  '387',
                  'Y', 
                  'N',
                  307) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3353)
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
      VALUES     (3353,
				 'CLAIMSTATUSCODES', 
                  'Date post-operative care assumed', 
                  '388',
                  'Y', 
                  'N',
                  308) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3354)
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
      VALUES     (3354,
				 'CLAIMSTATUSCODES', 
                  'Date post-operative care relinquished', 
                  '389',
                  'Y', 
                  'N',
                  309) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3355)
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
      VALUES     (3355,
				 'CLAIMSTATUSCODES', 
                  'Date of most recent medical event necessitating service(s)', 
                  '390',
                  'Y', 
                  'N',
                  310) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3356)
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
      VALUES     (3356,
				 'CLAIMSTATUSCODES', 
                  'Date(s) dialysis conducted', 
                  '391',
                  'Y', 
                  'N',
                  311) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3357)
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
      VALUES     (3357,
				 'CLAIMSTATUSCODES', 
                  'Date(s) of most recent hospitalization related to service', 
                  '394',
                  'Y', 
                  'N',
                  312) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3358)
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
      VALUES     (3358,
				 'CLAIMSTATUSCODES', 
                  'Date entity signed certification/recertification Note: This code requires use of an Entity Code.', 
                  '395',
                  'Y', 
                  'N',
                  313) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3359)
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
      VALUES     (3359,
				 'CLAIMSTATUSCODES', 
                  'Date home dialysis began', 
                  '396',
                  'Y', 
                  'N',
                  314) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3360)
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
      VALUES     (3360,
				 'CLAIMSTATUSCODES', 
                  'Date of onset/exacerbation of illness/condition', 
                  '397',
                  'Y', 
                  'N',
                  315) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3361)
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
      VALUES     (3361,
				 'CLAIMSTATUSCODES', 
                  'Visual field test results', 
                  '398',
                  'Y', 
                  'N',
                  316) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3362)
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
      VALUES     (3362,
				 'CLAIMSTATUSCODES', 
                  'Claim is out of balance', 
                  '400',
                  'Y', 
                  'N',
                  317) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3363)
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
      VALUES     (3363,
				 'CLAIMSTATUSCODES', 
                  'Source of payment is not valid', 
                  '401',
                  'Y', 
                  'N',
                  318) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3364)
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
      VALUES     (3364,
				 'CLAIMSTATUSCODES', 
                  'Amount must be greater than zero. Note: At least one other status code is required to identify which amount element is in error.', 
                  '402',
                  'Y', 
                  'N',
                  319) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3365)
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
      VALUES     (3365,
				 'CLAIMSTATUSCODES', 
                  'Entity referral notes/orders/prescription', 
                  '403',
                  'Y', 
                  'N',
                  320) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3366)
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
      VALUES     (3366,
				 'CLAIMSTATUSCODES', 
                  'Brief medical history as related to service(s)', 
                  '406',
                  'Y', 
                  'N',
                  321) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3367)
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
      VALUES     (3367,
				 'CLAIMSTATUSCODES', 
                  'Complications/mitigating circumstances', 
                  '407',
                  'Y', 
                  'N',
                  322) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3368)
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
      VALUES     (3368,
				 'CLAIMSTATUSCODES', 
                  'Initial certification', 
                  '408',
                  'Y', 
                  'N',
                  323) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3369)
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
      VALUES     (3369,
				 'CLAIMSTATUSCODES', 
                  'Medication logs/records (including medication therapy)', 
                  '409',
                  'Y', 
                  'N',
                  324) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3370)
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
      VALUES     (3370,
				 'CLAIMSTATUSCODES', 
                  'Necessity for concurrent care (more than one physician treating the patient)', 
                  '414',
                  'Y', 
                  'N',
                  325) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3371)
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
      VALUES     (3371,
				 'CLAIMSTATUSCODES', 
                  'Prior testing, including result(s) and date(s) as related to service(s)', 
                  '417',
                  'Y', 
                  'N',
                  326) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3372)
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
      VALUES     (3372,
				 'CLAIMSTATUSCODES', 
                  'Individual test(s) comprising the panel and the charges for each test', 
                  '419',
                  'Y', 
                  'N',
                  327) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3373)
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
      VALUES     (3373,
				 'CLAIMSTATUSCODES', 
                  'Name, dosage and medical justification of contrast material used for radiology procedure', 
                  '420',
                  'Y', 
                  'N',
                  328) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3374)
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
      VALUES     (3374,
				 'CLAIMSTATUSCODES', 
                  'Reason for transport by ambulance', 
                  '428',
                  'Y', 
                  'N',
                  329) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3375)
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
      VALUES     (3375,
				 'CLAIMSTATUSCODES', 
                  'Nearest appropriate facility', 
                  '430',
                  'Y', 
                  'N',
                  330) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3376)
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
      VALUES     (3376,
				 'CLAIMSTATUSCODES', 
                  'Patient''s condition/functional status at time of service.', 
                  '431',
                  'Y', 
                  'N',
                  331) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3377)
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
      VALUES     (3377,
				 'CLAIMSTATUSCODES', 
                  'Date benefits exhausted', 
                  '432',
                  'Y', 
                  'N',
                  332) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3378)
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
      VALUES     (3378,
				 'CLAIMSTATUSCODES', 
                  'Copy of patient revocation of hospice benefits', 
                  '433',
                  'Y', 
                  'N',
                  333) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3379)
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
      VALUES     (3379,
				 'CLAIMSTATUSCODES', 
                  'Reasons for more than one transfer per entitlement period', 
                  '434',
                  'Y', 
                  'N',
                  334) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3380)
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
      VALUES     (3380,
				 'CLAIMSTATUSCODES', 
                  'Notice of Admission', 
                  '435',
                  'Y', 
                  'N',
                  335) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3381)
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
      VALUES     (3381,
				 'CLAIMSTATUSCODES', 
                  'Entity professional qualification for service(s)', 
                  '441',
                  'Y', 
                  'N',
                  336) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3382)
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
      VALUES     (3382,
				 'CLAIMSTATUSCODES', 
                  'Modalities of service', 
                  '442',
                  'Y', 
                  'N',
                  337) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3383)
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
      VALUES     (3383,
				 'CLAIMSTATUSCODES', 
                  'Initial evaluation report', 
                  '443',
                  'Y', 
                  'N',
                  338) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3384)
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
      VALUES     (3384,
				 'CLAIMSTATUSCODES', 
                  'Projected date to discontinue service(s)', 
                  '449',
                  'Y', 
                  'N',
                  339) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3385)
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
      VALUES     (3385,
				 'CLAIMSTATUSCODES', 
                  'Awaiting spend down determination', 
                  '450',
                  'Y', 
                  'N',
                  340) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3386)
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
      VALUES     (3386,
				 'CLAIMSTATUSCODES', 
                  'Preoperative and post-operative diagnosis', 
                  '451',
                  'Y', 
                  'N',
                  341) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3387)
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
      VALUES     (3387,
				 'CLAIMSTATUSCODES', 
                  'Total visits in total number of hours/day and total number of hours/week', 
                  '452',
                  'Y', 
                  'N',
                  342) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3388)
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
      VALUES     (3388,
				 'CLAIMSTATUSCODES', 
                  'Procedure Code Modifier(s) for Service(s) Rendered', 
                  '453',
                  'Y', 
                  'N',
                  343) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3389)
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
      VALUES     (3389,
				 'CLAIMSTATUSCODES', 
                  'Procedure code for services rendered.', 
                  '454',
                  'Y', 
                  'N',
                  344) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3390)
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
      VALUES     (3390,
				 'CLAIMSTATUSCODES', 
                  'Revenue code for services rendered.', 
                  '455',
                  'Y', 
                  'N',
                  345) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3391)
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
      VALUES     (3391,
				 'CLAIMSTATUSCODES', 
                  'Covered Day(s)', 
                  '456',
                  'Y', 
                  'N',
                  346) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3392)
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
      VALUES     (3392,
				 'CLAIMSTATUSCODES', 
                  'Non-Covered Day(s)', 
                  '457',
                  'Y', 
                  'N',
                  347) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3393)
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
      VALUES     (3393,
				 'CLAIMSTATUSCODES', 
                  'Coinsurance Day(s)', 
                  '458',
                  'Y', 
                  'N',
                  348) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3394)
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
      VALUES     (3394,
				 'CLAIMSTATUSCODES', 
                  'Lifetime Reserve Day(s)', 
                  '459',
                  'Y', 
                  'N',
                  349) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3395)
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
      VALUES     (3395,
				 'CLAIMSTATUSCODES', 
                  'NUBC Condition Code(s)', 
                  '460',
                  'Y', 
                  'N',
                  350) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3396)
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
      VALUES     (3396,
				 'CLAIMSTATUSCODES', 
                  'Payer Assigned Claim Control Number', 
                  '464',
                  'Y', 
                  'N',
                  351) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3397)
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
      VALUES     (3397,
				 'CLAIMSTATUSCODES', 
                  'Principal Procedure Code for Service(s) Rendered', 
                  '465',
                  'Y', 
                  'N',
                  352) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3398)
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
      VALUES     (3398,
				 'CLAIMSTATUSCODES', 
                  'Entity''s Original Signature. Note: This code requires use of an Entity Code.', 
                  '466',
                  'Y', 
                  'N',
                  353) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3399)
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
      VALUES     (3399,
				 'CLAIMSTATUSCODES', 
                  'Entity Signature Date. Note: This code requires use of an Entity Code.', 
                  '467',
                  'Y', 
                  'N',
                  354) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3400)
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
      VALUES     (3400,
				 'CLAIMSTATUSCODES', 
                  'Patient Signature Source', 
                  '468',
                  'Y', 
                  'N',
                  355) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3401)
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
      VALUES     (3401,
				 'CLAIMSTATUSCODES', 
                  'Purchase Service Charge', 
                  '469',
                  'Y', 
                  'N',
                  356) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3402)
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
      VALUES     (3402,
				 'CLAIMSTATUSCODES', 
                  'Was service purchased from another entity? Note: This code requires use of an Entity Code.', 
                  '470',
                  'Y', 
                  'N',
                  357) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3403)
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
      VALUES     (3403,
				 'CLAIMSTATUSCODES', 
                  'Were services related to an emergency?', 
                  '471',
                  'Y', 
                  'N',
                  358) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3404)
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
      VALUES     (3404,
				 'CLAIMSTATUSCODES', 
                  'Ambulance Run Sheet', 
                  '472',
                  'Y', 
                  'N',
                  359) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3405)
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
      VALUES     (3405,
				 'CLAIMSTATUSCODES', 
                  'Missing or invalid lab indicator', 
                  '473',
                  'Y', 
                  'N',
                  360) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3406)
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
      VALUES     (3406,
				 'CLAIMSTATUSCODES', 
                  'Procedure code and patient gender mismatch', 
                  '474',
                  'Y', 
                  'N',
                  361) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3407)
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
      VALUES     (3407,
				 'CLAIMSTATUSCODES', 
                  'Procedure code not valid for patient age', 
                  '475',
                  'Y', 
                  'N',
                  362) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3408)
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
      VALUES     (3408,
				 'CLAIMSTATUSCODES', 
                  'Missing or invalid units of service', 
                  '476',
                  'Y', 
                  'N',
                  363) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3409)
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
      VALUES     (3409,
				 'CLAIMSTATUSCODES', 
                  'Diagnosis code pointer is missing or invalid', 
                  '477',
                  'Y', 
                  'N',
                  364) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3410)
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
      VALUES     (3410,
				 'CLAIMSTATUSCODES', 
                  'Claim submitter''s identifier', 
                  '478',
                  'Y', 
                  'N',
                  365) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3411)
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
      VALUES     (3411,
				 'CLAIMSTATUSCODES', 
                  'Other Carrier payer ID is missing or invalid', 
                  '479',
                  'Y', 
                  'N',
                  366) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3412)
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
      VALUES     (3412,
				 'CLAIMSTATUSCODES', 
                  'Entity''s claim filing indicator. Note: This code requires use of an Entity Code.', 
                  '480',
                  'Y', 
                  'N',
                  367) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3413)
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
      VALUES     (3413,
				 'CLAIMSTATUSCODES', 
                  'Claim/submission format is invalid.', 
                  '481',
                  'Y', 
                  'N',
                  368) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3414)
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
      VALUES     (3414,
				 'CLAIMSTATUSCODES', 
                  'Maximum coverage amount met or exceeded for benefit period.', 
                  '483',
                  'Y', 
                  'N',
                  369) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3415)
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
      VALUES     (3415,
				 'CLAIMSTATUSCODES', 
                  'Business Application Currently Not Available', 
                  '484',
                  'Y', 
                  'N',
                  370) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3416)
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
      VALUES     (3416,
				 'CLAIMSTATUSCODES', 
                  'More information available than can be returned in real time mode. Narrow your current search criteria.', 
                  '485',
                  'Y', 
                  'N',
                  371) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3417)
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
      VALUES     (3417,
				 'CLAIMSTATUSCODES', 
                  'Principal Procedure Date', 
                  '486',
                  'Y', 
                  'N',
                  372) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3418)
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
      VALUES     (3418,
				 'CLAIMSTATUSCODES', 
                  'Claim not found, claim should have been submitted to/through ''entity''. Note: This code requires use of an Entity Code.', 
                  '487',
                  'Y', 
                  'N',
                  373) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3419)
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
      VALUES     (3419,
				 'CLAIMSTATUSCODES', 
                  'Diagnosis code(s) for the services rendered.', 
                  '488',
                  'Y', 
                  'N',
                  374) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3420)
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
      VALUES     (3420,
				 'CLAIMSTATUSCODES', 
                  'Attachment Control Number', 
                  '489',
                  'Y', 
                  'N',
                  375) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3421)
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
      VALUES     (3421,
				 'CLAIMSTATUSCODES', 
                  'Other Procedure Code for Service(s) Rendered', 
                  '490',
                  'Y', 
                  'N',
                  376) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3422)
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
      VALUES     (3422,
				 'CLAIMSTATUSCODES', 
                  'Entity not eligible for encounter submission. Note: This code requires use of an Entity Code.', 
                  '491',
                  'Y', 
                  'N',
                  377) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3423)
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
      VALUES     (3423,
				 'CLAIMSTATUSCODES', 
                  'Other Procedure Date', 
                  '492',
                  'Y', 
                  'N',
                  378) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3424)
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
      VALUES     (3424,
				 'CLAIMSTATUSCODES', 
                  'Version/Release/Industry ID code not currently supported by information holder', 
                  '493',
                  'Y', 
                  'N',
                  379) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3425)
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
      VALUES     (3425,
				 'CLAIMSTATUSCODES', 
                  'Real-Time requests not supported by the information holder, resubmit as batch request', 
                  '494',
                  'Y', 
                  'N',
                  380) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END

/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3426)
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
      VALUES     (3426,
				 'CLAIMSTATUSCODES', 
                  'Requests for re-adjudication must reference the newly assigned payer claim control number for this previously adjusted claim. Correct the payer claim control number and re-submit.', 
                  '495',
                  'Y', 
                  'N',
                  381) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3427)
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
      VALUES     (3427,
				 'CLAIMSTATUSCODES', 
                  'Submitter not approved for electronic claim submissions on behalf of this entity. Note: This code requires use of an Entity Code.', 
                  '496',
                  'Y', 
                  'N',
                  382) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3428)
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
      VALUES     (3428,
				 'CLAIMSTATUSCODES', 
                  'Sales tax not paid', 
                  '497',
                  'Y', 
                  'N',
                  383) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3429)
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
      VALUES     (3429,
				 'CLAIMSTATUSCODES', 
                  'Maximum leave days exhausted', 
                  '498',
                  'Y', 
                  'N',
                  384) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3430)
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
      VALUES     (3430,
				 'CLAIMSTATUSCODES', 
                  'No rate on file with the payer for this service for this entity Note: This code requires use of an Entity Code.', 
                  '499',
                  'Y', 
                  'N',
                  385) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3431)
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
      VALUES     (3431,
				 'CLAIMSTATUSCODES', 
                  'Entity''s Postal/Zip Code. Note: This code requires use of an Entity Code.', 
                  '500',
                  'Y', 
                  'N',
                  386) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3432)
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
      VALUES     (3432,
				 'CLAIMSTATUSCODES', 
                  'Entity''s State/Province. Note: This code requires use of an Entity Code.', 
                  '501',
                  'Y', 
                  'N',
                  387) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3433)
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
      VALUES     (3433,
				 'CLAIMSTATUSCODES', 
                  'Entity''s City. Note: This code requires use of an Entity Code.', 
                  '502',
                  'Y', 
                  'N',
                  388) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3434)
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
      VALUES     (3434,
				 'CLAIMSTATUSCODES', 
                  'Entity''s Street Address. Note: This code requires use of an Entity Code.', 
                  '503',
                  'Y', 
                  'N',
                  389) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3435)
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
      VALUES     (3435,
				 'CLAIMSTATUSCODES', 
                  'Entity''s Last Name. Note: This code requires use of an Entity Code.', 
                  '504',
                  'Y', 
                  'N',
                  390) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3436)
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
      VALUES     (3436,
				 'CLAIMSTATUSCODES', 
                  'Entity''s First Name. Note: This code requires use of an Entity Code.', 
                  '505',
                  'Y', 
                  'N',
                  391) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3437)
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
      VALUES     (3437,
				 'CLAIMSTATUSCODES', 
                  'Entity is changing processor/clearinghouse. This claim must be submitted to the new processor/clearinghouse. Note: This code requires use of an Entity Code.', 
                  '506',
                  'Y', 
                  'N',
                  392) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3438)
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
      VALUES     (3438,
				 'CLAIMSTATUSCODES', 
                  'HCPCS', 
                  '507',
                  'Y', 
                  'N',
                  393) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3439)
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
      VALUES     (3439,
				 'CLAIMSTATUSCODES', 
                  'ICD9 NOTE: At least one other status code is required to identify the related procedure code or diagnosis code.', 
                  '508',
                  'Y', 
                  'N',
                  394) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3440)
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
      VALUES     (3440,
				 'CLAIMSTATUSCODES', 
                  'External Cause of Injury Code (E-code).', 
                  '509',
                  'Y', 
                  'N',
                  395) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3441)
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
      VALUES     (3441,
				 'CLAIMSTATUSCODES', 
                  'Future date. Note: At least one other status code is required to identify the data element in error.', 
                  '510',
                  'Y', 
                  'N',
                  396) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3442)
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
      VALUES     (3442,
				 'CLAIMSTATUSCODES', 
                  'Invalid character. Note: At least one other status code is required to identify the data element in error.', 
                  '511',
                  'Y', 
                  'N',
                  397) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3443)
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
      VALUES     (3443,
				 'CLAIMSTATUSCODES', 
                  'Length invalid for receiver''s application system. Note: At least one other status code is required to identify the data element in error.', 
                  '512',
                  'Y', 
                  'N',
                  398) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3444)
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
      VALUES     (3444,
				 'CLAIMSTATUSCODES', 
                  'HIPPS Rate Code for services Rendered', 
                  '513',
                  'Y', 
                  'N',
                  399) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3445)
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
      VALUES     (3445,
				 'CLAIMSTATUSCODES', 
                  'Entity''s Middle Name Note: This code requires use of an Entity Code.', 
                  '514',
                  'Y', 
                  'N',
                  400) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3446)
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
      VALUES     (3446,
				 'CLAIMSTATUSCODES', 
                  'Managed Care review', 
                  '515',
                  'Y', 
                  'N',
                  401) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3447)
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
      VALUES     (3447,
				 'CLAIMSTATUSCODES', 
                  'Other Entity''s Adjudication or Payment/Remittance Date. Note: An Entity code is required to identify the Other Payer Entity, i.e. primary, secondary.', 
                  '516',
                  'Y', 
                  'N',
                  402) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3448)
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
      VALUES     (3448,
				 'CLAIMSTATUSCODES', 
                  'Adjusted Repriced Claim Reference Number', 
                  '517',
                  'Y', 
                  'N',
                  403) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3449)
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
      VALUES     (3449,
				 'CLAIMSTATUSCODES', 
                  'Adjusted Repriced Line item Reference Number', 
                  '518',
                  'Y', 
                  'N',
                  404) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3450)
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
      VALUES     (3450,
				 'CLAIMSTATUSCODES', 
                  'Adjustment Amount', 
                  '519',
                  'Y', 
                  'N',
                  405) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3451)
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
      VALUES     (3451,
				 'CLAIMSTATUSCODES', 
                  'Adjustment Quantity', 
                  '520',
                  'Y', 
                  'N',
                  406) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3452)
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
      VALUES     (3452,
				 'CLAIMSTATUSCODES', 
                  'Adjustment Reason Code', 
                  '521',
                  'Y', 
                  'N',
                  407) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3453)
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
      VALUES     (3453,
				 'CLAIMSTATUSCODES', 
                  'Anesthesia Modifying Units', 
                  '522',
                  'Y', 
                  'N',
                  408) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3454)
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
      VALUES     (3454,
				 'CLAIMSTATUSCODES', 
                  'Anesthesia Unit Count', 
                  '523',
                  'Y', 
                  'N',
                  409) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3455)
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
      VALUES     (3455,
				 'CLAIMSTATUSCODES', 
                  'Arterial Blood Gas Quantity', 
                  '524',
                  'Y', 
                  'N',
                  410) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3456)
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
      VALUES     (3456,
				 'CLAIMSTATUSCODES', 
                  'Begin Therapy Date', 
                  '525',
                  'Y', 
                  'N',
                  411) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3457)
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
      VALUES     (3457,
				 'CLAIMSTATUSCODES', 
                  'Bundled or Unbundled Line Number', 
                  '526',
                  'Y', 
                  'N',
                  412) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3458)
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
      VALUES     (3458,
				 'CLAIMSTATUSCODES', 
                  'Certification Condition Indicator', 
                  '527',
                  'Y', 
                  'N',
                  413) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3459)
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
      VALUES     (3459,
				 'CLAIMSTATUSCODES', 
                  'Certification Period Projected Visit Count', 
                  '528',
                  'Y', 
                  'N',
                  414) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3460)
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
      VALUES     (3460,
				 'CLAIMSTATUSCODES', 
                  'Certification Revision Date', 
                  '529',
                  'Y', 
                  'N',
                  415) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3461)
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
      VALUES     (3461,
				 'CLAIMSTATUSCODES', 
                  'Claim Adjustment Indicator', 
                  '530',
                  'Y', 
                  'N',
                  416) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3462)
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
      VALUES     (3462,
				 'CLAIMSTATUSCODES', 
                  'Claim Disproportinate Share Amount', 
                  '531',
                  'Y', 
                  'N',
                  417) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3463)
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
      VALUES     (3463,
				 'CLAIMSTATUSCODES', 
                  'Claim DRG Amount', 
                  '532',
                  'Y', 
                  'N',
                  418) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3464)
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
      VALUES     (3464,
				 'CLAIMSTATUSCODES', 
                  'Claim DRG Outlier Amount', 
                  '533',
                  'Y', 
                  'N',
                  419) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3465)
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
      VALUES     (3465,
				 'CLAIMSTATUSCODES', 
                  'Claim ESRD Payment Amount', 
                  '534',
                  'Y', 
                  'N',
                  420) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3466)
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
      VALUES     (3466,
				 'CLAIMSTATUSCODES', 
                  'Claim Frequency Code', 
                  '535',
                  'Y', 
                  'N',
                  421) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3467)
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
      VALUES     (3467,
				 'CLAIMSTATUSCODES', 
                  'Claim Indirect Teaching Amount', 
                  '536',
                  'Y', 
                  'N',
                  422) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3468)
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
      VALUES     (3468,
				 'CLAIMSTATUSCODES', 
                  'Claim MSP Pass-through Amount', 
                  '537',
                  'Y', 
                  'N',
                  423) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3469)
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
      VALUES     (3469,
				 'CLAIMSTATUSCODES', 
                  'Claim or Encounter Identifier', 
                  '538',
                  'Y', 
                  'N',
                  424) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3470)
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
      VALUES     (3470,
				 'CLAIMSTATUSCODES', 
                  'Claim PPS Capital Amount', 
                  '539',
                  'Y', 
                  'N',
                  425) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3471)
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
      VALUES     (3471,
				 'CLAIMSTATUSCODES', 
                  'Claim PPS Capital Outlier Amount', 
                  '540',
                  'Y', 
                  'N',
                  426) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3472)
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
      VALUES     (3472,
				 'CLAIMSTATUSCODES', 
                  'Claim Submission Reason Code', 
                  '541',
                  'Y', 
                  'N',
                  427) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3473)
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
      VALUES     (3473,
				 'CLAIMSTATUSCODES', 
                  'Claim Total Denied Charge Amount', 
                  '542',
                  'Y', 
                  'N',
                  428) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3474)
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
      VALUES     (3474,
				 'CLAIMSTATUSCODES', 
                  'Clearinghouse or Value Added Network Trace', 
                  '543',
                  'Y', 
                  'N',
                  429) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3475)
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
      VALUES     (3475,
				 'CLAIMSTATUSCODES', 
                  'Clinical Laboratory Improvement Amendment', 
                  '544',
                  'Y', 
                  'N',
                  430) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3476)
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
      VALUES     (3476,
				 'CLAIMSTATUSCODES', 
                  'Contract Amount', 
                  '545',
                  'Y', 
                  'N',
                  431) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3477)
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
      VALUES     (3477,
				 'CLAIMSTATUSCODES', 
                  'Contract Code', 
                  '546',
                  'Y', 
                  'N',
                  432) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3478)
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
      VALUES     (3478,
				 'CLAIMSTATUSCODES', 
                  'Contract Percentage', 
                  '547',
                  'Y', 
                  'N',
                  433) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3479)
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
      VALUES     (3479,
				 'CLAIMSTATUSCODES', 
                  'Contract Type Code', 
                  '548',
                  'Y', 
                  'N',
                  434) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3480)
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
      VALUES     (3480,
				 'CLAIMSTATUSCODES', 
                  'Contract Version Identifier', 
                  '549',
                  'Y', 
                  'N',
                  435) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3481)
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
      VALUES     (3481,
				 'CLAIMSTATUSCODES', 
                  'Coordination of Benefits Code', 
                  '550',
                  'Y', 
                  'N',
                  436) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3482)
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
      VALUES     (3482,
				 'CLAIMSTATUSCODES', 
                  'Coordination of Benefits Total Submitted Charge', 
                  '551',
                  'Y', 
                  'N',
                  437) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3483)
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
      VALUES     (3483,
				 'CLAIMSTATUSCODES', 
                  'Cost Report Day Count', 
                  '552',
                  'Y', 
                  'N',
                  438) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3484)
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
      VALUES     (3484,
				 'CLAIMSTATUSCODES', 
                  'Covered Amount', 
                  '553',
                  'Y', 
                  'N',
                  439) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3485)
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
      VALUES     (3485,
				 'CLAIMSTATUSCODES', 
                  'Date Claim Paid', 
                  '554',
                  'Y', 
                  'N',
                  440) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3486)
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
      VALUES     (3486,
				 'CLAIMSTATUSCODES', 
                  'Delay Reason Code', 
                  '555',
                  'Y', 
                  'N',
                  441) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3487)
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
      VALUES     (3487,
				 'CLAIMSTATUSCODES', 
                  'Demonstration Project Identifier', 
                  '556',
                  'Y', 
                  'N',
                  442) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3488)
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
      VALUES     (3488,
				 'CLAIMSTATUSCODES', 
                  'Diagnosis Date', 
                  '557',
                  'Y', 
                  'N',
                  443) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3489)
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
      VALUES     (3489,
				 'CLAIMSTATUSCODES', 
                  'Discount Amount', 
                  '558',
                  'Y', 
                  'N',
                  444) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3490)
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
      VALUES     (3490,
				 'CLAIMSTATUSCODES', 
                  'Document Control Identifier', 
                  '559',
                  'Y', 
                  'N',
                  445) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3491)
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
      VALUES     (3491,
				 'CLAIMSTATUSCODES', 
                  'Entity''s Additional/Secondary Identifier. Note: This code requires use of an Entity Code.', 
                  '560',
                  'Y', 
                  'N',
                  446) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3492)
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
      VALUES     (3492,
				 'CLAIMSTATUSCODES', 
                  'Entity''s Contact Name. Note: This code requires use of an Entity Code.', 
                  '561',
                  'Y', 
                  'N',
                  447) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3493)
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
      VALUES     (3493,
				 'CLAIMSTATUSCODES', 
                  'Entity''s National Provider Identifier (NPI). Note: This code requires use of an Entity Code.', 
                  '562',
                  'Y', 
                  'N',
                  448) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3494)
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
      VALUES     (3494,
				 'CLAIMSTATUSCODES', 
                  'Entity''s Tax Amount. Note: This code requires use of an Entity Code.', 
                  '563',
                  'Y', 
                  'N',
                  449) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3495)
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
      VALUES     (3495,
				 'CLAIMSTATUSCODES', 
                  'EPSDT Indicator', 
                  '564',
                  'Y', 
                  'N',
                  450) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3496)
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
      VALUES     (3496,
				 'CLAIMSTATUSCODES', 
                  'Estimated Claim Due Amount', 
                  '565',
                  'Y', 
                  'N',
                  451) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3497)
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
      VALUES     (3497,
				 'CLAIMSTATUSCODES', 
                  'Exception Code', 
                  '566',
                  'Y', 
                  'N',
                  452) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3498)
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
      VALUES     (3498,
				 'CLAIMSTATUSCODES', 
                  'Facility Code Qualifier', 
                  '567',
                  'Y', 
                  'N',
                  453) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3499)
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
      VALUES     (3499,
				 'CLAIMSTATUSCODES', 
                  'Family Planning Indicator', 
                  '568',
                  'Y', 
                  'N',
                  454) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3500)
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
      VALUES     (3500,
				 'CLAIMSTATUSCODES', 
                  'Fixed Format Information', 
                  '569',
                  'Y', 
                  'N',
                  455) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3501)
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
      VALUES     (3501,
				 'CLAIMSTATUSCODES', 
                  'Frequency Count', 
                  '571',
                  'Y', 
                  'N',
                  456) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3502)
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
      VALUES     (3502,
				 'CLAIMSTATUSCODES', 
                  'Frequency Period', 
                  '572',
                  'Y', 
                  'N',
                  457) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3503)
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
      VALUES     (3503,
				 'CLAIMSTATUSCODES', 
                  'Functional Limitation Code', 
                  '573',
                  'Y', 
                  'N',
                  458) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3504)
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
      VALUES     (3504,
				 'CLAIMSTATUSCODES', 
                  'HCPCS Payable Amount Home Health', 
                  '574',
                  'Y', 
                  'N',
                  459) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3505)
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
      VALUES     (3505,
				 'CLAIMSTATUSCODES', 
                  'Homebound Indicator', 
                  '575',
                  'Y', 
                  'N',
                  460) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3506)
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
      VALUES     (3506,
				 'CLAIMSTATUSCODES', 
                  'Immunization Batch Number', 
                  '576',
                  'Y', 
                  'N',
                  461) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3507)
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
      VALUES     (3507,
				 'CLAIMSTATUSCODES', 
                  'Industry Code', 
                  '577',
                  'Y', 
                  'N',
                  462) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3508)
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
      VALUES     (3508,
				 'CLAIMSTATUSCODES', 
                  'Insurance Type Code', 
                  '578',
                  'Y', 
                  'N',
                  463) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3509)
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
      VALUES     (3509,
				 'CLAIMSTATUSCODES', 
                  'Investigational Device Exemption Identifier', 
                  '579',
                  'Y', 
                  'N',
                  464) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3510)
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
      VALUES     (3510,
				 'CLAIMSTATUSCODES', 
                  'Last Certification Date', 
                  '580',
                  'Y', 
                  'N',
                  465) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3511)
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
      VALUES     (3511,
				 'CLAIMSTATUSCODES', 
                  'Last Worked Date', 
                  '581',
                  'Y', 
                  'N',
                  466) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3512)
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
      VALUES     (3512,
				 'CLAIMSTATUSCODES', 
                  'Lifetime Psychiatric Days Count', 
                  '582',
                  'Y', 
                  'N',
                  467) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3513)
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
      VALUES     (3513,
				 'CLAIMSTATUSCODES', 
                  'Line Item Charge Amount', 
                  '583',
                  'Y', 
                  'N',
                  468) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3514)
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
      VALUES     (3514,
				 'CLAIMSTATUSCODES', 
                  'Line Item Control Number', 
                  '584',
                  'Y', 
                  'N',
                  469) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3515)
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
      VALUES     (3515,
				 'CLAIMSTATUSCODES', 
                  'Denied Charge or Non-covered Charge', 
                  '585',
                  'Y', 
                  'N',
                  470) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3516)
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
      VALUES     (3516,
				 'CLAIMSTATUSCODES', 
                  'Line Note Text', 
                  '586',
                  'Y', 
                  'N',
                  471) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3517)
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
      VALUES     (3517,
				 'CLAIMSTATUSCODES', 
                  'Measurement Reference Identification Code', 
                  '587',
                  'Y', 
                  'N',
                  472) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3518)
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
      VALUES     (3518,
				 'CLAIMSTATUSCODES', 
                  'Medical Record Number', 
                  '588',
                  'Y', 
                  'N',
                  473) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3519)
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
      VALUES     (3519,
				 'CLAIMSTATUSCODES', 
                  'Provider Accept Assignment Code', 
                  '589',
                  'Y', 
                  'N',
                  474) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3520)
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
      VALUES     (3520,
				 'CLAIMSTATUSCODES', 
                  'Medicare Coverage Indicator', 
                  '590',
                  'Y', 
                  'N',
                  475) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3521)
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
      VALUES     (3521,
				 'CLAIMSTATUSCODES', 
                  'Medicare Paid at 100% Amount', 
                  '591',
                  'Y', 
                  'N',
                  476) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3522)
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
      VALUES     (3522,
				 'CLAIMSTATUSCODES', 
                  'Medicare Paid at 80% Amount', 
                  '592',
                  'Y', 
                  'N',
                  477) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3523)
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
      VALUES     (3523,
				 'CLAIMSTATUSCODES', 
                  'Medicare Section 4081 Indicator', 
                  '593',
                  'Y', 
                  'N',
                  478) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3524)
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
      VALUES     (3524,
				 'CLAIMSTATUSCODES', 
                  'Mental Status Code', 
                  '594',
                  'Y', 
                  'N',
                  479) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3525)
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
      VALUES     (3525,
				 'CLAIMSTATUSCODES', 
                  'Monthly Treatment Count', 
                  '595',
                  'Y', 
                  'N',
                  480) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3526)
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
      VALUES     (3526,
				 'CLAIMSTATUSCODES', 
                  'Non-covered Charge Amount', 
                  '596',
                  'Y', 
                  'N',
                  481) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3527)
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
      VALUES     (3527,
				 'CLAIMSTATUSCODES', 
                  'Non-payable Professional Component Amount', 
                  '597',
                  'Y', 
                  'N',
                  482) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3528)
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
      VALUES     (3528,
				 'CLAIMSTATUSCODES', 
                  'Non-payable Professional Component Billed Amount', 
                  '598',
                  'Y', 
                  'N',
                  483) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3529)
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
      VALUES     (3529,
				 'CLAIMSTATUSCODES', 
                  'Note Reference Code', 
                  '599',
                  'Y', 
                  'N',
                  484) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3530)
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
      VALUES     (3530,
				 'CLAIMSTATUSCODES', 
                  'Oxygen Saturation Qty', 
                  '600',
                  'Y', 
                  'N',
                  485) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3531)
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
      VALUES     (3531,
				 'CLAIMSTATUSCODES', 
                  'Oxygen Test Condition Code', 
                  '601',
                  'Y', 
                  'N',
                  486) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3532)
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
      VALUES     (3532,
				 'CLAIMSTATUSCODES', 
                  'Oxygen Test Date', 
                  '602',
                  'Y', 
                  'N',
                  487) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3533)
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
      VALUES     (3533,
				 'CLAIMSTATUSCODES', 
                  'Old Capital Amount', 
                  '603',
                  'Y', 
                  'N',
                  488) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3534)
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
      VALUES     (3534,
				 'CLAIMSTATUSCODES', 
                  'Originator Application Transaction Identifier', 
                  '604',
                  'Y', 
                  'N',
                  489) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3535)
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
      VALUES     (3535,
				 'CLAIMSTATUSCODES', 
                  'Orthodontic Treatment Months Count', 
                  '605',
                  'Y', 
                  'N',
                  490) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3536)
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
      VALUES     (3536,
				 'CLAIMSTATUSCODES', 
                  'Paid From Part A Medicare Trust Fund Amount', 
                  '606',
                  'Y', 
                  'N',
                  491) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3537)
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
      VALUES     (3537,
				 'CLAIMSTATUSCODES', 
                  'Paid From Part B Medicare Trust Fund Amount', 
                  '607',
                  'Y', 
                  'N',
                  492) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3538)
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
      VALUES     (3538,
				 'CLAIMSTATUSCODES', 
                  'Paid Service Unit Count', 
                  '608',
                  'Y', 
                  'N',
                  493) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3539)
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
      VALUES     (3539,
				 'CLAIMSTATUSCODES', 
                  'Participation Agreement', 
                  '609',
                  'Y', 
                  'N',
                  494) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3540)
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
      VALUES     (3540,
				 'CLAIMSTATUSCODES', 
                  'Patient Discharge Facility Type Code', 
                  '610',
                  'Y', 
                  'N',
                  495) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3541)
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
      VALUES     (3541,
				 'CLAIMSTATUSCODES', 
                  'Peer Review Authorization Number', 
                  '611',
                  'Y', 
                  'N',
                  496) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3542)
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
      VALUES     (3542,
				 'CLAIMSTATUSCODES', 
                  'Per Day Limit Amount', 
                  '612',
                  'Y', 
                  'N',
                  497) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3543)
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
      VALUES     (3543,
				 'CLAIMSTATUSCODES', 
                  'Physician Contact Date', 
                  '613',
                  'Y', 
                  'N',
                  498) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3544)
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
      VALUES     (3544,
				 'CLAIMSTATUSCODES', 
                  'Physician Order Date', 
                  '614',
                  'Y', 
                  'N',
                  499) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3545)
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
      VALUES     (3545,
				 'CLAIMSTATUSCODES', 
                  'Policy Compliance Code', 
                  '615',
                  'Y', 
                  'N',
                  500) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3546)
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
      VALUES     (3546,
				 'CLAIMSTATUSCODES', 
                  'Policy Name', 
                  '616',
                  'Y', 
                  'N',
                  501) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3547)
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
      VALUES     (3547,
				 'CLAIMSTATUSCODES', 
                  'Postage Claimed Amount', 
                  '617',
                  'Y', 
                  'N',
                  502) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3548)
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
      VALUES     (3548,
				 'CLAIMSTATUSCODES', 
                  'PPS-Capital DSH DRG Amount', 
                  '618',
                  'Y', 
                  'N',
                  503) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3549)
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
      VALUES     (3549,
				 'CLAIMSTATUSCODES', 
                  'PPS-Capital Exception Amount', 
                  '619',
                  'Y', 
                  'N',
                  504) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3550)
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
      VALUES     (3550,
				 'CLAIMSTATUSCODES', 
                  'PPS-Capital FSP DRG Amount', 
                  '620',
                  'Y', 
                  'N',
                  505) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3551)
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
      VALUES     (3551,
				 'CLAIMSTATUSCODES', 
                  'PPS-Capital HSP DRG Amount', 
                  '621',
                  'Y', 
                  'N',
                  506) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3552)
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
      VALUES     (3552,
				 'CLAIMSTATUSCODES', 
                  'PPS-Capital IME Amount', 
                  '622',
                  'Y', 
                  'N',
                  507) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3553)
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
      VALUES     (3553,
				 'CLAIMSTATUSCODES', 
                  'PPS-Operating Federal Specific DRG Amount', 
                  '623',
                  'Y', 
                  'N',
                  508) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3554)
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
      VALUES     (3554,
				 'CLAIMSTATUSCODES', 
                  'PPS-Operating Hospital Specific DRG Amount', 
                  '624',
                  'Y', 
                  'N',
                  509) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3555)
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
      VALUES     (3555,
				 'CLAIMSTATUSCODES', 
                  'Predetermination of Benefits Identifier', 
                  '625',
                  'Y', 
                  'N',
                  510) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3556)
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
      VALUES     (3556,
				 'CLAIMSTATUSCODES', 
                  'Pregnancy Indicator', 
                  '626',
                  'Y', 
                  'N',
                  511) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3557)
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
      VALUES     (3557,
				 'CLAIMSTATUSCODES', 
                  'Pre-Tax Claim Amount', 
                  '627',
                  'Y', 
                  'N',
                  512) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3558)
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
      VALUES     (3558,
				 'CLAIMSTATUSCODES', 
                  'Pricing Methodology', 
                  '628',
                  'Y', 
                  'N',
                  513) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3559)
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
      VALUES     (3559,
				 'CLAIMSTATUSCODES', 
                  'Property Casualty Claim Number', 
                  '629',
                  'Y', 
                  'N',
                  514) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3560)
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
      VALUES     (3560,
				 'CLAIMSTATUSCODES', 
                  'Referring CLIA Number', 
                  '630',
                  'Y', 
                  'N',
                  515) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3561)
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
      VALUES     (3561,
				 'CLAIMSTATUSCODES', 
                  'Reimbursement Rate', 
                  '631',
                  'Y', 
                  'N',
                  516) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3562)
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
      VALUES     (3562,
				 'CLAIMSTATUSCODES', 
                  'Reject Reason Code', 
                  '632',
                  'Y', 
                  'N',
                  517) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3563)
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
      VALUES     (3563,
				 'CLAIMSTATUSCODES', 
                  'Related Causes Code (Accident, auto accident, employment)', 
                  '633',
                  'Y', 
                  'N',
                  518) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3564)
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
      VALUES     (3564,
				 'CLAIMSTATUSCODES', 
                  'Remark Code', 
                  '634',
                  'Y', 
                  'N',
                  519) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3565)
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
      VALUES     (3565,
				 'CLAIMSTATUSCODES', 
                  'Repriced Ambulatory Patient Group Code', 
                  '635',
                  'Y', 
                  'N',
                  520) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3566)
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
      VALUES     (3566,
				 'CLAIMSTATUSCODES', 
                  'Repriced Line Item Reference Number', 
                  '636',
                  'Y', 
                  'N',
                  521) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3567)
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
      VALUES     (3567,
				 'CLAIMSTATUSCODES', 
                  'Repriced Saving Amount', 
                  '637',
                  'Y', 
                  'N',
                  522) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3568)
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
      VALUES     (3568,
				 'CLAIMSTATUSCODES', 
                  'Repricing Per Diem or Flat Rate Amount', 
                  '638',
                  'Y', 
                  'N',
                  523) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3569)
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
      VALUES     (3569,
				 'CLAIMSTATUSCODES', 
                  'Responsibility Amount', 
                  '639',
                  'Y', 
                  'N',
                  524) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3570)
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
      VALUES     (3570,
				 'CLAIMSTATUSCODES', 
                  'Sales Tax Amount', 
                  '640',
                  'Y', 
                  'N',
                  525) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3571)
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
      VALUES     (3571,
				 'CLAIMSTATUSCODES', 
                  'Service Authorization Exception Code', 
                  '642',
                  'Y', 
                  'N',
                  526) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3572)
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
      VALUES     (3572,
				 'CLAIMSTATUSCODES', 
                  'Service Line Paid Amount', 
                  '643',
                  'Y', 
                  'N',
                  527) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3573)
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
      VALUES     (3573,
				 'CLAIMSTATUSCODES', 
                  'Service Line Rate', 
                  '644',
                  'Y', 
                  'N',
                  528) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3574)
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
      VALUES     (3574,
				 'CLAIMSTATUSCODES', 
                  'Service Tax Amount', 
                  '645',
                  'Y', 
                  'N',
                  529) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3575)
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
      VALUES     (3575,
				 'CLAIMSTATUSCODES', 
                  'Ship, Delivery or Calendar Pattern Code', 
                  '646',
                  'Y', 
                  'N',
                  530) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3576)
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
      VALUES     (3576,
				 'CLAIMSTATUSCODES', 
                  'Shipped Date', 
                  '647',
                  'Y', 
                  'N',
                  531) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3577)
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
      VALUES     (3577,
				 'CLAIMSTATUSCODES', 
                  'Similar Illness or Symptom Date', 
                  '648',
                  'Y', 
                  'N',
                  532) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3578)
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
      VALUES     (3578,
				 'CLAIMSTATUSCODES', 
                  'Skilled Nursing Facility Indicator', 
                  '649',
                  'Y', 
                  'N',
                  533) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3579)
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
      VALUES     (3579,
				 'CLAIMSTATUSCODES', 
                  'Special Program Indicator', 
                  '650',
                  'Y', 
                  'N',
                  534) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3580)
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
      VALUES     (3580,
				 'CLAIMSTATUSCODES', 
                  'State Industrial Accident Provider Number', 
                  '651',
                  'Y', 
                  'N',
                  535) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3581)
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
      VALUES     (3581,
				 'CLAIMSTATUSCODES', 
                  'Terms Discount Percentage', 
                  '652',
                  'Y', 
                  'N',
                  536) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3582)
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
      VALUES     (3582,
				 'CLAIMSTATUSCODES', 
                  'Test Performed Date', 
                  '653',
                  'Y', 
                  'N',
                  537) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3583)
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
      VALUES     (3583,
				 'CLAIMSTATUSCODES', 
                  'Total Denied Charge Amount', 
                  '654',
                  'Y', 
                  'N',
                  538) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3584)
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
      VALUES     (3584,
				 'CLAIMSTATUSCODES', 
                  'Total Medicare Paid Amount', 
                  '655',
                  'Y', 
                  'N',
                  539) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3585)
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
      VALUES     (3585,
				 'CLAIMSTATUSCODES', 
                  'Total Visits Projected This Certification Count', 
                  '656',
                  'Y', 
                  'N',
                  540) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3586)
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
      VALUES     (3586,
				 'CLAIMSTATUSCODES', 
                  'Total Visits Rendered Count', 
                  '657',
                  'Y', 
                  'N',
                  541) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3587)
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
      VALUES     (3587,
				 'CLAIMSTATUSCODES', 
                  'Treatment Code', 
                  '658',
                  'Y', 
                  'N',
                  542) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3588)
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
      VALUES     (3588,
				 'CLAIMSTATUSCODES', 
                  'Unit or Basis for Measurement Code', 
                  '659',
                  'Y', 
                  'N',
                  543) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3589)
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
      VALUES     (3589,
				 'CLAIMSTATUSCODES', 
                  'Universal Product Number', 
                  '660',
                  'Y', 
                  'N',
                  544) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3590)
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
      VALUES     (3590,
				 'CLAIMSTATUSCODES', 
                  'Visits Prior to Recertification Date Count CR702', 
                  '661',
                  'Y', 
                  'N',
                  545) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3591)
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
      VALUES     (3591,
				 'CLAIMSTATUSCODES', 
                  'X-ray Availability Indicator', 
                  '662',
                  'Y', 
                  'N',
                  546) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3592)
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
      VALUES     (3592,
				 'CLAIMSTATUSCODES', 
                  'Entity''s Group Name. Note: This code requires use of an Entity Code.', 
                  '663',
                  'Y', 
                  'N',
                  547) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3593)
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
      VALUES     (3593,
				 'CLAIMSTATUSCODES', 
                  'Orthodontic Banding Date', 
                  '664',
                  'Y', 
                  'N',
                  548) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3594)
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
      VALUES     (3594,
				 'CLAIMSTATUSCODES', 
                  'Surgery Date', 
                  '665',
                  'Y', 
                  'N',
                  549) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3595)
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
      VALUES     (3595,
				 'CLAIMSTATUSCODES', 
                  'Surgical Procedure Code', 
                  '666',
                  'Y', 
                  'N',
                  550) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3596)
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
      VALUES     (3596,
				 'CLAIMSTATUSCODES', 
                  'Real-Time requests not supported by the information holder, do not resubmit', 
                  '667',
                  'Y', 
                  'N',
                  551) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3597)
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
      VALUES     (3597,
				 'CLAIMSTATUSCODES', 
                  'Missing Endodontics treatment history and prognosis', 
                  '668',
                  'Y', 
                  'N',
                  552) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3598)
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
      VALUES     (3598,
				 'CLAIMSTATUSCODES', 
                  'Dental service narrative needed.', 
                  '669',
                  'Y', 
                  'N',
                  553) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END

/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3599)
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
      VALUES     (3599,
				 'CLAIMSTATUSCODES', 
                  'Funds applied from a consumer spending account such as consumer directed/driven health plan (CDHP), Health savings account (H S A) and or other similar accounts', 
                  '670',
                  'Y', 
                  'N',
                  554) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3600)
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
      VALUES     (3600,
				 'CLAIMSTATUSCODES', 
                  'Funds may be available from a consumer spending account such as consumer directed/driven health plan (CDHP), Health savings account (H S A) and or other similar accounts', 
                  '671',
                  'Y', 
                  'N',
                  555) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3601)
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
      VALUES     (3601,
				 'CLAIMSTATUSCODES', 
                  'Other Payer''s payment information is out of balance', 
                  '672',
                  'Y', 
                  'N',
                  556) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3602)
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
      VALUES     (3602,
				 'CLAIMSTATUSCODES', 
                  'Patient Reason for Visit', 
                  '673',
                  'Y', 
                  'N',
                  557) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END

/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3603)
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
      VALUES     (3603,
				 'CLAIMSTATUSCODES', 
                  'Authorization exceeded', 
                  '674',
                  'Y', 
                  'N',
                  558) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END

/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3604)
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
      VALUES     (3604,
				 'CLAIMSTATUSCODES', 
                  'Facility admission through discharge dates', 
                  '675',
                  'Y', 
                  'N',
                  559) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3605)
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
      VALUES     (3605,
				 'CLAIMSTATUSCODES', 
                  'Entity possibly compensated by facility. Note: This code requires use of an Entity Code.', 
                  '676',
                  'Y', 
                  'N',
                  560) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3606)
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
      VALUES     (3606,
				 'CLAIMSTATUSCODES', 
                  'Entity not affiliated. Note: This code requires use of an Entity Code.', 
                  '677',
                  'Y', 
                  'N',
                  561) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3607)
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
      VALUES     (3607,
				 'CLAIMSTATUSCODES', 
                  'Revenue code and patient gender mismatch', 
                  '678',
                  'Y', 
                  'N',
                  562) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */

IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3608)
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
      VALUES     (3608,
				 'CLAIMSTATUSCODES', 
                  'Submit newborn services on mother''s claim', 
                  '679',
                  'Y', 
                  'N',
                  563) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END

/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3609)
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
      VALUES     (3609,
				 'CLAIMSTATUSCODES', 
                  'Entity''s Country. Note: This code requires use of an Entity Code.', 
                  '680',
                  'Y', 
                  'N',
                  564) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3610)
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
      VALUES     (3610,
				 'CLAIMSTATUSCODES', 
                  'Claim currency not supported', 
                  '681',
                  'Y', 
                  'N',
                  565) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3611)
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
      VALUES     (3611,
				 'CLAIMSTATUSCODES', 
                  'Cosmetic procedure', 
                  '682',
                  'Y', 
                  'N',
                  566) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3612)
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
      VALUES     (3612,
				 'CLAIMSTATUSCODES', 
                  'Awaiting Associated Hospital Claims', 
                  '683',
                  'Y', 
                  'N',
                  567) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
--IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3613)
--BEGIN
--  SET IDENTITY_INSERT GlobalCodes ON
--      INSERT INTO GlobalCodes 
--                  (GlobalcodeId,
--                   Category, 
--                   CodeName, 
--                   ExternalCode1,
--                   Active, 
--                   CannotModifyNameOrDelete,
--                   SortOrder) 
--      VALUES     (3613,
--				 'CLAIMSTATUSCODES', 
--                  'Rejected.Syntax error noted for this claim/service/inquiry.See Functional or Implementation Acknowledgement for details.(Note:Only for use to reject claims or status requests in transactions that were accepted with errors on a 997 or 999 Acknowledgement.)', 
--                  '684',
--                  'Y', 
--                  'N',
--                  568) 
--    SET IDENTITY_INSERT GlobalCodes OFF    
--END

/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3614)
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
      VALUES     (3614,
				 'CLAIMSTATUSCODES', 
                  'Claim could not complete adjudication in real time. Claim will continue processing in a batch mode. Do not resubmit', 
                  '685',
                  'Y', 
                  'N',
                  569) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3615)
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
      VALUES     (3615,
				 'CLAIMSTATUSCODES', 
                  'The claim/ encounter has completed the adjudication cycle and the entire claim has been voided', 
                  '686',
                  'Y', 
                  'N',
                  570) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3616)
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
      VALUES     (3616,
				 'CLAIMSTATUSCODES', 
                  'Claim estimation can not be completed in real time. Do not resubmit.', 
                  '687',
                  'Y', 
                  'N',
                  571) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3617)
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
      VALUES     (3617,
				 'CLAIMSTATUSCODES', 
                  'Present on Admission Indicator for reported diagnosis code(s).', 
                  '688',
                  'Y', 
                  'N',
                  572) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3618)
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
      VALUES     (3618,
				 'CLAIMSTATUSCODES', 
                  'Entity was unable to respond within the expected time frame. Note: This code requires use of an Entity Code.', 
                  '689',
                  'Y', 
                  'N',
                  573) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3619)
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
      VALUES     (3619,
				 'CLAIMSTATUSCODES', 
                  'Multiple claims or estimate requests cannot be processed in real time.', 
                  '690',
                  'Y', 
                  'N',
                  574) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3620)
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
      VALUES     (3620,
				 'CLAIMSTATUSCODES', 
                  'Multiple claim status requests cannot be processed in real time.', 
                  '691',
                  'Y', 
                  'N',
                  575) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3621)
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
      VALUES     (3621,
				 'CLAIMSTATUSCODES', 
                  'Contracted funding agreement-Subscriber is employed by the provider of services', 
                  '692',
                  'Y', 
                  'N',
                  576) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END

/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3622)
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
      VALUES     (3622,
				 'CLAIMSTATUSCODES', 
                  'Amount must be greater than or equal to zero. Note: At least one other status code is required to identify which amount element is in error.', 
                  '693',
                  'Y', 
                  'N',
                  577) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3623)
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
      VALUES     (3623,
				 'CLAIMSTATUSCODES', 
                  'Amount must not be equal to zero. Note: At least one other status code is required to identify which amount element is in error.', 
                  '694',
                  'Y', 
                  'N',
                  578) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3624)
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
      VALUES     (3624,
				 'CLAIMSTATUSCODES', 
                  'Entity''s Country Subdivision Code. Note: This code requires use of an Entity Code.', 
                  '695',
                  'Y', 
                  'N',
                  579) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3625)
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
      VALUES     (3625,
				 'CLAIMSTATUSCODES', 
                  'Claim Adjustment Group Code.', 
                  '696',
                  'Y', 
                  'N',
                  580) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3626)
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
      VALUES     (3626,
				 'CLAIMSTATUSCODES', 
                  'Invalid Decimal Precision. Note: At least one other status code is required to identify the data element in error.', 
                  '697',
                  'Y', 
                  'N',
                  581) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3627)
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
      VALUES     (3627,
				 'CLAIMSTATUSCODES', 
                  'Form Type Identification', 
                  '698',
                  'Y', 
                  'N',
                  582) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3628)
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
      VALUES     (3628,
				 'CLAIMSTATUSCODES', 
                  'Question/Response from Supporting Documentation Form', 
                  '699',
                  'Y', 
                  'N',
                  583) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */

IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3629)
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
      VALUES     (3629,
				 'CLAIMSTATUSCODES', 
                  'ICD10. Note: At least one other status code is required to identify the related procedure code or diagnosis code.', 
                  '700',
                  'Y', 
                  'N',
                  584) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3630)
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
      VALUES     (3630,
				 'CLAIMSTATUSCODES', 
                  'Initial Treatment Date', 
                  '701',
                  'Y', 
                  'N',
                  585) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3631)
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
      VALUES     (3631,
				 'CLAIMSTATUSCODES', 
                  'Repriced Claim Reference Number', 
                  '702',
                  'Y', 
                  'N',
                  586) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3632)
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
      VALUES     (3632,
				 'CLAIMSTATUSCODES', 
                  'Advanced Billing Concepts (ABC) code', 
                  '703',
                  'Y', 
                  'N',
                  587) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3633)
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
      VALUES     (3633,
				 'CLAIMSTATUSCODES', 
                  'Claim Note Text', 
                  '704',
                  'Y', 
                  'N',
                  588) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3634)
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
      VALUES     (3634,
				 'CLAIMSTATUSCODES', 
                  'Repriced Allowed Amount', 
                  '705',
                  'Y', 
                  'N',
                  589) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3635)
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
      VALUES     (3635,
				 'CLAIMSTATUSCODES', 
                  'Repriced Approved Amount', 
                  '706',
                  'Y', 
                  'N',
                  590) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3636)
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
      VALUES     (3636,
				 'CLAIMSTATUSCODES', 
                  'Repriced Approved Ambulatory Patient Group Amount', 
                  '707',
                  'Y', 
                  'N',
                  591) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3637)
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
      VALUES     (3637,
				 'CLAIMSTATUSCODES', 
                  'Repriced Approved Revenue Code', 
                  '708',
                  'Y', 
                  'N',
                  592) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3638)
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
      VALUES     (3638,
				 'CLAIMSTATUSCODES', 
                  'Repriced Approved Service Unit Count', 
                  '709',
                  'Y', 
                  'N',
                  593) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3639)
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
      VALUES     (3639,
				 'CLAIMSTATUSCODES', 
                  'Line Adjudication Information. Note: At least one other status code is required to identify the data element in error.', 
                  '710',
                  'Y', 
                  'N',
                  594) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3640)
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
      VALUES     (3640,
				 'CLAIMSTATUSCODES', 
                  'Stretcher purpose', 
                  '711',
                  'Y', 
                  'N',
                  595) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3641)
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
      VALUES     (3641,
				 'CLAIMSTATUSCODES', 
                  'Obstetric Additional Units', 
                  '712',
                  'Y', 
                  'N',
                  596) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3642)
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
      VALUES     (3642,
				 'CLAIMSTATUSCODES', 
                  'Patient Condition Description', 
                  '713',
                  'Y', 
                  'N',
                  597) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3643)
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
      VALUES     (3643,
				 'CLAIMSTATUSCODES', 
                  'Care Plan Oversight Number', 
                  '714',
                  'Y', 
                  'N',
                  598) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3644)
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
      VALUES     (3644,
				 'CLAIMSTATUSCODES', 
                  'Acute Manifestation Date', 
                  '715',
                  'Y', 
                  'N',
                  599) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3645)
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
      VALUES     (3645,
				 'CLAIMSTATUSCODES', 
                  'Repriced Approved DRG Code', 
                  '716',
                  'Y', 
                  'N',
                  600) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3646)
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
      VALUES     (3646,
				 'CLAIMSTATUSCODES', 
                  'This claim has been split for processing.', 
                  '717',
                  'Y', 
                  'N',
                  601) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END

/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3647)
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
      VALUES     (3647,
				 'CLAIMSTATUSCODES', 
                  'Claim/service not submitted within the required timeframe (timely filing).', 
                  '718',
                  'Y', 
                  'N',
                  602) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3648)
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
      VALUES     (3648,
				 'CLAIMSTATUSCODES', 
                  'NUBC Occurrence Code(s)', 
                  '719',
                  'Y', 
                  'N',
                  603) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3649)
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
      VALUES     (3649,
				 'CLAIMSTATUSCODES', 
                  'NUBC Occurrence Code Date(s)', 
                  '720',
                  'Y', 
                  'N',
                  604) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3650)
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
      VALUES     (3650,
				 'CLAIMSTATUSCODES', 
                  'NUBC Occurrence Span Code(s)', 
                  '721',
                  'Y', 
                  'N',
                  605) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3651)
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
      VALUES     (3651,
				 'CLAIMSTATUSCODES', 
                  'NUBC Occurrence Span Code Date(s)', 
                  '722',
                  'Y', 
                  'N',
                  606) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3652)
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
      VALUES     (3652,
				 'CLAIMSTATUSCODES', 
                  'Drug days supply', 
                  '723',
                  'Y', 
                  'N',
                  607) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3653)
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
      VALUES     (3653,
				 'CLAIMSTATUSCODES', 
                  'Drug dosage', 
                  '724',
                  'Y', 
                  'N',
                  608) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3654)
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
      VALUES     (3654,
				 'CLAIMSTATUSCODES', 
                  'NUBC Value Code(s)', 
                  '725',
                  'Y', 
                  'N',
                  609) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3655)
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
      VALUES     (3655,
				 'CLAIMSTATUSCODES', 
                  'NUBC Value Code Amount(s)', 
                  '726',
                  'Y', 
                  'N',
                  610) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3656)
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
      VALUES     (3656,
				 'CLAIMSTATUSCODES', 
                  'Accident date', 
                  '727',
                  'Y', 
                  'N',
                  611) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3657)
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
      VALUES     (3657,
				 'CLAIMSTATUSCODES', 
                  'Accident state', 
                  '728',
                  'Y', 
                  'N',
                  612) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3658)
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
      VALUES     (3658,
				 'CLAIMSTATUSCODES', 
                  'Accident description', 
                  '729',
                  'Y', 
                  'N',
                  613) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3659)
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
      VALUES     (3659,
				 'CLAIMSTATUSCODES', 
                  'Accident cause', 
                  '730',
                  'Y', 
                  'N',
                  614) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3660)
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
      VALUES     (3660,
				 'CLAIMSTATUSCODES', 
                  'Measurement value/test result', 
                  '731',
                  'Y', 
                  'N',
                  615) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3661)
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
      VALUES     (3661,
				 'CLAIMSTATUSCODES', 
                  'Information submitted inconsistent with billing guidelines. Note: At least one other status code is required to identify the inconsistent information.', 
                  '732',
                  'Y', 
                  'N',
                  616) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3662)
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
      VALUES     (3662,
				 'CLAIMSTATUSCODES', 
                  'Prefix for entity''s contract/member number.', 
                  '733',
                  'Y', 
                  'N',
                  617) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3663)
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
      VALUES     (3663,
				 'CLAIMSTATUSCODES', 
                  'Verifying premium payment', 
                  '734',
                  'Y', 
                  'N',
                  618) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3664)
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
      VALUES     (3664,
				 'CLAIMSTATUSCODES', 
                  'This service/claim is included in the allowance for another service or claim.', 
                  '735',
                  'Y', 
                  'N',
                  619) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3665)
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
      VALUES     (3665,
				 'CLAIMSTATUSCODES', 
                  'A related or qualifying service/claim has not been received/adjudicated.', 
                  '736',
                  'Y', 
                  'N',
                  620) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3666)
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
      VALUES     (3666,
				 'CLAIMSTATUSCODES', 
                  'Current Dental Terminology (CDT) Code', 
                  '737',
                  'Y', 
                  'N',
                  621) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3667)
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
      VALUES     (3667,
				 'CLAIMSTATUSCODES', 
                  'Home Infusion EDI Coalition (HEIC) Product/Service Code', 
                  '738',
                  'Y', 
                  'N',
                  622) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3668)
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
      VALUES     (3668,
				 'CLAIMSTATUSCODES', 
                  'Jurisdiction Specific Procedure or Supply Code', 
                  '739',
                  'Y', 
                  'N',
                  623) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3669)
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
      VALUES     (3669,
				 'CLAIMSTATUSCODES', 
                  'Drop-Off Location', 
                  '740',
                  'Y', 
                  'N',
                  624) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3670)
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
      VALUES     (3670,
				 'CLAIMSTATUSCODES', 
                  'Entity must be a person. Note: This code requires use of an Entity Code.', 
                  '741',
                  'Y', 
                  'N',
                  625) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3671)
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
      VALUES     (3671,
				 'CLAIMSTATUSCODES', 
                  'Payer Responsibility Sequence Number Code', 
                  '742',
                  'Y', 
                  'N',
                  626) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3672)
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
      VALUES     (3672,
				 'CLAIMSTATUSCODES', 
                  'Entity’s credential/enrollment information. Note: This code requires use of an Entity Code.', 
                  '743',
                  'Y', 
                  'N',
                  627) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3673)
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
      VALUES     (3673,
				 'CLAIMSTATUSCODES', 
                  'Services/charges related to the treatment of a hospital-acquired condition or preventable medical error.', 
                  '744',
                  'Y', 
                  'N',
                  628) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3674)
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
      VALUES     (3674,
				 'CLAIMSTATUSCODES', 
                  'Identifier Qualifier Note: At least one other status code is required to identify the specific identifier qualifier in error.', 
                  '745',
                  'Y', 
                  'N',
                  629) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3675)
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
      VALUES     (3675,
				 'CLAIMSTATUSCODES', 
                  'Duplicate Submission Note: use only at the information receiver level in the Health Care Claim Acknowledgement transaction.', 
                  '746',
                  'Y', 
                  'N',
                  630) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3676)
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
      VALUES     (3676,
				 'CLAIMSTATUSCODES', 
                  'Hospice Employee Indicator', 
                  '747',
                  'Y', 
                  'N',
                  631) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3677)
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
      VALUES     (3677,
				 'CLAIMSTATUSCODES', 
                  'Corrected Data Note: Requires a second status code to identify the corrected data.', 
                  '748',
                  'Y', 
                  'N',
                  632) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3678)
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
      VALUES     (3678,
				 'CLAIMSTATUSCODES', 
                  'Date of Injury/Illness', 
                  '749',
                  'Y', 
                  'N',
                  633) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3679)
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
      VALUES     (3679,
				 'CLAIMSTATUSCODES', 
                  'Auto Accident State or Province Code', 
                  '750',
                  'Y', 
                  'N',
                  634) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3680)
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
      VALUES     (3680,
				 'CLAIMSTATUSCODES', 
                  'Ambulance Pick-up State or Province Code', 
                  '751',
                  'Y', 
                  'N',
                  635) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3681)
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
      VALUES     (3681,
				 'CLAIMSTATUSCODES', 
                  'Ambulance Drop-off State or Province Code', 
                  '752',
                  'Y', 
                  'N',
                  636) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3682)
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
      VALUES     (3682,
				 'CLAIMSTATUSCODES', 
                  'Co-pay status code.', 
                  '753',
                  'Y', 
                  'N',
                  637) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3683)
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
      VALUES     (3683,
				 'CLAIMSTATUSCODES', 
                  'Entity Name Suffix. Note: This code requires the use of an Entity Code.', 
                  '754',
                  'Y', 
                  'N',
                  638) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3684)
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
      VALUES     (3684,
				 'CLAIMSTATUSCODES', 
                  'Entity''s primary identifier. Note: This code requires the use of an Entity Code.', 
                  '755',
                  'Y', 
                  'N',
                  639) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3685)
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
      VALUES     (3685,
				 'CLAIMSTATUSCODES', 
                  'Entity''s Received Date. Note: This code requires the use of an Entity Code.', 
                  '756',
                  'Y', 
                  'N',
                  640) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3686)
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
      VALUES     (3686,
				 'CLAIMSTATUSCODES', 
                  'Last seen date.', 
                  '757',
                  'Y', 
                  'N',
                  641) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3687)
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
      VALUES     (3687,
				 'CLAIMSTATUSCODES', 
                  'Repriced approved HCPCS code.', 
                  '758',
                  'Y', 
                  'N',
                  642) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3688)
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
      VALUES     (3688,
				 'CLAIMSTATUSCODES', 
                  'Round trip purpose description.', 
                  '759',
                  'Y', 
                  'N',
                  643) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3689)
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
      VALUES     (3689,
				 'CLAIMSTATUSCODES', 
                  'Tooth status code.', 
                  '760',
                  'Y', 
                  'N',
                  644) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3690)
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
      VALUES     (3690,
				 'CLAIMSTATUSCODES', 
                  'Entity''s referral number. Note: This code requires the use of an Entity Code.', 
                  '761',
                  'Y', 
                  'N',
                  645) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3691)
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
      VALUES     (3691,
				 'CLAIMSTATUSCODES', 
                  'Locum Tenens Provider Identifier. Code must be used with Entity Code 82 - Rendering Provider', 
                  '762',
                  'Y', 
                  'N',
                  646) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3692)
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
      VALUES     (3692,
				 'CLAIMSTATUSCODES', 
                  'Ambulance Pickup ZipCode', 
                  '763',
                  'Y', 
                  'N',
                  647) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3693)
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
      VALUES     (3693,
				 'CLAIMSTATUSCODES', 
                  'Professional charges are non covered.', 
                  '764',
                  'Y', 
                  'N',
                  648) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3694)
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
      VALUES     (3694,
				 'CLAIMSTATUSCODES', 
                  'Institutional charges are non covered.', 
                  '765',
                  'Y', 
                  'N',
                  649) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3695)
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
      VALUES     (3695,
				 'CLAIMSTATUSCODES', 
                  'Services were performed during a Health Insurance Exchange (HIX) premium payment grace period.', 
                  '766',
                  'Y', 
                  'N',
                  650) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3696)
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
      VALUES     (3696,
				 'CLAIMSTATUSCODES', 
                  'Qualifications for emergent/urgent care', 
                  '767',
                  'Y', 
                  'N',
                  651) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3697)
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
      VALUES     (3697,
				 'CLAIMSTATUSCODES', 
                  'Service date outside the accidental injury coverage period.', 
                  '768',
                  'Y', 
                  'N',
                  652) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3698)
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
      VALUES     (3698,
				 'CLAIMSTATUSCODES', 
                  'DME Repair or Maintenance', 
                  '769',
                  'Y', 
                  'N',
                  653) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3699)
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
      VALUES     (3699,
				 'CLAIMSTATUSCODES', 
                  'Duplicate of a claim processed or in process as a crossover/coordination of benefits claim.', 
                  '770',
                  'Y', 
                  'N',
                  654) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END
/*Insert Into GlobalCodes */
IF NOT EXISTS (SELECT 1  FROM GlobalCodes  WHERE GlobalcodeId=3700)
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
      VALUES     (3700,
				 'CLAIMSTATUSCODES', 
                  'Claim submitted prematurely. Please resubmit after crossover/payer to payer COB allotted waiting period.', 
                  '771',
                  'Y', 
                  'N',
                  655) 
    SET IDENTITY_INSERT GlobalCodes OFF    
END

