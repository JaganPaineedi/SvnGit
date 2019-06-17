
/****** Object:  StoredProcedure [dbo].[scsp_ListPageSCMyDocuments]    Script Date: 06/25/2014 14:45:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_ListPageSCMyDocuments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_ListPageSCMyDocuments]
GO

/****** Object:  StoredProcedure [dbo].[scsp_ListPageSCMyDocuments]    Script Date: 12/13/2012 14:45:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE procedure [dbo].[scsp_ListPageSCMyDocuments]    
@LoggedInStaffId INT,      
@StaffId INT,      
@ClientsFilter varchar(50),      
@DocumentNavigationIdFilter INT,      
@DocumentStatusFilter INT,      
@DueDaysFilter INT,      
@OtherFilter INT ,
@DosFrom datetime='' , -- 20.12.2016	Ravichandra
@DosTo  datetime=''   -- 20.12.2016	Ravichandra                                        
/********************************************************************************                                                  
-- Stored Procedure: dbo.scsp_ListPageSCMyDocuments                                                    
--                                                  
-- Copyright: Streamline Healthcate Solutions                                                  
--                                                  
-- Purpose: used by My Caseload  list page to apply custom filters      
-- Called by: ssp_ListPageSCMyDocuments      
--                                                  
-- Updates:                                                                                                         
-- Date        Author   Purpose                                                  
-- 06.25.2014  Gautam    Created 
-- 09/10/2014  Added condition to check if csp_ListPageSCMyDocuments exists - Care Management to SmartCare Env. Issues Tracking task #314
-- 20/12/2016  Ravichandra What: Added Date Filters Paramter @DosFrom and @DosTo
						  why : Bradford - Customizations Tasks #289--My Documents List page: Add 'All Statuses' to status drop down >  
*********************************************************************************/                                                  
AS    
BEGIN                  
BEGIN TRY                                                 
                       
 if object_id('dbo.csp_ListPageSCMyDocuments', 'P') is not null
 BEGIN
 EXEC csp_ListPageSCMyDocuments @LoggedInStaffId = @LoggedInStaffId,                                 
                                   @StaffId = @StaffId,                
                                   @ClientsFilter = @ClientsFilter,                                                              
                                   @DocumentNavigationIdFilter = @DocumentNavigationIdFilter,                                    
                                   @DocumentStatusFilter = @DocumentStatusFilter,                                     
                                   @DueDaysFilter = @DueDaysFilter,                                    
                                   @OtherFilter = @OtherFilter ,
                                   @DosFrom = @DosFrom , -- 20.12.2016	Ravichandra
								   @DosTo  = @DosTo   -- 20.12.2016	Ravichandra
 END
    
END TRY                  
BEGIN CATCH                  
 DECLARE @Error varchar(8000)                                                                 
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                               
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'scsp_ListPageSCMyDocuments')                                                                                               
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                
    + '*****' + Convert(varchar,ERROR_STATE())                                            
 RAISERROR                                                                                               
 (                     
   @Error, -- Message text.                                                                                              
   16, -- Severity.                                                                                              
   1 -- State.                                                                                              
  );                   
END CATCH                  
END 
GO


