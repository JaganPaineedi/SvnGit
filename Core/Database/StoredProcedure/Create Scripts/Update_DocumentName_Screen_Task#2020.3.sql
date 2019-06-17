 /*********************************************************************************/  
-- Copyright: Streamline Healthcate Solutions  
--  
-- Purpose:
--  
-- Author:  Animesh Gaurav 
-- Date:    02/05/2018  
--: I have changed the Document Name from Progress Note to Medical Progress Note in document codes and screens table
 
 if exists(select * from DocumentCodes where DocumentName='Progress Note')
 begin 
 update DocumentCodes 
         
 set DocumentName='Medical Progress Note'
    
 where DocumentName='Progress Note'
 end
 
  if exists(select * from DocumentCodes where DocumentDescription='Progress Note')
 begin 
 update DocumentCodes 
         
 set  
    DocumentDescription= 'Medical Progress Note'
 where DocumentDescription='Progress Note'
 end
 
 
  if exists(select * from Screens  where ScreenName='Progress Notes')
 begin 
 update Screens 
         
 set  
    ScreenName= 'Medical Progress Note'
 where ScreenName='Progress Notes'
 
 end