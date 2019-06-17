IF EXISTS ( SELECT
                    *
                FROM
                    sys.objects
                WHERE
                    object_id = OBJECT_ID(N'ssp_ScriptOutRecodeCategories')
                    AND type IN ( N'P' , N'PC' ) )
    BEGIN 
        DROP PROCEDURE dbo.ssp_ScriptOutRecodeCategories; 
    END;
                    GO

CREATE PROCEDURE ssp_ScriptOutRecodeCategories
    @RecodeCategoryId INT = NULL ,
    @RecodeCategoryCode VARCHAR(100) = NULL
AS /*------------------------------------------------------------------------------------------------------
 Procedure: ssp_ScriptOutRecodeCategories		   											    
																				    
 Purpose: Create or update an entry in the Recodes table for a specific category.				    
 Parameters:																		   
		  @RecodeCategoryCode varchar(100) - Category code associated to the recode.
		  @RecodeCategoryId int - Unique Id of the recode category			         							    
																				    
 Returns: table that contains the scripted out recode category and codes using 	
 ssp_RecodesCategoryCreateUpdate
 ssp_RecodesCreateEntry

Example Call:
EXEC dbo.ssp_ScriptOutRecodeCategories @RecodeCategoryId = NULL , -- int
    @RecodeCategoryCode = 'xProcedureCodesRequireAttending';
 -- varchar(100)

Example Response:
EXEC dbo.ssp_RecodesCategoryCreateUpdate @CategoryCode = 'xProcedureCodesRequireAttending' , @CategoryName = 'xProcedureCodesRequireAttending' ,
    @Description = 'Procedure Codes that require an attending to be selected to complete.' , @MappingEntity = 'ProcedureCodes.ProcedureCodeId' ,
    @RecodeType = NULL , @RangeType = NULL;
EXEC dbo.ssp_RecodesCreateEntry @RecodeCategoryCode = xProcedureCodesRequireAttending , @IntegerCodeId = 9908 , @CharacterCodeId = NULL ,
    @CodeName = 'ECI THERAPY- SLPA' , @FromDate = '2016-01-01' , @ToDate = NULL , @IntegerRangeValueStart = NULL , @IntegerRangeValueEnd = NULL ,
    @DecimalRangeValueStart = NULL , @DecimalRangeValueEnd = NULL , @CharacterRangeValueStart = NULL , @CharacterRangeValueEnd = NULL ,
    @UseForNonMatchedEntry = NULL , @TranslationValue1 = NULL , @TranslationValue2 = NULL;
EXEC dbo.ssp_RecodesCreateEntry @RecodeCategoryCode = xProcedureCodesRequireAttending , @IntegerCodeId = 9909 , @CharacterCodeId = NULL ,
    @CodeName = 'ECI THERAPY - PTA' , @FromDate = '2016-01-01' , @ToDate = NULL , @IntegerRangeValueStart = NULL , @IntegerRangeValueEnd = NULL ,
    @DecimalRangeValueStart = NULL , @DecimalRangeValueEnd = NULL , @CharacterRangeValueStart = NULL , @CharacterRangeValueEnd = NULL ,
    @UseForNonMatchedEntry = NULL , @TranslationValue1 = NULL , @TranslationValue2 = NULL;
EXEC dbo.ssp_RecodesCreateEntry @RecodeCategoryCode = xProcedureCodesRequireAttending , @IntegerCodeId = 9910 , @CharacterCodeId = NULL ,
    @CodeName = 'ECI THERAPY - OTA' , @FromDate = '2016-01-01' , @ToDate = NULL , @IntegerRangeValueStart = NULL , @IntegerRangeValueEnd = NULL ,
    @DecimalRangeValueStart = NULL , @DecimalRangeValueEnd = NULL , @CharacterRangeValueStart = NULL , @CharacterRangeValueEnd = NULL ,
    @UseForNonMatchedEntry = NULL , @TranslationValue1 = NULL , @TranslationValue2 = NULL;
EXEC dbo.ssp_RecodesCreateEntry @RecodeCategoryCode = xProcedureCodesRequireAttending , @IntegerCodeId = 1840 , @CharacterCodeId = NULL ,
    @CodeName = 'ADMIN OF INJECTION' , @FromDate = '2016-01-01' , @ToDate = '2050-01-01' , @IntegerRangeValueStart = NULL , @IntegerRangeValueEnd = NULL ,
    @DecimalRangeValueStart = NULL , @DecimalRangeValueEnd = NULL , @CharacterRangeValueStart = NULL , @CharacterRangeValueEnd = NULL ,
    @UseForNonMatchedEntry = NULL , @TranslationValue1 = NULL , @TranslationValue2 = NULL; 
												    
																				    
 Revision History:																    
 Modifed Date      Modified By      Modification
          	    jcarlson		 created											    
------------------------------------------------------------------------------------------------------*/
    BEGIN TRY

        IF @RecodeCategoryId IS NULL
            AND ISNULL(@RecodeCategoryCode , '') = ''
            BEGIN
                RAISERROR('1 parameter has to be populated',16,1);

            END;
        IF @RecodeCategoryId IS NOT NULL
            AND ISNULL(@RecodeCategoryCode , '') <> ''
            BEGIN
                RAISERROR('Only 1 parameter can be populated',16,1);

            END;

        DECLARE @SqlStatement VARCHAR(MAX);
        DECLARE
            @recodecategory VARCHAR(MAX) ,
            @recodes VARCHAR(MAX);

        DECLARE @locRecodeCategoryId INT;

        DECLARE
            @CategoryCode VARCHAR(100) ,
            @CategoryName VARCHAR(100) ,
            @Description VARCHAR(MAX) ,
            @MappingEntity VARCHAR(100) ,
            @RecodeType INT ,
            @RangeType INT;

        SELECT
                @locRecodeCategoryId = rc.RecodeCategoryId ,
                @CategoryCode = rc.CategoryCode ,
                @CategoryName = rc.CategoryName ,
                @Description = rc.Description ,
                @MappingEntity = rc.MappingEntity ,
                @RecodeType = rc.RecodeType ,
                @RangeType = rc.RangeType
            FROM
                dbo.RecodeCategories AS rc
            WHERE
                rc.CategoryCode = @RecodeCategoryCode
                OR rc.RecodeCategoryId = @RecodeCategoryId;

        IF @locRecodeCategoryId IS NULL
            BEGIN

                RAISERROR('Cannot find Recode Category Id in target database',16,1);

            END;

        IF @CategoryCode IS NULL
            BEGIN
            
                RAISERROR('Cannot find Recode Category Code in target database',16,1);
            END;
            
        SELECT
                @recodecategory = ' exec ssp_RecodesCategoryCreateUpdate @CategoryCode = ' + QUOTENAME(@CategoryCode , '''') + ', @CategoryName = '
                + CASE WHEN ISNULL(@CategoryName , '') = '' THEN 'NULL'
                       ELSE QUOTENAME(@CategoryName , '''')
                  END + ', @Description = ' + CASE WHEN ISNULL(@Description , '') = '' THEN 'NULL'
                                                   ELSE '''' + REPLACE(@Description , '''' , '''''') + ''''
                                              END + ', @MappingEntity = ' + CASE WHEN ISNULL(@MappingEntity , '') = '' THEN 'NULL'
                                                                                 ELSE QUOTENAME(@MappingEntity , '''')
                                                                            END + ', @RecodeType = ' + CASE WHEN @RecodeType IS NULL THEN 'NULL'
                                                                                                            ELSE CONVERT(VARCHAR(MAX) , @RecodeType)
                                                                                                       END + ', @RangeType = '
                + CASE WHEN @RangeType IS NULL THEN 'NULL'
                       ELSE CONVERT(VARCHAR(MAX) , @RangeType)
                  END + ';';

        SELECT
                @recodes = STUFF((
                                   SELECT
                                        '  exec ssp_RecodesCreateEntry @RecodeCategoryCode = ' + QUOTENAME(@CategoryCode , '''') + ', @IntegerCodeId = '
                                        + CASE WHEN r.IntegerCodeId IS NULL THEN 'NULL'
                                               ELSE ISNULL(CONVERT(VARCHAR(MAX) , r.IntegerCodeId) , '')
                                          END + ', @CharacterCodeId = ' + CASE WHEN r.CharacterCodeId IS NULL THEN 'NULL'
                                                                               ELSE QUOTENAME(ISNULL(r.CharacterCodeId , '') , '''')
                                                                          END + ', @CodeName = ' + CASE WHEN r.CodeName IS NULL THEN 'NULL'
                                                                                                        ELSE QUOTENAME(ISNULL(r.CodeName , '') , '''')
                                                                                                   END + ', @FromDate = '
                                        + CASE WHEN r.FromDate IS NULL THEN 'NULL'
                                               ELSE QUOTENAME(ISNULL(r.FromDate , '') , '''')
                                          END + ', @ToDate = ' + CASE WHEN r.ToDate IS NULL THEN 'NULL'
                                                                      ELSE QUOTENAME(ISNULL(r.ToDate , '') , '''')
                                                                 END + ', @IntegerRangeValueStart = ' + CASE WHEN r.IntegerRangeValueStart IS NULL THEN 'NULL'
                                                                                                             ELSE CONVERT(VARCHAR(MAX) , r.IntegerRangeValueStart)
                                                                                                        END + ', @IntegerRangeValueEnd = '
                                        + CASE WHEN r.IntegerRangeValueEnd IS NULL THEN 'NULL'
                                               ELSE CONVERT(VARCHAR(MAX) , r.IntegerRangeValueEnd)
                                          END + ', @DecimalRangeValueStart = ' + CASE WHEN r.DecimalRangeValueStart IS NULL THEN 'NULL'
                                                                                      ELSE CONVERT(VARCHAR(MAX) , r.DecimalRangeValueStart)
                                                                                 END + ', @DecimalRangeValueEnd = '
                                        + CASE WHEN r.DecimalRangeValueEnd IS NULL THEN 'NULL'
                                               ELSE CONVERT(VARCHAR(MAX) , r.DecimalRangeValueEnd)
                                          END + ', @CharacterRangeValueStart = ' + CASE WHEN ISNULL(r.CharacterRangeValueStart , '') = '' THEN 'NULL'
                                                                                        ELSE QUOTENAME(r.CharacterRangeValueStart , '''')
                                                                                   END + ', @CharacterRangeValueEnd = '
                                        + CASE WHEN ISNULL(r.CharacterRangeValueEnd , '') = '' THEN 'NULL'
                                               ELSE QUOTENAME(r.CharacterRangeValueEnd , '''')
                                          END + ', @UseForNonMatchedEntry = ' + CASE WHEN ISNULL(r.UseForNonMatchedEntry , '') = '' THEN 'NULL'
                                                                                     ELSE QUOTENAME(r.UseForNonMatchedEntry , '''')
                                                                                END + ', @TranslationValue1 = '
                                        + CASE WHEN ISNULL(r.TranslationValue1 , '') = '' THEN 'NULL'
                                               ELSE QUOTENAME(r.TranslationValue1 , '''')
                                          END + ', @TranslationValue2 = ' + CASE WHEN ISNULL(r.TranslationValue2 , '') = '' THEN 'NULL'
                                                                                 ELSE QUOTENAME(r.TranslationValue2 , '''')
                                                                            END + '; '
                                    FROM
                                        dbo.Recodes AS r
                                    WHERE
                                        r.RecodeCategoryId = @locRecodeCategoryId
                                        AND ISNULL(r.RecordDeleted , 'N') = 'N'
                                 FOR
                                   XML PATH('')
                                 ) , 1 , 1 , '');

        SELECT
                @SqlStatement = @recodecategory + ' ' + @recodes;
	  
	   --if the numbers of characters in the string is > 10000, break the string apart into rows where each row has < 10000 characters
        DECLARE @x INT;
        DECLARE @y INT;
        DECLARE @SQLSTATEMENTS TABLE
            (
              SQLSTATEMENT VARCHAR(MAX)
            );
           
        WHILE LEN(@SqlStatement) > 0
            BEGIN
                IF LEN(@SqlStatement) > 10000
                    BEGIN
                        SET @x = LEN(LEFT(@SqlStatement , 10000)) - CHARINDEX(' ' , REVERSE(LEFT(@SqlStatement , 10000)));
                        INSERT INTO @SQLSTATEMENTS
                                ( SQLSTATEMENT
                                )
                            SELECT
                                    RTRIM(LTRIM(LEFT(LEFT(@SqlStatement , 10000) , @x)));
                        SET @SqlStatement = SUBSTRING(@SqlStatement , @x + 1 , LEN(@SqlStatement));
                    END;
                ELSE
                    BEGIN
                        INSERT INTO @SQLSTATEMENTS
                                ( SQLSTATEMENT )
                            SELECT
                                    @SqlStatement;
                        SET @SqlStatement = '';
                    END;
            END;
        SELECT
                SQLSTATEMENT
            FROM
                @SQLSTATEMENTS;
  



    END TRY
    BEGIN CATCH
        SELECT
                ERROR_MESSAGE();
    END CATCH;
                    