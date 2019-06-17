IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetExpectedPaymentTemplateData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetExpectedPaymentTemplateData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ssp_GetExpectedPaymentTemplateData]
/********************************************************************************                                                      
-- Stored Procedure: ssp_GetExpectedPaymentTemplateData    
--    
-- Copyright: Streamline Healthcare Solutions    
--    
-- Purpose: Procedure to return data for using plan as template for Payment and Adujstment.    
--    
-- Author:  Pradeep A    
-- Date:    03.05.2012    
--    
-- *****History****    
--  03.05.2012		Pradeep            Created
--	21.03.2014      Md Hussain Khusro  Included two new columns in 'ExpectedPayment' table & one new table 'ExpectedPaymentProcedureCodes' 
--										in the result set for Task# 161 Philhaven Development
--  Oct 16 2015		Revathi				what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.           
										why:task #609, Network180 Customization 
*********************************************************************************/    
@CoveragePlanId INT
AS
BEGIN
	BEGIN TRY
		--ExpectedPayment
		SELECT  
		 --EP.ExpectedPaymentId AS ExpectedPaymentNo,
		 EP.ExpectedPaymentId AS ExpectedPaymentId,
		 EP.BillingCode,
		 --Added by Revathi Oct 16 2015
		 case when  ISNULL(C.ClientType,'I')='I' then ISNULL(C.LastName,'') + ', ' + ISNULL(C.FirstName,'') else ISNULL(C.OrganizationName,'') end  AS Client,               
		 CONVERT(VARCHAR, EP.FromDate, 101) AS PayFromDate,        
		 CONVERT(VARCHAR, EP.ToDate, 101) AS PayToDate,        
		 '$' + 
     	 IsNull(LEFT(Convert(VARCHAR,EP.Payment,1),CHARINDEX('.',Convert(VARCHAR,EP.Payment,1))-1) ,'') + ' ' + '/$' + 
		 IsNull(LEFT(Convert(VARCHAR,EP.AllowedAmount,1),CHARINDEX('.',Convert(VARCHAR,EP.AllowedAmount,1))-1) ,'')+ ' '         
		 AS PaymentAdjustment,        
		 [ExpectedPaymentId], 
		 [CoveragePlanId], 
		 [FromDate], 
		 [ToDate], 
		 [Payment], 
		 AllowedAmount , 
		 [ProgramGroupName], 
		 [LocationGroupName], 
		 [DegreeGroupName], 
		 [StaffGroupName], 
		 EP.[ClientId], 
		 [Priority],
		 EP.[CreatedBy], EP.[CreatedDate], EP.[ModifiedBy], EP.[ModifiedDate], 
		 EP.[RecordDeleted], EP.[DeletedDate], EP.[DeletedBy],        
		 Convert(VARCHAR(10),EP.FromDate,101) AS FromDt,       
		 Convert(VARCHAR(10),EP.ToDate,101) AS ToDt,--PR.ToDate     
		 EP.[Modifier1],EP.[Modifier2],EP.[Modifier3],EP.[Modifier4] ,
		 EP.[RevenueCode] ,EP.[PlaceOfServiceGroupName],
		 EP.[ClientWasPresent],
		 EP.[ServiceAreaGroupName],
		 EP.[PaymentPercentage],
         EP.[ProcedureCodeGroupName],  --Added by Md Hussain K
		 ISNULL(EP.BillingCode, '')  + ' ' + ISNULL(EP.Modifier1, '') +  ' ' + ISNULL(EP.Modifier2, '') +  ' ' + ISNULL(EP.Modifier3, '') +  ' ' + ISNULL(EP.Modifier4, '') AS BillingCodeModifiers    		 
	FROM        
		ExpectedPayment EP        
	LEFT JOIN        
		Clients C        
	ON (EP.ClientID = C.ClientID)     
	WHERE EP.CoveragePlanId = @CoveragePlanId   
	AND  ISNULL(EP.RecordDeleted , 'N')= 'N'        
	AND  ISNULL(C.RecordDeleted, 'N') = 'N'  
	
	--ExpectedPaymentPrograms
	SELECT         
			EPP.[ExpectedPaymentProgramId], 
			EPP.[ExpectedPaymentId], 
			EPP.[ProgramId], 
			EPP.[CreatedBy], 
			EPP.[CreatedDate], 
			EPP.[ModifiedBy], 
			EPP.[ModifiedDate], 
			EPP.[RecordDeleted], 
			EPP.[DeletedDate], 
			EPP.[DeletedBy]         
		FROM         
			ExpectedPaymentPrograms  EPP JOIN ExpectedPayment EP
		ON 
			EPP.ExpectedPaymentId = EP.ExpectedPaymentId      
			AND EP.CoveragePlanId = @CoveragePlanId 
			AND ISNULL(EP.RecordDeleted , 'N')= 'N'  
			AND ISNULL(EPP.RecordDeleted , 'N')= 'N' 
		ORDER BY 
			EPP.ExpectedPaymentProgramID 
			
	--ExpectedPaymentLocations		
	SELECT         
		 EPL.[ExpectedPaymentLocationId], 
		 EPL.[ExpectedPaymentId], 
		 EPL.[LocationId], 
		 EPL.[CreatedBy], 
		 EPL.[CreatedDate], 
		 EPL.[ModifiedBy], 
		 EPL.[ModifiedDate], 
		 EPL.[RecordDeleted], 
		 EPL.[DeletedDate], 
		 EPL.[DeletedBy]         
		FROM         
			ExpectedPayment EP  JOIN ExpectedPaymentLocations EPL   
		ON         
			EPL.ExpectedPaymentId = EP.ExpectedPaymentId         
		 AND
			ISNULL(EP.RecordDeleted , 'N')= 'N'         
		 AND         
		   ISNULL(EPL.RecordDeleted, 'N') = 'N'        
		 AND 
		 EP.CoveragePlanId = @CoveragePlanId   
		ORDER BY EPL.ExpectedPaymentLocationId 	
		
		--ExpectedPaymentDegrees	
		SELECT         
			EPD.[ExpectedPaymentDegreeId], 
			EPD.[ExpectedPaymentId], 
			EPD.[Degree], 
			EPD.[CreatedBy], 
			EPD.[CreatedDate], 
			EPD.[ModifiedBy], 
			EPD.[ModifiedDate], 
			EPD.[RecordDeleted], 
			EPD.[DeletedDate], 
			EPD.[DeletedBy]          
		FROM         
			ExpectedPaymentDegrees  EPD JOIN ExpectedPayment EP
		ON         
			EPD.ExpectedPaymentId  = EP.ExpectedPaymentId
		AND   
			ISNULL(EPD.RecordDeleted , 'N')	= 'N'     
		AND         
		   ISNULL(EP.RecordDeleted, 'N') = 'N'     
		ORDER BY 
			ExpectedPaymentDegreeID 
			
	--ExpectedPaymentStaff		
	SELECT         
		  EPS.[ExpectedPaymentStaffId], 
		  EPS.[ExpectedPaymentId], 
		  EPS.[StaffId], 
		  EPS.[CreatedBy], 
		  EPS.[CreatedDate], 
		  EPS.[ModifiedBy], 
		  EPS.[ModifiedDate], 
		  EPS.[RecordDeleted], 
		  EPS.[DeletedDate], 
		  EPS.[DeletedBy]         
		FROM         
		 ExpectedPaymentStaff     EPS JOIN ExpectedPayment EP    
		 ON 
		 EPS.ExpectedPaymentId = EP.ExpectedPaymentId AND
		 EP.CoveragePlanId = @CoveragePlanId AND  
		 ISNULL(EPS.RecordDeleted , 'N')= 'N'   AND
		 ISNULL(EP.RecordDeleted, 'N') = 'N'             
		 ORDER BY ExpectedPaymentStaffID  
			
	  
		--Expected Payment Service Area
		
		 SELECT  
			  EP.[ExpectedPaymentId], 
			  EPSA.ServiceAreaId,
			  EP.ServiceAreaGroupName,
			  EPSA.[CreatedDate], 
			  EPSA.[ModifiedBy], 
			  EPSA.[ModifiedDate], 
			  EPSA.[RecordDeleted], 
			  EPSA.[DeletedDate], 
			  EPSA.[DeletedBy],
			  EPSA.ExpectedPaymentServiceAreaId    ,
			  EPSA.CreatedBy      
		FROM         
			 ExpectedPaymentServiceAreas  EPSA JOIN ExpectedPayment EP    
			 ON EPSA.ExpectedPaymentId = EP.ExpectedPaymentId
			 --JOIN ServiceAreas SA ON EPSA.ServiceAreaId = EP
		WHERE
			 EP.CoveragePlanId = @CoveragePlanId AND  
			 ISNULL(EPSA.RecordDeleted , 'N')= 'N'   AND
			 ISNULL(EP.RecordDeleted, 'N') = 'N'             
		ORDER BY ExpectedPaymentServiceAreaId  
         
		--Expected Payment Place of Service
		
		SELECT 
		   EPPL.ExpectedPaymentPlaceOfServiceId
		  ,EPPL.[CreatedBy]
		  ,EPPL.[CreatedDate]
		  ,EPPL.[ModifiedBy]
		  ,EPPL.[ModifiedDate]
		  ,EPPL.[RecordDeleted]
		  ,EPPL.[DeletedDate]
		  ,EPPL.[DeletedBy]
		  ,EPPL.PlaceOfService
		  ,EPPL.ExpectedPaymentId
		FROM 
			dbo.ExpectedPaymentPlaceOfServices EPPL JOIN ExpectedPayment EP
			ON EPPL.ExpectedPaymentId = EP.ExpectedPaymentId 
			JOIN GlobalCodes GC on GC.GlobalCodeId = EPPL.PlaceOfService
		WHERE
			ISNULL(EP.RecordDeleted, 'N') = 'N' AND 
			ISNULL(EPPL.RecordDeleted, 'N') = 'N' AND
			EP.CoveragePlanId = @CoveragePlanId
			
	--Added by Md Hussain Khusro on 21/03/2014
    --Expected Payment Procedure Codes   
		SELECT           
			EPP.[ExpectedPaymentProcedureCodeId],     
			EPP.[CreatedBy],   
			EPP.[CreatedDate],   
			EPP.[ModifiedBy],   
			EPP.[ModifiedDate],   
			EPP.[RecordDeleted],   
			EPP.[DeletedDate],   
			EPP.[DeletedBy],
			EPP.[ExpectedPaymentId],   
			EPP.[ProcedureCodeId]           
		FROM           
		   ExpectedPaymentProcedureCodes EPP JOIN ExpectedPayment EP      
		   ON   
		   EPP.ExpectedPaymentId = EP.ExpectedPaymentId AND  
		   EP.CoveragePlanId = @CoveragePlanId  AND    
		   ISNULL(EPP.RecordDeleted , 'N')= 'N' AND  
		   ISNULL(EP.RecordDeleted, 'N') = 'N'               
		ORDER BY ExpectedPaymentProcedureCodeId 
	
	END TRY
	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)       
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                            
			+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_GetExpectedPaymentTemplateData')                                                                                             
			+ '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                              
			+ '*****' + CONVERT(VARCHAR,ERROR_STATE())
		RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
	END CATCH
END