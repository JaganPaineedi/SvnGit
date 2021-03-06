/****** Object:  StoredProcedure [dbo].[ssp_GetClaimLineDetail]    Script Date: 11/18/2011 16:25:40 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClaimLineDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetClaimLineDetail]
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClaimLineDetail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE  PROCEDURE [dbo].[ssp_GetClaimLineDetail]
(
   @ClaimLineID int	
) 
AS

/*********************************************************************/                
/* Stored Procedure: dbo.ssp_GetClaimLineDetail            */                
/* Copyright: 2005 Provider Claim Management System      */                
/* Creation Date:  27/12/2005                                    */                
/*                                                                   */                
/* Purpose: retuns detail of a claim line passed as parameter    */               
/*                                                                   */              
/* Input Parameters: @ClaimLineID                     */              
/*                                                                   */                
/* Output Parameters:                                */                
/*                                                                   */                
/* Return: returns detail of a claim line passed as parameter   */                
/*                                                                   */                
/* Called By:                                                        */                
/*                                                                   */                
/* Calls:                                                            */                
/*                                                                   */                
/* Data Modifications:                                               */                
/*                                                                   */                
/* Updates:                                                          */                
/*  Date               Author                   Purpose                         */                
/* 27/12/2005    Bhupinder Bajwa			Created                         */   
 /*  21 Oct 2015	Revathi					what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */ 
/* 											why:task #609, Network180 Customization  */ 
/* 03 May 2017 Msood	What: Changed Users table reference to Staff table and changed ActivityUserId to ActivityStaffId as per ClaimLineHistory DM change
						Why: Allegan - Support Task # 964 */	
/******************************************************************** */              
-- Variables declared to hold different Activity values
Declare @Payment int, @Credit int, @Refund int, @Adjudication int, @Reversal int, @Approval int, @Deny int, @VoidCheck int
	Set @Payment = 2003
	Set @Credit = 2005
	Set @Refund = 2006
	Set @Adjudication = 2002
	Set @Reversal = 2004 	
	Set @Approval = 2007
	Set @Deny = 2009
	Set @VoidCheck = 2011	
   
-- Query returns Claim Line Information as Table

	Select    cl.ClaimLineId, c.ClaimId, c.ClientId,
	--Added by Revathi Oct 21,2015	
	case when ISNULL(ce.ClientType,''I'')=''I'' THEN 
               case when Len(ce.LastName + '' '' + ce.FirstName)>18 then substring(ce.LastName + '', '' + ce.FirstName,1,15)+''...'' else  ce.LastName + '', '' + ce.FirstName End 
               ELSE
               case when
               LEN(Ce.OrganizationName)>18 then substring (ce.OrganizationName,1,15)+''...'' else Ce.OrganizationName end
               END
               as ClientName,
                p.ProviderId, case when Len(p.ProviderName)>18 then substring(p.ProviderName,1,15)+''...'' else p.ProviderName End as ProviderName, p.NonNetwork, s.SiteId, 
	case when Len(s.SiteName)>18 then substring(s.SiteName,1,15)+''...'' else s.SiteName End as SiteName, s.TaxID, i.InsurerId,
	case when Len(i.InsurerName)>18 then substring(i.InsurerName,1,15)+''...'' else i.InsurerName End as InsurerName, cl.Status as Status, 
                g.CodeName as CodeName, cl.ProcedureCode, convert(decimal(18,0),cl.Units) as Units, rtrim(IsNull(cl.Modifier1,'''') + '' '' + IsNull(cl.Modifier2,'''') + '' '' + IsNull(cl.Modifier3,'''') + '' '' + IsNull(cl.Modifier4,'''')) as Modifiers, 
	 cl.RevenueCode, cl.charge, cl.PayableAmount, cl.ClaimedAmount, cl.PaidAmount,
              Isnull(cl.DoNotAdjudicate,''N'') as DoNotAdjudicate, Isnull(cl.NeedsToBeWorked,''N'') as NeedsToBeWorked, Isnull(cl.ToReadjudicate,''N'') as ToReadjudicate, 
              convert(varchar(10),cl.FromDate,101) as DOSFrom, convert(varchar(10),cl.ToDate,101) as DOSTo, convert(varchar(10),c.ReceivedDate,101) as ReceivedDate, 
              convert(varchar(10),c.CleanClaimDate,101) as CleanClaimDate, IsNull(c.Electronic, ''N'') as Electronic, cl.Comment, 
              (Select gc.CodeName from GlobalCodes gc where gc.GlobalCodeId=s.SiteType and IsNull(gc.RecordDeleted,''N'') <> ''Y'' and gc.Active=''Y'') as SiteType,
              (Select gc.CodeName from GlobalCodes gc where gc.GlobalCodeId=c.ClaimType and IsNull(gc.RecordDeleted,''N'') <> ''Y'' and gc.Active=''Y'') as ClaimType,
              (Select gc.CodeName from GlobalCodes gc where gc.GlobalCodeId=cl.PlaceOfService and IsNull(gc.RecordDeleted,''N'') <> ''Y'' and gc.Active=''Y'') as POS, 
              '''' as BlankColumn
	 from ClaimLines as cl inner join GlobalCodes as g on g.GlobalCodeId=cl.Status
 	 inner join Claims as c on cl.ClaimId=c.ClaimId
              inner join Clients as ce on ce.ClientId=c.Clientid
	 inner join Insurers as i on i.InsurerId=c.InsurerId 
	 inner join Sites as s on s.SiteId=c.SiteId 
	 inner join Providers as p on p.ProviderId=s.ProviderId
	 where IsNull(cl.RecordDeleted,''N'') <>''Y'' and IsNull(c.RecordDeleted,''N'') <>''Y'' and IsNull(ce.RecordDeleted,''N'') <>''Y'' 
	and IsNull(i.RecordDeleted,''N'') <>''Y'' and IsNull(s.RecordDeleted,''N'') <>''Y'' and IsNull(p.RecordDeleted,''N'') <>''Y'' and IsNull(g.RecordDeleted,''N'') <> ''Y''
	and cl.ClaimLineId = @ClaimLineID

	--Checking For Errors
	If (@@error!=0)  Begin  RAISERROR (''ssp_GetClaimLineDetail: An Error Occured'',16,1)     Return  End

--Query returns Claim Line Status and Payment History as Table
	Select clh.ClaimLineId, clh.ActivityDate, clh.Activity, (Select gc.CodeName from GlobalCodes gc where gc.GlobalCodeId=clh.Activity and IsNull(gc.RecordDeleted,''N'')=''N'') as ActivityName,
	clh.Status, g.CodeName as StatusName, case when clh.Activity=@Adjudication OR clh.Activity=@Reversal OR clh.Activity=@Approval then ad.ApprovedAmount else Null end as ApprovedAmount, 
             case when clh.Activity=@Adjudication OR clh.Activity=@Reversal OR clh.Activity=@Approval OR clh.Activity=@Deny then ad.DeniedAmount else Null end as DeniedAmount, 
	case when clh.Activity=@Payment OR clh.Activity=@VoidCheck then clp.Amount else null end as PaidAmount, case when clh.Activity=@Credit OR clh.Activity=@Refund then clc.Amount else null end as CreditAmount, 
	Case When clh.Activity=@Payment Then (Select cast(ch.CheckNumber as varchar) from Checks ch where 
	ch.CheckId=clp.CheckId and IsNull(ch.RecordDeleted,''N'')<>''Y'') 
	When clh.Activity=@Refund Then (Select pr.CheckNumber from ProviderRefunds pr where 
	pr.ProviderRefundId=clc.ProviderRefundId and IsNull(pr.RecordDeleted,''N'')<>''Y'')
	When clh.Activity=@Credit Then (Select cast(ch.CheckNumber as varchar) from Checks ch where 
	ch.CheckId=clc.CheckId and IsNull(ch.RecordDeleted,''N'')<>''Y'')  Else Null End as Check#, 
	clh.ActivityStaffId, u.UserCode as UserName, clh.Reason, case when clh.Activity=@Adjudication then ad.BatchId else null end as BatchId,
	clp.CheckId as PaymentCheckId, clc.CheckId as CreditCheckId, clc.ProviderRefundId
	From ClaimLineHistory clh inner join GlobalCodes g on g.GlobalCodeId=clh.Status 
	inner join Staff u on u.StaffId=clh.ActivityStaffId 
	left outer join Adjudications ad on clh.AdjudicationId=ad.AdjudicationId and IsNull(ad.RecordDeleted,''N'') <>''Y'' 
	left outer join ClaimLinePayments clp on clh.ClaimLinePaymentId=clp.ClaimLinePaymentId and IsNull(clp.RecordDeleted,''N'') <>''Y''
	left outer join ClaimLineCredits clc on clh.ClaimLineCreditId=clc.ClaimLineCreditId and IsNull(clc.RecordDeleted,''N'') <>''Y''
	where clh.ClaimLineId=@ClaimLineID 
	and IsNull(clh.RecordDeleted,''N'')<>''Y'' -- and IsNull(u.RecordDeleted,''N'') <>''Y'' (No need to check RecordDeleted flag for ActivityUser as per Task # 1324)
	and IsNull(g.RecordDeleted,''N'') <>''Y''
	Order by clh.ActivityDate Desc

	--Checking For Errors
	If (@@error!=0)  Begin  RAISERROR  (''ssp_GetClaimLineDetail: An Error Occured'',16,1)     Return  End

-- Query returns Plan Alllocation list

	/*Select p.PlanName, case when clp.PaidAmount > 0 then ''$'' + convert(varchar,clp.PaidAmount,1) 
                when clp.PaidAmount < 0 then ''($'' + convert(varchar,ABS(clp.PaidAmount),1) + '')'' Else null End  as PaidAmount from ClaimLinePlans clp 
	inner join Plans p ON clp.PlanId=p.PlanId 
	where clp.ClaimLineId=@ClaimLineID and IsNull(clp.RecordDeleted,''N'')<>''Y''
	and IsNull(p.RecordDeleted,''N'')<>''Y'' and p.Active=''Y'' */

	-- Query changed on 3/3/2006 as per discussions with David (To show sum(amount) for each row having sum(amount) > 0)
	Select p.PlanName, ''$'' + convert(varchar,sum(clp.PaidAmount),1) as PaidAmount from ClaimLinePlans clp 
	inner join Plans p ON clp.PlanId=p.PlanId 
	where clp.ClaimLineId=@ClaimLineID and IsNull(clp.RecordDeleted,''N'')<>''Y''
	and IsNull(p.RecordDeleted,''N'')<>''Y'' and p.Active=''Y'' 
	group by p.PlanId,p.PlanName having sum(clp.PaidAmount) > 0 order by p.PlanName

	--Checking For Errors
	If (@@error!=0)  Begin  RAISERROR  (''ssp_GetClaimLineDetail: An Error Occured'',16,1)     Return  End
 
-- Query returns the Authorization Numbers for the ClaimLineId
	Select cla.ProviderAuthorizationId, a.AuthorizationNumber from 
	ClaimLineAuthorizations cla
	inner join Authorizations a ON cla.ProviderAuthorizationId=a.AuthorizationId
	where cla.ClaimLineId=@ClaimLineID and IsNull(cla.RecordDeleted,''N'')<>''Y'' and IsNull(a.RecordDeleted,''N'')<>''Y''

	--Checking For Errors
	If (@@error!=0)  Begin  RAISERROR  (''ssp_GetClaimLineDetail: An Error Occured'',16,1)     Return  End

-- Query returns the Contract Rate information for the ClaimLineId (added on 01/07/2006 as per Task # 1238)
	Select top 1 ad.ClaimLineId, ad.ContractId, c.ContractName, c.StartDate, c.EndDate, ad.ContractRateId, cr.ContractRate, c.ProviderId, c.InsurerId, i.InsurerName
	from Adjudications ad
	left outer join ContractRates cr on ad.ContractRateId=cr.ContractRateId and IsNull(cr.RecordDeleted,''N'')=''N''
	left outer join Contracts c on ad.ContractId=c.ContractId and IsNull(c.RecordDeleted,''N'')=''N''
	left outer join Insurers i on c.InsurerId=i.InsurerId and IsNull(i.RecordDeleted,''N'')=''N''
	where ad.ClaimLineId=@ClaimLineID and IsNull(ad.RecordDeleted,''N'')=''N'' order by ad.CreatedDate Desc

	--Checking For Errors
	If (@@error!=0)  Begin  RAISERROR (''ssp_GetClaimLineDetail: An Error Occured'',16,1)     Return  End

-- Query returns the ClaimLine with fields needs to be updated
	Select cl.ClaimLineId, cl.Status, cl.DoNotAdjudicate, cl.NeedsToBeWorked, 
             cl.ToReadjudicate, cl.EOBReceived, cl.Comment, cl.ModifiedBy, cl.ModifiedDate from ClaimLines cl 
	where cl.ClaimLineId = @ClaimLineID and IsNull(cl.RecordDeleted,''N'') <> ''Y''


	--Checking For Errors
	If (@@error!=0)  Begin  RAISERROR(''ssp_GetClaimLineDetail: An Error Occured'',16,1)     Return  End
' 
END
GO
