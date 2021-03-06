/****** Object:  StoredProcedure [dbo].[csp_RDLERUnpostedLines]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLERUnpostedLines]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLERUnpostedLines]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLERUnpostedLines]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--[csp_RDLERUnpostedLines] 4

create procedure [dbo].[csp_RDLERUnpostedLines]  
@ERFileId int

/********************************************************************************
-- Stored Procedure: csp_RDLERUnpostedLines
--
-- Copyright: 2007 Streamline Healthcate Solutions
--
-- Purpose: used for ClaimLine Errors
--
-- Updates:                     		                                
-- Date        Author      Purpose
-- 08.27.2012  MSuma       Created.      
--
*********************************************************************************/

AS
BEGIN
		select 
			b.ClientName, 
			b.DateOfService, 
			b.BillingCode, 
			b.ChargeAmount,
			b.PaidAmount,
			b.ClientIdentifier, 
			b.LineItemControlNumber, 
			b.PayerClaimNumber,
			a.ERMessage
		from ERClaimLineItemLog a
		JOIN ERClaimLineItems b ON (a.ERClaimLineItemId = b.ERClaimLineItemId)
		JOIN ERBatches c ON (b.ERBatchId = c.ERBatchId)
		join dbo.ERFiles as f on f.ERFileId = c.ERFileId
		where f.ERFileId = @ERFileId
		and a.ERMessageType in (5235)
		and not exists (
			select * from dbo.ERClaimLineItemLog as a2
			where a2.ERClaimLineItemId = a.ERClaimLineItemId
			and a2.ERMessage = a.ERMessage
			and a2.ERMessageType = a.ERMessageType
			and a2.CreatedDate > a.CreatedDate
			and ISNULL(a2.RecordDeleted, ''N'') <> ''Y''
		) 



END

' 
END
GO
