IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_SCGetLockedDocumentListOnLogout')
	BEGIN
		DROP  Procedure  ssp_SCGetLockedDocumentListOnLogout
	END

GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 CREATE proc ssp_SCGetLockedDocumentListOnLogout  
(  
@staffid int,  
@sessionid varchar(200)   
)  
/******************************************************************************                                
**  File:                                 
**  Name: ssp_SCGetLockedDocumentListOnLogout                                
**  Desc:                                 
**                                
**                                              
**  Return values:                                
**                                 
**  Called by:                                   
**                                              
**  Parameters:                                
**  Input       Output                                
**     ----------       -----------                                
**                                
**  Auth:                                 
**  Date:                                 
*******************************************************************************                                
**  Change Histor6y                                
*******************************************************************************                                
**  Date:   Author:  Description:                                
**  --------- -------- -------------------------------------------                                
**  02 Dec 2011 Karan Garg     Used to get the list of Unsaved and Locked Documents list
**  16 July 2012 Sudhir Singh     Issue when logged out from application      
**  19 May 2014 Varun     Fixed SET QUOTED_IDENTIFIER issue when logging out from application   
**	29 Mar 2017	Wasif	Fixed the logout time logic so it doesn't update previous logouts from same browser session id   
**  07 Jan 2018 Bernardin  What: To avoid the multiple execution on logout. Why: Philhaven-Support# 244        
**  03/06/2018	jcarlson		Core Bugs 2450 - Removed logout time logic       
*******************************************************************************/    
as  

create table #UnsavedDocuments  
(  
DocumentID int  
)  
create table #totalUnsavedChanges  
(  
incrementId int identity (1,1) primary key,  
UnsavedChangeId int,  
ScreenProperties varchar(max)  
)  
  
insert into #totalUnsavedChanges  
select UnsavedChangeId,ScreenProperties from UnsavedChanges where ISNULL(RecordDeleted,'N') = 'N' And StaffId = @staffid  
  
declare @ScreenProperties XML  
declare @totalUnsavedChanges int  
declare @UnsavedChangeId int  
declare @count int  
DECLARE @ListofDocuments VARCHAR(8000)  
  
set @totalUnsavedChanges = (select Count(UnsavedChangeId) from #totalUnsavedChanges )  
set @count = 1  
  
while (@count <= @totalUnsavedChanges)  
  
begin  
  
set @UnsavedChangeId = (select UnsavedChangeId from #totalUnsavedChanges where incrementId = @Count)  
set @ScreenProperties = (select screenproperties from #totalUnsavedChanges where UnsavedChangeId = @UnsavedChangeId)  
  
  
insert into #UnsavedDocuments  
select  @ScreenProperties.value('(/ScreenProperties/DocumentId)[1]', 'int');  
  
set @count = @count + 1  
end  
  
delete from #UnsavedDocuments where DocumentId is null  
  
  
select @ListofDocuments = COALESCE(@ListofDocuments + '<br>' + DocumentName, DocumentName) from DocumentCodes Inner JOIN Documents   
ON Documents.DocumentCodeID = DocumentCodes.DocumentCodeID  
INNER JOIN DocumentLocks ON DocumentLocks.DocumentId = Documents.DocumentId  
where DocumentLocks.staffId = @staffId AND DocumentLocks.SessionId = @SessionId AND  
 DocumentLocks.DocumentId in   
(select DocumentId from #UnsavedDocuments)  
  
select @ListofDocuments as DocumentNames  

if((select COUNT(DOCUMENTID) from DocumentLocks where DocumentLocks.staffId = @staffid) = 1 and  (@ListofDocuments is null OR @ListofDocuments = ''))
begin
delete from DocumentLocks where StaffId = @staffid
end


drop table #UnsavedDocuments  
drop table #totalUnsavedChanges


SET QUOTED_IDENTIFIER OFF
  ---Added by Sudhir Singh as per issue when logged out from application  