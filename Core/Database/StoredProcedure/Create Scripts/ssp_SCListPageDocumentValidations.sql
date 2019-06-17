IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'ssp_SCListPageDocumentValidations')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
BEGIN
	DROP PROCEDURE ssp_SCListPageDocumentValidations;
END;
GO

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

CREATE PROCEDURE [dbo].ssp_SCListPageDocumentValidations @InstanceId INT
	,@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@CurrentUserId INT
	,@Active int
	,@SearchDocumentCode char(1) = 'Y'
	,@SearchScreenName char(1) = 'N'
	,@SearchProcedureCode char(1) = 'N'
	,@Search varchar(max)
AS
/******************************************************************************
**		File: ssp_SCListPageDocumentValidations.sql
**		Name: ssp_SCListPageDocumentValidations
**		Desc: 
**
**		This template can be customized:
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**		Input							Output
**     ----------							-----------
**
**		Auth: jcarlson
**		Date: 6/8/2017
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**	    6/8/2017          jcarlson			    created
*******************************************************************************/
BEGIN
	BEGIN TRY
		set @Search = NULLIF(@Search,'')
		/*Remove custom table and hook if not core?*/
		CREATE TABLE #CustomFilters (PrimaryKey INT NOT NULL);

		DECLARE @CustomFilterApplied CHAR(1) = 'N';

		SET @SortExpression = RTRIM(LTRIM(@SortExpression));

		IF ISNULL(@SortExpression, '') = ''
		BEGIN
			SET @SortExpression = 'DocumentName';
		END;

		CREATE TABLE #RawData (
			DocumentCodeId INT
			,DocumentName VARCHAR(max)
			,DocumentValidationId INT
			,Active CHAR(1)
			,ErrorMessage VARCHAR(max)
			,ValidationDescription varchar(max)
			,ServiceNote char(1)
			,[Order] int
			,[Manual] varchar(100)
			);

		IF EXISTS (
				SELECT *
				FROM sys.objects
				WHERE object_id = OBJECT_ID(N'scsp_SCDVAListPageDocumentValidations')
					AND type IN (
						N'P'
						,N'PC'
						)
				)
		BEGIN
			EXEC scsp_SCListPageDocumentValidations @InstanceId = @InstanceId
				,@PageNumber = @PageNumber
				,@PageSize = @PageSize
				,@SortExpression = @SortExpression
				,@Active = @Active
				 ,@SearchDocumentCode = @SearchDocumentCode
				 ,@SearchScreenName = @SearchScreenName
				 ,@SearchProcedureCode = @SearchProcedureCode
				 ,@Search = @Search

			SET @CustomFilterApplied = 'Y'
		END;

		INSERT INTO #RawData (
			DocumentCodeId
			,DocumentName
			,DocumentValidationId
			,Active
			,ValidationDescription
			,ErrorMessage
			,[Order]
			,ServiceNote
			,[Manual]
			)
		/*Select Raw Data*/
		SELECT dv.DocumentCodeId
			,dc.DocumentName + ' (' + cast(dc.DocumentCodeId as varchar) + ') '
			,dv.DocumentValidationId
			,dv.Active
			,dv.ValidationDescription
			,dv.ErrorMessage
			,dv.ValidationOrder
			,dc.ServiceNote
			,case
				when exists( select 1
						   from DocumentValidationConditions as a
						   where ISNULL(a.RecordDeleted,'N')='N'
						   and dv.DocumentValidationId = a.DocumentValidationId
						   ) then 'Generated'
						   else 'Manual'
						   end as [Manual]
		FROM DocumentValidations AS dv
		JOIN DocumentCodes AS dc ON dv.DocumentCodeId = dc.DocumentCodeId
		WHERE ISNULL(dv.RecordDeleted, 'N') = 'N'
			AND isnull(dc.RecordDeleted, 'N') = 'N'
			and ( ( @SearchDocumentCode = 'Y' and dc.DocumentName like '%' + @Search + '%' ) or ( @Search is null ) )
			AND (
				 ( @Active = 2 and dv.Active = 'Y')
				 or ( @Active = 3 and dv.Active = 'N' )
				 or ( @Active = 1 )
			    )
	   union
	   		SELECT dv.DocumentCodeId
			,dc.DocumentName + ' (' + cast(dc.DocumentCodeId as varchar) + ') '
			,dv.DocumentValidationId
			,dv.Active
			,dv.ValidationDescription
			,dv.ErrorMessage
			,dv.ValidationOrder
			,dc.ServiceNote
			,case
				when exists( select 1
						   from DocumentValidationConditions as a
						   where ISNULL(a.RecordDeleted,'N')='N'
						   and dv.DocumentValidationId = a.DocumentValidationId
						   ) then 'Generated'
						   else 'Manual'
						   end as [Manual]
		FROM DocumentValidations AS dv
		JOIN DocumentCodes AS dc ON dv.DocumentCodeId = dc.DocumentCodeId
		WHERE ISNULL(dv.RecordDeleted, 'N') = 'N'
			AND isnull(dc.RecordDeleted, 'N') = 'N'
			and @SearchScreenName = 'Y'
			AND (
				 ( @Active = 2 and dv.Active = 'Y')
				 or ( @Active = 3 and dv.Active = 'N' )
				 or ( @Active = 1 )
			    )
		      and existS( select 1
					   from Screens as s
					   where s.ScreenName like '%'+ @Search +'%'
					   and s.DocumentCodeId = dc.DocumentCodeId
					   and ISNULL(s.RecordDeleted,'N')='N'
					   )
	   union
	   		SELECT dv.DocumentCodeId
			,dc.DocumentName + ' (' + cast(dc.DocumentCodeId as varchar) + ') '
			,dv.DocumentValidationId
			,dv.Active
			,dv.ValidationDescription
			,dv.ErrorMessage
			,dv.ValidationOrder
			,dc.ServiceNote
			,case
				when exists( select 1
						   from DocumentValidationConditions as a
						   where ISNULL(a.RecordDeleted,'N')='N'
						   and dv.DocumentValidationId = a.DocumentValidationId
						   ) then 'Generated'
						   else 'Manual'
						   end as [Manual]
		FROM DocumentValidations AS dv
		JOIN DocumentCodes AS dc ON dv.DocumentCodeId = dc.DocumentCodeId
		WHERE ISNULL(dv.RecordDeleted, 'N') = 'N'
			AND isnull(dc.RecordDeleted, 'N') = 'N'
			and @SearchProcedureCode = 'Y'
			AND (
				 ( @Active = 2 and dv.Active = 'Y')
				 or ( @Active = 3 and dv.Active = 'N' )
				 or ( @Active = 1 )
			    )
		      and existS( select 1
					   from ProcedureCodes as pc
					   where ( pc.ProcedureCodeName like '%'+ @Search +'%' or pc.DisplayAs like '%'+@Search+'%' )
					   and pc.AssociatedNoteId = dc.DocumentCodeId
					   and ISNULL(pc.RecordDeleted,'N')='N'
					   )

		DECLARE @TotalRow INT;

		SELECT @TotalRow = COUNT(*)
		FROM #RawData AS rd;

		CREATE TABLE #RankResultSet (
			DocumentCodeId INT
			,DocumentName VARCHAR(max)
			,DocumentValidationId INT
			,Active CHAR(1)
			,ErrorMessage VARCHAR(max)
			,ValidationDescription varchar(max)
			,ServiceNote char(1)
			,[Order] int
			,[Manual] varchar(100)
			,TotalCount INT
			,RowNumber INT
			);

		INSERT INTO #RankResultSet (
			DocumentCodeId
			,DocumentName
			,DocumentValidationId
			,Active
			,ValidationDescription
			,ErrorMessage
			,[Order]
			,ServiceNote
			,[Manual]
			,TotalCount
			,RowNumber
			)
		SELECT rd.DocumentCodeId
			,rd.DocumentName
			,rd.DocumentValidationId
			,rd.Active
			,rd.ValidationDescription
			,rd.ErrorMessage
			,rd.[Order]
			,rd.ServiceNote
			,rd.[Manual]
			,@TotalRow AS TotalCount
			,ROW_NUMBER() OVER (
				ORDER BY CASE 
						WHEN @SortExpression = 'DocumentName'
							THEN rd.DocumentName
						END
					,CASE 
						WHEN @SortExpression = 'DocumentName desc'
							THEN rd.DocumentName
						END DESC
					,CASE 
						WHEN @SortExpression = 'Active'
							THEN rd.Active
						END
					,CASE 
						WHEN @SortExpression = 'Active desc'
							THEN rd.Active
						END DESC
					,CASE 
						WHEN @SortExpression = 'ValidationDescription'
							THEN rd.ValidationDescription
						END
					,CASE 
						WHEN @SortExpression = 'ValidationDescription desc'
							THEN rd.ValidationDescription
						END DESC
					,CASE 
						WHEN @SortExpression = 'ErrorMessage'
							THEN rd.ErrorMessage
						END
					,CASE 
						WHEN @SortExpression = 'ErrorMessage desc'
							THEN rd.ErrorMessage
						END DESC
					,CASE 
						WHEN @SortExpression = 'Order'
							THEN rd.[Order]
						END
					,CASE 
						WHEN @SortExpression = 'Order desc'
							THEN rd.[Order]
						END
					,CASE 
						WHEN @SortExpression = 'ServiceNote'
							THEN rd.ServiceNote
						END
					,CASE 
						WHEN @SortExpression = 'ServiceNote desc'
							THEN rd.ServiceNote
						END DESC
				    ,CASE 
						WHEN @SortExpression = 'Manual'
							THEN rd.[Manual]
						END
					,CASE 
						WHEN @SortExpression = 'Manual desc'
							THEN rd.[Manual]
						END DESC
					,rd.DocumentValidationId
				) AS RowNumber
		FROM #RawData AS rd;

		SELECT TOP (
				CASE 
					WHEN (@PageNumber = - 1)
						THEN @TotalRow
					ELSE (@PageSize)
					END
				) rrs.DocumentValidationId
			,rrs.Active
			,rrs.DocumentCodeId
			,rrs.DocumentName
			,rrs.ValidationDescription
			,rrs.ErrorMessage
			,rrs.[Order]
			,rrs.ServiceNote
			,rrs.[Manual]
			,rrs.TotalCount
			,rrs.RowNumber
		INTO #FinalResultSet
		FROM #RankResultSet AS rrs
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize);

		IF NOT EXISTS (
				SELECT 1
				FROM #FinalResultSet
				)
		BEGIN
			SELECT 0 AS PageNumber
				,0 AS NumberOfPages
				,0 NumberOfRows;
		END;
		ELSE
		BEGIN
			SELECT TOP 1 @PageNumber AS PageNumber
				,CASE (TotalCount % @PageSize)
					WHEN 0
						THEN ISNULL((TotalCount / @PageSize), 0)
					ELSE ISNULL((TotalCount / @PageSize), 0) + 1
					END AS NumberOfPages
				,ISNULL(TotalCount, 0) AS NumberOfRows
			FROM #FinalResultSet;
		END;

		SELECT a.Active
			,a.DocumentCodeId
			,a.DocumentName
			,a.DocumentValidationId
			,a.ValidationDescription
			,a.ErrorMessage
			,a.ServiceNote
			,a.[Order]
			,a.[Manual]
			,null as ChangeOrder
			,TotalCount
			,RowNumber
		FROM #FinalResultSet AS a
		ORDER BY RowNumber;

		DROP TABLE #CustomFilters;
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000);

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCListPageDocumentValidations') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());

		RAISERROR (
				@Error
				,-- Message text.                                           
				16
				,-- Severity.                                           
				1 -- State.                                           
				);
	END CATCH;
END;
GO

