IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_SCSearchMeasureValueSets')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN
        DROP PROCEDURE ssp_SCSearchMeasureValueSets;
    END;
GO

CREATE PROCEDURE ssp_SCSearchMeasureValueSets
    @InstanceId INT ,
    @PageNumber INT ,
    @PageSize INT ,
    @SortExpression VARCHAR(MAX) ,
    @Concept VARCHAR(MAX) ,
    @CodeSystem VARCHAR(MAX) ,
    @LoggedInUserId INT,
    @From VARCHAR(MAX),
    @CMSNumber int,
    @ProcedureCodeId int = null
AS /******************************************************************************
**		File: 
**		Name: ssp_SCSearchMeasureValueSets
**		Desc: 
**
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**
**		Auth: jcarlson
**		Date: 4/17/2018
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**      4/17/2018          jcarlson				created
*******************************************************************************/
    BEGIN
        BEGIN TRY

            SET @SortExpression = RTRIM(LTRIM(@SortExpression));               
	         
			IF NULLIF(@CodeSystem,'') IS NULL
			BEGIN
				SET @CodeSystem = 'All';
			END

            IF ISNULL(@SortExpression, '') = ''
                BEGIN               
                    SET @SortExpression = '';               
                END;               
	                                  
            CREATE TABLE #RawData
                (
                  MeasureValueSetId INT ,
                  MeasureId INT ,
                  MeasureName VARCHAR(MAX) ,
                  Category VARCHAR(MAX) ,
                  QualityDataElement VARCHAR(MAX) ,
                  ValueSetName VARCHAR(MAX) ,
                  CodeSystem VARCHAR(MAX) ,
                  Concept VARCHAR(MAX) ,
                  ConceptDescription VARCHAR(MAX)
                );      
            INSERT  INTO #RawData
                    ( MeasureValueSetId ,
                      MeasureId ,
                      MeasureName ,
                      Category ,
                      QualityDataElement ,
                      ValueSetName ,
                      CodeSystem ,
                      Concept ,
                      ConceptDescription 
	                )
                    SELECT  MeasureValueSetId ,
                            MeasureId ,
                            MeasureName ,
                            Category ,
                            QualityDataElement ,
                            ValueSetName ,
                            CodeSystem ,
                            Concept ,
                            ConceptDescription
                    FROM    CQMSolution.MeasureValueSet AS a
                    WHERE   a.Concept LIKE '%' + @Concept + '%'
                            AND ( a.CodeSystem = @CodeSystem OR @CodeSystem = 'All' )
					   AND a.Category IN ('Procedure','Encounter','Intervention')
					   AND ( a.MeasureId = @CMSNumber or @CMSNumber is null )
					   and ( @ProcedureCodeId = null 
							or not exists( select 1
								      from ProcedureCodeCQMConfigurations as b
									 where a.MeasureValueSetId = b.MeasureValueSetId
									 and b.ProcedureCodeId = @ProcedureCodeId
									 and isnull(b.RecordDeleted,'N')='N'
								    )
						  )
	                        
	
            DECLARE @TotalRow INT;
            SELECT  @TotalRow = COUNT(*)
            FROM    #RawData AS rd;
	                       
	
            CREATE TABLE #RankResultSet
                (
                  MeasureValueSetId INT ,
                  MeasureId INT ,
                  MeasureName VARCHAR(MAX) ,
                  Category VARCHAR(MAX) ,
                  QualityDataElement VARCHAR(MAX) ,
                  ValueSetName VARCHAR(MAX) ,
                  CodeSystem VARCHAR(MAX) ,
                  Concept VARCHAR(MAX) ,
                  ConceptDescription VARCHAR(MAX) ,
                  TotalCount INT ,
                  RowNumber INT
                );   
            INSERT  INTO #RankResultSet
                    ( MeasureValueSetId ,
                      MeasureId ,
                      MeasureName ,
                      Category ,
                      QualityDataElement ,
                      ValueSetName ,
                      CodeSystem ,
                      Concept ,
                      ConceptDescription ,
                      TotalCount ,
                      RowNumber
				    )
                    SELECT  MeasureValueSetId ,
                            MeasureId ,
                            MeasureName ,
                            Category ,
                            QualityDataElement ,
                            ValueSetName ,
                            CodeSystem ,
                            Concept ,
                            ConceptDescription ,
                            @TotalRow AS TotalCount ,
                            ROW_NUMBER() OVER ( ORDER BY CASE WHEN @SortExpression = 'MeasureId'
                                                              THEN rd.MeasureId
                                                         END, CASE
                                                              WHEN @SortExpression = 'MeasureId desc'
                                                              THEN rd.MeasureId
                                                              END DESC, CASE
                                                              WHEN @SortExpression = 'MeasureName'
                                                              THEN rd.MeasureName
                                                              END, CASE
                                                              WHEN @SortExpression = 'MeasureName desc'
                                                              THEN rd.MeasureName
                                                              END DESC, CASE
                                                              WHEN @SortExpression = 'Category'
                                                              THEN rd.Category
                                                              END, CASE
                                                              WHEN @SortExpression = 'Category desc'
                                                              THEN rd.Category
                                                              END DESC, CASE
                                                              WHEN @SortExpression = 'ValueSetName'
                                                              THEN rd.ValueSetName
                                                              END, CASE
                                                              WHEN @SortExpression = 'ValueSetName desc'
                                                              THEN rd.ValueSetName
                                                              END DESC, CASE
                                                              WHEN @SortExpression = 'CodeSystem'
                                                              THEN rd.CodeSystem
                                                              END, CASE
                                                              WHEN @SortExpression = 'CodeSystem desc'
                                                              THEN rd.CodeSystem
                                                              END DESC, CASE
                                                              WHEN @SortExpression = 'Concept'
                                                              THEN rd.Concept
                                                              END, CASE
                                                              WHEN @SortExpression = 'Concept desc'
                                                              THEN rd.Concept
                                                              END DESC, rd.MeasureValueSetId ) AS RowNumber
                    FROM    #RawData AS rd;
	                         
            SELECT TOP ( CASE WHEN ( @PageNumber = -1 ) THEN @TotalRow
                              ELSE ( @PageSize )
                         END )
                    MeasureValueSetId ,
                    MeasureId ,
                    MeasureName ,
                    Category ,
                    QualityDataElement ,
                    ValueSetName ,
                    CodeSystem ,
                    Concept ,
                    ConceptDescription ,
                    rrs.TotalCount ,
                    rrs.RowNumber
            INTO    #FinalResultSet
            FROM    #RankResultSet AS rrs
            WHERE   RowNumber > ( ( @PageNumber - 1 ) * @PageSize );               
	              
            IF NOT EXISTS ( SELECT  1
                            FROM    #FinalResultSet )
                BEGIN               
                    SELECT  0 AS PageNumber ,
                            0 AS NumberOfPages ,
                            0 NumberOfRows;               
                END;               
            ELSE
                BEGIN               
                    SELECT TOP 1
                            @PageNumber AS PageNumber ,
                            CASE ( TotalCount % @PageSize )
                              WHEN 0
                              THEN ISNULL(( TotalCount / @PageSize ), 0)
                              ELSE ISNULL(( TotalCount / @PageSize ), 0) + 1
                            END AS NumberOfPages ,
                            ISNULL(TotalCount, 0) AS NumberOfRows
                    FROM    #FinalResultSet;               
                END;               
	              
            SELECT  MeasureValueSetId ,
                    MeasureId ,
                    MeasureName ,
                    Category ,
                    QualityDataElement ,
                    ValueSetName ,
                    CodeSystem ,
                    Concept ,
                    ConceptDescription ,
                    TotalCount ,
                    RowNumber
            FROM    #FinalResultSet
            ORDER BY RowNumber;               
	                           
        END TRY               
	              
        BEGIN CATCH               
            DECLARE @Error VARCHAR(8000);               
	              
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
                + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                         'ssp_SCSearchMeasureValueSets') + '*****'
                + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
                + CONVERT(VARCHAR, ERROR_STATE());               
	              
            RAISERROR ( @Error,-- Message text.                                           
	                    16,-- Severity.                                           
	                    1 -- State.                                           
	        );               
        END CATCH;               
    END; 
	
	GO
	
	