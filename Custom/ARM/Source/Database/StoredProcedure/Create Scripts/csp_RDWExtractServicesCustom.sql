/****** Object:  StoredProcedure [dbo].[csp_RDWExtractServicesCustom]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractServicesCustom]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDWExtractServicesCustom]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDWExtractServicesCustom]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_RDWExtractServicesCustom]
@AffiliateId int
/*********************************************************************
-- Stored Procedure: dbo.csp_RDWExtractServicesCustom
-- Creation Date:    11/19/2009
--
-- Purpose: Custom processing for extracted services
--
-- Updates:
--   Date         Author      Purpose
--   11.19.2009   SFarber     Created.
*********************************************************************/
as

--
-- Add QJ Modifier for Jail Locations
--

declare @JailLocation table (LocationId int)

insert into @JailLocation (LocationId)
select case @AffiliateId
            when 100 then 54
            when 200 then 12
            when 300 then 10
            when 400 then 13
            when 500 then 18
       end
      
if @@error <> 0 goto error

update es
   set CPTModifier1 = ''QJ''
  from CustomRDWExtractServices es
       join Services s on s.ServiceId = es.ServiceId
       join @JailLocation l on l.LocationId = s.LocationId
 where isnull(es.CPTModifier1, '''') = ''''

if @@error <> 0 goto error

update es
   set CPTModifier2 = ''QJ''
  from CustomRDWExtractServices es
       join Services s on s.ServiceId = es.ServiceId
       join @JailLocation l on l.LocationId = s.LocationId
 where es.CPTModifier1 <> ''QJ''
   and isnull(es.CPTModifier2, '''') = ''''

if @@error <> 0 goto error

update es
   set CPTModifier3 = ''QJ''
  from CustomRDWExtractServices es
       join Services s on s.ServiceId = es.ServiceId
       join @JailLocation l on l.LocationId = s.LocationId
 where es.CPTModifier1 <> ''QJ''
   and es.CPTModifier2 <> ''QJ''

if @@error <> 0 goto error

return

error:

exec csp_RDWExtractError @AffiliateId = @AffiliateId, @ErrorText = ''Failed to execute csp_RDWExtractServicesCustom''
' 
END
GO
