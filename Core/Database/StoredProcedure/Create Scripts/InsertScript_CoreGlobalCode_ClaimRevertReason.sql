if not exists(select * from GlobalCodeCategories where Category = 'ClaimRevertReason')
  insert into GlobalCodeCategories (Category, CategoryName, Active, AllowAddDelete, AllowCodeNameEdit, AllowSortOrderEdit, UserDefinedCategory, HasSubCodes)
  select 'ClaimRevertReason', 'ClaimRevertReason', 'Y', 'N', 'N', 'Y', 'N', 'N'


  IF NOT EXISTS ( SELECT    GlobalCodeId
                  FROM      GlobalCodes
                  WHERE     GlobalCodeId = 3718
                            AND Category = 'ClaimRevertReason'
                            AND CodeName = 'INNOU-Incorrect number of Units' )
    BEGIN
        SET IDENTITY_INSERT GlobalCodes ON;
        INSERT  INTO GlobalCodes
                ( GlobalCodeId ,
                  Category ,
                  CodeName ,
				  Code,
                  [Description] ,
                  Active ,
                  CannotModifyNameOrDelete ,
                  SortOrder ,
                  ExternalCode1 ,
                  ExternalSource1 ,
                  ExternalCode2 ,
                  ExternalSource2 ,
                  Bitmap 
                )
        VALUES  ( 3718 ,
                  'ClaimRevertReason' ,
                  'INNOU-Incorrect number of Units' ,
				  'INNOU-Incorrect number of Units',
                  NULL ,
                  'Y' ,
                  'Y' ,
                  1 ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL 
                    ); 
        SET IDENTITY_INSERT GlobalCodes OFF;

    END;

	  IF NOT EXISTS ( SELECT    GlobalCodeId
                  FROM      GlobalCodes
                  WHERE     GlobalCodeId = 3719
                            AND Category = 'ClaimRevertReason'
                            AND CodeName = 'INBLD-Incorrect Billed Amount' )
    BEGIN
        SET IDENTITY_INSERT GlobalCodes ON;
        INSERT  INTO GlobalCodes
                ( GlobalCodeId ,
                  Category ,
                  CodeName ,
				  Code,
                  [Description] ,
                  Active ,
                  CannotModifyNameOrDelete ,
                  SortOrder ,
                  ExternalCode1 ,
                  ExternalSource1 ,
                  ExternalCode2 ,
                  ExternalSource2 ,
                  Bitmap 
                )
        VALUES  ( 3719 ,
                  'ClaimRevertReason' ,
                  'INBLD-Incorrect Billed Amount' ,
				  'INBLD-Incorrect Billed Amount',
                  NULL ,
                  'Y' ,
                  'Y' ,
                  2 ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL 
                    ); 
        SET IDENTITY_INSERT GlobalCodes OFF;

    END;
  IF NOT EXISTS ( SELECT    GlobalCodeId
                  FROM      GlobalCodes
                  WHERE     GlobalCodeId = 3720
                            AND Category = 'ClaimRevertReason'
                            AND CodeName = 'INCOB-Incorrect COB Amount' )
    BEGIN
        SET IDENTITY_INSERT GlobalCodes ON;
        INSERT  INTO GlobalCodes
                ( GlobalCodeId ,
                  Category ,
                  CodeName ,
				  Code,
                  [Description] ,
                  Active ,
                  CannotModifyNameOrDelete ,
                  SortOrder ,
                  ExternalCode1 ,
                  ExternalSource1 ,
                  ExternalCode2 ,
                  ExternalSource2 ,
                  Bitmap 
                )
        VALUES  ( 3720,
                  'ClaimRevertReason' ,
                  'INCOB-Incorrect COB Amount' ,
				  'INCOB-Incorrect COB Amount',
                  NULL ,
                  'Y' ,
                  'Y' ,
                  3 ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL 
                    ); 
        SET IDENTITY_INSERT GlobalCodes OFF;

    END;

  IF NOT EXISTS ( SELECT    GlobalCodeId
                  FROM      GlobalCodes
                  WHERE     GlobalCodeId = 3721
                            AND Category = 'ClaimRevertReason'
                            AND CodeName = 'INCOP-Incorrect Co-Pay Amount' )
    BEGIN
        SET IDENTITY_INSERT GlobalCodes ON;
        INSERT  INTO GlobalCodes
                ( GlobalCodeId ,
                  Category ,
                  CodeName ,
				  Code,
                  [Description] ,
                  Active ,
                  CannotModifyNameOrDelete ,
                  SortOrder ,
                  ExternalCode1 ,
                  ExternalSource1 ,
                  ExternalCode2 ,
                  ExternalSource2 ,
                  Bitmap 
                )
        VALUES  ( 3721,
                  'ClaimRevertReason' ,
                  'INCOP-Incorrect Co-Pay Amount' ,
				  'INCOP-Incorrect Co-Pay Amount',
                  NULL ,
                  'Y' ,
                  'Y' ,
                  4 ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL 
                    ); 
        SET IDENTITY_INSERT GlobalCodes OFF;

    END;


  IF NOT EXISTS ( SELECT    GlobalCodeId
                  FROM      GlobalCodes
                  WHERE     GlobalCodeId = 3722
                            AND Category = 'ClaimRevertReason'
                            AND CodeName = 'INCLT-Incorrect Client' )
    BEGIN
        SET IDENTITY_INSERT GlobalCodes ON;
        INSERT  INTO GlobalCodes
                ( GlobalCodeId ,
                  Category ,
                  CodeName ,
				  Code,
                  [Description] ,
                  Active ,
                  CannotModifyNameOrDelete ,
                  SortOrder ,
                  ExternalCode1 ,
                  ExternalSource1 ,
                  ExternalCode2 ,
                  ExternalSource2 ,
                  Bitmap 
                )
        VALUES  ( 3722,
                  'ClaimRevertReason' ,
                  'INCLT-Incorrect Client' ,
				  'INCLT-Incorrect Client',
                  NULL ,
                  'Y' ,
                  'Y' ,
                  5 ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL 
                    ); 
        SET IDENTITY_INSERT GlobalCodes OFF;

    END;


  IF NOT EXISTS ( SELECT    GlobalCodeId
                  FROM      GlobalCodes
                  WHERE     GlobalCodeId = 3723
                            AND Category = 'ClaimRevertReason'
                            AND CodeName = 'INPOS-Incorrect Place of Service' )
    BEGIN
        SET IDENTITY_INSERT GlobalCodes ON;
        INSERT  INTO GlobalCodes
                ( GlobalCodeId ,
                  Category ,
                  CodeName ,
				  Code,
                  [Description] ,
                  Active ,
                  CannotModifyNameOrDelete ,
                  SortOrder ,
                  ExternalCode1 ,
                  ExternalSource1 ,
                  ExternalCode2 ,
                  ExternalSource2 ,
                  Bitmap 
                )
        VALUES  ( 3723,
                  'ClaimRevertReason' ,
                  'INPOS-Incorrect Place of Service' ,
				  'INPOS-Incorrect Place of Service',
                  NULL ,
                  'Y' ,
                  'Y' ,
                  6 ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL 
                    ); 
        SET IDENTITY_INSERT GlobalCodes OFF;

    END;

  IF NOT EXISTS ( SELECT    GlobalCodeId
                  FROM      GlobalCodes
                  WHERE     GlobalCodeId = 3724
                            AND Category = 'ClaimRevertReason'
                            AND CodeName = 'INMOD-Incorrect Modifier(s)' )
    BEGIN
        SET IDENTITY_INSERT GlobalCodes ON;
        INSERT  INTO GlobalCodes
                ( GlobalCodeId ,
                  Category ,
                  CodeName ,
				  Code,
                  [Description] ,
                  Active ,
                  CannotModifyNameOrDelete ,
                  SortOrder ,
                  ExternalCode1 ,
                  ExternalSource1 ,
                  ExternalCode2 ,
                  ExternalSource2 ,
                  Bitmap 
                )
        VALUES  ( 3724,
                  'ClaimRevertReason' ,
                  'INMOD-Incorrect Modifier(s)' ,
				  'INMOD-Incorrect Modifier(s)',
                  NULL ,
                  'Y' ,
                  'Y' ,
                  7 ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL 
                    ); 
        SET IDENTITY_INSERT GlobalCodes OFF;

    END;

  IF NOT EXISTS ( SELECT    GlobalCodeId
                  FROM      GlobalCodes
                  WHERE     GlobalCodeId = 3725
                            AND Category = 'ClaimRevertReason'
                            AND CodeName = 'INREN-Incorrect Rendering NPI' )
    BEGIN
        SET IDENTITY_INSERT GlobalCodes ON;
        INSERT  INTO GlobalCodes
                ( GlobalCodeId ,
                  Category ,
                  CodeName ,
				  Code,
                  [Description] ,
                  Active ,
                  CannotModifyNameOrDelete ,
                  SortOrder ,
                  ExternalCode1 ,
                  ExternalSource1 ,
                  ExternalCode2 ,
                  ExternalSource2 ,
                  Bitmap 
                )
        VALUES  ( 3725,
                  'ClaimRevertReason' ,
                  'INREN-Incorrect Rendering NPI' ,
				  'INREN-Incorrect Rendering NPI',
                  NULL ,
                  'Y' ,
                  'Y' ,
                  8 ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL 
                    ); 
        SET IDENTITY_INSERT GlobalCodes OFF;

    END;

  IF NOT EXISTS ( SELECT    GlobalCodeId
                  FROM      GlobalCodes
                  WHERE     GlobalCodeId = 3726
                            AND Category = 'ClaimRevertReason'
                            AND CodeName = 'INSUP-Incorrect Supervisor NPI' )
    BEGIN
        SET IDENTITY_INSERT GlobalCodes ON;
        INSERT  INTO GlobalCodes
                ( GlobalCodeId ,
                  Category ,
                  CodeName ,
				  Code,
                  [Description] ,
                  Active ,
                  CannotModifyNameOrDelete ,
                  SortOrder ,
                  ExternalCode1 ,
                  ExternalSource1 ,
                  ExternalCode2 ,
                  ExternalSource2 ,
                  Bitmap 
                )
        VALUES  ( 3726,
                  'ClaimRevertReason' ,
                  'INSUP-Incorrect Supervisor NPI' ,
				  'INSUP-Incorrect Supervisor NPI',
                  NULL ,
                  'Y' ,
                  'Y' ,
                  9 ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL 
                    ); 
        SET IDENTITY_INSERT GlobalCodes OFF;

    END;

  IF NOT EXISTS ( SELECT    GlobalCodeId
                  FROM      GlobalCodes
                  WHERE     GlobalCodeId = 3727
                            AND Category = 'ClaimRevertReason'
                            AND CodeName = 'INNDC-Incorrect National Drug Code' )
    BEGIN
        SET IDENTITY_INSERT GlobalCodes ON;
        INSERT  INTO GlobalCodes
                ( GlobalCodeId ,
                  Category ,
                  CodeName ,
				  Code,
                  [Description] ,
                  Active ,
                  CannotModifyNameOrDelete ,
                  SortOrder ,
                  ExternalCode1 ,
                  ExternalSource1 ,
                  ExternalCode2 ,
                  ExternalSource2 ,
                  Bitmap 
                )
        VALUES  ( 3727,
                  'ClaimRevertReason' ,
                  'INNDC-Incorrect National Drug Code' ,
				  'INNDC-Incorrect National Drug Code',
                  NULL ,
                  'Y' ,
                  'Y' ,
                  10 ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL 
                    ); 
        SET IDENTITY_INSERT GlobalCodes OFF;

    END;
	  IF NOT EXISTS ( SELECT    GlobalCodeId
                  FROM      GlobalCodes
                  WHERE     GlobalCodeId = 3728
                            AND Category = 'ClaimRevertReason'
                            AND CodeName = 'INURT-Incorrect Unit Rate' )
    BEGIN
        SET IDENTITY_INSERT GlobalCodes ON;
        INSERT  INTO GlobalCodes
                ( GlobalCodeId ,
                  Category ,
                  CodeName ,
				  Code,
                  [Description] ,
                  Active ,
                  CannotModifyNameOrDelete ,
                  SortOrder ,
                  ExternalCode1 ,
                  ExternalSource1 ,
                  ExternalCode2 ,
                  ExternalSource2 ,
                  Bitmap 
                )
        VALUES  ( 3728,
                  'ClaimRevertReason' ,
                  'INURT-Incorrect Unit Rate' ,
				  'INURT-Incorrect Unit Rate',
                  NULL ,
                  'Y' ,
                  'Y' ,
                  11 ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL 
                    ); 
        SET IDENTITY_INSERT GlobalCodes OFF;

    END;
  IF NOT EXISTS ( SELECT    GlobalCodeId
                  FROM      GlobalCodes
                  WHERE     GlobalCodeId = 3729
                            AND Category = 'ClaimRevertReason'
                            AND CodeName = 'RTMCD-Retroactive Medicaid' )
    BEGIN
        SET IDENTITY_INSERT GlobalCodes ON;
        INSERT  INTO GlobalCodes
                ( GlobalCodeId ,
                  Category ,
                  CodeName ,
				  Code,
                  [Description] ,
                  Active ,
                  CannotModifyNameOrDelete ,
                  SortOrder ,
                  ExternalCode1 ,
                  ExternalSource1 ,
                  ExternalCode2 ,
                  ExternalSource2 ,
                  Bitmap 
                )
        VALUES  ( 3729,
                  'ClaimRevertReason' ,
                  'RTMCD-Retroactive Medicaid' ,
				  'RTMCD-Retroactive Medicaid',
                  NULL ,
                  'Y' ,
                  'Y' ,
                  12 ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL 
                    ); 
        SET IDENTITY_INSERT GlobalCodes OFF;

    END;

 IF NOT EXISTS ( SELECT    GlobalCodeId
                  FROM      GlobalCodes
                  WHERE     GlobalCodeId = 3730
                            AND Category = 'ClaimRevertReason'
                            AND CodeName = 'BLINE-Billing Ineligible' )
    BEGIN
        SET IDENTITY_INSERT GlobalCodes ON;
        INSERT  INTO GlobalCodes
                ( GlobalCodeId ,
                  Category ,
                  CodeName ,
				  Code,
                  [Description] ,
                  Active ,
                  CannotModifyNameOrDelete ,
                  SortOrder ,
                  ExternalCode1 ,
                  ExternalSource1 ,
                  ExternalCode2 ,
                  ExternalSource2 ,
                  Bitmap 
                )
        VALUES  ( 3730,
                  'ClaimRevertReason' ,
                  'BLINE-Billing Ineligible' ,
				  'BLINE-Billing Ineligible',
                  NULL ,
                  'Y' ,
                  'Y' ,
                  13 ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL 
                    ); 
        SET IDENTITY_INSERT GlobalCodes OFF;

    END;
 IF NOT EXISTS ( SELECT    GlobalCodeId
                  FROM      GlobalCodes
                  WHERE     GlobalCodeId = 3731
                            AND Category = 'ClaimRevertReason'
                            AND CodeName = 'INDIA-Incorrect Diagnosis' )
    BEGIN
        SET IDENTITY_INSERT GlobalCodes ON;
        INSERT  INTO GlobalCodes
                ( GlobalCodeId ,
                  Category ,
                  CodeName ,
				  Code,
                  [Description] ,
                  Active ,
                  CannotModifyNameOrDelete ,
                  SortOrder ,
                  ExternalCode1 ,
                  ExternalSource1 ,
                  ExternalCode2 ,
                  ExternalSource2 ,
                  Bitmap 
                )
        VALUES  ( 3731,
                  'ClaimRevertReason' ,
                  'INDIA-Incorrect Diagnosis' ,
				  'INDIA-Incorrect Diagnosis',
                  NULL ,
                  'Y' ,
                  'Y' ,
                  14 ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL 
                    ); 
        SET IDENTITY_INSERT GlobalCodes OFF;

    END;
IF NOT EXISTS ( SELECT    GlobalCodeId
                  FROM      GlobalCodes
                  WHERE     GlobalCodeId = 3732
                            AND Category = 'ClaimRevertReason'
                            AND CodeName = 'RTRTC-Retroactive Rate Change' )
    BEGIN
        SET IDENTITY_INSERT GlobalCodes ON;
        INSERT  INTO GlobalCodes
                ( GlobalCodeId ,
                  Category ,
                  CodeName ,
				  Code,
                  [Description] ,
                  Active ,
                  CannotModifyNameOrDelete ,
                  SortOrder ,
                  ExternalCode1 ,
                  ExternalSource1 ,
                  ExternalCode2 ,
                  ExternalSource2 ,
                  Bitmap 
                )
        VALUES  ( 3732,
                  'ClaimRevertReason' ,
                  'RTRTC-Retroactive Rate Change' ,
				  'RTRTC-Retroactive Rate Change',
                  NULL ,
                  'Y' ,
                  'Y' ,
                  15 ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL 
                    ); 
        SET IDENTITY_INSERT GlobalCodes OFF;

    END;
IF NOT EXISTS ( SELECT    GlobalCodeId
                  FROM      GlobalCodes
                  WHERE     GlobalCodeId = 3733
                            AND Category = 'ClaimRevertReason'
                            AND CodeName = 'CTRTE-Contract/Rate Error' )
    BEGIN
        SET IDENTITY_INSERT GlobalCodes ON;
        INSERT  INTO GlobalCodes
                ( GlobalCodeId ,
                  Category ,
                  CodeName ,
				  Code,
                  [Description] ,
                  Active ,
                  CannotModifyNameOrDelete ,
                  SortOrder ,
                  ExternalCode1 ,
                  ExternalSource1 ,
                  ExternalCode2 ,
                  ExternalSource2 ,
                  Bitmap 
                )
        VALUES  ( 3733,
                  'ClaimRevertReason' ,
                  'CTRTE-Contract/Rate Error' ,
				  'CTRTE-Contract/Rate Error',
                  NULL ,
                  'Y' ,
                  'Y' ,
                  16 ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL 
                    ); 
        SET IDENTITY_INSERT GlobalCodes OFF;

    END;
IF NOT EXISTS ( SELECT    GlobalCodeId
                  FROM      GlobalCodes
                  WHERE     GlobalCodeId = 3734
                            AND Category = 'ClaimRevertReason'
                            AND CodeName = 'PROVE-Provider Error' )
    BEGIN
        SET IDENTITY_INSERT GlobalCodes ON;
        INSERT  INTO GlobalCodes
                ( GlobalCodeId ,
                  Category ,
                  CodeName ,
				  Code,
                  [Description] ,
                  Active ,
                  CannotModifyNameOrDelete ,
                  SortOrder ,
                  ExternalCode1 ,
                  ExternalSource1 ,
                  ExternalCode2 ,
                  ExternalSource2 ,
                  Bitmap 
                )
        VALUES  ( 3734,
                  'ClaimRevertReason' ,
                  'PROVE-Provider Error' ,
				  'PROVE-Provider Error',
                  NULL ,
                  'Y' ,
                  'Y' ,
                  17 ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL 
                    ); 
        SET IDENTITY_INSERT GlobalCodes OFF;

    END;
IF NOT EXISTS ( SELECT    GlobalCodeId
                  FROM      GlobalCodes
                  WHERE     GlobalCodeId = 3735
                            AND Category = 'ClaimRevertReason'
                            AND CodeName = 'INSUE-Insurer Error' )
    BEGIN
        SET IDENTITY_INSERT GlobalCodes ON;
        INSERT  INTO GlobalCodes
                ( GlobalCodeId ,
                  Category ,
                  CodeName ,
				  Code,
                  [Description] ,
                  Active ,
                  CannotModifyNameOrDelete ,
                  SortOrder ,
                  ExternalCode1 ,
                  ExternalSource1 ,
                  ExternalCode2 ,
                  ExternalSource2 ,
                  Bitmap 
                )
        VALUES  ( 3735,
                  'ClaimRevertReason' ,
                  'INSUE-Insurer Error' ,
				  'INSUE-Insurer Error',
                  NULL ,
                  'Y' ,
                  'Y' ,
                  18 ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL 
                    ); 
        SET IDENTITY_INSERT GlobalCodes OFF;

    END;
IF NOT EXISTS ( SELECT    GlobalCodeId
                  FROM      GlobalCodes
                  WHERE     GlobalCodeId = 3736
                            AND Category = 'ClaimRevertReason'
                            AND CodeName = 'INSVC-Incorrect Service' )
    BEGIN
        SET IDENTITY_INSERT GlobalCodes ON;
        INSERT  INTO GlobalCodes
                ( GlobalCodeId ,
                  Category ,
                  CodeName ,
				  Code,
                  [Description] ,
                  Active ,
                  CannotModifyNameOrDelete ,
                  SortOrder ,
                  ExternalCode1 ,
                  ExternalSource1 ,
                  ExternalCode2 ,
                  ExternalSource2 ,
                  Bitmap 
                )
        VALUES  ( 3736,
                  'ClaimRevertReason' ,
                  'INSVC-Incorrect Service' ,
				  'INSVC-Incorrect Service',
                  NULL ,
                  'Y' ,
                  'Y' ,
                  19 ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL ,
                  NULL 
                    ); 
        SET IDENTITY_INSERT GlobalCodes OFF;

    END;

