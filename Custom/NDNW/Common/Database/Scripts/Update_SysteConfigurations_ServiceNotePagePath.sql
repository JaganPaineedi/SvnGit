-- =============================================  
-- Author:    Malathi Shiva 
-- Create date: Mar 3, 2015 
-- Description:  Updates the Service Note Path for New Directions: Task# 4: New Directions - Setup : It says move Service Note from Valley Environment 
-- =============================================    
UPDATE SystemConfigurations 
SET    ServiceNoteServicePagePath = 
              '~/ActivityPages/Client/Detail/ServiceNote/ServiceNoteUC3.ascx' 