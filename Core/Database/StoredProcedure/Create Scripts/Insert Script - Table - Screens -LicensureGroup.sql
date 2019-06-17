/************************************************************************************************/                                                                                                                                                          
/* INSERT SCRIPT: TABLE SCREENS,BANNERS          */  
/* SCREEN TYPE - Detail screen  */                                                                                                                                                   
/* COPYRIGHT: 2005 STREAMLINE HEALTHCARE SOLUTIONS,  LLC          */                                                                                                                                                          
/* CREATION DATE:    26/Jan/2017                 */                                                                                                    
/* PURPOSE:  TO INSERT THE NEW ENTRY INTO SCREENS AND BANNERS FOR HEARTLAND TASK #6400*/  
/* CREATED:																  */                                                       
/* DATE				AUTHOR					PURPOSE								  */                                                          
/* 26/Jan/2017     NANDITA					CREATED								  */
/************************************************************************************************/ 

SET IDENTITY_INSERT [SCREENS] ON
GO
IF NOT EXISTS (SELECT [SCREENNAME] FROM SCREENS WHERE [SCREENNAME] = 'Licensure Group' AND [SCREENID] = 1500 )
BEGIN
INSERT INTO [DBO].[SCREENS]
          ([SCREENID]
          ,[SCREENNAME]
          ,[SCREENTYPE]
          ,[SCREENURL]
          ,[TABID]
		  
          )
    VALUES 
	      (
		  1500,
          'Licensure Group'
          ,5761
          ,'/Modules/CareManagement/ActivityPages/Admin/Detail/LicensureGroupDetail.ascx'
          ,4
          )
           END
GO
SET IDENTITY_INSERT [SCREENS] OFF
GO


--BANNER
IF NOT EXISTS (SELECT BANNERNAME FROM BANNERS WHERE BANNERNAME = 'Licensure Group')
BEGIN
INSERT INTO BANNERS
(
 BANNERNAME
,DISPLAYAS
,ACTIVE
,DEFAULTORDER
,CUSTOM
,TABID
,SCREENID
,ParentBannerId
)
VALUES
(
 'Licensure Group'
,'Licensure Group'
,'Y'
,5900
,'N'
,4
,1500
,NULL
)
END




SET IDENTITY_INSERT [SCREENS] ON
GO
IF NOT EXISTS (SELECT [SCREENNAME] FROM SCREENS WHERE [SCREENNAME] = 'Licensure Level' AND [SCREENID] = 1501 )
BEGIN
INSERT INTO [DBO].[SCREENS]
          ([SCREENID]
          ,[SCREENNAME]
          ,[SCREENTYPE]
          ,[SCREENURL]
          ,[TABID]
          )
    VALUES 
	      (
		  1501,
          'Licensure Level'
          ,5765
          ,'/Modules/CareManagement/ActivityPages/Admin/Detail/LicensureLevelPopup.ascx'
          ,4 
          )
           END
GO
SET IDENTITY_INSERT [SCREENS] OFF
GO
