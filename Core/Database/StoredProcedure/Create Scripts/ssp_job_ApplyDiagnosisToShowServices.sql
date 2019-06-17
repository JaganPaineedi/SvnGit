/****** Object:  StoredProcedure [dbo].[ssp_job_ApplyDiagnosisToShowServices]    Script Date: 12/11/2016 16:08:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_job_ApplyDiagnosisToShowServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_job_ApplyDiagnosisToShowServices]
GO


/****** Object:  StoredProcedure [dbo].[ssp_job_ApplyDiagnosisToShowServices]    Script Date: 12/11/2016 16:08:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


create procedure [dbo].[ssp_job_ApplyDiagnosisToShowServices] as
/*======================================================================*/
/* Procedure: ssp_job_ApplyDiagnosisToShowServices						*/
/*																		*/
/* Purpose: Find all SHOW services with no ServiceDiagnoses and apply	*/
/*			the most recent applicable DSM5 document diagnoses to them.	*/
/*																		*/
/* Parameters: NONE														*/
/*																		*/
/* System Configuration Keys Referenced: NONE							*/
/*																		*/
/* IMPORTANT NOTES:														*/
/*	If the result set from ssp_SCBillingDiagnosiServiceNote changes,	*/
/*	the #sdx temporary table in this proc must change as well.			*/
/*																		*/
/* History:																*/
/*		T.Remisoski - 11/16/2015 - Created.								*/			
/*		T.Remisoski	- 09/01/2016 - Remove invalid dx before refreshing.	*/
/*						Tighten up transaction handling.				*/
/*      T.Remisoski - 12/11/2016 - If service has *any* diagnoses       */
/*                                  mising order, include in the        */
/*                                  recalc.                             */
/*      V.Sinha - 05/15/2018 -  The record will insert in ServiceDiagnosis only when the Services.ProcedureCodeId has DoesNotRequireBillingDiagnosis='N' */  
/*                              Task: 	AHN-Support Go Live #182        */  
/*                                                                      */ 
/*======================================================================*/


begin try

declare @c1 cursor 

declare @ServiceId int, @ClientId int, @DateOfService datetime, @ProgramId int

declare @trancount int = @@trancount
declare @NeedCommit bit = 0



create table #sdx (
	DSMCode varchar(30),
	DSMNumber int,
	SortOrder int,
	Version int,
	DiagnosisOrder int,
	DSMVCodeId int,
	ICD10Code varchar(30),
	ICD9Code varchar(30),
	Description varchar(3000),
	[Order] int
)

set @c1 = cursor static for
select
sv.ServiceId, sv.ClientId, sv.DateOfService, sv.ProgramId
from Services as sv
where sv.Status = 71
and exists (SELECT 1 From ProcedureCodes  PC 
where PC.ProcedureCodeId=sv.ProcedureCodeId
AND ISNULL(PC.DoesNotRequireBillingDiagnosis,'N')='N')
and not exists (
	select *
	from ServiceDiagnosis as sd
	where sd.ServiceId = sv.ServiceId
	and sd.[Order] is not null
	and isnull(sd.RecordDeleted, 'N') = 'N'
	and not exists (
		select *
		from ServiceDiagnosis as sd2
		where sd2.ServiceId = sd.ServiceId
		and sd2.[Order] is null
		and ISNULL(sd2.RecordDeleted, 'N') = 'N'
	)
)
and isnull(sv.RecordDeleted, 'N') = 'N'



open @c1

fetch @c1 into @ServiceId, @ClientId, @DateOfService, @ProgramId

while @@FETCH_STATUS = 0
begin

	if @trancount = 0
	begin
		begin tran
		set @NeedCommit = 1
	end
	else
		save transaction ssp_job_ApplyDx

	delete #sdx
	
	update ServiceDiagnosis set
		RecordDeleted = 'Y',
		DeletedBy = 'SSPJOBAPPLYDX',
		DeletedDate = GETDATE()
	where ServiceId = @ServiceId
	and ISNULL(RecordDeleted, 'N') = 'N'
	

	insert into #sdx
	exec [dbo].[ssp_SCBillingDiagnosiServiceNote]
		@varClientId = @ClientId
		,@varDate = @DateOfService
		,@varProgramId = @ProgramId

	insert into ServiceDiagnosis (
		ServiceId
		,DSMCode
		,DSMNumber
		,DSMVCodeId
		,ICD10Code
		,ICD9Code
		,[Order]
	)
	select
		@ServiceId
		,DSMCode
		,DSMNumber
		,DSMVCodeId
		,ICD10Code
		,ICD9Code
		,[Order]
	from #sdx


	if @NeedCommit = 1
		commit transaction ssp_job_ApplyDx

	fetch @c1 into @ServiceId, @ClientId, @DateOfService, @ProgramId

end

close @c1

deallocate @c1


end try
begin catch

	declare @xstate int = XACT_STATE();


	if @xstate = -1 --and @trancount = 0
		rollback;
	if @xstate = 1 and @trancount = 0
		rollback;
	if @xstate = 1 and @trancount > 0
		rollback transaction ssp_job_ApplyDx;

	exec ssp_SQLErrorHandler
end catch

GO


