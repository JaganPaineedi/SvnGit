/****** Object:  StoredProcedure [dbo].[ssp_CMGetStaffData]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMGetStaffData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMGetStaffData]
GO

/****** Object:  StoredProcedure [dbo].[ssp_CMGetStaffData]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[ssp_CMGetStaffData]
 
/************************************************************************/                
/* Stored Procedure: dbo.ssp_CMGetStaffData								*/                
/* Copyright: 2005 Provider Claim Management System						*/                
/* Creation Date:														*/                
/* Copied from PCM database and tables modified according to SC application */                
/* Purpose: Get Staff Data*/
/* Input Parameters:													*/  
  
/* Output Parameters:													*/                
/*																		*/                
/* Called By:															*/                
/*																		*/                
/* Calls:																*/                
/*																		*/                
/* Data Modifications:													*/                
/*																		*/                
/* Updates:																*/                
/*  Date          Author      Purpose                                   */                
/*																		*/                
/************************************************************************/       
  
 AS  
	SELECT S.StaffId , S.DisplayAs as StaffName
	FROM Staff S JOIN StaffRoles SR ON SR.StaffId = S.StaffId
	WHERE SR.RoleId = 4006 AND ISNULL(SR.RecordDeleted, 'N') = 'N' AND ISNULL(S.RecordDeleted, 'N') = 'N'
	ORDER BY StaffName

If (@@error!=0)  Begin  RAISERROR  20006  'ssp_CMGetStaffData: An Error Occured'     Return  End

GO


