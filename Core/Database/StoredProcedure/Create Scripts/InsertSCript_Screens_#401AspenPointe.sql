--------------------------------------------------------------------
--Author : Shruthi.S
--Date   : 02/06/2016
--Purpose : Added screen entry for Provider Search screen.Ref : #401 AspenPointe-Customizations.
--------------------------------------------------------------------


SET IDENTITY_INSERT [SCREENS] ON
GO
IF NOT EXISTS (SELECT [SCREENNAME] FROM SCREENS WHERE [SCREENNAME] = 'Provider Search' AND [SCREENID] = 1196 )
BEGIN
INSERT INTO [DBO].[SCREENS]
          ([SCREENID]
          ,[SCREENNAME]
          ,[SCREENTYPE]
          ,[SCREENURL]
          ,[TABID]
         
          )
    VALUES 
	      (1196,
          'Provider Search'
          ,5762
          ,'Modules/CareManagement/ActivityPages/Office/ListPages/ProviderSearch.ascx'
          ,1 
        
          )
           END
GO
SET IDENTITY_INSERT [SCREENS] OFF
GO

--BANNER
IF NOT EXISTS (SELECT BANNERNAME FROM BANNERS WHERE BANNERNAME = 'Provider Search')
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
			'Provider Search'
			,'Provider Search'
			,'Y'
			,1
			,'N'
			,1
			,1196 
			)
END

---Screen Permission Controls entry for export button.
  if not exists (select * from screenpermissioncontrols where screenid=1196 and ControlName='ButtonExport')
      begin
      INSERT INTO screenpermissioncontrols 
                  (screenid, 
                   controlname, 
                   displayas, 
                   active) 
      VALUES      (1196, 
                   'ButtonExport', 
                   'Export', 
                   'Y') 
      end