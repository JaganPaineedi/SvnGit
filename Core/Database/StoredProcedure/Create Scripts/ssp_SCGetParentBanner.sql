IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetParentBanner]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetParentBanner]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure ssp_SCGetParentBanner

/************************************************************************************************                        
**  File:	ssp_SCGetParentBanner.sql                                       
**  Name:	ssp_SCGetParentBanner                                         
**  Desc:	This stored Procedure is for getting the list of Parent Banner from Banners.
**
**  Parameters: 
**  Input  
**  Output     ----------       ----------- 
**  
**  Author:  Rachna Singh
**  Date:    May 11, 2012
*************************************************************************************************
**  Change History 
**  Date:		Author:			Description: 
**  5/6/2015	Steczynski		Add BannerName to 'TextField', System Improvements - SmartCare Permissions #1, Item 2.a 
**
*************************************************************************************************/ 

AS
BEGIN
  BEGIN TRY
	SELECT BannerId as 'ValueField' ,
	CASE WHEN BannerName = DisplayAs THEN BannerName ELSE BannerName + ' (' + DisplayAs + ')' END AS 'TextField' 
	FROM Banners where  isnull(RecordDeleted,'N')='N'
END TRY
BEGIN CATCH
 DECLARE @Error varchar(8000)                                                                                                                                  
         SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                                   
         + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetParentBanner')                                                                                                                                   
         + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                                                   
         + '*****' + Convert(varchar,ERROR_STATE())                                                                                                                 
        RAISERROR                                                                          
   (                                                                            
     @Error, -- Message text.                                                                                                
     16, -- Severity.                     
     1 -- State.                                                            
    );     
END CATCH

END


