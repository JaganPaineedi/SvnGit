IF OBJECT_ID('ssp_EDIProcessFile') IS NOT NULL
	DROP PROC dbo.ssp_EDIProcessFile
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO


/*****************************************************************************************************/                                                
/* Stored Procedure: dbo.[ssp_EDIProcessFile]                                                        */                                                
/* Creation Date:    August 12 2014                                                                  */                                                
/*                                                                                                   */                                                
/* Created By: jay (big hat) wheeler                                                                 */                                                
/* Purpose: Read an EDI file of any type (ie. 278) fully qualified pathname in table EDIFiles.       */
/*          It is assumed EDIFiles.FileText has been populated before this call.                     */                                                
/*                                                                                                   */   
/*  Populates the following set of Tables:                                                           */
/*        EDIFileTypes                                                                               */
/*        EDIFileLineElements                                                                        */
/*        EDIFileLines                                                                               */
/*        EDIFileLineSubElements                                                                     */
/*        EDIFunctionalGroups                                                                        */
/*        EDIInterchanges                                                                            */
/*        EDISegmentTypes                                                                            */
/*        EDITransactionSets                                                                         */
/*                                                                                                   */                                                
/* Test Call:
                 Exec ssp_EDIProcessFile 1   
                                                                                                     */                                                
/*                                                                                                   */                                                
/* Change Log:                                                                                       */                                               
/*       3/3/2016 - Dknewtson - Moving to a different tokenizing algorithm (faster and more reliable)*/   
/*		 10/25/2016 - Dknewtson - Fixed an issue with EDIFiles with carriage returns and line feeds  */     
/*		 11/1/2016 - Dknewtson - Improved Error Handling											 */                                        
/*                                                                                                   */                                                
/*****************************************************************************************************/                                             
 

CREATE PROCEDURE [ssp_EDIProcessFile]
	@EDIFileId INT
  , @CreatedByUserId NVARCHAR(25) = 'EDIFileProcess'
  , @Debug CHAR(1) = 'N'
AS
	BEGIN
		DECLARE	@AutoAddMissingSegments CHAR(1)= 'Y'
		DECLARE	@DefaultTransactionSetId INTEGER = 1 -- 'Unknown'
        
        --#############################################################################
        -- for files with multiple ST/SE sets, Abort Entire ISA (file) or mark   
        -- EDITransactionSet.Error and continue.
        --############################################################################# 
		DECLARE	@AbortOnBadTransactionSet CHAR(1) = 'Y'
        
		

		DECLARE	@SegmentSeparator NVARCHAR(5)
		DECLARE	@ElementSeparator NVARCHAR(5)  
		DECLARE	@SubElementSeparator NVARCHAR(5)
		DECLARE	@RepetitionSeparator NVARCHAR(5)

		DECLARE	@FirstRowString VARCHAR(MAX) 
		DECLARE	@ErrorMessage NVARCHAR(MAX) = ''
		DECLARE	@MySql NVARCHAR(MAX)
		DECLARE	@NUMBEROFMAXELEMENTS INTEGER = 20
		DECLARE	@FileText NVARCHAR(MAX)
		DECLARE	@LineNumber INTEGER
		DECLARE	@SegmentType NVARCHAR(25)

		DECLARE	@Startline INTEGER
		DECLARE	@EndLine INTEGER
		DECLARE	@ControlNumber VARCHAR(MAX)
		DECLARE	@NestingLevel INTEGER
		DECLARE	@GSNestingLevel INTEGER
		DECLARE	@TSNestingLevel INTEGER
		DECLARE	@NumberofTransactionSets INTEGER
		DECLARE	@NumberofSegments INTEGER
		DECLARE	@GroupControlNumber VARCHAR(MAX)
		DECLARE	@TransactionSetControlNumber VARCHAR(MAX)
        
        

		BEGIN TRY
			SET NOCOUNT ON


			IF OBJECT_ID('Tempdb..#MyTable') IS NOT NULL
				DROP TABLE #MyTable
            
			CREATE TABLE #MyTable
				(
				  RowId [INT] IDENTITY(1, 1)
				, aRow NVARCHAR(MAX)
				)

			CREATE TABLE #Tokens
				(
				  rowid INT IDENTITY
				, toke INT
				)          

            

			SELECT	@SegmentSeparator = SegmentSeparator
				  , @ElementSeparator = ElementSeparator
				  , @SubElementSeparator = SubElementSeparator
				  , @RepetitionSeparator = RepetitionSeparator
			FROM	dbo.EDIFiles
			WHERE	EDIFileId = @EDIFileId
			
            
            --#############################################################################
            -- Remove CRLF if they follow delim
            --############################################################################# 
            
			WHILE EXISTS ( SELECT	1
						   FROM		dbo.EDIFiles AS ef
						   WHERE	( CHARINDEX(@SegmentSeparator + CHAR(10), ef.FileText) > 0
									  OR CHARINDEX(@SegmentSeparator + CHAR(13), ef.FileText) > 0
									)
									AND ef.EDIFileId = @EDIFileId )
				BEGIN
					UPDATE	dbo.EDIFiles
					SET		FileText = REPLACE(FileText, @SegmentSeparator + CHAR(10), @SegmentSeparator)
					WHERE	EDIFileId = @EDIFileId
					UPDATE	dbo.EDIFiles
					SET		FileText = REPLACE(FileText, @SegmentSeparator + CHAR(13), @SegmentSeparator)
					WHERE	EDIFileId = @EDIFileId
				END

			SELECT	@FileText = FileText
			FROM	dbo.EDIFiles
			WHERE	EDIFileId = @EDIFileId
            
            
			-- already did this on file load.  Doing here too for redundancey (just in case someone uses another method to load the file)
			IF SUBSTRING(@FileText, 1, 3) <> 'ISA' -- Why read a phonebook when you have speed dial?
				BEGIN
					SET @ErrorMessage = 'File ' + CAST(@EDIFileId AS VARCHAR) + ' does not appear to be an EDI File. (File does not begin with an ISA segment)'
					INSERT	INTO dbo.EDIFileErrors
							( CreatedBy
							, CreatedDate
							, ModifiedBy
							, ModifiedDate
							, EDIFileId
							, ErrorCode
							, ErrorMessage
							)
					VALUES	( @CreatedByUserId-- CreatedBy - type_CurrentUser
							, GETDATE()-- CreatedDate - type_CurrentDatetime
							, @CreatedByUserId-- ModifiedBy - type_CurrentUser
							, GETDATE()-- ModifiedDate - type_CurrentDatetime
							, @EDIFileId -- EDIFileId - int
							, NULL-- ErrorCode - varchar(10)
							, @ErrorMessage-- ErrorMessage - type_Comment2
							)
                     --RAISERROR (@ErrorMessage,16,1)        
				END;
			WITH	lv0
					  AS ( SELECT	0 g
						   UNION ALL
						   SELECT	0
						 ) , --2
					lv1
					  AS ( SELECT	0 g
						   FROM		lv0 a
						   CROSS JOIN lv0 b
						 ) , -- 4
					lv2
					  AS ( SELECT	0 g
						   FROM		lv1 a
						   CROSS JOIN lv1 b
						 ) , --16
					lv3
					  AS ( SELECT	0 g
						   FROM		lv2 a
						   CROSS JOIN lv2 b
						 ) ,--256
					lv4
					  AS ( SELECT	0 g
						   FROM		lv3 a
						   CROSS JOIN lv3 b
						 ) , --65536
					lv5
					  AS ( SELECT	0 g
						   FROM		lv4 a
						   CROSS JOIN lv3 b
						   CROSS JOIN lv1 c
						 ) , --16777216
					Tally ( n )
					  AS ( SELECT	ROW_NUMBER() OVER ( ORDER BY ( SELECT NULL
																 ) )
						   FROM		lv5
						 )
				INSERT	INTO #Tokens
						( toke
                            
						)
						SELECT DISTINCT
								CHARINDEX(ef.SegmentSeparator, ef.SegmentSeparator + ef.FileText, Tally.n) AS toke
						FROM	dbo.EDIFiles ef
						JOIN	Tally ON Tally.n BETWEEN 1 AND LEN(ef.FileText) + 1
                           --AND CHARINDEX(ef.SegmentSeparator,ef.SegmentSeparator+ef.FileText,N) = 1 
						WHERE	ef.EDIFileId = @EDIFileId
						ORDER BY toke     

			DELETE	#Tokens
			WHERE	toke < 1                                 
            
			INSERT	INTO #MyTable
					( aRow
					)
					SELECT	SUBSTRING(ef.FileText, t.toke, t2.toke - t.toke - 1)
					FROM	dbo.EDIFiles ef
					CROSS JOIN #Tokens t
					JOIN	#Tokens t2 ON t.rowid + 1 = t2.rowid
					WHERE	ef.EDIFileId = @EDIFileId
					ORDER BY t.rowid
                    
           
			DROP TABLE #Tokens

			SELECT TOP 1
					@FirstRowString = MT.aRow
			FROM	#MyTable MT
			ORDER BY MT.RowId

			IF @Debug = 'Y'
				PRINT @FirstRowString
         
			IF LEN(@FirstRowString) <> 105
				BEGIN
					SET @ErrorMessage = 'Error raised Parsing File: First line exceded 105 characters line #1'
					SET @ErrorMessage += CHAR(13) + ISNULL(@FirstRowString, 'first line null')
					INSERT	INTO dbo.EDIFileErrors
							( CreatedBy
							, CreatedDate
							, ModifiedBy
							, ModifiedDate
							, EDIFileId
							, ErrorCode
							, ErrorMessage
							)
					VALUES	( @CreatedByUserId-- CreatedBy - type_CurrentUser
							, GETDATE()-- CreatedDate - type_CurrentDatetime
							, @CreatedByUserId-- ModifiedBy - type_CurrentUser
							, GETDATE()-- ModifiedDate - type_CurrentDatetime
							, @EDIFileId -- EDIFileId - int
							, NULL-- ErrorCode - varchar(10)
							, @ErrorMessage-- ErrorMessage - type_Comment2
							)
                    --RAISERROR (@ErrorMessage,16,1)        
				END   
      
 
            --SELECT  @SubElementSeparator = SUBSTRING(@FirstRowString, 105, 1)
            --       ,@ElementSeparator = SUBSTRING(@FirstRowString, 4, 1) 
			-- already did this.
			IF @Debug = 'Y'
				BEGIN
					PRINT '@SubElementSeparator: ' + @SubElementSeparator
					PRINT '@ElementSeparator: ' + @ElementSeparator
				END

			DECLARE	@LastRow INTEGER
			DECLARE	@FirstCRLFRow INTEGER


			SELECT TOP 1
					@FirstCRLFRow = MT.RowId
			FROM	#MyTable MT
			WHERE	MT.aRow = CHAR(13) + CHAR(10)
			ORDER BY MT.RowId


			SELECT	@LastRow = MAX(MT.RowId)
			FROM	#MyTable MT
			WHERE	MT.RowId > @FirstCRLFRow
					AND ISNULL(MT.aRow, '') NOT IN ( CHAR(13) + CHAR(10), '' )
               
             
       
			IF @LastRow > ISNULL(@FirstCRLFRow, 0)
				BEGIN
					SET @ErrorMessage = 'Error raised Parsing File Bad Format near EOF or around guessed line #:' + CAST(@FirstCRLFRow AS VARCHAR(10))
					INSERT	INTO dbo.EDIFileErrors
							( CreatedBy
							, CreatedDate
							, ModifiedBy
							, ModifiedDate
							, EDIFileId
							, ErrorCode
							, ErrorMessage
							)
					VALUES	( @CreatedByUserId-- CreatedBy - type_CurrentUser
							, GETDATE()-- CreatedDate - type_CurrentDatetime
							, @CreatedByUserId-- ModifiedBy - type_CurrentUser
							, GETDATE()-- ModifiedDate - type_CurrentDatetime
							, @EDIFileId -- EDIFileId - int
							, NULL-- ErrorCode - varchar(10)
							, @ErrorMessage-- ErrorMessage - type_Comment2
							)
                    --RAISERROR (@ErrorMessage,16,1)     
				END



     -- Get rid of any trailing spaces and carriage returns   
			DELETE	#MyTable
			WHERE	ISNULL(aRow, '') IN ( CHAR(13) + CHAR(10), '' )
       
			ALTER TABLE #MyTable ADD SegmentType NVARCHAR(25)
			ALTER TABLE #MyTable ADD Element1DelimPos INTEGER


			UPDATE	#MyTable
			SET		SegmentType = SUBSTRING(aRow, 1, CHARINDEX(@ElementSeparator, aRow) - 1)
				  , Element1DelimPos = CHARINDEX(@ElementSeparator, aRow)

			DECLARE	@BaseStr VARCHAR(MAX)= '
UPDATE  M
SET     M.Element##CurrentNum##DelimPos = Case
                                   WHEN CHARINDEX(''' + @ElementSeparator + ''', aRow, Element##LastNum##DelimPos +1 ) = 0  THEN LEN(aRow)
                                   Else CHARINDEX(''' + @ElementSeparator + ''', aRow, Element##LastNum##DelimPos +1 )   
                             End
       ,M.Element##LastNum## = substring(aRow, Element##LastNum##DelimPos +1,
                         Case
                                   WHEN CHARINDEX(''' + @ElementSeparator + ''', aRow, Element##LastNum##DelimPos +1 ) = 0  THEN LEN(aRow) + 1
                                   Else CHARINDEX(''' + @ElementSeparator + ''', aRow, Element##LastNum##DelimPos +1 )   
                             End -  Element##LastNum##DelimPos - 1 )
FROM #MyTable M'

			DECLARE	@i INTEGER = 1
			WHILE @i <= @NUMBEROFMAXELEMENTS
				BEGIN
					IF @Debug = 'Y'
						PRINT '@i split:' + CAST(@i AS CHAR(10)) + ' ' + CONVERT(VARCHAR(25), GETDATE(), 126)
					SET @MySql = REPLACE('Alter Table #MyTable Add ELement##num## NVarchar(1024)', '##num##', CAST(@i AS VARCHAR(2)))  -- Element 1
					IF @Debug = 'Y'
						PRINT @MySql
					EXECUTE sys.sp_executesql @MySql
					SET @MySql = REPLACE('Alter Table #MyTable Add ELement##num##DelimPos Integer', '##num##', CAST(@i + 1 AS VARCHAR(2))) -- Element 2
					IF @Debug = 'Y'
						PRINT @MySql
					EXECUTE sys.sp_executesql @MySql
        
					SET @MySql = REPLACE(@BaseStr, '##CurrentNum##', CAST(@i + 1 AS VARCHAR(2)))
					SET @MySql = REPLACE(@MySql, '##LastNum##', CAST(@i AS VARCHAR(2)))
					IF @Debug = 'Y'
						PRINT @MySql
					EXECUTE sys.sp_executesql @MySql

					SET @i += 1
				END

			CREATE NONCLUSTERED INDEX IX_SegmentType ON #MyTable (SegmentType)
    

			DECLARE	@SegmentTypes TABLE ( SegMent VARCHAR(10) )
    
			IF @AutoAddMissingSegments = 'Y'
				BEGIN
					INSERT	INTO dbo.EDISegmentTypes
							( SegmentType
							, SegmentTypeDesc
							, NumberofElements
							, CreatedBy
							, CreatedDate
							, ModifiedBy
							, ModifiedDate
							)
							SELECT DISTINCT
									SegmentType
								  , 'System Added Unknown Segment Type'
								  , -1
								  , @CreatedByUserId
								  , GETDATE()
								  , @CreatedByUserId
								  , GETDATE()
							FROM	#MyTable MT
							WHERE	NOT EXISTS ( SELECT	1
												 FROM	dbo.EDISegmentTypes E
												 WHERE	E.SegmentType = MT.SegmentType )
				END
			ELSE
				BEGIN
					DECLARE	@Missing INT
					SET @ErrorMessage = NULL
					SELECT	@Missing = COUNT(*)
					FROM	( SELECT DISTINCT TOP 1000
										SegmentType
							  FROM		#MyTable
							  ORDER BY	SegmentType
							) MT
					WHERE	NOT EXISTS ( SELECT	1
										 FROM	dbo.EDISegmentTypes E
										 WHERE	E.SegmentType = MT.SegmentType )
 
                    
					IF @Missing > 1
						BEGIN    
							SELECT	@ErrorMessage = COALESCE(@ErrorMessage + ', ' + MT.SegmentType + CHAR(13), 'Undefined Segment Types:  ' + MT.SegmentType + CHAR(13))
							FROM	( SELECT DISTINCT TOP 100000
												SegmentType
									  FROM		#MyTable
									  ORDER BY	SegmentType
									) MT
							WHERE	NOT EXISTS ( SELECT	1
												 FROM	dbo.EDISegmentTypes E
												 WHERE	E.SegmentType = MT.SegmentType )
						END
					ELSE
						BEGIN
							SELECT	@ErrorMessage = COALESCE(@ErrorMessage + ', ' + MT.SegmentType + CHAR(13), 'Undefined Segment Type:  ' + MT.SegmentType + CHAR(13))
							FROM	( SELECT DISTINCT TOP 1000
												SegmentType
									  FROM		#MyTable
									  ORDER BY	SegmentType
									) MT
							WHERE	NOT EXISTS ( SELECT	1
												 FROM	dbo.EDISegmentTypes E
												 WHERE	E.SegmentType = MT.SegmentType )
						END                     
                                    
					IF LEN(@ErrorMessage) > 0
						BEGIN
							INSERT	INTO dbo.EDIFileErrors
									( CreatedBy
									, CreatedDate
									, ModifiedBy
									, ModifiedDate
									, EDIFileId
									, ErrorCode
									, ErrorMessage
									)
							VALUES	( @CreatedByUserId-- CreatedBy - type_CurrentUser
									, GETDATE()-- CreatedDate - type_CurrentDatetime
									, @CreatedByUserId-- ModifiedBy - type_CurrentUser
									, GETDATE()-- ModifiedDate - type_CurrentDatetime
									, @EDIFileId -- EDIFileId - int
									, NULL-- ErrorCode - varchar(10)
									, @ErrorMessage-- ErrorMessage - type_Comment2
									)
                        --RAISERROR (@ErrorMessage,16,1)     
						END
				END   
 --#############################################################################
 -- Check that ther is only 1 ISA record
 --############################################################################# 
			SET @ErrorMessage = ''
			IF ( SELECT COUNT (*) FROM #MyTable WHERE SegmentType = 'ISA'
			   ) = 0
				SET @ErrorMessage += 'ISA Record Not Found for EDIFileID ' + ISNULL(CAST(@EDIFileId AS VARCHAR(25)), 'Null ')
			IF ( SELECT COUNT (*) FROM #MyTable WHERE SegmentType = 'IEA'
			   ) = 0
				SET @ErrorMessage += 'IEA Record Not Found for EDIFileID ' + ISNULL(CAST(@EDIFileId AS VARCHAR(25)), 'Null ')
			IF ( SELECT COUNT (*) FROM #MyTable WHERE SegmentType = 'ISA'
			   ) > 1
				SET @ErrorMessage += 'Multiple ISA Records Found for EDIFileID ' + ISNULL(CAST(@EDIFileId AS VARCHAR(25)), 'Null ')
			IF ( SELECT COUNT (*) FROM #MyTable WHERE SegmentType = 'IEA'
			   ) > 1
				SET @ErrorMessage += 'Multiple IEA Records Found for EDIFileID ' + ISNULL(CAST(@EDIFileId AS VARCHAR(25)), 'Null ')
			IF LEN(@ErrorMessage) > 0
				BEGIN
					INSERT	INTO dbo.EDIFileErrors
							( CreatedBy
							, CreatedDate
							, ModifiedBy
							, ModifiedDate
							, EDIFileId
							, ErrorCode
							, ErrorMessage
							)
					VALUES	( @CreatedByUserId-- CreatedBy - type_CurrentUser
							, GETDATE()-- CreatedDate - type_CurrentDatetime
							, @CreatedByUserId-- ModifiedBy - type_CurrentUser
							, GETDATE()-- ModifiedDate - type_CurrentDatetime
							, @EDIFileId -- EDIFileId - int
							, NULL-- ErrorCode - varchar(10)
							, @ErrorMessage-- ErrorMessage - type_Comment2
							)            
                --RAISERROR (@ErrorMessage,16,1)
				END
 --#############################################################################
 -- File is loaded and ISA/IEA Checks Out.  Associate each Record with its
 -- Functional Group
 --############################################################################# 
 
			ALTER TABLE #MyTable ADD GSNestingLevel VARCHAR(255)  -- Nesting Level for Functional Groups (GS Records)
			ALTER TABLE #MyTable ADD TSNestingLevel VARCHAR(255)  -- Nesting Level for Transaction Segmets (TS Records)
                
                ;
			WITH	Startlines ( BeginRow, GroupControlNumber )
					  AS ( SELECT	RowId AS BeginRow
								  , Element6 AS GroupControlNumber
						   FROM		#MyTable
						   WHERE	SegmentType = 'GS'
						 )
				SELECT	BeginRow
					  , ( SELECT TOP 1
									M.RowId AS EndRow
						  FROM		#MyTable M
						  WHERE		M.SegmentType = 'GE'
									AND M.RowId > BeginRow
						  ORDER BY	M.RowId ASC
						) AS EndRow
					  , GroupControlNumber
					  , ROW_NUMBER() OVER ( ORDER BY BeginRow ) AS GSNestingLevel
				INTO	#ControlGroups
				FROM	Startlines       
            
			UPDATE	mt
			SET		GSNestingLevel = cg.GSNestingLevel
			FROM	#MyTable mt
			JOIN	#ControlGroups cg ON mt.RowId BETWEEN cg.BeginRow AND cg.EndRow

			DROP TABLE #ControlGroups


					
            --OPEN #MyCursor 

            --FETCH #MyCursor INTO @Startline, @EndLine, @ControlNumber

            --SET @NestingLevel = 0
            --WHILE @@fetch_status = 0 
            --    BEGIN
            --        SET @NestingLevel += 1
            --        UPDATE  #MyTable
            --        SET     GSNestingLevel = @NestingLevel
            --        WHERE   RowID BETWEEN @StartLine AND @EndLine
            --        FETCH #MyCursor INTO @Startline, @EndLine, @ControlNumber
            --    END

            --CLOSE #MyCursor

            --DEALLOCATE #MyCursor

--#############################################################################
-- Associate each file line with it's transaction set
--############################################################################# 
 
            --DECLARE #MyCursor CURSOR FAST_FORWARD
            --FOR
              ;
			WITH	Startlines ( BeginRow, GroupControlNumber )
					  AS ( SELECT	RowId AS BeginRow
								  , Element2 AS GroupControlNumber
						   FROM		#MyTable
						   WHERE	SegmentType = 'ST'
						 )
				SELECT	BeginRow
					  , ( SELECT TOP 1
									M.RowId AS EndRow
						  FROM		#MyTable M
						  WHERE		M.SegmentType = 'SE'
									AND M.RowId > BeginRow
						  ORDER BY	M.RowId ASC
						) AS EndRow
					  , GroupControlNumber
					  , ROW_NUMBER() OVER ( ORDER BY BeginRow ) AS TSNestingLevel
				INTO	#TransactionSets
				FROM	Startlines       
            
			UPDATE	mt
			SET		TSNestingLevel = ts.TSNestingLevel
			FROM	#MyTable mt
			JOIN	#TransactionSets ts ON mt.RowId BETWEEN ts.BeginRow AND ts.EndRow

			DROP TABLE #TransactionSets
					
            --OPEN #MyCursor 

            --FETCH #MyCursor INTO @Startline, @EndLine, @ControlNumber
            
            --SET @NestingLevel = 0
            
            --WHILE @@fetch_status = 0 
            --    BEGIN
            --        SET @NestingLevel += 1
            --        UPDATE  #MyTable
            --        SET     TSNestingLevel = @NestingLevel
            --        WHERE   RowID BETWEEN @StartLine AND @EndLine
            --        FETCH #MyCursor INTO @Startline, @EndLine, @ControlNumber
            --    END

            --CLOSE #MyCursor
            --DEALLOCATE #MyCursor
           
 --#############################################################################
 -- make sure FG and ST groups are formed properly.
 --############################################################################# 
          
          
			IF ( SELECT MAX (TSNestingLevel) FROM #MyTable WHERE SegmentType = 'ST'
			   ) <> ( SELECT MAX (TSNestingLevel) FROM #MyTable WHERE SegmentType = 'SE'
					)
				BEGIN
					SET @ErrorMessage += 'Transaction Set Headers and Footer Syntax Error (Order).' + CHAR(13)
				END  
                
			IF ( SELECT COUNT (*) FROM #MyTable WHERE SegmentType = 'ST'
			   ) <> ( SELECT COUNT (*) FROM #MyTable WHERE SegmentType = 'SE'
					)
				BEGIN
					SET @ErrorMessage += 'Transaction Set Headers and Footers Syntax Error (Order).' + CHAR(13)
				END  
                
			IF ( SELECT MAX (GSNestingLevel) FROM #MyTable WHERE SegmentType = 'GS'
			   ) <> ( SELECT MAX (GSNestingLevel) FROM #MyTable WHERE SegmentType = 'GE'
					)
				BEGIN
					SET @ErrorMessage += 'Functional Group Headers and Footers Do not Match.' + CHAR(13)
				END  
                
			IF ( SELECT COUNT (*) FROM #MyTable WHERE SegmentType = 'GS'
			   ) <> ( SELECT COUNT (*) FROM #MyTable WHERE SegmentType = 'GE'
					)
				BEGIN
					SET @ErrorMessage += 'Functional Group Headers and Footers Do not Match.' + CHAR(13)
				END  
                
             
            --#############################################################################
            -- check control numbers
            --############################################################################# 
    
			CREATE INDEX IX_GSNestingLevel ON #MyTable (GSNestingLevel)
			CREATE INDEX IX_GSTSNestingLevel ON #MyTable (GSNestingLevel,TSNestingLevel);
			WITH	GSControlNumbers ( NestingLevel, ControlNumber )
					  AS ( SELECT	GSNestingLevel
								  , Element6
						   FROM		#MyTable
						   WHERE	SegmentType = 'GS'
						 ) ,
					GEControlNumbers ( NestingLevel, ControlNumber )
					  AS ( SELECT	GSNestingLevel
								  , Element2
						   FROM		#MyTable
						   WHERE	SegmentType = 'GE'
						 )
				SELECT	@ErrorMessage = COALESCE(@ErrorMessage + 'Functional Group Mismatch:  GS Control Number ' + ISNULL(GS.ControlNumber, 'NULL') + CHAR(13) + 'GE Control Number ' + ISNULL(GE.ControlNumber, 'NULL') + CHAR(13), '@errormessage was null... not possible')
				FROM	GSControlNumbers GS
				JOIN	GEControlNumbers GE ON GS.NestingLevel = GE.NestingLevel
				WHERE	GS.ControlNumber <> GE.ControlNumber;
			WITH	STControlNumbers ( NestingLevel, ControlNumber )
					  AS ( SELECT	TSNestingLevel
								  , Element2
						   FROM		#MyTable
						   WHERE	SegmentType = 'ST'
						 ) ,
					SEControlNumbers ( NestingLevel, ControlNumber )
					  AS ( SELECT	TSNestingLevel
								  , Element2
						   FROM		#MyTable
						   WHERE	SegmentType = 'SE'
						 )
				SELECT	@ErrorMessage = COALESCE(@ErrorMessage + 'Transaction Set Mismatch:  ST Control Number ' + ISNULL(ST.ControlNumber, 'NULL') + CHAR(13) + 'SE Control Number ' + ISNULL(SE.ControlNumber, 'NULL') + CHAR(13), '@errormessage was null... not possible')
				FROM	STControlNumbers ST
				JOIN	SEControlNumbers SE ON ST.NestingLevel = SE.NestingLevel
				WHERE	ST.ControlNumber <> SE.ControlNumber
            
    --#############################################################################
    -- Check Control Counts
    --############################################################################# 
			CREATE TABLE #GSCounts
				(
				  GSNestingLevel INT
				, TSCount INT
				)
			INSERT	INTO #GSCounts
					( GSNestingLevel
					, TSCount
					)
					SELECT	a.GSNestingLevel  -- GSNestingLevel - int
						  , COUNT(*)-- SegmentCount - int
					FROM	#MyTable a
					WHERE	a.SegmentType = 'ST'
					GROUP BY a.GSNestingLevel
			CREATE TABLE #STCounts
				(
				  TSNestingLevel INT
				, GSNestingLevel INT
				, SegmentCount INT
				)      
			INSERT	INTO #STCounts
					( TSNestingLevel
					, GSNestingLevel
					, SegmentCount
					)
					SELECT	a.TSNestingLevel  -- STNestingLevel - int
						  , a.GSNestingLevel-- GSNestingLevel - int
						  , COUNT(*)-- TSCount - int
					FROM	#MyTable a
					GROUP BY a.TSNestingLevel
						  , a.GSNestingLevel;
			WITH	GEControlNumbers ( NestingLevel, TSCount, ControlNumber )
					  AS ( SELECT	GSNestingLevel
								  , Element1  -- Transaction Count
								  , Element2  -- Control Number
						   FROM		#MyTable
						   WHERE	SegmentType = 'GE'
						 )
				SELECT	@ErrorMessage = COALESCE(@ErrorMessage + 'Transaction Set Count within Group Mismatch:  Group Control Number ' + ISNULL(GE.ControlNumber, 'NULL') + ' Count On File: ' + CAST(GE.TSCount AS VARCHAR) + ' Actual: ' + CAST(gc.TSCount AS VARCHAR) + CHAR(13), '@errormessage WNNP!')
				FROM	GEControlNumbers GE
				JOIN	#GSCounts gc ON gc.GSNestingLevel = GE.NestingLevel
										AND gc.TSCount <> GE.TSCount              

			IF @AbortOnBadTransactionSet = 'Y'
				BEGIN
        ;
					WITH	SEControlNumbers ( GSNestingLevel, TSNestingLevel, SegmentCount, ControlNumber )
							  AS ( SELECT	GSNestingLevel
										  , TSNestingLevel
										  , Element1  -- Transaction Count
										  , Element2  -- Control Number
								   FROM		#MyTable
								   WHERE	SegmentType = 'SE'
								 )
						SELECT	@ErrorMessage = COALESCE(@ErrorMessage + 'Segment Count within Transaction Mismatch:  Transaction Control Number ' + ISNULL(SE.ControlNumber, 'NULL') + ' Count On File: ' + CAST(SE.SegmentCount AS VARCHAR) + ' Actual: ' + CAST(sc.SegmentCount AS VARCHAR) + CHAR(13), '@errormessage WNNP!')
						FROM	SEControlNumbers SE
						JOIN	#STCounts sc ON sc.GSNestingLevel = SE.GSNestingLevel
												AND sc.TSNestingLevel = SE.TSNestingLevel
												AND sc.SegmentCount <> SE.SegmentCount
				END
  
  
                 
			IF LEN(@ErrorMessage) > 0
				BEGIN
					INSERT	INTO dbo.EDIFileErrors
							( CreatedBy
							, CreatedDate
							, ModifiedBy
							, ModifiedDate
							, EDIFileId
							, ErrorCode
							, ErrorMessage
                       		)
					VALUES	( @CreatedByUserId-- CreatedBy - type_CurrentUser
							, GETDATE()-- CreatedDate - type_CurrentDatetime
							, @CreatedByUserId-- ModifiedBy - type_CurrentUser
							, GETDATE()-- ModifiedDate - type_CurrentDatetime
							, @EDIFileId -- EDIFileId - int
							, NULL-- ErrorCode - varchar(10)
							, @ErrorMessage-- ErrorMessage - type_Comment2
							)                      
                --RAISERROR (@ErrorMessage,16,1)
				END


            --#############################################################################
            -- basic file checks complete.  load SC Tables
            --############################################################################# 
         
            
			INSERT	INTO dbo.EDIInterchanges
					( EDIFileId
					--,EDITradingPartnerId going to do this later
					, Acknowledged
					, AcknowledgementRequested
					, AuthorizationInformationQualifier
					, AuthorizationInformation
					, SecurityInformationQualifier
					, SecurityInformation
					, InterchangeSenderIdQualifier
					, InterchangeSenderId
					, InterchangeReceiverIdQualifier
					, InterchangeReceiverId
					, DateYYMMDD
					, TimeHHMM
					, RepititionSeparator
					, NumberofFunctionalGroups
					, InterchangeControlVersionNumber
					, InterchangeControlNumber
					, InterchangeUsageNumber
					, ComponentElementSeparator
                    --,ElementSeparator
					, CreatedBy
					, CreatedDate
					, ModifiedBy
					, ModifiedDate
					)
					SELECT	@EDIFileId
						  , -- EDIFileId - int
						   --etp.EDITradingPartnerId
						   --, -- EDITradingPartnerId - int
							NULL
						  , -- Acknowledged - type_YOrN
							CASE WHEN ISNULL(Element14, 0) = 0 THEN 'N'
								 ELSE 'Y'
							END
						  , -- AcknowledgementRequested - char(1)
							Element1
						  , -- AuthorizationInformationQualifier - char(2)
							Element2
						  , -- AuthorizationInformation - varchar(10)
							Element3
						  , -- SecurityInformationQualifier - char(2)
							Element4
						  , -- SecurityInformation - varchar(10)
							Element5
						  , -- InterchangeSenderIdQualifier - char(2)
							Element6
						  , -- InterchangeSenderId - varchar(15)
							Element7
						  , -- InterchangeReceiverIdQualifier - char(2)
							Element8
						  , -- InterchangeReceiverId - varchar(15)
							Element9
						  , -- DateCCYYMMDD - varchar(8)
							Element10
						  , -- TimeHHMM - char(4)
							Element11
						  , -- RepititionSeparator - char(1)
							CAST(Element12 AS INTEGER)
						  , -- NumberofFunctionalGroups - int
							Element12
						  , -- InterchangeControlVersionNumber - varchar(5)
							Element13
						  , -- InterchangeControlNumber - varchar(9)
							Element15
						  , -- InterchangeUsageNumber - char(1)
							Element16
						  , -- ComponentElementSeparator - char(1)
                            --@ElementSeparator
							@CreatedByUserId
						  , -- CreatedBy - type_CurrentUser
							GETDATE()
						  , -- CreatedDate - type_CurrentDatetime
							@CreatedByUserId
						  , -- ModifiedBy - type_CurrentUser
							GETDATE()
                      -- ModifiedDate - type_CurrentDatetime
					FROM	#MyTable m
					WHERE	SegmentType = 'ISA'
                    
			DECLARE	@InsertedEDIInterchangeID INTEGER = SCOPE_IDENTITY()
			DECLARE	@InsertedEDIFunctionalGroupID INTEGER
			DECLARE	@InsertedEDITransactionSetId INTEGER
        
			DECLARE #MyCursor CURSOR FAST_FORWARD
			FOR
				SELECT  DISTINCT
						RowId
					  , SegmentType
					  , GSNestingLevel
					  , TSNestingLevel
				FROM	#MyTable
				WHERE	SegmentType IN ( 'ST', 'GS' )
				ORDER BY RowId
        
        					
			OPEN #MyCursor 
 
			FETCH #MyCursor INTO @LineNumber, @SegmentType, @GSNestingLevel, @TSNestingLevel
        
			WHILE @@fetch_status = 0
				BEGIN
					IF @SegmentType = 'GS'
						BEGIN
							SELECT	@NumberofTransactionSets = Element1
								  , @GroupControlNumber = Element6
							FROM	#MyTable
							WHERE	SegmentType = 'GE'
									AND GSNestingLevel = @GSNestingLevel
                        
							INSERT	INTO dbo.EDIFunctionalGroups
									( EDIInterchangeId
									, NumberofTransactionSets
									, GroupControlNumber
									, FunctionalIdentifierCode
									, ApplicationSendersCode
									, ApplicationReceiversCode
									, DateCCYYMMDD
									, TimeHHMMSSMM
									, ResponsibleAgencyCode
									, VersionReleaseIICCode
									, CreatedBy
									, CreatedDate
									, ModifiedBy
									, ModifiedDate
									)
									SELECT	@InsertedEDIInterchangeID
										  , -- EDIInterchangeId - int
											@NumberofTransactionSets
										  , -- NumberofTransactionSets - int
											@GroupControlNumber
										  , -- GroupControlNumber - varchar(max)
											Element1
										  , -- FunctionalIdentifierCode - char(2)
											Element2
										  , -- ApplicationSendersCode - varchar(15)
											Element3
										  , -- ApplicationReceiversCode - varchar(15)
											Element4
										  , -- DateCCYYMMDD - varchar(8)
											Element5
										  , -- TimeHHMMSSMM - varchar(8)
											Element7
										  , -- ResponsibleAgencyCode - char(2)
											Element8
										  , -- VersionReleaseIICCode - varchar(12)
											@CreatedByUserId
										  , -- CreatedBy - type_CurrentUser
											GETDATE()
										  , -- CreatedDate - type_CurrentDatetime
											@CreatedByUserId
										  , -- ModifiedBy - type_CurrentUser
											GETDATE()
                                  -- ModifiedDate - type_CurrentDatetime
									FROM	#MyTable
									WHERE	SegmentType = 'GS'
											AND GSNestingLevel = @GSNestingLevel

							SET @InsertedEDIFunctionalGroupID = SCOPE_IDENTITY()
						END
					ELSE -- 'ST record'
						BEGIN
                    
							SELECT	@NumberofSegments = Element1
								  , @TransactionSetControlNumber = Element2
							FROM	#MyTable
							WHERE	SegmentType = 'SE'
									AND GSNestingLevel = @GSNestingLevel
									AND TSNestingLevel = @TSNestingLevel
 
							INSERT	INTO dbo.EDITransactionSets
									( EDIFunctionalGroupId
									--,EDITradingPartnerId
									, Processed
									, ProcessingFailed
									, EDITransactionSetTypeId
									, TransactionSetControlNumber
									, NumberOfSegments
									, ImplementationConvention
									, IdentifierCode
									, CreatedBy
									, CreatedDate
									, ModifiedBy
									, ModifiedDate
									)
									SELECT	@InsertedEDIFunctionalGroupID
										  , NULL -- Processed - type_YOrN
										  , NULL -- ProcessingFailed - type_YOrN
										  , NULL--EDITransactionSetTypeId tint
										  , M.Element2 -- TransactionSetControlNumber - varchar(9)
										  , @NumberofSegments -- NumberOfSegments - int
										  , M.Element3 -- Implementation Convention
										  , M.Element1 -- IdentifierCode
										  , @CreatedByUserId -- CreatedBy - type_CurrentUser
										  , GETDATE() -- CreatedDate - type_CurrentDatetime
										  , @CreatedByUserId -- ModifiedBy - type_CurrentUser
										  , GETDATE() -- ModifiedDate - type_CurrentDatetime
									FROM	#MyTable M
            --                                LEFT JOIN EDITransactionSetTypes ETST ON ETST.TransactionSetIdentifierCode = M.Element1
												--AND ETST.TransactionSetTypeImplementationConventionReference = M.Element3
												--AND ISNULL(etst.RecordDeleted,'N') <> 'Y'
									WHERE	SegmentType = 'ST'
											AND GSNestingLevel = @GSNestingLevel
											AND TSNestingLevel = @TSNestingLevel
							SET @InsertedEDITransactionSetId = SCOPE_IDENTITY()
 
							INSERT	INTO dbo.EDIFileLines
									( EDIInterchangeId
									, EDITransactionSetId
									, LineNumber
									, EDISegmentTypeId
									, Element1
									, Element2
									, Element3
									, Element4
									, Element5
									, Element6
									, Element7
									, Element8
									, Element9
									, Element10
									, Element11
									, Element12
									, Element13
									, Element14
									, Element15
									, Element16
									, Element17
									, Element18
									, Element19
									, Element20
									, CreatedBy
									, CreatedDate
									, ModifiedBy
									, ModifiedDate
									)
									SELECT	@InsertedEDIInterchangeID AS EDIInterchangeId
										  , @InsertedEDITransactionSetId AS EDITransactionSetId
										  , M.RowId AS LineNumber
										  , EST.EDISegmentTypeId AS EDISegmentTypeId
										  , Element1
										  , Element2
										  , Element3
										  , Element4
										  , Element5
										  , Element6
										  , Element7
										  , Element8
										  , Element9
										  , Element10
										  , Element11
										  , Element12
										  , Element13
										  , Element14
										  , Element15
										  , Element16
										  , Element17
										  , Element18
										  , Element19
										  , Element20
										  , @CreatedByUserId
										  , GETDATE()
										  , @CreatedByUserId
										  , GETDATE()
									FROM	#MyTable M
									JOIN	dbo.EDISegmentTypes EST ON EST.SegmentType = M.SegmentType
									WHERE	GSNestingLevel = @GSNestingLevel
											AND TSNestingLevel = @TSNestingLevel
   
						END 
            
					FETCH #MyCursor INTO @LineNumber, @SegmentType, @GSNestingLevel, @TSNestingLevel
				END
        
			CLOSE #MyCursor
        
			DEALLOCATE #MyCursor
 
			IF @Debug = 'Y'
				SELECT	*
				FROM	#MyTable

			EXEC dbo.ssp_EDIProcessTransactionsForFile @EDIFileId = @EDIFileId

		END TRY

    
		BEGIN CATCH			
			DECLARE @ThisProcedureName VARCHAR(255) = ISNULL(OBJECT_NAME(@@PROCID), 'Testing')
            DECLARE @ErrorProc VARCHAR(4000) = CONVERT(VARCHAR(4000), ISNULL(ERROR_PROCEDURE(), @ThisProcedureName)) 
            DECLARE @ErrorLine VARCHAR(25) = ISNULL(ERROR_LINE(), 0)                
            SET @ErrorMessage = 'Line: ' + @ErrorLine + ' ' + @ThisProcedureName + ' Reports Error Thrown by: ' + @ErrorProc + CHAR(13)
            SET @ErrorMessage += ISNULL(CONVERT(VARCHAR(4000), ERROR_MESSAGE()), 'Unknown') 

			IF @@TRANCOUNT > 0
				ROLLBACK TRAN
                
                --+ CHAR(13) + @ThisProcedureName + ' Variable dump:' + CHAR(13) 
                --+ '@TableName:' + ISNULL(@TableName, 'Null') + CHAR(13) 
                --+ '@IdentityColumn:' + ISNULL(@IdentityColumn,'Null') + CHAR(13)
                --+ ISNULL(CAST(@DataStoreValues AS VARCHAR(MAX)), 'No ##DataStore') 
            --IF @Debug = 'Y' 
            --    SELECT  *
            --    FROM    #MyTable
            --    WHERE   segmenttype IN ('st', 'se')
            --    ORDER BY RowId

			INSERT	INTO dbo.EDIFileErrors
					( CreatedBy
					, CreatedDate
					, ModifiedBy
					, ModifiedDate
					, EDIFileId
					, ErrorCode
					, ErrorMessage
					)
			VALUES	( @CreatedByUserId-- CreatedBy - type_CurrentUser
					, GETDATE()-- CreatedDate - type_CurrentDatetime
					, @CreatedByUserId-- ModifiedBy - type_CurrentUser
					, GETDATE()-- ModifiedDate - type_CurrentDatetime
					, @EDIFileId -- EDIFileId - int
					, NULL-- ErrorCode - varchar(10)
					, @ErrorMessage-- ErrorMessage - type_Comment2
					)   
                
            RAISERROR (@ErrorMessage,16,1)     
 
		END CATCH

	END
GO
