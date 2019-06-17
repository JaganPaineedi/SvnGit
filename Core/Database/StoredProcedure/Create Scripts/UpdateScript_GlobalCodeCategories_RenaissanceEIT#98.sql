/********************************************************************************                                                   
-- Purpose: Created.(#98 Renaissance - Environment Issues Tracking)
-- Author:  Rajeshwari S
-- Date:    05-Apr-2018
*********************************************************************************/
UPDATE GlobalCodeCategories 
SET    HasSubcodes = 'Y' 
WHERE  Category = 'IMAGEASSOCIATEDWITH' 
       AND ISNULL(RecordDeleted, 'N') = 'N' 