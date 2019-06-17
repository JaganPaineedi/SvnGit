/************************************************************************************************                              
 
**  Author:  Sunil.D   
**  Date:    04/13/2017      
*************************************************************************************************      
**  Change History       
**  Date:    Author:   Description:       
**  --------   --------  -------------------------------------------------------------      
  
*************************************************************************************************/  
  
IF NOT EXISTS (	SELECT *	FROM GlobalCodes	WHERE Category = 'STAFFLIST' and code='TxEpisodeAssociatedStaff' AND ISNULL(RecordDeleted, 'N') = 'N'		)
BEGIN
	INSERT INTO GlobalCodes (
		Category
		,CodeName
		,Code
		,[Description]
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		,ExternalCode1
		,ExternalSource1
		,ExternalCode2
		,ExternalSource2
		,Bitmap
		,BitmapImage
		,Color
		)
	VALUES (
		'STAFFLIST'
		,'Tx Episode Associated Staff'
		,'TxEpisodeAssociatedStaff'
		,NULL
		,'Y'
		,'Y'
		,null
		,null
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		,NULL
		)
		
END 
 
 
 
 