IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetEMNoteScoringForOrders]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetEMNoteScoringForOrders]
GO      
    
CREATE PROCEDURE [dbo].[ssp_GetEMNoteScoringForOrders]     
 (    
 @OrderIds VARCHAR(MAX) 
)    
AS    
/******************************************************************************************     
  Created By   : Pabitra [ssp_GetEMNoteScoringForOrders]            
  Created Date : 19 APR 2018             
  Description  : To get the orders Score for EM Calculation        
  Called From  :ClientOrderUserControl.ashx       
    Date			Author          Description              
    04/19/2018	    Chethan N		What : Created
									Why : Engineering Improvement Initiatives- NBL(I) task #585.2 
******************************************************************************************/     
BEGIN    
 BEGIN TRY    
   
 DECLARE @MDMDRROClinicalLabs CHAR(1),
		@MDMDRRORadiologyTest CHAR(1),
		@MDMDRROOtherTest CHAR(1),
		@MDMRCMMDCardiacElectro CHAR(1)
 
 
 SET @MDMDRROClinicalLabs = CASE WHEN EXISTS(SELECT 1
    FROM Orders O
    WHERE EXISTS(SELECT Token FROM [dbo].[SplitString] (@OrderIds,',') WHERE Token = O.OrderId)
    AND NOT EXISTS(SELECT IntegerCodeId FROM dbo.ssf_RecodeValuesAsOfDate('EKGOrders', GETDATE()) AS EKGO WHERE EKGO.IntegerCodeId = O.OrderId )
    AND O.OrderType = 6481)
    THEN 'Y'
    ELSE 'N'
    END
    
 SET @MDMDRRORadiologyTest = CASE WHEN EXISTS(SELECT 1
    FROM Orders O
    WHERE EXISTS(SELECT Token FROM [dbo].[SplitString] (@OrderIds,',') WHERE Token = O.OrderId)
    AND NOT EXISTS(SELECT IntegerCodeId FROM dbo.ssf_RecodeValuesAsOfDate('EKGOrders', GETDATE()) AS EKGO WHERE EKGO.IntegerCodeId = O.OrderId )
    AND O.OrderType = 6482)
    THEN 'Y'
    ELSE 'N'
    END
        
 SET @MDMDRROOtherTest = CASE WHEN EXISTS(SELECT 1
    FROM Orders O
    WHERE EXISTS(SELECT Token FROM [dbo].[SplitString] (@OrderIds,',') WHERE Token = O.OrderId)
    AND NOT EXISTS(SELECT IntegerCodeId FROM dbo.ssf_RecodeValuesAsOfDate('EKGOrders', GETDATE()) AS EKGO WHERE EKGO.IntegerCodeId = O.OrderId )
    AND O.OrderType NOT IN (6482, 6481))
    THEN 'Y'
    ELSE 'N'
    END
    
 SET @MDMRCMMDCardiacElectro = CASE WHEN EXISTS(SELECT 1
    FROM Orders O
    WHERE EXISTS(SELECT Token FROM [dbo].[SplitString] (@OrderIds,',') WHERE Token = O.OrderId)
    AND EXISTS(SELECT IntegerCodeId FROM dbo.ssf_RecodeValuesAsOfDate('EKGOrders', GETDATE()) AS EKGO WHERE EKGO.IntegerCodeId = O.OrderId )
    )
    THEN 'Y'
    ELSE 'N'
    END
    
 Select @MDMDRROClinicalLabs AS MDMDRROClinicalLabs,
		@MDMDRRORadiologyTest AS MDMDRRORadiologyTest,
		@MDMDRROOtherTest AS MDMDRROOtherTest,
		@MDMRCMMDCardiacElectro AS MDMRCMMDCardiacElectro
    
   

      
 END TRY    
    
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)    
    
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetEMNoteScoringForOrders') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @Error    
    ,-- Message text.                                                                                                      
    16    
    ,-- Severity.                                                                                                      
    1 -- State.                                                                                                      
    );    
 END CATCH    
END    