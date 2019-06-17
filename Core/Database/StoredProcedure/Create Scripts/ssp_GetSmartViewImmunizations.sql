/****** Object:  StoredProcedure [dbo].[ssp_GetSmartViewImmunizations]    Script Date: 10/17/2017 15:02:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetSmartViewImmunizations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetSmartViewImmunizations]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetSmartViewImmunizations] 13460   Script Date: 10/17/2017 15:02:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

               
CREATE proc [dbo].[ssp_GetSmartViewImmunizations]        
(                      
  @ClientId int                           
)                      
as                  
/******************************************************************************                        
**  File: ssp_GetSmartViewImmunizations.sql                       
**  Name: ssp_GetSmartViewImmunizations   66899
**  Desc: To Retrive SmartView Sections Data.
**  Return values:                        
**  Parameters:                     
**  Auth: Manjunath K                        
**  Date: 28 OCT 2017             
*******************************************************************************                        
**  Change History                        
*******************************************************************************                        
**  Date:      Author:     Description:                        
**  ---------  --------    -------------------------------------------                        
**      
*************************************************************************************/                      
BEGIN                     
                
BEGIN TRY                 

SELECT c.ClientImmunizationId  
   ,GV.CodeName AS ImmunizationsName  
   ,CONVERT(VARCHAR(10),C.AdministeredDateTime,101)  AS DateTimeImmunizations
   --,C.ExportedDateTime   AS DateTimeImmunizations
   ,GStatus.CodeName AS ImmunizationsStatus  
  FROM ClientImmunizations C  
  LEFT JOIN GlobalCodes GV ON C.VaccineNameId = GV.GlobalCodeId  
   AND ISNULL(GV.RecordDeleted, 'N') = 'N'  
  LEFT JOIN GlobalCodes GM ON C.ManufacturerId = GM.GlobalCodeId  
   AND ISNULL(GM.RecordDeleted, 'N') = 'N'  
  LEFT JOIN GlobalCodes GAmount ON C.AdministedAmountType = GAmount.GlobalCodeId  
   AND ISNULL(GAmount.RecordDeleted, 'N') = 'N'  
  LEFT JOIN GlobalCodes GStatus ON C.VaccineStatus = GStatus.GlobalCodeId  
   AND ISNULL(GStatus.RecordDeleted, 'N') = 'N'  
  WHERE C.ClientId = @ClientId  
   AND ISNULL(C.RecordDeleted, 'N') = 'N'; 

END TRY                                                                                    
BEGIN CATCH                                        
DECLARE @Error varchar(8000)                                                                                   
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                 
+ '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),                                
'ssp_GetSmartViewImmunizations')                                                                                                                   
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                                    
    + '*****' + Convert(varchar,ERROR_STATE())                                                                
 RAISERROR                                                                                       
 (                                                                                     
  @Error, -- Message text.                                                                                                       
  16, -- Severity.                                                                                                                  
  1 -- State.                                           
 );                                                                                                                
END CATCH                  
end
GO