
/****** Object:  UserDefinedFunction [dbo].[GetContractRateId]    Script Date: 12/07/2016 16:03:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetContractRateId]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[GetContractRateId]
GO


/****** Object:  UserDefinedFunction [dbo].[GetContractRateId]    Script Date: 12/07/2016 16:03:23 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

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
--12.07.2016   Bibhu       Added Left Join with ContractRateSites to get ContractRate
                           For SiteId(CEI-SGL #385)
*********************************************************************************/
begin
  
  declare @ContractRateId int
  declare @ContractId int

 
  select top 1 @ContractId = ContractId
    from Contracts
   where ProviderId = @ProviderId
     and InsurerId = @InsurerId
     and Status = 'A'
     and (StartDate <= @StartDate or StartDate is null)
     and (EndDate >= @EndDate or EndDate is null)
     and IsNull(RecordDeleted, 'N') = 'N'
   order by StartDate desc

  select Top 1 @ContractRateId = CR.ContractRateId  
    from ContractRates  CR
    Left Join ContractRateSites CRS on CR.ContractRateId=CRS.ContractRateId  and IsNull(CRS.RecordDeleted, 'N') = 'N' ---Added on 12.07.2016 by Bibhu 
   where CR.ContractId = @ContractId  
     and CR.BillingCodeId = @BillingCodeId  
     and CR.Active = 'Y'  
     and (CR.StartDate <= @StartDate or CR.StartDate is null)  
     and (CR.EndDate >= @EndDate or CR.EndDate is null)  
     and IsNull(CR.RecordDeleted, 'N') = 'N' 
     and (CR.ClientId = @ClientId or CR.ClientId is null)  
     and (CRS.SiteId = @SiteId or (CRS.SiteId is null AND CR.AllSites='Y') or @SiteId is null)  
     and (CR.Modifier1 = @Modifier1 or IsNull(CR.Modifier1, '') = '')   
     and (CR.Modifier2 = @Modifier2 or IsNull(CR.Modifier2, '') = '')   
     and (CR.Modifier3 = @Modifier3 or IsNull(CR.Modifier3, '') = '')   
     and (CR.Modifier4 = @Modifier4 or IsNull(CR.Modifier4, '') = '')   
   order by ClientId desc,   
            case when @SiteId is not null and CRS.SiteId is not null then 1  
                 when @SiteId is null and CRS.SiteId is null then 2  
                 else 3  
            end,  
            CR.Modifier1 desc,
            CR.Modifier2 desc,
            CR.Modifier3 desc,
            CR.Modifier4 desc,
            CR.StartDate desc,
            CR.ContractRate desc


  return @ContractRateId

end








GO


