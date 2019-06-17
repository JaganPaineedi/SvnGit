 /*********************************************************************************             
**  File: css_CreateGlobalCodeJailDiversionStatus.sql 
**  Name: Create Global Code Jail Diversion Status Script 
**  Desc: Creates Jail Diversion Global Code for the Jail Diversion Reports.
**                   
**  Created By:  Paul Ongwela 
**  Date:		 June 22, 2015 
**
...............................................................................                  
..  Change History                   
...............................................................................                  
..  Date:		Author:				Description:                   
..  --------	--------			-------------------------------------------    
..  06/22/2015  Paul Ongwela        Created.
..
..
**********************************************************************************/

 IF NOT EXISTS (SELECT * FROM   sys.columns WHERE  object_id = OBJECT_ID(N'[dbo].[CustomClients]') 
         AND name = 'JailDiversionStatus')Alter Table CustomClients Add JailDiversionStatus type_GlobalCode

IF NOT EXISTS(SELECT * FROM dbo.GlobalCodeCategories WHERE CategoryName = 'XJAILDIVERSIONSTATUS') 
INSERT INTO dbo.GlobalCodeCategories
        ( Category ,
          CategoryName ,
          Active ,
          AllowAddDelete ,
          AllowCodeNameEdit ,
          AllowSortOrderEdit ,
          Description ,
          UserDefinedCategory ,
          HasSubcodes ,
          UsedInPracticeManagement ,
          UsedInCareManagement ,
          ExternalReferenceId ,
          RowIdentifier 
        )
VALUES  ( 'XJAILDIVERSIONSTATUS' , -- Category - char(20)
          'XJAILDIVERSIONSTATUS' , -- CategoryName - varchar(250)
          'Y' , -- Active - type_Active
          'Y' , -- AllowAddDelete - type_YOrN
          'N' , -- AllowCodeNameEdit - type_YOrN
          'Y' , -- AllowSortOrderEdit - type_YOrN
          'Jail Diversion Status' , -- Description - type_Comment
          'Y' , -- UserDefinedCategory - type_YOrN
          'N' , -- HasSubcodes - type_YOrN
          NULL , -- UsedInPracticeManagement - type_YOrN
          NULL , -- UsedInCareManagement - type_YOrN
          NULL , -- ExternalReferenceId - type_ExternalReferenceId
          NEWID()  -- RowIdentifier - type_GUID
        )        
        
CREATE TABLE #stupidGlobalCodes (CodeId INT IDENTITY(1,1), CodeName VARCHAR(200))
INSERT INTO #stupidGlobalCodes
        ( CodeName )
VALUES('Pre-booking'), 
	  ('Post-booking')  

DELETE FROM dbo.GlobalCodes
WHERE Category = 'XJAILDIVERSIONSTATUS'

INSERT INTO dbo.GlobalCodes
        ( Category ,
          CodeName ,
          Code ,
          Description ,
          Active ,
          CannotModifyNameOrDelete ,
          SortOrder ,
          ExternalCode1 ,
          ExternalSource1 ,
          ExternalCode2 ,
          ExternalSource2 ,
          Bitmap ,
          BitmapImage ,
          Color
        )
SELECT   'XJAILDIVERSIONSTATUS' , -- Category - char(20)
          CodeName , -- CodeName - varchar(250)
          NULL , -- Code - varchar(100)
          NULL , -- Description - type_Comment
          'Y' , -- Active - type_Active
          'N' , -- CannotModifyNameOrDelete - type_YOrN
          CodeId, -- SortOrder - int
          NULL , -- ExternalCode1 - varchar(25)
          NULL , -- ExternalSource1 - type_GlobalCode
          NULL , -- ExternalCode2 - varchar(25)
          NULL , -- ExternalSource2 - type_GlobalCode
          NULL , -- Bitmap - varchar(200)
          NULL , -- BitmapImage - image
          NULL  -- Color - varchar(10)
FROM #stupidGlobalCodes    


DROP TABLE #stupidGlobalCodes

--SELECT * FROM dbo.GlobalCodes gc
--WHERE Category = 'XJAILDIVERSIONSTATUS'
  