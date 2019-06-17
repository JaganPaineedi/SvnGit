/******************************************************************************                                                     
**  Auth:  Swatika  
**  Date:  27/08/2018  
** Update script for adding code field in DocumentCodes table for DSM 5 Diagnosis MHP - Enhancements #34
********************************************************************************/  
  If EXISTS (Select Code From DocumentCodes Where DocumentCodeId=1601)
  BEGIN
    UPDATE DocumentCodes SET Code='DSM5DIAGNOSIS' WHERE DocumentCodeId=1601 
  END 
  
  
  