/*********************************************************************/
--  Created By	:	Alok Kumar
--  Dated		:	16/May/2016
--  Purpose		:	To update TableList value
--  What/Why	:	#602.5 Network 180 Environment Issues Tracking

/*********************************************************************/

IF EXISTS (select 1 from DocumentCodes where DocumentCodeId=1637)

BEGIN
	UPDATE DocumentCodes SET TableList='DocumentAuthorizationRequests,AuthorizationRequests,ImageRecords,BillingCodes' where DocumentCodeId=1637
END

