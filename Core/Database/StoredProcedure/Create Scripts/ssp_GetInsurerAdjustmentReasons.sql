IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetInsurerAdjustmentReasons]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetInsurerAdjustmentReasons]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE Proc [dbo].[ssp_GetInsurerAdjustmentReasons] 
@InsurerId int
As
/*************************************************************************************************/
            
/*************************************************************************************************/  
Begin	
 BEGIN TRY
  SELECT IAR.[InsurerCOBExcludeAdjustmentReasonId]
      ,IAR.[CreatedBy]
      ,IAR.[CreatedDate]
      ,IAR.[ModifiedBy]
      ,IAR.[ModifiedDate]
      ,IAR.[RecordDeleted]
      ,IAR.[DeletedBy]
      ,IAR.[DeletedDate]
      ,IAR.[InsurerId]
      ,[AdjustmentReason]
  FROM [InsurerCOBExcludeAdjustmentReasons] IAR
  INNER JOIN Insurers I ON I.InsurerId=IAR.InsurerId
  WHERE ISNULL(IAR.RecordDeleted,'N')='N'
  AND ISNULL(I.RecordDeleted,'N')='N'
  AND I.InsurerId=@InsurerId

 END TRY
BEGIN CATCH  
     IF @@error <> 0  
		 BEGIN    
		    RAISERROR('Failed to execute ssp_GetInsurerAdjustmentReasons.', 16, 1);
		  END  
  END CATCH 
END   



GO


