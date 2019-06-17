IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'ssp_SCDirectMessages')
                    AND type IN ( N'P', N'PC' ) )
    BEGIN 
        DROP PROCEDURE ssp_SCDirectMessages; 
    END;
                    GO

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

CREATE PROCEDURE [dbo].[ssp_SCDirectMessages]
    @InstanceId INT
  , @PageNumber INT
  , @PageSize INT
  , @SortExpression VARCHAR(100)
  , @CurrentUserId INT
  , @FromDate DATETIME
  , @ToDate DATETIME
  , @MessageSearch VARCHAR(MAX)
  , @MessageFrom VARCHAR(MAX)
AS /******************************************************************************
**		File: /Database/Modules/DirectMessaging/StoredProcedures
**		Name: ssp_SCDirectMessages
**		Desc: This is used to return the dataset used by the Direct Message List Page
**
**		This template can be customized:
**              
**		Return values:
** 
**		Called by: DirectMessages.ascx.cs > GetListPageData()
**              
**		Parameters:
**		Input							Output
**     ----------							-----------
**
**		Auth: jcarlson
**		Date: 6/22/2017
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**	    6/22/2017          jcarlson			    created
*******************************************************************************/
    BEGIN            
 
        BEGIN TRY         
            SELECT  @MessageSearch = LTRIM(RTRIM(@MessageSearch));

		/*Remove custom table and hook if not core?*/      
            CREATE TABLE #CustomFilters (
                  PrimaryKey INT NOT NULL
                );               
                            
            DECLARE @CustomFilterApplied CHAR(1) = 'N';               
              
            SET @SortExpression = RTRIM(LTRIM(@SortExpression));               
              
            IF ISNULL(@SortExpression, '') = ''
                BEGIN               
                    SET @SortExpression = 'ReceivedDate';               
                END;               
            CREATE TABLE #RawData (
                  PrimaryKey INT
                , MessageFrom VARCHAR(MAX)
                , MessageSubject VARCHAR(MAX)
                , MessageReceivedDate DATETIME
                , MessageId VARCHAR(MAX)
                , MessageRead CHAR(1)
                );                                          
            IF EXISTS ( SELECT  *
                        FROM    sys.objects
                        WHERE   object_id = OBJECT_ID(N'scsp_SCDirectMessages')
                                AND type IN ( N'P', N'PC' ) )
                BEGIN
                    EXEC scsp_SCReceivedMessages @InstanceId = @InstanceId, @PageNumber = @PageNumber, @PageSize = @PageSize, @SortExpression = @SortExpression,
                        @CurrentUserId = @CurrentUserId, @FromDate = @FromDate, @ToDate = @ToDate, @MessageSearch = @MessageSearch, @MessageFrom = @MessageFrom;
                    SET @CustomFilterApplied = 'Y';
                END;
                                
            IF ( @CustomFilterApplied = 'N' )
                BEGIN 
                    INSERT  INTO #RawData ( PrimaryKey, MessageFrom, MessageSubject, MessageReceivedDate, MessageId, MessageRead )
                    SELECT  a.DirectMessageId, a.MessageFrom, ISNULL(NULLIF(LTRIM(RTRIM(a.MessageSubject)),''),'(No Subject)'), a.MessageReceivedDate, a.MessageId, a.MessageRead
                    FROM    dbo.DirectMessages AS a
                    WHERE   @CurrentUserId = a.StaffId
                            AND ISNULL(a.RecordDeleted, 'N') = 'N'
                            AND a.MessageType = 'I' -- Incoming    
                            AND ( ( CONVERT(DATE, a.MessageReceivedDate) >= CONVERT(DATE, @FromDate)
                                  OR @FromDate IS NULL )
                                )
                            AND ( ( CONVERT(DATE, a.MessageReceivedDate) <= CONVERT(DATE, @ToDate)
                                  OR @ToDate IS NULL )
                                )
                            AND ( ( a.MessageSubject LIKE '%' + @MessageSearch + '%' )
                                  OR ( a.MessageBody LIKE '%' + @MessageSearch + '%' )
                                  OR ( ISNULL(@MessageSearch, '') = '' )
                                )
							AND ( ( a.MessageFrom LIKE '%' + @MessageFrom + '%' )
									OR ( ISNULL(@MessageFrom,'') = '' ) 
								);
                END;
            DECLARE @TotalRow INT;
            SELECT  @TotalRow = COUNT(*)
            FROM    #RawData AS rd;
                       

            CREATE TABLE #RankResultSet (
                  PrimaryKey INT
                , MessageFrom VARCHAR(MAX)
                , MessageSubject VARCHAR(MAX)
                , MessageReceivedDate DATETIME
                , MessageId VARCHAR(MAX)
                , MessageRead CHAR(1)
                , TotalCount INT
                , RowNumber INT
                );   
            INSERT  INTO #RankResultSet ( PrimaryKey, MessageFrom, MessageSubject, MessageReceivedDate, MessageId, MessageRead, TotalCount, RowNumber )
            SELECT  rd.PrimaryKey, rd.MessageFrom, rd.MessageSubject, rd.MessageReceivedDate, rd.MessageId, rd.MessageRead, @TotalRow AS TotalCount,
                    ROW_NUMBER() OVER ( ORDER BY CASE WHEN @SortExpression = 'MessageFrom' THEN rd.MessageFrom
                                                 END, CASE WHEN @SortExpression = 'MessageFrom desc' THEN rd.MessageFrom
                                                      END DESC, CASE WHEN @SortExpression = 'MessageSubject' THEN rd.MessageSubject
                                                                END, CASE WHEN @SortExpression = 'MessageSubject desc' THEN rd.MessageSubject
                                                                     END DESC, CASE WHEN @SortExpression = 'MessageReceivedDate' THEN rd.MessageReceivedDate
                                                                               END, CASE WHEN @SortExpression = 'MessageReceivedDate desc'
                                                                                         THEN rd.MessageReceivedDate
                                                                                    END DESC, rd.PrimaryKey ) AS RowNumber
            FROM    #RawData AS rd;
                         
            SELECT TOP ( CASE WHEN ( @PageNumber = -1 ) THEN @TotalRow
                              ELSE ( @PageSize )
                         END )
                    rrs.PrimaryKey, rrs.MessageFrom, rrs.MessageSubject, rrs.MessageReceivedDate, rrs.MessageId, rrs.MessageRead, rrs.TotalCount, rrs.RowNumber
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
              
            SELECT  PrimaryKey AS DirectMessageId, MessageFrom, MessageSubject, MessageReceivedDate, MessageId, MessageRead, TotalCount, RowNumber
            FROM    #FinalResultSet
            ORDER BY RowNumber;               
              
            DROP TABLE #CustomFilters;               
        END TRY               
              
        BEGIN CATCH               
            DECLARE @Error VARCHAR(8000);               
              
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCDirectMessages') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());               
              
            RAISERROR ( @Error,-- Message text.                                           
                    16,-- Severity.                                           
                    1 -- State.                                           
        );               
        END CATCH;               
    END; 

GO

