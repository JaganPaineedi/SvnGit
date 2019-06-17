IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCMyOfficeClientNotesList]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCMyOfficeClientNotesList]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCMyOfficeClientNotesList]    Script Date: 13/06/2018 11:11:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_SCMyOfficeClientNotesList]  --'',0,0,200,'NoteTypeName',-1,-1,-1,'Open',2,-1,23389,-1, 0, '06/13/2018',-1
 @SessionId VARCHAR(30)  
 ,@InstanceId INT  
 ,@PageNumber INT  
 ,@PageSize INT  
 ,@SortExpression VARCHAR(100)  
 ,@AssignedTo INT  
 ,@RoleId INT
 ,@FlagTypeId INT
 ,@DueX VARCHAR(50) 
 ,@TrackingProtocolId INT 
 ,@WorkGroup INT
 ,@ClientId INT
 ,@ProgrameId INT 
 ,@StaffId INT
 ,@CreateDate  DATETIME
 --,@StartDate DATETIME  
 --,@NoteType INT  
 ,@OtherFilter INT  
 --,@StaffId INT  
 --,@EndDate DATETIME 
 --,@EndDateFlag INT
 --  --Added by Veena on 05/18/2016   
 --,@WorkGroup INT
 --,@ClientId INT
AS 
/********************************************************************************                                                    
-- Stored Procedure: ssp_SCMyOfficeClientNotesList  
--  
-- Copyright: Streamline Healthcare Solutions  
--  
-- Purpose: Procedure to return data for the Client Notes list page.  
--  
-- Author:  Girish Sanaba  
-- Date:    25 July 2011  
-- Modified: 29 Jan 2014 PPOTNURU Added Active Check condition  
-- 08 Jan 2015  Avi Goyal What : Changed Client NoteType from GlobalCode to FlagTypes  
        Why : Task 600 Security Alerts of Network-180 Customizations  
-- 11 May 2015  Avi Goyal What : Added @Active parameter  
        Why : Task 600.1 Security Alerts - Flags of Network-180 Customizations  
-- 03 December 2015 Manjunath Kondikoppa  What : Added Queries to retrieve First Name  and Last Name of Client. 
										  Why : To Add ClientName field in ClientNote List Page.  
-- 14 Dec 2015 Manjunath K			What : Added RecordDeleted Condition with Clients table.
									Why : Deleted Clients were Showing in ClientNote List Page. For MFS - Customization Issue Tracking 106 & 122
									-- 14 Dec 2015 Manjunath K			What : Added RecordDeleted Condition with Clients table.
									Why : Deleted Clients were Showing in ClientNote List Page. For MFS - Customization Issue Tracking 106 & 122
-- 05 Apr 2016 Venkatesh			What : Added @EndDate and @EndDateFlag parameter .
									Why : As per task Renaissance - Dev Items - #780
-- 06 Apr 2016		Neelima			What : Added convert to the startdate condition
									Why : Camino - Environment Issues Tracking - #1.08
-- 18 May 2016      Veena           What and Why: Adding workGroup EI #340 
-- 06 Apr 2016		Neelima			What : Reverted old changes and modified date condition
									Why : Bradford - Environment Issues Tracking #58
-- 05 31 2016		Pradeep		What: FlagTypes.Active check is added
								Why : Bradford EIT #36
-- 02-06-2016        Pavani		 Changed StartDate and EndDate Logic as pe the Task #69 Bradford EIT
-- 26 April 2018	Vijay		What: Adding Client Tracking changes to My Office - Client Notes list page
								Why : Engineering Improvement Initiatives- NBL(I) - Task#590
-- 27 July 2018		Bibhu			what:Added join with staffclients table to display associated clients for login staff  
          							why:Engineering Improvement Initiatives- NBL(I) task #77 My office List Pages should always have StaffID as an input parameter  
*********************************************************************************/   
BEGIN  
 BEGIN TRY  
  CREATE TABLE #CustomFilters (ClientNoteId INT NOT NULL)  
  
  DECLARE @ApplyFilterClicked CHAR(1)  
  DECLARE @CustomFiltersApplied CHAR(1)  
  DECLARE @EffectiveDate DATETIME  
  DECLARE @Today DATETIME
  SET @Today=GETDATE()   
  
  
 -- IF @StartDate = ''  
 --  SET @EffectiveDate = NULL  
 -- ELSE  
 --  SET @EffectiveDate = @StartDate  
  
 --  IF @EndDate=''  
 --SET @EndDate=NULL  
  
  SET @SortExpression = RTRIM(LTRIM(@SortExpression))  
  
  IF ISNULL(@SortExpression, '') = ''  
   SET @SortExpression = 'NoteTypeName'  
  --   
  -- New retrieve - the request came by clicking on the Apply Filter button                     
  --  
  SET @ApplyFilterClicked = 'Y'  
  SET @CustomFiltersApplied = 'N'  
  
  --SET @PageNumber = 1  
  IF @OtherFilter > 10000  
  BEGIN  
   SET @CustomFiltersApplied = 'Y'  
  
   INSERT INTO #CustomFilters (ClientNoteId)  
   EXEC scsp_SCMyOfficeClientNotesList --@Active = @Active        -- Added by Avi Goyal on 11 May 2015  
    @AssignedTo = @AssignedTo  
    --,@StartDate = @StartDate  
    --,@NoteType = @NoteType 
     --Added by Veena on 05/18/2016   
    ,@WorkGroup=@WorkGroup 
    ,@OtherFilter = @OtherFilter  
    ,@StaffId = @StaffId  
  END  
    --  
    -- User Selections  
    --        
    --ALTER TABLE #CustomFilters ADD  CONSTRAINT [CustomerFilters_PK] PRIMARY KEY CLUSTERED   
    --          (  
    --          [ClientNoteId] ASC  
    --          )   
    ;  
  
  WITH ListPagePMClientNotesList  
  AS (  
   SELECT CN.ClientNoteId  
    ,CN.ClientId
    ,C.LastName + ', ' +C.FirstName  As ClientName
    ,CN.TrackingProtocolId
    ,CN.TrackingProtocolFlagId     
    ,CONVERT(VARCHAR, CN.OpenDate, 101) AS OpenDate 
    ,CONVERT(VARCHAR, CN.DueDate, 101) AS DueDate
    ,DC.DocumentName
    ,DC.DocumentCodeId
    ,St.LastName+' '+St.FirstName as CompletedBy
    ,(SELECT STUFF((SELECT ', ' + GC.CodeName
                FROM GlobalCodes GC
                    INNER JOIN ClientNoteAssignedRoles CNAR ON GC.GlobalCodeId = CNAR.RoleId
                WHERE ISNULL(CNAR.RecordDeleted, 'N') = 'N'
                    AND CNAR.ClientNoteId = CN.ClientNoteId
                    AND ISNULL(GC.RecordDeleted, 'N') = 'N'
                FOR    XML PATH('')
                ,   TYPE).value('.[1]', 'nvarchar(max)'), 1, 2, '') ) as AssignedRoles
                
    ,PTD.ProtocolName AS Protocol  
    ,CN.NoteType AS NoteType
    ,FT.FlagType AS NoteTypeName   
    ,CN.NoteLevel  
    ,GC2.CodeName AS NoteLevelName  
    ,CN.Note  
    ,CONVERT(VARCHAR, CN.StartDate, 101) AS StartDate  
    ,CONVERT(VARCHAR, CN.EndDate, 101) AS EndDate  
    ,CN.CreatedBy  
    ,CN.CreatedDate  
    ,CN.Active  
    ,CN.NoteType AS BitMapId
     ,(SELECT STUFF((SELECT '; ' + S.LastName + ', ' + S.FirstName
                FROM Staff S
                    INNER JOIN ClientNoteAssignedUsers CNAU ON CNAU.StaffId = S.StaffId
                WHERE ISNULL(CNAU.RecordDeleted, 'N') = 'N'
                    AND CNAU.ClientNoteId = CN.ClientNoteId
                    AND ISNULL(S.RecordDeleted, 'N') = 'N'
                FOR    XML PATH('')
                ,   TYPE).value('.[1]', 'nvarchar(max)'), 1, 2, '') ) as AssignedTo
    ,CN.WorkGroup
    ,GC3.CodeName as WorkGroupName
    ,CN.DocumentId
    ,CN.FlagRecurs
   FROM ClientNotes CN  
   LEFT Join Clients C ON C.ClientId=CN.ClientId AND ISNULL(C.RecordDeleted, 'N') = 'N'
   --LEFT JOIN TrackingProtocolFlags PTF ON PTF.TrackingProtocolFlagId = CN.TrackingProtocolFlagId --AND ISNULL(PTF.RecordDeleted, 'N') = 'N'  AND ISNULL(PTF.Active,'Y') = 'Y' 
   LEFT JOIN TrackingProtocols PTD ON PTD.TrackingProtocolId = CN.TrackingProtocolId --AND ISNULL(PTD.RecordDeleted, 'N') = 'N' AND ISNULL(PTD.Active,'Y') = 'Y' 
   --LEFT JOIN FlagTypes FT ON FT.FlagTypeId = PTF.FlagTypeId AND ISNULL(FT.Active,'Y') = 'Y' AND ISNULL(FT.RecordDeleted, 'N') = 'N' 
   LEFT JOIN FlagTypes FT ON FT.FlagTypeId = CN.NoteType --AND ISNULL(FT1.Active,'Y') = 'Y' AND ISNULL(FT1.RecordDeleted, 'N') = 'N' 
   LEFT JOIN GlobalCodes GC2 ON GC2.GlobalCodeId = CN.NoteLevel
   LEFT JOIN GlobalCodes GC3 ON GC3.GlobalCodeId = CN.WorkGroup
   --LEFT JOIN DocumentCodes DC on DC.DocumentCodeId =FT1.DocumentCodeId AND ISNULL(DC.RecordDeleted, 'N') = 'N'
   LEFT JOIN DocumentCodes DC on DC.DocumentCodeId =CN.DocumentCodeId AND ISNULL(DC.RecordDeleted, 'N') = 'N'
   --LEFT JOIN Staff S ON S.StaffId = CN.AssignedTo AND ISNULL(S.RecordDeleted, 'N') = 'N' 
   --LEFT JOIN ClientNoteAssignedRoles CNAR ON CNAR.ClientNoteId = CN.ClientNoteId AND ISNULL(CNAR.RecordDeleted, 'N') = 'N'
   LEFT JOIN Staff St on St.StaffId=CN.CompletedBy
   INNER JOIN StaffClients sc ON sc.StaffId = @StaffId AND sc.ClientId = CN.ClientId -- 27 July 2018		Bibhu
   WHERE (  
     (  
      @CustomFiltersApplied = 'Y'  
      AND EXISTS (  
       SELECT *  
       FROM #CustomFilters cf  
       WHERE cf.ClientNoteId = CN.ClientNoteId  
       )  
      )  
     OR (  
      @CustomFiltersApplied = 'N'  
      AND (  
       @ClientId = - 1
       OR @ClientId  = CN.ClientID
       )   
      AND (  
		 @AssignedTo = - 1  
		 OR EXISTS(SELECT 1 FROM ClientNoteAssignedUsers CNAU WHERE CNAU.ClientNoteId = CN.ClientNoteId AND ISNULL(CNAU.RecordDeleted, 'N') = 'N' AND @AssignedTo = CNAU.StaffId)
       ) 
      AND (  
       @WorkGroup = - 1  
       OR (@WorkGroup = CN.WorkGroup)  
       )
       AND (  
		 @RoleId = - 1  
		 OR EXISTS(SELECT 1 FROM ClientNoteAssignedRoles CNAR WHERE CNAR.ClientNoteId = CN.ClientNoteId AND ISNULL(CNAR.RecordDeleted, 'N') = 'N' AND @RoleId = CNAR.RoleId)
       ) 
      AND (  
       @FlagTypeId = - 1  
       OR (@FlagTypeId = FT.FlagTypeId)  
       )  
     AND (  
       @TrackingProtocolId = - 1  
       OR (@TrackingProtocolId = PTD.TrackingProtocolId)  
       )
     AND (  
       @ProgrameId = - 1  
       OR EXISTS(SELECT 1 FROM TrackingProtocolPrograms PTP WHERE PTP.TrackingProtocolId=PTD.TrackingProtocolId AND ISNULL(PTP.RecordDeleted, 'N') = 'N' AND @ProgrameId = PTP.ProgramId) 
       ) 
	  AND ((@DueX='Open' AND  (CN.OpenDate IS NULL OR  CAST(CN.OpenDate AS DATE) <=  CAST(@CreateDate AS DATE)) AND (CN.EndDate IS NULL OR CAST(@CreateDate AS DATE) < CAST(CN.EndDate AS DATE)))           
          or (@DueX='Started' AND  (CN.StartDate IS NULL OR CAST (CN.StartDate AS DATE)  <= CAST(@CreateDate AS DATE)) AND (CN.EndDate IS NULL OR CAST(@CreateDate AS DATE) < CAST(CN.EndDate AS DATE)))  
          or (@DueX='OverDue' AND (CN.DueDate IS NULL OR CAST(CN.DueDate AS DATE) < CAST(@Today AS DATE)) AND (CN.EndDate IS NULL OR CAST(CN.EndDate AS DATE) > CAST(@Today AS DATE)))                
          or (@DueX='Due in 30 days' AND (CN.DueDate IS NULL OR CAST(CN.DueDate AS DATE) >= CAST(@Today AS DATE)) AND (CN.DueDate IS NULL OR CAST(CN.DueDate AS DATE) <= CAST(DATEADD(d ,30 ,@Today) AS DATE)) AND (CN.EndDate IS NULL OR CAST(CN.EndDate AS DATE) > CAST(@Today AS DATE)))
          or (@DueX='Due in 60-31 days' AND (CN.DueDate IS NULL OR CN.DueDate >= CAST(DATEADD(d ,31 ,@Today) AS DATE)) AND (CN.DueDate IS NULL OR CN.DueDate <= CAST(DATEADD(d ,60 ,@Today) AS DATE)) AND (CN.EndDate IS NULL OR CAST(CN.EndDate AS DATE) > CAST(@Today AS DATE)))
          or (@DueX='Due in 90-61 days' AND (CN.DueDate IS NULL OR CN.DueDate >= CAST(DATEADD(d ,61 ,@Today) AS DATE)) AND (CN.DueDate IS NULL OR CN.DueDate <= CAST(DATEADD(d ,90 ,@Today) AS DATE)) AND (CN.EndDate IS NULL OR CAST(CN.EndDate AS DATE) > CAST(@Today AS DATE)))
          or (@DueX='Completed' AND (CAST(CN.EndDate AS DATE) >= CAST(@CreateDate AS DATE)))
       )
      --AND (  
      -- @EffectiveDate IS NULL  
      -- OR (  
      --  @EffectiveDate >= isnull(CN.StartDate, GETDATE())  
      --  AND @EffectiveDate <= isnull(DATEADD(Day, 1, CN.EndDate), '01/01/2070')  
      --  AND CAST(GETDATE() AS DATE) <= isnull(CN.EndDate, '01/01/2070')  
      --  )  
      -- )  
   --    AND (@EffectiveDate is null or cast(CONVERT(DATE,CN.StartDate,101) as date) >= @EffectiveDate )		 -- Added by Neelima
   --   AND ((@EndDateFlag=0 and (@EndDate IS NULL or cast(CONVERT(DATE,CN.EndDate,101) as date) <=   @EndDate))		 -- Added by Neelima
			--or (@EndDateFlag=1 and CONVERT(DATE,CN.EndDate,101) is null))		
			
			--Pavani 02-06-2016
			 
	  --AND (@EffectiveDate is null or cast(convert(varchar(10),isnull(CN.StartDate,GETDATE()), 101) as date) >= @EffectiveDate )			-- Added by Neelima
   --   AND ((@EndDateFlag=0 and (@EndDate IS NULL or cast(convert(varchar(10),isnull(CN.EndDate, '01/01/2070'), 101) as date) <=   @EndDate)) -- Added by Neelima
			--or (@EndDateFlag=1 and CN.EndDate is null))
			
		--	 AND (@EndDate IS NULL OR CN.StartDate IS NULL OR  CAST(CN.StartDate AS DATE) <= @EndDate)  
  --AND ((@EndDateFlag=0 and (@EffectiveDate IS NULL OR CN.EndDate IS NULL OR  CAST(CN.EndDate AS DATE) >=   @EffectiveDate))  
  -- or (@EndDateFlag=1 and CN.EndDate is null)) 
   
   --End
			
			
			
			
      --AND ISNULL(CN.Active, 'N') = 'Y'  
      AND ISNULL(CN.RecordDeleted, 'N') = 'N'
      -- When Flags are Denied in Staff Details,those should not be display in Client Flag List
      AND ( EXISTS (
				SELECT 1
				FROM viewstaffpermissions V
				WHERE V.permissiontemplatetype = 5928 --Flags
					AND V.permissionitemid = FT.flagtypeid
					AND V.staffid = @StaffId
				)
			OR ISNULL(FT.PermissionedFlag, 'N') = 'N'
			)
      )  
     )  
   )  
   ,counts  
  AS (  
   SELECT count(*) AS totalrows  
   FROM ListPagePMClientNotesList  
   )  
   ,RankResultSet  
  AS (  
   SELECT ClientNoteId  
    ,ClientId
    ,ClientName
    ,TrackingProtocolId
    ,TrackingProtocolFlagId
    ,OpenDate 
    ,DueDate
    ,DocumentName
    ,DocumentCodeId
    ,CompletedBy
    ,AssignedRoles                
    ,Protocol
    ,NoteType  
    ,NoteTypeName  
    ,NoteLevel  
    ,NoteLevelName  
    ,Note  
    ,StartDate  
    ,EndDate  
    ,CreatedBy  
    ,CreatedDate  
    ,Active  
    ,BitMapId  
    ,AssignedTo
    ,WorkGroup
    ,WorkGroupName
    ,DocumentId
    ,FlagRecurs
    
    ,COUNT(*) OVER () AS TotalCount  
    ,RANK() OVER (  
     ORDER BY CASE
       WHEN @SortExpression = 'ClientNoteId'  
        THEN ClientNoteId  
       END  
      ,CASE   
       WHEN @SortExpression = 'ClientNoteId desc'  
        THEN ClientNoteId  
       END DESC     
      ,CASE WHEN @SortExpression = 'ClientId'  
        THEN ClientId  
       END  
      ,CASE   
       WHEN @SortExpression = 'ClientId desc'  
        THEN ClientId  
       END DESC  
      ,CASE 
       WHEN @SortExpression = 'ClientName'  
        THEN ClientName  
       END  
      ,CASE   
       WHEN @SortExpression = 'ClientName desc'  
        THEN ClientName  
       END DESC        
      ,CASE 
       WHEN @SortExpression = 'TrackingProtocolId'  
        THEN TrackingProtocolId  
       END
       ,CASE   
       WHEN @SortExpression = 'TrackingProtocolId desc'  
        THEN TrackingProtocolId  
       END DESC
       ,CASE 
       WHEN @SortExpression = 'TrackingProtocolFlagId'  
        THEN TrackingProtocolFlagId  
       END
       ,CASE   
       WHEN @SortExpression = 'TrackingProtocolFlagId desc'  
        THEN TrackingProtocolFlagId  
       END DESC
      ,CASE 
       WHEN @SortExpression = 'OpenDate'  
        THEN OpenDate  
       END  
      ,CASE   
       WHEN @SortExpression = 'OpenDate desc'  
        THEN OpenDate  
       END DESC
      ,CASE 
       WHEN @SortExpression = 'DueDate'  
        THEN DueDate  
       END  
      ,CASE   
       WHEN @SortExpression = 'DueDate desc'  
        THEN DueDate  
       END DESC       
      ,CASE 
       WHEN @SortExpression = 'DocumentName'  
        THEN DocumentName  
       END  
      ,CASE   
       WHEN @SortExpression = 'DocumentName desc'  
        THEN DocumentName  
       END DESC       
      ,CASE 
       WHEN @SortExpression = 'DocumentCodeId'  
        THEN DocumentCodeId  
       END 
      ,CASE   
       WHEN @SortExpression = 'DocumentCodeId desc'  
        THEN DocumentCodeId  
       END DESC
      ,CASE 
       WHEN @SortExpression = 'CompletedBy'  
        THEN CompletedBy  
       END  
      ,CASE   
       WHEN @SortExpression = 'CompletedBy desc'  
        THEN CompletedBy  
       END DESC
      ,CASE 
       WHEN @SortExpression = 'AssignedRoles'  
        THEN AssignedRoles  
       END  
      ,CASE   
       WHEN @SortExpression = 'AssignedRoles desc'  
        THEN AssignedRoles  
       END DESC
      ,CASE 
       WHEN @SortExpression = 'Protocol'  
        THEN Protocol  
       END  
      ,CASE   
       WHEN @SortExpression = 'Protocol desc'  
        THEN Protocol  
       END DESC
      ,CASE   
       WHEN @SortExpression = 'NoteTypeName'  
        THEN NoteTypeName  
       END  
      ,CASE   
       WHEN @SortExpression = 'NoteTypeName desc'  
        THEN NoteTypeName  
       END DESC  
      ,CASE   
       WHEN @SortExpression = 'NoteLevelName'  
        THEN NoteLevelName  
       END  
      ,CASE   
       WHEN @SortExpression = 'NoteLevelName desc'  
        THEN NoteLevelName  
       END DESC  
      ,CASE   
       WHEN @SortExpression = 'Note'  
        THEN Note  
       END  
      ,CASE   
       WHEN @SortExpression = 'Note desc'  
        THEN Note  
       END DESC  
      ,CASE   
       WHEN @SortExpression = 'StartDate'  
        THEN StartDate  
       END  
      ,CASE   
       WHEN @SortExpression = 'StartDate desc'  
        THEN StartDate  
       END DESC  
      ,CASE   
       WHEN @SortExpression = 'EndDate'  
        THEN EndDate  
       END  
      ,CASE   
       WHEN @SortExpression = 'EndDate desc'  
        THEN EndDate  
       END DESC  
      ,CASE   
       WHEN @SortExpression = 'AssignedTo'  
        THEN AssignedTo  
       END  
      ,CASE   
       WHEN @SortExpression = 'AssignedTo desc'  
        THEN AssignedTo  
       END DESC 
        ,CASE
       WHEN @SortExpression = 'WorkGroup'  
        THEN WorkGroup  
       END  
      ,CASE   
       WHEN @SortExpression = 'WorkGroup desc'  
        THEN WorkGroup  
       END DESC  
      ,ClientNoteId  
     ) AS RowNumber  
   FROM ListPagePMClientNotesList  
   )  
  SELECT TOP (  
    CASE   
     WHEN (@PageNumber = - 1)  
      THEN (  
        SELECT ISNULL(totalrows, 0)  
        FROM counts  
        )  
     ELSE (@PageSize)  
     END  
    ) ClientNoteId  
   ,ClientId
   ,ClientName
   ,TrackingProtocolId
   ,TrackingProtocolFlagId
   ,OpenDate 
   ,DueDate
   ,DocumentName
   ,DocumentCodeId
   ,CompletedBy
   ,AssignedRoles                
   ,Protocol
   ,NoteType  
   ,NoteTypeName  
   ,NoteLevel  
   ,NoteLevelName  
   ,Note  
   ,StartDate  
   ,EndDate  
   ,CreatedBy  
   ,CreatedDate  
   ,Active  
   ,BitMapId  
   ,TotalCount  
   ,RowNumber  
   ,AssignedTo
   ,WorkGroup
   ,WorkGroupName
   ,DocumentId
   ,FlagRecurs
  INTO #FinalResultSet  
  FROM RankResultSet  
  WHERE RowNumber > ((@PageNumber - 1) * @PageSize)  
  
  IF (  
    SELECT ISNULL(COUNT(*), 0)  
    FROM #FinalResultSet  
    ) < 1  
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
  
  SELECT ClientNoteId  
   ,ClientId
   ,ClientName
   ,TrackingProtocolId
   ,TrackingProtocolFlagId
   ,OpenDate 
   ,DueDate
   ,DocumentName
   ,DocumentCodeId
   ,CompletedBy
   ,AssignedRoles                
   ,Protocol   
   ,NoteType  
   ,NoteTypeName  
   ,NoteLevel  
   ,NoteLevelName  
   ,Note  
   ,StartDate  
   ,EndDate  
   ,CreatedBy  
   ,CreatedDate  
   ,Active  
   ,BitMapId  
   ,AssignedTo
   ,WorkGroup
   ,WorkGroupName
   ,DocumentId
   ,FlagRecurs
  
  FROM #FinalResultSet  
  ORDER BY RowNumber  
  
  DROP TABLE #CustomFilters  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCMyOfficeClientNotesList') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.  
    16  
    ,-- Severity.  
    1 -- State.  
    );  
 END CATCH  
END  
