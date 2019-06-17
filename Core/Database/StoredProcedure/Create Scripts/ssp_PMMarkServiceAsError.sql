if object_id('dbo.ssp_PMMarkServiceAsError') is not null 
  drop procedure dbo.ssp_PMMarkServiceAsError
go

create procedure dbo.ssp_PMMarkServiceAsError
  @ServiceId int,
  @UserCode varchar(30),
  @RetStatus int,
  @PreviousServiseCompleteStatus varchar(10)
 /*********************************************************************                      
-- Stored Procedure: dbo.ssp_PMMarkServiceAsError                      
--                      
-- Copyright: 2006 Streamline Healthcare Solutions                      
--                      
-- Purpose: Mark service as error                      
--                      
-- Return:                      
--          @RetStatus=0 - Successfully deleted the service.                      
--          @RetStatus=1 - Cannot set service to error.  Payments still exist for this service.                      
--          @RetStatus=2 - Signed document exists for this service.  Document must be moved or deleted before continuing.                      
--          @RetStatus=3 - Document update failed.  Contact tech support.                      
--          @RetStatus=4 - Service delete failed.  Could not update Services table.  Contact tech support.                      
--          @RetStatus=5 - Appointment delete failed.  Could not update Appointments table.  Contact tech support.                      
--          @RetStatus=6 - Error in generating Financial Activity.  Contact tech support.                      
--          @RetStatus=7 - Error in generating Financial Activity Lines.  Contact tech support.                      
--          @RetStatus=8 - Error in generating ARLedger.  Contact tech support.                      
--          @RetStatus=9 - Mark service as Error failed.  Could not update Services table.  Contact tech support.                      
--          @RetStatus=10 - Authorization Update Failed.  Could not update Services table.  Contact tech support.                      
--                      
-- Updates:                       
--  Date         Author       Purpose                      
-- 01.18.2007    SFarber      Fixed inserts into FinancialActvityLines and ARLedger tables.                      
-- 13.06.2012    MSuma        Modified Condition to check Balance                     
-- 03.07.2012    Shifali      Modified - Added Status Check Error Along with Complete when setting Services.RecorDeleted = 'Y'  
--                            Above Change is for Harbor Only, we need to discuss with SHS team before executing for other client's environment  
-- 05.07.2012    MSuma        Fix for PayerPayment   
-- 20.07.2012    jagdeep      Add check 'select ChargeId from #TempCharges where Balance <> 0' As per task-449 Group Service:-Exception occurred while trying to delete the client service - Threshold 3.5x Merged Issues   
-- 21 Sep 2012   Shifali      Modified - Added sql stmt to delete record from table DocumentSignatures as well as we doing for Documents/DocumentSignatures  
-- 20 Nov 2012   Shifali      Modified - When Service becomes Error then delete the unsigned versions if Status = 22 but currentversionStatus <> 22   
--                            (Ref Task# 2258 - Thresholds Bugs/Features)
-- 13 Feb 2013   Vikas        What: Added One more paramete "@PreviousServiseCompleteStatus" For Complete Service Mark as Error  
--                            Why: Made changes w.r.t Task# ServicesDeleted functionality.  
-- 09 Oct 2015   Shankha      For Services with Signed Documents modified to logic to NOT include Status = @ServiceCompleteStatus 
-- 03.03.2016    SFarber      Fixed Clients.CurrentBalance calculation    
-- 19.May.2016   Dknewtson    Allowing services to be marked as error when there is a payment attached.  Also removed Payment from reversal process.
-- 06 July 2016  Manjunath K  Added Condition to show validation based on AllowServiceErrorWithPayment Configuration Value.
							  Why: Valley - Support Go Live #472.
--12 April 2017  TRemisoski	  Delete in-progress document version and set back to current document version if the note has an in progress version when the service is marked as error
                              Why:Bear River - Support Go Live#109	
--30 April 2017  Pranay       Document with Status 26 Should not be Record Deleted	
--28 July 2017	 Govind		  what - Updated ServiceId in the Bed Attendance Record to Null
							  why - CareLink Implementation Task#7	
--18 Dec 2017	 Chita Ranjan what - Commented delete statement which was deleteing associated record from OpenCharges table when we make a service as error.
							  why  - Camino - Support Go Live #424.1
--03 April 2018  Vijeta       If Document with Status 26 Should not be Record Deleted the DocumentVersions and DocumentSignatures also should not be deleted for non-deleted Documents	
                			  why  - 	Woods - Support Go Live #864		  						  
--11 May 2018	tchen		 What: When a service status is changed from Complete to Error, implemented logic to update ClaimLineItems
							 Why: Engineering Improvement Initiatives #615.1
-- 02 Aug 2018 P.Narayana    What : Added the Custom sp scsp_PMMarkServiceAsError (Task #1004  CEI - Enhancements)
                             Why:To delete delete the generated CM event and Hospital record when user mark the prescreen service note as error
-- 27 Sep 2018	M. Jensen	 What: Delete OpenCharges record when balance is 0.00 and update oherwise.
							 Why:  Change of 18Dec2017 leaving OpenCharges rows with wrong balance.

-- 15 Oct 2018  Lakshmi      What: If the service is error out then the charge should be set to 0.00 (As per the approve from core commite)
							 Why:  CHC - Enhancements #254	

-- 11 Jan 2018 P. Narayana	What: Moved the hook scsp_PMMarkServiceAsError outside constrain.
                            Why: Requested in CEI - Enhancements: #1004 to move th  hook scsp_PMMarkServiceAsError outside constrain
 						  							 
**********************************************************************/
as 
declare @Payment int,
  @SignedDocument int,
  @FinancialActivityId int,
  @FinancialActivityLineId int,
  @FinancialServiceDeleted int,
  @ServiceErrorStatus int,
  @ServiceCompleteStatus int  

declare @errorMessage nvarchar(max)  
declare @ERROR nvarchar(max)  
  
select  @Payment = 4202,
        @SignedDocument = 22,
        @FinancialServiceDeleted = 4327,
        @ServiceErrorStatus = 76,
        @ServiceCompleteStatus = 75,
        @RetStatus = 0  
  
create table #TempCharges (
ChargeId int,
Balance money,
LedgerType int,
CoveragePlanId int,
ClientId int)  
  
insert  into #TempCharges
        (ChargeId,
         Balance,
         LedgerType)
        select  AR.ChargeId,
                sum(AR.Amount),
                AR.LedgerType
        from    ARLedger AR
                inner join Charges Ch on (AR.ChargeId = Ch.ChargeId)
        where   Ch.ServiceId = @ServiceId
        group by AR.CHargeId,
                AR.LedgerType  

DECLARE @AllowServiceErrorWithPayment CHAR(1)

SELECT @AllowServiceErrorWithPayment = ISNULL(LEFT(dbo.ssf_GetSystemConfigurationKeyValue('ALLOWSERVICEERRORWITHPAYMENT'),1),'N')
  
if @@rowcount > 0 
  begin  
    if exists ( select  balance
                from    #TempCharges
                where   LedgerType = @Payment
                        and balance <> 0
						and @AllowServiceErrorWithPayment= 'N') --06 July 2016  Manjunath K  
      begin  

        set @ERROR = dbo.Ssf_GetMesageByMessageCode(323, 'SERVICENOTDELETED_SSP', 'Service Can not be deleted since balance of the payment is not zero')  
  
        RAISERROR (
				@ERROR
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				); 
  
        set @errorMessage = dbo.Ssf_GetMesageByMessageCode(323, 'SERVICENOTDELETED_SSP', 'Service Can not be deleted since balance of the payment is not zero')  
 
        set @RetStatus = 1  
  
        return @RetStatus  
      end  
  end  
  
create table #TempDocuments (
DocumentId int,
Status int,
CurrentDocumentVersionId int,
CurrentVersionStatus int,
InProgressDocumentVersionId int)  
  
insert  into #TempDocuments
        select  a.DocumentId,
                a.Status,
                CurrentDocumentVersionId,
                CurrentVersionStatus,
                InProgressDocumentVersionId
        from    Documents a
        where   a.ServiceId = @ServiceId
                and isnull(a.RecordDeleted, 'N') = 'N'
  
begin transaction TranServiceDelete  
  
if (@PreviousServiseCompleteStatus = 'Y') 
  begin  
    insert  into ServicesDeleted
            (ServiceId,
             CreatedBy,
             CreatedDate,
             ModifiedBy,
             ModifiedDate)
    values  (@ServiceId,
             @UserCode,
             getdate(),
             @UserCode,
             getdate())  
  end  
  
-- Check for Signed Documents attached to this service.  If they exist, quit
if exists ( select  *
            from    #TempDocuments
            where   Status = @SignedDocument ) 
  begin  
    if exists ( select  *
                from    Services
                where   ServiceId = @ServiceId ) -- and Status = @ServiceCompleteStatus)        -09 Oct 2015 Shankha      
      begin  
        --Added By KamaljitSingh ref task#748                    
        update  Services
        set     Status = @ServiceErrorStatus,
                ModifiedBy = @UserCode,
                ModifiedDate = getdate(),
                Charge=0.00   -- Added by Lakshmi on 15 Oct 2018
        where   serviceId = @ServiceId  

        -- 12 April 2017 T.Remisoski
		begin try
			if exists (
				select *
				from #TempDocuments as td
				join Documents as d on d.DocumentId = td.DocumentId
				where d.CurrentDocumentVersionId <> d.InProgressDocumentVersionId
			)
			begin
				-- remove in-progress document versions and signatures
				-- technically, should not be any document sigantures on the in-progress version but coding against possible future core changes
				update ds set
					RecordDeleted = 'Y',
					DeletedDate = getdate(),
					DeletedBy = @UserCode
				from #TempDocuments as td
				join Documents as d on d.DocumentId = td.DocumentId
				join DocumentSignatures as ds on ds.SignedDocumentVersionId = d.InProgressDocumentVersionId

				update dv set
					RecordDeleted = 'Y',
					DeletedDate = getdate(),
					DeletedBy = @UserCode
				from #TempDocuments as td
				join Documents as d on d.DocumentId = td.DocumentId
				join DocumentVersions as dv on dv.DocumentVersionId = d.InProgressDocumentVersionId

				-- "erase" the fact that an in-progress document version ever existed.
				update d set
					InProgressDocumentVersionId = d.CurrentDocumentVersionId,
					CurrentVersionStatus = d.Status
				from #TempDocuments as td
				join Documents as d on d.DocumentId = td.DocumentId


				

			end
		end try
		begin catch
			set @RetStatus = 3  
 
			set @ERROR = dbo.Ssf_GetMesageByMessageCode(29, 'DOCUPDATEFAILED_SSP', 'Document Update Failed.Contact your System Administrator.')  
  
			  RAISERROR (
					@ERROR
					,-- Message text.                                                                     
					16
					,-- Severity.                                                            
					1 -- State.                                                         
					); 
  
			set @errorMessage = dbo.Ssf_GetMesageByMessageCode(29, 'DOCUPDATEFAILED_SSP', 'Document Update Failed.Contact your System Administrator.')  
  
			goto Finalize  		
		end catch
        -- 12 April 2017 T.Remisoski - End changes
		  
        /* Application needs to accept @RetStatus 4.  Status means: Signed Document exists for this service.  Document must be moved or deleted before continuing.*/  
        set @RetStatus = 0  
  
        -- Raiserror 50000 'Signed Document exists for this service.  Document must be moved or deleted before continuing.'                       
        goto Finalize    
      end
  
    /*Shifali Changes Start Here*/  
   
    update  DV
    set     RecordDeleted = 'Y',
            DeletedDate = getdate(),
            DeletedBy = @UserCode
    from    DocumentVersions DV
            inner join #TempDocuments b on DV.DocumentId = b.DocumentId
    where   DV.DocumentVersionId > b.CurrentDocumentVersionId  
  
    update  DS
    set     RecordDeleted = 'Y',
            DeletedDate = getdate(),
            DeletedBy = @UserCode
    from    DocumentSignatures DS
            inner join #TempDocuments b on DS.DocumentId = b.DocumentId
    where   DS.SignatureDate is null  
  
    update  D
    set     D.InProgressDocumentVersionId = D.CurrentDocumentVersionId,
            D.CurrentVersionStatus = D.Status
    from    Documents D
            inner join #TempDocuments b on D.DocumentId = b.DocumentId  
    /*Ends Here*/  
    
  end  
  /* RJN 09/26/2006 Check for Un-Signed Documents attached to this service.  If they exist, change their Status(s) to deleted.*/  
else 
  if exists ( select  *
              from    #TempDocuments
              where   Status <> @SignedDocument ) 
    begin  
      --Begin Tran DocumentDelete                      
      update  a
      set     RecordDeleted = CASE WHEN b.status =26 THEN NULL ELSE 'Y'END,
              DeletedDate = CASE WHEN b.status =26 THEN NULL ELSE getdate() END,
              DeletedBy =CASE WHEN b.status =26 THEN NULL ELSE @UserCode END
      from    Documents a
              inner join #TempDocuments b on a.DocumentId = b.DocumentId  
  
      update  C
      set     RecordDeleted = CASE WHEN b.status =26 THEN NULL ELSE 'Y'END,
              DeletedDate = CASE WHEN b.status =26 THEN NULL ELSE getdate() END,
              DeletedBy =CASE WHEN b.status =26 THEN NULL ELSE @UserCode END
      from    DocumentVersions C
              inner join #TempDocuments b on C.DocumentId = b.DocumentId  
  
      --Added by shifali on 21stSept2012  
      update  DS
      set     RecordDeleted = CASE WHEN b.status =26 THEN NULL ELSE 'Y'END,
              DeletedDate = CASE WHEN b.status =26 THEN NULL ELSE getdate() END,
              DeletedBy =CASE WHEN b.status =26 THEN NULL ELSE @UserCode END
      from    DocumentSignatures DS
              inner join #TempDocuments b on DS.DocumentId = b.DocumentId  
  
      --Changes by shifali ends here  
      if @@error <> 0 
        begin  
          --Rollback Tran DocumentDelete                      
          set @RetStatus = 3  
 
          set @ERROR = dbo.Ssf_GetMesageByMessageCode(29, 'DOCUPDATEFAILED_SSP', 'Document Update Failed.Contact your System Administrator.')  
  
          RAISERROR (
				@ERROR
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				); 
  
          set @errorMessage = dbo.Ssf_GetMesageByMessageCode(29, 'DOCUPDATEFAILED_SSP', 'Document Update Failed.Contact your System Administrator.')  
  
          goto Finalize  
        end  
    end  
  
/* RJN 09/28/2006 If the existing Status is anything other than Complete, set the RecordDeleted = 'Y' otherwise A/R rollback will need to occur.*/  
if exists ( select  *
            from    Services
            where   ServiceId = @ServiceId
                    and Status not in (@ServiceCompleteStatus, @ServiceErrorStatus) ) 
  begin  
    update  Services
    set     RecordDeleted = 'Y',
            DeletedDate = getdate(),
            DeletedBy = @UserCode
    where   ServiceId = @ServiceId  
  
    --Added By KamaljitSingh ref task#748                    
    update  a
    set     RecordDeleted = 'Y',
            DeletedDate = getdate(),
            DeletedBy = @UserCode
    from    Documents a
            inner join #TempDocuments b on a.DocumentId = b.DocumentId  
  
    update  C
    set     RecordDeleted = 'Y',
            DeletedDate = getdate(),
            DeletedBy = @UserCode
    from    DocumentVersions C
            inner join #TempDocuments b on C.DocumentId = b.DocumentId  
  
    --End of added       
    --Added by shifali on 21stSept2012  
    update  DS
    set     RecordDeleted = 'Y',
            DeletedDate = getdate(),
            DeletedBy = @UserCode
    from    DocumentSignatures DS
            inner join #TempDocuments b on DS.DocumentId = b.DocumentId  
  
    --Changes by shifali ends here  
    if (@@error <> 0) 
      begin  
        set @RetStatus = 4 -- Service delete failed.  Could not update Services table.  Contact tech support.                      
  
        goto Finalize  
      end  
  
    update  Appointments
    set     RecordDeleted = 'Y',
            DeletedDate = getdate(),
            DeletedBy = @UserCode
    where   ServiceId = @ServiceId  
  
    if (@@error <> 0) 
      begin  
        set @RetStatus = 5 -- Appointment delete failed.  Could not update Appointments table.  Contact tech support.                      

        set @ERROR = dbo.Ssf_GetMesageByMessageCode(352, 'APPOINTMENTDELETEFAILED_SSP', 'Appointment delete failed. Could not update Appointments table. Contact tech support.')  
  
        
          RAISERROR (
				@ERROR
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				);  
  
        set @errorMessage = dbo.Ssf_GetMesageByMessageCode(352, 'APPOINTMENTDELETEFAILED_SSP', 'Appointment delete failed. Could not update Appointments table. Contact tech support.')  
  
        goto Finalize --This would get handled by the next Finalize, but just in case additional checking is added.                      
      end  
  
    -- JHB 4/18/07                      
    exec ssp_PMServiceAuthorizations 
      @CurrentUser = @UserCode,
      @ServiceId = @ServiceId,
      @ServiceDeleted = 'Y' -- Bhupinder Bajwa 12 Jan 2007 REF Task # 285                      
  
    if (@@error <> 0) 
      begin  
        set @RetStatus = 10 -- Appointment delete failed.  Could not update Appointments table.  Contact tech support.                      
 
        set @ERROR = dbo.Ssf_GetMesageByMessageCode(404, 'AUTHORIZATIONUPDATEFAILED_SSP', 'Authorization Update Failed. Contact tech support.')  
  
        
          RAISERROR (
				@ERROR
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				); 
  
        set @errorMessage = dbo.Ssf_GetMesageByMessageCode(404, 'AUTHORIZATIONUPDATEFAILED_SSP', 'Authorization Update Failed. Contact tech support.')  
  
        goto Finalize --This would get handled by the next Finalize, but just in case additional checking is added.                      
      end  
  
    goto Finalize --If nothing fails @RetStatus should be 0 and the transaction should commit.                      
  end  
  
--If Charge exists reverse financial activities                      
if exists ( select  ChargeId
            from    #TempCharges ) 
  begin  
    insert  into FinancialActivities
            (ActivityType,
             CreatedBy,
             CreatedDate,
             ModifiedBy,
             ModifiedDate,
             RecordDeleted)
    values  (@FinancialServiceDeleted,
             @UserCode,
             getdate(),
             @UserCode,
             getdate(),
             'N')  
  
    if (@@error <> 0) 
      begin  
        set @RetStatus = 6 --Financial Activity can not be created                      
 
        set @ERROR = dbo.Ssf_GetMesageByMessageCode(8, 'FINANCIALACTIVITYERROR_SSP', 'Error in generating Financial Activity. Contact tech support.')  
  
        
          RAISERROR (
				@ERROR
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				);   
  
        set @errorMessage = dbo.Ssf_GetMesageByMessageCode(8, 'FINANCIALACTIVITYERROR_SSP', 'Error in generating Financial Activity. Contact tech support.')  
  
        goto Finalize  
      end  
    else 
      begin  
        select  @FinancialActivityId = max(FinancialActivityId)
        from    FinancialActivities  
  
        print 'FinancialActivityId=' + convert(varchar(10), @FinancialActivityId)  
      end  
  
    --Create new financial activity lines record       
    if exists ( select  ChargeId
                from    #TempCharges
                where   Balance <> 0 ) 
      begin  
        insert  into FINANCIALACTIVITYLINES
                (FinancialActivityId,
                 ChargeId,
                 CurrentVersion,
                 Flagged,
                 Comment,
                 CreatedBy,
                 CreatedDate,
                 ModifiedBy,
                 ModifiedDate,
                 RecordDeleted)
                select  @FinancialActivityId,
                        min(tc.ChargeId),
                        1,
                        'N',
                        'Service Deleted',
                        @UserCode,
                        getdate(),
                        @UserCode,
                        getdate(),
                        'N'
                from    #TempCharges tc
                where   Balance <> 0 -- SFarber 1.18.2007                      
                AND tc.LedgerType <> @Payment
      end  
  
    if (@@error <> 0) 
      begin  
        set @RetStatus = 7 --Financial Activity Lines can not be created                      

        set @ERROR = dbo.Ssf_GetMesageByMessageCode(394, 'FINANCIALACTIVITYLINESERROR_SSP', 'Error in generating Financial Activity Lines. Contact tech support.')  
  
        
          RAISERROR (
				@ERROR
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				);   
  
        set @errorMessage = dbo.Ssf_GetMesageByMessageCode(8, 'FINANCIALACTIVITYERROR_SSP', 'Error in generating Financial Activity. Contact tech support.')  
  
        goto Finalize  
      end  
    else 
      begin  
        select  @FinancialActivityLineId = max(FinancialActivityLineId)
        from    FinancialActivityLines  
  
        print 'FinancialActivityLineId=' + convert(varchar(10), @FinancialActivityLineId)  
      end  
  
    -- Block added to update client Balance (Bhupinder Bajwa REF Task # 204)                      
    update  tc
    set     CoveragePlanId = arl.CoveragePlanId,
            ClientId = arl.ClientId
    from    #TempCharges tc
            inner join ARLedger arl on arl.ChargeId = tc.ChargeId
                                       and arl.LedgerType = tc.LedgerType  
  
    declare @clientId int  
  
    select  @clientId = ClientId
    from    Services
    where   ServiceId = @ServiceId  
  
    update  a
    set     a.CurrentBalance = isnull(a.CurrentBalance, 0) - isnull((select sum(tc.Balance)
                                                                     from   #TempCharges tc
                                                                     where  tc.CoveragePlanId is null
                                                                            and tc.LedgerType <> @Payment
                                                                            and tc.ClientId = @clientId), 0)
    from    Clients a
    where   a.clientId = @clientId
            and isnull(a.RecordDeleted, 'N') = 'N'  
  
    if (@@error <> 0) 
      begin  
        set @RetStatus = 8 --Error in updating client balance                      
 
        set @ERROR = dbo.Ssf_GetMesageByMessageCode(98, 'ARLEDGERERROR_SSP', 'Error in generating ARLedger. Contact tech support.')  
   
        
          RAISERROR (
				@ERROR
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				);   
  
        set @errorMessage = dbo.Ssf_GetMesageByMessageCode(98, 'ARLEDGERERROR_SSP', 'Error in generating ARLedger. Contact tech support.')  
  
        goto Finalize  
      end  
  
    --insert negative entries for the current charges in the ARLedger                      
    insert  into ARLedger
            (ChargeId,
             FinancialActivityLineId,
             FinancialActivityVersion,
             LedgerType,
             Amount,
             PaymentId,
             AdjustmentCode,
             AccountingPeriodId,
             PostedDate,
             ClientId,
             CoveragePlanId,
             DateOfService,
             MarkedAsError,
             ErrorCorrection,
             CreatedBy,
             CreatedDate,
             ModifiedBy,
             ModifiedDate)
            select  arl.ChargeId,
                    @FinancialActivityLineId,
                    1,
                    arl.LedgerType,
                    max(tc.Balance) * -1,
                    max(arl.PaymentId),
                    max(arl.AdjustmentCode),
                    max(ap.AccountingPeriodId),
                    getdate(),
                    max(arl.ClientId),
                    max(arl.CoveragePlanId),
                    max(DateOfService),
                    null,
                    null,
                    @UserCode,
                    getdate(),
                    @UserCode,
                    getdate()
            from    ARLedger arl
                    inner join #TempCharges tc on arl.ChargeId = tc.ChargeId
                                                  and arl.LedgerType = tc.LedgerType
                    inner join AccountingPeriods ap on datediff(day, ap.StartDate, getdate()) >= 0
                                                       and datediff(day, ap.EndDate, getdate()) <= 0
            where   tc.Balance <> 0 -- SFarber 1.18.2007                      
                    AND tc.LedgerType <> @Payment
            group by arl.ChargeId,
                    arl.LedgerType  
  
    if (@@error <> 0) 
      begin  
        set @RetStatus = 8 --Error in generating ARLedger                      

        set @ERROR = dbo.Ssf_GetMesageByMessageCode(98, 'ARLEDGERERROR_SSP', 'Error in generating ARLedger. Contact tech support.')  
  
        
          RAISERROR (
				@ERROR
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				);   
  
        set @errorMessage = dbo.Ssf_GetMesageByMessageCode(98, 'ARLEDGERERROR_SSP', 'Error in generating ARLedger. Contact tech support.')  
  
        goto Finalize  
      end  
  
    delete  a     
    from    OpenCharges a
    where   exists ( select *
                     from   #TempCharges b
                     where  a.ChargeId = b.ChargeId )  
			AND (
				SELECT SUM(ar.amount)
				FROM dbo.ARLedger ar
				WHERE ar.ChargeId = a.ChargeId
				AND ISNULL(ar.RecordDeleted, 'N') = 'N'
				) = 0.00
  
    if (@@error <> 0) 
      begin  
        set @RetStatus = 10 --Error in generating ARLedger                      

        set @ERROR = dbo.Ssf_GetMesageByMessageCode(29, 'OPENCHARGESERROR_SSP', 'Error deleting Open Charges. Contact tech support.')  
  
        
          RAISERROR (
				@ERROR
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				);  
  
        set @errorMessage = dbo.Ssf_GetMesageByMessageCode(29, 'OPENCHARGESERROR_SSP', 'Error deleting Open Charges. Contact tech support.')  
  
        goto Finalize  
      end  

		UPDATE a
		SET a.Balance = tot.bal
			,a.ModifiedBy = @UserCode
			,a.ModifiedDate = GETDATE()
		FROM OpenCharges a
		CROSS APPLY (
			SELECT SUM(ar.Amount) AS bal
			FROM dbo.ARLedger ar
			WHERE ar.ChargeId = a.chargeid
				AND ISNULL(ar.RecordDeleted, 'N') = 'N'
			) tot
		WHERE EXISTS (
				SELECT *
				FROM #TempCharges b
				WHERE a.ChargeId = b.ChargeId
				)
			AND a.Balance <> tot.bal
				  
    if (@@error <> 0) 
      begin  
        set @RetStatus = 10 --Error in generating ARLedger                      

        set @ERROR = dbo.Ssf_GetMesageByMessageCode(29, 'OPENCHARGESERROR_SSP', 'Error updating Open Charges. Contact tech support.')  
  
        
          RAISERROR (
				@ERROR
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				);  
  
        set @errorMessage = dbo.Ssf_GetMesageByMessageCode(29, 'OPENCHARGESERROR_SSP', 'Error updating Open Charges. Contact tech support.')  
  
        goto Finalize  
      end 
  end -- Processing picks up here is no charge exists                      


--Update Bed Attendance Record - (Logic Added for CareLink Implementation - Task #7)

update  BedAttendances
set     ServiceId = null,
		ModifiedBy = @UserCode,
        ModifiedDate = getdate()
where   serviceId = @ServiceId  

  
update  Services
set     Status = @ServiceErrorStatus,
        ModifiedBy = @UserCode,
        ModifiedDate = getdate(),
        Charge=0.00 -- Added by Lakshmi on 15 Oct 2018
where   serviceId = @ServiceId  
  
if (@@error <> 0) 
  begin  
    set @RetStatus = 9 --Mark service as Error failed.  Could not update Services table.  Contact tech support.                      

    set @ERROR = dbo.Ssf_GetMesageByMessageCode(29, 'MARKSERVICEERROR_SSP', 'Mark service as Error failed. Could not update Services table. Contact tech support.')  
  
    
          RAISERROR (
				@ERROR
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				);   
  
    set @errorMessage = dbo.Ssf_GetMesageByMessageCode(29, 'MARKSERVICEERROR_SSP', 'Mark service as Error failed. Could not update Services table. Contact tech support.')  
  
    goto Finalize  
  end  
  
update  Appointments
set     RecordDeleted = 'Y',
        DeletedDate = getdate(),
        DeletedBy = @UserCode
where   ServiceId = @ServiceId  
  
if (@@error <> 0) 
  begin  
    set @RetStatus = 5 -- Appointment delete failed.  Could not update Appointments table.  Contact tech support.                      

    set @ERROR = dbo.Ssf_GetMesageByMessageCode(352, 'APPOINTMENTDELETEFAILED_SSP', 'Appointment delete failed. Could not update Appointments table. Contact tech support.')  
  
    
          RAISERROR (
				@ERROR
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				);   
  
    set @errorMessage = dbo.Ssf_GetMesageByMessageCode(352, 'APPOINTMENTDELETEFAILED_SSP', 'Appointment delete failed. Could not update Appointments table. Contact tech support.')  
  
    goto Finalize --This would get handled by the next Finalize, but just in case additional checking is added.                      
  end  
  
exec ssp_PMServiceAuthorizations 
  @CurrentUser = @UserCode,
  @ServiceId = @ServiceId,
  @ServiceDeleted = 'Y' -- Bhupinder Bajwa 12 Jan 2007 REF Task # 285                      
 -- JHB 4/18/07                      
  
if (@@error <> 0) 
  begin  
    set @RetStatus = 10 -- Appointment delete failed.  Could not update Appointments table.  Contact tech support.                      

    set @ERROR = dbo.Ssf_GetMesageByMessageCode(352, 'APPOINTMENTDELETEFAILED_SSP', 'Appointment delete failed. Could not update Appointments table. Contact tech support.')  
  
    
          RAISERROR (
				@ERROR
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				);   
  
    set @errorMessage = dbo.Ssf_GetMesageByMessageCode(404, 'AUTHORIZATIONUPDATEFAILED_SSP', 'Authorization Update Failed. Contact tech support.')  
  
    goto Finalize --This would get handled by the next Finalize, but just in case additional checking is added.                      
  end  
  
/*tchen 5/11/2018: Engineering Improvement Initiatives #615.1*/
IF OBJECT_ID('tempdb..#ClaimLineItemFlagStage') IS NOT NULL
    DROP TABLE #ClaimLineItemFlagStage

CREATE TABLE #ClaimLineItemFlagStage ( ClaimLineItemId INT, PlanDoesNotAllowClaimResubmission CHAR(1))

--Find the most recently billed ClaimLineItemId for each charge and populate #ClaimLineItemFlagStage table
;
WITH Base
    AS ( SELECT c.ChargeId,
                c.ClientCoveragePlanId,
                cli.ClaimLineItemId,
                cli.ToBeVoided,
                cli.ToBeResubmitted,
                cli.VoidedClaim,
                cli.ResubmittedClaim,
                cli.ModifiedBy,
                cli.ModifiedDate,
                cb.BilledDate
         FROM   Charges              AS c
         JOIN   ClaimLineItemCharges AS clic ON c.ChargeId = clic.ChargeId
                                                AND ISNULL(clic.RecordDeleted, 'N') = 'N'
         JOIN   ClaimLineItems       AS cli ON clic.ClaimLineItemId = cli.ClaimLineItemId
                                               AND ISNULL(cli.RecordDeleted, 'N') = 'N'
         JOIN   ClaimLineItemGroups  AS clig ON cli.ClaimLineItemGroupId = clig.ClaimLineItemGroupId
                                                AND  ISNULL(clig.RecordDeleted, 'N') = 'N'
         JOIN   ClaimBatches         AS cb ON clig.ClaimBatchId = cb.ClaimBatchId
                                              AND   ISNULL(cb.RecordDeleted, 'N') = 'N'
         WHERE  c.ServiceId = @ServiceId
                AND ISNULL(c.RecordDeleted, 'N') = 'N' )
INSERT INTO #ClaimLineItemFlagStage ( ClaimLineItemId, PlanDoesNotAllowClaimResubmission )
            SELECT DISTINCT
                    b1.ClaimLineItemId,
                    cp.PlanDoesNotAllowClaimResubmission
            FROM    Base                AS b1
            JOIN    ClientCoveragePlans AS ccp ON b1.ClientCoveragePlanId = ccp.ClientCoveragePlanId
                                                  AND  ISNULL(ccp.RecordDeleted, 'N') = 'N'
            JOIN    CoveragePlans       AS cp ON ccp.CoveragePlanId = cp.CoveragePlanId
                                                 AND ISNULL(cp.RecordDeleted, 'N') = 'N'
            WHERE   NOT EXISTS
            (   SELECT  1
                FROM    Base AS b2
                WHERE   b1.ChargeId = b2.ChargeId
                        AND ISNULL(b2.BilledDate, '1/1/1754') > ISNULL(b1.BilledDate, '12/31/1753'))
                    AND ISNULL(b1.ToBeVoided, 'N') = 'N'
                    AND ISNULL(b1.ToBeResubmitted, 'N') = 'N'
                    AND ISNULL(b1.VoidedClaim, 'N') = 'N'
                    AND ISNULL(b1.ResubmittedClaim, 'N') = 'N'
                    AND @PreviousServiseCompleteStatus = 'Y'

--If the Claim Line Item has more than 1 service within it and at least one of them is in a Complete status and "Plan Does Not Allow Claim Resubmission" is flagged as No, then flag it as "To Be Resubmitted" 
UPDATE  cli
SET     cli.ToBeResubmitted = 'Y'
FROM    #ClaimLineItemFlagStage AS clifs
JOIN    ClaimLineItems          AS cli ON clifs.ClaimLineItemId = cli.ClaimLineItemId
                                          AND   ISNULL(cli.RecordDeleted, 'N') = 'N'
WHERE
        (   SELECT  COUNT(DISTINCT s.ServiceId)
            FROM    ClaimLineItemCharges AS clic
            JOIN    Charges              AS c ON clic.ChargeId = c.ChargeId
                                                 AND ISNULL(c.RecordDeleted, 'N') = 'N'
            JOIN    Services             AS s ON c.ServiceId = s.ServiceId
                                                 AND   ISNULL(s.RecordDeleted, 'N') = 'N'
            WHERE   ISNULL(clic.RecordDeleted, 'N') = 'N'
                    AND clifs.ClaimLineItemId = clic.ClaimLineItemId ) > 1
        AND EXISTS
(   SELECT  1
    FROM    ClaimLineItemCharges AS clic2
    JOIN    Charges              AS c2 ON clic2.ChargeId = c2.ChargeId
                                          AND   ISNULL(c2.RecordDeleted, 'N') = 'N'
    JOIN    Services             AS s2 ON c2.ServiceId = s2.ServiceId
                                          AND  ISNULL(s2.RecordDeleted, 'N') = 'N'
                                          AND  s2.Status = 75
    WHERE   ISNULL(clic2.RecordDeleted, 'N') = 'N'
            AND clifs.ClaimLineItemId = clic2.ClaimLineItemId )
        AND ISNULL(clifs.PlanDoesNotAllowClaimResubmission, 'N') = 'N'

--ELSE flag the ClaimLineItem as "To Be Voided"
UPDATE  cli
SET     cli.ToBeVoided = 'Y'
FROM    #ClaimLineItemFlagStage AS clifs
JOIN    ClaimLineItems          AS cli ON clifs.ClaimLineItemId = cli.ClaimLineItemId
                                          AND   ISNULL(cli.RecordDeleted, 'N') = 'N'
                                          AND   ISNULL(cli.ToBeResubmitted, 'N') <> 'Y'

DROP TABLE #ClaimLineItemFlagStage
/*END OF tchen 5/11/2018: Engineering Improvement Initiatives #615.1*/
Finalize:  
  
if (@RetStatus <> 0) 
  begin  
    rollback transaction TranServiceDelete  
  end  
else 
  begin  
    commit transaction TranServiceDelete   
  end  
  
 -- Caling custom SP hook scsp_PMMarkServiceAsError
		IF EXISTS ( SELECT  *
				   FROM    sys.objects
				   WHERE   OBJECT_ID = OBJECT_ID(N'[scsp_PMMarkServiceAsError]')
						   AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1 ) 
						   BEGIN
		EXEC [dbo].scsp_PMMarkServiceAsError @ServiceId,  @UserCode, @RetStatus, @PreviousServiseCompleteStatus
		END
  
select  @errorMessage as ErrorMessage,
        @RetStatus as RetStatus  
  
select  @RetStatus  
  
return @RetStatus  

go
