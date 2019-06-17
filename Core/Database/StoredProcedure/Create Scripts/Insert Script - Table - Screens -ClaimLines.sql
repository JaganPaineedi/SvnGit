 /************************************************************************************************/                                                                                                                                                          
/* INSERT SCRIPT: TABLE SCREENS,BANNERS															*/  
/* SCREEN TYPE - LISTPAGE																		*/                                                                                                                                                   
/* COPYRIGHT: 2005 STREAMLINE HEALTHCARE SOLUTIONS,  LLC										*/                                                                                                                                                          
/* CREATION DATE:    05/June/2014																*/                                                                                                    
/* PURPOSE:  TO INSERT THE NEW ENTRY INTO SCREENS AND BANNERS PER THE TASK #25(CARE MANAGEMENT TO SMARTCARE) */  
/* CREATED:																						*/                                                       
/* DATE				AUTHOR					PURPOSE												*/                                                          
/* 05/June/2014     Manju					CREATED												*/
/* 10/10/2014       Shruthi.S               Modified to add new screen entry for unused checks popup in pay popup.Ref : 25 CM to SC*/
/************************************************************************************************/ 

SET IDENTITY_INSERT [SCREENS] ON
GO
IF NOT EXISTS (SELECT [SCREENNAME] FROM SCREENS WHERE [SCREENNAME] = 'Claim Lines' AND [SCREENID] = 1001 )
BEGIN
INSERT INTO [DBO].[SCREENS]
          ([SCREENID]
          ,[SCREENNAME]
          ,[SCREENTYPE]
          ,[SCREENURL]
          ,[ScreenToolbarURL]          
          ,[TABID]
          )
    VALUES 
	      (1001,
          'Claim Lines'
          ,5762
          ,'/Modules/CareManagement/ActivityPages/Office/ListPages/ClaimLines.ascx'
          ,'/ScreenToolBars/ClaimLineListPageToolbar.ascx'
          ,1 
          )
           END
GO
SET IDENTITY_INSERT [SCREENS] OFF
GO


--BANNER
IF NOT EXISTS (SELECT BANNERNAME FROM BANNERS WHERE BANNERNAME = 'Claims' AND SCREENID = 1001)
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
)
VALUES
(
 'Claims'
,'Claims'
,'N'
,1
,'Y'
,1
,1001
)
END


-----Custom page popup for claimlines actions -------------------------------------------------------------

SET IDENTITY_INSERT [SCREENS] ON
GO
IF NOT EXISTS (SELECT [SCREENNAME] FROM SCREENS WHERE [SCREENNAME] = 'Claim Lines' AND [SCREENID] = 1003 )
BEGIN
INSERT INTO [DBO].[SCREENS]
          ([SCREENID]
          ,[SCREENNAME]
          ,[SCREENTYPE]
          ,[SCREENURL]
          ,[TABID]
          )
    VALUES 
	      (1003,
          'Claim Lines'
          ,5765
          ,'/Modules/CareManagement/ActivityPages/Office/Detail/ClaimLineActions.ascx'
          ,1 
          )
           END
GO
SET IDENTITY_INSERT [SCREENS] OFF
GO


-----Custom page popup for Pay -------------------------------------------------------------

SET IDENTITY_INSERT [SCREENS] ON
GO
IF NOT EXISTS (SELECT [SCREENNAME] FROM SCREENS WHERE [SCREENNAME] = 'Claim Lines Pay' AND [SCREENID] = 1004 )
	BEGIN
		INSERT INTO [DBO].[SCREENS]
          ([SCREENID]
          ,[SCREENNAME]
          ,[SCREENTYPE]
          ,[SCREENURL]
          ,[TABID]
          )
		VALUES 
	      (1004,
          'Claim Lines Pay'
          ,5765
          ,'/Modules/CareManagement/ActivityPages/Office/Detail/ClaimLinePay.ascx'
          ,1 
          )
	END
GO

SET IDENTITY_INSERT [SCREENS] OFF
GO

-----Custom page popup for TBW -------------------------------------------------------------

SET IDENTITY_INSERT [SCREENS] ON
GO
IF NOT EXISTS (SELECT [SCREENNAME] FROM SCREENS WHERE [SCREENNAME] = 'Claim Lines TBW' AND [SCREENID] = 1246 )
	BEGIN
		INSERT INTO [DBO].[SCREENS]
          ([SCREENID]
          ,[SCREENNAME]
          ,[SCREENTYPE]
          ,[SCREENURL]
          ,[TABID]
          )
		VALUES 
	      (1246,
          'Claim Lines TBW'
          ,5765
          ,'/Modules/CareManagement/ActivityPages/Office/Detail/ClaimLinesToBeWorked.ascx'
          ,1 
          )
	END
GO

SET IDENTITY_INSERT [SCREENS] OFF
GO

---- insert script for screenpermissioncontrols

DECLARE @screenid1 INT
SET @screenid1 = 1001

IF @screenid1 > 0 
  BEGIN 
	IF NOT EXISTS (SELECT * FROM screenpermissioncontrols WHERE screenid=@screenid1 and ControlName='ButtonClaimLineDeny')
	BEGIN
      INSERT INTO screenpermissioncontrols 
                  (screenid, 
                   controlname, 
                   displayas, 
                   active) 
      VALUES      (@screenid1, 
                   'ButtonClaimLineDeny', 
                   'Deny', 
                   'Y') 
	END
	
	IF NOT EXISTS (SELECT * FROM screenpermissioncontrols WHERE screenid=@screenid1 and ControlName='ButtonClaimLineAdjudicate')
	BEGIN
      INSERT INTO screenpermissioncontrols 
                  (screenid, 
                   controlname, 
                   displayas, 
                   active) 
      VALUES      (@screenid1, 
                   'ButtonClaimLineAdjudicate', 
                   'Adjudicate', 
                   'Y') 
	END
	
	IF NOT EXISTS (SELECT * FROM screenpermissioncontrols WHERE screenid=@screenid1 and ControlName='ButtonClaimLinePay')
	BEGIN
      INSERT INTO screenpermissioncontrols 
                  (screenid, 
                   controlname, 
                   displayas, 
                   active) 
      VALUES      (@screenid1, 
                   'ButtonClaimLinePay', 
                   'Pay', 
                   'Y') 
	END
	
	IF NOT EXISTS (SELECT * FROM screenpermissioncontrols WHERE screenid=@screenid1 and ControlName='ButtonClaimLineDenialLetter')
	BEGIN
      INSERT INTO screenpermissioncontrols 
                  (screenid, 
                   controlname, 
                   displayas, 
                   active) 
      VALUES      (@screenid1, 
                   'ButtonClaimLineDenialLetter', 
                   'Denial Letter', 
                   'Y') 
	END
	
	IF NOT EXISTS (SELECT * FROM screenpermissioncontrols WHERE screenid=@screenid1 and ControlName='ButtonClaimLineRevert')
	BEGIN
      INSERT INTO screenpermissioncontrols 
                  (screenid, 
                   controlname, 
                   displayas, 
                   active) 
      VALUES      (@screenid1, 
                   'ButtonClaimLineRevert', 
                   'Revert', 
                   'Y') 
	END
	
	IF NOT EXISTS (SELECT * FROM screenpermissioncontrols WHERE screenid=@screenid1 and ControlName='ButtonClaimLineReAdjudicate')
	BEGIN
      INSERT INTO screenpermissioncontrols 
                  (screenid, 
                   controlname, 
                   displayas, 
                   active) 
      VALUES      (@screenid1, 
                   'ButtonClaimLineReAdjudicate', 
                   'ReAdjudicate', 
                   'Y') 
	END
	
	IF NOT EXISTS (SELECT * FROM screenpermissioncontrols WHERE screenid=@screenid1 and ControlName='ButtonClaimLineDoNotAdjudicate')
	BEGIN
      INSERT INTO screenpermissioncontrols 
                  (screenid, 
                   controlname, 
                   displayas, 
                   active) 
      VALUES      (@screenid1, 
                   'ButtonClaimLineDoNotAdjudicate', 
                   'Do Not Adjudicate', 
                   'Y') 
	END
	
	IF NOT EXISTS (SELECT * FROM screenpermissioncontrols WHERE screenid=@screenid1 and ControlName='ButtonClaimLineTBW')
	BEGIN
      INSERT INTO screenpermissioncontrols 
                  (screenid, 
                   controlname, 
                   displayas, 
                   active) 
      VALUES      (@screenid1, 
                   'ButtonClaimLineTBW', 
                   'To Be Worked', 
                   'Y') 
	END
	
	--IF NOT EXISTS (SELECT * FROM screenpermissioncontrols WHERE screenid=@screenid1 and ControlName='ButtonClaimLineBatch')
	--BEGIN
 --     INSERT INTO screenpermissioncontrols 
 --                 (screenid, 
 --                  controlname, 
 --                  displayas, 
 --                  active) 
 --     VALUES      (@screenid1, 
 --                  'ButtonClaimLineBatch', 
 --                  'Batch', 
 --                  'Y') 
	--END
	
  END
  
  -----------------Screen entry for unused checks when we change the checknumber in Pay popup------------------------------
   SET IDENTITY_INSERT [SCREENS] ON
GO
IF NOT EXISTS (SELECT [SCREENNAME] FROM SCREENS WHERE [SCREENNAME] = 'Unused Checks' AND [SCREENID] = 1052 )
BEGIN
INSERT INTO [SCREENS]
          ([SCREENID]
          ,[SCREENNAME]
          ,[SCREENTYPE]
          ,[SCREENURL]
          ,[TABID]
          )
    VALUES 
	      (1052 ,
          'Unused Checks'
          ,5765
          ,'Modules/CareManagement/ActivityPages/Office/Detail/UnusedChecksPopup.ascx'
          ,2
          )
           END
ELSE
update Screens
set 
ScreenName='Unused Checks',
ScreenType=5765,
ScreenURL='Modules/CareManagement/ActivityPages/Office/Detail/UnusedChecksPopup.ascx',
TabId=2   
where ScreenId=1052        
         
GO
SET IDENTITY_INSERT [SCREENS] OFF
GO
