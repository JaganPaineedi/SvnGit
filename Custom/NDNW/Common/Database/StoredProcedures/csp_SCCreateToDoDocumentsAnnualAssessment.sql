/****** Object:  StoredProcedure [dbo].[csp_SCCreateToDoDocumentsAnnualAssessment]    Script Date: 5/15/2018 11:06:13 AM ******/
if object_id('dbo.csp_SCCreateToDoDocumentsAnnualAssessment') is not null 
DROP PROCEDURE [dbo].[csp_SCCreateToDoDocumentsAnnualAssessment]
GO

/****** Object:  StoredProcedure [dbo].[csp_SCCreateToDoDocumentsAnnualAssessment]    Script Date: 5/15/2018 11:06:13 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[csp_SCCreateToDoDocumentsAnnualAssessment]
AS

/*******************************************************************************
Date			Author			Purpose
-----------		---------------	--------------------------------------------
24/Nov/2015		Govind		    Created - New Directions-Sup Go Live Task # 139
02/15/2016		praorane		Added a year to the review date to determine due date for the document
05/02/2018      Bfagaly	        added active check task New Directions 827
********************************************************************************/

     BEGIN
         DECLARE @AlertType INT
       
          SET @AlertType =
         (
             SELECT GlobalCodeId
             FROM GlobalCodes 
             WHERE CodeName = 'Documents'
                   AND Category = 'AlertType'
         )
         DECLARE @DocumentCodeId INT= ISNULL(
                                            (
                                                SELECT DocumentCodeId
                                                FROM DocumentCodes
                                                WHERE DocumentName = 'Assessment'
                                                      AND ISNULL(RecordDeleted, 'N') = 'N'
                                            ), 0)
         DECLARE @NewDocuments TABLE(DocumentId INT)
         DECLARE @NewDocumentVersions TABLE
         (DocumentId        INT,
          DocumentVersionId INT
         )
         --drop table #ClientsWithAnnualAssessmentDueIn14Days1
         CREATE TABLE #ClientsWithAnnualAssessmentDueIn14Days1
         (ClientId          INT,
          AssessmentDate    DATETIME,
          ReviewDate        DATETIME,
          --,ReviewIntervalDays int
          ReviewDueInDays   INT,
          AssessmentType    CHAR(1),
          DocumentId        INT,
          DocumentVersionId INT
         )
         INSERT INTO #ClientsWithAnnualAssessmentDueIn14Days1
         (ClientId,
          AssessmentDate,
          ReviewDate,
          --,ReviewIntervalDays
          ReviewDueInDays,
          AssessmentType,
          DocumentId,
          DocumentVersionId
         )
                SELECT ClientId = d.ClientId,
                       AssessmentDate = d.effectivedate,
                       ReviewDate = DATEADD(YEAR, 1, chra.currentassessmentdate),
	
/*,ReviewIntervalDays =
	case when p.ReviewEntireCareType  = 'S'
	then cast(ltrim(replace(dbo.csf_GetGlobalCodeNameById(p.ReviewEntireCarePlan), 'days', '')) as int)
	else null
	end*/
 
                       ReviewDueInDays = NULL,
                       AssessmentType = chra.assessmenttype,
                       DocumentId = d.DocumentId,
                       DocumentVersionId = d.CurrentDocumentVersionId
                FROM dbo.customhrmassessments chra
                     JOIN Documents d ON chra.DocumentVersionId = d.CurrentDocumentVersionId
                     JOIN Clients c ON d.ClientId = c.ClientId
                WHERE d.[status] = 22
				      AND c.Active='Y' -- added active check task New Directions 827
                      AND chra.assessmenttype = 'A'
                      AND ISNULL(chra.RecordDeleted, 'N') = 'N'
                      AND ISNULL(d.RecordDeleted, 'N') = 'N'
                      AND ISNULL(c.RecordDeleted, 'N') = 'N'


         --select * from #ClientsWithAnnualAssessmentDueIn14Days1 WHERE ClientId = 6
         -- Step 2a: Compute ReviewDueInDays, ReviewDate as needed ...

/*update #ClientsWithAnnualAssessmentDueIn14Days
	set ReviewDate = dateadd(day, ReviewIntervalDays, AssessmentDate)
	where ReviewDate is null*/

         UPDATE #ClientsWithAnnualAssessmentDueIn14Days1
           SET
               ReviewDueInDays = DATEDIFF(day, GETDATE(), ReviewDate)
         WHERE ReviewDueInDays IS NULL
         --select * from #ClientsWithAnnualAssessmentDueIn14Days1
         -- Step 2b: Remove from the temp table unless Review Due Date is within 30 days...
         DELETE FROM #ClientsWithAnnualAssessmentDueIn14Days1
         WHERE ReviewDueInDays > 14
 OR ReviewDueInDays <= 0
               OR ReviewDueInDays IS NULL

         --select * from #ClientsWithAnnualAssessmentDueIn14Days1
         -- New Documents ...
         INSERT INTO dbo.Documents
         (ClientId,
          EffectiveDate,
          DueDate,
          DocumentCodeId,
          AuthorId,
          [Status],
          CurrentVersionStatus,
          DocumentShared,
          CreatedBy,
          ModifiedBy
         )
         OUTPUT inserted.DocumentId
                INTO @NewDocuments(DocumentId)
                SELECT ClientId = r.ClientId,
                       EffectiveDate = r.ReviewDate,
                       DueDate = r.ReviewDate,
                       DocumentCodeId = @DocumentCodeId,
                       AuthorId = c.PrimaryClinicianId,
                       [Status] = 20, -- To Do
                       CurrentVersionStatus = 20, -- To Do
                       DocumentShared = 'Y',
                       CreatedBy = 'SYSTEM',
                       ModifiedBy = 'SYSTEM'
                FROM #ClientsWithAnnualAssessmentDueIn14Days1 AS r
                     JOIN dbo.Clients AS c ON c.ClientId = r.ClientId
                WHERE NOT EXISTS
                (
                    SELECT *
                    FROM Documents
                    WHERE ClientId = r.ClientId
                          AND DocumentCodeId = @DocumentCodeId
                       --   AND AuthorId = c.PrimaryClinicianId
                          AND EffectiveDate > = r.ReviewDate 
                          AND [Status] IN ( 20,21,22,25)
                          AND ISNULL(RecordDeleted, 'N') = 'N'
                )

         -- New Document Versions ...
         INSERT INTO dbo.DocumentVersions
         (DocumentId,
          [Version],
          AuthorId,
          EffectiveDate,
          CreatedBy,
          ModifiedBy
         )
         OUTPUT inserted.DocumentID,
                inserted.DocumentVersionId
                INTO @NewDocumentVersions(DocumentId,
                                          DocumentVersionId)
                SELECT DocumentId = nd.DocumentId,
                       [Version] = 1,
                       AuthorId = d.AuthorId,
                       EffectiveDate = d.EffectiveDate,
                       CreatedBy = 'SYSTEM',
                       ModifiedBy = 'SYSTEM'
                FROM @NewDocuments AS nd
                     JOIN dbo.Documents AS d ON nd.DocumentId = d.DocumentId

         -- Set Document Current and InProgress DocumentVersionIDs ...
         UPDATE doc
           SET
               CurrentDocumentVersionId = ndv.DocumentVersionId,
               InProgressDocumentVersionId = ndv.DocumentVersionId
         FROM dbo.Documents AS doc
              JOIN @NewDocumentVersions AS ndv ON doc.DocumentId = ndv.DocumentId

         INSERT INTO alerts
         (ToStaffId,
          ClientId,
          AlertType,
          DocumentId,
          Unread,
          DateReceived,
          Subject,
          Message
         )
                SELECT D.AuthorId, --h.AlertToUser, --to Staff (service clinician)  
                       D.ClientId,
                       @AlertType, --Documents
                       D.DocumentId,
                       'Y',
                       GETDATE(),
                       'Annual Assessment due in 14 Days', --Subject  
                       'Client, '+C.lastname+', '+C.Firstname+' Annual Assessment is due on '+CONVERT( VARCHAR(20), DATEADD(yyyy, 1, D.EffectiveDate), 101)+'.'
                FROM @NewDocuments N
                     JOIN Documents D ON N.DocumentId = D.Documentid
                     JOIN clients C ON C.Clientid = D.Clientid
                     where d.authorid is not null

                --message  

/*
	-- New Custom Document table records	...
	insert into dbo.DocumentCarePlanReviews
	( DocumentVersionId
	,CreatedBy
	,ModifiedBy
	)
	select DocumentVersionId = ndv.DocumentVersionId
	,CreatedBy = 'SYSTEM'
	,ModifiedBy = 'SYSTEM'
	from @NewDocumentVersions as ndv
	*/



     END



GO


