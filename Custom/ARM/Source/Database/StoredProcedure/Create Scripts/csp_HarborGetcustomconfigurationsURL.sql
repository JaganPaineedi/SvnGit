/****** Object:  StoredProcedure [dbo].[csp_HarborGetcustomconfigurationsURL]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_HarborGetcustomconfigurationsURL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_HarborGetcustomconfigurationsURL]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_HarborGetcustomconfigurationsURL]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'  
create procedure [dbo].[csp_HarborGetcustomconfigurationsURL] as  
--  
-- Procedure: ssp_HarborGetcustomconfigurationsURL  
-- Purpose: Retrieve the CustomConfigurations table  
--  
-- Change Log: 2011.09.27 - T. Remisoski - created.  
--  
  
select top 1 ReferralTransferReferenceUrl  
from dbo.CustomConfigurations  
  ' 
END
GO
