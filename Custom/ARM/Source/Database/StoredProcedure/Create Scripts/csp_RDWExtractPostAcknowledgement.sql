/****** Object:  StoredProcedure [dbo].[csp_RDWExtractPostAcknowledgement]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractPostAcknowledgement]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDWExtractPostAcknowledgement]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractPostAcknowledgement]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_RDWExtractPostAcknowledgement]
@AffiliateId int,
@ExtractDate datetime,
@AcknowledgedDate datetime
/********************************************************************************
-- Stored Procedure: dbo.csp_RDWExtractPostAcknowledgement  
--
-- Copyright: 2006 Streamline Healthcate Solutions
--
-- Creation Date:    11.17.2006                                          	
--                                                                   		
-- Purpose: Posts exctract acknowledgement
--
-- Updates:                     		                                
-- Date        Author      Purpose
-- 11.17.2006  SFarber     Created.   
-- 05.20.2007  SFarber     Fixed overflow issue.
-- 07.23.2007  SFarber     Added validation for Extract and Acknowledged dates.    
--
*********************************************************************************/
as

declare @ExtractHistory table (ExtractHistoryId int null, ExtractDate datetime)
declare @ExtractHistoryId int

--
-- Validate Extract and Acknowledged dates
--
if isnull(@ExtractDate, ''1/1/1900'') = ''1/1/1900''  return
if @ExtractDate >= isnull(@AcknowledgedDate, ''1/1/1900'')  return


-- 
-- The DateDiff function is needed because the @ExtractDate argument gets passed in from the DTS package
-- and the DTS Package truncates milliseconds.
--
insert into @ExtractHistory (
       ExtractHistoryId,
       ExtractDate)
select ExtractHistoryId,
       ExtractDate
  from CustomRDWExtractHistory
 where AffiliateId = @AffiliateId
   and abs(datediff(dd, ExtractDate, @ExtractDate)) <= 1  
   and AcknowledgedDate is null

if @@error <> 0 goto error

select @ExtractHistoryId = max(ExtractHistoryId)
  from @ExtractHistory
 where abs(datediff(ms, ExtractDate, @ExtractDate)) <= 1000

if @ExtractHistoryId is not null
begin
  select @ExtractDate = ExtractDate
    from CustomRDWExtractHistory
   where ExtractHistoryId = @ExtractHistoryId

  update CustomRDWExtractHistory
     set AcknowledgedDate = @AcknowledgedDate
   where ExtractHistoryId = @ExtractHistoryId

  if @@error <> 0 goto error

  update CustomRDWExtractServicesSent
     set AcknowledgedDate = @AcknowledgedDate
   where AffiliateId = @AffiliateId
     and SentDate = @ExtractDate
     and AcknowledgedDate is null

  if @@error <> 0 goto error

  update CustomRDWExtractServiceFinancialHistory
     set AcknowledgedDate = @AcknowledgedDate
   where AffiliateId = @AffiliateId
     and ExtractDate = @ExtractDate
     and AcknowledgedDate is null

  if @@error <> 0 goto error

  update CustomRDWExtractSummary
     set ResendAll = ''N''
   where AffiliateId = @AffiliateId

  if @@error <> 0 goto error
end

return

error:

exec csp_RDWExtractError @AffiliateId = @AffiliateId, @ErrorText = ''Failed to execute csp_RDWExtractPostAcknowledgement''
' 
END
GO
