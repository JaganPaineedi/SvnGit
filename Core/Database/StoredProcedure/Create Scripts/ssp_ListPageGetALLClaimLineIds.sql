/****** Object:  StoredProcedure [dbo].[ssp_ListPageGetALLClaimLineIds]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageGetALLClaimLineIds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPageGetALLClaimLineIds]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ListPageGetALLClaimLineIds]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[ssp_ListPageGetALLClaimLineIds]
(                   
 @InsurerId int,                  
 @Status type_GlobalCode,                  
 @ProviderId varchar(MAX),                  
 @SiteId int, 
 @BankAccounts int,
 @ClaimPopulationDropdown VARCHAR(15),
 @BillingCodeModifiers varchar(MAX), 
 @DenialReasons varchar(MAX), 
 @BatchNo int,                  
 @ClaimId int,                  
 @ClaimLineNo int,  
 @ReceivedFrom varchar(15),                  
 @ReceivedTo varchar(15),                  
 @DOSFrom varchar(15),                  
 @DOSTo varchar(15),       
 @UserCode varchar(30), 
 @Populations int,                 
 @PendedDaysId int,
 @OtherFilter int ,    
 @SortExpression  varchar(50)='ClaimLineId',    
 @SortOrder varchar(4) ='asc',
 @StaffId int,
 @ReallocationExceptionFlag CHAR(1)    
)          
AS      
/*********************************************************************                                  
-- Stored Procedure: dbo.ssp_ListPageGetALLClaimLineIds      
-- Copyright: 2005 Provider Claim Management System      
-- Creation Date:  17.Aug.2015                       
--                                                       
-- Purpose	:	Retuns list of claim lines when All option is selected in ClaimLine list page. 
-- NOTE		:	1.This SP needs to be modified whenever ssp_ListPageCMGetFilteredClaimLines is modified.
				2.It is not used to load List page.             
-- Updates:                      
--  Date         Author     Purpose 
--  2 Feb 2018   PradeepT   What: Modified to include modified logic of ssp_ListPageCMGetFilteredClaimLines
--                          Whay: This sp should be modified to include the modified logic of 
---                         ssp_ListPageCMGetFilteredClaimLines whenever it would be modified As Per task KCMHSAS - Support -#960.80 
--  07 May 2018   Neelima   What: Modified the Sql query which was broken and written in a new line and hence generated incorrect sql query, bec of this the claims list when ALL is selected, and clicking on Revert claims, the validation is occuring which should not occur. Whay:  KCMHSAS - Support -#1083 
*********************************************************************/                                
Begin   
  BEGIN TRY
  
	CREATE TABLE #ResultSet 
	(
		ClaimLineId INT
		,DenialReason VARCHAR(MAX)
		,ReallocationStatus VARCHAR(MAX)
	)

	DECLARE @CustomFiltersApplied CHAR(1) = 'N'
	DECLARE @AllStaffInsurer VARCHAR(1)
	DECLARE @AllStaffProvider CHAR(1)

	SELECT	@AllStaffInsurer = ISNULL(AllInsurers, 'N')
			,@AllStaffProvider = ISNULL(AllProviders, 'N')
	FROM Staff
	WHERE StaffId = @StaffId

	DECLARE @SQLStr AS NVARCHAR(MAX)
	DECLARE @AllStatuses INT
			,@EntryIncomplete INT
			,@EntryComplete INT
			,@Tobeadjudicated INT
			,@TobePaid INT
			,@Pended INT
			,@Approved INT
			,@ApprovedandPartiallyApproved INT
			,@PartiallyApproved INT
			,@Denied INT
			,@DeniedandPartiallyApproved INT
			,@Paid INT
			,@ToReadjudicate INT
			,@DoNotAdjudicate INT
			,@Tobeworked INT
			,@PaymentOverdue INT
			,@Void INT
			,@DenialNoticeNotSent INT
			,@PagePayableAmount MONEY
			,@AllPayableAmount MONEY
			,@GlobalCode INT
			,@strColumnGlobalCode3 NVARCHAR(40)
			,@OriginalClaimLineStatus INT

	SET @strColumnGlobalCode3 = ''
	SET @AllStatuses = 0
	SET @EntryIncomplete = 6188
	SET @EntryComplete = 6189
	SET @Approved = 6190
	SET @Denied = 6191
	SET @PartiallyApproved = 6192
	SET @Paid = 6193
	SET @Pended = 6194
	SET @Void = 6195
	SET @Tobeadjudicated = 6196
	SET @TobePaid = 6197
	SET @ApprovedandPartiallyApproved = 6198
	SET @DeniedandPartiallyApproved = 6199
	SET @ToReadjudicate = 6200
	SET @DoNotAdjudicate = 6201
	SET @Tobeworked = 6202
	SET @PaymentOverdue = 6203
	SET @DenialNoticeNotSent = 6204

	IF @SortExpression = ''
		SET @SortExpression = 'ClaimLineId'

	IF @Status = 6188
		SET @OriginalClaimLineStatus = 2021
	ELSE IF @Status = 6189
		SET @OriginalClaimLineStatus = 2022
	ELSE IF @Status = 6190
		SET @OriginalClaimLineStatus = 2023
	ELSE IF @Status = 6191
		SET @OriginalClaimLineStatus = 2024
	ELSE IF @Status = 6192
		SET @OriginalClaimLineStatus = 2025
	ELSE IF @Status = 6193
		SET @OriginalClaimLineStatus = 2026
	ELSE IF @Status = 6194
		SET @OriginalClaimLineStatus = 2027
	ELSE IF @Status = 6195
		SET @OriginalClaimLineStatus = 2028

	DECLARE @PendedDays INT

	IF @PendedDaysId = 6205
		SET @PendedDays = 30
	ELSE IF @PendedDaysId = 6206
		SET @PendedDays = 60
	ELSE IF @PendedDaysId = 6207
		SET @PendedDays = - 1
	ELSE IF @PendedDaysId = - 1
		SET @PendedDays = 0

	CREATE TABLE #Providers (ProviderId INT)

	CREATE TABLE #BillingCodeModifiers (BillingCodeModifierId INT)

	CREATE TABLE #DenialReasons (DenialReasonId INT)

	IF isnull(@ProviderId, '') <> ''
	BEGIN
		INSERT INTO #Providers (ProviderId)
		SELECT *
		FROM dbo.fnSplit(@ProviderId, ',')
	END

	INSERT INTO #BillingCodeModifiers (BillingCodeModifierId)
	SELECT *
	FROM dbo.fnSplit(@BillingCodeModifiers, ',')

	INSERT INTO #DenialReasons (DenialReasonId)
	SELECT *
	FROM dbo.fnSplit(@DenialReasons, ',')

	IF @OtherFilter > 10000
	BEGIN
		SET @CustomFiltersApplied = 'Y'

		INSERT INTO #ResultSet (ClaimLineId)
		EXEC scsp_ListPageCMGetFilteredClaimLines @InsurerId = @InsurerId
			,@Status = @Status
			,@ProviderId = @ProviderId
			,@SiteId = @SiteId
			,@BankAccounts = @BankAccounts
			,@ClaimPopulationDropdown = @ClaimPopulationDropdown
			,@BillingCodeModifiers = @BillingCodeModifiers
			,@DenialReasons = @DenialReasons
			,@BatchNo = @BatchNo
			,@ClaimId = @ClaimId
			,@ClaimLineNo = @ClaimLineNo
			,@ReceivedFrom = @ReceivedFrom
			,@ReceivedTo = @ReceivedTo
			,@DOSFrom = @DOSFrom
			,@DOSTo = @DOSTo
			,@UserCode = @UserCode
			,@Populations = @Populations
			,@PendedDaysId = @PendedDaysId
			,@OtherFilter = @OtherFilter
			,@SortExpression = @SortExpression
			,@StaffId = @StaffId
			,@ReallocationExceptionFlag = @ReallocationExceptionFlag

		GOTO DenialReasons
	END

	SET @SQLStr = 'SELECT cl.ClaimLineId FROM ClaimLines AS cl '

	-- Use OpenClaims table when Status is EntryIncomplete, EntryComplete, Approved, PartiallyApproved, TobePaid OR ToReadjudicate, NeedsTobeworked is set to 'Y'                      
	IF (
			@Status = @EntryIncomplete
			OR @Status = @EntryComplete
			OR @Status = @ApprovedandPartiallyApproved
			OR @Status = @PartiallyApproved
			OR @Status = @Approved
			OR @Status = @TobePaid
			OR @Status = @ToReadjudicate
			OR @Status = @Tobeworked
			OR @Status = @Pended
			OR @Status = @Tobeadjudicated
			OR @Status = @PaymentOverdue
		)
		SET @SQLStr = @SQLStr + ' join OpenClaims oc on oc.ClaimLineId = cl.ClaimLineId and ISNULL(oc.RecordDeleted, ''N'') = ''N'' '
	SET @SQLStr = @SQLStr + ' join Claims as c on cl.ClaimId = c.ClaimId ' + ' join Clients as ce on ce.ClientId = c.Clientid and ISNULL(ce.RecordDeleted,''N'') = ''N'' ' + ' join Insurers as i on i.InsurerId = c.InsurerId and isnull(i.RecordDeleted,''N'') =

 ''N'' ' + ' join Sites as s on s.SiteId = c.SiteId and isnull(s.RecordDeleted,''N'') =''N'' ' + ' join Providers p on p.ProviderId = s.ProviderId and isnull(p.RecordDeleted,''N'') = ''N'' '

	-- Use ClaimLineDenials when status is DenialNoticeNotSent ref #task 1533                    
	IF @Status = @DenialNoticeNotSent
		SET @SQLStr = @SQLStr + ' join ClaimLineDenials as dc on dc.ClaimLineId = cl.ClaimLineId and ISNULL(dc.RecordDeleted, ''N'') = ''N'' '

	IF @BatchNo <> 0
		SET @SQLStr = @SQLStr + ' join Adjudications as ad on ad.ClaimLineId = cl.ClaimLineId and ISNULL(ad.RecordDeleted,''N'') = ''N'' '

	IF (@Populations > 0)
	BEGIN
		DECLARE @Code VARCHAR(5)

		SELECT @Code = Code
		FROM GlobalSubCodes
		WHERE GlobalSubCodeId = @Populations

		IF @Code <> 'AP' -- AP = All Population 
		BEGIN
			SET @SQLStr = @SQLStr + ' JOIN CustomFieldsData AS cfd ON cfd.PrimaryKey1 = ce.ClientId and cfd.DocumentType = 4941 and ISNULL(cfd.RecordDeleted, ''N'') = ''N'' '

			IF @Code = 'NPA' -- No population Assigned  
			BEGIN
				SET @SQLStr = @SQLStr + ' and cfd.ColumnGlobalCode7 IS NULL ' -- ==== TMU modified on 01/03/2018
			END
			ELSE
			BEGIN
				-- We are selecting Globalcode Code for that particular Code that we are getting from Sub           
				SELECT @GlobalCode = GlobalCodeId
				FROM GlobalCodes
				WHERE Category = 'XPRESENTINGPOP'
					AND Code = @Code
					AND isnull(RecordDeleted, 'N') = 'N'
					AND Active = 'Y'

				SET @SQLStr = @SQLStr + ' AND cfd.ColumnGlobalCode7 = ' + CAST(ISNULL(@GlobalCode, - 1) AS VARCHAR) -- ==== TMU modified on 01/03/2018
			END
		END
	END

	-- BillingCodeModifiers    
	IF 
	(
		EXISTS (
				SELECT BillingCodeModifierId
				FROM #BillingCodeModifiers
				WHERE BillingCodeModifierId <> - 1
				)
	)
	BEGIN
		SET @SQLStr = @SQLStr + ' join BillingCodeModifiers bcm on bcm.BillingCodeId = cl.BillingCodeId and isnull(bcm.RecordDeleted,''N'') = ''N'' ' + ' and isnull(bcm.Modifier1, '''') = isnull(cl.Modifier1, '''') and isnull(bcm.Modifier2, '''') = isnull(cl.Modifier2, '''')  ' + ' and isnull(bcm.Modifier3, '''') = isnull(cl.Modifier3, '''') and isnull(bcm.Modifier4, '''') = isnull(cl.Modifier4, '''')  '
		SET @SQLStr = @SQLStr + ' join #BillingCodeModifiers bcmt on bcmt.BillingCodeModifierId = bcm.BillingCodeModifierId '
	END

	SET @SQLStr = @SQLStr + '  where  IsNull(cl.RecordDeleted,''N'') = ''N'' and IsNull(c.RecordDeleted,''N'') = ''N'' '

	IF @SiteId <> - 1
		SET @SQLStr = @SQLStr + ' and s.SiteId = ' + cast(@SiteId AS VARCHAR) --filter for Site                      

	IF @UserCode <> '0'
		AND @UserCode <> ''
		SET @SQLStr = @SQLStr + ' and cl.ModifiedBy = ''' + @UserCode + '''' --filter for ClaimStaff/User                      

	-- Denial Reasons    
	IF (
			EXISTS (
				SELECT DenialReasonId
				FROM #DenialReasons
				WHERE DenialReasonId <> - 1
				)
			)
	BEGIN
		SET @SQLStr = @SQLStr + ' and (exists (select * from #DenialReasons dr where dr.DenialReasonId = isnull(cl.DenialReason, cl.PendedReason) AND dr.DenialReasonId <> -1 ) ' + '   or exists (select * from AdjudicationDenialPendedReasons adpr join #DenialReasons dr on dr.DenialReasonId = isnull(adpr.DenialReason, adpr.PendedReason) ' + ' where adpr.AdjudicationId = cl.LastAdjudicationId and isnull(adpr.RecordDeleted, ''N'') = ''N'' )) '
	END

	-- filter for STATUS                      
	IF @Status <> - 1
	BEGIN
		IF (@Status = @Tobeadjudicated) --To be adjudicate                        
			SET @SQLStr = @SQLStr + ' and (IsNull(cl.DoNotAdjudicate,''N'') <>''Y'' and (cl.Status=2022 OR (ToReadjudicate = ''Y'' and cl.Status in (2024, 2027)))) '
		ELSE IF (@Status = @DenialNoticeNotSent) -- filter where status is Denial Notice Not Sent ref #task 1533                   
			SET @SQLStr = @SQLStr + ' and cl.status = 2024 and dc.CheckId is null and dc.DenialLetterId is null and IsNull(cl.NeedsToBeWorked,''N'') <> ''Y'' and IsNull(cl.ToReadjudicate,''N'') <> ''Y'' '
		ELSE IF (@Status = @ToReadjudicate) -- To Readjudicate                      
			SET @SQLStr = @SQLStr + ' and cl.ToReadjudicate = ''Y'' and cl.Status in (2024, 2027) '
		ELSE IF (@Status = @DoNotAdjudicate) -- Do Not Adjudicate                      
			SET @SQLStr = @SQLStr + ' and cl.DoNotAdjudicate = ''Y'' '
		ELSE IF (@Status = @Tobeworked) -- To be worked                      
			SET @SQLStr = @SQLStr + ' and cl.NeedsToBeWorked = ''Y'' '
		ELSE IF (@Status = @DeniedandPartiallyApproved) -- Denied and Partially Approved                      
			SET @SQLStr = @SQLStr + ' and (cl.Status=2024 or cl.Status=2025) '
		ELSE IF (@Status = @PaymentOverdue) -- Payment Overdue                      
			SET @SQLStr = @SQLStr + ' and (cl.Status=2023 or cl.Status=2025) and datediff(d, c.CleanClaimDate, getDate()) >= 30 '
		ELSE IF (@Status = @ApprovedandPartiallyApproved) --Approved and Partially Approved                      
			SET @SQLStr = @SQLStr + ' and (cl.Status=2023 or cl.Status=2025) '
		ELSE IF (@Status = @TobePaid) -- To be Paid                      
			SET @SQLStr = @SQLStr + ' and (cl.Status=2023 or cl.Status=2025)  and IsNull(cl.NeedsToBeWorked,''N'') <>''Y'' '
		ELSE
			SET @SQLStr = @SQLStr + ' and cl.Status= ' + cast(@OriginalClaimLineStatus AS VARCHAR)
	END

	-- filter for Claims Pended x days, works only if Pended is selected in status dropdown                      
	IF (
			@PendedDays > 0
			AND @Status = @Pended
			)
	BEGIN
		IF (@PendedDays > 90) -- Claims Pended more than 90 days                      
			SET @SQLStr = @SQLStr + ' and datediff(d, cl.LastAdjudicationDate, getdate()) > 90 '
		ELSE IF (@PendedDays <= 90) -- Claims Pended up to 30,45,60,90 days   
			SET @SQLStr = @SQLStr + ' and datediff(d, cl.LastAdjudicationDate, getdate()) >  ' + cast(@PendedDays AS VARCHAR)
	END

	--filter for Negative claimLines (added on 07/06/2006 as per Task # 1256                       
	IF (@PendedDays < 0)
	BEGIN
		SET @SQLStr = @SQLStr + ' and cl.PayableAmount < 0 '
	END

	--filter for BatchNo                      
	IF (@BatchNo <> 0)
		SET @SQLStr = @SQLStr + ' and ad.BatchId = ' + cast(@BatchNo AS VARCHAR)

	--filter for ClaimId                      
	IF (@ClaimId <> 0)
		SET @SQLStr = @SQLStr + ' and cl.ClaimId = ' + cast(@ClaimId AS VARCHAR)

	-- filter for EnteredFrom Date         
	IF @ReceivedFrom <> ''
		SET @SQLStr = @SQLStr + ' and c.ReceivedDate >= ''' + ltrim(rtrim(convert(VARCHAR(11), @ReceivedFrom, 101))) + ''' '

	-- filter for EnteredTo Date      
	IF @ReceivedTo <> ''
		SET @SQLStr = @SQLStr + ' and cast(c.ReceivedDate as date) <= ''' + ltrim(rtrim(convert(VARCHAR(11), @ReceivedTo, 101))) + ''' '

	-- filter for DOSFrom Date                      
	IF @DOSFrom <> ''
		SET @SQLStr = @SQLStr + ' and cl.FromDate >= ''' + ltrim(rtrim(convert(VARCHAR(11), @DOSFrom, 101))) + ''' '

	-- filter for DOSTo Date                      
	IF @DOSTo <> ''
		SET @SQLStr = @SQLStr + ' and cl.ToDate <= ''' + ltrim(rtrim(convert(VARCHAR(11), @DOSTo, 101))) + ''' '

	--filter for ClaimLineNo                      
	IF (@ClaimLineNo <> 0)
		SET @SQLStr = @SQLStr + ' and cl.ClaimLineId = ' + cast(@ClaimLineNo AS VARCHAR)

	-- filter for Insurer     
	IF @AllStaffInsurer = 'N'
		SET @SQLStr = @SQLStr + ' and exists ( select * from StaffInsurers si where si.StaffId = ' + cast(@StaffId AS VARCHAR) + ' and si.InsurerId = c.InsurerId and isnull(si.RecordDeleted, ''N'') = ''N'' ) '

	IF @InsurerId > 0
		SET @SQLStr = @SQLStr + ' and i.InsurerId =  ' + cast(@InsurerId AS VARCHAR)
	ELSE
		SET @SQLStr = @SQLStr + ' and i.Active = ''Y'' '

	-- filter for Providers
	IF (
			EXISTS (
				SELECT 1
				FROM #Providers pr
				WHERE pr.ProviderId = 0
				)
			)
		SET @SQLStr = @SQLStr + '  and IsNull(p.Active, ''N'') = ''N'' ' -- filter for Inactive Provider                  
	ELSE IF (
			EXISTS (
				SELECT 1
				FROM #Providers PR
				WHERE PR.ProviderId = - 1
				)
			) -- All Provider will return only active providers as per task #2658.        
		SET @SQLStr = @SQLStr + '  and p.Active = ''Y'' '
	ELSE IF @ProviderId <> ''
		SET @SQLStr = @SQLStr + ' and exists (select * from #Providers pr where pr.ProviderId = p.ProviderId) '

	IF @AllStaffProvider = 'N'
		SET @SQLStr = @SQLStr + ' and exists (select * from StaffProviders si where si.StaffId = ' + cast(@StaffId AS VARCHAR) + ' and si.ProviderId = p.ProviderId and isnull(si.RecordDeleted, ''N'') = ''N'' ) '

	IF (@ReallocationExceptionFlag = 'Y')
		SET @SQLStr = @SQLStr + ' and cl.Status in (2023, 2025, 2026) ' + ' and exists(select * from ReallocatedClaimLines rcl where rcl.ClaimLineId = cl.ClaimLineId and rcl.Status <> ''Reallocated'' and isnull(rcl.RecordDeleted, ''N'') = ''N'' ' + ' and not exists ( select *
                           from   ReallocatedClaimLines rcl2
                           where  rcl2.ClaimLineId = cl.ClaimLineId
                             and  isnull(rcl2.RecordDeleted, ''N'') = ''N''
                             and  rcl2.ReallocationId > rcl.ReallocationId ))'

	--print @SQLStr     
	INSERT INTO #ResultSet (ClaimLineId)
	EXECUTE sp_executesql @SQLStr

	DenialReasons:

	UPDATE rs
	SET DenialReason = r.Reason
	FROM #ResultSet rs
	JOIN (
		SELECT cl.ClaimLineId
			,isnull(stuff((
						SELECT '; ' + r.Reason
						FROM AdjudicationDenialPendedReasons r
						WHERE r.AdjudicationId = cl.LastAdjudicationId
						ORDER BY r.Reason
						FOR XML path('')
							,type
						).value('.', 'varchar(max)'), 1, 2, ''), max(gcr.CodeName)) AS Reason
		FROM #ResultSet rs
		JOIN ClaimLines cl ON cl.ClaimLineId = rs.ClaimLineId
		JOIN GlobalCodes gcr ON gcr.GlobalCodeId = isnull(cl.DenialReason, cl.PendedReason)
		WHERE cl.STATUS IN (
				2023
				,2024
				,2025
				,2026
				,2027
				)
			AND (
				cl.DenialReason IS NOT NULL
				OR cl.PendedReason IS NOT NULL
				)
		GROUP BY cl.ClaimLineId
			,cl.LastAdjudicationId
			,isnull(cl.DenialReason, cl.PendedReason)
		) r ON r.ClaimLineId = rs.ClaimLineId

	IF (@ReallocationExceptionFlag = 'Y')
	BEGIN
		UPDATE rs
		SET ReallocationStatus = rcl.STATUS
		FROM #ResultSet rs
		JOIN ReallocatedClaimLines rcl ON rcl.ClaimLineId = rs.ClaimLineId
		WHERE rcl.STATUS <> 'Reallocated'
			AND isnull(rcl.RecordDeleted, 'N') = 'N'
			AND NOT EXISTS (
				SELECT *
				FROM ReallocatedClaimLines rcl2
				WHERE rcl2.ClaimLineId = rs.ClaimLineId
					AND isnull(rcl2.RecordDeleted, 'N') = 'N'
					AND rcl2.ReallocationId > rcl.ReallocationId
				)
	END

	SELECT @AllPayableAmount = sum(cl.PayableAmount)
	FROM #ResultSet rs
	JOIN ClaimLines cl ON cl.ClaimLineId = rs.ClaimLineId;
	
	SELECT ClaimLineId,DenialReason FROM #ResultSet
		 
  END TRY

  BEGIN CATCH
    DECLARE @Error varchar(8000)
    SET @Error = CONVERT(varchar, ERROR_NUMBER()) + '*****' + CONVERT(varchar(4000), ERROR_MESSAGE())
    + '*****' + ISNULL(CONVERT(varchar, ERROR_PROCEDURE()), 'ssp_ListPageGetALLClaimLineIds')
    + '*****' + CONVERT(varchar, ERROR_LINE()) + '*****' + CONVERT(varchar, ERROR_SEVERITY())
    + '*****' + CONVERT(varchar, ERROR_STATE())
    RAISERROR
    (
    @Error, -- Message text.  
    16,  -- Severity.  
    1  -- State.  
    );
  END CATCH                 
End                  
      


GO


