/****** Object:  StoredProcedure [dbo].[csp_RDWExtractServicesCustomFilter]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractServicesCustomFilter]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDWExtractServicesCustomFilter]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractServicesCustomFilter]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create proc [dbo].[csp_RDWExtractServicesCustomFilter]
@AffiliateId int
/*********************************************************************
-- Stored Procedure: dbo.csp_RDWExtractServicesCustomFilter
-- Creation Date:    04/30/2008
--
-- Purpose: Retrieves services that should be filter out from the extract based on custom rules.
--          Leave this sp empty if there is no custom rule
--
-- Updates:
--   Date         Author      Purpose
--   04.30.2008   SFarber     Created.
*********************************************************************/
as
' 
END
GO
