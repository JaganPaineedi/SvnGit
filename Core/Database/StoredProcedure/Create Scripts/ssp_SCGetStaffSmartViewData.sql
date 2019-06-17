/****** Object:  StoredProcedure [dbo].[ssp_SCGetStaffSmartViewData]    Script Date: 10/17/2017 15:02:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetStaffSmartViewData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetStaffSmartViewData]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetStaffSmartViewData] 13460   Script Date: 10/17/2017 15:02:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

               
CREATE proc [dbo].[ssp_SCGetStaffSmartViewData]        
(                      
  @StaffId int   = null                                   
)                      
as                  
/******************************************************************************                        
**  File: ssp_SCGetStaffSmartViewData.sql                       
**  Name: ssp_SCGetStaffSmartViewData   550
**  Desc: To Retrive SmartView Sections Data.
**  Return values:                        
**  Parameters:                     
**  Auth: Manjunath K                        
**  Date: 28 OCT 2017             
*******************************************************************************                        
**  Change History                        
*******************************************************************************                        
**  Date:      Author:     Description:                        
**  ---------  --------    -------------------------------------------                        
**      
*************************************************************************************/                      
BEGIN                     
                
BEGIN TRY                 

select 
SV.SectionName,
SV.DisplayAs as SectionHeading,
SV.SectionURL ,
isnull(SV.ScreenIdToRedirect,'') as ScreenIdToRedirect,
SV.SmartViewSectionId,
SV.DefaultOrder as  SectionOrder,
v.StaffId,
SV.DisplayAs,
IsNull(SV.SectionHeight,90) as SectionHeight,
sc.ScreenType,
sc.TabId,
SV.JavascriptFilePath,
DetailPageScreenId
from viewstaffpermissions v     
inner join SmartViewSections SV on v.permissionitemid=SV.SmartViewSectionId
Left Join Screens sc on sc.ScreenId = sv.ScreenIdToRedirect AND ISNULL(sc.RecordDeleted,'N')<>'Y'
cross Join SystemConfigurationKeys SK 
where v.permissiontemplatetype=5929  and v.staffid=@StaffId  and Isnull(SV.RecordDeleted,'N')<>'Y'    
and sv.SmartViewSectionId=v.PermissionItemId AND SK.Value='Yes' AND SK.[Key] = 'SHOWSMARTVIEW'
order by SectionOrder asc


END TRY                                                                                    
BEGIN CATCH                                        
DECLARE @Error varchar(8000)                                                                                   
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                 
+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),                                
'ssp_SCGetStaffSmartViewData')                                                                                                                   
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                                    
    + '*****' + Convert(varchar,ERROR_STATE())                                                                
 RAISERROR                                                                                       
 (                                                                                     
  @Error, -- Message text.                                                                                                       
  16, -- Severity.                                                                                                                  
  1 -- State.                                           
 );                                                                                                                
END CATCH                  
end
GO