 /****** Object:  StoredProcedure [dbo].[ssp_ListPageSCDocuments]    Script Date: 11/08/2013 15:54:40 ******/
 IF object_id('ssp_ListPageSCDocuments', 'P') IS NOT NULL
 DROP PROCEDURE dbo.ssp_ListPageSCDocuments
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_ListPageSCDocuments] @SessionId VARCHAR(30)    
 ,@InstanceId INT    
 ,@PageNumber INT    
 ,@PageSize INT    
 ,@SortExpression VARCHAR(100)    
 ,@ClientId INT    
 ,@ClinicianId INT    
 ,@AuthorIdFilter INT    
 ,@StatusFilter INT    
 ,@DueDaysFilter INT    
 ,@DocumentNavigationId INT    
 ,@OtherFilter INT    
 ,@LoggedInStaffId INT = - 1  
 ,@DosFrom datetime='' -- 20.12.2016	Ravichandra
 ,@DosTo  datetime=''  -- 20.12.2016	Ravichandra
 ,@IncludeErrorDocument CHAR(3)  --05/06/2017 PranayB Harbor#857
 /*=================================================================================================                           
-- Stored Procedure: dbo.ssp_ListPageSCDocuments                              
--                            
-- Copyright: Streamline Healthcate Solutions                            
--                            
-- Purpose: used by Client Documents list page                            
--                            
-- Updates:                                                                                   
-- Date        Author      Purpose                            
-- 08.15.2009  SFarber     Created.                                  
-- 03.25.2010  Vikas Monga Updated (Add new parameter @DocumentNavigationId to implement GoToDocument dropdown functionality).                           
--                         (Remove 2 parameters @DocumentCodeIdFilter,DocumentBannerFilter not required)        
-- 23.04.2010  Mahesh      Sorting (Rename the sort expression StatusName from Status on case when @SortExpression= 'StatusName' then StatusName end,      
--                         2. Use Ltrim & Rtrim  funciton for remove space on @sortExpression /\/\ |<      
-- 10.05.2010  Mahesh      1) Select ServiceID of doucment 2) Alter table ListPageSCDocuments      
-- 06.25.2010  SFarber     Modified custom filters logic.      
-- 07.07.2010  SFarber     Modified to use ssp_GetDocumentNavigationDocumentCodes      
-- 07.27.2010  SFarber     Removed join to ImageRecords.      
-- 10.20.2010  SFarber     Replaced @ResultSet with #ResultSet      
-- 11.21.2011  Shifali    Modifications by Shifali in ref to task# 11 (Document Status - To Be Reviewed)     
-- 10.29.2012  Vikas Kashyap    What:Need To Get DocumentNavigationId=-1 Record List condition    
--        Why: When DocumentNavigationId associated with screen Then open no Document List on LDocument ListPage                 
-- 03.21.2014  TRemisoski  Added image record description if available.      
-- 04.24.2014  T.Remisoski    What:Only test the most current client signature row per document to determine whether client needs to sign    
--        Why: Some documents listed twice when multiple versions of document exist and client has not signed.      
-- 06.24.2014  Gautam      What : Removed the table ListPageSCDocuments from SP why : Ace task#107,Engineering Improvement Initiatives- NBL(I)      
/* 08.20.2014  Kirtee      What : Removed set @PageNumber = 1 statement from SP why :  Same documents lists is displayed when clicked on any page     
                           wrf Core Bugs Task# 265 */                                   
-- 01.31.2015 Vamsi  What:Need To display procedure code behind the service note type.      
--       Why:Valley - Customizations #924           
-- 03.13.2015   Chethan N What: Checking for orders permission for the logged in staff    
       Why: Woods - Customizations task#844     
-- 05.07.2015 Gautam  What: Assign Screenid =102 when DocumentCodes that have Document type 17 and do not have any ScreeneId    
       Why: Woods - Core bugs #473     
-- JUNE-03-2016 Akwinass  What: Included HasMoreThanOneVersion column
                          Why: To display whether the document has more than one version or not (Task #383 in Philhaven Development)
-- Nov-22-2016  Anto      What: Modified the logic to avoid duplicates in the list page.
                          Why: Showing duplicates in the list page if there is more version and that signed by different staff and client(Key Point - Support Go Live 629)                           
-- 20.12.2016 Ravichandra What: Added Date Filters Paramter @DosFrom and @DosTo
						  why : Bradford - Customizations Tasks #289--My Documents List page: Add 'All Statuses' to status drop down >                                
--02/10/2017      jcarlson   Keystone Customizations 69 - increased documentname length to 175 to handle procedure code display as increasing to 75   
--04/11/2017     Pranayb    Harbor support# 857- Added @IncludeErrorDocument  to include the Error Document only when the check box is checked                         
-- 08/21/2017    Gautam   What: Changed the code to not show duplicate records when client Orders received why: AP- SGL#356
 -- SEP-22-2016 Chita Ranjan   What: Added new column AssociateDocuments to display all associted documents in the list page
                               Why: Thresholds-Enhancements – Task# 838
 -- SEP-26-2016 Neethu   What:   Added scsp call to Append the document name with the sub type  
                         Why:    AspenPointe SGL – Task# 471
 --- --27/10/2017 Sunil.D      What: Extened Logic written by Chitta In Above Comments "SEP-22-2016 Chita Ranjan"
                               Why: As Per Requirement it is needed,Thresholds-Enhancements – Task# 838	
--24-NOV-2017   Akwinass    Added "Attachments" column (Task #589 in Engineering Improvement Initiatives- NBL(I))
----14/12/2107   Prem      What:Changed the code to get documents in ListPage
                            Why: Previously created documents are not showing in the documents list page, Barry - Support #523   
-- 17/01/2018   Arjun K R  Modified to pull co-signer staffs and co-signer clients and guardian. Task #113 MHP Customizations.
--16/03/2018   Neha           What: Added a new column 'Group Name' to display the Group name if the document is a Group Service Note.
                               Why: MHP-Enhancements – Task# 193
--May/10/2018   Swatika Shinde What/Why: Included a check to DocumentCodeId = 300 (Progress Note) - to display the Template Name instead of Document Name as all the Tempaltes will have only one DocumentCodes with DocumentName as Progress Note
--							              as part of Renaissance - Dev Items: #640.2
--04/26/2018  Rega			Updated the limit of characters in #result set select statement. Task #234 springriver SGL	
-- 12/03/2018   Lakshmi  Added record deleted check for imagerecords table, as per the task 	AHN-Support Go Live #174						   
-- 6/15/2018  Robert Caffrey - Increased Datatype to Varchar150 for ClientToSign field in #ResultSet - Multiple Client Contacts Selected - KeyPoint #1345
-- 10/29/2018	Chethan N		What : 1. Showing Current Status of the document for both Author and Non-Author.
									   2. Displaying the count of versions in Ver column instead of 'Yes' or 'No'.
								Why : Valley - Support Go Live task # 1601
========================================================================================================================================*/    
AS    
BEGIN    
 BEGIN TRY    
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
   ,ClientToSign VARCHAR(150)    
   ,Shared VARCHAR(3) 
   -- JUNE-03-2016 Akwinass
   ,HasMoreThanOneVersion VARCHAR(3) 
    -- SEP-22-2016 Chita Ranjan
   ,AssociateDocuments VARCHAR(175),
   --27/10/2017 Sunil.D 
		AssociateDocumentId int,
		AssociateScreenId int,
		AssociateServiceId int,
		Attachments INT,
		GroupName  varchar(100), 
		GroupId int,    
		GroupServiceId int  
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
    ,@DosFrom = @DosFrom    -- 20.12.2016	Ravichandra
    ,@DosTo = @DosTo		-- 20.12.2016	Ravichandra
      
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
   ,GroupName    
   ,GroupId    
   ,GroupServiceId   
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
   ,CASE     
     WHEN pc.DisplayDocumentAsProcedureCode = 'Y'    
      THEN pc.DisplayAs    
     WHEN dc.DocumentCodeId = 2    
      AND tp.PlanOrAddendum = 'A'    
      THEN 'TxPlan Addendum'    
       -- 01.31.2015  Vamsi  To display procedure code behind the service note type.         
     WHEN dc.ServiceNote = 'Y'
						THEN CASE 
								WHEN pc.DisplayAs IS NOT NULL
									THEN dc.DocumentName + ' ( ' + pc.DisplayAs + ' )' else dc.DocumentName end
								ELSE 
								CASE --Added by swatika May-10-2018
										WHEN dc.DocumentCodeId = 300
											THEN ISNULL(NT.TemplateName, dc.DocumentName)
										ELSE dc.DocumentName
										END
								END     
    -- 03.21.2014  TRemisoski  If image is scanned and has a description, show it after the DocumentName    
    + CASE     
     WHEN imr.RecordDescription IS NOT NULL    
      THEN '(' + ltrim(rtrim(imr.RecordDescription)) + ')'    
     ELSE ''    
     END    
   ,d.EffectiveDate    
   ,    
   /*Commented & changed by Shifali on 21Nov ref task# 11(To be reviewed)*/    
    /*10/29/2018- Changes by Chethan N : displaying Current Status for both Author and Non-Author*/   
   d.CurrentVersionStatus AS [Status],                            
   /*CASE      
    WHEN (    
      d.AuthorId = @ClinicianId    
      OR d.ReviewerId = @ClinicianId    
      )    
     THEN d.CurrentVersionStatus    
    ELSE d.[Status]    
    END AS [Status]    
   ,     */
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
   ,left(a.LastName + ', ' + a.FirstName,100)--limited to 100 characters 04/26/2018 Task #234 spring river SGL    
    --17/01/2018   Arjun K R Start
   ,LEFT(CASE      
    WHEN dss.DocumentId IS NOT NULL    
     AND dss.SignatureDate IS NULL    
     AND isnull(dss.DeclinedSignature, 'N') = 'N'     
     THEN (SELECT Staff.LastName+', '+Staff.FirstName FROM Staff WHERE Staff.StaffId=dss.StaffId)     
    ELSE NULL    
    END,50) --limited to 50 characters 04/26/2018 Task #234 spring river SGL    
   ,LEFT(CASE      
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
    END,50) --limited to 50 characters 04/26/2018 Task #234 spring river SGL
      --17/01/2018   Arjun K R End
   ,CASE     
    WHEN d.DocumentShared = 'Y'    
     THEN 'Yes'    
    ELSE 'No'    
    END
	,IsNull(G.GroupName,'') as 'GroupName',
    GS.GroupId,
    GS.GroupServiceId
  FROM Documents d    
  INNER JOIN DocumentCodes dc ON dc.DocumentCodeId = d.DocumentCodeId    
  /*Commented & changed by Shifali on 21Nov ref task# 11(To be reviewed)*/    
  /*10/29/2018- Changes by Chethan N : displaying Current Status for both Author and Non-Author*/   
  join GlobalCodes gcs on gcs.GlobalCodeId = d.CurrentVersionStatus                           
  /*INNER JOIN GlobalCodes gcs ON gcs.GlobalCodeId = CASE       
    WHEN (    
      d.AuthorId = @ClinicianId    
      OR d.ReviewerId = @ClinicianId    
      )    
     THEN d.CurrentVersionStatus    
    ELSE d.[Status]    
    END    */
  INNER JOIN Staff a ON a.StaffId = d.AuthorId    
  -- 05/07/2015 Gautam
  left join Services Se on Se.ServiceId = d.ServiceId  and isNull(Se.RecordDeleted,'N')<>'Y'
  left outer join GroupServices GS on Se.GroupServiceId=GS.GroupServiceId and isNull(GS.RecordDeleted,'N')<>'Y'
  left outer join Groups G ON GS.GroupId=G.GroupId   
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
AND isnull(imr.RecordDeleted, 'N') = 'N' --Added by Lakshmi on 12/03/2018  
   Left Join #OrdersData OD on D.DocumentId=OD.DocumentId    --Added By prem 14/12/2017
   LEFT JOIN DocumentProgressNotes DPN ON DPN.DocumentVersionId = d.CurrentDocumentVersionId
							AND isnull(DPN.RecordDeleted, 'N') = 'N' LEFT JOIN NoteTemplates NT ON NT.NoteTemplateId = DPN.TemplateID
							AND isnull(NT.RecordDeleted, 'N') = 'N'  --Added by swatika 10/05/2018

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
     AND   -- 20.12.2016	Ravichandra
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
	  /*10/29/2018- Changes by Chethan N : displaying count of Document version*/ 
	UPDATE D
	SET D.HasMoreThanOneVersion = DVC.HasMoreThanOneVersion
	FROM #ResultSet D
	JOIN (  SELECT DV.DocumentId, COUNT(DV.DocumentId) AS HasMoreThanOneVersion
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
	,GroupName
	,GroupId   
	,GroupServiceId
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
       ,case when @SortExpression= 'GroupName' then GroupName end,
       case when @SortExpression= 'GroupName desc' then GroupName end desc       
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
	,GroupName,
	GroupId,
	GroupServiceId	
   ,RowNumber    
   ,TotalCount    
  INTO #FinalResultSet    
  FROM RankResultSet    
  WHERE RowNumber > ((@PageNumber - 1) * @PageSize)    
    
  IF (    
    SELECT ISNULL(COUNT(*), 0)    
    FROM #FinalResultSet    
   ) < 1    
  BEGIN    
   SELECT 0 AS PageNumber    
    ,0 AS NumberOfPages    
    ,0 NumberOfRows    
  END    
  ELSE    
  BEGIN    
   SELECT TOP 1 @PageNumber AS PageNumber    
    ,CASE (TotalCount % @PageSize)    
     WHEN 0    
      THEN ISNULL((TotalCount / @PageSize), 0)    
     ELSE ISNULL((TotalCount / @PageSize), 0) + 1    
     END AS NumberOfPages    
    ,ISNULL(TotalCount, 0) AS NumberOfRows    
   FROM #FinalResultSet    
  END    
   
 -- SEP-26-2016 Neethu
   
 IF EXISTS (SELECT * 
           FROM   sys.Objects 
           WHERE  object_id = Object_id(N'[dbo].[scsp_ListPageSCUpdateDocuments ]') 
                  AND type IN ( N'P', N'PC' ))  
        BEGIN 
        EXEC scsp_ListPageSCUpdateDocuments  
        END  
 
 ---
 
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
	,GroupName,  
	GroupId,
	GroupServiceId  
  FROM #FinalResultSet    
  ORDER BY RowNumber  

  
  
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
GO



