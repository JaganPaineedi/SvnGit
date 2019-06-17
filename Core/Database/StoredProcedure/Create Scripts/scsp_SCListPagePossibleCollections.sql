/****** Object:  StoredProcedure [dbo].[scsp_SCListPagePossibleCollections]    Script Date: 08/27/2015 14:42:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCListPagePossibleCollections]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_SCListPagePossibleCollections]
GO

/****** Object:  StoredProcedure [dbo].[scsp_SCListPagePossibleCollections]    Script Date: 08/27/2015 14:42:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[scsp_SCListPagePossibleCollections]@PageNumber INT
	,@PageSize INT
	,@SortExpression VARCHAR(100)
	,@ProgramFilter INT
	,@ProgramViewFilter INT
	,@Balance DECIMAL(10,2)
	,@LastPaymentDate DATETIME
	,@StaffId INT
	,@Days INT
	,@OtherFilter INT
/********************************************************************************                                                          
-- Stored Procedure: ssp_SCListPagePossibleCollections        
--        
-- Copyright: Streamline Healthcate Solutions        
--        
-- Purpose: To display clients data in possible collections     
--        
-- Author:  Akwinass        
-- Date:    AUG/27/2015        
--  
*********************************************************************************/   
AS  
BEGIN   
 SELECT -1 AS ClientId  
 RETURN  
END  
  
GO


