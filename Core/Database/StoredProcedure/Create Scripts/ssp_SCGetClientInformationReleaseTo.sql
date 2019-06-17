IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientInformationReleaseTo]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCGetClientInformationReleaseTo]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[ssp_SCGetClientInformationReleaseTo]                        
@ClientId int,                            
@DisclosureId int ,                          
@DisclosureDate varchar(50)                                  
                                           
/********************************************************************************                                                      
-- Stored Procedure: dbo.[ssp_GetReleaseDisclosedTo]                                
--                                                      
-- Copyright: Streamline Healthcate Solutions                                                      
--                                                      
-- Purpose: used by  Disclosure detail page to bind the Release Dropdown                                                      
--                                                      
-- Updates:                                                                                                             
-- Date        Author      Purpose                                                      
-- 07.01.2010  Sahil Bhagat     Created.                                                            
-- 26.02.2015  PPOTNURU    Appended Startdate and Enddate to ReleaseToName, why task 170 Engineering Improvement Initiatives. 
-- Mar/1/2016   Basudev		Added code To hide ReleaseToName if it is  null  as it creating empty value with comma in   ReleaseToName fields  
							613.3 Network 180 Environment Issues Tracking                                            
*********************************************************************************/                                                      
as                                 
declare @TempDisclosureDate as datetime           
if(@DisclosureDate is not null)          
begin                          
    select distinct (isnull(convert(varchar,CIR.ReleaseToId),'') +'_'+ CONVERT(varchar, CIR.ClientInformationReleaseId)) as ReleaseToId,                
    case when ISNULL(CIR.ReleaseToName,'')<>'' then ISNULL( CIR.ReleaseToName,'')+', '+ISNULL(   CONVERT(VARCHAR, CIR.StartDate, 101),'')+' - '+ISNULL(  CONVERT(VARCHAR, CIR.EndDate, 101) ,'') 
    else ISNULL( CONVERT(VARCHAR, CIR.StartDate, 101),'')+' - '+ISNULL(  CONVERT(VARCHAR, CIR.EndDate, 101) ,'') end as  
    ReleaseToName                         
    from ClientInformationReleases as CIR where CIR.ClientId=@ClientId and ISNULL(CIR.RecordDeleted,'N')='N' and                            
    CONVERT(datetime, @DisclosureDate) >=  isnull(CIR.StartDate,CONVERT(datetime,@DisclosureDate)) and CONVERT(datetime,@DisclosureDate) <=isnull(CIR.EndDate,CONVERT(datetime,@DisclosureDate))-- and ISNULL(CIR.ReleaseToId,0)>0                            
    --CIR.StartDate>=@DisclosureDate and CIR.EndDate<=@DisclosureDate                  
end          
else          
begin          
select @TempDisclosureDate=DisclosureDate from ClientDisclosures where ClientDisclosureId=@DisclosureId and ISNULL(RecordDeleted,'N')='N'                            
 if (@TempDisclosureDate is not null)                            
  begin                            
    select distinct (isnull(convert(varchar,CIR.ReleaseToId),'') +'_'+ CONVERT(varchar, CIR.ClientInformationReleaseId)) as ReleaseToId,                
    case when ISNULL(CIR.ReleaseToName,'')<>'' then ISNULL( CIR.ReleaseToName,'')+', '+ISNULL(   CONVERT(VARCHAR, CIR.StartDate, 101),'')+' - '+ISNULL(  CONVERT(VARCHAR, CIR.EndDate, 101) ,'') 
    else ISNULL( CONVERT(VARCHAR, CIR.StartDate, 101),'')+' - '+ISNULL(  CONVERT(VARCHAR, CIR.EndDate, 101) ,'') end as  
    ReleaseToName                          
    from ClientInformationReleases as CIR where CIR.ClientId=@ClientId and ISNULL(CIR.RecordDeleted,'N')='N' and                            
    @TempDisclosureDate >=  isnull(CIR.StartDate,@TempDisclosureDate) and @TempDisclosureDate <=isnull(CIR.EndDate,@TempDisclosureDate)-- and ISNULL(CIR.ReleaseToId,0)>0                            
    --CIR.StartDate>=@DisclosureDate and CIR.EndDate<=@DisclosureDate                            
  end                            
 else                            
  begin                            
    select distinct (isnull(convert(varchar,CIR.ReleaseToId),'') +'_'+ CONVERT(varchar, CIR.ClientInformationReleaseId)) as ReleaseToId,  
    case when ISNULL(CIR.ReleaseToName,'')<>'' then ISNULL( CIR.ReleaseToName,'')+', '+ISNULL(   CONVERT(VARCHAR, CIR.StartDate, 101),'')+' - '+ISNULL(  CONVERT(VARCHAR, CIR.EndDate, 101) ,'') 
    else ISNULL( CONVERT(VARCHAR, CIR.StartDate, 101),'')+' - '+ISNULL(  CONVERT(VARCHAR, CIR.EndDate, 101) ,'') end as  
    ReleaseToName      
    from ClientInformationReleases as CIR where ClientId=@ClientId and  ISNULL(CIR.RecordDeleted,'N')='N' --and ISNULL(CIR.ReleaseToId,0)>0                            
  end           
end  