/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportCustomAssessmentHRMMentalStatus]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportCustomAssessmentHRMMentalStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportCustomAssessmentHRMMentalStatus]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportCustomAssessmentHRMMentalStatus]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/************************************************************************/                                                
/* Stored Procedure: [csp_RDLSubReportCustomAssessmentHRMMentalStatus]	*/                                                                             
/* Copyright: 2008 Streamline SmartCare									*/                                                                                      
/* Creation Date:  August 5, 2008										*/                                                
/*																		*/                                                
/* Purpose: HRM assessment sub report for Mental Status					*/                                    
/*																		*/                                              
/* Input Parameters: DocumentID,Version									*/                                              
/* Output Parameters:													*/                                                
/* Purpose: Use For Rdl Report											*/                                      
/* Calls:																*/                                                
/* Author: Tom Remisoski												*/                                                
/************************************************************************/     

CREATE procedure [dbo].[csp_RDLSubReportCustomAssessmentHRMMentalStatus]
	--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010
as
declare @MaxColumns int
declare @CurrColumn int
declare @CurrRow int
declare @CurrSection varchar(100)

declare
@SectionLabel varchar(100),
@SectionAddToNeedsList char(1),
@SectionSortOrder int,
@ItemLabel varchar(50),
@ItemChecked char(1),
@ItemNarrative varchar(max)

create table #output
(
	RowNumber int,
	SectionLabel varchar(100),
	SectionAddToNeedsList char(1),
	SectionSortOrder int,
	ItemLabel1 varchar(50),
	ItemChecked1 char(1),
	ItemNarrative1 varchar(max),
	ItemLabel2 varchar(50),
	ItemChecked2 char(1),
	ItemNarrative2 varchar(max),
	ItemLabel3 varchar(50),
	ItemChecked3 char(1),
	ItemNarrative3 varchar(max)
)

declare cMentalStatus cursor for
select amss.SectionLabel,
--amss.HRMMentalStatusSectionId, 
amss.AddToNeedsList, 
mss.SortOrder,
--amsi.HRMMentalStatusItemId, 
amsi.ItemLabel, 
amsi.ItemChecked,
amsi.ItemNarrative
--msi.SortOrder
from CustomHRMAssessmentMentalStatusItems as amsi
join CustomHRMMentalStatusItems as msi on msi.HRMMentalStatusItemId = amsi.HRMMentalStatusItemId
join CustomHRMMentalStatusSections as mss on mss.HRMMentalStatusSectionId = msi.HRMMentalStatusSectionId
--join CustomHRMAssessmentMentalStatusSections as amss on amss.DocumentId = amsi.DocumentId and amss.Version = amsi.Version and amss.HRMMentalStatusSectionId = mss.HRMMentalStatusSectionId
join CustomHRMAssessmentMentalStatusSections as amss on amss.DocumentVersionId = amsi.DocumentVersionId and amss.HRMMentalStatusSectionId = mss.HRMMentalStatusSectionId  --Modified by Anuj Dated 03-May-2010
--where amsi.DocumentId = @DocumentId
--and amsi.Version = @Version
where amsi.DocumentVersionId=@DocumentVersionId  --Modified by Anuj Dated 03-May-2010
order by mss.SortOrder, msi.SortOrder


set @MaxColumns = 3
set @CurrColumn = 0
set @CurrRow = 0
set @currSection = ''''

open cMentalStatus

fetch cMentalStatus into
@SectionLabel,
@SectionAddToNeedsList,
@SectionSortOrder,
@ItemLabel,
@ItemChecked,
@ItemNarrative

while @@fetch_status = 0
begin

	if (@CurrSection <> @SectionLabel) or (@CurrColumn > @MaxColumns) or (@ItemNarrative is not null)
	begin
		set @CurrRow = @CurrRow + 1
		set @CurrColumn = 1
		set @CurrSection = @SectionLabel

		insert into #output(RowNumber) values (@CurrRow)
	end
	
	if @CurrColumn = 1
	begin
		update #output set
			SectionLabel = @SectionLabel,
			SectionAddToNeedsList = @SectionAddToNeedsList,
			SectionSortOrder = @SectionSortOrder,
			ItemLabel1 = @ItemLabel,
			ItemChecked1 = @ItemChecked,
			ItemNarrative1 = @ItemNarrative
		where RowNumber = @CurrRow
	end
	else if @CurrColumn = 2
	begin
		update #output set
			SectionLabel = @SectionLabel,
			SectionAddToNeedsList = @SectionAddToNeedsList,
			SectionSortOrder = @SectionSortOrder,
			ItemLabel2 = @ItemLabel,
			ItemChecked2 = @ItemChecked,
			ItemNarrative2 = @ItemNarrative
		where RowNumber = @CurrRow
	end
	else if @CurrColumn = 3
	begin
		update #output set
			SectionLabel = @SectionLabel,
			SectionAddToNeedsList = @SectionAddToNeedsList,
			SectionSortOrder = @SectionSortOrder,
			ItemLabel3 = @ItemLabel,
			ItemChecked3 = @ItemChecked,
			ItemNarrative3 = @ItemNarrative
		where RowNumber = @CurrRow
	end

	-- Want items with narrative to take up one column
	if @ItemNarrative is not null
	begin
		set @CurrColumn = @MaxColumns + 1
	end
	else
	begin
		set @CurrColumn = @CurrColumn + 1
	end		

	fetch cMentalStatus into
	@SectionLabel,
	@SectionAddToNeedsList,
	@SectionSortOrder,
	@ItemLabel,
	@ItemChecked,
	@ItemNarrative

end

close cMentalStatus

deallocate cMentalStatus

select * from #output
order by SectionSortOrder, RowNumber
' 
END
GO
