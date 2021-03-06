
/****** Object:  StoredProcedure [dbo].[Csp_HarborGetcustomconfigurationsURL]    Script Date: 11/18/2011 16:25:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Csp_HarborGetcustomconfigurationsURL]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Csp_HarborGetcustomconfigurationsURL]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Csp_HarborGetcustomconfigurationsURL]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[Csp_HarborGetcustomconfigurationsURL] as
--
-- Procedure: Csp_HarborGetcustomconfigurationsURL
-- Purpose: Retrieve the CustomConfigurations table
--
-- Change Log: 2011.09.27 - T. Remisoski - created.
--

select top 1 ReferralTransferReferenceUrl
from dbo.CustomConfigurations

' 
END
GO
