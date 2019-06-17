/****** Object:  StoredProcedure [dbo].[scsp_SCListPageInternalCollections]    Script Date: 08/11/2015 16:37:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCListPageInternalCollections]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_SCListPageInternalCollections]
GO

/****** Object:  StoredProcedure [dbo].[scsp_SCListPageInternalCollections]    Script Date: 08/11/2015 16:37:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[scsp_SCListPageInternalCollections]
	@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@FromDate DATETIME
	,@ToDate DATETIME
	,@AmountDue DECIMAL(18,2)
	,@ProgramFilter INT
	,@ActivePaymentArrangement CHAR(1)
	,@Delinquent CHAR(1)
	,@ClientFlaggedNoServices CHAR(1)	
	,@ProgramViewFilter INT
	,@Status INT
	,@ClientName VARCHAR(100)
	,@ClientId INT
	,@StaffId INT	
	,@OtherFilter INT
/********************************************************************************                                                          
-- Stored Procedure: ssp_SCListPageInternalCollections        
--        
-- Copyright: Streamline Healthcate Solutions        
--        
-- Purpose: To display cliets data in internal collections     
--        
-- Author:  Akwinass        
-- Date:    AUG/27/2015        
--  
*********************************************************************************/
AS
BEGIN
	SELECT - 1 AS ClientId

	RETURN
END

GO


