/****** Object:  StoredProcedure [dbo].[ssp_CCRGetProblemListSummary]    Script Date: 06/09/2015 03:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CCRGetProblemListSummary]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ssp_CCRGetProblemListSummary] ( @ClientId INT )
AS /******************************************************************************                                              
**  File: [ssp_CCRGetProblemListSummary]                                          
**  Name: [ssp_CCRGetProblemListSummary]                     
**  Desc:    
**  Return values:                                          
**  Called by:                                               
**  Parameters:                          
**  Auth:  srf
**  Date:  12/13/2011                                         
*******************************************************************************                                              
**  Change History                                              
*******************************************************************************                                              
**  Date:       Author:       Description:                            
**  
**  -------------------------------------------------------------------------            
*******************************************************************************/                                            
  
  
    BEGIN                                                            
                  
        BEGIN TRY   
 
 
 --
 -- Get problem list info
 --

            SELECT  ''PR.'' + CAST(d.DocumentId AS VARCHAR(100)) + ''.'' + CAST(di.DiagnosisId AS VARCHAR(100)) AS CCRDataObjectID,
					CAST(d.DocumentId AS VARCHAR(100)) + ''.'' + CAST(di.DiagnosisId AS VARCHAR(100)) AS ID1_ActorID,
					''Problem ID'' AS ID1_IDType,
					''SmartcareWeb'' AS ID1_Source_ActorID,
					icd.ICDCode AS Code_Value ,
                    icd.ICDDescription AS Description ,
                    ''ICD9-CM'' AS Code_CodingSystem ,
                    CONVERT(VARCHAR(10),d.EffectiveDate, 21) AS ApproximateDateTime ,
                    ''Effective Date'' AS [DateType],
                    CASE WHEN ISNULL(RuleOut, ''N'') = ''Y'' THEN ''Rule Out''
                         WHEN ISNULL(Remission, 0) <> 0
                         THEN ''Remission: '' + gc.CodeName
                         ELSE ''Active''
                    END AS STATUS,
                    ''SmartcareWeb'' AS SLRCGroup_Source_ActorID
            FROM    Documents d
                    JOIN DiagnosesIAndII di ON di.DocumentVersionId = d.CurrentDocumentVersionId
                    JOIN DiagnosisDSMCodes dsm ON dsm.DSMCode = di.DSMCode
                    JOIN DiagnosisICDCodes icd ON icd.ICDCode = dsm.ICDCode
                    LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = di.Remission
            WHERE   d.ClientId = @ClientId
                    AND d.DocumentCodeId IN ( 5 ) -- Diagnosis
                    AND d.Status = 22
                    AND ISNULL(d.RecordDeleted, ''N'') = ''N''
                    AND NOT EXISTS ( SELECT *
                                     FROM   Documents d2
                                     WHERE  d2.ClientId = d.ClientId
                                            AND d2.DocumentCodeId IN ( 5 ) --Diagnosis
                                            AND d2.Status = 22
                                            AND d2.EffectiveDate > d.EffectiveDate
                                            AND ISNULL(d2.RecordDeleted, ''N'') = ''N'' )
		UNION
         SELECT  ''PR.'' + CAST(d.DocumentId AS VARCHAR(100)) + ''.'' + CAST(di.DiagnosesIIICodeId AS VARCHAR(100)) AS CCRDataObjectID,
					CAST(d.DocumentId AS VARCHAR(100)) + ''.'' + CAST(di.DiagnosesIIICodeId AS VARCHAR(100)) AS ID1_ActorID,
					''Problem ID'' AS ID1_IDType,
					''SmartcareWeb'' AS ID1_Source_ActorID,
					di.ICDCode AS Code_Value ,
                    c.ICDDescription AS Description ,
                    ''ICD9-CM'' AS Code_CodingSystem ,
                    CONVERT(VARCHAR(10),d.EffectiveDate, 21) AS ApproximateDateTime ,
                    ''Effective Date'' AS [DateType],
                    ''Active''AS STATUS,
                    ''SmartcareWeb'' AS SLRCGroup_Source_ActorID
            FROM    Documents d
                    JOIN DiagnosesIIICodes di ON di.DocumentVersionId = d.CurrentDocumentVersionId
					Join DiagnosisICDCodes c on c.ICDCode = di.ICDCode
--                    LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = di.Remission
            WHERE   d.ClientId = @ClientId
                    AND d.DocumentCodeId IN ( 5 ) -- Diagnosis
                    AND d.Status = 22
                    AND ISNULL(d.RecordDeleted, ''N'') = ''N''
                    AND NOT EXISTS ( SELECT *
                                     FROM   Documents d2
                                     WHERE  d2.ClientId = d.ClientId
                                            AND d2.DocumentCodeId IN ( 5 ) --Diagnosis
                                            AND d2.Status = 22
                                            AND d2.EffectiveDate > d.EffectiveDate
                                            AND ISNULL(d2.RecordDeleted, ''N'') = ''N'' )                                            
				



              
        END TRY                                                            
                                                                                            
        BEGIN CATCH                
              
            DECLARE @Error VARCHAR(8000)                                                             
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + ''*****''
                + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + ''*****''
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                         ''[ssp_CCRGetProblemListSummary]'') + ''*****''
                + CONVERT(VARCHAR, ERROR_LINE()) + ''*****''
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + ''*****''
                + CONVERT(VARCHAR, ERROR_STATE())
            RAISERROR                                                                                           
 (                                                             
  @Error, -- Message text.                                                                                          
  16, -- Severity.                                                                                          
  1 -- State.                                                                                          
 ) ;                                                                                       
        END CATCH                                      
    END
' 
END
GO
