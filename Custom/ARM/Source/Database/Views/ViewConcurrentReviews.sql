/****** Object:  View [dbo].[ViewConcurrentReviews]    Script Date: 06/19/2013 17:54:23 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ViewConcurrentReviews]'))
DROP VIEW [dbo].[ViewConcurrentReviews]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ViewConcurrentReviews]'))
EXEC dbo.sp_executesql @statement = N'
Create view [dbo].[ViewConcurrentReviews] as    
/********************************************************************************    
-- View: dbo.ViewConcurrentReviews      
--    
-- Copyright: Streamline Healthcate Solutions    
--    
-- Purpose: returns concurrent review data    
--    
-- Updates:                                                           
-- Date        Author      Purpose    
-- 08.12.2011  SFarber     Created.          
-- 09.07.2011  Pradee      Addedd Documents.Status,AuthorId,ProxyId,DocumentShared in select list as per task#2394
-- Sep-15-2011 Ryan Noble  Modified the second select statement to use a left join on customConcurrentReviews as
--						   an inner join was eliminating scheduled concurrent reviews from inclusion as the custom
--						   table entry does not exist for scheudled events.
-- Sep-20-2011 Ryan Noble  Eliminated Document records from the second select which were already included in the first.
--						   Since the left join added above was then including all prior records.
*********************************************************************************/    
    
-- Legacy data    
select e.InsurerId,    
       e.ClientId,    
       e.EventId as ConcurrentReviewEventId,    
       e.EventTypeId as ConcurrentReviewEventTypeId,    
       d.DocumentId as ConcurrentReviewDocumentId,    
       d.CurrentDocumentVersionId as ConcurrentReviewDocumentVersionId,    
       d.DocumentCodeId as ConcurrentReviewDocumentCodeId,    
       s.ScreenId as ConcurrentReviewScreenId,    
       dp.EventId as PrescreenEventId,    
       dp.DocumentId as PrescreenDocumentId,    
       dp.CurrentDocumentVersionId as PrescreenDocumentVersionId,    
       e.EventDateTime as DateOfConcurrentReview,    
       e.Status as ConcurrentReviewStatus,    
       p.HospitalizationStatus as HospitalizationStatus,    
       cr.ReviewerLastName AS ReviewerLastName,    
       cr.ReviewerFirstName AS ReviewerFirstName,    
       CONVERT(VARCHAR(max),cr.ClinicalUpdate) AS ClinicalUpdate,  
       ------Following Line are added by Pradeep as per task#2394 to test    
       d.Status as ConcurrentReviewDocumentStatus,    
       d.AuthorId as ConcurrentReviewAuthorId,    
       d.ProxyId as ConcurrentReviewProxyId,    
       d.DocumentShared as ConcurrentReviewDocumentShared    
  from Documents d     
       join DocumentVersions dv on dv.DocumentVersionId = d.CurrentDocumentVersionId    
       join CustomConcurrentReviewsOld cr on cr.DocumentVersionId = dv.DocumentVersionId    
       join Events e on e.EventId = d.EventId    
       join DocumentCodes dc on dc.DocumentCodeId = d.DocumentCodeId    
       left join Screens s on s.DocumentCodeId = dc.DocumentCodeId and isnull(s.RecordDeleted, ''N'') = ''N''    
       join Documents dp on dp.DocumentId = cr.PreScreenDocumentId    
       join Events ep on ep.EventId = dp.EventId    
       join CustomPreScreens p on p.DocumentVersionId = dp.CurrentDocumentVersionId    
 where e.EventTypeId = 102    
   and isnull(d.RecordDeleted, ''N'') = ''N''    
   and isnull(dv.RecordDeleted, ''N'') = ''N''    
   and isnull(e.RecordDeleted, ''N'') = ''N''    
   and isnull(cr.RecordDeleted, ''N'') = ''N''    
union    
-- Current data    
select e.InsurerId,    
       e.ClientId,    
       e.EventId as ConcurrentReviewEventId,    
       e.EventTypeId as ConcurrentReviewEventTypeId,    
       d.DocumentId as ConcurrentReviewDocumentId,    
       d.CurrentDocumentVersionId as ConcurrentReviewDocumentVersionId,    
       d.DocumentCodeId as ConcurrentReviewDocumentCodeId,    
       s.ScreenId as ConcurrentReviewScreenId,    
       vp.PrescreenEventId,    
       vp.PrescreenDocumentId,    
       vp.PrescreenDocumentVersionId,    
       e.EventDateTime as DateOfConcurrentReview,    
       e.Status as ConcurrentReviewStatus,    
       vp.HospitalizationStatus,    
       s2.LastName AS ReviewerLastName,    
       s2.FirstName AS ReviewerFirstName,    
       CONVERT(VARCHAR(max),cr.ClinicalUpdate) AS ClinicalUpdate,  
        ------Following Line are added by Pradeep as per task#2394 to test    
       d.Status as ConcurrentReviewDocumentStatus,    
       d.AuthorId as ConcurrentReviewAuthorId,    
       d.ProxyId as ConcurrentReviewProxyId,    
       d.DocumentShared as ConcurrentReviewDocumentShared     
  from Documents d     
       join DocumentVersions dv on dv.DocumentVersionId = d.CurrentDocumentVersionId    
       LEFT join CustomConcurrentReviews cr on cr.DocumentVersionId = dv.DocumentVersionId    
       join Events e on e.EventId = d.EventId    
       join DocumentCodes dc on dc.DocumentCodeId = d.DocumentCodeId    
       left join Screens s on s.DocumentCodeId = dc.DocumentCodeId and isnull(s.RecordDeleted, ''N'') = ''N''    
       join ViewPrescreens vp on vp.ClientId = e.ClientId and vp.DateOfPrescreen < e.EventDateTime    
       JOIN Staff s2 ON s2.staffId = d.AuthorId    
 where e.EventTypeId = 102    
   and not exists(select *    
                    from ViewPrescreens vp2    
                   where vp2.ClientId = e.ClientId    
                     and vp2.DateOfPrescreen < e.EventDateTime    
                     and vp2.DateOfPrescreen > vp.DateOfPrescreen)    
   AND NOT EXISTS(SELECT * FROM dbo.CustomConcurrentReviewsOld cro
					WHERE cro.DocumentVersionId = dv.DocumentVersionId
					AND ISNULL(cro.RecordDeleted,''N'') <> ''Y'')
   
   and isnull(d.RecordDeleted, ''N'') = ''N''    
   and isnull(dv.RecordDeleted, ''N'') = ''N''    
   and isnull(e.RecordDeleted, ''N'') = ''N''    
   and (isnull(cr.RecordDeleted, ''N'') = ''N'' OR cr.RecordDeleted IS NULL)
 AND ISNULL(s2.RecordDeleted, ''N'') <> ''Y''    
    '
GO
