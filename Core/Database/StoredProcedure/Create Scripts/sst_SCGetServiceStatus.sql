IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SCGetServiceStatus]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[SCGetServiceStatus]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

    
CREATE function [dbo].[SCGetServiceStatus] (@ServiceId int) returns int    
/********************************************************************************                                        
-- Stored Procedure: SCGetServiceStatus                                          
--                                        
-- Copyright: Streamline Healthcate Solutions                                        
--                                        
-- Purpose: To get the service status
--                                        
-- Updates:                                                                                               
-- Date        Author      Purpose                                        
-- 10/05/2017  Hemant      Created.                                              
*********************************************************************************/                                        
begin        
  
declare @Status int  
                      
select @Status = [Status]
  from Services 
 where ServiceId = @ServiceId  
   and isnull(RecordDeleted, 'N') = 'N'  
    
return @Status  
  
end  
  
GO


