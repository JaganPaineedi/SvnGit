
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
  WHERE ScreenId = 1323)
  INSERT dbo.Screens (ScreenId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,
  ScreenName, ScreenType, ScreenURL, TabId)
    VALUES (1323, SYSTEM_USER, -- CreatedBy - type_CurrentUser
    CURRENT_TIMESTAMP, -- CreatedDate - type_CurrentDatetime
    SYSTEM_USER, -- ModifiedBy - type_CurrentUser
    CURRENT_TIMESTAMP, -- ModifiedDate - type_CurrentDatetime
    'School District Assignment', -- ScreenName - varchar(100)
    5761, -- ScreenType - type_GlobalCode
    '/Modules/Classroom/WebPages/SchoolDistrictAssignmentMain.ascx', -- ScreenURL - varchar(200)				
    2  -- TabId - int				  
    )

SET IDENTITY_INSERT dbo.Screens OFF

INSERT INTO screenpermissioncontrols (ScreenId, ControlName, DisplayAs, Active)
  VALUES (1323, 'ButtonNew', 'New', 'Y')

INSERT INTO screenpermissioncontrols (ScreenId, ControlName, DisplayAs, Active)
  VALUES (1323, 'ButtonExport', 'Export', 'Y')
  
  SET IDENTITY_INSERT dbo.Screens ON
IF NOT EXISTS (SELECT
    *
  FROM dbo.Screens
  WHERE ScreenId = 1335)
  INSERT dbo.Screens (ScreenId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,
  ScreenName, ScreenType, ScreenURL, TabId)
    VALUES (1335, SYSTEM_USER, -- CreatedBy - type_CurrentUser
    CURRENT_TIMESTAMP, -- CreatedDate - type_CurrentDatetime
    SYSTEM_USER, -- ModifiedBy - type_CurrentUser
    CURRENT_TIMESTAMP, -- ModifiedDate - type_CurrentDatetime
    'School District Assignment', -- ScreenName - varchar(100)
    5761, -- ScreenType - type_GlobalCode
    '/Modules/Classroom/WebPages/SchoolDistrictAssignmentMain.ascx', -- ScreenURL - varchar(200)				
    2  -- TabId - int				  
    )

SET IDENTITY_INSERT dbo.Screens OFF

INSERT INTO screenpermissioncontrols (ScreenId, ControlName, DisplayAs, Active)
  VALUES (1335, 'ButtonNew', 'New', 'Y')

INSERT INTO screenpermissioncontrols (ScreenId, ControlName, DisplayAs, Active)
  VALUES (1335, 'ButtonExport', 'Export', 'Y')
  