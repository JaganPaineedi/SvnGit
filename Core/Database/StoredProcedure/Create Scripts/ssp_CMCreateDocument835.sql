if object_id('dbo.ssp_CMCreateDocument835') is not null 
  drop procedure dbo.ssp_CMCreateDocument835
go  

CREATE procedure dbo.ssp_CMCreateDocument835
@BatchId int
/********************************************************************************  
-- Stored Procedure: dbo.ssp_CMCreateDocument835   
--  
-- Copyright: 2012 Streamline Healthcate Solutions  
--  
-- Purpose: Generates electronic Health Care Claims Payment/Advice(835)  
--  
-- Updates:     
-- Date				Author      Purpose  
-- 04.26.2012		Samrat      CREATE 835 EDI file for required Segments.
-- 06.11.2012		Samrat      Created      Ref: task No: 1490  
-- July 6, 2012		Pralyankar	Modified for fixing issues of task 1791.
-- July 21, 2012	Pralyankar	Modified for including the denial claims into document 835.
-- August 21, 2012	Pralyankar	Modified for Stored Procedure Optimization.
-- 25 Sep 2012		Manjit		Added initialization code for usercode
-- 15 Oct 2012		Samrat		Modified ISA and PER segments
-- Dec 11, 2012		Pralyankar  Modified for removing duplicate rows from the file.
-- 07.25.2013       SFarber     Replaced 'join Counties' with 'left join Counties'
-- 09.17.2013       SFarber     Added REF*6R segment
-- 02.09.2015       SFarber     Improved performance.
-- 05.13.2015       SFarber     Removed CheckNumber from the final result set.
-- 11.17.2016       SFarber     Added call to scsp_CMCreateDocument835
-- 12.01.2016       SFaber      Fixed logic for getting sites.
-- 12.01.2016       SFarber     Fixed InterchangeTime and FunctionalTime format
-- 12.07.2016       SFarber     Changed version code to 005010X221A1
-- 12.08.2016       SFarber     Added CAS segment
-- 07.19.2018		MJensen		Added paid qty to SVC segment - Partner Solutions Support #33
								Fixed credits being sent as denials.
								Reversed charge amount for credits.
								Trimmed blanks from application sender code in gs segment
-- 08.16.2018       SFarber     Added CAS segment for copay
*********************************************************************************/
as 

declare @ClaimStatusDenied int                        
declare @AddressTypeOffice int                        
declare @AddressTypeInsurer int                        
declare @UserCode varchar(20)                        
declare @DateTimeNow datetime = getdate()
declare @InsurerName varchar(50)
declare @InsurerNPI varchar(10)
declare @ProviderNPI varchar(10)
declare @ProviderId int 

declare @ErrorMessage varchar(4000)
declare @ErrorNumber int
declare @ErrorSeverity int
declare @ErrorState int
declare @ErrorLine int
declare @ErrorProcedure varchar(200)

begin try
                       
  create table #Checks (
  CheckId int null,
  CheckNumber varchar(20) null,
  PayeeName varchar(100) null,
  CheckDate datetime null,
  CreatedDate datetime null,
  CheckAmount money null,
  PayeeAddress varchar(150) null,
  ProviderId int null,
  InsurerId int null,
  InsurerTaxId char(9) null,
  InsurerName varchar(100) null,
  InsurerLegalName varchar(100) null,
  InsurerAddress varchar(100) null,
  InsurerCity varchar(30) null,
  InsurerState char(2) null,
  InsurerZip varchar(12) null,
  InsurerContactName varchar(50) null,
  InsurerContactPhone varchar(50) null,
  ProviderName varchar(150) null,
  ProviderNPI varchar(10) null,
  ProviderAddress varchar(100) null,
  ProviderCity varchar(30) null,
  ProviderState char(2) null,
  ProviderZip varchar(12) null,
  Reason1 varchar(max) null,
  Reason2 varchar(max) null,
  UpdateClaimLineDenials char(1) null)                        
                        
  create table #Claims (
  ClaimId int null,
  CheckId int null,
  ClientId int null,
  SiteId int null,
  InsuredId varchar(25) null,
  ClaimLineId int null,
  Status int null,
  FromDate datetime null,
  ToDate datetime null,
  BillingCodeId int null,
  Modifier1 varchar(3) null,
  Modifier2 varchar(3) null,
  Modifier3 varchar(3) null,
  Modifier4 varchar(3) null,
  ClaimedAmount money null,
  PaidAmount money null,
  NotCoveredAmount money null,
  DenialReason int null,
  Units int null,
  Charge money null,
  LineItemControlNumber varchar(30),
  PaidUnits INT null,   -- MJ 7/19/2018               
  CopayAmount money null)
                          
  create table #Denials (
  ClaimLineDenialId int null,
  ClaimLineId int null,
  CheckId int null,
  DenialReason int null,
  DenialReasonName varchar(250) null)        

  create table #Addresses (
  ProviderId int,
  SiteId int,
  SiteAddressId int,
  Priority int)

  create table #Sites (
  SiteId int,
  ProviderId int)
                        
  set @ClaimStatusDenied = 2024                        
  set @AddressTypeOffice = 2282                        
  set @AddressTypeInsurer = 91                        
             
  select  @UserCode = b.CreatedBy
  from    Export835Batches b
  where   b.Export835BatchId = @BatchId		            
                        
  insert  into #Checks
          (CheckId,
           CheckNumber,
           PayeeName,
           CheckDate,
           CreatedDate,
           CheckAmount,
           ProviderId,
           InsurerId,
           InsurerTaxId,
           InsurerName,
           InsurerLegalName,
           InsurerContactName,
           InsurerContactPhone,
           ProviderName)
          select  c.CheckId,
                  c.CheckNumber,
                  c.PayeeName,
                  c.CheckDate,
                  c.CreatedDate,
                  c.Amount,
                  c.ProviderId,
                  c.InsurerId,
                  i.TaxId,
                  i.InsurerName,
                  i.LegalName,
                  i.ContactName,
                  i.ContactPhone,
                  case when p.FirstName is not null then p.FirstName + ' '
                       else ''
                  end + p.ProviderName
          from    Export835BatchChecks ebc
                  join Checks c on c.CheckId = ebc.CheckId
                  join Insurers i on i.InsurerId = c.InsurerId
                  join Providers p on p.ProviderId = c.ProviderId
          where   ebc.Export835BatchId = @BatchId
 
  update  c
  set     InsurerAddress = ia.Address,
          InsurerCity = ia.City,
          InsurerState = ia.State,
          InsurerZip = ia.Zip
  from    #Checks c
          join InsurerAddresses ia on ia.InsurerId = c.InsurerId
                                      and ia.AddressType = @AddressTypeInsurer
  where   isnull(ia.RecordDeleted, 'N') = 'N'
               
  -- Get claim lines                         
  insert  into #Claims
          (CheckId,
           ClientId,
           ClaimId,
           ClaimLineId,
           SiteId,
           Status,
           FromDate,
           ToDate,
           BillingCodeId,
           Modifier1,
           Modifier2,
           Modifier3,
           Modifier4,
           ClaimedAmount,
           PaidAmount,
           NotCoveredAmount,
           units,
           charge,
		   PaidUnits)	-- MJ 7/19/2018                        
          -- Payments                        
          select  clp.CheckId,
                  c.ClientId,
                  cl.ClaimId,
                  cl.ClaimLineId,
                  c.SiteId,
                  cl.Status,
                  cl.FromDate,
                  cl.ToDate,
                  cl.BillingCodeId,
                  nullif(cl.Modifier1, ''),
                  nullif(cl.Modifier2, ''),
                  nullif(cl.Modifier3, ''),
                  nullif(cl.Modifier4, ''),
                  cl.ClaimedAmount,
                  clp.Amount,
                  cl.ClaimedAmount - isnull(clp.Amount, 0),
                  cl.units,
                  cl.charge,
				  NULL	-- MJ 7/19/2018
          from    Claims c
                  join ClaimLines cl on cl.ClaimId = c.ClaimId
                  join ClaimLinePayments clp on clp.ClaimLineId = cl.ClaimLineId
                  join #Checks ch on ch.CheckId = clp.CheckId
          where   isnull(clp.RecordDeleted, 'N') = 'N'
          union all                                  
          -- Credits                        
          select  clc.CheckId,
                  c.ClientId,
                  cl.ClaimId,
                  cl.ClaimLineId,
                  max(c.SiteId),
                  max(cl.Status),
                  max(cl.FromDate),
                  max(cl.ToDate),
                  max(cl.BillingCodeId),
                  max(nullif(cl.Modifier1, '')),
                  max(nullif(cl.Modifier2, '')),
                  max(nullif(cl.Modifier3, '')),
                  max(nullif(cl.Modifier4, '')),
                  -MAX(cl.ClaimedAmount),	-- MJ 7/19/2018
                  -sum(clc.Amount),
                  max(cl.ClaimedAmount) - max(isnull(cl.PaidAmount, 0)),
                  max(cl.units),
                  max(cl.charge),
				  - MAX(CAST(ISNULL(cl.Units,0) AS INT))	-- MJ 7/19/2018
          from    Claims c
                  join ClaimLines cl on cl.ClaimId = c.ClaimId
                  join ClaimLineCredits clc on clc.ClaimLineId = cl.ClaimLineId
                  join #Checks ch on ch.CheckId = clc.CheckId
          where   isnull(clc.RecordDeleted, 'N') = 'N'
          group by clc.CheckId,
                  c.ClientId,
                  cl.ClaimId,
                  cl.ClaimLineId                        

  -- Member copay
  update  c
  set     c.CopayAmount = case when c.ClaimedAmount > 0 then ar.DeniedAmount else -ar.DeniedAmount end
  from    #Claims c
          join CheckAdjudications ca on ca.CheckId = c.CheckId 
		  join Adjudications a on a.AdjudicationId = ca.AdjudicationId and a.ClaimLineId = c.ClaimLineId
          join AdjudicationDenialPendedReasons ar on ar.AdjudicationId = a.AdjudicationId
  where   isnull(ar.RecordDeleted, 'N') = 'N'
          and ar.DenialReason = 2584 -- Member copay

  -- Denials        
  insert  into #Denials
          (ClaimLineDenialId,
           ClaimLineId,
           CheckId,
           DenialReason,
           DenialReasonName)
          select  cld.ClaimLineDenialId,
                  cld.ClaimLineId,
                  cld.CheckId,
                  cld.DenialReason,
                  cld.DenialReasonName
          from    ClaimLineDenials cld
                  join #Checks c on c.CheckId = cld.CheckId
          where   isnull(cld.RecordDeleted, 'N') = 'N'        
        
  update  c
  set     UpdateClaimLineDenials = 'N'
  from    #Checks c
  where   exists ( select *
                   from   #Denials d
                   where  d.CheckId = c.CheckId )        
        
  -- First time creating 835 file for the check        
  if exists ( select  *
              from    #Checks
              where   UpdateClaimLineDenials is null ) 
    begin        
      insert  into #Denials
              (ClaimLineDenialId,
               ClaimLineId,
               CheckId,
               DenialReason,
               DenialReasonName)
              select  cld.ClaimLineDenialId,
                      cld.ClaimLineId,
                      ch.CheckId,
                      cld.DenialReason,
                      cld.DenialReasonName
              from    #Checks ch
                      join Sites s on s.ProviderId = ch.ProviderId
                      join Claims c on c.SiteId = s.SiteId
                                       and c.InsurerId = ch.InsurerId
                      join ClaimLines cl on cl.ClaimId = c.ClaimId
                      join ClaimlineDenials cld on cld.ClaimlineId = cl.ClaimlineId
              where   ch.UpdateClaimLineDenials is null
                      and cld.DenialLetterId is null
                      and cld.CheckId is null
                      and cld.CreatedDate < ch.CreatedDate
                      and isnull(cl.NeedsToBeWorked, 'N') = 'N'
                      and isnull(c.RecordDeleted, 'N') = 'N'
                      and isnull(cl.RecordDeleted, 'N') = 'N'
                      and isnull(cld.RecordDeleted, 'N') = 'N'
                      and not exists ( select *
                                       from   #Denials d
                                       where  d.CheckId = ch.CheckId )        
   
      update  c
      set     UpdateClaimLineDenials = 'Y'
      from    #Checks c
      where   UpdateClaimLineDenials is null
              and exists ( select *
                           from   #Denials d
                           where  d.CheckId = c.CheckId )        
    end        
        
  insert  into #Claims
          (CheckId,
           ClientId,
           ClaimId,
           ClaimLineId,
           SiteId,
           Status,
           FromDate,
           ToDate,
           BillingCodeId,
           Modifier1,
           Modifier2,
           Modifier3,
           Modifier4,
           ClaimedAmount,
           PaidAmount,
           NotCoveredAmount,
		   PaidUnits)	-- MJ 7/19/2018
          select  d.CheckId,
                  c.ClientId,
                  cl.ClaimId,
                  cl.ClaimLineId,
                  c.SiteId,
                  cl.Status,
                  cl.FromDate,
                  cl.ToDate,
                  cl.BillingCodeId,
                  nullif(cl.Modifier1, ''),
                  nullif(cl.Modifier2, ''),
                  nullif(cl.Modifier3, ''),
                  nullif(cl.Modifier4, ''),
                  cl.ClaimedAmount,
                  0,
                  cl.ClaimedAmount,
				  CAST(ISNULL(cl.Units,0) AS INT)	-- MJ 7/19/2018
          from    #Denials d
                  join ClaimLines cl on cl.ClaimLineId = d.ClaimLineId
                  join Claims c on c.ClaimId = cl.ClaimId
          where   not exists ( select *
                               from   #Claims c2
                               where  c2.ClaimLineId = cl.ClaimLineId )                        
       
  -- Get Line Item Control Number submitted in the 837
  update  c
  set     LineItemControlNumber = cl.LineItemControlNumber
  from    #Claims c
          join dbo.Import837BatchClaimLines cl on cl.ClaimLineId = c.ClaimLineId
  where   isnull(cl.RecordDeleted, 'N') = 'N'
        
  -- Get units paid from adjudications	-- MJ 7/19/2018
  update  cl
  set     cl.PaidUnits = cast(isnull(a.UnitsApproved, 0) as int)
  from    #Claims cl
          join CheckAdjudications ca on ca.CheckId = cl.CheckId
          join Adjudications a on a.AdjudicationId = ca.AdjudicationId
  where   cl.ClaimLineId = a.ClaimLineId
          and cl.PaidUnits is null
          and isnull(ca.RecordDeleted, 'N') = 'N'
          and isnull(a.RecordDeleted, 'N') = 'N'
              
  -- Get units paid from ClaimLines	-- MJ 7/19/2018
  update  c
  set     c.PaidUnits = cast(isnull(cl.Units, 0) as int)
  from    #Claims c
          join ClaimLines cl on cl.ClaimLineId = c.ClaimLineId
  where   c.ClaimId = cl.ClaimId
          and c.PaidUnits is null
          and isnull(cl.RecordDeleted, 'N') = 'N'

  -- Get Denial reasons         
  update  cl
  set     DenialReason = d.DenialReason
  from    #Claims cl
          join #Denials d on d.ClaimlineId = cl.ClaimlineId
                             and d.CheckId = cl.CheckId        

        
  update  cl
  set     DenialReason = a.DenialReason
  from    #Claims cl
          join Adjudications a on a.ClaimLineId = cl.ClaimLineId
  where   cl.ClaimedAmount <> cl.PaidAmount
          and cl.DenialReason is null
          and a.DenialReason is not null
          and isnull(a.RecordDeleted, 'N') = 'N'
          and not exists ( select *
                           from   Adjudications a2
                           where  a2.ClaimLineId = a.ClaimLineId
                                  and a2.DenialReason is not null
                                  and a2.AdjudicationId > a.AdjudicationId
                                  and isnull(a2.RecordDeleted, 'N') = 'N' )                         

  if exists ( select  *
              from    #Checks
              where   UpdateClaimLineDenials = 'Y' ) 
    begin        
                 
      -- Update ClaimlineDenials table with the check ID of the check being created                  
      update  cld
      set     CheckId = d.CheckId,
              ModifiedBy = @UserCode,
              ModifiedDate = getdate()
      from    ClaimlineDenials cld
              join #Denials d on d.ClaimLineDenialId = cld.ClaimLineDenialId
              join #Checks c on c.CheckId = d.CheckId
      where   c.UpdateClaimLineDenials = 'Y'        
        
    end                      
 
  -- Get provider address
  insert  into #Sites
          (SiteId,
           ProviderId)
          select  s.SiteId,
                  s.ProviderId
          from    #Checks c
                  join Providers p on p.ProviderId = c.ProviderId
                  join Sites s on s.ProviderId = p.ProviderId
          where   isnull(s.RecordDeleted, 'N') = 'N'
                  and exists ( select *
                               from   #Claims cl
                               where  cl.SiteId = s.SiteId ) 
                
  insert  into #Addresses
          (ProviderId,
           SiteId,
           SiteAddressId,
           Priority)
          select  s.ProviderId,
                  s.SiteId,
                  sa.SiteAddressId,
                  1
          from    #Checks c
                  join Providers p on p.ProviderId = c.ProviderId
                  join Sites s on s.SiteId = p.PrimarySiteId
                  join SiteAddressess sa on sa.SiteId = s.SiteId
                                            and sa.Billing = 'Y'
          where   isnull(s.RecordDeleted, 'N') = 'N'
                  and isnull(sa.RecordDeleted, 'N') = 'N'                
                
  insert  into #Addresses
          (ProviderId,
           SiteId,
           SiteAddressId,
           Priority)
          select  s.ProviderId,
                  s.SiteId,
                  sa.SiteAddressId,
                  2
          from    #Sites s
                  join SiteAddressess sa on sa.SiteId = s.SiteId
                                            and sa.Billing = 'Y'
          where   isnull(sa.RecordDeleted, 'N') = 'N'
                  and not exists ( select *
                                   from   #Addresses ad
                                   where  ad.SiteAddressId = sa.SiteAddressId )                
                
  insert  into #Addresses
          (ProviderId,
           SiteId,
           SiteAddressId,
           Priority)
          select  s.ProviderId,
                  s.SiteId,
                  sa.SiteAddressId,
                  case when sa.AddressType = @AddressTypeOffice then 3
                       else 4
                  end
          from    #Checks c
                  join Providers p on p.ProviderId = c.ProviderId
                  join Sites s on s.SiteId = p.PrimarySiteId
                  join SiteAddressess sa on sa.SiteId = s.SiteId
          where   isnull(s.RecordDeleted, 'N') = 'N'
                  and isnull(sa.RecordDeleted, 'N') = 'N'
                  and not exists ( select *
                                   from   #Addresses ad
                                   where  ad.SiteAddressId = sa.SiteAddressId )                
                
  insert  into #Addresses
          (ProviderId,
           SiteId,
           SiteAddressId,
           Priority)
          select  s.ProviderId,
                  s.SiteId,
                  sa.SiteAddressId,
                  case when sa.AddressType = @AddressTypeOffice then 5
                       else 6
                  end
          from    #Sites s
                  join SiteAddressess sa on sa.SiteId = s.SiteId
          where   isnull(sa.RecordDeleted, 'N') = 'N'
                  and not exists ( select *
                                   from   #Addresses ad
                                   where  ad.SiteAddressId = sa.SiteAddressId )                

  update  c
  set     ProviderAddress = sa.Address,
          ProviderCity = sa.City,
          ProviderState = sa.State,
          ProviderZip = sa.Zip
  from    #Checks c
          join #Addresses a on a.ProviderId = c.ProviderId
          join SiteAddressess sa on sa.SiteAddressId = a.SiteAddressId
  where   not exists ( select *
                       from   #Addresses a2
                       where  a2.ProviderId = a.ProviderId
                              and a2.Priority < a.Priority ) 
                      
  -- Generate 835 file
  create table #HIPAAHeaderTrailer (
  AuthorizationIdQualifier varchar(2) null,
  AuthorizationId varchar(10) null,
  SecurityIdQualifier varchar(2) null,
  SecurityId varchar(10) null,
  InterchangeSenderQualifier varchar(2) null,
  InterchangeSenderId varchar(15) null,
  InterchangeReceiverQualifier varchar(2) null,
  InterchangeReceiverId varchar(15) null,
  InterchangeDate varchar(6) null,
  InterchangeTime varchar(4) null,
  InterchangeControlStandardId varchar(1) null,
  InterchangeControlVersionNumber varchar(5) null,
  InterchangeControlNumberHeader varchar(9) null,
  AcknowledgeRequested varchar(1) null,
  UsageIndicator varchar(1) null,
  ComponentSeparator varchar(10) null,
  FunctionalIdCode varchar(2) null,
  ApplicationSenderCode varchar(15) null,
  ApplicationReceiverCode varchar(15) null,
  FunctionalDate varchar(8) null,
  FunctionalTime varchar(4) null,
  GroupControlNumberHeader varchar(9) null,
  ResponsibleAgencyCode varchar(2) null,
  VersionCode varchar(12) null,
  NumberOfTransactions varchar(6) null,
  GroupControlNumberTrailer varchar(9) null,
  NumberOfGroups varchar(6) null,
  InterchangeControlNumberTrailer varchar(9) null,
  InterchangeHeaderSegment varchar(max) null,
  FunctionalHeaderSegment varchar(max) null,
  FunctionalTrailerSegment varchar(max) null,
  InterchangeTrailerSegment varchar(max) null,)

  create table #835TransactionSegments (
  CheckId int null,
  ClaimId int null,
  ClaimLineId int null,
  SegmentLevel int null,
  SegmentNumber int null,
  SegmentCode varchar(6) null,
  TransactionSetCode varchar(max) null)  
	  
  select top 1
          @InsurerNPI = i.NationalProviderId
  from    #Checks c
          join Insurers i on i.InsurerId = c.InsurerId
       
  select top 1
          @ProviderId = p.ProviderId,
          @ProviderNPI = s.NationalProviderId
  from    #Checks c
          join Providers p on p.ProviderId = c.ProviderId
          left join Sites s on s.SiteId = p.PrimarySiteId              
              
  if @ProviderNPI is null 
    begin
      select top 1
              @ProviderNPI = s.NationalProviderId
      from    #Claims c
              join Sites s on s.SiteId = c.SiteId
      where   s.NationalProviderId is not null          
    end              
	  
  insert  into #HIPAAHeaderTrailer
          (AuthorizationIdQualifier,
           AuthorizationId,
           SecurityIdQualifier,
           SecurityId,
           InterchangeSenderQualifier,
           InterchangeSenderId,
           InterchangeReceiverQualifier,
           InterchangeReceiverId,
           InterchangeDate,
           InterchangeTime,
           InterchangeControlStandardId,
           InterchangeControlVersionNumber,
           InterchangeControlNumberHeader,
           AcknowledgeRequested,
           UsageIndicator,
           ComponentSeparator,
           FunctionalIdCode,
           ApplicationSenderCode,
           ApplicationReceiverCode,
           FunctionalDate,
           FunctionalTime,
           GroupControlNumberHeader,
           ResponsibleAgencyCode,
           VersionCode,
           NumberOfTransactions,
           GroupControlNumberTrailer,
           NumberOfGroups,
           InterchangeControlNumberTrailer)
          select  '00' -- AuthorizationIdQualifier  
                  ,space(10) -- AuthorizationId  
                  ,'00' -- SecurityIdQualifier
                  ,space(10) -- SecurityId
                  ,'ZZ' -- InterchangeSenderQualifier - ZZ - Mutually Defined  
                  ,right(replicate('0', 15) + @InsurerNPI, 15)  -- InterchangeSenderId
                  ,'ZZ'  -- InterchangeReceiverQualifier
                  ,right(replicate('0', 15) + @ProviderNPI, 15) -- InterchangeReceiverId 
                  ,convert(char(6), @DateTimeNow, 12)  -- InterchangeDate
                  ,substring(convert(char(8), @DateTimeNow, 108), 1, 2) + substring(convert(char(8), @DateTimeNow, 108), 4, 2) -- InterchangeTime  
                  ,'U' -- InterchangeControlStandardId
                  ,'00501' -- InterchangeControlVersionNumber
                  ,right(replicate('0', 9) + convert(varchar, @BatchId), 9) -- InterchangeControlNumberHeader
                  ,'0' -- AcknowledgeRequested
                  ,'P' -- UsageIndicator
                  ,':' -- ComponentSeparator
                  ,'HP' -- FunctionalIdCode  
                  ,@InsurerNPI -- ApplicationSenderCode
                  ,@ProviderNPI -- ApplicationReceiverCode
                  ,convert(char(8), @DateTimeNow, 112) -- FunctionalDate
                  ,substring(convert(char(8), @DateTimeNow, 108), 1, 2) + substring(convert(char(8), @DateTimeNow, 108), 4, 2) -- FunctionalTime  
                  ,left(convert(varchar, @BatchId), 9) -- GroupControlNumberHeader
                  ,'X' -- ResponsibleAgencyCode  
                  ,'005010X221A1' -- VersionCode
                  ,(select count(*)
                   from   #Checks) -- NumberOfTransactions
                  ,left(convert(varchar, @BatchId), 9) -- GroupControlNumberTrailer
                  ,'1' -- NumberOfGroups
                  ,right(replicate('0', 9) + convert(varchar, @BatchId), 9) -- InterchangeControlNumberTrailer  	                  

  --  
  -- Execute custom logic  
  --  
  if object_id('dbo.scsp_CMCreateDocument835', 'P') is not null 
    begin    
      exec dbo.scsp_CMCreateDocument835 
        @BatchId = @BatchId
    end
 

  update  #HIPAAHeaderTrailer
  set     InterchangeHeaderSegment = 'ISA' + '*' + AuthorizationIdQualifier + '*' + AuthorizationId + '*' + SecurityIdQualifier + '*' + SecurityId + '*' + InterchangeSenderQualifier + '*' + InterchangeSenderId + '*' + InterchangeReceiverQualifier + '*' + InterchangeReceiverId + '*' + InterchangeDate + '*' + InterchangeTime + '*' + InterchangeControlStandardId + '*' + InterchangeControlVersionNumber + '*' + InterchangeControlNumberHeader + '*' + AcknowledgeRequested + '*' + UsageIndicator + '*' + ComponentSeparator + '~',
          FunctionalHeaderSegment = 'GS' + '*' + FunctionalIdCode + '*' + LTRIM(RTRIM(ApplicationSenderCode)) + '*' + ApplicationReceiverCode + '*' + FunctionalDate + '*' + FunctionalTime + '*' + GroupControlNumberHeader + '*' + ResponsibleAgencyCode + '*' + VersionCode + '~',	-- MJ 7/19/2018
          FunctionalTrailerSegment = 'GE' + '*' + NumberOfTransactions + '*' + GroupControlNumberTrailer + '~',
          InterchangeTrailerSegment = 'IEA' + '*' + NumberOfGroups + '*' + InterchangeControlNumberTrailer + '~'   

  -- Transaction set header
  insert  into #835TransactionSegments
          (CheckId,
           SegmentLevel,
           SegmentNumber,
           SegmentCode,
           TransactionSetCode)
          select  c.CheckId,
                  1,
                  1000,
                  'ST',
                  'ST' + +'*' + '835' + '*' + convert(varchar, c.CheckId) + '~'
          from    #Checks c

  -- Financial Info  
  insert  into #835TransactionSegments
          (CheckId,
           SegmentLevel,
           SegmentNumber,
           SegmentCode,
           TransactionSetCode)
          select  c.CheckId,
                  1,
                  1010,
                  'BPR',
                  'BPR' + '*' + 'I' + '*' + convert(varchar, c.CheckAmount) + '*' + 'C' + '*' + 'CHK' + '*' + '*' + '*' + '*' + '*' + '*' + '*' + '*' + '*' + '*' + '*' + '*' + convert(char(8), c.CheckDate, 112) + '~'
          from    #Checks c

  -- Reassociation Trace Number
  insert  into #835TransactionSegments
          (CheckId,
           SegmentLevel,
           SegmentNumber,
           SegmentCode,
           TransactionSetCode)
          select  c.CheckId,
                  1,
                  1020,
                  'TRN',
                  'TRN' + '*' + '1' + '*' + c.CheckNumber + '*' + '1' + convert(varchar, c.InsurerTaxId) + '~'
          from    #Checks c

  -- Payer Identification  
  insert  into #835TransactionSegments
          (CheckId,
           SegmentLevel,
           SegmentNumber,
           SegmentCode,
           TransactionSetCode)
          select  c.CheckId,
                  1,
                  1030,
                  'N1',
                  'N1' + '*' + 'PR' + '*' + left(c.InsurerName, 60) + '~'
          from    #Checks c
  
  -- Payer Address  
  insert  into #835TransactionSegments
          (CheckId,
           SegmentLevel,
           SegmentNumber,
           SegmentCode,
           TransactionSetCode)
          select  c.CheckId,
                  1,
                  1040,
                  'N3',
                  'N3' + '*' + left(isnull(c.InsurerAddress, ''), 55) + '~'
          from    #Checks c
  
  -- Payer City, State, Zip  
  insert  into #835TransactionSegments
          (CheckId,
           SegmentLevel,
           SegmentNumber,
           SegmentCode,
           TransactionSetCode)
          select  c.CheckId,
                  1,
                  1050,
                  'N4',
                  'N4' + '*' + isnull(c.InsurerCity, '') + '*' + isnull(c.InsurerState, '') + '*' + isnull(c.InsurerZip, '') + '~'
          from    #Checks c

  -- Payer Technical contact info  
  insert  into #835TransactionSegments
          (CheckId,
           SegmentLevel,
           SegmentNumber,
           SegmentCode,
           TransactionSetCode)
          select  c.CheckId,
                  1,
                  1060,
                  'PER',
                  'PER' + '*' + 'BL' + '*' + isnull(c.InsurerContactName, '') + '*' + 'TE' + '*' + isnull(c.InsurerContactPhone, '') + '~'
          from    #Checks c

  -- Payee identification  
  insert  into #835TransactionSegments
          (CheckId,
           SegmentLevel,
           SegmentNumber,
           SegmentCode,
           TransactionSetCode)
          select  c.CheckId,
                  1,
                  1070,
                  'N1',
                  'N1' + '*' + 'PE' + '*' + left(c.ProviderName, 60) + '*' + 'XX' + '*' + isnull(@ProviderNPI, '') + '~'
          from    #Checks c

  -- Payee Address  
  insert  into #835TransactionSegments
          (CheckId,
           SegmentLevel,
           SegmentNumber,
           SegmentCode,
           TransactionSetCode)
          select  c.CheckId,
                  1,
                  1080,
                  'N3',
                  'N3' + '*' + left(isnull(c.ProviderAddress, ''), 55) + '~'
          from    #Checks c

  -- Payee City, State, Zip  
  insert  into #835TransactionSegments
          (CheckId,
           SegmentLevel,
           SegmentNumber,
           SegmentCode,
           TransactionSetCode)
          select  c.CheckId,
                  1,
                  1090,
                  'N4',
                  'N4' + '*' + isnull(c.ProviderCity, '') + '*' + isnull(c.ProviderState, '') + '*' + isnull(c.ProviderZip, '') + '~'
          from    #Checks c

  -- LX - HEADER NUMBER  
  insert  into #835TransactionSegments
          (CheckId,
           SegmentLevel,
           SegmentNumber,
           SegmentCode,
           TransactionSetCode)
          select  c.CheckId,
                  1,
                  1100,
                  'LX',
                  'LX' + '*' + '1' + '~'
          from    #Checks c

  -- CLP - CLAIM PAYMENT INFORMATION
  insert  into #835TransactionSegments
          (CheckId,
           ClaimId,
           SegmentLevel,
           SegmentNumber,
           SegmentCode,
           TransactionSetCode)
          select  c.CheckId,
                  clp.ClaimId,
                  2,
                  2000,
                  'CLP',
                  'CLP' + '*' + isnull(max(cm.PatientAccountNumber), '0') + '*' + case when sum(clp.PaidAmount) < 0 then '22' -- Reversal of Previous Payment  -- MJ 7/19/2018
																					   WHEN count(clp.ClaimLineId) = count(d.ClaimLineId) then '4' -- Denied   -- MJ 7/19/2018                                                                                    
                                                                                       when max(cl.EOBReceived) = 'Y' then '2' -- Processed as Secondary
                                                                                       else '1' -- Processed as Primary
                                                                                  end + '*' + convert(varchar, sum(clp.ClaimedAmount)) + '*' + convert(varchar, sum(clp.PaidAmount)) + '*' + '*' + 'ZZ' + '*' + convert(varchar, clp.ClaimId) + -- Payer Claim Control Number
                  '~'
          from    #Checks c
                  join #Claims clp on clp.CheckId = c.CheckId
                  join Claims cm on cm.ClaimId = clp.ClaimId
                  join ClaimLines cl on cl.ClaimLineId = clp.ClaimLineId
                  left join #Denials d on d.ClaimLineId = clp.ClaimLineId
          group by c.CheckId,
                  clp.ClaimId    
 
  -- NM1 - PATIENT NAME
  insert  into #835TransactionSegments
          (CheckId,
           ClaimId,
           SegmentLevel,
           SegmentNumber,
           SegmentCode,
           TransactionSetCode)
          select  c.CheckId,
                  clp.ClaimId,
                  2,
                  2010,
                  'NM1',
                  'NM1' + '*' + 'QC' + '*' + '1' + '*' + isnull(max(cl.LastName), '') + '*' + isnull(max(cl.FirstName), '') + '*' + isnull(max(cl.MiddleName), '') + '*' + '*' + isnull(max(cl.Suffix), '') + '*' + 'MI' + '*' + convert(varchar, max(cl.ClientId)) + '~'
          from    #Checks c
                  join #Claims clp on clp.CheckId = c.CheckId
                  join Clients cl on cl.ClientId = clp.ClientId
          group by c.CheckId,
                  clp.ClaimId    

  -- SVC - SERVICE PAYMENT INFORMATION
  insert  into #835TransactionSegments
          (CheckId,
           ClaimId,
           ClaimLineId,
           SegmentLevel,
           SegmentNumber,
           SegmentCode,
           TransactionSetCode)
          select  c.CheckId,
                  clp.ClaimId,
                  clp.ClaimLineId,
                  2,
                  2020,
                  'SVC',
                  'SVC' + '*' + 'HC' + ':' + isnull(bc.BillingCode, '') + case when clp.Modifier1 is not null then ':' + clp.Modifier1
                                                                               else ''
                                                                          end + 
																		  case when clp.Modifier2 is not null then ':' + clp.Modifier2
                                                                               else ''
                                                                          end + 
																		  case when clp.Modifier3 is not null then ':' + clp.Modifier3
                                                                               else ''
                                                                          end + 
																		  case when clp.Modifier4 is not null then ':' + clp.Modifier4
                                                                               else ''
                                                                          end + '*' + 
																		  convert(varchar, clp.ClaimedAmount) + '*' + 
																		  convert(varchar, clp.PaidAmount) + 
																		  CASE WHEN ISNULL(clp.PaidUnits,0) = 0 THEN '' -- MJ 7/19/2018
																				ELSE '**' + CAST(clp.PaidUnits AS VARCHAR(15)) END  + -- MJ 7/19/2018
																		  '~'
          from    #Checks c
                  join #Claims clp on clp.CheckId = c.CheckId
                  left join BillingCodes bc on bc.BillingCodeId = clp.BillingCodeId
       
  -- DTM - SERVICE DATE
  insert  into #835TransactionSegments
          (CheckId,
           ClaimId,
           ClaimLineId,
           SegmentLevel,
           SegmentNumber,
           SegmentCode,
           TransactionSetCode)
          select  c.CheckId,
                  clp.ClaimId,
                  clp.ClaimLineId,
                  2,
                  2030,
                  'DTM',
                  'DTM' + '*' + '150' + '*' + convert(char(8), clp.FromDate, 112) + '~'
          from    #Checks c
                  join #Claims clp on clp.CheckId = c.CheckId

  insert  into #835TransactionSegments
          (CheckId,
           ClaimId,
           ClaimLineId,
           SegmentLevel,
           SegmentNumber,
           SegmentCode,
           TransactionSetCode)
          select  c.CheckId,
                  clp.ClaimId,
                  clp.ClaimLineId,
                  2,
                  2040,
                  'DTM',
                  'DTM' + '*' + '151' + '*' + convert(char(8), clp.ToDate, 112) + '~'
          from    #Checks c
                  join #Claims clp on clp.CheckId = c.CheckId

  insert  into #835TransactionSegments
          (CheckId,
           ClaimId,
           ClaimLineId,
           SegmentLevel,
           SegmentNumber,
           SegmentCode,
           TransactionSetCode)
          select  c.CheckId,
                  clp.ClaimId,
                  clp.ClaimLineId,
                  2,
                  2045,
                  'CAS',
                  'CAS' + '*' + 'CO' + '*' + gcdr.ExternalCode1 + '*'  + 
				  convert(varchar, clp.ClaimedAmount - (clp.PaidAmount + isnull(clp.CopayAmount, 0))) + '~'
          from    #Checks c
                  join #Claims clp on clp.CheckId = c.CheckId
				  join GlobalCodes gcdr on gcdr.GlobalCodeId = clp.DenialReason
	      where   gcdr.ExternalCode1 is not null
		          and clp.ClaimedAmount - (clp.PaidAmount + isnull(clp.CopayAmount, 0)) <> 0
		  			   
  insert  into #835TransactionSegments
          (CheckId,
           ClaimId,
           ClaimLineId,
           SegmentLevel,
           SegmentNumber,
           SegmentCode,
           TransactionSetCode)
          select  c.CheckId,
                  clp.ClaimId,
                  clp.ClaimLineId,
                  2,
                  2046,
                  'CAS',
                  'CAS' + '*' + 'PR' + '*' + '2' + '*'  + 
				  convert(varchar, clp.CopayAmount) + '~'
          from    #Checks c
                  join #Claims clp on clp.CheckId = c.CheckId
	      where   isnull(clp.CopayAmount, 0) <> 0

  -- REF - LINE ITEM CONTROL NUMBER
  insert  into #835TransactionSegments
          (CheckId,
           ClaimId,
           ClaimLineId,
           SegmentLevel,
           SegmentNumber,
           SegmentCode,
           TransactionSetCode)
          select  c.CheckId,
                  clp.ClaimId,
                  clp.ClaimLineId,
                  2,
                  2050,
                  'REF*6R',
                  'REF*6R' + '*' + clp.LineItemControlNumber + '~'
          from    #Checks c
                  join #Claims clp on clp.CheckId = c.CheckId
          where   clp.LineItemControlNumber is not null
 			
   -- SE - TRANSACTION SET TRAILER				   
  insert  into #835TransactionSegments
          (CheckId,
           SegmentLevel,
           SegmentNumber,
           SegmentCode,
           TransactionSetCode)
          select  c.CheckId,
                  3,
                  3000,
                  'SE',
                  'SE' + '*' + convert(varchar, count(*) + 1) + '*' + convert(varchar, c.CheckId) + '~'
          from    #Checks c
                  join #835TransactionSegments ts on ts.CheckId = c.CheckId
          group by c.CheckId        
			
  declare @Header varchar(max)
  declare @Trailer varchar(max)
			
  select  @Header = InterchangeHeaderSegment + FunctionalHeaderSegment
  from    #HIPAAHeaderTrailer
	
  select  @Trailer = FunctionalTrailerSegment + InterchangeTrailerSegment
  from    #HIPAAHeaderTrailer
		
  create table #File (FileText varchar(max))

  insert  into #File
          (FileText)
          select  @Header + (select TransactionSetCode as [text()]
                             from   #835TransactionSegments ts
                             order by ts.CheckId,
                                    ts.SegmentLevel,
                                    ts.ClaimId,
                                    ts.ClaimLineId,
                                    ts.SegmentNumber
                  for        xml path('')) + @Trailer

  update  b
  set     [835FileText] = FileText,
          Status = 22
  from    Export835Batches b
          cross join #File f
  where   Export835BatchId = @BatchId   

  update  c
  set     [835FileText] = b.[835FileText]
  from    Export835Batches b
          join Export835BatchChecks bc on bc.Export835BatchId = b.Export835BatchId
          join Checks c on c.CheckId = bc.CheckId
  where   b.Export835BatchId = @BatchId
  
  select top 1
          b.[835FileText]
  from    Export835Batches b
          join dbo.Export835BatchChecks bc on bc.Export835BatchId = b.Export835BatchId
          join Checks c on c.CheckId = bc.CheckId
  where   b.Export835BatchId = @BatchId  

end try
begin catch

  select  @ErrorNumber = error_number(),
          @ErrorSeverity = error_severity(),
          @ErrorState = error_state(),
          @ErrorLine = error_line(),
          @ErrorProcedure = isnull(error_procedure(), '-')

  select  @ErrorMessage = 'Error %d, Level %d, State %d, Procedure %s, Line %d, ' + 'Message: ' + error_message()
 
  if @@trancount > 0 
    rollback transaction

  raiserror(@ErrorMessage, @ErrorSeverity, 1, @ErrorNumber, @ErrorSeverity, @ErrorState, @ErrorProcedure, @ErrorLine)


end catch

return

go
