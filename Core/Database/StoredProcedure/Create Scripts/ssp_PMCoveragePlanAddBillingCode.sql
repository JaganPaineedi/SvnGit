IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[dbo].[ssp_PMCoveragePlanAddBillingCode]') AND TYPE IN (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PMCoveragePlanAddBillingCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

CREATE Procedure [dbo].[ssp_PMCoveragePlanAddBillingCode]      
		   @CoveragePlanID INT       ,
		   @ProcedureRateId	INT 

		AS      
/******************************************************************************    
**  File: dbo..ssp_PMCoveragePlanAddBillingCode .prc    
**  Name: dbo.ssp_PMCoveragePlanAddBillingCode     
**  Desc:     
**    
**  This template can be customized:    
**                  
**  Return values:    
**     
**  Called by:       
**                  
**  Parameters:    
**  Input       Output    
**     ----------       -----------    
**    
**  Auth: Mary Suma
**  Date: 05/12/2011    
*******************************************************************************    
**  Change History    
*******************************************************************************    
**  Date:		Author:    Description:    
**  --------	--------    -------------------------------------------    
**   05/12/2011 msuma		Added for Eligible Clients Tab of Plan Details
**	 08/24/2011 msuma		Renamed ProcedureCodeId 
/**  Eligible Clients**********************/    
19 /Oct/ 2015		Revathi 		what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.  
										why:task #609, Network180 Customization							
*******************************************************************************/  


     
BEGIN  
 
  
SELECT         
	PR.ProcedureRateId,
	PC.ProcedureCodeId      
	,PC.DisplayAs        
	,PC.ProcedureCodeName, 
    '$' + Convert(VARCHAR,PR.Amount,1) + CASE PR.Chargetype         
     WHEN 'P' THEN ' Per '  --Per        
     WHEN 'E' THEN ' For '  --Exact        
    END as ChargeTemplate   
	,CL.LastName + ', ' + CL.FirstName AS Client ,       
   CoveragePlanId, 
   PR.[ProcedureCodeId], 
   [FromDate], 
   [ToDate],  
   [ChargeType], 
   [FromUnit], 
   [ToUnit], 
   [ProgramGroupName], 
   [LocationGroupName], 
   [DegreeGroupName], 
   [StaffGroupName], 
   PR.ServiceAreaGroupName,
   PR.PlaceOfServiceGroupName,
   PR.ClientWasPresent,--Y/N/NA
   PR.[ClientId], 
   [Priority],
	BillingCodeClaimUnits,       
	[BillingCodeUnitType], [BillingCodeUnits], [BillingCode], [Modifier1], [Modifier2], [Modifier3], [Modifier4], [RevenueCode], 
[RevenueCodeDescription], [Advanced], 
PR.[Comment], 
[StandardRateId], 
[BillingCodeModified],        
PR.[CreatedBy], PR.[CreatedDate], PR.[ModifiedBy], PR.[ModifiedDate], PR.[RecordDeleted], PR.[DeletedDate], PR.[DeletedBy]         
  ,Convert(VARCHAR(10),PR.FromDate,101) AS FromDt--PR.FromDate        
  ,Convert(VARCHAR(10),PR.ToDate,101) AS ToDt--PR.ToDate          
 FROM         
  ProcedureRates PR         
 JOIN       
  ProcedureCodes PC         
 ON         
  PR.ProcedureCodeId = PC.ProcedureCodeId         
 LEFT JOIN Clients CL         
  ON  PR.ClientID = CL.ClientID         
 --LEFT JOIN ProcedureRateBillingCodes PRBC         
 -- ON PR.ProcedureRateID = PRBC.ProcedureRateID        
 LEFT JOIN GlobalCodes GC        
  ON GC.GlobalCodeId=PC.EnteredAs  
     
 WHERE        
 (PR.RecordDeleted = 'N' OR PR.RecordDeleted IS NULL)        
 AND        
  ISNULL(PC.RecordDeleted,'N') = 'N'        
AND
	ProcedureRateId = @ProcedureRateId    
         
     
END
        
GO