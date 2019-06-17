
/****** Object:  StoredProcedure [dbo].[scsp_ListPageLetterTemplates]    Script Date: 02/22/2016 17:54:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_ListPageLetterTemplates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_ListPageLetterTemplates]
GO

/****** Object:  StoredProcedure [dbo].[scsp_ListPageLetterTemplates]    Script Date: 02/22/2016 17:54:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
          
CREATE procedure [dbo].[scsp_ListPageLetterTemplates]                                                                                                                                                                                              
@OtherFilter int                                                     
/********************************************************************************                                                  
-- Stored Procedure: dbo.scsp_ListPageLetterTemplates                                                 
--                                                  
-- Copyright: Streamline Healthcate Solutions                                                  
--                                                  
-- Purpose: used by LetterTemplates list page to apply custom filters    
-- Called by: scsp_ListPageLetterTemplates  
--              
-- Updates:                                                                                                         
-- Date        Author          Purpose                                                  
-- 12.30.2016  Vijeta s         Created.           
*********************************************************************************/                    
as  
  
-- Retrieve only LetterTemplateId in the final Select  
select 0 as LetterTemplateId  
  
  
GO


