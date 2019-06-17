
/****** Object:  StoredProcedure [dbo].[csp_RDLCustomMiscellaneousNotes]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomMiscellaneousNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomMiscellaneousNotes]
GO



/****** Object:  StoredProcedure [dbo].[csp_RDLCustomMiscellaneousNotes]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[csp_RDLCustomMiscellaneousNotes]       
(          
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010
)          
As          
                  
Begin                  
/************************************************************************/                    
/* Stored Procedure: csp_RdlCustomMiscellaneousNotes					*/
/* Copyright: 2006 Streamline SmartCare									*/                    
/* Creation Date:  Oct 09, 2007											*/                    
/*																		*/                    
/* Purpose: Gets Data for MiscellaneousNote								*/                   
/*																		*/                  
/* Input Parameters: DocumentID,Version									*/                  
/* Output Parameters:													*/                    
/* Purpose: Use For Rdl Report											*/          
/* Calls:																*/  
/* Revision history: 10/16/2009 - changed handling to not break on last word in text. */                  
/*********************************************************************/                     

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
--	where DocumentId = @DocumentId 
--	and Version = @Version
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

             
SELECT	d.ClientID
		,#NoteData.NoteText as Narration
FROM DocumentVersions dv
Join Documents d on d.DocumentId = dv.DocumentId  and ISNULL(d.RecordDeleted,'N') <> 'Y' 
join CustomMiscellaneousNotes CMN on cmn.DocumentVersionId = dv.DOcumentVersionId and ISNULL(cmn.RecordDeleted,'N') <> 'Y' 
cross join #NoteData
--Join Documents on Documents.DocumentID = CMN.DocumentID
where ISNull(dv.RecordDeleted,'N')='N' 
--and CMN.Documentid = @DocumentId 
--and CMN.Version = @Version  
and dv.DocumentVersionId= @DocumentVersionId    
 
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
		RAISERROR  20006   'csp_RdlCustomMiscellaneousNotes : An Error Occured'           
		Return          
	End
End


GO


