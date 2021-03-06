if object_Id('dbo.ssp_PAProcess837FileImport') is not null
  drop procedure dbo.ssp_PAProcess837FileImport
go
  
create procedure dbo.ssp_PAProcess837FileImport
  @Import837FileId int,
  @StaffId int
/*********************************************************************
-- Stored Procedure: dbo.ssp_PAProcess837FileImport 
-- Creation Date:    11/1/08
-- 
-- Purpose:
--
-- Updates:
--   Date        Author		Purpose
--  11.01.2008   JHB		Created.
--  07.13.2009   SFarber	Modified logic for mapping clients.  Fixed insert into ClaimLines.
--  07.28.2009   SFarber	Modified logic for place of service.
--  07.30.2009   SFarber	Modified logic for mapping sites.
--  09.09.2009   SFarber	Modified logic for place of service: changed = 'B' to <> 'A'
--  10.28.2009   SFarber	Changed SubmitterLastName to varchar(60) and SubmitterFirstName to varchar(35).
--  03.10.2010   SFarber	Modified to set PatientInsuredId to SubscriberInsuredId when subscriber not same as patient. 
--  03.22.2010   SFarber	Modified to work around duplicate NPI #s for sites. This should be a temporary fix.
--  07.30.2010   SFarber	Modified code to validate diagnoses.
--  01.06.2012	 SFerenz	Added logic to differntiate between 4010 and 5010 claims.
--  05.02.2012   SFarber	Enabled code that maps InsurerId based on PayerNPI.
--  05.18.2012	 Pralyankar Modified to process CAS Line adjustment.
--  06.19.2012	 Pralyankar	Modified to get Provider Site based on authorization number.
--  10.09.2012   SFarber    Fixed SVD and CAS segmemts logic
--  09.12.2013   SFarber    Added logic to void/replace claims
--  03.06.2015   SFarber    Authorization number must have a dash and at least one number after it to be considered for site search.
--  06.08.2015   DHarvey    Replaced @Table variables with #Temp tables with indexes 
--  07.16.2015   SFarber    Modified logic for AdmissionHour (DTP*435)
--  07.17.2015   SFarber    Added support for ICD10
--  04.06.2016   SFarber    Added AuthorizationNumber to #CustomImport837ClaimsMapping
--  10.12.2016   SFarber    Added support for service NTE segment and ClaimLines.StartTime and ClaimLines.EndTime
--  11.11.2016   SFarber    Modified to ignore C109 error if rendering provider is the same as billing provider.
--	11.28.2016	 MJensen	Modified to account for $ in InsuredId field. SWMBH task #1105
--	12.15.2016	 MJensen	Modified to use the separator characters from the file SWMBH Task #1109
--  03.06.2017   SFarber    Added code to support Import837IdentifyInsurerByClientCoveragePlan configuration.
--  04.18.2017   Govind		Added code to update Clientid in Import837BatchClaims when Client Type = 'O' - Heartland customizations Task#7
--  05.31.2017   SFarber    Modified to properly identify rendering provider at the service line level (loop 2420A).
--  06.05.2017   SFarber    Added logic for supervising and ordering providers.
--  06.09.2017   MKhusro    Added logic to round off Charge and ClaimedAmount of ClaimLines table w.r.t task #1192 SWMBH - Support
--  06.22.2017   SFarber    Fixed TransactionDateTime logic for BHT segment when len(TransactionDateTime) > 4
--  06.26.2017   SFarber    Added logic to create rendering, supervising and ordering providers and associate them with the billing providers
--  08.29.2017	 Govind	    Added logic for National Drug Code & Unit Count (Segment 2410) - Heartland East Customizations - Task#21
--  02.22.2018   SFarber    Fixed rendering provider logic for the service line level.
--  05.11.2018   SFarber    Modified to check for all diagnosis pointers when setting Diagnosis1, Diagnosis2 and Diagnosis3 columns in the ClaimLines table.
--  08.21.2018   SFarber    Modified to handle NationalDrugcodeUnitType = 'ME'
--  01.11.2019   SFarber    Modified to support InsurerCOBExcludeAdjustmentReasons
--  11.29.2018   RGandikota Modified to handle more than 20 segments. Network180 Support Go Live Task #542
*********************************************************************/
as 

set ansi_warnings off

declare @ErrorNo int
declare @ErrorMessage varchar(1000)
declare @ElementSeperator char(1)
declare @SubElementSeparator char(1)
declare @MinimumFileLineNumber int
declare @SubmitterId varchar(25)
declare @SubmitterName varchar(100)
declare @SenderId int
declare @IncomingBatchDate datetime
declare @FirstTimeProcessing char(1)
declare @UserCode varchar(30)
declare @Import837IdentifyInsurerByClientCoveragePlan char(1)

create table #ParseErrors (
LineNumber int null,
ErrorMessage varchar(1000) null,
LineDataText varchar(1000) null)

create table #837ImportParse (
Import837FileSegmentId int null,
FileLineNumber int not null,
DataText varchar(4000) null,
TempDataText varchar(4000) null,
Segment varchar(10) null,
Element1 varchar(1000) null,
Element2 varchar(1000) null,
Element3 varchar(1000) null,
Element4 varchar(1000) null,
Element5 varchar(1000) null,
Element6 varchar(1000) null,
Element7 varchar(1000) null,
Element8 varchar(1000) null,
Element9 varchar(1000) null,
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
Element21 varchar(1000) null,
Element22 varchar(1000) null,
Element23 varchar(1000) null,
Element24 varchar(1000) null,
Element25 varchar(1000) null,
Element26 varchar(1000) null,
Element27 varchar(1000) null,
Element28 varchar(1000) null,
Element29 varchar(1000) null,
Element30 varchar(1000) null)

create nonclustered index XIE1_#837ImportParse on #837ImportParse (Segment, FileLineNumber)

select  @UserCode = s.UserCode
from    Staff s
where   s.StaffId = @StaffId

select  @FirstTimeProcessing = 'Y'

-- Get separator characters from file
select  @ElementSeperator = substring(FileText, 4, 1),
        @SubElementSeparator = substring(FileText, 105, 1)
from    Import837Files
where   Import837FileId = @Import837FileId

if @@error <> 0 
  return

if rtrim(@ElementSeperator) = '' 
  set @ElementSeperator = '*'

if rtrim(@SubElementSeparator) = '' 
  set @SubElementSeparator = ':'

-- Check if there are any claim lines that are to be processed
if exists ( select  *
            from    Import837Files f
                    join Import837Batches b on b.Import837FileId = f.Import837FileId
                    join Import837BatchClaims c on c.Import837BatchId = b.Import837BatchId
                    join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
            where   f.Import837FileId = @Import837FileId
                    and isnull(b.RecordDeleted, 'N') = 'N'
                    and isnull(c.RecordDeleted, 'N') = 'N'
                    and isnull(cl.RecordDeleted, 'N') = 'N' ) 
  begin
    set @FirstTimeProcessing = 'N'

    if not exists ( select  *
                    from    Import837Files f
                            join Import837Batches b on b.Import837FileId = f.Import837FileId
                            join Import837BatchClaims c on c.Import837BatchId = b.Import837BatchId
                            join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                    where   f.Import837FileId = @Import837FileId
                            and isnull(cl.Processed, 'N') = 'N'
                            and isnull(b.RecordDeleted, 'N') = 'N'
                            and isnull(c.RecordDeleted, 'N') = 'N'
                            and isnull(cl.RecordDeleted, 'N') = 'N' ) 
      return
  end

-- Get Sender Id 
select  @SubmitterId = b.SenderId,
        @SenderId = b.Import837SenderId,
        @SubmitterName = b.SenderName
from    Import837Files a
        join Import837Senders b on (a.Import837SenderId = b.Import837SenderId)
where   a.Import837FileId = @Import837FileId

if @@error <> 0 
  return

insert  into #837ImportParse
        (Import837FileSegmentId,
         FileLineNumber,
         DataText,
         TempDataText)
        select  Import837FileSegmentId,
                FileLineNumber,
                LineText,
                LineText
        from    Import837FileSegments
        where   Import837FileId = @Import837FileId
                and isnull(RecordDeleted, 'N') = 'N'
        order by FileLineNumber

if @@error <> 0 
  return

declare @ParseCount int

select  @ParseCount = 0

-- Parse the data
while exists ( select *
               from   #837ImportParse
               where  len(TempDataText) > 0 ) 
  begin

    if @ParseCount > 30 
      begin
        insert  into #ParseErrors
                (LineNumber,
                 ErrorMessage)
                select  FileLineNumber,
                        'Number of elements in a Segment is greater than 20, unable to parse.'
                from    #837ImportParse
                where   len(TempDataText) > 0

        goto end_parsing
      end

    if @ParseCount = 0 
      begin
        update  #837ImportParse
        set     Segment = substring(TempDataText, 1, charindex(@ElementSeperator, TempDataText) - 1)
        where   TempDataText like '%' + @ElementSeperator + '%'
      end

    if @@error <> 0 
      return

    if @ParseCount = 1 
      begin
        update  #837ImportParse
        set     Element1 = substring(TempDataText, 1, charindex(@ElementSeperator, TempDataText) - 1)
        where   TempDataText like '%' + @ElementSeperator + '%'

        update  #837ImportParse
        set     Element1 = TempDataText
        where   TempDataText not like '%' + @ElementSeperator + '%'
                and len(TempDataText) > 0
      end

    if @@error <> 0 
      return

    if @ParseCount = 2 
      begin
        update  #837ImportParse
        set     Element2 = substring(TempDataText, 1, charindex(@ElementSeperator, TempDataText) - 1)
        where   TempDataText like '%' + @ElementSeperator + '%'

        update  #837ImportParse
        set     Element2 = TempDataText
        where   TempDataText not like '%' + @ElementSeperator + '%'
                and len(TempDataText) > 0
      end

    if @@error <> 0 
      return

    if @ParseCount = 3 
      begin
        update  #837ImportParse
        set     Element3 = substring(TempDataText, 1, charindex(@ElementSeperator, TempDataText) - 1)
        where   TempDataText like '%' + @ElementSeperator + '%'

        update  #837ImportParse
        set     Element3 = TempDataText
        where   TempDataText not like '%' + @ElementSeperator + '%'
                and len(TempDataText) > 0
      end

    if @@error <> 0 
      return

    if @ParseCount = 4 
      begin
        update  #837ImportParse
        set     Element4 = substring(TempDataText, 1, charindex(@ElementSeperator, TempDataText) - 1)
        where   TempDataText like '%' + @ElementSeperator + '%'

        update  #837ImportParse
        set     Element4 = TempDataText
        where   TempDataText not like '%' + @ElementSeperator + '%'
                and len(TempDataText) > 0
      end

    if @@error <> 0 
      return

    if @ParseCount = 5 
      begin
        update  #837ImportParse
        set     Element5 = substring(TempDataText, 1, charindex(@ElementSeperator, TempDataText) - 1)
        where   TempDataText like '%' + @ElementSeperator + '%'

        update  #837ImportParse
        set     Element5 = TempDataText
        where   TempDataText not like '%' + @ElementSeperator + '%'
                and len(TempDataText) > 0
      end

    if @@error <> 0 
      return

    if @ParseCount = 6 
      begin
        update  #837ImportParse
        set     Element6 = substring(TempDataText, 1, charindex(@ElementSeperator, TempDataText) - 1)
        where   TempDataText like '%' + @ElementSeperator + '%'

        update  #837ImportParse
        set     Element6 = TempDataText
        where   TempDataText not like '%' + @ElementSeperator + '%'
                and len(TempDataText) > 0
      end

    if @@error <> 0 
      return

    if @ParseCount = 7 
      begin
        update  #837ImportParse
        set     Element7 = substring(TempDataText, 1, charindex(@ElementSeperator, TempDataText) - 1)
        where   TempDataText like '%' + @ElementSeperator + '%'

        update  #837ImportParse
        set     Element7 = TempDataText
        where   TempDataText not like '%' + @ElementSeperator + '%'
                and len(TempDataText) > 0
      end

    if @@error <> 0 
      return

    if @ParseCount = 8 
      begin
        update  #837ImportParse
        set     Element8 = substring(TempDataText, 1, charindex(@ElementSeperator, TempDataText) - 1)
        where   TempDataText like '%' + @ElementSeperator + '%'

        update  #837ImportParse
        set     Element8 = TempDataText
        where   TempDataText not like '%' + @ElementSeperator + '%'
                and len(TempDataText) > 0
      end

    if @@error <> 0 
      return

    if @ParseCount = 9 
      begin
        update  #837ImportParse
        set     Element9 = substring(TempDataText, 1, charindex(@ElementSeperator, TempDataText) - 1)
        where   TempDataText like '%' + @ElementSeperator + '%'

        update  #837ImportParse
        set     Element9 = TempDataText
        where   TempDataText not like '%' + @ElementSeperator + '%'
                and len(TempDataText) > 0
      end

    if @@error <> 0 
      return

    if @ParseCount = 10 
      begin
        update  #837ImportParse
        set     Element10 = substring(TempDataText, 1, charindex(@ElementSeperator, TempDataText) - 1)
        where   TempDataText like '%' + @ElementSeperator + '%'

        update  #837ImportParse
        set     Element10 = TempDataText
        where   TempDataText not like '%' + @ElementSeperator + '%'
                and len(TempDataText) > 0
      end

    if @@error <> 0 
      return

    if @ParseCount = 11 
      begin
        update  #837ImportParse
        set     Element11 = substring(TempDataText, 1, charindex(@ElementSeperator, TempDataText) - 1)
        where   TempDataText like '%' + @ElementSeperator + '%'

        update  #837ImportParse
        set     Element11 = TempDataText
        where   TempDataText not like '%' + @ElementSeperator + '%'
                and len(TempDataText) > 0
      end

    if @@error <> 0 
      return

    if @ParseCount = 12 
      begin
        update  #837ImportParse
        set     Element12 = substring(TempDataText, 1, charindex(@ElementSeperator, TempDataText) - 1)
        where   TempDataText like '%' + @ElementSeperator + '%'

        update  #837ImportParse
        set     Element12 = TempDataText
        where   TempDataText not like '%' + @ElementSeperator + '%'
                and len(TempDataText) > 0
      end

    if @@error <> 0 
      return

    if @ParseCount = 13 
      begin
        update  #837ImportParse
        set     Element13 = substring(TempDataText, 1, charindex(@ElementSeperator, TempDataText) - 1)
        where   TempDataText like '%' + @ElementSeperator + '%'

        update  #837ImportParse
        set     Element13 = TempDataText
        where   TempDataText not like '%' + @ElementSeperator + '%'
                and len(TempDataText) > 0
      end

    if @@error <> 0 
      return

    if @ParseCount = 14 
      begin
        update  #837ImportParse
        set     Element14 = substring(TempDataText, 1, charindex(@ElementSeperator, TempDataText) - 1)
        where   TempDataText like '%' + @ElementSeperator + '%'

        update  #837ImportParse
        set     Element14 = TempDataText
        where   TempDataText not like '%' + @ElementSeperator + '%'
                and len(TempDataText) > 0
      end

    if @@error <> 0 
      return

    if @ParseCount = 15 
      begin
        update  #837ImportParse
        set     Element15 = substring(TempDataText, 1, charindex(@ElementSeperator, TempDataText) - 1)
        where   TempDataText like '%' + @ElementSeperator + '%'

        update  #837ImportParse
        set     Element15 = TempDataText
        where   TempDataText not like '%' + @ElementSeperator + '%'
                and len(TempDataText) > 0
      end

    if @@error <> 0 
      return

    if @ParseCount = 16 
      begin
        update  #837ImportParse
        set     Element16 = substring(TempDataText, 1, charindex(@ElementSeperator, TempDataText) - 1)
        where   TempDataText like '%' + @ElementSeperator + '%'

        update  #837ImportParse
        set     Element16 = TempDataText
        where   TempDataText not like '%' + @ElementSeperator + '%'
                and len(TempDataText) > 0
      end

    if @@error <> 0 
      return

    if @ParseCount = 17 
      begin
        update  #837ImportParse
        set     Element17 = substring(TempDataText, 1, charindex(@ElementSeperator, TempDataText) - 1)
        where   TempDataText like '%' + @ElementSeperator + '%'

        update  #837ImportParse
        set     Element17 = TempDataText
        where   TempDataText not like '%' + @ElementSeperator + '%'
                and len(TempDataText) > 0
      end

    if @@error <> 0 
      return

    if @ParseCount = 18 
      begin
        update  #837ImportParse
        set     Element18 = substring(TempDataText, 1, charindex(@ElementSeperator, TempDataText) - 1)
        where   TempDataText like '%' + @ElementSeperator + '%'

        update  #837ImportParse
        set     Element18 = TempDataText
        where   TempDataText not like '%' + @ElementSeperator + '%'
                and len(TempDataText) > 0
      end

    if @@error <> 0 
      return

    if @ParseCount = 19 
      begin
        update  #837ImportParse
        set     Element19 = substring(TempDataText, 1, charindex(@ElementSeperator, TempDataText) - 1)
        where   TempDataText like '%' + @ElementSeperator + '%'

        update  #837ImportParse
        set     Element19 = TempDataText
        where   TempDataText not like '%' + @ElementSeperator + '%'
                and len(TempDataText) > 0
      end

    if @@error <> 0 
      return

    if @ParseCount = 20 
      begin
        update  #837ImportParse
        set     Element20 = substring(TempDataText, 1, charindex(@ElementSeperator, TempDataText) - 1)
        where   TempDataText like '%' + @ElementSeperator + '%'

        update  #837ImportParse
        set     Element20 = TempDataText
        where   TempDataText not like '%' + @ElementSeperator + '%'
                and len(TempDataText) > 0
      end

    if @@error <> 0 
      return

    update  #837ImportParse
    set     TempDataText = null
    where   TempDataText not like '%' + @ElementSeperator + '%'
            and len(TempDataText) > 0

    if @@error <> 0 
      return
	
	  if @ParseCount = 21 
      begin
        update  #837ImportParse
        set     Element21 = substring(TempDataText, 1, charindex(@ElementSeperator, TempDataText) - 1)
        where   TempDataText like '%' + @ElementSeperator + '%'

        update  #837ImportParse
        set     Element21 = TempDataText
        where   TempDataText not like '%' + @ElementSeperator + '%'
                and len(TempDataText) > 0
      end

    if @@error <> 0 
      return

    if @ParseCount = 22 
      begin
        update  #837ImportParse
        set     Element22 = substring(TempDataText, 1, charindex(@ElementSeperator, TempDataText) - 1)
        where   TempDataText like '%' + @ElementSeperator + '%'

        update  #837ImportParse
        set     Element22 = TempDataText
        where   TempDataText not like '%' + @ElementSeperator + '%'
                and len(TempDataText) > 0
      end

    if @@error <> 0 
      return

    if @ParseCount = 23 
      begin
        update  #837ImportParse
        set     Element23 = substring(TempDataText, 1, charindex(@ElementSeperator, TempDataText) - 1)
        where   TempDataText like '%' + @ElementSeperator + '%'

        update  #837ImportParse
        set     Element23 = TempDataText
        where   TempDataText not like '%' + @ElementSeperator + '%'
                and len(TempDataText) > 0
      end

    if @@error <> 0 
      return

    if @ParseCount = 24 
      begin
        update  #837ImportParse
        set     Element24 = substring(TempDataText, 1, charindex(@ElementSeperator, TempDataText) - 1)
        where   TempDataText like '%' + @ElementSeperator + '%'

        update  #837ImportParse
        set     Element24 = TempDataText
        where   TempDataText not like '%' + @ElementSeperator + '%'
                and len(TempDataText) > 0
      end

    if @@error <> 0 
      return

    if @ParseCount = 25 
      begin
        update  #837ImportParse
        set     Element25 = substring(TempDataText, 1, charindex(@ElementSeperator, TempDataText) - 1)
        where   TempDataText like '%' + @ElementSeperator + '%'

        update  #837ImportParse
        set     Element25 = TempDataText
        where   TempDataText not like '%' + @ElementSeperator + '%'
                and len(TempDataText) > 0
      end

    if @@error <> 0 
      return

    if @ParseCount = 26 
      begin
        update  #837ImportParse
        set     Element26 = substring(TempDataText, 1, charindex(@ElementSeperator, TempDataText) - 1)
        where   TempDataText like '%' + @ElementSeperator + '%'

        update  #837ImportParse
        set     Element26 = TempDataText
        where   TempDataText not like '%' + @ElementSeperator + '%'
                and len(TempDataText) > 0
      end

    if @@error <> 0 
      return

    if @ParseCount = 27 
      begin
        update  #837ImportParse
        set     Element27 = substring(TempDataText, 1, charindex(@ElementSeperator, TempDataText) - 1)
        where   TempDataText like '%' + @ElementSeperator + '%'

        update  #837ImportParse
        set     Element27 = TempDataText
        where   TempDataText not like '%' + @ElementSeperator + '%'
                and len(TempDataText) > 0
      end

    if @@error <> 0 
      return

    if @ParseCount = 28 
      begin
        update  #837ImportParse
        set     Element28 = substring(TempDataText, 1, charindex(@ElementSeperator, TempDataText) - 1)
        where   TempDataText like '%' + @ElementSeperator + '%'

        update  #837ImportParse
        set     Element28 = TempDataText
        where   TempDataText not like '%' + @ElementSeperator + '%'
                and len(TempDataText) > 0
      end

    if @@error <> 0 
      return

    if @ParseCount = 29 
      begin
        update  #837ImportParse
        set     Element29 = substring(TempDataText, 1, charindex(@ElementSeperator, TempDataText) - 1)
        where   TempDataText like '%' + @ElementSeperator + '%'

        update  #837ImportParse
        set     Element29 = TempDataText
        where   TempDataText not like '%' + @ElementSeperator + '%'
                and len(TempDataText) > 0
      end

    if @@error <> 0 
      return

    if @ParseCount = 30 
      begin
        update  #837ImportParse
        set     Element30 = substring(TempDataText, 1, charindex(@ElementSeperator, TempDataText) - 1)
        where   TempDataText like '%' + @ElementSeperator + '%'

        update  #837ImportParse
        set     Element30 = TempDataText
        where   TempDataText not like '%' + @ElementSeperator + '%'
                and len(TempDataText) > 0
      end

    if @@error <> 0 
      return
    update  #837ImportParse
    set     TempDataText = right(TempDataText, len(TempDataText) - charindex(@ElementSeperator, TempDataText))
    where   TempDataText like '%' + @ElementSeperator + '%'

    if @@error <> 0 
      return

    select  @ParseCount = @ParseCount + 1

    if @@error <> 0 
      return

  end

update  #837ImportParse
set     Element1 = null
where   rtrim(Element1) in ('', null)

if @@error <> 0 
  return

update  #837ImportParse
set     Element2 = null
where   rtrim(Element2) in ('', null)

update  #837ImportParse
set     Element3 = null
where   rtrim(Element3) in ('', null)

if @@error <> 0 
  return

update  #837ImportParse
set     Element4 = null
where   rtrim(Element4) in ('', null)

if @@error <> 0 
  return

update  #837ImportParse
set     Element5 = null
where   rtrim(Element5) in ('', null)

if @@error <> 0 
  return

update  #837ImportParse
set     Element6 = null
where   rtrim(Element6) in ('', null)

if @@error <> 0 
  return

update  #837ImportParse
set     Element7 = null
where   rtrim(Element7) in ('', null)

if @@error <> 0 
  return

update  #837ImportParse
set     Element8 = null
where   rtrim(Element8) in ('', null)

if @@error <> 0 
  return

update  #837ImportParse
set     Element9 = null
where   rtrim(Element9) in ('', null)

if @@error <> 0 
  return

update  #837ImportParse
set     Element10 = null
where   rtrim(Element10) in ('', null)

if @@error <> 0 
  return

update  #837ImportParse
set     Element11 = null
where   rtrim(Element11) in ('', null)

if @@error <> 0 
  return

update  #837ImportParse
set     Element12 = null
where   rtrim(Element12) in ('', null)

if @@error <> 0 
  return

update  #837ImportParse
set     Element13 = null
where   rtrim(Element13) in ('', null)

if @@error <> 0 
  return

update  #837ImportParse
set     Element14 = null
where   rtrim(Element14) in ('', null)

if @@error <> 0 
  return

update  #837ImportParse
set     Element15 = null
where   rtrim(Element15) in ('', null)

if @@error <> 0 
  return

update  #837ImportParse
set     Element16 = null
where   rtrim(Element16) in ('', null)

if @@error <> 0 
  return

update  #837ImportParse
set     Element17 = null
where   rtrim(Element17) in ('', null)

if @@error <> 0 
  return

update  #837ImportParse
set     Element18 = null
where   rtrim(Element18) in ('', null)

if @@error <> 0 
  return

update  #837ImportParse
set     Element19 = null
where   rtrim(Element19) in ('', null)

if @@error <> 0 
  return

update  #837ImportParse
set     Element20 = null
where   rtrim(Element20) in ('', null)

if @@error <> 0 
  return
  
  update  #837ImportParse
set     Element21 = null
where   rtrim(Element21) in ('', null)

if @@error <> 0 
  return

update  #837ImportParse
set     Element22 = null
where   rtrim(Element22) in ('', null)

if @@error <> 0 
  return

update  #837ImportParse
set     Element23 = null
where   rtrim(Element23) in ('', null)

if @@error <> 0 
  return

update  #837ImportParse
set     Element24 = null
where   rtrim(Element24) in ('', null)

if @@error <> 0 
  return

update  #837ImportParse
set     Element25 = null
where   rtrim(Element25) in ('', null)

if @@error <> 0 
  return

update  #837ImportParse
set     Element26 = null
where   rtrim(Element26) in ('', null)

if @@error <> 0 
  return

update  #837ImportParse
set     Element27 = null
where   rtrim(Element27) in ('', null)

if @@error <> 0 
  return

update  #837ImportParse
set     Element28 = null
where   rtrim(Element28) in ('', null)

if @@error <> 0 
  return

update  #837ImportParse
set     Element29 = null
where   rtrim(Element29) in ('', null)

if @@error <> 0 
  return

update  #837ImportParse
set     Element30 = null
where   rtrim(Element30) in ('', null)

if @@error <> 0 
  return
-- Get first line number for the file
declare @FirstLine int

select  @FirstLine = min(FileLineNumber)
from    #837ImportParse

if @@error <> 0 
  return

create table #BatchServiceCount (
BatchNumber int null,
ServiceCount int null)

create table #ClaimCharge (
ClaimFileLineNumber int null,
ClaimCharge money null)

declare @FileDateTime datetime,
  @InterchangeSenderId varchar(15),
  @InterchangeReceiverId varchar(15)
  
declare @InterchangeControlNumber varchar(9),
  @AcknowledgementRequested char(1)

declare @NumberOfBatches int,
  @TotalClaims int,
  @TotalClaimLines int,
  @TotalCharges money

declare @NumberOfSegments int,
  @Processed char(1)

select  @InterchangeSenderId = Element6,
        @InterchangeReceiverId = Element8,
        @FileDateTime = convert(datetime, Element9 + ' ' + left(right('0000' + Element10, 4), 2) + ':' + right(Element10, 2)),
        @InterchangeControlNumber = Element13,
        @AcknowledgementRequested = case when Element14 = 1 then 'Y'
                                         else 'N'
                                    end
from    #837ImportParse
where   Segment = 'ISA'

if @@error <> 0 
  return

-- Get Batch Information
create table #837Batches (
BatchNumber int identity not null,
StartFileLineNumber int null,
EndFileLineNumber int null,
TotalSegments int null,
TransactionSetControlNumber varchar(9) null,
TransactionTypeCode char(2) null,
TransmissionTypeCode varchar(30) null,
FileType char(1) null,
ApplicationTransactionId varchar(30) null,
TransactionDateTime datetime null,
SubmitterLastName varchar(60) null,
SubmitterFirstName varchar(35) null,
SubmitterId varchar(80) null,
ServiceCount int null,
ImportBatchNumber int null)

create table #837BatchSummaries (
BatchNumber int not null,
TotalClaims int null,
TotalClaimLines int null,
TotalCharges money null)

insert  into #837Batches
        (StartFileLineNumber,
         TransactionSetControlNumber)
        select  FileLineNumber,
                Element2
        from    #837ImportParse
        where   Segment = 'ST'

if @@error <> 0 
  return

update  a
set     EndFileLineNumber = b.FileLineNumber,
        TotalSegments = convert(int, b.Element1)
from    #837Batches a
        join #837ImportParse b on (b.FileLineNumber > a.StartFileLineNumber)
where   b.Segment = 'SE'
        and not exists ( select *
                         from   #837ImportParse c
                         where  c.Segment = 'SE'
                                and c.FileLineNumber > a.StartFileLineNumber
                                and c.FileLineNumber < b.FileLineNumber )

if @@error <> 0 
  return

if exists ( select  *
            from    #837Batches
            where   EndFileLineNumber - StartFileLineNumber + 1 <> TotalSegments ) 
  begin
    insert  into #ParseErrors
            (LineNumber,
             ErrorMessage)
            select  EndFileLineNumber,
                    'Invalid Segment count in SE Segment'
            from    #837Batches
            where   EndFileLineNumber - StartFileLineNumber + 1 <> TotalSegments
	
  end

if @@error <> 0 
  return

update  b
set     b.Element5 = right('0000' + b.Element5, 4)
from    #837Batches a
        join #837ImportParse b on (b.FileLineNumber = a.StartFileLineNumber + 1)
where   b.Segment = 'BHT'
        and len(b.Element5) < 4

if @@error <> 0 
  return

update  a
set     TransactionDateTime = convert(datetime,  substring(b.Element4, 1, 8) + ' ' + left (b.Element5, 2) + ':' + substring(b.Element5, 3, 2) + ':' + right('00' + substring(b.Element5, 5, 2), 2)),
        TransactionTypeCode = b.Element6,
        ApplicationTransactionId = b.Element3
from    #837Batches a
        join #837ImportParse b on (b.FileLineNumber = a.StartFileLineNumber + 1)
where   b.Segment = 'BHT'

if @@error <> 0 
  return

--
-- Differentiate between 4010 and 5010 claim files. srf 1/6/2011
--

declare @InterchangeControlVersionNo varchar(10)

set @InterchangeControlVersionNo = (select top 1
                                            Element12
                                    from    #837ImportParse
                                    where   Segment = 'ISA')

-- 4010
if @InterchangeControlVersionNo like '%401%' 
  begin
    update  a
    set     TransmissionTypeCode = b.Element2
    from    #837Batches a
            join #837ImportParse b on (b.FileLineNumber = a.StartFileLineNumber + 2)
    where   b.Segment = 'REF'

    if @@error <> 0 
      return

    update  a
    set     SubmitterId = b.Element9,
            SubmitterLastName = b.Element3,
            SubmitterFirstName = b.Element4
    from    #837Batches a
            join #837ImportParse b on (b.FileLineNumber = a.StartFileLineNumber + 3)
    where   b.Segment = 'NM1'

    if @@error <> 0 
      return
  end

--5010
if @InterchangeControlVersionNo like '%501%' 
  begin
    update  a
    set     TransmissionTypeCode = b.Element3
    from    #837Batches a
            join #837ImportParse b on (b.FileLineNumber = a.StartFileLineNumber)
    where   b.Segment = 'ST'

    if @@error <> 0 
      return

    update  a
    set     SubmitterId = b.Element9,
            SubmitterLastName = b.Element3,
            SubmitterFirstName = b.Element4
    from    #837Batches a
            join #837ImportParse b on (b.FileLineNumber = a.StartFileLineNumber + 2)
    where   b.Segment = 'NM1'

    if @@error <> 0 
      return
  end

-- Provider Links
create table #ProviderSegmentLinks (
BatchNumber int not null,
ProviderFileLineNumber int not null,
ProviderNameId int null,
ProviderName varchar(50) null,
ProviderTaxId varchar(12) null,
ProviderNPI varchar(10) null,
ProviderId1 varchar(35) null,
ProviderTaxonomyCode varchar(30) null)

insert  into #ProviderSegmentLinks
        (BatchNumber,
         ProviderFileLineNumber)
        select  b.BatchNumber,
                a.FileLineNumber
        from    #837ImportParse a
                join #837Batches b on (a.FileLineNumber > b.StartFileLineNumber
                                       and a.FileLineNumber <= b.EndFileLineNumber)
        where   a.Segment = 'HL'
                and a.Element3 = '20'

if @@error <> 0 
  return

update  a
set     ProviderNameId = b.FileLineNumber,
        ProviderName = b.Element3,
        ProviderTaxId = case when b.Element8 <> 'XX' then b.Element9
                             else null
                        end,
        ProviderNPI = case when b.Element8 = 'XX' then b.Element9
                           else null
                      end
from    #ProviderSegmentLinks a
        join #837ImportParse b on (b.FileLineNumber > a.ProviderFileLineNumber
                                   and b.FileLineNumber < (a.ProviderFileLineNumber + 100))
where   b.Segment = 'NM1'
        and b.Element1 = '85'
        and not exists ( select *
                         from   #ProviderSegmentLinks c
                         where  c.ProviderFileLineNumber > a.ProviderFileLineNumber
                                and b.FileLineNumber > c.ProviderFileLineNumber
                                and b.FileLineNumber < (c.ProviderFileLineNumber + 100) )

if @@error <> 0 
  return

update  a
set     ProviderId1 = b.Element2
from    #ProviderSegmentLinks a
        join #837ImportParse b on (b.FileLineNumber > a.ProviderNameId
                                   and b.FileLineNumber < (a.ProviderNameId + 10))
where   b.Segment = 'REF'
        and b.Element1 not in ('EI', 'SY')

if @@error <> 0 
  return

update  a
set     ProviderTaxId = b.Element2
from    #ProviderSegmentLinks a
        join #837ImportParse b on (b.FileLineNumber > a.ProviderNameId
                                   and b.FileLineNumber < (a.ProviderNameId + 10))
where   b.Segment = 'REF'
        and b.Element1 in ('EI', 'SY')

if @@error <> 0 
  return

update  a
set     ProviderTaxonomyCode = b.Element3
from    #ProviderSegmentLinks a
        join #837ImportParse b on (b.FileLineNumber > a.ProviderNameId
                                   and b.FileLineNumber < (a.ProviderNameId + 10))
where   b.Segment = 'PRV'
        and b.Element1 = 'PE'

if @@error <> 0 
  return

-- Get Subscriber links
-- Subscriber Segment
create table #SubscriberSegmentLinks (
ProviderFileLineNumber int null,
SubscriberFileLineNumber int null,
SubscriberInfoId int null,
SubscriberNameId int null,
SubscriberDemographicsId int null,
SubscriberPayerId int null,
SubscriberResponsibleId int null,
SubscriberRelation varchar(2) null,
SubscriberGroupNumber varchar(35) null,
SubscriberInsuredId varchar(80) null,
SubscriberLastName varchar(30) null,
SubscriberFirstName varchar(30) null,
SubscriberAddress varchar(200) null,
SubscriberAddress1 varchar(55) null,
SubscriberAddress2 varchar(55) null,
SubscriberCity varchar(30) null,
SubscriberState varchar(2) null,
SubscriberZip varchar(15) null,
SubscriberDOB datetime null,
SubscriberSex char(1) null,
PayerName varchar(100) null,
PayerPriority char(1) null,
PayerId varchar(80) null,
PayerNPI varchar(80) null,
ProviderSecondaryId varchar(30) null,
ResponsibleName varchar(30) null,
ResponsibleAddress varchar(200) null,
ResponsibleAddress1 varchar(55) null,
ResponsibleAddress2 varchar(55) null,
ResponsibleCity varchar(30) null,
ResponsibleState varchar(2) null,
ResponsibleZip varchar(15) null)

if @@error <> 0 
  return

insert  into #SubscriberSegmentLinks
        (ProviderFileLineNumber,
         SubscriberFileLineNumber)
        select  b.ProviderFileLineNumber,
                a.FileLineNumber
        from    #837ImportParse a
                join #ProviderSegmentLinks b on (a.FileLineNumber > b.ProviderFileLineNumber)
        where   a.Segment = 'HL'
                and a.Element3 = '22'
                and not exists ( select *
                                 from   #ProviderSegmentLinks c
                                 where  a.FileLineNumber > c.ProviderFileLineNumber
                                        and b.ProviderFileLineNumber < c.ProviderFileLineNumber )

if @@error <> 0 
  return

update  a
set     SubscriberInfoId = b.FileLineNumber,
        SubscriberRelation = b.Element2,
        SubscriberGroupNumber = b.Element3,
        PayerPriority = b.Element1
from    #SubscriberSegmentLinks a
        join #837ImportParse b on (b.FileLineNumber = SubscriberFileLineNumber + 1)

if @@error <> 0 
  return

update  a
set     SubscriberNameId = b.FileLineNumber,
        SubscriberLastName = b.Element3,
        SubscriberFirstName = b.Element4,
        SubscriberInsuredId = b.Element9
from    #SubscriberSegmentLinks a
        join #837ImportParse b on (b.FileLineNumber > a.SubscriberFileLineNumber
                                   and b.FileLineNumber < (a.SubscriberFileLineNumber + 3))
where   Segment = 'NM1'
        and Element1 = 'IL'

if @@error <> 0 
  return

update  a
set     SubscriberAddress = b.Element1 + case when isnull(rtrim(b.Element2), '') = '' then ''
                                              else ', ' + rtrim(b.Element2)
                                         end + ', ' + rtrim(c.Element1) + ', ' + rtrim(c.Element2) + ' ' + rtrim(c.Element3),
        SubscriberAddress1 = b.Element1,
        SubscriberAddress2 = b.Element2,
        SubscriberCity = c.Element1,
        SubscriberState = c.Element2,
        SubscriberZip = c.Element3
from    #SubscriberSegmentLinks a
        join #837ImportParse b on (a.SubscriberNameId + 1 = b.FileLineNumber)
        join #837ImportParse c on (a.SubscriberNameId + 2 = c.FileLineNumber)
where   b.Segment = 'N3'
        and c.Segment = 'N4'

if @@error <> 0 
  return

update  a
set     SubscriberPayerId = b.FileLineNumber,
        PayerName = b.Element3,
        PayerId = b.Element9,
        PayerNPI = case when b.Element8 = 'PI' then b.Element9
                        else null
                   end
from    #SubscriberSegmentLinks a
        join #837ImportParse b on (b.FileLineNumber > a.SubscriberFileLineNumber
                                   and b.FileLineNumber < (a.SubscriberFileLineNumber + 12))
where   Segment = 'NM1'
        and Element1 = 'PR'
        and not exists ( select *
                         from   #SubscriberSegmentLinks c
                         where  c.SubscriberFileLineNumber > a.SubscriberFileLineNumber
                                and b.FileLineNumber > c.SubscriberFileLineNumber
                                and b.FileLineNumber < (c.SubscriberFileLineNumber + 12) )

if @@error <> 0 
  return

update  a
set     ProviderSecondaryId = b.Element2
from    #SubscriberSegmentLinks a
        join #837ImportParse b on (b.FileLineNumber > a.SubscriberPayerId
                                   and b.FileLineNumber < a.SubscriberPayerId + 5)
where   Segment = 'REF'
        and Element1 = 'G2'
        and not exists ( select *
                         from   #SubscriberSegmentLinks c
                         where  c.SubscriberPayerId < a.SubscriberPayerId
                                and b.FileLineNumber > c.SubscriberPayerId
                                and b.FileLineNumber < c.SubscriberPayerId + 5 )

if @@error <> 0 
  return

update  a
set     SubscriberDemographicsId = b.FileLineNumber,
        SubscriberDOB = convert(datetime, b.Element2),
        SubscriberSex = b.Element3
from    #SubscriberSegmentLinks a
        join #837ImportParse b on (b.FileLineNumber > a.SubscriberFileLineNumber
                                   and b.FileLineNumber < a.SubscriberPayerId)
where   Segment = 'DMG'

if @@error <> 0 
  return

update  a
set     SubscriberResponsibleId = b.FileLineNumber,
        ResponsibleName = case when isnull(rtrim(b.Element3), '') = '' then b.Element2
                               else b.Element2 + ', ' + b.Element3
                          end
from    #SubscriberSegmentLinks a
        join #837ImportParse b on (b.FileLineNumber > a.SubscriberFileLineNumber
                                   and b.FileLineNumber < (a.SubscriberFileLineNumber + 20))
where   Segment = 'NM1'
        and Element1 = 'QD'
        and not exists ( select *
                         from   #SubscriberSegmentLinks c
                         where  c.SubscriberFileLineNumber > a.SubscriberFileLineNumber
                                and b.FileLineNumber > c.SubscriberFileLineNumber
                                and b.FileLineNumber < (c.SubscriberFileLineNumber + 20) )

if @@error <> 0 
  return

update  a
set     ResponsibleAddress = b.Element1 + case when isnull(rtrim(b.Element2), '') = '' then ''
                                               else ', ' + rtrim(b.Element2)
                                          end + ', ' + rtrim(c.Element1) + ', ' + rtrim(c.Element2) + ' ' + rtrim(c.Element3),
        ResponsibleAddress1 = b.Element1,
        ResponsibleAddress2 = b.Element2,
        ResponsibleCity = c.Element1,
        ResponsibleState = c.Element2,
        ResponsibleZip = c.Element3
from    #SubscriberSegmentLinks a
        join #837ImportParse b on (a.SubscriberResponsibleId + 1 = b.FileLineNumber)
        join #837ImportParse c on (a.SubscriberResponsibleId + 2 = c.FileLineNumber)
where   b.Segment = 'N3'
        and c.Segment = 'N4'

if @@error <> 0 
  return

-- Patient Segment
create table #PatientSegmentLinks (
SubscriberFileLineNumber int null,
PatientFileLineNumber int null,
PatientNameId int null,
PatientDemographicsId int null,
PatientLastName varchar(30) null,
PatientFirstName varchar(30) null,
PatientInsuredId varchar(80) null,
PatientAddress varchar(200) null,
PatientAddress1 varchar(55) null,
PatientAddress2 varchar(55) null,
PatientCity varchar(30) null,
PatientState varchar(2) null,
PatientZip varchar(15) null,
PatientDOB datetime null,
PatientSex char(1) null)

-- Get Patient Links
-- Subscriber not same as patient
insert  into #PatientSegmentLinks
        (SubscriberFileLineNumber,
         PatientFileLineNumber)
        select  b.SubscriberFileLineNumber,
                a.FileLineNumber
        from    #837ImportParse a
                join #SubscriberSegmentLinks b on (a.FileLineNumber > b.SubscriberFileLineNumber)
        where   isnull(b.SubscriberRelation, '') <> '18'
                and a.Segment = 'PAT'
                and not exists ( select *
                                 from   #SubscriberSegmentLinks c
                                 where  a.FileLineNumber > c.SubscriberFileLineNumber
                                        and b.SubscriberFileLineNumber < c.SubscriberFileLineNumber )

if @@error <> 0 
  return

update  a
set     PatientNameId = b.FileLineNumber,
        PatientLastName = b.Element3,
        PatientFirstName = b.Element4,
        PatientInsuredId = b.Element9
from    #PatientSegmentLinks a
        join #837ImportParse b on (b.FileLineNumber = a.PatientFileLineNumber + 1)
where   b.Segment = 'NM1'
        and b.Element1 = 'QC'

if @@error <> 0 
  return

update  a
set     PatientDemographicsId = b.FileLineNumber,
        PatientDOB = b.Element2,
        PatientSex = b.Element3
from    #PatientSegmentLinks a
        join #837ImportParse b on (b.FileLineNumber > a.PatientFileLineNumber
                                   and b.FileLineNumber < (a.PatientFileLineNumber + 5))
where   b.Segment = 'DMG'
        and not exists ( select *
                         from   #PatientSegmentLinks c
                         where  c.PatientFileLineNumber > a.PatientFileLineNumber
                                and b.FileLineNumber > c.PatientFileLineNumber
                                and b.FileLineNumber < (c.PatientFileLineNumber + 5) )

if @@error <> 0 
  return

update  a
set     PatientAddress = b.Element1 + case when isnull(rtrim(b.Element2), '') = '' then ''
                                           else ', ' + rtrim(b.Element2)
                                      end + ', ' + rtrim(c.Element1) + ', ' + rtrim(c.Element2) + ' ' + rtrim(c.Element3),
        PatientAddress1 = b.Element1,
        PatientAddress2 = b.Element2,
        PatientCity = c.Element1,
        PatientState = c.Element2,
        PatientZip = c.Element3
from    #PatientSegmentLinks a
        join #837ImportParse b on (a.PatientNameId + 1 = b.FileLineNumber)
        join #837ImportParse c on (a.PatientNameId + 2 = c.FileLineNumber)
where   b.Segment = 'N3'
        and c.Segment = 'N4'

if @@error <> 0 
  return

insert  into #PatientSegmentLinks
        (SubscriberFileLineNumber,
         PatientFileLineNumber,
         PatientLastName,
         PatientFirstName,
         PatientDOB,
         PatientSex,
         PatientAddress,
         PatientAddress1,
         PatientAddress2,
         PatientCity,
         PatientState,
         PatientZip,
         PatientInsuredId)
        select  SubscriberFileLineNumber,
                SubscriberFileLineNumber,
                SubscriberLastName,
                SubscriberFirstName,
                SubscriberDOB,
                SubscriberSex,
                SubscriberAddress,
                SubscriberAddress1,
                SubscriberAddress2,
                SubscriberCity,
                SubscriberState,
                SubscriberZip,
                SubscriberInsuredId
        from    #SubscriberSegmentLinks
        where   SubscriberRelation = '18'

if @@error <> 0 
  return

update  ps
set     PatientInsuredId = ss.SubscriberInsuredId
from    #PatientSegmentLinks ps
        join #SubscriberSegmentLinks ss on ss.SubscriberFileLineNumber = ps.SubscriberFileLineNumber
where   ps.PatientInsuredId is null

if @@error <> 0 
  return

-- Link Claim and Service Segments
create table #ClaimSegmentLinks (
PatientFileLineNumber int null,
ClaimFileLineNumber int null,
EstimatedAmountId int null,
AuthorizationNumberId int null,
DiagnosisId int null,
AdmittingDiagnosisId int null,
PrincipalDiagnosisId int null,
OtherDiagnosisId int null,
AttendingPhysicianId int null,
PatientControlNumber varchar(38) null,
TypeOfBill varchar(10) null,
StatementStartDate datetime null,
StatementEndDate datetime null,
AdmissoinDate datetime null,
AdmissionHour varchar(10) null,
DischargeHour varchar(10) null,
ClaimCharge money null,
EstimatedAmountDue1 money null,
AuthorizationNumber1 varchar(20) null,
DiagnosisType varchar(10) null,
PrincipalDiagnosis varchar(20) null,
OtherDiagnosis1 varchar(20) null,
OtherDiagnosis2 varchar(20) null,
OtherDiagnosis3 varchar(20) null,
OtherDiagnosis4 varchar(20) null,
OtherDiagnosis5 varchar(20) null,
OtherDiagnosis6 varchar(20) null,
OtherDiagnosis7 varchar(20) null,
OtherDiagnosis8 varchar(20) null,
AdmittingDiagnosis varchar(20) null,
AttendingPhysician varchar(40) null,
RenderingProviderId int null,
RenderingProviderNameId int null,
RenderingProviderNumber varchar(35) null,
RenderingProviderName varchar(60) null,
RenderingProviderLastName varchar(30) null,
RenderingProviderFirstName varchar(30) null,
RenderingProviderTaxId varchar(12) null,
RenderingProviderNPI varchar(80) null,
RenderingProviderTaxonomyCode varchar(30) null,
SupervisingProviderId int null,
SupervisingProviderNameId int null,
SupervisingProviderName varchar(60) null,
SupervisingProviderLastName varchar(30) null,
SupervisingProviderFirstName varchar(30) null,
SupervisingProviderNPI varchar(80) null,
PlaceOfServiceCode varchar(2) null,
ImportClaimId int null,
ClaimFrequencyCode char(1) null,
PayerClaimControlNumber varchar(50) null)

if @@error <> 0 
  return

-- Get Claim Information
insert  into #ClaimSegmentLinks
        (PatientFileLineNumber,
         ClaimFileLineNumber,
         PatientControlNumber,
         ClaimCharge,
         TypeOfBill,
         PlaceOfServiceCode,
         ClaimFrequencyCode)
        select  b.PatientFileLineNumber,
                a.FileLineNumber,
                a.Element1,
                convert(money, a.Element2),
                case when substring(a.Element5, 3, 1) = @SubElementSeparator
                          and substring(a.Element5, 4, 1) = 'A' then substring(a.Element5, 1, 2)
                     else null
                end,
                case when substring(a.Element5, 3, 1) = @SubElementSeparator
                          and substring(a.Element5, 4, 1) <> 'A' /*='B'*/ then substring(a.Element5, 1, 2)
                     else null
                end,
                case when substring(a.Element5, 5, 1) = @SubElementSeparator then substring(a.Element5, 6, 1)
                     else '1'
                end
        from    #837ImportParse a
                join #PatientSegmentLinks b on (a.FileLineNumber > b.PatientFileLineNumber)
        where   Segment = 'CLM'
                and not exists ( select *
                                 from   #PatientSegmentLinks c
                                 where  a.FileLineNumber > c.PatientFileLineNumber
                                        and b.PatientFileLineNumber < c.PatientFileLineNumber )

if @@error <> 0 
  return

update  a
set     StatementStartDate = case when b.Element2 = 'D8' then convert(datetime, b.Element3)
                                  else convert(datetime, substring(b.Element3, 1, 8))
                             end,
        StatementEndDate = case when b.Element2 = 'D8' then null
                                else convert(datetime, substring(b.Element3, 10, 8))
                           end
from    #ClaimSegmentLinks a
        join #837ImportParse b on (b.FileLineNumber > a.ClaimFileLineNumber
                                   and b.FileLineNumber < (a.ClaimFileLineNumber + 100))
where   b.Segment = 'DTP'
        and b.Element1 = '434'
        and not exists ( select *
                         from   #ClaimSegmentLinks c
                         where  c.PatientFileLineNumber > a.ClaimFileLineNumber
                                and b.FileLineNumber > c.ClaimFileLineNumber
                                and b.FileLineNumber < (c.ClaimFileLineNumber + 100) )

if @@error <> 0 
  return

update  a
set     AdmissoinDate = convert(datetime, substring(b.Element3, 1, 8)),
        AdmissionHour = case when b.Element2 = 'DT' then substring(b.Element3, 10, 4)
                             else '0000'
                        end
from    #ClaimSegmentLinks a
        join #837ImportParse b on (b.FileLineNumber > a.ClaimFileLineNumber
                                   and b.FileLineNumber < (a.ClaimFileLineNumber + 100))
where   b.Segment = 'DTP'
        and b.Element1 = '435'
        and not exists ( select *
                         from   #ClaimSegmentLinks c
                         where  c.ClaimFileLineNumber > a.ClaimFileLineNumber
                                and b.FileLineNumber > c.ClaimFileLineNumber
                                and b.FileLineNumber < (c.ClaimFileLineNumber + 100) )

if @@error <> 0 
  return

update  a
set     DischargeHour = b.Element3
from    #ClaimSegmentLinks a
        join #837ImportParse b on (b.FileLineNumber > a.ClaimFileLineNumber
                                   and b.FileLineNumber < (a.ClaimFileLineNumber + 100))
where   b.Segment = 'DTP'
        and b.Element1 = '096'
        and not exists ( select *
                         from   #ClaimSegmentLinks c
                         where  c.ClaimFileLineNumber > a.ClaimFileLineNumber
                                and b.FileLineNumber > c.ClaimFileLineNumber
                                and b.FileLineNumber < (c.ClaimFileLineNumber + 100) )

if @@error <> 0 
  return

update  a
set     EstimatedAmountDue1 = convert(money, b.Element2)
from    #ClaimSegmentLinks a
        join #837ImportParse b on (b.FileLineNumber > a.ClaimFileLineNumber
                                   and b.FileLineNumber < (a.ClaimFileLineNumber + 100))
where   b.Segment = 'AMT'
        and b.Element1 = 'C5'
        and not exists ( select *
                         from   #ClaimSegmentLinks c
                         where  c.ClaimFileLineNumber > a.ClaimFileLineNumber
                                and b.FileLineNumber > c.ClaimFileLineNumber
                                and b.FileLineNumber < (c.ClaimFileLineNumber + 100) )

if @@error <> 0 
  return

-- Authorization Number
update  a
set     AuthorizationNumberId = b.FileLineNumber,
        AuthorizationNumber1 = b.Element2
from    #ClaimSegmentLinks a
        join #837ImportParse b on (b.FileLineNumber > a.ClaimFileLineNumber
                                   and b.FileLineNumber < (a.ClaimFileLineNumber + 20))
where   b.Segment = 'REF'
        and b.Element1 in ('9F', 'G1')
        and not exists ( select *
                         from   #ClaimSegmentLinks c
                         where  c.ClaimFileLineNumber > a.ClaimFileLineNumber
                                and b.FileLineNumber > c.ClaimFileLineNumber
                                and b.FileLineNumber < (c.ClaimFileLineNumber + 20) )
        and not exists ( select *
                         from   #837ImportParse d
                         where  d.Segment = 'REF'
                                and d.Element1 in ('9F', 'G1')
                                and d.FileLineNumber > a.ClaimFileLineNumber
                                and d.FileLineNumber < b.FileLineNumber )

if @@error <> 0 
  return

update  csl
set     PayerClaimControlNumber = ip.Element2
from    #ClaimSegmentLinks csl
        join #837ImportParse ip on ip.FileLineNumber > csl.ClaimFileLineNumber
                                   and ip.FileLineNumber < (csl.ClaimFileLineNumber + 100)
where   ip.Segment = 'REF'
        and ip.Element1 = 'F8'
        and not exists ( select *
                         from   #ClaimSegmentLinks csl2
                         where  csl2.ClaimFileLineNumber > csl.ClaimFileLineNumber
                                and ip.FileLineNumber > csl2.ClaimFileLineNumber
                                and ip.FileLineNumber < (csl2.ClaimFileLineNumber + 100) )

if @@error <> 0 
  return

-- Diagnosis
-- Principal and Admitting
-- Admitting diagnosis only exists in case of Institutional
update  a
set     DiagnosisType = case when substring(b.Element1, 1, 3) = 'ABK' then 'ICD10'
                             else 'ICD9'
                        end,
        PrincipalDiagnosisId = b.FileLineNumber,
        PrincipalDiagnosis = replace(replace(b.Element1, 'ABK:', ''), 'BK:', '')
from    #ClaimSegmentLinks a
        join #837ImportParse b on (b.FileLineNumber > a.ClaimFileLineNumber
                                   and b.FileLineNumber < (a.ClaimFileLineNumber + 100))
where   b.Segment = 'HI'
        and (substring(b.Element1, 1, 2) = 'BK'
             or substring(b.Element1, 1, 3) = 'ABK')
        and not exists ( select *
                         from   #ClaimSegmentLinks c
                         where  c.ClaimFileLineNumber > a.ClaimFileLineNumber
                                and b.FileLineNumber > c.ClaimFileLineNumber
                                and b.FileLineNumber < (c.ClaimFileLineNumber + 100) )

if @@error <> 0 
  return

update  a
set     AdmittingDiagnosisId = b.FileLineNumber,
        AdmittingDiagnosis = replace(replace(b.Element1, 'ABJ:', ''), 'BJ:', '')
from    #ClaimSegmentLinks a
        join #837ImportParse b on (b.FileLineNumber > a.ClaimFileLineNumber
                                   and b.FileLineNumber < (a.ClaimFileLineNumber + 100))
where   b.Segment = 'HI'
        and (substring(b.Element1, 1, 2) = 'BJ'
             or substring(b.Element1, 1, 3) = 'ABJ')
        and not exists ( select *
                         from   #ClaimSegmentLinks c
                         where  c.ClaimFileLineNumber > a.ClaimFileLineNumber
                                and b.FileLineNumber > c.ClaimFileLineNumber
                                and b.FileLineNumber < (c.ClaimFileLineNumber + 100) )

if @@error <> 0 
  return

-- Other diagnosis in case of Intitutional
update  a
set     OtherDiagnosisId = b.FileLineNumber,
        OtherDiagnosis1 = replace(replace(b.Element1, 'ABF:', ''), 'BF:', ''),
        OtherDiagnosis2 = replace(replace(b.Element2, 'ABF:', ''), 'BF:', ''),
        OtherDiagnosis3 = replace(replace(b.Element3, 'ABF:', ''), 'BF:', ''),
        OtherDiagnosis4 = replace(replace(b.Element4, 'ABF:', ''), 'BF:', ''),
        OtherDiagnosis5 = replace(replace(b.Element5, 'ABF:', ''), 'BF:', ''),
        OtherDiagnosis6 = replace(replace(b.Element6, 'ABF:', ''), 'BF:', ''),
        OtherDiagnosis7 = replace(replace(b.Element7, 'ABF:', ''), 'BF:', ''),
        OtherDiagnosis8 = replace(replace(b.Element8, 'ABF:', ''), 'BF:', '')
from    #ClaimSegmentLinks a
        join #837ImportParse b on (b.FileLineNumber > a.ClaimFileLineNumber
                                   and b.FileLineNumber < (a.ClaimFileLineNumber + 100))
where   b.Segment = 'HI'
        and (substring(b.Element1, 1, 2) = 'BF'
             or substring(b.Element1, 1, 3) = 'ABF')
        and not exists ( select *
                         from   #ClaimSegmentLinks c
                         where  c.ClaimFileLineNumber > a.ClaimFileLineNumber
                                and b.FileLineNumber > c.ClaimFileLineNumber
                                and b.FileLineNumber < (c.ClaimFileLineNumber + 100) )

if @@error <> 0 
  return

-- Other diagnosis in case of Professional
update  a
set     OtherDiagnosisId = b.FileLineNumber,
        OtherDiagnosis1 = replace(replace(b.Element2, 'ABF:', ''), 'BF:', ''),
        OtherDiagnosis2 = replace(replace(b.Element3, 'ABF:', ''), 'BF:', ''),
        OtherDiagnosis3 = replace(replace(b.Element4, 'ABF:', ''), 'BF:', ''),
        OtherDiagnosis4 = replace(replace(b.Element5, 'ABF:', ''), 'BF:', ''),
        OtherDiagnosis5 = replace(replace(b.Element6, 'ABF:', ''), 'BF:', ''),
        OtherDiagnosis6 = replace(replace(b.Element7, 'ABF:', ''), 'BF:', ''),
        OtherDiagnosis7 = replace(replace(b.Element8, 'ABF:', ''), 'BF:', ''),
        OtherDiagnosis8 = replace(replace(b.Element9, 'ABF:', ''), 'BF:', '')
from    #ClaimSegmentLinks a
        join #837ImportParse b on (b.FileLineNumber > a.ClaimFileLineNumber
                                   and b.FileLineNumber < (a.ClaimFileLineNumber + 100))
where   b.Segment = 'HI'
        and (substring(b.Element1, 1, 2) = 'BK'
             or substring(b.Element1, 1, 3) = 'ABK')
        and (substring(b.Element2, 1, 2) = 'BF'
             or substring(b.Element2, 1, 3) = 'ABF')
        and not exists ( select *
                         from   #ClaimSegmentLinks c
                         where  c.ClaimFileLineNumber > a.ClaimFileLineNumber
                                and b.FileLineNumber > c.ClaimFileLineNumber
                                and b.FileLineNumber < (c.ClaimFileLineNumber + 100) )

if @@error <> 0 
  return

update  #ClaimSegmentLinks
set     PrincipalDiagnosis = case when charindex(@SubElementSeparator, PrincipalDiagnosis) = 0 then PrincipalDiagnosis
                                  else left(PrincipalDiagnosis, charindex(@SubElementSeparator, PrincipalDiagnosis) - 1)
                             end,
        AdmittingDiagnosis = case when charindex(@SubElementSeparator, AdmittingDiagnosis) = 0 then AdmittingDiagnosis
                                  else left(AdmittingDiagnosis, charindex(@SubElementSeparator, AdmittingDiagnosis) - 1)
                             end,
        OtherDiagnosis1 = case when charindex(@SubElementSeparator, OtherDiagnosis1) = 0 then OtherDiagnosis1
                               else left(OtherDiagnosis1, charindex(@SubElementSeparator, OtherDiagnosis1) - 1)
                          end,
        OtherDiagnosis2 = case when charindex(@SubElementSeparator, OtherDiagnosis2) = 0 then OtherDiagnosis2
                               else left(OtherDiagnosis2, charindex(@SubElementSeparator, OtherDiagnosis2) - 1)
                          end,
        OtherDiagnosis3 = case when charindex(@SubElementSeparator, OtherDiagnosis3) = 0 then OtherDiagnosis3
                               else left(OtherDiagnosis3, charindex(@SubElementSeparator, OtherDiagnosis3) - 1)
                          end,
        OtherDiagnosis4 = case when charindex(@SubElementSeparator, OtherDiagnosis4) = 0 then OtherDiagnosis4
                               else left(OtherDiagnosis4, charindex(@SubElementSeparator, OtherDiagnosis4) - 1)
                          end,
        OtherDiagnosis5 = case when charindex(@SubElementSeparator, OtherDiagnosis5) = 0 then OtherDiagnosis5
                               else left(OtherDiagnosis5, charindex(@SubElementSeparator, OtherDiagnosis5) - 1)
                          end,
        OtherDiagnosis6 = case when charindex(@SubElementSeparator, OtherDiagnosis6) = 0 then OtherDiagnosis6
                               else left(OtherDiagnosis6, charindex(@SubElementSeparator, OtherDiagnosis6) - 1)
                          end,
        OtherDiagnosis7 = case when charindex(@SubElementSeparator, OtherDiagnosis7) = 0 then OtherDiagnosis7
                               else left(OtherDiagnosis7, charindex(@SubElementSeparator, OtherDiagnosis7) - 1)
                          end,
        OtherDiagnosis8 = case when charindex(@SubElementSeparator, OtherDiagnosis8) = 0 then OtherDiagnosis8
                               else left(OtherDiagnosis8, charindex(@SubElementSeparator, OtherDiagnosis8) - 1)
                          end

if @@error <> 0 
  return

update  #ClaimSegmentLinks
set     PrincipalDiagnosis = case when len(PrincipalDiagnosis) > 3 then substring(PrincipalDiagnosis, 1, 3) + '.' + substring(PrincipalDiagnosis, 4, 10)
                                  else PrincipalDiagnosis
                             end,
        AdmittingDiagnosis = case when len(AdmittingDiagnosis) > 3 then substring(AdmittingDiagnosis, 1, 3) + '.' + substring(AdmittingDiagnosis, 4, 10)
                                  else AdmittingDiagnosis
                             end,
        OtherDiagnosis1 = case when len(OtherDiagnosis1) > 3 then substring(OtherDiagnosis1, 1, 3) + '.' + substring(OtherDiagnosis1, 4, 10)
                               else OtherDiagnosis1
                          end,
        OtherDiagnosis2 = case when len(OtherDiagnosis2) > 3 then substring(OtherDiagnosis2, 1, 3) + '.' + substring(OtherDiagnosis2, 4, 10)
                               else OtherDiagnosis2
                          end,
        OtherDiagnosis3 = case when len(OtherDiagnosis3) > 3 then substring(OtherDiagnosis3, 1, 3) + '.' + substring(OtherDiagnosis3, 4, 10)
                               else OtherDiagnosis3
                          end,
        OtherDiagnosis4 = case when len(OtherDiagnosis4) > 3 then substring(OtherDiagnosis4, 1, 3) + '.' + substring(OtherDiagnosis4, 4, 10)
                               else OtherDiagnosis4
                          end,
        OtherDiagnosis5 = case when len(OtherDiagnosis5) > 3 then substring(OtherDiagnosis5, 1, 3) + '.' + substring(OtherDiagnosis5, 4, 10)
                               else OtherDiagnosis5
                          end,
        OtherDiagnosis6 = case when len(OtherDiagnosis6) > 3 then substring(OtherDiagnosis6, 1, 3) + '.' + substring(OtherDiagnosis6, 4, 10)
                               else OtherDiagnosis6
                          end,
        OtherDiagnosis7 = case when len(OtherDiagnosis7) > 3 then substring(OtherDiagnosis7, 1, 3) + '.' + substring(OtherDiagnosis7, 4, 10)
                               else OtherDiagnosis7
                          end,
        OtherDiagnosis8 = case when len(OtherDiagnosis8) > 3 then substring(OtherDiagnosis8, 1, 3) + '.' + substring(OtherDiagnosis8, 4, 10)
                               else OtherDiagnosis8
                          end

if @@error <> 0 
  return

-- Attending Physician
update  a
set     AttendingPhysicianId = b.FileLineNumber,
        AttendingPhysician = case when isnull(rtrim(b.Element4), '') = '' then b.Element3
                                  else b.Element3 + ', ' + b.Element4
                             end
from    #ClaimSegmentLinks a
        join #837ImportParse b on (b.FileLineNumber > a.ClaimFileLineNumber
                                   and b.FileLineNumber < (a.ClaimFileLineNumber + 100))
where   b.Segment = 'NM1'
        and b.Element1 = '71'
        and not exists ( select *
                         from   #ClaimSegmentLinks c
                         where  c.ClaimFileLineNumber > a.ClaimFileLineNumber
                                and b.FileLineNumber > c.ClaimFileLineNumber
                                and b.FileLineNumber < (c.ClaimFileLineNumber + 100) )

if @@error <> 0 
  return




-- Service Information
create table #ServiceSegmentLinks (
ClaimFileLineNumber int null,
ClaimFileLineNumberEnd int null,
ServiceFileLineNumber int null,
ServiceFileLineNumberEnd int null,
ServiceDateId int null,
LineItemControlNumber varchar(30) null,
ServiceLineNumber int null,
RevenueCode varchar(10) null,
HCPCSCode varchar(10) null,
BillingCodeId int null,
Modifier1 char(2) null,
Modifier2 char(2) null,
Modifier3 char(2) null,
Modifier4 char(2) null,
HCPCSRate money null,
ServiceFromDate datetime null,
ServiceToDate datetime null,
ServiceUnits varchar(10) null,
NonCoveredCharges money null,
ChargeAmount money null,
PlaceOfServiceCode varchar(2) null,
DiagnosisPointer1 int null,
DiagnosisPointer2 int null,
DiagnosisPointer3 int null,
DiagnosisPointer4 int null,
EmergencyIndicator char(1) null,
RenderingProviderNameId int null,
RenderingProviderNumber varchar(35) null,
RenderingProviderName varchar(60) null,
RenderingProviderLastName varchar(30) null,
RenderingProviderFirstName varchar(30) null,
RenderingProviderTaxId varchar(12) null,
RenderingProviderNPI varchar(80) null,
SupervisingProviderId int null,
SupervisingProviderNameId int null,
SupervisingProviderName varchar(60) null,
SupervisingProviderLastName varchar(30) null,
SupervisingProviderFirstName varchar(30) null,
SupervisingProviderNPI varchar(80) null,
OrderingProviderId int null,
OrderingProviderNameId int null,
OrderingProviderName varchar(60) null,
OrderingProviderLastName varchar(30) null,
OrderingProviderFirstName varchar(30) null,
OrderingProviderNPI varchar(80) null,
RenderingProviderTaxonomyCode varchar(30) null,
ImportClaimLineId int null,
LineNoteReferenceCode varchar(3),
LineNote varchar(100),
ServiceStartTime datetime,
ServiceEndTime datetime,
NationalDrugcode varchar(35) null,
NationalDrugcodeUnitCount varchar(15) null,
NationalDrugcodeUnitType varchar(10) null
)

if @@error <> 0 
  return

-- Institutional Service Segment
insert  into #ServiceSegmentLinks
        (ClaimFileLineNumber,
         ServiceFileLineNumber,
         RevenueCode,
         HCPCSCode,
         Modifier1,
         Modifier2,
         Modifier3,
         Modifier4,
         ChargeAmount,
         ServiceUnits,
         HCPCSRate,
         NonCoveredCharges)
        select  a.ClaimFileLineNumber,
                b.FileLineNumber,
                b.Element1,
                case when charindex(@SubElementSeparator, b.Element2, 4) = 0 then substring(b.Element2, 4, len(b.Element2) - 3)
                     else substring(b.Element2, 4, charindex(@SubElementSeparator, b.Element2, 4) - 4)
                end,
                case when charindex(@SubElementSeparator, b.Element2, 4) = 0
                          or charindex(@SubElementSeparator, b.Element2, charindex(@SubElementSeparator, b.Element2) + 1) = 0 then null
                     else substring(b.Element2, charindex(@SubElementSeparator, b.Element2, charindex(@SubElementSeparator, b.Element2) + 1) + 1, 2)
                end,
                case when charindex(@SubElementSeparator, b.Element2, 4) = 0
                          or charindex(@SubElementSeparator, b.Element2, charindex(@SubElementSeparator, b.Element2) + 1) = 0
                          or charindex(@SubElementSeparator, b.Element2, charindex(@SubElementSeparator, b.Element2, charindex(@SubElementSeparator, b.Element2) + 1) + 1) = 0 then null
                     else substring(b.Element2, charindex(@SubElementSeparator, b.Element2, charindex(@SubElementSeparator, b.Element2, charindex(@SubElementSeparator, b.Element2) + 1) + 1) + 1, 2)
                end,
                case when charindex(@SubElementSeparator, b.Element2, 4) = 0
                          or charindex(@SubElementSeparator, b.Element2, charindex(@SubElementSeparator, b.Element2) + 1) = 0
                          or charindex(@SubElementSeparator, b.Element2, charindex(@SubElementSeparator, b.Element2, charindex(@SubElementSeparator, b.Element2) + 1) + 1) = 0
                          or charindex(@SubElementSeparator, b.Element2, charindex(@SubElementSeparator, b.Element2, charindex(@SubElementSeparator, b.Element2, charindex(@SubElementSeparator, b.Element2) + 1) + 1) + 1) = 0 then null
                     else substring(b.Element2, charindex(@SubElementSeparator, b.Element2, charindex(@SubElementSeparator, b.Element2, charindex(@SubElementSeparator, b.Element2, charindex(@SubElementSeparator, b.Element2) + 1) + 1) + 1) + 1, 2)
                end,
                case when charindex(@SubElementSeparator, b.Element2, 4) = 0
                          or charindex(@SubElementSeparator, b.Element2, charindex(@SubElementSeparator, b.Element2) + 1) = 0
                          or charindex(@SubElementSeparator, b.Element2, charindex(@SubElementSeparator, b.Element2, charindex(@SubElementSeparator, b.Element2) + 1) + 1) = 0
                          or charindex(@SubElementSeparator, b.Element2, charindex(@SubElementSeparator, b.Element2, charindex(@SubElementSeparator, b.Element2, charindex(@SubElementSeparator, b.Element2) + 1) + 1) + 1) = 0
                          or charindex(@SubElementSeparator, b.Element2, charindex(@SubElementSeparator, b.Element2, charindex(@SubElementSeparator, b.Element2, charindex(@SubElementSeparator, b.Element2, charindex(@SubElementSeparator, b.Element2) + 1) + 1) + 1) + 1) = 0 then null
                     else substring(b.Element2, charindex(@SubElementSeparator, b.Element2, charindex(@SubElementSeparator, b.Element2, charindex(@SubElementSeparator, b.Element2, charindex(@SubElementSeparator, b.Element2, charindex(@SubElementSeparator, b.Element2) + 1) + 1) + 1) + 1) + 1, 2)
                end,
                convert(money, b.Element3),
                b.Element5,
                convert(money, b.Element6),
                convert(money, b.Element7)
        from    #ClaimSegmentLinks a
                join #837ImportParse b on (b.FileLineNumber > a.ClaimFileLineNumber)
        where   Segment = 'SV2'
                and not exists ( select *
                                 from   #ClaimSegmentLinks c
                                 where  c.ClaimFileLineNumber > a.ClaimFileLineNumber
                                        and b.FileLineNumber > c.ClaimFileLineNumber )

if @@error <> 0 
  return

-- Professional Service Segment
insert  into #ServiceSegmentLinks
        (ClaimFileLineNumber,
         ServiceFileLineNumber,
         HCPCSCode,
         Modifier1,
         Modifier2,
         Modifier3,
         Modifier4,
         ChargeAmount,
         ServiceUnits,
         PlaceOfServiceCode,
         DiagnosisPointer1,
         DiagnosisPointer2,
         DiagnosisPointer3,
         DiagnosisPointer4,
         EmergencyIndicator)
        select  a.ClaimFileLineNumber,
                b.FileLineNumber,
                case when charindex(@SubElementSeparator, b.Element1, 4) = 0 then substring(b.Element1, 4, len(b.Element1) - 3)
                     else substring(b.Element1, 4, charindex(@SubElementSeparator, b.Element1, 4) - 4)
                end,
                case when charindex(@SubElementSeparator, b.Element1, 4) = 0
                          or charindex(@SubElementSeparator, b.Element1, charindex(@SubElementSeparator, b.Element1) + 1) = 0 then null
                     else substring(b.Element1, charindex(@SubElementSeparator, b.Element1, charindex(@SubElementSeparator, b.Element1) + 1) + 1, 2)
                end,
                case when charindex(@SubElementSeparator, b.Element1, 4) = 0
                          or charindex(@SubElementSeparator, b.Element1, charindex(@SubElementSeparator, b.Element1) + 1) = 0
                          or charindex(@SubElementSeparator, b.Element1, charindex(@SubElementSeparator, b.Element1, charindex(@SubElementSeparator, b.Element1) + 1) + 1) = 0 then null
                     else substring(b.Element1, charindex(@SubElementSeparator, b.Element1, charindex(@SubElementSeparator, b.Element1, charindex(@SubElementSeparator, b.Element1) + 1) + 1) + 1, 2)
                end,
                case when charindex(@SubElementSeparator, b.Element1, 4) = 0
                          or charindex(@SubElementSeparator, b.Element1, charindex(@SubElementSeparator, b.Element1) + 1) = 0
                          or charindex(@SubElementSeparator, b.Element1, charindex(@SubElementSeparator, b.Element1, charindex(@SubElementSeparator, b.Element1) + 1) + 1) = 0
                          or charindex(@SubElementSeparator, b.Element1, charindex(@SubElementSeparator, b.Element1, charindex(@SubElementSeparator, b.Element1, charindex(@SubElementSeparator, b.Element1) + 1) + 1) + 1) = 0 then null
                     else substring(b.Element1, charindex(@SubElementSeparator, b.Element1, charindex(@SubElementSeparator, b.Element1, charindex(@SubElementSeparator, b.Element1, charindex(@SubElementSeparator, b.Element1) + 1) + 1) + 1) + 1, 2)
                end,
                case when charindex(@SubElementSeparator, b.Element1, 4) = 0
                          or charindex(@SubElementSeparator, b.Element1, charindex(@SubElementSeparator, b.Element1) + 1) = 0
                          or charindex(@SubElementSeparator, b.Element1, charindex(@SubElementSeparator, b.Element1, charindex(@SubElementSeparator, b.Element1) + 1) + 1) = 0
                          or charindex(@SubElementSeparator, b.Element1, charindex(@SubElementSeparator, b.Element1, charindex(@SubElementSeparator, b.Element1, charindex(@SubElementSeparator, b.Element1) + 1) + 1) + 1) = 0
                          or charindex(@SubElementSeparator, b.Element1, charindex(@SubElementSeparator, b.Element1, charindex(@SubElementSeparator, b.Element1, charindex(@SubElementSeparator, b.Element1, charindex(@SubElementSeparator, b.Element1) + 1) + 1) + 1) + 1) = 0 then null
                     else substring(b.Element1, charindex(@SubElementSeparator, b.Element1, charindex(@SubElementSeparator, b.Element1, charindex(@SubElementSeparator, b.Element1, charindex(@SubElementSeparator, b.Element1, charindex(@SubElementSeparator, b.Element1) + 1) + 1) + 1) + 1) + 1, 2)
                end,
                convert(money, b.Element2),
                b.Element4,
                b.Element5,
                case when len(b.Element7) = 0 then null
                     else substring(b.Element7, 1, 1)
                end,
                case when charindex(@SubElementSeparator, b.Element7, 1) = 0 then null
                     else substring(b.Element7, charindex(@SubElementSeparator, b.Element7, 1) + 1, 1)
                end,
                case when charindex(@SubElementSeparator, b.Element7, charindex(@SubElementSeparator, b.Element7) + 1) = 0 then null
                     else substring(b.Element7, charindex(@SubElementSeparator, b.Element7, charindex(@SubElementSeparator, b.Element7) + 1) + 1, 1)
                end,
                case when charindex(@SubElementSeparator, b.Element7, charindex(@SubElementSeparator, b.Element7) + 1) = 0
                          or charindex(@SubElementSeparator, b.Element7, charindex(@SubElementSeparator, b.Element7, charindex(@SubElementSeparator, b.Element7) + 1) + 1) = 0 then null
                     else substring(b.Element7, charindex(@SubElementSeparator, b.Element7, charindex(@SubElementSeparator, b.Element7, charindex(@SubElementSeparator, b.Element7) + 1) + 1) + 1, 1)
                end,
                b.Element9
        from    #ClaimSegmentLinks a
                join #837ImportParse b on (b.FileLineNumber > a.ClaimFileLineNumber)
        where   Segment = 'SV1'
                and not exists ( select *
                                 from   #ClaimSegmentLinks c
                                 where  c.ClaimFileLineNumber > a.ClaimFileLineNumber
                                        and b.FileLineNumber > c.ClaimFileLineNumber )

if @@error <> 0 
  return

-- Identify line number where each claim ends
update  s
set     ClaimFileLineNumberEnd = b.FileLineNumber - 1
from    #ServiceSegmentLinks s
        join #837ImportParse b on b.FileLineNumber > s.ServiceFileLineNumber
where   b.Segment = 'CLM'
        and not exists ( select *
                         from   #837ImportParse b2
                         where  b2.FileLineNumber > s.ServiceFileLineNumber
                                and b2.Segment = 'CLM'
                                and b2.FileLineNumber < b.FileLineNumber )
        and not exists ( select *
                         from   #837ImportParse b2
                         where  b2.FileLineNumber > s.ServiceFileLineNumber
                                and b2.Segment in ('HL', 'SE')
                                and b2.FileLineNumber < b.FileLineNumber )

if @@error <> 0 
  return

update  s
set     ClaimFileLineNumberEnd = b.FileLineNumber - 1
from    #ServiceSegmentLinks s
        join #837ImportParse b on b.FileLineNumber > s.ServiceFileLineNumber
where   s.ClaimFileLineNumberEnd is null
        and b.Segment in ('HL', 'SE')
        and not exists ( select *
                         from   #837ImportParse b2
                         where  b2.FileLineNumber > s.ServiceFileLineNumber
                                and b2.Segment in ('HL', 'SE')
                                and b2.FileLineNumber < b.FileLineNumber )

if @@error <> 0 
  return

---- the last claim
--update s
--  set  ClaimFileLineNumberEnd = (select max(FileLineNumber) from #837ImportParse)
-- from #ServiceSegmentLinks s
-- where ClaimFileLineNumberEnd is null

--if @@error <> 0 
--  return

-- Identify line number where each service end
update  s
set     s.ServiceFileLineNumberEnd = s2.ServiceFileLineNumber - 2
from    #ServiceSegmentLinks s
        join #ServiceSegmentLinks s2 on s2.ClaimFileLineNumber = s.ClaimFileLineNumber
                                        and s2.ServiceFileLineNumber > s.ServiceFileLineNumber
where   not exists ( select *
                     from   #ServiceSegmentLinks s3
                     where  s3.ClaimFileLineNumber = s.ClaimFileLineNumber
                            and s3.ServiceFileLineNumber > s.ServiceFileLineNumber
                            and s3.ServiceFileLineNumber < s2.ServiceFileLineNumber )

if @@error <> 0
  return

-- the last service  
update  s
set     s.ServiceFileLineNumberEnd = s.ClaimFileLineNumberEnd
from    #ServiceSegmentLinks s
where   s.ServiceFileLineNumberEnd is null

if @@error <> 0
  return

update  a
set     ServiceLineNumber = convert(int, b.Element1)
from    #ServiceSegmentLinks a
        join #837ImportParse b on (b.FileLineNumber = a.ServiceFileLineNumber - 1)

if @@error <> 0 
  return

update  a
set     ServiceDateId = b.FileLineNumber,
        ServiceFromDate = convert(datetime, substring(b.Element3, 1, 8)),
        ServiceToDate = case b.Element2
                          when 'D8' then convert(datetime, substring(b.Element3, 1, 8))
                          when 'RD8' then convert(datetime, substring(b.Element3, 10, 8))
                          else null
                        end
from    #ServiceSegmentLinks a
        join #837ImportParse b on (b.FileLineNumber > a.ServiceFileLineNumber
                                   and b.FileLineNumber < (a.ServiceFileLineNumber + 5))
where   Segment = 'DTP'
        and Element1 = '472'
        and not exists ( select *
                         from   #ServiceSegmentLinks c
                         where  c.ServiceFileLineNumber > a.ServiceFileLineNumber
                                and b.FileLineNumber > c.ServiceFileLineNumber
                                and b.FileLineNumber < (c.ServiceFileLineNumber + 5) )

if @@error <> 0 
  return

-- Get Line Item Control Number
update  a
set     LineItemControlNumber = b.Element2
from    #ServiceSegmentLinks a
        join #837ImportParse b on (b.FileLineNumber > a.ServiceFileLineNumber
                                   and b.FileLineNumber < (a.ServiceFileLineNumber + 10))
where   Segment = 'REF'
        and Element1 = '6R'
        and not exists ( select *
                         from   #ServiceSegmentLinks c
                         where  c.ServiceFileLineNumber > a.ServiceFileLineNumber
                                and b.FileLineNumber > c.ServiceFileLineNumber
                                and b.FileLineNumber < (c.ServiceFileLineNumber + 10) )

if @@error <> 0 
  return

-- Get claim level rendering provider information
update  a
set     RenderingProviderNameId = b.FileLineNumber,
        RenderingProviderName = b.Element3 + case when b.Element2 = '1' then ', ' + b.Element4
                                                  else ''
                                             end,
        RenderingProviderLastName = b.Element3,
        RenderingProviderFirstName = case when b.Element2 = '1' then b.Element4
                                          else null
                                     end,
        RenderingProviderTaxId = case when b.Element8 <> 'XX' then b.Element9
                                      else null
                                 end,
        RenderingProviderNPI = case when b.Element8 = 'XX' then b.Element9
                                    else null
                               end
from    #ClaimSegmentLinks a
        join #ServiceSegmentLinks s on s.ClaimFileLineNumber = a.ClaimFileLineNumber
        join #837ImportParse b on b.FileLineNumber between s.ClaimFileLineNumber
                                                   and     s.ClaimFileLineNumberEnd
                                  and s.ServiceFileLineNumber > b.FileLineNumber
where   b.Segment = 'NM1'
        and b.Element1 = '82'
        and not exists ( select *
                         from   #ServiceSegmentLinks s2
                         where  b.FileLineNumber between s2.ClaimFileLineNumber
                                                 and     s2.ClaimFileLineNumberEnd
                                and s2.ServiceFileLineNumber < s.ServiceFileLineNumber )

if @@error <> 0 
  return

update  a
set     RenderingProviderNumber = b.Element2
from    #ClaimSegmentLinks a
        join #837ImportParse b on (b.FileLineNumber > a.RenderingProviderNameId
                                   and b.FileLineNumber < (a.RenderingProviderNameId + 3))
where   b.Segment = 'REF'
        and b.Element1 in ('0B', '1G', 'G2', 'LU')

if @@error <> 0 
  return

update  a
set     RenderingProviderTaxId = b.Element2
from    #ClaimSegmentLinks a
        join #837ImportParse b on (b.FileLineNumber > a.RenderingProviderNameId
                                   and b.FileLineNumber < (a.RenderingProviderNameId + 3))
where   b.Segment = 'REF'
        and b.Element1 in ('EI', 'SY')

if @@error <> 0 
  return

update  a
set     RenderingProviderTaxonomyCode = b.Element3
from    #ClaimSegmentLinks a
        join #837ImportParse b on (b.FileLineNumber > a.RenderingProviderNameId
                                   and b.FileLineNumber < (a.RenderingProviderNameId + 3))
where   b.Segment = 'PRV'
        and b.Element1 = 'PE'

if @@error <> 0 
  return

-- Get claim level supervising provider information
update  a
set     SupervisingProviderNameId = b.FileLineNumber,
        SupervisingProviderName = b.Element3 + case when b.Element2 = '1' then ', ' + b.Element4
                                                    else ''
                                               end,
        SupervisingProviderLastName = b.Element3,
        SupervisingProviderFirstName = case when b.Element2 = '1' then b.Element4
                                            else null
                                       end,
        SupervisingProviderNPI = case when b.Element8 = 'XX' then b.Element9
                                      else null
                                 end
from    #ClaimSegmentLinks a
        join #ServiceSegmentLinks s on s.ClaimFileLineNumber = a.ClaimFileLineNumber
        join #837ImportParse b on b.FileLineNumber between s.ClaimFileLineNumber
                                                   and     s.ClaimFileLineNumberEnd
                                  and s.ServiceFileLineNumber > b.FileLineNumber
where   b.Segment = 'NM1'
        and b.Element1 = 'DQ'
        and not exists ( select *
                         from   #ServiceSegmentLinks s2
                         where  b.FileLineNumber between s2.ClaimFileLineNumber
                                                 and     s2.ClaimFileLineNumberEnd
                                and s2.ServiceFileLineNumber < s.ServiceFileLineNumber )

if @@error <> 0 
  return

-- Get service level rendering provider information
update  a
set     RenderingProviderNameId = b.FileLineNumber,
        RenderingProviderName = b.Element3 + case when b.Element2 = '1' then ', ' + b.Element4
                                                  else ''
                                             end,
        RenderingProviderLastName = b.Element3,
        RenderingProviderFirstName = case when b.Element2 = '1' then b.Element4
                                          else null
                                     end,
        RenderingProviderTaxId = case when b.Element8 <> 'XX' then b.Element9
                                      else null
                                 end,
        RenderingProviderNPI = case when b.Element8 = 'XX' then b.Element9
                                    else null
                               end
from    #ServiceSegmentLinks a
        join #837ImportParse b on b.FileLineNumber between a.ServiceFileLineNumber
                                                   and     a.ServiceFileLineNumberEnd
where   b.Segment = 'NM1'
        and b.Element1 = '82'

if @@error <> 0
  return

update  a
set     RenderingProviderNumber = b.Element2
from    #ServiceSegmentLinks a
        join #837ImportParse b on (b.FileLineNumber > a.RenderingProviderNameId
                                   and b.FileLineNumber < (a.RenderingProviderNameId + 3))
where   b.Segment = 'REF'
        and b.Element1 in ('0B', '1G', 'G2', 'LU')

if @@error <> 0
  return

update  a
set     RenderingProviderTaxId = b.Element2
from    #ServiceSegmentLinks a
        join #837ImportParse b on (b.FileLineNumber > a.RenderingProviderNameId
                                   and b.FileLineNumber < (a.RenderingProviderNameId + 3))
where   b.Segment = 'REF'
        and b.Element1 in ('EI', 'SY')

if @@error <> 0
  return

update  a
set     RenderingProviderTaxonomyCode = b.Element3
from    #ServiceSegmentLinks a
        join #837ImportParse b on (b.FileLineNumber > a.RenderingProviderNameId
                                   and b.FileLineNumber < (a.RenderingProviderNameId + 3))
where   b.Segment = 'PRV'
        and b.Element1 = 'PE'

if @@error <> 0
  return

-- Get service level supervising provider information
update  a
set     SupervisingProviderNameId = b.FileLineNumber,
        SupervisingProviderName = b.Element3 + case when b.Element2 = '1' then ', ' + b.Element4
                                                    else ''
                                               end,
        SupervisingProviderLastName = b.Element3,
        SupervisingProviderFirstName = case when b.Element2 = '1' then b.Element4
                                            else null
                                       end,
        SupervisingProviderNPI = case when b.Element8 = 'XX' then b.Element9
                                      else null
                                 end
from    #ServiceSegmentLinks a
        join #837ImportParse b on b.FileLineNumber between a.ServiceFileLineNumber
                                                   and     a.ServiceFileLineNumberEnd
where   b.Segment = 'NM1'
        and b.Element1 = 'DQ'

if @@error <> 0
  return

-- Get service level ordering provider information
update  a
set     OrderingProviderNameId = b.FileLineNumber,
        OrderingProviderName = b.Element3 + case when b.Element2 = '1' then ', ' + b.Element4
                                                    else ''
                                               end,
        OrderingProviderLastName = b.Element3,
        OrderingProviderFirstName = case when b.Element2 = '1' then b.Element4
                                            else null
                                       end,
        OrderingProviderNPI = case when b.Element8 = 'XX' then b.Element9
                                      else null
                                 end
from    #ServiceSegmentLinks a
        join #837ImportParse b on b.FileLineNumber between a.ServiceFileLineNumber
                                                   and     a.ServiceFileLineNumberEnd
where   b.Segment = 'NM1'
        and b.Element1 = 'DK'

if @@error <> 0
  return

-- If there is no rendering information in Service Segment use from Claim segment if exists
update  a
set     RenderingProviderName = b.RenderingProviderName,
        RenderingProviderLastName = b.RenderingProviderLastName,
        RenderingProviderFirstName = b.RenderingProviderFirstName,
        RenderingProviderNumber = b.RenderingProviderNumber,
        RenderingProviderTaxId = b.RenderingProviderTaxId,
        RenderingProviderNPI = b.RenderingProviderNPI,
        RenderingProviderTaxonomyCode = b.RenderingProviderTaxonomyCode
from    #ServiceSegmentLinks a
        join #ClaimSegmentLinks b on (a.ClaimFileLineNumber = b.ClaimFileLineNumber)
where   a.RenderingProviderName is null
        and b.RenderingProviderName is not null

if @@error <> 0 
  return

-- If there is no supervising information in Service Segment use from Claim segment if exists
update  a
set     SupervisingProviderName = b.SupervisingProviderName,
        SupervisingProviderLastName = b.SupervisingProviderLastName,
        SupervisingProviderFirstName = b.SupervisingProviderFirstName,
        SupervisingProviderNPI = b.SupervisingProviderNPI
from    #ServiceSegmentLinks a
        join #ClaimSegmentLinks b on (a.ClaimFileLineNumber = b.ClaimFileLineNumber)
where   a.SupervisingProviderName is null
        and b.SupervisingProviderName is not null

if @@error <> 0 
  return

-- Get National Drug Code information
update  a 
set     NationalDrugcode = case when len(replace(isnull(b.Element3, ''),' ','')) <= 11 then b.Element3 end 
from    #ServiceSegmentLinks a
        join #837ImportParse b on b.FileLineNumber between a.ServiceFileLineNumber
                                                   and     a.ServiceFileLineNumberEnd
where   b.Segment = 'LIN'
        and b.Element2 = 'N4'

if @@error <> 0 
  return

-- Get National Drug Code Unit Count information
update  a
set     NationalDrugcodeUnitCount = b.Element4,
		NationalDrugcodeUnitType = b.Element5
from    #ServiceSegmentLinks a
        join #837ImportParse b on b.FileLineNumber between a.ServiceFileLineNumber
                                                   and     a.ServiceFileLineNumberEnd
where   b.Segment = 'CTP'

if @@error <> 0 
  return

-- Get service line note
update  a
set     LineNoteReferenceCode = b.Element1,
        LineNote = b.Element2
from    #ServiceSegmentLinks a
        join #837ImportParse b on b.FileLineNumber between a.ServiceFileLineNumber
                                                   and     a.ServiceFileLineNumberEnd
where   b.Segment = 'NTE'

if @@error <> 0 
  return

-- Other Insured
create table #OtherInsuranceSegementLinks2 (
ClaimFileLineNumber int null,
Payer1 varchar(50) null,
Payer2 varchar(50) null,
Payer3 varchar(50) null,
-- Below columns added by Pralyankar on June 12, 2012 ----
PayerId1 varchar(20) null,
PayerId2 varchar(20) null,
PayerId3 varchar(20) null,
----------------------------------------------------------
ProviderNumber1 varchar(20) null,
ProviderNumber2 varchar(20) null,
ProviderNumber3 varchar(20) null,
InsuredName1 varchar(30) null,
InsuredName2 varchar(30) null,
InsuredName3 varchar(30) null,
InsuredId1 varchar(20) null,
InsuredId2 varchar(20) null,
InsuredId3 varchar(20) null,
GroupNumber1 varchar(20) null,
GroupNumber2 varchar(20) null,
GroupNumber3 varchar(20) null,
AuthorizationNumber1 varchar(20) null,
AuthorizationNumber2 varchar(20) null,
AuthorizationNumber3 varchar(20) null,
EstimatedAmountDue1 money null,
EstimatedAmountDue2 money null,
EstimatedAmountDue3 money null,
PriorPayment1 money null,
PriorPayment2 money null,
PriorPayment3 money null)

create table #OtherInsuranceSegementLinks (
ClaimFileLineNumber int null,
OtherInsuranceFileLineNumber int null,
ServiceFileLineNumber int null,
PayerPriority char(1) null,
PayerPriorityNumber int null,
Payer varchar(50) null,
PayerId varchar(20) null, -- This new field Added by Pralyankar On June 12, 2012.
ProviderNumber varchar(20) null,
InsuredName varchar(30) null,
InsuredId varchar(20) null,
GroupNumber varchar(20) null,
AuthorizationNumber varchar(20) null,
PriorPayment money null)

insert  into #OtherInsuranceSegementLinks
        (ClaimFileLineNumber,
         OtherInsuranceFileLineNumber,
         ServiceFileLineNumber)
        select  b.ClaimFileLineNumber,
                a.FileLineNumber,
                min(c.ServiceFileLineNumber)
        from    #837ImportParse a
                join #ClaimSegmentLinks b on (a.FileLineNumber > b.ClaimFileLineNumber)
                join #ServiceSegmentLinks c on (b.ClaimFileLineNumber = c.ClaimFileLineNumber)
        where   a.Segment = 'OI'
                and not exists ( select *
                                 from   #ClaimSegmentLinks c
                                 where  a.FileLineNumber > c.ClaimFileLineNumber
                                        and b.ClaimFileLineNumber < c.ClaimFileLineNumber )
        group by b.ClaimFileLineNumber,
                a.FileLineNumber

if @@error <> 0 
  return

update  a
set     PayerPriority = b.Element1,
        GroupNumber = b.Element3
from    #OtherInsuranceSegementLinks a
        join #837ImportParse b on (b.FileLineNumber > a.ClaimFileLineNumber
                                   and b.FileLineNumber < a.OtherInsuranceFileLineNumber)
where   b.Segment = 'SBR'
        and not exists ( select *
                         from   #OtherInsuranceSegementLinks c
                         where  b.FileLineNumber < c.OtherInsuranceFileLineNumber
                                and a.OtherInsuranceFileLineNumber > c.OtherInsuranceFileLineNumber )

if @@error <> 0 
  return

update  a
set     PriorPayment = convert(money, b.Element2)
from    #OtherInsuranceSegementLinks a
        join #837ImportParse b on (b.FileLineNumber > a.ClaimFileLineNumber
                                   and b.FileLineNumber < a.OtherInsuranceFileLineNumber)
where   b.Segment = 'AMT'
        and b.Element1 = 'D'
        and not exists ( select *
                         from   #OtherInsuranceSegementLinks c
                         where  b.FileLineNumber < c.OtherInsuranceFileLineNumber
                                and a.OtherInsuranceFileLineNumber > c.OtherInsuranceFileLineNumber )

if @@error <> 0 
  return

update  a
set     InsuredName = b.Element3 + ', ' + isnull(b.Element4, ''),
        InsuredId = Element9
from    #OtherInsuranceSegementLinks a
        join #837ImportParse b on (b.FileLineNumber > a.OtherInsuranceFileLineNumber
                                   and b.FileLineNumber < a.ServiceFileLineNumber
                                   and b.FileLineNumber < a.OtherInsuranceFileLineNumber + 5)
where   b.Segment = 'NM1'
        and b.Element1 = 'IL'
        and not exists ( select *
                         from   #OtherInsuranceSegementLinks c
                         where  b.FileLineNumber > c.OtherInsuranceFileLineNumber
                                and a.OtherInsuranceFileLineNumber < c.OtherInsuranceFileLineNumber )

if @@error <> 0 
  return

update  a
set     Payer = b.Element3,
        PayerId = b.Element9 -- This line of code written by Pralyankar on June 12, 2012.
from    #OtherInsuranceSegementLinks a
        join #837ImportParse b on (b.FileLineNumber > a.OtherInsuranceFileLineNumber
                                   and b.FileLineNumber < a.ServiceFileLineNumber
                                   and b.FileLineNumber < a.OtherInsuranceFileLineNumber + 10)
where   b.Segment = 'NM1'
        and b.Element1 = 'PR'
        and not exists ( select *
                         from   #OtherInsuranceSegementLinks c
                         where  b.FileLineNumber > c.OtherInsuranceFileLineNumber
                                and a.OtherInsuranceFileLineNumber < c.OtherInsuranceFileLineNumber )

if @@error <> 0 
  return

update  a
set     AuthorizationNumber = b.Element2
from    #OtherInsuranceSegementLinks a
        join #837ImportParse b on (b.FileLineNumber > a.OtherInsuranceFileLineNumber
                                   and b.FileLineNumber < a.ServiceFileLineNumber
                                   and b.FileLineNumber < a.OtherInsuranceFileLineNumber + 15)
where   b.Segment = 'REF'
        and b.Element1 in ('9F', 'G1')
        and not exists ( select *
                         from   #OtherInsuranceSegementLinks c
                         where  b.FileLineNumber > c.OtherInsuranceFileLineNumber
                                and a.OtherInsuranceFileLineNumber < c.OtherInsuranceFileLineNumber )

if @@error <> 0 
  return

update  a
set     ProviderNumber = b.Element2
from    #OtherInsuranceSegementLinks a
        join #837ImportParse b on (b.FileLineNumber > a.OtherInsuranceFileLineNumber
                                   and b.FileLineNumber < a.ServiceFileLineNumber)
where   b.Segment = 'REF'
        and b.Element1 in ('1B', '1C', '1D', '1G', '1H', 'EI', 'G2', 'LU', 'N5', 'SY')
        and not exists ( select *
                         from   #OtherInsuranceSegementLinks c
                         where  b.FileLineNumber > c.OtherInsuranceFileLineNumber
                                and a.OtherInsuranceFileLineNumber < c.OtherInsuranceFileLineNumber )

if @@error <> 0 
  return

-- Calculate payer priority number
create table #OtherInsuranceSegementLinksPriority (
PayerPriorityId int identity
                    not null,
ClaimFileLineNumber int not null,
OtherInsuranceFileLineNumber int not null,
PayerPriorityNumber int null)

insert  into #OtherInsuranceSegementLinksPriority
        (ClaimFileLineNumber,
         OtherInsuranceFileLineNumber)
        select  ClaimFileLineNumber,
                OtherInsuranceFileLineNumber
        from    #OtherInsuranceSegementLinks
        order by case PayerPriority
                   when 'P' then 1
                   when 'S' then 2
                   when 'T' then 3
                   else 4
                 end

if @@error <> 0 
  return

update  oip
set     PayerPriorityNumber = (oip.PayerPriorityId - oipf.FirstPayerPriorityId) + 1
from    #OtherInsuranceSegementLinksPriority oip
        join (select  ClaimFileLineNumber,
                      min(PayerPriorityId) as FirstPayerPriorityId
              from    #OtherInsuranceSegementLinksPriority
              group by ClaimFileLineNumber) as oipf on oipf.ClaimFileLineNumber = oip.ClaimFileLineNumber

if @@error <> 0 
  return

-- Update information for each Payer
insert  into #OtherInsuranceSegementLinks2
        (ClaimFileLineNumber,
         Payer1,
         Payer2,
         Payer3,
         PayerId1,
         PayerId2,
         PayerId3,
         ProviderNumber1,
         ProviderNumber2,
         ProviderNumber3,
         InsuredName1,
         InsuredName2,
         InsuredName3,
         InsuredId1,
         InsuredId2,
         InsuredId3,
         GroupNumber1,
         GroupNumber2,
         GroupNumber3,
         AuthorizationNumber1,
         AuthorizationNumber2,
         AuthorizationNumber3,
         EstimatedAmountDue1,
         EstimatedAmountDue2,
         EstimatedAmountDue3,
         PriorPayment1,
         PriorPayment2,
         PriorPayment3)
        select  a.ClaimFileLineNumber,
                max(case when oip.PayerPriorityNumber = 1 then ois.Payer
                         else null
                    end),
                max(case when oip.PayerPriorityNumber = 2 then ois.Payer
                         else null
                    end),
                max(case when oip.PayerPriorityNumber = 3 then ois.Payer
                         else null
                    end),
                max(case when oip.PayerPriorityNumber = 1 then ois.PayerId
                         else null
                    end),
                max(case when oip.PayerPriorityNumber = 2 then ois.PayerId
                         else null
                    end),
                max(case when oip.PayerPriorityNumber = 3 then ois.PayerId
                         else null
                    end),
                max(case when oip.PayerPriorityNumber = 1 then ois.ProviderNumber
                         else null
                    end),
                max(case when oip.PayerPriorityNumber = 2 then ois.ProviderNumber
                         else null
                    end),
                max(case when oip.PayerPriorityNumber = 3 then ois.ProviderNumber
                         else null
                    end),
                max(case when oip.PayerPriorityNumber = 1 then ois.InsuredName
                         else null
                    end),
                max(case when oip.PayerPriorityNumber = 2 then ois.InsuredName
                         else null
                    end),
                max(case when oip.PayerPriorityNumber = 3 then ois.InsuredName
                         else null
                    end),
                max(case when oip.PayerPriorityNumber = 1 then ois.InsuredId
                         else null
                    end),
                max(case when oip.PayerPriorityNumber = 2 then ois.InsuredId
                         else null
                    end),
                max(case when oip.PayerPriorityNumber = 3 then ois.InsuredId
                         else null
                    end),
                max(case when oip.PayerPriorityNumber = 1 then ois.GroupNumber
                         else null
                    end),
                max(case when oip.PayerPriorityNumber = 2 then ois.GroupNumber
                         else null
                    end),
                max(case when oip.PayerPriorityNumber = 3 then ois.GroupNumber
                         else null
                    end),
                max(case when oip.PayerPriorityNumber = 1 then ois.AuthorizationNumber
                         else null
                    end),
                max(case when oip.PayerPriorityNumber = 2 then ois.AuthorizationNumber
                         else null
                    end),
                max(case when oip.PayerPriorityNumber = 3 then ois.AuthorizationNumber
                         else null
                    end),
                max(case when oip.PayerPriorityNumber = 1 then a.EstimatedAmountDue1
                         else null
                    end),
                max(case when oip.PayerPriorityNumber = 2 then a.EstimatedAmountDue1
                         else null
                    end),
                max(case when oip.PayerPriorityNumber = 3 then a.EstimatedAmountDue1
                         else null
                    end),
                max(case when oip.PayerPriorityNumber = 1 then ois.PriorPayment
                         else null
                    end),
                max(case when oip.PayerPriorityNumber = 2 then ois.PriorPayment
                         else null
                    end),
                max(case when oip.PayerPriorityNumber = 3 then ois.PriorPayment
                         else null
                    end)
        from    #ClaimSegmentLinks a
                join #OtherInsuranceSegementLinks ois on ois.ClaimFileLineNumber = a.ClaimFileLineNumber
                join #OtherInsuranceSegementLinksPriority oip on oip.OtherInsuranceFileLineNumber = ois.OtherInsuranceFileLineNumber
        where   oip.PayerPriorityNumber <= 3
        group by a.ClaimFileLineNumber

if @@error <> 0 
  return

-- Process service line other payer adjudications and adjuadjustments
create table #ServiceAdjudications (
ServiceAdjudicationLineNumber int null,
ServiceFileLineNumber int null,
ClaimFileLineNumber int null,
OtherInsuranceFileLineNumber int null,
PayerId varchar(20) null,
PaidAmount money null)

if @@error <> 0 
  return

insert  into #ServiceAdjudications
        (ServiceAdjudicationLineNumber,
         ServiceFileLineNumber,
         ClaimFileLineNumber,
         PayerId,
         PaidAmount)
        select  ip.FileLineNumber,
                ss.ServiceFileLineNumber,
                ss.ClaimFileLineNumber,
                ip.Element1,
                ip.Element2
        from    #837ImportParse ip
                join #ServiceSegmentLinks ss on ss.ServiceFileLineNumber < ip.FileLineNumber
        where   ip.Segment = 'SVD'
                and not exists ( select *
                                 from   #ServiceSegmentLinks ss2
                                 where  ss2.ServiceFileLineNumber < ip.FileLineNumber
                                        and ss2.ServiceFileLineNumber > ss.ServiceFileLineNumber )

if @@error <> 0 
  return
                     
update  sa
set     OtherInsuranceFileLineNumber = ois.OtherInsuranceFileLineNumber
from    #ServiceAdjudications sa
        join #OtherInsuranceSegementLinks ois on ois.ClaimFileLineNumber = sa.ClaimFileLineNumber
                                                 and ois.PayerId = sa.PayerId   

if @@error <> 0 
  return

create table #ServiceAdjustments (
ServiceAdjustmentFileNumber int,
ServiceAdjudicationLineNumber int,
ServiceFileLineNumber int,
AdjustmentNumber int,
AdjustmentgroupCode varchar(10),
AdjustmentReasonCode varchar(10),
AdjustmentAmount money)

if @@error <> 0 
  return

insert  into #ServiceAdjustments
        (ServiceAdjustmentFileNumber,
         ServiceAdjudicationLineNumber,
         ServiceFileLineNumber,
         AdjustmentNumber,
         AdjustmentgroupCode,
         AdjustmentReasonCode,
         AdjustmentAmount)
        select  ip.FileLineNumber,
                sa.ServiceAdjudicationLineNumber,
                sa.ServiceFileLineNumber,
                1,
                ip.Element1,
                ip.Element2,
                ip.Element3
        from    #837ImportParse ip
                join #ServiceAdjudications sa on sa.ServiceAdjudicationLineNumber < ip.FileLineNumber
                                                 and (sa.ServiceAdjudicationLineNumber + 5) >= ip.FileLineNumber
        where   ip.Segment = 'CAS'
                and not exists ( select *
                                 from   #ServiceAdjudications sa2
                                 where  sa2.ServiceAdjudicationLineNumber < ip.FileLineNumber
                                        and (sa2.ServiceAdjudicationLineNumber + 5) >= ip.FileLineNumber
                                        and sa2.ServiceAdjudicationLineNumber > sa.ServiceAdjudicationLineNumber )

if @@error <> 0 
  return

insert  into #ServiceAdjustments
        (ServiceAdjustmentFileNumber,
         ServiceAdjudicationLineNumber,
         ServiceFileLineNumber,
         AdjustmentNumber,
         AdjustmentgroupCode,
         AdjustmentReasonCode,
         AdjustmentAmount)
        select  sa.ServiceAdjustmentFileNumber,
                sa.ServiceAdjudicationLineNumber,
                sa.ServiceFileLineNumber,
                2,
                ip.Element1,
                ip.Element5,
                ip.Element6
        from    #837ImportParse ip
                join #ServiceAdjustments sa on sa.ServiceAdjustmentFileNumber = ip.FileLineNumber
        where   isnull(ip.Element5, '') <> ''
        union
        select  sa.ServiceAdjustmentFileNumber,
                sa.ServiceAdjudicationLineNumber,
                sa.ServiceFileLineNumber,
                3,
                ip.Element1,
                ip.Element8,
                ip.Element9
        from    #837ImportParse ip
                join #ServiceAdjustments sa on sa.ServiceAdjustmentFileNumber = ip.FileLineNumber
        where   isnull(ip.Element8, '') <> ''
        union
        select  sa.ServiceAdjustmentFileNumber,
                sa.ServiceAdjudicationLineNumber,
                sa.ServiceFileLineNumber,
                4,
                ip.Element1,
                ip.Element11,
                ip.Element12
        from    #837ImportParse ip
                join #ServiceAdjustments sa on sa.ServiceAdjustmentFileNumber = ip.FileLineNumber
        where   isnull(ip.Element11, '') <> ''
        union
        select  sa.ServiceAdjustmentFileNumber,
                sa.ServiceAdjudicationLineNumber,
                sa.ServiceFileLineNumber,
                5,
                ip.Element1,
                ip.Element14,
                ip.Element15
        from    #837ImportParse ip
                join #ServiceAdjustments sa on sa.ServiceAdjustmentFileNumber = ip.FileLineNumber
        where   isnull(ip.Element14, '') <> ''
        union
        select  sa.ServiceAdjustmentFileNumber,
                sa.ServiceAdjudicationLineNumber,
                sa.ServiceFileLineNumber,
                6,
                ip.Element1,
                ip.Element17,
                ip.Element18
        from    #837ImportParse ip
                join #ServiceAdjustments sa on sa.ServiceAdjustmentFileNumber = ip.FileLineNumber
        where   isnull(ip.Element17, '') <> ''                    

if @@error <> 0 
  return

--Get service count by batch
insert  into #BatchServiceCount
        (BatchNumber,
         ServiceCount)
        select  b.BatchNumber,
                count(*)
        from    #837ImportParse a
                join #837Batches b on (a.FileLineNumber > b.StartFileLineNumber
                                       and a.FileLineNumber < b.EndFileLineNumber)
        where   a.Segment in ('SV2', 'SV1')
        group by b.BatchNumber

if @@error <> 0 
  return

update  a
set     ServiceCount = b.ServiceCount
from    #837Batches a
        join #BatchServiceCount b on (a.BatchNumber = b.BatchNumber)

if @@error <> 0 
  return

-- Summarize Batch Information
insert  into #837BatchSummaries
        (BatchNumber,
         TotalClaims,
         TotalClaimLines,
         TotalCharges)
        select  a.BatchNumber,
                count(distinct d.ClaimFileLineNumber),
                count(*),
                sum(e.ChargeAmount)
        from    #ProviderSegmentLinks a
                join #SubscriberSegmentLinks b on (a.ProviderFileLineNumber = b.ProviderFileLineNumber)
                join #PatientSegmentLinks c on (b.SubscriberFileLineNumber = c.SubscriberFileLineNumber)
                join #ClaimSegmentLinks d on (c.PatientFileLineNumber = d.PatientFileLineNumber)
                join #ServiceSegmentLinks e on (d.ClaimFileLineNumber = e.ClaimFileLineNumber)
        group by a.BatchNumber

if @@error <> 0 
  return

-- Compare claim charge to service charge
insert  into #ClaimCharge
        (ClaimFileLineNumber,
         ClaimCharge)
        select  ClaimFileLineNumber,
                sum(isnull(ChargeAmount, 0))
        from    #ServiceSegmentLinks
        group by ClaimFileLineNumber

if @@error <> 0 
  return

if exists ( select  *
            from    #ClaimCharge a
                    join #ClaimSegmentLinks b on (a.ClaimFileLineNumber = b.ClaimFileLineNumber)
            where   isnull(a.ClaimCharge, 0) <> isnull(b.ClaimCharge, 0) ) 
  begin
    insert  into #ParseErrors
            (LineNumber,
             ErrorMessage)
            select  a.ClaimFileLineNumber,
                    'Claim charge amount does not match sum of service charge amount'
            from    #ClaimCharge a
                    join #ClaimSegmentLinks b on (a.ClaimFileLineNumber = b.ClaimFileLineNumber)
            where   isnull(a.ClaimCharge, 0) <> isnull(b.ClaimCharge, 0)
  end

if @@error <> 0 
  return

if exists ( select  *
            from    #837Batches
            where   SubmitterId <> @SubmitterId ) 
  begin
    insert  into #ParseErrors
            (LineNumber,
             ErrorMessage)
            select  StartFileLineNumber,
                    'Batch Submitter ID does not match selected Sender''s Submitter Id'
            from    #837Batches a
            where   SubmitterId <> @SubmitterId
	
  end

if exists ( select  *
            from    #837Batches
            where   SubmitterLastName + case when len(SubmitterFirstName) > 0 then ', ' + SubmitterFirstName
                                             else ''
                                        end <> @SubmitterName ) 
  begin
    insert  into #ParseErrors
            (LineNumber,
             ErrorMessage)
            select  StartFileLineNumber,
                    'Batch Submitter Name does not match selected Sender''s Submitter Name'
            from    #837Batches a
            where   SubmitterLastName + case when len(SubmitterFirstName) > 0 then ', ' + SubmitterFirstName
                                             else ''
                                        end <> @SubmitterName
	
  end

if @@error <> 0 
  return

-- Check if the file was imported before
if @FirstTimeProcessing = 'Y' 
  begin
    if exists ( select  *
                from    Import837Batches a
                        join #837Batches b on (a.TransactionSetControlNumber = b.TransactionSetControlNumber)
                        join Import837Files c on (a.Import837FileId = c.Import837FileId
                                                  and a.TransactionDateTime = b.TransactionDateTime)
                where   c.Import837SenderId = @SenderId
                        and isnull(a.RecordDeleted, 'N') = 'N'
                        and isnull(c.RecordDeleted, 'N') = 'N' ) 
      begin
        insert  into #ParseErrors
                (LineNumber,
                 ErrorMessage)
                select distinct
                        b.StartFileLineNumber,
                        'Batch has already been imported once. File Name:' + c.FileName + ', Import Date:' + convert(varchar, c.ImportDate, 101)
                from    Import837Batches a
                        join #837Batches b on (a.TransactionSetControlNumber = b.TransactionSetControlNumber)
                        join Import837Files c on (a.Import837FileId = c.Import837FileId
                                                  and a.TransactionDateTime = b.TransactionDateTime
                                                  and a.ApplicationTransactionId = b.ApplicationTransactionId)
                where   c.Import837SenderId = @SenderId
                        and isnull(a.RecordDeleted, 'N') = 'N'
                        and isnull(c.RecordDeleted, 'N') = 'N'
      end
  end

if @@error <> 0 
  return

-- Deleted Previous Parsing Errors
update  Import837FileParsingErrors
set     RecordDeleted = 'Y',
        DeletedBy = @UserCode,
        DeletedDate = getdate()
where   Import837FileId = @Import837FileId
        and isnull(RecordDeleted, 'N') = 'N'

end_parsing:

if exists ( select  *
            from    #ParseErrors ) 
  goto parse_error

if @FirstTimeProcessing = 'N' 
  goto process_claims

-- Enter data into batch
begin tran

if @@error <> 0 
  return

-- Create batch information
declare @BatchNumber int,
  @BatchStartId int,
  @BatchEndId int
declare @BatchCount int,
  @TotalBatches int
declare @StartFileLInNumber int,
  @EndFileLineNumber int,
  @ImportBatchNumber int

select  @BatchCount = 0,
        @TotalBatches = count(*)
from    #837Batches

if @@error <> 0 
  goto rollback_tran

declare cur_batch cursor
for
select  BatchNumber,
        StartFileLineNumber,
        EndFileLineNumber
from    #837Batches
order by BatchNumber

if @@error <> 0 
  goto rollback_tran

open cur_batch

if @@error <> 0 
  begin
    deallocate cur_batch
    goto rollback_tran
  end

fetch cur_batch into @BatchNumber, @StartFileLInNumber, @EndFileLineNumber

if @@error <> 0 
  begin
    close cur_batch
    deallocate cur_batch
    goto rollback_tran
  end

/* Begin Of While loop for batch numbers */
while @@fetch_status = 0 
  begin

    select  @BatchCount = @BatchCount + 1

    insert  into Import837Batches
            (Import837FileId,
             TransactionSetControlNumber,
             TransactionTypeCode,
             TransmissionTypeCode, /*FileType,*/
             ApplicationTransactionId,
             TransactionDateTime,
             SubmitterLastName,
             SubmitterFirstName,
             SubmitterId,
             TotalClaims,
             TotalClaimLines,
             TotalCharges,
             NumberOfSegments,
             FileLineStart,
             FileLineEnd,
             CreatedBy,
             ModifiedBy)
            select  @Import837FileId,
                    a.TransactionSetControlNumber,
                    a.TransactionTypeCode,
                    a.TransmissionTypeCode, /*a.FileType,*/
                    a.ApplicationTransactionId,
                    a.TransactionDateTime,
                    a.SubmitterLastName,
                    a.SubmitterFirstName,
                    a.SubmitterId,
                    b.TotalClaims,
                    b.TotalClaimLines,
                    b.TotalCharges,
                    a.TotalSegments,
                    a.StartFileLineNumber,
                    a.EndFileLineNumber,
                    @UserCode,
                    @UserCode
            from    #837Batches a
                    join #837BatchSummaries b on (a.BatchNumber = b.BatchNumber)
            where   a.BatchNumber = @BatchNumber

    if @@error <> 0 
      goto rollback_tran

    select  @ImportBatchNumber = @@identity

    if @ImportBatchNumber < 1 
      begin
        select  @ErrorNo = 30003,
                @ErrorMessage = 'Failure to create batch record.'
        close cur_batch
        deallocate cur_batch
        goto rollback_tran
      end

    update  #837Batches
    set     ImportBatchNumber = @ImportBatchNumber
    where   BatchNumber = @BatchNumber

    if @@error <> 0 
      begin
        close cur_batch
        deallocate cur_batch
        goto rollback_tran
      end

    insert  into Import837BatchClaims
            (Import837BatchId,
             FileLineStart,
             FileLineEnd,
             ProviderNumber,
             ProviderName,
             ProviderTaxId,
             ProviderNPI,
             ProviderTaxonomyCode,
             SubscriberNumber,
             PatientAccountNumber,
             ClientLastName,
             ClientFirstName,
             PayerId,
             ClaimControlNumber,
             ClaimCharges,
             DeletedBy,
             CreatedBy,
             ModifiedBy)
            select  @ImportBatchNumber,
                    d.ClaimFileLineNumber,
                    null,
                    b.ProviderSecondaryId,
                    a.ProviderName,
                    a.ProviderTaxId,
                    a.ProviderNPI,
                    a.ProviderTaxonomyCode,
                    b.SubscriberInsuredId,
                    d.PatientControlNumber,
                    c.PatientLastName,
                    c.PatientFirstName,
                    b.PayerName,
                    d.PayerClaimControlNumber,
                    d.ClaimCharge,
                    convert(varchar, @ImportBatchNumber) + ';' + convert(varchar, d.ClaimFileLineNumber),
                    @UserCode,
                    @UserCode
            from    #ProviderSegmentLinks a
                    join #SubscriberSegmentLinks b on (a.ProviderFileLineNumber = b.ProviderFileLineNumber)
                    join #PatientSegmentLinks c on (b.SubscriberFileLineNumber = c.SubscriberFileLineNumber)
                    join #ClaimSegmentLinks d on (c.PatientFileLineNumber = d.PatientFileLineNumber)
            where   a.BatchNumber = @BatchNumber

    if @@error <> 0 
      begin
        close cur_batch
        deallocate cur_batch
        goto rollback_tran
      end

    update  b
    set     ImportClaimId = a.Import837BatchClaimId
    from    Import837BatchClaims a
            join #ClaimSegmentLinks b on (convert(varchar, @ImportBatchNumber) + ';' + convert(varchar, b.ClaimFileLineNumber) = a.DeletedBy)
    where   a.Import837BatchId = @ImportBatchNumber

    if @@error <> 0 
      begin
        close cur_batch
        deallocate cur_batch
        goto rollback_tran
      end

    update  a
    set     DeletedBy = null
    from    Import837BatchClaims a
            join #ClaimSegmentLinks b on (convert(varchar, @ImportBatchNumber) + ';' + convert(varchar, b.ClaimFileLineNumber) = a.DeletedBy)
    where   a.Import837BatchId = @ImportBatchNumber


    if @@error <> 0 
      begin
        close cur_batch
        deallocate cur_batch
        goto rollback_tran
      end

    insert  into Import837BatchClaimLines
            (Import837BatchClaimId,
             FileLineStart,
             FileLineEnd,
             ServiceLineNumber,
             LineItemControlNumber,
             ServiceDate,
             RevenueCode,
             ProcedureCode,
             AuthorizationNumber,
             ChargeAmount,
             RenderingProviderNumber,
             RenderingProviderName,
             RenderingProviderTaxId,
             RenderingProviderNPI,
			 SupervisingProviderName,
			 SupervisingProviderNPI,
			 OrderingProviderName,
			 OrderingProviderNPI,
             DeletedBy,
             CreatedBy,
             ModifiedBy)
            select  a.ImportClaimId,
                    b.ServiceFileLineNumber,
                    b.ServiceFileLineNumberEnd,
                    b.ServiceLineNumber,
                    b.LineItemControlNumber,
                    isnull(b.ServiceFromdate, a.StatementStartDate),
                    b.RevenueCode,
                    b.HCPCSCode,
                    a.AuthorizationNumber1,
                    b.ChargeAmount,
                    b.RenderingProviderNumber,
                    b.RenderingProviderName,
                    b.RenderingProviderTaxId,
                    b.RenderingProviderNPI,
					b.SupervisingProviderName,
			        b.SupervisingProviderNPI,
			        b.OrderingProviderName,
			        b.OrderingProviderNPI,
                    convert(varchar, @ImportBatchNumber) + ';' + convert(varchar, b.ServiceFileLineNumber),
                    @UserCode,
                    @UserCode
            from    #ClaimSegmentLinks a
                    join #ServiceSegmentLinks b on (a.ClaimFileLineNumber = b.ClaimFileLineNumber)
	-- Below Code Written By Pralyankar On June 20, 2012 to Insert rows into Import837BatchClaimLines table based on batch number -----
                    join #PatientSegmentLinks c on (c.PatientFileLineNumber = a.PatientFileLineNumber)
                    join #SubscriberSegmentLinks d on (d.SubscriberFileLineNumber = c.SubscriberFileLineNumber)
                    join #ProviderSegmentLinks E on (E.ProviderFileLineNumber = d.ProviderFileLineNumber)
            where   E.BatchNumber = @BatchNumber
	--------------------------------------------------------------------------------

    if @@error <> 0 
      begin
        close cur_batch
        deallocate cur_batch
        goto rollback_tran
      end

    update  c
    set     ImportClaimLineId = b.Import837BatchClaimLineId
    from    Import837BatchClaims a
            join Import837BatchClaimLines b on (a.Import837BatchClaimId = b.Import837BatchClaimId)
            join #ServiceSegmentLinks c on (convert(varchar, @ImportBatchNumber) + ';' + convert(varchar, c.ServiceFileLineNumber) = b.DeletedBy)
    where   a.Import837BatchId = @ImportBatchNumber

    if @@error <> 0 
      begin
        close cur_batch
        deallocate cur_batch
        goto rollback_tran
      end

    update  b
    set     DeletedBy = null
    from    Import837BatchClaims a
            join Import837BatchClaimLines b on (a.Import837BatchClaimId = b.Import837BatchClaimId)
            join #ServiceSegmentLinks c on (convert(varchar, @ImportBatchNumber) + ';' + convert(varchar, c.ServiceFileLineNumber) = b.DeletedBy)
    where   a.Import837BatchId = @ImportBatchNumber

    if @@error <> 0 
      begin
        close cur_batch
        deallocate cur_batch
        goto rollback_tran
      end

    fetch_next:
    fetch cur_batch into @BatchNumber, @BatchStartId, @BatchEndId

    if @@error <> 0 
      begin
        close cur_batch
        deallocate cur_batch
        goto rollback_tran
      end

  end
/* End of While loop for batch numbers */
close cur_batch

if @@error <> 0 
  begin
    deallocate cur_batch
    goto rollback_tran
  end

deallocate cur_batch

if @@error <> 0 
  goto rollback_tran

update  f
set     FileDatetime = @FileDateTime,
        InterchangeSenderId = @InterchangeSenderId,
        InterchangeReceiverId = @InterchangeReceiverId,
        InterchangeControlNumber = @InterchangeControlNumber,
        AcknowledgementRequested = @AcknowledgementRequested,
        NumberOfBatches = b.NumberOfBatches,
        TotalClaims = b.TotalClaims,
        TotalClaimLines = b.TotalClaimLines,
        TotalCharges = b.TotalCharges,
        NumberOfSegments = b.NumberOfSegments
from    Import837Files f
        join (select  Import837FileId,
                      count(*) as NumberOfBatches,
                      sum(TotalClaims) as TotalClaims,
                      sum(TotalClaimLines) as TotalClaimLines,
                      sum(TotalCharges) as TotalCharges,
                      sum(NumberOfSegments) as NumberOfSegments
              from    Import837Batches
              where   isnull(RecordDeleted, 'N') = 'N'
              group by Import837FileId) b on b.Import837FileId = f.Import837FileId
where   f.Import837FileId = @Import837FileId

if @@error <> 0 
  goto rollback_tran

commit tran

if @@error <> 0 
  goto rollback_tran

process_claims:

begin tran

-- Delete previously entered claim line errors
-- Change this code to do phisical delete in a couple of months!!!!!!!!!!!!!!!!!
update  cle
set     RecordDeleted = 'Y',
        DeletedBy = @UserCode,
        DeletedDate = getdate()
from    Import837Batches b
        join Import837BatchClaims c on c.Import837BatchId = b.Import837BatchId
        join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
        join Import837BatchClaimLineErrors cle on cle.Import837BatchClaimLineId = cl.Import837BatchClaimLineId
where   b.Import837FileId = @Import837FileId

if @@error <> 0 
  goto rollback_tran

-- Determine claims to process
create table #ClaimsToProcess (
Import837BatchClaimId int not null,
ClaimFileLineNumber int not null,
ClaimType int null,
InsurerId int null)

insert  into #ClaimsToProcess
        (Import837BatchClaimId,
         ClaimFileLineNumber,
         ClaimType)
        select  c.Import837BatchClaimId,
                c.FileLineStart,
                case when (b.TransmissionTypeCode like '%x098%'
                           or b.TransmissionTypeCode like '%x222%') then 2221 -- Professional
                     when (b.TransmissionTypeCode like '%x096%'
                           or b.TransmissionTypeCode like '%x223%') then 2222 -- Institutional
                     else null
                end
        from    Import837Batches b
                join Import837BatchClaims c on c.Import837BatchId = b.Import837BatchId
        where   b.Import837FileId = @Import837FileId
                and isnull(b.RecordDeleted, 'N') = 'N'
                and isnull(c.RecordDeleted, 'N') = 'N'
                and exists ( select *
                             from   Import837BatchClaimLines cl
                             where  cl.Import837BatchClaimId = c.Import837BatchClaimId
                                    and isnull(cl.Processed, 'N') = 'N'
                                    and isnull(cl.RecordDeleted, 'N') = 'N' )

if @@error <> 0 
  goto rollback_tran

-- Clear previously mapped values
update  c
set     ClientId = null,
        SiteId = null
from    #ClaimsToProcess ctp
        join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId

if @@error <> 0 
  goto rollback_tran

update  cl
set     RenderingProviderId = null
from    #ClaimsToProcess ctp
        join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
        join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId

if @@error <> 0 
  goto rollback_tran

update  cl
set     SupervisingProviderId = null
from    #ClaimsToProcess ctp
        join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
        join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId

if @@error <> 0 
  goto rollback_tran

update  cl
set     OrderingProviderId = null
from    #ClaimsToProcess ctp
        join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
        join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId

if @@error <> 0 
  goto rollback_tran

create table #CustomImport837ClaimsMapping (
Import837BatchClaimId int not  null,
Import837BatchId int not  null,
InsurerId int null,
ClientId int null,
SiteId int null,
RenderingProviderId int null,
ProviderNumber varchar(30) null,
ProviderName varchar(60) null,
ProviderNPI varchar(80) null,
ProviderTaxId varchar(11) null,
ClientLastName varchar(30) null,
ClientFirstName varchar(30) null,
ClientInsuredId varchar(80) null,
ClientDOB datetime null,
SubscriberLastName varchar(30) null,
SubscriberFirstName varchar(30) null,
SubscriberInsuredId varchar(80) null,
SubscriberDOB datetime null,
PayerName varchar(100) null,
PayerId varchar(80) null,
PayerNPI varchar(80) null,
RenderingProviderNumber varchar(35) null,
RenderingProviderName varchar(60) null,
RenderingProviderTaxId varchar(12) null,
RenderingProviderNPI varchar(80) null,
AuthorizationNumber varchar(20) null,
SupervisingProviderId int null,
SupervisingProviderName varchar(100) null,
SupervisingProviderNPI varchar(80) null
)

create table #CustomImport837ClaimLinesMapping (
Import837BatchClaimLineId int not  null,
Import837BatchClaimId int not  null,
RenderingProviderId int null,
RenderingProviderNumber varchar(35) null,
RenderingProviderName varchar(60) null,
RenderingProviderTaxId varchar(12) null,
RenderingProviderNPI varchar(80) null,
SupervisingProviderId int null,
SupervisingProviderName varchar(100) null,
SupervisingProviderNPI varchar(80) null,
OrderingProviderId int null,
OrderingProviderName varchar(100) null,
OrderingProviderNPI varchar(80) null
)

-- Map sites
create table #ClaimSites (
SenderSiteId int identity
                 not null,
SiteId int not null,
ProviderId int not null,
Import837BatchClaimId int not null)

create nonclustered index XIE1_#ClaimSites on #ClaimSites (Import837BatchClaimId)      


-- Below code written By Pralyankar On June 19, 2012
/* NOTE: As Discussed with David on June 19th, 2012. David has asked to get SiteId based on AuthorizationNumber because in Kalamazoo 
	we can have multiple Providers with same nation Provider ID */

-- Get Claim Site based on Authorization Number -----
insert  into #ClaimSites
        (SiteId,
         ProviderId,
         Import837BatchClaimId)
        select distinct
                s.SiteId,
                s.ProviderId,
                c.Import837BatchClaimId
        from    #ClaimSegmentLinks csl
                join Import837BatchClaims c on c.FileLineStart = csl.ClaimFileLineNumber
                join Import837Batches b on b.Import837BatchId = c.Import837BatchId
                join Import837Senders se on se.SenderId = b.SubmitterId
                join ProviderAuthorizations PA on PA.AuthorizationNumber = csl.AuthorizationNumber1
                join Sites s on s.SiteId = PA.siteId
                join Providers p on p.ProviderId = PA.ProviderId
        where   p.Active = 'Y'
                and s.Active = 'Y'
                and csl.AuthorizationNumber1 like '%-[0-9]%' -- Authorization number must have a dash and at least one number after it to be considered
                and isnull(C.RecordDeleted, 'N') = 'N'
                and isnull(se.RecordDeleted, 'N') = 'N'
                and isnull(p.RecordDeleted, 'N') = 'N'
                and isnull(s.RecordDeleted, 'N') = 'N'
------------------------------------------------------------------------

insert  into #ClaimSites
        (SiteId,
         ProviderId,
         Import837BatchClaimId)
        select  s.SiteId,
                s.ProviderId,
                c.Import837BatchClaimId
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join Import837Batches b on b.Import837BatchId = c.Import837BatchId
                join Import837Senders se on se.SenderId = b.SubmitterId
                join Sites s on s.NationalProviderId = c.ProviderNPI
                join Providers p on p.ProviderId = s.ProviderId
        where   p.Active = 'Y'
                and s.Active = 'Y'
                and isnull(se.RecordDeleted, 'N') = 'N'
                and isnull(p.RecordDeleted, 'N') = 'N'
                and isnull(s.RecordDeleted, 'N') = 'N'
	---- Exclude the sites that found with Authorization Number ----------------------
                and c.Import837BatchClaimId not in (select  Import837BatchClaimId
                                                    from    #ClaimSites)
	----------------------------------------------------------------------------------
	
if @@error <> 0 
  goto rollback_tran

insert  into #ClaimSites
        (SiteId,
         ProviderId,
         Import837BatchClaimId)
        select  s.SiteId,
                s.ProviderId,
                c.Import837BatchClaimId
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join Import837Batches b on b.Import837BatchId = c.Import837BatchId
                join Import837Senders se on se.SenderId = b.SubmitterId
                join Sites s on s.SiteId = convert(int,c.ProviderNumber)
                                and s.TaxID = replace(c.ProviderTaxId, '-', '')
                join Providers p on p.ProviderId = s.ProviderId
        where   p.Active = 'Y'
                and s.Active = 'Y'
                and c.ProviderNPI is null
                and isnumeric(c.ProviderNumber) = 1
				AND c.ProviderNumber NOT LIKE '%$%'  -- 11.28.2016
				AND c.ProviderNumber NOT LIKE '%.%'  -- 11.28.2016
                and isnull(se.RecordDeleted, 'N') = 'N'
                and isnull(p.RecordDeleted, 'N') = 'N'
                and isnull(s.RecordDeleted, 'N') = 'N'
	---- Exclude the sites that found with Authorization Number or Provider NPI ------
                and c.Import837BatchClaimId not in (select  Import837BatchClaimId
                                                    from    #ClaimSites)
	----------------------------------------------------------------------------------

if @@error <> 0 
  goto rollback_tran

update  c
set     SiteId = s.SiteId
from    Import837BatchClaims c
        join #ClaimSites s on s.Import837BatchClaimId = c.Import837BatchClaimId
        join (select  Import837BatchClaimId
              from    #ClaimSites
              group by Import837BatchClaimId
              having  count(*) = 1) as sc on sc.Import837BatchClaimId = s.Import837BatchClaimId

if @@error <> 0 
  goto rollback_tran

-- Map clients
update  c
set     ClientId = cl.ClientId
from    #ClaimsToProcess ctp
        join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
        join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = c.FileLineStart
        join #PatientSegmentLinks ps on ps.PatientFileLineNumber = cs.PatientFileLineNumber
        join Clients cl on cl.ClientId = ps.PatientInsuredId
                           and cl.DOB = ps.PatientDOB
where   isnumeric(ps.PatientInsuredId) = 1
		AND ps.PatientInsuredId NOT LIKE '%$%'  -- 11.28.2016
		AND ps.PatientInsuredId NOT LIKE '%.%'  -- 11.28.2016
		AND cl.ClientType = 'I' 
        AND isnull(cl.RecordDeleted, 'N') = 'N'

if @@error <> 0 
  goto rollback_tran

update  c
set     ClientId = cl.ClientId
from    #ClaimsToProcess ctp
        join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
        join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = c.FileLineStart
        join #PatientSegmentLinks ps on ps.PatientFileLineNumber = cs.PatientFileLineNumber
        join Clients cl on cl.ClientId = ps.PatientInsuredId
                           and cl.LastName = ps.PatientLastName
                           and cl.FirstName = ps.PatientFirstName
where   c.ClientId is null
        AND isnumeric(ps.PatientInsuredId) = 1
		AND ps.PatientInsuredId NOT LIKE '%$%'	-- 11.28.2016
		AND ps.PatientInsuredId NOT LIKE '%.%'  -- 11.28.2016
		AND cl.ClientType = 'I' 
        AND isnull(cl.RecordDeleted, 'N') = 'N'

if @@error <> 0 
  goto rollback_tran

--For ClientType - 'O'
update  c
set     ClientId = cl.ClientId
from    #ClaimsToProcess ctp
        join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
        join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = c.FileLineStart
        join #PatientSegmentLinks ps on ps.PatientFileLineNumber = cs.PatientFileLineNumber
        join Clients cl on cl.ClientId = ps.PatientInsuredId
						   AND replace(cl.organizationname, ' ', '') = replace(isnull(ps.PatientFirstName, '') + isnull(ps.PatientLastName, ''), ' ', '')
where   isnumeric(ps.PatientInsuredId) = 1
		AND ps.PatientInsuredId NOT LIKE '%$%'	-- 11.28.2016
		AND ps.PatientInsuredId NOT LIKE '%.%'  -- 11.28.2016
		AND cl.ClientType = 'O'
        AND isnull(cl.RecordDeleted, 'N') = 'N'

if @@error <> 0 
  goto rollback_tran

--Switching First and Last Names
update  c
set     ClientId = cl.ClientId
from    #ClaimsToProcess ctp
        join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
        join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = c.FileLineStart
        join #PatientSegmentLinks ps on ps.PatientFileLineNumber = cs.PatientFileLineNumber
        join Clients cl on cl.ClientId = ps.PatientInsuredId
						   AND replace(cl.organizationname, ' ', '') = replace(isnull(ps.PatientLastName, '') + isnull(ps.PatientFirstName, ''), ' ', '')
where   isnumeric(ps.PatientInsuredId) = 1
		AND ps.PatientInsuredId NOT LIKE '%$%'	-- 11.28.2016
		AND ps.PatientInsuredId NOT LIKE '%.%'  -- 11.28.2016
		AND cl.ClientType = 'O'
        AND isnull(cl.RecordDeleted, 'N') = 'N'

if @@error <> 0 
  goto rollback_tran
  
-- Map insurers

select  @Import837IdentifyInsurerByClientCoveragePlan = sck.Value
from    SystemConfigurationKeys sck
where   sck.[Key] = 'Import837IdentifyInsurerByClientCoveragePlan'
        and sck.Value in ('Y', 'N')

if @Import837IdentifyInsurerByClientCoveragePlan is null 
  set @Import837IdentifyInsurerByClientCoveragePlan = 'N';

if @Import837IdentifyInsurerByClientCoveragePlan = 'Y' 
  begin
    ;with  CTE_ClientCoveragePlans
            as (select  ctp.Import837BatchClaimId,
                        ccp.CoveragePlanId,
                        cch.ServiceAreaId,
                        row_number() over (partition by ctp.Import837BatchClaimId order by cch.COBOrder) as COBOrder
                from    #ClaimsToProcess ctp
                        join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
		                join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = c.FileLineStart
                        join #ServiceSegmentLinks ss on ss.ClaimFileLineNumber = cs.ClaimFileLineNumber
                        join ClientCoveragePlans ccp on ccp.ClientId = c.ClientId
                        join ClientCoverageHistory cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                        join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
                where   isnull(cp.ThirdPartyPlan, 'N') = 'N'
                        and ((cch.StartDate <= isnull(ss.ServiceFromDate, cs.StatementStartDate)
                              and (cch.EndDate is null
                                   or dateadd(day, 1, cch.EndDate) > isnull(ss.ServiceFromDate, cs.StatementStartDate)))
                             or (cch.StartDate <= isnull(ss.ServiceToDate, cs.StatementEndDate)
                                 and (cch.EndDate is null
                                      or dateadd(day, 1, cch.EndDate) > isnull(ss.ServiceToDate, cs.StatementEndDate))))
                        and isnull(ccp.RecordDeleted, 'N') = 'N'
                        and isnull(cch.RecordDeleted, 'N') = 'N'),
          CTE_Insurers
            as (select  ccp.Import837BatchClaimId,
                        max(i.InsurerId) as InsurerId
                from    CTE_ClientCoveragePlans ccp 
                        join Insurers i on i.ServiceAreaId = ccp.ServiceAreaId
                where   ccp.COBOrder = 1
                        and (i.ValidAllCoveragePlans = 'Y'
                             or exists ( select *
                                         from   InsurerValidCoveragePlans ivcp
                                         where  ivcp.InsurerId = i.InsurerId
                                                and ivcp.CoveragePlanId = ccp.CoveragePlanId
                                                and isnull(ivcp.RecordDeleted, 'N') = 'N' ))
                        and isnull(i.RecordDeleted, 'N') = 'N'
                group by ccp.Import837BatchClaimId
                having  count(distinct i.InsurerId) = 1)
      update  ctp
      set     InsurerId = i.InsurerId
      from    #ClaimsToProcess ctp
              join CTE_Insurers i on i.Import837BatchClaimId = ctp.Import837BatchClaimId
   
    if @@error <> 0 
      goto rollback_tran

  end
else 
  begin
    update  ctp
    set     InsurerId = i.InsurerId
    from    #ClaimsToProcess ctp
            join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = ctp.ClaimFileLineNumber
            join #PatientSegmentLinks ps on ps.PatientFileLineNumber = cs.PatientFileLineNumber
            join #SubscriberSegmentLinks ss on ss.SubscriberFileLineNumber = ps.SubscriberFileLineNumber
            join Insurers i on i.NationalProviderId = ss.PayerNPI

    if @@error <> 0 
      goto rollback_tran

  end 

-- Map rendering providers
update  cs
set     RenderingProviderId = s.ProviderId
from    #ClaimsToProcess ctp
        join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
        join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = ctp.ClaimFileLineNumber
        join Sites s on s.NationalProviderId = cs.RenderingProviderNPI
		join Providers p on p.ProviderId = s.ProviderId
where   cs.RenderingProviderName is not null
        and s.Active = 'Y'
		and p.Active = 'Y'
        and isnull(s.RecordDeleted, 'N') = 'N'
		and isnull(p.RecordDeleted, 'N') = 'N'

if @@error <> 0 
  goto rollback_tran

update  cs
set     RenderingProviderId = s.ProviderId
from    #ClaimsToProcess ctp
        join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
        join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = ctp.ClaimFileLineNumber
        join Sites s on s.TaxID = cs.RenderingProviderTaxId
		join Providers p on p.ProviderId = s.ProviderId
where   cs.RenderingProviderName is not null
        and cs.RenderingProviderId is null
        and s.Active = 'Y'
		and p.Active = 'Y'
        and isnull(s.RecordDeleted, 'N') = 'N'
		and isnull(p.RecordDeleted, 'N') = 'N'

if @@error <> 0 
  goto rollback_tran

update  cl
set     RenderingProviderId = s.ProviderId
from    #ClaimsToProcess ctp
        join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
        join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
        join Sites s on s.NationalProviderId = cl.RenderingProviderNPI
		join Providers p on p.ProviderId = s.ProviderId
where   cl.RenderingProviderName is not null
        and s.Active = 'Y'
		and p.Active = 'Y'
        and isnull(s.RecordDeleted, 'N') = 'N'
		and isnull(p.RecordDeleted, 'N') = 'N'

if @@error <> 0 
  goto rollback_tran

update  cl
set     RenderingProviderId = s.ProviderId
from    #ClaimsToProcess ctp
        join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
        join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
        join Sites s on s.TaxId = cl.RenderingProviderTaxId
		join Providers p on p.ProviderId = s.ProviderId
where   cl.RenderingProviderName is not null
        and cl.RenderingProviderId is null
        and s.Active = 'Y'
		and p.Active = 'Y'
        and isnull(s.RecordDeleted, 'N') = 'N'
		and isnull(p.RecordDeleted, 'N') = 'N'

if @@error <> 0 
  goto rollback_tran


-- Map Supervising provider
update  cs
set     SupervisingProviderId = s.ProviderId
from    #ClaimsToProcess ctp
        join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
        join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = ctp.ClaimFileLineNumber
        join Sites s on s.NationalProviderId = cs.SupervisingProviderNPI
		join Providers p on p.ProviderId = s.ProviderId
where   cs.SupervisingProviderName is not null
        and s.Active = 'Y'
		and p.Active = 'Y'
        and isnull(s.RecordDeleted, 'N') = 'N'
		and isnull(p.RecordDeleted, 'N') = 'N'

if @@error <> 0 
  goto rollback_tran

update  cl
set     SupervisingProviderId = s.ProviderId
from    #ClaimsToProcess ctp
        join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
        join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
        join Sites s on s.NationalProviderId = cl.SupervisingProviderNPI
		join Providers p on p.ProviderId = s.ProviderId
where   cl.SupervisingProviderName is not null
        and s.Active = 'Y'
		and p.Active = 'Y'
        and isnull(s.RecordDeleted, 'N') = 'N'
		and isnull(p.RecordDeleted, 'N') = 'N'

if @@error <> 0 
  goto rollback_tran

-- Map Ordering provider 
update  cl
set     OrderingProviderId = s.ProviderId
from    #ClaimsToProcess ctp
        join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
        join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
        join Sites s on s.NationalProviderId = cl.OrderingProviderNPI
		join Providers p on p.ProviderId = s.ProviderId
where   cl.OrderingProviderName is not null
        and s.Active = 'Y'
		and p.Active = 'Y'
        and isnull(s.RecordDeleted, 'N') = 'N'
		and isnull(p.RecordDeleted, 'N') = 'N'

if @@error <> 0 
  goto rollback_tran


-- Custom mapping

insert  into #CustomImport837ClaimsMapping
        (Import837BatchClaimId,
         Import837BatchId,
         InsurerId,
         ClientId,
         SiteId,
         RenderingProviderId,
         ProviderNumber,
         ProviderName,
         ProviderNPI,
         ProviderTaxId,
         ClientLastName,
         ClientFirstName,
         ClientInsuredId,
         ClientDOB,
         SubscriberLastName,
         SubscriberFirstName,
         SubscriberInsuredId,
         SubscriberDOB,
         PayerName,
         PayerId,
         PayerNPI,
         RenderingProviderNumber,
         RenderingProviderName,
         RenderingProviderTaxId,
         RenderingProviderNPI,
		 AuthorizationNumber,
		 SupervisingProviderId,
         SupervisingProviderName,
         SupervisingProviderNPI)
        select  c.Import837BatchClaimId,
                c.Import837BatchId,
                ctp.InsurerId,
                c.ClientId,
                c.SiteId,
                cs.RenderingProviderId,
                c.ProviderNumber,
                c.ProviderName,
                c.ProviderNPI,
                c.ProviderTaxId,
                ps.PatientLastName,
                ps.PatientFirstName,
                ps.PatientInsuredId,
                ps.PatientDOB,
                ss.SubscriberLastName,
                ss.SubscriberFirstName,
                ss.SubscriberInsuredId,
                ss.SubscriberDOB,
                ss.PayerName,
                ss.PayerId,
                ss.PayerNPI,
                cs.RenderingProviderNumber,
                cs.RenderingProviderName,
                cs.RenderingProviderTaxId,
                cs.RenderingProviderNPI,
				cs.AuthorizationNumber1,
				cs.SupervisingProviderId,
                cs.SupervisingProviderName,
                cs.SupervisingProviderNPI
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = ctp.ClaimFileLineNumber
                join #PatientSegmentLinks ps on ps.PatientFileLineNumber = cs.PatientFileLineNumber
                join #SubscriberSegmentLinks ss on ss.SubscriberFileLineNumber = ps.SubscriberFileLineNumber

if @@error <> 0 
  goto rollback_tran

insert  into #CustomImport837ClaimLinesMapping
        (Import837BatchClaimLineId,
         Import837BatchClaimId,
         RenderingProviderId,
         RenderingProviderNumber,
         RenderingProviderName,
         RenderingProviderTaxId,
         RenderingProviderNPI,
		 SupervisingProviderId,
         SupervisingProviderName,
         SupervisingProviderNPI,
		 OrderingProviderId,
         OrderingProviderName,
         OrderingProviderNPI)
        select  cl.Import837BatchClaimLineId,
                cl.Import837BatchClaimId,
                cl.RenderingProviderId,
                cl.RenderingProviderNumber,
                cl.RenderingProviderName,
                cl.RenderingProviderTaxId,
                cl.RenderingProviderNPI,
                cl.SupervisingProviderId,
                cl.SupervisingProviderName,
                cl.SupervisingProviderNPI,
                cl.OrderingProviderId,
                cl.OrderingProviderName,
                cl.OrderingProviderNPI
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId

if @@error <> 0 
  goto rollback_tran

-- Custom logic
exec scsp_PAProcess837FileImport

if @@error <> 0 
  goto rollback_tran

update  c
set     ClientId = cm.ClientId,
        SiteId = cm.SiteId
from    #ClaimsToProcess ctp
        join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
        join #CustomImport837ClaimsMapping cm on cm.Import837BatchClaimId = c.Import837BatchClaimId

if @@error <> 0 
  goto rollback_tran

update  ctp
set     InsurerId = cm.InsurerId
from    #ClaimsToProcess ctp
        join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
        join #CustomImport837ClaimsMapping cm on cm.Import837BatchClaimId = c.Import837BatchClaimId

if @@error <> 0 
  goto rollback_tran

update  cs
set     RenderingProviderId = cm.RenderingProviderId
from    #ClaimsToProcess ctp
        join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
        join #CustomImport837ClaimsMapping cm on cm.Import837BatchClaimId = c.Import837BatchClaimId
        join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = ctp.ClaimFileLineNumber

if @@error <> 0 
  goto rollback_tran

update  cs
set     SupervisingProviderId = cm.SupervisingProviderId
from    #ClaimsToProcess ctp
        join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
        join #CustomImport837ClaimsMapping cm on cm.Import837BatchClaimId = c.Import837BatchClaimId
        join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = ctp.ClaimFileLineNumber

if @@error <> 0 
  goto rollback_tran

update  cl
set     RenderingProviderId = clm.RenderingProviderId
from    #ClaimsToProcess ctp
        join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
        join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
        join #CustomImport837ClaimLinesMapping clm on clm.Import837BatchClaimLineId = cl.Import837BatchClaimLineId

if @@error <> 0 
  goto rollback_tran

update  cl
set     SupervisingProviderId = clm.SupervisingProviderId
from    #ClaimsToProcess ctp
        join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
        join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
        join #CustomImport837ClaimLinesMapping clm on clm.Import837BatchClaimLineId = cl.Import837BatchClaimLineId

if @@error <> 0 
  goto rollback_tran

update  cl
set     OrderingProviderId = clm.OrderingProviderId
from    #ClaimsToProcess ctp
        join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
        join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
        join #CustomImport837ClaimLinesMapping clm on clm.Import837BatchClaimLineId = cl.Import837BatchClaimLineId

if @@error <> 0 
  goto rollback_tran


--
-- Create rendering, supervising and ordering providers and associate them with the billing providers
--
declare @Import837CreateAssociatedProvider char(1)

select  @Import837CreateAssociatedProvider = sck.Value
from    SystemConfigurationKeys sck
where   sck.[Key] = 'Import837CreateAssociatedProvider'
        and sck.Value in ('Y', 'N')

if @Import837CreateAssociatedProvider is null
  set @Import837CreateAssociatedProvider = 'N';

if @Import837CreateAssociatedProvider = 'Y'
  begin

    create table #NewProviders (ProviderId int,
                                NationalProviderId varchar(20))

    if @@error <> 0
      goto rollback_tran

    create table #NewSites (SiteId int,
                            ProviderId int)

    if @@error <> 0
      goto rollback_tran

    insert  into Providers
            (CreatedBy,
             CreatedDate,
             ModifiedBy,
             ModifiedDate,
             ProviderType,
             Active,
             ProviderName,
             FirstName,
             ExternalId,
             DataEntryComplete,
             NPIAppliesToAllSites,
			 POSAppliesToAllSites,
			 TaxonomyAppliesToAllSites,
			 NonNetwork,
			 ProviderIdAppliesToAllSites)
    output  inserted.ProviderId,
            Inserted.ExternalId
            into #NewProviders (ProviderId, NationalProviderId)
    select  @UserCode,
            getdate(),
            @UserCode,
            getdate(),
            'I',
            'Y',
            p.ProviderName,
            p.FirstName,
            p.ProviderNPI,
            'Y',
            'N',
            'N',
            'N',
            'N',
			'N'
    from    (select cs.RenderingProviderLastName as ProviderName,
                    cs.RenderingProviderFirstName as FirstName,
                    cs.RenderingProviderNPI as ProviderNPI
             from   #ClaimsToProcess ctp
                    join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                    join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                    join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = ctp.ClaimFileLineNumber
             where  cs.RenderingProviderName is not null
                    and cs.RenderingProviderNPI is not null
                    and cs.RenderingProviderId is null
                    and c.SiteId is not null
             union
             select cs.SupervisingProviderLastName,
                    cs.SupervisingProviderFirstName,
                    cs.SupervisingProviderNPI
             from   #ClaimsToProcess ctp
                    join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                    join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                    join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = ctp.ClaimFileLineNumber
             where  cs.SupervisingProviderName is not null
                    and cs.SupervisingProviderNPI is not null
                    and cs.SupervisingProviderId is null
                    and c.SiteId is not null
             union
             select sl.RenderingProviderLastName,
                    sl.RenderingProviderFirstName,
                    sl.RenderingProviderNPI
             from   #ClaimsToProcess ctp
                    join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                    join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                    join #ServiceSegmentLinks sl on sl.ServiceFileLineNumber = cl.FileLineStart
             where  cl.RenderingProviderName is not null
                    and cl.RenderingProviderNPI is not null
                    and cl.RenderingProviderId is null
                    and c.SiteId is not null
             union
             select sl.SupervisingProviderLastName,
                    sl.SupervisingProviderFirstName,
                    sl.SupervisingProviderNPI
             from   #ClaimsToProcess ctp
                    join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                    join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                    join #ServiceSegmentLinks sl on sl.ServiceFileLineNumber = cl.FileLineStart
             where  cl.SupervisingProviderName is not null
                    and cl.SupervisingProviderNPI is not null
                    and cl.SupervisingProviderId is null
                    and c.SiteId is not null
             union
             select sl.OrderingProviderLastName,
                    sl.OrderingProviderFirstName,
                    sl.OrderingProviderNPI
             from   #ClaimsToProcess ctp
                    join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                    join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                    join #ServiceSegmentLinks sl on sl.ServiceFileLineNumber = cl.FileLineStart
             where  cl.OrderingProviderName is not null
                    and cl.OrderingProviderNPI is not null
                    and cl.OrderingProviderId is null
                    and c.SiteId is not null) as p

    if @@error <> 0
      goto rollback_tran

    insert  into Sites
            (CreatedBy,
             CreatedDate,
             ModifiedBy,
             ModifiedDate,
             ProviderId,
             SiteName,
             Active,
             SiteType,
             TaxIDType,
             TaxID,
             NationalProviderId,
             PayableName,
             HandicapAccess,
             EveningHours,
             WeekendHours,
             Adults,
             DDPopulation,
             MIPopulation,
             Children,
             SUDPopulation)
    output  Inserted.SiteId,
            Inserted.ProviderId
            into #NewSites (SiteId, ProviderId)
    select  @UserCode,
            getdate(),
            @UserCode,
            getdate(),
            p.ProviderId,
            p.ProviderName,
            'Y',
            2241, -- Clinic
            'E',
            '999999999',
            np.NationalProviderId,
            p.ProviderName,
            'N',
            'N',
            'N',
            'N',
            'N',
            'N',
            'N',
            'N'
    from    #NewProviders np
            join Providers p on p.ProviderId = np.ProviderId

    if @@error <> 0
      goto rollback_tran

    update  p
    set     PrimarySiteId = ns.SiteId,
            p.ExternalId = null
    from    #NewProviders np
            join #NewSites ns on ns.ProviderId = np.ProviderId
            join Providers p on p.ProviderId = np.ProviderId

    if @@error <> 0
      goto rollback_tran

    update  cs
    set     RenderingProviderId = np.ProviderId
    from    #ClaimsToProcess ctp
            join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
            join #CustomImport837ClaimsMapping cm on cm.Import837BatchClaimId = c.Import837BatchClaimId
            join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = ctp.ClaimFileLineNumber
            join #NewProviders np on np.NationalProviderId = cs.RenderingProviderNPI
    where   cs.RenderingProviderId is null

    if @@error <> 0
      goto rollback_tran

    update  cs
    set     SupervisingProviderId = np.ProviderId
    from    #ClaimsToProcess ctp
            join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
            join #CustomImport837ClaimsMapping cm on cm.Import837BatchClaimId = c.Import837BatchClaimId
            join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = ctp.ClaimFileLineNumber
            join #NewProviders np on np.NationalProviderId = cs.SupervisingProviderNPI
    where   cs.SupervisingProviderId is null

    if @@error <> 0
      goto rollback_tran

    update  cl
    set     RenderingProviderId = np.ProviderId
    from    #ClaimsToProcess ctp
            join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
            join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
            join #NewProviders np on np.NationalProviderId = cl.RenderingProviderNPI
    where   cl.RenderingProviderId is null

    if @@error <> 0
      goto rollback_tran

    update  cl
    set     SupervisingProviderId = np.ProviderId
    from    #ClaimsToProcess ctp
            join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
            join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
            join #NewProviders np on np.NationalProviderId = cl.SupervisingProviderNPI
    where   cl.SupervisingProviderId is null

    if @@error <> 0
      goto rollback_tran

    update  cl
    set     OrderingProviderId = np.ProviderId
    from    #ClaimsToProcess ctp
            join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
            join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
            join #NewProviders np on np.NationalProviderId = cl.OrderingProviderNPI
    where   cl.OrderingProviderId is null

    if @@error <> 0
      goto rollback_tran


    insert  into dbo.ProviderAffiliates
            (CreatedBy,
             CreatedDate,
             ModifiedBy,
             ModifiedDate,
             ProviderId,
             AffiliateProviderId)
    select  @UserCode,
            getdate(),
            @UserCode,
            getdate(),
            p.ProviderId,
            p.AffiliateProviderId
    from    (select s.ProviderId as ProviderId,
                    cs.RenderingProviderId as AffiliateProviderId
             from   #ClaimsToProcess ctp
                    join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                    join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                    join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = ctp.ClaimFileLineNumber
                    join Sites s on s.SiteId = c.SiteId
             where  cs.RenderingProviderId is not null
                    and cs.RenderingProviderId <> s.ProviderId
             union
             select s.ProviderId,
                    cs.SupervisingProviderId
             from   #ClaimsToProcess ctp
                    join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                    join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                    join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = ctp.ClaimFileLineNumber
                    join Sites s on s.SiteId = c.SiteId
             where  cs.SupervisingProviderId is not null
                    and cs.SupervisingProviderId <> s.ProviderId
             union
             select s.ProviderId,
                    cl.RenderingProviderId
             from   #ClaimsToProcess ctp
                    join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                    join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                    join Sites s on s.SiteId = c.SiteId
             where  cl.RenderingProviderId is not null
                    and cl.RenderingProviderId <> s.ProviderId
             union
             select s.ProviderId,
                    cl.SupervisingProviderId
             from   #ClaimsToProcess ctp
                    join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                    join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                    join Sites s on s.SiteId = c.SiteId
             where  cl.SupervisingProviderId is not null
                    and cl.SupervisingProviderId <> s.ProviderId
             union
             select s.ProviderId,
                    cl.OrderingProviderId
             from   #ClaimsToProcess ctp
                    join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                    join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                    join Sites s on s.SiteId = c.SiteId
             where  cl.OrderingProviderId is not null
                    and cl.OrderingProviderId <> s.ProviderId) as p
    where   not exists ( select *
                         from   dbo.ProviderAffiliates pa
                         where  pa.ProviderId = p.ProviderId
                                and pa.AffiliateProviderId = p.AffiliateProviderId
                                and isnull(pa.RecordDeleted, 'N') = 'N' )

  end



--
-- Check for errors
--

insert  into Import837BatchClaimLineErrors
        (Import837BatchClaimLineId,
         ErrorCode,
         ErrorText,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  cl.Import837BatchClaimLineId,
                'C101',
                'Unknown claim type',
                @UserCode,
                getdate(),
                @UserCode,
                getdate()
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
        where   ctp.ClaimType is null

if @@error <> 0 
  goto rollback_tran

insert  into Import837BatchClaimLineErrors
        (Import837BatchClaimLineId,
         ErrorCode,
         ErrorText,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  cl.Import837BatchClaimLineId,
                'C102',
                'Provider/site not found for submitted NPI',
                @UserCode,
                getdate(),
                @UserCode,
                getdate()
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
        where   c.SiteId is null
                and c.ProviderNPI is not null
                and not exists ( select *
                                 from   #ClaimSites cs
                                 where  cs.Import837BatchClaimId = c.Import837BatchClaimId )

if @@error <> 0 
  goto rollback_tran

insert  into Import837BatchClaimLineErrors
        (Import837BatchClaimLineId,
         ErrorCode,
         ErrorText,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate) 
        select  cl.Import837BatchClaimLineId,
                'C112',
                'More than one provider/site found for submitted NPI or No Authorization found',
                @UserCode,
                getdate(),
                @UserCode,
                getdate()
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
        where   c.SiteId is null
                and c.ProviderNPI is not null
                and exists ( select *
                             from   #ClaimSites cs
                             where  cs.Import837BatchClaimId = c.Import837BatchClaimId )

if @@error <> 0 
  goto rollback_tran

insert  into Import837BatchClaimLineErrors
        (Import837BatchClaimLineId,
         ErrorCode,
         ErrorText,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  cl.Import837BatchClaimLineId,
                'C113',
                'Provider/site not found',
                @UserCode,
                getdate(),
                @UserCode,
                getdate()
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
        where   c.SiteId is null
                and c.ProviderNPI is null

if @@error <> 0 
  goto rollback_tran


insert  into Import837BatchClaimLineErrors
        (Import837BatchClaimLineId,
         ErrorCode,
         ErrorText,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  cl.Import837BatchClaimLineId,
                'C103',
                'Provider/site not found in Import837SenderProviders',
                @UserCode,
                getdate(),
                @UserCode,
                getdate()
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                join Import837Batches b on b.Import837BatchId = c.Import837BatchId
        where   c.SiteId is not null
                and not exists ( select *
                                 from   Import837Senders se
                                        join Import837SenderProviders sp on sp.Import837SenderId = se.Import837SenderId
                                 where  se.SenderId = b.SubmitterId
                                        and sp.SiteId = c.SiteId
                                        and sp.Active = 'Y'
                                        and isnull(sp.RecordDeleted, 'N') = 'N' )

if @@error <> 0 
  goto rollback_tran

insert  into Import837BatchClaimLineErrors
        (Import837BatchClaimLineId,
         ErrorCode,
         ErrorText,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  cl.Import837BatchClaimLineId,
                'C104',
                'Client not found',
                @UserCode,
                getdate(),
                @UserCode,
                getdate()
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
        where   c.ClientId is null

if @@error <> 0 
  goto rollback_tran

insert  into Import837BatchClaimLineErrors
        (Import837BatchClaimLineId,
         ErrorCode,
         ErrorText,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  cl.Import837BatchClaimLineId,
                'C105',
                'Client is not active',
                @UserCode,
                getdate(),
                @UserCode,
                getdate()
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                join Clients p on p.ClientId = c.ClientId
        where   c.ClientId is not null
                and isnull(p.Active, 'N') = 'N'

if @@error <> 0 
  goto rollback_tran

insert  into Import837BatchClaimLineErrors
        (Import837BatchClaimLineId,
         ErrorCode,
         ErrorText,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  cl.Import837BatchClaimLineId,
                'C106',
                'Client is not authorized for this provider',
                @UserCode,
                getdate(),
                @UserCode,
                getdate()
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                join Clients p on p.ClientId = c.ClientId
                join Sites s on s.SiteId = c.SiteId
        where   c.ClientId is not null
                and p.Active = 'Y'
                and not exists ( select *
                                 from   ProviderClients pc
                                 where  pc.ProviderId = s.ProviderId
                                        and pc.ClientId = c.ClientId
                                        and pc.Active = 'Y'
                                        and isnull(pc.RecordDeleted, 'N') = 'N' )

if @@error <> 0 
  goto rollback_tran

insert  into Import837BatchClaimLineErrors
        (Import837BatchClaimLineId,
         ErrorCode,
         ErrorText,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  cl.Import837BatchClaimLineId,
                'C107',
                'Insurer not found',
                @UserCode,
                getdate(),
                @UserCode,
                getdate()
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
        where   ctp.InsurerId is null

if @@error <> 0 
  goto rollback_tran

insert  into Import837BatchClaimLineErrors
        (Import837BatchClaimLineId,
         ErrorCode,
         ErrorText,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  cl.Import837BatchClaimLineId,
                'C108',
                'Claim rendering provider not found',
                @UserCode,
                getdate(),
                @UserCode,
                getdate()
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = ctp.ClaimFileLineNumber
        where   cs.RenderingProviderName is not null
                and cs.RenderingProviderId is null

if @@error <> 0 
  goto rollback_tran

insert  into Import837BatchClaimLineErrors
        (Import837BatchClaimLineId,
         ErrorCode,
         ErrorText,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  cl.Import837BatchClaimLineId,
                'C109',
                'Claim rendering provider not associated with billing provider',
                @UserCode,
                getdate(),
                @UserCode,
                getdate()
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = ctp.ClaimFileLineNumber
                join Sites s on s.SiteId = c.SiteId
        where   cs.RenderingProviderName is not null
                and cs.RenderingProviderId is not null
                and cs.RenderingProviderId <> s.ProviderId              
                and not exists ( select *
                                 from   ProviderAffiliates pa
                                 where  pa.AffiliateProviderid = cs.RenderingProviderId
                                        and pa.ProviderId = s.ProviderId
                                        and isnull(pa.RecordDeleted, 'N') = 'N' )


if @@error <> 0 
  goto rollback_tran

insert  into Import837BatchClaimLineErrors
        (Import837BatchClaimLineId,
         ErrorCode,
         ErrorText,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  cl.Import837BatchClaimLineId,
                'C110',
                'Claim place of service not specified',
                @UserCode,
                getdate(),
                @UserCode,
                getdate()
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = ctp.ClaimFileLineNumber
        where   ctp.ClaimType = 2221
                and cs.PlaceOfServiceCode is null

if @@error <> 0 
  goto rollback_tran

insert  into Import837BatchClaimLineErrors
        (Import837BatchClaimLineId,
         ErrorCode,
         ErrorText,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  cl.Import837BatchClaimLineId,
                'C111',
                'Claim place of service not found',
                @UserCode,
                getdate(),
                @UserCode,
                getdate()
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = ctp.ClaimFileLineNumber
        where   ctp.ClaimType = 2221
                and cs.PlaceOfServiceCode is not null
                and not exists ( select *
                                 from   GlobalCodes gcpsc
                                 where  gcpsc.Category = 'PCMPLACEOFSERVICE'
                                        and gcpsc.ExternalCode1 = cs.PlaceOfServiceCode
                                        and gcpsc.Active = 'Y'
                                        and isnull(gcpsc.RecordDeleted, 'N') = 'N' )

if @@error <> 0 
  goto rollback_tran

insert  into Import837BatchClaimLineErrors
        (Import837BatchClaimLineId,
         ErrorCode,
         ErrorText,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  cl.Import837BatchClaimLineId,
                'C114',
                'Principal diagnosis is invalid',
                @UserCode,
                getdate(),
                @UserCode,
                getdate()
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = ctp.ClaimFileLineNumber
        where   cs.PrincipalDiagnosis is not null
                and ((cs.DiagnosisType = 'ICD9'
                      and not exists ( select *
                                       from   DiagnosisDSMDescriptions dd
                                       where  dd.DSMCode = cs.PrincipalDiagnosis ))
                     or (cs.DiagnosisType = 'ICD10'
                         and not exists ( select  *
                                          from    DiagnosisICD10Codes dd
                                          where   dd.ICD10Code = cs.PrincipalDiagnosis )))
   

if @@error <> 0 
  goto rollback_tran

insert  into Import837BatchClaimLineErrors
        (Import837BatchClaimLineId,
         ErrorCode,
         ErrorText,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  cl.Import837BatchClaimLineId,
                'C115',
                'Other diagnosis 1 is invalid',
                @UserCode,
                getdate(),
                @UserCode,
                getdate()
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = ctp.ClaimFileLineNumber
        where   ctp.ClaimType = 2221
                and cs.OtherDiagnosis1 is not null
                and ((cs.DiagnosisType = 'ICD9'
                      and not exists ( select *
                                       from   DiagnosisDSMDescriptions dd
                                       where  dd.DSMCode = cs.OtherDiagnosis1 ))
                     or (cs.DiagnosisType = 'ICD10'
                         and not exists ( select  *
                                          from    DiagnosisICD10Codes dd
                                          where   dd.ICD10Code = cs.OtherDiagnosis1 )))
 
if @@error <> 0 
  goto rollback_tran

insert  into Import837BatchClaimLineErrors
        (Import837BatchClaimLineId,
         ErrorCode,
         ErrorText,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  cl.Import837BatchClaimLineId,
                'C116',
                'Other diagnosis 2 is invalid',
                @UserCode,
                getdate(),
                @UserCode,
                getdate()
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = ctp.ClaimFileLineNumber
        where   ctp.ClaimType = 2221
                and cs.OtherDiagnosis2 is not null
                and ((cs.DiagnosisType = 'ICD9'
                      and not exists ( select *
                                       from   DiagnosisDSMDescriptions dd
                                       where  dd.DSMCode = cs.OtherDiagnosis2 ))
                     or (cs.DiagnosisType = 'ICD10'
                         and not exists ( select  *
                                          from    DiagnosisICD10Codes dd
                                          where   dd.ICD10Code = cs.OtherDiagnosis2 )))

if @@error <> 0 
  goto rollback_tran

insert  into Import837BatchClaimLineErrors
        (Import837BatchClaimLineId,
         ErrorCode,
         ErrorText,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  cl.Import837BatchClaimLineId,
                'C117',
                'Other diagnosis 3 is invalid',
                @UserCode,
                getdate(),
                @UserCode,
                getdate()
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = ctp.ClaimFileLineNumber
        where   ctp.ClaimType = 2222
                and cs.OtherDiagnosis3 is not null
                and ((cs.DiagnosisType = 'ICD9'
                      and not exists ( select *
                                       from   DiagnosisDSMDescriptions dd
                                       where  dd.DSMCode = cs.OtherDiagnosis3 ))
                     or (cs.DiagnosisType = 'ICD10'
                         and not exists ( select  *
                                          from    DiagnosisICD10Codes dd
                                          where   dd.ICD10Code = cs.OtherDiagnosis3 )))

if @@error <> 0 
  goto rollback_tran

insert  into Import837BatchClaimLineErrors
        (Import837BatchClaimLineId,
         ErrorCode,
         ErrorText,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  cl.Import837BatchClaimLineId,
                'C118',
                'Admission diagnosis is invalid',
                @UserCode,
                getdate(),
                @UserCode,
                getdate()
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = ctp.ClaimFileLineNumber
        where   ctp.ClaimType = 2222
                and cs.AdmittingDiagnosis is not null
                and ((cs.DiagnosisType = 'ICD9'
                      and not exists ( select *
                                       from   DiagnosisDSMDescriptions dd
                                       where  dd.DSMCode = cs.AdmittingDiagnosis ))
                     or (cs.DiagnosisType = 'ICD10'
                         and not exists ( select  *
                                          from    DiagnosisICD10Codes dd
                                          where   dd.ICD10Code = cs.AdmittingDiagnosis )))

if @@error <> 0 
  goto rollback_tran

insert  into Import837BatchClaimLineErrors
        (Import837BatchClaimLineId,
         ErrorCode,
         ErrorText,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  cl.Import837BatchClaimLineId,
                'C119',
                'Claim Frequency Code is invalid',
                @UserCode,
                getdate(),
                @UserCode,
                getdate()
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = ctp.ClaimFileLineNumber
        where   isnull(cs.ClaimFrequencyCode, '') not in ('1', '7', '8')
 
if @@error <> 0 
  goto rollback_tran

insert  into Import837BatchClaimLineErrors
        (Import837BatchClaimLineId,
         ErrorCode,
         ErrorText,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  cl.Import837BatchClaimLineId,
                'C120',
                'Payer Claim Control Number is invalid',
                @UserCode,
                getdate(),
                @UserCode,
                getdate()
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = ctp.ClaimFileLineNumber
        where   cs.ClaimFrequencyCode in ('7', '8')
                and (isnumeric(cs.PayerClaimControlNumber) = 0
                     or (isnumeric(cs.PayerClaimControlNumber) = 1
                         and not exists ( select  *
                                          from    Claims cm
                                          where   cm.ClaimId = cs.PayerClaimControlNumber
												  AND cs.PayerClaimControlNumber NOT LIKE '%$%'	-- 11.28.2016
												  AND cs.PayerClaimControlNumber NOT LIKE '%.%'	-- 11.28.2016
                                                  and isnull(cm.RecordDeleted, 'N') = 'N' )))
                      
 
if @@error <> 0 
  goto rollback_tran

insert  into Import837BatchClaimLineErrors
        (Import837BatchClaimLineId,
         ErrorCode,
         ErrorText,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  cl.Import837BatchClaimLineId,
                'C121',
                'Provider on replacement/void claim does not match provider on original claim',
                @UserCode,
                getdate(),
                @UserCode,
                getdate()
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = ctp.ClaimFileLineNumber
                join Claims clm on clm.ClaimId = cs.PayerClaimControlNumber
                join Sites s on s.SiteId = c.SiteId
                join Sites se on se.SiteId = clm.SiteId
        where   cs.ClaimFrequencyCode in ('7', '8')
                and isnumeric(cs.PayerClaimControlNumber) = 1
				AND cs.PayerClaimControlNumber NOT LIKE '%$%'	-- 11.28.2016
				AND cs.PayerClaimControlNumber NOT LIKE '%.%'	-- 11.28.2016
                and s.ProviderId <> se.ProviderId

if @@error <> 0 
  goto rollback_tran

insert  into Import837BatchClaimLineErrors
        (Import837BatchClaimLineId,
         ErrorCode,
         ErrorText,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  cl.Import837BatchClaimLineId,
                'C122',
                'Claim supervising provider not found',
                @UserCode,
                getdate(),
                @UserCode,
                getdate()
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = ctp.ClaimFileLineNumber
        where   cs.SupervisingProviderName is not null
                and cs.SupervisingProviderId is null

if @@error <> 0 
  goto rollback_tran

insert  into Import837BatchClaimLineErrors
        (Import837BatchClaimLineId,
         ErrorCode,
         ErrorText,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  cl.Import837BatchClaimLineId,
                'C123',
                'Claim supervising provider not associated with billing provider',
                @UserCode,
                getdate(),
                @UserCode,
                getdate()
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = ctp.ClaimFileLineNumber
                join Sites s on s.SiteId = c.SiteId
        where   cs.SupervisingProviderName is not null
                and cs.SupervisingProviderId is not null
                and cs.SupervisingProviderId <> s.ProviderId              
                and not exists ( select *
                                 from   ProviderAffiliates pa
                                 where  pa.AffiliateProviderid = cs.SupervisingProviderId
                                        and pa.ProviderId = s.ProviderId
                                        and isnull(pa.RecordDeleted, 'N') = 'N' )

if @@error <> 0 
  goto rollback_tran

insert  into Import837BatchClaimLineErrors
        (Import837BatchClaimLineId,
         ErrorCode,
         ErrorText,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
select  cl.Import837BatchClaimLineId,
        'CL101',
        'Claim line rendering provider not found',
        @UserCode,
        getdate(),
        @UserCode,
        getdate()
from    #ClaimsToProcess ctp
        join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
        join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
        join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = ctp.ClaimFileLineNumber
where   cl.RenderingProviderName is not null
        and cl.RenderingProviderId is null
        and cl.RenderingProviderName <> isnull(cs.RenderingProviderName, '')
 
if @@error <> 0 
  goto rollback_tran

insert  into Import837BatchClaimLineErrors
        (Import837BatchClaimLineId,
         ErrorCode,
         ErrorText,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  cl.Import837BatchClaimLineId,
                'CL102',
                'Claim line rendering provider not associated with billing provider',
                @UserCode,
                getdate(),
                @UserCode,
                getdate()
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = ctp.ClaimFileLineNumber
                join Sites s on s.SiteId = c.SiteId
        where   cl.RenderingProviderName is not null
                and cl.RenderingProviderId is not null
		        and cl.RenderingProviderName <> isnull(cs.RenderingProviderName, '')
	-- As Discussed with Slavik on June 20, 2012, he has suggested that if ProviderId is same as Rendering Provider ID then skip this validation message 
                and cl.RenderingProviderId <> s.ProviderId
	------------------------------------------------------------------------
                and not exists ( select *
                                 from   ProviderAffiliates pa
                                 where  pa.AffiliateProviderid = cl.RenderingProviderId
                                        and pa.ProviderId = s.ProviderId
                                        and isnull(pa.RecordDeleted, 'N') = 'N' )


if @@error <> 0 
  goto rollback_tran

insert  into Import837BatchClaimLineErrors
        (Import837BatchClaimLineId,
         ErrorCode,
         ErrorText,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  cl.Import837BatchClaimLineId,
                'CL103',
                'Claim line place of service not found',
                @UserCode,
                getdate(),
                @UserCode,
                getdate()
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = ctp.ClaimFileLineNumber
                join #ServiceSegmentLinks ss on ss.ClaimFileLineNumber = cs.ClaimFileLineNumber
                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                                                    and cl.FileLineStart = ss.ServiceFileLineNumber
        where   ctp.ClaimType = 2221
                and ss.PlaceOfServiceCode is not null
                and not exists ( select *
                                 from   GlobalCodes gcpss
                                 where  gcpss.Category = 'PCMPLACEOFSERVICE'
                                        and gcpss.ExternalCode1 = ss.PlaceOfServiceCode
                                        and gcpss.Active = 'Y'
                                        and isnull(gcpss.RecordDeleted, 'N') = 'N' )

if @@error <> 0 
  goto rollback_tran

insert  into Import837BatchClaimLineErrors
        (Import837BatchClaimLineId,
         ErrorCode,
         ErrorText,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  cl.Import837BatchClaimLineId,
                'CL104',
                'Claim line supervising provider not found',
                @UserCode,
                getdate(),
                @UserCode,
                getdate()
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = ctp.ClaimFileLineNumber
        where   cl.SupervisingProviderName is not null
                and cl.SupervisingProviderId is null
		        and cl.SupervisingProviderName <> isnull(cs.SupervisingProviderName, '')

if @@error <> 0 
  goto rollback_tran

insert  into Import837BatchClaimLineErrors
        (Import837BatchClaimLineId,
         ErrorCode,
         ErrorText,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  cl.Import837BatchClaimLineId,
                'CL105',
                'Claim line supervising provider not associated with billing provider',
                @UserCode,
                getdate(),
                @UserCode,
                getdate()
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = ctp.ClaimFileLineNumber
                join Sites s on s.SiteId = c.SiteId
        where   cl.SupervisingProviderName is not null
                and cl.SupervisingProviderId is not null
                and cl.SupervisingProviderId <> s.ProviderId
		        and cl.SupervisingProviderName <> isnull(cs.SupervisingProviderName, '')
                and not exists ( select *
                                 from   ProviderAffiliates pa
                                 where  pa.AffiliateProviderid = cl.SupervisingProviderId
                                        and pa.ProviderId = s.ProviderId
                                        and isnull(pa.RecordDeleted, 'N') = 'N' )


if @@error <> 0 
  goto rollback_tran

insert  into Import837BatchClaimLineErrors
        (Import837BatchClaimLineId,
         ErrorCode,
         ErrorText,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  cl.Import837BatchClaimLineId,
                'CL106',
                'Claim line ordering provider not found',
                @UserCode,
                getdate(),
                @UserCode,
                getdate()
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
        where   cl.OrderingProviderName is not null
                and cl.OrderingProviderId is null

if @@error <> 0 
  goto rollback_tran

insert  into Import837BatchClaimLineErrors
        (Import837BatchClaimLineId,
         ErrorCode,
         ErrorText,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  cl.Import837BatchClaimLineId,
                'CL107',
                'Claim line ordering provider not associated with billing provider',
                @UserCode,
                getdate(),
                @UserCode,
                getdate()
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                join Sites s on s.SiteId = c.SiteId
        where   cl.OrderingProviderName is not null
                and cl.OrderingProviderId is not null
                and cl.OrderingProviderId <> s.ProviderId
                and not exists ( select *
                                 from   ProviderAffiliates pa
                                 where  pa.AffiliateProviderid = cl.OrderingProviderId
                                        and pa.ProviderId = s.ProviderId
                                        and isnull(pa.RecordDeleted, 'N') = 'N' )


if @@error <> 0 
  goto rollback_tran

--
-- Create/void/replace claims if no claim or claim line level errors
--

create table #NewClaims (
ClaimId int not null,
Import837BatchClaimId int not null)
declare @ClaimLineId int,
  @ClaimLineStatus int

-- Void all existing claim lines for the replacement and void claims
declare cur_VoidClaimLines cursor
for
select  cl.ClaimLineId,
        cl.Status
from    #ClaimsToProcess ctp
        join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
        join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = c.FileLineStart
        join Claims clm on clm.ClaimId = cs.PayerClaimControlNumber
        join ClaimLines cl on cl.ClaimId = clm.ClaimId
where   cs.ClaimFrequencyCode in ('7', '8') -- Replacement and Void
        and cl.status <> 2028
        and isnull(cl.RecordDeleted, 'N') = 'N'
        and not exists ( select *
                         from   Import837BatchClaimLines cl
                                join Import837BatchClaimLineErrors cle on cle.Import837BatchClaimLineId = cl.Import837BatchClaimLineId
                         where  cl.Import837BatchClaimId = c.Import837BatchClaimId
                                and isnull(cl.RecordDeleted, 'N') = 'N'
                                and isnull(cle.RecordDeleted, 'N') = 'N' )

open cur_VoidClaimLines 

if @@error <> 0 
  goto rollback_tran

fetch cur_VoidClaimLines into @ClaimLineId, @ClaimLineStatus

if @@error <> 0 
  goto rollback_tran

while @@fetch_status = 0 
  begin
    -- Revert the claim line first
    if @ClaimLineStatus in (2023, 2024, 2025, 2026, 2027) 
      begin
        exec ssp_CMRevertClaimLine 
          @ClaimLineId = @ClaimLineId,
          @UserId = @StaffId,
          @UserCode = @UserCode 
        if @@error <> 0 
          goto rollback_tran
      end 

    -- Void the claim line
    exec ssp_CMUpdateClaimLineStatus 
      @ClaimLineId = @ClaimLineId,
      @Status = 2028,
      @ActivityId = 2010,
      @UserCode = @UserCode
      
    if @@error <> 0 
      goto rollback_tran

    -- Remove from Open claims
    delete  from OpenClaims
    where   ClaimLineId = @ClaimLineId
    
    if @@error <> 0 
      goto rollback_tran

    fetch cur_VoidClaimLines into @ClaimLineId, @ClaimLineStatus
    if @@error <> 0 
      goto rollback_tran
  end

close cur_VoidClaimLines

if @@error <> 0 
  goto rollback_tran

deallocate cur_VoidClaimLines

if @@error <> 0 
  goto rollback_tran


-- Insert new and replacement claims
insert  into Claims
        (ClientId,
         InsurerId,
         SiteId,
         ReceivedDate,
         CleanClaimDate,
         ClaimType,
         ClientAddress1,
         ClientAddress2,
         ClientCity,
         ClientState,
         ClientZip,
         AuthorizationNumber,
         PatientAccountNumber,
         OtherInsured,
         OtherInsuredName,
         OtherInsuredId,
         OtherInsuredDOB,
         OtherPlanName,
         Diagnosis1,
         Diagnosis2,
         Diagnosis3,
         TotalCharge,
         AmountPaid,
         BalanceDue,
         TaxIdType,
         StartDate,
         EndDate,
         AdmissionDate,
         AdmissionTime,
         DischargeTime,
         DiagnosisAdmission,
         DiagnosisPrincipal,
         OtherPayers,
         OtherPayerName1,
         OtherProviderNumber1,
         OtherPriorPayment1,
         OtherInsuredName1,
         OtherCertification1,
         OtherGroupNumber1,
         OtherPayerName2,
         OtherProviderNumber2,
         OtherPriorPayment2,
         OtherInsuredName2,
         OtherInsuredDOB2,
         OtherInsuredDOB1,
         OtherCertification2,
         OtherGroupNumber2,
         OtherPayerName3,
         OtherProviderNumber3,
         OtherPriorPayment3,
         OtherInsuredName3,
         OtherInsuredDOB3,
         OtherCertification3,
         OtherGroupNumber3,
         RenderingProviderId,
         RenderingProviderName,
         RenderingFacilityInfo,
		 SupervisingProviderId,
		 SupervisingProviderName,
         BillingProviderInfo,
         PreviouslyPaidAmount,
         Electronic,
         Comment,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate,
         DeletedBy)
output  inserted.ClaimId,
        convert(int, inserted.DeletedBy)
        into #NewClaims (ClaimId, Import837BatchClaimId)
        select  c.ClientId,
                ctp.InsurerId,
                c.SiteId,
                convert(char(10), getdate(), 101) --ReceivedDate
                ,
                convert(char(10), getdate(), 101) --CleanClaimDate
                ,
                ctp.ClaimType,
                ps.PatientAddress1,
                ps.PatientAddress2,
                ps.PatientCity,
                ps.PatientState,
                ps.PatientZip,
                cs.AuthorizationNumber1,
                c.PatientAccountNumber,
                case when ois.ClaimFileLineNumber is not null then 'Y'
                     else 'N'
                end --OtherInsured
                ,
                ois.InsuredName1 --OtherInsuredName
                ,
                ois.InsuredId1 --OtherInsuredId
                ,
                null --OtherInsuredDOB
                ,
                ois.Payer1 --OtherPlanName
                ,
                case when ctp.ClaimType = 2221 then cs.PrincipalDiagnosis
                     else cs.OtherDiagnosis1
                end,
                case when ctp.ClaimType = 2221 then cs.OtherDiagnosis1
                     else cs.OtherDiagnosis2
                end,
                case when ctp.ClaimType = 2221 then cs.OtherDiagnosis2
                     else cs.OtherDiagnosis3
                end,
                c.ClaimCharges,
                isnull(PriorPayment1, 0) + isnull(PriorPayment2, 0) + isnull(PriorPayment3, 0) --AmountPaid
                ,
                c.ClaimCharges - (isnull(PriorPayment1, 0) + isnull(PriorPayment2, 0) + isnull(PriorPayment3, 0)) --BalanceDue
                ,
                s.TaxIdType,
                cs.StatementStartDate,
                cs.StatementEndDate,
                cs.AdmissoinDate,
                convert(char(10), cs.AdmissoinDate, 101) + ' ' + left(right('0000' + cs.AdmissionHour, 4), 2) + ':' + right('00' + cs.AdmissionHour, 2),
                convert(char(10), isnull(cs.StatementEndDate, cs.AdmissoinDate), 101) + ' ' + left(right('0000' + cs.DischargeHour, 4), 2) + ':' + right('00' + cs.DischargeHour, 2),
                cs.AdmittingDiagnosis,
                case when ctp.ClaimType = 2221 then null
                     else cs.PrincipalDiagnosis
                end,
                case when ois.ClaimFileLineNumber is not null then 'Y'
                     else 'N'
                end --OtherPayers
                ,
                ois.Payer1--OtherPayerName1
                ,
                ois.ProviderNumber1 --OtherProviderNumber1
                ,
                ois.PriorPayment1 --OtherPriorPayment1
                ,
                ois.InsuredName1 --OtherInsuredName1
                ,
                null --OtherCertification1
                ,
                ois.GroupNumber1 --OtherGroupNumber1
                ,
                ois.Payer2 --OtherPayerName2
                ,
                ois.ProviderNumber2 --OtherProviderNumber2
                ,
                ois.PriorPayment2 --OtherPriorPayment2
                ,
                ois.InsuredName2 --OtherInsuredName2
                ,
                null --OtherInsuredDOB2
                ,
                null --OtherInsuredDOB1
                ,
                null --OtherCertification2
                ,
                ois.GroupNumber2 --OtherGroupNumber2
                ,
                ois.Payer3 --OtherPayerName3
                ,
                ois.ProviderNumber3 --OtherProviderNumber3
                ,
                ois.PriorPayment3 --OtherPriorPayment3
                ,
                ois.InsuredName3 --OtherInsuredName3
                ,
                null --OtherInsuredDOB3
                ,
                null --OtherCertification3
                ,
                ois.GroupNumber3 --OtherGroupNumber3
                ,
                cs.RenderingProviderId,
                cs.RenderingProviderName,
                null --RenderingFacilityInfo
                ,
  			    cs.SupervisingProviderId,
		        cs.SupervisingProviderName,
                null --BillingProviderInfo
                ,
                isnull(PriorPayment1, 0) + isnull(PriorPayment2, 0) + isnull(PriorPayment3, 0) --PreviouslyPaidAmount
                ,
                'Y' --Electronic
                ,
                case when cs.PayerClaimControlNumber is not null then 'Replacement of claim #' + convert(varchar, cs.PayerClaimControlNumber)
                     else null
                end      --Comment
                ,
                @UserCode --CreatedBy
                ,
                getdate() --CreatedDate
                ,
                @UserCode --ModifiedBy
                ,
                getdate() --ModifiedDate
                ,
                convert(varchar, ctp.Import837BatchClaimId) --DeletedBy
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = c.FileLineStart
                join #PatientSegmentLinks ps on ps.PatientFileLineNumber = cs.PatientFileLineNumber
                join #SubscriberSegmentLinks ss on ss.SubscriberFileLineNumber = ps.SubscriberFileLineNumber
                join #ProviderSegmentLinks prs on prs.ProviderFileLineNumber = ss.ProviderFileLineNumber
                join Sites s on s.SiteId = c.SiteId
                left join #OtherInsuranceSegementLinks2 ois on ois.ClaimFileLineNumber = cs.ClaimFileLineNumber
        where   cs.ClaimFrequencyCode in ('1', '7') -- New, Replacements
		        and c.ClaimId is null
                and not exists ( select *
                                 from   Import837BatchClaimLines cl
                                        join Import837BatchClaimLineErrors cle on cle.Import837BatchClaimLineId = cl.Import837BatchClaimLineId
                                 where  cl.Import837BatchClaimId = c.Import837BatchClaimId
                                        and isnull(cl.RecordDeleted, 'N') = 'N'
                                        and isnull(cle.RecordDeleted, 'N') = 'N' )

if @@error <> 0 
  goto rollback_tran

update  c
set     ClaimId = nc.ClaimId
from    Import837BatchClaims c
        join #NewClaims nc on nc.Import837BatchClaimId = c.Import837BatchClaimId

if @@error <> 0 
  goto rollback_tran

update  c
set     DeletedBy = null
from    Claims c
        join #NewClaims nc on nc.ClaimId = c.ClaimId

if @@error <> 0 
  goto rollback_tran

-- Determine claim line billing code IDs
update  ss
set     BillingCodeId = bc.BillingCodeId
from    #ServiceSegmentLinks ss
        join BillingCodes bc on bc.BillingCode = ss.HCPCSCode
where   bc.Active = 'Y'
        and ss.HCPCSCode is not null
        and isnull(bc.RecordDeleted, 'N') = 'N'

if @@error <> 0 
  goto rollback_tran

update  ss
set     BillingCodeId = bc.BillingCodeId
from    #ServiceSegmentLinks ss
        join BillingCodes bc on bc.BillingCode = ss.RevenueCode
where   bc.Active = 'Y'
        and ss.RevenueCode is not null
        and isnull(bc.RecordDeleted, 'N') = 'N'

if @@error <> 0 
  goto rollback_tran

update  ss
set     BillingCodeId = bc.BillingCodeId
from    #ServiceSegmentLinks ss
        join BillingCodes bc on bc.BillingCode = 'RC' + ss.RevenueCode
where   bc.Active = 'Y'
        and ss.RevenueCode is not null
        and isnull(bc.RecordDeleted, 'N') = 'N'
        and ss.BillingCodeId is null
             
if @@error <> 0 
  goto rollback_tran

-- Create claim lines

create table #NewClaimLines (
ClaimLineId int not null,
Import837BatchClaimLineId int not null)

insert  into ClaimLines
        (ClaimId,
         Status,
         FromDate,
         ToDate,
         PlaceOfService,
         RevenueCode,
         ProcedureCode,
         BillingCodeId,
         Modifier1,
         Modifier2,
         Modifier3,
         Modifier4,
         Diagnosis1,
         Diagnosis2,
         Diagnosis3,
         Charge,
         Units,
         PaidAmount,
         ClaimedAmount,
         RenderingProviderId,
         RenderingProviderName,
 		 SupervisingProviderId,
		 SupervisingProviderName,
 		 OrderingProviderId,
		 OrderingProviderName,
         DoNotAdjudicate,
         NeedsToBeWorked,
         ToReadjudicate,
         PayableAmount,
         ManualApprovalReason,
         DenialReason,
         PendedReason,
         Comment,
         AuthorizationExistsAtEntry,
         EOBReceived,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate,
         DeletedBy,
		 StartTime,
		 EndTime)
output  inserted.ClaimLineId,
        convert(int, inserted.DeletedBy)
        into #NewClaimLines (ClaimLineId, Import837BatchClaimLineId)
        select  c.ClaimId,
                2022 -- Status Entry Complete
                ,
                isnull(ss.ServiceFromDate, cs.StatementStartDate),
                isnull(ss.ServiceToDate, cs.StatementEndDate),
                case when ctp.ClaimType = 2221 then isnull(gcpss.GlobalCodeId, gcpsc.GlobalCodeId)
                     else null
                end,
                ss.RevenueCode,
                ss.HCPCSCode --ProcedureCode
                ,
                ss.BillingCodeId,
                ss.Modifier1,
                ss.Modifier2,
                ss.Modifier3,
                ss.Modifier4,
                case when (ss.DiagnosisPointer1 = 1 or ss.DiagnosisPointer2 = 1 or ss.DiagnosisPointer3 = 1) then 'Y'
                     else 'N'
                end,
                case when (ss.DiagnosisPointer1 = 2 or ss.DiagnosisPointer2 = 2 or ss.DiagnosisPointer3 = 2) then 'Y'
                     else 'N'
                end,
                case when (ss.DiagnosisPointer1 = 3 or ss.DiagnosisPointer2 = 3 or ss.DiagnosisPointer3 = 3) then 'Y'
                     else 'N'
                end,
                round(ss.ChargeAmount, 2) --Charge    -- Modified by mkhusro on 6/9/2017
                ,
                ss.ServiceUnits,
                null --PaidAmount
                ,
                round(ss.ChargeAmount, 2) --ClaimedAmount
                ,
                cl.RenderingProviderId,
                cl.RenderingProviderName,
				cl.SupervisingProviderId,
				cl.SupervisingProviderName,
				cl.OrderingProviderId,
				cl.OrderingProviderName,
                'N' --DoNotAdjudicate
                ,
                'N' --NeedsToBeWorked
                ,
                'N' --ToReadjudicate
                ,
                null --PayableAmount
                ,
                null --ManualApprovalReason
                ,
                null --DenialReason
                ,
                null --PendedReason
                ,
                null --Comment
                ,
                case when cl.AuthorizationNumber is not null then 'Y'
                     else 'N'
                end --AuthorizationExistsAtEntry
                ,
                null --EOBReceived
                ,
                @UserCode,
                getdate(),
                @UserCode,
                getdate(),
                convert(varchar, cl.Import837BatchClaimLineId), -- DeletedBy
				ss.ServiceStartTime,
				ss.ServiceEndTime
        from    #ClaimsToProcess ctp
                join Import837BatchClaims c on c.Import837BatchClaimId = ctp.Import837BatchClaimId
                join #NewClaims nc on nc.Import837BatchClaimId = c.Import837BatchClaimId
                join #ClaimSegmentLinks cs on cs.ClaimFileLineNumber = c.FileLineStart
                join #ServiceSegmentLinks ss on ss.ClaimFileLineNumber = cs.ClaimFileLineNumber
                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                                                    and cl.FileLineStart = ss.ServiceFileLineNumber
                left join GlobalCodes gcpsc on gcpsc.Category = 'PCMPLACEOFSERVICE'
                                               and gcpsc.ExternalCode1 = cs.PlaceOfServiceCode
                                               and gcpsc.Active = 'Y'
                                               and isnull(gcpsc.RecordDeleted, 'N') = 'N'
                left join GlobalCodes gcpss on gcpss.Category = 'PCMPLACEOFSERVICE'
                                               and gcpss.ExternalCode1 = ss.PlaceOfServiceCode
                                               and gcpss.Active = 'Y'
                                               and isnull(gcpss.RecordDeleted, 'N') = 'N'
        where   cs.ClaimFrequencyCode in ('1', '7') -- New or Replacement
		  and   cl.ClaimLineId is null

if @@error <> 0 
  goto rollback_tran

update  cl
set     ClaimLineId = ncl.ClaimLineId,
        Processed = 'Y'
from    Import837BatchClaimLines cl
        join #NewClaimLines ncl on ncl.Import837BatchClaimLineId = cl.Import837BatchClaimLineId

if @@error <> 0 
  goto rollback_tran

update  cl
set     DeletedBy = null
from    ClaimLines cl
        join #NewClaimLines ncl on ncl.ClaimLineId = cl.ClaimLineId

if @@error <> 0 
  goto rollback_tran

----Insert Into ClaimLineDrugs Table
insert  into ClaimLineDrugs
        (ClaimLineId,
         NationalDrugCode,
         Units,
         UnitType,
         CreatedBy,
         CreatedDate,
        ModifiedBy,
         ModifiedDate)
select  cl.ClaimLineId,
        ss.NationalDrugcode,
        ss.NationalDrugcodeUnitCount,
        gc.GlobalCodeId,--ss.NationalDrugcodeUnitType,
        @UserCode,
        getdate(),
        @UserCode,
        getdate()
from    #NewClaimLines ncl
        join dbo.Import837BatchClaimLines cl on cl.Import837BatchClaimLineId = ncl.Import837BatchClaimLineId
        join #ServiceSegmentLinks ss on ss.ServiceFileLineNumber = cl.FileLineStart
        left join dbo.GlobalCodes gc on gc.CodeName = case when ss.NationalDrugcodeUnitType = 'UN' then 'Units'
		                                                   when ss.NationalDrugcodeUnitType = 'ME' then 'MG'
                                                           else ss.NationalDrugcodeUnitType
                                                      end
                                        and gc.Category = 'MEDICATIONUNIT'
                                        and gc.Active = 'Y'
                                        and isnull(gc.RecordDeleted, 'N') = 'N'
where   isnull(cl.RecordDeleted, 'N') = 'N'
        and ss.NationalDrugcode is not null
		
		

if @@error <> 0 
  goto rollback_tran

---Update ClaimLineDrugs.DrugId based on NationalDrugcode
update  cld
set		DrugId = mdd.DrugId
from	ClaimLineDrugs cld
join	MDDrugs mdd on replace(isnull(ltrim(rtrim(mdd.NationalDrugCode)), ''),' ','') = replace(isnull(ltrim(rtrim(cld.NationalDrugCode)), ''),' ','')
join	#NewClaimLines ncl on ncl.ClaimLineId = cld.ClaimLineId
and		isnull(mdd.RecordDeleted, 'N') = 'N'
where	isnull(cld.RecordDeleted, 'N') = 'N'

if @@error <> 0 
  goto rollback_tran

-- Create COB payments
insert  into ClaimLineCOBPaymentAdjustments
        (ClaimLineId,
         PayerId,
         PayerName,
         PayerIsClient,
         PaidAmount,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  cl.ClaimLineId,
                null,
                ois.Payer,
                null,
                sa.PaidAmount,
                @UserCode,
                getdate(),
                @UserCode,
                getdate()
        from    #NewClaimLines ncl
                join Import837BatchClaimLines cl on cl.Import837BatchClaimLineId = ncl.Import837BatchClaimLineId
                join #ServiceAdjudications sa on sa.ServiceFileLineNumber = cl.FileLineStart
                left join #OtherInsuranceSegementLinks ois on ois.OtherInsuranceFileLineNumber = sa.OtherInsuranceFileLineNumber
        where   isnull(sa.PaidAmount, 0) <> 0

if @@error <> 0 
  goto rollback_tran

-- Create COB adjustments
insert  into ClaimLineCOBPaymentAdjustments
        (ClaimLineId,
         PayerId,
         PayerName,
         PayerIsClient,
         AdjustmentGroupCode,
         AdjustmentReason,
         AdjustmentAmount,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  cl.ClaimLineId,
                null,
                ois.Payer,
                null,
                gcgc.GlobalCodeId,
                gscr.GlobalSubCodeId,
                sad.AdjustmentAmount,
                @UserCode,
                getdate(),
                @UserCode,
                getdate()
        from    #NewClaimLines ncl
                join Import837BatchClaimLines cl on cl.Import837BatchClaimLineId = ncl.Import837BatchClaimLineId
                join #ServiceAdjudications sa on sa.ServiceFileLineNumber = cl.FileLineStart
                join #ServiceAdjustments sad on sad.ServiceAdjudicationLineNumber = sa.ServiceAdjudicationLineNumber
                left join #OtherInsuranceSegementLinks ois on ois.OtherInsuranceFileLineNumber = sa.OtherInsuranceFileLineNumber
                left join GlobalCodes gcgc on gcgc.Category = 'CLAIMADJGROUPCODE'
                                              and gcgc.ExternalCode1 = sad.AdjustmentgroupCode
                                              and isnull(gcgc.RecordDeleted, 'N') = 'N'
                left join GlobalSubCodes gscr on gscr.GlobalCodeId = gcgc.GlobalCodeId
                                                 and gscr.ExternalCode1 = sad.AdjustmentReasonCode
                                                 and isnull(gscr.RecordDeleted, 'N') = 'N'
        where   isnull(sad.AdjustmentAmount, 0) <> 0
        order by cl.ClaimLineId,
                sad.ServiceAdjustmentFileNumber,
                sad.AdjustmentNumber
   
if @@error <> 0 
  goto rollback_tran

-- Adjust claimed amount by other payers payments and adjustments
update  cl
set     ClaimedAmount = case when cl.ClaimedAmount - (isnull(p.PaidAmount, 0) + isnull(a.AdjustmentAmount, 0)) < 0 then 0
                             else round(cl.ClaimedAmount - (isnull(p.PaidAmount, 0) + isnull(a.AdjustmentAmount, 0)), 2)
                        end
from    #NewClaimLines ncl
        join ClaimLines cl on cl.ClaimLineId = ncl.ClaimLineId
        left join (select ncl.ClaimLineId,
                          sum(pa.PaidAmount) as PaidAmount
                   from   #NewClaimLines ncl
                          join ClaimLineCOBPaymentAdjustments pa on pa.ClaimLineId = ncl.ClaimLineId
                   where  isnull(pa.PaidAmount, 0) <> 0
                   group by ncl.ClaimLineId) p on p.ClaimLineId = cl.ClaimLineId
        left join (select ncl.ClaimLineId,
                          sum(pa.AdjustmentAmount) as AdjustmentAmount
                   from   #NewClaimLines ncl
                          join ClaimLines cl on cl.ClaimLineId = ncl.ClaimLineId
                          join Claims c on c.ClaimId = cl.ClaimId
                          join Insurers i on i.InsurerId = c.InsurerId
                          join ClaimLineCOBPaymentAdjustments pa on pa.ClaimLineId = ncl.ClaimLineId
                   where  isnull(pa.AdjustmentAmount, 0) <> 0
                          and (nullif(i.COBExcludeAdjustmentReasonGroupName, '') is null
                               or (len(i.COBExcludeAdjustmentReasonGroupName) > 0
                                   and not exists ( select  *
                                                    from    InsurerCOBExcludeAdjustmentReasons ear
                                                    where   ear.InsurerId = i.InsurerId
                                                            and ear.AdjustmentReason = pa.AdjustmentReason
                                                            and isnull(ear.RecordDeleted, 'N') = 'N' )))
                   group by ncl.ClaimLineId) a on a.ClaimLineId = cl.ClaimLineId
where   (isnull(p.PaidAmount, 0) <> 0
         or isnull(a.AdjustmentAmount, 0) <> 0)
                         
if @@error <> 0 
  goto rollback_tran

insert  into ClaimLineHistory
        (ClaimLineId,
         Activity,
         ActivityDate,
         Status,
         ActivityStaffId,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  cl.ClaimLineId,
                2001 --Data Entry Activity
                ,
                getdate() --ActivityDate
                ,
                cl.Status,
                @StaffId --ActivityStaffId
                ,
                @UserCode,
                getdate(),
                @UserCode,
                getdate()
        from    ClaimLines cl
                join #NewClaimLines ncl on ncl.ClaimLineId = cl.ClaimLineId

if @@error <> 0 
  goto rollback_tran

insert  into OpenClaims
        (ClaimLineId,
         CreatedBy,
         CreatedDate,
         ModifiedBy,
         ModifiedDate)
        select  cl.ClaimLineId,
                cl.CreatedBy,
                cl.CreatedDate,
                cl.ModifiedBy,
                cl.ModifiedDate
        from    ClaimLines cl
                join #NewClaimLines ncl on ncl.ClaimLineId = cl.ClaimLineId

if @@error <> 0 
  goto rollback_tran

update  f
set     Processed = 'Y'
from    Import837Files f
where   f.Import837FileId = @Import837FileId
        and not exists ( select *
                         from   Import837Batches b
                                join Import837BatchClaims c on c.Import837BatchId = b.Import837BatchId
                                join Import837BatchClaimLines cl on cl.Import837BatchClaimId = c.Import837BatchClaimId
                         where  b.Import837FileId = f.Import837FileId
                                and isnull(cl.Processed, 'N') = 'N'
                                and isnull(b.RecordDeleted, 'N') = 'N'
                                and isnull(c.RecordDeleted, 'N') = 'N'
                                and isnull(cl.RecordDeleted, 'N') = 'N' )

if @@error <> 0 
  goto rollback_tran

end_process_claims:

commit

return 

rollback_tran:

if @@trancount > 0 
  rollback transaction

parse_error:

insert  into Import837FileParsingErrors
        (Import837FileId,
         Import837FileSegmentId,
         LineNumber,
         ErrorMessage,
         LineDataText,
         CreatedBy,
         ModifiedBy)
        select  @Import837FileId,
                b.Import837FileSegmentId,
                b.FileLineNumber,
                a.ErrorMessage,
                b.DataText,
                @UserCode,
                @UserCode
        from    #ParseErrors a
                join #837ImportParse b on (a.LineNumber = b.FileLineNumber)


go
