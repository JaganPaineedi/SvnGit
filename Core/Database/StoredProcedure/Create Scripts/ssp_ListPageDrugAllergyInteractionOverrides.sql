/****** Object:  StoredProcedure [dbo].[scsp_PMServices]    Script Date: 04/16/2011 17:34:36 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[ssp_ListPageDrugAllergyInteractionOverrides]')
			AND TYPE IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_ListPageDrugAllergyInteractionOverrides]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_ListPageDrugAllergyInteractionOverrides] (
	@SessionId VARCHAR(30)
	,@InstanceId INT
	,@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@OtherFilter INT
	)
	/*********************************************************************************************************************/
	/* Stored Procedure: [ssp_ListPageDrugAllergyInteractionOverrides]													 */
	/* Creation Date:  17/May/2011																						*/
	/* Purpose: To Get The Data on List Page of DrugAllergy Interaction Overides Screen								*/
	/* Input Parameters: @SessionId ,@InstanceId,@PageNumber,@PageSize,@SortExpression ,@OtherFilter                  */
	/* Output Parameters:   Returns The Two Table, One have the apge Information and second table Contain the List Page Data  */
	/* Called By: Admin List Page DrugAllergyInteractionOverrides															 */
	/* Data Modifications:																									 */
	/*   Updates:																											*/
	/*   Date              Author																							*/
	/*   17/May/2011       Davinder Kumar																					*/
	/*   23Jan2012         Rakesh Garg		Rename Table ListPageTableDrugAllergyInteractionOverrides to ListPageSCDrugAllergyInteractionOverrides 
											and comment the fields which are not exists in Physical table.*/
	/*   20 JUN,2016       Ravichandra		Removed the physical table ListPageSCDrugAllergyInteractionOverrides from SP
											Why:Task #108, Engineering Improvement Initiatives- NBL(I)	
											108 - Do NOT use list page tables for remaining list pages (refer #107)	 */
	/*********************************************************************/
	-- Add the parameters for the stored procedure here  
	---Mandatory to add the below 6 Parameters for each List Page   
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from  
	-- interfering with SELECT statements.  
	SET NOCOUNT ON;

	BEGIN TRY
		--@ApplyFilterClicked variable is used to store value 'Y' when user clicked on Filter Button otherwise its value    will be 'N'  
		CREATE TABLE #ResultSet (
			-- Mandatory Field For All List Page Related Table Data                                                            
			-- Below field are which you have to show in the grid   
			---and exists in the table which you have created for List.  
			DrugDrugInteractionOverrideId INT
			,Degree VARCHAR(250)
			,Prescriber VARCHAR(30)
			,Specialty VARCHAR(250)
			,DefaultInteractionLevel VARCHAR(3)
			,AdjustedInteractionLevel VARCHAR(3)
			,MedicationName VARCHAR(100)
			,
			--AllergenConceptId int,  
			AllergenConceptDescription VARCHAR(250)
			)

		-- PrescriberId int,  
		--SpecialityId int,  
		-- DegreeId int,  
		-- MedicationNameId int  
		INSERT INTO #ResultSet (
			--- Write all fields (comma separated exclude PageNumber,RowNumber)  
			DrugDrugInteractionOverrideId
			,Degree
			,Prescriber
			,Specialty
			,DefaultInteractionLevel
			,AdjustedInteractionLevel
			,MedicationName
			,
			-- AllergenConceptId,  
			AllergenConceptDescription
			)
		--PrescriberId,  
		--SpecialityId ,  
		--DegreeId ,  
		--MedicationNameId   
		SELECT dd.DrugDrugInteractionOverrideId
			,isnull(gc.CodeName, 'All') AS Degree
			,isnull(st.UserCode, 'All') AS Prescriber
			,isnull(gc2.CodeName, 'All') AS Specialty
			,dd.DefaultInteractionLevel
			,dd.AdjustedInteractionLevel
			,md.MedicationName AS MedicationName
			,
			--dbo.GetMedicationName(dd.MedicationNameId) as MedicationDrugName,  
			-- dd.AllergenConceptId as AllergenConceptId,  
			MDAllergenConcepts.ConceptDescription
		--  st.StaffId as PrescriberId,  
		--  gc2.GlobalCodeId as SpecialtyId,  
		--   gc.GlobalCodeId as DegreeId,  
		-- dd.MedicationNameId as MedicationNameId  
		FROM dbo.DrugAllergyInteractionOverrides dd
		LEFT JOIN GlobalCodes gc ON dd.Degree = gc.GlobalCodeId
		LEFT JOIN GlobalCodes gc2 ON dd.Specialty = gc2.GlobalCodeId
		LEFT JOIN Staff st ON dd.PrescriberId = st.StaffId
			AND isnull(st.RecordDeleted, 'N') = 'N'
		LEFT JOIN MDMedicationNames md ON dd.MedicationNameId = md.MedicationNameId
			AND isnull(md.RecordDeleted, 'N') = 'N'
		LEFT JOIN MDAllergenConcepts ON dd.AllergenConceptId = MDAllergenConcepts.AllergenConceptId
			AND isnull(MDAllergenConcepts.RecordDeleted, 'N') = 'N'
		WHERE isnull(dd.RecordDeleted, 'N') = 'N';

		WITH Counts
		AS (
			SELECT Count(*) AS TotalRows
			FROM #ResultSet
			)
			,RankResultSet
		AS (
			SELECT DrugDrugInteractionOverrideId
				,Degree
				,Prescriber
				,Specialty
				,DefaultInteractionLevel
				,AdjustedInteractionLevel
				,MedicationName
				,
				-- AllergenConceptId,  
				AllergenConceptDescription
				--PrescriberId,  
				--SpecialityId ,  
				--DegreeId ,  
				--MedicationNameId   
				,Count(*) OVER () AS TotalCount
				,row_number() OVER (
					ORDER BY CASE 
							WHEN @SortExpression = 'Degree '
								THEN Degree
							END
						,CASE 
							WHEN @SortExpression = 'Degree desc'
								THEN Degree
							END DESC
						,CASE 
							WHEN @SortExpression = 'Prescriber'
								THEN Prescriber
							END
						,CASE 
							WHEN @SortExpression = 'Prescriber desc'
								THEN Prescriber
							END DESC
						,CASE 
							WHEN @SortExpression = 'Specialty'
								THEN Specialty
							END
						,CASE 
							WHEN @SortExpression = 'Specialty desc'
								THEN Specialty
							END DESC
						,CASE 
							WHEN @SortExpression = 'Allergy'
								THEN AllergenConceptDescription
							END
						,CASE 
							WHEN @SortExpression = 'Allergy desc'
								THEN AllergenConceptDescription
							END DESC
						,CASE 
							WHEN @SortExpression = 'MedicationName'
								THEN MedicationName
							END
						,CASE 
							WHEN @SortExpression = 'MedicationName desc'
								THEN MedicationName
							END DESC
						,CASE 
							WHEN @SortExpression = 'AdjustedInteractionLevel'
								THEN AdjustedInteractionLevel
							END
						,CASE 
							WHEN @SortExpression = 'AdjustedInteractionLevel desc'
								THEN AdjustedInteractionLevel
							END DESC
						,CASE 
							WHEN @SortExpression = 'DefaultInteractionLevel'
								THEN DefaultInteractionLevel
							END
						,CASE 
							WHEN @SortExpression = 'DefaultInteractionLevel desc'
								THEN DefaultInteractionLevel
							END DESC
						,DrugDrugInteractionOverrideId
					) AS RowNumber
			FROM #ResultSet
			)
		SELECT TOP (
				CASE 
					WHEN (@PageNumber = - 1)
						THEN (
								SELECT ISNULL(TotalRows, 0)
								FROM Counts
								)
					ELSE (@PageSize)
					END
				) DrugDrugInteractionOverrideId
			,Degree
			,Prescriber
			,Specialty
			,DefaultInteractionLevel
			,AdjustedInteractionLevel
			,MedicationName
			,
			-- AllergenConceptId,  
			AllergenConceptDescription
			--PrescriberId,  
			--SpecialityId ,  
			--DegreeId ,  
			--MedicationNameId     
			,TotalCount
			,RowNumber
		INTO #FinalResultSet
		FROM RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

		IF (
				SELECT ISNULL(Count(*), 0)
				FROM #FinalResultSet
				) < 1
		BEGIN
			SELECT 0 AS PageNumber
				,0 AS NumberOfPages
				,0 NumberofRows
		END
		ELSE
		BEGIN
			SELECT TOP 1 @PageNumber AS PageNumber
				,CASE (Totalcount % @PageSize)
					WHEN 0
						THEN ISNULL((Totalcount / @PageSize), 0)
					ELSE ISNULL((Totalcount / @PageSize), 0) + 1
					END AS NumberOfPages
				,ISNULL(Totalcount, 0) AS NumberofRows
			FROM #FinalResultSet
		END

		SELECT DrugDrugInteractionOverrideId
			,MedicationName
			,AllergenConceptDescription
			,Degree
			,Prescriber
			,Specialty
			,AdjustedInteractionLevel
			,DefaultInteractionLevel
		-- AllergenConceptId,  
		--PrescriberId,  
		--SpecialityId ,  
		--DegreeId ,  
		--MedicationNameId   
		FROM #FinalResultSet
		ORDER BY RowNumber
	END TRY

	BEGIN CATCH
		DECLARE @error VARCHAR(8000)

		SET @error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_ListPageDrugAllergyInteractionOverrides') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

		RAISERROR (
				@error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH
END