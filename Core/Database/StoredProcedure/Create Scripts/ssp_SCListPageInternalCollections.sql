/****** Object:  StoredProcedure [dbo].[ssp_SCListPageInternalCollections]    Script Date: 08/11/2015 16:35:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCListPageInternalCollections]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCListPageInternalCollections]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCListPageInternalCollections]    Script Date: 08/11/2015 16:35:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_SCListPageInternalCollections] 
	@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@FromDate DATETIME
	,@ToDate DATETIME
	,@AmountDue DECIMAL(18,2)
	,@ProgramFilter INT
	,@ActivePaymentArrangement CHAR(1)
	,@Delinquent CHAR(1)
	,@ClientFlaggedNoServices CHAR(1)	
	,@ProgramViewFilter INT
	,@Status INT
	,@ClientName VARCHAR(100)
	,@ClientId INT
	,@StaffId INT	
	,@OtherFilter INT
	,@ClientActive CHAR(1)='Y'
/********************************************************************************                                                          
-- Stored Procedure: ssp_SCListPageInternalCollections        
--        
-- Copyright: Streamline Healthcate Solutions        
--        
-- Purpose: To display cliets data in internal collections     
--        
-- Author:  Vamsi.N        
-- Date:    02/27/2015        
-- Date              Author                  Purpose                   
-- 27-Aug-2015		 Akwinass				 Modified based on latest requirement(Task #936 in Valley - Customizations) 
-- 01-Nov-2015		 Manjunath K             What:Added Condition in where for filtering ProgramView.
											 Why :Clients who were not part of those programs were displaying.
-- 11-Dec-2015		 Venkatesh				 Get one more value BalanceAmountToReachResolution and PaymentFrequency also add one more parameter Active or not. ref Task 936.2 in Valley Customization
31-DEC-2015  Basudev Sahu Modified For Task #609 Network180 Customization to  Get Organisation  As ClientName	
27-April-2017       Sachin                   Added 	ChargesBalance Column do display sum of Balance charges in Internal Collection
											 List Page. Task : Renaissance - Dev Items #830.2
27-July-2018		Bibhu					 what:Added join with staffclients table to display associated clients for login staff  
          									 why:Engineering Improvement Initiatives- NBL(I) task #77 My office List Pages should always have StaffID as an input parameter  
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @CustomFiltersApplied CHAR(1) = 'N'

		
		SET @SortExpression = RTRIM(LTRIM(@SortExpression))  

   
  IF ISNULL(@SortExpression, '') = ''  
   SET @SortExpression = 'ClientName DESC'  

	--        
	--Declare table to get data if Other filter exists -------        
	--        
		CREATE TABLE #Collections (ClientId INT NOT NULL)
        
    CREATE TABLE #TotalInternalCollections (
	CollectionId INT
	,ClientId INT
	,ClientName  VARCHAR(250) 
	,EnteredDate DATETIME
	,ClientBalance DECIMAL(18,2) 
	,[Status]    VARCHAR(MAX) 
	,StatusDate	 DATETIME
	,LastContactDate      DATETIME
	,LastContactDateId  INT
	, NextContactDate  DATETIME  
	,NextContactDateId INT
	,Delinquent  VARCHAR(100)
	,LastPaymentDate DATETIME
	,LastPaymentAmount  DECIMAL(18,2) 
	--,PaymentPlanAmount DECIMAL(18,2) 
	,PaymentPlanAmount Varchar(100) 
	,PrimaryClinician VARCHAR(250)
	,PrimaryProgram VARCHAR(250)
	,BalanceAmountToReachResolution DECIMAL(18,2)
	,ChargesBalance  DECIMAL(18,2)  
 ) 
		-- --        
		-- --Get custom filters         
		-- --                                                    
		IF @OtherFilter > 10000
		BEGIN
			IF OBJECT_ID('dbo.scsp_SCListPageInternalCollections', 'P') IS NOT NULL
			BEGIN
				SET @CustomFiltersApplied = 'Y'

				INSERT INTO #Collections (ClientId)
				EXEC scsp_SCListPageInternalCollections @ProgramFilter = @ProgramFilter
					,@ProgramViewFilter = @ProgramViewFilter
					,@StaffId = @StaffId
					,@ClientId = @ClientId
					,@OtherFilter = @OtherFilter
					,@ClientName = @ClientName
					,@FromDate = @FromDate
					,@ToDate = @ToDate
					,@Status = @Status
			END
		END
				-- --                                       
				-- --Insert data in to temp table which is fetched below by appling filter.           
				-- --          
  ;with TempInternalCollection AS
  (
   SELECT DISTINCT IC.CollectionId
				,c.ClientId
				,CASE     
			WHEN ISNULL(C.ClientType, 'I') = 'I'
			THEN ISNULL(C.LastName,'') + ',' + + ' ' + ISNULL(C.FirstName,'') + '(' + CONVERT(VARCHAR, C.ClientId) + ')'
				ELSE ISNULL(C.OrganizationName, '') + '(' + CONVERT(VARCHAR, C.ClientId) + ')'
				END AS ClientName
				--C.LastName + ',' + + ' ' + C.FirstName + '(' + CONVERT(VARCHAR, C.ClientId) + ')' AS ClientName
				,IC.CreatedDate AS EnteredDate
				,CASE WHEN C.CurrentBalance IS NULL THEN 0.00 ELSE C.CurrentBalance END ClientBalance
				,dbo.GetGlobalCodeName(IC.[CollectionStatus]) AS [Status]
				, ROW_NUMBER()OVER (Partition by IC.CollectionId Order by C.ClientId,CSH.CreatedDate desc, CCN.ContactDateTime DESC ,CCN1.ContactDateTime DESC,Py.DateReceived DESC,CP.ModifiedDate DESC  ) as ROW
				,CSH.CreatedDate as StatusDate
				, CCN.ContactDateTime    AS LastContactDate
				,CCN.ClientContactNoteId AS LastContactDateId
				,  CCN1.ContactDateTime AS NextContactDate
				, CCN1.ClientContactNoteId  as NextContactDateId
				,CASE WHEN ISNULL(IC.PaymentArrangementDelinquent,'N') = 'N' THEN 'No' ELSe 'Yes' END Delinquent
				,py.DateReceived AS LastPaymentDate
				,Py.Amount   AS LastPaymentAmount
				,(CAST(Ic.PaymentPlanAmount AS VARCHAR(100)) + ' (' + dbo.ssf_GetGlobalCodeNameById(IC.PaymentFrequency) + ')') AS PaymentPlanAmount
				,s.LastName + ', ' + s.FirstName AS PrimaryClinician
				 ,P.ProgramCode as PrimaryProgram
				 ,IC.BalanceAmountToReachResolution
			FROM Collections  IC		
			LEFT JOIN  Clients AS c ON IC.ClientId = c.ClientId 	AND ISNULL(c.RecordDeleted, 'N') = 'N'	 	
			LEFT JOIN ClientPrograms AS cp ON cp.ClientId = C.ClientId AND ISNULL(cp.RecordDeleted, 'N') = 'N'
			LEFT JOIN Programs p ON cp.ProgramId = p.ProgramId AND ISNULL(p.RecordDeleted, 'N') = 'N' AND ISNULL(p.Active, 'N') = 'Y'
			LEFT JOIN Staff AS s ON s.StaffId = C.PrimaryClinicianId AND ISNULL(s.RecordDeleted, 'N') = 'N'
			INNER JOIN StaffClients sc ON sc.StaffId = @StaffId AND   sc.ClientId = C.ClientId 		------27-July-2018		Bibhu
			LEFT JOIN CollectionStatusHistory  CSH	ON  CSH.CollectionId = IC.CollectionId     AND ISNULL(CSH.RecordDeleted, 'N') = 'N'  
			LEFT JOIN  ClientContactNotes CCN    ON C.ClientId = CCN.ClientId    AND ISNULL(CCN.RecordDeleted, 'N') = 'N'  AND CCN.ContactStatus IN (371)  
			LEFT JOIN  ClientContactNotes CCN1    ON C.ClientId = CCN1.ClientId    AND ISNULL(CCN1.RecordDeleted, 'N') = 'N' AND CCN1.ContactStatus IN (370)  
			 AND CAST(CCN1.ContactDateTime AS DATE) >= CAST(GETDATE() AS DATE)
			LEFT JOIN Payments Py ON Py.ClientId = C.ClientId   AND ISNULL(P.RecordDeleted, 'N') = 'N'  
			WHERE ((@CustomFiltersApplied = 'Y' AND EXISTS (SELECT * FROM #Collections cf WHERE cf.ClientId = c.ClientId))
					OR (@CustomFiltersApplied = 'N'
			AND (c.ClientId = @ClientId OR @ClientId = 0)
			AND ((cp.[Status] = 4 AND p.ProgramId = @ProgramFilter) OR @ProgramFilter = 0)
			AND (ISNULL(@ProgramViewFilter, 0) = 0 OR (cp.[Status] = 4 AND EXISTS (SELECT 1 FROM ProgramViewPrograms PV WHERE PV.ProgramViewId = @ProgramViewFilter AND PV.ProgramId = CP.ProgramId AND ISNULL(RecordDeleted, 'N') = 'N')))    
			AND (ISNULL(@ClientName, '') = '' OR C.LastName LIKE '%' + @ClientName + '%' OR C.FirstName LIKE '%' + @ClientName + '%' OR C.LastName + ',' + C.FirstName LIKE '%' + @ClientName + '%' OR C.LastName + C.FirstName LIKE '%' + @ClientName + '%')
			AND (IC.[CollectionStatus] = @Status OR @Status = 0)
			AND (@AmountDue IS NULL OR CAST(ISNULL([dbo].[ssf_SCGetPossibleCollections]('AmountDue',C.ClientId,NULL), 0) AS MONEY) > CAST(@AmountDue AS MONEY))
			AND (( @FromDate IS NULL OR CAST( IC.CreatedDate AS DATE) >= @FromDate  ) AND (@ToDate IS NULL OR CAST( IC.CreatedDate AS DATE) <= @ToDate))
			AND (@ActivePaymentArrangement IS NULL OR IC.PaymentArrangementActive = @ActivePaymentArrangement)
			AND (@Delinquent IS NULL OR IC.PaymentArrangementDelinquent = @Delinquent)
			AND (@ClientFlaggedNoServices IS NULL OR IC.ClientNotReceiveServices = @ClientFlaggedNoServices)
			AND ISNULL(IC.RecordDeleted, 'N') = 'N')
			AND C.Active=ISNULL(@ClientActive,'Y')
  ) )
INSERT INTO  #TotalInternalCollections(
CollectionId
,ClientId 
,ClientName 
,EnteredDate
,ClientBalance
,[Status]   
,StatusDate	
,LastContactDate 
,LastContactDateId  
, NextContactDate 
,NextContactDateId 
,Delinquent 
,LastPaymentDate 
,LastPaymentAmount   
,PaymentPlanAmount 
,PrimaryClinician 
,PrimaryProgram
,BalanceAmountToReachResolution
)
SELECT
T.CollectionId
,T.ClientId 
,T.ClientName 
,T.EnteredDate
,T.ClientBalance
,T.[Status]   
,T.StatusDate	
,T.LastContactDate 
,T.LastContactDateId  
,T.NextContactDate 
,T.NextContactDateId 
,T.Delinquent 
,T.LastPaymentDate 
,T.LastPaymentAmount   
,T.PaymentPlanAmount 
,T.PrimaryClinician 
,T.PrimaryProgram
,T.BalanceAmountToReachResolution
FROM TempInternalCollection  T WHERE 
  T.ROW=1    

  UPDATE T     
  SET T.ChargesBalance=c.SumBalance    
  From #TotalInternalCollections T Join (    
  select CL.CollectionId ,sum(OPC.Balance) AS SumBalance from SERVICES S    
  JOIN Charges C ON S.ServiceId=c.ServiceId    
  JOIN OpenCharges OPC ON OPC.Chargeid=C.Chargeid    
  JOIN InternalCollectionCharges CCH ON C.ChargeId = CCH.ChargeId AND ISNULL(CCH.RecordDeleted,'N') = 'N'    
  JOIN Collections CL ON CCH.CollectionId = CL.CollectionId   
  WHERE ISNULL(S.RecordDeleted, 'N') = 'N' AND ISNULL(C.RecordDeleted, 'N') = 'N'     
  AND ISNULL(OPC.RecordDeleted, 'N') = 'N'  AND (S.ClientId = @ClientId OR @ClientId = 0)    
  Group by CL.CollectionId ) C ON T.CollectionId=c.CollectionId    

IF @PageNumber = - 1
   BEGIN
    SET  @PageSize=(SELECT COUNT(*) AS totalrows  
			 FROM #TotalInternalCollections )
			 
END		
    -- --                                         
    -- --Insert data in to temp table which is fetched below by appling filter.             
    -- --            
  
 
   ; WITH InternalCollections  
  AS (  
   SELECT CollectionId,
   ClientId  
    ,ClientName  
    ,EnteredDate  
    ,[Status]  
    ,StatusDate  
    ,LastContactDate  
    ,NextContactDate  
    ,Delinquent  
    ,LastPaymentAmount  
    ,PaymentPlanAmount  
    ,ClientBalance  
    ,LastPaymentDate  
    ,PrimaryClinician  
    ,PrimaryProgram     
    ,BalanceAmountToReachResolution
    ,ChargesBalance  -- Added Sachin
    ,LastContactDateId  
    ,NextContactDateId        
    ,COUNT(*) OVER () AS TotalCount  
    ,ROW_NUMBER() OVER (  
	ORDER BY CASE WHEN @SortExpression = 'ClientName'	THEN ClientName		END
			,CASE WHEN @SortExpression = 'ClientName DESC'	THEN ClientName	END DESC
						,CASE WHEN @SortExpression = 'EnteredDate' THEN EnteredDate	END
						,CASE WHEN @SortExpression = 'EnteredDate DESC'	THEN EnteredDate END DESC
						,CASE WHEN @SortExpression = 'LastPaymentAmount' THEN LastPaymentAmount	END
						,CASE WHEN @SortExpression = 'LastPaymentAmount DESC' THEN LastPaymentAmount END DESC
						,CASE WHEN @SortExpression = 'ClientBalance' THEN ClientBalance END
						,CASE WHEN @SortExpression = 'ClientBalance DESC' THEN ClientBalance END DESC
						,CASE WHEN @SortExpression = 'LastPaymentDate'	THEN LastPaymentDate	END
						,CASE WHEN @SortExpression = 'LastPaymentDate DESC'	THEN LastPaymentDate	END DESC
						,CASE WHEN @SortExpression = 'PaymentPlanAmount'	THEN PaymentPlanAmount	END
						,CASE WHEN @SortExpression = 'PaymentPlanAmount DESC'	THEN PaymentPlanAmount	END DESC
						,CASE WHEN @SortExpression = 'PrimaryClinician'	THEN PrimaryClinician	END
						,CASE WHEN @SortExpression = 'PrimaryClinician DESC' THEN PrimaryClinician	END DESC
						,CASE WHEN @SortExpression = 'PrimaryProgram' THEN PrimaryProgram	END
						,CASE WHEN @SortExpression = 'PrimaryProgram DESC'	THEN PrimaryProgram	END DESC
						,CASE WHEN @SortExpression = 'BalanceAmountToReachResolution'	THEN BalanceAmountToReachResolution	END
						,CASE WHEN @SortExpression = 'BalanceAmountToReachResolution DESC'	THEN BalanceAmountToReachResolution	END DESC
						,CASE WHEN @SortExpression = 'Status' THEN [Status]	END
						,CASE WHEN @SortExpression = 'Status DESC'	THEN [Status]	END DESC
						,CASE WHEN @SortExpression = 'StatusDate' THEN StatusDate	END
						,CASE WHEN @SortExpression = 'StatusDate DESC'	THEN StatusDate	END DESC
						,CASE WHEN @SortExpression = 'LastContactDate' THEN LastContactDate	END
						,CASE WHEN @SortExpression = 'LastContactDate DESC'	THEN LastContactDate	END DESC
						,CASE WHEN @SortExpression = 'NextContactDate' THEN NextContactDate	END
						,CASE WHEN @SortExpression = 'NextContactDate DESC'	THEN NextContactDate	END DESC
						,CASE WHEN @SortExpression = 'Delinquent' THEN Delinquent	END
						,CASE WHEN @SortExpression = 'Delinquent DESC'	THEN Delinquent	END DESC
						
						,CASE WHEN @SortExpression = 'ChargesBalance' THEN ChargesBalance END  
					    ,CASE WHEN @SortExpression = 'ChargesBalance DESC' THEN ChargesBalance END DESC 
       ,CollectionId
     ) AS RowNumber  
   FROM #TotalInternalCollections  
   )  
  SELECT TOP 
      (@PageSize)
    CollectionId, 
    ClientId  
   ,ClientName  
   ,CONVERT(VARCHAR,EnteredDate,101) as  EnteredDate 
   ,[Status]  
   ,CONVERT(VARCHAR,StatusDate,101) AS StatusDate
   ,CONVERT(VARCHAR,LastContactDate,101) AS  LastContactDate
   ,CONVERT(VARCHAR,NextContactDate  ,101) AS NextContactDate
   ,Delinquent  
   ,'$ ' + CAST(LastPaymentAmount AS VARCHAR) AS LastPaymentAmount
   ,'$ ' + CAST(PaymentPlanAmount AS VARCHAR) AS PaymentPlanAmount   
   ,'$ ' + CAST(ClientBalance AS VARCHAR) AS ClientBalance      
   ,CONVERT(VARCHAR,LastPaymentDate  ,101) AS LastPaymentDate   
   ,PrimaryClinician  
   ,PrimaryProgram 
   ,'$ ' + CAST(BalanceAmountToReachResolution AS VARCHAR) AS BalanceAmountToReachResolution  
   
   ,'$'+ case when ChargesBalance  > 0 then  cast(ChargesBalance as varchar)
							when ChargesBalance  < 0 then  '(' +cast(ChargesBalance AS varchar)+')'
			                end AS ChargesBalance -- Sachin   
   ,LastContactDateId  
   ,NextContactDateId  
   ,TotalCount  
   ,RowNumber  
  INTO #FinalResultSet  
  FROM InternalCollections  
  WHERE RowNumber > ((@PageNumber - 1) * @PageSize)  
  
    

    
  IF (SELECT ISNULL(COUNT(*), 0) FROM #FinalResultSet) < 1  
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
  
  SELECT CollectionId,
	ClientId  
   ,ClientName  
   ,EnteredDate  
   ,ClientBalance  
   ,[Status]  
   ,StatusDate  
   ,LastContactDate  
   ,NextContactDate  
   ,Delinquent  
   ,LastPaymentDate  
   ,LastPaymentAmount  
   ,PaymentPlanAmount     
   ,PrimaryClinician  
   ,PrimaryProgram 
   ,BalanceAmountToReachResolution  
  -- ,'$'+cast(CAST(ISNULL(ChargesBalance,0) as decimal(18,2)) as varchar) AS ChargesBalance  -- Sachin
   ,'$'+ CAST(ISNULL(ChargesBalance,0) as VARCHAR)AS ChargesBalance  -- Sachin  
   ,LastContactDateId  
   ,NextContactDateId        
  FROM #FinalResultSet  
  ORDER BY RowNumber  
  
END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCListPageInternalCollections') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


