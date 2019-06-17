
/*********************************************************************************************************/
/* Date			Author			Purpose																	 */                  
/* 07/03/2017   Alok Kumar		Created    Ref: AspenPointe-Customizations #103                          */ 
/*********************************************************************************************************/


DECLARE @ScreenId INT 
DECLARE @ListScreenToolbarURL VARCHAR(200) 

SET @ScreenId = 908
SET @ListScreenToolbarURL = '/MAR/ScreenToolBars/AdministrationToolBar.ascx' 

IF EXISTS (SELECT * FROM screens WHERE screenid = @ScreenId)  
  BEGIN 
      UPDATE Screens  SET ScreenToolbarURL = @ListScreenToolbarURL WHERE  ScreenId = @ScreenId 
  END 
 
