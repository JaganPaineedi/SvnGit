/****** Object:  StoredProcedure [dbo].[csp_RDLClientAddressHistory]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLClientAddressHistory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLClientAddressHistory]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLClientAddressHistory]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE   [dbo].[csp_RDLClientAddressHistory]
       
@ClientId   int          
          
AS            
      
     
/************************************************************************/                                            
/*********************************************************************/              

Select c.ClientId, c.lastname + '', '' + c.firstname as ClientName,
gc.CodeName as AddressType, a.Display, a.Billing, a.ModifiedBy, a.ModifiedDate
From Clients c
left join ClientAddressHistory a on c.clientid = a.ClientId and isnull(a.RecordDeleted, ''N'')<> ''Y''
left join GlobalCodes gc on gc.globalCodeId = a.AddressType and isnull(gc.RecordDeleted, ''N'') <> ''Y''
Where c.ClientId = @ClientId
and isnull(c.RecordDeleted, ''N'') <> ''Y''



--Checking For Errors                                            
If (@@error!=0)                                            
	Begin                                            
		RAISERROR  20006   ''[csp_RDLClientAddressHistory] : An Error Occured''                                             
		Return                                            
	End
' 
END
GO
