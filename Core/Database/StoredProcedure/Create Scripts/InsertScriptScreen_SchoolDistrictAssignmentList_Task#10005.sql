
/********************************************************************************                                                        
         
-- Copyright: Streamline Healthcare Solutions          
--          
-- Purpose: Called in Insert screen for School District Assignment         

/* Data Modifications:                                               */    
/*                                                                   */    
/*   Date			Author       Purpose                                    */    
/*   09 Apr 2018    Abhishek     Created                        */    
/*********************************************************************/       
*********************************************************************************/

SET IDENTITY_INSERT dbo.Screens ON
IF NOT EXISTS (SELECT
    *
  FROM dbo.Screens
  WHERE ScreenId = 1330)
  INSERT dbo.Screens (ScreenId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,
  ScreenName, ScreenType, ScreenURL, TabId)
    VALUES (1330, SYSTEM_USER, -- CreatedBy - type_CurrentUser
    CURRENT_TIMESTAMP, -- CreatedDate - type_CurrentDatetime
    SYSTEM_USER, -- ModifiedBy - type_CurrentUser
    CURRENT_TIMESTAMP, -- ModifiedDate - type_CurrentDatetime
    'School District Assignment', -- ScreenName - varchar(100)
    5762, -- ScreenType - type_GlobalCode
    '/Modules/Classroom/WebPages/SchoolDistrictAssignmentList.ascx', -- ScreenURL - varchar(200)				
    2  -- TabId - int				  
    )
    
    ELSE 
  BEGIN 
      UPDATE Screens 
      SET    ScreenName = 'School District Assignment', 
             ScreenType = 5762, 
             ScreenURL = '/Modules/Classroom/WebPages/SchoolDistrictAssignmentList.ascx', 
             TabId = 2            
      WHERE  ScreenId = 1330
  END 


     IF NOT EXISTS (SELECT
    *
  FROM dbo.Banners
  WHERE ScreenId = 1330)
  INSERT dbo.Banners (BannerName,
  DisplayAs,
  Active,
  DefaultOrder,
  Custom,
  TabId,
  ScreenId)
    VALUES ('School District Assignment', -- BannerName - varchar(100)
    'School District Assignment', -- DisplayAs - varchar(100)
    'Y', -- Active - type_Active
    1, -- DefaultOrder - int
    'N', -- Custom - type_YOrN
    2, -- TabId - int				
    1330  -- ScreenId - int
    )
    
     ELSE 
  BEGIN 
      UPDATE Banners 
      SET    BannerName = 'School District Assignment', 
			DisplayAs = 'School District Assignment', 
			Active = 'Y',
			DefaultOrder = 1,
			Custom = 'N',           
             TabId = 2            
      WHERE  ScreenId = 1330
  END 
    

IF NOT EXISTS (SELECT
    *
  FROM dbo.Screens
  WHERE ScreenId = 1334)
  INSERT dbo.Screens (ScreenId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,
  ScreenName, ScreenType, ScreenURL, TabId)
    VALUES (1334, SYSTEM_USER, -- CreatedBy - type_CurrentUser
    CURRENT_TIMESTAMP, -- CreatedDate - type_CurrentDatetime
    SYSTEM_USER, -- ModifiedBy - type_CurrentUser
    CURRENT_TIMESTAMP, -- ModifiedDate - type_CurrentDatetime
    'School District Assignment', -- ScreenName - varchar(100)
    5762, -- ScreenType - type_GlobalCode
    '/Modules/Classroom/WebPages/SchoolDistrictAssignmentList.ascx', -- ScreenURL - varchar(200)				
    1  -- TabId - int				  
    )

SET IDENTITY_INSERT dbo.Screens OFF    
     IF NOT EXISTS (SELECT
    *
  FROM dbo.Banners
  WHERE ScreenId = 1334)
  INSERT dbo.Banners (BannerName,
  DisplayAs,
  Active,
  DefaultOrder,
  Custom,
  TabId,
  ScreenId)
    VALUES ('School District Assignment', -- BannerName - varchar(100)
    'School District Assignment', -- DisplayAs - varchar(100)
    'Y', -- Active - type_Active
    1, -- DefaultOrder - int
    'N', -- Custom - type_YOrN
    1, -- TabId - int				
    1334  -- ScreenId - int
    )