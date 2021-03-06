
/****** Object:  StoredProcedure [dbo].[ssp_SCExecuteClientNoteCopyProcedure]    Script Date: 11/08/2012 14:51:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCExecuteClientNoteCopyProcedure]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCExecuteClientNoteCopyProcedure]
GO



/****** Object:  StoredProcedure [dbo].[ssp_SCExecuteClientNoteCopyProcedure]    Script Date: 11/08/2012 14:51:12 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE proc [dbo].[ssp_SCExecuteClientNoteCopyProcedure]   
(  
 @GroupServiceId int,  
 @StaffId int  
)  
AS  
begin  
  
-- Modify by Jagdeep as per task #1952-Group Service - Error Message-Thresholds - Bugs/Features (Offshore)  
-- Modify by Maninder as per task #1867-Group Service -Thresholds - Bugs/Features (Offshore)  
-- 13-APRIL-2016    Akwinass	What:Included GroupNoteType Column.          
--							    Why:task #167.1 Valley - Support Go Live

 DECLARE @CopyStoredProcedureName varchar(100)  
   
 select @CopyStoredProcedureName = GNDC.CopyStoredProcedureName from GroupServices GS  
 inner join Groups G on GS.GroupId = G.GroupId   
 inner join GroupNoteDocumentCodes GNDC on G.GroupNoteDocumentCodeId = GNDC.GroupNoteDocumentCodeId AND ISNULL(G.GroupNoteType,0) = 9383--13-APRIL-2016    Akwinass  
 where GS.GroupServiceId =@GroupServiceId   
 and ISNULL(G.RecordDeleted ,'n')='n'  
 and ISNULL(GS.RecordDeleted ,'n')='n'  
 and ISNULL(GNDC.RecordDeleted ,'n')='n'  
 --print  @CopyStoredProcedureName  
  if(isnull(@CopyStoredProcedureName,'') <> '')    
 EXEC @CopyStoredProcedureName @GroupServiceId ,@StaffId 
 
 declare @sql as varchar(max)

declare @customFieldTableName varchar(200)
select @customFieldTableName=TableName from Screens S left join Forms F on S.CustomFieldFormId=F.FormId where screenid=29
declare @FieldName as varchar(200)
set @FieldName='MemberParticipated'
select @sql='


if(exists( select  1 from sys.columns c inner join sys.tables t on c.object_id=t.object_id where t.name='''+@customFieldTableName+''' and c.name='''+@FieldName+'''))
begin
	update '+@customFieldTableName+'  
 set  '+@FieldName+' = CASE s.Status  
      WHEN 71 THEN ''Y''  
      WHEN 72 THEN ''N''  
       END  
 from Services s  
 INNER JOIN '+@customFieldTableName+' cfd ON cfd.ServiceId = s.ServiceId  
 WHERE s.GroupServiceId = '+convert(varchar,@GroupServiceId) +' and cfd.'+@FieldName+' is null
 
end'

-- Added by jagdeep to resolve  issue #742-Group Service:- Exception occurred while clicking on 'Update my client note(Need to discuss the changes with team)

if(exists( select  1 from sys.columns c inner join sys.tables t on c.object_id=t.object_id where t.name=''+@customFieldTableName+'' and c.name=''+@FieldName+''))
begin
exec(@sql)
end
end  
GO


