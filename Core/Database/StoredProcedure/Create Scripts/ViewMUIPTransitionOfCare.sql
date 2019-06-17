

/****** Object:  View [dbo].[ViewMUIPTransitionOfCare]    Script Date: 04/11/2018 19:12:19 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ViewMUIPTransitionOfCare]'))
DROP VIEW [dbo].[ViewMUIPTransitionOfCare]
GO



/****** Object:  View [dbo].[ViewMUIPTransitionOfCare]    Script Date: 04/11/2018 19:12:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE VIEW [dbo].[ViewMUIPTransitionOfCare]  
AS  
/********************************************************************************                  
-- View: dbo.ViewClientServices                    
--                  
-- Copyright: Streamline Healthcate Solutions                  
--                  
-- Purpose: returns all Client IP visits            
-- Updates:                                                                         
-- Date        Author      Purpose                  
-- 21.10.2017  Gautam     Created.   Why:Meaningful Use - Stage 3 > Tasks #46 > Stage 3 Reports                     
*********************************************************************************/  
SELECT DISTINCT S.ClientId  
 ,(IsNull(S1.LastName, '') + coalesce(' , ' + S1.FirstName, '')) AS ProviderName  
 ,CONVERT(VARCHAR, D.EffectiveDate, 101) AS ExportedDate  
 ,case when T.DisclosureStatus = 10573 then CONVERT(VARCHAR, T.DisclosureDate, 101) else null end AS EffectiveDate   
 ,ISNULL(D.InProgressDocumentVersionId, 0) AS CurrentDocumentVersionId  
 ,cast(S.AdmitDate AS DATE) AS AdmitDate  
 ,S.ClinicianId  
 ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName  
 ,S.DischargedDate  
 ,D.DocumentId  
 ,T.DisclosureStatus
FROM ClientInpatientVisits S  
INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType  
INNER JOIN ClientDisclosures T ON T.ClientId = s.ClientId  
INNER JOIN ClientDisclosedRecords CD ON T.ClientDisclosureId = CD.ClientDisclosureId  
JOIN Documents D ON D.DocumentId = CD.DocumentId  
 --AND T.ExportedDate IS NOT NULL                          
 AND isnull(T.RecordDeleted, 'N') = 'N'  
INNER JOIN Clients C ON S.ClientId = C.ClientId  
 AND isnull(C.RecordDeleted, 'N') = 'N'  
LEFT JOIN Staff S1 ON S1.StaffId = C.PrimaryClinicianId  
WHERE D.DocumentCodeId IN (  
  1611  
  ,1644  
  ,1645  
  ,1646  
  ) -- Summary of Care                               
 AND isnull(D.RecordDeleted, 'N') = 'N'  
  AND isnull(S.RecordDeleted, 'N') = 'N'  
 AND d.STATUS = 22  
 --  INNER JOIN ClientDisclosedRecords CD On CD.DocumentId = D.DocumentId  AND isnull(CD.RecordDeleted, 'N') = 'N'       
 --INNER Join ClientDisclosures CDS On CDS.ClientDisclosureId= CD.ClientDisclosureId AND isnull(CDS.RecordDeleted, 'N') = 'N'       
 ----          and CDS.DisclosureType in (5525,5526,5527,11127069,6641) -- Email(5525), Secure mail(5526), Electronic media(5527), Patient portal, Direct message      
GO


