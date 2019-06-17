/****** Object:  StoredProcedure [dbo].[ssp_ListPageGetClientTracking]    Script Date: 02/09/2018 11:11:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageGetClientTracking]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ssp_ListPageGetClientTracking]
GO


/****** Object:  StoredProcedure [dbo].[ssp_ListPageGetClientTracking]    Script Date: 02/09/2018 11:11:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_ListPageGetClientTracking] --0, 200, 'ProtocolName', 1001076, -1, -1, 'Open', '09/02/2018', -1, -1, 550
 @PageNumber     INT,       
 @PageSize       INT,       
 @SortExpression VARCHAR(100),
 @ClientId		 INT,  
 @AssignedTo	 INT,
 @RoleId         INT,
 @DueX			 VARCHAR(50),
 @CreateDate	 DATETIME,
 @TrackingProtocolId  INT,
 @WorkGroup      INT,
 @StaffId		 INT     
AS       
  /************************************************************************************************                                            
  -- Stored Procedure: dbo.ssp_ListPageGetClientTracking                    
  -- Copyright: Streamline Healthcate Solutions                    
  -- Purpose: Client Tracking List Page                  
  -- Updates:                    
  -- Date          Author            Purpose       
  -- July 10 2018   Vijay			 Why:This ssp is for Client Tracking List Page 
									 What:Engineering Improvement Initiatives- NBL(I) - Task#590
  *************************************************************************************************/      
  BEGIN       
      BEGIN try       
          SET nocount ON;        
             
  DECLARE @Today DATETIME
  SET @Today=GETDATE()
 --Insert data in to temp table which is fetched below by appling filter.                    
    ;WITH TotalProtocols  AS         
 (        
	   SELECT CN.ClientNoteId,
	   CN.ClientId,
	   CN.TrackingProtocolId,
	   CN.TrackingProtocolFlagId,      
	   FT.FlagType AS FlagType, 
	   CN.NoteType AS FlagTypeId,
	   (SELECT STUFF((SELECT ', ' + S.LastName+' '+S.FirstName 
                                    FROM Staff S
                                        INNER JOIN ClientNoteAssignedUsers CNAU ON CNAU.StaffId = S.StaffId 
                                    WHERE ISNULL(CNAU.RecordDeleted, 'N') = 'N'
                                        AND CNAU.ClientNoteId=CN.ClientNoteId
                                        --AND ISNULL(S.RecordDeleted, 'N') = 'N'
                                    FOR    XML PATH('')
                                    ,   TYPE).value('.[1]', 'nvarchar(max)'), 1, 2, '') ) as AssignedStaff,
	   CONVERT(VARCHAR, CN.OpenDate, 101) as OpenDate,
	   CONVERT(VARCHAR, CN.StartDate, 101) as StartDate,
	   CONVERT(VARCHAR, CN.DueDate, 101) as DueDate, 
	   DC.DocumentName AS LinkTo,
       DC.DocumentCodeId,
	   CONVERT(VARCHAR, CN.EndDate, 101) as CompletedDate,
	   St.LastName+' '+St.FirstName as CompletedBy,
	   CN.Note as NoteField,
	   (SELECT STUFF((SELECT ', ' + GC1.CodeName 
                                    FROM GlobalCodes GC1
                                        INNER JOIN ClientNoteAssignedRoles CNAR ON GC1.GlobalCodeId=CNAR.RoleId
                                    WHERE ISNULL(CNAR.RecordDeleted, 'N') = 'N'
                                        AND CNAR.ClientNoteId=CN.ClientNoteId
                                        AND ISNULL(GC1.RecordDeleted, 'N') = 'N'
                                    FOR    XML PATH('')
                                    ,   TYPE).value('.[1]', 'nvarchar(max)'), 1, 2, '') ) as AssignedRoles,
	   
	   PTD.ProtocolName as ProtocolName,
	   CN.NoteType,
	   CN.NoteLevel,
	   CN.CreatedBy,
	   CASE WHEN CN.DocumentId IS NOT NULL THEN CN.DocumentId			
			ELSE 0
          END AS DocumentId,
	   CONVERT(VARCHAR, PTD.CreatedDate, 101) as ProtocolCreatedDate,
	   CN.FlagRecurs
	   FROM ClientNotes CN	   
	   --LEFT JOIN TrackingProtocolFlags PTF ON PTF.TrackingProtocolFlagId = CN.TrackingProtocolFlagId  AND ISNULL(PTF.RecordDeleted, 'N') = 'N' --AND ISNULL(PTF.Active,'Y') = 'Y' 
	   LEFT JOIN TrackingProtocols PTD ON PTD.TrackingProtocolId = CN.TrackingProtocolId --AND ISNULL(PTD.RecordDeleted, 'N') = 'N' AND ISNULL(PTD.Active,'Y') = 'Y' 
       --LEFT JOIN FlagTypes FT ON FT.FlagTypeId = PTF.FlagTypeId AND ISNULL(FT.Active,'Y') = 'Y' --AND ISNULL(FT.RecordDeleted, 'N') = 'N' 
       LEFT JOIN FlagTypes FT ON FT.FlagTypeId = CN.NoteType --AND ISNULL(FT1.Active,'Y') = 'Y' AND ISNULL(FT1.RecordDeleted, 'N') = 'N' 
	   --LEFT JOIN DocumentCodes DC on DC.DocumentCodeId =FT1.DocumentCodeId 
	   LEFT JOIN DocumentCodes DC on DC.DocumentCodeId =CN.DocumentCodeId
	   LEFT JOIN Staff St on St.StaffId=CN.CompletedBy
	   WHERE CN.ClientId = @ClientId AND CN.Active='Y'
	   AND (PTD.TrackingProtocolId = @TrackingProtocolId OR @TrackingProtocolId = -1)
	   AND (CN.WorkGroup = @WorkGroup  OR @WorkGroup = -1)  
	   AND (  
		 @AssignedTo = - 1  
		 OR EXISTS(SELECT 1 FROM ClientNoteAssignedUsers CNAU WHERE CNAU.ClientNoteId = CN.ClientNoteId AND ISNULL(CNAU.RecordDeleted, 'N') = 'N' AND @AssignedTo = CNAU.StaffId)
       )
        AND (  
		 @RoleId = - 1  
		 OR EXISTS(SELECT 1 FROM ClientNoteAssignedRoles CNAR WHERE CNAR.ClientNoteId = CN.ClientNoteId AND ISNULL(CNAR.RecordDeleted, 'N') = 'N' AND @RoleId = CNAR.RoleId)
       ) 
	   AND ((@DueX='Open' AND  (CN.OpenDate IS NULL OR  CAST(CN.OpenDate AS DATE) <=  CAST(@CreateDate AS DATE)) AND (CN.EndDate IS NULL OR CAST(@CreateDate AS DATE) < CAST(CN.EndDate AS DATE)))           
          or (@DueX='Started' AND  (CN.StartDate IS NULL OR CAST(CN.StartDate AS DATE)  <= CAST(@CreateDate AS DATE)) AND (CN.EndDate IS NULL OR CAST(@CreateDate AS DATE) < CAST(CN.EndDate AS DATE)))  
          or (@DueX='OverDue' AND (CN.DueDate IS NULL OR CAST(CN.DueDate AS DATE) < CAST(@Today AS DATE)) AND (CN.EndDate IS NULL OR CAST(CN.EndDate AS DATE) > CAST(@Today AS DATE)))                
          or (@DueX='Due in 30 days' AND (CN.DueDate IS NULL OR CAST(CN.DueDate AS DATE) >= CAST(@Today AS DATE)) AND (CN.DueDate IS NULL OR CAST(CN.DueDate AS DATE) <= CAST(DATEADD(d ,30 ,@Today) AS DATE)) AND (CN.EndDate IS NULL OR CAST(CN.EndDate AS DATE) > CAST(@Today AS DATE)))
          or (@DueX='Due in 60-31 days' AND (CN.DueDate IS NULL OR CN.DueDate >= CAST(DATEADD(d ,31 ,@Today) AS DATE)) AND (CN.DueDate IS NULL OR CN.DueDate <= CAST(DATEADD(d ,60 ,@Today) AS DATE)) AND (CN.EndDate IS NULL OR CAST(CN.EndDate AS DATE) > CAST(@Today AS DATE)))
          or (@DueX='Due in 90-61 days' AND (CN.DueDate IS NULL OR CN.DueDate >= CAST(DATEADD(d ,61 ,@Today) AS DATE)) AND (CN.DueDate IS NULL OR CN.DueDate <= CAST(DATEADD(d ,90 ,@Today) AS DATE)) AND (CN.EndDate IS NULL OR CAST(CN.EndDate AS DATE) > CAST(@Today AS DATE)))
          or (@DueX='Completed' AND (CAST(CN.EndDate AS DATE) >= CAST(@CreateDate AS DATE)))
       )
       AND ISNULL(CN.RecordDeleted,'N')='N'  
       --AND ISNULL(DC.RecordDeleted,'N')='N'
       -- When Flags are Denied in Staff Details,those should not be display in Client Flag List
       AND ( EXISTS (
				SELECT 1
				FROM viewstaffpermissions V
				WHERE V.permissiontemplatetype = 5928 --Flags
					AND V.permissionitemid = FT.FlagTypeId
					AND V.staffid = @StaffId
				)
			OR ISNULL(FT.PermissionedFlag, 'N') = 'N'
			)
  ),        
 counts AS         
 (         
  SELECT COUNT(*) AS totalrows FROM TotalProtocols        
 ),                    
    ListTrackingProtocols AS         
    (         
  SELECT DISTINCT 
    ClientNoteId
   ,ClientId        
   ,TrackingProtocolId
   ,TrackingProtocolFlagId
   ,FlagType 
   ,FlagTypeId     
   ,AssignedStaff 
   ,OpenDate
   ,StartDate
   ,DueDate
   ,LinkTo
   ,DocumentCodeId
   ,CompletedDate
   ,CompletedBy
   ,NoteField
   ,AssignedRoles
   ,ProtocolName
   ,NoteType
   ,NoteLevel
   ,CreatedBy
   ,DocumentId
   ,ProtocolCreatedDate
   ,FlagRecurs
   ,COUNT(*) OVER ( ) AS TotalCount ,        
    Rank() OVER ( order by 
    
     case when @SortExpression= 'ClientNoteId' then ClientNoteId end ,                                       
     case when @SortExpression= 'ClientNoteId desc' then ClientNoteId end desc,    
     case when @SortExpression= 'ClientId' then ClientId end ,                                       
     case when @SortExpression= 'ClientId desc' then ClientId end desc,     
     case when @SortExpression= 'TrackingProtocolId' then TrackingProtocolId end ,                                       
     case when @SortExpression= 'TrackingProtocolId desc' then TrackingProtocolId end desc,
     case when @SortExpression= 'TrackingProtocolFlagId' then TrackingProtocolFlagId end ,                                       
     case when @SortExpression= 'TrackingProtocolFlagId desc' then TrackingProtocolFlagId end desc,
     case when @SortExpression= 'FlagType' then FlagType end ,                                       
     case when @SortExpression= 'FlagType desc' then FlagType end desc,
     case when @SortExpression= 'FlagTypeId' then FlagTypeId end ,                                       
     case when @SortExpression= 'FlagTypeId desc' then FlagTypeId end desc,
     case when @SortExpression= 'AssignedStaff' then AssignedStaff end ,      
     case when @SortExpression= 'AssignedStaff desc' then AssignedStaff end desc, 
     case when @SortExpression= 'OpenDate' then OpenDate end ,      
     case when @SortExpression= 'OpenDate desc' then OpenDate end desc,      
     case when @SortExpression= 'StartDate' then StartDate end ,                                       
     case when @SortExpression= 'StartDate desc' then StartDate end desc,       
     case when @SortExpression= 'DueDate' then DueDate end ,                                       
     case when @SortExpression= 'DueDate desc' then DueDate end desc,   
     case when @SortExpression= 'LinkTo' then LinkTo end ,                                       
     case when @SortExpression= 'LinkTo desc' then LinkTo end desc,
     case when @SortExpression= 'DocumentCodeId' then DocumentCodeId end ,                                       
     case when @SortExpression= 'DocumentCodeId desc' then DocumentCodeId end desc,     
     case when @SortExpression= 'CompletedDate' then CompletedDate end ,                                       
     case when @SortExpression= 'CompletedDate desc' then CompletedDate end desc , 
     case when @SortExpression= 'CompletedBy' then CompletedBy end ,                                       
     case when @SortExpression= 'CompletedBy desc' then CompletedBy end desc , 
     case when @SortExpression= 'NoteField' then NoteField end ,                                       
     case when @SortExpression= 'NoteField desc' then NoteField end desc ,
     case when @SortExpression= 'AssignedRoles' then AssignedRoles end ,
     case when @SortExpression= 'AssignedRoles desc' then AssignedRoles end desc ,
     case when @SortExpression= 'ProtocolName' then ProtocolName end ,
     case when @SortExpression= 'ProtocolName desc' then ProtocolName end desc ,
     case when @SortExpression= 'NoteType' then NoteType end ,
     case when @SortExpression= 'NoteType desc' then NoteType end desc ,
     case when @SortExpression= 'NoteLevel' then NoteLevel end ,
     case when @SortExpression= 'NoteLevel desc' then NoteLevel end desc ,
     case when @SortExpression= 'CreatedBy' then CreatedBy end ,
     case when @SortExpression= 'CreatedBy desc' then CreatedBy end desc ,
     case when @SortExpression= 'DocumentId' then DocumentId end ,
     case when @SortExpression= 'DocumentId desc' then DocumentId end desc ,
     case when @SortExpression= 'ProtocolCreatedDate' then ProtocolCreatedDate end ,
     case when @SortExpression= 'ProtocolCreatedDate desc' then ProtocolCreatedDate end desc , 
     case when @SortExpression= 'FlagRecurs' then FlagRecurs end ,
     case when @SortExpression= 'FlagRecurs desc' then FlagRecurs end desc ,
           
         ClientNoteId
            ) as RowNumber        
            FROM TotalProtocols         
    )        
    SELECT TOP ( Case WHEN (@PageNumber = -1) THEN (SELECT ISNULL(totalrows,0) from counts) ELSE (@PageSize) END)
			ClientNoteId
			,ClientId
			,TrackingProtocolId
			,TrackingProtocolFlagId
		    ,FlagType  
		    ,FlagTypeId    
		    ,AssignedStaff 
		    ,OpenDate
		    ,StartDate
		    ,DueDate
		    ,LinkTo
		    ,DocumentCodeId
		    ,CompletedDate
		    ,CompletedBy
		    ,NoteField
		    ,AssignedRoles
		    ,ProtocolName
		    ,NoteType
		    ,NoteLevel
		    ,CreatedBy
		    ,DocumentId
		    ,ProtocolCreatedDate
		    ,FlagRecurs
			,TotalCount         
			,RowNumber        
	INTO    #FinalResultSet        
	FROM    ListTrackingProtocols        
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
   ClientNoteId
   ,ClientId
   ,TrackingProtocolId
   ,TrackingProtocolFlagId
   ,FlagType
   ,FlagTypeId     
   ,AssignedStaff 
   ,OpenDate
   ,StartDate
   ,DueDate
   ,LinkTo
   ,DocumentCodeId
   ,CompletedDate
   ,CompletedBy
   ,NoteField
   ,AssignedRoles
   ,ProtocolName
   ,NoteType
   ,NoteLevel
   ,CreatedBy
   ,DocumentId
   ,ProtocolCreatedDate
   ,FlagRecurs
 FROM #FinalResultSet                                          
 ORDER BY RowNumber          
         
 DROP TABLE #FinalResultSet
         
END try       
      
    BEGIN catch       
       DECLARE @Error VARCHAR(8000)       
      
        SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'       
                    + CONVERT(VARCHAR(4000), ERROR_MESSAGE())       
                    + '*****'       
                    + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),       
                    'ssp_ListPageGetClientTracking')       
                    + '*****' + CONVERT(VARCHAR, ERROR_LINE())       
                    + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY())       
                    + '*****' + CONVERT(VARCHAR, ERROR_STATE())       
      
        RAISERROR ( @Error,       
                    -- Message text.                                                                                                                
                    16,       
                    -- Severity.                                                                                                                
                    1       
        -- State.                                                                                                         
        );       
    END catch       
END   

GO
