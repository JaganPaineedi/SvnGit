/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportHRMTPObjectiveText]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportHRMTPObjectiveText]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportHRMTPObjectiveText]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportHRMTPObjectiveText]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RDLSubReportHRMTPObjectiveText]    
(                                            
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int, --Modified by Anuj Dated 03-May-2010
@NeedId  int,
@ObjectiveNumber [decimal](18, 2)                                       
)                                            
As                                            
                                                    
Begin                                                    
/*                                                   
Called by: csp_RDLSubReportTPObjectives                                              
                                            

Copyright: 2008 Streamline SmartCare                                                                                                 
*/       
set nocount on


create table #NoteData
(
	seq int identity(1,1),
	NoteText varchar(200)
)

declare @currtext varchar(200)

declare @NoteTextLen int
set @NoteTextLen = 80

declare @SearchString varchar(24)
set @SearchString  = ''%'' + char(13) + char(10) + ''%''

declare @TotalNoteLength int, @CurrStringPos int, @ParaMarker int, @SpaceMarker int

select @TotalNoteLength = DataLength(a.ObjectiveText) 
From  TPObjectives a 
Join GlobalCodes gc on gc.GlobalCodeId = a.ObjectiveStatus
--Where a.DocumentId = @DocumentId
--and a.Version = @Version
Where a.DocumentVersionId = @DocumentVersionId   --Modified by Anuj Dated 03-May-2010
and a.NeedId = @NeedId
and a.ObjectiveNumber = @ObjectiveNumber
and isnull(a.RecordDeleted, ''N'') = ''N''

--select top 10* from tpObjectives
set @CurrStringPos = 1

if isnull(@TotalNoteLength, 0) <= 0 
begin
	insert into #NoteData(NoteText) values ('''') 
	goto done
end

while(@CurrStringPos <= @TotalNoteLength)
begin
	select @currtext = substring(a.ObjectiveText, @CurrStringPos, @NoteTextLen) 
From  TPObjectives a 
--Where a.DocumentId = @DocumentId
--and a.Version = @Version
Where a.DocumentVersionId = @DocumentVersionId   --Modified by Anuj Dated 03-May-2010
and a.NeedId = @NeedId
and a.ObjectiveNumber = @ObjectiveNumber
and isnull(a.RecordDeleted, ''N'') = ''N''
--Group by a.ObjectiveNumber, substring(a.ObjectiveText, @CurrStringPos, @NoteTextLen) 

	select @ParaMarker = patindex(@SearchString, @currtext)

	if @ParaMarker = 1
	begin
		insert into #NoteData(NoteText) values ('''')
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
			set @SpaceMarker = patindex(''% %'', reverse(@currtext))

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


--select * from #notedata

done:
                            
select NoteText as ObjectiveText  --a.ObjectiveText, 
from #NoteData
--From  TPObjectives a 
--cross join #NoteData
--Where a.DocumentId = @DocumentId
--and a.Version = @Version
--and a.NeedId = @NeedId
--and a.ObjectiveNumber = @ObjectiveNumber
--and isnull(a.RecordDeleted, ''N'') = ''N''
--order by a.ObjectiveNumber

--Checking For Errors
drop table #NoteData

If (@@error!=0)          
	Begin          
		RAISERROR  20006   ''csp_RdlSubReportHRMTPObjectiveText: An Error Occured''           
		Return          
	End
End
' 
END
GO
