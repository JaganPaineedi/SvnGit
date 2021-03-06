/****** Object:  StoredProcedure [dbo].[ssp_CMGetClientNameById]    Script Date: 11/18/2011 16:25:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetClientNameById]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMGetClientNameById]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetClientNameById]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE  PROCEDURE [dbo].[ssp_CMGetClientNameById]
@ClientId int
AS
/*********************************************************************/          
/* Stored Procedure: ssp_CMGetClientNameById                                                          */          
/* Copyright: 2006 Provider Claim Management System                                                    */          
/* Creation Date:  10/10/2005                                                                                     */          
/*                                                                                                                           */          
/* Purpose:  fetches the LastNAme & FirstName from Clients on the basis on clientid          */         
/*                                                                                                                                          */        
/* Input Parameters:  @ClientId  */
/*                                                                   */        
/*                                                                                                                              */          
/*                                                                                                                              */          
/*                                                                                                                              */          
/* Called By:   Insurer.cs                                                                                                           */          
/*                                                                                                                              */          
/* Calls:                                                                                                                     */          
/*                                                                                                                              */          
/* Data Modifications:                                                                                               */          
/*                                                                                                                            */          
/* Created on , Created By:                                                                                          */          
/*  Date              Author                Purpose                                                                   */          
/* 10/10/2005   Yash     Created                                                                        */
/*Modified on, Modified By  
/*  21 Oct 2015	Revathi				what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */ 
/* 									why:task #609, Network180 Customization  */                                                                              */          
/****************************************************************************/           

--Enumeration used 
begin
--Added by Revathi   21.Oct.2015
Select case when  ISNULL(ClientType,''I'')=''I'' then rtrim(ISNULL(LastName,'''')) + '', '' + rtrim(ISNULL(FirstName,'''')) else ISNULL(OrganizationName,'''') end from Clients where ClientId=@ClientId
end
If (@@error!=0)  Begin  RAISERROR  20006  ''ssp_CMGetClientNameById: An Error Occured''   

  Return  
End
' 
END
GO
