
/****** Object:  StoredProcedure [dbo].[ssp_ReportPrint1099s]    Script Date: 09/06/2016 17:41:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ReportPrint1099s]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ReportPrint1099s]
GO


/****** Object:  StoredProcedure [dbo].[ssp_ReportPrint1099s]    Script Date: 09/06/2016 17:41:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
CREATE procedure [dbo].[ssp_ReportPrint1099s]    
@InsurerId      int,  
@CalendarYear datetime,  
--@TaxId1   char(9) = null,  
--@TaxId2         char(9) = null 
@TaxId1 varchar(max) =null,  
@TaxId2 varchar(max)=null   
/********************************************************************************    
-- Stored Procedure: dbo.ReportPrint1099s      
--    
-- Copyright: 2006 Streamline Healthcate Solutions    
--    
-- Creation Date:    11.17.2006                                               
--                                                                         
-- Purpose: Print 1099 report    
--    
-- Updates:                                                           
-- Date        Author      Purpose    
-- 11.17.2006  RNoble      Created.          
-- 01.30.2007  SFarber     Added RecipientFIN.    
-- 01.23.2009  SFarber     Modified to Summit Pointe information in case of Venture SA.    
-- 09.06.2016  MD Hussain  committed missing ssp for Print 1099 Forms Report in SVN w.r.t SWMBH - Support #483   
-- 12-July-2017 Sachin  What : When we are selecting the Multiple checks in Popup, it should display multiple checkboxes report
                        Why : AspenPointe - Support Go Live #106  
-- 21-November-2017 Sachin WHat : When user is selecting the main checkbox and based on main chaeck box selection it is selecting all sub checkboxes, it was throwng as error i.e. server not found.
                                  because url length is exceeding. To solve this issue from ui passing the 'ALL' and filtering all records on click of main check box.
                           Why  : Kalamazoo Build Cycle Tasks #41.       
*********************************************************************************/    
as    

  IF EXISTS (SELECT  *  FROM    sys.objects  
				        WHERE   OBJECT_ID = OBJECT_ID(N'[scsp_ReportPrint1099s]')  
				        AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1 )   
   BEGIN  
						exec scsp_ReportPrint1099s @InsurerId, @CalendarYear, @TaxId1,@TaxId2  
						      
   Return
   END 
        
-- Added By Sachin  
IF (@TaxId1 ='ALL' AND  @TaxId2 ='ALL')  
BEGIN   
 create table #TempTable (   
 Checkbox1 int,    
 ProviderID1 int,      
 ProviderName1 varchar(max),  
 TaxId1   varchar(9) )   
   
INSERT INTO #TempTable (Checkbox1,ProviderID1,ProviderName1,TaxId1)   
   
select distinct  0 as Checkbox, P.ProviderID,P.ProviderName , S.Taxid from Providers P  Left outer join Sites S on          
P.providerID = S.ProviderID and isNull(S.RecordDeleted,'N') = 'N' and S.Active = 'Y'      
where  isNull(P.RecordDeleted,'N') = 'N'   and P.active = 'Y'        
order by P.ProviderName    
  
DECLARE  @TaxIdList TABLE  
(TaxId varchar(max),  
TaxId2 varchar(max))  
  
INSERT INTO @TaxIdList(TaxId,TaxId2)select TaxId1,TaxId1 from #TempTable    
Drop table #TempTable  
  
END  
--END Sachin Changes
ELSE    
BEGIN 
--DECLARE  @TaxIdList TABLE(TaxId char(9))
--DECLARE  @TaxId2List TABLE(TaxId2 char(9))

INSERT INTO @TaxIdList(TaxId)
SELECT item
from dbo.fnsplit(@TaxId1,',')

UNION
SELECT item
from dbo.fnsplit(@TaxId2,',')
END 

create table #1099 (    
RecordId           int identity not null,    
PageNumber           int,    
FormNumber                  int,    
PayerDetails       varchar(500),    
PayerFIN           char(10),    
RecipientFIN                char(11),    
RecipientName       varchar(200),    
RecipientStreetAddress  varchar(200),    
RecipientCityStateZipCode varchar(200),    
Box6            money,    
Box18           money)    
    
create Table #Payments (    
InsurerId  int,    
ProviderId  int,    
TaxIdType       char(1),    
TaxId   varchar(9),    
Amount   money,    
SiteId          int,    
SiteAddressId   int)    
    
create table #Refunds (    
InsurerId  int,    
ProviderId  int,    
TaxIdType       char(1),    
TaxId   varchar(9),    
Amount   money)    
    
declare @VentureSAInsurerId int    
declare @SummitPointeInsurerId int    
    
set @VentureSAInsurerId = 6    
set @SummitPointeInsurerId = 4    
    
insert into #Payments (    
       InsurerId,    
       ProviderId,    
       TaxIdType,    
       TaxId,    
       Amount)    
select c.InsurerId,     
       c.ProviderId,    
       max(c.TaxIdType),     
       c.TaxId,     
       sum(c.Amount)    
  from Checks c     
 where c.InsurerId = @InsurerId    
   --and (c.TaxId in (@TaxId1, @TaxId2) or @TaxId1 is null)   
   AND ( c.TaxId IN (select TaxId from @TaxIdList)--( @TaxId1, @TaxId2 )  
                          OR ISNULL(c.TaxId,0)=0  
                        )  
   and isnull(c.Voided, 'N') <> 'Y'    
   and isnull(c.RecordDeleted,'N') <> 'Y'    
   and datediff(year, c.checkdate, @CalendarYear) = 0    
 group by c.InsurerId,    
          c.ProviderId,    
          c.TaxId    
    
insert into #Refunds (    
       InsurerId,    
       ProviderId,    
       TaxIdType,    
       TaxId,    
       Amount)    
select pr.InsurerId,    
       pr.ProviderId,    
       max(pr.TaxIdType),    
       pr.TaxId,    
       sum(pr.Amount)     
  from ProviderRefunds pr    
 where pr.InsurerId = @InsurerId    
   --and (pr.TaxId in (@TaxId1, @TaxId2) or @TaxId1 is null)    
    AND ( pr.TaxId IN (select TaxId from @TaxIdList)--( @TaxId1, @TaxId2 )  
                          OR ISNULL(pr.TaxId,0)=0 
                        ) 
   and isnull(pr.RecordDeleted,'N') <> 'Y'    
   and datediff(year,pr.checkdate,@CalendarYear) = 0    
 group by pr.InsurerId,    
          pr.ProviderId,    
          pr.TaxId    
    
update p    
   set p.Amount = p.Amount - r.Amount    
  from #Payments p    
       join #Refunds r on r.InsurerId = p.InsurerId and    
                          r.ProviderId = p.ProviderId and    
                          r.TaxId = p.TaxId    
    
    
update p    
   set SiteId = s.SiteId,    
       SiteAddressId = sa.SiteAddressId    
  from #Payments p    
       join Sites s on s.TaxId = p.TaxId and s.ProviderId = p.ProviderId    
       join SiteAddressess sa on sa.SiteId = s.SiteId and sa.for1099 = 'Y'    
   and isnull(s.RecordDeleted,'N') <> 'Y'    
   and isnull(sa.RecordDeleted,'N') <> 'Y'    
    
update p    
   set SiteId = s.SiteId,    
       SiteAddressId = sa.SiteAddressId    
  from #Payments p    
       join Sites s on s.TaxId = p.TaxId and s.ProviderId = p.ProviderId    
       join SiteAddressess sa on sa.SiteId = s.SiteId and sa.Billing = 'Y'    
 where p.SiteId is null    
   and isnull(s.RecordDeleted,'N') <> 'Y'    
   and isnull(sa.RecordDeleted,'N') <> 'Y'    
    
update p    
   set SiteId = s.SiteId,    
       SiteAddressId = sa.SiteAddressId    
  from #Payments p    
       join Sites s on s.TaxId = p.TaxId and s.ProviderId = p.ProviderId    
       join SiteAddressess sa on sa.SiteId = s.SiteId and sa.AddressType = 2282 -- Office    
 where p.SiteId is null    
   and isnull(s.RecordDeleted,'N') <> 'Y'    
   and isnull(sa.RecordDeleted,'N') <> 'Y'    
    
update p    
   set SiteId = s.SiteId,    
       SiteAddressId = sa.SiteAddressId    
  from #Payments p    
       join Sites s on s.TaxId = p.TaxId and s.ProviderId = p.ProviderId    
       join SiteAddressess sa on sa.SiteId = s.SiteId    
 where p.SiteId is null    
   and isnull(s.RecordDeleted,'N') <> 'Y'    
   and isnull(sa.RecordDeleted,'N') <> 'Y'    
    
update p    
   set TaxIdType = s.TaxIdType    
  from #Payments p    
       join Sites s on s.SiteId = p.SiteId    
 where isnull(p.TaxIdType, 'N') <> isnull(s.TaxIdType, 'N')     
    
-- Replace Venture SA insurer ID with Summit Pointe insurer ID    
-- since Summit Pointe information should be displayed on 1099    
if @InsurerId = @VentureSAInsurerId    
  update #Payments set InsurerId = @SummitPointeInsurerId    
    
insert into #1099 (    
       PayerDetails,    
       PayerFIN,    
       RecipientFIN,    
       RecipientName,    
       RecipientStreetAddress,    
       RecipientCityStateZipCode,    
       Box6,    
       Box18)    
select i.LegalName + char(13) + char(10) + isnull(ia.Display, '') + char(13) + char(10) + isnull(i.ContactPhone, ''),    
       left(i.TaxId, 2) + '-' + substring(i.TaxId, 3, 7),    
       case when len(pay.TaxId) <> 9 or isnumeric(pay.TaxId) = 0 or pay.TaxId = replicate('9', 9) or    
                 pay.TaxId = replicate('0', 9) or pay.TaxId = replicate('1', 9) or pay.TaxId = replicate('2', 9) or     
                 pay.TaxId = replicate('3', 9) or pay.TaxId = replicate('4', 9) or pay.TaxId = replicate('5', 9) or    
                 pay.TaxId = replicate('6', 9) or pay.TaxId = replicate('7', 9) or pay.TaxId = replicate('8', 9)    
            then null      
            else case pay.TaxIdType    
                      when 'E' then left(pay.TaxId, 2) + '-' + substring(pay.TaxId, 3, 7)    
                      when 'S' then left(pay.TaxId, 3) + '-' + substring(pay.TaxId, 4, 2) + '-' + substring(pay.TaxId, 6, 4)    
                      else pay.TaxId    
                 end    
       end,    
       case when p.ProviderType = 'I' and p.FirstName is not null     
            then p.FirstName + ' ' + p.ProviderName    
            else p.ProviderName    
       end,    
       sa.Address,    
       sa.City + ', ' + sa.State + ' ' +sa.Zip,    
       pay.Amount,    
       pay.Amount    
  from Insurers i    
       join InsurerAddresses ia on i.InsurerId = ia.InsurerId and ia.AddressType = 91 -- Office    
       join #Payments pay on i.InsurerId = pay.InsurerId    
       join Providers p on p.ProviderId = pay.ProviderId    
       join SiteAddressess sa on sa.SiteAddressId = pay.SiteAddressId    
 order by p.ProviderName,    
          pay.TaxId    
    
update #1099    
   set PageNumber = RecordId/2 + RecordId%2,    
       FormNumber = case when RecordId%2 = 0 then 2 else 1 end    
    
select PageNumber,    
       max(case when FormNumber = 1 then PayerDetails else null end) as PayerDetails_1,    
       max(case when FormNumber = 1 then PayerFIN else null end) as PayerFIN_1,    
       max(case when FormNumber = 1 then RecipientFIN else null end) as RecipientFIN_1,    
       max(case when FormNumber = 1 then RecipientName else null end) as RecipientName_1,    
       max(case when FormNumber = 1 then RecipientStreetAddress else null end) as RecipientStreetAddress_1,    
       max(case when FormNumber = 1 then RecipientCityStateZipCode else null end) as RecipientCityStateZipCode_1,    
       max(case when FormNumber = 1 then Box6 else null end) as Box6_1,    
       max(case when FormNumber = 1 then Box18 else null end) as Box18_1,    
       max(case when FormNumber = 2 then PayerDetails else null end) as PayerDetails_2,    
       max(case when FormNumber = 2 then PayerFIN else null end) as PayerFIN_2,    
       max(case when FormNumber = 2 then RecipientFIN else null end) as RecipientFIN_2,    
       max(case when FormNumber = 2 then RecipientName else null end) as RecipientName_2,    
       max(case when FormNumber = 2 then RecipientStreetAddress else null end) as RecipientStreetAddress_2,    
       max(case when FormNumber = 2 then RecipientCityStateZipCode else null end) as RecipientCityStateZipCode_2,    
       max(case when FormNumber = 2 then Box6 else null end) as Box6_2,    
       max(case when FormNumber = 2 then Box18 else null end) as Box18_2    
  from #1099    
 group by PageNumber    
 order by PageNumber    
  
    
    
return    
GO


