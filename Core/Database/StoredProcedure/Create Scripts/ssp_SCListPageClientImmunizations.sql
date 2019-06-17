
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCListPageClientImmunizations]    Script Date: 06/13/2015 17:22:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPageClientImmunizations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCListPageClientImmunizations]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_SCListPageClientImmunizations]    Script Date: 06/13/2015 17:22:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCListPageClientImmunizations] 
    @SessionId VARCHAR(30)
	,@InstanceId INT
	,@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@ClientId INT
	,@StaffId INT
	,@LoggedInUserId INT
	,@RowSelectionList VARCHAR(max)
	,@VaccineStatus int
	,@OtherFilter int                                  
	/********************************************************************************                                                
-- Stored Procedure: dbo.ListPageSCClientImmunizations                                                  
-- Copyright: Streamline Healthcate Solutions                                                
-- Purpose: used by Client Immunization list page                                                
-- Updates:                                                                                                       
-- Date        Author            Purpose                                                
-- 05.10.2011  Ashwani           Created.   
-- 23.01.2012  Rakesh Garg       Rename Physical table  to ListPageSCClientImmunizations as in data model changes
-- 17-jun-2014 Revathi			 what:Remove ListPageSCClientImmunizations table and include check box list
		                         why:task 9 MeaningfulUse                      
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @CustomFiltersApplied char(1)='N'
		SET @SortExpression = rtrim(ltrim(@SortExpression))

		IF ISNULL(@SortExpression, '') = ''
			SET @SortExpression = 'VaccineName desc'

		IF ISNULL(@RowSelectionList, '') = ''
			SET @RowSelectionList = 'none'

		CREATE TABLE #CustomFilters (ClientImmunizationId INT)

		CREATE TABLE #ResultSet (
			ClientImmunizationId INT
			,VaccineName VARCHAR(250)
			,AdministeredDateTime DATETIME
			,AdministeredAmount VARCHAR(250)
			,LotNumber VARCHAR(25)
			,Manufacturer VARCHAR(250)
			,ExportedDateTime DATETIME
			,VaccineStatus VARCHAR(250)
			,Comment VARCHAR(MAX)
			,IsSelected BIT 
			)

		CREATE TABLE #RowSelection (
			ClientImmunizationId INT
			,IsSelected BIT
			)

		IF (lower(@RowSelectionList) = 'all' OR lower(@RowSelectionList) = 'allonpage'	OR lower(@RowSelectionList) = 'none')
		BEGIN
			INSERT INTO #RowSelection (
				ClientImmunizationId
				,IsSelected	)
			SELECT 0
				,CASE WHEN (lower(@RowSelectionList) = 'all' OR lower(@RowSelectionList) = 'allonpage')	THEN 1
					  WHEN (lower(@RowSelectionList) = 'none')	THEN 0	END
		END
		ELSE
		BEGIN
			INSERT INTO #RowSelection (
				ClientImmunizationId
				,IsSelected
				)
			SELECT ids
				,1
			FROM dbo.SplitJSONString(@RowSelectionList, ',')
		END

		 IF @OtherFilter > 10000                    
		BEGIN    
		  SET @CustomFiltersApplied = 'Y'                          
		  INSERT  INTO #CustomFilters (ClientImmunizationId)                          
		  EXEC scsp_SCListPageClientImmunizations @ClientId =@ClientId,      
												@StaffId=@StaffId,                
												@LoggedInUserId=@LoggedInUserId,
												@RowSelectionList=@RowSelectionList,
												@OtherFilter=@OtherFilter 
		END 
		INSERT INTO #ResultSet (
			ClientImmunizationId
			,VaccineName
			,AdministeredDateTime
			,AdministeredAmount
			,LotNumber
			,Manufacturer
			,ExportedDateTime
			,VaccineStatus 
			,Comment
			,IsSelected
			)
		SELECT c.ClientImmunizationId
			,GV.CodeName AS VaccineName
			,C.AdministeredDateTime
			,isnull(Str(C.AdministeredAmount, 10, 2), '') + ' ' + isnull(GAmount.CodeName, '') AS AdministeredAmount
			,C.LotNumber
			,GM.CodeName AS Manufacturer
			,C.ExportedDateTime 
			,GStatus.CodeName AS VaccineStatus
			,C.Comment
			,0 AS IsSelected
		FROM ClientImmunizations C
		LEFT JOIN GlobalCodes GV ON C.VaccineNameId = GV.GlobalCodeId
			AND ISNULL(GV.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes GM ON C.ManufacturerId = GM.GlobalCodeId
			AND ISNULL(GM.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes GAmount ON C.AdministedAmountType = GAmount.GlobalCodeId
			AND ISNULL(GAmount.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes GStatus ON C.VaccineStatus = GStatus.GlobalCodeId
			AND ISNULL(GStatus.RecordDeleted, 'N') = 'N'
		WHERE C.ClientId = @ClientId
			AND ((@CustomFiltersApplied = 'Y' AND EXISTS(SELECT * FROM #CustomFilters CF WHERE CF.ClientImmunizationId = C.ClientImmunizationId))OR (@CustomFiltersApplied = 'N'))
			AND (@VaccineStatus = C.VaccineStatus OR @VaccineStatus = 0)
			AND ISNULL(C.RecordDeleted, 'N') = 'N';

		WITH Counts
		AS (
			SELECT COUNT(*) AS TotalRows
			FROM #ResultSet
			)
			,RankResultSet
		AS (
			SELECT ClientImmunizationId
				,VaccineName
				,AdministeredDateTime
				,AdministeredAmount
				,LotNumber
				,Manufacturer
				,ExportedDateTime
				,VaccineStatus
				,Comment
				,IsSelected
				,COUNT(*) OVER () AS TotalCount
				,ROW_NUMBER() OVER (ORDER BY CASE WHEN @SortExpression = 'VaccineName' THEN VaccineName	END
						,CASE WHEN @SortExpression = 'VaccineName desc'	THEN VaccineName END DESC
						,CASE WHEN @SortExpression = 'AdministeredDateTime'	THEN AdministeredDateTime END
						,CASE WHEN @SortExpression = 'AdministeredDateTime desc' THEN AdministeredDateTime END DESC
						,CASE WHEN @SortExpression = 'LotNumber' THEN LotNumber	END
						,CASE WHEN @SortExpression = 'LotNumber desc' THEN LotNumber END DESC
						,CASE WHEN @SortExpression = 'Manufacturer'	THEN Manufacturer END
						,CASE WHEN @SortExpression = 'Manufacturer desc' THEN Manufacturer END DESC
						,CASE WHEN @SortExpression = 'ExportedDateTime'	THEN ExportedDateTime END
						,CASE WHEN @SortExpression = 'ExportedDateTime desc' THEN ExportedDateTime END DESC
						,CASE WHEN @SortExpression = 'Status'	THEN VaccineStatus END
						,CASE WHEN @SortExpression = 'Status desc' THEN VaccineStatus END DESC
						,CASE WHEN @SortExpression = 'Comment'	THEN Comment END
						,CASE WHEN @SortExpression = 'Comment desc' THEN Comment END DESC
						,ClientImmunizationId
					) AS RowNumber
			FROM #ResultSet
			)
		SELECT TOP (CASE WHEN (@PageNumber = - 1)THEN (SELECT ISNULL(TotalRows, 0)FROM Counts)
					ELSE (@PageSize)END) 
			ClientImmunizationId
			,VaccineName
			,AdministeredDateTime
			,AdministeredAmount
			,LotNumber
			,Manufacturer
			,ExportedDateTime
			,VaccineStatus
			,Comment
			,IsSelected
			,TotalCount
			,RowNumber
		INTO #FinalResultSet
		FROM RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

		UPDATE #FinalResultSet
		SET IsSelected = a.IsSelected
		FROM #RowSelection a
		WHERE (a.ClientImmunizationId = 0 OR #FinalResultSet.ClientImmunizationId = a.ClientImmunizationId)

		IF (SELECT ISNULL(COUNT(*), 0)FROM #FinalResultSet) < 1
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

		SELECT ClientImmunizationId
			,VaccineName
			,AdministeredDateTime
			,AdministeredAmount
			,LotNumber
			,Manufacturer
			,ExportedDateTime
			,VaccineStatus
			,Comment
			,IsSelected
		FROM #FinalResultSet
		ORDER BY RowNumber
	END TRY

	BEGIN CATCH                                    
                                  
DECLARE @Error varchar(8000)                               
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                              
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCListPageClientImmunizations')                                                                    
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                                
    + '*****' + Convert(varchar,ERROR_STATE())                                                             
 RAISERROR                                                           
 (                                                                    
  @Error, -- Message text.                                                                                                              
  16, -- Severity.                                           
  1 -- State.                                                                                                              
 );                                                                                                            
END CATCH                                                          
END
GO
