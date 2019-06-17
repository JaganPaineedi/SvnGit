/****** Object:  StoredProcedure [dbo].[ssp_RDLClientContactsAddressHistory]    Script Date: 11/20/2013 14:04:35 ******/
IF EXISTS (SELECT
    *
  FROM sys.objects
  WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLClientContactsAddressHistory]') AND type IN (N'P', N'PC'))
  DROP PROCEDURE [dbo].[ssp_RDLClientContactsAddressHistory]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLClientContactsAddressHistory]    Script Date: 11/20/2013 14:04:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_RDLClientContactsAddressHistory] @ClientContactId int

/******************************************************************************       
** File: ssp_RDLClientContactsAddressHistory.sql    
/*  
ssp_RDLClientContactsAddressHistory 20616  
csp_RDLClientAddressHistory
*/           
*******************************************************************************       
** Change History       
*******************************************************************************       
** Date:  				Author:					Description:       
** 11/20/2013		John Sudhakar M		Created SP to get history of changes.
** 11/28/2013       John Sudhakar M		Added Order By to sort by ModifiedDate.
** 10/09/2015       Venkatesh MR		Get only date from Modified Date
/*   20 Oct 2015	Revathi	  what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  */ 
/* 									why:task #609, Network180 Customization  */ 
 *******************************************************************************/
AS

  SELECT
    c.ClientId,
    -- Modified by   Revathi   20 Oct 2015   
	case when  ISNULL(C.ClientType,'I')='I' then ISNULL(C.LastName,'') + ', ' + ISNULL(C.FirstName,'') else ISNULL(C.OrganizationName,'') end  AS ClientName,
    gc.CodeName AS AddressType,
    CCAH.Display,
    CCAH.Mailing,
    CCAH.ModifiedBy,
    Cast(CCAH.ModifiedDate AS DATE) as ModifiedDate
  FROM Clients c
  INNER JOIN ClientContacts CC
    ON C.ClientId = cc.ClientId AND ISNULL(CC.RecordDeleted, 'N') <> 'Y'
  INNER JOIN ClientContactsAddressHistory CCAH
    ON CCAH.ClientContactId = CC.ClientContactId
    AND ISNULL(CCAH.RecordDeleted, 'N') <> 'Y'
  INNER JOIN GlobalCodes gc
    ON gc.globalCodeId = CCAH.AddressType AND ISNULL(gc.RecordDeleted, 'N') <> 'Y'
  WHERE CCAH.ClientContactId = @ClientContactId
  AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
  UNION
  --This is to fetch the current address	
  SELECT
    c.ClientId,
    -- Modified by   Revathi   20 Oct 2015   
	case when  ISNULL(C.ClientType,'I')='I' then ISNULL(C.LastName,'') + ', ' + ISNULL(C.FirstName,'') else ISNULL(C.OrganizationName,'') end  AS ClientName,
    gc.CodeName AS AddressType,
    CCA.Display,
    CCA.Mailing,
    CCA.ModifiedBy,
    Cast(CCA.ModifiedDate AS DATE)  AS ModifiedDate
  FROM Clients c
  INNER JOIN ClientContacts CC
    ON C.ClientId = cc.ClientId AND ISNULL(CC.RecordDeleted, 'N') <> 'Y'
  INNER JOIN ClientContactAddresses CCA
    ON CCA.ClientContactId = CC.ClientContactId AND ISNULL(CCA.RecordDeleted, 'N') <> 'Y'
  INNER JOIN GlobalCodes gc
    ON gc.globalCodeId = CCA.AddressType AND ISNULL(gc.RecordDeleted, 'N') <> 'Y'
  WHERE CCA.ClientContactId = @ClientContactId
  AND ISNULL(c.RecordDeleted, 'N') <> 'Y'
  ORDER BY
	ModifiedDate

  --Checking For Errors                                                
  IF (@@error != 0)
  BEGIN
    RAISERROR 20006 '[ssp_RDLClientContactsAddressHistory] : An Error Occured'
    RETURN
  END
GO