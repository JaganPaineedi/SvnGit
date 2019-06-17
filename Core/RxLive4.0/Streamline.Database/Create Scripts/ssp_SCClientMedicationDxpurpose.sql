/****** Object:  StoredProcedure [ssp_SCClientMedicationDxpurpose]    Script Date: 12/11/2012 3:59:52 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ssp_SCClientMedicationDxpurpose]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ssp_SCClientMedicationDxpurpose]
GO

/****** Object:  StoredProcedure [ssp_SCClientMedicationDxpurpose]    Script Date: 12/11/2012 3:59:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ssp_SCClientMedicationDxpurpose]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [ssp_SCClientMedicationDxpurpose] ( @ClientId INT )
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
/************************************************************************/                                                           
  
    DECLARE @varCurrentdocumentVersionId INT      
                    
-- Get the most recently signed diagnosis document  
    SELECT TOP 1
            @varCurrentdocumentVersionId = a.CurrentDocumentVersionId
    FROM    Documents a
    WHERE   a.ClientId = @ClientId
            AND a.EffectiveDate <= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101))
            AND a.Status = 22
            -- Modified by Malathi Shiva, included DocumentCodeId = 1042 which points to the new diagnosis
            AND a.DocumentCodeId in (5,1042)
            AND ISNULL(a.RecordDeleted, ''N'') <> ''Y''
    ORDER BY a.EffectiveDate DESC ,
            a.ModifiedDate DESC                      
  
-- Get the Axis I, II, and III DSM and ICD Codes                        
    SELECT DISTINCT
            DSM.DSMCode ,
            DSM.DSMNumber ,
            DSM.DSMDescription ,
            DSM.Axis ,
            CASE DSM.Axis
              WHEN 1 THEN ''Axis I''
              ELSE ''Axis II''
            END AxisName ,
            DSMDescription + ''_''
            + RTRIM(LTRIM(ISNULL(CAST(DSM.DSMNumber AS VARCHAR), ''0''))) AS DxId ,
            D.DiagnosisOrder
    FROM    DiagnosisDSMDescriptions DSM
            JOIN DiagnosesIandII AS D ON DSM.DSMCODE = D.DSMCODE
                                         AND ISNULL(D.RecordDeleted, ''N'') = ''N''
                                         AND DSM.DSMNumber = D.DSMNumber
    WHERE   D.DocumentVersionId = @varCurrentdocumentVersionId
    UNION
    SELECT  dx.ICDCode ,
            1 AS DSMNumber ,
            icd.ICDDescription ,
            3 AS Axis ,
            ''Axis III'' AS AxisName ,
            --LTRIM(RTRIM(dx.ICDCode)) + ''_1'' AS DxId ,
			LTRIM(RTRIM(icd.ICDDescription)) + ''_1'' AS DxId ,
            9 AS DiagnosisOrder
    FROM    DiagnosesIIICodes AS dx
            JOIN DiagnosisICDCodes AS icd ON icd.ICDCode = dx.ICDCode
    WHERE   dx.DocumentVersionId = @varCurrentdocumentVersionId
            AND dx.ICDCode <> ''000''
            AND ISNULL(dx.RecordDeleted, ''N'') <> ''Y''    
              
 -- Modified by Malathi Shiva, below Union is added  
    UNION 
      SELECT  DISTINCT
            D.DSMVCodeId   ,
            ''1'' as DSMNumber ,
            DSM.DSMDescription ,
            ''10'' as Axis ,
            ''ICD10Code'' As AxisName ,
            DSMDescription + ''_''
            + RTRIM(LTRIM(ISNULL(CAST(''1'' AS VARCHAR), ''0''))) AS DxId ,
            D.DiagnosisOrder
            FROM  DocumentDiagnosisCodes AS D INNER JOIN                
       DiagnosisDSMVCodes AS DSM ON DSM.DSMVCodeId = D.DSMVCodeId       
 WHERE (D.DocumentVersionId = @varCurrentdocumentVersionId) AND (ISNULL(D.RecordDeleted, ''N'') = ''N'')               
                           
    IF ( @@error != 0 ) 
        BEGIN                              
            RAISERROR  20002 ''ssp_SCClientMedicationDxpurpose : An error  occured''                                                              
                                                                 
            RETURN(1)                                                              
                                                 
        END
' 
END
GO


