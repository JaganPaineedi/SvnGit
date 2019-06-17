IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPageAuthorizations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCListPageAuthorizations]
GO

CREATE PROC [dbo].[ssp_SCListPageAuthorizations]
(
	 @SessionId VARCHAR(30),                                                                                            
	 @InstanceId int,                                                                                          
	 @PageNumber int,                                                                                               
	 @PageSize int,                                                                                               
	 @SortExpression VARCHAR(100),     
	 @OtherFilter int,
	 @staffId int,
	 @ClientId int,
	 @AuthorizationStatus int,
	 @StartDate datetime,
	 @EndDate datetime,
	 @CoveragePlan int,
	 @AuthorizationCode int,
	 @AuthorizationNumber varchar(35),
	 @Payer int,
	 @PayerTypeId int	 
)               
AS
/********************************************************************************/
-- Stored Procedure: dbo.[ssp_SCListPageAuthorizations]
--                                                                                                             
-- Copyright: Streamline Healthcate Solutions                                                                                                             
--                                                                                                             
-- Purpose:  To fecth the data for the list page of List Page authorization               
--  
--Author: Sudhir Singh
--
--Date: 19 JUN 2012
--                                                                                                           
-- Updates:       
-- Date				Author			Purpose   
/*	July 19,2012	Varinder Verma	Added check of RecordDeleted for 'GlobalCodes' table*/
/*	Dec 11,2012		Manjit Singh	Fix the time-out issue by optimizing the queries	*/
/*	Jan 14 2013		Vikas Kashyap	What:Change Default Order "ClientName,FromDate"	*/
/*									Why:Made Cahnges w.r.t Task#464 Thresholds Merge 3.5x Issues*/
/*  May-09-2013     Jagdeep Hundal  What:Added OR condition A.AuthorizationId=@AuthorizationNumber
                                    Why: To filter data for AuthorizationId  As per task #2989-Thresholds - Bugs/Features (Offshore)  */
/*  May-09-2013     Rahul Aneja     What:Added OR condition with type casting   as Cast(A.AuthorizationId as varchar(max))=cast(@AuthorizationNumber as Varchar(max)) 
                                    Why: To filter data for AuthorizationId  As per task #2989-Thresholds - Bugs/Features (Offshore)  */  
/*  Jan-06-2014      Revathi         what: Added Join with staffclients table to display associated clients for login staff
                                    why:Engineering Improvement Initiatives- NBL(I) task #77 My office List Pages should always have StaffID as an input parameter */
/*  May-18-2015     Arjun K R       Payers and PayerType, these two new filters are added to listpage.Task #97 CEI Environment Issues Tracking            */                                    
/*********************************************************************************/           
BEGIN
	SET NOCOUNT ON;
          
	IF @StartDate = ''
		SET @StartDate = null
	IF @EndDate = ''
		SET @EndDate = null
	  
	--
	--Declare table to get data if Other filter exists -------
	--
	CREATE TABLE #Authorizations
	(
		AuthorizationId INT
	)
	
	--
	--Get custom filters 
	--                                            
	IF @OtherFilter > 10000                    
	BEGIN   
		INSERT INTO #Authorizations                                    
		EXEC scsp_SCListPageAuthorizations @staffId = @staffId,@OtherFilter = @OtherFilter 
	END 
	
	--	                              
	--Insert data in to temp table which is fetched below by appling filter.   
	-- 
	;WITH TotalAuthorizations  AS 
	(         
		SELECT 
			AuthorizationId,
			C.ClientId, 
			ISNULL(C.LastName + ', ','') + C.FirstName AS ClientName,
			CP.DisplayAs AS CoveragePlanName,
			A.AuthorizationDocumentId, 
			AC.AuthorizationCodeName,
			GC.CodeName AS StatusName,
			CASE WHEN A.Status= 4243 THEN  A.StartDate ELSE  A.StartDateRequested END  AS FromDate,  
			CASE  WHEN A.Status =4243 THEN A.EndDate ELSE A.EndDateRequested  END AS  ToDate,
			ISNULL(A.UnitsUsed,0) AS Used,
			ISNULL(A.TotalUnits,0) AS Approved,
			ISNULL(A.TotalUnitsRequested,0) AS Requested,
			A.AuthorizationNumber 
		FROM Authorizations A
		INNER JOIN AuthorizationDocuments AD ON A.AuthorizationDocumentId = AD.AuthorizationDocumentId AND ISNULL(AD.RecordDeleted,'N') = 'N'  
		INNER JOIN AuthorizationCodes AC ON A.AuthorizationCodeId = AC.AuthorizationCodeId AND ISNULL(AC.RecordDeleted,'N') = 'N'  
		LEFT JOIN GlobalCodes GC ON A.[Status] = GC.GlobalCodeId   AND ISNULL(GC.RecordDeleted,'N') = 'N' AND GC.Active='Y'
		INNER JOIN ClientCoveragePlans CCS ON AD.ClientCoveragePlanId = CCS.ClientCoveragePlanId AND ISNULL(CCS.RecordDeleted,'N') = 'N'  AND CCS.ClientId > 0
		INNER JOIN Clients C ON C.ClientId = CCS.ClientId AND ISNULL(C.RecordDeleted,'N') = 'N'
		--Added by Revathi on 06-Jan-2014 for task #77 Engineering Improvement Initiatives- NBL(I)
		INNER JOIN StaffClients sc ON sc.StaffId = @StaffId   AND sc.ClientId = C.ClientId   
		INNER JOIN CoveragePlans CP ON CP.CoveragePlanId = CCS.CoveragePlanId AND ISNULL(CP.RecordDeleted,'N') = 'N' 
		--Added By Arjun K R May-18-2015 
		INNER JOIN Payers F ON (F.PayerId = CP.PayerId) AND ISNULL(F.RecordDeleted,'N')='N'
		WHERE 
				CCS.ClientId = CASE WHEN ISNULL(@ClientId, 0)=0 THEN CCS.ClientId ELSE @ClientId END  
			   AND   
				A.Status = CASE WHEN ISNULL(@AuthorizationStatus,0) =0 THEN A.Status ELSE @AuthorizationStatus END   
			   --AND   
			   -- CAST(CONVERT(VARCHAR(10),A.StartDate,101) AS DATETIME) BETWEEN ISNULL(@StartDate,'01/01/1900')   
			   --  AND ISNULL(@EndDate, CAST(CONVERT(VARCHAR(10),A.EndDate,101) AS DATETIME))  
			   --AND   
			   -- CAST(CONVERT(VARCHAR(10),A.EndDate,101) AS DATETIME) BETWEEN ISNULL(@StartDate,'01/01/1900')   
			   --  AND ISNULL(@EndDate, CAST(CONVERT(VARCHAR(10),A.EndDate,101) AS DATETIME)) 
			   
			   -- Added By Arjun K R May-18-2015 
			   AND (@PayerTypeId = -1 OR F.PayerType = @PayerTypeId)       
	           AND	(@Payer = -1 OR F.PayerId = @Payer)     
	           
			   AND   
				CASE WHEN A.Status= 4243  THEN  A.StartDate WHEN A.StartDateRequested IS NULL THEN A.StartDate   
					ELSE  A.StartDateRequested  END < dateadd(dd, 1, ISNULL(@EndDate,(CASE WHEN A.Status= 4243  THEN  A.StartDate   
									 WHEN A.StartDateRequested IS NULL THEN A.StartDate   
									 ELSE  A.StartDateRequested  END)))                              
			   And   
				ISNULL(CASE WHEN A.Status =4243 THEN A.EndDate WHEN A.EndDateRequested IS NULL THEN A.EndDate   
					ELSE A.EndDateRequested END,ISNULL(@StartDate,'01/01/1900')) >=  ISNULL(@StartDate,'01/01/1900')   
			   AND  
				CCS.CoveragePlanId = CASE WHEN ISNULL(@CoveragePlan,0)=0 THEN CCS.CoveragePlanId ELSE @CoveragePlan END  
			   AND   
				A.AuthorizationCodeId = CASE WHEN ISNULL(@AuthorizationCode,0) = 0 THEN A.AuthorizationCodeId ELSE @AuthorizationCode END  
			   AND   
				( 
				  isnull(A.AuthorizationNumber,'') = CASE WHEN ISNULL(@AuthorizationNumber,'') ='' THEN isnull(A.AuthorizationNumber,'') ELSE @AuthorizationNumber END 
				 Or	
				 --A.AuthorizationId=@AuthorizationNumber  comment by Rahul Aneja and Add new condition as below
				 Cast(A.AuthorizationId as varchar(max))=cast(@AuthorizationNumber as Varchar(max))
				 )
			   AND  
				(NOT Exists(SELECT 'X' FROM #Authorizations) OR A.AuthorizationId IN (SELECT AuthorizationId FROM #Authorizations))  
			      
			   AND ISNULL(A.RecordDeleted,'N') = 'N'   
			  )
		select * INTO #ResultSet From TotalAuthorizations
    
  ;with counts AS   
		( 
			SELECT COUNT(*) AS totalrows FROM #ResultSet
		),            
        ListAuthorizations AS 
        ( 
			Select
				AuthorizationId,
				ClientId, 
				ClientName,
				CoveragePlanName,
				AuthorizationDocumentId, 
				AuthorizationCodeName,
				StatusName,
				FromDate,
				ToDate,
				Used,
				Approved,
				Requested,
				AuthorizationNumber, 
				COUNT(*) OVER ( ) AS TotalCount ,
				ROW_NUMBER() OVER ( ORDER BY CASE WHEN @SortExpression= 'AuthorizationId' THEN  AuthorizationId END,  
						CASE WHEN @SortExpression= 'AuthorizationId desc' THEN  AuthorizationId END DESC,
						CASE WHEN @SortExpression= 'ClientName' THEN  ClientName END,                                                                   
						CASE WHEN @SortExpression= 'ClientName desc' THEN ClientName END DESC ,
						CASE WHEN @SortExpression= 'CoveragePlanName' THEN  CoveragePlanName END,
						CASE WHEN @SortExpression= 'CoveragePlanName desc' THEN CoveragePlanName END DESC ,
						CASE WHEN @SortExpression= 'AuthorizationCodeName' THEN AuthorizationCodeName END ,                                              
						CASE WHEN @SortExpression= 'AuthorizationCodeName desc' THEN AuthorizationCodeName END DESC,
						CASE WHEN @SortExpression= 'StatusName' THEN StatusName END,                                                     
						CASE WHEN @SortExpression= 'StatusName desc' THEN StatusName END DESC,
						CASE WHEN @SortExpression= 'FromDate' THEN FromDate END,                                                     
						CASE WHEN @SortExpression= 'FromDate desc' THEN FromDate END DESC,
						CASE WHEN @SortExpression= 'ToDate' THEN ToDate END,                                                     
						CASE WHEN @SortExpression= 'ToDate desc' THEN ToDate END DESC,
						CASE WHEN @SortExpression= 'Used' THEN Used END,                                                     
						CASE WHEN @SortExpression= 'Used desc' THEN Used END DESC,
						CASE WHEN @SortExpression= 'Approved' THEN Approved END,                                                     
						CASE WHEN @SortExpression= 'Approved desc' THEN Approved END DESC,
						CASE WHEN @SortExpression= 'Requested' THEN Requested END,                                                     
						CASE WHEN @SortExpression= 'Requested desc' THEN Requested END DESC,
						CASE WHEN @SortExpression= 'AuthorizationNumber' THEN AuthorizationNumber END,                                                     
						CASE WHEN @SortExpression= 'AuthorizationNumber desc' THEN AuthorizationNumber END DESC,
						CASE WHEN @SortExpression= 'ClientName,FromDate' THEN ClientName END,
						--CASE WHEN @SortExpression= 'ClientName, ClientId, FromDate' THEN ClientId END,
						CASE WHEN @SortExpression= 'ClientName,FromDate' THEN FromDate END
				)AS RowNumber
				FROM #ResultSet                   
		)
		SELECT TOP ( Case WHEN (@PageNumber = -1) THEN (SELECT ISNULL(totalrows,0) from counts) ELSE (@PageSize) END)
						AuthorizationId,
						ClientId, 
						ClientName,
						CoveragePlanName,
						AuthorizationDocumentId, 
						AuthorizationCodeName,
						StatusName,
						FromDate,
						ToDate,
						Used,
						Approved,
						Requested,
						AuthorizationNumber,
                        TotalCount ,
                        RowNumber
                INTO    #FinalResultSet
                FROM    ListAuthorizations
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
			@PageNumber AS PageNumber,
			CASE (TotalCount % @PageSize) WHEN 0 THEN 
			ISNULL(( TotalCount / @PageSize ), 0)
			ELSE ISNULL(( TotalCount / @PageSize ), 0) + 1 END AS NumberOfPages,
			ISNULL(TotalCount, 0) AS NumberOfRows
			FROM    #FinalResultSet     
		END         
                      
	SELECT        
		AuthorizationId,
		ClientId,  
		ClientName,                
		CoveragePlanName,  
		AuthorizationCodeName,  
		StatusName,
		ISNULL(CONVERT(VARCHAR,FromDate,101),'') AS FromDate,  
		ISNULL(CONVERT(VARCHAR,ToDate,101),'') AS ToDate,   
		Used,  
		Approved,  
		Requested,
		AuthorizationNumber,
		AuthorizationDocumentId
	FROM #FinalResultSet                                  
	ORDER BY RowNumber  
	
	DROP TABLE #FinalResultSet
	DROP Table #Authorizations
	DROP Table #ResultSet 
END
GO




