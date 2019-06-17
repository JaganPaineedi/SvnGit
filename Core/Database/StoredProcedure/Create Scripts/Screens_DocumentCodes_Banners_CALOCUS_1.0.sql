/********************************************************************************                                                    
-- Copyright: Streamline Healthcare Solutions    
-- Author:  Kaushal Kishor Pandey
-- Created Date:    26-Nov-2018   
-- Purpose: created new copy of LOCUS TO CALOCUS for task#21 	MHP - Enhancements - CALOCUS
*********************************************************************************/ 
----------------------------------------   DocumentCodes Table   -----------------------------------  

-- Declaration of variable
DECLARE @DocumentCodeId INT
DECLARE @DocumentName VARCHAR(100)
DECLARE @Code VARCHAR(250)
DECLARE @DocumentType INT 
DECLARE @Active CHAR(1) 
DECLARE @ServiceNote CHAR(1)
DECLARE @ViewDocumentURL VARCHAR(500)
DECLARE @ViewDocumentRDL VARCHAR(500)
DECLARE @StoredProcedure VARCHAR(100)
DECLARE @TableList VARCHAR(MAX)
DECLARE @RequiresSignature CHAR(1)
DECLARE @InitializationStoredProcedure VARCHAR(100)
DECLARE @ViewStoredProcedure VARCHAR(100)
DECLARE @RecreatePDFOnClientSignature CHAR(1)
DECLARE @RegenerateRDLOnCoSignature CHAR(1)

 -- Setting value to the variables

SET @DocumentName = 'CALOCUS'
SET @Code ='FB823686-2E4B-4350-A8C0-8F4B47EC4712'
SET @DocumentType = 10
SET @Active = 'Y'
SET @ServiceNote = 'N'	
SET @StoredProcedure ='ssp_SCGetDocumentCALOCUS'
SET @TableList ='DocumentCALOCUS'
SET @ViewDocumentURL ='RDLDocumentCALOCUS'
SET @ViewDocumentRDL ='RDLDocumentCALOCUS'
SET @RequiresSignature ='Y'
SET @ViewStoredProcedure = 'ssp_RDLDocumentCALOCUS'
SET @RecreatePDFOnClientSignature = 'Y'
SET @RegenerateRDLOnCoSignature = 'Y'


	IF NOT EXISTS (SELECT top 1 DocumentCodeId 
	FROM   DocumentCodes 
	WHERE  Code =@Code) 

	BEGIN 

		INSERT INTO [dbo].[DocumentCodes] ([DocumentName], [DocumentDescription], [DocumentType], [Active], [ServiceNote],   [ViewDocumentURL], [ViewDocumentRDL], [StoredProcedure], [TableList], [RequiresSignature], [ViewStoredProcedure], [RecreatePDFOnClientSignature], [RegenerateRDLOnCoSignature], [Code]) VALUES 
				(@DocumentName,  @DocumentName,   @DocumentType, @Active,  @ServiceNote,   @ViewDocumentURL,   @ViewDocumentRDL, @StoredProcedure,  @TableList,  @RequiresSignature,  @ViewStoredProcedure, @RecreatePDFOnClientSignature,  @RegenerateRDLOnCoSignature,  @Code)

		SET @DocumentCodeId = @@Identity


	END 

   
   -----------------------------------------------END--------------------------------------------  
----------------------------------------   Screens Table   -----------------------------------  
/*   
  Please change these variables for supporting a new page/document/widget   
  Screen Types:   
    None:               0,   
        Detail:             5761,   
        List:               5762,   
        Document:           5763,   
        Summary:            5764,   
        Custom:             5765,   
        ExternalScreen:     5766   
*/

--DECLARE @ScreenName VARCHAR(100) 
DECLARE @ScreenType INT 
DECLARE @ScreenURL VARCHAR(200) 
DECLARE @TabId INT 
DECLARE @ValidationStoredProcedureComplete VARCHAR(500) 

SET @ScreenType = 5763 
SET @ScreenURL = '/Modules/CALOCUS/WebPages/CALOCUSMain.ascx'
SET @TabId = 2 
SET @InitializationStoredProcedure = 'ssp_InitDocumentCALOCUS' 
SET @ValidationStoredProcedureComplete= 'SSP_ValidateDocumentCALOCUS'
Declare @ScreenId int


IF NOT EXISTS (SELECT top 1 ScreenId 
               FROM   Screens 
               WHERE  Code =@Code) 
  BEGIN 

      INSERT INTO [Screens] 
                ( [ScreenName], 
                   [ScreenType], 
                   [ScreenURL], 
                   [TabId], 
                   [InitializationStoredProcedure], 
                   [ValidationStoredProcedureComplete], 
                   [DocumentCodeId],
                   [Code]) 
      VALUES      (  
                    @DocumentName, 
                    @ScreenType, 
                    @ScreenURL, 
                    @TabId, 
                    @InitializationStoredProcedure, 
                    @ValidationStoredProcedureComplete, 
                    @DocumentCodeId,
                    @Code) 
                    
                   set @ScreenId = @@Identity

  END 
   
 -----------------------------------------------END--------------------------------------------  

  ----------------------------------------   Banner Table   -----------------------------------  
--DECLARE @BannerName VARCHAR(100)
DECLARE @dispalyAs VARCHAR(100) 
DECLARE @DefaultOrder INT
DECLARE @IsCustom CHAR(1)
DECLARE @ParentBannerId INT
DECLARE @ParentBannerIdForNavigation INT
DECLARE @BHTEDSBannerId INT

SET @DefaultOrder = 5
SET @IsCustom = 'N'
SET @ParentBannerId =21

IF NOT EXISTS (SELECT 1 FROM dbo.Banners WHERE ScreenId = (Select top 1 screenId From Screens Where Code =@Code))
	BEGIN	
		INSERT dbo.Banners
				( 
				  BannerName ,
				  DisplayAs ,
				  Active ,
				  DefaultOrder ,
				  Custom ,
				  TabId ,
				  ParentBannerId,
				  ScreenId		  
				)
		VALUES  ( @DocumentName , -- BannerName - varchar(100)
				  @DocumentName , -- DisplayAs - varchar(100)
				  @Active , -- Active - type_Active
				  @DefaultOrder , -- DefaultOrder - int
				  @IsCustom , -- Custom - type_YOrN
				  @TabId , -- TabId - int
				  @ParentBannerId,
				  @ScreenId
				)		
	END	

	
----------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE @BannerId INT=(SELECT TOP 1 BannerID FROM Banners 
	WHERE BannerName=@DocumentName AND DisplayAs=@DocumentName 
		AND ISNULL(RecordDeleted,'N')<>'Y' AND Active='Y' AND ScreenId=(Select top 1 screenId From Screens Where Code =@Code))

IF NOT EXISTS (SELECT 1 FROM DocumentNavigations 
					WHERE NavigationName=@DocumentName AND BannerId=@BannerId 
							AND ScreenId=(Select top 1 screenId From Screens Where Code =@Code))
BEGIN
	INSERT INTO DocumentNavigations(NavigationName,DisplayAs,Active,ParentDocumentNavigationId,BannerId,ScreenId)
	VALUES (@DocumentName,@DocumentName,'Y',NULL,@BannerId,@ScreenId)
END


------------------------------------------------------------------------------------------------------------------------------------------------------





