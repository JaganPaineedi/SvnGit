/****** Object:  StoredProcedure [dbo].[ssp_ListPageGetTrackingProtocols]    Script Date: 02/09/2018 11:11:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageGetTrackingProtocols]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPageGetTrackingProtocols]
GO


/****** Object:  StoredProcedure [dbo].[ssp_ListPageGetTrackingProtocols]    Script Date: 02/09/2018 11:11:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_ListPageGetTrackingProtocols]   --0, 200, 'ProtocolName', Null, -1,-1,-1, Null   
 @PageNumber     INT,       
 @PageSize       INT,       
 @SortExpression VARCHAR(100),  
 @CreateDate	 DATETIME,
 @FlagTypeId     INT,       
 @ProgramId      INT,       
 @RoleId         INT,  
 @Active		 VARCHAR(2)       
AS       
  /************************************************************************************************                                            
  -- Stored Procedure: dbo.ssp_ListPageGetTrackingProtocols                    
  -- Copyright: Streamline Healthcate Solutions                    
  -- Purpose: Tracking Protocols List Page                  
  -- Updates:                    
  -- Date          Author            Purpose       
  -- Feb 09 2018   Vijay			 What:This ssp is for "Tracking Protocols" list page
									 Why:Engineering Improvement Initiatives- NBL(I) - Task#590
  *************************************************************************************************/      
  BEGIN       
      BEGIN try       
          SET nocount ON;        
CREATE TABLE #TrackingProtocols        
 (        
  TrackingProtocolId  INT        
 )        
                                          
 --Insert data in to temp table which is fetched below by appling filter.                    
    ;WITH TotalProtocols  AS         
 (        
	   SELECT PTD.TrackingProtocolId,      
	   PTD.ProtocolName,      
	   CONVERT(VARCHAR, PTD.StartDate, 101) AS StartDate,      
	   CONVERT(VARCHAR, PTD.EndDate, 101) AS EndDate, 
	   PTD.Active,   
		(SELECT COUNT(*) FROM TrackingProtocolFlags PTF1 where  PTF1.TrackingProtocolId=PTD.TrackingProtocolId AND ISNULL(PTF1.RecordDeleted, 'N') = 'N' ) as FlagCount
	   ,GC.CodeName as CreateProtocolName --CreateProtocol
	   ,(SELECT ISNULL(STUFF((SELECT ', ' + ISNULL(P.ProgramName, '')
			  FROM 
			  TrackingProtocolPrograms PTP 
			  JOIN Programs P ON P.ProgramId=PTP.ProgramId
			  WHERE PTP.TrackingProtocolId=PTD.TrackingProtocolId 
			  AND ISNULL(PTP.RecordDeleted, 'N') = 'N' --AND (PTP.ProgramId = @ProgramId OR @ProgramId = -1)  
			  AND ISNULL(P.RecordDeleted,'N')='N'
			  FOR XML PATH('')
			  ,type ).value('.', 'nvarchar(max)'), 1, 2, ' '), '')) AS Programs
		,(SELECT ISNULL(STUFF((SELECT ', ' + ISNULL(g.CodeName, '')
			  FROM 
			  TrackingProtocolFlagRoles PTFR 
			  JOIN TrackingProtocolFlags PTF on PTFR.TrackingProtocolFlagId=PTF.TrackingProtocolFlagId 
			  LEFT JOIN GlobalCodes g ON g.GlobalCodeId=PTFR.RoleId 
			  WHERE PTD.TrackingProtocolId=PTF.TrackingProtocolId 
			  AND ISNULL(PTFR.RecordDeleted, 'N') = 'N' --AND (PTFR.RoleId = @RoleId OR @RoleId = -1)  
			  AND ISNULL(g.RecordDeleted,'N')='N'
			  FOR XML PATH('')
			  ,type ).value('.', 'nvarchar(max)'), 1, 1, ' '), '')) AS Roles
	   FROM TrackingProtocols PTD      
	   LEFT JOIN TrackingProtocolFlags PTF on PTF.TrackingProtocolId=PTD.TrackingProtocolId AND ISNULL(PTF.RecordDeleted, 'N') = 'N' 
	   LEFT JOIN FlagTypes FT on FT.FlagTypeId=PTF.FlagTypeId AND ISNULL(FT.RecordDeleted, 'N') = 'N'	   
	   LEFT JOIN TrackingProtocolPrograms PTP on PTP.TrackingProtocolId=PTD.TrackingProtocolId AND ISNULL(PTP.RecordDeleted, 'N') = 'N'
	   LEFT JOIN TrackingProtocolFlagRoles PTFR on PTFR.TrackingProtocolFlagId=PTF.TrackingProtocolFlagId AND ISNULL(PTFR.RecordDeleted, 'N') = 'N'
	   INNER JOIN GlobalCodes GC on GC.GlobalCodeId=PTD.CreateProtocol 
	   --INNER JOIN Programs P on P.ProgramId=PTP.ProgramId 
	   --INNER JOIN GlobalCodes g on g.GlobalCodeId=PTFR.RoleId   
	   WHERE (FT.FlagTypeId = @FlagTypeId   OR @FlagTypeId = -1)       
       AND ( ISNULL(PTD.Active,'N') = @Active  OR (@Active is NULL))
       AND (@CreateDate IS NULL OR  (CAST(PTD.CreatedDate AS DATE) < DATEADD(DAY,1,@CreateDate) ))  
       AND (@ProgramId = -1 OR PTP.ProgramId = @ProgramId)
       AND (@RoleId = -1 OR PTFR.RoleId = @RoleId) 
       AND ISNULL(PTD.RecordDeleted,'N')='N'         
  ),        
 counts AS         
 (         
  SELECT COUNT(*) AS totalrows FROM TotalProtocols        
 ),                    
    ListTrackingProtocols AS         
    (         
  SELECT DISTINCT         
    TrackingProtocolId
   ,ProtocolName      
   ,StartDate      
   ,EndDate 
   ,CASE WHEN ISNULL(Active,'N') = 'Y' THEN 'Yes' else 'No' end as Active
   ,FlagCount
   ,CreateProtocolName
   ,Programs
   ,Roles        
   ,COUNT(*) OVER ( ) AS TotalCount ,        
    Rank() OVER ( order by 
           
     case when @SortExpression= 'TrackingProtocolId' then TrackingProtocolId end ,                                       
     case when @SortExpression= 'TrackingProtocolId desc' then TrackingProtocolId end desc,
     case when @SortExpression= 'ProtocolName' then ProtocolName end ,                                       
     case when @SortExpression= 'ProtocolName desc' then ProtocolName end desc,
     case when @SortExpression= 'StartDate' then StartDate end ,                                       
     case when @SortExpression= 'StartDate desc' then StartDate end desc,       
     case when @SortExpression= 'EndDate' then EndDate end ,                                       
     case when @SortExpression= 'EndDate desc' then EndDate end desc,   
     case when @SortExpression= 'Active' then Active end ,                                       
     case when @SortExpression= 'Active desc' then Active end desc,
     case when @SortExpression= 'FlagCount' then FlagCount end ,                                       
     case when @SortExpression= 'FlagCount desc' then FlagCount end desc , 
     case when @SortExpression= 'CreateProtocolName' then CreateProtocolName end ,                                       
     case when @SortExpression= 'CreateProtocolName desc' then CreateProtocolName end desc , 
     case when @SortExpression= 'Programs' then Programs end ,                                       
     case when @SortExpression= 'Programs desc' then Programs end desc ,
     case when @SortExpression= 'Roles' then Roles end ,                                       
     case when @SortExpression= 'Roles desc' then Roles end desc ,       
           
         TrackingProtocolId
            ) as RowNumber        
            FROM TotalProtocols         
    )        
    SELECT TOP ( Case WHEN (@PageNumber = -1) THEN (SELECT ISNULL(totalrows,0) from counts) ELSE (@PageSize) END)
			TrackingProtocolId
		    ,ProtocolName      
		    ,StartDate      
		    ,EndDate 
		    ,Active
		    ,FlagCount
		    ,CreateProtocolName
		    ,Programs
		    ,Roles  
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
    TrackingProtocolId
    ,ProtocolName      
    ,StartDate      
    ,EndDate 
    ,Active
    ,FlagCount
    ,CreateProtocolName
    ,Programs
    ,Roles          
 FROM #FinalResultSet                                          
 ORDER BY RowNumber          
         
END try       
      
    BEGIN catch       
       DECLARE @Error VARCHAR(8000)       
      
        SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'       
                    + CONVERT(VARCHAR(4000), ERROR_MESSAGE())       
                    + '*****'       
                    + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),       
                    'ssp_ListPageGetTrackingProtocols')       
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


