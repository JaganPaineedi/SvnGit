

/****** Object:  StoredProcedure [dbo].[ssp_SCWebDashMyDocumentSelShowProc]    Script Date: 09/20/2016 16:05:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebDashMyDocumentSelShowProc]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWebDashMyDocumentSelShowProc]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCWebDashMyDocumentSelShowProc]    Script Date: 09/20/2016 16:05:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 CREATE PROCEDURE [dbo].[ssp_SCWebDashMyDocumentSelShowProc]    
    @StaffId INT ,    
    @LoggedInStaffId INT ,    
    @RefreshData CHAR(1) = NULL            
/********************************************************************************                                                  
-- Stored Procedure: dbo.ssp_SCWebDashMyDocumentSelShowProc                                                    
--                                                  
-- Copyright: Streamline Healthcate Solutions                                                  
--                                                  
-- Purpose: used by dashboard Documents widget                                                  
--                                                  
-- Updates:                                                                                                         
-- Date        Author       Purpose                                                  
-- 10.20.2010  SFarber       Redesigned.         
-- 06.23.2011  Damanpreet Kaur     Modified ref: Task #117 DocumentAcknowledgement    
-- 09.20.2011  Shifali       Modified ref: Task #11 Document Status - To Be Reviewed    
            (Replaced Status with CurrentVersionStatus field as well)    
-- 01.26.2012  avoss       Do not insert into #DocumentCodeFilters if there are no records for the @DocumentNavigationId for core lists    
   03.01.2012  avoss       Fixed to match dashboard and listpages for to review and proxy    
-- 18June2012  Vikas Kashyap     Modified ref: Task#1230 Distinct Document Count & Co-Sign Add ReviewId    
-- 06.22.2012  Sanjayb/Amit Kumar Srivastava, #1721,  Harbor Go Live Issues,       
            The My Document banner has no "To co-sign" in th filter drop down. The co-signed document is not showing up when filtering       
            by this. In the dashboard the widget Documents is not showing the "To Co-sign" document.     
-- 15-Jan-2013  Varinder      Ref to Task #102 3.5x Issues.    
--             What: Optimized the stored procedure    
--            Why:  Stored procedure is taking 21 seconds to execute.    
--08 Jan, 2013 By Rakesh-II      W r t Task 449 in Centra Wellness Bugs/ Features      
AUG-27-2014  dharvey       Added local variables to avoid parameter sniffing      
Feb-02-2015  Revathi       what:Join with Screens table    
            why:task #331 Care Management to SmartCare Env. Issues Tracking      
Sept-21-2015 Neelima       What:Added BannerName Condition to get BannerName based on DocumentNavigationId     
            Why: MFS - Customization Issue Tracking Task #95        
Nov-10-2015  Neelima       What:Added @BannerNameReview and BannerNameNotes Condition to get BannerName based on DocumentNavigationId     
            Why: MFS - Customization Issue Tracking Task #95     
JAN-25-2016  Neelima       What:Added DispalyAs and removed BannerName Condition to get BannerName based on DocumentNavigationId     
            Why: MFS - Customization Issue Tracking Task #95               
May-03-2016  Msood       Harbor Support task # 908, Core Bugs - 908, Barry Support - 510            
            What: Commented the code "OR d.CurrentVersionStatus = 25 " for InProgress.     
            Why : Separate Select is already written for "ToBeReviewed". 
Sep-20-2016 Pradeep Kumar Yadav 
            What : Modify the logic add record deleted check for Clients
			Why  : For Task #345 Barry- Support   
*********************************************************************************/    
AS     
    
    
 /** SET LOCAL VARIABLES **/    
    DECLARE @Local_StaffId INT ,    
        @Local_LoggedInStaffId INT ,    
        @Local_RefreshData CHAR(1)       
    SELECT @Local_StaffId = @StaffId ,    
        @Local_LoggedInStaffId = @LoggedInStaffId ,    
        @Local_RefreshData = @RefreshData    
    /** SET LOCAL VARIABLES **/    
      
    
    
    
     
    DECLARE @TxDocumentNavigationId INT            
    DECLARE @NotesDocumentNavigationId INT                
    DECLARE @PerRevDocumentNavigationId INT         
    DECLARE @ToAcknowledgeDocumentNavigationId INT           
    DECLARE @NotesInProgress INT             
    DECLARE @NotesToSign INT            
    DECLARE @NotesToCoSign INT    
    DECLARE @NotesToAcknowledge INT           
    DECLARE @TxInProgress INT            
    DECLARE @TxToSign INT            
    DECLARE @TxToCoSign INT        
    DECLARE @TxToAcknowledge INT        
    DECLARE @TxDue INT            
    DECLARE @PerRevInProgress INT            
    DECLARE @PerRevToSign INT            
    DECLARE @PerRevToCoSign INT      
    DECLARE @PerRevToAcknowledge INT           
    DECLARE @PerRevDue INT            
    DECLARE @OthersInProgress INT            
    DECLARE @OthersToSign INT            
    DECLARE @OthersToCoSign INT            
    DECLARE @OthersToAcknowledge INT            
    DECLARE @OthersDue INT     
    DECLARE @NotesToBeReviewed INT    
    DECLARE @TxToBeReviewed INT    
    DECLARE @PerRevToBeReviewed INT    
    DECLARE @OthersToBeReviewed INT           
    DECLARE @BannerName varchar(100) /* Sept-21-2015 Added by Neelima Task#95 MFS Customization Issue Tracking */    
    DECLARE @BannerNameReview varchar(100) /* NOV-10-2015 Added by Neelima Task#95 MFS Customization Issue Tracking */    
    DECLARE @BannerNameNotes varchar(100) /* NOV-10-2015 Added by Neelima Task#95 MFS Customization Issue Tracking */    
            
--if exists(select *             
--            from DocumentsWidgetCache a                
--                 cross join Widgets b                
--           where b.WidgetId = 3             
--             and datediff(mi, a.LastRefreshed, getdate()) < isnull(b.RefreshInterval,0)                
--             and a.StaffId = @Local_StaffId             
--             and a.LoggedInStaffId = @Local_LoggedInStaffId                
--             and isnull(@Local_RefreshData,'') <> 'Y')                
--begin                
--  select @NotesDocumentNavigationid = NotesDocumentNavigationid,                
--         @NotesInProgress = NotesInProgress,                
--         @NotesToSign = NotesToSign,                
--         @NotesToCoSign = NotesToCoSign,                
--         @TxDocumentNavigationId = TxDocumentNavigationId,                
--         @TxInProgress = TxInProgress,                
--         @TxToSign = TxToSign,                
--         @TxToCoSign = TxToCoSign,                
--         @TxDue = TxDue,                
--         @PerRevDocumentNavigationId = PerRevDocumentNavigationId,                
--         @PerRevInProgress = PerRevInProgress,                
--         @PerRevToSign = PerRevToSign,                
--         @PerRevToCoSign = PerRevToCoSign,                
--         @PerRevDue = PerRevDue,                
--         @OthersInProgress = OthersInProgress,                
--         @OthersToSign = OthersToSign,                
--         @OthersToCoSign = OthersToCoSign,                
--         @OthersDue = OthersDue            
--    from DocumentsWidgetCache             
--   where StaffId = @Local_StaffId            
--     and LoggedInStaffId = @Local_LoggedInStaffId                
            
--  goto FinalSelect                
--end                
            
    CREATE TABLE #DocumentCodeFilters    
        (    
          DocumentCodeId INT ,    
          DocumentNavigationId INT    
        )               
    CREATE TABLE #DocumentCounts    
        (    
          CountType VARCHAR(20) ,    
          DocumentNavigationId INT ,    
          DocumentCount INT    
        )            
             
--delete from DocumentsWidgetCache where StaffId = @Local_StaffId and LoggedInStaffId = @Local_LoggedInStaffId                 
               
    SELECT  @NotesDocumentNavigationId = a.DocumentNavigationId    
    FROM    DocumentWidgetDocumentNavigations a    
    WHERE   a.ColumnNumber = 1                
                
    SELECT  @TxDocumentNavigationId = a.DocumentNavigationId    
    FROM    DocumentWidgetDocumentNavigations a    
    WHERE   a.ColumnNumber = 2          
                
    SELECT  @PerRevDocumentNavigationId = a.DocumentNavigationId    
    FROM    DocumentWidgetDocumentNavigations a    
    WHERE   a.ColumnNumber = 3        
          
 /* Sept-21-2015 Added by Neelima Task#95 MFS Customization Issue Tracking */    
    SELECT TOP 1 @BannerName = DN.DisplayAs     
 FROM DocumentWidgetDocumentNavigations a    
 LEFT JOIN DocumentNavigations DN ON DN.DocumentNavigationId = a.DocumentNavigationId    
 LEFT JOIN Banners B ON B.BannerId = DN.BannerId    
 WHERE a.DocumentNavigationId = @TxDocumentNavigationId     
    
 /* NOV-10-2015 Added by Neelima Task#95 MFS Customization Issue Tracking */    
  SELECT TOP 1 @BannerNameReview = DN.DisplayAs       
 FROM DocumentWidgetDocumentNavigations a      
 LEFT JOIN DocumentNavigations DN ON DN.DocumentNavigationId = a.DocumentNavigationId      
 LEFT JOIN Banners B ON B.BannerId = DN.BannerId      
 WHERE a.DocumentNavigationId = @PerRevDocumentNavigationId     
     
  /* NOV-10-2015 Added by Neelima Task#95 MFS Customization Issue Tracking */    
    SELECT TOP 1 @BannerNameNotes = DN.DisplayAs     
 FROM DocumentWidgetDocumentNavigations a      
 LEFT JOIN DocumentNavigations DN ON DN.DocumentNavigationId = a.DocumentNavigationId      
 LEFT JOIN Banners B ON B.BannerId = DN.BannerId      
 WHERE a.DocumentNavigationId = @NotesDocumentNavigationId     
      
     
    IF @NotesDocumentNavigationId IS NOT NULL     
        BEGIN    
            INSERT  INTO #DocumentCodeFilters    
                    ( DocumentCodeId    
                    )    
                    EXEC ssp_GetDocumentNavigationDocumentCodes @DocumentNavigationId = @NotesDocumentNavigationId                
            UPDATE  #DocumentCodeFilters    
            SET     DocumentNavigationId = @NotesDocumentNavigationid    
            WHERE   DocumentNavigationId IS NULL            
        END    
    
    IF @TxDocumentNavigationId IS NOT NULL     
        BEGIN    
            INSERT  INTO #DocumentCodeFilters    
                    ( DocumentCodeId    
                    )    
                    EXEC ssp_GetDocumentNavigationDocumentCodes @DocumentNavigationId = @TxDocumentNavigationId                
            UPDATE  #DocumentCodeFilters    
            SET     DocumentNavigationId = @TxDocumentNavigationId    
            WHERE   DocumentNavigationId IS NULL            
        END    
       
    IF @PerRevDocumentNavigationId IS NOT NULL     
        BEGIN     
            INSERT  INTO #DocumentCodeFilters    
                    ( DocumentCodeId    
                    )    
                    EXEC ssp_GetDocumentNavigationDocumentCodes @DocumentNavigationId = @PerRevDocumentNavigationId                
            UPDATE  #DocumentCodeFilters    
            SET     DocumentNavigationId = @PerRevDocumentNavigationId    
            WHERE   DocumentNavigationId IS NULL            
        END     
    
    INSERT  INTO #DocumentCodeFilters    
            ( DocumentCodeId    
            )    
            EXEC ssp_GetDocumentNavigationDocumentCodes @DocumentNavigationId = NULL            
    UPDATE  #DocumentCodeFilters    
    SET     DocumentNavigationId = 0    
    WHERE   DocumentNavigationId IS NULL            
            
        
    INSERT  INTO #DocumentCounts    
            ( CountType ,    
              DocumentNavigationId ,    
              DocumentCount    
            )    
            SELECT  'ToAcknowledge' ,    
                    dcf.DocumentNavigationId ,    
                    COUNT(DISTINCT d.DocumentId)     
 --from DocumentsAcknowledgements da      
        -- join Documents d  on da.DocumentId = d.DocumentId     
        -- join DocumentSignatures ds on ds.DocumentId = d.DocumentId               
        -- join StaffClients c on c.ClientId = d.ClientId and c.StaffId = @Local_LoggedInStaffId     
        --join #DocumentCodeFilters dcf on dcf.DocumentCodeId = d.DocumentCodeId           
  --where   isnull(da.RecordDeleted, 'N') <> 'Y'                                
  --and isnull(d.RecordDeleted, 'N') <> 'Y'          
  -- and da.AcknowledgedByStaffId=@Local_LoggedInStaffId    
  -- and da.DateAcknowledged is null    
            FROM    Documents d    
                    JOIN #DocumentCodeFilters dcf ON dcf.DocumentCodeId = d.DocumentCodeId    
                    --02/02/2015 Revathi    
                     join Screens sr on sr.DocumentCodeId= d.DocumentCodeId    
            WHERE   EXISTS ( SELECT 1    
                             FROM   DocumentsAcknowledgements da    
                             WHERE  da.DocumentId = d.DocumentId    
           AND ISNULL(da.RecordDeleted, 'N') <> 'Y'    
                                    AND da.AcknowledgedByStaffId = @Local_LoggedInStaffId    
                                    AND da.DateAcknowledged IS NULL )    
                    AND EXISTS ( SELECT 1    
                                 FROM   DocumentSignatures ds    
                                 WHERE  ds.DocumentId = d.DocumentId )    
                    AND EXISTS ( SELECT 1    
                                 FROM   StaffClients c    
                                 WHERE  c.ClientId = d.ClientId    
                                        AND c.StaffId = @Local_LoggedInStaffId )    
                    AND ISNULL(d.RecordDeleted, 'N') <> 'Y'    
            GROUP BY dcf.DocumentNavigationId    
            UNION     
/*Changes By Shifali Starts Here for To Be Reviewed*/    
/*Show documents with to be reviewed Status(25) as In Progress for Author*/      
--That makes no sense -- changing        
            SELECT  'InProgress' ,    
                    dcf.DocumentNavigationId ,    
                    COUNT(DISTINCT d.DocumentId)    
            FROM    Documents d    
                    JOIN #DocumentCodeFilters dcf ON dcf.DocumentCodeId = d.DocumentCodeId     
                      --02/02/2015 Revathi    
                     join Screens sr on sr.DocumentCodeId= d.DocumentCodeId               
     --join StaffClients c on c.ClientId = d.ClientId and c.StaffId = @Local_LoggedInStaffId      
            WHERE   EXISTS ( SELECT 1    
                             FROM   StaffClients c join Clients cl On c.ClientId=cl.ClientId   
                             WHERE  c.ClientId = d.ClientId    
                                    AND c.StaffId = @Local_LoggedInStaffId 
                                    AND  ISNULL(cl.RecordDeleted, 'N') = 'N' )   --Added By Pradeep Y
                                       
                    AND ( d.AuthorId = @Local_StaffId    
                          OR d.ProxyId = @Local_StaffId    
                        )    
                    AND ( d.CurrentVersionStatus = 21    
                     -- Commented by msood Harbor Support task # 908, Core Bugs - 908, Barry Support - 510    
                          --OR d.CurrentVersionStatus = 25    
                        )    
                    AND ISNULL(d.RecordDeleted, 'N') <> 'Y'
                        
            GROUP BY dcf.DocumentNavigationId       
/*Ends here*/    
            UNION    
            SELECT  'Due' ,    
                    dcf.DocumentNavigationId ,    
                    COUNT(DISTINCT d.DocumentId)    
            FROM    Documents d    
                    JOIN #DocumentCodeFilters dcf ON dcf.DocumentCodeId = d.DocumentCodeId           
                      --02/02/2015 Revathi    
                     join Screens sr on sr.DocumentCodeId= d.DocumentCodeId         
     --join StaffClients c on c.ClientId = d.ClientId and c.StaffId = @Local_LoggedInStaffId     
     --below alise c to table  StaffClients was not given which was giving issue done w r t task  4489 in Centra Bugs/features                
            WHERE   EXISTS ( SELECT 1    
                             FROM   StaffClients c    
                             WHERE  c.ClientId = d.ClientId    
                                    AND c.StaffId = @Local_LoggedInStaffId )    
                    AND ( d.AuthorId = @Local_StaffId    
                          OR d.ProxyId = @Local_StaffId    
                        )    
                    AND d.CurrentVersionStatus = 20    
                    AND d.DueDate < CONVERT(VARCHAR(10), DATEADD(dd, 14, GETDATE()), 101)    
                    AND ISNULL(d.RecordDeleted, 'N') <> 'Y'    
            GROUP BY dcf.DocumentNavigationId    
        UNION    
            SELECT  'ToSign' ,    
                    dcf.DocumentNavigationId ,    
                    COUNT(DISTINCT d.DocumentId)    
            FROM    Documents d    
                    JOIN #DocumentCodeFilters dcf ON dcf.DocumentCodeId = d.DocumentCodeId     
                      --02/02/2015 Revathi    
                     join Screens sr on sr.DocumentCodeId= d.DocumentCodeId        
      --join DocumentSignatures ds on ds.DocumentId = d.DocumentId                
      --join StaffClients c on c.ClientId = d.ClientId and c.StaffId = @Local_LoggedInStaffId     
            WHERE   EXISTS ( SELECT 1    
                             FROM   DocumentSignatures ds    
                             WHERE  ds.DocumentId = d.DocumentId    
                                    AND ds.Signaturedate IS NULL    
                                    AND ISNULL(ds.DeclinedSignature, 'N') = 'N'    
                                    AND ds.StaffId = @Local_StaffId    
                                    AND ds.StaffId = d.AuthorId    
                                    AND ISNULL(ds.RecordDeleted, 'N') <> 'Y' )    
                    AND EXISTS ( SELECT 1    
                                 FROM   StaffClients c    
                                 WHERE  c.ClientId = d.ClientId    
                                        AND c.StaffId = @Local_LoggedInStaffId )    
                    AND d.CurrentVersionStatus = 21    
                    AND d.ToSign = 'Y'    
                    AND ISNULL(d.RecordDeleted, 'N') <> 'Y'    
            GROUP BY dcf.DocumentNavigationId    
            UNION    
            SELECT  'ToCoSign' ,    
                    dcf.DocumentNavigationId ,    
                    COUNT(DISTINCT d.DocumentId)    
            FROM    Documents d    
                    JOIN #DocumentCodeFilters dcf ON dcf.DocumentCodeId = d.DocumentCodeId       
                     --02/02/2015 Revathi    
                     join Screens sr on sr.DocumentCodeId= d.DocumentCodeId        
       --join DocumentSignatures ds on ds.DocumentId = d.DocumentId      
       --join StaffClients c on c.ClientId = d.ClientId and c.StaffId = @Local_LoggedInStaffId    
       -- BY Rakesh-II added alise in  below line to signaturedate wi r t task 449 in Centra wellness/ Bugs & Customization       
            WHERE   EXISTS ( SELECT 1    
                             FROM   DocumentSignatures ds    
                             WHERE  ds.DocumentId = d.DocumentId    
                                    AND ds.signaturedate IS NULL    
                                    AND ISNULL(ds.declinedsignature, 'N') = 'N'    
                                    AND ds.StaffId = @Local_StaffId    
                                    AND ds.StaffId <> d.AuthorId    
                                    AND ( ds.StaffId <> ISNULL(d.ReviewerId, 0) )    
                                    AND ISNULL(ds.RecordDeleted, 'N') <> 'Y' )    
                    AND EXISTS ( SELECT 1    
                                 FROM   StaffClients c    
                                 WHERE  c.ClientId = d.ClientId    
                                        AND c.StaffId = @Local_LoggedInStaffId )    
                    AND d.CurrentVersionStatus = 22 --21                
                    AND ISNULL(d.RecordDeleted, 'N') <> 'Y'    
            GROUP BY dcf.DocumentNavigationId    
            UNION    
/*Changes By Shifali Starts Here for To Be Reviewed*/    
/*Show documents with to be reviewed Status(25) as To Be Reviewed for Reviewer*/    
--Also display author documents that are to be reviewed           
            SELECT  'ToBeReviewed' ,    
                    dcf.DocumentNavigationId ,    
                    COUNT(DISTINCT d.DocumentId)    
            FROM    Documents d    
                    JOIN #DocumentCodeFilters dcf ON dcf.DocumentCodeId = d.DocumentCodeId     
                      --02/02/2015 Revathi    
                     join Screens sr on sr.DocumentCodeId= d.DocumentCodeId               
   --join StaffClients c on c.ClientId = d.ClientId and c.StaffId = @Local_LoggedInStaffId                
            WHERE   EXISTS ( SELECT 1    
                             FROM   StaffClients c    
                             WHERE  c.ClientId = d.ClientId    
                                    AND c.StaffId = @Local_LoggedInStaffId )    
                    AND ( d.ReviewerId = @Local_StaffId    
                          OR ( d.ReviewerId <> @Local_StaffId    
                               AND d.AuthorId = @Local_StaffId    
                             )    
                        )    
                    AND d.CurrentVersionStatus = 25    
                    AND ISNULL(d.RecordDeleted, 'N') <> 'Y'    
            GROUP BY dcf.DocumentNavigationId            
/* Ends Here */    
    
             
--select 'ToAcknowledge', dcf.DocumentNavigationId, count(d.DocumentId)     
-- from DocumentsAcknowledgements da      
--         join Documents d  on da.DocumentId = d.DocumentId     
--         join DocumentSignatures ds on ds.DocumentId = d.DocumentId      
--         join #DocumentCodeFilters dcf on dcf.DocumentCodeId = d.DocumentCodeId     
--         join StaffClients c on c.ClientId = d.ClientId and c.StaffId = @Local_LoggedInStaffId           
-- where ds.Signaturedate is not null             
--   and isnull(ds.DeclinedSignature, 'N') = 'N'                                  
--   and ds.StaffId = @Local_StaffId             
--   and ds.StaffId = d.AuthorId                                  
--   and isnull(d.RecordDeleted, 'N') <> 'Y'                                  
--   and isnull(ds.RecordDeleted, 'N') <> 'Y'                                  
-- group by dcf.DocumentNavigationId         
    
            
    SELECT  @NotesInProgress = MAX(CASE WHEN CountType = 'InProgress'    
                                             AND DocumentNavigationId = @NotesDocumentNavigationId THEN DocumentCount    
                                        ELSE 0    
                                   END) ,    
            @NotesToSign = MAX(CASE WHEN CountType = 'ToSign'    
                                         AND DocumentNavigationId = @NotesDocumentNavigationId THEN DocumentCount    
                                    ELSE 0    
                               END) ,    
            @NotesToCoSign = MAX(CASE WHEN CountType = 'ToCoSign'    
                                           AND DocumentNavigationId = @NotesDocumentNavigationId THEN DocumentCount    
                                      ELSE 0    
                                 END) ,    
            @NotesToAcknowledge = MAX(CASE WHEN CountType = 'ToAcknowledge'    
                                                AND DocumentNavigationId = @NotesDocumentNavigationId THEN DocumentCount    
                                           ELSE 0    
                                      END) ,    
            @TxInProgress = MAX(CASE WHEN CountType = 'InProgress'    
                                          AND DocumentNavigationId = @TxDocumentNavigationId THEN DocumentCount    
                                     ELSE 0    
                                END) ,    
            @TxToSign = MAX(CASE WHEN CountType = 'ToSign'    
                                      AND DocumentNavigationId = @TxDocumentNavigationId THEN DocumentCount    
                                 ELSE 0    
                            END) ,    
            @TxToCoSign = MAX(CASE WHEN CountType = 'ToCoSign'    
                                        AND DocumentNavigationId = @TxDocumentNavigationId THEN DocumentCount    
                                   ELSE 0    
                              END) ,    
            @TxToAcknowledge = MAX(CASE WHEN CountType = 'ToAcknowledge'    
                                             AND DocumentNavigationId = @TxDocumentNavigationId THEN DocumentCount    
                                        ELSE 0    
                                   END) ,    
            @TxDue = MAX(CASE WHEN CountType = 'Due'    
                                   AND DocumentNavigationId = @TxDocumentNavigationId THEN DocumentCount    
                              ELSE 0    
                         END) ,    
            @PerRevInProgress = MAX(CASE WHEN CountType = 'InProgress'    
                                              AND DocumentNavigationId = @PerRevDocumentNavigationId THEN DocumentCount    
                                         ELSE 0    
                                    END) ,    
            @PerRevToSign = MAX(CASE WHEN CountType = 'ToSign'    
                                          AND DocumentNavigationId = @PerRevDocumentNavigationId THEN DocumentCount    
                                     ELSE 0    
                                END) ,    
            @PerRevToCoSign = MAX(CASE WHEN CountType = 'ToCoSign'    
                                         AND DocumentNavigationId = @PerRevDocumentNavigationId THEN DocumentCount    
                                       ELSE 0    
                                  END) ,    
            @PerRevToAcknowledge = MAX(CASE WHEN CountType = 'ToAcknowledge'    
                                                 AND DocumentNavigationId = @PerRevDocumentNavigationId THEN DocumentCount    
                                            ELSE 0    
                                       END) ,    
            @PerRevDue = MAX(CASE WHEN CountType = 'Due'    
                                       AND DocumentNavigationId = @PerRevDocumentNavigationId THEN DocumentCount    
                                  ELSE 0    
                             END) ,                   
       /*Changes by Shifali in ref to Task# 11( To Be Reviewed)*/    
            @NotesToBeReviewed = MAX(CASE WHEN CountType = 'ToBeReviewed'    
                                               AND DocumentNavigationId = @NotesDocumentNavigationId THEN DocumentCount    
                                          ELSE 0    
                                     END) ,    
            @TxToBeReviewed = MAX(CASE WHEN CountType = 'ToBeReviewed'    
                                            AND DocumentNavigationId = @TxDocumentNavigationId THEN DocumentCount    
                                       ELSE 0    
                                  END) ,    
            @PerRevToBeReviewed = MAX(CASE WHEN CountType = 'ToBeReviewed'    
                                                AND DocumentNavigationId = @PerRevDocumentNavigationId THEN DocumentCount    
                                           ELSE 0    
                                      END) ,    
            @OthersToBeReviewed = MAX(CASE WHEN CountType = 'ToBeReviewed'    
                                                AND DocumentNavigationId = 0 THEN DocumentCount    
                                           ELSE 0    
                                      END) ,                   
       /*Ends here*/    
            @OthersInProgress = MAX(CASE WHEN CountType = 'InProgress'    
                                              AND DocumentNavigationId = 0 THEN DocumentCount    
                                         ELSE 0    
                                    END) ,    
            @OthersToSign = MAX(CASE WHEN CountType = 'ToSign'    
                                          AND DocumentNavigationId = 0 THEN DocumentCount    
                                     ELSE 0    
                                END) ,    
            @OthersToCoSign = MAX(CASE WHEN CountType = 'ToCoSign'    
                                            AND DocumentNavigationId = 0 THEN DocumentCount    
                                       ELSE 0    
                                  END) ,    
            @OthersToAcknowledge = MAX(CASE WHEN CountType = 'ToAcknowledge'    
                                                 AND DocumentNavigationId = 0 THEN DocumentCount    
                                            ELSE 0    
                                       END) ,    
            @OthersDue = MAX(CASE WHEN CountType = 'Due'    
                                       AND DocumentNavigationId = 0 THEN DocumentCount    
                                  ELSE 0    
                             END)    
    FROM    #DocumentCounts dc            
            
            
--insert into DocumentsWidgetCache (               
--       StaffId,                
--       LoggedInStaffId,                
--       LastRefreshed,                
--       NotesDocumentNavigationid,                
--       NotesInProgress,                
--       NotesToSign,                
--       NotesToCoSign,                
--       TxDocumentNavigationId,                
--       TxInProgress,                
--       TxToSign,                
--       TxToCoSign,                
--       TxDue,                
--       PerRevDocumentNavigationId,                
--       PerRevInProgress,                
--       PerRevToSign,                
--       PerRevToCoSign,                
--       PerRevDue,          
--       OthersDocumentNavigationId,                
--       OthersInProgress,                
--       OthersToSign,                
--       OthersToCoSign,                
--       OthersDue)       
             
    SELECT     
      --@Local_StaffId, @Local_LoggedInStaffId, getdate(),       
            @NotesDocumentNavigationId AS NotesDocumentNavigationid ,    
            @NotesInProgress AS NotesInProgress ,    
            @NotesToSign AS NotesToSign ,    
            @NotesToCoSign AS NotesToCoSign ,    
            @NotesToAcknowledge AS NotesToAcknowledge ,    
            NULL AS NotesDue ,    
            @TxDocumentNavigationId AS TxDocumentNavigationId ,    
            @TxInProgress AS TxInProgress ,    
            @TxToSign AS TxToSign ,    
            @TxToCoSign AS TxToCoSign ,    
            @TxToAcknowledge AS TxToAcknowledge ,    
            @TxDue AS TxDue ,    
            @PerRevDocumentNavigationId AS PerRevDocumentNavigationId ,    
            @PerRevInProgress AS PerRevInProgress ,    
            @PerRevToSign AS PerRevToSign ,    
            @PerRevToCoSign AS PerRevToCoSign ,    
            @PerRevToAcknowledge AS PerRevToAcknowledge ,    
            @PerRevDue AS PerRevDue ,    
            0 AS OtherDocumentNavigationId ,    
            @OthersInProgress AS OthersInProgress ,    
            @OthersToSign AS OthersToSign ,    
            @OthersToCoSign AS OthersToCoSign ,    
            @OthersToAcknowledge AS OthersToAcknowledge ,    
            @OthersDue AS OthersDue ,    
       /*Changes by Shifali in ref to Task# 11( To Be Reviewed)*/    
            @NotesToBeReviewed AS NotesToBeReviewed ,    
            @TxToBeReviewed AS TxToBeReviewed ,    
            @PerRevToBeReviewed AS PerRevToBeReviewed ,    
            @OthersToBeReviewed AS OthersToBeReviewed,    
   @BannerName AS BannerName /* Sept-21-2015 Added by Neelima Task#95 MFS Customization Issue Tracking */    
   ,@BannerNameReview AS BannerNameReview   /* NOV-10-2015 Added by Neelima Task#95 MFS Customization Issue Tracking */    
   ,@BannerNameNotes AS BannerNameNotes  /* NOV-10-2015 Added by Neelima Task#95 MFS Customization Issue Tracking */    
       /*Ends here*/            
            
--FinalSelect:                
            
--select @NotesDocumentNavigationid as NotesDocumentNavigationid,                
--       @NotesInProgress as NotesInProgress,                
--       @NotesToSign as NotesToSign,                
--       @NotesToCoSign as NotesToCoSign,                
--       null as NotesDue,                
--       @TxDocumentNavigationId as TxDocumentNavigationId,                
--       @TxInProgress as TxInProgress,                
--       @TxToSign as TxToSign,                
--       @TxToCoSign as TxToCoSign,                
--       @TxDue as TxDue,         
--       @PerRevDocumentNavigationId as PerRevDocumentNavigationId,                
--       @PerRevInProgress as PerRevInProgress,                
--       @PerRevToSign as PerRevToSign,                
--       @PerRevToCoSign as PerRevToCoSign,                
--       @PerRevDue as PerRevDue,                
--       0 as OthersDocumentNavigationId,                
--       @OthersInProgress as OthersInProgress,                
--       @OthersToSign as OthersToSign,                
--       @OthersToCoSign as OthersToCoSign,                
--    @OthersDue as OthersDue                
            
    RETURN 
GO


