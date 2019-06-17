IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_ListPageSCGetHealthMaintenanceTrigInfo')
	BEGIN
		DROP  Procedure ssp_ListPageSCGetHealthMaintenanceTrigInfo
	END

GO

CREATE procedure [dbo].[ssp_ListPageSCGetHealthMaintenanceTrigInfo]                                                                                       
@PageNumber INT,            
@PageSize INT,            
@SortExpression VARCHAR(100),      
@ActionValue VARCHAR(100),      
@SearchText VARCHAR(100) 
--@PrimaryKey INT             
            
            
/*********************************************************************************/                        
/* Stored Procedure: ssp_ListPageSCGetHealthMaintenanceTrigInfo         */               
/* Copyright: Streamline Healthcare Solutions          */                        
/* Creation Date:  29-August-2012              */                        
/* Purpose: used by Client Activity List Page For Staff        */                       
/* Input Parameters:                */                      
/* Output Parameters:PageNumber,PageSize,SortExpression,  */              
/*     @ActionType,@SearchText */                      
/* Return:                      */                        
/* Called By: Activity.cs , GetActivityListPageData()        */                        
/* Calls:                   */                        
/* Data Modifications:                */                        
/* Updates:                   */                        
/* Date                Author                  Purpose        */                        
/* 29-August-2012      Devender K              Created        */   
/* 03-Septemeber-2012  Rakesh Garg             Get AddButtonEnabled Information        */ 
/* 20-Septemeber-2012  Rahul  An			   Change table ProcedureCodes to PcProcedureCodes       */ 
/* 27th feb 2013       Sunilkh                 show the diagnosis from DiagnosisIcdCodes tables and remove axis & dsmnumber column */   
/* 16 Oct	2014	   Ponnin				   show Health Data Element from HealthDataAttributes table. Why : For task #4 of Certification 2014 */  
/* 21 Oct	2014	   Prasan				   show Allergies from MDAllergenConcepts table. Why : For task #4 of Certification 2014 */
/* 10 Nov	2014	   Ponnin				   Added a new Column DataType and UnitName for ProcedureCodes resultset. Why : For task #4 of Certification 2014 */                
/* 21 Dec	2015	   Ponnin				   show Diagnosis Description from DiagnosisAllCodes table instead of DiagnosisICDCodes.   For task #14 of Diagnosis Changes (ICD10) */                                                            
/* 07 Dec	2018	   Jeffin				   Added a new Column DropDownCategory for implementation of Dropdown functionality. Why : For task #38 of Meaningful Use - Stage 3 */
/*********************************************************************************/                   
AS                                                                        
BEGIN                              
BEGIN TRY                     
    SET NOCOUNT ON;      
   --     
 --Insert data in to temp table which is fetched below by appling filter.               
 --      
 IF (@ActionValue='8118')      
 --For Procedure      
 BEGIN      
 ;WITH TotalHealthDataProcedureCodes  AS             
(               
 SELECT PCHMT.ProcedureCode  as Code,PCHMT.Description as [Description],    
 0 as AddButtonEnabled,
 0 as  DataType,
 '' as UnitName
 FROM dbo.PCProcedureCodes as PCHMT where         
 ISNULL(PCHMT.RecordDeleted,'N') = 'N' and           
 PCHMT.Description like CASE WHEN @SearchText IS NOT NULL OR @SearchText <> '' THEN          
 ('%' + @SearchText + '%')  ELSE PCHMT.Description END OR
  PCHMT.ProcedureCode like CASE WHEN  @SearchText IS NOT NULL OR @SearchText <> '' THEN
   ('%' + @SearchText + '%')  ELSE PCHMT.ProcedureCode END           
),             
           
  counts AS             
(             
 SELECT COUNT(*) AS totalrows FROM TotalHealthDataProcedureCodes            
),           
 LisHealthDataProcedureCodes  AS                                                                                
  (SELECT            
  Code,               
 [Description],  
 AddButtonEnabled,
 DataType,
 UnitName,
 COUNT(*) OVER ( ) AS TotalCount ,            
 ROW_NUMBER() OVER ( ORDER BY
    CASE WHEN @SortExpression= 'Code'    THEN Description END,                                                                            
    CASE WHEN @SortExpression= 'Code desc'   THEN Description END DESC,                     
    CASE WHEN @SortExpression= 'Description'    THEN Description END,                                                                            
    CASE WHEN @SortExpression= 'Description desc'   THEN Description END DESC        
                                                                               
    )AS RowNumber            
  FROM TotalHealthDataProcedureCodes                               
)                                                                                  
    SELECT TOP ( Case WHEN (@PageNumber = -1) THEN (SELECT ISNULL(totalrows,0) from counts) ELSE (@PageSize) END)            
      Code,               
      [Description],AddButtonEnabled,  
						0 as  DataType,
						'' as UnitName,
                        TotalCount ,            
                        RowNumber            
                INTO    #FinalResultSetProcedure            
                FROM    LisHealthDataProcedureCodes       
                WHERE   RowNumber > ( ( @PageNumber - 1 ) * @PageSize )            
                          
  IF (SELECT     ISNULL(COUNT(*),0) FROM   #FinalResultSetProcedure)<1            
  BEGIN            
   SELECT 0 AS PageNumber ,            
   0 AS NumberOfPages ,            
   0 NumberOfRows            
  END            
  ELSE            
  BEGIN            
   SELECT TOP 1            
   @PageNumber AS PageNumber,            
   1 AS NumberOfPages,            
   ISNULL(TotalCount, 0) AS NumberOfRows            
   FROM    #FinalResultSetProcedure                 
  END                         
             
 SELECT                                                                                   
 Code,                
 [Description],  
 AddButtonEnabled,
 0 as  DataType,
 '' as UnitName
 FROM #FinalResultSetProcedure                                              
 ORDER BY RowNumber       
 DROP TABLE #FinalResultSetProcedure       
 END      
       
 --For Diagnosis      
 ELSE IF (@ActionValue='8119')      
 BEGIN      
;WITH TotalHealthDataDiagnosisCodes  AS               
(       
                
 --SELECT  DCHMT.DSMCode as Code,DCHMT.DSMDescription as [Description],  
 -- 0 as AddButtonEnabled, 
 -- DCHMT.DSMNumber,DCHMT.Axis               
 --FROM dbo.DiagnosisDSMDescriptions As DCHMT   
 --Where        
 --DCHMT.DSMDescription like CASE WHEN @SearchText IS NOT NULL OR @SearchText <> '' THEN        
 --('%' + @SearchText + '%')  ELSE DCHMT.DSMDescription END OR      
 --DCHMT.DSMCode like CASE WHEN @SearchText IS NOT NULL OR @SearchText <> '' THEN        
 --('%' + @SearchText + '%')  ELSE DCHMT.DSMCode END    
 
 -- Modified by Ponnin on 21 Dec 2015 - For task #14 of Diagnosis Changes (ICD10)
SELECT  DAC.DiagnosisCode as Code,DAC.DiagnosisDescription as [Description],        
  0 as AddButtonEnabled                     
 FROM dbo.DiagnosisAllCodes As DAC         
 Where  DAC.IncludeInSearch='Y' and  DAC.CodeType in ('ICD10', 'DSM5') and          
( DAC.DiagnosisDescription like CASE WHEN @SearchText IS NOT NULL OR @SearchText <> '' THEN              
 ('%' + @SearchText + '%')  ELSE DAC.DiagnosisDescription END OR            
 DAC.DiagnosisCode like CASE WHEN @SearchText IS NOT NULL OR @SearchText <> '' THEN              
 ('%' + @SearchText + '%')  ELSE DAC.DiagnosisCode  END  )            
),               
             
  counts AS               
(               
 SELECT COUNT(*) AS totalrows FROM TotalHealthDataDiagnosisCodes              
),             
 LisHealthDataDiagnosisCodes  AS                                                                                  
  (   SELECT              
 Code,                 
 [Description],  
 AddButtonEnabled,  
 0 as  DataType,
 '' as UnitName,
 COUNT(*) OVER ( ) AS TotalCount ,              
 ROW_NUMBER() OVER ( ORDER BY
    CASE WHEN @SortExpression= 'Code'    THEN Description END,                                                                            
    CASE WHEN @SortExpression= 'Code desc'   THEN Description END DESC,                
    CASE WHEN @SortExpression= 'Description'    THEN Description END,                                                                              
    CASE WHEN @SortExpression= 'Description desc'   THEN Description END DESC                                                                                 
    )AS RowNumber              
  FROM TotalHealthDataDiagnosisCodes                                 
)                                                                                    
    SELECT TOP ( Case WHEN (@PageNumber = -1) THEN (SELECT ISNULL(totalrows,0) from counts) ELSE (@PageSize) END)              
       Code,                 
      [Description],  
      AddButtonEnabled,  
	  DataType,
	  UnitName,
      TotalCount ,              
      RowNumber              
                INTO    #FinalResultSetDiagnosis              
                FROM    LisHealthDataDiagnosisCodes              
                WHERE   RowNumber > ( ( @PageNumber - 1 ) * @PageSize )       
    IF (SELECT     ISNULL(COUNT(*),0) FROM   #FinalResultSetDiagnosis)<1              
  BEGIN              
   SELECT 0 AS PageNumber ,              
   0 AS NumberOfPages ,              
   0 NumberOfRows              
  END              
  ELSE              
  BEGIN              
   SELECT TOP 1              
   @PageNumber AS PageNumber,              
   1 AS NumberOfPages,              
   ISNULL(TotalCount, 0) AS NumberOfRows              
   FROM    #FinalResultSetDiagnosis                   
  END      
 SELECT                                                                                   
 Code,                
 [Description],  
 AddButtonEnabled,
 DataType,
 UnitName
 FROM #FinalResultSetDiagnosis                                              
 ORDER BY RowNumber              
             
 DROP TABLE #FinalResultSetDiagnosis         
 END         
       
 --For Medication      
  ELSE IF (@ActionValue='8117')      
  BEGIN       
  ;WITH TotalHealthDataMedicationCodes  AS               
(                 
 SELECT  MedicationNameId As Code,
  MedicationName as [Description],  
  0 as AddButtonEnabled,
   0 as  DataType,
 '' as UnitName
 FROM dbo.MDMedicationNames As MDHMT where       
 ISNULL(MDHMT.RecordDeleted,'N') = 'N' and         
 MDHMT.MedicationName like CASE WHEN @SearchText IS NOT NULL OR @SearchText <> '' THEN        
 ('%' + @SearchText + '%')  ELSE MDHMT.MedicationName END      
       
),       
             
  counts AS               
(               
 SELECT COUNT(*) AS totalrows FROM TotalHealthDataMedicationCodes              
),             
 LisHealthDataMedicationCodes  AS                                                                                  
  (   select              
 Code,                 
 [Description],AddButtonEnabled, 
  DataType,
 UnitName,
 COUNT(*) OVER ( ) AS TotalCount ,              
 ROW_NUMBER() OVER ( ORDER BY               
    CASE WHEN @SortExpression= 'Description'    THEN Description END,                                                      
    CASE WHEN @SortExpression= 'Description desc'   THEN Description END DESC                                                                                 
    )AS RowNumber              
  FROM TotalHealthDataMedicationCodes                                 
)                                                                                    
    SELECT TOP ( Case WHEN (@PageNumber = -1) THEN (SELECT ISNULL(totalrows,0) from counts) ELSE (@PageSize) END)              
      Code,                 
      [Description], AddButtonEnabled, 
						 DataType,
						UnitName,
                        TotalCount ,              
                        RowNumber              
                INTO    #FinalResultSetMedication              
                FROM    LisHealthDataMedicationCodes              
                WHERE   RowNumber > ( ( @PageNumber - 1 ) * @PageSize )              
                            
    IF (SELECT     ISNULL(COUNT(*),0) FROM   #FinalResultSetMedication)<1              
  BEGIN              
   SELECT 0 AS PageNumber ,              
   0 AS NumberOfPages ,              
   0 NumberOfRows              
  END              
  ELSE              
  BEGIN              
   SELECT TOP 1              
   @PageNumber AS PageNumber,              
   1 AS NumberOfPages,              
   ISNULL(TotalCount, 0) AS NumberOfRows              
   FROM    #FinalResultSetMedication                   
  END        
  SELECT                                                                                   
 Code,                
 [Description],  
 AddButtonEnabled,
  DataType,
 UnitName
 FROM #FinalResultSetMedication                                              
 ORDER BY RowNumber      
 DROP TABLE #FinalResultSetMedication               
 END      
 
 
 
 
 -- Changes made by Ponnin Starts here........
 
 --For Health Data Element      
  ELSE IF (@ActionValue='8121')      
  BEGIN       
  ;WITH TotalHealthDataElements  AS               
(                 
 SELECT  HealthDataAttributeId As Code,
  [Name] as [Description],  
  0 as AddButtonEnabled,
  DataType,
 (select top 1 CodeName  from GlobalCodes where GlobalCodeId = Units  ) as UnitName 
 FROM dbo.HealthDataAttributes As MDA where   MDA.DataType not in (8086,8085,8084,8089) and   -- Results dispaly for text box enter related Type 
 ISNULL(MDA.RecordDeleted,'N') = 'N' and         
 MDA.[Name] like CASE WHEN @SearchText IS NOT NULL OR @SearchText <> '' THEN        
 ('%' + @SearchText + '%')  ELSE MDA.Name END      
       
),       
             
  counts AS               
(               
 SELECT COUNT(*) AS totalrows FROM TotalHealthDataElements              
),             
 LisHealthDataElements  AS                                                                                  
  (   select              
 Code,                 
 [Description],AddButtonEnabled, 
 DataType,
 UnitName,
 COUNT(*) OVER ( ) AS TotalCount ,              
 ROW_NUMBER() OVER ( ORDER BY               
    CASE WHEN @SortExpression= 'Description'    THEN Description END,                                                      
    CASE WHEN @SortExpression= 'Description desc'   THEN Description END DESC                                                                                 
    )AS RowNumber              
  FROM TotalHealthDataElements                                 
)                                                                                    
    SELECT TOP ( Case WHEN (@PageNumber = -1) THEN (SELECT ISNULL(totalrows,0) from counts) ELSE (@PageSize) END)              
      Code,                 
      [Description], AddButtonEnabled, 
						DataType,
						UnitName,
                        TotalCount ,              
                        RowNumber              
                INTO    #FinalResultSetHealthDataElement            
                FROM    LisHealthDataElements              
                WHERE   RowNumber > ( ( @PageNumber - 1 ) * @PageSize )              
                            
    IF (SELECT     ISNULL(COUNT(*),0) FROM   #FinalResultSetHealthDataElement)<1              
  BEGIN              
   SELECT 0 AS PageNumber ,              
   0 AS NumberOfPages ,              
   0 NumberOfRows              
  END              
  ELSE              
  BEGIN              
   SELECT TOP 1              
   @PageNumber AS PageNumber,              
   1 AS NumberOfPages,              
   ISNULL(TotalCount, 0) AS NumberOfRows              
   FROM    #FinalResultSetHealthDataElement                   
  END        
  SELECT                                                                                   
 Code,                
 [Description],  
 AddButtonEnabled,
 DataType,
 UnitName,
 -- Modified by Jeffin on 07 Dec 2018 - For task #38 of Meaningful Use - Stage 3
 Case when DataType = 8081 then (select top 1 DropDownCategory  from HealthDataAttributes where HealthDataAttributeId = Code)  
 ELSE 0 END  
 as DropDownCategory
 FROM #FinalResultSetHealthDataElement                                              
 ORDER BY RowNumber      
 DROP TABLE #FinalResultSetHealthDataElement             
 END      
 
 ------------------------------------------------------------------
 --For Allergies      
  ELSE IF (@ActionValue='8122')      
  BEGIN       
  ;WITH TotalAllergiesCodes  AS               
(                 
 SELECT  AllergenConceptId As Code,
  ConceptDescription as [Description],  
  0 as AddButtonEnabled,
   0 as  DataType,
 '' as UnitName
 FROM dbo.MDAllergenConcepts As MDAC where       
 ISNULL(MDAC.RecordDeleted,'N') = 'N' and         
 MDAC.ConceptDescription like CASE WHEN @SearchText IS NOT NULL OR @SearchText <> '' THEN        
 ('%' + @SearchText + '%')  ELSE MDAC.ConceptDescription END      
       
),       
             
  counts AS               
(               
 SELECT COUNT(*) AS totalrows FROM TotalAllergiesCodes              
),             
 ListAllergiesCodes  AS                                                                                  
  (   select              
 Code,                 
 [Description],AddButtonEnabled, 
  DataType,
 UnitName,
 COUNT(*) OVER ( ) AS TotalCount ,              
 ROW_NUMBER() OVER ( ORDER BY               
    CASE WHEN @SortExpression= 'Description'    THEN Description END,                                                      
    CASE WHEN @SortExpression= 'Description desc'   THEN Description END DESC                                                                                 
    )AS RowNumber              
  FROM TotalAllergiesCodes                                 
)                                                                                    
    SELECT TOP ( Case WHEN (@PageNumber = -1) THEN (SELECT ISNULL(totalrows,0) from counts) ELSE (@PageSize) END)              
      Code,                 
      [Description], AddButtonEnabled, 
						 DataType,
						UnitName,
                        TotalCount ,              
                        RowNumber              
                INTO    #FinalResultSetAllergies              
                FROM    ListAllergiesCodes              
                WHERE   RowNumber > ( ( @PageNumber - 1 ) * @PageSize )              
                            
    IF (SELECT     ISNULL(COUNT(*),0) FROM   #FinalResultSetAllergies)<1              
  BEGIN              
   SELECT 0 AS PageNumber ,              
   0 AS NumberOfPages ,              
   0 NumberOfRows              
  END              
  ELSE              
  BEGIN              
   SELECT TOP 1              
   @PageNumber AS PageNumber,              
   1 AS NumberOfPages,              
   ISNULL(TotalCount, 0) AS NumberOfRows              
   FROM    #FinalResultSetAllergies                   
  END        
  SELECT                                                                                   
 Code,                
 [Description],  
 AddButtonEnabled,
  DataType,
 UnitName
 FROM #FinalResultSetAllergies                                              
 ORDER BY RowNumber      
 DROP TABLE #FinalResultSetAllergies               
 END
 
 ------------------------------------------------------------------
         
                        
 END TRY                              
BEGIN CATCH                              
 DECLARE @Error varchar(8000)                                                                             
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                           
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_ListPageSCGetHealthMaintenanceTrigInfo')                                                                                                           
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