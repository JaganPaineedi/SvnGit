IF OBJECT_ID('ssf_RecodeTranslateAsOfDateDec', 'FN') IS NOT NULL 
    DROP FUNCTION ssf_RecodeTranslateAsOfDateDec
go

CREATE FUNCTION ssf_RecodeTranslateAsOfDateDec
    (
      @RecodeCategoryName VARCHAR(100) ,
      @CompareValue DECIMAL(19,6) ,
      @EffectiveDate DATETIME ,
      @TranslationIndex SMALLINT
    )
RETURNS VARCHAR(255)
AS 
/*------------------------------------------------------------------------------------------------------------------------------*/
/* Function: ssf_RecodeTranslateAsOfDateDec																						*/
/*																																*/
/* Purpose: Find the "translation" value for a given incoming decimal value based on recode entries.								*/
/*																																*/
/* Parameters:																													*/
/*		@RecodeCategoryName - varchar(100) - Category name of the category to be compared.										*/
/*																																*/
/*		@CompareValue - decimal(19,6) - value to be compared.																	*/
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
                AND ( ( @CompareValue BETWEEN r.DecimalRangeValueStart
                                      AND     r.DecimalRangeValueEnd )
                      OR ( r.UseForNonMatchedEntry = 'Y' )
                    )
				AND ISNULL(r.RecordDeleted, 'N') = 'N'
        ORDER BY CASE WHEN ( @CompareValue BETWEEN r.DecimalRangeValueStart
                                           AND     r.DecimalRangeValueEnd )
                      THEN 0
                      ELSE 1
                 END ,  -- give preference to the match
                CASE WHEN ISNULL(r.UseForNonMatchedEntry, 'N') = 'N' THEN 0
                     ELSE 1
                END ,
                r.DecimalRangeValueStart

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
          'XTRANSLATETESTDEC' , -- CategoryCode - varchar(100)
          'Recode category int testing' , -- CategoryName - varchar(100)
          'Used to test the category' , -- Description - type_Comment2
          NULL , -- MappingEntity - varchar(100)
          @GCRangeType , -- RecodeType - type_GlobalCode
          @GCRangeTypeDecimal  -- RangeType - type_GlobalCode
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
          NULL, -- IntegerRangeValueStart - int
          NULL, -- IntegerRangeValueEnd - int
          .5, -- DecimalRangeValueStart - decimal
          .555, -- DecimalRangeValueEnd - decimal
          NULL, -- CharacterRangeValueStart - varchar(255)
          NULL, -- CharacterRangeValueEnd - varchar(255)
          NULL, -- UseForNonMatchedEntry - type_YOrN
          '.5 - .555 a', -- TranslationValue1 - varchar(255)
          '.5 - .555 b'  -- TranslationValue2 - varchar(255)
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
          NULL, -- IntegerRangeValueStart - int
          NULL, -- IntegerRangeValueEnd - int
          1.5, -- DecimalRangeValueStart - decimal
          100.555, -- DecimalRangeValueEnd - decimal
          NULL, -- CharacterRangeValueStart - varchar(255)
          NULL, -- CharacterRangeValueEnd - varchar(255)
          NULL, -- UseForNonMatchedEntry - type_YOrN
          '1.5 - 100.555 a', -- TranslationValue1 - varchar(255)
          '1.5 - 100.555 b'  -- TranslationValue2 - varchar(255)
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
          NULL, -- IntegerRangeValueStart - int
          NULL, -- IntegerRangeValueEnd - int
          .5, -- DecimalRangeValueStart - decimal
          .555, -- DecimalRangeValueEnd - decimal
          NULL, -- CharacterRangeValueStart - varchar(255)
          NULL, -- CharacterRangeValueEnd - varchar(255)
          NULL, -- UseForNonMatchedEntry - type_YOrN
          '.5 - .555 o a', -- TranslationValue1 - varchar(255)
          '.5 - .555 o b'  -- TranslationValue2 - varchar(255)
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
          NULL, -- IntegerRangeValueStart - int
          NULL, -- IntegerRangeValueEnd - int
          1.5, -- DecimalRangeValueStart - decimal
          100.555, -- DecimalRangeValueEnd - decimal
          NULL, -- CharacterRangeValueStart - varchar(255)
          NULL, -- CharacterRangeValueEnd - varchar(255)
          NULL, -- UseForNonMatchedEntry - type_YOrN
          '1.5 - 100.555 o a', -- TranslationValue1 - varchar(255)
          '1.5 - 100.555 o b'  -- TranslationValue2 - varchar(255)
          )
,
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
          NULL, -- IntegerRangeValueStart - int
          NULL, -- IntegerRangeValueEnd - int
          -1000.5, -- DecimalRangeValueStart - decimal
          10000.999999, -- DecimalRangeValueEnd - decimal
          NULL, -- CharacterRangeValueStart - varchar(255)
          NULL, -- CharacterRangeValueEnd - varchar(255)
          'Y', -- UseForNonMatchedEntry - type_YOrN
          '1.5 - 100.555 o a default', -- TranslationValue1 - varchar(255)
          '1.5 - 100.555 o b default'  -- TranslationValue2 - varchar(255)
          )

SELECT * FROM dbo.Recodes

--SELECT  dbo.ssf_RecodeTranslateAsOfDateDec('XTRANSLATETESTDEC', 29, GETDATE(),
--                                           1)
--SELECT  dbo.ssf_RecodeTranslateAsOfDateDec('XTRANSLATETESTDEC', 1.462311, GETDATE(),
--                                           2)
--SELECT  dbo.ssf_RecodeTranslateAsOfDateDec('XTRANSLATETESTDEC', 0.9999999, GETDATE(),
--                                           1)
--SELECT  dbo.ssf_RecodeTranslateAsOfDateDec('XTRANSLATETESTDEC', -1.9, GETDATE(),
--                                           2)
--SELECT  dbo.ssf_RecodeTranslateAsOfDateDec('XTRANSLATETESTDEC', NULL,
--                                           GETDATE(), 2)

--SELECT  dbo.ssf_RecodeTranslateAsOfDateDec('XTRANSLATETESTDEC', 5200000000000, '2/1/2014',
--                                           1)
SELECT  dbo.ssf_RecodeTranslateAsOfDateDec('XTRANSLATETESTDEC', .55000000, GETDATE(),
                                           2)

SELECT  dbo.ssf_RecodeTranslateAsOfDateDec('XTRANSLATETESTDEC', .555555666, GETDATE(),
                                           2)
ROLLBACK TRAN

*/
