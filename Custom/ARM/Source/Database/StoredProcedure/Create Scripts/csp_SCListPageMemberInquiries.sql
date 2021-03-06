/****** Object:  StoredProcedure [dbo].[csp_SCListPageMemberInquiries]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCListPageMemberInquiries]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCListPageMemberInquiries]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCListPageMemberInquiries]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/*********************************************************************/                                                                            
 /* Stored Procedure: [csp_SCListPageMemberInquiries]      */                                                                   
 /* Creation Date:  07/Sep/2011               */                                                                            
 /* Purpose: To Get The Data on List Page of Member Inquiries Screen */                                                                          
 /* Input Parameters: @SessionId ,@InstanceId,@PageNumber,@PageSize,@SortExpression ,@OtherFilter                  */                                                                          
 /* Output Parameters:   Returns The Two Table, One have the page Information and second table Contain the List Page Data  */                                                                            
 /* Called By: Client Tab for Member List Page(Threshold)              */                                                                  
 /* Data Modifications:              */                                                                            
 /*   Updates:                */                                                                            
 /*   Date					Author           */                                                                            
 /*   07/Sep/2011       Minakshi Varma         */    
 /*  17 Dec 2012       Sunil            ISNULL Check For First & Last Name*/   
 /* 9 Jan 2013  Varinder  */
 /* What: Added case for '','' in InquireFirstName and InquirerLastName  */
 /* Why: Change required for the Task #2540 Threshold Bugs/Features (Offshore) */                                                                
 /*********************************************************************/         
CREATE PROCEDURE [dbo].[csp_SCListPageMemberInquiries]       
@SessionId varchar(30),                                              
 @InstanceId int,                                              
 @PageNumber int,                                                  
 @PageSize int,                                                  
 @SortExpression varchar(100),      
 @ClientId int,      
 @RecordedBy INT,                              
 @StaffId INT,          
 @Disposition INT,          
 @FromDate DATETIME,              
 @ToDate DATETIME,              
 @OtherFilter INT       
      
AS      
BEGIN 
BEGIN TRY     
 
 CREATE Table #ResultSet (      
 RowNumber int,                                                                  
 PageNumber int,      
 InquiryId int,      
 InquirerName varchar(100),      
 InquiryDateTime datetime,      
 RecordedBy int,        
 RecordedByName varchar(100),                          
 AssignedToStaffId int,          
 AssignedStaffName varchar(100),          
 Disposition int,      
 DispositionName Varchar(250)       
 )     
 
 DECLARE @ApplyFilterClick AS CHAR(1)      
 SET @ApplyFilterClick =''N''      
 DECLARE @CustomFiltersApplied CHAR(1) 
 DECLARE @CustomFilters table (ClientTrackId INT)      
 
 IF @PageNumber > 0 AND EXISTS(SELECT * FROM CustomListPageMemberInquiries WHERE SessionId = @SessionId AND InstanceId = @InstanceId)                                           
	BEGIN                                 
		SET @ApplyFilterClick = ''N''                                          
	GOTO GetPage 
	END
           
  SET @ApplyFilterClick = ''Y''                                                                          
  SET @PageNumber = 1        
  INSERT INTO #ResultSet      
  (      
  InquiryId,      
 InquirerName,      
 InquiryDateTime,      
 RecordedBy,        
 RecordedByName,                          
 AssignedToStaffId,          
 AssignedStaffName,          
 Disposition,      
 DispositionName      
  )      
  SELECT      
  CI.InquiryId AS InquiryId,
 CASE 
	WHEN CI.InquirerLastName IS NOT NULL and CI.InquireFirstName IS NOT NULL THEN
			CI.InquirerLastName+'', ''+ CI.InquireFirstName   
	WHEN CI.InquirerLastName IS NOT NULL THEN CI.InquirerLastName
	WHEN CI.InquireFirstName IS NOT NULL THEN CI.InquireFirstName
	ELSE ''''
  END as InquirerName,  
  CI.InquiryDateTime as InquiryDateTime,
  S.StaffId as RecordedBy,
  S.LastName+'', ''+S.FirstName as RecordedByName,        
  ST.StaffId As AssignedToStaffId,      
  ST.LastName+'', ''+ST.FirstName AS AssignedStaffName,
  CI.Disposition as Disposition,      
  GD.CodeName as DispositionName
  FROM      
  CustomInquiries CI      
  Left Outer Join Staff ST on CI.AssignedToStaffId=ST.StaffId AND ISNULL(ST.RecordDeleted,''N'')=''N''
  Inner JOIN Staff S on CI.RecordedBy=S.StaffId AND ISNULL(ST.RecordDeleted,''N'')=''N''      
  LEFT OUTER JOIN GlobalCodes GD ON CI.Disposition = GD.GlobalCodeId      
  WHERE 
  (       
		ISNULL(CI.RecordDeleted,''N'')=''N''           
		AND CI.ClientId=@ClientId
		AND ((CI.RecordedBy=@RecordedBy) OR @RecordedBy=0)
		AND ((CI.AssignedToStaffId=@StaffId) OR @StaffId=0)      
		AND ((CI.Disposition=@Disposition) OR @Disposition=0)      
		AND (@FromDate is null or CI.InquiryDateTime >= @FromDate)
		AND (@ToDate is null or CI.InquiryDateTime < dateadd(dd, 1, @ToDate))
  )

SET @CustomFiltersApplied = ''N''     
    
	--Get custom filters                                        
	IF @OtherFilter > 10000                       
	BEGIN                  
	SET @CustomFiltersApplied = ''Y''                  
	INSERT INTO @CustomFilters (ClientTrackId)                                        
	EXEC scsp_ListPageMemberInquiriesList @OtherFilter = @OtherFilter                                   
	END
	
 GetPage:
 
 IF @ApplyFilterClick = ''N'' AND EXISTS(SELECT * FROM CustomListPageMemberInquiries WHERE SessionId = @SessionId AND InstanceId = @InstanceId AND SortExpression = @SortExpression)                                          
  GOTO Final                                          
                                          
SET @PageNumber = 1                                          
                                          
IF @ApplyFilterClick = ''N''
BEGIN	      
   INSERT INTO #ResultSet      
    (      
     InquiryId,      
 InquirerName,      
 InquiryDateTime,      
 RecordedBy,        
 RecordedByName,                          
 AssignedToStaffId,          
 AssignedStaffName,          
 Disposition,      
 DispositionName     
    )       
    SELECT      
     InquiryId,      
 InquirerName,      
 InquiryDateTime,      
 RecordedBy,        
 RecordedByName,                          
 AssignedToStaffId,          
 AssignedStaffName,          
 Disposition,      
 DispositionName      
    FROM       
     CustomListPageMemberInquiries      
    WHERE SessionId = @SessionId                                                                    
    AND   InstanceId = @InstanceId       
 END
               
	UPDATE R                                                                                              
	SET RowNumber = rn.RowNumber,                                    
	PageNumber=(rn.RowNumber/@PageSize) + CASE WHEN rn.RowNumber % @PageSize = 0 THEN 0 ELSE 1 END                                    
	FROM #ResultSet R                                                                                              
	JOIN ( SELECT InquiryId,                                                                
				row_number() over(order by 
				case when @SortExpression= ''InquirerName'' then InquirerName end ,                                                                
				case when @SortExpression= ''InquirerName desc'' then InquirerName end desc,                                                                
				case when @SortExpression= ''InquiryDateTime'' then InquiryDateTime end,                                                                
				case when @SortExpression= ''InquiryDateTime desc'' then InquiryDateTime end desc,                                              
				case when @SortExpression= ''RecordedByName'' then RecordedByName end,            
				case when @SortExpression= ''RecordedByName desc'' then RecordedByName end desc,      
				case when @SortExpression= ''AssignedStaffName'' then AssignedStaffName end,            
				case when @SortExpression= ''AssignedStaffName desc'' then AssignedStaffName end desc,                                                                   
				case when @SortExpression= ''DispositionName'' then DispositionName end,            
				case when @SortExpression= ''DispositionName desc'' then DispositionName end desc,                                                                   
				InquiryId) as RowNumber                                       
				FROM #ResultSet) rn on rn.InquiryId= R.InquiryId              
            
  DELETE FROM        
  CustomListPageMemberInquiries      --< TableName which you have created for your list page>       
  WHERE SessionId = @SessionId                                         
  AND InstanceId = @InstanceId       
        
  INSERT INTO       
    CustomListPageMemberInquiries--< TableName which you have created for your list  page>       
    (                                                                
    SessionID,      
    InstanceId,      
    PageNumber,      
    RowNumber,      
    SortExpression,      
    InquiryId,      
 InquirerName,      
 InquiryDateTime,      
 RecordedBy,        
 RecordedByName,                          
 AssignedToStaffId,          
 AssignedStaffName,          
 Disposition,      
 DispositionName
    )                                       
    SELECT      
     @SessionId,                                                                
     @InstanceId,      
     PageNumber,      
     RowNumber ,                           
     @SortExpression,                                
    InquiryId,      
 InquirerName,      
 InquiryDateTime,      
 RecordedBy,        
 RecordedByName,                          
 AssignedToStaffId,          
 AssignedStaffName,          
 Disposition,      
 DispositionName
    FROM #ResultSet
    
    Final:
    
    SELECT @PageNumber AS PageNumber, ISNULL(MAX(PageNumber), 0) AS NumberOfPages, ISNULL(MAX(RowNumber), 0) AS NumberOfRows                                          
	FROM CustomListPageMemberInquiries                              
	WHERE SessionId = @SessionId AND InstanceId = @InstanceId         
    
    SELECT        
	InquiryId,      
 InquirerName,      
 InquiryDateTime,      
 RecordedBy,        
 RecordedByName,                          
 AssignedToStaffId,          
 AssignedStaffName,          
 Disposition,      
 DispositionName
    FROM       
    CustomListPageMemberInquiries--< TableName which you have created for your list  page>       
    WHERE SessionId = @SessionId                                                                
    AND InstanceId = @InstanceId                                                                
	AND PageNumber = @PageNumber                                                                
    ORDER BY RowNumber
    END TRY
    
    BEGIN CATCH
	DECLARE @Error varchar(8000)                                               
	SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                             
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_SCListPageMemberInquiries'')                                                                             
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                              
    + ''*****'' + Convert(varchar,ERROR_STATE())                          
	RAISERROR                                                                             
	(                                               
	  @Error, -- Message text.                                                                            
	  16, -- Severity.                                                                            
	  1 -- State.                                                                            
	 ); 
	END CATCH         
END        
        


' 
END
GO
