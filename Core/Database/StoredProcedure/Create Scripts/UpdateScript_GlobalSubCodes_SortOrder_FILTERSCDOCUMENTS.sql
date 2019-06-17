/*********************************************************************/            
/**  Added by : K.Soujanya                                                   **/   
/**  Date : 05/Jan/2018                                                     **/   
/**  Purpose: What:Update script to set default status to 'All' in  Client -> Documents list page instead of 'Signed, Completed'       **/   
/**           Why:Network180-Enhancements#2092
**/       
/*********************************************************************/   

IF EXISTS (Select * from GlobalSubCodes WHERE   GlobalCodeId = 5380 AND SubCodeName='All Statuses' AND SortOrder=2)
BEGIN
	UPDATE  dbo.GlobalSubCodes
	SET     SortOrder = 1
    WHERE   GlobalCodeId = 5380 AND SubCodeName='All Statuses' AND SortOrder=2
            
END

IF EXISTS (Select * from GlobalSubCodes WHERE   GlobalCodeId = 5380 AND SubCodeName='Signed, Completed' AND SortOrder=1)
BEGIN
	UPDATE  dbo.GlobalSubCodes
	SET     SortOrder=2
    WHERE   GlobalCodeId = 5380 
            AND SubCodeName='Signed, Completed' AND SortOrder=1
END
	