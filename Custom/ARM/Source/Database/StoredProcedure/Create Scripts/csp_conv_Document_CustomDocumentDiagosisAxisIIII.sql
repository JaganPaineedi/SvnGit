/****** Object:  StoredProcedure [dbo].[csp_conv_Document_CustomDocumentDiagosisAxisIIII]    Script Date: 06/19/2013 17:49:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Document_CustomDocumentDiagosisAxisIIII]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_conv_Document_CustomDocumentDiagosisAxisIIII]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_conv_Document_CustomDocumentDiagosisAxisIIII]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
  
CREATE PROCEDURE [dbo].[csp_conv_Document_CustomDocumentDiagosisAxisIIII]
AS 
    INSERT  INTO CustomDocumentDiagosisAxisIIII
            ( DocumentVersionId ,
              DSMCode ,
              DSMNumber ,
              DiagnosisType ,
              DiagnosisVersion ,
              AxisType ,
              Severity ,
              RuleOut ,
              IsBillable ,
              SequenceNumber ,
              Specifier
            )
            SELECT  dvm.DocumentVersionId ,
                    d.dsm_code , -- dsm_code - char(10)
                    d.dsm_no , -- dsm_no - smallint
                    d.diag_type ,  -- diag_type - char(1)
                    d.diagnosis_version , -- diagnosis_version - char(10)
                    d.axis_type , -- axis_type - smallint
                    d.severity , -- severity - smallint
                    d.rule_out , -- rule_out - UD_N_For_No
                    d.is_billable , -- is_billable - UD_N_For_No
                    d.sequence_no ,-- sequence_no - tinyint
                    b.dsm_desc -- specifier - varchar(500)
            FROM    Psych..Doc_Diag_Axis_I_III d
                    LEFT OUTER JOIN Psych..DSM_Desc b ON ( d.dsm_code = b.dsm_code )
                                                         AND ( d.dsm_no = b.dsm_no )
                    left JOIN Cstm_Conv_Map_DocumentVersions dvm ON dvm.doc_session_no = d.doc_session_no
                                                              AND dvm.version_no = d.version_no
            WHERE   ( d.axis_type = 1
                      OR d.axis_type = 2
                    )
                    AND NOT EXISTS ( SELECT *
                                     FROM   CustomDocumentDiagosisAxisIIII c
                                     WHERE  c.DocumentVersionId = ISNULL(dvm.DocumentVersionId,
                                                              -1) )
            UNION
            SELECT  dvm.DocumentVersionId ,
                    sd.dsm_code ,
                    sd.dsm_no ,
                    sd.diag_type ,
                    sd.diagnosis_version ,
                    sd.axis_type ,
                    sd.severity ,
                    sd.rule_out ,
                    sd.is_billable ,
                    sd.sequence_no ,
                    ICD.icd_desc
            FROM    Psych..Doc_Diag_Axis_I_III sd
                    JOIN Psych..ICD ON ( ICD.icd_code = sd.dsm_code )
                    left JOIN Cstm_Conv_Map_DocumentVersions dvm ON dvm.doc_session_no = sd.doc_session_no
                                                              AND dvm.version_no = sd.version_no
            WHERE   ( sd.axis_type = 3 )
                    AND NOT EXISTS ( SELECT *
                                     FROM   CustomDocumentDiagosisAxisIIII c
                                     WHERE  c.DocumentVersionId = ISNULL(dvm.DocumentVersionId,
                                                              -1) )
            UNION
            SELECT  dvm.DocumentVersionId ,
                    '''' ,
                    '''' ,
                    '''' ,
                    '''' ,
                    ''4'' ,
                    '''' ,
                    '''' ,
                    d.is_billable ,
                    d.sequence_no ,
                    RTRIM(z.category_name) + '' - '' + LTRIM(d.specification)
            FROM    Psych..Doc_Diag_Axis_IV d
                    LEFT OUTER JOIN Psych..Axis_IV_Category z ON d.category_id = z.category_id
                    left JOIN Cstm_Conv_Map_DocumentVersions dvm ON dvm.doc_session_no = d.doc_session_no
                                                              AND dvm.version_no = d.version_no
            WHERE   NOT EXISTS ( SELECT *
                                 FROM   CustomDocumentDiagosisAxisIIII c
                                 WHERE  c.DocumentVersionId = ISNULL(dvm.DocumentVersionId,
                                                              -1) )
            UNION
            SELECT  dvm.DocumentVersionId ,
                    ''Score# '' + CONVERT(VARCHAR, d.level_no) ,
                    '''' ,
                    '''' ,
                    '''' ,
                    ''5'' ,
                    '''' ,
                    '''' ,
                    d.is_billable ,
                    d.sequence_no ,
                    CASE d.axis_v_type
                      WHEN ''CU'' THEN ''Current''
                      WHEN ''NA'' THEN ''On Admission''
                      WHEN ''AD'' THEN ''At Discharge''
                      WHEN ''HL'' THEN ''Highest Level Past Year''
                    END
            FROM    Psych..Doc_Diag_Axis_V d
                    left JOIN Cstm_Conv_Map_DocumentVersions dvm ON dvm.doc_session_no = d.doc_session_no
                                                              AND dvm.version_no = d.version_no
            WHERE   NOT EXISTS ( SELECT *
                                 FROM   CustomDocumentDiagosisAxisIIII c
                                 WHERE  c.DocumentVersionId = ISNULL(dvm.DocumentVersionId,
                                                              -1) )   
    IF @@error <> 0 
        GOTO error

    RETURN

    error:

    RAISERROR 5010 ''Failed to execute csp_conv_Document_CustomDocumentDiagosisAxisIIII''



' 
END
GO
