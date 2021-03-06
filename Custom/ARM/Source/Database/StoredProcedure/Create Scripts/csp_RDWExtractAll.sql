/****** Object:  StoredProcedure [dbo].[csp_RDWExtractAll]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractAll]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDWExtractAll]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractAll]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_RDWExtractAll]
@AffiliateId int
/********************************************************************************
-- Stored Procedure: dbo.csp_RDWExtractAll  
--
-- Copyright: 2006 Streamline Healthcate Solutions
--
-- Creation Date:    11.17.2006                                          	
--                                                                   		
-- Purpose: Extracts all data
--
-- Updates:                     		                                
-- Date        Author      Purpose
-- 11.17.2006  SFarber     Created.   
-- 07.23.2007  SFarber     Modified to use @ExtractDate.     
-- 01.19.2009  SFarber     Commented out call to csp_RDWExtractServiceFinancialHistory.
-- 08.24.2009  SFarger     Added call to csp_RDWExtractCustom.
-- 04.26.2010  SFarber     Added call to csp_RDWExtractProcedureCodes
--
*********************************************************************************/
as

set nocount on
set ansi_warnings off

declare @StartDate   varchar(10)
declare @ExtractDate datetime

set @ExtractDate = GetDate()

update CustomRDWExtractSummary
   set ExtractDate = @ExtractDate,
       ErrorMessage = null
 where AffiliateId = @AffiliateId

if @@error <> 0 goto error

execute csp_RDWExtractClients @AffiliateId = @AffiliateId

if @@error <> 0 goto error

execute csp_RDWExtractServices @AffiliateId = @AffiliateId, @ExtractDate = @ExtractDate 

if @@error <> 0 goto error

--execute csp_RDWExtractServiceFinancialHistory  @AffiliateId = @AffiliateId, @ExtractDate = @ExtractDate 

--if @@error <> 0 goto error

execute csp_RDWExtractClientCoverages @AffiliateId = @AffiliateId

if @@error <> 0 goto error

execute csp_RDWExtractClientCoverageHistory @AffiliateId = @AffiliateId

if @@error <> 0 goto error

execute csp_RDWExtractHabWaiverEnrollments @AffiliateId = @AffiliateId

if @@error <> 0 goto error

execute csp_RDWExtractHospitalizations @AffiliateId = @AffiliateId

if @@error <> 0 goto error

execute csp_RDWExtractStaff @AffiliateId = @AffiliateId

if @@error <> 0 goto error

execute csp_RDWExtractCustomTimeliness @AffiliateId = @AffiliateId

if @@error <> 0 goto error

execute csp_RDWExtractEvidenceBasedPracticeServices @AffiliateId = @AffiliateId

if @@error <> 0 goto error

execute csp_RDWExtractProcedureCodes  @AffiliateId = @AffiliateId

if @@error <> 0 goto error

execute csp_RDWExtractSummary @AffiliateId = @AffiliateId, @ExtractDate = @ExtractDate

if @@error <> 0 goto error

execute csp_RDWExtractCustom @AffiliateId = @AffiliateId

if @@error <> 0 goto error

return

error:

exec csp_RDWExtractError @AffiliateId = @AffiliateId, @ErrorText = ''Failed to execute csp_RDWExtractAll''
' 
END
GO
