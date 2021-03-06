/****** Object:  StoredProcedure [dbo].[csp_RDWExtractCustom]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractCustom]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDWExtractCustom]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractCustom]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_RDWExtractCustom]
@AffiliateId int
/*********************************************************************
-- Stored Procedure: dbo.csp_RDWExtractCustom
-- Creation Date:    08/24/2009
--
-- Purpose: populates custom extract tables
--
-- Updates:
--   Date         Author      Purpose
--   08.24.2009   SFarber     Created.
--   11.20.2009   SFarber     Added csp_RDWExtractRAPScores, csp_RDWExtractCAFASScores
*********************************************************************/
as

exec dbo.csp_RDWExtractDailyLivingActivityScores @AffiliateId = @AffiliateId

if @@error <> 0 goto error

exec dbo.csp_RDWExtractRAPScores @AffiliateId = @AffiliateId

if @@error <> 0 goto error

exec dbo.csp_RDWExtractCAFASScores @AffiliateId = @AffiliateId

if @@error <> 0 goto error

return

error:

exec csp_RDWExtractError @AffiliateId = @AffiliateId, @ErrorText = ''Failed to execute csp_RDWExtractCustom''
' 
END
GO
