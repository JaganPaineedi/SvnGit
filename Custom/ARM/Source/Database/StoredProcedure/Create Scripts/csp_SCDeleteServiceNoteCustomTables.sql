/****** Object:  StoredProcedure [dbo].[csp_SCDeleteServiceNoteCustomTables]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteServiceNoteCustomTables]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCDeleteServiceNoteCustomTables]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCDeleteServiceNoteCustomTables]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_SCDeleteServiceNoteCustomTables]
(
 @DocumentCodeId int,           
 @DocumentId as int,          
 @varAuthorName varchar(50)                                                                                                                              
)          
As          
/******************************************************************************  
**  File: MSDE.cs  
**  Name:  csp_SCDeleteServiceNoteCustomTables  
**  Desc: This fetches data for Service Note Custom Tables 
**  Copyright: 2006 Streamline SmartCare                            
**  
**  This template can be customized:  
**                
**  Return values:  
**   
**  Called by:   DownloadReqServiceData function in MSDE Class in DataServices  
**                
**  Parameters:  
**  Input       Output  
**     ----------      -----------  
**  DocumentID,Version    Result Set containing values from Service Note Custom Tables
**  
**  Auth: Balvinder Singh  
**  Date: 24-April-08  
*******************************************************************************  
**  Change History  
*******************************************************************************  
**  Date:    Author:    Description:  
**  --------   --------   -------------------------------------------  

*******************************************************************************/  
BEGIN TRY  
 
if(@DocumentCodeId=107)
begin
 Exec csp_SCDeleteServiceNoteCustomTables107 @DocumentId,@varAuthorName  
end
    
if(@DocumentCodeId=109)
begin
 Exec csp_SCDeleteServiceNoteCustomTables109 @DocumentId,@varAuthorName
end

if(@DocumentCodeId=111)
begin
 Exec csp_SCDeleteServiceNoteCustomTables111 @DocumentId,@varAuthorName
end

if(@DocumentCodeId=115)
begin
 Exec csp_SCDeleteServiceNoteCustomTables115 @DocumentId,@varAuthorName
end

if(@DocumentCodeId=117)
begin
 Exec csp_SCDeleteServiceNoteCustomTables117 @DocumentId,@varAuthorName
end

if(@DocumentCodeId=118)
begin
 Exec csp_SCDeleteServiceNoteCustomTables118 @DocumentId,@varAuthorName
end

if(@DocumentCodeId=116)
begin
 Exec csp_SCDeleteServiceNoteCustomTables116 @DocumentId,@varAuthorName
end

if(@DocumentCodeId=120)
begin
 Exec csp_SCDeleteServiceNoteCustomTables120 @DocumentId,@varAuthorName
end

if(@DocumentCodeId=121)
begin
 Exec csp_SCDeleteServiceNoteCustomTables121 @DocumentId,@varAuthorName
end

if(@DocumentCodeId=119)
begin
 Exec csp_SCDeleteServiceNoteCustomTables119 @DocumentId,@varAuthorName
end

if(@DocumentCodeId=122)
begin
 Exec csp_SCDeleteServiceNoteCustomTables122 @DocumentId,@varAuthorName
end

if(@DocumentCodeId=6)
begin
 Exec csp_SCDeleteServiceNoteCustomTables6 @DocumentId,@varAuthorName
end

if(@DocumentCodeId=281)
begin
 Exec csp_SCDeleteServiceNoteCustomTables281 @DocumentId,@varAuthorName
end

if(@DocumentCodeId=306)
begin
 Exec csp_SCDeleteServiceNoteCustomTables306 @DocumentId,@varAuthorName
end

if(@DocumentCodeId=332)
begin
 Exec csp_SCDeleteServiceNoteCustomTables332 @DocumentId,@varAuthorName
end

if(@DocumentCodeId=307)
begin
 Exec csp_SCDeleteServiceNoteCustomTables307 @DocumentId,@varAuthorName
end

if(@DocumentCodeId=353)
begin
 Exec csp_SCDeleteServiceNoteCustomTables353 @DocumentId,@varAuthorName
end

if(@DocumentCodeId=354)
begin
 Exec csp_SCDeleteServiceNoteCustomTables354 @DocumentId,@varAuthorName
end


END TRY  

BEGIN CATCH  
 declare @Error varchar(8000)  
 set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())   
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''[csp_SCDeleteServiceNoteCustomTables]'')   
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())    
    + ''*****'' + Convert(varchar,ERROR_STATE())  
    
 RAISERROR   
 (  
  @Error, -- Message text.  
  16,  -- Severity.  
  1  -- State.  
 );  
  
END CATCH
' 
END
GO
