/****** Object:  StoredProcedure [dbo].[ssp_SCGetCareManagementInfo]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetCareManagementInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetCareManagementInfo]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetCareManagementInfo]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetCareManagementInfo] 
	 @ClientId INT

/********************************************************************************  
-- Stored Procedure: dbo.ssp_SCGetCareManagementInfo                                            
--                                          
-- Copyright	: Streamline Healthcate Solutions                                          
                                         
-- Purpose		: To get Caremanagement Id from SC Clients table.                                          
--                                          
-- Updates		:                                                                                                 
-- Date			Author				Purpose
---------------------------------------------------------------------
*********************************************************************************/                                        
AS 
 	 
	SELECT CareManagementId  
	FROM Clients 
	WHERE ClientId = @ClientId

GO


