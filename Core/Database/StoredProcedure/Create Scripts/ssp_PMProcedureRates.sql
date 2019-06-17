/****** Object:  StoredProcedure [ssp_PMProcedureRates]    Script Date: 03/28/2012 13:06:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ssp_PMProcedureRates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ssp_PMProcedureRates]
GO

/****** Object:  StoredProcedure [ssp_PMProcedureRates]    Script Date: 03/28/2012 13:06:34 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



 CREATE PROCEDURE [dbo].[ssp_PMProcedureRates] 
/********************************************************************************                                                        
-- Stored Procedure: ssp_PMProcedureRates      
--      
-- Copyright: Streamline Healthcate Solutions      
--      
-- Purpose: Query to return data for the procedure rates list page.      
--      
-- Author:  Girish Sanaba      
-- Date:    18 Apr 2011      
--       
-- *****History****      
-- Author:    Date      Reason      
-- MSuma    17 Aug 2011     Service ARea Changes included, Fixed Isues on Datatype LEngth      
-- MSuma    03 Oct 2011     Datamodel Changes for ChargeType          
-- avoss       10.13.2011     corrected record deleted checks to be on the joins to display rates correctly      
-- ter    01.04.2012     moved from left joins to exists to restrict records returned       
-- PSelvan          8 Mar 2012            Performance Tuning.        
-- Ponnin Selvan 4.04.2012     Conditions added for Export       
-- PSelvan   13.04.2012     Added Conditions for NumberOfPages.      
-- Atul Pandey  25 Apr 2012     Partial Search By ProcedureCode name     
-- MSuma   06 SEP 2012  Custom Charge Changes from Javed    
-- John Sudhakar 03/27/2014  DataType changed from Varchar(25) to Varchar(250); Reviewer: Kiran K    
--Kirtee   14 July 2014    ProcedureName filter condition was not implemented in the second table used  after Union   also wrf Core Bugs   
-- MD Hussain  11/29/2016  Added condition to check for new entry 'Exclude None' in Exclude Procedure dropdown (@ExcludeProcedureCode= -2)w.r.t Woods - Support Go Live - #400   
*********************************************************************************/      
      
 @SessionId    VARCHAR(30),      
 @InstanceId    INT,      
 @PageNumber    INT,      
 @PageSize    INT,      
 @SortExpression   VARCHAR(100),      
 @ActiveProcedure  INT,      
 @ActivePlan    INT,      
 @Degrees    INT,      
 @Programs    INT,      
 @Staff     INT,      
 @Client     INT,      
 @CodeRates    INT,      
 @Locations    INT,      
 @EffectiveOn   VARCHAR(100),      
 @OtherFilter   int,      
 @StaffId    INT,      
 @ServiceArea   INT,      
 @PlaceOfService   INT,      
 @ProcedureName          varchar(100),--Added by atul Pandey      
 @ExcludeProcedureCode INT    =-1  
       
AS      
BEGIN                                                                    
 declare      
 @xSessionId    VARCHAR(30),      
 @xInstanceId   INT,      
 @xPageNumber   INT,      
 @xPageSize    INT,      
 @xSortExpression  VARCHAR(100),      
 @xActiveProcedure  INT,      
 @xActivePlan   INT,      
 @xDegrees    INT,      
 @xPrograms    INT,      
 @xStaff     INT,      
 @xClient    INT,      
 @xCodeRates    INT,      
 @xLocations    INT,      
 @xEffectiveOn   VARCHAR(100),      
 @xOtherFilter   INT,      
 @xStaffId    INT,      
 @xServiceArea   INT,      
 @xPlaceOfService  INT,      
 @xProcedureName   VARCHAR(100)--Added by atul Pandey      
      
 select      
  @xSessionId = @SessionId,      
  @xInstanceId = @InstanceId,      
  @xPageNumber = @PageNumber,      
  @xPageSize = @PageSize,      
  @xSortExpression = @SortExpression,      
  @xActiveProcedure = @ActiveProcedure,      
  @xActivePlan = @ActivePlan,      
  @xDegrees = @Degrees,      
  @xPrograms = @Programs,      
  @xStaff = @Staff,      
  @xClient = @Client,      
  @xCodeRates = @CodeRates,      
  @xLocations = @Locations,      
  @xEffectiveOn = @EffectiveOn,      
  @xOtherFilter = @OtherFilter,      
  @xStaffId = @StaffId,      
  @xServiceArea = @ServiceArea,      
  @xPlaceOfService = @PlaceOfService,      
  @xProcedureName= @ProcedureName--Added by atul Pandey      
      
 BEGIN TRY      
       
 CREATE TABLE #ResultSet      
 (      
 RowNumber    INT,    
 PageNumber    INT,      
 ProcedureRateId   INT,      
 ProcedureCodeId   INT,      
 ProcedureCode   VARCHAR(250),      
 Amount     VARCHAR(30),      
 BillingCode    VARCHAR(10),      
 ProgramGroupName  VARCHAR(250),      
 LocationGroupName  VARCHAR(250),      
 DegreeGroupName   VARCHAR(250),      
 StaffGroupName   VARCHAR(250),      
 ServiceAreaGroupName VARCHAR(250),      
 PlaceOfServiceGroupName VARCHAR(250),      
 ClientName    VARCHAR(110),      
 RevenueCode    VARCHAR(100),      
 FromDate    DATETIME,      
 ToDate     DATETIME,      
 ClientId    INT,      
 NotBillable    VARCHAR(5),      
 Active     VARCHAR(5),      
 )      
       
 DECLARE @CustomFilters   TABLE (ProcedureRateId INT)                                                        
 DECLARE @ApplyFilterClicked  CHAR(1)      
 DECLARE @CustomFiltersApplied CHAR(1)      
 DECLARE @EffectiveDate   DATETIME      
 DECLARE @CoveragePlanId   INT      
       
 IF @xActivePlan = -1      
  SET @CoveragePlanId = NULL      
 ELSE      
  SET @CoveragePlanId = @xActivePlan      
        
 IF @xEffectiveOn = ''      
  SET @EffectiveDate = NULL       
 ELSE      
  SET @EffectiveDate = CONVERT(DATETIME,@xEffectiveOn,101)      
        
 SET @xSortExpression = RTRIM(LTRIM(@xSortExpression))      
 IF ISNULL(@xSortExpression, '') = ''      
  SET @xSortExpression= 'ProcedureCode'      
      
 --       
 -- New retrieve - the request came by clicking on the Apply Filter button                         
 --      
 SET @ApplyFilterClicked = 'Y'       
 SET @CustomFiltersApplied = 'N'                                                       
 SET @xPageNumber = 1      
       
 IF @xOtherFilter > 10000                                          
 BEGIN      
  SET @CustomFiltersApplied = 'Y'      
        
  INSERT INTO @CustomFilters (ProcedureRateId)       
  EXEC scsp_PMProcedureRates       
   @ActiveProcedure  =@xActiveProcedure,      
   @ActivePlan    =@xActivePlan,      
   @Degrees    =@xDegrees,      
   @Programs    =@xPrograms,      
   @Staff     =@xStaff,      
   @ServiceArea   =@xServiceArea,      
   @PlaceOfService   =@xPlaceOfService,      
   @Client     =@xClient,      
   @CodeRates    =@xCodeRates,      
   @Locations    =@xLocations,      
   @EffectiveOn   =@xEffectiveOn,      
   @OtherFilter   =@xOtherFilter,      
   @StaffId    =@xStaffId      
 END      
       
 --      
 --       
 IF @CoveragePlanId IS NULL       
      
 BEGIN       
      
        
  INSERT INTO #ResultSet      
  (       
   ProcedureRateId      
  ,ProcedureCodeId      
  ,ProcedureCode      
  ,Amount      
  ,BillingCode      
  ,ProgramGroupName      
  ,LocationGroupName      
  ,DegreeGroupName      
  ,StaffGroupName      
  ,ServiceAreaGroupName      
  ,PlaceOfServiceGroupName      
  ,ClientName      
  ,RevenueCode      
  ,FromDate      
  ,ToDate      
  ,ClientId      
  ,NotBillable      
  ,Active      
  )     
    
  SELECT      
  PR.ProcedureRateId             
  ,PC.ProcedureCodeid             
  ,CAST(PC.DisplayAs AS VARCHAR(250)) AS ProcedureCode             
  ,CAST('$' +              
  CONVERT(VARCHAR,PR.Amount,1) + ' '              
  + CASE PR.Chargetype            
  --DataType changes for ChargeType        
  WHEN '6761'-- 'P'       
  THEN 'Per ' + (CASE WHEN AllowDecimals='Y' THEN CONVERT(VARCHAR,FromUnit,1) ELSE CAST(CAST(ROUND(FromUnit,0)AS INT)AS VARCHAR)  END)  --Per             
  WHEN '6763'--'R'       
  THEN (CASE WHEN AllowDecimals='Y' THEN CONVERT(VARCHAR,FromUnit,1) ELSE CAST(CAST(ROUND(FromUnit,0)AS INT)AS VARCHAR)  END) + ' to ' + (CASE WHEN AllowDecimals='Y' THEN CONVERT(VARCHAR,ToUnit,1) ELSE CAST(CAST(ROUND(ToUnit,0)AS INT)AS VARCHAR)  END) --Range             
  WHEN '6762'--'E'       
  THEN 'for ' + (CASE WHEN AllowDecimals='Y' THEN CONVERT(VARCHAR,FromUnit,1) ELSE CAST(CAST(ROUND(FromUnit,0)AS INT)AS VARCHAR)  END) --Exact             
  ELSE CT.CodeName    
  END  + ' ' + GC1.CodeName AS VARCHAR(30)) AS Amount--Unit             
  ,CASE                   
  WHEN  EXISTS (SELECT * FROM ProcedureRateBillingCodes BC WHERE BC.ProcedureRateId=PR.ProcedureRateId AND ISNULL(BC.RecordDeleted, 'N') = 'N') THEN 'Varies'             
  ELSE CAST(PR.BillingCode + ' ' + ISNULL(PR.Modifier1, '') +  ' ' + ISNULL(PR.Modifier2, '') +  ' ' + ISNULL(PR.Modifier3, '') +  ' ' + ISNULL(PR.Modifier4, '') AS VARCHAR(10))             
  END AS BillingCode                
  ,CAST(PR.ProgramGroupName AS VARCHAR(25)) AS ProgramGroupName             
  ,CAST(PR.LocationGroupName AS VARCHAR(25)) AS LocationGroupName             
  ,CAST(PR.DegreeGroupName AS VARCHAR(10)) AS DegreeGroupName             
  ,CAST(PR.StaffGroupName AS VARCHAR(30)) AS StaffGroupName         
  ,CAST(PR.ServiceAreaGroupName AS VARCHAR(30)) AS ServiceAreaGroupName       
  ,CAST(PR.PlaceOfServiceGroupName AS VARCHAR(30)) AS PlaceOfServiceGroupName       
  ,CAST(CL.LastName + ', ' + CL.FirstName AS VARCHAR(30))AS ClientName             
  ,CAST(PR.RevenueCode AS VARCHAR(10)) AS RevenueCode             
  ,PR.FromDate             
  ,PR.ToDate             
  ,PR.ClientId             
  ,PC.NotBillable           
  ,PC.Active              
  FROM              
  ProcedureCodes PC                         
  JOIN ProcedureRates PR ON  PR.ProcedureCodeId = PC.ProcedureCodeId  AND ISNULL(PR.RecordDeleted,'N') = 'N'             
  LEFT JOIN Clients CL ON  PR.ClientID = CL.ClientID              
  LEFT JOIN GlobalCodes GC1 ON PC.EnteredAs = GC1.GlobalCodeId     
  LEFT JOIN GlobalCodes CT  ON (CT.GlobalCodeId = PR.ChargeType)           
  WHERE ((@CustomFiltersApplied = 'Y' AND EXISTS(SELECT * FROM @CustomFilters cf WHERE cf.ProcedureRateId = PR.ProcedureRateId)) OR      
  (@CustomFiltersApplied = 'N'      
  AND ISNULL(PC.RecordDeleted,'N') = 'N'      
  AND PR.CoveragePlanID IS NULL        
  AND (@xActiveProcedure = -1 OR         -- All Category states        
   (@xActiveProcedure = 1 AND ISNULL(PC.Active,'N') = 'Y') OR    -- Active                     
   (@xActiveProcedure = 2 AND ISNULL(PC.Active,'N') = 'N'))  -- InActive           
      
  AND (@xDegrees = -1 OR      
   (exists (select * from dbo.ProcedureRateDegrees as prd where prd.ProcedureRateId = pr.ProcedureRateId and @xDegrees = PRD.Degree and ISNULL(prd.RecordDeleted, 'N') <> 'Y')))      
             
  AND (@xPrograms = -1 or      
   (exists (select * from dbo.ProcedureRatePrograms as prp where prp.ProcedureRateId = pr.ProcedureRateId and @xPrograms = PRP.ProgramId and ISNULL(prp.RecordDeleted, 'N') <> 'Y')))      
              
  AND (@xStaff = -1 OR      
   (exists (select * from dbo.ProcedureRateStaff as prs where prs.ProcedureRateId = pr.ProcedureRateId and @xStaff = PRS.StaffId and ISNULL(prs.RecordDeleted, 'N') <> 'Y')))      
             
  AND (@xClient = -1 OR      
   (@xClient = CL.ClientId))       
      
  AND (@xLocations = -1 OR      
   (exists (select * from dbo.ProcedureRateLocations as prl where prl.ProcedureRateId = pr.ProcedureRateId and @xLocations = PRL.LocationId and ISNULL(prl.RecordDeleted, 'N') <> 'Y')))       
      
  AND (@xServiceArea = -1 OR      
   (exists (select * from dbo.ProcedureRateServiceAreas as prsa where prsa.ProcedureRateId = pr.ProcedureRateId and @xServiceArea = PRSA.ServiceAreaId and ISNULL(prsa.RecordDeleted, 'N') <> 'Y')))      
      
  AND (@xPlaceOfService = -1 OR      
   (exists (select * from dbo.ProcedureRatePlacesOfServices as prps where prps.ProcedureRateId = pr.ProcedureRateId and @xPlaceOfService = prps.PlaceOfServieId and ISNULL(prps.RecordDeleted, 'N') <> 'Y')))      
              
        AND (@xProcedureName='' OR (PC.DisplayAs like '%'+@xProcedureName+'%' or PR.BillingCode like '%'+@xProcedureName+'%'))--Added by Atul Pandey on 25 Apr 2012         
       
  AND ((@xCodeRates = -1)    
   OR (@xCodeRates = 1 AND PR.ProgramGroupName IS NOT NULL)      
   OR (@xCodeRates = 2 AND PR.LocationGroupName IS NOT NULL)      
   OR (@xCodeRates = 3 AND PR.DegreeGroupName IS NOT NULL)      
   OR (@xCodeRates = 4 AND PR.StaffGroupName IS NOT NULL)      
   OR (@xCodeRates = 5 AND CAST(CL.LastName + ', ' + CL.FirstName AS VARCHAR(30)) IS NOT NULL)      
   OR (@xCodeRates = 6       
      AND PR.ProgramGroupName IS NULL      
      AND PR.LocationGroupName IS NULL       
      AND PR.DegreeGroupName IS NULL        
      AND PR.StaffGroupName IS NULL        
      AND PR.ServiceAreaGroupName IS NULL      
      AND PR.PlaceOfServiceGroupName IS NULL      
      AND CAST(CL.LastName + ', ' + CL.FirstName AS VARCHAR(30)) IS NULL ))      
  AND (@xCodeRates <> 7)   
  AND ((@ExcludeProcedureCode= 1 and exists(Select 1 from ProcedureCodes PC1 where PC1.ProcedureCodeId=  
                PC.ProcedureCodeId and ISNULL(PC1.BedProcedureCode,'N')='N'   
                and ISNULL(PC1.RecordDeleted,'N')='N' ))  
         or (@ExcludeProcedureCode= 2 and exists(Select 1 from ProcedureCodes PC1 where PC1.ProcedureCodeId=  
                PC.ProcedureCodeId and ISNULL(PC1.MedicationProcedureCode,'N')='N'   
                and ISNULL(PC1.RecordDeleted,'N')='N' ))  
         or (@ExcludeProcedureCode= -1 and exists(Select 1 from ProcedureCodes PC1 where PC1.ProcedureCodeId=  
                PC.ProcedureCodeId and ISNULL(PC1.BedProcedureCode,'N')='N' and ISNULL(PC1.MedicationProcedureCode,'N')='N'  
                and ISNULL(PC1.RecordDeleted,'N')='N' )) 
         or @ExcludeProcedureCode= 3)
      
  ))      
        
  UNION     
      
   SELECT            
  '0'AS ProcedureRateId--PR.ProcedureRateId             
  ,ProcedureCodeid             
  ,CAST(DisplayAs AS VARCHAR(250)) AS ProcedureCode             
  ,'' AS Amount--Unit             
  ,NULL AS BillingCode--PR.BillingCode             
  ,NULL AS ProgramGroupName--PR.ProgramGroupName             
  ,NULL AS LocationGroupName--PR.LocationGroupName             
  ,NULL AS DegreeGroupName--PR.DegreeGroupName             
  ,NULL AS StaffGroupName--PR.StaffGroupName        
  ,NULL AS ServiceAreaGroupName      
  ,NULL AS PlaceOfServiceGroupName           
  ,NULL AS ClientName--CL.LastName + ', ' + CL.FirstName AS ClientName             
  ,NULL AS RevenueCode--PR.RevenueCode             
  ,NULL AS FromDate--PR.FromDate             
  ,NULL AS ToDate--PR.ToDate             
  ,NULL AS ClientId--PR.ClientId             
  ,NotBillable           
  ,Active              
  FROM               
  ProcedureCodes PC              
  WHERE             
  ISNULL(PC.RecordDeleted,'N') = 'N'       
  AND (@xActiveProcedure = -1 OR         -- All Category states        
   (@xActiveProcedure = 1 AND ISNULL(PC.Active,'N') = 'Y') OR    -- Active                     
   (@xActiveProcedure = 2 AND ISNULL(PC.Active,'N') = 'N')  -- InActive       
   )            
  AND ( @xCodeRates = -1 OR @xCodeRates = 6 OR @xCodeRates = 7 )        
  AND (@xDegrees = -1)      
  AND (@xPrograms = -1)      
  AND (@xStaff = -1)      
  AND (@xClient = -1)      
  AND (@xLocations = -1)       
  AND (@xServiceArea = -1)      
  AND (@xPlaceOfService = -1)     
  -- Kirtee 14 July 2014   ProcedureName filter condition added    
  AND (@xProcedureName='' OR PC.DisplayAs like '%'+@xProcedureName+'%')     
  AND (NOT EXISTS ( SELECT * FROM ProcedureRates PR      
       WHERE  PR.ProcedureCodeId = PC.ProcedureCodeId      
       AND ISNULL(PR.RecordDeleted,'N') = 'N'      
       AND PR.CoveragePlanId IS NULL)      
   )     
    AND ((@ExcludeProcedureCode= 1 and exists(Select 1 from ProcedureCodes PC1 where PC1.ProcedureCodeId=  
                PC.ProcedureCodeId and ISNULL(PC1.BedProcedureCode,'N')='N'   
                and ISNULL(PC1.RecordDeleted,'N')='N' ))  
         or (@ExcludeProcedureCode= 2 and exists(Select 1 from ProcedureCodes PC1 where PC1.ProcedureCodeId=  
                PC.ProcedureCodeId and ISNULL(PC1.MedicationProcedureCode,'N')='N'   
                and ISNULL(PC1.RecordDeleted,'N')='N' ))  
         or (@ExcludeProcedureCode= -1 and exists(Select 1 from ProcedureCodes PC1 where PC1.ProcedureCodeId=  
                PC.ProcedureCodeId and ISNULL(PC1.BedProcedureCode,'N')='N' and ISNULL(PC1.MedicationProcedureCode,'N')='N'  
                and ISNULL(PC1.RecordDeleted,'N')='N' ))
         or @ExcludeProcedureCode= 3)  
         
         
  DELETE #ResultSet      
  WHERE (ProcedureRateId = 0      
  AND @xCodeRates IN (-1,6)        
  AND @EffectiveDate IS NOT NULL      
  AND ISNULL(NotBillable,'N') = 'N')        
  OR (@EffectiveDate < ISNULL(FromDate,CONVERT(DATETIME,'01/01/1900',101)) OR @EffectiveDate > ISNULL(ToDate, CONVERT(DATETIME,'12/31/2299',101)))      
         
        
  END       
       
 ELSE      
       
 --      
 --  Find only billable procedure codes for the corresponding coverage plan      
 --      
 BEGIN      

	SELECT 
	cpr.CoveragePlanId, 
	ProcedureCodeId
	INTO #NotBillableCoveragePlanProcedureCode
	FROM   coverageplanrules cpr 
		   LEFT JOIN coverageplanrulevariables cprv 
				  ON cpr.coverageplanruleid = cprv.coverageplanruleid 
	WHERE  cpr.ruletypeid = 4267 --Not billable to this plan       
		   AND ( Isnull(cpr.appliestoallprocedurecodes, 'Y') = 'Y' 
				  OR Isnull(cprv.appliestoallprocedurecodes, 'Y') = 'Y' ) 
		   AND cpr.coverageplanid = @CoveragePlanId 
		   AND Isnull(cpr.recorddeleted, 'N') = 'N' 
		   AND Isnull(cprv.recorddeleted, 'N') = 'N' 

	SELECT CASE 
			 WHEN Isnull(cp2.billingcodetemplate, 'S') = 'S' THEN 0 
			 WHEN Isnull(cp2.billingcodetemplate, 'S') = 'T' THEN cp2.coverageplanid 
			 WHEN Isnull(cp2.billingcodetemplate, 'S') = 'O' THEN 
			 cp2.usebillingcodesfrom 
		   END as CoveragePlanId
	INTO #BillingCoveragePlan
	FROM   coverageplans cp2 
	WHERE  cp2.coverageplanid = @CoveragePlanId 
		   AND Isnull(cp2.recorddeleted, 'N') = 'N'       

  INSERT INTO #ResultSet      
  (       
   ProcedureRateId      
  ,ProcedureCodeId      
  ,ProcedureCode      
  ,Amount      
  ,BillingCode      
  ,ProgramGroupName      
  ,LocationGroupName      
  ,DegreeGroupName      
  ,StaffGroupName      
  ,ServiceAreaGroupName      
  ,PlaceOfServiceGroupName      
  ,ClientName      
  ,RevenueCode      
  ,FromDate      
  ,ToDate      
  ,ClientId      
  ,NotBillable      
  ,Active      
  )      
  ( SELECT    DISTINCT          
    ISNULL(PR.ProcedureRateId,0) AS ProcedureRateId      
    ,PC.ProcedureCodeid              
    ,CAST(PC.DisplayAs AS VARCHAR(25)) AS ProcedureCode              
    ,CAST('$' +               
     CONVERT(VARCHAR,PR.Amount,1) + ' '             
     --DataType changes for ChargeType        
     + CASE PR.Chargetype               
    WHEN '6761'--'P'      
     THEN 'Per ' + (CASE WHEN AllowDecimals='Y' THEN CONVERT(VARCHAR,FromUnit,1) ELSE CAST(CAST(ROUND(FromUnit,0)AS INT)AS VARCHAR)  END)  --Per              
    WHEN '6763'--'R'       
    THEN (CASE WHEN AllowDecimals='Y' THEN CONVERT(VARCHAR,FromUnit,1) ELSE CAST(CAST(ROUND(FromUnit,0)AS INT)AS VARCHAR)  END) + ' to ' + (CASE WHEN AllowDecimals='Y' THEN CONVERT(VARCHAR,ToUnit,1) ELSE CAST(CAST(ROUND(ToUnit,0)AS INT)AS VARCHAR)  END)  
 
--Range              
    WHEN '6762'--'E'       
    THEN 'for ' + (CASE WHEN AllowDecimals='Y' THEN CONVERT(VARCHAR,FromUnit,1) ELSE CAST(CAST(ROUND(FromUnit,0)AS INT)AS VARCHAR)  END) --Exact      
    ELSE CT.CodeName            
     END  + ' ' + GC.CodeName AS VARCHAR(30)) AS Amount--Unit              
    ,CASE                    
     WHEN  EXISTS (SELECT * FROM ProcedureRateBillingCodes BC WHERE BC.ProcedureRateId=PR.ProcedureRateId AND ISNULL(BC.RecordDeleted, 'N') = 'N') THEN 'Varies'              
     ELSE CAST(PR.BillingCode + ' ' + ISNULL(PR.Modifier1, '') +  ' ' + ISNULL(PR.Modifier2, '') +  ' ' + ISNULL(PR.Modifier3, '') +  ' ' + ISNULL(PR.Modifier4, '') AS VARCHAR(10))              
     END AS BillingCode                 
    ,CAST(PR.ProgramGroupName AS VARCHAR(25)) AS ProgramGroupName              
    ,CAST(PR.LocationGroupName AS VARCHAR(25)) AS LocationGroupName              
    ,CAST(PR.DegreeGroupName AS VARCHAR(10)) AS DegreeGroupName              
    ,CAST(PR.StaffGroupName AS VARCHAR(30)) AS StaffGroupName      
    ,CAST(PR.ServiceAreaGroupName AS VARCHAR(30)) AS ServiceAreaGroupName      
    ,CAST(PR.PlaceOfServiceGroupName AS VARCHAR(30))  AS PlaceOfServiceGroupName      
    ,CAST(CL.LastName + ', ' + CL.FirstName AS VARCHAR(30))AS ClientName              
    ,CAST(PR.RevenueCode AS VARCHAR(10)) AS RevenueCode              
    ,PR.FromDate              
    ,PR.ToDate              
    ,PR.ClientId              
    ,PC.NotBillable            
    ,PC.Active               
   FROM ProcedureCodes PC      
   LEFT JOIN ProcedureRates PR ON PR.ProcedureCodeId = PC.ProcedureCodeId AND (ISNULL(PR.RecordDeleted,'N') = 'N')        
   LEFT JOIN Clients CL ON  PR.ClientID = CL.ClientID               
   LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId=PC.EnteredAs              
   LEFT JOIN GlobalCodes CT  ON (CT.GlobalCodeId = PR.ChargeType)           
    WHERE ((@CustomFiltersApplied = 'Y' AND EXISTS(SELECT * FROM @CustomFilters cf WHERE cf.ProcedureRateId = PR.ProcedureRateId)) OR      
  (@CustomFiltersApplied = 'N'           
  AND ISNULL(PC.RecordDeleted,'N') = 'N'             
  AND ISNULL(PR.RecordDeleted,'N') = 'N'         
  AND (@xActiveProcedure = -1 OR         -- All Category states        
   (@xActiveProcedure = 1 AND ISNULL(PC.Active,'N') = 'Y') OR    -- Active                     
   (@xActiveProcedure = 2 AND ISNULL(PC.Active,'N') = 'N'))  -- InActive           
  AND (@xDegrees = -1 OR      
   (exists (select * from dbo.ProcedureRateDegrees as prd where prd.ProcedureRateId = pr.ProcedureRateId and @xDegrees = PRD.Degree and ISNULL(prd.RecordDeleted, 'N') <> 'Y')))      
             
  AND (@xPrograms = -1 or      
   (exists (select * from dbo.ProcedureRatePrograms as prp where prp.ProcedureRateId = pr.ProcedureRateId and @xPrograms = PRP.ProgramId and ISNULL(prp.RecordDeleted, 'N') <> 'Y')))      
              
  AND (@xStaff = -1 OR      
   (exists (select * from dbo.ProcedureRateStaff as prs where prs.ProcedureRateId = pr.ProcedureRateId and @xStaff = PRS.StaffId and ISNULL(prs.RecordDeleted, 'N') <> 'Y')))      
             
  AND (@xClient = -1 OR      
   (@xClient = CL.ClientId))       
      
  AND (@xLocations = -1 OR      
   (exists (select * from dbo.ProcedureRateLocations as prl where prl.ProcedureRateId = pr.ProcedureRateId and @xLocations = PRL.LocationId and ISNULL(prl.RecordDeleted, 'N') <> 'Y')))       
      
  AND (@xServiceArea = -1 OR      
   (exists (select * from dbo.ProcedureRateServiceAreas as prsa where prsa.ProcedureRateId = pr.ProcedureRateId and @xServiceArea = PRSA.ServiceAreaId and ISNULL(prsa.RecordDeleted, 'N') <> 'Y')))      
      
  AND (@xPlaceOfService = -1 OR      
   (exists (select * from dbo.ProcedureRatePlacesOfServices as prps where prps.ProcedureRateId = pr.ProcedureRateId and @xPlaceOfService = prps.PlaceOfServieId and ISNULL(prps.RecordDeleted, 'N') <> 'Y')))      
        
  AND (@xProcedureName='' OR (PC.DisplayAs like '%'+@xProcedureName+'%' or PR.BillingCode like '%'+@xProcedureName+'%')) --Added By Atul Pandey            
  AND ((@xCodeRates = -1)      
   OR (@xCodeRates = 1 AND PR.ProgramGroupName IS NOT NULL)      
   OR (@xCodeRates = 2 AND PR.LocationGroupName IS NOT NULL)      
   OR (@xCodeRates = 3 AND PR.DegreeGroupName IS NOT NULL)      
   OR (@xCodeRates = 4 AND PR.StaffGroupName IS NOT NULL)      
   OR (@xCodeRates = 5 AND CL.LastName IS NOT NULL AND CL.FirstName IS NOT NULL)      
   OR (@xCodeRates = 6 AND PR.ProgramGroupName IS NULL      
    AND PR.LocationGroupName IS NULL AND PR.DegreeGroupName IS NULL        
    AND PR.StaffGroupName IS NULL        
    AND PR.ServiceAreaGroupName IS NULL      
    AND PR.PlaceOfServiceGroupName IS NULL      
    AND CAST(CL.LastName + ', ' + CL.FirstName AS VARCHAR(30)) IS NULL       
   ))      
  AND (@xCodeRates <> 7)      
               
  AND (ISNULL(@EffectiveDate,PR.FromDate) BETWEEN PR.FromDate AND ISNULL(PR.ToDate,CONVERT(DATETIME,'12/31/2299',101)))         
          
  AND NOT EXISTS (SELECT * 
					FROM #NotBillableCoveragePlanProcedureCode vplan
					WHERE ISNULL(vplan.ProcedureCodeId,PC.ProcedureCodeId) = PC.ProcedureCodeId       
						  AND vplan.CoveragePlanId = @CoveragePlanId)
  AND ISNULL(pr.CoveragePlanId, 0) IN  (SELECT CoveragePlanId
											FROM #BillingCoveragePlan bcp
											WHERE bcp.CoveragePlanId = @CoveragePlanId)
    AND ((@ExcludeProcedureCode= 1 and exists(Select * from ProcedureCodes PC1 where PC1.ProcedureCodeId=  
                PC.ProcedureCodeId and ISNULL(PC1.BedProcedureCode,'N')='N'   
                and ISNULL(PC1.RecordDeleted,'N')='N' ))  
         or (@ExcludeProcedureCode= 2 and exists(Select * from ProcedureCodes PC1 where PC1.ProcedureCodeId=  
                PC.ProcedureCodeId and ISNULL(PC1.MedicationProcedureCode,'N')='N'   
                and ISNULL(PC1.RecordDeleted,'N')='N' ))  
         or (@ExcludeProcedureCode= -1 and exists(Select * from ProcedureCodes PC1 where PC1.ProcedureCodeId=  
                PC.ProcedureCodeId and ISNULL(PC1.BedProcedureCode,'N')='N' and ISNULL(PC1.MedicationProcedureCode,'N')='N'  
                and ISNULL(PC1.RecordDeleted,'N')='N' ))
         or @ExcludeProcedureCode= 3)  
   ))    
  )      
      
 END      
       
       
  ; with   counts as (       
    select count(*) as totalrows from #ResultSet      
    ),      
      
                                       
   RankResultSet      
                      AS ( SELECT   ProcedureRateId      
   ,ProcedureCodeId      
   ,ProcedureCode      
   ,Amount      
   ,BillingCode      
   ,ProgramGroupName      
   ,LocationGroupName      
   ,DegreeGroupName      
   ,StaffGroupName      
   ,ServiceAreaGroupName      
   ,PlaceOfServiceGroupName      
   ,ClientName      
   ,RevenueCode      
   ,FromDate      
   ,ToDate      
   ,NotBillable      
   ,Active ,      
                                    COUNT(*) OVER ( ) AS TotalCount ,      
                                    RANK() OVER ( ORDER BY        
    CASE WHEN @xSortExpression= 'ProcedureCode'   THEN ProcedureCode END,                                     
    CASE WHEN @xSortExpression= 'ProcedureCode desc'  THEN ProcedureCode END DESC,      
    CASE WHEN @xSortExpression= 'Amount'     THEN Amount END,                                        
    CASE WHEN @xSortExpression= 'Amount desc'   THEN Amount END DESC,      
    CASE WHEN @xSortExpression= 'BillingCode'   THEN BillingCode END,                                        
    CASE WHEN @xSortExpression= 'BillingCode desc'  THEN BillingCode END DESC,      
    CASE WHEN @xSortExpression= 'ProgramGroupName'  THEN ProgramGroupName END,                                        
    CASE WHEN @xSortExpression= 'ProgramGroupName desc' THEN ProgramGroupName END DESC,      
    CASE WHEN @xSortExpression= 'LocationGroupName'  THEN LocationGroupName END,                                        
    CASE WHEN @xSortExpression= 'LocationGroupName desc' THEN LocationGroupName END DESC,      
    CASE WHEN @xSortExpression= 'DegreeGroupName'  THEN DegreeGroupName END,                                        
    CASE WHEN @xSortExpression= 'DegreeGroupName desc' THEN DegreeGroupName END DESC,      
    CASE WHEN @xSortExpression= 'StaffGroupName'   THEN StaffGroupName END,                                        
    CASE WHEN @xSortExpression= 'StaffGroupName desc' THEN StaffGroupName END DESC,      
    CASE WHEN @xSortExpression= 'ServiceAreaGroupName' THEN ServiceAreaGroupName END,                                        
    CASE WHEN @xSortExpression= 'ServiceAreaGroupName desc' THEN ServiceAreaGroupName END DESC,  
    CASE WHEN @xSortExpression= 'PlaceOfServiceGroupName' THEN PlaceOfServiceGroupName END,                                        
    CASE WHEN @xSortExpression= 'PlaceOfServiceGroupName desc' THEN PlaceOfServiceGroupName END DESC,      
    CASE WHEN @xSortExpression= 'ClientName'    THEN ClientName END,                                        
    CASE WHEN @xSortExpression= 'ClientName desc'  THEN ClientName END DESC,      
    CASE WHEN @xSortExpression= 'RevenueCode'   THEN RevenueCode END,                                        
    CASE WHEN @xSortExpression= 'RevenueCode desc'  THEN RevenueCode END DESC,      
    CASE WHEN @xSortExpression= 'FromDate'    THEN FromDate END,                                        
    CASE WHEN @xSortExpression= 'FromDate desc'   THEN FromDate END DESC,      
    CASE WHEN @xSortExpression= 'ToDate'     THEN ToDate END,                                        
    CASE WHEN @xSortExpression= 'ToDate desc'   THEN ToDate END DESC,      
    ProcedureRateId ) AS RowNumber      
                           FROM     #ResultSet      
                           )      
                                 
                                               
         
      
   SELECT TOP ( Case WHEN (@PageNumber = -1) THEN (SELECT ISNULL(totalrows,0) from counts) ELSE (@PageSize) END)      
                      ProcedureRateId      
   ,ProcedureCodeId      
   ,ProcedureCode      
   ,Amount      
   ,BillingCode      
   ,ProgramGroupName     
   ,LocationGroupName      
   ,DegreeGroupName      
   ,StaffGroupName      
   ,ServiceAreaGroupName      
   ,PlaceOfServiceGroupName      
   ,ClientName      
   ,RevenueCode      
   ,FromDate      
   ,ToDate      
   ,NotBillable      
   ,Active  , RowNumber ,      
                        TotalCount       
                INTO    #FinalResultSet      
                FROM    RankResultSet      
                WHERE   RowNumber > ( ( @PageNumber - 1 ) * @PageSize )    
               -- Kirtee 14 July 2014   Removed the ProcedureName filter condition from the resulting table     
               -- AND  (@xProcedureName='' OR ProcedureCode like '%'+@xProcedureName+'%')--Added By Atul Pandey                                           
               
               
         IF (SELECT     ISNULL(COUNT(*),0) FROM   #FinalResultSet)<1      
             BEGIN      
                    SELECT 0 AS PageNumber ,      
                    0 AS NumberOfPages ,      
                    0 NumberOfRows      
                  END      
             ELSE      
  BEGIN                                  
  SELECT TOP 1      
                    @PageNumber AS PageNumber ,      
                    CASE (TotalCount % @PageSize) WHEN 0 THEN       
                    ISNULL(( TotalCount / @PageSize ), 0)      
                    ELSE ISNULL(( TotalCount / @PageSize ), 0) + 1 END AS NumberOfPages,      
                    ISNULL(TotalCount, 0) AS NumberOfRows      
            FROM    #FinalResultSet       
            END      
                                               
                                             
                                          
  SELECT      
    ProcedureRateId      
   ,ProcedureCodeId      
   ,ProcedureCode      
   ,Amount      
   ,BillingCode      
   ,ProgramGroupName      
   ,LocationGroupName      
   ,DegreeGroupName      
   ,StaffGroupName      
   ,ServiceAreaGroupName      
   ,PlaceOfServiceGroupName      
   ,ClientName      
   ,RevenueCode      
   ,FromDate      
   ,ToDate      
   ,NotBillable      
   ,Active        
  FROM #FinalResultSet                                                                               
  ORDER BY RowNumber      
        
        
 END TRY      
       
 BEGIN CATCH      
  DECLARE @Error VARCHAR(8000)             
  SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())                                                                                                  
   + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'ssp_PMProcedureRates')                                                                                                   
   + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())                                                                                                    
   + '*****' + CONVERT(VARCHAR,ERROR_STATE())      
  RAISERROR      
  (      
   @Error, -- Message text.      
   16,  -- Severity.      
   1  -- State.      
  );      
 END CATCH      
END 

GO