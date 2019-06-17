 
/****** Object:  StoredProcedure [dbo].[ssp_PCGetClientInfoByClientId]    Script Date: 07/06/2012 14:53:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PCGetClientInfoByClientId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PCGetClientInfoByClientId]
GO
 
/****** Object:  StoredProcedure [dbo].[ssp_PCGetClientInfoByClientId]    Script Date: 07/06/2012 14:53:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO 

    
CREATE PROCEDURE [dbo].[ssp_PCGetClientInfoByClientId]     
@ClientId int=0
AS    
/**************************************************************/                                                                                            
/* Stored Procedure: [ssp_PCGetClientInfoByClientId]   */
/* Task# - 7 - Scheduling - Primary Care - Summit Pointe*/                                                                                   
/* Creation Date:  03August2012                                */     
/* Creation By:	   Davinderk                                */                      
/* Purpose: To Get client dob,client current coverage plan      */                                                                                           
/* Input Parameters:   @ClientId           */                                                                                          
/* Output Parameters:            */                                                                                            
/* Return:               */                                                                                            
/* Called By: Core My calendar - New Primary Care Entry      */                                                                                  
/* Calls:                                                     */                                                                                            
/*                                                            */                                                                                            
/* Data Modifications:                                        */                                                                                            
/* Updates:                                                   */                                                                                            
/* Date			Author				Purpose         */   
/* 20-Aug-2012	Davinderk			Update - select ClientName 	*/
/* 16 Oct 2015		Revathi				what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.       
										why:task #609, Network180 Customization  */
/**************************************************************/      


BEGIN    
BEGIN TRY  

SELECT TOP 1 COBOrder,CoveragePlanName,StartDate,EndDate, ISNULL(CONVERT(VARCHAR,C.DOB,101),'') AS ClientDOB
,CASE --Added by Revathi 16 Oct 2015
				WHEN ISNULL(C.ClientType, 'I') = 'I'
					THEN rtrim(ISNULL(C.LastName, '')) + ', ' + rtrim(ISNULL(C.FirstName, ''))
				ELSE ISNULL(C.OrganizationName, '')
				END AS ClientName,
C.Active
FROM Clients C left join
(
	select CCH.COBOrder,CCP.ClientId, CP.CoveragePlanName,CCH.StartDate,CCH.EndDate from
	ClientCoveragePlans CCP inner JOIN  
	ClientCoverageHistory CCH on cch.ClientCoveragePlanId=CCP.ClientCoveragePlanId and ISNULL(CCP.RecordDeleted,'N')<>'Y' 
	inner JOIN CoveragePlans CP on CP.CoveragePlanId=ccp.CoveragePlanId and ISNULL(CCH.RecordDeleted,'N')<>'Y'
	where (CCH.EndDate >= GETDATE() OR CCH.EndDate ='' OR  CCH.EndDate IS NULL)  
) T ON C.ClientId= t.ClientId
WHERE c.ClientId=@ClientId and ISNULL(C.RecordDeleted,'N')<>'Y'
and C.Active='Y'
ORDER BY COBOrder,StartDate ASC
     
END TRY    
BEGIN CATCH                                
DECLARE @Error varchar(8000)                                                                          
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_PCGetClientInfoByClientId')                                                                                                           
+ '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                            
+ '*****' + Convert(varchar,ERROR_STATE())                                                        
RAISERROR                                                                                                           
(                                                                             
@Error, -- Message text.         
16, -- Severity.         
1 -- State.                                                           
);                                                                                                        
END CATCH     
END  
GO


