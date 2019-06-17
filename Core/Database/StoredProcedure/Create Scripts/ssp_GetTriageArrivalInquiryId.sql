IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetTriageArrivalInquiryId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetTriageArrivalInquiryId]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetTriageArrivalInquiryId]    Script Date: 08/31/2016 15:21:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Varun
-- Create date: 31-Jan-2017
-- Description:	Task#: 33 Network 180 Support Go Live.
-- =============================================
CREATE PROCEDURE [dbo].[ssp_GetTriageArrivalInquiryId]  --128806
	@TriageArrivalDetailId INT
AS
BEGIN
      IF EXISTS(SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_GetTriageArrivalInquiryId]') AND type in (N'P', N'PC'))
      BEGIN
		  	exec scsp_GetTriageArrivalInquiryId @TriageArrivalDetailId
      END
	
END


