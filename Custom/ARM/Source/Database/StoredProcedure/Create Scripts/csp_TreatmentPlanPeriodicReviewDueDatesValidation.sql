/****** Object:  StoredProcedure [dbo].[csp_TreatmentPlanPeriodicReviewDueDatesValidation]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_TreatmentPlanPeriodicReviewDueDatesValidation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_TreatmentPlanPeriodicReviewDueDatesValidation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_TreatmentPlanPeriodicReviewDueDatesValidation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE   procedure [dbo].[csp_TreatmentPlanPeriodicReviewDueDatesValidation]      
 /* Param List */      
 @ClientId INT,      
 @ServiceId INT,      
 @ProcedureCodeId INT,      
 @ClinicianId INT,      
 @StartDate DateTime,      
-- @EndDate DateTime,      
-- @Attending VARCHAR(10),      
-- @DSMCode1 VARCHAR(10),      
-- @DSMCode2 VARCHAR(10),      
-- @DSMCode3 VARCHAR(10),      
 @ServiceCompletionStatus VARCHAR(10),      
 @ProgramId int,      
-- @LocationId int,      
-- @Degree int,      
-- @UnitValue decimal(9,2),      
-- @Count int,      
-- @ServiceAlreadyCompleted char(1),      
 @Billable char(1)      
-- @DoesNotRequireStaffForService char(1),      
-- @PreviousStatus int      
      
      
AS      
      
      
      
DECLARE      
 @TxPlanDate varchar(150),      
 @TxPlanDueDate varchar(150),      
 @TxPlanNextPeriodic varchar(50),      
 @TxPlanDocumentId int,      
 @TxPlanCurrentDocumentVersionId int ,       
 @PeriodicReviewDueDate varchar(150),      
 @LastPeriodicReview varchar(150) ,      
 @LastPeriodicDueDate varchar(150) ,      
 @PeriodicDocumentId int ,      
 @PeriodicCurrentDocumentVersionId int       
       
       
      
      
-- Find Treatment Plan Date      
select @TxPlanDate = convert(varchar(50), d.effectiveDate, 101),      
@TxPlanDueDate = convert(varchar(50), dateadd(yy, 1, d.effectivedate),101),      
@TxPlanDocumentId = d.DocumentId,      
@TxPlanCurrentDocumentVersionId = d.CurrentDocumentVersionId,      
@TxPlanNextPeriodic = convert(varchar(50), case when PeriodicReviewDueDate is null and PeriodicReviewFrequencyUnitType = ''Month(s)''      
             then dateadd(mm, tp.PeriodicReviewFrequencyNumber, d.effectivedate )       
             when PeriodicReviewDueDate is null and PeriodicReviewFrequencyUnitType = ''Week(s)''      
             then dateadd(wk, tp.PeriodicReviewFrequencyNumber, d.effectivedate )       
            else PeriodicReviewDueDate  end ,      
       101)      
From Documents d       
Join TpGeneral tp on tp.DocumentVersionId = d.CurrentDocumentVersionId --and tp.Version = d.CurrentVersion  commented by Sahil in ref of Task #11 on April 21,2010    
where d.ClientId = @clientId      
and d.DocumentCodeId in  (2, 350)      
and d.Status = 22 and isnull(d.RecordDeleted, ''N'') = ''N''      
and @StartDate >= d.EffectiveDate       
and @StartDate <= convert(varchar(50), dateadd(yy, 1, d.effectivedate),101)      
and d.documentid in (select tpg.DocumentVersionId from tpGeneral tpg      
   where  tpg.PlanOrAddendum = ''T''      
   and tpg.DocumentVersionId = d.CurrentDocumentVersionId    
   --and tpg.Version = d.CurrentVersion  commented by Sahil in ref of Task #11 on April 21,2010    
   and isnull(tpg.RecordDeleted, ''N'') = ''N'')      
      
and not exists (select * from documents d2      
  join TPGeneral tpg2 on tpg2.DocumentVersionId = d2.DocumentId --and tpg2.Version = d2.CurrentVersion   commented by Sahil in ref of Task #11 on April 21,2010    
  where d2.ClientId = d.ClientId      
  and tpg2.PlanOrAddendum = ''T''      
  and d2.DocumentCodeId in  (2, 350)      
  and d2.Status = 22      
  and @StartDate >= d2.EffectiveDate       
  and @StartDate <= convert(varchar(50), dateadd(yy, 1, d2.effectivedate),101)      
  and d2.EffectiveDate > d.EffectiveDate      
  and isnull(d2.RecordDeleted, ''N'') = ''N'')      
and isnull(d.recorddeleted, ''N'') = ''N''      
      
If isnull(@TxPlanDueDate, '''') = ''''      
BEGIN      
Set @TxPlanDueDate = ''01/01/1900''      
END      
      
If  @StartDate not between @TxPlanDate and @TxPlanDueDate      
and @ServiceCompletionStatus=''Completed'' and @Billable=''Y''      
and Not Exists (Select * From CustomTreatmentPlanServiceRuleExceptions tpe      
    where (tpe.ClientId = @ClientId      
      OR tpe.ServiceId = @ServiceId      
      OR tpe.ServiceProgramId = @ProgramId      
      OR tpe.ProcedureCodeId = @ProcedureCodeId      
      OR tpe.ClinicianId = @ClinicianId)      
    and (tpe.BeginDate <= @StartDate or isnull(tpe.NoBeginDate, ''N'') = ''Y'')      
    and (tpe.EndDate >= @StartDate or isnull(tpe.NoEndDate, ''N'') = ''Y'')      
    and isnull(tpe.RecordDeleted, ''N'') = ''N'')      
Begin       
  insert into serviceErrors(ServiceId,ErrorType,ErrorMessage,ErrorSeverity)        
  Values (@ServiceId, 11047, ''Signed Treatment Plan missing for this date of service.'', ''E'')      
END      
      
      
      
      
      
      
      
-- Find Last Periodic Review Date      
select @LastPeriodicReview = convert(varchar(50), d.effectivedate, 101),      
@LastPeriodicDueDate =  convert(varchar(50), case when pr.NextReviewDate is null and len(isnull(Pr.NextPeriodicReviewYear, 0)) = 4 then      
     convert(varchar(20), convert(varchar(2),NextPeriodicReviewMonth) + ''/''+ convert(varchar(20),  case when NextPeriodicReviewMonth in (2) and datepart(d, d.effectivedate) >28 then ''28''      
                              when NextPeriodicReviewMonth in (4, 6, 9, 11) and datepart(d, d.effectivedate) >30 then ''30''      
                              else convert(varchar(20), datepart(d, d.effectivedate)) end)      
               + ''/'' + isnull(convert(varchar(4), Pr.NextPeriodicReviewYear) , ''''))      
      else pr.NextReviewDate end ,101),      
@PeriodicDocumentId = d.DocumentId,      
@PeriodicCurrentDocumentVersionId = d.CurrentDocumentVersionId     
From Documents d       
Left Join PeriodicReviews pr on pr.DocumentVersionId = d.DocumentId-- and pr.Version = d.CurrentVersion   commented by Sahil in ref of Task #11 on April 21,2010    
where d.ClientId = @ClientID       
and d.DocumentCodeId in (3, 352)      
and d.Status = 22       
and d.documentid not in (296524)      
and @StartDate >= @TxPlanDate      
and @StartDate <= @TxPlanDueDate      
and isnull(d.RecordDeleted, ''N'') = ''N''      
and not exists (select * from documents d2      
  where d2.ClientId = d.ClientId      
  and d2.DocumentCodeId in (3, 352)      
  and d2.Status = 22      
  and d.documentid not in (296524)      
  and @StartDate >= @TxPlanDate      
  and @StartDate <= @TxPlanDueDate      
  and d2.EffectiveDate > d.EffectiveDate      
  and isnull(d2.RecordDeleted, ''N'') = ''N'')      
      
      
If isnull(@LastPeriodicReview, '''') = ''''      
Begin       
Set @LastPeriodicReview = ''01/01/1900''      
Set @LastPeriodicDueDate = ''01/01/1900''      
END      
      
      
set @PeriodicReviewDueDate =       
    case when isnull(convert(datetime, @TxPlanDate, 101), ''01/01/1900'') > isnull(convert(datetime, @LastPeriodicReview, 101), ''01/01/1900'')       
      then convert(varchar(50),@TxPlanNextPeriodic,101)      
      
           when isnull(convert(datetime, @TxPlanDate, 101), ''01/01/1900'') < isnull(convert(datetime, @LastPeriodicReview, 101), ''01/01/1900'')       
      then convert(varchar(50), @LastPeriodicDueDate, 101)      
              
       else null end      
      
      
      
If  @StartDate between @TxPlanDate and @TxPlanDueDate      
and @StartDate >= @PeriodicReviewDueDate      
and @ServiceCompletionStatus=''Completed'' and @Billable=''Y''      
Begin       
  insert into serviceErrors(ServiceId,ErrorType,ErrorMessage,ErrorSeverity)        
  Values (@ServiceId, 11048, ''Signed Periodic Review missing for this date of service.'', ''E'')      
END      
      
      
      
-- Delete Periodic Review Errors for HabWaiver Clients      
If Exists (select * from clients c      
join clientprograms cp on cp.clientid = c.clientid      
where --status = 4 --Enrolled      
 enrolleddate <= @StartDate      
and (dischargeddate >= @StartDate or dischargeddate is null)      
and programid = 4 -- Hab Waiver      
and c.ClientId = @ClientId      
and isnull(c.RecordDeleted, ''N'') = ''N''      
and isnull(cp.RecordDeleted, ''N'') = ''N'')      
      
and @ServiceCompletionStatus=''Completed'' and @Billable=''Y''      
      
Begin      
Delete From ServiceErrors      
Where ServiceId = @ServiceId      
and ErrorType = 11048      
End      
      
      
      
-- Delete Periodic Review or Treatment Plan Errors for Medical Services primary Clients      
If Exists (select * from clients c      
join clientprograms cp on cp.clientid = c.clientid      
where --status = 4 --Enrolled      
 enrolleddate <= @StartDate      
and (dischargeddate >= @StartDate or dischargeddate is null)      
and programid in  (9, --Medical Services - Downtown      
     10,  --Medical Services - Lakeview      
     11)  --Medical Services - Albion      
and cp.PrimaryAssignment = ''Y''      
and c.ClientId = @ClientId      
and isnull(c.RecordDeleted, ''N'') = ''N''      
and isnull(cp.RecordDeleted, ''N'') = ''N'')      
      
and @ServiceCompletionStatus=''Completed'' and @Billable=''Y''      
      
Begin      
Delete From ServiceErrors      
Where ServiceId = @ServiceId      
and ErrorType in (11048, 11047)      
End
' 
END
GO
