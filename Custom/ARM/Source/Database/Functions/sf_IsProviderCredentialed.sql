/****** Object:  UserDefinedFunction [dbo].[sf_IsProviderCredentialed]    Script Date: 06/19/2013 18:03:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sf_IsProviderCredentialed]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[sf_IsProviderCredentialed]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sf_IsProviderCredentialed]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
Create function [dbo].[sf_IsProviderCredentialed] (
@InsurerId int,
@ProviderId int,
@SiteId int,
@FromDate datetime,
@ToDate datetime,
@BillingCodeId int,
@Modifier1 varchar(10),
@Modifier2 varchar(10),
@Modifier3 varchar(10),
@Modifier4 varchar(10))
returns char(1)
/*********************************************************************              
-- Function: dbo.sf_IsProviderCredentialed    
-- Copyright: Streamline Healthcare Solutions    
-- Creation Date:  09/20/2011                         
--                                                     
-- Purpose: determines if provider is credentialed   
--                                                                                      
-- Modified Date    Modified By  Purpose    
-- 09.20.2011       SFarber      Created
****************************************************************************/               
as
begin

declare @Credentialing table (SiteId int, BillingCodeId int, AnyModifier char(1), Modifier1 varchar(10), Modifier2 varchar(10), Modifier3 varchar(10), Modifier4 varchar(10))

declare @SiteCredentialed char(1)
declare @BillingCodeCredentialed char(1)

select @SiteCredentialed = ''N'', @BillingCodeCredentialed = ''N''

if @ToDate is null
  set @ToDate = @FromDate

-- Get all credentialing record for provider
insert into @Credentialing (SiteId, BillingCodeId, AnyModifier, Modifier1, Modifier2, Modifier3, Modifier4)
select c.SiteId, cpbc.BillingCodeId, cpbc.AnyModifier, cpbc.Modifier1, cpbc.Modifier2, cpbc.Modifier3, cpbc.Modifier4
  from Credentialing c
       join CredentialingProviderBillingCodes cpbc on cpbc.ProviderId = c.ProviderId
 where c.ProviderId = @ProviderId
   and (c.PerformedBy = @InsurerId or c.Share = ''Y'')
   and c.Status = 2642 -- Completed
   and @FromDate <= @ToDate
   and c.EffectiveFrom <= @FromDate
   and (c.ExpirationDate is null or dateadd(dd, 1, c.ExpirationDate) > @ToDate)
   and cpbc.FromDate <= @FromDate
   and (cpbc.ToDate is null or dateadd(dd, 1, cpbc.ToDate) > @ToDate)
   and isnull(c.RecordDeleted, ''N'') = ''N''
   and isnull(cpbc.RecordDeleted, ''N'') = ''N''

-- Check is the site is credentialed:
--  if @SiteId is not passed, there has to be a record with SiteId set to null
--  if @SiteId is passed, there has to be a record matching on @SiteId or with SiteId set to null;
if @SiteId is null and exists(select * from @Credentialing where SiteId is null) 
  set @SiteCredentialed = ''Y''  
else if exists(select * from @Credentialing where isnull(SiteId, @SiteId) = @SiteId)
  set @SiteCredentialed = ''Y''  

-- Check if the billing code is credentialed:
--  if @BillingCodeId is not passed, assume it is credentialed;
--  if @BillingCodeId is passed, there has to be a record:
--    with @BillingCodeId set to null and AnyModifier set to Y or
--    matching on @BillingCodeId and AnyModifier set to Y or
--    matching on @BillingCodeId and all modifiers
if @SiteCredentialed = ''Y''
begin
  if @BillingCodeId is null 
    set @BillingCodeCredentialed = ''Y''
  else if @BillingCodeId is not null and exists(select * 
                                                  from @Credentialing 
                                                 where isnull(BillingCodeId, @BillingCodeId) = @BillingCodeId 
                                                   and AnyModifier = ''Y'')
    set @BillingCodeCredentialed = ''Y''
  else if @BillingCodeId is not null and exists(select * 
                                                  from @Credentialing 
                                                 where BillingCodeId = @BillingCodeId 
                                                   and isnull(Modifier1, '''') = isnull(@Modifier1, '''')
                                                   and isnull(Modifier2, '''') = isnull(@Modifier2, '''')
                                                   and isnull(Modifier3, '''') = isnull(@Modifier3, '''')
                                                   and isnull(Modifier4, '''') = isnull(@Modifier4, ''''))
                                                   
    set @BillingCodeCredentialed = ''Y''
end
  
return case when @SiteCredentialed = ''Y'' and @BillingCodeCredentialed = ''Y'' then ''Y'' else ''N'' end

end

' 
END
GO
