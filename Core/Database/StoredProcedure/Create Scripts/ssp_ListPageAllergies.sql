/****** Object:  StoredProcedure [dbo].[ssp_ListPageAllergies]    Script Date: 05/03/2013 11:54:00 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageAllergies]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_ListPageAllergies]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ListPageAllergies]    Script Date: 05/03/2013 11:54:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_ListPageAllergies]
	/*************************************************************/
	/* Stored Procedure: dbo.ssp_ListPageAllergies	             */
	/* Creation Date:  May 19 2013                                */
	/* Purpose: To display the Allergies list page	for Patient Portal			 */
	/*  Date                  Author                 Purpose     */
	/* Jul 30 2014           Chethan N            Created     */
	/*History*/
	/*  14-mar-2016           Ajay k Bangar      What/Why: Changed the order of Comment column. Pathway-Customization:Task#5    */
	/*	22-mar-2016			  Chethan N			 What: Commented Union statement of ClientAllergyHistory table.  
												 Why: Core Bugs task #2050  */
	/*  26-jul-2016			  Lakshmi			what:Showing 'No known allergies' why:Woods support go live #179	
	/*  27-Jul-2016           Dhanil            What:Added client Name Woods - Support Go Live task #186	*/
	/*  10-Oct-2016           Pabitra           What: Added the RecordDeleted Condition to Avoid Sub Query Error -Key Point - Support Go Live #617 */ 														*/			 							 
	/*  03-Nov-2016           Vamsi             What: Getting ModifiedDate value from clients and displaying if NoKnownAllergies is 'Y'
	                                            Why: Woods - Support Go Live #342 */ 																	 							 
     /*************************************************************/
	@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@ClientID INT
	,@AllergyType VARCHAR(50)
	,@Active VARCHAR(3)
	,@AddModifiedBy INT
	,@OtherFilter INT
AS
BEGIN
	BEGIN TRY
	--Start here 
	--Added by Lakshmi Woods support go live #179
	    DECLARE @NoKnownAllergies CHAR(1)
	    DECLARE @ModifiedBy varchar(30)
	    DECLARE @ModifiedDate DATETIME --03-Nov-2016           Vamsi 
	    SELECT @NoKnownAllergies=NoKnownAllergies,@ModifiedBy=(select  CASE WHEN  isnull (NoKnownAllergies,'N') = 'N' THEN ISNULL(ModifiedBy, '') else '' end as 'ModifiedBy') ,@ModifiedDate = (select  CASE WHEN  isnull (NoKnownAllergies,'N') = 'N' THEN ISNULL(ModifiedDate, '') else null end as 'ModifiedDate')   FROM ClientS WHERE ClientId=@ClientID -- Modified 03-Nov-2016 Vamsi 
	     CREATE TABLE #TempNoKnownAllergies (
			  ClientAllergyId INT ,
			  AllergenConceptId INT  ,
			  AllergenConceptName VARCHAR(100) ,
			  AllergyType VARCHAR(100),
			  SNOMEDCodeName VARCHAR(100),
			  [Active] VARCHAR(10),
			  AddModifiedDate VARCHAR(100),
			  Comments VARCHAR(100),
			  --27-Jul-2016  Dhanil 
			  ClientName VARCHAR(250)
			  )
	    IF(@NoKnownAllergies='Y' AND (@AllergyType='All' or @AllergyType='A'))
	    BEGIN
	       --IF(OBJECT_ID('TEMPDB..#TEMPNOKNOWNALLERGIES') IS NOT NULL)
        --   BEGIN
        --   DROP TABLE #TempNoKnownAllergies
        --   END
INSERT INTO #TempNoKnownAllergies (ClientAllergyId,
			[AllergenConceptId],
			AllergenConceptName,
			[AllergyType],
			[SNOMEDCodeName],
			[Active],
			[AddModifiedDate],
			[Comments],
			 --27-Jul-2016  Dhanil 
			[ClientName]) 
			VALUES (0,0,'No known allergies',null,null,'',
			(SELECT Top 1 (LastName + ',' + FirstName + ' '+ 'on' + ' '+ REPLACE(REPLACE(CONVERT(VARCHAR(30), @ModifiedDate, 100), 'AM', ' AM'), 'PM',' PM')) FROM Staff WHERE UserCode=@ModifiedBy AND ISNULL(RecordDeleted,'N')='N'),null,null)--Pabitra  Date: 10 Oct 2016
	       END
	    --End
	    

		CREATE TABLE #CustomFilters (ClientAllergyId INT NOT NULL)

		DECLARE @CustomFilterApplied CHAR(1)

		SET @SortExpression = RTRIM(LTRIM(@SortExpression))

		IF ISNULL(@SortExpression, '') = ''
			SET @SortExpression = 'AllergenConceptName'
		SET @CustomFilterApplied = 'N'

		IF @OtherFilter > 10000
		BEGIN
			SET @CustomFilterApplied = 'Y'

			IF object_id('dbo.scsp_ListPageAllergies', 'P') IS NOT NULL
			BEGIN
				INSERT INTO #CustomFilters (ClientAllergyId)
				EXEC scsp_ListPageAllergies @ClientID = @ClientID
					,@AllergyType = @AllergyType
					,@Active = @Active
					,@AddModifiedBy = @AddModifiedBy
					,@OtherFilter = @OtherFilter
			END
		END;
			WITH AllergiesListResultSet AS (
					SELECT ca.ClientAllergyId
						,ca.CreatedBy
						,ca.CreatedDate
						,ca.ModifiedBy
						,ca.ModifiedDate
						,ca.RecordDeleted
						,ca.DeletedDate
						,ca.DeletedBy
						,ca.AllergenConceptId
						,CASE ca.AllergyType
							WHEN 'A'
								THEN 'Allergy'
							WHEN 'I'
								THEN 'Intolerance'
							WHEN 'F'
								THEN 'Failed Trial'
							END AS AllergyType
						,ca.SNOMEDCode
						,gc.CodeName AS SNOMEDCodeName
						
						,CASE ca.Active
							WHEN 'Y'
								THEN 'Yes'
							ELSE 'No'
							END AS Active
						,mda.ConceptDescription AS AllergenConceptName
						,COALESCE((LTRIM(RTRIM(s2.LastName)) + ', ' + LTRIM(RTRIM(s2.FirstName))), (LTRIM(RTRIM(s.LastName)) + ', ' + LTRIM(RTRIM(s.FirstName)))) + ' on ' + REPLACE(REPLACE(CONVERT(VARCHAR(30), ca.ModifiedDate, 100), 'AM', ' AM'), 'PM', ' PM') AS AddModifiedDate
						,ca.Comment   -- Modified by Ajay  Date:14-Mar-2016
						,(CASE 
							WHEN ISNULL(c.ClientType, 'I') = 'I'
							THEN ISNULL(c.LastName, '') + ', ' + ISNULL(C.FirstName, '')
							ELSE ISNULL(c.OrganizationName, '')
							END) as  ClientName    --27-Jul-2016  Dhanil 
					FROM dbo.ClientAllergies ca
					join clients c on c.clientid = ca.ClientId  --27-Jul-2016  Dhanil 
					LEFT JOIN dbo.GlobalCodes gc ON gc.GlobalCodeId = ca.SNOMEDCode
					INNER JOIN dbo.MDAllergenConcepts mda ON mda.AllergenConceptId = ca.AllergenConceptId
					INNER JOIN dbo.Staff s ON s.UserCode = ca.ModifiedBy
					LEFT JOIN dbo.Staff s2 ON s2.StaffId = ca.LastReviewedBy
					WHERE ISNULL(ca.RecordDeleted, 'N') = 'N'
						AND ca.ClientId = @ClientId
						AND ISNULL(ca.RecordDeleted, 'N') <> 'Y'
						AND (
							ca.AllergyType = @AllergyType
							OR @AllergyType = 'All'
							)
						AND (
							ca.Active = @Active
							OR @Active = 'All'
							)
						AND (
							(
								@CustomFilterApplied = 'Y'
								AND EXISTS (
									SELECT *
									FROM #CustomFilters CF
									WHERE CF.ClientAllergyId = ca.ClientAllergyId
									)
								)
							OR @CustomFilterApplied = 'N'
							)
					UNION -- Added by Lakshmi For Woods Support Go live #179
					SELECT ClientAllergyId
						,'' as CreatedBy
						,'' as CreatedDate
						,'' as ModifiedBy
						,'' as ModifiedDate
						,'' as RecordDeleted
						,'' as DeletedDate
						,'' as DeletedBy
						,AllergenConceptId
						,AllergyType
						,'' as SNOMEDCode
						,SNOMEDCodeName
						,Active
						,AllergenConceptName
						,AddModifiedDate
						,Comments   
						,ClientName  --27-Jul-2016  Dhanil 
						From #TempNoKnownAllergies
					-- Chethan N changes on 22/Mar/2016 
					--UNION 
					--SELECT 0 AS ClientAllergyId
					--	,cah.CreatedBy
					--	,cah.CreatedDate
					--	,cah.ModifiedBy
					--	,cah.ModifiedDate
					--	,cah.RecordDeleted
					--	,cah.DeletedDate
					--	,cah.DeletedBy
					--	,ca.AllergenConceptId
					--	,CASE ca.AllergyType
					--		WHEN 'A'
					--			THEN 'Allergy'
					--		WHEN 'I'
					--			THEN 'Intolerance'
					--		WHEN 'F'
					--			THEN 'Failed Trial'
					--		END AS AllergyType
					--	,cah.SNOMEDCode
					--	,gc.CodeName AS SNOMEDCodeName
						
					--	,CASE cah.Active
					--		WHEN 'Y'
					--			THEN 'Yes'
					--		ELSE 'No'
					--		END AS Active
					--	,mda.ConceptDescription AS AllergenConceptName
					--	,COALESCE((LTRIM(RTRIM(s2.LastName)) + ', ' + LTRIM(RTRIM(s2.FirstName))), (LTRIM(RTRIM(s.LastName)) + ', ' + LTRIM(RTRIM(s.FirstName)))) + ' on ' + REPLACE(REPLACE(CONVERT(VARCHAR(30), cah.ModifiedDate, 100), 'AM', ' AM'), 'PM', ' PM') AS AddModifiedDate
					--	,cah.Comment   -- Modified by Ajay  Date:14-Mar-2016
					--FROM dbo.ClientAllergyHistory cah
					--INNER JOIN dbo.ClientAllergies ca ON ca.ClientAllergyId = cah.ClientAllergyId
					--LEFT JOIN dbo.GlobalCodes gc ON gc.GlobalCodeId = cah.SNOMEDCode
					--INNER JOIN dbo.MDAllergenConcepts mda ON mda.AllergenConceptId = ca.AllergenConceptId
					--INNER JOIN dbo.Staff s ON s.UserCode = cah.ModifiedBy
					--LEFT JOIN dbo.Staff s2 ON s2.StaffId = cah.LastReviewedBy
					--WHERE ISNULL(ca.RecordDeleted, 'N') = 'N'
					--	AND ISNULL(cah.RecordDeleted, 'N') = 'N'
					--	AND ca.ClientId = @ClientId
					--	AND ISNULL(ca.RecordDeleted, 'N') <> 'Y'
					--	AND (
					--		s.StaffId = @AddModifiedBy
					--		OR @AddModifiedBy = 0
					--		)
					--	AND (
					--		cah.AllergyType = @AllergyType
					--		OR @AllergyType = 'All'
					--		)
					--	AND (
					--		cah.Active = @Active
					--		OR @Active = 'All'
					--		)
					-- Chethan N Changes Ends  
					)
				,COUNTS AS (
					SELECT count(*) AS totalrows
					FROM AllergiesListResultSet
					)
				,RankResultSet AS (
					SELECT ClientAllergyId
						,[AllergenConceptId]
						,[AllergyType]
						,[SNOMEDCodeName]
						
						,[Active]
						,AllergenConceptName
						,[AddModifiedDate]
						,COUNT(*) OVER () AS TotalCount
						,RANK() OVER (
							ORDER BY CASE 
									WHEN @SortExpression = 'AllergenConceptName'
										THEN AllergenConceptName
									END
								,CASE 
									WHEN @SortExpression = 'AllergenConceptName DESC'
										THEN AllergenConceptName
									END DESC
								,CASE 
									WHEN @SortExpression = 'AllergyType'
										THEN AllergyType
									END
								,CASE 
									WHEN @SortExpression = 'AllergyType DESC'
										THEN AllergyType
									END DESC
								,CASE 
									WHEN @SortExpression = 'Active'
										THEN Active
									END
								,CASE 
									WHEN @SortExpression = 'Active DESC'
										THEN Active
									END DESC
								,CASE 
									WHEN @SortExpression = 'AddModifiedDate'
										THEN AddModifiedDate
									END
								,CASE 
									WHEN @SortExpression = 'AddModifiedDate DESC'
										THEN AddModifiedDate
									END DESC
								,CASE 
									WHEN @SortExpression = 'SNOMEDCodeName'
										THEN SNOMEDCode
									END
								,CASE 
									WHEN @SortExpression = 'SNOMEDCodeName DESC'
										THEN SNOMEDCode
									END DESC
								,CASE                                          -- Added by Ajay  Date:14-Mar-2016
									WHEN @SortExpression = 'Comment'   
										THEN Comment
									END
								,CASE 
									WHEN @SortExpression = 'Comment DESC'
										THEN Comment
									END DESC
								,ClientAllergyId
							) AS RowNumber
							,[Comment]    -- Modified by Ajay  Date:14-Mar-2016
							,[ClientName]   --27-Jul-2016  Dhanil 
					FROM AllergiesListResultSet
					)

		SELECT TOP (
				CASE 
					WHEN (@PageNumber = - 1)
						THEN (
								SELECT ISNULL(totalrows, 0)
								FROM counts
								)
					ELSE (@PageSize)
					END
				) ClientAllergyId
			,[AllergenConceptId]
			,[AllergyType]
			,[SNOMEDCodeName]
			
			,[Active]
			,AllergenConceptName
			,[AddModifiedDate]
			,TotalCount
			,RowNumber
			,[Comment]     -- Modified by Ajay  Date:14-Mar-2016
			,[ClientName]   --27-Jul-2016  Dhanil 
		INTO #FinalResultSet
		FROM RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

		IF (
				SELECT ISNULL(COUNT(*), 0)
				FROM #FinalResultSet
				) < 1
		BEGIN
			SELECT 0 AS PageNumber
				,0 AS NumberOfPages
				,0 NumberOfRows
		END
		ELSE
		BEGIN
			SELECT TOP 1 @PageNumber AS PageNumber
				,CASE (TotalCount % @PageSize)
					WHEN 0
						THEN ISNULL((TotalCount / @PageSize), 0)
					ELSE ISNULL((TotalCount / @PageSize), 0) + 1
					END AS NumberOfPages
				,ISNULL(TotalCount, 0) AS NumberOfRows
			FROM #FinalResultSet
		END

		SELECT
		    [ClientName]  --27-Jul-2016  Dhanil
		    ,ClientAllergyId
			,[AllergenConceptId]
			,AllergenConceptName
			,[AllergyType]
			,[SNOMEDCodeName]
			,[Active]
			,[AddModifiedDate]
			,[Comment]   as Comments  -- Modified by Ajay  Date:14-Mar-2016
		FROM #FinalResultSet
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_ListPageAllergies') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.          
				16
				,-- Severity.          
				1 -- State.          
				);
	END CATCH
END
GO

