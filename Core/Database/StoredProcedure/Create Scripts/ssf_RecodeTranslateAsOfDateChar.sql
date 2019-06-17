IF OBJECT_ID('ssf_RecodeTranslateAsOfDateChar', 'FN') IS NOT NULL 
    DROP FUNCTION ssf_RecodeTranslateAsOfDateChar
go

CREATE FUNCTION ssf_RecodeTranslateAsOfDateChar
    (
      @RecodeCategoryName VARCHAR(100) ,
      @CompareValue VARCHAR(255) ,
      @EffectiveDate DATETIME ,
      @TranslationIndex SMALLINT
    )
RETURNS VARCHAR(255)
AS 
/*------------------------------------------------------------------------------------------------------------------------------*/
/* Function: ssf_RecodeTranslateAsOfDateChar																					*/
/*																																*/
/* Purpose: Find the "translation" value for a given incoming character value based on recode entries.							*/
/*																																*/
/* Parameters:																													*/
/*		@RecodeCategoryName - varchar(100) - Category name of the category to be compared.										*/
/*																																*/
/*		@CompareValue - varchar(255) - value to be compared.																	*/
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
                AND ( ( @CompareValue BETWEEN r.CharacterRangeValueStart
                                      AND     r.CharacterRangeValueEnd )
                      OR ( r.UseForNonMatchedEntry = 'Y' )
                    )
AND ISNULL(r.RecordDeleted, 'N') = 'N'
        ORDER BY CASE WHEN ( @CompareValue BETWEEN r.CharacterRangeValueStart
                                           AND     r.CharacterRangeValueEnd )
                      THEN 0
                      ELSE 1
                 END ,  -- give preference to the match
                CASE WHEN ISNULL(r.UseForNonMatchedEntry, 'N') = 'N' THEN 0
                     ELSE 1
                END ,
                r.CharacterRangeValueStart

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
          'XTRANSLATETESTCHR' , -- CategoryCode - varchar(100)
          'Recode category int testing' , -- CategoryName - varchar(100)
          'Used to test the category' , -- Description - type_Comment2
          NULL , -- MappingEntity - varchar(100)
          @GCRangeType , -- RecodeType - type_GlobalCode
          @GCRangeTypeCharacter  -- RangeType - type_GlobalCode
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
          null, -- DecimalRangeValueStart - decimal
          null, -- DecimalRangeValueEnd - decimal
          'a', -- CharacterRangeValueStart - varchar(255)
          'b', -- CharacterRangeValueEnd - varchar(255)
          NULL, -- UseForNonMatchedEntry - type_YOrN
          'a - b 1', -- TranslationValue1 - varchar(255)
          'a - b 2'  -- TranslationValue2 - varchar(255)
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
          null, -- DecimalRangeValueStart - decimal
          null, -- DecimalRangeValueEnd - decimal
          'ba', -- CharacterRangeValueStart - varchar(255)
          'bz', -- CharacterRangeValueEnd - varchar(255)
          NULL, -- UseForNonMatchedEntry - type_YOrN
          'ba - bz 1', -- TranslationValue1 - varchar(255)
          'ba - bz 2'  -- TranslationValue2 - varchar(255)
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
          null, -- DecimalRangeValueStart - decimal
          null, -- DecimalRangeValueEnd - decimal
          'c', -- CharacterRangeValueStart - varchar(255)
          'z', -- CharacterRangeValueEnd - varchar(255)
          NULL, -- UseForNonMatchedEntry - type_YOrN
          'c - z 1', -- TranslationValue1 - varchar(255)
          'c - z 2'  -- TranslationValue2 - varchar(255)
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
          null, -- DecimalRangeValueStart - decimal
          null, -- DecimalRangeValueEnd - decimal
          null, -- CharacterRangeValueStart - varchar(255)
          null, -- CharacterRangeValueEnd - varchar(255)
          'Y', -- UseForNonMatchedEntry - type_YOrN
          'char default 1', -- TranslationValue1 - varchar(255)
          'char default 2'  -- TranslationValue2 - varchar(255)
          )
          

SELECT * FROM dbo.Recodes

SELECT  dbo.ssf_RecodeTranslateAsOfDateChar('XTRANSLATETESTCHR', 'a', GETDATE(),
                                           1)
SELECT  dbo.ssf_RecodeTranslateAsOfDateChar('XTRANSLATETESTCHR', 'b', GETDATE(),
                                           2)
SELECT  dbo.ssf_RecodeTranslateAsOfDateChar('XTRANSLATETESTCHR', 'bd', GETDATE(),
                                           1)
SELECT  dbo.ssf_RecodeTranslateAsOfDateChar('XTRANSLATETESTCHR', '-tom', GETDATE(),
                                           2)
SELECT  dbo.ssf_RecodeTranslateAsOfDateChar('XTRANSLATETESTCHR', NULL,
                                           GETDATE(), 2)

SELECT  dbo.ssf_RecodeTranslateAsOfDateChar('XTRANSLATETESTCHR', '5200000000000', '2/1/2015',
                                           1)
SELECT  dbo.ssf_RecodeTranslateAsOfDateChar('XTRANSLATETESTCHR', 'oscar', GETDATE(),
                                           2)
ROLLBACK TRAN

*/
