/****** Object:  StoredProcedure [ssp_SCClientMedicationDxpurpose]    Script Date: 12/11/2012 3:59:52 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ssp_SCClientMedicationDxpurpose]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ssp_SCClientMedicationDxpurpose]
GO

/****** Object:  StoredProcedure [ssp_SCClientMedicationDxpurpose]    Script Date: 12/11/2012 3:59:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ssp_SCClientMedicationDxpurpose] ( @ClientId INT )
AS /************************************************************************/                                                              
/* Stored Procedure: dbo.[ssp_SCClientMedicationDxpurpose]    */                                                              
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC    */                                                              
/* Creation Date:    28/Sep/07           */                                                             
/*                  */                                                              
/* Purpose:  To retrieve DxPurpose            */                              
/*                  */                                                            
/* Input Parameters: none        @ClientId        */                                                            
/*                  */                                                              
/* Output Parameters:   None           */  
/*                  */                                                              
/* Return:  0=success, otherwise an error number      */                                                              
/*                  */                                                              
/* Called By:               */                                                              
/*                  */                                                              
/* Calls:                */                                                              
/*                  */                                                              
/* Data Modifications:             */                                                              
/*                  */                                                              
/* Updates:                */                                                              
/*Date: Author               */  
/*Description of Change             */                                                              
/*  28/Sep/07    Rishu    Created          */                
/* TER Modified               */  
/* Include any Axis III codes/descriptions defined in the dx document */               
/* 06/06/2008 Sonia Modified           */          
/* Ref Task #48 MM 1.5             */          
/* While retrieving records from DiagnosisIandII no join with documents */  
/* table is required             */                                                       
/* Modified by Loveena in ref to Task#2547 as ref to Javed-Comment Null */  
/* to store in DSMCode             */       
/* so eac Global Code DrigPurpose will have sane DxId so to set unique */   
/* DxId DSMDescription is concatenated with DSMNumber.     */                                                      
/* Jul 15 2010:RJN              */  
/* Modified stored procedure to utilize new DiagnosesIIICodes table  */  
/* Dec 11, 2012 Kneale Changed the second select to use ICDDescription instead of ICDCode */
/* Jul 14 2015	Malathi Shiva	WRT Diagnosis Changes (ICD10) Task# 19, Added ICD10 changes to the existing logic  */
/* Aug 07 2015	Malathi Shiva	WRT Summit Pointe- Support 567, Data model change from  DocumentDiagnosisCodes.DSMVCodeId to DocumentDiagnosisCodes.ICD10CodeId, Patient Summary was not loading the data*/
/* Aug 11 2015  Malathi Shiva   WRT Core Bugs 1862, Displayedthe latest signed Diagnosis document, If there is no ICD10 diagnosis it takes from Axis I/II */
/* Feb 26 2015  Malathi Shiva	WRT Key Point - Environment Issues Tracking: Task# 255 , When we sign a diagnosis document or any document which has diagnosis tab and immediately check the Rx Diagnosis drop down in Client Medication Order, the diagnosis does not appear because the effective date check was incorrect
		It was checking for Effective date <= Today's date which was not satisfying since the effective date was not converted to date instead it was checking along with the time so the date was not satisfied */
/* Aug 23 2017  Anto   WRT Andrews Center - Environment Issues Tracking #64, Modified the logic to display Problem detail diagnosis along with DSM5 Diagnosis */  		
/************************************************************************/                                                           
  
    DECLARE @varCurrentdocumentVersionId INT      
      DECLARE @DSM5DOC CHAR(1)    
 
	 CREATE TABLE  #DiagnosisTemp
	(
	 DSMCode VARCHAR(50),
	 DSMNumber VARCHAR(50),
	 DSMDescription VARCHAR(MAX),
	 Axis Varchar(50),
	 AxisName VARCHAR(50),
	 DxId VARCHAR(MAX),
	 DiagnosisOrder VARCHAR(50)
	 
	)    
	                      
-- Get the most recently signed diagnosis document    
    SELECT TOP 1  
            @varCurrentdocumentVersionId = a.CurrentDocumentVersionId, @DSM5DOC=ISNULL(DC.DSMV,'N')
    FROM    Documents a 
    INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeid = a.DocumentCodeid   
    WHERE   a.ClientId = @ClientId  
            AND CONVERT(DATETIME, CONVERT(VARCHAR, a.EffectiveDate, 101)) <= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101))  
            AND a.Status = 22  
            -- Modified by Malathi Shiva, included DocumentCodeId which points to the active diagnosis  
            --AND a.DocumentCodeId in (5,1601)
            AND Dc.DiagnosisDocument = 'Y'  
            AND ISNULL(Dc.RecordDeleted, 'N') <> 'Y'
            AND ISNULL(a.RecordDeleted, 'N') <> 'Y'  
    ORDER BY a.EffectiveDate DESC ,  
            a.ModifiedDate DESC                        
    
    IF EXISTS (select 1 from DiagnosesIandII where DocumentVersionId = @varCurrentdocumentVersionId)
     BEGIN
		SET @DSM5DOC = 'N'
     END
     IF EXISTS (select 1 from DocumentDiagnosisCodes where DocumentVersionId = @varCurrentdocumentVersionId)
     BEGIN
		SET @DSM5DOC = 'Y'
	 END
	 
   if(@DSM5DOC = 'N')
   begin
-- Get the Axis I, II, and III DSM and ICD Codes 
   INSERT INTO #DiagnosisTemp (DSMCode ,DSMNumber, DSMDescription, Axis, AxisName, DxId, DiagnosisOrder)                           
    SELECT DISTINCT  
            DSM.DSMCode ,  
            DSM.DSMNumber ,  
            DSM.DSMDescription ,  
            DSM.Axis ,  
            CASE DSM.Axis  
              WHEN 1 THEN 'Axis I'  
              ELSE 'Axis II'  
            END AxisName ,  
            DSMDescription + '_'  
            + RTRIM(LTRIM(ISNULL(CAST(DSM.DSMNumber AS VARCHAR), '0'))) AS DxId ,  
            D.DiagnosisOrder  
    FROM    DiagnosisDSMDescriptions DSM  
            JOIN DiagnosesIandII AS D ON DSM.DSMCODE = D.DSMCODE  
                                         AND ISNULL(D.RecordDeleted, 'N') = 'N'  
                                         AND DSM.DSMNumber = D.DSMNumber  
    WHERE   D.DocumentVersionId = @varCurrentdocumentVersionId  
    UNION  
    SELECT  dx.ICDCode as DSMCode,  
            1 AS DSMNumber ,  
            icd.ICDDescription as DSMDescription,  
            3 AS Axis ,  
            'Axis III' AS AxisName ,  
            --LTRIM(RTRIM(dx.ICDCode)) + '_1' AS DxId ,  
   LTRIM(RTRIM(icd.ICDDescription)) + '_1' AS DxId ,  
            9 AS DiagnosisOrder  
    FROM    DiagnosesIIICodes AS dx  
            JOIN DiagnosisICDCodes AS icd ON icd.ICDCode = dx.ICDCode  
    WHERE   dx.DocumentVersionId = @varCurrentdocumentVersionId  
            AND dx.ICDCode <> '000'  
            AND ISNULL(dx.RecordDeleted, 'N') <> 'Y'             
      end
      else
      begin 
     INSERT INTO #DiagnosisTemp (DSMCode ,DSMNumber, DSMDescription, Axis, AxisName, DxId, DiagnosisOrder)  
     SELECT  DISTINCT  
            D.ICD10CodeId as DSMCode  ,  
            '1' as DSMNumber ,  
            SUBSTRING(CAST(D.ICD10Code AS VARCHAR(10)) + ' - ' + DSM.ICDDescription,0,95) as DSMDescription,
            '10' as Axis ,  
            'ICD10Code' As AxisName ,  
            ICDDescription + '_'  
            + RTRIM(LTRIM(ISNULL(CAST('1' AS VARCHAR), '0'))) AS DxId ,  
            D.DiagnosisOrder  
            FROM  DocumentDiagnosisCodes AS D INNER JOIN                  
       DiagnosisICD10Codes AS DSM ON DSM.ICD10CodeId = D.ICD10CodeId       
 WHERE (D.DocumentVersionId = @varCurrentdocumentVersionId) AND (ISNULL(D.RecordDeleted, 'N') = 'N') 
     end
     
    INSERT INTO #DiagnosisTemp (DSMCode ,DSMNumber, DSMDescription, Axis, AxisName, DxId, DiagnosisOrder)  
    SELECT  DISTINCT    
            CP.ICD10CodeId as DSMCode  ,    
            '1' as DSMNumber ,    
            SUBSTRING(CAST(CP.ICD10Code AS VARCHAR(10)) + ' - ' + DSM.ICDDescription,0,95) as DSMDescription, 
            '10' as Axis ,    
            'ICD10Code' As AxisName ,    
            ICDDescription + '_'    
            + RTRIM(LTRIM(ISNULL(CAST('1' AS VARCHAR), '0'))) AS DxId ,    
            CP.DiagnosisOrder    
            FROM  ClientProblems AS CP INNER JOIN                    
       DiagnosisICD10Codes AS DSM ON DSM.ICD10CodeId = CP.ICD10CodeId         
    WHERE (CP.ClientId = @ClientId) AND (ISNULL(CP.RecordDeleted, 'N') = 'N')  AND (CP.ICD10CodeId NOT IN (SELECT DSMCode FROM #DiagnosisTemp))
    
    
    SELECT * FROM #DiagnosisTemp
    
    DROP TABLE #DiagnosisTemp
                           
    IF ( @@error != 0 ) 
        BEGIN                              
            RAISERROR  ( 'ssp_SCClientMedicationDxpurpose : An error  occured' ,16,1)                                                        
                                                                 
            RETURN(1)                                                              
                                                 
        END


GO


