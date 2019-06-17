/****** Object:  StoredProcedure [dbo].[scsp_SCGetListPageInternalCommunications]    Script Date: 08/14/2015 12:43:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCGetListPageInternalCommunications]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_SCGetListPageInternalCommunications]
GO

/****** Object:  StoredProcedure [dbo].[scsp_SCGetListPageInternalCommunications]    Script Date: 08/14/2015 12:43:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[scsp_SCGetListPageInternalCommunications] @PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@FromDate DATETIME
	,@ToDate DATETIME
	,@Status INT
	,@Reason INT
	,@Type INT
	,@ClientId INT
	,@OtherFilter INT
	,@CurrentUserId INT
	/********************************************************************************    
-- Stored Procedure: dbo.scsp_SCGetListPageInternalCommunications      
--    
-- Copyright: Streamline Healthcate Solutions    
--    
-- Purpose: used by Contact Note List page.   
-- Called by: ssp_SCGetListPageInternalCommunications    
--    
	-- Updates:                                                                                                                                 
	-- Date				Author			Purpose                                                                          
	-- 14.AUG.2015		Akwinass		 Created. 
*********************************************************************************/
AS
SELECT NULL AS ClientContactNoteId

RETURN

GO


