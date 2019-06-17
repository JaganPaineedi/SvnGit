IF OBJECT_ID('ssf_RecodeTranslateAsOfDateInt', 'FN') IS NOT NULL 
    DROP FUNCTION ssf_RecodeTranslateAsOfDateInt
go

CREATE FUNCTION ssf_RecodeTranslateAsOfDateInt
    (
      @RecodeCategoryName VARCHAR(100) ,
      @CompareValue INT ,
      @EffectiveDate DATETIME ,
      @TranslationIndex SMALLINT
    )
RETURNS VARCHAR(255)
AS /*------------------------------------------------------------------------------------------------------------------------------*/
/* Function: ssf_RecodeTranslateAsOfDateInt																						*/
/*																																*/
/* Purpose: Find the "translation" value for a given incoming integer value based on recode entries.								*/
/*																																*/
/* Parameters:																													*/
/*		@RecodeCategoryName - varchar(100) - Category name of the category to be compared.										*/
/*																																*/
/*		@CompareValue - int - value to be compared.																				*/
/*																																*/
/*		@EffectiveDate - datetime - only recodes effective in the daterange will be compared.									*/
/*																																*/
/*		@TranslationIndex - smallint - allows the caller to indicate which translation value to select.							*/
/*																																*/
/* Log:																															*/
/*		02/22/2015 - T.Remisoski - Created.																						*/
/*------------------------------------------------------------------------------------------------------------------------------*/
    BEGIN

        DECLARE @TranslateValue VARCHAR(255)
        
        -- NULL incoming values cannot be mapped
        IF @CompareValue IS NULL RETURN NULL

        SELECT TOP 1
                @TranslateValue = CASE @TranslationIndex
                                    WHEN 1 THEN TranslationValue1
                                    WHEN 2 THEN TranslationValue2
                                  END
        FROM    dbo.Recodes AS r
                JOIN dbo.RecodeCategories AS rc ON rc.RecodeCategoryId = r.RecodeCategoryId
        WHERE   rc.CategoryCode = @RecodeCategoryName
                AND ( ( r.FromDate IS NULL )
                      OR ( DATEDIFF(DAY, r.FromDate, @EffectiveDate) >= 0 )
                    )
                AND ( ( r.ToDate IS NULL )
                      OR ( DATEDIFF(DAY, r.ToDate, @EffectiveDate) <= 0 )
                    )
                AND ( ( @CompareValue BETWEEN r.IntegerRangeValueStart
                                      AND     r.IntegerRangeValueEnd )
                      OR ( r.UseForNonMatchedEntry = 'Y' )
                    )
AND ISNULL(r.RecordDeleted, 'N') = 'N'
        ORDER BY CASE WHEN ( @CompareValue BETWEEN r.IntegerRangeValueStart
                                           AND     r.IntegerRangeValueEnd )
                      THEN 0
                      ELSE 1
                 END ,  -- give preference to the match
                CASE WHEN ISNULL(r.UseForNonMatchedEntry, 'N') = 'N' THEN 0
                     ELSE 1
                END ,
                r.IntegerRangeValueStart

        RETURN @TranslateValue
    END
GO

/*

-- test code
BEGIN TRAN

DECLARE @GCDomainType INT = 8401 ,
    @GCRangeType INT = 8402
DECLARE @GCRangeTypeInt INT = 8410 ,
    @GCRangeTypeDecimal INT = 8411 ,
    @GCRangeTypeCharacter INT = 8412
        
DECLARE @recodecategory INT
	
INSERT  INTO dbo.RecodeCategories
        ( CreatedBy ,
          CreatedDate ,
          ModifiedBy ,
          ModifiedDate ,
          CategoryCode ,
          CategoryName ,
          Description ,
          MappingEntity ,
          RecodeType ,
          RangeType
        )
VALUES  ( 'tremisoski' , -- CreatedBy - type_CurrentUser
          GETDATE() , -- CreatedDate - type_CurrentDatetime
          'tremisoski' , -- ModifiedBy - type_CurrentUser
          GETDATE() , -- ModifiedDate - type_CurrentDatetime
          'XTRANSLATETESTINT' , -- CategoryCode - varchar(100)
          'Recode category int testing' , -- CategoryName - varchar(100)
          'Used to test the category' , -- Description - type_Comment2
          NULL , -- MappingEntity - varchar(100)
          @GCRangeType , -- RecodeType - type_GlobalCode
          @GCRangeTypeInt  -- RangeType - type_GlobalCode
        )

SET @recodecategory = SCOPE_IDENTITY()

INSERT  INTO dbo.Recodes
        ( CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, IntegerCodeId,
          CharacterCodeId, CodeName, FromDate, ToDate, RecodeCategoryId,
          IntegerRangeValueStart, IntegerRangeValueEnd, DecimalRangeValueStart,
          DecimalRangeValueEnd, CharacterRangeValueStart,
          CharacterRangeValueEnd, UseForNonMatchedEntry, TranslationValue1,
          TranslationValue2 )
VALUES  ( 'tremisoski', -- CreatedBy - type_CurrentUser
          GETDATE(), -- CreatedDate - type_CurrentDatetime
          'tremisoski', -- ModifiedBy - type_CurrentUser
          GETDATE(), -- ModifiedDate - type_CurrentDatetime
          0, -- IntegerCodeId - int
          NULL, -- CharacterCodeId - varchar(100)
          NULL, -- CodeName - varchar(100)
          '2015-02-01', -- FromDate - date
          '2015-07-28', -- ToDate - date
          @recodecategory, -- RecodeCategoryId - int
          1, -- IntegerRangeValueStart - int
          100, -- IntegerRangeValueEnd - int
          NULL, -- DecimalRangeValueStart - decimal
          NULL, -- DecimalRangeValueEnd - decimal
          NULL, -- CharacterRangeValueStart - varchar(255)
          NULL, -- CharacterRangeValueEnd - varchar(255)
          NULL, -- UseForNonMatchedEntry - type_YOrN
          'One-to-100', -- TranslationValue1 - varchar(255)
          'One-to-100 b'  -- TranslationValue2 - varchar(255)
          ),
        ( 'tremisoski', -- CreatedBy - type_CurrentUser
          GETDATE(), -- CreatedDate - type_CurrentDatetime
          'tremisoski', -- ModifiedBy - type_CurrentUser
          GETDATE(), -- ModifiedDate - type_CurrentDatetime
          0, -- IntegerCodeId - int
          NULL, -- CharacterCodeId - varchar(100)
          NULL, -- CodeName - varchar(100)
          '2015-02-01', -- FromDate - date
          '2015-07-28', -- ToDate - date
          @recodecategory, -- RecodeCategoryId - int
          101, -- IntegerRangeValueStart - int
          200, -- IntegerRangeValueEnd - int
          NULL, -- DecimalRangeValueStart - decimal
          NULL, -- DecimalRangeValueEnd - decimal
          NULL, -- CharacterRangeValueStart - varchar(255)
          NULL, -- CharacterRangeValueEnd - varchar(255)
          NULL, -- UseForNonMatchedEntry - type_YOrN
          'Onezero1-to-200', -- TranslationValue1 - varchar(255)
          'Onezero1-to-200 b'  -- TranslationValue2 - varchar(255)
          ),
        ( 'tremisoski', -- CreatedBy - type_CurrentUser
          GETDATE(), -- CreatedDate - type_CurrentDatetime
          'tremisoski', -- ModifiedBy - type_CurrentUser
          GETDATE(), -- ModifiedDate - type_CurrentDatetime
          0, -- IntegerCodeId - int
          NULL, -- CharacterCodeId - varchar(100)
          NULL, -- CodeName - varchar(100)
          '2015-02-01', -- FromDate - date
          '2015-07-28', -- ToDate - date
          @recodecategory, -- RecodeCategoryId - int
          501, -- IntegerRangeValueStart - int
          600, -- IntegerRangeValueEnd - int
          NULL, -- DecimalRangeValueStart - decimal
          NULL, -- DecimalRangeValueEnd - decimal
          NULL, -- CharacterRangeValueStart - varchar(255)
          NULL, -- CharacterRangeValueEnd - varchar(255)
          'Y', -- UseForNonMatchedEntry - type_YOrN
          'default 1', -- TranslationValue1 - varchar(255)
          'default 2'  -- TranslationValue2 - varchar(255)
          ),
        ( 'tremisoski', -- CreatedBy - type_CurrentUser
          GETDATE(), -- CreatedDate - type_CurrentDatetime
          'tremisoski', -- ModifiedBy - type_CurrentUser
          GETDATE(), -- ModifiedDate - type_CurrentDatetime
          0, -- IntegerCodeId - int
          NULL, -- CharacterCodeId - varchar(100)
          NULL, -- CodeName - varchar(100)
          '2014-02-01', -- FromDate - date
          '2014-12-31', -- ToDate - date
          @recodecategory, -- RecodeCategoryId - int
          501, -- IntegerRangeValueStart - int
          600, -- IntegerRangeValueEnd - int
          NULL, -- DecimalRangeValueStart - decimal
          NULL, -- DecimalRangeValueEnd - decimal
          NULL, -- CharacterRangeValueStart - varchar(255)
          NULL, -- CharacterRangeValueEnd - varchar(255)
          'N', -- UseForNonMatchedEntry - type_YOrN
          'default 500 1', -- TranslationValue1 - varchar(255)
          'default 500 2'  -- TranslationValue2 - varchar(255)
          ),
        ( 'tremisoski', -- CreatedBy - type_CurrentUser
          GETDATE(), -- CreatedDate - type_CurrentDatetime
          'tremisoski', -- ModifiedBy - type_CurrentUser
          GETDATE(), -- ModifiedDate - type_CurrentDatetime
          0, -- IntegerCodeId - int
          NULL, -- CharacterCodeId - varchar(100)
          NULL, -- CodeName - varchar(100)
          '2014-02-01', -- FromDate - date
          '2014-12-31', -- ToDate - date
          @recodecategory, -- RecodeCategoryId - int
          1, -- IntegerRangeValueStart - int
          1, -- IntegerRangeValueEnd - int
          NULL, -- DecimalRangeValueStart - decimal
          NULL, -- DecimalRangeValueEnd - decimal
          NULL, -- CharacterRangeValueStart - varchar(255)
          NULL, -- CharacterRangeValueEnd - varchar(255)
          'Y', -- UseForNonMatchedEntry - type_YOrN
          'default default 1', -- TranslationValue1 - varchar(255)
          'default default 2'  -- TranslationValue2 - varchar(255)
          )       


select * from recodes where RecodeCategoryId = @recodecategory

SELECT  dbo.ssf_RecodeTranslateAsOfDateInt('XTRANSLATETESTINT', 29, GETDATE(),
                                           1)
SELECT  dbo.ssf_RecodeTranslateAsOfDateInt('XTRANSLATETESTINT', 150, GETDATE(),
                                           2)
SELECT  dbo.ssf_RecodeTranslateAsOfDateInt('XTRANSLATETESTINT', 552, GETDATE(),
                                           1)
SELECT  dbo.ssf_RecodeTranslateAsOfDateInt('XTRANSLATETESTINT', -1, GETDATE(),
                                           2)
SELECT  dbo.ssf_RecodeTranslateAsOfDateInt('XTRANSLATETESTINT', NULL,
                                           GETDATE(), 2)

SELECT  dbo.ssf_RecodeTranslateAsOfDateInt('XTRANSLATETESTINT', 520, '2/1/2014',
                                           1)
SELECT  dbo.ssf_RecodeTranslateAsOfDateInt('XTRANSLATETESTINT', 520, '1/1/2014',
                                           2)
ROLLBACK TRAN

*/
