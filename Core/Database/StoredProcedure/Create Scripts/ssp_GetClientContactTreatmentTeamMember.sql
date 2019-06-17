IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClientContactTreatmentTeamMember]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetClientContactTreatmentTeamMember]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetClientContactTreatmentTeamMember]    Script Date: 06-12-2016 19:59:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE  Procedure [dbo].[ssp_GetClientContactTreatmentTeamMember] --227539
	@ClientId INT    
AS    

/****************************************************************************** 
** File: ssp_GetClientTreatmentTeamMember.sql
** Name: ssp_GetClientTreatmentTeamMember
** Desc:  
** 
** 
** This template can be customized: 
** 
** Return values: Filter Values - Query to return values for Client Treatment Team Member Details
** 
** Called by: 
** 
** Parameters: 
** Input Output 
** ---------- ----------- 
** Auth: Varun
** Date: 11/30/2016
******************************************************************************* 
** Change History 
******************************************************************************* 

*******************************************************************************/

         
BEGIN  
	select CC.ClientContactId
	,CC.LastName + ', ' + CC.FirstName as ClientContactName
	, (SELECT STUFF( (SELECT  CAST(gc.codename as varchar) +': '  + ccp.[PhoneNumber] + '<br/><br/>'
                             FROM dbo.ClientContactPhones ccp 
							 join globalcodes gc on gc.globalcodeid=ccp.phonetype
							 where ClientContactId=CC.ClientContactId
                             FOR XML PATH('')), 
                            1, 0, '')) AS ClientContactPhone
	,(SELECT STUFF( (SELECT  CAST(gc.codename as varchar) +': '  + cca.[Display] + '<br/><br/>'
                             FROM dbo.ClientContactAddresses cca 
							 join globalcodes gc on gc.globalcodeid=cca.AddressType
							 where ClientContactId=CC.ClientContactId and ISNULL(cca.[Display],'')<>''
                             FOR XML PATH('')), 
                            1, 0, '')) AS ClientContactAddress
	from ClientContacts CC
	where CC.ClientId=@ClientId
	and CC.Active='Y' and ISNULL(RecordDeleted,'N')<>'Y'

END      


GO


