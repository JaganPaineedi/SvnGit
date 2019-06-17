/*********************************************************************/            
/**  Added by : Ajay K Bangar                                                      **/   
/**  Date : 21/Oct/2016                                                      **/   
/**  Purpose: To copying IntegerCodeId to CharacterCodeId where CategoryCode = 'STATESFORCOUNTYDROPDOWNS'        **/   
/**  Why: Column StateFIPS (char type) column (In States table) was joining with InegerCodeId (Int type) column(In Recodes table). 
		  So whenever StateFIPS will have charecter type value it will throw data conversion error. So we are copying IntegerCodeId into CharacterCodeId
		  and we are joining States table to Recodes table with States.StateFIPs = Recodes.CharacterCodeId and applying UNION to existing recodes. 
          Woods - Support Go Live:Task#311  
**/       
/*********************************************************************/            

DECLARE @RecodeCategoryId INT

SELECT @RecodeCategoryId = RecodeCategoryId
FROM RecodeCategories
WHERE CategoryCode = 'STATESFORCOUNTYDROPDOWNS'

UPDATE Recodes
SET CharacterCodeId = IntegerCodeId
WHERE RecodeCategoryId = @RecodeCategoryId