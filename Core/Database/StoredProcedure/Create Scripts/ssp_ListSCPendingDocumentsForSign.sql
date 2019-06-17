/****** Object:  StoredProcedure [dbo].[ssp_ListSCPendingDocumentsForSign]    Script Date: 09/02/2013 16:56:13 ******/ 
IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = 
                  OBJECT_ID(N'[dbo].[ssp_ListSCPendingDocumentsForSign]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_ListSCPendingDocumentsForSign] 

go 

/****** Object:  StoredProcedure [dbo].[ssp_ListSCPendingDocumentsForSign]    Script Date: 09/02/2013 16:56:13 ******/ 
SET ansi_nulls ON 

go 

SET quoted_identifier ON 

go 

CREATE PROCEDURE [dbo].[ssp_ListSCPendingDocumentsForSign] @Status     varchar(max), 
                                                           @MaxRecords INT=NULL, 
                                                           @StaffId    INT,
                                                           @SortExpression VARCHAR(100)=null 
AS 
/*********************************************************************/ 
/* Stored Procedure: dbo.ssp_ListSCPendingDocumentsForSign  'TOBEREVIEWED',100,2394,null        */ 
/* Creation Date: 09/02/2013                                           */ 
/*                                                                     */ 
/* Purpose: To display all documents where the user has to Sign or 
        Cosign a document 
                                   */ 
/*   Exec [ssp_ListSCPendingDocumentsForSign] 'TOACKNOWLEDGE',10,590,'Effective Desc'                                                               */ 
/* Input Parameters: @ClientId               */ 
/*                                                                   */ 
/* Output Parameters:                         */ 
/*                                                                   */ 
/*  Date                 Author                 Purpose             */ 
/* 2nd Sep 2013			Gautam					Created             */ 
/* 18th Oct 2013		Praveen Potnuru			Modified              */ 
/* 02nd Apr 2015		MD Hussain			    Modified to not pull documents not ready to sign w.r.t task #1747 Core Bugs*/ 
/* 27th Oct 2015		Chethan N				What : Excluding documents from signing ('To-Sign' status) which are marked to Exclude in the DocumentCodes.ExcludeFromBatchSigning 
												Why : Engineering Improvement Initiatives- NBL(I)  task# 225	*/
												
/*20th 	july 2017       Prem                    Added Three more statuses 'To Be Reviewed','To Acknowledge','In Progress' as part of Harbor Enhancements #821 */											
/*26th Nov 2018         Jyothi                  Added Author and Author Sorting as part of Harbor Enhancements #22 */
 
  /*********************************************************************/ 
  BEGIN 
      BEGIN try 	
          IF @MaxRecords IS NULL 
            BEGIN 
                SET @MaxRecords=100 
            END 
		
		 IF Isnull(@SortExpression, '') = '' 
            BEGIN 
                SET @SortExpression='Effective DESC' 
            END 
          CREATE TABLE #documentlist 
            ( 
               DocumentId INT, 
               ClientId   INT 
            ) 

          CREATE TABLE #tocosign 
            ( 
               DocumentId INT 
            ) 
			
			CREATE TABLE #DisplayList 
            ( 
               DocumentVersionId INT,
               Name Varchar(130),
               Effective date,
               Document Varchar(250),
               [Status] Varchar(25),
               DocumentId int,
               DocumentCodeId int,
               CurrentVersionStatus int,  
               ClientId   INT ,
               Author Varchar(100),
               DocumentType int,
               ServiceId int,
               DocumentScreenId int,
               [Version] int,
               ErrorFlag char(1) 
            ) 
            
          -- @Status = TOSIGN         'To Sign' --Added by Prem on 26/07/2017 
          -- @Status = TOCOSIGN       'To Cosign' 
          -- @Status = INPROGRESS     'In Progress'
          -- @Status = TOBEREVIEWED   'To Be Reviewed'
          -- @Status = TOACKNOWLEDGE  'To Acknowledge' 
          -- Get all the documents need to be co-signed                 
          IF(@Status='TOCOSIGN') --Added by Prem on 26/07/2017 
          BEGIN
          INSERT INTO #tocosign 
                      (DocumentId) 
          SELECT DISTINCT d.DocumentId 
          FROM   DocumentSignatures dss WITH (NOLOCK)
                 JOIN Documents d WITH (NOLOCK)
                   ON d.DocumentId = dss.DocumentId 
                      AND ISNULL(dss.RecordDeleted, 'N') = 'N' 
                      AND ISNULL(d.RecordDeleted, 'N') = 'N' 
          WHERE   
                  dss.StaffId = @StaffId 
                 AND ( dss.StaffId <> d.AuthorId ) 
                 AND ( dss.StaffId <> ISNULL(d.ReviewerId, 0) ) 
                 AND dss.SignatureDate IS NULL 
                 AND ISNULL(dss.DeclinedSignature, 'N') = 'N' 
                 AND d.CurrentVersionStatus = 22
           END
          -- Get all the documents for To Sign  
          IF(@Status='TOSIGN') --Added by Prem on 26/07/2017 
          BEGIN
          INSERT INTO #documentlist 
                      (DocumentId, 
                       ClientId) 
          SELECT DISTINCT d.DocumentId, 
                          d.ClientId 
          FROM   Documents d WITH (NOLOCK)
          JOIN DocumentCodes DC ON DC.DocumentCodeId = d.DocumentCodeId
          WHERE  
                 (d.AuthorId = @StaffId or d.ProxyId = @StaffId)
                 and d.CurrentVersionStatus = 21  
                 and isnull(d.ToSign, 'N')='Y' --Added by MD Hussain on 04/02/2015            
				 and isnull(d.RecordDeleted, 'N') = 'N'
				 AND ISNULL(DC.ExcludeFromBatchSigning,'N') = 'N' -- Chethan Changes -- Exclude documentcodes which are marked has DocumentCodes.ExcludeFromBatchSigning = 'Y'
				 
		  END
          -- To CoSign                 
          -- Get all the documents for To Cosign  
          
          IF(@Status='TOCOSIGN') --Added by Prem on 26/07/2017       
          BEGIN
          INSERT INTO #documentlist 
                      (DocumentId, 
                       ClientId) 
          SELECT DISTINCT d.DocumentId, 
                          d.ClientId 
          FROM   Documents d WITH (NOLOCK)
                 JOIN #tocosign tcs 
                   ON tcs.DocumentId = d.DocumentId 
          WHERE   isnull(d.RecordDeleted, 'N') = 'N' 
          END
      ----Start    
          
          
         --In Progress
         --Get all the documents for In Progress
         IF(@Status='INPROGRESS') --Added by Prem on 26/07/2017 
          begin
         INSERT INTO #documentlist 
                      (DocumentId, 
                       ClientId) 
         SELECT DISTINCT d.Documentid 
                         ,d.Clientid 
           FROM   DOCUMENTS d 
           WHERE  ( d.Authorid = @StaffId 
          OR d.Proxyid = @StaffId ) 
       AND d.Currentversionstatus = 21 
       AND Isnull(d.Recorddeleted, 'N') = 'N' 
                
         end
         --To Be Reviewed
         --Get All the Documents for To Be Reviewed
          IF(@Status='TOBEREVIEWED') --Added by Prem on 26/07/2017 
          begin
          INSERT INTO #documentlist 
                      (DocumentId, 
                       ClientId) 
            SELECT DISTINCT d.Documentid 
                           ,d.Clientid 
            FROM   DOCUMENTS d 
            WHERE  ( d.Authorid = @StaffId 
          OR d.Proxyid = @StaffId 
          OR d.Reviewerid = @StaffId ) 
       AND d.Currentversionstatus = 25 
       
       AND Isnull(d.Recorddeleted, 'N') = 'N'           
         END
         
         --To Acknowledge
         --Get All the Documents for To Acknowledge
         
          IF(@Status='TOACKNOWLEDGE') --Added by Prem on 26/07/2017 
          BEGIN
          INSERT INTO #documentlist 
                      (Documentid 
                      ,Clientid) 
          SELECT DISTINCT da.Documentid 
                         ,d.Clientid 
           FROM   DOCUMENTSACKNOWLEDGEMENTS da 
       JOIN DOCUMENTS d 
         ON da.Documentid = d.Documentid 
            AND da.Dateacknowledged IS NULL 
            AND Isnull(d.Recorddeleted, 'N') = 'N' 
            AND da.Acknowledgedbystaffid = @StaffId            
           END    
       --END  
          SET ROWCOUNT @MaxRecords 
                  
          Insert Into #DisplayList
		  SELECT D.CurrentDocumentVersionId                 AS 
                  DocumentVersionId, 
                  CASE 
						WHEN ISNULL(C.ClientType, 'I') = 'I'
						 THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
						ELSE ISNULL(C.OrganizationName, '')
						END AS Name,
                  --C.LastName + ', ' + C.FirstName            AS Name, 
                  CONVERT(VARCHAR(10), D.EffectiveDate, 101) AS 
                  Effective, 
                  DC.DocumentName                            AS Document 
                  , 
                  CASE 
                    WHEN @Status= 'TOSIGN'        THEN  'To Sign' 
                    WHEN @Status= 'TOCOSIGN'      THEN  'To Cosign'
                    WHEN @Status= 'INPROGRESS'    THEN  'In Progress'
                    WHEN @Status= 'TOBEREVIEWED'  THEN  'To Be Reviewed'
                    WHEN @Status= 'TOACKNOWLEDGE' THEN  'To Acknowledge'
                  END                                        AS 'Status' 
                 --  gcs.CodeName    AS 'Status' 
                  , 
                  d.DocumentId as DocumentId,
                  d.DocumentCodeId as DocumentCodeId,
                  d.CurrentVersionStatus as CurrentVersionStatus,
                  c.ClientId as ClientId,
                  ISNULL(st.LastName, '') + ', ' + ISNULL(st.FirstName, '') AS Author,
                  dc.DocumentType,
                  d.ServiceId,
                  sr.ScreenId as DocumentScreenId,
                  DV.Version as 'Version',
                  'N' 
                  AS 
                  'ErrorFlag' 
          FROM   Documents d WITH (NOLOCK)
                 Join #documentlist md 
                   ON md.DocumentId = d.DocumentId 
                   And ISNULL(d.RecordDeleted, 'N') = 'N'
                 JOIN Clients c WITH (NOLOCK)
                   ON c.ClientId = d.ClientId 
                 JOIN StaffClients sc 
                   ON sc.StaffId = @StaffId 
                      AND sc.ClientId = c.ClientId 
                 JOIN DocumentCodes dc 
                   ON dc.DocumentCodeId = d.DocumentCodeId 
                   AND ISNULL(dc.RecordDeleted, 'N') = 'N' 
                 JOIN GlobalCodes gcs 
                   ON gcs.GlobalCodeId = CASE 
                                           WHEN ( d.AuthorId = @StaffId 
                                                   OR d.ReviewerId = 
                                                      @StaffId 
                                                ) 
                                         THEN 
                                           d.CurrentVersionStatus 
                                           ELSE d.Status 
                                         END 
                 JOIN DocumentVersions DV WITH (NOLOCK)
                   ON DV.DocumentId = d.DocumentId and D.InProgressDocumentVersionId=DV.DocumentVersionId
                   AND ISNULL(DV.RecordDeleted, 'N') = 'N' 
                 JOIN dbo.Staff st WITH (NOLOCK)
                   ON st.StaffId = d.AuthorId and ISNULL(St.RecordDeleted, 'N') = 'N'
                 JOIN Screens sr WITH (NOLOCK) ON sr.DocumentCodeId= d.DocumentCodeId   and isnull(sr.RecordDeleted, 'N') = 'N' 
                 LEFT JOIN #tocosign tcs 
                        ON tcs.DocumentId = d.DocumentId 
                 LEFT JOIN DocumentSignatures dsc WITH (NOLOCK)
                        ON dsc.DocumentId = d.DocumentId 
                           AND dsc.IsClient = 'Y' 
                           AND ISNULL(dsc.RecordDeleted, 'N') = 'N' 
                 
          WHERE  ISNULL(c.RecordDeleted, 'N') = 'N' 
          ORDER BY CASE WHEN @SortExpression= 'Effective DESC' 
                            THEN 
                            D.EffectiveDate else ''
                            END DESC
          
          SET ROWCOUNT 0
          
          Select DocumentVersionId,Name ,CONVERT(VARCHAR(10), Effective, 101) as Effective,Document ,[Status] ,DocumentId ,DocumentCodeId,
               CurrentVersionStatus ,ClientId,Author,DocumentType ,ServiceId ,DocumentScreenId ,
               [Version] , ErrorFlag  
          From #DisplayList
          ORDER BY CASE WHEN @SortExpression= 'Effective ASC' 
                            THEN 
                            Effective 
                            END ASC,
                            CASE WHEN @SortExpression= 'Effective DESC' 
                            THEN 
                            Effective 
                            END DESC,  
                            CASE 
                            WHEN @SortExpression= 'Name ASC' THEN 
                            Name
                            END 
                            ASC 
                            , 
                            CASE 
                            WHEN @SortExpression= 'Name DESC' THEN 
                            Name
                            END 
                            DESC 
                            , 
                            CASE 
                            WHEN 
                            @SortExpression= 'Document ASC' THEN Document END ASC, 
                            CASE 
                            WHEN 
                            @SortExpression= 'Document DESC' THEN Document END DESC,
                            CASE 
                            WHEN 
                            @SortExpression= 
                            'Status ASC' THEN DocumentId END ASC, 
							CASE 
                            WHEN 
                            @SortExpression= 
                            'Status DESC' THEN DocumentId END DESC ,
                             CASE 
                            WHEN 
                            @SortExpression= 
                            'Author ASC' THEN Author END ASC, 
							CASE 
                            WHEN 
                            @SortExpression= 
                            'Author DESC' THEN Author END DESC 

           
           Drop table #DisplayList
           Drop table #documentlist
           Drop table #tocosign
      END try 

      BEGIN catch 
          DECLARE @Error VARCHAR(8000) 

          SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                      + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                      + '*****' 
                      + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                      'ssp_ListSCPendingDocumentsForSign' ) 
                      + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 

          RAISERROR ( @Error,-- Message text.             
                      16,-- Severity.             
                      1 -- State.             
          ); 
      END catch 
  END 

go  