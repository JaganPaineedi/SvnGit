/****** Object:  StoredProcedure [dbo].[ssp_GetAssociatedDocumentsGridList]    Script Date:19/09/2017 10:26:51 ******/ 
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = 
                  Object_id(N'[dbo].[ssp_GetAssociatedDocumentsGridList]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_GetAssociatedDocumentsGridList]  
go  
/****** Object:  StoredProcedure [dbo].[ssp_GetAssociatedDocumentsGridList] 5457791  Script Date:19/09/2017 10:26:51 ******/ 
SET ansi_nulls ON  
go  
SET quoted_identifier ON  
go  
CREATE PROCEDURE [dbo].[ssp_GetAssociatedDocumentsGridList] @DocumentId INT ,@FromScaned char(2)
AS 
  /**************************************************************   
  Created By   : Chita Ranjan 
  Created Date : 19/09/2017 
  Description  : To get all the associated documents
   Task        : Thresholds-Enhancements #838 . 
  Called From  : ssp_GetAssociatedDocumentsGridList 1364233,'' 
  /*  Date        Author          Description */ 
  /*  19/09/2017        Chita Ranjan          Created    */ 
   
  **************************************************************/ 
  BEGIN 
      BEGIN try 
       If(@FromScaned ='1')
       begin
        SELECT DC.documentname, 
                 S.screenid AS DocumentScreenId, 
                 D.documentid, 
                 D.ClientId, 
                 isnull(C.lastname,'')+', '+isnull(C.firstname,'') as ClientName,
                 D.serviceid 
          FROM   documentcodes DC 
                 JOIN documents D 
                   ON D.documentcodeid = DC.documentcodeid 
                   Join clients C on  C.ClientId = D.ClientId   
                 JOIN screens S 
                   ON S.documentcodeid = DC.documentcodeid 
                 JOIN associatedocuments AD 
                   ON AD.documentid = D.documentid 
                      AND  Ad.NativeImageRecordId = @DocumentId  
          WHERE  Isnull(DC.recorddeleted, 'N') <> 'Y' 
                 AND Isnull(D.recorddeleted, 'N') <> 'Y' 
                 AND Isnull(S.recorddeleted, 'N') <> 'Y' 
                 AND Isnull(AD.recorddeleted, 'N') <> 'Y' 
               end  
                 else
                 begin
					   SELECT DC.documentname, 
								 S.screenid AS DocumentScreenId, 
								 D.documentid, 
								 D.ClientId, 
								  isnull(C.lastname,'')+', '+isnull(C.firstname,'') as ClientName,
								 D.serviceid 
						  FROM   documentcodes DC 
								 JOIN documents D 
								   ON D.documentcodeid = DC.documentcodeid 
								   Join clients C on  C.ClientId = D.ClientId   
								 JOIN screens S 
								   ON S.documentcodeid = DC.documentcodeid 
								 JOIN associatedocuments AD 
								   ON AD.documentid = D.documentid 
									  AND  Ad.NativeDocumentId = @DocumentId   
						  WHERE  Isnull(DC.recorddeleted, 'N') <> 'Y' 
								 AND Isnull(D.recorddeleted, 'N') <> 'Y' 
								 AND Isnull(S.recorddeleted, 'N') <> 'Y' 
								 AND Isnull(AD.recorddeleted, 'N') <> 'Y' 
					   end
      END try  
      BEGIN catch 
          DECLARE @Error VARCHAR(8000)  
          SET @Error= CONVERT(VARCHAR, Error_number()) + '*****' 
                      + CONVERT(VARCHAR(4000), Error_message()) 
                      + '*****' 
                      + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                      'ssp_GetAssociatedDocumentsGridList') 
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