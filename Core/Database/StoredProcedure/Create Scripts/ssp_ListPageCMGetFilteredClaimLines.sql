IF EXISTS 
(
	SELECT	*
	FROM	sys.objects
	WHERE	object_id = OBJECT_ID(N'[dbo].[ssp_ListPageCMGetFilteredClaimLines]')
		AND type IN (N'P', N'PC')
)
	DROP PROCEDURE [dbo].[ssp_ListPageCMGetFilteredClaimLines]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create PROCEDURE [dbo].[ssp_ListPageCMGetFilteredClaimLines]     
(    
 @InsurerId INT,    
 @Status type_GlobalCode,    
 @ProviderId VARCHAR(MAX),    
 @SiteId INT,    
 @BankAccounts INT,    
 @ClaimPopulationDropdown VARCHAR(15),    
 @BillingCodeModifiers VARCHAR(MAX),    
 @DenialReasons VARCHAR(MAX),    
 @BatchNo INT,    
 @ClaimId INT,    
 @ClaimLineNo INT,    
 @ReceivedFrom VARCHAR(15),    
 @ReceivedTo VARCHAR(15),    
 @DOSFrom VARCHAR(15),    
 @DOSTo VARCHAR(15),    
 @UserCode VARCHAR(30),    
 @Populations INT,    
 @PendedDaysId INT,    
 @PageNumber INT,    
 @PageSize INT,    
 @OtherFilter INT,    
 @SortExpression VARCHAR(50) = 'ClaimLineId',    
 @SortOrder VARCHAR(4) = 'asc',    
 @StaffId INT,    
 @ReallocationExceptionFlag CHAR(1)    
)    
/***********************************************************************************************************************                                          
 Stored Procedure: dbo.ssp_GetFilteredClaimLines              
 Copyright: 2005 Provider Claim Management System              
 Creation Date:  22/12/2005                                                                                             
 Purpose: retuns list of claim lines based on parameter values              
========================================================================================================================    
 Modification Log    
========================================================================================================================                                                              
 Date   Author   Purpose       
    ------------- -------------- ----------------------------------------------------------------    
 30/jun/2014  Manju P   Care Management to SmartCare Task #25 Claims list page and Claim Lines details page          
 07/10/2014  Shruthi.S  Uncommented ProviderID null condition and changed for all population.         
 31.OCT.2014  Rohith Uppin two new Column ClientId & ProivderId are added.Task#25 CM to SC.        
 10. Nov.2014 Vichee Humane Added Logic to get the providerid on basis of permissions CM to SC Env.     
         Issues Tracking #82        
 11.Nov.2014  Rohith Uppin. Issues fixed for Task#25.02 CM to SC issue tracking.        
 13.Nov.2014  Vichee Humane Modified  Record deleted code to check NULL also in Insurer.CM to SC Env. Issues     
         Tracking #82        
 14/11/2014  Shruthi.S  Added Billingcodes join to display the billingcode not the billingcodeid.    
         Ref #127 Care Management to SmartCare Env. Issues Tracking.        
 17.Nov.2014  Vichee Humane Modified  to put inner join Providers with StaffProviders.CM to SC Env. Issues     
         Tracking #82        
 09-12-2014  Shruthi.S  Modified staffproviders to check for AllProviders and selected providerid's.    
         Ref : No Specific task .Env Issues.        
 30-12-2014  Venkatesh MR Export was not working since when click on export providerid is coming as NULL gives     
         the result as empty table. So added the condition as @Provider IS NULL in if condition        
 21/Jan/2015  SuryaBalan  Added conditions for Dashboard : Widget sp's needs to be changed to include StaffInsu     
         StaffProvRef #331 CM to SC.        
         Provider Claims Widgets        
 09/Feb/2015  T.Remisoski  Corrected issues with null columns        
 11.Mar.2015  Rohith Uppin Comment column added to Select query.Task#488 Summit Pointe - Contract Support        
 13.Mar.2015  Rohith Uppin ClaimLine Status = 2024(Denied) check added for  Denial Letters Not Sent filter.     
         task#192 SWMBH - Support.        
 27.Apr.2015  Rohith Uppin Units datatype changed to INT & DOS sorting column modified to DOSTo.     
         Task#213 SWMBH - Support.        
 20.Jul.2015  Rohith Uppin Column name modified for Sorting. Task#487 SWMBH Support.        
 18.Aug.2015  Rohith Uppin Removed Comma seperated ClaimLineIds section and moved to new SP     
         ssp_ListPageGetALLClaimLineIds which is called only when All option is selected in     
         ClaimLine list page.        
         Task#585 SWMBH - Support.        
 17-DEC-2015  Basudev sahu    Modified For Task #609 Network180 Customization to Get Organisation  As ClientName        
 20-July-2016 Basudev Sahu updated Int Datatype to Decimal Type  in temp table and removed casting of units to     
         int for task #559 Network180 Environment issue tracking .        
 02 Dec 2016  Manjunath K  Removed DATEADD from @ReceivedTo filter, because it was returing extra records.         
         For AspenPointe - Support Go Live #259        
 13 MAR  2017 Lakshmi   @ReceivedTo date is formated as per the task The Arc - Support Go Live #146        
 16 June 2017 SuryaBalan  Changed Column DenialReasonDescription to DenialReason which is making issue in     
         sorting reported in KCMHSAS - Support #900.73    
 06/20/2017  Pranay          Added @ReallocationExceptionFlag Why: SWMBHA Task#557    
 08.18.2017  SFarber   Redesigned to improve performance.  Added logic to show all denied/pended reasons.    
 15-Nov-2017  SuryaBalan      Fixed ClaimLines List Page Exporting only one record on click of Export for task     
         KCMHSAS - Support #950.01    
 01/03/2018  Ting-Yu Mu  Modified the logic to filter the results of population based on the column    
         ColumnGlobalCode7 of the CustomFieldsData table instead of ColumnGlobalCode3    
         Why: KCMHSAS - Support #960.17    
 04/23/2018  Ting-Yu Mu  What: Re-formatted the dynamic SQL syntax to avoid the incorrect syntax wrapping    
         issues.    
         Why: Woodlands - Support # 569    
 10/31/2018  K.Soujanya  What:Added logic to filter the ClaimLines which are under review status and final status if user filter with ClaimLineUnderStatus and FinalStatus Why:SWMBH - Enhancements#591      
***********************************************************************************************************************/    
AS    
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
    
 SELECT @AllStaffInsurer = ISNULL(AllInsurers, 'N')    
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
   ,@ClaimLineUnderReview INT -- K.Soujanya 10/31/2018
   ,@FinalStatus INT    
    
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
 SET @ClaimLineUnderReview = 6271 -- K.Soujanya 10/31/2018
 SET @FinalStatus = 6272   
    
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
  SET @PendedDays = -1    
 ELSE IF @PendedDaysId = -1    
  SET @PendedDays = 0    
    
 CREATE TABLE #Providers (ProviderId INT)    
    
 CREATE TABLE #BillingCodeModifiers (BillingCodeModifierId INT)    
    
 CREATE TABLE #DenialReasons (DenialReasonId INT)    
    
 IF ISNULL(@ProviderId, '') <> ''    
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
 SET @SQLStr = @SQLStr + ' join Claims as c on cl.ClaimId = c.ClaimId ' +     
       ' join Clients as ce on ce.ClientId = c.Clientid and ISNULL(ce.RecordDeleted,''N'') = ''N'' ' +     
       ' join Insurers as i on i.InsurerId = c.InsurerId and isnull(i.RecordDeleted,''N'') = ''N'' ' +     
       ' join Sites as s on s.SiteId = c.SiteId and isnull(s.RecordDeleted,''N'') =''N'' ' +     
       ' join Providers p on p.ProviderId = s.ProviderId and isnull(p.RecordDeleted,''N'') = ''N'' ' -- ==== TMU modified on 04/23/2018    
    
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
  SET @SQLStr = @SQLStr + ' join BillingCodeModifiers bcm on bcm.BillingCodeId = cl.BillingCodeId and isnull(bcm.RecordDeleted,''N'') = ''N'' ' +     
        ' and isnull(bcm.Modifier1, '''') = isnull(cl.Modifier1, '''') and isnull(bcm.Modifier2, '''') = isnull(cl.Modifier2, '''')  ' +     
        ' and isnull(bcm.Modifier3, '''') = isnull(cl.Modifier3, '''') and isnull(bcm.Modifier4, '''') = isnull(cl.Modifier4, '''')  ' -- ==== TMU modified on 04/23/2018    
  SET @SQLStr = @SQLStr + ' join #BillingCodeModifiers bcmt on bcmt.BillingCodeModifierId = bcm.BillingCodeModifierId '    
 END    
    
 SET @SQLStr = @SQLStr + '  where IsNull(cl.RecordDeleted,''N'') = ''N'' and IsNull(c.RecordDeleted,''N'') = ''N'' '    
    
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
  SET @SQLStr = @SQLStr + ' and (exists (select * from #DenialReasons dr where dr.DenialReasonId = isnull(cl.DenialReason, cl.PendedReason) AND dr.DenialReasonId <> -1 ) ' +     
        ' or exists (select * from AdjudicationDenialPendedReasons adpr join #DenialReasons dr on dr.DenialReasonId = isnull(adpr.DenialReason, adpr.PendedReason) ' +     
        ' where adpr.AdjudicationId = cl.LastAdjudicationId and isnull(adpr.RecordDeleted, ''N'') = ''N'' )) ' -- ==== TMU modified on 04/23/2018    
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
  ELSE IF (@Status = @ClaimLineUnderReview) -- K.Soujanya 10/31/2018
   SET @SQLStr = @SQLStr + 'and IsNull(cl.ClaimLineUnderReview,''N'') =''Y'''
  ELSE IF (@Status = @FinalStatus) -- K.Soujanya 10/31/2018
   SET @SQLStr = @SQLStr + 'and IsNull(cl.FinalStatus,''N'') =''Y'''
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
  SET @SQLStr = @SQLStr + ' and exists ( select * from StaffInsurers si where si.StaffId = ' + cast(@StaffId AS VARCHAR) +     
        ' and si.InsurerId = c.InsurerId and isnull(si.RecordDeleted, ''N'') = ''N'' ) ' -- ==== TMU modified on 04/23/2018    
    
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
  SET @SQLStr = @SQLStr + ' and cl.Status in (2023, 2025, 2026) ' +     
        ' and exists(select * from ReallocatedClaimLines rcl where rcl.ClaimLineId = cl.ClaimLineId and rcl.Status <> ''Reallocated'' and isnull(rcl.RecordDeleted, ''N'') = ''N'' ' +     
        ' and not exists ( select * from ReallocatedClaimLines rcl2 where  rcl2.ClaimLineId = cl.ClaimLineId and isnull(rcl2.RecordDeleted, ''N'') = ''N'' and rcl2.ReallocationId > rcl.ReallocationId ))' -- ==== TMU modified on 04/23/2018    
    
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
    
 --declare @RowStart int    
 --declare @RowEnd int    
 DECLARE @TotalRows INT    
  --select  @TotalRows = count(*)    
  --from    #ResultSet    
  --if @PageNumber <= 0    
  --  set @PageNumber = 1    
  --set @RowStart = ((@PageNumber - 1) * @PageSize) + 1    
  --set @RowEnd = @RowStart + @PageSize - 1;    
    
 ;WITH RankResultSet    
 AS (    
  SELECT '0' AS Checkbox    
   ,cl.ClaimLineId    
   ,CASE     
    WHEN ce.ClientType = 'O'    
     THEN isnull(ce.OrganizationName, '')    
    ELSE isnull(ce.LastName, '') + ', ' + isnull(ce.FirstName, '')    
    END AS ClientName    
   ,c.ClientId    
   ,p.ProviderId    
   ,p.ProviderName + isnull(', ' + p.FirstName, '') AS ProviderName    
   ,cl.FromDate AS DOS    
   ,gcs.CodeName AS STATUS    
   ,isnull(cl.PayableAmount, 0) AS PayableAmount    
   ,isnull(cl.PaidAmount, 0) AS PaidAmount  -- Added By Narayana 14/07/2018    
   ,cast(cl.Comment AS VARCHAR(max)) AS Comment    
   ,i.InsurerName    
   ,coalesce(bc.BillingCode + ' ' + isnull(cl.Modifier1, '') + ' ' + isnull(cl.Modifier2, '') + ' ' + isnull(cl.Modifier3, '') + ' ' + isnull(cl.Modifier4, ''), cl.ProcedureCode, cl.RevenueCode) AS ProcedureCode    
   ,cl.Units    
   ,rs.DenialReason    
   ,isnull(nullif(@ReallocationExceptionFlag, ''), 'N') AS ReallocationFlag    
   ,rs.ReallocationStatus    
   ,row_number() OVER (    
    ORDER BY CASE     
      WHEN @SortExpression = 'ClaimLineId'    
       THEN cl.ClaimLineId    
      END    
     ,CASE     
      WHEN @SortExpression = 'ClaimLineId desc'    
       THEN cl.ClaimLineId    
      END DESC    
     ,CASE     
      WHEN @SortExpression = 'ClientName'    
       THEN CASE     
         WHEN ce.ClientType = 'O'              THEN isnull(ce.OrganizationName, '')    
         ELSE isnull(ce.LastName, '') + ', ' + isnull(ce.FirstName, '')    
         END    
      END    
     ,CASE     
      WHEN @SortExpression = 'ClientName desc'    
       THEN CASE     
         WHEN ce.ClientType = 'O'    
          THEN isnull(ce.OrganizationName, '')    
         ELSE isnull(ce.LastName, '') + ', ' + isnull(ce.FirstName, '')    
         END    
      END DESC    
     ,CASE     
      WHEN @SortExpression = 'ProviderName'    
       THEN p.ProviderName + isnull(', ' + p.FirstName, '')    
      END    
     ,CASE     
      WHEN @SortExpression = 'ProviderName desc'    
       THEN p.ProviderName + isnull(', ' + p.FirstName, '')    
      END DESC    
     ,CASE     
      WHEN @SortExpression = 'DOSTo'    
       THEN cl.FromDate    
      END    
     ,CASE     
      WHEN @SortExpression = 'DOSTo desc'    
       THEN cl.FromDate    
      END DESC    
     ,CASE     
      WHEN @SortExpression = 'Status'    
       THEN gcs.CodeName    
      END    
     ,CASE     
      WHEN @SortExpression = 'Status desc'    
       THEN gcs.CodeName    
      END DESC    
     ,CASE     
      WHEN @SortExpression = 'PayableAmount'    
       THEN isnull(cl.PayableAmount, 0)    
      END
      ,CASE     
      WHEN @SortExpression = 'PayableAmount desc'    
       THEN isnull(cl.PayableAmount, 0)    
      END DESC     
     ,CASE -- Added by Narayana om 14/07/2018    
      WHEN @SortExpression = 'PaidAmount'    
       THEN isnull(cl.PaidAmount, 0)    
      END     
      ,CASE    -- Added by Narayana om 25/07/2018  
      WHEN @SortExpression = 'PaidAmount desc'    
       THEN isnull(cl.PaidAmount, 0)    
      END DESC  
     --,CASE  -- Added by Narayana om 14/07/2018    
     -- WHEN @SortExpression = 'PaidAmount desc'    
     --  THEN isnull(cl.PaidAmount, 0)    
     -- END DESC    
     ,CASE     
      WHEN @SortExpression = 'InsurerName'    
       THEN i.InsurerName    
      END    
     ,CASE     
      WHEN @SortExpression = 'InsurerName desc'    
       THEN i.InsurerName    
      END DESC    
     ,CASE     
      WHEN @SortExpression = 'ProcedureCode'    
       THEN coalesce(bc.BillingCode + ' ' + isnull(cl.Modifier1, '') + ' ' + isnull(cl.Modifier2, '') + ' ' + isnull(cl.Modifier3, '') + ' ' + isnull(cl.Modifier4, ''), cl.ProcedureCode, cl.RevenueCode)    
      END    
     ,CASE     
      WHEN @SortExpression = 'ProcedureCode desc'    
       THEN coalesce(bc.BillingCode + ' ' + isnull(cl.Modifier1, '') + ' ' + isnull(cl.Modifier2, '') + ' ' + isnull(cl.Modifier3, '') + ' ' + isnull(cl.Modifier4, ''), cl.ProcedureCode, cl.RevenueCode)    
      END DESC    
     ,CASE     
      WHEN @SortExpression = 'Units'    
       THEN cl.Units    
      END    
     ,CASE     
      WHEN @SortExpression = 'Units desc'    
       THEN cl.Units    
      END DESC    
     ,CASE     
      WHEN @SortExpression = 'DenialReason'    
       THEN rs.DenialReason    
      END    
     ,CASE     
      WHEN @SortExpression = 'DenialReason desc'    
       THEN rs.DenialReason    
      END DESC    
     ,cl.ClaimLineId    
    ) AS RowNumber    
    --,cl.PaidAmount as PaidAmount  --Commented by by Narayana om 14/07/2018    
    --,isnull(cl.PaidAmount, 0) AS PaidAmount  --Added by Narayana om instead of above 14/07/2018    
  FROM #ResultSet rs    
  JOIN ClaimLines cl ON cl.ClaimLineId = rs.ClaimLineId    
  JOIN Claims c ON c.ClaimId = cl.ClaimId    
  JOIN Clients ce ON ce.ClientId = c.ClientId    
  JOIN Insurers i ON i.InsurerId = c.InsurerId    
  JOIN Sites s ON s.SiteId = c.SiteId    
  JOIN Providers p ON p.ProviderId = s.ProviderId    
  JOIN GlobalCodes gcs ON gcs.GlobalCodeId = cl.STATUS    
  LEFT JOIN BillingCodes bc ON bc.BillingCodeId = cl.BillingCodeId    
  )    
 SELECT TOP (    
   CASE     
    WHEN (@PageNumber = - 1)    
     THEN (    
       SELECT count(*)    
       FROM RankResultSet    
       )    
    ELSE (@PageSize)    
    END    
   ) Checkbox    
  ,ClaimLineId    
  ,ClientName    
  ,ClientId    
  ,ProviderId    
  ,ProviderName    
  ,convert(VARCHAR(10), DOS, 101) AS DOS    
  ,STATUS    
  ,PayableAmount    
  --,PaidAmount --Added by Narayana om 14/07/2018    
  ,Comment    
  ,InsurerName    
  ,ProcedureCode    
  ,Units    
  ,DenialReason    
  ,ReallocationFlag    
  ,ReallocationStatus    
  ,(    
   SELECT count(*)    
   FROM RankResultSet    
   ) AS TotalCount    
  ,RowNumber    
  --, PaidAmount    -- comment by Narayana(20/07/2018)
  ,isnull(PaidAmount, 0) AS PaidAmount   --Added by Narayana om 20/07/2018 
 --into    #FinalResultSet    
 --from    RankResultSet    
 --where   RowNumber between @RowStart and @RowEnd       
 INTO #FinalResultSet --SuryaBalan 15-Nov-2017    
 FROM RankResultSet    
 WHERE RowNumber > ((@PageNumber - 1) * @PageSize)    
    
 SELECT @PagePayableAmount = sum(PayableAmount)    
  ,@TotalRows = count(*)    
 FROM #FinalResultSet    
    
 IF (    
   SELECT isnull(count(*), 0)    
   FROM #FinalResultSet    
   ) < 1    
 BEGIN    
  SELECT 0 AS PageNumber    
   ,0 AS NumberOfPages    
   ,0 AS NumberOfRows    
   ,0 AS PagePayableAmount    
   ,0 AS AllPayableAmount    
   ,0 AS PagePayableAmount    
   ,0 AS AllPayableAmount    
 END    
 ELSE    
 BEGIN    
  SELECT TOP 1 @PageNumber AS PageNumber    
   ,CASE (TotalCount % @PageSize)    
    WHEN 0    
     THEN isnull((TotalCount / @PageSize), 0)    
    ELSE isnull((TotalCount / @PageSize), 0) + 1    
    END AS NumberOfPages    
   ,isnull(TotalCount, 0) AS NumberOfRows    
   ,@PagePayableAmount AS PagePayableAmount    
   ,@AllPayableAmount AS AllPayableAmount    
   ,@PagePayableAmount AS PagePayableAmount    
   ,@AllPayableAmount AS AllPayableAmount    
  FROM #FinalResultSet    
 END    
    
 SELECT Checkbox    
  ,ClaimLineId    
  ,ClientName    
  ,ClientId    
  ,ProviderId    
  ,ProviderName    
  ,DOS    
  ,STATUS    
  ,PayableAmount    
  --.PaidAmount  --Added by Narayana om 14/07/2018    
  ,Comment    
  ,InsurerName    
  ,ProcedureCode    
  ,Units    
  ,DenialReason    
  ,ReallocationFlag    
  ,ReallocationStatus    
  --,PaidAmount    --Commented by Narayana om 20/07/2018 
 ,isnull(PaidAmount, 0) AS PaidAmount --Added by Narayana om 20/07/2018 
 FROM #FinalResultSet    
 ORDER BY RowNumber    
END TRY    
    
BEGIN CATCH    
 DECLARE @Error VARCHAR(8000)    
    
 SET @Error = convert(VARCHAR, error_number()) + '*****' + convert(VARCHAR(4000), error_message()) + '*****' + isnull(convert(VARCHAR, error_procedure()), 'ssp_ListPageCMGetFilteredClaimLines') + '*****' + convert(VARCHAR, error_line()) + '*****' + convert(VARCHAR, error_severity()) + '*****' + convert(VARCHAR, error_state())    
    
 RAISERROR     
 (    
  @Error,  -- Message text.          
  16,   -- Severity.          
  1   -- State.          
 );    
END CATCH    

