-- =============================================   
-- Author:    Shivanand   
-- Description: Spelling of word Childhood are wrong in question 'What is the name of your favorite Childhoold friend'.
--              It should be ''What is the name of your favorite Childhood friend'.'
-- =============================================  

IF EXISTS(SELECT GlobalCodeId 
              FROM   GlobalCodes 
              WHERE  Category = 'SECURITYQUESTION' AND CodeName='What is the name of your favorite childhoold friend?') 
  BEGIN 
      UPDATE GlobalCodes Set CodeName ='What is the name of your favorite Childhood friend?' 
      WHERE Category = 'SECURITYQUESTION' AND 
            CodeName ='What is the name of your favorite childhoold friend?'
 END
 
GO 


