/****** Object:  StoredProcedure [dbo].[SSP_GetAssociatedDocumentsByDocumentId]    Script Date:19/09/2017 10:26:51 ******/ 
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = 
                  Object_id(N'[dbo].[SSP_GetAssociatedDocumentsByDocumentId]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[SSP_GetAssociatedDocumentsByDocumentId]  
go  
/****** Object:  StoredProcedure [dbo].[SSP_GetAssociatedDocumentsByDocumentId] 5457791  Script Date:19/09/2017 10:26:51 ******/ 
SET ansi_nulls ON  
go  
SET quoted_identifier ON  
go  
CREATE PROCEDURE [dbo].[SSP_GetAssociatedDocumentsByDocumentId] @DocumentId INT 
AS 
  /**************************************************************   
  Created By   : Chita Ranjan 
  Created Date : 19/09/2017 
  Description  : To get all the associated documents
   Task        : Thresholds-Enhancements #838 . 
  Called From  : SSP_GetAssociatedDocumentsByDocumentId 411,5763 
  /*  Date        Author          Description */ 
  /*  19/09/2017        Chita Ranjan          Created    */ 
   
  **************************************************************/ 
  BEGIN 
      BEGIN try 
          SELECT DC.documentname, 
                 S.screenid AS DocumentScreenId, 
                 D.documentid, 
                 D.serviceid 
          FROM   documentcodes DC 
                 JOIN documents D 
                   ON D.documentcodeid = DC.documentcodeid 
                 JOIN screens S 
                   ON S.documentcodeid = DC.documentcodeid 
                 JOIN associatedocuments AD 
                   ON AD.documentid = D.documentid 
                      AND Ad.nativedocumentid = @DocumentId 
          WHERE  Isnull(DC.recorddeleted, 'N') <> 'Y' 
                 AND Isnull(D.recorddeleted, 'N') <> 'Y' 
                 AND Isnull(S.recorddeleted, 'N') <> 'Y' 
                 AND Isnull(AD.recorddeleted, 'N') <> 'Y' 
      END try  
      BEGIN catch 
          DECLARE @Error VARCHAR(8000)  
          SET @Error= CONVERT(VARCHAR, Error_number()) + '*****' 
                      + CONVERT(VARCHAR(4000), Error_message()) 
                      + '*****' 
                      + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                      'SSP_GetAssociatedDocumentsByDocumentId') 
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