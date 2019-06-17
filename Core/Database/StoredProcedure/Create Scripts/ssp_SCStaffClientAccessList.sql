/****** Object:  StoredProcedure [ssp_SCStaffClientAccessList]    Script Date: 03/07/2012 19:41:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ssp_SCStaffClientAccessList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ssp_SCStaffClientAccessList]
GO

/****** Object:  StoredProcedure [ssp_SCStaffClientAccessList]    Script Date: 03/07/2012 19:41:17 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [ssp_SCStaffClientAccessList]         

/****************************************************************************** 
** File: ssp_SCStaffClientAccessList.sql
** Name: ssp_SCStaffClientAccessList
** Desc:  
** 
** 
** This template can be customized: 
** 
** Return values: Filter Values - Staff Client Access List Page
** 
** Called by: 
** 
** Parameters: 
** Input Output 
** ---------- ----------- 
** Auth: Ponnin Selvan
** Date: 16/06/2011
******************************************************************************* 
** Change History 
******************************************************************************* 
** Date: 			Author: 			Description: 
** 29/10/2014		Ponnin Selvan		Query to return values for the grid in StaffClientAccess List Page

*******************************************************************************/
                                             

@PageNumber				INT,
@PageSize				INT,
@SortExpression			VARCHAR(100),
@FromDate				DATETIME,  
@ToDate					DATETIME
AS     
BEGIN                                                              
	BEGIN TRY
		
            CREATE TABLE #CustomFilters
                (
                  StaffClientAccessId INT NOT NULL 
                ) 
                                                          
	                                                                                                  
		DECLARE @ApplyFilterClicked		CHAR(1)
		DECLARE @CustomFiltersApplied	CHAR(1)
		Declare @maxID int
		SET @SortExpression = RTRIM(LTRIM(@SortExpression))
		IF ISNULL(@SortExpression, '') = ''
			SET @SortExpression= 'StaffName'
		
	  IF( @FromDate = CONVERT(DATETIME, N'') )  
  BEGIN  
   SET @FromDate = NULL  
  END  
    
  IF( @ToDate = CONVERT(DATETIME, N'') )  
  BEGIN  
   SET @ToDate = NULL  
  END  
  
  IF( @ToDate >= (select max(CONVERT(DATE,CreatedDate,101)) FROM StaffClientAccess) )  
  BEGIN  
   SET @maxID= IDENT_CURRENT('StaffClientAccess')
  END 
  ELSE
  BEGIN
	SET @maxID=(select min(StaffClientAccessId) from StaffClientAccess where CONVERT(DATE,CreatedDate,101)=(select min(CONVERT(DATE,CreatedDate,101)) FROM StaffClientAccess WHERE CONVERT(DATE,CreatedDate,101) >@ToDate))
  END 

		SET @ApplyFilterClicked = 'Y' 
		SET @CustomFiltersApplied = 'N' 
		
		Create table #MissingId
		(Id int,
		StaffId int, 
		ClientId int,
		 SystemScreenId int,
		 ScreenId int,
		 ObjectId int,
		 ActivityType char(1),
		 TableName varchar(250),HashValues varchar(max), StaffName varchar(200), ClientName varchar(250),
		 ScreenName varchar(250),
		 DeletedRecord varchar(250))
		                                                
	;WITH Missing (missnum, maxid)AS
(  SELECT (select max(StaffClientAccessId) from StaffClientAccess where CONVERT(DATE,CreatedDate,101)=(select max(CONVERT(DATE,CreatedDate,101)) FROM StaffClientAccess WHERE CONVERT(DATE,CreatedDate,101) <@FromDate))
, @maxID
UNION ALL
 SELECT missnum + 1, maxid FROM Missing WHERE missnum < maxid)
 
 Insert into #MissingId
  SELECT missnum AS StaffClientAcessId, '' AS StaffId, '' AS ClientId, '' AS SystemScreenId, '' AS ScreenId, '' AS ObjectId, '' AS ActivityType, '' AS TableName,'' AS HashValues, '' AS StaffName, '' AS ClientName, '' AS ScreenName, 'Record deleted' AS DeletedRecord  FROM Missing 
 LEFT OUTER JOIN StaffClientAccess tt on tt.StaffClientAccessId = Missing.missnum 
 WHERE 
 tt.StaffClientAccessId is 
 NULL OPTION (MAXRECURSION 0);   
 
        
WITH ListStaffClientAccess
	AS
	(                      
		SELECT  SCA.StaffClientAccessId, SCA.StaffId, SCA.ClientId,SCA.SystemScreenId,SCA.ScreenId,SCA.ObjectId,SCA.ActivityType,
		SCA.TableName,SCA.HashValues, S.LastName + ', ' + S.FirstName as StaffName, C.LastName + ', ' + C.FirstName as ClientName,
		SC.ScreenName, '' AS DeletedRecord 
		FROM StaffClientAccess SCA join Staff S on SCA.StaffId = S.StaffId 
		Join Clients C on SCA.ClientId = C.ClientId 
		Join Screens SC on SCA.ScreenId = SC.ScreenId 
		WHERE 
		( 
			ISNULL(SCA.RecordDeleted,'N')<>'Y' 
			AND ISNULL(S.RecordDeleted,'N')<>'Y' 
			AND ISNULL(C.RecordDeleted,'N')<>'Y' 
			AND ISNULL(SC.RecordDeleted,'N')<>'Y'
			AND SCA.HashValues is Not null 
			AND ((@FromDate IS NULL OR  CONVERT(DATE,SCA.CreatedDate,101)  >= @FromDate) AND   
				(@ToDate IS NULL OR  CONVERT(DATE,SCA.CreatedDate,101) <=@ToDate))
		)
		
		UNION
		select * from #MissingId	

		),
		
		     counts as ( 
    select count(*) as totalrows from ListStaffClientAccess
    ),

RankResultSet
as
		(
SELECT
				StaffClientAccessId, 
				StaffId, 
				ClientId,
				SystemScreenId,
				ScreenId,
				ObjectId,
				ActivityType,
			    TableName,
			    HashValues,
			    StaffName, 
			    ClientName,
				ScreenName, 
				DeletedRecord,         
		 COUNT(*) OVER ( ) AS TotalCount ,
                                    RANK() OVER ( ORDER BY 
                CASE WHEN @SortExpression= 'StaffName'			THEN StaffName END,                                  
				CASE WHEN @SortExpression= 'StaffName DESC'		THEN StaffName END DESC,
				CASE WHEN @SortExpression= 'ClientName'			THEN ClientName END,                                  
				CASE WHEN @SortExpression= 'ClientName DESC'	THEN ClientName END DESC,
				CASE WHEN @SortExpression= 'ScreenName'			THEN ScreenName END,                                            
				CASE WHEN @SortExpression= 'ScreenName DESC'	THEN ScreenName END DESC,
				CASE WHEN @SortExpression= 'ActivityType'			THEN ScreenName END,                                            
				CASE WHEN @SortExpression= 'ActivityType DESC'	THEN ScreenName END DESC,
				StaffClientAccessId
				) AS RowNumber
                           FROM     ListStaffClientAccess
                           )
	                                        
		 SELECT TOP ( Case WHEN (@PageNumber = -1) THEN (SELECT ISNULL(totalrows,0) from counts) ELSE (@PageSize) END)
				StaffClientAccessId,
				StaffId, 
				ClientId,
				SystemScreenId,
				ScreenId,
				ObjectId,
				ActivityType,
			    TableName,
			    HashValues,
			    StaffName, 
			    ClientName,
				ScreenName,
				DeletedRecord,
							TotalCount ,
							RowNumber
					INTO    #FinalResultSet
					FROM    RankResultSet
					WHERE   RowNumber > ( ( @PageNumber - 1 ) * @PageSize ) 
				


			  IF (SELECT     ISNULL(COUNT(*),0) FROM   #FinalResultSet)<1
             BEGIN
                    SELECT 0 AS PageNumber ,
                    0 AS NumberOfPages ,
                    0 NumberOfRows
                  END
             ELSE
		BEGIN                              
			 SELECT TOP 1
						@PageNumber AS PageNumber ,
						CASE (TotalCount % @PageSize) WHEN 0 THEN 
						ISNULL(( TotalCount / @PageSize ), 0)
						ELSE ISNULL(( TotalCount / @PageSize ), 0) + 1 END AS NumberOfPages,
						ISNULL(TotalCount, 0) AS NumberOfRows
				FROM    #FinalResultSet  
				END                       

            SELECT
           StaffClientAccessId, 
				StaffId, 
				ClientId,
				SystemScreenId,
				ScreenId,
				ObjectId,
			    TableName,
			    HashValues,
			    StaffName, 
			    ClientName,
				ScreenName,
				ActivityType,
				DeletedRecord	
            FROM    #FinalResultSet
            ORDER BY StaffClientAccessId
	DROP TABLE #CustomFilters	
	END TRY
	
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_SCStaffClientAccessList')                                                                                             
			+ '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                              
			+ '*****' + CONVERT(VARCHAR,ERROR_STATE())
		RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
	END CATCH
END


GO


