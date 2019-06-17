
/****** Object:  StoredProcedure [dbo].[scsp_ListPageSystemReports]    Script Date: 02/22/2016 17:54:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_ListPageSystemReports]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_ListPageSystemReports]
GO

/****** Object:  StoredProcedure [dbo].[scsp_ListPageSystemReports]    Script Date: 02/22/2016 17:54:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
          
CREATE procedure [dbo].[scsp_ListPageSystemReports]                                                                                                                                                                                              
@OtherFilter int                                                     
/********************************************************************************                                                  
-- Stored Procedure: dbo.scsp_ListPageSystemReports                                                 
--                                                  
-- Copyright: Streamline Healthcate Solutions                                                  
--                                                  
-- Purpose: used by Reports list page to apply custom filters    
-- Called by: ssp_ListPageSystemReports  
--              
-- Updates:                                                                                                         
-- Date        Author          Purpose                                                  
-- 22.02.2016  Vijeta s         Created.           
*********************************************************************************/                    
as  
  
-- Retrieve only SystemReportId in the final Select  
select 0 as SystemReportId  
  
  
GO


