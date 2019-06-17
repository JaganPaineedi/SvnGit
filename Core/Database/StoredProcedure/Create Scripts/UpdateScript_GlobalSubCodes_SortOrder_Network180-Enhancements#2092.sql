/*********************************************************************/            
/**  Added by : K.Soujanya                                                   **/   
/**  Date : 11/Oct/2017                                                      **/   
/**  Purpose: What:Update script to set default status to 'All' in  Documents list page instead of 'Not Signed, Not Completed,  Not Co-Signed'       **/   
/**           Why:MHP-Environment Issues
**/       
/*********************************************************************/   

IF EXISTS (Select * from GlobalSubCodes WHERE   GlobalCodeId = 5403 AND SubCodeName='All Statuses' AND SortOrder=11)
BEGIN
	UPDATE  dbo.GlobalSubCodes
	SET     SortOrder=SortOrder + 1
    WHERE   GlobalCodeId = 5403 
            
END

IF EXISTS (Select * from GlobalSubCodes WHERE   GlobalCodeId = 5403 AND SubCodeName='All Statuses' AND SortOrder=12)
BEGIN
	UPDATE  dbo.GlobalSubCodes
	SET     SortOrder=1
    WHERE   GlobalCodeId = 5403 
            AND SubCodeName='All Statuses'
END
	