/****** Object:  StoredProcedure [dbo].[ssp_ListPageAppealDetailsFilter]    Script Date: 9/26/2017 2:19:26 AM ******/
DROP PROCEDURE [dbo].[ssp_ListPageAppealDetailsFilter]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ListPageAppealDetailsFilter]    Script Date: 9/26/2017 2:19:26 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_ListPageAppealDetailsFilter] @OrganizationId INT
	,@ClientId INT
	,@Type INT
	,@FromDate DATETIME
	,@ToDate DATETIME
	,@StatusFilter INT
	,@OtherFilter INT
	,@StaffId INT
	,@StateFilter INT
	/******************************************************************************                                                                  
**  File:                                                                   
**  Name: ssp_ListPageAppealDetailsFilter                                                                  
**  Desc: This storeProcedure will return information regarding AppealsListPage based on filters                                                             
**                                                                                
**  Parameters:                                                                  
**  Input  Filters                                                
                                                                    
**  Output     ----------       -----------                                                                  
**  Appeals Data                                                   
                                                                
**  Auth:  Vikas Vyas                                                              
**  Date:  10 may 2010                                                                
*******************************************************************************                                                                  
**  Change History                                                                  
*******************************************************************************                                                                  
**  Date:				Author:						Description:                                                                  
**  --------			--------							-------------------------------------------                                                                  
**  07 Sep 2010			Jitender Kumar Kamboj		Removed logic of @SessionId,@InstanceId,@PageNumber,@PageSize, @SortExpression    
    29 jan 2013         Suarav Pande                New column added "Date"  w.r.t task #459 in Centra Wellness Customization.
    06-Jan-2014         Revathi                     what: Added join with StaffClients table to display associated Clients for Login staff
                                                    why:Engineering Improvement Initiatives- NBL(I) task #77 My office List Pages should always have StaffID as an input parameter                                  
    16-Oct-2015			Revathi						what:Changed code to display Clients LastName and FirstName when ClientType='I' else  OrganizationName. 
													why:task #609, Network180 Customization  
	14-June-2018        Arjun K R                   DaysLeft in Appeals List Page is calculated based on the value of the key SetDaysRemainingForAppealDueDate.Task #20.1 SWMBH Enhancement.                              
*******************************************************************************/
AS
DECLARE @ResultSet TABLE (
	AppealId INT
	,DateReceived DATETIME
	,[Status] VARCHAR(100)
	,ClientId INT
	,ClientName VARCHAR(100)
	,DaysLeft INT
	,ComplainantName VARCHAR(50)
	,[Type] VARCHAR(250)
	,OrganizationId INT
	,OrganizationName VARCHAR(100)
	,StateFairHearingStatus VARCHAR(100)
	)
DECLARE @CustomFilters TABLE (AppealID INT)
DECLARE @CustomFiltersApplied CHAR(1)

-- Added By Arjun K R 14-June-2018  
DECLARE @SysConfValue VARCHAR(max) 
DECLARE @NumberOfDays INT 
SET @SysConfValue=(SELECT ISNULL([Value],60) FROM SystemConfigurationKeys
				   WHERE [Key]='SetDaysRemainingForAppealDueDate'
				   AND ISNULL(RecordDeleted,'N')='N'
					)
					
SELECT @NumberOfDays=CAST(ISNULL(CASE WHEN ISNUMERIC(@SysConfValue)=0 then 60 ELSE @SysConfValue end,60) as int) 


------------------End--------------------------------------
			
					

SET @CustomFiltersApplied = 'N'

IF @StatusFilter > 10000
	OR @OtherFilter > 10000
	OR @StateFilter > 10000
BEGIN
	SET @CustomFiltersApplied = 'Y'

	INSERT INTO @CustomFilters (AppealID)
	EXEC scsp_ListPageAppealDetailsFilter @OrganizationId = @OrganizationId
		,@ClientId = @ClientId
		,@Type = @Type
		,@FromDate = @FromDate
		,@ToDate = @ToDate
		,@StatusFilter = @StatusFilter
		,@OtherFilter = @OtherFilter
		,@StaffId = @StaffId
		,@StateFilter = @StateFilter
END

BEGIN
	INSERT INTO @ResultSet (
		AppealId
		,DateReceived
		,STATUS
		,ClientId
		,ClientName
		,DaysLeft
		,ComplainantName
		,Type
		,OrganizationId
		,OrganizationName
		,StateFairHearingStatus
		)
	SELECT AppealId
		,Appeals.DateReceived
		,CASE 
			WHEN AppealStatus = 'O'
				THEN 'Open'
			ELSE 'Close'
			END AS [Status]
		,Appeals.[ClientId]
		--Added by Revathi 16-Oct-2015                                                          
		,CASE 
			WHEN ISNULL(Clients.ClientType, 'I') = 'I'
				THEN ISNULL(Clients.LastName, '') + ', ' + ISNULL(Clients.FirstName, '')
			ELSE ISNULL(Clients.OrganizationName, '')
			END
		,@NumberOfDays - DATEDIFF(day, DateReceived, GETDATE())  -- Modified 14-June-2018        Arjun K R
		--Added by Revathi 16-Oct-2015                                                                   
		,CASE 
			WHEN Appeals.ComplainantRelationToClient = 5661
				AND isnull(Appeals.ComplainantName, '') = ''
				THEN CASE 
						WHEN ISNULL(Clients.ClientType, 'I') = 'I'
							THEN ISNULL(Clients.LastName, '') + ', ' + ISNULL(Clients.FirstName, '')
						ELSE ISNULL(Clients.OrganizationName, '')
						END
			ELSE Appeals.ComplainantName
			END AS ComplainantName
		,GC1.CodeName
		,@OrganizationId AS 'OrganizationId'
		,(
			SELECT OrganizationName
			FROM SystemDatabases
			WHERE SystemDatabaseId = @OrganizationId
			) AS 'OrganizationName'
		--,(select Connectionstring from Systemdatabases where systemdatabaseid=@OrganizationId) as 'ConnectionString'                        
		,CASE 
			WHEN StateFairHearingStatus = 'O'
				THEN 'Open'
			WHEN StateFairHearingStatus = 'C'
				THEN 'Close'
			END AS StateFairHearingStatus
	FROM [Appeals]
	LEFT JOIN Clients ON Appeals.ClientId = Clients.ClientId
	--Added by Revathi on 06-Jan-2014 for task #77 Engineering Improvement Initiatives- NBL(I)
	JOIN StaffClients sc ON sc.ClientId = clients.ClientId
		AND sc.StaffId = @StaffId
	LEFT OUTER JOIN GlobalCodes GC1 ON GC1.GlobalCodeId = Appeals.AppealType
	WHERE ISNULL(Clients.RecordDeleted, 'N') <> 'Y'
		AND ISNULL(Appeals.RecordDeleted, 'N') <> 'Y'
		AND (
			@ClientId = 0
			OR Appeals.ClientId = @ClientId
			)
		AND (
			@Type = 419
			OR -- All Type                                                       
			(
				@Type = 420
				AND Appeals.AppealType = 5681
				)
			OR -- Local Appeal                                                    
			(
				@Type = 421
				AND Appeals.AppealType <> 5681
				AND isnull(Appeals.AppealType, '') <> ''
				) -- Venture Appeal                           
			)
		--and (@StatusFilter=10436 or                                                
		--  (@StatusFilter=10435 and Appeals.AppealStatus='C' )                                         
		--  or                                                 
		--  (@StatusFilter=10434 and Appeals.AppealStatus='O')                             
		--)                         
		AND (
			@StatusFilter = 435
			OR (
				@StatusFilter = 434
				AND Appeals.AppealStatus = 'C'
				)
			OR (
				@StatusFilter = 433
				AND Appeals.AppealStatus = 'O'
				)
			)
		AND (
			@StateFilter = 442
			OR (
				@StateFilter = 429
				AND (
					Appeals.StateFairHearingStatus = 'O'
					OR Appeals.StateFairHearingStatus = 'C'
					)
				)
			OR (
				@StateFilter = 444
				AND Appeals.StateFairHearingStatus = 'O'
				)
			OR (
				@StateFilter = 445
				AND Appeals.StateFairHearingStatus = 'C'
				)
			)
		AND (
			@FromDate IS NULL
			OR Appeals.DateReceived >= @FromDate
			)
		AND (
			@ToDate IS NULL
			OR Appeals.DateReceived < dateadd(dd, 1, @ToDate)
			)
END

SELECT AppealId
	,DateReceived
	,Convert(VARCHAR(12), DateReceived, 101) AS 'Date'
	,[Status]
	,ClientId
	,ClientName
	,DaysLeft
	,ComplainantName
	,[Type]
	,StateFairHearingStatus
	,OrganizationId
	,OrganizationName
FROM @ResultSet
ORDER BY DateReceived DESC

RETURN
GO

