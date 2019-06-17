/****** Object:  StoredProcedure [dbo].[scsp_SCListPageInternalCollectionCharges]    Script Date: 08/14/2015 12:43:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCListPageInternalCollectionCharges]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_SCListPageInternalCollectionCharges]
GO

/****** Object:  StoredProcedure [dbo].[scsp_SCListPageInternalCollectionCharges]    Script Date: 08/14/2015 12:43:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROC [dbo].[scsp_SCListPageInternalCollectionCharges] @PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@CollectionId INT
	,@ProcedureCodeId INT
	,@ClinicianId INT
	,@ProgramId INT
	,@DOSFromDate DATETIME
	,@DOSToDate DATETIME
	,@OtherFilter INT
	,@CurrentUserId INT
	/********************************************************************************    
-- Stored Procedure: dbo.scsp_SCListPageInternalCollectionCharges      
--    
-- Copyright: Streamline Healthcate Solutions    
--    
-- Purpose: used by Contact Note List page.   
-- Called by: ssp_SCListPageInternalCollectionCharges    
--    
	-- Updates:                                                                                                                                 
	-- Date				Author			Purpose                                                                          
	-- 23.JAN.2017		Akwinass		 Created. 
*********************************************************************************/
AS
SELECT NULL AS ChargeId

RETURN

GO


