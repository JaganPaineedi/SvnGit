/****** Object:  StoredProcedure [dbo].[csp_RDWExtractProcedureCodes]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractProcedureCodes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDWExtractProcedureCodes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractProcedureCodes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_RDWExtractProcedureCodes]
@AffiliateId int
/*********************************************************************
-- Stored Procedure: dbo.csp_RDWExtractProcedureCodes
-- Creation Date:    04/26/2010
--
-- Purpose: populates CustomRDWExtractProcedureCodes table
--
-- Updates:
--   Date         Author      Purpose
--   04.26.2010   SFarber     Created.
*********************************************************************/
as

delete from CustomRDWExtractProcedureCodes

if @@error <> 0 goto error

insert into CustomRDWExtractProcedureCodes (
       AffiliateId,
       ProcedureCodeId,
       ProcedureCode,
       ProcedureCodeName,
       Active,
       NotBillable,
       FaceToFace,
       GroupCode)
select @AffiliateId,
       pc.ProcedureCodeId,
       pc.DisplayAs,
       pc.ProcedureCodeName,
       pc.Active,
       pc.NotBillable,
       pc.FaceToFace,
       pc.GroupCode
  from ProcedureCodes pc
 where isnull(pc.RecordDeleted, ''N'') = ''N''

if @@error <> 0 goto error

return

error:

exec csp_RDWExtractError @AffiliateId = @AffiliateId, @ErrorText = ''Failed to execute csp_RDWExtractProcedureCodes''
' 
END
GO
