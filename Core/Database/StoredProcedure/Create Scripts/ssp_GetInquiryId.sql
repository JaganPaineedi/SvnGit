IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetInquiryId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetInquiryId]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetInquiryId]    Script Date: 08/31/2016 15:21:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Arjun K R
-- Create date: 31-August-2016
-- Description:	Task #383 Network180 Environment Issues  Tracking.
-- =============================================
CREATE PROCEDURE [dbo].[ssp_GetInquiryId]  --128806
	@ClientId INT
AS
BEGIN
      IF EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_GetInquiryId]') AND type in (N'P', N'PC'))
      BEGIN
		  	exec scsp_GetInquiryId @ClientId
      END
	
END


