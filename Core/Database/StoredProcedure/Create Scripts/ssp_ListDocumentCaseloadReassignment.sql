/****** Object:  StoredProcedure [dbo].[ssp_ListDocumentCaseloadReassignment]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListDocumentCaseloadReassignment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListDocumentCaseloadReassignment]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ListDocumentCaseloadReassignment]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************                                                
**  File: ssp_ListDocumentCaseloadReassignment                                            
**  Name: ssp_ListDocumentCaseloadReassignment                        
**  Desc: To Get ReAssignment SubTypes                                           
**  Called by:                                                 
**  Parameters:                            
**  Auth:  Ponnin selvan                              
**  Date:  April 20 2017
*******************************************************************************                                                
**  Change History                                          
*******************************************************************************    
 -- Date			Author            Purpose                                          
 -- 27 July 2018	Bibhu     what:Added join with staffclients table to display associated clients for login staff  
          					  why:Engineering Improvement Initiatives- NBL(I) task #77
-- 11/28/2018		Msood		What: Removed the Staff.Active check as Documents for Inactive Staff were not displaying on List page
								Why: Spring River-Support Go Live Task #362

--*******************************************************************************/                                   
CREATE PROCEDURE  [dbo].[ssp_ListDocumentCaseloadReassignment]                                                                   
(          
	@AssignmentTypeCode varchar (100),
	@StaffId INT = NULL,
	@ClientId INT = NULL,
	@AssignmentSubType INT = NULL,
	@LogInStaffId INT = NULL
                                                                  
)                                                                              
As                                                                          
BEGIN                                                            
   BEGIN TRY   
   
     IF (isnull(@AssignmentTypeCode, '') = 'DOCUMENTS' OR isnull(@AssignmentTypeCode, '') = '' )
          BEGIN
			INSERT INTO #ResultSet (ClientId,ClientName,StaffId,StaffName,AssignmentTypeId,AssignmentCode,AssignmentSubTypeId,AssignmentSubTypeText,AssignmentTypeDescription,IsOrdersAssignedTo,ScreenId,ScreenType,ScreenParameter,DocumentStaffAssignPKId)
           Select D.ClientId, 
        ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')  AS ClientName,
          D.AuthorId as StaffId,
           rtrim(ltrim(s.LastName)) + ', ' + rtrim(s.FirstName)   AS StaffName, 
		CASE     
		  WHEN D.Status = 21   
		   THEN (SELECT TOP 1 GlobalCodeId from #GCASSIGNMENTTYPES where Code = 'DOCUMENTSINPROGRESS')
		WHEN D.Status = 20   
		  THEN (SELECT TOP 1 GlobalCodeId from #GCASSIGNMENTTYPES where Code = 'DOCUMENTSTODO')
		  END AS AssignmentTypeId  ,  
		           
		 CASE     
		  WHEN D.Status = 21   
		   THEN (SELECT TOP 1 CodeName from #GCASSIGNMENTTYPES where Code = 'DOCUMENTSINPROGRESS')
			WHEN D.Status = 20      
		  THEN (SELECT TOP 1 CodeName from #GCASSIGNMENTTYPES where Code = 'DOCUMENTSTODO')
		  END AS AssignmentCode  ,  
          D.DocumentId as AssignmentSubTypeId,
          DC.DocumentName as AssignmentSubTypeText,
          'Document: ' +   DC.DocumentName +  ' - ' + CASE WHEN D.EffectiveDate IS NULL THEN '' ELSE  CONVERT(VARCHAR(10), D.EffectiveDate, 101) END + ' - ' + dbo.ssf_GetGlobalCodeNameById(D.Status) + ' - '  +   ISNULL(s.LastName, '') + ', ' + ISNULL(s.FirstName, '') AS AssignmentTypeDescription,
           NULL,
           SC.ScreenId,
           5763,
           'null,' + convert(varchar(10),SC.ScreenId) + ','+ convert(varchar(10),D.DocumentId) + ',0,''N''',
		   0
           from DocumentCodes DC
           INNER JOIN Documents D ON DC.DocumentCodeId = D.DocumentCodeId AND isnull(DC.RecordDeleted, 'N') = 'N' AND isnull(D.RecordDeleted, 'N') = 'N'
           INNER JOIN Clients C  on C.ClientId = D.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  AND C.Active = 'Y'
           INNER JOIN Staff s on s.StaffId = D.AuthorId  --AND s.Active = 'Y' msood 11/28/2018
           INNER JOIN Screens SC on SC.DocumentCodeId = DC.DocumentCodeId AND isnull(SC.RecordDeleted, 'N') = 'N' 
           where (isnull(@StaffId, -1) = -1 or D.AuthorId = @StaffId) and (isnull(@ClientId, -1) = -1 or D.ClientId = @ClientId)
           and (isnull(@AssignmentSubType, -1) = -1 or DC.DocumentCodeId = @AssignmentSubType)
          -- and (isnull(@AssignmentTypeCode, '') = '' or isnull(@AssignmentTypeCode, '') = 'DOCUMENTS')
            AND isnull(DC.ServiceNote, 'N') = 'N' AND isnull(s.RecordDeleted, 'N') = 'N' 
           AND DC.Active = 'Y' AND D.Status in (20,21) AND DC.DocumentCodeId NOT IN (SELECT ISNULL(AssociatedDocumentCodeId, -1) from EventTypes ET Where isnull(ET.RecordDeleted, 'N') = 'N')
		   AND Exists (Select 1 From  StaffClients SC Where  SC.ClientId=C.ClientId AND SC.StaffId=@LogInStaffId)  --- 30-July-2018		Bibhu
          END
          
          
                 
            -- To get All active InProgress/Todo documents
          IF (isnull(@AssignmentTypeCode, '') = 'DOCUMENTSINPROGRESS' OR isnull(@AssignmentTypeCode, '') = 'DOCUMENTSTODO')
          BEGIN
          DECLARE @DocumentStatus int 
          
          IF(isnull(@AssignmentTypeCode, '') = 'DOCUMENTSINPROGRESS') SET @DocumentStatus = 21
          ELSE  IF(isnull(@AssignmentTypeCode, '') = 'DOCUMENTSTODO') SET @DocumentStatus = 20
         --  ELSE  IF(isnull(@AssignmentTypeCode, '') = 'DOCUMENTSTOBEREVIEWED') SET @DocumentStatus = 25
          
			INSERT INTO #ResultSet (ClientId,ClientName,StaffId,StaffName,AssignmentTypeId,AssignmentCode,AssignmentSubTypeId,AssignmentSubTypeText,AssignmentTypeDescription,IsOrdersAssignedTo,ScreenId,ScreenType,ScreenParameter,DocumentStaffAssignPKId)
           Select D.ClientId, 
        ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')  AS ClientName,
          D.AuthorId as StaffId,
           rtrim(ltrim(s.LastName)) + ', ' + rtrim(s.FirstName)   AS StaffName, 
         (SELECT TOP 1 GlobalCodeId from #GCASSIGNMENTTYPES where Code = @AssignmentTypeCode)  as AssignmentTypeId,
          (SELECT TOP 1 CodeName from #GCASSIGNMENTTYPES where Code = @AssignmentTypeCode) as AssignmentCode,
          D.DocumentId as AssignmentSubTypeId,
          DC.DocumentName as AssignmentSubTypeText,
          'Document: ' +   DC.DocumentName +  ' - ' + CASE WHEN D.EffectiveDate IS NULL THEN '' ELSE  CONVERT(VARCHAR(10), D.EffectiveDate, 101) END + ' - ' + dbo.ssf_GetGlobalCodeNameById(D.Status) + ' - '  +   ISNULL(s.LastName, '') + ', ' + ISNULL(s.FirstName, '') AS AssignmentTypeDescription,
           NULL,
           SC.ScreenId,
           5763,
           'null,' + convert(varchar(10),SC.ScreenId) + ','+ convert(varchar(10),D.DocumentId) + ',0,''N''',
		   0
           from DocumentCodes DC
           INNER JOIN Documents D ON DC.DocumentCodeId = D.DocumentCodeId AND isnull(DC.RecordDeleted, 'N') = 'N' AND isnull(D.RecordDeleted, 'N') = 'N'
           INNER JOIN Clients C  on C.ClientId = D.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  AND C.Active = 'Y'
           INNER JOIN Staff s on s.StaffId = D.AuthorId -- AND s.Active = 'Y' msood 11/28/2018
           INNER JOIN Screens SC on SC.DocumentCodeId = DC.DocumentCodeId AND isnull(SC.RecordDeleted, 'N') = 'N' 
           where (isnull(@StaffId, -1) = -1 or D.AuthorId = @StaffId) and (isnull(@ClientId, -1) = -1 or D.ClientId = @ClientId)
           and (isnull(@AssignmentSubType, -1) = -1 or DC.DocumentCodeId = @AssignmentSubType)
          -- and (isnull(@AssignmentTypeCode, '') = '' or isnull(@AssignmentTypeCode, '') = 'DOCUMENTS')
            AND isnull(DC.ServiceNote, 'N') = 'N' AND isnull(s.RecordDeleted, 'N') = 'N' 
           AND DC.Active = 'Y' AND D.Status in (@DocumentStatus) AND DC.DocumentCodeId NOT IN (SELECT ISNULL(AssociatedDocumentCodeId, -1) from EventTypes ET Where isnull(ET.RecordDeleted, 'N') = 'N')
           AND Exists (Select 1 From  StaffClients SC Where  SC.ClientId=C.ClientId AND SC.StaffId=@LogInStaffId)  --- 30-July-2018		Bibhu
          END
          
              -- To get All active To Be Reviewed documents
          IF (isnull(@AssignmentTypeCode, '') = 'DOCUMENTSTOBEREVIEWED' OR (isnull(@AssignmentTypeCode, '') = 'DOCUMENTS' OR isnull(@AssignmentTypeCode, '') = '' ))
          BEGIN
          
			INSERT INTO #ResultSet (ClientId,ClientName,StaffId,StaffName,AssignmentTypeId,AssignmentCode,AssignmentSubTypeId,AssignmentSubTypeText,AssignmentTypeDescription,IsOrdersAssignedTo,ScreenId,ScreenType,ScreenParameter,DocumentStaffAssignPKId)
           Select D.ClientId, 
        ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')  AS ClientName,
          D.ReviewerId as StaffId,
           rtrim(ltrim(s.LastName)) + ', ' + rtrim(s.FirstName)   AS StaffName, 
         (SELECT TOP 1 GlobalCodeId from #GCASSIGNMENTTYPES where Code = 'DOCUMENTSTOBEREVIEWED')  as AssignmentTypeId,
          (SELECT TOP 1 CodeName from #GCASSIGNMENTTYPES where Code = 'DOCUMENTSTOBEREVIEWED') as AssignmentCode,
          D.DocumentId as AssignmentSubTypeId,
          DC.DocumentName as AssignmentSubTypeText,
          'Document: ' +   DC.DocumentName +  ' - ' + CASE WHEN D.EffectiveDate IS NULL THEN '' ELSE  CONVERT(VARCHAR(10), D.EffectiveDate, 101) END + ' - ' + dbo.ssf_GetGlobalCodeNameById(D.Status) + ' - '  +   ISNULL(s.LastName, '') + ', ' + ISNULL(s.FirstName, '') AS AssignmentTypeDescription,
           NULL,
           SC.ScreenId,
           5763,
           'null,' + convert(varchar(10),SC.ScreenId) + ','+ convert(varchar(10),D.DocumentId) + ',0,''N''',
		   0
           from DocumentCodes DC
           INNER JOIN Documents D ON DC.DocumentCodeId = D.DocumentCodeId AND isnull(DC.RecordDeleted, 'N') = 'N' AND isnull(D.RecordDeleted, 'N') = 'N'
           INNER JOIN Clients C  on C.ClientId = D.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  AND C.Active = 'Y'
           INNER JOIN Staff s on s.StaffId = D.ReviewerId  --AND s.Active = 'Y' msood 11/28/2018
           INNER JOIN Screens SC on SC.DocumentCodeId = DC.DocumentCodeId AND isnull(SC.RecordDeleted, 'N') = 'N' 
           where (isnull(@ClientId, -1) = -1 or D.ClientId = @ClientId) and ((isnull(@StaffId, -1) = -1 or D.AuthorId = @StaffId) OR D.ReviewerId = @StaffId)
           and (isnull(@AssignmentSubType, -1) = -1 or DC.DocumentCodeId = @AssignmentSubType)
            AND isnull(DC.ServiceNote, 'N') = 'N' AND isnull(s.RecordDeleted, 'N') = 'N' 
           AND DC.Active = 'Y' AND D.Status in (25) AND DC.DocumentCodeId NOT IN (SELECT ISNULL(AssociatedDocumentCodeId, -1) from EventTypes ET Where isnull(ET.RecordDeleted, 'N') = 'N')
           AND Exists (Select 1 From  StaffClients SC Where  SC.ClientId=C.ClientId AND SC.StaffId=@LogInStaffId)  --- 30-July-2018		Bibhu
          END
          
               -- To get All active To Acknowledge documents
          IF (isnull(@AssignmentTypeCode, '') = 'DOCUMENTSTOACKNOWLEDGE' OR (isnull(@AssignmentTypeCode, '') = 'DOCUMENTS' OR isnull(@AssignmentTypeCode, '') = '' ))
          BEGIN
     
		INSERT INTO #ResultSet (ClientId,ClientName,StaffId,StaffName,AssignmentTypeId,AssignmentCode,AssignmentSubTypeId,AssignmentSubTypeText,AssignmentTypeDescription,IsOrdersAssignedTo,ScreenId,ScreenType,ScreenParameter,DocumentStaffAssignPKId)
           Select D.ClientId, 
        ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')  AS ClientName,
        DAK.AcknowledgedByStaffId as StaffId,
           rtrim(ltrim(s.LastName)) + ', ' + rtrim(s.FirstName)   AS StaffName, 
         (SELECT TOP 1 GlobalCodeId from #GCASSIGNMENTTYPES where Code = 'DOCUMENTSTOACKNOWLEDGE')  as AssignmentTypeId,
          (SELECT TOP 1 CodeName from #GCASSIGNMENTTYPES where Code = 'DOCUMENTSTOACKNOWLEDGE') as AssignmentCode,
          D.DocumentId as AssignmentSubTypeId,
          DC.DocumentName as AssignmentSubTypeText,
          'Document: ' +   DC.DocumentName +  ' - ' + CASE WHEN D.EffectiveDate IS NULL THEN '' ELSE  CONVERT(VARCHAR(10), D.EffectiveDate, 101) END + ' - To Acknowledge - '  +   ISNULL(s.LastName, '') + ', ' + ISNULL(s.FirstName, '') AS AssignmentTypeDescription,
           NULL,
           SC.ScreenId,
           5763,
           'null,' + convert(varchar(10),SC.ScreenId) + ','+ convert(varchar(10),D.DocumentId) + ',0,''N''',
		   DAK.DocumentsAcknowledgementId
           from DocumentCodes DC
           INNER JOIN Documents D ON DC.DocumentCodeId = D.DocumentCodeId AND isnull(DC.RecordDeleted, 'N') = 'N' AND isnull(D.RecordDeleted, 'N') = 'N'
           INNER JOIN Clients C  on C.ClientId = D.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  AND C.Active = 'Y'
           INNER JOIN DocumentsAcknowledgements DAK on  DAK.DocumentId = D.DocumentId  AND ISNULL(DAK.RecordDeleted, 'N') <> 'Y'    
           INNER JOIN Staff s on s.StaffId = DAK.AcknowledgedByStaffId  --AND s.Active = 'Y' msood 11/28/2018
           INNER JOIN Screens SC on SC.DocumentCodeId = DC.DocumentCodeId AND isnull(SC.RecordDeleted, 'N') = 'N' 
           where (DAK.AcknowledgedByStaffId = @StaffId OR isnull(@StaffId, -1) = -1)  AND DAK.DateAcknowledged IS NULL  and (isnull(@ClientId, -1) = -1 or D.ClientId = @ClientId)
           and (isnull(@AssignmentSubType, -1) = -1 or DC.DocumentCodeId = @AssignmentSubType)
          -- and (isnull(@AssignmentTypeCode, '') = '' or isnull(@AssignmentTypeCode, '') = 'DOCUMENTS')
            AND isnull(DC.ServiceNote, 'N') = 'N' AND isnull(s.RecordDeleted, 'N') = 'N' 
           AND DC.Active = 'Y' AND DC.DocumentCodeId NOT IN (SELECT ISNULL(AssociatedDocumentCodeId, -1) from EventTypes ET Where isnull(ET.RecordDeleted, 'N') = 'N')
           AND EXISTS ( SELECT 1      
                                 FROM   DocumentSignatures ds      
                                 WHERE  ds.DocumentId = d.DocumentId  AND ISNULL(ds.RecordDeleted, 'N') <> 'Y' ) 
		   AND Exists (Select 1 From  StaffClients SC Where  SC.ClientId=C.ClientId AND SC.StaffId=@LogInStaffId)  --- 30-July-2018		Bibhu
          END
          
          -- To get All active To Document To Sign
         IF (isnull(@AssignmentTypeCode, '') = 'DOCUMENTSTOSIGN' OR (isnull(@AssignmentTypeCode, '') = 'DOCUMENTS' OR isnull(@AssignmentTypeCode, '') = '' ))
          BEGIN
			INSERT INTO #ResultSet (ClientId,ClientName,StaffId,StaffName,AssignmentTypeId,AssignmentCode,AssignmentSubTypeId,AssignmentSubTypeText,AssignmentTypeDescription,IsOrdersAssignedTo,ScreenId,ScreenType,ScreenParameter,DocumentStaffAssignPKId)
           Select D.ClientId, 
        ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')  AS ClientName,
          ds.StaffId as StaffId,
           rtrim(ltrim(s.LastName)) + ', ' + rtrim(s.FirstName)   AS StaffName, 
         (SELECT TOP 1 GlobalCodeId from #GCASSIGNMENTTYPES where Code = 'DOCUMENTSTOSIGN')  as AssignmentTypeId,
          (SELECT TOP 1 CodeName from #GCASSIGNMENTTYPES where Code = 'DOCUMENTSTOSIGN') as AssignmentCode,
          D.DocumentId as AssignmentSubTypeId,
          DC.DocumentName as AssignmentSubTypeText,
          'Document: ' +   DC.DocumentName +  ' - ' + CASE WHEN D.EffectiveDate IS NULL THEN '' ELSE  CONVERT(VARCHAR(10), D.EffectiveDate, 101) END + ' - To Sign - '  +   ISNULL(s.LastName, '') + ', ' + ISNULL(s.FirstName, '') AS AssignmentTypeDescription,
           NULL,
           SC.ScreenId,
           5763,
           'null,' + convert(varchar(10),SC.ScreenId) + ','+ convert(varchar(10),D.DocumentId) + ',0,''N''',
		   ds.SignatureId
           from DocumentCodes DC
           INNER JOIN Documents D ON DC.DocumentCodeId = D.DocumentCodeId AND isnull(DC.RecordDeleted, 'N') = 'N' AND isnull(D.RecordDeleted, 'N') = 'N'
           INNER JOIN Clients C  on C.ClientId = D.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  AND C.Active = 'Y'
		   INNER JOIN DocumentSignatures ds on ds.DocumentId = D.DocumentId 
           INNER JOIN Staff s on s.StaffId = ds.StaffId -- AND s.Active = 'Y' msood 11/28/2018
           INNER JOIN Screens SC on SC.DocumentCodeId = DC.DocumentCodeId AND isnull(SC.RecordDeleted, 'N') = 'N' 
           where (isnull(@ClientId, -1) = -1 or D.ClientId = @ClientId)
           and (isnull(@AssignmentSubType, -1) = -1 or DC.DocumentCodeId = @AssignmentSubType)
          -- and (isnull(@AssignmentTypeCode, '') = '' or isnull(@AssignmentTypeCode, '') = 'DOCUMENTS')
            AND isnull(DC.ServiceNote, 'N') = 'N' AND isnull(s.RecordDeleted, 'N') = 'N' 
           AND DC.Active = 'Y' AND D.Status in (21) AND DC.DocumentCodeId NOT IN (SELECT ISNULL(AssociatedDocumentCodeId, -1) from EventTypes ET Where isnull(ET.RecordDeleted, 'N') = 'N')
           AND D.ToSign = 'Y'   AND ds.Signaturedate IS NULL      
                                    AND ISNULL(ds.DeclinedSignature, 'N') = 'N'      
                                    AND (ds.StaffId = @StaffId  or isnull(@StaffId, -1) = -1    )
                                    AND ds.StaffId = D.AuthorId      
                                    AND ISNULL(ds.RecordDeleted, 'N') <> 'Y'
		   AND Exists (Select 1 From  StaffClients SC Where  SC.ClientId=C.ClientId AND SC.StaffId=@LogInStaffId)  --- 30-July-2018		Bibhu
          END
          
          
         -- To get All active To Document To Co-Sign
         IF (isnull(@AssignmentTypeCode, '') = 'DOCUMENTSTOCOSIGN' OR (isnull(@AssignmentTypeCode, '') = 'DOCUMENTS' OR isnull(@AssignmentTypeCode, '') = '' ))
          BEGIN
			INSERT INTO #ResultSet (ClientId,ClientName,StaffId,StaffName,AssignmentTypeId,AssignmentCode,AssignmentSubTypeId,AssignmentSubTypeText,AssignmentTypeDescription,IsOrdersAssignedTo,ScreenId,ScreenType,ScreenParameter,DocumentStaffAssignPKId)
           Select D.ClientId, 
        ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')  AS ClientName,
          ds.StaffId as StaffId,
           rtrim(ltrim(s.LastName)) + ', ' + rtrim(s.FirstName)   AS StaffName, 
         (SELECT TOP 1 GlobalCodeId from #GCASSIGNMENTTYPES where Code = 'DOCUMENTSTOCOSIGN')  as AssignmentTypeId,
          (SELECT TOP 1 CodeName from #GCASSIGNMENTTYPES where Code = 'DOCUMENTSTOCOSIGN') as AssignmentCode,
          D.DocumentId as AssignmentSubTypeId,
          DC.DocumentName as AssignmentSubTypeText,
          'Document: ' +   DC.DocumentName +  ' - ' + CASE WHEN D.EffectiveDate IS NULL THEN '' ELSE  CONVERT(VARCHAR(10), D.EffectiveDate, 101) END + ' - To Co-Sign - '  +   ISNULL(s.LastName, '') + ', ' + ISNULL(s.FirstName, '') AS AssignmentTypeDescription,
           NULL,
           SC.ScreenId,
           5763,
           'null,' + convert(varchar(10),SC.ScreenId) + ','+ convert(varchar(10),D.DocumentId) + ',0,''N''',
		   ds.SignatureId
           from DocumentCodes DC
           INNER JOIN Documents D ON DC.DocumentCodeId = D.DocumentCodeId AND isnull(DC.RecordDeleted, 'N') = 'N' AND isnull(D.RecordDeleted, 'N') = 'N'
           INNER JOIN Clients C  on C.ClientId = D.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'  AND C.Active = 'Y'
		    INNER JOIN DocumentSignatures ds on ds.DocumentId = D.DocumentId 
           INNER JOIN Staff s on s.StaffId = ds.StaffId  --AND s.Active = 'Y' msood 11/28/2018
           INNER JOIN Screens SC on SC.DocumentCodeId = DC.DocumentCodeId AND isnull(SC.RecordDeleted, 'N') = 'N' 
           where (isnull(@ClientId, -1) = -1 or D.ClientId = @ClientId)
           and (isnull(@AssignmentSubType, -1) = -1 or DC.DocumentCodeId = @AssignmentSubType)
          -- and (isnull(@AssignmentTypeCode, '') = '' or isnull(@AssignmentTypeCode, '') = 'DOCUMENTS')
            AND isnull(DC.ServiceNote, 'N') = 'N' AND isnull(s.RecordDeleted, 'N') = 'N' 
           AND DC.Active = 'Y' AND D.Status in (22) AND DC.DocumentCodeId NOT IN (SELECT ISNULL(AssociatedDocumentCodeId, -1) from EventTypes ET Where isnull(ET.RecordDeleted, 'N') = 'N')
           AND ds.signaturedate IS NULL    AND ISNULL(ds.declinedsignature, 'N') = 'N'      
                                    AND (ds.StaffId = @StaffId  or isnull(@StaffId, -1) = -1)  
                                    AND ds.StaffId <> D.AuthorId      
                                    AND ( ds.StaffId <> ISNULL(D.ReviewerId, 0) )      
                                    AND ISNULL(ds.RecordDeleted, 'N') <> 'Y' 
		   AND Exists (Select 1 From  StaffClients SC Where  SC.ClientId=C.ClientId AND SC.StaffId=@LogInStaffId)  --- 30-July-2018		Bibhu
          END
	
 END TRY                                        
                                                           
 BEGIN CATCH                                                            
   DECLARE @Error varchar(8000)                                                                                               
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                              
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[ssp_ListDocumentCaseloadReassignment]')                                                                                               
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                              
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                              
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                                            
 END CATCH                                          
End 

GO


