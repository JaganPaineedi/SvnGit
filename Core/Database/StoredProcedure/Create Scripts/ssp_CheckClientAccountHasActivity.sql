IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CheckClientAccountHasActivity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CheckClientAccountHasActivity]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_CheckClientAccountHasActivity]              
@ClientID int,  
@CoveragePlanId int            
as              
              
/******************************************************************************              
**  File: dbo.ssp_CheckClientAccountHasActivity             
**  Name: Stored_Procedure_Name           
**              
**  Auth:  Bernardin             
**  Date:  01/18/2016             
*******************************************************************************/  

BEGIN

	BEGIN TRY
	
  IF EXISTS( SELECT  1         
   FROM                
    Services S LEFT JOIN Charges CH ON S.ServiceId = CH.ServiceId              
    LEFT JOIN ClientCoveragePlans CCP ON CH.clientCoveragePlanId = CCP.clientCoveragePlanId               
    LEFT JOIN CoveragePlans CP ON CCP.CoveragePlanId = CP.CoveragePlanId               
    LEFT JOIN ARLedger AR ON CH.ChargeId = AR.ChargeId              
   WHERE                
    S.Clientid = @ClientID AND CH.clientCoveragePlanId IS NOT NULL AND CCP.CoveragePlanId = @CoveragePlanId AND (s.RecordDeleted IS NULL OR s.RecordDeleted = 'N')               
    GROUP BY               
    CH.clientCoveragePlanId              
    ,CH.Flagged              
    ,CP.DisplayAs              
    ,CCP.InsuredId    
    ,CP.CoveragePlanId          
   Having Sum(AR.Amount)>0  )
   BEGIN
   Select '1' AS Presents
   END
   ELSE
   BEGIN
    Select '0' AS Presents
   END
	END TRY
              
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_CheckClientAccountHasActivity')                                                                                             
			+ '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                              
			+ '*****' + CONVERT(VARCHAR,ERROR_STATE())
		RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
	END CATCH 
	RETURN

END