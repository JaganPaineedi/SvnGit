IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_SCDirectAccounts')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN 
        DROP PROCEDURE ssp_SCDirectAccounts; 
    END;
                    GO

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

CREATE PROCEDURE [dbo].[ssp_SCDirectAccounts]
    @InstanceId INT
  , @PageNumber INT
  , @PageSize INT
  , @SortExpression VARCHAR(100)
  , @CurrentUserId INT
  , @CreatedFrom DATETIME = NULL
  , @CreatedTo DATETIME = NULL
  , @Email VARCHAR(500) = NULL
  , @User VARCHAR(500) = NULL
AS /******************************************************************************
**		File: ssp_SCDirectAccounts.sql
**		Name: ssp_SCDirectAccounts
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
**		Date: 7/19/2017
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**	    7/19/2017          jcarlson			    created
*******************************************************************************/
    BEGIN            
 
        BEGIN TRY         
		/*Remove custom table and hook if not core?*/      
            CREATE TABLE #CustomFilters (
                  DirectAccountId INT NOT NULL
                );               
                            
            DECLARE @CustomFilterApplied CHAR(1) = 'N';               
              
            SET @SortExpression = RTRIM(LTRIM(@SortExpression));               
              
            IF ISNULL(@SortExpression, '') = ''
                BEGIN               
                    SET @SortExpression = '';               
                END;               
            CREATE TABLE #RawData (
                  DirectAccountId INT
                , DirectEmail VARCHAR(500)
                , DirectAlternativeEmail VARCHAR(500)
                , CreatedDate DATETIME
                , AssociatedStaffId INT
                , AssociatedStaffName VARCHAR(500)
                , DirectName VARCHAR(500)
                );                                       
            IF EXISTS ( SELECT  *
                        FROM    sys.objects
                        WHERE   object_id = OBJECT_ID(N'scsp_SCDirectAccounts')
                                AND type IN ( N'P', N'PC' ) )
                BEGIN
                    EXEC scsp_SCDirectAccounts @InstanceId = @InstanceId, @PageNumber = @PageNumber, @PageSize = @PageSize, @SortExpression = @SortExpression,
                        @CreatedFrom = @CreatedFrom, @CreatedTo = @CreatedTo, @Email = @Email, @User = @User;
                    SET @CustomFilterApplied = 'Y';
                END;
                                
            IF ( @CustomFilterApplied = 'N' )
                BEGIN
  
                    INSERT  INTO #RawData ( DirectAccountId, DirectEmail, DirectAlternativeEmail, CreatedDate, AssociatedStaffId, AssociatedStaffName,
                                            DirectName )
                /*Select Raw Data*/
                    SELECT  a.DirectAccountId, a.DirectEmailAddress, a.DirectAlternativeEmail, a.CreatedDate, s.StaffId, s.DisplayAs, LTRIM(RTRIM(ISNULL(a.DirectFirstName,'') + ' ' + ISNULL(a.DirectLastName,'')))
					FROM    dbo.DirectAccounts AS a
                    LEFT JOIN Staff AS s ON a.StaffId = s.StaffId
                                            AND ISNULL(s.RecordDeleted, 'N') = 'N'
                    WHERE   ISNULL(a.RecordDeleted, 'N') = 'N'
					AND ( ( ISNULL(@Email,'')='') OR ( a.DirectEmailAddress LIKE '%' + @Email + '%' ) OR ( a.DirectAlternativeEmail LIKE '%' + @Email + '%' ) ) 
					AND ( ( ( ISNULL(@User,'') = '') OR 
						  ( ISNULL(a.DirectFirstName,'') + ' ' + ISNULL(a.DirectLastName,'') LIKE '%' + @User + '%' )
						  OR ( ISNULL(a.DirectFirstName,'') LIKE '%' + @User + '%' )
						  OR ( ISNULL(a.DirectLastName,'') LIKE '%' + @User + '%' )
						  )
					OR ( ( s.StaffId IS NULL )
						  OR ( s.StaffId IS NOT NULL
								AND ( ( s.DisplayAs LIKE '%' + @User  + '%' )
									 OR ( s.FirstName LIKE '%' + @User + '%' )
									 OR ( s.LastName LIKE '%' + @User + '%' )
									 )
						      )
						)
						)
					AND ( @CreatedFrom IS NULL OR CONVERT(DATE,a.CreatedDate) >= CONVERT(DATE,@CreatedFrom) )
					AND ( @CreatedTo IS NULL OR CONVERT(DATE,a.CreatedDate) <= CONVERT(DATE,@CreatedTo) ) 
 						 
                    DECLARE @TotalRow INT;
                    SELECT  @TotalRow = COUNT(*)
                    FROM    #RawData AS rd;
                END;                   

            CREATE TABLE #RankResultSet (
                  DirectAccountId INT
                , DirectEmail VARCHAR(500)
                , DirectAlternativeEmail VARCHAR(500)
                , CreatedDate DATETIME
                , AssociatedStaffId INT
                , AssociatedStaffName VARCHAR(500)
                , DirectName VARCHAR(500)
                , TotalCount INT
                , RowNumber INT
                );   
            INSERT  INTO #RankResultSet ( DirectAccountId, DirectEmail, DirectAlternativeEmail, CreatedDate, AssociatedStaffId, AssociatedStaffName, DirectName,
                                          TotalCount, RowNumber )
            SELECT  rd.DirectAccountId, rd.DirectEmail, rd.DirectAlternativeEmail, rd.CreatedDate, rd.AssociatedStaffId, rd.AssociatedStaffName, rd.DirectName,
                    @TotalRow AS TotalCount,
                    ROW_NUMBER() OVER ( ORDER BY CASE WHEN @SortExpression = 'DirectEmail' THEN rd.DirectEmail
                                                 END, CASE WHEN @SortExpression = 'DirectEmail desc' THEN rd.DirectEmail
                                                      END DESC, CASE WHEN @SortExpression = 'DirectAlternativeEmail' THEN rd.DirectAlternativeEmail
                                                                END, CASE WHEN @SortExpression = 'DirectAlternativeEmail desc' THEN rd.DirectAlternativeEmail
                                                                     END DESC, CASE WHEN @SortExpression = 'CreatedDate' THEN rd.CreatedDate
                                                                               END, CASE WHEN @SortExpression = 'CreatedDate desc' THEN rd.CreatedDate
                                                                                    END DESC, CASE WHEN @SortExpression = 'AssociatedStaffName'
                                                                                                   THEN rd.AssociatedStaffName
                                                                                              END, CASE WHEN @SortExpression = 'AssociatedStaffName desc'
                                                                                                        THEN rd.AssociatedStaffName
                                                                                                   END DESC, CASE WHEN @SortExpression = 'DirectName'
                                                                                                                  THEN rd.DirectName
                                                                                                             END, CASE WHEN @SortExpression = 'DirectName desc'
                                                                                                                       THEN rd.DirectName
                                                                                                                  END DESC, rd.DirectAccountId ) AS RowNumber
            FROM    #RawData AS rd;
                         
            SELECT TOP ( CASE WHEN ( @PageNumber = -1 ) THEN @TotalRow
                              ELSE ( @PageSize )
                         END )
                    rrs.DirectAccountId, rrs.DirectEmail, rrs.DirectAlternativeEmail, rrs.CreatedDate, rrs.AssociatedStaffId, rrs.AssociatedStaffName,
                    rrs.DirectName, rrs.TotalCount, rrs.RowNumber
            INTO    #FinalResultSet
            FROM    #RankResultSet AS rrs
            WHERE   RowNumber > ( ( @PageNumber - 1 ) * @PageSize );               
              
            IF NOT EXISTS ( SELECT  1
                            FROM    #FinalResultSet )
                BEGIN               
                    SELECT  0 AS PageNumber, 0 AS NumberOfPages, 0 NumberOfRows;               
                END;               
            ELSE
                BEGIN               
                    SELECT TOP 1
                            @PageNumber AS PageNumber, CASE ( TotalCount % @PageSize )
                                                         WHEN 0 THEN ISNULL(( TotalCount / @PageSize ), 0)
                                                         ELSE ISNULL(( TotalCount / @PageSize ), 0) + 1
                                                       END AS NumberOfPages, ISNULL(TotalCount, 0) AS NumberOfRows
                    FROM    #FinalResultSet;               
                END;               
              
            SELECT  DirectAccountId, DirectEmail, DirectAlternativeEmail, CreatedDate, AssociatedStaffId, AssociatedStaffName, DirectName, TotalCount, RowNumber
            FROM    #FinalResultSet
            ORDER BY RowNumber;               
              
            DROP TABLE #CustomFilters;               
        END TRY               
              
        BEGIN CATCH               
            DECLARE @Error VARCHAR(8000);               
              
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCDirectAccounts') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());               
              
            RAISERROR ( @Error,-- Message text.                                           
                    16,-- Severity.                                           
                    1 -- State.                                           
        );               
        END CATCH;               
    END; 

GO

