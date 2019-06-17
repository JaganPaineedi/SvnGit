

/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientInformationTabConfigurations]    Script Date: 05/15/2013 17:09:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientInformationTabConfigurations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetClientInformationTabConfigurations]
GO



/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientInformationTabConfigurations]    Script Date: 05/15/2013 17:09:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Maninder
-- Create date: 15/5/2013
-- Description:	to fill shared table ClientInformationTabConfigurations with data
-- =============================================
CREATE PROCEDURE [dbo].[ssp_SCGetClientInformationTabConfigurations]
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- 25.05.2014	Vaibhav Khare		Commiting on DEV environment 
-- =============================================
AS
BEGIN
	
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT [ClientInformationTabConfigurationId]
      ,[ScreenId]
      ,[TabName]
      ,[TabURL]
      ,[TabType]
      ,[FormId]
      ,[TabOrder]
   FROM [ClientInformationTabConfigurations]
   where ISNULL(RecordDeleted,'N')<>'Y'
   
   
END


GO


