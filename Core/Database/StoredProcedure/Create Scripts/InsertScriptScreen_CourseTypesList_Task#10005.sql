
/********************************************************************************                                                        
         
-- Copyright: Streamline Healthcare Solutions          
--          
-- Purpose: Called in Insert screen for Course Type        
--           

/* Data Modifications:                                               */    
/*                                                                   */    
/*   Date			Author       Purpose                                    */    
/*   22 Mar 2018    Abhishek     Created                        */    
/*********************************************************************/       
*********************************************************************************/

SET IDENTITY_INSERT dbo.Screens ON
IF NOT EXISTS (SELECT
    *
  FROM dbo.Screens
  WHERE ScreenId = 1319)
  INSERT dbo.Screens (ScreenId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,
  ScreenName, ScreenType, ScreenURL, TabId)
    VALUES (1319, SYSTEM_USER, -- CreatedBy - type_CurrentUser
    CURRENT_TIMESTAMP, -- CreatedDate - type_CurrentDatetime
    SYSTEM_USER, -- ModifiedBy - type_CurrentUser
    CURRENT_TIMESTAMP, -- ModifiedDate - type_CurrentDatetime
    'Course Type', -- ScreenName - varchar(100)
    5762, -- ScreenType - type_GlobalCode
    '/Modules/Classroom/WebPages/CourseTypeList.ascx', -- ScreenURL - varchar(200)				
    4  -- TabId - int				  
    )

SET IDENTITY_INSERT dbo.Screens OFF
IF NOT EXISTS (SELECT
    *
  FROM dbo.Banners
  WHERE ScreenId = 1319)
  INSERT dbo.Banners (BannerName,
  DisplayAs,
  Active,
  DefaultOrder,
  Custom,
  TabId,
  ScreenId)
    VALUES ('Course Type', -- BannerName - varchar(100)
    'Course Type', -- DisplayAs - varchar(100)
    'Y', -- Active - type_Active
    1, -- DefaultOrder - int
    'N', -- Custom - type_YOrN
    4, -- TabId - int				
    1319  -- ScreenId - int
    )

INSERT INTO screenpermissioncontrols (ScreenId, ControlName, DisplayAs, Active)
  VALUES (1319, 'ButtonNew', 'New', 'Y')

INSERT INTO screenpermissioncontrols (ScreenId, ControlName, DisplayAs, Active)
  VALUES (1319, 'ButtonExport', 'Export', 'Y')