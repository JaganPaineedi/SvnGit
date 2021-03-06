/****** Object:  StoredProcedure [dbo].[csp_GetCustomFASClientsStaging]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCustomFASClientsStaging]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetCustomFASClientsStaging]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetCustomFASClientsStaging]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE [dbo].[csp_GetCustomFASClientsStaging]
AS
	SET NOCOUNT ON;

   select primaryClientID, firstName, lastName, middleName, DOB, gender, clientID2, 
      clientID3, serviceAreaCode, programCode, zipCode, primaryLanguage, isInSingleParentHome, isLatino, 
      wardOfStateName, ClientInfoXML, activity
   from customFASClientsStaging a
' 
END
GO
