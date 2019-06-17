
/********************************************************************************                                                        
         
-- Copyright: Streamline Healthcare Solutions          
--          
-- Purpose: Called in Insert screen for Child and Adolescent Needs and Strengths (CANS) Document        
--          
-- Author:  Md Hussain Khusro          
-- Date:    02 July 2013   

/* Data Modifications:                                               */    
/*                                                                   */    
/*   Date     Author       Purpose                                    */    
/*                                    */    
/*********************************************************************/       
*********************************************************************************/  

SET IDENTITY_INSERT dbo.DocumentCodes ON
	IF NOT EXISTS (SELECT * FROM dbo.DocumentCodes WHERE DocumentCodeId = 12500)
		INSERT dbo.DocumentCodes
				(DocumentCodeId,
				 DocumentName,
				 DocumentType,
				 Active,
				 ServiceNote,
				 OnlyAvailableOnline,
				 ViewDocumentURL,
				 ViewDocumentRDL,
				 StoredProcedure,
				 TableList,
				 RequiresSignature,
				 InitializationStoredProcedure,
				 ValidationStoredProcedure,
				 ViewStoredProcedure)
		VALUES(	12500,
				'Child and Adolescent Needs and Strengths (CANS)',
				10,
				'Y',
				'N',
				'N',
				'RDLCANS',
				'RDLCANS',
				'csp_GetCustomDocumentCANS',
				'CustomDocumentCANSGenerals,CustomDocumentCANSYouthStrengths,CustomDocumentCANSModules',
				'Y',
				NULL,
				NULL,
				'csp_RDLCustomDocumentCANS')
			
	else
		Update DocumentCodes
	Set
	DocumentName='Child and Adolescent Needs and Strengths (CANS)',
	DocumentType=10,
	Active='Y',
	ServiceNote='N',
	
	ViewDocumentURL='RDLCANS',
	ViewDocumentRDL='RDLCANS',
	StoredProcedure='csp_GetCustomDocumentCANS',
	TableList='CustomDocumentCANSGenerals,CustomDocumentCANSYouthStrengths,CustomDocumentCANSModules',
	RequiresSignature ='Y',
	InitializationStoredProcedure=NULL,
	ValidationStoredProcedure=NULL,
	ViewStoredProcedure='csp_RDLCustomDocumentCANS'
	where DocumentCodeId=12500	
SET IDENTITY_INSERT dbo.DocumentCodes OFF	
 
SET IDENTITY_INSERT dbo.Screens ON
	IF NOT EXISTS (SELECT * FROM dbo.Screens WHERE ScreenId = 12500)
		INSERT  dbo.Screens
				( ScreenId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate,
				  ScreenName, ScreenType, ScreenURL, ScreenToolbarURL, TabId,InitializationStoredProcedure,DocumentCodeId,ValidationStoredProcedureComplete)
		VALUES  ( 12500, SYSTEM_USER, -- CreatedBy - type_CurrentUser
				  CURRENT_TIMESTAMP, -- CreatedDate - type_CurrentDatetime
				  SYSTEM_USER, -- ModifiedBy - type_CurrentUser
				  CURRENT_TIMESTAMP, -- ModifiedDate - type_CurrentDatetime
				  'CANS', -- ScreenName - varchar(100)
				  5763, -- ScreenType - type_GlobalCode
				  '/Custom/CANS/WebPages/CANS.ascx', -- ScreenURL - varchar(200)
				  NULL, -- ScreenToolbarURL - varchar(200)
				  2,  -- TabId - int
				  'csp_InitCustomDocumentCANS',
				  12500,
				  'csp_ValidateCustomDocumentCANS'  )      
	ELSE
	UPDATE Screens
	SET ScreenName='CANS',
	ScreenType=5763,
	ScreenURL='/Custom/CANS/WebPages/CANS.ascx',
	ScreenToolbarURL=NULL,
	TabId=2,
	InitializationStoredProcedure='csp_InitCustomDocumentCANS',
	DocumentCodeId=12500,
	ValidationStoredProcedureComplete='csp_ValidateCustomDocumentCANS'
	WHERE ScreenId=12500
				  
SET IDENTITY_INSERT dbo.Screens OFF
	IF NOT EXISTS (SELECT * FROM dbo.Banners WHERE BannerName = 'CANS')
		INSERT dbo.Banners
				( BannerName ,
				  DisplayAs ,
				  Active ,
				  DefaultOrder ,
				  Custom ,
				  TabId ,
				  ParentBannerId ,
				  ScreenId
				)
		VALUES  ( 'CANS' , -- BannerName - varchar(100)
				  'CANS' , -- DisplayAs - varchar(100)
				  'Y' , -- Active - type_Active
				  1 , -- DefaultOrder - int
				  'Y' , -- Custom - type_YOrN
				  2 , -- TabId - int
				  21 , -- ParentBannerId - int
				  12500  -- ScreenId - int
				)

