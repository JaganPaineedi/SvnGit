IF OBJECT_ID('scsp_PMElectronicProcessERFile') IS NOT NULL
   DROP PROCEDURE scsp_PMElectronicProcessERFile
GO

CREATE PROCEDURE scsp_PMElectronicProcessERFile @ERFileId INT
   ,@UserId INT
   ,@ExecuteCoreCode CHAR(1) OUTPUT
AS
BEGIN
/**************************************************************************************
   Procedure: scsp_PMElectronicProcessERFile
   
   Streamline Healthcare Solutions, LLC Copyright 2016

   Purpose: Override core logic for cross overs.

   Parameters: 
      @ERFileId file to process
      @UserId user id processing the file
      @ExecuteCoreCode return whether or not to run core code or simply return
   Output: 
      

   Called By: ssp_PMElectronicProcessERFile
*****************************************************************************************
   Revision History:
   26-JAN-2015 - Dknewtson - Created

*****************************************************************************************/ 

SET @ExecuteCoreCode = 'N' -- need to do this no matter what.

declare @ElementSeperator char(1)    
declare @SubElementSeparator char(1)    
declare @MinimumLineNumber int    
declare @SubmitterId varchar(25)    
declare @SubmitterName varchar(100)    
declare @SenderId int    
declare @IncomingBatchDate datetime    
declare @FirstTimeProcessing char(1)    
declare @ERSenderId varchar(25)    
declare @BatchNumber int    
declare @UserCode varchar(30)    
declare @ErrorNo int    
declare @ErrorMessage varchar(1000)  
DECLARE @PayerId INT  
    
    
declare @ParseErrors table    
(LineNumber int null,    
ErrorMessage varchar(1000) null,    
LineDataText varchar(1000) null)    
    
--DROP TEMP Tables        
     
    
if exists (select * from ERFiles where ERFileId = @ERFileId and Processed = 'Y')    
BEGIN    
 SELECT @ErrorMessage = 'File Already Processed'    
 goto do_not_process        
END       
    
--?????    
If @UserId = 0     
Begin    
Set @UserId = 1    
End    
    
select @UserCode = UserCode from Staff where StaffId = @UserId    
    
    
--    
--Run Validations to determine it is ok to process    
--    
                        
--insert into dbo.ERFileParsingErrors(ERFileSegmentId,ERFileId, LineNumber, ErrorMessage, LineDataText)                        
--select  ERfileSegmentId,@ERFileId, LineNumber, cast(@ERFileId as varchar) + '-Some Error Message ' + cast(LineNumber as varchar), FileLineText                        
--from ERFileSegments WHERE ERFileId = @ERFileId                       
                        
                        
-- Get an existing payment for the payer   
declare @PaymentId int                        
declare @BatchId int                        
                        
/*                     
select top 1 @PaymentId = py.PaymentId                        
from ERFiles as f                        
join ERSenders as s on s.ERSenderId = f.ERSenderId                        
join Payers as p on p.PayerId = s.PayerId                        
join Payments as py on py.PayerId = p.PayerId                        
and not exists (select * from ERBatches as b where b.PaymentId = py.PaymentId)                        
                        
if @PaymentId is null                        
begin                        
                        
 select top 1 @PaymentId = py.PaymentId                        
 from ERFiles as f                        
 join ERSenders as s on s.ERSenderId = f.ERSenderId                        
 join Payers as p on p.PayerId = s.PayerId                        
 join CoveragePlans as cp on cp.PayerId = p.PayerId                        
 join Payments as py on py.CoveragePlanId = cp.CoveragePlanId                        
 and not exists (select * from ERBatches as b where b.PaymentId = py.PaymentId)                        
                        
end                        
                        
if @PaymentId is null     
BEGIN    
SET @ErrorMessage = 'Could not find an appropriate paymentid for this sender'    
goto do_not_process                        
END    
*/
    
 if exists (Select * From ERFiles  a    
    Where isnull(a.Processing, 'N') = 'Y'    
    and isnull(a.RecordDeleted, 'N')= 'N'    
    and a.ERFileId = @ERFileId    
    )    
 begin    
      Set @ErrorMessage = 'Remittance is currently being processed by another user, unable to process.'     
    goto do_not_process    
 end    
     
 if exists (Select * From ERFiles  a    
    Where isnull(a.DoNotProcess, 'N') = 'Y'    
    and isnull(a.RecordDeleted, 'N')= 'N'    
    and a.ERFileId = @ERFileId    
    )    
 begin    
   Set @ErrorMessage = 'Remittance is set to Do Not Process, unable to process.'     
    goto do_not_process    
 end    
    
    
 --Set Processing Flag for File    
 Update ERFiles    
 Set Processing = 'Y',    
 ProcessingStartTime = getdate()    
 where ERFileId = @ERFileId    
    
    
    
    
--    
-- Begin Processing    
--    
    
declare @835ImportParse table    
(ERFilesegmentId int null,    
LineNumber int NOT NULL,    
DataText varchar(4000) null,    
TempDataText varchar(4000) null,    
Segment varchar(10) null,    
Element1 varchar(1000) null,    
Element2 varchar(1000) null,    
Element3 varchar(1000) null,    
Element4 varchar(1000) null,    
Element5 varchar(1000) null,    
Element6 varchar(1000) null,    
Element7 varchar(1000)  null,    
Element8 varchar(1000)  null,    
Element9 varchar(1000)  null,    
Element10 varchar(1000) null,    
Element11 varchar(1000) null,    
Element12 varchar(1000) null,    
Element13 varchar(1000) null,    
Element14 varchar(1000) null,    
Element15 varchar(1000) null,    
Element16 varchar(1000) null,    
Element17 varchar(1000) null,    
Element18 varchar(1000) null,    
Element19 varchar(1000) null,    
Element20 varchar(1000) null,
unique (ERFileSegmentId, Segment, LineNumber)
)
    
    
SELECT  @ElementSeperator = SUBSTRING(ef.FileText,4,1)
       ,@SubElementSeparator = SUBSTRING(ef.FileText,105,1)
FROM    dbo.ERFiles ef
WHERE   ef.ERFileId = @ERFileId
    
--select @ElementSeperator = '*', @SubElementSeparator = ':', @FirstTimeProcessing = 'Y'    
    
select @FirstTimeProcessing = 'Y'    
    
-- Get Sender Id     
SELECT  @SubmitterId = b.ERSenderId
       ,@SenderId = b.ERSenderId
       ,@SubmitterName = b.SenderName
       ,@PayerId = b.PayerId
FROM    ERFiles a
        JOIN ERSenders b
            ON ( a.ERSenderId = b.ERSenderId )
WHERE   a.ERFileId = @ERFileId    
    
if @@error <> 0 return    
    
begin tran

select *
into #tmpERFileSegments
from ERFilesegments
where ERFileId  = @ERFileId
if @@error <> 0 return

declare @MaxSeg int = 0

delete from dbo.ERFileParsingErrors where ERFileId = @ERFileId
if @@error <> 0 return

delete from dbo.ERFileSegments where ERFileId = @ERFileId
if @@error <> 0 return

select @MaxSeg = MAX(erfilesegmentid) from dbo.ERFileSegments
if @@error <> 0 return

if @MaxSeg is null set @MaxSeg = 0

set identity_insert dbo.ERFileSegments on
if @@error <> 0 return

insert into dbo.ERFileSegments 
        (
        ERFileSegmentId,
         ERFileId,
         LineNumber,
         FileLineText,
         FileLineParsed,
         Element1,
         Element2,
         Element3,
         Element4,
         Element5,
         Element6,
         Element7,
         Element8,
         Element9,
         Element10,
         Element11,
         Element12,
         Element13,
         Element14,
         Element15,
         Element16,
         Element17,
         Element18,
         Element19,
         Element20,
         RowIdentifier,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate,
         RecordDeleted,
         DeletedDate,
         DeletedBy
        )
select
		(@MaxSeg + ROW_NUMBER() OVER (ORDER BY LineNumber )),  --- change line number to row number. Pooja.
         ERFileId,
         LineNumber,
         FileLineText,
         FileLineParsed,
         Element1,
         Element2,
         Element3,
         Element4,
         Element5,
         Element6,
         Element7,
         Element8,
         Element9,
         Element10,
         Element11,
         Element12,
         Element13,
         Element14,
         Element15,
         Element16,
         Element17,
         Element18,
         Element19,
         Element20,
         RowIdentifier,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate,
         RecordDeleted,
         DeletedDate,
         DeletedBy
from #tmpERFileSegments
if @@error <> 0 return

set identity_insert dbo.ERFileSegments off
if @@error <> 0 return

commit tran



insert into @835ImportParse    
(ERFilesegmentId, LineNumber, DataText, TempDataText)    
select ERFilesegmentId, LineNumber, FileLineText, FileLineText    
from ERFilesegments     
where ERFileId  = @ERFileId    
and isnull(RecordDeleted,'N') = 'N'    
order by LineNumber    
    
if @@error <> 0 return    
    
declare @ParseCount int    
    
select @ParseCount = 0    
    
-- Parse the data    
while exists (select * from @835ImportParse where len(TempDataText) > 0)    
begin    
    
 if @ParseCount > 20    
 begin    
      insert into @ParseErrors (LineNumber, ErrorMessage)    
   select LineNumber, 'Number of elements in a Segment is greater than 20, unable to parse.'     
        from @835ImportParse     
       where len(TempDataText) > 0    
    
 goto error    
 end    
    
 if @ParseCount = 0    
 begin    
  update @835ImportParse    
  set Segment = substring(TempDataText, 1, charindex(@ElementSeperator,TempDataText)-1)    
  where TempDataText like '%' + @ElementSeperator + '%'    
 end    
    
 if @@error <> 0 return    
    
 if @ParseCount = 1    
 begin    
  update @835ImportParse    
  set Element1 = substring(TempDataText, 1, charindex(@ElementSeperator,TempDataText)-1)    
  where TempDataText like '%' + @ElementSeperator + '%'    
    
  update @835ImportParse    
  set Element1 = TempDataText    
  where TempDataText not like '%' + @ElementSeperator + '%'    
  and len(TempDataText) > 0    
 end    
    
 if @@error <> 0 return    
    
 if @ParseCount = 2    
 begin    
  update @835ImportParse    
  set Element2 = substring(TempDataText, 1, charindex(@ElementSeperator,TempDataText)-1)    
  where TempDataText like '%' + @ElementSeperator + '%'    
      update @835ImportParse    
  set Element2 = TempDataText    
  where TempDataText not like '%' + @ElementSeperator + '%'    
  and len(TempDataText) > 0    
 end    
    
 if @@error <> 0 return    
    
 if @ParseCount = 3    
 begin    
  update @835ImportParse    
  set Element3 = substring(TempDataText, 1, charindex(@ElementSeperator,TempDataText)-1)    
  where TempDataText like '%' + @ElementSeperator + '%'    
    
  update @835ImportParse    
  set Element3 = TempDataText    
  where TempDataText not like '%' + @ElementSeperator + '%'    
  and len(TempDataText) > 0    
 end    
    
 if @@error <> 0 return    
    
 if @ParseCount = 4    
 begin    
  update @835ImportParse    
  set Element4 = substring(TempDataText, 1, charindex(@ElementSeperator,TempDataText)-1)    
  where TempDataText like '%' + @ElementSeperator + '%'    
    
  update @835ImportParse    
  set Element4 = TempDataText    
  where TempDataText not like '%' + @ElementSeperator + '%'    
  and len(TempDataText) > 0    
 end    
    
 if @@error <> 0 return    
    
 if @ParseCount = 5    
 begin    
  update @835ImportParse    
  set Element5 = substring(TempDataText, 1, charindex(@ElementSeperator,TempDataText)-1)    
  where TempDataText like '%' + @ElementSeperator + '%'    
    
  update @835ImportParse    
  set Element5 = TempDataText    
  where TempDataText not like '%' + @ElementSeperator + '%'    
  and len(TempDataText) > 0    
 end    
    
 if @@error <> 0 return    
    
 if @ParseCount = 6    
 begin    
  update @835ImportParse    
  set Element6 = substring(TempDataText, 1, charindex(@ElementSeperator,TempDataText)-1)    
  where TempDataText like '%' + @ElementSeperator + '%'    
    
  update @835ImportParse    
  set Element6 = TempDataText    
  where TempDataText not like '%' + @ElementSeperator + '%'    
  and len(TempDataText) > 0    
 end    
    
 if @@error <> 0 return    
    
 if @ParseCount = 7    
 begin    
  update @835ImportParse    
  set Element7 = substring(TempDataText, 1, charindex(@ElementSeperator,TempDataText)-1)    
  where TempDataText like '%' + @ElementSeperator + '%'    
    
  update @835ImportParse    
  set Element7 = TempDataText    
  where TempDataText not like '%' + @ElementSeperator + '%'    
  and len(TempDataText) > 0    
 end    
    
 if @@error <> 0 return    
    
 if @ParseCount = 8    
 begin    
  update @835ImportParse    
  set Element8 = substring(TempDataText, 1, charindex(@ElementSeperator,TempDataText)-1)    
  where TempDataText like '%' + @ElementSeperator + '%'    
    
  update @835ImportParse    
  set Element8 = TempDataText    
  where TempDataText not like '%' + @ElementSeperator + '%'    
  and len(TempDataText) > 0    
 end    
    
 if @@error <> 0 return    
    
 if @ParseCount = 9    
 begin    
  update @835ImportParse    
  set Element9 = substring(TempDataText, 1, charindex(@ElementSeperator,TempDataText)-1)    
  where TempDataText like '%' + @ElementSeperator + '%'    
    
  update @835ImportParse    
  set Element9 = TempDataText    
  where TempDataText not like '%' + @ElementSeperator + '%'    
  and len(TempDataText) > 0    
 end    
    
 if @@error <> 0 return    
    
 if @ParseCount = 10    
 begin    
  update @835ImportParse    
  set Element10 = substring(TempDataText, 1, charindex(@ElementSeperator,TempDataText)-1)    
  where TempDataText like '%' + @ElementSeperator + '%'    
    
  update @835ImportParse    
  set Element10 = TempDataText    
  where TempDataText not like '%' + @ElementSeperator + '%'    
  and len(TempDataText) > 0    
 end    
    
 if @@error <> 0 return    
    
 if @ParseCount = 11    
 begin    
  update @835ImportParse    
  set Element11 = substring(TempDataText, 1, charindex(@ElementSeperator,TempDataText)-1)    
  where TempDataText like '%' + @ElementSeperator + '%'    
    
  update @835ImportParse    
  set Element11 = TempDataText    
  where TempDataText not like '%' + @ElementSeperator + '%'    
  and len(TempDataText) > 0    
 end    
    
 if @@error <> 0 return    
    
 if @ParseCount = 12    
 begin    
  update @835ImportParse    
  set Element12 = substring(TempDataText, 1, charindex(@ElementSeperator,TempDataText)-1)    
  where TempDataText like '%' + @ElementSeperator + '%'    
    
  update @835ImportParse    
  set Element12 = TempDataText    
  where TempDataText not like '%' + @ElementSeperator + '%'    
  and len(TempDataText) > 0    
 end    
    
 if @@error <> 0 return    
    
 if @ParseCount = 13    
 begin    
  update @835ImportParse    
  set Element13 = substring(TempDataText, 1, charindex(@ElementSeperator,TempDataText)-1)    
  where TempDataText like '%' + @ElementSeperator + '%'    
    
  update @835ImportParse    
  set Element13 = TempDataText    
  where TempDataText not like '%' + @ElementSeperator + '%'    
  and len(TempDataText) > 0    
 end    
    
 if @@error <> 0 return    
    
 if @ParseCount = 14    
 begin    
  update @835ImportParse    
  set Element14 = substring(TempDataText, 1, charindex(@ElementSeperator,TempDataText)-1)    
  where TempDataText like '%' + @ElementSeperator + '%'    
    
  update @835ImportParse    
  set Element14 = TempDataText    
  where TempDataText not like '%' + @ElementSeperator + '%'    
  and len(TempDataText) > 0    
 end    
    
 if @@error <> 0 return    
    
 if @ParseCount = 15    
 begin    
  update @835ImportParse    
  set Element15 = substring(TempDataText, 1, charindex(@ElementSeperator,TempDataText)-1)    
  where TempDataText like '%' + @ElementSeperator + '%'    
    
  update @835ImportParse    
  set Element15 = TempDataText    
  where TempDataText not like '%' + @ElementSeperator + '%'    
  and len(TempDataText) > 0    
 end    
    
 if @@error <> 0 return    
    
 if @ParseCount = 16    
 begin    
  update @835ImportParse    
  set Element16 = substring(TempDataText, 1, charindex(@ElementSeperator,TempDataText)-1)    
  where TempDataText like '%' + @ElementSeperator + '%'    
    
  update @835ImportParse    
  set Element16 = TempDataText    
  where TempDataText not like '%' + @ElementSeperator + '%'    
  and len(TempDataText) > 0    
 end    
    
 if @@error <> 0 return    
    
 if @ParseCount = 17    
 begin    
  update @835ImportParse    
  set Element17 = substring(TempDataText, 1, charindex(@ElementSeperator,TempDataText)-1)    
  where TempDataText like '%' + @ElementSeperator + '%'    
    
  update @835ImportParse    
  set Element17 = TempDataText    
  where TempDataText not like '%' + @ElementSeperator + '%'    
  and len(TempDataText) > 0    
 end    
    
 if @@error <> 0 return    
    
 if @ParseCount = 18    
 begin    
  update @835ImportParse    
  set Element18 = substring(TempDataText, 1, charindex(@ElementSeperator,TempDataText)-1)    
  where TempDataText like '%' + @ElementSeperator + '%'    
    
  update @835ImportParse    
  set Element18 = TempDataText    
  where TempDataText not like '%' + @ElementSeperator + '%'    
  and len(TempDataText) > 0    
 end    
    
 if @@error <> 0 return    
    
 if @ParseCount = 19    
 begin    
  update @835ImportParse    
  set Element19 = substring(TempDataText, 1, charindex(@ElementSeperator,TempDataText)-1)    
  where TempDataText like '%' + @ElementSeperator + '%'    
    
  update @835ImportParse    
  set Element19 = TempDataText    
  where TempDataText not like '%' + @ElementSeperator + '%'    
  and len(TempDataText) > 0    
 end    
    
 if @@error <> 0 return    
    
 if @ParseCount = 20    
 begin    
  update @835ImportParse    
  set Element20 = substring(TempDataText, 1, charindex(@ElementSeperator,TempDataText)-1)    
  where TempDataText like '%' + @ElementSeperator + '%'    
    
  update @835ImportParse    
  set Element20 = TempDataText    
  where TempDataText not like '%' + @ElementSeperator + '%'    
  and len(TempDataText) > 0    
 end    
    
 if @@error <> 0 return    
    
 update @835ImportParse    
 set TempDataText = null    
 where TempDataText not like '%' + @ElementSeperator + '%'    
 and len(TempDataText) > 0    
    
 if @@error <> 0 return    
    
 update @835ImportParse    
 set TempDataText = right(TempDataText, len(TempDataText) - charindex(@ElementSeperator,TempDataText))    
where TempDataText like '%' + @ElementSeperator + '%'    
    
 if @@error <> 0 return    
    
 select @ParseCount = @ParseCount + 1    
    
 if @@error <> 0 return    
    
end    
    
update @835ImportParse    
set Element1 = null    
where rtrim(Element1) in ('',null)    
    
if @@error <> 0 return    
    
update @835ImportParse    
set Element2 = null    
where rtrim(Element2) in ('',null)    
    
update @835ImportParse    
set Element3 = null    
where rtrim(Element3) in ('',null)    
    
if @@error <> 0 return    
    
update @835ImportParse    
set Element4 = null    
where rtrim(Element4) in ('',null)    
    
if @@error <> 0 return    
    
update @835ImportParse    
set Element5 = null    
where rtrim(Element5) in ('',null)    
    
if @@error <> 0 return    
    
update @835ImportParse    
set Element6 = null    
where rtrim(Element6) in ('',null)    
    
if @@error <> 0 return    
    
update @835ImportParse    
set Element7 = null    
where rtrim(Element7) in ('',null)    
    
if @@error <> 0 return    
    
update @835ImportParse    
set Element8 = null    
where rtrim(Element8) in ('',null)    
    
if @@error <> 0 return    
    
update @835ImportParse    
set Element9 = null    
where rtrim(Element9) in ('',null)    
    
if @@error <> 0 return    
    
update @835ImportParse    
set Element10 = null    
where rtrim(Element10) in ('',null)    
    
if @@error <> 0 return    
    
update @835ImportParse    
set Element11 = null    
where rtrim(Element11) in ('',null)    
    
if @@error <> 0 return    
    
update @835ImportParse    
set Element12 = null    
where rtrim(Element12) in ('',null)    
    
if @@error <> 0 return    
    
update @835ImportParse    
set Element13 = null    
where rtrim(Element13) in ('',null)    
    
if @@error <> 0 return    
    
update @835ImportParse    
set Element14 = null    
where rtrim(Element14) in ('',null)    
    
if @@error <> 0 return    
    
update @835ImportParse    
set Element15 = null    
where rtrim(Element15) in ('',null)    
    
if @@error <> 0 return    
    
update @835ImportParse    
set Element16 = null    
where rtrim(Element16) in ('',null)    
    
if @@error <> 0 return    
    
update @835ImportParse    
set Element17 = null    
where rtrim(Element17) in ('',null)    
    
if @@error <> 0 return    
    
update @835ImportParse    
set Element18 = null    
where rtrim(Element18) in ('',null)    
    
if @@error <> 0 return    
    
update @835ImportParse    
set Element19 = null    
where rtrim(Element19) in ('',null)    
    
if @@error <> 0 return    
    
update @835ImportParse    
set Element20 = null    
where rtrim(Element20) in ('',null)    
    
if @@error <> 0 return    
    
-- Get first line number for the file    
declare @FirstLine int    
    
select @FirstLine = min(LineNumber)    
from @835ImportParse    
    
if @@error <> 0 return    
    
    
    
    
--Get Check Amount    
Declare @835Batch table    
(ERFileSegmentId int not null,    
 ERFileId int  null,    
 HandlingCode char(1)  null,    
 CheckAmount money null,    
 AmountAutoPaid money null,    
 CheckDate datetime  null,    
 CheckNumber varchar(30),    
 BatchStartId int null,    
 BatchEndId int null,    
 BatchNumber int null    
)    
     
declare @CheckAmount money    
declare @AmountManualPaid money    
declare @AmountAutoPaid money    
declare @CheckDate datetime    
declare @CheckNumber varchar(25)    
    
--select @ERSenderId = Element2    
--from @835ImportParse    
--where segment = 'GS'    
    
if @@error <> 0 return    
    
insert into @835Batch    
(ERFileSegmentId, HandlingCode, CheckAmount, CheckDate)    
select ERFileSegmentId, Element1, 
case 
	when Element3 = 'C' then convert(money, Element2)
	when Element3 = 'D' then  
		case
			when convert(money, Element2) > 0 then -convert(money, Element2)
			else convert(money, Element2)
		end
end,
convert(datetime,substring(Element16,5,2) + '/' + substring(Element16,7,2) +     
'/' + substring(Element16,1,4))    
from @835ImportParse    
where segment = 'BPR'    
    
if @@error <> 0 return    
  
update @835Batch  
set HandlingCode = 'I'  
    
update b    
set b.ERFileId = s.ERFileId    
from @835Batch b    
Join ERFileSegments s on s.ERFileSegmentId = b.ERFileSegmentId    
    
  
update a    
set CheckNumber = Element2    
from @835Batch a    
JOIN @835ImportParse b ON (b.ERFileSegmentId = (a.ERFileSegmentId + 1))    
where segment = 'TRN'    
    
if @@error <> 0 return    
    
update @835Batch    
set BatchStartId = ERFileSegmentId - 1    
    
if @@error <> 0 return    
    
    
update a    
set BatchEndId = b.ERFileSegmentId    
from @835Batch a    
JOIN @835ImportParse b ON (b.ERFileSegmentId > a.ERFileSegmentId)    
where b.segment = 'SE'    
and not exists    
(select * from @835ImportParse c    
where c.segment = 'SE'    
and c.ERFileSegmentId > a.ERFileSegmentId    
and c.ERFileSegmentId < b.ERFileSegmentId)    
    
if @@error <> 0 return    
    
    
    
 if exists (select * from ERBatches a    
    JOIN @835Batch b ON (a.CheckNumber = b.CheckNumber    
    and a.CheckDate = b.CheckDate)    
    where --a.ERSenderId = @ERSenderId  srf ??    
   --  b.ERFileSegmentId = a.ERBatchId    
    isnull(a.RecordDeleted, 'N')= 'N')    
 begin    
   Set @ErrorMessage = 'File has already been imported and processed.'     
       
    --Set Processing Flag for File    
  Update ERFiles    
  Set Processing = 'N'    
  where ERFileId = @ERFileId    
      
  goto do_not_process    
      
 end    
    
    
-- Link Claim and Service Segments    
create table #ClaimSegmentLink    
(BatchERFileSegmentId int null,    
ClaimId int null,    
PatientNameId int null,    
PayorBatchId int null)    
    
create index temp_ClaimSegmentLink1 on #ClaimSegmentLink(ClaimId)    
    
create table #ClaimAdjustmentLink    
(ClaimId int null,    
AdjustmentId int null)    
    
create table #ServiceSegmentLink    
(ClaimId int null,    
ServiceId int null,    
ServiceDateId int null,    
LineItemNoId int null,   
ClaimLineItemId int null,
LineItemControlNumber varchar(30) null,   
ClassOfContractCodeId INT NULL,
AdjustmentId1 int null,    
AdjustmentId2 int null,    
AdjustmentId3 int null,    
AdjustmentId4 int null,    
AdjustmentId5 int null)    
    
create index temp_ServiceSegmentLink1 on #ServiceSegmentLink(ClaimId)    
create index temp_ServiceSegmentLink2 on #ServiceSegmentLink(ClaimId,ServiceId)
create index temp_ServiceSegmentLink3 on #ServiceSegmentLink(ServiceId,ClaimId)

    
create table #ServiceAdjustmentLink    
(ClaimId int null,    
ServiceId int null,    
AdjustmentId int null)    
    
create table #PLBSegment    
(BatchERFileSegmentId int null,    
PLBId int null,    
FiscalPeriodDate datetime null,    
AdjustmentIdentifier1 varchar(35) null,    
AdjustmentAmount1 money null,    
AdjustmentIdentifier2 varchar(35) null,    
AdjustmentAmount2 money null,    
AdjustmentIdentifier3 varchar(35) null,    
AdjustmentAmount3 money null,    
AdjustmentIdentifier4 varchar(35) null,    
AdjustmentAmount4 money null,    
AdjustmentIdentifier5 varchar(35) null,    
AdjustmentAmount5 money null,    
AdjustmentIdentifier6 varchar(35) null,    
AdjustmentAmount6 money null)    
    
create table #ClaimServiceCount    
(ClaimId int not null,    
ServiceCount int not null,    
ClaimPaidAmount money null,    
TotalServicePaid money null)    
    
create table #ServicePaidAmount    
(ClaimId int not null,    
ServiceId int null,    
ServiceFraction decimal(9,2) null,    
ChargeAmount money null,    
PaidAmount decimal(10,2) null)    
    
create table #ClaimServiceSum    
(ClaimId int not null,    
ServicePaidSum decimal(10,2) null)    
    
    
insert into #ClaimSegmentLink    
(ClaimId, BatchERFileSegmentId)    
select a.ERFileSegmentId, b.ERFileSegmentId    
from @835ImportParse a    
JOIN @835Batch b ON (a.ERFileSegmentId > b.ERFileSegmentId)    
where segment = 'CLP'    
and not exists    
(select * from @835Batch c    
where a.ERFileSegmentId > c.ERFileSegmentId    
and b.ERFileSegmentId < c.ERFileSegmentId)    
    
if @@error <> 0 return    
 


update a    
set PatientNameId = b.ERFileSegmentId    
from #ClaimSegmentLink a    
JOIN @835ImportParse b ON (b.ERFileSegmentId > a.ClaimId    
and b.ERFileSegmentId < (a.ClaimId + 100))    
where segment = 'NM1'    
and Element1 = 'QC'    
and not exists    
(select * from #ClaimSegmentLink c    
where c.ClaimId > a.ClaimId    
and b.ERFileSegmentId > c.ClaimId    
and b.ERFileSegmentId < (c.ClaimId + 100))    
    
if @@error <> 0 return    
    
update a    
set PayorBatchId = b.ERFileSegmentId    
from #ClaimSegmentLink a    
JOIN @835ImportParse b ON (b.ERFileSegmentId > a.ClaimId    
and b.ERFileSegmentId < (a.ClaimId + 50))    
where segment = 'REF'    
and b.Element1 = 'F8'    
and not exists    
(select * from #ClaimSegmentLink c    
where c.ClaimId > a.ClaimId    
and b.ERFileSegmentId > c.ClaimId    
and b.ERFileSegmentId < (c.ClaimId + 50))    
    
if @@error <> 0 return    
    
    
    
insert into #ServiceSegmentLink    
(ClaimId, ServiceId)    
select a.ClaimId, b.ERFileSegmentId    
from #ClaimSegmentLink a    
JOIN @835ImportParse b ON (b.ERFileSegmentId > a.ClaimId    
and b.ERFileSegmentId < (a.ClaimId + 500))    
where segment = 'SVC'    
and not exists    
(select * from #ClaimSegmentLink c    
where c.ClaimId > a.ClaimId    
and b.ERFileSegmentId > c.ClaimId    
and b.ERFileSegmentId < (c.ClaimId + 500))    
    
if @@error <> 0 return    
    
-- Add claims that do not have an SVC segment    
insert into #ServiceSegmentLink    
(ClaimId)    
select ClaimId    
from #ClaimSegmentLink a    
where not exists    
(select * from #ServiceSegmentLink b    
where a.ClaimId = b.ClaimId)    
    
if @@error <> 0 return    
update a    
set ServiceDateId = b.ERFileSegmentId    
from #ServiceSegmentLink a    
JOIN @835ImportParse b ON (b.ERFileSegmentId > a.ServiceId    
and b.ERFileSegmentId < (a.ServiceId + 5))    
where segment = 'DTM'    
and Element1 = '472'    
and not exists    
(select * from #ServiceSegmentLink c    
where c.ServiceId > a.ServiceId    
and b.ERFileSegmentId > c.ServiceId    
and b.ERFileSegmentId < (c.ServiceId + 5))    
    
if @@error <> 0 return    
    
update a    
set ServiceDateId = b.ERFileSegmentId    
from #ServiceSegmentLink a    
JOIN @835ImportParse b ON (b.ERFileSegmentId > a.ServiceId    
and b.ERFileSegmentId < (a.ServiceId + 5))    
where a.ServiceDateId is null    
and segment = 'DTM'    
and Element1 = '150'    
and not exists    
(select * from #ServiceSegmentLink c    
where c.ServiceId > a.ServiceId    
and b.ERFileSegmentId > c.ServiceId    
and b.ERFileSegmentId < (c.ServiceId + 5))    
    
if @@error <> 0 return    
    
-- For missing SVC segment    
update a    
set ServiceDateId = b.ERFileSegmentId    
from #ServiceSegmentLink a    
JOIN @835ImportParse b ON (b.ERFileSegmentId > a.ClaimId    
and b.ERFileSegmentId < (a.ClaimId + 50))    
where a.ServiceId is null    
and segment = 'DTM'    
and Element1 = '232'    
and not exists    
(select * from #ClaimSegmentLink c    
where c.ClaimId > a.ClaimId    
and b.ERFileSegmentId > c.ClaimId    
and b.ERFileSegmentId < (c.ClaimId + 50))    
    
if @@error <> 0 return    

update a    
set LineItemNoId = b.ERFileSegmentId, LineItemControlNumber = b.Element2
from #ServiceSegmentLink a    
JOIN @835ImportParse b ON (b.ERFileSegmentId > a.ServiceId    
and b.ERFileSegmentId < (a.ServiceId + 10))    
where b.Segment = 'REF'    
and b.Element1 = '6R'   
and not exists    
(select * from #ServiceSegmentLink c    
where c.ServiceId > a.ServiceId    
and b.ERFileSegmentId > c.ServiceId    
and b.ERFileSegmentId < (c.ServiceId + 10))   

UPDATE  a
SET     ClassOfContractCodeId = b.ERFileSegmentId
FROM    #ServiceSegmentLink a
        LEFT JOIN #ServiceSegmentLink c
            ON a.ClaimId < c.ClaimId
               AND NOT EXISTS ( SELECT  1
                                FROM    #ServiceSegmentLink d
                                WHERE   a.ClaimId < d.ClaimId
                                        AND c.ClaimId > d.ClaimId )
        JOIN @835ImportParse b
            ON b.Segment = 'REF'
               AND b.Element1 = 'CE'
               AND b.ERFileSegmentId BETWEEN a.ClaimId AND COALESCE(a.ServiceId, c.ClaimId,a.ClaimId + 10)
  

  
if @@error <> 0 return    

-- TER - 2013.08.11 - get claim line item from CLP segment if not sent as ref*6r
update  a
set     LineItemNoId = b.ERFileSegmentId,
        LineItemControlNumber = case when charindex('-', b.Element1) > 0
                                     then substring(b.Element1,
                                                    charindex('-', b.Element1)
                                                    + 1, 100)
                                     else null
                                end
from    #ServiceSegmentLink a
join    @835ImportParse b
on      a.ClaimId = b.ERFileSegmentId
where   b.Segment = 'CLP'
        and LineItemControlNumber is null
        --and not exists ( select *
        --                 from   #ServiceSegmentLink c
        --                 where  c.ServiceId < a.ServiceId
        --                        and b.ERFileSegmentId < c.ServiceId
        --                        and b.ERFileSegmentId > ( c.ServiceId - 10 ) )


if @@error <> 0 return    

update #ServiceSegmentLink
set ClaimLineItemId = CONVERT(int, LineItemControlNumber)
where ISNUMERIC(LineItemControlNumber) = 1  

-- Remove the ClaimLineItemId when the patient control number doesn't match


UPDATE  a
SET     ClaimLineItemId = NULL
FROM    #ServiceSegmentLink a
        JOIN @835ImportParse b
            ON b.ERFileSegmentId = a.ClaimId
WHERE   b.Segment = 'CLP'
        AND NOT EXISTS ( SELECT 1
                         FROM   dbo.ClaimLineItems cli
                                JOIN dbo.ClaimLineItemGroups clig
                                    ON cli.ClaimLineItemGroupId = clig.ClaimLineItemGroupId
                         WHERE  cli.ClaimLineItemId = a.ClaimLineItemId
                                AND CAST(clig.ClientId AS VARCHAR) + '-' + CAST(a.ClaimLineItemId AS VARCHAR) = b.Element1 )
                         --FROM   dbo.ClaimLineItemCharges clic
                         --       JOIN dbo.Charges c
                         --           ON clic.ChargeId = c.ChargeId
                         --       JOIN dbo.Services s
                         --           ON c.ServiceId = s.ServiceId
                         --WHERE  clic.ClaimLineItemId = a.ClaimLineItemId )

if @@error <> 0 return    

-- Calculate service paid amount    
-- in case of reversals the total of service paid amounts     
-- does not equal claim paid amount     
    
-- Get Claim Service Count and Payment amount    
insert into #ClaimServiceCount    
(ClaimId, ClaimPaidAmount, ServiceCount,TotalServicePaid)    
select a.ClaimId, convert(money, b.Element4), count(*),     
sum(isnull(convert(money, c.Element3),0))    
from #ServiceSegmentLink a    
JOIN @835ImportParse b ON (a.ClaimId = b.ERFileSegmentId)    
JOIN @835ImportParse c ON (a.ServiceId = c.ERFileSegmentId)    
where a.ServiceId is not null     
and b.segment = 'CLP'    
and ISNUMERIC(c.Element3)=1     
and ISNUMERIC(b.Element4 )=1    
group by a.ClaimId, convert(money, b.Element4)    
    
if @@error <> 0 return    
  
-- Case where SVC is missing    
insert into #ClaimServiceCount    
(ClaimId, ClaimPaidAmount, ServiceCount,TotalServicePaid)    
select a.ClaimId, convert(money, b.Element4), 1, convert(money, b.Element4)    
from #ServiceSegmentLink a    
JOIN @835ImportParse b ON (a.ClaimId = b.ERFileSegmentId)    
where a.ServiceId is null    
    
    
    
    
    
if @@error <> 0 return    
    
--25/10/2012
declare @el2 varchar(1000), @el3 varchar(1000), @cId int, @sId int, @sCount int
declare c1 cursor for
select a.ClaimId, a.ServiceId, b.ServiceCount, c.Element2, c.Element3
from #ServiceSegmentLink a    
JOIN #ClaimServiceCount b ON (a.ClaimId = b.ClaimId)    
JOIN @835ImportParse c ON (a.ServiceId = c.ERFileSegmentId)    
where a.ServiceId is not null    
    
open c1

fetch c1 into @cId, @sId, @sCount, @el2, @el3
while @@FETCH_STATUS = 0
begin
	insert into #ServicePaidAmount
	(ClaimId, ServiceId, ServiceFraction, ChargeAmount, PaidAmount)
	values (
		@cId, @sId,
		convert(decimal(9,2),1)/convert(decimal(9,2), @sCount),
		isnull(convert(money, @el2),0), isnull(convert(money, @el3),0)
	)

if @@error <> 0 return    
    
	fetch c1 into @cId, @sId, @sCount, @el2, @el3

end

close c1

deallocate c1

if @@error <> 0 return


--insert into #ServicePaidAmount
--(ClaimId, ServiceId, ServiceFraction, ChargeAmount, PaidAmount)
--select a.ClaimId, a.ServiceId,
--convert(decimal(9,2),1)/convert(decimal(9,2),b.ServiceCount),
----isnull(convert(money, CONVERT(decimal(9,2), c.Element2)),0), isnull(convert(money, CONVERT(decimal(9,2), c.Element3)),0)
--isnull(convert(money, c.Element2),0), isnull(convert(money, c.Element3),0)
--from #ServiceSegmentLink a
--JOIN #ClaimServiceCount b ON (a.ClaimId = b.ClaimId)
--JOIN @835ImportParse c ON (a.ServiceId = c.ERFileSegmentId)
--where a.ServiceId is not null

--if @@error <> 0 return

print 'after2'
insert into #ServicePaidAmount    
(ClaimId, ServiceId, ServiceFraction, ChargeAmount, PaidAmount)    
select a.ClaimId, a.ServiceId, 1, isnull(convert(money, c.Element3),0),    
b.ClaimPaidAmount    
from #ServiceSegmentLink a    
JOIN #ClaimServiceCount b ON (a.ClaimId = b.ClaimId)    
JOIN @835ImportParse c ON (a.ClaimId = c.ERFileSegmentId)    
where a.ServiceId is null    
and ISNUMERIC(c.Element3) = 1
    
if @@error <> 0 return    
    
update a    
set PaidAmount = b.ClaimPaidAmount*a.ServiceFraction    
from #ServicePaidAmount a    
JOIN #ClaimServiceCount b ON (a.ClaimId = b.ClaimId)    
where b.ClaimPaidAmount <> b.TotalServicePaid    
    
if @@error <> 0 return    
    
insert into #ClaimServiceSum    
(ClaimId, ServicePaidSum)    
select ClaimId, sum(PaidAmount)    
from #ServicePaidAmount    
group by ClaimId    
    
if @@error <> 0 return    
    
-- The difference between the claim paid amount and the sum of service paid amounts    
-- is applied to the first service for the claim    
update a    
set PaidAmount = a.PaidAmount + c.ClaimPaidAmount - b.ServicePaidSum    
from #ServicePaidAmount a    
JOIN #ClaimServiceSum b ON (a.ClaimId = b.ClaimId)    
JOIN #ClaimServiceCount c ON (a.ClaimId = c.ClaimId)    
where c.ClaimPaidAmount <> c.TotalServicePaid    
and not exists    
(select * from #ServicePaidAmount c    
where a.ClaimId = c.ClaimId    
and c.ServiceId < a.ServiceId)    
    
if @@error <> 0 return    
    
/*    
update a    
set PaidAmount = b.ClaimPaidAmount*a.ServiceFraction    
from #ServicePaidAmount a    
JOIN #ClaimServiceCount b ON (a.ClaimId = b.ClaimId)    
where b.ClaimPaidAmount <> b.TotalServicePaid    
*/    
-- Claim Level Adjustments    
-- The claim level adjustment is between the claim record    
-- and the first service record    
insert into #ClaimAdjustmentLink    
(ClaimId, AdjustmentId)    
select a.ClaimId, b.ERFileSegmentId    
from #ServiceSegmentLink a     
JOIN @835ImportParse b ON (b.ERFileSegmentId > a.ClaimId --srf ERFileSegments replaced    
and b.ERFileSegmentId < (a.ClaimId + 10)    
and b.ERFileSegmentId < a.ServiceId)    
where b.segment = 'CAS'    
and a.ServiceId is not null    
and not exists    
(select * from #ServiceSegmentLink c    
where a.ClaimId = c.ClaimId    
and c.ServiceId < a.ServiceId)    
    
if @@error <> 0 return    
    
insert into #ClaimAdjustmentLink    
(ClaimId, AdjustmentId)    
select a.ClaimId, b.ERFileSegmentId    
from #ServiceSegmentLink a     
JOIN @835ImportParse b ON (b.ERFileSegmentId > a.ClaimId --srf ERFileSegments replaced    
and b.ERFileSegmentId < (a.ClaimId + 10))    
where b.segment = 'CAS'    
and a.ServiceId is null    
and not exists    
(select * from #ServiceSegmentLink c    
where b.ERFileSegmentId > c.ClaimId    
and c.ClaimId > a.ClaimId)    
    
if @@error <> 0 return    
    
-- Service Level Adjustments    
-- The service level adjustment is service record     
-- and another service record for the same claim     
-- or between the service record and the next claim record    
insert into #ServiceAdjustmentLink    
(ClaimId, ServiceId, AdjustmentId)    
select a.ClaimId, a.ServiceId, b.ERFileSegmentId    
from #ServiceSegmentLink a     
JOIN @835ImportParse b ON (b.ERFileSegmentId > a.ServiceId --srf replaced ERFileSegments    
and b.ERFileSegmentId < (a.ServiceId + 10))    
where b.segment = 'CAS'    
and not exists (select * from #ServiceSegmentLink c    
where a.ClaimId = c.ClaimId    
and c.ServiceId > a.ServiceId    
and b.ERFileSegmentId > c.ServiceId)    
and not exists (select * from #ClaimSegmentLink c    
where c.ClaimId > a.ClaimId    
and b.ERFileSegmentId > c.ClaimId)    
    
if @@error <> 0 return    
    
-- Update Adjustment ids in #ClaimSegmentLink    
-- These ids can come from claim level adjustments or service level adjustments    
update a    
set AdjustmentId1 = b.AdjustmentId    
from #ServiceSegmentLink a    
JOIN #ClaimAdjustmentLink b ON (a.ClaimId = b.ClaimId)    
where a.AdjustmentId1 is null    
and not exists    
(select * from #ClaimAdjustmentLink c    
where a.ClaimId = c.ClaimId    
and c.AdjustmentId < b.AdjustmentId)    
    
if @@error <> 0 return    
    
update a    
set AdjustmentId2 = b.AdjustmentId    
from #ServiceSegmentLink a    
JOIN #ClaimAdjustmentLink b ON (a.ClaimId = b.ClaimId)    
where a.AdjustmentId1 is not null    
and a.AdjustmentId2 is null    
and b.AdjustmentId <> a.AdjustmentId1    
and not exists    
(select * from #ClaimAdjustmentLink c    
where a.ClaimId = c.ClaimId    
and c.AdjustmentId <> a.AdjustmentId1    
and c.AdjustmentId < b.AdjustmentId)    
    
if @@error <> 0 return    
    
update a    
set AdjustmentId3 = b.AdjustmentId    
from #ServiceSegmentLink a    
JOIN #ClaimAdjustmentLink b ON (a.ClaimId = b.ClaimId)    
where a.AdjustmentId1 is not null    
and a.AdjustmentId2 is not null    
and a.AdjustmentId3 is null    
and b.AdjustmentId <> a.AdjustmentId1    
and b.AdjustmentId <> a.AdjustmentId2    
and not exists    
(select * from #ClaimAdjustmentLink c    
where a.ClaimId = c.ClaimId    
and c.AdjustmentId <> a.AdjustmentId1    
and c.AdjustmentId <> a.AdjustmentId2    
and c.AdjustmentId < b.AdjustmentId)    
    
if @@error <> 0 return    
    
update a    
set AdjustmentId4 = b.AdjustmentId    
from #ServiceSegmentLink a    
JOIN #ClaimAdjustmentLink b ON (a.ClaimId = b.ClaimId)    
where a.AdjustmentId1 is not null    
and a.AdjustmentId2 is not null    
and a.AdjustmentId3 is not null    
and a.AdjustmentId4 is null    
and b.AdjustmentId <> a.AdjustmentId1    
and b.AdjustmentId <> a.AdjustmentId2    
and b.AdjustmentId <> a.AdjustmentId3    
and not exists    
(select * from #ClaimAdjustmentLink c    
where a.ClaimId = c.ClaimId    
and c.AdjustmentId <> a.AdjustmentId1    
and c.AdjustmentId <> a.AdjustmentId2    
and c.AdjustmentId <> a.AdjustmentId3    
and c.AdjustmentId < b.AdjustmentId)    
    
if @@error <> 0 return    
    
update a    
set AdjustmentId5 = b.AdjustmentId    
from #ServiceSegmentLink a    
JOIN #ClaimAdjustmentLink b ON (a.ClaimId = b.ClaimId)    
where a.AdjustmentId1 is not null    
and a.AdjustmentId2 is not null    
and a.AdjustmentId3 is not null    
and a.AdjustmentId4 is not null    
and a.AdjustmentId5 is null    
and b.AdjustmentId <> a.AdjustmentId1    
and b.AdjustmentId <> a.AdjustmentId2    
and b.AdjustmentId <> a.AdjustmentId3    
and b.AdjustmentId <> a.AdjustmentId4    
and not exists    
(select * from #ClaimAdjustmentLink c    
where a.ClaimId = c.ClaimId    
and c.AdjustmentId <> a.AdjustmentId1    
and c.AdjustmentId <> a.AdjustmentId2    
and c.AdjustmentId <> a.AdjustmentId3    
and c.AdjustmentId <> a.AdjustmentId4    
and c.AdjustmentId < b.AdjustmentId)    
    
if @@error <> 0 return    
    
-- Service Level    
update a    
set AdjustmentId1 = b.AdjustmentId    
from #ServiceSegmentLink a    
JOIN #ServiceAdjustmentLink b ON (a.ServiceId = b.ServiceId)    
where a.AdjustmentId1 is null    
and not exists    
(select * from #ServiceAdjustmentLink c    
where a.ServiceId = c.ServiceId    
and c.AdjustmentId < b.AdjustmentId)    
    
if @@error <> 0 return    
    
update a    
set AdjustmentId2 = b.AdjustmentId    
from #ServiceSegmentLink a    
JOIN #ServiceAdjustmentLink b ON (a.ServiceId = b.ServiceId)    
where a.AdjustmentId1 is not null    
and a.AdjustmentId2 is null    
and b.AdjustmentId <> a.AdjustmentId1    
and not exists    
(select * from #ServiceAdjustmentLink c    
where a.ServiceId = c.ServiceId    
and c.AdjustmentId <> a.AdjustmentId1    
and c.AdjustmentId < b.AdjustmentId)    
    
if @@error <> 0 return    
    
update a    
set AdjustmentId3 = b.AdjustmentId    
from #ServiceSegmentLink a    
JOIN #ServiceAdjustmentLink b ON (a.ServiceId = b.ServiceId)    
where a.AdjustmentId1 is not null    
and a.AdjustmentId2 is not null    
and a.AdjustmentId3 is null    
and b.AdjustmentId <> a.AdjustmentId1    
and b.AdjustmentId <> a.AdjustmentId2    
and not exists    
(select * from #ServiceAdjustmentLink c    
where a.ServiceId = c.ServiceId    
and c.AdjustmentId <> a.AdjustmentId1    
and c.AdjustmentId <> a.AdjustmentId2    
and c.AdjustmentId < b.AdjustmentId)    
    
if @@error <> 0 return    
    
update a    
set AdjustmentId4 = b.AdjustmentId    
from #ServiceSegmentLink a    
JOIN #ServiceAdjustmentLink b ON (a.ServiceId = b.ServiceId)    
where a.AdjustmentId1 is not null    
and a.AdjustmentId2 is not null    
and a.AdjustmentId3 is not null    
and a.AdjustmentId4 is null    
and b.AdjustmentId <> a.AdjustmentId1    
and b.AdjustmentId <> a.AdjustmentId2    
and b.AdjustmentId <> a.AdjustmentId3    
and not exists    
(select * from #ServiceAdjustmentLink c    
where a.ServiceId = c.ServiceId    
and c.AdjustmentId <> a.AdjustmentId1    
and c.AdjustmentId <> a.AdjustmentId2    
and c.AdjustmentId <> a.AdjustmentId3    
and c.AdjustmentId < b.AdjustmentId)    
    
if @@error <> 0 return    
    
update a    
set AdjustmentId5 = b.AdjustmentId    
from #ServiceSegmentLink a    
JOIN #ServiceAdjustmentLink b ON (a.ServiceId = b.ServiceId)    
where a.AdjustmentId1 is not null    
and a.AdjustmentId2 is not null    
and a.AdjustmentId3 is not null    
and a.AdjustmentId4 is not null    
and a.AdjustmentId5 is null    
and b.AdjustmentId <> a.AdjustmentId1    
and b.AdjustmentId <> a.AdjustmentId2    
and b.AdjustmentId <> a.AdjustmentId3    
and b.AdjustmentId <> a.AdjustmentId4    
and not exists    
(select * from #ServiceAdjustmentLink c    
where a.ServiceId = c.ServiceId    
and c.AdjustmentId <> a.AdjustmentId1    
and c.AdjustmentId <> a.AdjustmentId2    
and c.AdjustmentId <> a.AdjustmentId3    
and c.AdjustmentId <> a.AdjustmentId4    
and c.AdjustmentId < b.AdjustmentId)    
    
if @@error <> 0 return    
    
-- Get information from PLB segment    
insert into #PLBSegment    
(BatchERFileSegmentId, PLBId, FiscalPeriodDate ,    
AdjustmentIdentifier1 ,  AdjustmentAmount1 ,    
AdjustmentIdentifier2 ,  AdjustmentAmount2 ,    
AdjustmentIdentifier3 ,  AdjustmentAmount3 ,    
AdjustmentIdentifier4 ,  AdjustmentAmount4 ,    
AdjustmentIdentifier5 ,  AdjustmentAmount5 ,    
AdjustmentIdentifier6 ,  AdjustmentAmount6 )    
select b.ERFileSegmentId, a.ERFileSegmentId,     
convert(datetime,substring(a.Element2,5,2) + '/' + substring(a.Element2,7,2) +     
'/' + substring(a.Element2,1,4)),    
a.Element3, convert(money,a.Element4), a.Element5, convert(money,a.Element6),     
a.Element7, convert(money,a.Element8), a.Element9, convert(money,a.Element10),     
a.Element11, convert(money,a.Element12), a.Element13, convert(money,a.Element14)    
from @835ImportParse a    
JOIN @835Batch b ON (a.ERFileSegmentId > b.ERFileSegmentId)    
where segment = 'PLB'    
and not exists    
(select * from @835Batch c    
where a.ERFileSegmentId > c.ERFileSegmentId    
and c.ERFileSegmentId > b.ERFileSegmentId)    
    
if @@error <> 0 return    
  
    
-- Enter data into batch    
begin tran    
    
if @@error <> 0 return    
    
-- Create batch information    
declare @BatchDetailId int, @BatchStartId int, @BatchEndId int    
declare @BatchCount int, @TotalBatches int    
declare @HandlingCode char(1)    
    
select @BatchCount = 0, @TotalBatches = count(*)    
from @835Batch    
    
if @@error <> 0 goto error    
  If Cursor_Status('global','cur_batch')>=-1 BEGIN    
CLOSE cur_batch    
DEALLOCATE cur_batch    
END    
declare cur_batch cursor for    
select ERFileSegmentId, BatchStartId, BatchEndId, HandlingCode    
from @835Batch    
order by ERFileSegmentId    
    
if @@error <> 0 goto error    
    
open cur_batch    
    
if @@error <> 0     
begin    
 deallocate cur_batch    
 goto error    
end    
   
fetch cur_batch into @BatchDetailId, @BatchStartId, @BatchEndId, @HandlingCode    
    
if @@error <> 0     
begin    
 close cur_batch    
 deallocate cur_batch    
 goto error    
end    
    
while @@fetch_status = 0    
begin    
    
select @BatchCount = @BatchCount  + 1    
    
-- Only handle remittance    
if @HandlingCode <> 'I'  goto fetch_next    
    
-- Check if the file was imported before    
    
--LOOK INTO    
if exists (select * from ERBatches a    
 JOIN @835Batch b ON (a.CheckNumber = b.CheckNumber    
 and a.CheckDate = b.CheckDate)    
 where --a.ERSenderId = @ERSenderId  srf ??    
  b.ERFileSegmentId = @BatchDetailId    
 and isnull(a.RecordDeleted, 'N')= 'N')    
begin    
 insert into @ParseErrors    
 (LineNumber, ErrorMessage, LineDataText)    
 values    
 (1, 'File has been imported once', NULL) --?? what do i use for line number?    
-- select @ErrorNo = 30005, @ErrorMessage = 'File has been imported once'    
 close cur_batch    
 deallocate cur_batch    
 goto error    
end    
    
   
insert into ERBatches    
(ERFileID, SenderBatchId, CheckAmount, CheckDate, CheckNumber, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)    
select ERFileId, 1, CheckAmount,  CheckDate, CheckNumber, @UserCode,getdate(), @UserCode, getdate()    
from @835Batch    
where ERFileSegmentId = @BatchDetailId    
    
select @BatchNumber = @@identity    
    
   
if @BatchNumber < 1    
begin    
 insert into @ParseErrors    
 (LineNumber, ErrorMessage, LineDataText)    
 values    
 (1, 'Failure to create batch record', NULL)    
-- select @ErrorNo = 30002, @ErrorMessage = 'Failure to create batch record'    
 close cur_batch    
 deallocate cur_batch    
 goto error    
end    
    
update @835Batch    
set BatchNumber = @BatchNumber    
where ERFileSegmentId = @BatchDetailId    
    
if @@error <> 0     
begin    
 close cur_batch    
 deallocate cur_batch    
 goto error    
end    
    
/*    
LOOK INTO    
if @BatchCount = 1    
 insert into ERBatches_Detail    
 (BatchNumber , data_text)    
 select @BatchNumber, a.data_text    
 from Cstm_835_Import_Temp a    
 where a.ERFileSegmentId <= @BatchEndId    
 order by a.ERFileSegmentId    
else if @BatchCount = @TotalBatches    
 insert into ERBatches_Detail    
 (BatchNumber , data_text)    
 select @BatchNumber, a.data_text    
 from Cstm_835_Import_Temp a    
 where a.ERFileSegmentId >= @BatchStartId    
 order by a.ERFileSegmentId    
else    
 insert into ERBatches_Detail    
 (BatchNumber , data_text)    
 select @BatchNumber, a.data_text    
 from Cstm_835_Import_Temp a    
 where a.ERFileSegmentId >= @BatchStartId    
 and a.ERFileSegmentId <= @BatchEndId    
 order by a.ERFileSegmentId    
    
    
if @@error <> 0     
begin    
 close cur_batch    
 deallocate cur_batch    
 goto error    
end    
*/    
    
    
insert into ERBatchProviderAdjustments    
(ERBatchID, FiscalPeriodDate ,    
AdjustmentIdentifier1 ,  AdjustmentAmount1 ,    
AdjustmentIdentifier2 ,  AdjustmentAmount2 ,    
AdjustmentIdentifier3 ,  AdjustmentAmount3 ,    
AdjustmentIdentifier4 ,  AdjustmentAmount4 ,    
AdjustmentIdentifier5 ,  AdjustmentAmount5 ,    
AdjustmentIdentifier6 ,  AdjustmentAmount6 )    
select @BatchNumber,  FiscalPeriodDate ,    
AdjustmentIdentifier1 ,  AdjustmentAmount1 ,    
AdjustmentIdentifier2 ,  AdjustmentAmount2 ,    
AdjustmentIdentifier3 ,  AdjustmentAmount3 ,    
AdjustmentIdentifier4 ,  AdjustmentAmount4 ,    
AdjustmentIdentifier5 ,  AdjustmentAmount5 ,    
AdjustmentIdentifier6 ,  AdjustmentAmount6     
from #PLBSegment     
where BatchERFileSegmentId = @BatchDetailId    
    
    
if @@error <> 0     
begin    
 close cur_batch    
 deallocate cur_batch    
 goto error    
end    
    
    
fetch_next:    
    
fetch cur_batch into @BatchDetailId, @BatchStartId, @BatchEndId, @HandlingCode    
    
if @@error <> 0     
begin    
 close cur_batch    
 deallocate cur_batch    
 goto error    
end    
    
    
end    
    
close cur_batch    
    
if @@error <> 0     
begin    
 deallocate cur_batch    
 goto error    
end    
    
    
deallocate cur_batch    
    
    
insert  into ERClaimLineItems
        (
          ERBatchId,
          ClaimLineItemId,
          LineItemControlNumber,
          ClaimStatusCode,
          ClientName,
          ClientIdentifier,
          PayerClaimNumber,
          BillingCode,
          DateOfService, --srf ??    
          ChargeAmount,
          PaidAmount,    
          AdjustmentGroupCode11,
          AdjustmentReason11,
          AdjustmentAmount11,
          AdjustmentQuantity11,
          AdjustmentReason12,
          AdjustmentAmount12,
          AdjustmentQuantity12,
          AdjustmentReason13,
          AdjustmentAmount13,
          AdjustmentQuantity13,
          AdjustmentReason14,
          AdjustmentAmount14,
          AdjustmentQuantity14,
          AdjustmentGroupCode21,
          AdjustmentReason21,
          AdjustmentAmount21,
          AdjustmentQuantity21,
          AdjustmentReason22,
          AdjustmentAmount22,
          AdjustmentQuantity22,
          AdjustmentReason23,
          AdjustmentAmount23,
          AdjustmentQuantity23,
          AdjustmentReason24,
          AdjustmentAmount24,
          AdjustmentQuantity24,
          AdjustmentGroupCode31,
          AdjustmentReason31,
          AdjustmentAmount31,
          AdjustmentQuantity31,
          AdjustmentReason32,
          AdjustmentAmount32,
          AdjustmentQuantity32,
          AdjustmentReason33,
          AdjustmentAmount33,
          AdjustmentQuantity33,
          AdjustmentReason34,
          AdjustmentAmount34,
          AdjustmentQuantity34,
          AdjustmentGroupCode41,
          AdjustmentReason41,
          AdjustmentAmount41,
          AdjustmentQuantity41,
          AdjustmentReason42,
          AdjustmentAmount42,
          AdjustmentQuantity42,
          AdjustmentReason43,
          AdjustmentAmount43,
          AdjustmentQuantity43,
          AdjustmentReason44,
          AdjustmentAmount44,
          AdjustmentQuantity44,
          AdjustmentGroupCode51,
          AdjustmentReason51,
          AdjustmentAmount51,
          AdjustmentQuantity51,
          AdjustmentReason52,
          AdjustmentAmount52,
          AdjustmentQuantity52,
          AdjustmentReason53,
          AdjustmentAmount53,
          AdjustmentQuantity53,
          AdjustmentReason54,
          AdjustmentAmount54,
          AdjustmentQuantity54     
        )
        select  z.BatchNumber, 
                CLI.ClaimLineItemId,
                b.LineItemControlNumber,
                c.Element2 ,
                d.Element3 + ', ' + d.Element4,
                c.Element1,
                c.Element7,
                right(f.Element1, len(f.Element1) - 3),
                convert(datetime, substring(g.Element2, 5, 2) + '/'
                + substring(g.Element2, 7, 2) + '/' + substring(g.Element2, 1,
                                                              4)),
                j.ChargeAmount,
                j.PaidAmount, --k.CheckNumber, k.CheckDate,    
                h1.Element1,
                h1.Element2,
                convert(money, h1.Element3),
                convert(decimal(6, 2), h1.Element4),
                h1.Element5,
                convert(money, h1.Element6),
                convert(decimal(6, 2), h1.Element7),
                h1.Element8,
                convert(money, h1.Element9),
                convert(decimal(6, 2), h1.Element10),
                h1.Element11,
                convert(money, h1.Element12),
                convert(decimal(6, 2), h1.Element13),
                h2.Element1,
                h2.Element2,
                convert(money, h2.Element3),
                convert(decimal(6, 2), h2.Element4),
                h2.Element5,
                convert(money, h2.Element6),
                convert(decimal(6, 2), h2.Element7),
                h2.Element8,
                convert(money, h2.Element9),
                convert(decimal(6, 2), h2.Element10),
                h2.Element11,
                convert(money, h2.Element12),
                convert(decimal(6, 2), h2.Element13),
                h3.Element1,
                h3.Element2,
                convert(money, h3.Element3),
                convert(decimal(6, 2), h3.Element4),
                h3.Element5,
                convert(money, h3.Element6),
                convert(decimal(6, 2), h3.Element7),
                h3.Element8,
                convert(money, h3.Element9),
                convert(decimal(6, 2), h3.Element10),
                h3.Element11,
                convert(money, h3.Element12),
                convert(decimal(6, 2), h3.Element13),
                h4.Element1,
                h4.Element2,
                convert(money, h4.Element3),
                convert(decimal(6, 2), h4.Element4),
                h4.Element5,
                convert(money, h4.Element6),
                convert(decimal(6, 2), h4.Element7),
                h4.Element8,
                convert(money, h4.Element9),
                convert(decimal(6, 2), h4.Element10),
                h4.Element11,
                convert(money, h4.Element12),
                convert(decimal(6, 2), h4.Element13),
                h5.Element1,
                h5.Element2,
                convert(money, h5.Element3),
                convert(decimal(6, 2), h5.Element4),
                h5.Element5,
                convert(money, h5.Element6),
                convert(decimal(6, 2), h5.Element7),
                h5.Element8,
                convert(money, h5.Element9),
                convert(decimal(6, 2), h5.Element10),
                h5.Element11,
                convert(money, h5.Element12),
                convert(decimal(6, 2), h5.Element13)
        from    @835Batch z
        join    #ClaimSegmentLink a
        on      ( a.BatchERFileSegmentId = z.ERFileSegmentId )
        join    #ServiceSegmentLink b
        on      ( a.ClaimId = b.ClaimId )
        join    @835ImportParse c
        on      ( a.ClaimId = c.ERFileSegmentId )
        join    @835ImportParse d
        on      ( a.PatientNameId = d.ERFileSegmentId )
        left join @835ImportParse e
        on      ( a.PayorBatchId = e.ERFileSegmentId )
        left join @835ImportParse f
        on      ( b.ServiceId = f.ERFileSegmentId )
        join    @835ImportParse g
        on      b.ServiceDateId = g.ERFileSegmentId
                and g.segment = 'DTM'  --srf added so only rows with Service Date are returned     
        left join @835ImportParse h1
        on      ( b.AdjustmentId1 = h1.ERFileSegmentId )
        left join @835ImportParse h2
        on      ( b.AdjustmentId2 = h2.ERFileSegmentId )
        left join @835ImportParse h3
        on      ( b.AdjustmentId3 = h3.ERFileSegmentId )
        left join @835ImportParse h4
        on      ( b.AdjustmentId4 = h4.ERFileSegmentId )
        left join @835ImportParse h5
        on      ( b.AdjustmentId5 = h5.ERFileSegmentId )    
--LEFT JOIN ERFilesegments i ON (b.LineItemNoId = i.ERFileSegmentId)    
        join    #ServicePaidAmount j
        on      (
                  (
                    b.ServiceId is not null
                    and b.ServiceId = j.ServiceId
                  )
                  or (
                       b.ServiceId is null
                       and ( b.ClaimId = j.ClaimId )
                     )
                )
        join    ERBatches k
        on      ( z.BatchNumber = k.ERBatchId )    
--Added by Msuma to avoid Constraint Error    
--LEFT OUTER JOIN ClaimLineItems CLI ON(CLI.ClaimLineItemId = convert(int, substring(c.Element1, charindex('-', c.Element1) + 1 , len(c.Element1))))    
        left outer join ClaimLineItems CLI
        on      ( CLI.ClaimLineItemId = b.ClaimLineItemId )
        where   --len(substring(c.Element1,10,15)) <= 10  --srf ??    
/*  
len( substring(c.Element1, charindex('-', c.Element1) + 1 , len(c.Element1))) <=10    
--and isnumeric(substring(c.Element1,10,15)) = 1    
and isnumeric( substring(c.Element1, charindex('-', c.Element1) + 1 , len(c.Element1))) =1    
and c.Element1 like '%-%'    
and */          z.HandlingCode = 'I'    
  
--and b.LineItemNoId is not null --srf added so rows are not duplicated    
order by        a.ClaimId    
    
    -- need this for further delination of plans.
    INSERT  INTO dbo.CustomERClaimLineCustomFields
            ( ERClaimLineItemId
            ,ClassOfContractCode
            )
            SELECT DISTINCT
                    ecli.ERClaimLineItemId -- ERClaimLineItemId - int
                   ,c.Element2-- ClassOfContractCode - varchar(50)
            FROM    @835Batch z
                    JOIN #ClaimSegmentLink a
                        ON ( a.BatchERFileSegmentId = z.ERFileSegmentId )
                    JOIN #ServiceSegmentLink b
                        ON ( a.ClaimId = b.ClaimId )
                    JOIN dbo.ERClaimLineItems ecli
                        ON ecli.ERBatchId = z.BatchNumber
                           AND ISNUMERIC(b.LineItemControlNumber) = 1
                           AND ecli.ClaimLineItemId IS NOT NULL
                           AND ecli.ClaimLineItemId = b.LineItemControlNumber
                    JOIN @835ImportParse c
                        ON b.ClassOfContractCodeId = c.ERFileSegmentId


if @@error <> 0 goto error    
    
  
insert into ERClaimLineItemLog      
(ERClaimLineItemId , ErrorFlag, ERMessageType, ERMessage)      
select distinct ERClaimLineItemId, 'Y', 5233, 'ClaimLineItem '+  ISNULL(LineItemControlNumber,'NULL') 
+' does not exist in the system or Claim ID ' + ISNULL(a.ClientIdentifier,'NULL') + ' is incorrect.'      
from ERClaimLineItems a      
JOIN @835Batch z ON a.ERBatchId = z.BatchNumber -- Added by Venkatesh as per the task 1434
where a.ClaimLineItemId is null    
    
    
    
    
if @@error <> 0 goto error    
    
Insert into ERClaimLineItemAdjustments    
(ERClaimLineItemId, AdjustmentGroupCode, AdjustmentReason, AdjustmentAmount, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate)    
    
    
    
select ERClaimLineItemId, AdjustmentGroupCode11 , AdjustmentReason11, AdjustmentAmount11, @UserCode, getdate(), @UserCode, getdate()    
From ERClaimLineItems a    
Join @835Batch z on a.ERBatchId = z.BatchNumber    
Where isnull(a.AdjustmentReason11, '') <> ''    
and isnull(a.AdjustmentAmount11, '') <> ''    
and isnull(a.RecordDeleted, 'N') = 'N'    
UNION    
select ERClaimLineItemId, AdjustmentGroupCode11 , AdjustmentReason12, AdjustmentAmount12, @UserCode, getdate(), @UserCode, getdate()    
From ERClaimLineItems a    
Join @835Batch z on a.ERBatchId = z.BatchNumber    
Where isnull(a.AdjustmentReason12, '') <> ''    
and isnull(a.AdjustmentAmount12, '') <> ''    
and isnull(a.RecordDeleted, 'N') = 'N'    
UNION    
select ERClaimLineItemId, AdjustmentGroupCode11 , AdjustmentReason13, AdjustmentAmount13, @UserCode, getdate(), @UserCode, getdate()    
From ERClaimLineItems a    
Join @835Batch z on a.ERBatchId = z.BatchNumber    
Where isnull(a.AdjustmentReason13, '') <> ''    
and isnull(a.AdjustmentAmount13, '') <> ''    
and isnull(a.RecordDeleted, 'N') = 'N'    
UNION    
select ERClaimLineItemId, AdjustmentGroupCode11 , AdjustmentReason14, AdjustmentAmount14, @UserCode, getdate(), @UserCode, getdate()    
From ERClaimLineItems a    
Join @835Batch z on a.ERBatchId = z.BatchNumber    
Where isnull(a.AdjustmentReason14, '') <> ''    
and isnull(a.AdjustmentAmount14, '') <> ''    
and isnull(a.RecordDeleted, 'N') = 'N'    
UNION    
select ERClaimLineItemId, AdjustmentGroupCode21 , AdjustmentReason21, AdjustmentAmount21, @UserCode, getdate(), @UserCode, getdate()    
From ERClaimLineItems a    
Join @835Batch z on a.ERBatchId = z.BatchNumber    
Where isnull(a.AdjustmentReason21, '') <> ''    
and isnull(a.AdjustmentAmount21, '') <> ''    
and isnull(a.RecordDeleted, 'N') = 'N'    
UNION    
select ERClaimLineItemId, AdjustmentGroupCode21 , AdjustmentReason22, AdjustmentAmount22, @UserCode, getdate(), @UserCode, getdate()    
From ERClaimLineItems a    
Join @835Batch z on a.ERBatchId = z.BatchNumber    
Where isnull(a.AdjustmentReason22, '') <> ''    
and isnull(a.AdjustmentAmount22, '') <> ''    
and isnull(a.RecordDeleted, 'N') = 'N'    
UNION    
select ERClaimLineItemId, AdjustmentGroupCode21 , AdjustmentReason23, AdjustmentAmount23, @UserCode, getdate(), @UserCode, getdate()    
From ERClaimLineItems a    
Join @835Batch z on a.ERBatchId = z.BatchNumber    
Where isnull(a.AdjustmentReason23, '') <> ''    
and isnull(a.AdjustmentAmount23, '') <> ''    
and isnull(a.RecordDeleted, 'N') = 'N'    
UNION    
select ERClaimLineItemId, AdjustmentGroupCode21 , AdjustmentReason24, AdjustmentAmount24, @UserCode, getdate(), @UserCode, getdate()    
From ERClaimLineItems a    
Join @835Batch z on a.ERBatchId = z.BatchNumber    
Where isnull(a.AdjustmentReason24, '') <> ''    
and isnull(a.AdjustmentAmount24, '') <> ''    
and isnull(a.RecordDeleted, 'N') = 'N'    
UNION    
select ERClaimLineItemId, AdjustmentGroupCode31 , AdjustmentReason31, AdjustmentAmount31, @UserCode, getdate(), @UserCode, getdate()    
From ERClaimLineItems a    
Join @835Batch z on a.ERBatchId = z.BatchNumber    
Where isnull(a.AdjustmentReason31, '') <> ''    
and isnull(a.AdjustmentAmount31, '') <> ''    
and isnull(a.RecordDeleted, 'N') = 'N'    
UNION    
select ERClaimLineItemId, AdjustmentGroupCode31 , AdjustmentReason32, AdjustmentAmount32, @UserCode, getdate(), @UserCode, getdate()    
From ERClaimLineItems a    
Join @835Batch z on a.ERBatchId = z.BatchNumber    
Where isnull(a.AdjustmentReason32, '') <> ''    
and isnull(a.AdjustmentAmount32, '') <> ''    
and isnull(a.RecordDeleted, 'N') = 'N'    
UNION    
select ERClaimLineItemId, AdjustmentGroupCode31 , AdjustmentReason33, AdjustmentAmount33, @UserCode, getdate(), @UserCode, getdate()    
From ERClaimLineItems a    
Join @835Batch z on a.ERBatchId = z.BatchNumber    
Where isnull(a.AdjustmentReason33, '') <> ''    
and isnull(a.AdjustmentAmount33, '') <> ''    
and isnull(a.RecordDeleted, 'N') = 'N'    
UNION    
select ERClaimLineItemId, AdjustmentGroupCode31 , AdjustmentReason34, AdjustmentAmount34, @UserCode, getdate(), @UserCode, getdate()    
From ERClaimLineItems a    
Join @835Batch z on a.ERBatchId = z.BatchNumber    
Where isnull(a.AdjustmentReason34, '') <> ''    
and isnull(a.AdjustmentAmount34, '') <> ''    
and isnull(a.RecordDeleted, 'N') = 'N'    
UNION    
select ERClaimLineItemId, AdjustmentGroupCode41 , AdjustmentReason41, AdjustmentAmount41, @UserCode, getdate(), @UserCode, getdate()    
From ERClaimLineItems a    
Join @835Batch z on a.ERBatchId = z.BatchNumber    
Where isnull(a.AdjustmentReason41, '') <> ''    
and isnull(a.AdjustmentAmount41, '') <> ''    
and isnull(a.RecordDeleted, 'N') = 'N'    
UNION    
select ERClaimLineItemId, AdjustmentGroupCode51 , AdjustmentReason51, AdjustmentAmount51, @UserCode, getdate(), @UserCode, getdate()    
From ERClaimLineItems a    
Join @835Batch z on a.ERBatchId = z.BatchNumber    
Where isnull(a.AdjustmentReason51, '') <> ''    
and isnull(a.AdjustmentAmount51, '') <> ''    
and isnull(a.RecordDeleted, 'N') = 'N'    
UNION    
select ERClaimLineItemId, AdjustmentGroupCode51 , AdjustmentReason52, AdjustmentAmount52, @UserCode, getdate(), @UserCode, getdate()    
From ERClaimLineItems a    
Join @835Batch z on a.ERBatchId = z.BatchNumber    
Where isnull(a.AdjustmentReason52, '') <> ''    
and isnull(a.AdjustmentAmount52, '') <> ''    
and isnull(a.RecordDeleted, 'N') = 'N'    
UNION    
select ERClaimLineItemId, AdjustmentGroupCode51 , AdjustmentReason53, AdjustmentAmount53, @UserCode, getdate(), @UserCode, getdate()    
From ERClaimLineItems a    
Join @835Batch z on a.ERBatchId = z.BatchNumber    
Where isnull(a.AdjustmentReason53, '') <> ''    
and isnull(a.AdjustmentAmount53, '') <> ''    
and isnull(a.RecordDeleted, 'N') = 'N'    
UNION    
select ERClaimLineItemId, AdjustmentGroupCode51 , AdjustmentReason54, AdjustmentAmount54, @UserCode, getdate(), @UserCode, getdate()    
From ERClaimLineItems a    
Join @835Batch z on a.ERBatchId = z.BatchNumber    
Where isnull(a.AdjustmentReason54, '') <> ''    
and isnull(a.AdjustmentAmount54, '') <> ''    
and isnull(a.RecordDeleted, 'N') = 'N'    

    
if @@error <> 0 goto error    
  
-- Verify if the individual paid amounts add up to the total    
create table #BatchAutoPaid    
(BatchNumber int null, TotalAutoPaid money null)    
    
create table #BatchPLB    
(BatchNumber int null, TotalAutoPaid money null)    
    
-- Add the line item paid amounts     
insert into #BatchAutoPaid    
(BatchNumber, TotalAutoPaid)    
select a.BatchNumber, isnull(sum(b.PaidAmount),0)    
from @835Batch a     
LEFT JOIN ERClaimLineItems b ON (a.BatchNumber = b.ERBatchId)    
where a.HandlingCode = 'I'    
and isnull(b.RecordDeleted, 'N')= 'N'    
group by a.BatchNumber     
    
if @@error <> 0 goto error    
    
-- Add the provider adjustment paid amounts     
insert into #BatchPLB    
(BatchNumber, TotalAutoPaid)    
select a.BatchNumber, sum(isnull(b.AdjustmentAmount1,0) + isnull(b.AdjustmentAmount2,0)    
+ isnull(b.AdjustmentAmount3,0) + isnull(b.AdjustmentAmount4,0)    
+ isnull(b.AdjustmentAmount5,0) + isnull(b.AdjustmentAmount6,0))    
from @835Batch a     
LEFT JOIN ERBatchProviderAdjustments b ON (a.BatchNumber = b.ERBatchId)    
where a.HandlingCode = 'I'    
and isnull(b.RecordDeleted, 'N')= 'N'    
group by a.BatchNumber     
    
if @@error <> 0 goto error    
    
update a    
set TotalAutoPaid = a.TotalAutoPaid - b.TotalAutoPaid    
from #BatchAutoPaid a    
JOIN #BatchPLB b ON (a.BatchNumber = b.BatchNumber)    
    
if @@error <> 0 goto error    
  
-- Compare the total to the check amount     
if exists (select * from @835Batch a JOIN     
 #BatchAutoPaid b ON (a.BatchNumber = b.BatchNumber)    
 where a.HandlingCode = 'I'    
 and isnull(a.CheckAmount,0) <> isnull(b.TotalAutoPaid, 0))    
begin    
 insert into @ParseErrors    
 (LineNumber, ErrorMessage, LineDataText)    
 values --srf ?? what do i use for line number??    
 (1, 'Error: Computed total paid amount different from value sent in 835. Please contact system administrator.', NULL)    
    
 goto error    
end    
    
    
-- update provider adjustments in the batch table    
update a    
set TotalProviderAdjustments = b.TotalAutoPaid    
from ERBatches a    
JOIN #BatchPLB b ON (a.ERBatchId = b.BatchNumber)    
Where isnull(a.RecordDeleted, 'N')= 'N'    
    
    
if @@error <> 0 goto error    
    
-- Update the correct client id from the ClaimLineItemGroups table    
-- this should actually stay the patient id.

    
--update a    
--set ClientIdentifier = c.ClientId    
--from ERClaimLineItems a    
--JOIN ClaimLineItems b ON a.ClaimLineItemId = b.ClaimLineItemId    
--Join ClaimLineItemGroups c on b.ClaimLineItemGroupId = c.ClaimLineItemGroupId    
--where  isnull(a.RecordDeleted, 'N')= 'N'    
--and isnull(b.RecordDeleted, 'N')= 'N'    
--and isnull(c.RecordDeleted, 'N')= 'N'    
    
    
if @@error <> 0 goto error    
    
--begin tran

-- identify entries that offset each other exactly and delete them

SELECT  li.ERClaimLineItemId AS ERClaimLineItem1
       ,li2.ERClaimLineItemId AS ERClaimLineItem2
INTO    #ERClaimLineItemOffsets
FROM    ERClaimLineItems AS li
        JOIN ERBatches AS b
            ON b.ERBatchId = li.ERBatchId
        JOIN ERBatches AS b2
            ON b2.ERFileId = b.ERFileId
        JOIN ERClaimLineItems AS li2
            ON li2.ERBatchId = b2.ERBatchId
WHERE   b.ERFileId = @ERFileId
        AND li.PaidAmount < 0
        AND li2.DateOfService = li.DateOfService
        AND ABS(li2.ChargeAmount) = ABS(li.ChargeAmount)
        AND LTRIM(RTRIM(CASE WHEN CHARINDEX('-', li2.ClientIdentifier) > 1
                             THEN SUBSTRING(li2.ClientIdentifier, 1, CHARINDEX('-', li2.ClientIdentifier) - 1)
                             ELSE li2.ClientIdentifier
                        END)) = LTRIM(RTRIM(CASE WHEN CHARINDEX('-', li.ClientIdentifier) > 1
                                                 THEN SUBSTRING(li.ClientIdentifier, 1,
                                                                CHARINDEX('-', li.ClientIdentifier) - 1)
                                                 ELSE li.ClientIdentifier
                                            END))
        AND li2.PaidAmount + li.PaidAmount = 0.0
        AND ISNULL(li2.AdjustmentAmount11, 0.0) + ISNULL(li.AdjustmentAmount11, 0.0) = 0.0
        AND ISNULL(li2.AdjustmentAmount12, 0.0) + ISNULL(li.AdjustmentAmount12, 0.0) = 0.0
        AND ISNULL(li2.AdjustmentAmount13, 0.0) + ISNULL(li.AdjustmentAmount13, 0.0) = 0.0
        AND ISNULL(li2.AdjustmentAmount14, 0.0) + ISNULL(li.AdjustmentAmount14, 0.0) = 0.0
        AND ISNULL(li2.AdjustmentAmount21, 0.0) + ISNULL(li.AdjustmentAmount21, 0.0) = 0.0
        AND ISNULL(li2.AdjustmentAmount22, 0.0) + ISNULL(li.AdjustmentAmount22, 0.0) = 0.0
        AND ISNULL(li2.AdjustmentAmount23, 0.0) + ISNULL(li.AdjustmentAmount23, 0.0) = 0.0
        AND ISNULL(li2.AdjustmentAmount24, 0.0) + ISNULL(li.AdjustmentAmount24, 0.0) = 0.0
        AND ISNULL(li2.AdjustmentAmount31, 0.0) + ISNULL(li.AdjustmentAmount31, 0.0) = 0.0
        AND ISNULL(li2.AdjustmentAmount32, 0.0) + ISNULL(li.AdjustmentAmount32, 0.0) = 0.0
        AND ISNULL(li2.AdjustmentAmount33, 0.0) + ISNULL(li.AdjustmentAmount33, 0.0) = 0.0
        AND ISNULL(li2.AdjustmentAmount34, 0.0) + ISNULL(li.AdjustmentAmount34, 0.0) = 0.0
        AND ISNULL(li2.AdjustmentAmount41, 0.0) + ISNULL(li.AdjustmentAmount41, 0.0) = 0.0
        AND ISNULL(li2.AdjustmentAmount42, 0.0) + ISNULL(li.AdjustmentAmount42, 0.0) = 0.0
        AND ISNULL(li2.AdjustmentAmount43, 0.0) + ISNULL(li.AdjustmentAmount43, 0.0) = 0.0
        AND ISNULL(li2.AdjustmentAmount44, 0.0) + ISNULL(li.AdjustmentAmount44, 0.0) = 0.0
        AND ISNULL(li2.AdjustmentAmount51, 0.0) + ISNULL(li.AdjustmentAmount51, 0.0) = 0.0
        AND ISNULL(li2.AdjustmentAmount52, 0.0) + ISNULL(li.AdjustmentAmount52, 0.0) = 0.0
        AND ISNULL(li2.AdjustmentAmount53, 0.0) + ISNULL(li.AdjustmentAmount53, 0.0) = 0.0
        AND ISNULL(li2.AdjustmentAmount54, 0.0) + ISNULL(li.AdjustmentAmount54, 0.0) = 0.0

if @@error <> 0 goto error

-- delete any duplicate allocations
delete from a
from #ERClaimLineItemOffsets as a
where exists (
	select * from #ERClaimLineItemOffsets as b
	where b.ERClaimLineItem1 = a.ERClaimLineItem1
	and b.ERClaimLineItem2 < a.ERClaimLineItem2
)
if @@error <> 0 goto error

-- delete any duplicate allocations
delete from a
from #ERClaimLineItemOffsets as a
where exists (
	select * from #ERClaimLineItemOffsets as b
	where b.ERClaimLineItem2 = a.ERClaimLineItem2
	and b.ERClaimLineItem1 < a.ERClaimLineItem1
)
if @@error <> 0 goto error


delete from a
from ERClaimLineItemAdjustments as a
join #ERClaimLineItemOffsets as b on b.ERClaimLineItem1 = a.ERClaimLineItemId
if @@error <> 0 goto error

delete from a
from ERClaimLineItemLog as a
join #ERClaimLineItemOffsets as b on b.ERClaimLineItem1 = a.ERClaimLineItemId
if @@error <> 0 goto error

delete from a
from ERClaimLineItems as a
join #ERClaimLineItemOffsets as b on b.ERClaimLineItem1 = a.ERClaimLineItemId
if @@error <> 0 goto error

delete from a
from ERClaimLineItemAdjustments as a
join #ERClaimLineItemOffsets as b on b.ERClaimLineItem2 = a.ERClaimLineItemId
if @@error <> 0 goto error

delete from a
from ERClaimLineItemLog as a
join #ERClaimLineItemOffsets as b on b.ERClaimLineItem2 = a.ERClaimLineItemId
if @@error <> 0 goto error

delete from a
from ERClaimLineItems as a
join #ERClaimLineItemOffsets as b on b.ERClaimLineItem2 = a.ERClaimLineItemId
if @@error <> 0 goto error

-- 


commit tran    
  
if @@error <> 0 goto error

   
process_payments:    


exec ssp_PM835PaymentPosting @UserId, @ERFileId    
    
if @@error <> 0     
begin    
 insert into @ParseErrors    
 (LineNumber, ErrorMessage, LineDataText)    
 values --srf ?? what do i use for line number??    
 (1, 'Error: Payment Posting Process Failed. Please ask system admin to run ssp_835_payment_posting through SQL Query Analyzer', NULL)    
 --select @ErrorNo = 30006, @ErrorMessage = 'Error: Payment Posting Process Failed. Please ask system admin to run ssp_835_payment_posting through SQL Query Analyzer'    
 goto error    
end    
    
     
    
    
--Set File to Process    
Update ERFiles    
Set Processed = 'Y'    
where ERFileId = @ERFileId    
    
--Set Processing Flag for File    
Update ERFiles    
Set Processing = 'N'    
where ERFileId = @ERFileId    

    
return    
    
    
end_process_claims:    
    
commit    
    
    
--Set Processing Flag for File    
Update ERFiles    
Set Processing = 'N'    
where ERFileId = @ERFileId    
    
    
return     
    
    
    
    
error:    
    
if @@trancount > 0    
  rollback transaction    
    
    
    
insert into ERFileParsingErrors     
(ERFileId, ERFilesegmentId, LineNumber, ErrorMessage, LineDataText, CreatedBy, ModifiedBy)    
select @ERFileId, b.ERFilesegmentId, b.LineNumber, a.ErrorMessage    
, b.DataText, @UserCode, @UserCode    
from @ParseErrors a    
LEFT JOIN @835ImportParse b ON (a.LineNumber = b.LineNumber)    
    
    
--Set Processing Flag for File    
Update ERFiles    
Set Processing = 'N'    
where ERFileId = @ERFileId    
    
return    
    
SELECT @ErrorMessage = 'Processed Sucessfully'    
do_not_process:    
SELECT @ErrorMessage            
    
    
    
return 
END
GO