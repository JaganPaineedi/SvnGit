IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetSwapBedBedDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetSwapBedBedDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
                                                       
Create  Procedure [dbo].[ssp_GetSwapBedBedDetails]-- 24 -- 131           
(                    
@ClientInpatientVisitId int                    
)                    
As   
 Begin   
 Begin TRY     
/****************************************************************************************/                            
/* Stored Procedure: dbo.ssp_GetSwapBedBedDetails                                    */                            
/* Creation Date:  07-June-2012                                                         */                            
/* Creation By:  Veena S Mani                                                        */                            
/* Purpose: To Get Bed Details                         */                                                
/* Input Parameters: @ClientInpatientVisitId                                                           */                          
/* Output Parameters:                                                                   */                            
/*  Date                  Author                 Purpose                                */  
/*  20/01/2016            Veena                  Philhaven Development #373 Swap beds          */
/****************************************************************************************/                     

SELECT CI.ClientInpatientVisitId,
CI.ClientId,
BA.BedId,
B.DisplayAs + 
CASE WHEN dbo.ssf_GetGlobalCodeNameById(CI.ClientType) IS NULL
THEN ''
ELSE
'('+  isnull(dbo.ssf_GetGlobalCodeNameById(CI.ClientType),'') +')' END
 AS BedName,
R.DisplayAs AS Room,
U.DisplayAs AS Unit,
 CASE   
    WHEN ISNULL(C.ClientType, 'I') = 'I'  
     THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')  + '(' + CAST(C.ClientId AS VARCHAR) + ')'
    ELSE ISNULL(C.OrganizationName, '')  + '(' + CAST(C.ClientId AS VARCHAR) + ')'
    END AS ClientName
--C.LastName + ' ' + C.FirstName + '(' + CAST(C.ClientId AS VARCHAR) + ')' AS ClientName
from ClientInpatientVisits CI JOIN
BedAssignments BA ON CI.ClientInpatientVisitId=BA.ClientInpatientVisitId
INNER JOIN Beds B ON BA.BedId=B.BedId  
INNER JOIN Rooms R ON B.RoomId=R.RoomId 
INNER JOIN Units U ON R.UnitId=U.UnitId
INNER JOIN Clients C ON CI.ClientId=C.ClientId
WHERE CI.ClientInpatientVisitId=@ClientInpatientVisitId  and BA.EndDate is null     
AND   ISNULL(B.RecordDeleted, 'N') = 'N'  
AND   ISNULL(R.RecordDeleted, 'N') = 'N'         
AND   ISNULL(U.RecordDeleted, 'N') = 'N' 
AND   ISNULL(CI.RecordDeleted, 'N') = 'N' 
AND   ISNULL(BA.RecordDeleted, 'N') = 'N' 

     
END TRY                                                                            
BEGIN CATCH                                
DECLARE @Error varchar(8000)                                                                             
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                       
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetSwapBedBedDetails')                                                                                                           
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

