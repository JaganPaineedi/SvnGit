IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetBindDiagnosis]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetBindDiagnosis]
GO 
  
 CREATE PROCEDURE [dbo].[ssp_GetBindDiagnosis]          
 @ClientId INT,
 @OrderId VARCHAR(MAX)   
AS           
  /**************************************************************              
  Created By   : Pabitra [ssp_GetBindDiagnosis] 4,2         
  Created Date : 13 June 2017             
  Description  : To get the orders          
  Called From  :ClientOrderUserControl.ascx.cs       
  /*  Date        Author          Description */ 
    08/21/2017    Pabitra         Texas Customizations#104   
	05/22/2018    Akwinass        Added code to avoid duplicate diagnosis(Task#255 in Texas Go Live Build Issues)     
 **************************************************************/           
  BEGIN           
      BEGIN try           
            
  DECLARE @LatestICD10DocumentVersionID INT      
      
  SET @LatestICD10DocumentVersionID = (      
    SELECT TOP 1 a.CurrentDocumentVersionId      
    FROM Documents AS a      
    INNER JOIN DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId      
    INNER JOIN DocumentDiagnosisCodes AS DDC ON a.CurrentDocumentVersionId = DDC.DocumentVersionId      
    WHERE a.ClientId = @ClientId      
     AND a.EffectiveDate <= CAST(GETDATE() AS DATE)      
     AND a.STATUS = 22      
     AND Dc.DiagnosisDocument = 'Y'      
     AND ISNULL(a.RecordDeleted, 'N') <> 'Y'      
     AND ISNULL(Dc.RecordDeleted, 'N') <> 'Y'      
    ORDER BY a.EffectiveDate DESC      
     ,a.ModifiedDate DESC      
    )      

		CREATE TABLE  #DiagnosisTemp
		(
		 ID INT IDENTITY(1,1) NOT NULL,
		 DSMCode VARCHAR(50),
		 [Default] CHAR(1),
		 DisplayAs VARCHAR(Max),
		 Diagnosisvalue VARCHAR(MAX)
		) 
		
		
	    INSERT INTO #DiagnosisTemp (DSMCode,[Default],DisplayAs,Diagnosisvalue)	    
	    SELECT OD.ICD10CodeId as DSMCode,
	    OD.IsDefault AS [Default],
	     SUBSTRING(CAST(OD.ICDCode AS VARCHAR(10)) + ' - ' + ICD10.ICDDescription, 0, 95) AS DisplayAs 
	    ,CAST(OD.ICDCode AS VARCHAR(10)) + '$$$' + ICD10.ICDDescription + '$$$' + CAST(ISNULL(DICD.ICD9Code, '') AS VARCHAR(10)) + '$$$' + CAST(ISNULL(OD.ICD10CodeId, '') AS VARCHAR(10)) + '$$$' + ''+ '$$$' + '' AS Diagnosisvalue  
	    FROM OrderDiagnosis OD 
	    INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = OD.ICD10CodeId  
	    --LEFT JOIN SNOMEDCTCodes SNC ON SNC.SNOMEDCTCode = CP.SNOMEDCODE  
	    LEFT JOIN DiagnosisICD10ICD9Mapping DICD ON DICD.ICD10CodeId = OD.ICD10CodeId
	    WHERE ISNULL(OD.RecordDeleted, 'N') <> 'Y'  
	    AND Od.OrderId=@OrderId AND (OD.ICD10CodeId NOT IN (SELECT DSMCode FROM #DiagnosisTemp))
	 
		
		 INSERT INTO #DiagnosisTemp (DSMCode, [Default],DisplayAs,Diagnosisvalue)
		SELECT DDC.ICD10CodeId as DSMCode, 
		'N' AS [Default],
		     SUBSTRING(CAST(DDC.ICD10Code AS VARCHAR(10)) + ' - ' + ICD10.ICDDescription, 0, 95) AS DisplayAs
			,CAST(DDC.ICD10Code AS VARCHAR(10)) + '$$$' + ICD10.ICDDescription + '$$$' + CAST(ISNULL(DDC.ICD9Code, '') AS VARCHAR(10)) + '$$$' + CAST(ISNULL(DDC.ICD10CodeId, '') AS VARCHAR(10)) + '$$$' + CAST(ISNULL(DDC.SNOMEDCODE, '') AS VARCHAR(10)) + '$$$' + ISNULL(SNC.SNOMEDCTDescription, '') AS Diagnosisvalue
		FROM DocumentDiagnosisCodes DDC
		INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = DDC.ICD10CodeId
		LEFT JOIN SNOMEDCTCodes SNC ON SNC.SNOMEDCTCode = DDC.SNOMEDCODE
		WHERE ISNULL(DDC.RecordDeleted, 'N') <> 'Y'
			AND DDC.DocumentVersionId = @LatestICD10DocumentVersionID  AND (DDC.ICD10CodeId NOT IN (SELECT DSMCode FROM #DiagnosisTemp))	
		ORDER BY DDC.DiagnosisOrder
				
		INSERT INTO #DiagnosisTemp (DSMCode, [Default],DisplayAs,Diagnosisvalue)
	    SELECT CP.ICD10CodeId as DSMCode,
	    'N' AS [Default],
	     SUBSTRING(CAST(CP.ICD10Code AS VARCHAR(10)) + ' - ' + ICD10.ICDDescription, 0, 95) AS DisplayAs 
	    ,CAST(CP.ICD10Code AS VARCHAR(10)) + '$$$' + ICD10.ICDDescription + '$$$' + CAST(ISNULL(DICD.ICD9Code, '') AS VARCHAR(10)) + '$$$' + CAST(ISNULL(CP.ICD10CodeId, '') AS VARCHAR(10)) + '$$$' + CAST(ISNULL(CP.SNOMEDCODE, '') AS VARCHAR(10)) + '$$$' + ISNULL(SNC.SNOMEDCTDescription, '') AS Diagnosisvalue  
	    FROM ClientProblems CP  
	    INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = CP.ICD10CodeId  
	    LEFT JOIN SNOMEDCTCodes SNC ON SNC.SNOMEDCTCode = CP.SNOMEDCODE  
	    LEFT JOIN DiagnosisICD10ICD9Mapping DICD ON DICD.ICD10CodeId = CP.ICD10CodeId
	    WHERE ISNULL(CP.RecordDeleted, 'N') <> 'Y'  
	    AND CP.ClientId = @ClientId AND (CP.ICD10CodeId NOT IN (SELECT DSMCode FROM #DiagnosisTemp))
	    ORDER BY CP.DiagnosisOrder     
	    
		--05/22/2018    Akwinass 
		CREATE TABLE  #DiagnosisTemp2
		(		
		 DSMCode VARCHAR(50),
		 [Default] CHAR(1),
		 DisplayAs VARCHAR(Max),
		 Diagnosisvalue VARCHAR(MAX)
		) 

		INSERT INTO #DiagnosisTemp2(DisplayAs,Diagnosisvalue,[Default])    
	    SELECT DisplayAs,Diagnosisvalue,[Default]
		FROM (SELECT ROW_NUMBER() OVER (PARTITION BY DisplayAs,Diagnosisvalue ORDER BY DisplayAs) AS RowNum
				,DisplayAs
				,Diagnosisvalue
				,[Default]
				,ID
			FROM #DiagnosisTemp
			) AS Diagnosis
		WHERE RowNum = 1
		ORDER BY ID ASC

		UPDATE T2
		SET T2.[Default] = 'Y'
		FROM #DiagnosisTemp2 T2
		WHERE EXISTS(SELECT 1 FROM #DiagnosisTemp T1 WHERE T1.DisplayAs = T2.DisplayAs AND T1.Diagnosisvalue = T2.Diagnosisvalue AND T1.[Default] = 'Y')
		--
		SELECT DisplayAs,Diagnosisvalue,[Default] FROM #DiagnosisTemp2

		DROP TABLE #DiagnosisTemp
        DROP TABLE #DiagnosisTemp2
      END try           
          
      BEGIN catch           
          DECLARE @Error VARCHAR(8000)           
          
          SET @Error = CONVERT(VARCHAR, Error_number()) + '*****'           
                       + CONVERT(VARCHAR(4000), Error_message())           
                       + '*****'           
                       + Isnull(CONVERT(VARCHAR, Error_procedure()),           
                       'ssp_GetBindDiagnosis')           
                       + '*****' + CONVERT(VARCHAR, Error_line())           
                       + '*****' + CONVERT(VARCHAR, Error_severity())           
                       + '*****' + CONVERT(VARCHAR, Error_state())           
          
          RAISERROR ( @Error,-- Message text.            
                      16,-- Severity.            
                      1 -- State.            
          );           
      END catch           
  END 