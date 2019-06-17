IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_GetInquiryId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_GetInquiryId]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Arjun K R
-- Create date: 31-August-2016
-- Description:	Task #383 Network180 Environment Issues  Tracking.
-- =============================================
CREATE PROCEDURE [dbo].[scsp_GetInquiryId]  
	@ClientId INT
AS
BEGIN
     SELECT -1
END


GO


