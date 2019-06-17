/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions  
-- "Orders"
-- Purpose:  
--  
-- Author:  Chethan N
-- Date:    05-Jul-2018
--  
-- *****History****  
   Date				Author				Description                    
   05/Jul/2018		Chethan N			Engineering Improvement Initiatives- NBL(I) task # 667                    
*********************************************************************************/

UPDATE OrderLabs SET RecordDeleted = 'Y', DeletedBy = 'EI#667', DeletedDate = GETDATE() WHERE ISNULL(IsDefault, 'N') = 'N'

UPDATE Orders SET ClinicalLocation = NULL