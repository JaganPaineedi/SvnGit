/****** Object:  StoredProcedure [dbo].[ssp_SCGetHRMTPClientNeeds]    Script Date: 09/24/2015 15:31:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
        
ALTER PROCEDURE [dbo].[ssp_SCGetHRMTPClientNeeds]
    @ClientId INT ,
    @DocumentId INT ,
    @Version INT ,
    @ForInitialization CHAR(1) ,
    @DocumentVersionId INT
AS /******************************************************************************                                                  
**  File:                                                   
**  Name: [ssp_SCGetHRMTPClientNeeds]                                                  
**  Desc:  called by ssp_SCGetTreatmentPlanHRM                                                
**                                                  
**  This template can be customized:                                                  
**                                                                
**  Return values:                                                  
**                                                   
**  Called by: ssp_SCGetTreatmentPlanHRM                                                     
**                                                                
**  Parameters:                                                  
**  Input    Output                                                  
**  @ClientId                                             
**                                            
**                                              
**                                            
**  Auth:  Sonia Dhamija                                                 
**  Date:  09/07/2008                                                 
*******************************************************************************                                                  
**  Change History                                                  
*******************************************************************************                                                  
**  Date:  Author:    Description:                                                  
**  27/08/2008 Sonia Modified                           
**With Reference to Task #260                           
**For new needs added in the context of the current treatment plan/version, the radio buttons and check box and delete options should always be available.                          
                           
**--------  --------    ----------------------------------------------------                                                  
/*09/April/09 Priya Modified the table Clientneeds to CustomClientNeeds and TPNeedsClientNeeds to  CustomTPNeedsClientNeeds */                                           
     May 28,2009:updated by munish singla in lieu of task 3108 to comment the print statement                      
           
     -----------------------      
     Updated by Ashwani Kumar Angrish for new dataModel changes.      
     on:16 july 2010      
     changed SourceDocumentId to SourceDocumentVersionId       
*******************************************************************************/                                                
    BEGIN                                            
        BEGIN TRY                                            
                                        
                                                            
            DECLARE @DocumentIDHRMTP AS BIGINT                                                                                                                            
            DECLARE @VersionHRMTP AS BIGINT                                                                 
            DECLARE @DocumentIDHRMAD AS BIGINT                                                                
            DECLARE @VersionHRMAD AS BIGINT                                              
            DECLARE @DocumentIDHRMASS AS BIGINT                                                   
            DECLARE @VersionHRMASS AS BIGINT                 
                                        
                                        
              
--Variables for HRMAssessment                                                              
            SET @DocumentIDHRMASS = 0                                                                                                                        
            SET @VersionHRMASS = 0                                
--Variables for HRMTP                                                              
            SET @DocumentIDHRMTP = 0                         
            SET @VersionHRMTP = 0                                                               
--Variables for HRMAD                                                        
            SET @DocumentIDHRMAD = 0                                                                       
            SET @VersionHRMAD = 0                                          
                             
                                        
--Addendum Plan                                                                             
--GETS THE MAXIMUM DOCUMENTID FOR A SIGNED AddendumPlan  DOCUMENT                
                
--Changed By Anuj as per new datamodal changes                                                         
--select top 1 @DocumentIDHRMAD= a.DocumentId,  @VersionHRMAD=a.CurrentVersion  from Documents a where a.ClientId = @ClientId  and a.EffectiveDate <= convert(datetime, convert(varchar, getdate(),101)) and a.Status = 22 and a.DocumentCodeId =503 and      
  
     
     
         
         
           
--Changes ended over here                
                
            SELECT TOP 1
                    @DocumentIDHRMAD = a.DocumentId ,
                    @VersionHRMAD = a.CurrentDocumentVersionId
            FROM    Documents a
            WHERE   a.ClientId = 1387
                    AND a.EffectiveDate <= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101))
                    AND a.Status = 22
                    AND a.DocumentCodeId = 503
                    AND ISNULL(a.RecordDeleted, 'N') <> 'Y'
            ORDER BY a.EffectiveDate DESC ,
                    ModifiedDate DESC                                                    
              
            PRINT @DocumentIDHRMAD          
          
                                                               
--HRMTreatment Plan                                                            
--GETS THE MAXIMUM DOCUMENTID FOR A SIGNED HRMTreatmentPlan  DOCUMENT                  
--Changed By Anuj as per new datamodal changes                                                                                                                         
--select top 1 @DocumentIDHRMTP= a.DocumentId,  @VersionHRMTP=a.CurrentVersion  from Documents a where a.ClientId = @ClientId  and a.EffectiveDate <= convert(datetime, convert(varchar, getdate(),101)) and a.Status = 22 and a.DocumentCodeId =350 and       
  
    
      
        
          
--Changes Ended over here                
            SELECT TOP 1
                    @DocumentIDHRMTP = a.DocumentId ,
                    @VersionHRMTP = a.CurrentDocumentVersionId
            FROM    Documents a
            WHERE   a.ClientId = 34632
                    AND a.EffectiveDate <= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101))
                    AND a.Status = 22
                    AND a.DocumentCodeId = 350
                    AND ISNULL(a.RecordDeleted, 'N') <> 'Y'
            ORDER BY a.EffectiveDate DESC ,
                    ModifiedDate DESC                                                        
        
                                                      
                                                                 
--GETS THE MAXIMUM DOCUMENTID FOR A SIGNED HRMASSESSMENT                                                                     
                
--Changed By Anuj as per new datamodal changes                   
--select top 1 @DocumentIDHRMASS= a.DocumentId,  @VersionHRMASS=a.CurrentVersion  from Documents a where a.ClientId = @ClientId  and a.EffectiveDate <= convert(datetime, convert(varchar, getdate(),101)) and a.Status = 22 and a.DocumentCodeId =349 and     
  
    
      
        
          
            
--Changes ended over here     
                
                
            SELECT TOP 1
                    @DocumentIDHRMASS = a.DocumentId ,
                    @VersionHRMASS = a.CurrentDocumentVersionId
            FROM    Documents a
            WHERE   a.ClientId = @ClientId
                    AND a.EffectiveDate <= CONVERT(DATETIME, CONVERT(VARCHAR, GETDATE(), 101))
                    AND a.Status = 22
                    AND a.DocumentCodeId = 349
                    AND ISNULL(a.RecordDeleted, 'N') <> 'Y'
            ORDER BY a.EffectiveDate DESC ,
                    ModifiedDate DESC                                                                                              
                              
                              
            DECLARE @ClientEpisodeId INT                                                             
            SET @ClientEpisodeId = ( SELECT TOP 1
                                            ClientEpisodeId
                                     FROM   ClientEpisodes
                                     WHERE  ClientId = @ClientId
                                            AND ISNULL(RecordDeleted, 'N') = 'N'
                                     ORDER BY EpisodeNumber DESC
                                   )                                                              
                                        
--print @DocumentIDHRMASS                                       
                                              
                   
            IF ( @ForInitialization = 'N' ) 
                BEGIN                                      
                    SELECT DISTINCT
                            C.* ,                          
     --<SONIA>                      
     -- Ref Task #260                          
                            CASE ISNULL(AssessmentUpdateType, '')
                              WHEN '' THEN 'N'
                              ELSE                            
  -- begin                          
                                   CASE ISNULL(C2.HRMAssessmentNeedId, -1)
                                     WHEN -1 THEN 'Y'
                                     ELSE 'N'
                                   END                           
        -- end                          
                            END AS 'DisplayRadioButtons'                          
 -- </SONIA>                          
                    FROM    CustomClientNeeds AS c --Changed By Anuj as per new datamodal changes                                        
   --left join Documents D on C.SourceDocumentId=D.DocumentId and C.SourceDocumentVersion=D.CurrentVersion                   
   --Changes ended over here                
   --By Vikas Vyas in ref TreatmentPlanHRM For Web on Dated 26th Nov,2009        
   --left join Documents D on C.SourceDocumentId=D.DocumentId  and C.SourceDocumentVersion=D.CurrentDocumentVersionId                        
   --End        
   --By Vikas Vyas in ref TreatmentPlanHRM For Web on Dated 26th Nov,2009        
                            LEFT JOIN Documents D ON C.SourceDocumentVersionId = D.CurrentDocumentVersionId
                            INNER JOIN DocumentVersions ON DocumentVersions.DocumentVersionId = D.CurrentDocumentVersionId
                                                           AND c.SourceDocumentVersionId = DocumentVersions.DocumentVersionId        
    --and C.SourceDocumentVersion=D.CurrentDocumentVersionId                        
   --End        
                            LEFT OUTER JOIN CustomHRMAssessmentNeeds AS C2 ON c2.ClientNeedId = c.ClientNeedId
                                                              AND ISNULL(c2.RecordDeleted,
                                                              'N') <> 'Y'                          
                   
   --Changed By Anuj as per new datamodal changes                   
   --left outer join CustomHRMAssessments as cha on cha.DocumentId = c2.DocumentId and cha.Version = c2.Version and isnull(cha.RecordDeleted, 'N') <> 'Y'                 
   --Changes ended over here                
                            LEFT OUTER JOIN CustomHRMAssessments AS cha ON cha.DocumentVersionId = c2.DocumentVersionId
                                                              AND ISNULL(cha.RecordDeleted,
                                                              'N') <> 'Y'                         
                   
   --Changed By Anuj as per new datamodal changes                   
   --left outer join Documents as d1 on d1.DocumentId = cha.DocumentId and isnull(d1.RecordDeleted, 'N') <> 'Y'                
   --Changes ended over here                
                            LEFT OUTER JOIN Documents AS d1 ON d1.CurrentDocumentVersionId = cha.DocumentVersionId
                                                              AND ISNULL(d1.RecordDeleted,
                                                              'N') <> 'Y'
                    WHERE   clientepisodeid = @ClientEpisodeId
                            AND ISNULL(C.RecordDeleted, 'N') = 'N'                           
                              
                       
                        
                                    
 --<Sonia>                                  
--Removed the filters as per discussion with SHS team of 18th July 2008                                  
/*(                                        
 --HRMTP                                        
 (SourceDocumentId=@DocumentIDHRMTP and SourceDocumentVersion=@VersionHRMTP) or                                        
 --HRMAddendum                                        
 (SourceDocumentId=@DocumentIDHRMAD and SourceDocumentVersion=@VersionHRMAD) or                                        
 --HRMAssessment                                        
 (SourceDocumentId=@DocumentIDHRMASS and SourceDocumentVersion=@VersionHRMASS) or                                        
 --Current Document                                        
 (SourceDocumentId=@DocumentId and SourceDocumentVersion=@Version)                                         
 )         */                                  
--<Sonia>                                                             
                END              
            ELSE 
                BEGIN                                      
                    SELECT DISTINCT
                            C.* ,
                            'CustomClientNeeds' AS TableName ,                          
          --<SONIA> Ref Task #260                          
                            CASE ISNULL(AssessmentUpdateType, '')
                              WHEN '' THEN 'N'
                              ELSE                            
   --begin                          
                                   CASE ISNULL(C2.HRMAssessmentNeedId, -1)
                                     WHEN -1 THEN 'Y'
                                     ELSE 'N'
                                   END                           
     --end                          
                            END AS 'DisplayRadioButtons'                          
  --</SONIA>                           
                    FROM    CustomClientNeeds AS c --Changed By Anuj as per new datamodal changes                              
   --left join Documents D on C.SourceDocumentId=D.DocumentId and C.SourceDocumentVersion=D.CurrentVersion                
   --Changes Ended over here                
           
    --By Vikas Vyas in ref TreatmentPlanHRM For Web on Dated 26th Nov,2009               
   --left join Documents D on C.SourceDocumentId=D.DocumentId and C.SourceDocumentVersion=D.CurrentDocumentVersionId                            
   --End        
   --By Vikas Vyas in ref TreatmentPlanHRM For Web on Dated 26th Nov,2009               
                            LEFT JOIN Documents D ON C.SourceDocumentVersionId = D.CurrentDocumentVersionId
                            INNER JOIN DocumentVersions ON DocumentVersions.DocumentVersionId = D.CurrentDocumentVersionId
                                                           AND c.SourceDocumentVersionId = DocumentVersions.DocumentVersionId        
   --End        
                            LEFT OUTER JOIN CustomHRMAssessmentNeeds AS C2 ON c2.ClientNeedId = c.ClientNeedId
                                                              AND ISNULL(c2.RecordDeleted,
                                                              'N') <> 'Y'                          
              
   --Changed By Anuj as per new datamodal changes                   
   --left outer join CustomHRMAssessments as cha on cha.DocumentId = c2.DocumentId and cha.Version = c2.Version and isnull(cha.RecordDeleted, 'N') <> 'Y'                          
   --Changes Ended over here                
                            LEFT OUTER JOIN CustomHRMAssessments AS cha ON cha.DocumentVersionId = c2.DocumentVersionId
                                                              AND ISNULL(cha.RecordDeleted,
                                                              'N') <> 'Y'                          
                   
                   
                      
   --Changed By Anuj as per new datamodal changes                      
   --left outer join Documents as d1 on d1.DocumentId = cha.DocumentId and isnull(d1.RecordDeleted, 'N') <> 'Y'                
   --changes Ended over here                
                            LEFT OUTER JOIN Documents AS d1 ON d1.CurrentDocumentVersionId = cha.DocumentVersionId
                                                              AND ISNULL(d1.RecordDeleted,
                                                              'N') <> 'Y'
                    WHERE   clientepisodeid = @ClientEpisodeId
                            AND ISNULL(C.RecordDeleted, 'N') = 'N'                                  
                          
                              
                END                             
                                    
                                      
                                      
                                        
     
                                          
                                            
        END TRY                                              
                                            
        BEGIN CATCH                                               
            DECLARE @Error VARCHAR(8000)                                                
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
                + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                         'ssp_SCGetHRMTPClientNeeds') + '*****'
                + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
                + CONVERT(VARCHAR, ERROR_STATE())                                                
            DEALLOCATE cur_ClientNeeds                                                                      
                                            
            RAISERROR                                                 
 (                                                
  @Error, -- Message text.                                                
  16, -- Severity.                                                
1 -- State.                                                
 );                                                
                                                
        END CATCH                                             
    END 