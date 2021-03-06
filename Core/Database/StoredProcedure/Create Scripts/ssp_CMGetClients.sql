/****** Object:  StoredProcedure [dbo].[ssp_CMGetClients]    Script Date: 11/18/2011 16:25:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetClients]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMGetClients]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetClients]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE  PROCEDURE [dbo].[ssp_CMGetClients]
  
AS  
/*********************************************************************/            
/* Stored Procedure: ssp_CMGetClients                                                          */            
/* Copyright: 2006 Provider Claim Management System                                                    */            
/* Creation Date:  10/10/2005                                                                                     */            
/*                                                                                                                           */            
/* Purpose:  fetches the list of Members(Client) whose status is Active          */           
/*                                                                                                                                          */          
/* Input Parameters: None */  
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
/*Modified on, Modified By                                                                               */ 
/*  21 Oct 2015	Revathi				what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */ 
/* 									why:task #609, Network180 Customization  */                
/****************************************************************************/             
  
--Enumeration used   
begin  
select ClientId,LastName,FirstName,
--Added by Revathi   21 Oct 2015
case when  ISNULL(ClientType,''I'')=''I'' then
      ISNULL(LastName,'''')+'', ''+ ISNULL(FirstName,'''')
     else ISNULL(OrganizationName,'''') end  as ''Name'' 
 from clients where isnull(recorddeleted,''N'') = ''N'' and active = ''Y''
end  
If (@@error!=0)  Begin  RAISERROR  20006  ''ssp_CMGetClients: An Error Occured''     
  
  Return    
End
' 
END
GO
