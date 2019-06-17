
/********************************************************************************                                                        
         
-- Copyright: Streamline Healthcare Solutions          
--          
-- Purpose: Called in Insert screen for Course Type Details        
--          

/* Data Modifications:                                               */    
/*                                                                   */    
/*   Date			Author       Purpose                                    */    
/*   09 Mar 2018    Abhishek     Created                        */    
/*********************************************************************/       
*********************************************************************************/

SET IDENTITY_INSERT dbo.Screens ON
IF NOT EXISTS (SELECT
    *
  FROM dbo.Screens
  WHERE ScreenId = 1316)
  INSERT dbo.Screens (ScreenId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,
  ScreenName, ScreenType, ScreenURL, TabId)
    VALUES (1316, SYSTEM_USER, -- CreatedBy - type_CurrentUser
    CURRENT_TIMESTAMP, -- CreatedDate - type_CurrentDatetime
    SYSTEM_USER, -- ModifiedBy - type_CurrentUser
    CURRENT_TIMESTAMP, -- ModifiedDate - type_CurrentDatetime
    'Course Type', -- ScreenName - varchar(100)
    5761, -- ScreenType - type_GlobalCode
    '/Modules/Classroom/WebPages/CourseTypeMain.ascx', -- ScreenURL - varchar(200)				
    4  -- TabId - int				  
    )
ELSE
  UPDATE Screens
  SET ScreenName = 'Course Type',
      ScreenType = 5761,
      ScreenURL = '/Modules/Classroom/WebPages/CourseTypeMain.ascx',
      TabId = 4

  WHERE ScreenId = 1316

SET IDENTITY_INSERT dbo.Screens OFF

INSERT INTO screenpermissioncontrols (ScreenId, ControlName, DisplayAs, Active)
  VALUES (1316, 'ButtonNew', 'New', 'Y')

INSERT INTO screenpermissioncontrols (ScreenId, ControlName, DisplayAs, Active)
  VALUES (1316, 'ButtonSave', 'Save', 'Y')

INSERT INTO screenpermissioncontrols (ScreenId, ControlName, DisplayAs, Active)
  VALUES (1316, 'ButtonDelete', 'Delete', 'Y')


/********************************************************************************/                                                       