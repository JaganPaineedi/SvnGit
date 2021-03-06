/****** Object:  StoredProcedure [dbo].[ProcedureRateSelAll]    Script Date: 11/18/2011 16:25:32 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProcedureRateSelAll]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ProcedureRateSelAll]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[ProcedureRateSelAll]        
 /* Param List */        
@CoveragePlanId int = null
AS   
BEGIN     
SET NOCOUNT ON        
/******************************************************************************        
**  File: dbo.ProcedureRateSelAll.prc        
**  Name: dbo.ProcedureRateSelAll        
**  Desc: This SP returns all the ProcedureRates        
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
**  Auth: Yogesh 
**     ----------       -----------         
**  Date:        Modified:    Description:            
**  --------      --------    ------------------------------------------- 
**  03/01/2017      vsinha	  What:  Length of "Display As" to handle procedure code display as increasing to 75     
							Why :  Keystone Customizations 69  
*******************************************************************************/        
BEGIN TRY
IF @CoveragePlanId is null 

Begin 
( SELECT         
  PR.ProcedureRateId        
  ,PC.ProcedureCodeid        
  ,CAST(PC.DisplayAs AS VARCHAR(75)) AS ProcedureCode      --03/01/2017      vsinha  
  ,CAST('$' +         
   Convert(VARCHAR,PR.Amount,1) + ' '         
   + CASE PR.Chargetype         
     WHEN 'P' THEN 'Per ' + (Case when AllowDecimals='Y' then Convert(VARCHAR,FromUnit,1) else CAST(CAST(ROUND(FromUnit,0)AS INT)AS VARCHAR)  end)  --Per        
     WHEN 'R' THEN (Case when AllowDecimals='Y' then Convert(VARCHAR,FromUnit,1) else CAST(CAST(ROUND(FromUnit,0)AS INT)AS VARCHAR)  end) + ' to ' + (Case when AllowDecimals='Y' then Convert(VARCHAR,ToUnit,1) else CAST(CAST(ROUND(ToUnit,0)AS INT)AS VARCHAR)  end) --Range        
     WHEN 'E' THEN 'for ' + (Case when AllowDecimals='Y' then Convert(VARCHAR,FromUnit,1) else CAST(CAST(ROUND(FromUnit,0)AS INT)AS VARCHAR)  end) --Exact        
   END  + ' ' + GC.CodeName AS VARCHAR(30)) AS Amount--Unit        
  ,CASE              
   WHEN  EXISTS (SELECT * FROM ProcedureRateBillingCodes BC WHERE BC.ProcedureRateId=PR.ProcedureRateId AND isnull(BC.RecordDeleted, 'N') = 'N') THEN 'Varies'        
   ELSE CAST(PR.BillingCode + ' ' + isnull(PR.Modifier1, '') +  ' ' + isnull(PR.Modifier2, '') +  ' ' + isnull(PR.Modifier3, '') +  ' ' + isnull(PR.Modifier4, '') AS VARCHAR(10))        
   END AS BillingCode           
  ,CAST(PR.ProgramGroupName AS VARCHAR(25)) AS ProgramGroupName        
  ,CAST(PR.LocationGroupName AS VARCHAR(25)) AS LocationGroupName        
  ,CAST(PR.DegreeGroupName AS VARCHAR(10)) AS DegreeGroupName        
  ,CAST(PR.StaffGroupName AS VARCHAR(30)) AS StaffGroupName        
  ,CAST(CL.LastName + ', ' + CL.FirstName AS VARCHAR(30))AS ClientName        
  ,CAST(PR.RevenueCode AS VARCHAR(10)) AS RevenueCode        
  ,PR.FromDate        
  ,PR.ToDate        
  ,PR.ClientId        
  --,Convert(VARCHAR(10),PR.FromDate,101) AS FromDt--PR.FromDate        
  --,Convert(VARCHAR(10),PR.ToDate,101) AS ToDt--PR.ToDate          
  ,PC.NotBillable      
  ,PC.Active         
 FROM         
  ProcedureRates PR         
 JOIN         
  ProcedureCodes PC         
 ON         
  PR.ProcedureCodeId = PC.ProcedureCodeId         
 LEFT JOIN Clients CL         
  ON  PR.ClientID = CL.ClientID         
 LEFT JOIN GlobalCodes GC        
  ON GC.GlobalCodeId=PC.EnteredAs        
 WHERE        
 (PR.RecordDeleted = 'N' OR PR.RecordDeleted IS NULL)        
 AND        
  ISNULL(PC.RecordDeleted,'N') = 'N'        
 AND        
  PR.CoveragePlanID IS NULL        
)        
UNION        
( --Only Codes that do not have Rates        
 SELECT         
  '0'AS ProcedureRateId--PR.ProcedureRateId        
  ,ProcedureCodeid        
  ,CAST(DisplayAs AS VARCHAR(75)) AS ProcedureCode   --03/01/2017      vsinha       
  ,'' AS Amount--Unit        
  ,NULL AS BillingCode--PR.BillingCode        
  ,NULL AS ProgramGroupName--PR.ProgramGroupName        
  ,NULL AS LocationGroupName--PR.LocationGroupName        
  ,NULL AS DegreeGroupName--PR.DegreeGroupName        
  ,NULL AS StaffGroupName--PR.StaffGroupName        
  ,NULL AS ClientName--CL.LastName + ', ' + CL.FirstName AS ClientName        
  ,NULL AS RevenueCode--PR.RevenueCode        
  ,NULL AS FromDate--PR.FromDate        
  ,NULL AS ToDate--PR.ToDate        
  ,NULL AS ClientId--PR.ClientId        
  --,NULL AS FromDt--Convert(VARCHAR(10),PR.FromDate,101) AS FromDt        
  --,NULL AS ToDt--Convert(VARCHAR(10),PR.ToDate,101) AS ToDt          
  ,NotBillable      
  ,Active         
 FROM          
  ProcedureCodes PC         
 WHERE        
  (RecordDeleted = 'N' OR RecordDeleted IS NULL)        
 AND         
  ISNULL(PC.RecordDeleted,'N') = 'N'        
 AND        
  ProcedureCodeid        
 NOT IN        
  (        
  SELECT         
   PC.ProcedureCodeid         
  FROM         
   ProcedureRates PR         
  JOIN         
   ProcedureCodes PC         
  ON         
   PR.ProcedureCodeId = PC.ProcedureCodeId         
  WHERE        
   ISNULL(PC.RecordDeleted,'N') = 'N'        
   AND        
   ISNULL(PR.RecordDeleted,'N') = 'N'           
   AND        
   PR.CoveragePlanID IS NULL        
  )         
)        
       
End
Else
--
--  Find only billable procedure codes for the cooresponding coverage plan
--
Begin
 SELECT         
  PR.ProcedureRateId        
  ,PC.ProcedureCodeid        
  ,CAST(PC.DisplayAs AS VARCHAR(75)) AS ProcedureCode      --03/01/2017      vsinha  
  ,CAST('$' +         
   Convert(VARCHAR,PR.Amount,1) + ' '         
   + CASE PR.Chargetype         
     WHEN 'P' THEN 'Per ' + (Case when AllowDecimals='Y' then Convert(VARCHAR,FromUnit,1) else CAST(CAST(ROUND(FromUnit,0)AS INT)AS VARCHAR)  end)  --Per        
     WHEN 'R' THEN (Case when AllowDecimals='Y' then Convert(VARCHAR,FromUnit,1) else CAST(CAST(ROUND(FromUnit,0)AS INT)AS VARCHAR)  end) + ' to ' + (Case when AllowDecimals='Y' then Convert(VARCHAR,ToUnit,1) else CAST(CAST(ROUND(ToUnit,0)AS INT)AS VARCHAR)  end) --Range        
     WHEN 'E' THEN 'for ' + (Case when AllowDecimals='Y' then Convert(VARCHAR,FromUnit,1) else CAST(CAST(ROUND(FromUnit,0)AS INT)AS VARCHAR)  end) --Exact        
   END  + ' ' + GC.CodeName AS VARCHAR(30)) AS Amount--Unit        
  ,CASE              
   WHEN  EXISTS (SELECT * FROM ProcedureRateBillingCodes BC WHERE BC.ProcedureRateId=PR.ProcedureRateId AND isnull(BC.RecordDeleted, 'N') = 'N') THEN 'Varies'        
   ELSE CAST(PR.BillingCode + ' ' + isnull(PR.Modifier1, '') +  ' ' + isnull(PR.Modifier2, '') +  ' ' + isnull(PR.Modifier3, '') +  ' ' + isnull(PR.Modifier4, '') AS VARCHAR(10))        
   END AS BillingCode           
  ,CAST(PR.ProgramGroupName AS VARCHAR(25)) AS ProgramGroupName        
  ,CAST(PR.LocationGroupName AS VARCHAR(25)) AS LocationGroupName        
  ,CAST(PR.DegreeGroupName AS VARCHAR(10)) AS DegreeGroupName        
  ,CAST(PR.StaffGroupName AS VARCHAR(30)) AS StaffGroupName        
  ,CAST(CL.LastName + ', ' + CL.FirstName AS VARCHAR(30))AS ClientName        
  ,CAST(PR.RevenueCode AS VARCHAR(10)) AS RevenueCode        
  ,PR.FromDate        
  ,PR.ToDate        
  ,PR.ClientId        
  ,PC.NotBillable      
  ,PC.Active         
 FROM ProcedureCodes pc
left Join ProcedureRates pr on pr.ProcedureCodeId = pc.ProcedureCodeId and isnull(pr.RecordDeleted, 'N')= 'N' 
 LEFT JOIN Clients CL ON  PR.ClientID = CL.ClientID         
 LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId=PC.EnteredAs        
    
Where not exists (Select * from CoveragePlanRules cpr
				Join CoveragePlanRuleVariables cprv on cpr.CoveragePlanRuleId = cprv.CoveragePlanRuleId
				Where cpr.RuleTypeId = 4267 --Not billable to this plan
				and cpr.CoveragePlanId = @CoveragePlanId
				and cprv.ProcedureCodeId = pc.ProcedureCodeId
				and isnull(cpr.RecordDeleted, 'N')= 'N'
				and isnull(cprv.RecordDeleted, 'N')= 'N'
				)
and isnull(pr.CoveragePlanId, 0) in  (select case when isnull(cp2.BillingCodeTemplate, 'S')= 'S' then 0
									         when isnull(cp2.BillingCodeTemplate, 'S')= 'T' then cp2.CoveragePlanid
									         when isnull(cp2.BillingCodeTemplate, 'S')= 'O' then cp2.UseBillingCodesFrom
									         end 
									  from CoveragePlans cp2 
									  where cp2.CoveragePlanId = @CoveragePlanId
									  and isnull(cp2.RecordDeleted, 'N')= 'N'
									)
and isnull(pc.RecordDeleted, 'N') = 'N'


End


  
--Active ProcedureCodes        
SELECT         
 ProcedureCodeId        
FROM        
 ProcedureCodes        
WHERE Active='Y'         
        
--Plan        
SELECT        
  CoveragePlanId        
 ,StandardRateID AS ProcedureRateId        
FROM        
 ProcedureRates        
WHERE        
 (RecordDeleted='N' OR RecordDeleted IS NULL)        
AND         
 BillingCodeModified = 'N'         
ORDER BY        
 CoveragePlanId        
         
--Degree        
SELECT         
  Degree        
 ,ProcedureRateId        
FROM        
 ProcedureRateDegrees         
WHERE        
 --RecordDeleted <> 'Y'         
isnull(RecordDeleted,'N') ='N' 
ORDER BY        
 Degree        
         
--ProcedureRatePrograms        
SELECT DISTINCT        
  ProgramId        
 ,ProcedureRateId        
FROM        
 ProcedureRatePrograms        
WHERE        
-- RecordDeleted <> 'Y'
isnull(RecordDeleted,'N') ='N' 
ORDER BY        
 ProgramId        
        
--ProcedureRateStaff        
SELECT        
  StaffId        
 ,ProcedureRateId        
FROM        
 ProcedureRateStaff        
WHERE        
-- RecordDeleted <> 'Y'  
isnull(RecordDeleted,'N') ='N' 
ORDER BY StaffId        
        
/*Location*/        
SELECT             
 LocationId,         
 ProcedureRateId        
FROM        
 ProcedureRateLocations        
WHERE        
 ISNULL(RecordDeleted, 'N') = 'N'        
         


	--Following queries added by Jatinder on 28th-Feb-08 because 2 seperate SPs were being executed
	--One for showing the actual data (this SP) 
	--and other for fetching the data to fill the dropdown(ProceduresGlobalCodesSel)

	--Degree              
	SELECT 0 AS GlobalCodeId,'' AS CodeName, -1 as SortOrder              
	UNION              
	SELECT DISTINCT              
	GC.GlobalCodeId,              
	GC.CodeName, case when GC.SortOrder is null then 9999 else GC.SortOrder end                
	FROM                       
	GlobalCodes GC              
	INNER JOIN              
	ProcedureRateDegrees PRD              
	ON GC.GlobalCodeId=PRD.Degree                
	WHERE               
	GC.Category = 'DEGREE'               
	AND               
	(GC.RecordDeleted = 'N' OR GC.RecordDeleted IS NULL)              
	AND ISNULL(PRD.RecordDeleted, 'N') = 'N'              
	ORDER BY SortOrder, CodeName              
	 
             
	--Programs              
	SELECT 0 AS ProgramId,'' AS ProgramCode              
		UNION              
	SELECT DISTINCT P.ProgramId,P.ProgramCode               
	FROM Programs P              
	INNER JOIN              
	ProcedureRatePrograms PRP              
	ON P.ProgramId=PRP.ProgramId               
	WHERE              
	(P.RecordDeleted = 'N' OR P.RecordDeleted IS NULL)              
	AND               
	ISNULL(PRP.RecordDeleted, 'N') = 'N'              
	ORDER BY ProgramCode                 
              
	--Staff              
	SELECT 0 AS StaffId,'' AS StaffName              
	UNION              
	SELECT S.StaffId,              
	CASE               
	WHEN S.DEGREE IS NULL THEN S.LastName + ', ' + S.FirstName              
	ELSE S.LastName + ', ' + S.FirstName + ' ' + GC.CodeName              
	END AS StaffName              
	FROM Staff S              
	Left JOIN              
	GlobalCodes GC              
	ON               
	GC.GlobalCodeId=S.Degree              
	WHERE S.Active='Y'              
	AND              
	(S.RecordDeleted='N' OR S.RecordDeleted IS NULL)              
	ORDER BY StaffName              

	--Clients              
	SELECT 0 AS ClientId,'' AS ClientName              
	UNION              
	SELECT DISTINCT              
	C.ClientId,C.LastName + ', ' + C.FirstName AS ClientName              
	FROM              
	Clients C              
	INNER JOIN              
	ProcedureRates PR              
	ON              
	C.ClientId = PR.ClientId              
	WHERE               
	(C.RecordDeleted = 'N' OR C.RecordDeleted IS NULL)               
	AND               
	ISNULL(C.Active, 'Y') = 'Y'              
	AND               
	ISNULL(PR.RecordDeleted, 'N') = 'N'              
	ORDER BY ClientName               
              
	/*Location*/              
	SELECT 0 AS LocationId,'' AS LocationName              
	UNION              
	SELECT                   
	DISTINCT L.LocationId, L.LocationCode AS LocationName              
	FROM                  
	ProcedureRateLocations PRL              
	INNER JOIN              
	Locations L              
	ON PRL.LocationId = L.LocationId              
	WHERE (L.Active = 'Y')              
	AND ISNULL(PRL.RecordDeleted, 'N') = 'N'              
	ORDER BY LocationName
	
END TRY
BEGIN CATCH
   DECLARE @Error varchar(8000)                                            
         SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                             
         + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ProcedureRateSelAll')                                        
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