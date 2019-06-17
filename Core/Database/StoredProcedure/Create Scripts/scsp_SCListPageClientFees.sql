
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCListPageClientFees]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_SCListPageClientFees]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[scsp_SCListPageClientFees]  
(  
	@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@FeeBeginDate DATETIME
	,@FeeEndDate DATETIME
	,@ProgramId INT
	,@LocationId INT
	,@EnteredBy INT
	,@OtherFilter INT
)  
 
/********************************************************************************    
-- Stored Procedure: dbo.scsp_SCListPageClientFees      
--    
-- Copyright: Streamline Healthcate Solutions 
--    
-- Updates:                                                           
-- Date			 Author			Purpose    
-- 27-JULY-2015	 Akwinass		What:Used in ssp_SCListPageClientFees.          
--								Why:task  #995 Valley - Customizations
*********************************************************************************/   
AS
BEGIN  
SELECT NULL AS ClientFeeId
END
GO
