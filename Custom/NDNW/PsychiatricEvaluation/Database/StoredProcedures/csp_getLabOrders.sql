/****** Object:  StoredProcedure [dbo].[csp_getLabOrders]    Script Date: 03/19/2015 16:15:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_getLabOrders]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_getLabOrders]
GO


/****** Object:  StoredProcedure [dbo].[csp_getLabOrders]    Script Date: 03/19/2015 16:15:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_getLabOrders] (
	 @ClientId INT
	)
AS
BEGIN
	/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions  
-- "Psychiatric Service"
-- Purpose: Script for Task #823 - Woods Customizations
--  
-- Author:  Dhanil Manuel
-- Date:    12-31-2014
-- *****History****  

*********************************************************************************/

	 select 
		co.ClientOrderId,
		(o.OrderName +'('+(CONVERT(varchar(20),  co.OrderStartDateTime,101) + ' ' +  RIGHT(CONVERT(VARCHAR,co.OrderStartDateTime,0),6)) + ')') as OrderName
	   
from clientorders CO    
         join Orders O on co.orderid = o.orderid     
         join documentversions ds  on ds.DocumentVersionId = CO.DocumentVersionId 
         join documents d on ds.DocumentVersionId  = d.CurrentDocumentVersionId                                                
   where CO.ClientId = @ClientId
   and o.OrderType = 6481  
   and d.status = 22
   and isnull(O.RecordDeleted,'N') <> 'Y'   
   and isnull(CO.RecordDeleted,'N') <> 'Y'   
    
END

--Checking For Errors             
IF (@@error != 0)
BEGIN
	RAISERROR 20006 '[csp_getLabOrders] : An Error Occured'

	RETURN
END

GO


