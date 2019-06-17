
IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[ssp_PMCoveragePlanDetailInitData]') AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1)
	DROP PROCEDURE ssp_PMCoveragePlanDetailInitData
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE ssp_PMCoveragePlanDetailInitData
@CoveragePlanId INT	
,@ProcedureCodeId INT
AS

	/****************************************************************************** 
	** File: ssp_PMCoveragePlanDetailInitData.sql
	** Name: ssp_PMCoveragePlanDetailInitData
	** Desc:  
	** 
	** 
	** This template can be customized: 
	** 
	** Return values: Drop down values for Plan Details General Tab
	** 
	** Called by: 
	** 
	** Parameters: 
	** Input			Output 
	** ----------		----------- 
	** CoveragePlanId	Dropdown values for General Tab
	** Auth: Mary Suma
	** Date: 12/05/2011
	******************************************************************************* 
	** Change History 
	******************************************************************************* 
	** Date: 			Author: 			Description: 
	** 12/05/2011		MSuma				Procedure to retrieve drop down values in General Tab
	-------- 			-------- 			--------------- 
	** 12/09/2011		MSuma				Fix on CoveragePlan Rules
	*******************************************************************************/

BEGIN
	BEGIN TRY
    -- Table 1 PAyers
	SELECT            
	  PayerId, PayerName            
	FROM            
	  payers            
	WHERE            
	  Active = 'Y'
	  AND 
	  (RecordDeleted='N' or RecordDeleted is null)            
	ORDER BY            
	   PayerName 
	 
	 -- Table 2 Provider ID Type
	 
	 SELECT            
	  GlobalCOdeId, COdeName            
	FROM            
	  GlobalCOdes            
	WHERE            
	  Active = 'Y'
	  AND 
	  (RecordDeleted='N' or RecordDeleted is null)  
	  AND Category =     'PROVIDERIDTYPE'      
	ORDER BY            
	   SortOrder,CodeName
	  
	  -- Table 3 Claim Filling Indicator COde
	  
	  
	 SELECT            
	  GlobalCOdeId, COdeName            
	FROM            
	  GlobalCOdes            
	WHERE            
	  Active = 'Y'
	  AND 
	  (RecordDeleted='N' or RecordDeleted is null)  
	  AND Category =     'CLAIMINDICATORCODE'      
	ORDER BY            
	   SortOrder,CodeName
	  

	   -- TAble 4 Electronic Claim Format
	 SELECT            
	  GlobalCOdeId, COdeName            
	FROM            
	  GlobalCOdes            
	WHERE            
	  Active = 'Y'
	  AND 
	  (RecordDeleted='N' or RecordDeleted is null)  
	  AND Category =     'CLAIMFORMATTYPE'  
	  AND GlobalCodeId in(4684,4683)    
	ORDER BY            
	   SortOrder,CodeName
	     
	   -- Table 5 Paper Claim Format
	   
	   	 SELECT            
	  GlobalCOdeId, COdeName            
	FROM            
	  GlobalCOdes            
	WHERE            
	  Active = 'Y'
	  AND 
	  (RecordDeleted='N' or RecordDeleted is null)  
	  AND Category =     'CLAIMFORMATTYPE'     
	    AND GlobalCodeId in(4681,4682)  
	ORDER BY            
	   SortOrder,CodeName  
			
	
	 
	   --Table 8 Advanced Claim Format for Plans
	   
	   --SELECT   CP.CoveragePlanClaimFormatId,
				--'N' as RadioButton,
				--'' as DeleteButton,
				--CP.CoveragePlanId ,  
				--CP.ProgramId, 
				--CASE  WHEN CP.PaperClaimFormatId IS NULL 
				--	THEN 'Electronic'  ELSE  'Paper' End as FormatType,  
				--CASE  WHEN CP.PaperClaimFormatId IS NULL 
				--	  THEN CM1.FormatName ELSE CM.FormatName End AS FormatName,  
				--P.ProgramName,
				--GC1.CodeName as DegreeName, 
				--CASE  WHEN S.DEGREE IS NULL THEN S.LastName + ', ' + S.FirstName ELSE S.LastName + ', ' + S.FirstName + ' ' + GC.CodeName END AS StaffName
				--from  
				--	  CoveragePlanClaimFormats CP   
				--LEFT JOIN GlobalCodes GC1 on GC1.GlobalCodeId = CP.Degree  
				--LEFT JOIN Staff S on S.StaffId = CP.StaffId   
				--LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId=S.Degree   
				--LEFT JOIN ClaimFormats CM ON CP.PaperClaimFormatId = CM.ClaimFormatID   
				--LEFT JOIN ClaimFormats CM1 ON CP.ElectronicClaimFormatId = CM1.ClaimFormatID   
				--LEFT JOIN  Programs P ON P.ProgramId = CP.ProgramId  
				--Where CP.CoveragePlanId = @CoveragePlanId   
				--AND isnull(CP.RecordDeleted,'N') <>'Y'   
				--ORDER BY CP.ModifiedDate  
	 
	   --Table 9 Advanced ProviderId Type Plans
	     
		SELECT DISTINCT    
		  GlobalCodeId AS GlobalCodeId,    
		  CodeName     AS CodeName 
		FROM             
		  GlobalCodes    
		WHERE 
			Category = 'ProviderIDType'    
		AND 
			Active = 'Y'    
		AND 
			ISNULL(RecordDeleted, 'N') = 'N' 
			
			
	--Table 10 All Programs              
            
	            
	SELECT DISTINCT 
		P.ProgramId,
		P.ProgramCode               
	FROM Programs P              
	       
	WHERE              
	ISNULL(P.RecordDeleted, 'N') = 'N'              
	AND P.Active = 'Y'         
	ORDER BY ProgramCode                 
                            
	
	--Table 11 All Degrees
	
	SELECT 
		DISTINCT  GC.GlobalCodeId,              
		GC.CodeName, ISNULL(GC.SortOrder,9999) AS SortOrder                
	FROM                       
		GlobalCodes GC	             
	WHERE               
	GC.Category = 'DEGREE'
	AND GC.Active = 'Y'               
	AND               
	(GC.RecordDeleted = 'N' OR GC.RecordDeleted IS NULL)              
	ORDER BY SortOrder,CodeName                     
	 
  
              
	--Table 12 All Staff              
            
	SELECT S.StaffId,              
	CASE               
	WHEN GC.CodeName IS NULL THEN S.LastName + ', ' + S.FirstName              
	ELSE S.LastName + ', ' + S.FirstName + ' ' + GC.CodeName              
	END AS StaffName              
	FROM Staff S              
	LEFT JOIN              
	GlobalCodes GC              
	ON               
	GC.GlobalCodeId=S.Degree  
	WHERE 
	S.Active='Y'              
	AND              
	ISNULL(S.RecordDeleted, 'N') = 'N'              
	ORDER BY StaffName              

	-- Table 13 Billing Codes Tab: Advanced Billing Codes
	
	SELECT  
		 	
		1 AS DeleteButton,
		'N' AS RadioButton, 
		BillingCode + ' ' + Modifier1 + ' ' + Modifier2   AS CodeModifire,
		/*Column for the Type column in datagrid.*/
		PRB.RevenueCode,
		PRB.FromUnit,
		PRB.ToUnit,
		'' AS Type
	FROM 
        ProcedureRateBillingCodes PRB
	WHERE
		PRB.ProcedureRateId  IN(
								SELECT 
									ProcedureRateId 
								From ProcedureRates
								Where ProcedureCodeID =@ProcedureCodeId
							)
		AND ISNULL(PRB.RecordDeleted,'N')='N'
	ORDER BY ProcedureRateBillingCodeID
    
    
    -- Table 14 ProcedureCodes
    
	SELECT 
		0 AS ProcedureCodeId,            
		'' AS ProcedureCodeName            
	union            
	SELECT            
	  ProcedureCodeId AS ProcedureCodeId,
	  ProcedureCodeName AS ProcedureCodeName          
	FROM            
	  ProcedureCodes            
	WHERE            
	  Active = 'Y'
	  AND 
	  (RecordDeleted='N' or RecordDeleted is null)            
	ORDER BY            
	   ProcedureCodeName 
	
	
	    
   
	 --Table 15 Grid values in Expected Payment
	 
	 
	----SELECT            
	----	 1 DeleteButton,        
	----	 'N' AS RadioButton,        
	----	 C.LastName + ', ' + C.FirstName AS Client,        
	----	 PC.DisplayAs,        
	----	 CONVERT(VARCHAR, EP.FromDate, 101) AS PayFromDate,        
	----	 CONVERT(VARCHAR, EP.ToDate, 101) AS PayToDate,        
	----	 '$' + CASE PC.AllowDecimals        
	----	   WHEN 'Y' THEN Convert(VARCHAR,EP.Payment,1) + ' '        
	----	   ELSE IsNull(LEFT(Convert(VARCHAR,EP.Payment,1),CHARINDEX('.',Convert(VARCHAR,EP.Payment,1))-1) ,'') + ' ' END + '/$' + CASE PC.AllowDecimals        
	----	   WHEN 'Y' THEN Convert(VARCHAR,EP.AdjustMent,1) + ' '        
	----	   ELSE IsNull(LEFT(Convert(VARCHAR,EP.AdjustMent,1),CHARINDEX('.',Convert(VARCHAR,EP.AdjustMent,1))-1) ,'')+ ' ' END +        
	----	 CASE ChargeType         
	----	   WHEN 'P' THEN ' Per ' + CAST(FromUnit AS VARCHAR)+ ' '+ ISNULL( (SELECT CodeName FROM GlobalCodes WHERE GlobalCodeID = PC.EnteredAs), '')        
	----	   WHEN 'E' THEN ' Exactly for ' + CAST(FromUnit AS VARCHAR)+ ' '+ ISNULL( (SELECT CodeName FROM GlobalCodes WHERE GlobalCodeID = PC.EnteredAs), '')        
	----	  WHEN 'R' THEN ' From ' + CAST(FromUnit AS VARCHAR)+ ' To ' + IsNull(CAST(ToUnit AS VARCHAR),'') +  ' '+ ISNULL( (SELECT CodeName FROM GlobalCodes WHERE GlobalCodeID = PC.EnteredAs), '')        
	----	 END        
	----	 AS PaymentAdjustment,        
	----	 [ExpectedPaymentId], 
	----	 [CoveragePlanId], 
	----	 EP.[ProcedureCodeId], 
	----	 [FromDate], 
	----	 [ToDate], 
	----	 [ChargeType], 
	----	 [FromUnit], 
	----	 [ToUnit], 
	----	 [Payment], [Adjustment], [ProgramGroupName], [LocationGroupName], [DegreeGroupName], [StaffGroupName], EP.[ClientId], [Priority],      
		 
	----	EP.[RowIdentifier], EP.[CreatedBy], EP.[CreatedDate], EP.[ModifiedBy], EP.[ModifiedDate], EP.[RecordDeleted], EP.[DeletedDate], EP.[DeletedBy]        
	----	 ,Convert(VARCHAR(10),EP.FromDate,101) AS FromDt--PR.FromDate        
	----	 ,Convert(VARCHAR(10),EP.ToDate,101) AS ToDt--PR.ToDate          
	----FROM        
	----	ExpectedPayment EP        
	----LEFT JOIN        
	----	Clients C        
	----ON        
	----	(EP.ClientID = C.ClientID)         
	----LEFT JOIN        
	----	ProcedureCodes PC        
	----ON        
	----	PC.ProcedureCodeID = EP.ProcedureCodeID        
	----WHERE        
	----(        
	----	 (EP.CoveragePlanId = @CoveragePlanID)        
	----	 OR        
	----	  EP.CoveragePlanId IN        
	----	  (        
	----	  SELECT         
	------	   DISTINCT CoveragePlanID        
	----	   FROM        
	----	   ExpectedPayment        
	----	  WHERE        
	----	   ISNULL(RecordDeleted , 'N')= 'N'         
	----	  )        
	---- )        
	---- AND         
	---- ISNULL(EP.RecordDeleted , 'N')= 'N'        
	---- AND         
	---- ISNULL(C.RecordDeleted, 'N') = 'N'        
         
 
	   
	  /*Table #17*/        
	/*Coverage Plan Rule*/        
	SELECT          
	 'N' AS RadioButton,        
	 1 AS DeleteButton,        
	 GC.CodeName AS RuleTypeName,        
	 CPR.[CoveragePlanRuleId], [CoveragePlanId], CPR.[RuleTypeId], [RuleName], 
	 CPR.[RuleViolationAction],  CPR.[CreatedBy], CPR.[CreatedDate], 
	 CPR.[ModifiedBy], CPR.[ModifiedDate], CPR.[RecordDeleted], CPR.[DeletedDate], CPR.[DeletedBy]   
	,Convert(VARCHAR(10),CPR.CreatedDate,101) AS CreatedDt--PR.FromDate        
	FROM        
	  CoveragePlanRules CPR         
	 LEFT JOIN        
	  GlobalCodes GC        
	 ON         
	  CPR.RuleTypeId = GC.GlobalCodeId        
	WHERE          
	 ISNULL(CPR.RecordDeleted, 'N') = 'N'        
	 AND        
	 (CPR.CoveragePlanId = @CoveragePlanID)        
	 ORDER BY CPR.CoveragePlanRuleID      
	 /* Table 18 CoveragePlan Rule Variable*/
	 
	 
	 SELECT             
		 1 DeleteButton,        
		 'N' RadioButton,        
		 ISNULL(PC.DisplayAs, 'N') AS ProcedureCode,  
		 CP.CoveragePlanId,      
		 CP.CoveragePlanName AS CoveragePlanName,        
		 ST.LastName + ', ' + ST.FirstName as StaffName,         
		 CPR.[RuleVariableId], 
		 CPR.[CoveragePlanRuleId], 
		 CPR.[ProcedureCodeId],
		 CPR.[LocationId],    -----Location rule   
		 CPR.[CoveragePlanId],
		 CPR.[StaffId], 
		 CPR.[DiagnosisCode], 
		 CPR.[CreatedBy], 
		 CPR.[CreatedDate], 
		 CPR.[ModifiedBy], 
		 CPR.[ModifiedDate], 
		 CPR.[RecordDeleted], 
		CPR.[DeletedDate],       
		CPR.[DeletedBy], 
		1 as [DSMNumber]    
		,Case when CPR.ProcedureCodeId is null and CPR.StaffId IS not Null Then 'Y' Else 'N' End As SelectAllCodes    
	FROM                 
		CoveragePlanRuleVariables CPR        
     left JOIN        
        CoveragePlans CP        
        ON         
        CPR.CoveragePlanId = CP.CoveragePlanId         
    LEFT JOIN        
        ProcedureCodes PC        
        ON         
        CPR.ProcedureCodeId = PC.ProcedureCodeId        
	LEFT JOIN         
        Staff ST        
        on        
        CPR.StaffId = ST.StaffId 
        	LEFT JOIN         
        Locations L        
        on        
        CPR.LocationId = L.LocationId 
  --  left JOIN 
		--CoveragePlanRules RULES
		--ON RULES.CoveragePlanId = CP.CoveragePlanId
     WHERE
	  ISNULL(CPR.RecordDeleted, 'N') = 'N'        
	 --AND        
	 --(rules.CoveragePlanRuleId = @CoveragePlanRuleId)        
	 ORDER BY CPR.CoveragePlanRuleID     
	 
	
	 
	 /**********************************************************************************************          
      --Table 19 Coverage Plan  Rules- Copy Rules From  the plan which has rules
	  **********************************************************************************************/          
           
		SELECT          
		 distinct CP.CoveragePlanId,          
		 CP.DisplayAs          
		FROM          
		 CoveragePlans  CP JOIN CoveragePlanRules CPR     
		ON          
		      CP.CoveragePlanId = CPR.CoveragePlanId   
		  AND CP.CoveragePlanId <>      @CoveragePlanID  
		  AND CP.Active = 'Y'   
		  AND ISNULL(CP.RecordDeleted, 'N') = 'N'      
		  AND ISNULL(CPR.RecordDeleted, 'N') = 'N'        
		ORDER BY CP.DisplayAs  
		
		
		          
/**********************************************************************************************          
       Table No.:20 Copy Expected Payments from this Table           
**********************************************************************************************/          
		SELECT          
			 DISTINCT 
			 EP.CoveragePlanId,          
			 CP.DisplayAs          
		FROM          
			  CoveragePlans CP JOIN   ExpectedPayment EP
		  ON  CP.CoveragePlanId =  EP.CoveragePlanId   
		  AND CP.CoveragePlanId <> @CoveragePlanID  
		  AND CP.Active = 'Y'   
		  AND ISNULL(CP.RecordDeleted, 'N') = 'N'      
		  AND ISNULL(EP.RecordDeleted, 'N') = 'N'
		         
		ORDER BY CP.DisplayAs     
		
/**********************************************************************************************          
       Table No.:21 Use Billing Rules from Specified Plan          
**********************************************************************************************/          
		select 
			CoveragePlanId,
			CoveragePlanName 
		From	
			CoveragePlans 
		where 
			BillingRulesTemplate = 'T'
		AND
			Active = 'Y'
		AND	
			ISNULL(RecordDeleted,'N')='N'
		 
/**********************************************************************************************          
       Table No.:22 Use Expected Payment from Specified Plan        
**********************************************************************************************/          
		select 
			CoveragePlanId,
			CoveragePlanName 
		From	
			CoveragePlans 
		where 
			ExpectedPaymentTemplate = 'T'
		AND
			Active = 'Y'
		AND	
			ISNULL(RecordDeleted,'N')='N'
			
			 -- Table for Locations
    
    
    SELECT   
  0 AS LocationId,              
  '' AS LocationName              
 union              
 SELECT              
   LocationId AS LocationId,  
   LocationName AS LocationName            
 FROM              
   Locations              
 WHERE              
   Active = 'Y'  
   AND   
   (RecordDeleted='N' or RecordDeleted is null)              
 ORDER BY              
    LocationName   
    
    
     	 
		 --Table All Programs
	
	SELECT 
		DISTINCT  P.ProgramId,              
		P.ProgramName            
	FROM                       
		Programs P	             
	WHERE               
	 P.Active = 'Y'               
	AND               
	(P.RecordDeleted = 'N' OR P.RecordDeleted IS NULL)              
	ORDER BY ProgramName          
	END TRY	 	 
 BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
		+ CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
		 + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_PMCoveragePlanDetailInitData')
		  + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
		  + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY())
		   + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH
END
GO

  

     
     
