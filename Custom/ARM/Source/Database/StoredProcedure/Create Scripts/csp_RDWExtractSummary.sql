/****** Object:  StoredProcedure [dbo].[csp_RDWExtractSummary]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractSummary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDWExtractSummary]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractSummary]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_RDWExtractSummary]
@AffiliateId int,
@ExtractDate datetime 
/*********************************************************************
-- Stored Procedure: dbo.csp_RDWExtractSummary
-- Creation Date:    11/06/2006
--
-- Purpose: Validates extract and creates summary
--
-- Updates:
--   Date         Author      Purpose
--   11.06.2006   SFarber     Created.
--   04.30.2008   SFarber     Modified to filter out services based on custom rules.
--   01.19.2009   SFarber     Commented out code related to the Custom RDWExtractServiceFinancialHistory table.
*********************************************************************/

as

set nocount on
set ansi_warnings off

declare @ClientsCount int
declare @ProgramsCount int
declare @MedicationsCount int
declare @AuthorizationsCount int
declare @ProcedureRatesCount int
declare @ServicesCount int
declare @CoverageCount int
declare @CoverageHistoryCount int
declare @HospitalizationsCount int
declare @HabWaiverEnrollmentsCount int
declare @StaffCount int

declare @ServicesCountAll int

declare @CompletedServicesCountAll int
declare @CompletedServicesCount int
declare @ScheduledServicesCountAll int

declare @CompletedServicesCountAllPM int
declare @ScheduledServicesCountAllPM int

declare @Charges money
declare @Charges2 money
declare @ChargesAll money
declare @ChargesAllPM money
--declare @ChargesAllSFH money

declare @Payments money
declare @Payments2 money
declare @PaymentsAll money
declare @PaymentsAllPM money
--declare @PaymentsAllSFH money

declare @Adjustments money
declare @Adjustments2 money
declare @AdjustmentsAll money
declare @AdjustmentsAllPM money
--declare @AdjustmentsAllSFH money

declare @ErrorText varchar(1000)
declare @StartDate datetime


-- Get record counts from extract

select @StartDate = RDWStartDate
  from CustomRDWExtractSummary 
 where AffiliateId = @AffiliateId

select @ClientsCount = Count(*) from CustomRDWExtractClients
select @ServicesCount = Count(*) from CustomRDWExtractServices
select @CoverageCount = Count(*) from CustomRDWExtractClientCoverages
select @CoverageHistoryCount = Count(*) from CustomRDWExtractClientCoverageHistory
select @HospitalizationsCount = Count(*) from CustomRDWExtractHospitalizations
select @HabWaiverEnrollmentsCount = Count(*) from CustomRDWExtractHabWaiverEnrollments
select @StaffCount = Count(*) from CustomRDWExtractStaff

--select @ProgramsCount = Count(*) from CustomRDWExtractPrograms
--select @MedicationsCount = Count(*) from CustomRDWExtractMedications
--select @AuthorizationsCount = Count(*) from CustomRDWExtractProcedureAuthorizations
--select @ProcedureRatesCount = Count(*) from CustomRDWExtractProcedureRates

-- Get services counts from extracts

select @CompletedServicesCount = Count(*) from CustomRDWExtractServices where Status = ''CO''

select @CompletedServicesCountAll = @CompletedServicesCount + Count(*)
  from CustomRDWExtractServicesSent ss
 where ss.Status = ''CO''
   and not exists (select * from CustomRDWExtractServices s where s.ServiceId= ss.ServiceId) 

select @ScheduledServicesCountAll = Count(*) from CustomRDWExtractServices where status IN (''SC'', ''SH'')

select @ServicesCountAll = @ScheduledServicesCountAll + Count(*) from CustomRDWExtractServicesSent


-- Get transaction counts from PracticeManagement databse

select @CompletedServicesCountAllPM = count(*)
  from Services s
 where Status = 75
   and isnull(RecordDeleted, ''N'') = ''N''
   and DateOfService >= @StartDate
   and CreatedDate <= @ExtractDate   
   and not exists(select * 
                    from CustomRDWExtractServicesCustomFilter f
                   where f.ServiceId = s.ServiceId) 

select @ScheduledServicesCountAllPM = count(*)
  from Services s
 where Status in (70, 71)
   and isnull(RecordDeleted, ''N'') = ''N''
   and DateOfService >= @StartDate
   and CreatedDate <= @ExtractDate   
   and not exists(select * 
                    from CustomRDWExtractServicesCustomFilter f
                   where f.ServiceId = s.ServiceId) 


-- Get amounts from extracts

select @Charges = sum(Charge),
       @Payments = sum(isnull(ClientPayment, 0) + isnull(MedicaidPayment, 0) + 
                       isnull(ABWPayment, 0) + isnull(MIChildPayment, 0) + isnull(GFPayment, 0) + 
                       isnull(OtherPayerPayment1, 0) + isnull(OtherPayerPayment2, 0) +
                       isnull(OtherPayerPayment3, 0) + isnull(OtherPayerPayment4, 0) +
                       isnull(OtherPayerPayment5, 0) + isnull(OtherPayerPayment6, 0)),
       @Adjustments = sum(isnull(ClientAdjustment, 0) + isnull(MedicaidAdjustment, 0) + 
                          isnull(ABWAdjustment, 0) + isnull(MIChildAdjustment, 0) + isnull(GFadjustment, 0) + 
                          isnull(OtherPayerAdjustment1, 0) + isnull(OtherPayerAdjustment2, 0) +
                          isnull(OtherPayerAdjustment3, 0) + isnull(OtherPayerAdjustment4, 0) +
                          isnull(OtherPayerAdjustment5, 0) + isnull(OtherPayerAdjustment6, 0))
  from CustomRDWExtractServices
 where Status in (''CO'', ''CA'', ''NS'')

select @Charges2 = sum(Charge),
       @Payments2 = sum(isnull(ClientPayment, 0) + isnull(MedicaidPayment, 0) + 
                        isnull(ABWPayment, 0) + isnull(MIChildPayment, 0) + isnull(GFPayment, 0) + 
                        isnull(OtherPayerPayment1, 0) + isnull(OtherPayerPayment2, 0) +
                        isnull(OtherPayerPayment3, 0) + isnull(OtherPayerPayment4, 0) +
                        isnull(OtherPayerPayment5, 0) + isnull(OtherPayerPayment6, 0)),
       @Adjustments2 = sum(isnull(ClientAdjustment, 0) + isnull(MedicaidAdjustment, 0) + 
                           isnull(ABWAdjustment, 0) + isnull(MIChildAdjustment, 0) + isnull(GFadjustment, 0) + 
                           isnull(OtherPayerAdjustment1, 0) + isnull(OtherPayerAdjustment2, 0) +
                           isnull(OtherPayerAdjustment3, 0) + isnull(OtherPayerAdjustment4, 0) +
                           isnull(OtherPayerAdjustment5, 0) + isnull(OtherPayerAdjustment6, 0))
  from CustomRDWExtractServicesSent ss
 where ss.Status in (''CO'', ''CA'', ''NS'')
   and not exists (select * from CustomRDWExtractServices s where s.ServiceId = ss.ServiceId) 

select @ChargesAll = isnull(@Charges, 0) + isnull(@Charges2, 0)
select @PaymentsAll = isnull(@Payments, 0) + isnull(@Payments2, 0)
select @AdjustmentsAll = isnull(@Adjustments, 0) + isnull(@Adjustments2, 0)


-- Get amounts from PracticeManagement database

select @ChargesAllPM = sum(case when arl.LedgerType in (4201, 4204) then arl.Amount else 0 end),
       @PaymentsAllPM = sum(case when arl.LedgerType = 4202 then arl.Amount else 0 end),
       @AdjustmentsAllPM = sum(case when arl.LedgerType = 4203 then arl.Amount else 0 end)
  from ARLedger arl
       join Charges c on c.ChargeId = arl.ChargeId
       join Services s on s.ServiceId = c.ServiceId
 where s.Status in (75, 73, 72) -- Complete/Cancel/Now Show
   and s.DateOfService >= @StartDate
   and s.CreatedDate <= @ExtractDate
   and arl.PostedDate <= @ExtractDate
   and isnull(arl.RecordDeleted, ''N'') = ''N''
   and isnull(c.RecordDeleted, ''N'') = ''N''
   and isnull(s.RecordDeleted, ''N'') = ''N''
   and not exists(select * 
                    from CustomRDWExtractServicesCustomFilter f
                   where f.ServiceId = s.ServiceId) 


/*
-- Get amounts from Service Financial History

select @ChargesAllSFH = isnull(sum(Charge), 0),
       @PaymentsAllSFH = isnull(sum(Payment), 0),
       @AdjustmentsAllSFH = isnull(sum(Adjustment), 0)
  from CustomRDWExtractServiceFinancialHistory
*/

select @ErrorText = space(0)


-- Validate coounts and amounts

if @CompletedServicesCountAll <> @CompletedServicesCountAllPM
  select @ErrorText = @ErrorText + ''Completed Serices Count in Extract - '' + 
                      convert(varchar, @CompletedServicesCountAll) + 
                      ''; Completed Services Count in PM DB - '' + 
                      convert(varchar, @CompletedServicesCountAllPM) + 
                      char(13) + char(10) 


if @ScheduledServicesCountAll <> @ScheduledServicesCountAllPM
  select @ErrorText = @ErrorText + ''Scheduled Serices Count in Extract - '' + 
                      convert(varchar, @ScheduledServicesCountAll) + 
                      ''; Scheduled Services Count in PM DB - '' + 
                      convert(varchar, @ScheduledServicesCountAllPM) +
                      char(13) + char(10) 

if @ChargesAll <> @ChargesAllPM --or @ChargesAll <> @ChargesAllSFH 
  select @ErrorText = @ErrorText + ''Charges in Extract - $'' + 
                      convert(varchar, @ChargesAll, 1) + 
                      ''; Charges in PM DB - $'' + convert(varchar, @ChargesAllPM, 1) + 
                      --''; Charges in Extract History - $'' + convert(varchar, @ChargesAllSFH, 1) + 
                      char(13) + char(10) 

if @PaymentsAll <> @PaymentsAllPM --or @PaymentsAll <> @PaymentsAllSFH
  select @ErrorText = @ErrorText + ''Payments in Extract - $'' + convert(varchar, @PaymentsAll, 1) + 
                      ''; Payments in PM DB - $'' + convert(varchar, @PaymentsAllPM, 1) + 
                      --''; Payments in Extract History - $'' + convert(varchar, @PaymentsAllSFH, 1) + 
                      char(13) + char(10) 

if @AdjustmentsAll <> @AdjustmentsAllPM --or @AdjustmentsAll <> @AdjustmentsAllSFH
  select @ErrorText = @ErrorText + ''Adjustments in Extract - $'' + convert(varchar, @AdjustmentsAll, 1) + 
                      ''; Adjustments in PM DB - $'' + convert(varchar, @AdjustmentsAllPM, 1) + 
                      --''; Adjustments in Extract History - $'' + convert(varchar, @AdjustmentsAllSFH, 1) + 
                      char(13) + char(10) 


if len(@ErrorText) > 0 
begin
  select @ErrorText = ''Failed to validate extract summary:'' + char(13) + char(10) + @ErrorText
  goto error
end


update CustomRDWExtractSummary
   set ExtractDate                  = @ExtractDate,
       ClientsCount                 = @ClientsCount,
       ServicesCount                = @ServicesCount,
       CoverageCount                = @CoverageCount,
       CoverageHistoryCount         = @CoverageHistoryCount,
       StaffCount                   = @StaffCount,
       ProgramsCount                = @ProgramsCount,
       MedicationsCount             = @MedicationsCount,
       AuthorizationsCount          = @AuthorizationsCount,
       ProcedureRatesCount          = @ProcedureRatesCount,
       HospitalizationsCount        = @HospitalizationsCount,
       HabWaiverEnrollmentsCount    = @HabWaiverEnrollmentsCount,

       CompletedServicesCount       = @CompletedServicesCount,
       ScheduledServicesCount       = @ScheduledServicesCountAll,
       Charges                      = @Charges,
       Payments                     = @Payments,
       Adjustments                  = @Adjustments,

       ServicesCountAll             = @ServicesCountAll,
       CompletedServicesCountAll    = @CompletedServicesCountAll,
       ChargesAll                   = @ChargesAll,
       PaymentsAll                  = @PaymentsAll,
       AdjustmentsAll               = @AdjustmentsAll
 where AffiliateId = @AffiliateId

if @@error <> 0 goto error

insert into CustomRDWExtractHistory (
       AffiliateId,    
       ExtractDate,
       ClientsCount,
       ProgramsCount,
       MedicationsCount,
       AuthorizationsCount,
       ServicesCount,
       ProcedureRatesCount,
       CoverageCount,
       CoverageHistoryCount,
       HospitalizationsCount,
       HabWaiverEnrollmentsCount,
       StaffCount,

       CompletedServicesCount,
       ScheduledServicesCount,
       Charges,
       Payments,
       Adjustments,

       ServicesCountAll,
       CompletedServicesCountAll,
       ChargesAll,
       PaymentsAll,
       AdjustmentsAll)
values(@AffiliateId,
       @ExtractDate,
       @ClientsCount,
       @ProgramsCount,
       @MedicationsCount,
       @AuthorizationsCount,
       @ServicesCount,
       @ProcedureRatesCount,
       @CoverageCount,
       @CoverageHistoryCount,
       @HospitalizationsCount,
       @HabWaiverEnrollmentsCount,
       @StaffCount,

       @CompletedServicesCount,
       @ScheduledServicesCountAll,
       @Charges,
       @Payments,
       @Adjustments,

       @ServicesCountAll,
       @CompletedServicesCountAll,
       @ChargesAll,
       @PaymentsAll,
       @AdjustmentsAll)
 
if @@error <> 0 goto error


return


error:

if len(@ErrorText) = 0
  set @ErrorText = ''Failed to execute csp_RDWExtractSummary''

exec csp_RDWExtractError @AffiliateId = @AffiliateId, @ErrorText = @ErrorText
' 
END
GO
