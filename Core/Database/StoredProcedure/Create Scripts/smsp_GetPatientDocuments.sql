
/****** Object:  StoredProcedure [dbo].[smsp_GetPatientDocuments]    Script Date: 31/05/2018 12:23:47 PM ******/

IF EXISTS
(
    SELECT *
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[smsp_GetPatientDocuments]')
          AND type IN(N'P', N'PC')
)
    DROP PROCEDURE [dbo].[smsp_GetPatientDocuments];
GO

/****** Object:  StoredProcedure [dbo].[smsp_GetPatientDocuments]    Script Date: 31/05/2018 12:23:47 PM ******/

SET ANSI_NULLS ON;
GO
SET QUOTED_IDENTIFIER ON;
GO
CREATE PROCEDURE [dbo].[smsp_GetPatientDocuments]   
 @ClientId INT          
 ,@ClinicianId INT          
 ,@AuthorIdFilter INT=0          
 ,@StatusFilter INT=1          
 ,@DueDaysFilter INT=10     
 ,@LoggedInStaffId INT = - 1        
 ,@DosFrom datetime=''     
 ,@DosTo  datetime=''       
 ,@IncludeErrorDocument CHAR(1)= 'N'   
 ,@DocumentNavigationId INT = 0     
 ,@JsonResult VARCHAR(MAX) OUTPUT  
 /*=================================================================================================                                 
-- Stored Procedure: dbo.smsp_GetPatientDocuments                                    
--                                  
-- Copyright: Streamline Healthcate Solutions                                  
--                                  
-- Purpose: used to return  Client Documents as a json result
-- 
-- Created : Vishnu Narayanan
--
-- Copied logic from ssp_ListPageSCDocuments                                  
    
========================================================================================================================================*/          
AS          
BEGIN          
 BEGIN TRY    
 DECLARE @InstanceId INT;          
 DECLARE @PageNumber INT ;         
 DECLARE @PageSize INT;          
 DECLARE @SortExpression VARCHAR(100); 
 DECLARE @OtherFilter INT;   
 SET @InstanceId = 0;  
 SET @PageNumber = 0;  
 SET @PageSize = 200;  
 SET @SortExpression='EffectiveDate desc';  
 SET @OtherFilter =0;
  CREATE TABLE #ResultSet (          
   ListPageSCDocumentId [bigint] IDENTITY(1, 1) NOT NULL          
   ,RowNumber INT          
   ,PageNumber INT          
   ,DocumentId INT          
   ,ServiceId INT          
   ,DocumentCodeId INT          
   ,DocumentScreenId INT          
   ,ClientId INT          
   ,DocumentName VARCHAR(175)          
   ,EffectiveDate DATETIME          
   ,[Status] INT          
   ,StatusName VARCHAR(50)          
   ,DueDate DATETIME          
   ,AuthorId INT          
   ,AuthorName VARCHAR(100)          
   ,ToCoSign VARCHAR(50)          
   ,ClientToSign VARCHAR(50)          
   ,Shared VARCHAR(3)       
   -- JUNE-03-2016 Akwinass      
   ,HasMoreThanOneVersion VARCHAR(3)       
    -- SEP-22-2016 Chita Ranjan      
   ,AssociateDocuments VARCHAR(175),      
   --27/10/2017 Sunil.D       
  AssociateDocumentId int,      
  AssociateScreenId int,      
  AssociateServiceId int,      
  Attachments INT        
   )          
          
  DECLARE @CustomFilters TABLE (DocumentId INT)          
  DECLARE @ScreenId INT          
  DECLARE @CustomFiltersApplied CHAR(1)          
  DECLARE @Today DATETIME          
  DECLARE @ApplyFilterClicked CHAR(1)          
  DECLARE @DocumentCodeFilters TABLE (DocumentCodeId INT)          
          
  SET @SortExpression = rtrim(ltrim(@SortExpression))          
          
  IF isnull(@SortExpression, '') = ''          
   SET @SortExpression = 'EffectiveDate desc'          
          
  ------ Get Permissioned Orders for the logged in Staff ------            
  CREATE TABLE #PermissionTable (PermissionItemId INT)          
          
  INSERT INTO #PermissionTable (PermissionItemId)          
  EXEC ssp_GetPermisionedOrder @LoggedInStaffId = @LoggedInStaffId          
          
          
   CREATE TABLE #OrdersData (DocumentId INT)  --Added By Prem 14-12-2017       
   Insert into #OrdersData      
   Select CO.DocumentId      
   From #PermissionTable P JOIN Orders O ON P.PermissionItemId = O.OrderId         
   AND isnull(O.RecordDeleted, 'N') = 'N'       
    join ClientOrders CO  ON O.OrderId = CO.OrderId  AND isnull(CO.RecordDeleted, 'N') = 'N'       
    Join Documents D ON CO.DocumentId = D.DocumentId         
   Where   isnull(D.RecordDeleted, 'N') = 'N'       
  --                                  
  -- New retrieve - the request came by clicking on the Apply Filter button                                             
  --                                  
  SET @ApplyFilterClicked = 'Y'          
  --08.20.2014  Kirtee  wrf Core Bugs Task# 265                               
  --set @PageNumber = 1                                                        
  SET @Today = convert(CHAR(10), getdate(), 101)          
  SET @CustomFiltersApplied = 'N'          
          
  -- Get custom filters                                  
  IF @StatusFilter > 10000          
   OR @DueDaysFilter > 10000          
   OR @OtherFilter > 10000          
  BEGIN          
   SET @CustomFiltersApplied = 'Y'          
          
   INSERT INTO @CustomFilters (DocumentId)          
   EXEC scsp_ListPageSCDocuments @ClientId = @ClientId          
    ,@ClinicianId = @ClinicianId          
    ,@AuthorIdFilter = @AuthorIdFilter          
    ,@StatusFilter = @StatusFilter          
    ,@DueDaysFilter = @DueDaysFilter          
    ,@DocumentNavigationId = @DocumentNavigationId          
    ,@OtherFilter = @OtherFilter       
    ,@DosFrom = @DosFrom    -- 20.12.2016 Ravichandra      
    ,@DosTo = @DosTo  -- 20.12.2016 Ravichandra      
            
  END          
          
  -- Get all document codes based on DocumentNavigationId              
  IF @CustomFiltersApplied = 'N'          
  BEGIN          
   INSERT INTO @DocumentCodeFilters (DocumentCodeId)          
   EXEC ssp_GetDocumentNavigationDocumentCodes @DocumentNavigationId = @DocumentNavigationId          
  END          
          
  -- Get result set                          
  INSERT INTO #ResultSet (          
   DocumentId          
   ,ServiceId          
   ,DocumentCodeId          
   ,DocumentScreenId          
   ,ClientId          
   ,DocumentName          
   ,EffectiveDate          
   ,[Status]          
   ,StatusName          
   ,DueDate          
   ,AuthorId          
   ,AuthorName          
   ,ToCoSign          
   ,ClientToSign          
   ,Shared         
   )          
  SELECT d.DocumentId          
   ,isnull(d.ServiceId, 0)          
   ,d.DocumentCodeId          
   ,          
   -- 05/07/2015 Gautam          
   CASE           
    WHEN (          
      dc.DocumentType = 17          
      AND sr.ScreenId IS NULL          
      )          
     THEN 102          
    ELSE sr.ScreenId          
    END AS 'ScreenId'          
   ,d.ClientId          
   ,left(CASE           
     WHEN pc.DisplayDocumentAsProcedureCode = 'Y'          
      THEN pc.DisplayAs          
     WHEN dc.DocumentCodeId = 2          
      AND tp.PlanOrAddendum = 'A'          
      THEN 'TxPlan Addendum'          
       -- 01.31.2015  Vamsi  To display procedure code behind the service note type.               
     WHEN dc.ServiceNote = 'Y'          
      THEN case when pc.DisplayAs is not null then dc.DocumentName + ' ( ' + pc.DisplayAs + ' )' else  dc.DocumentName end        
       --Changes End                
     ELSE dc.DocumentName          
     END          
    -- 03.21.2014  TRemisoski  If image is scanned and has a description, show it after the DocumentName          
    + CASE           
     WHEN imr.RecordDescription IS NOT NULL          
      THEN '(' + ltrim(rtrim(imr.RecordDescription)) + ')'          
     ELSE ''          
     END, 100)          
   ,d.EffectiveDate          
   ,          
   /*Commented & changed by Shifali on 21Nov ref task# 11(To be reviewed)*/          
   --d.Status,                                  
   CASE           
    WHEN (          
      d.AuthorId = @ClinicianId          
      OR d.ReviewerId = @ClinicianId          
      )          
     THEN d.CurrentVersionStatus          
    ELSE d.[Status]          
    END AS [Status]          
   ,          
   /*Changes end here*/          
   CASE           
    WHEN isnull(d.SignedByAuthor, 'N') = 'N'          
     AND gcs.GlobalCodeId = 22          
     THEN 'Completed'          
    WHEN d.SignedByAuthor = 'Y'          
     AND gcs.GlobalCodeId = 22          
     THEN 'Signed'          
    ELSE gcs.CodeName          
    END AS StatusName          
   ,d.DueDate          
   ,d.AuthorId          
   ,a.LastName + ', ' + a.FirstName          
    --17/01/2018   Arjun K R Start      
   ,CASE           
    WHEN dss.DocumentId IS NOT NULL          
     AND dss.SignatureDate IS NULL          
     AND isnull(dss.DeclinedSignature, 'N') = 'N'           
     THEN (SELECT Staff.LastName+', '+Staff.FirstName FROM Staff WHERE Staff.StaffId=dss.StaffId)           
    ELSE NULL          
    END          
   ,CASE           
    WHEN dsc1.DocumentId IS NOT NULL          
     AND dsc1.SignatureDate IS NULL          
     AND isnull(dsc1.DeclinedSignature, 'N') = 'N'          
     AND d.[Status] = 22      
     AND ISNULL(dc.DefaultGuardian ,'N')='Y'        
     THEN        
     (SELECT ISNULL(STUFF((SELECT ', ' + ISNULL(CC.LastName+', '+ CC.FirstName,'')      
   FROM ClientContacts CC      
   WHERE  CC.ClientId=D.ClientId      
     AND ISNULL(CC.RecordDeleted,'N')='N'       
     AND ISNULL(CC.Guardian,'N')='Y'       
     AND EXISTS(SELECT 1 FROM DocumentSignatures DSIGN WHERE DSIGN.RelationToClient=CC.Relationship       
     AND DSIGN.DocumentId=dsc1.DocumentId AND ISNULL(DSIGN.IsClient,'N')='N'       
     AND DSIGN.SignatureDate IS NULL       
     AND DSIGN.StaffId IS NULL AND ISNULL(DSIGN.RecordDeleted,'N')='N')      
   FOR XML PATH('')      
    ,type ).value('.', 'nvarchar(max)'), 1, 2, ' '), '')      
          
  )      
    WHEN  dsc.DocumentId IS NOT NULL          
     AND dsc.SignatureDate IS NULL          
     AND isnull(dsc.DeclinedSignature, 'N') = 'N'          
     AND d.[Status] = 22       
     AND dsc.ClientId IS NOT NULL      
     AND ISNULL(DC.DefaultCoSigner,'N')='Y'      
    THEN dsc.SignerName        
    ELSE NULL      
    END      
      --17/01/2018   Arjun K R End      
   ,CASE           
    WHEN d.DocumentShared = 'Y'          
     THEN 'Yes'          
    ELSE 'No'          
    END      
  FROM Documents d          
  INNER JOIN DocumentCodes dc ON dc.DocumentCodeId = d.DocumentCodeId          
  /*Commented & changed by Shifali on 21Nov ref task# 11(To be reviewed)*/          
  /*join GlobalCodes gcs on gcs.GlobalCodeId = d.Status                        */          
  INNER JOIN GlobalCodes gcs ON gcs.GlobalCodeId = CASE           
    WHEN (          
      d.AuthorId = @ClinicianId          
      OR d.ReviewerId = @ClinicianId          
      )          
     THEN d.CurrentVersionStatus          
    ELSE d.[Status]          
    END          
  INNER JOIN Staff a ON a.StaffId = d.AuthorId          
  -- 05/07/2015 Gautam          
  LEFT JOIN Screens sr ON sr.DocumentCodeId = d.DocumentCodeId          
  LEFT JOIN DocumentSignatures dss ON dss.DocumentId = d.DocumentId          
   AND dss.StaffId = @ClinicianId          
   AND dss.StaffId <> d.AuthorId          
   AND isnull(dss.RecordDeleted, 'N') = 'N'          
  LEFT JOIN DocumentSignatures dsc ON dsc.DocumentId = d.DocumentId          
   AND dsc.IsClient = 'Y'          
   AND isnull(dsc.RecordDeleted, 'N') = 'N'         
  AND NOT EXISTS (                                                        --17/01/2018   Arjun K R Start      
    SELECT *          
    FROM dbo.DocumentSignatures AS dsc2          
    WHERE dsc2.DocumentId = dsc.DocumentId          
     AND dsc2.IsClient = 'Y'          
     AND isnull(dsc2.RecordDeleted, 'N') = 'N'          
     AND (dsc2.SignatureId > dsc.SignatureId)          
    )       
  LEFT JOIN DocumentSignatures dsc1 ON dsc1.DocumentId = d.DocumentId          
   AND dsc1.IsClient = 'N'  AND dsc1.StaffId  IS NULL       
   AND dsc1.SignatureDate IS NULL       
   AND isnull(dsc1.RecordDeleted, 'N') = 'N'               
   AND EXISTS(SELECT 1 FROM ClientContacts CC      
   WHERE  CC.ClientId=D.ClientId      
     AND ISNULL(CC.RecordDeleted,'N')='N'       
     AND ISNULL(CC.Guardian,'N')='Y'       
     AND dsc1.RelationToClient=CC.Relationship       
     )      
    --17/01/2018   Arjun K R Start      
   AND NOT EXISTS (          
    SELECT 1          
    FROM dbo.DocumentSignatures AS dsc3          
    WHERE dsc3.DocumentId = dsc1.DocumentId          
     AND dsc3.IsClient = 'N'          
     AND isnull(dsc3.RecordDeleted, 'N') = 'N'        
     AND dsc3.SignatureDate IS NULL        
     AND dsc3.StaffId IS NULL        
     AND (dsc3.SignatureId > dsc1.SignatureId)          
    )               
        --17/01/2018   Arjun K R End      
  LEFT JOIN Services s ON s.ServiceId = d.ServiceId          
   AND d.[Status] IN (          
    20          
    ,21          
    ,22          
    ,23          
    )          
   AND dc.ServiceNote = 'Y'          
  LEFT JOIN ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeID          
  LEFT JOIN TpGeneral tp ON tp.DocumentVersionId = d.CurrentDocumentVersionId          
  -- 03.21.2014  TRemisoski  Add left join to ImageRecords to include ImageDescription          
  LEFT JOIN ImageRecords AS imr ON imr.DocumentVersionId = d.CurrentDocumentVersionId            
   Left Join #OrdersData OD on D.DocumentId=OD.DocumentId    --Added By prem 14/12/2017      
  WHERE d.ClientID = @ClientId          
   AND isnull(d.RecordDeleted, 'N') = 'N'          
   AND isnull(sr.RecordDeleted, 'N') = 'N'         
   AND (          
    (          
     @CustomFiltersApplied = 'Y'          
     AND EXISTS (          
      SELECT *          
      FROM @CustomFilters cf          
      WHERE cf.DocumentId = d.DocumentId          
      )          
     )          
    OR (          
     @CustomFiltersApplied = 'N'          
     AND (          
      (          
       d.AuthorId = @ClinicianId          
       OR -- Current clinician is an author                                  
       d.ProxyId = @ClinicianId          
       OR -- Current clinician is a proxy                                  
       d.ReviewerId = @ClinicianId          
       OR -- Current clinician is a Reviewer          
       d.[Status] IN (          
        22          
        ,23          
        )          
       OR -- Document is in the final status: Signed or Cancelled                                  
       d.DocumentShared = 'Y'          
       ) -- Document is shared                                  
      OR (          
       d.[Status] IN (          
        22   
        ,23          
        )          
       OR d.DocumentShared = 'Y'          
       )          
      )          
     --and (isnull(@DocumentNavigationId, 0) <= 0 or exists(select * from @DocumentCodeFilters dcf where dcf.DocumentCodeId = d.DocumentCodeId))            
     AND (          
      (          
       ISNULL(@DocumentNavigationId, 0) = 0          
       AND ISNULL(@DocumentNavigationId, 0) != - 1          
       )          
      OR EXISTS (          
       SELECT *          
       FROM @DocumentCodeFilters dcf          
       WHERE dcf.DocumentCodeId = d.DocumentCodeId          
       )          
      )          
     AND (          
      d.AuthorId = @AuthorIdFilter          
      OR isnull(@AuthorIdFilter, 0) <= 0          
      )          
     AND       
  ( (         
      @StatusFilter IN (          
       0          
       ,1          
       )       
    AND d.Status !=26 AND d.CurrentVersionStatus!=26       
    OR  (       
  @IncludeErrorDocument = 'Y'      
  AND  @StatusFilter IN (          
       0          
       ,1          
       )  )        
    )        
      OR -- All Statuses            
      --(@StatusFilter = 2 and d.Status = 20) or -- To Do                                  
      (          
       @StatusFilter = 2          
       AND (          
        (          
         (          
          isnull(d.AuthorId, - 1) = @AuthorIdFilter          
          OR isnull(d.ReviewerId, - 1) = @AuthorIdFilter          
          OR isnull(d.ProxyId, - 1) = @AuthorIdFilter          
          )          
         AND d.CurrentVersionStatus = 20          
         )          
        OR (          
         (          
          (          
           isnull(d.AuthorId, - 1) != @AuthorIdFilter          
           AND isnull(d.ReviewerId, - 1) != @AuthorIdFilter          
           AND isnull(d.ProxyId, - 1) != @AuthorIdFilter          
           )          
          AND d.[Status] = 20          
          )          
         )        
   OR --If includeErrorDocument is checked and @StatusFilter=3 #Pranay      
   (       
  @IncludeErrorDocument = 'Y'      
  AND ( d.[Status] = 26      
         OR d.CurrentVersionStatus = 26        
   ) )        
        )          
       )          
      OR -- To Do           
      --(@StatusFilter = 3 and d.Status = 21) or -- In Progress                                  
      (          
       @StatusFilter = 3          
       AND (          
        (          
         (          
          isnull(d.AuthorId, - 1) = @AuthorIdFilter          
          OR isnull(d.ReviewerId, - 1) = @AuthorIdFilter          
          OR isnull(d.ProxyId, - 1) = @AuthorIdFilter          
          )          
         AND d.CurrentVersionStatus = 21          
         )          
        OR (          
         (          
          (          
           isnull(d.AuthorId, - 1) != @AuthorIdFilter          
           AND isnull(d.ReviewerId, - 1) != @AuthorIdFilter          
           AND isnull(d.ProxyId, - 1) != @AuthorIdFilter          
           )          
          AND d.[Status] = 21          
          )          
         )      
   OR  --If Include ErrorDocument is checked and @StausFilter =3      
   (       
  @IncludeErrorDocument = 'Y'      
  AND ( d.[Status] = 26      
         OR d.CurrentVersionStatus = 26        
   ) )          
        )          
       )          
      OR --In Progress          
      --(@StatusFilter = 4 and d.Status = 22 and d.SignedByAuthor = 'Y') or -- Signed                                  
      (          
       @StatusFilter = 4          
       AND (          
        (          
         (          
          isnull(d.AuthorId, - 1) = @AuthorIdFilter          
          OR isnull(d.ReviewerId, - 1) = @AuthorIdFilter          
          OR isnull(d.ProxyId, - 1) = @AuthorIdFilter          
          )          
         AND d.CurrentVersionStatus = 22          
         AND d.SignedByAuthor = 'Y'          
         )          
        OR (          
         (          
          (          
           isnull(d.AuthorId, - 1) != @AuthorIdFilter          
           AND isnull(d.ReviewerId, - 1) != @AuthorIdFilter          
           AND isnull(d.ProxyId, - 1) != @AuthorIdFilter          
           )          
          AND d.[Status] = 22          
          AND d.SignedByAuthor = 'Y'          
          )          
         )      
   OR  --If @includeErrorDocument is checked and Status is 22      
   (       
  @IncludeErrorDocument = 'Y'      
  AND ( d.[Status] = 26      
         OR d.CurrentVersionStatus = 26        
   ) )          
        )          
       )          
      OR -- Signed          
      --(@StatusFilter = 5 and d.Status = 22 and isnull(d.SignedByAuthor, 'N') = 'N') or --Completed                                  
      (          
       @StatusFilter = 5          
       AND (          
        (          
         (          
          isnull(d.AuthorId, - 1) = @AuthorIdFilter          
          OR isnull(d.ReviewerId, - 1) = @AuthorIdFilter          
          OR isnull(d.ProxyId, - 1) = @AuthorIdFilter          
          )          
         AND d.CurrentVersionStatus = 22          
         AND isnull(d.SignedByAuthor, 'N') = 'N'          
         )          
        OR (          
         (          
   (          
           isnull(d.AuthorId, - 1) != @AuthorIdFilter          
           AND isnull(d.ReviewerId, - 1) != @AuthorIdFilter          
           AND isnull(d.ProxyId, - 1) != @AuthorIdFilter          
           )          
          AND d.[Status] = 22          
          AND isnull(d.SignedByAuthor, 'N') = 'N'          
          )          
         )      
   OR      
   (       
  @IncludeErrorDocument = 'Y'      
  AND ( d.[Status] = 26      
         OR d.CurrentVersionStatus = 26        
   ) )          
        )          
       )          
      OR --Completed          
      (          
       @StatusFilter = 6          
       AND dss.DocumentId IS NOT NULL          
       AND dss.SignatureDate IS NULL          
       AND isnull(dss.DeclinedSignature, 'N') = 'N'          
       )          
      OR -- To Co-Sign                                                               
      --(@StatusFilter = 7 and d.Status = 22) or --Signed, Completed                                   
      (          
       @StatusFilter = 7          
       AND (          
        (          
         (          
          isnull(d.AuthorId, - 1) = @AuthorIdFilter          
          OR isnull(d.ReviewerId, - 1) = @AuthorIdFilter          
          OR isnull(d.ProxyId, - 1) = @AuthorIdFilter          
        )          
         AND d.CurrentVersionStatus = 22          
         )          
        OR (          
         (          
          (          
           isnull(d.AuthorId, - 1) != @AuthorIdFilter          
           AND isnull(d.ReviewerId, - 1) != @AuthorIdFilter          
           AND isnull(d.ProxyId, - 1) != @AuthorIdFilter          
           )          
          AND d.[Status] = 22          
          )          
         )      
   OR -- If IncludeErrorDocument is checked and Status =22      
   (       
  @IncludeErrorDocument = 'Y'      
  AND ( d.[Status] = 26      
         OR d.CurrentVersionStatus = 26        
   ) )          
        )          
       )          
      OR --Signed, Completed          
      --(@StatusFilter = 8 and d.Status not in (22, 23)) or -- Not-Signed, Not-Completed                                  
      (          
       @StatusFilter = 8          
       AND (          
        (          
         (          
          isnull(d.AuthorId, - 1) = @AuthorIdFilter          
          OR isnull(d.ReviewerId, - 1) = @AuthorIdFilter          
          OR isnull(d.ProxyId, - 1) = @AuthorIdFilter          
          )          
         AND d.CurrentVersionStatus NOT IN (          
          22          
          ,23 ,26        
          )          
         )          
        OR (          
         (          
          (          
           isnull(d.AuthorId, - 1) != @AuthorIdFilter          
           AND isnull(d.ReviewerId, - 1) != @AuthorIdFilter          
           AND isnull(d.ProxyId, - 1) != @AuthorIdFilter          
           )          
          AND d.[Status] NOT IN (          
           22          
           ,23,26          
           )          
          )          
         )      
   OR      
   (       
  @IncludeErrorDocument = 'Y'      
  AND ( d.[Status] = 26      
         OR d.CurrentVersionStatus = 26        
   ) )          
        )          
       )          
      OR -- Not-Signed, Not-Completed          
      --(@StatusFilter = 9 and d.Status = 21 and d.ToSign = 'Y')) -- To Sign                                   
      (          
       @StatusFilter = 9          
       AND (          
        (          
         (          
          isnull(d.AuthorId, - 1) = @AuthorIdFilter          
          OR isnull(d.ReviewerId, - 1) = @AuthorIdFilter          
          OR isnull(d.ProxyId, - 1) = @AuthorIdFilter          
          )          
         AND d.CurrentVersionStatus = 21          
         AND d.ToSign = 'Y'          
         )          
        OR (          
         (          
          (          
           isnull(d.AuthorId, - 1) != @AuthorIdFilter          
           AND isnull(d.ReviewerId, - 1) != @AuthorIdFilter          
           AND isnull(d.ProxyId, - 1) != @AuthorIdFilter          
           )          
          AND d.[Status] = 21          
          AND d.ToSign = 'Y'          
          )          
         )      
   OR      
   (       
  @IncludeErrorDocument = 'Y'      
  AND ( d.[Status] = 26      
         OR d.CurrentVersionStatus = 26        
   ) )       
             
        )          
       )          
      OR -- To Sign           
      (          
       @StatusFilter = 4036          
       AND (          
        (          
         (isnull(d.ReviewerId, - 1) = @AuthorIdFilter)          
         AND d.CurrentVersionStatus = 21          
         )          
        )          
       )          
      )          
     AND (          
      @DueDaysFilter = 0          
      OR -- All                     
      @DueDaysFilter = 10          
      OR -- All                                  
      (          
       d.[Status] = 20          
       AND -- Only applies for To Do            
       (          
        (          
         @DueDaysFilter = 11          
         AND d.DueDate < @today          
         )          
        OR -- Past Due                                  
        (          
         @DueDaysFilter = 12          
         AND d.DueDate < dateadd(dd, 8, @today)          
         )          
        OR --Due within 1 week and Past Due                                  
        (          
         @DueDaysFilter = 13          
         AND (          
          d.DueDate >= @today          
          OR d.DueDate < dateadd(dd, 15, @today)          
          )          
         )          
        OR -- Due within 14 days                                  
        (          
         @DueDaysFilter = 14          
         AND d.DueDate < dateadd(dd, 15, @today)          
         )          
        OR -- Due within 14 days and Past Due                                  
        (          
         @DueDaysFilter = 15          
         AND (          
          d.DueDate >= @today          
          OR d.DueDate < dateadd(dd, 36, @today)          
          )          
         )          
        OR -- Due within 5 weeks                                  
        (          
         @DueDaysFilter = 16          
         AND (          
          d.DueDate >= @today          
          OR d.DueDate <= dateadd(mm, 3, @today)          
          )          
         )          
        OR -- Due within 3 months                                  
        (          
         @DueDaysFilter = 17          
         AND d.DueDate > dateadd(mm, 3, @today)          
         ) -- Due greater than 3 months                                  
        )          
       )          
      )          
     )          
    )       
     AND   -- 20.12.2016 Ravichandra      
       (        
       (ISNULL(@DosFrom,'') = ''       
       OR CAST(D.EffectiveDate AS DATE) >= @DosFrom      
        )        
       AND (      
     ISNULL(@DosTo,'')=''      
     OR CAST(D.EffectiveDate AS DATE)  <= @DosTo      
     )      
       )       
                     
 -- JUNE-03-2016 Akwinass      
 UPDATE D      
 SET D.HasMoreThanOneVersion = DVC.HasMoreThanOneVersion      
 FROM #ResultSet D      
 JOIN (  SELECT DV.DocumentId,CASE WHEN COUNT(DV.DocumentId) > 1 THEN 'Yes' ELSE 'No'END HasMoreThanOneVersion      
   FROM DocumentVersions DV      
   WHERE EXISTS (SELECT 1 FROM #ResultSet D WHERE DV.DocumentId = D.DocumentId AND ISNULL(DV.RecordDeleted, 'N') = 'N')      
   GROUP BY DV.DocumentId      
   ) DVC ON D.DocumentId = DVC.DocumentId       
         
 UPDATE C      
 SET C.Attachments = (SELECT COUNT(ImageRecordId) FROM ImageRecords IR WHERE IR.ServiceId = C.ServiceId AND ISNULL(IR.RecordDeleted, 'N') = 'N')      
 FROM #ResultSet C      
 JOIN Services S ON C.ServiceId = S.ServiceId      
 JOIN ProcedureCodes PC ON S.ProcedureCodeId = PC.ProcedureCodeId      
   --                                  
   -- If the sort expression has changed, resort the data set, otherwise goto Final and retrieve the page                                  
   --           
         
     --Chita Ranjan SEP-21-2017-----      
    --- 27/10/2017 Sunil.D       
 CREATE TABLE #DocumentCount(NativeDocumentId int, total int)      
  INSERT INTO #DocumentCount(NativeDocumentId,total)       
     SELECT AD.NativeDocumentId, COUNT(AD.NativeDocumentId)       
    FROM #ResultSet D        
   JOIN AssociateDocuments AD ON AD.NativeDocumentId=D.DocumentId       
   AND ISNULL(AD.RecordDeleted, 'N') = 'N'       
  GROUP by AD.NativeDocumentId       
        
;WITH CTE AS (      
       SELECT AD.NativeDocumentId,      
       CASE WHEN t.total >1 THEN 'Multiple'  WHEN t.total =1 THEN DC.DocumentName  END AS  DocumentName ,      
     AD.DocumentId As DocumentId,      
     S.Screenid AS Screenid,      
     D1.ServiceId As ServiceId      
  FROM #ResultSet D        
   JOIN #DocumentCount  t ON T.NativeDocumentId=D.DocumentId      
   JOIN AssociateDocuments AD ON AD.NativeDocumentId=D.DocumentId      
   AND ISNULL(AD.RecordDeleted, 'N') = 'N'       
   JOIN Documents D1 ON D1.DocumentId=AD.DocumentId      
   AND ISNULL(D1.RecordDeleted, 'N') = 'N'      
   JOIN DocumentCodes DC ON DC.DocumentCodeId=D1.DocumentCodeId      
    JOIN screens S  ON S.documentcodeid = DC.documentcodeid       
  GROUP by AD.NativeDocumentId ,AD.DocumentId,DC.DocumentName,t.total,S.Screenid ,D1.ServiceId      
)      
      
UPDATE  R      
SET R.AssociateDocuments = Isnull(cte.DocumentName,'Add'),      
R.AssociateDocumentId=CTE.DocumentId,      
R.AssociateScreenId=CTE.Screenid,      
R.AssociateServiceId=CTE.ServiceId      
FROM #ResultSet R    JOIN cte      
   on (R.DocumentId = cte.NativeDocumentId)      
UPDATE  R      
SET R.AssociateDocuments =Isnull(R.AssociateDocuments,'Add')      
FROM #ResultSet R        
--------------------------------------------------------------------      
                              
   ;          
          
  WITH Counts          
  AS (          
   SELECT count(*) AS totalrows          
   FROM #ResultSet          
   )          
   ,RankResultSet          
  AS (          
   SELECT DocumentId          
    ,ServiceId          
    ,DocumentCodeId          
    ,DocumentScreenId          
    ,ClientId          
    ,DocumentName          
    ,EffectiveDate          
    ,[Status]          
    ,StatusName          
    ,DueDate          
    ,AuthorId          
    ,AuthorName          
    ,ToCoSign          
    ,ClientToSign          
    ,Shared      
    -- JUNE-03-2016 Akwinass          
    ,HasMoreThanOneVersion      
    -- SEP-22-2016 Chita Ranjan      
    ,AssociateDocuments      
    --- 27/10/2017 Sunil.D       
 ,AssociateDocumentId       
 ,AssociateScreenId       
 ,AssociateServiceId       
 ,Attachments      
    ,COUNT(*) OVER () AS TotalCount          
    ,RANK() OVER (          
     ORDER BY CASE           
       WHEN @SortExpression = 'DocumentName'          
        THEN DocumentName          
       END          
      ,CASE           
       WHEN @SortExpression = 'DocumentName desc'          
        THEN DocumentName          
       END DESC          
      ,CASE           
       WHEN @SortExpression = 'EffectiveDate'          
        THEN EffectiveDate          
       END          
      ,CASE           
       WHEN @SortExpression = 'EffectiveDate desc'          
        THEN EffectiveDate          
       END DESC          
      ,CASE           
       WHEN @SortExpression = 'StatusName'          
        THEN StatusName          
       END          
      ,CASE           
       WHEN @SortExpression = 'StatusName desc'          
        THEN StatusName          
       END DESC          
      ,CASE           
       WHEN @SortExpression = 'DueDate'          
        THEN DueDate          
       END          
      ,CASE           
       WHEN @SortExpression = 'DueDate desc'          
        THEN DueDate          
       END DESC          
      ,CASE           
       WHEN @SortExpression = 'AuthorName'          
        THEN AuthorName          
       END          
      ,CASE           
       WHEN @SortExpression = 'AuthorName desc'          
        THEN AuthorName          
       END DESC          
      ,CASE           
       WHEN @SortExpression = 'ToCoSign'          
        THEN ToCoSign          
       END          
      ,CASE           
       WHEN @SortExpression = 'ToCoSign desc'          
        THEN ToCoSign          
       END DESC          
      ,CASE           
       WHEN @SortExpression = 'ClientToSign'          
        THEN ClientToSign          
       END          
      ,CASE           
       WHEN @SortExpression = 'ClientToSign desc'          
        THEN ClientToSign          
       END DESC          
      ,CASE           
       WHEN @SortExpression = 'Shared'          
        THEN Shared          
       END          
      ,CASE           
       WHEN @SortExpression = 'Shared desc'          
        THEN Shared          
       END DESC      
      ,CASE -- JUNE-03-2016 Akwinass       
       WHEN @SortExpression = 'HasMoreThanOneVersion'          
        THEN HasMoreThanOneVersion          
       END          
      ,CASE           
       WHEN @SortExpression = 'HasMoreThanOneVersion DESC'          
        THEN HasMoreThanOneVersion          
       END      
     -- SEP-22-2016 Chita Ranjan      
       ,CASE WHEN @SortExpression = 'AssociateDocuments'       
        THEN AssociateDocuments END      
       ,CASE WHEN @SortExpression = 'AssociateDocuments DESC'       
        THEN AssociateDocuments       
        END DESC      
      ,CASE       
       WHEN @SortExpression = 'Attachments'          
        THEN Attachments          
       END          
      ,CASE           
       WHEN @SortExpression = 'Attachments DESC'          
        THEN Attachments          
       END           
      ,EffectiveDate DESC          
      ,DocumentName          
      ,ListPageSCDocumentId          
     ) AS RowNumber          
   FROM #ResultSet          
   WHERE DocumentScreenId IS NOT NULL          
   )          
  SELECT TOP (          
    CASE           
     WHEN (@PageNumber = - 1)          
      THEN (          
        SELECT ISNULL(totalrows, 0)          
        FROM counts          
        )          
     ELSE (@PageSize)          
     END          
    ) DocumentId          
   ,ServiceId          
   ,DocumentCodeId          
   ,DocumentScreenId          
   ,ClientId          
   ,DocumentName          
   ,EffectiveDate          
   ,[Status]          
   ,StatusName          
   ,DueDate          
   ,AuthorId          
   ,AuthorName          
   ,ToCoSign          
   ,ClientToSign          
   ,Shared       
   -- JUNE-03-2016 Akwinass      
   ,HasMoreThanOneVersion         
    -- SEP-22-2016 Chita Ranjan      
   ,AssociateDocuments      
   --- 27/10/2017 Sunil.D        
 ,AssociateDocumentId       
 ,AssociateScreenId       
 ,AssociateServiceId      
 ,Attachments       
   ,RowNumber          
   ,TotalCount          
  INTO #FinalResultSet          
  FROM RankResultSet          
  WHERE RowNumber > ((@PageNumber - 1) * @PageSize)          
       

 SET @JsonResult =  dbo.smsf_FlattenedJSON      
   (      
   (      
   SELECT DocumentName AS DocumentName 
       ,DocumentCodeId as DocumentCodeId     
       ,EffectiveDate AS EffectiveDate      
       ,StatusName AS Status      
       ,HasMoreThanOneVersion AS version      
       ,DueDate AS  DueDate      
       ,AuthorName AS Author      
       ,ToCoSign AS ToCoSign      
       ,ClientToSign AS OtherToSign      
       ,Shared AS Shared      
       FROM #FinalResultSet      
       FOR XML PATH, ROOT      
 )      
 );
 END TRY   
 BEGIN CATCH          
  DECLARE @Error VARCHAR(8000)          
          
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_ListPageSCDocuments') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR,
 ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())          
          
  RAISERROR (          
    @Error          
    ,-- Message text.                                                                                                        
    16          
    ,-- Severity.                                                                                                        
    1 -- State.                                                                                                        
    );          
 END CATCH          
END 