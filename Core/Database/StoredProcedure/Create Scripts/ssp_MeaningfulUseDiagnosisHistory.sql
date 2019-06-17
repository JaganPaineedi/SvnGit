/****** Object:  StoredProcedure [dbo].[ssp_MeaningfulUseDiagnosisHistory]    Script Date: 01/22/2015 13:54:29 ******/
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_MeaningfulUseDiagnosisHistory]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].[ssp_MeaningfulUseDiagnosisHistory]
GO


/****** Object:  StoredProcedure [dbo].[ssp_MeaningfulUseDiagnosisHistory] NULL,NULL,93460    Script Date: 01/22/2015 13:54:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[ssp_MeaningfulUseDiagnosisHistory]
    (
      @StartDate DATETIME ,
      @EndDate DATETIME ,
      @ClientId INT
    )
/********************************************************************************                                                      
-- Stored Procedure: ssp_MeaningfulUseDiagnosisHistory    
-- File      : ssp_MeaningfulUseDiagnosisHistory.sql    
-- Copyright: Streamline Healthcate Solutions    
--    
-- Purpose: Procedure to return data for the Client Problems list page.    
--    
-- Date				Author    Purpose    
-- 30/july/2017		Gautam    Added code to display correct Diagnosis end date, MU Stage3 , MeaningfulUseStage3 #5.1    
-- 23 Aug 2017		Varun	  Updating SnomedCode if NULL
*********************************************************************************/       
AS
    BEGIN
			  
create table #ClientDiag
(ClientId Int,
ClientName varchar(150),
EffectiveDate datetime,
StartDate date,
EndDate date,
ICD9Code varchar(20),
Remission int,
ICD9Desc varchar(max),
ICD10Code varchar(20),
ICD10Desc varchar(max),
SNOMEDCodeICD9 varchar(max),
SNOMEDCodeICD10 varchar(20),
SNOMEDCTDescription  varchar(max),
ACTIVE  varchar(1),
DiagnosisType varchar(250)
)


Insert Into #ClientDiag
(ClientId ,ClientName ,EffectiveDate ,ICD9Code ,Remission ,ICD9Desc ,ICD10Code ,ICD10Desc ,SNOMEDCodeICD9,
SNOMEDCodeICD10 ,SNOMEDCTDescription  ,ACTIVE ,EndDate ,DiagnosisType)  
SELECT DISTINCT a.ClientId  
    ,(a.FirstName + ' ' + a.LastName) AS ClientName  
    ,b.EffectiveDate  
    ,  
    -- ds.SignatureDate , -- b.EffectiveDate AS SignatureDate ,  
    c.ICD9Code  
    ,c.Remission  
    ,REPLACE((  
      SELECT DISTINCT ICD9Codes.ICDDescription + CHAR(13) + CHAR(10)  
      FROM dbo.DiagnosisICDCodes ICD9Codes  
      WHERE ICD9Codes.ICDCode = c.ICD9Code  
      FOR XML PATH('')  
      ), '&#x0D;', CHAR(13) + CHAR(10)) AS ICD9Desc  
    ,c.ICD10Code  
    ,icd10.ICDDescription AS ICD10Desc  
    ,REPLACE((  
      SELECT DISTINCT e.SNOMEDCTCode + CHAR(13) + CHAR(10)  
      FROM dbo.ICD9SNOMEDCTMapping d  
      INNER JOIN dbo.SNOMEDCTCodes e ON e.SNOMEDCTCodeId = d.SNOMEDCTCodeId  
      WHERE d.ICD9Code = c.ICD9Code  
      FOR XML PATH('')  
      ), '&#x0D;', '  ') AS SNOMEDCodeICD9  
    ,  
    --e.SNOMEDCTDescription AS SNOMEDDescICD9 ,  
    c.SNOMEDCODE AS SNOMEDCodeICD10  
    ,s.SNOMEDCTDescription  
    ,'Y' AS ACTIVE  
    ,'12/31/2199' AS EndDate  
    ,gc.codename AS DiagnosisType  
   FROM Clients a  
   INNER JOIN Documents b ON b.ClientId = a.ClientId  
    AND ISNULL(a.RecordDeleted, 'N') = 'N'  
    AND ISNULL(b.RecordDeleted, 'N') = 'N'  
   INNER JOIN dbo.DocumentVersions dv ON dv.DocumentId = b.DocumentId  
    AND ISNULL(dv.RecordDeleted, 'N') = 'N'  
   INNER JOIN dbo.DocumentDiagnosis dd ON dd.DocumentVersionId = dv.DocumentVersionId  
    AND ISNULL(dd.RecordDeleted, 'N') = 'N'  
   INNER JOIN dbo.DocumentDiagnosisCodes c ON c.DocumentVersionId = b.CurrentDocumentVersionId  
    AND ISNULL(c.RecordDeleted, 'N') = 'N'  
   INNER JOIN dbo.DocumentSignatures ds ON ds.SignedDocumentVersionId = dv.DocumentVersionId  
    AND ISNULL(ds.RecordDeleted, 'N') = 'N'  
   LEFT JOIN dbo.SNOMEDCTCodes s ON s.SNOMEDCTCode = c.SNOMEDCODE  
   INNER JOIN dbo.DiagnosisICD10Codes icd10 ON icd10.ICD10Code = c.ICD10Code  
    AND icd10.ICD10CodeId = c.ICD10CodeId  
   INNER JOIN GlobalCodes gc on c.DiagnosisType=gc.globalcodeid  
       AND ISNULL(gc.RecordDeleted, 'N') = 'N'   
   WHERE b.STATUS = 22  
    AND b.DocumentCodeId = 1601  
    AND a.ClientId = @ClientId  
    --AND CAST(b.EffectiveDate AS DATE) >= CAST(ISNULL(@StartDate, '12/31/1901') AS DATE)  
    -- AND CAST(b.EffectiveDate AS DATE) <=CAST(ISNULL(@EndDate, '12/31/2199') AS DATE)  


-- update Startdate 
Update c
set c.StartDate=cd.StartDate
From #ClientDiag c join (Select MIN(CAST(c.EffectiveDate as date)) as StartDate,c.ICD10Code
							From #ClientDiag c
							Group by c.ICD10Code) cd on c.ICD10Code=cd.ICD10Code

Update c
set c.EndDate= (Select top 1 dateadd(d,-1,c1.StartDate) From  #ClientDiag c1 where  c1.StartDate>cd.EndDate order by c1.StartDate asc)
From #ClientDiag c join 
 (select CD1.ICD10Code,max(CD1.EffectiveDate) as EndDate From  #ClientDiag CD1 
							where not exists(Select 1 from #ClientDiag CD2 where CD1.ICD10Code=CD2.ICD10Code 
													and CD1.EffectiveDate < CD2.EffectiveDate)
								and exists(Select 1 from #ClientDiag CD3 where CD1.ICD10Code <> CD3.ICD10Code 
													and CD1.EffectiveDate < CD3.EffectiveDate)																					
	group by CD1.ICD10Code	) CD on c.ICD10Code=cd.ICD10Code
  
  
 UPDATE CD set CD.SNOMEDCodeICD10= (SELECT DISTINCT TOP 1 S.SNOMEDCTCode   
      FROM dbo.ICD10SNOMEDCTMapping ICDMapping  
      INNER JOIN dbo.SNOMEDCTCodes S ON S.SNOMEDCTCodeId = ICDMapping.SNOMEDCTCodeId 
	  INNER JOIN Documents b ON b.ClientId = @ClientId AND b.DocumentCodeId = 1601  AND b.STATUS = 22  
	   INNER JOIN dbo.DocumentDiagnosisCodes c ON c.DocumentVersionId = b.CurrentDocumentVersionId  
    AND ISNULL(b.RecordDeleted, 'N') = 'N'  
    AND ISNULL(c.RecordDeleted, 'N') = 'N' 
      WHERE ICDMapping.ICD10CodeId = c.ICD10Code )
       From #ClientDiag CD where CD.SNOMEDCodeICD10 IS NULL
  
         SELECT  b.StartDate ,  
            Replace(b.EndDate,'12/31/2199',NULL) as EndDate,  
			b.ICD9Code AS DSMCode,  
			b.ICD10Code,  
			b.SNOMEDCodeICD10 AS SNOMEDCODE,  
            b.ICD10Desc AS DSMDescription,  
			b.DiagnosisType  
        FROM    #ClientDiag b  
         where CAST(b.EffectiveDate AS DATE) >= CAST(ISNULL(@StartDate, '12/31/1901') AS DATE)  
     AND CAST(b.EffectiveDate AS DATE) <=CAST(ISNULL(@EndDate, '12/31/2199') AS DATE)  
          
          
  
    END  
        




GO


