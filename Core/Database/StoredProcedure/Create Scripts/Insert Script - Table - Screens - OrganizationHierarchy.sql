SET IDENTITY_INSERT [SCREENS] ON
GO
IF NOT EXISTS (SELECT [SCREENNAME] FROM SCREENS WHERE [SCREENNAME] = 'Organization Hierarchy' AND [SCREENID] = 1502 )
BEGIN
INSERT INTO [SCREENS]
          ([SCREENID]
          ,[SCREENNAME]
          ,[SCREENTYPE]
          ,[SCREENURL]
          ,[TABID]
          )
    VALUES 
	      (
		  1502,
          'Organization Hierarchy'
          ,5765
          ,'/PartialIOP/WebPages/OrganizationHierarchy.ascx'
          ,4 
          )
           END
GO
SET IDENTITY_INSERT [SCREENS] OFF
GO
