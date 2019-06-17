/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientHospitalizations]    Script Date: 05/15/2013 18:40:49 ******/ 
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = 
                  Object_id(N'[dbo].[ssp_SCGetClientHospitalizations]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_SCGetClientHospitalizations] 

go 

/****** Object:  StoredProcedure [dbo].[ssp_SCGetClientHospitalizations]    Script Date: 05/15/2013 18:40:49 ******/ 
SET ansi_nulls ON 

go 

SET quoted_identifier ON 

go 

CREATE PROCEDURE [dbo].[ssp_SCGetClientHospitalizations] @ClientId INT 

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- 25.05.2014	Vaibhav Khare		Commiting on DEV environment 
-- =============================================
AS 
  BEGIN 
      BEGIN try 
          -- ClientHospitalizations                      
          SELECT hospitalizationid, 
                 clientid, 
                 prescreendate, 
                 threehourdisposition, 
                 --modified by manjup on 18/mar/2014 - customization bugs #681                                
                 CASE threehourdisposition 
                   WHEN 'N' THEN 'No' 
                   WHEN 'Y' THEN 'Yes' 
                   WHEN 'NR' THEN 'Not Reportable' 
                   ELSE '' 
                 END AS ThreeHourDispositionText, 
                 performedby, 
                 hospitalized, 
                 CASE hospitalized 
                   WHEN 'N' THEN 'No' 
                   WHEN 'Y' THEN 'Yes' 
                   ELSE '' 
                 END AS HospitalizedText, 
                 hospital, 
                 hospitaltext, 
                 admitdate, 
                 dischargedate, 
                 systemsevendayfollowup, 
                 CASE systemsevendayfollowup 
                   WHEN 'N' THEN 'No' 
                   WHEN 'Y' THEN 'Yes' 
                   ELSE '' 
                 END AS SystemSevenDayFollowUpText, 
                 sevendayfollowup, 
                 CASE sevendayfollowup 
                   WHEN 'N' THEN 'No' 
                   WHEN 'Y' THEN 'Yes' 
                   ELSE '' 
                 END AS SevenDayFollowUpText, 
                 dxcriteriamet, 
                 CASE dxcriteriamet 
                   WHEN 'N' THEN 'No' 
                   WHEN 'Y' THEN 'Yes' 
                   ELSE '' 
                 END AS DxCriteriaMetText, 
                 cancellationornoshow, 
                 CASE cancellationornoshow 
                   WHEN 'N' THEN 'No' 
                   WHEN 'Y' THEN 'Yes' 
                   ELSE '' 
                 END AS CancellationOrNoShowText, 
                 clientrefusedservice, 
                 followupexception, 
                 followupexceptionreason, 
                 comment, 
                 clientwastransferred, 
                 CASE clientwastransferred 
                   WHEN 'N' THEN 'No' 
                   WHEN 'Y' THEN 'Yes' 
                   ELSE '' 
                 END AS ClientWasTransferredText, 
                 declinedservicesreason, 
                 rowidentifier, 
                 externalreferenceid, 
                 createdby, 
                 createddate, 
                 modifiedby, 
                 clientcmhsppihpservices, 
                 modifieddate, 
                 recorddeleted, 
                 deleteddate, 
                 deletedby 
          FROM   clienthospitalizations 
                 LEFT OUTER JOIN (SELECT s.siteid, 
                                         CASE 
                                           WHEN Isnull(s.sitename, '') = '' THEN 
                                           Rtrim(p.providername) 
                                           ELSE Rtrim(p.providername) + ' - ' 
                                                + Ltrim(s.sitename) 
                                         END AS HospitalText 
                                  FROM   providers p 
                                         LEFT OUTER JOIN sites s 
                                                      ON 
                                         p.providerid = s.providerid 
                                         AND 
                                         Isnull(s.recorddeleted, 'N') = 'N') 
                                           AS Hospital 
                              ON 
clienthospitalizations.hospital = Hospital.siteid 
          WHERE  ( clientid = @ClientID ) 
                 AND ( recorddeleted IS NULL 
                        OR recorddeleted = 'N' ) 
      END try 

      BEGIN catch 
          DECLARE @Error VARCHAR(8000) 

          SET @Error= CONVERT(VARCHAR, Error_number()) + '*****' 
                      + CONVERT(VARCHAR(4000), Error_message()) 
                      + '*****' 
                      + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                      'ssp_SCGetClientHospitalizations') 
                      + '*****' + CONVERT(VARCHAR, Error_line()) 
                      + '*****' + CONVERT(VARCHAR, Error_severity()) 
                      + '*****' + CONVERT(VARCHAR, Error_state()) 

          RAISERROR ( @Error, 
                      -- Message text.                                                                                    
                      16, 
                      -- Severity.                                                                                    
                      1 
          -- State.                                                                                     
          ); 
      END catch 
  END 

go 