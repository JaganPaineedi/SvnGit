
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageDocumentAssignment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPageDocumentAssignment]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_ListPageDocumentAssignment]    
 @PageNumber     INT,     
 @PageSize       INT,     
 @SortExpression VARCHAR(100),  
 @PacketName         INT,
 @PacketType         INT,  
 @Status		 INT,      
 @OtherFilter    INT     
AS     
  /************************************************************************************************                                    
  -- Stored Procedure: dbo.ssp_ListPageDocumentAssignment          
  -- Copyright: Streamline Healthcate Solutions           
  -- Purpose: Used by Document Assignment list page           
  -- Updates:           
  -- Date          Author            Purpose           
  -- 07 Oct 2016  Arjun KR         List Page SP for Document Assignment. Task #447 Aspen Pointe Customizations   
  -- Modified
  --11 DEC 2018	  Alok Kumar		Added a new fields 'PacketType' also filtering based on that.	Ref#618 EII.        
  *************************************************************************************************/    
  BEGIN     
      BEGIN TRY     
          SET nocount ON;     
    
          --DECLATE TABLE TO GET DATA IF OTHER FILTER EXISTS -------                
          DECLARE @CustomFiltersApplied CHAR(1)     
          CREATE TABLE #CustomFilters (InsurersID int)     
             
          SET @CustomFiltersApplied = 'N'        
              
    
          CREATE TABLE #DocumentAssignments    
            (     
              DocumentAssignmentId	 INT,
              PacketName VARCHAR(100),
              PacketTypeName VARCHAR(100),
              Active   VARCHAR(100)
            )     
    
          --GET CUSTOM FILTERS                
          IF @OtherFilter > 10000     
            BEGIN    
                SET @CustomFiltersApplied = 'Y'     
                INSERT INTO #CustomFilters (InsurersID)     
                EXEC scsp_ListPageDocumentAssignment  @PacketName,@PacketType,@Status,@OtherFilter     
            END     
    
          --INSERT DATE INTO TEMP TABLE WHICH IS FETCHED BELOW BY APPLYING FILTER.             
          IF @CustomFiltersApplied = 'N'     
				BEGIN 
					INSERT INTO #DocumentAssignments
					SELECT DocumentAssignmentId 
						   ,PacketName 
						   ,dbo.csf_GetGlobalCodeNameById(PacketType) AS PacketTypeName
						   ,CASE WHEN Active='Y' THEN 'Active' ELSE 'InActive' END AS Active
					FROM   DocumentAssignments
					WHERE  Isnull(RECORDDELETED, 'N') = 'N'
					       AND ((DocumentAssignmentId=@PacketName) or @PacketName=-1)
					       AND ((PacketType=@PacketType) or @PacketType=-1)
						   AND (( @Status = 1 AND Active = 'Y' ) 
						   OR ( @Status = 2 AND ISNULL(Active,'N') = 'N' ) 
						   OR ( @Status = -1 ) )
			  END;
				
			
		  
    
       
    
    WITH Counts     
         AS (SELECT COUNT(*) AS TotalRows     
             FROM   #DocumentAssignments),     
         ListBanners     
         AS (SELECT			 DocumentAssignmentId,          
							 PacketName,
							 PacketTypeName,     
                             Active,         
                             COUNT(*)     
                             OVER ()   AS     
                             TotalCount,     
                             RANK()     
                               OVER (  ORDER BY     
                                          CASE WHEN @SortExpression='DocumentAssignmentId' THEN DocumentAssignmentId  END,     
                                          CASE WHEN @SortExpression='DocumentAssignmentId desc' THEN DocumentAssignmentId END DESC,    
                                          CASE WHEN @SortExpression='PacketName' THEN PacketName END,     
                                          CASE WHEN @SortExpression='PacketName desc' THEN PacketName END DESC,    
                                          CASE WHEN @SortExpression='PacketTypeName' THEN PacketTypeName END,     
                                          CASE WHEN @SortExpression='PacketTypeName desc' THEN PacketTypeName END DESC, 
                                          CASE WHEN @SortExpression='Status' THEN Active END,     
                                          CASE WHEN @SortExpression='Status desc' THEN Active END DESC,DocumentAssignmentId) AS  RowNumber    
              FROM  #DocumentAssignments)     
    SELECT TOP (CASE WHEN (@PageNumber = -1) THEN (SELECT ISNULL( totalrows, 0)     
    FROM     
    Counts ) ELSE (@PageSize) END) DocumentAssignmentId,
								   PacketName,
								   PacketTypeName,
								   Active,  
                                   TotalCount,     
                                   RowNumber     
    INTO   #FinalResultSet     
    FROM   ListBanners     
    WHERE  RowNumber > ((@PageNumber - 1 ) * @PageSize )     
    
    IF (SELECT ISNULL(COUNT(*), 0)     
        FROM   #finalresultset) < 1     
      BEGIN     
          SELECT 0 AS PageNumber,     
                 0 AS NumberOfPages,     
                 0 NumberOfRows     
      END     
    ELSE     
      BEGIN     
          SELECT TOP 1 @PageNumber           AS PageNumber,     
                       CASE ( TotalCount % @PageSize )     
                       WHEN 0 THEN ISNULL(( TotalCount / @PageSize ), 0)     
                       ELSE ISNULL(( TotalCount / @PageSize ), 0) + 1     
                       END  AS NumberOfPages,     
                       ISNULL(totalcount, 0) AS NumberOfRows     
          FROM   #FinalResultSet     
      END     
    
    SELECT DocumentAssignmentId,     
           PacketName,     
           PacketTypeName,
           Active         
    FROM   #FinalResultSet     
    ORDER  BY RowNumber     
     





END TRY     
    
    BEGIN CATCH     
        DECLARE @Error VARCHAR(8000)     
    
        SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'     
                    + CONVERT(VARCHAR(4000), ERROR_MESSAGE())     
                    + '*****'     
                    + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),     
                    'ssp_ListPageDocumentAssignment')     
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
     END CATCH     
END 

GO


