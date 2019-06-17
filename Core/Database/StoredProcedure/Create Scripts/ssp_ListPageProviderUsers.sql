GO

/****** Object:  StoredProcedure [dbo].[ssp_ListPageProviderUsers]    Script Date: 01/19/2012 18:38:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageProviderUsers]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPageProviderUsers]
GO

GO   

/****** Object:  StoredProcedure [dbo].[ssp_ListPageProviderUsers]    Script Date: 01/19/2012 18:38:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[ssp_ListPageProviderUsers] 
	@SessionId varchar(30),
	@InstanceId int,
	@PageNumber int,
	@PageSize int,
	@SortExpression varchar(100),
	@StatusFilter int,
	@ProgramFilter int,
	@RoleFilter int,
	@StaffID INT,
	@OtherFilter int

/********************************************************************************
-- Stored Procedure: dbo.ssp_ListPageProviderUsers
-- Copyright: Streamline Healthcate Solutions
-- Purpose: used by Provider Users list page
-- Updates:
-- Date				Author						Purpose
-- 16 Dec 2011		Pralyankar Kumar Singh		Created.
--31 Jan 2013       Saurav pande				Added by saurav pande wr.t task #473 Centrawellness-Bugs/Features 
--5 JUN,2016		Ravichandra			        Removed the physical table ListPageSCProviderUsers from SP
--										        Why:Task #108, Engineering Improvement Initiatives- NBL(I)	
--										        108 - Do NOT use list page tables for remaining list pages (refer #107)	 	    
/*********************************************************************************/     
*********************************************************************************/
AS
	BEGIN
		BEGIN TRY
			CREATE TABLE #ResultSet(
				StaffId int,
				StaffName varchar(100),
				UserName varchar(100),
				PhoneNumber varchar(100),
				CaseLoad int,
				Email varchar(100)
			)
                                                          
			DECLARE @CustomFilters TABLE (StaffId int)
			
			DECLARE @ProgramID INT
			
			------ SELECT Primary Program ID of the staff ------
			SELECT @ProgramID = PrimaryProgramId FROM Staff WHERE StaffId = @StaffID
			
			CREATE TABLE #StaffUser (Cnt INT,StaffId INT)

			INSERT INTO #StaffUser (Cnt,StaffId)
			( SELECT COUNT(C.ClientId), S.StaffId
			FROM Clients C INNER JOIN Staff S ON S.StaffId = C.PrimaryClinicianId
			WHERE C.Active = 'Y' AND ISNULL(C.RecordDeleted,'N') = 'N' AND ISNULL(S.RecordDeleted,'N') = 'N'
			GROUP BY S.StaffId )

			INSERT INTO #ResultSet(
				StaffId ,
				StaffName,
				UserName ,
				PhoneNumber ,
				Email ,
				CaseLoad
			)
			SELECT Distinct
				S.StaffID,
				S.LastName + ', ' + S.FirstName AS StaffName,
				ISNULL(S.UserCode, '') AS UserCode,
				-- ISNULL(S.PhoneNumber, '')+ ' ' + S.OfficePhone1 + ' ' + S.OfficePhone2 AS PhoneNumber,
				--ISNULL(S.OfficePhone1, '') AS PhoneNumber,
				 ISNULL(S.PhoneNumber, '') AS PhoneNumber,  --Added by saurav pande wr.t task #473 Centrawellness-Bugs/Features 
				ISNULL(S.Email, '') AS Email,
				C.Cnt AS Caseload                     
			FROM Staff S
				--LEFT OUTER JOIN Programs P ON S.PrimaryProgramId  = P.ProgramID
				LEFT JOIN  #StaffUser C ON  C.StaffId = S.StaffId
				LEFT OUTER JOIN StaffRoles SR ON SR.StaffId=S.StaffId
			WHERE
				ISNULL(S.RecordDeleted, 'N') = 'N'
				AND S.PrimaryProgramId = @ProgramID
				AND (  @StatusFilter = 0 or --- for All
					( @StatusFilter = 400)or
					( @StatusFilter = 401 and S.Active='Y') or
					( @StatusFilter = 402 and S.Active='N')
				)
				and (  @RoleFilter =0 or --- for All    
					( @RoleFilter > 0 and  
					( SR.RoleId=@RoleFilter))
				)
				--and ( @ProgramFilter = -1 or --- for All
				--	(P.ProgramId=@ProgramFilter)
				--)

			-- Drop Table 
			DROP TABLE #StaffUser

			IF @OtherFilter > 10000                                                
				BEGIN 
					INSERT INTO @CustomFilters (StaffId)
					EXEC scsp_ListPageStaffUsers @OtherFilter = @OtherFilter

					Delete d
					FROM #ResultSet d  WHERE NOT EXISTS(SELECT * FROM @CustomFilters f WHERE f.StaffId = d.StaffId)
				END
				
	
	;WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
			AS (SELECT StaffId ,
						StaffName,
						UserName ,
						PhoneNumber ,
						Email ,
						CaseLoad 
					,Count(*) OVER () AS TotalCount
					,row_number() over (order by	CASE WHEN @SortExpression= 'StaffName' THEN StaffName END,
													CASE WHEN @SortExpression= 'StaffName desc' THEN StaffName END DESC,
													CASE WHEN @SortExpression= 'UserName' THEN UserName END ,
													CASE WHEN @SortExpression= 'UserName desc' THEN UserName END DESC,
													CASE WHEN @SortExpression= 'PhoneNumber' THEN PhoneNumber END,
													CASE WHEN @SortExpression= 'PhoneNumber desc' THEN PhoneNumber END DESC,
													CASE WHEN @SortExpression= 'Email' THEN Email END,
													CASE WHEN @SortExpression= 'Email desc' THEN Email END DESC,
												   StaffId,StaffName) as RowNumber         
							FROM #ResultSet	)
		SELECT TOP (CASE WHEN (@PageNumber = - 1)
						THEN (SELECT ISNULL(TotalRows, 0) FROM Counts)
					ELSE (@PageSize)
					END
			)	StaffId ,
				StaffName,
				UserName ,
				PhoneNumber ,
				Email ,
				CaseLoad
			,TotalCount
			,RowNumber
		INTO #FinalResultSet
		FROM RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

		IF (SELECT ISNULL(Count(*), 0)	FROM #FinalResultSet) < 1
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

			SELECT StaffId, 
				   StaffName, 
				   UserName, 
				   PhoneNumber, 
				   CaseLoad, 
				   Email
		FROM #FinalResultSet
		ORDER BY RowNumber	

		END TRY

	BEGIN CATCH
		DECLARE @Error varchar(8000)
		SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())
			+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_ListPageProviderUsers')
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

