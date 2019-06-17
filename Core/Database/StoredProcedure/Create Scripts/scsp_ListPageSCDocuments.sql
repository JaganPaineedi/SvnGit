
/****** Object:  StoredProcedure [dbo].[scsp_ListPageSCDocuments]     ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_ListPageSCDocuments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_ListPageSCDocuments]
GO

/****** Object:  StoredProcedure [dbo].[scsp_ListPageSCDocuments]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
create procedure [dbo].[scsp_ListPageSCDocuments]  
@ClientId int,                        
@ClinicianId int,                                                  
@AuthorIdFilter int,                        
@StatusFilter int,                         
@DueDaysFilter int,                        
@DocumentNavigationId int,                        
@OtherFilter int ,  
@DosFrom datetime , -- 20.12.2016	Ravichandra
@DosTo  datetime   -- 20.12.2016	Ravichandra
/********************************************************************************  
-- Stored Procedure: dbo.ssp_ListPageSCDocuments    
--  
-- Copyright: Streamline Healthcate Solutions  
--  
-- Purpose: used by Client Documents list page to apply custom filters  
-- Called by: ssp_ListPageSCDocuments  
--  
-- Updates:                                                         
-- Date        Author      Purpose  
-- 06.25.2010  SFarber     Created.        
-- 12.20.2016  Ravichandra What: Added Date Filters Paramter @DosFrom and @DosTo
						   why : Bradford - Customizations Tasks #289--My Documents List page: Add 'All Statuses' to status drop down >  
*********************************************************************************/  
as  
  
-- Retrieve only DocumentId in the final Select statement  
  
select null as DocumentCodeId  
  
return  