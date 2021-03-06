
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLMiscellaneousNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLMiscellaneousNotes]
GO

/* Object:  StoredProcedure [dbo].[ssp_RDLMiscellaneousNotes]  Script Date: 09/Feb/2016 */
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO 
CREATE PROCEDURE  [dbo].[ssp_RDLMiscellaneousNotes]           
(              
--@DocumentId int,                 
--@Version int                
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010    
)              
As              
                      
Begin                      
/******************************************************************************              
Created By         Date           Reason 
     
Vijeta Sinha    02/17/2016   Created to make Core MiscellaneousNotes from custom under the task-  Engineering Improvement Initiatives- NBL(I)#310            
Tom Remisoski	07/12/2017	 What: AspenPointe SGL #308.  Added "order by" to final data select to ensure text is not "jumbled".  Installed SQL 2014-Compliant RAISERROR.
                             Why: Followup from production issues reviewed with customer.
Vijeta Sinha	07/14/2017	 What:  Added Tom changes "order by" to final data select to ensure text is not "jumbled" which was on Prod but not on svn.  
                                     
*******************************************************************************/                        
    
set nocount on    
    
create table #NoteData    
(    
 seq int identity(1,1),    
 NoteText varchar(200)    
)    
    
declare @currtext varchar(200)    
    
declare @NoteTextLen int    
set @NoteTextLen = 105    
    
declare @SearchString varchar(24)    
set @SearchString  = '%' + char(13) + char(10) + '%'    
    
declare @TotalNoteLength int, @CurrStringPos int, @ParaMarker int, @SpaceMarker int    
    
select @TotalNoteLength = DataLength(Narration)     
from CustomMiscellaneousNotes     
--where DocumentId = @DocumentId     
--and Version = @Version    
where DocumentVersionId=@DocumentVersionId   --Modified by Anuj Dated 03-May-2010    
    
set @CurrStringPos = 1    
    
if isnull(@TotalNoteLength, 0) <= 0     
begin    
 insert into #NoteData(NoteText) values ('')    
 goto done    
end    
    
while(@CurrStringPos <= @TotalNoteLength)    
begin    
 select @currtext = substring(Narration, @CurrStringPos, @NoteTextLen)     
 from CustomMiscellaneousNotes     
-- where DocumentId = @DocumentId     
-- and Version = @Version    
where DocumentVersionId=@DocumentVersionId   --Modified by Anuj Dated 03-May-2010    
    
 select @ParaMarker = patindex(@SearchString, @currtext)    
    
 if @ParaMarker = 1    
 begin    
  insert into #NoteData(NoteText) values ('')    
  set @CurrStringPos = @CurrStringPos + @ParaMarker + 1    
 end    
 else    
 begin    
  if @ParaMarker > 1    
  begin    
   insert into #NoteData (NoteText) values(substring(@currtext, 1, @ParaMarker - 1))    
    
   set @CurrStringPos = @CurrStringPos + @ParaMarker + 1    
  end    
  else    
  begin    
         -- If this is the last chunk, don't break on a space    
         if (@TotalNoteLength - @CurrStringPos <= @NoteTextLen)    
   begin    
    insert into #NoteData (NoteText) values(@currtext)    
    set @CurrStringPos = @CurrStringPos + @NoteTextLen    
   end    
         else    
         begin    
      set @SpaceMarker = patindex('% %', reverse(@currtext))    
    
      if @Spacemarker > 1    
      begin    
       set @SpaceMarker = Len(@currtext) - @SpaceMarker + 1    
       insert into #NoteData(NoteText) values(substring(@currtext, 1, @SpaceMarker - 1))    
       set @CurrStringPos = @CurrStringPos + @SpaceMarker    
      end    
      else    
      begin    
       insert into #NoteData (NoteText) values(@currtext)    
       set @CurrStringPos = @CurrStringPos + @NoteTextLen    
      end    
         end    
  end    
 end    
end    
    
    
--select * from #notedata    
    
done:    
    
                 
SELECT d.ClientID    
  ,#NoteData.NoteText as Narration    
FROM DocumentVersions dv    
left Join Documents d on d.DocumentId = dv.DocumentId  and ISNULL(d.RecordDeleted,'N') <> 'Y'     
left join CustomMiscellaneousNotes CMN on cmn.DocumentVersionId = dv.DOcumentVersionId and ISNULL(cmn.RecordDeleted,'N') <> 'Y'     
cross join #NoteData    
--Join Documents on Documents.DocumentID = CMN.DocumentID    
where ISNull(dv.RecordDeleted,'N')='N'     
--and CMN.Documentid = @DocumentId     
--and CMN.Version = @Version      
and dv.DocumentVersionId= @DocumentVersionId  
-- added order by to ensure text is not jumbled.  
order by #NoteData.seq      
     
/*    
SELECT Narration    
FROM CustomMiscellaneousNotes     
--cross join #NoteData    
where ISNull(RecordDeleted,'N')='N'     
and Documentid=@DocumentId     
and Version=@Version       
*/             
    
--Checking For Errors    
drop table #NoteData    
    
If (@@error!=0)              
 Begin              
    RAISERROR('[ssp_RDLMiscellaneousNotes] : An Error Occured', 16, 1)                           
  Return              
 End    
End    