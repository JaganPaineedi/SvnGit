/****** Object:  StoredProcedure [dbo].[csp_RDWExtractClientCoverages]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractClientCoverages]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDWExtractClientCoverages]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractClientCoverages]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_RDWExtractClientCoverages]
@AffiliateId int
as

set nocount on
set ansi_warnings off

delete from CustomRDWExtractClientCoverages

if @@error <> 0 goto error

insert into CustomRDWExtractClientCoverages (
       AffiliateId,
       ClientId,
       EpisodeNumber,
       CoveragePlanId,
       CoveragePlanName,
       CoveragePayerType,
       CoveragePayerName,
       InsuredId,
       GroupNumber,
       InsuredName,
       ClientIsSubscriber,
       SubscriberLastName,
       SubscriberFirstName,
       SubscriberMIddleName,
       SubscriberDOB,
       SubscriberSex,
       SubscriberAddress1,
       SubscriberAddress2,
       SubscriberCity,
       SubscriberState,
       SubscriberZip,
       SubscriberRelation)
select @AffiliateId,
       c.ClientId,
       c.EpisodeNumber,
       cp.DisplayAs,
       cp.CoveragePlanName,
       gcpt.ExternalCode2,
       p.PayerName,
       ccp.InsuredId,
       ccp.GroupNumber,
       case when ccp.ClientIsSubscriber = ''Y''
            then c.LastName + '', '' + c.FirstName 
            else cc.LastName + '', '' + cc.FirstName
       end,
       ccp.ClientIsSubscriber,
       case when ccp.ClientIsSubscriber = ''Y'' then c.LastName else cc.LastName end,
       case when ccp.ClientIsSubscriber = ''Y'' then c.FirstName else cc.FirstName end,
       case when ccp.ClientIsSubscriber = ''Y'' then c.MiddleName else cc.MiddleName end,
       case when ccp.ClientIsSubscriber = ''Y'' then c.DOB else cc.DOB end,
       case when ccp.ClientIsSubscriber = ''Y'' then c.Sex else null end,
       case when ccp.ClientIsSubscriber = ''Y'' 
            then c.Address1
            else case when charindex(char(13) + char(10), ca.Address) > 0 
                       then left(ca.Address, charindex(char(13) + char(10), ca.Address) - 1)
                       else ca.Address
                 end 
       end,
       case when ccp.ClientIsSubscriber = ''Y'' 
            then c.Address2
            else case when charindex(char(13) + char(10), ca.Address) > 0 
                      then substring(ca.Address, charindex(char(13) + char(10), ca.Address) + 2, len(ca.Address) - charindex(char(13) + char(10), ca.Address) + 2)
                      else null
                 end
       end,
       case when ccp.ClientIsSubscriber = ''Y'' then c.City else ca.City end,
       case when ccp.ClientIsSubscriber = ''Y'' then c.State else ca.State end, 
       case when ccp.ClientIsSubscriber = ''Y'' then c.Zip else ca.Zip end,
       case when ccp.ClientIsSubscriber = ''Y'' then null else gcrt.ExternalCode2 end
  from CustomRDWExtractClients c
       join ClientCoveragePlans ccp on ccp.ClientId = c.ClientId
       join CoveragePlans cp on cp.CoveragePlanId = ccp.CoveragePlanId
       join Payers p on p.PayerId = cp.PayerId
       left join GlobalCodes gcpt on gcpt.GlobalCodeId = p.PayerType
       left join ClientContacts cc on cc.ClientContactId = ccp.SubscriberContactId 
       left join GlobalCodes gcrt on gcrt.GlobalCodeId = cc.Relationship
       left join (select cca.ClientContactId,
                         cca.Address,
                         cca.City,
                         cca.State,
                         cca.Zip
                    from ClientContactAddresses cca
                   where cca.AddressType = 90 -- Home
                     and isnull(cca.RecordDeleted, ''N'') = ''N''
                     and not exists(select *
                                      from ClientContactAddresses cca2 
                                     where cca2.ClientContactId = cca.ClientContactId
                                       and cca2.AddressType = cca.AddressType
                                       and isnull(cca2.RecordDeleted, ''N'') = ''N''
                                       and cca2.ContactAddressId > cca.ContactAddressId)) ca on ca.ClientContactId = ccp.SubscriberContactId
 where isnull(ccp.RecordDeleted, ''N'') = ''N''
   and not exists(select *
                    from ClientCoveragePlans ccp2
                   where ccp2.ClientId = ccp.ClientId
                     and ccp2.CoveragePlanId = ccp.CoveragePlanId
                     and isnull(ccp2.InsuredId, ''IsNuLl'') = isnull(ccp.InsuredId, ''IsNuLl'')
                     and isnull(ccp2.RecordDeleted, ''N'') = ''N''
                     and ccp2.ClientCoveragePlanId > ccp.ClientCoveragePlanId)

if @@error <> 0 goto error

return

error:

exec csp_RDWExtractError @AffiliateId = @AffiliateId, @ErrorText = ''Failed to execute csp_RDWExtractClientCoverages''
' 
END
GO
