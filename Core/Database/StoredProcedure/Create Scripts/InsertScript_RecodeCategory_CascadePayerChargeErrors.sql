---Create Core Recode Category For Charge Errors that Transfer Down
DECLARE @RecodeCategoryId INT

INSERT INTO dbo.RecodeCategories
        ( 
          CategoryCode ,
          CategoryName ,
          Description ,
          MappingEntity ,
          RecodeType ,
          RangeType
        )
	   SELECT 'CascadePayerChargeErrors',
			'CascadePayerChargeErrors',
			'Charges Errors that cause a service to be cascaded to the next payer.',
			'GlobalCodes.GlobalCodeId',
			8401,
			8410
			WHERE NOT EXISTS( SELECT 1
						   FROM dbo.RecodeCategories AS rc
						   WHERE rc.CategoryCode = 'CascadePayerChargeErrors'
						   AND ISNULL(rc.RecordDeleted,'N')='N'
						 )
SET @RecodeCategoryId = SCOPE_IDENTITY()

IF @RecodeCategoryId IS NOT NULL
BEGIN

--Create Code Recodes
INSERT INTO dbo.Recodes
        ( 
          IntegerCodeId ,
          CodeName ,
          FromDate ,
          RecodeCategoryId 
        )
SELECT 
4554,
LEFT('No charge for this code if a previous plan has denied the charge',100),
'1/1/2000',
@RecodeCategoryId
UNION ALL
SELECT 
4546,
LEFT('Plan will not pay for this procedure',100),
'1/1/2000',
@RecodeCategoryId
UNION all
SELECT 
4549,
LEFT('Clinician is not authorized to provide services to plan - Verify that not currently affecting services',100),
'1/1/2000',
@RecodeCategoryId
UNION ALL
SELECT 
4558,
LEFT('Monthly deductible met after service date',100),
'1/1/2000',
@RecodeCategoryId
UNION ALL
SELECT 
4560,
LEFT('Non-billable primary diagnosis code',100),
'1/1/2000',
@RecodeCategoryId
END
