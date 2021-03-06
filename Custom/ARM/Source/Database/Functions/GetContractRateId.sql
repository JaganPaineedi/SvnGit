/****** Object:  UserDefinedFunction [dbo].[GetContractRateId]    Script Date: 06/19/2013 18:03:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetContractRateId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetContractRateId]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetContractRateId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'






create function [dbo].[GetContractRateId] (
@BillingCodeId int,
@ProviderId int,
@InsurerId  int,
@StartDate datetime,
@EndDate datetime,
@ClientId int,
@SiteId int,
@Modifier1 varchar(10),
@Modifier2 varchar(10),
@Modifier3 varchar(10),
@Modifier4 varchar(10))
returns int
/********************************************************************************
-- Function: dbo.GetContractRateId
--
-- Copyright: 2006 Streamline Healthcate Solutions
--
-- Creation Date:    07.10.2006                                          	
--                                                                   		
-- Purpose: Gets contract rate id
--
-- Updates:                     		                                
-- Date        Author      Purpose
-- 7.10.2006   SFarber     Created.      
--
*********************************************************************************/
begin
  
  declare @ContractRateId int
  declare @ContractId int

 
  select top 1 @ContractId = ContractId
    from Contracts
   where ProviderId = @ProviderId
     and InsurerId = @InsurerId
     and Status = ''A''
     and (StartDate <= @StartDate or StartDate is null)
     and (EndDate >= @EndDate or EndDate is null)
     and IsNull(RecordDeleted, ''N'') = ''N''
   order by StartDate desc

  select top 1 @ContractRateId = ContractRateId
    from ContractRates
   where ContractId = @ContractId
     and BillingCodeId = @BillingCodeId
     and Active = ''Y''
     and (StartDate <= @StartDate or StartDate is null)
     and (EndDate >= @EndDate or EndDate is null)
     and IsNull(RecordDeleted, ''N'') = ''N''
     and (ClientId = @ClientId or ClientId is null)
     and (SiteId = @SiteId or SiteId is null or @SiteId is null)
     and (Modifier1 = @Modifier1 or IsNull(Modifier1, '''') = '''') 
     and (Modifier2 = @Modifier2 or IsNull(Modifier2, '''') = '''') 
     and (Modifier3 = @Modifier3 or IsNull(Modifier3, '''') = '''') 
     and (Modifier4 = @Modifier4 or IsNull(Modifier4, '''') = '''') 
   order by ClientId desc, 
            case when @SiteId is not null and SiteId is not null then 1
                 when @SiteId is null and SiteId is null then 2
                 else 3
            end, 
            Modifier1 desc,
            Modifier2 desc,
            Modifier3 desc,
            Modifier4 desc,
            StartDate desc,
            ContractRate desc


  return @ContractRateId

end







' 
END
GO
