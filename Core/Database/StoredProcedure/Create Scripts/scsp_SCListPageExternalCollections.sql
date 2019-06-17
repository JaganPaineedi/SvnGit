IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCListPageExternalCollections]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_SCListPageExternalCollections]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[scsp_SCListPageExternalCollections]  
/********************************************************************************                                                    
-- Stored Procedure: scsp_SCListPageExternalCollections  
--  
-- Copyright: Streamline Healthcate Solutions  
--  
-- Purpose: Customization support for list page depending on the custom filter selection.  
-- *****History****  
*********************************************************************************/  
  @PageNumber INT              
 ,@PageSize INT              
 ,@SortExpression VARCHAR(100)            
 ,@StaffPrograms INT            
 ,@ExternalCollectionStatus INT             
 ,@ServiceArea INT            
 ,@ClientId INT            
 ,@SentFrom DATETIME            
 ,@SentTo DATETIME              
 ,@DOSFrom DATETIME              
 ,@DOSTo DATETIME            
 ,@CreatedFrom DATETIME              
 ,@CreatedTo DATETIME              
 ,@OtherFilter INT = NULL            
 ,@CollectionsAgencyId INT    
AS  
BEGIN  
SELECT -1 AS ExternalCollectionChargeId  
  
RETURN  
END  
GO


