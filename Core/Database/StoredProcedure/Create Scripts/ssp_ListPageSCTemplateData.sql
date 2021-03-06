IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[ssp_ListPageSCTemplateData]') AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[ssp_ListPageSCTemplateData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO   
   

/****** Object:  StoredProcedure [dbo].[ssp_ListPageSCTemplateData]    Script Date: 07/09/2012 14:21:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_ListPageSCTemplateData]  
    @PageNumber INT ,    
    @PageSize INT ,    
    @SortExpression VARCHAR(100) , 
    @TemplateType INT,   
    @Status INT ,    
    @OtherFilter int,
	@TagName varchar(250)    
     
/*********************************************************************************/              
/* Stored Procedure: ssp_ListPageSCTemplateData           */     
/* Copyright: Streamline Healthcare Solutions          */              
/* Creation Date:  2012-09-21              */              
/* Purpose: Populates Progress Note Template list page         */             
/* Input Parameters:@SessionId,@InstanceId,@PageNumber,@PageSize,@SortExpression,*/    
/*      @Active,@TagTypeId ,@Others      */            
/* Return:                      */              
/* Called By: PrimaryCare.cs , GetSCTemplateData()        */              
/* Calls:                   */              
/* Data Modifications:                */              
/* Updates:                   */              
/* Date              Author             Purpose          */            
/* 2012-09-21   Vaibhav khare           Created          */ 
/* 2o12-09-21   Bernardin               Modified selection Condition */ 
/* 2012-12-14	Varinderv               Added @SortExpression for Status and TemplateType for sorting. Ref Task# 724 Threshold 3.5x Merged Issues */
/* 2014-06-17	Wasif Butt				Added @TagName to allow filtering templates that contain a certain tag.	*/
/* 2016-06-07	Basudev Sahu			Modified for task core bug # 2069 for column renamed for TemplateType to SubTemplate and GlobalSubCodeName to Status for export list functionality	*/
/*********************************************************************************/    
   
AS  
set transaction isolation level read uncommitted  
  
BEGIN                                                                
 BEGIN TRY  
   
                                  
 DECLARE @ApplyFilterClicked  CHAR(1)  
 DECLARE @CustomFiltersApplied CHAR(1)  
 CREATE TABLE #CustomFilters  
            (  
              TemplateId INT NOT NULL   
            )      
 SET @SortExpression = RTRIM(LTRIM(@SortExpression))  
 IF ISNULL(@SortExpression, '') = ''  
  SET @SortExpression= 'TemplateId'  
 --   
  
 --   
 -- New retrieve - the request came by clicking on the Apply Filter button                     
 --  
 SET @ApplyFilterClicked = 'Y'   
 SET @CustomFiltersApplied = 'N'                                                   
 --SET @PageNumber = 1  
   
 IF @OtherFilter > 10000                                      
 BEGIN  
  SET @CustomFiltersApplied = 'Y'  
    
  INSERT INTO #CustomFilters (TemplateId)   
  EXEC scsp_PCPageSCTemplateData   
  
   @Status        =@Status,  
  
   @OtherFilter      =@OtherFilter  
    
 END  
   
 --  
 -- User Selections  
 --             
           
    
              
  ;WITH ListProgressNoteTemplates  
 AS  
 (              
 SELECT  T.NoteTemplateId ,T.TemplateName,T.TemplateHTML,T.[Active],  
    CASE   
WHEN (@Status = '-1' and  T.[Active] = 'Y') Then 'Active'  
WHEN (@Status = '-1' and  T.[Active] = 'N') Then 'Inactive'   
WHEN  @Status = '1' THEN 'Active'   
WHEN  @Status = '2' THEN 'Inactive'  
--2016-06-07	Basudev Sahu 
--END as 'GlobalSubCodeName'  ,
END as 'Status'  ,
   CASE   
WHEN (@TemplateType = '-1' and SubTemplate = 'Y') Then 'Yes'  
WHEN (@TemplateType = '-1' and ISNULL(SubTemplate,'N') = 'N') Then 'No'   
WHEN  @TemplateType = '1' THEN 'Yes'  
when @TemplateType = '2' then 'No'
--2016-06-07	Basudev Sahu 
 --END as 'TemplateType' FROM    NoteTemplates T
 END as 'SubTemplate' FROM    NoteTemplates T
 
 WHERE ISNULL(T.RecordDeleted,'N') ='N'            
 and  (isnull(@Status, -1) = -1 or (@Status = 1 and T.[Active] = 'Y') or (@Status = 2 and isnull(T.[Active], 'N') = 'N'))
 AND ((@TemplateType = -1) or (@TemplateType = 1 and isnull(SubTemplate, 'N') = 'Y') or (@TemplateType = 2 and isnull(SubTemplate, 'N') = 'N') )
 and (CHARINDEX('[[*'+@TagName+'*]]',T.TemplateHTML) > 0 or @TagName is null or @TagName = '')
   ),    
       
       
          counts as (   
    select count(*) as totalrows from ListProgressNoteTemplates  
    ),  
      
RankResultSet  
as  
  
(                                               
   SELECT  NoteTemplateId ,TemplateName,TemplateHTML,[Active], SubTemplate, Status,  
  
      
   COUNT(*) OVER ( ) AS TotalCount ,  
                                    RANK() OVER ( ORDER BY    
    CASE WHEN @SortExpression= 'TemplateName'     THEN [TemplateName] END,                                    
    CASE WHEN @SortExpression= 'TemplateName desc'    THEN [TemplateName] END DESC,  
    CASE WHEN @SortExpression= 'Active'     THEN [Active] END,                                    
    CASE WHEN @SortExpression= 'Active desc'   THEN [Active] END DESC, 
    
    --Added @SortExpression for Status and TemplateType for sorting. Ref Task# 724 Threshold 3.5x Merged Issues 
    CASE WHEN @SortExpression= 'Status'     THEN [Active] END,                                    
    CASE WHEN @SortExpression= 'Status DESC'   THEN [Active] END DESC,
    --2016-06-07	Basudev Sahu 
    --CASE WHEN @SortExpression= 'TemplateType'     THEN TemplateType END,                                    
    --CASE WHEN @SortExpression= 'TemplateType DESC'   THEN TemplateType END DESC
    CASE WHEN @SortExpression= 'SubTemplate'     THEN SubTemplate END,                                    
    CASE WHEN @SortExpression= 'SubTemplate DESC'   THEN SubTemplate END DESC, 
         
    NoteTemplateId   
    )  AS RowNumber  
                           FROM     ListProgressNoteTemplates   
                             
                             
     )  
                                           
   SELECT TOP ( Case WHEN (@PageNumber = -1) THEN (SELECT ISNULL(totalrows,0) from counts) ELSE (@PageSize) END)  
  NoteTemplateId ,  
  TemplateName,  
  TemplateHTML,  
  [Active],    
  --2016-06-07	Basudev Sahu 
  --GlobalSubCodeName,  
  --TemplateType,
    Status,  
  SubTemplate,
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
     RowNumber,  
    @PageNumber AS PageNumber,     
 NoteTemplateId ,  
 TemplateName,  
 TemplateHTML,  
 [Active],  
 --2016-06-07	Basudev Sahu 
 --GlobalSubCodeName,
 --TemplateType 
   Status,  
  SubTemplate
            FROM    #FinalResultSet  
            ORDER BY RowNumber  
    DROP TABLE #CustomFilters  
 END TRY  
   
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)         
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                              
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_ListPageSCTemplateData')                                                                                               
   + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                
   + '*****' + CONVERT(VARCHAR,ERROR_STATE())  
  RAISERROR  
  (  
   @Error, -- Message text.  
   16,  -- Severity.  
   1  -- State.  
  );  
 END CATCH  
END  

