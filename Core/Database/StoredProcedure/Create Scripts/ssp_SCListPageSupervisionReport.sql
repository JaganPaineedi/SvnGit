IF EXISTS (SELECT * 
           FROM   sys.objects 
           WHERE  object_id = 
                  OBJECT_ID(N'[dbo].[ssp_SCListPageSupervisionReport]') 
                  AND type IN ( N'P', N'PC' )) 
  DROP PROCEDURE [dbo].[ssp_SCListPageSupervisionReport] 

go 
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[ssp_SCListPageSupervisionReport] 
(@LoggedInStaffId      INT,   
 @SessionId    VARCHAR(30),   
 @InstanceId           INT,   
 @PageNumber           INT,   
 @PageSize             INT,   
 @SortExpression  VARCHAR(100),   
 @OtherFilter          INT,   
 @DocumentGroupName    INT,   
 @SupervisionDocStatus INT,   
 @DocumentNavigationId INT,   
 @OrganizationLevel    INT,   
 @OrganizationSubLevel INT,   
 @ClientFilter         INT,   
 @DueDaysFilter        INT,
 @AuthorId	       INT,
 @InvokedFromNewDashBoard char(1)='N')   
AS   
  --- exec ssp_SCListPageSupervisionReport @SessionId=N'z1pah445wfrjrp2wdv4upf55',@InstanceId=18,@PageNumber=0,@PageSize=100,   
  ---@SortExpression=N'EffectiveDate desc',@LoggedInStaffId=3,@ClientFilter=0,@OrganizationLevel=1,@OrganizationSubLevel=2,   
  ---@DocumentNavigationId=0,@SupervisionDocStatus=6131,@DocumentGroupName=7042,@OtherFilter=0,@DueDaysFilter=10504   
  /********************************************************************************   
  -- Stored Procedure: dbo.[[ssp_SCListPageSupervisionReport]]   
  --                                                                                                                
  -- Copyright: Streamline Healthcate Solutions                                                                                                                
  --                                                                                                                
  -- Purpose:  To fecth the data for the list page of Supervision Reports                  
  --                                                                                                                
  -- Updates:          
  -- Date            Author          Purpose                                                                                                            
  -- 03 May 2012     Sudhir Singh    To fecth the data for the list page of Supervision Reports   
  -- 19/2/2013       Maninder        What- Now those documents counted whose Author has their PrimaryProgramId assigned at the Team Level   
  --        Earlier documents which are added to OrganizationLevelStaff were being used to count the documents   
  --        Why-  As per task#2764 in Thresholds Bugs/Fetaure    
  -- 21/Nov/2013     Gautam          What : added new input Parameters @DueDaysFilter and changed code based on Supervision document status.   
										Removed the ListPage table code   
										Why : Required for the task #4, Thresholds - Enhancements,Supervision Report Update   
  -- 16/Jan/2014  Gautam			What : Added condition for all division   
										Why : It was showing past data      
  -- 21/02/2014   Venkatesh MR      What : Included CurrentVersionStatus = 25 and Concatinate the Effective date and the Status name in the result set. 
									Why : missing the due date when it goes to excel. Ref Threshold supprt 479     
  -- 07/Mar/2014  Md Hussain Khusro What: added new input Parameters @AuthorId		
									Why : Required for the task #441 Enhancement-Supervision Report Update - Thresholds - Support 
-- 13/oct/2015		Revathi			what:Added ProgramName in Level 2 to  show in hierarchical order
-- 									why:task #466 Valley Client Acceptance Testing Issues
-- 29/SEP/2016	Akwinass			What: Included record deleted condition for services
--									Why:  Task #563 in Key Point - Support Go Live.	
--10/Nov/2016  Chita Ranjan		What : Added Status!=76 to restrict all the services whose status is "Error"
--                              Why:  Why:Key Point - Support Go Live Task #668	
-- 30/Nov/2016	Prateek			What : Added condition to filter only the active clients
								Why : Valley - Support Go Live #961      
-- 27/Aug/2018	Vandana			What : Added parameter @InvokedFromNewDashBoard, added a filter for authors
								Why : CCC-Customizations #34         
  *********************************************************************************/   
  BEGIN   
      BEGIN try   
          SET nocount ON;   
  
          CREATE TABLE #resultset   
            (   
               RowNumber                   INT,   
               PageNumber                  INT,   
               SNo                         INT IDENTITY(1, 1),   
               ClientId                    INT,   
               ClientName                  VARCHAR(100),   
               DocumentId                  INT,   
               DocumentCodeId              INT,   
               ScreenId                    INT,   
               DocumentName                VARCHAR(100),   
               EffectiveDate               DATETIME,   
               ServiceId                   INT,   
               [Status]                    INT,   
               StatusName                  VARCHAR(50),   
               OrganizationLevelId         INT,   
               LevelName                   VARCHAR(250),   
               ScreenType                  INT,   
               OrganizationLevelScreenId   INT,   
               OrganizationLevelScreenType INT,   
               IsOrganizationLevelLink     CHAR(1),   
               Author                      VARCHAR(120)   
            )   
  
          CREATE TABLE #mydocuments   
            (   
               DocumentId INT,   
               ClientId  INT,   
               LevelName  VARCHAR(200),   
               LevelId    INT   
            )   
  
          CREATE TABLE #tocosign   
            (   
               DocumentId INT,   
               StaffId    INT   
            )   
  
          CREATE TABLE #membersign   
            (   
               DocumentId INT   
            )   
  
          DECLARE @Today DATETIME;   
          DECLARE @DueDaysCodeName VARCHAR(50);   
  
          SET @DueDaysCodeName=dbo.CSF_GETGLOBALSUBCODEBYID(@DueDaysFilter);   
  
          DECLARE @strSQL NVARCHAR(4000)   
          DECLARE @ApplyFilterClicked CHAR(1)   
  
          CREATE TABLE #documentcodefilters   
            (   
               DocumentCodeId INT   
            )   
    If (@PageNumber is null or @PageNumber=0)  
   Begin  
    SET @PageNumber = 1   
   End  
          IF @SortExpression is null  
   Begin  
    set @SortExpression='EffectiveDate desc'  
   End  
          SET @Today = CONVERT(CHAR(10), GETDATE(), 101)   
  
          --Get custom filters                                                  
          IF @OtherFilter > 10000   
            BEGIN   
                EXEC SCSP_SCLISTPAGESUPERVISIONREPORT   
                  @LoggedInStaffId = @LoggedInStaffId,   
                  @OtherFilter = @OtherFilter   
            END   
  
          DECLARE @LevelNumber INT   
  
          SELECT @LevelNumber = ISNULL(LevelNumber, 0)   
          FROM   OrganizationLevelTypes   
          WHERE  LevelTypeId = (SELECT LevelTypeId   
                                FROM   OrganizationLevels   
                                WHERE  OrganizationLevelId = @OrganizationLevel)   
  
  
    DECLARE @ProgramLevel CHAR(1) --Added by Revathi 13/oct/2015
  
            SELECT  @ProgramLevel = ISNULL(b.ProgramLevel, 'N')
            FROM    dbo.OrganizationLevels a
                    JOIN dbo.OrganizationLevelTypes b ON b.LevelTypeId = a.LevelTypeId
            WHERE   a.OrganizationLevelId = @OrganizationLevel
                    AND ISNULL(a.RecordDeleted, 'N') = 'N'
                    AND ISNULL(b.RecordDeleted, 'N') = 'N'
                    
                    
          -------- Getting the documentcode from document nevigations         
          CREATE TABLE #organisationsublevels   
            (   
               OrganizationLevelId INT,   
               LevelName           VARCHAR(250)   
            )   
  
          CREATE TABLE #organisationsublevelstaffs   
            (   
               StaffId             INT,   
               OrganizationLevelId INT   
            )   
  
          INSERT INTO #documentcodefilters   
                      (DocumentCodeId)   
          EXEC SSP_GETDOCUMENTNAVIGATIONDOCUMENTCODES   
            @DocumentNavigationId   
     IF ( @InvokedFromNewDashBoard='Y')  
     BEGIN  
    INSERT INTO #organisationsublevels     
        (OrganizationLevelId,     
                             LevelName)  
         values  
                            (3,     
                             'All Authors')     
                INSERT INTO #organisationsublevelstaffs     
                            (staffId,     
                             OrganizationLevelId)     
                SELECT DISTINCT SS.staffid,     
                                3 AS OrganizationLevelId     
                FROM   Staff S  
    INNER JOIN StaffSupervisors SS ON S.StaffId=SS.SupervisorId  
    AND ISNULL(S.RecordDeleted, 'N') = 'N'     
     END  
     ELSE  
      BEGIN  
          -------- Getting the documentcode from document nevigations                     
          ---------> getting all programid's <----------------           
          IF @levelNumber = 4   
            BEGIN   
                INSERT INTO #organisationsublevels   
                            (OrganizationLevelId,   
                             LevelName)   
                SELECT DISTINCT Staff.staffid                           AS   
                                OrganizationLevelId,   
                                ISNULL(LastName + ', ', '') + FirstName AS   
                                LevelName   
                FROM   OrganizationLevels   
                       INNER JOIN Staff   
                               ON OrganizationLevels.ProgramId = Staff.PrimaryProgramId   
                                  AND ISNULL(Staff.RecordDeleted, 'N') = 'N'               
                WHERE  OrganizationLevels.OrganizationLevelId =   
                       @OrganizationLevel   
  
                INSERT INTO #organisationsublevelstaffs   
                            (staffId,   
                             OrganizationLevelId)   
                SELECT DISTINCT Staff.staffid,   
                                Staff.staffid AS OrganizationLevelId   
                FROM   OrganizationLevels             
                       INNER JOIN Staff   
                               ON OrganizationLevels.ProgramId = Staff.PrimaryProgramId   
                                  AND ISNULL(Staff.RecordDeleted, 'N') = 'N'   
                WHERE  OrganizationLevels.OrganizationLevelId =   
                       @OrganizationLevel   
            END 
              ELSE   IF  (@levelNumber = 3  OR  @levelNumber = 2) AND @ProgramLevel = 'Y'    --Added by Revathi 13/oct/2015
            BEGIN   
                INSERT INTO #organisationsublevels   
                            (OrganizationLevelId,   
                             LevelName)   
                SELECT DISTINCT Staff.staffid                           AS   
                                OrganizationLevelId,   
                                ISNULL(LastName + ', ', '') + FirstName AS   
                                LevelName   
                FROM   OrganizationLevels   
                       INNER JOIN Staff   
                               ON OrganizationLevels.ProgramId = Staff.PrimaryProgramId   
                                  AND ISNULL(Staff.RecordDeleted, 'N') = 'N'               
                WHERE  OrganizationLevels.OrganizationLevelId =   
                       @OrganizationLevel   
  
                INSERT INTO #organisationsublevelstaffs   
                            (staffId,   
                             OrganizationLevelId)   
                SELECT DISTINCT Staff.staffid,   
                                Staff.staffid AS OrganizationLevelId   
                FROM   OrganizationLevels             
                       INNER JOIN Staff   
                               ON OrganizationLevels.ProgramId = Staff.PrimaryProgramId   
                                  AND ISNULL(Staff.RecordDeleted, 'N') = 'N'   
                WHERE  OrganizationLevels.OrganizationLevelId =   
                       @OrganizationLevel   
            END     
          ELSE IF @levelNumber = 3    AND @ProgramLevel = 'N'  --Added by Revathi 13/oct/2015
            BEGIN   
                INSERT INTO #organisationsublevels   
                  (OrganizationLevelId,   
                             LevelName)   
                SELECT DISTINCT OrganizationLevels.OrganizationLevelId,   
                                ISNULL(LevelName, programs.ProgramName) AS   
                                LevelName   
                FROM   OrganizationLevels   
                       LEFT JOIN Programs   
                              ON OrganizationLevels.ProgramId =   
                                 Programs.ProgramId   
                                 AND ISNULL(Programs.RecordDeleted, 'N') = 'N'   
                WHERE  ISNULL(OrganizationLevels.RecordDeleted, 'N') = 'N'   
                       AND OrganizationLevels.ParentLevelId = @OrganizationLevel   
  
                INSERT INTO #organisationsublevelstaffs   
                            (StaffId,   
                             OrganizationLevelId)   
                SELECT DISTINCT Staff.StaffId,   
                                OrganizationLevels.OrganizationLevelId   
                FROM   OrganizationLevels            
                       INNER JOIN Staff   
                               ON  OrganizationLevels.ProgramId = Staff.PrimaryProgramId  
                                  AND ISNULL(Staff.RecordDeleted, 'N') = 'N'              
                WHERE  ISNULL(OrganizationLevels.RecordDeleted, 'N') = 'N'   
                       AND OrganizationLevels.ParentLevelId = @OrganizationLevel   
            END   
          ELSE IF @levelNumber = 2    AND @ProgramLevel = 'N'  --Added by Revathi 13/oct/2015
            BEGIN   
                INSERT INTO #organisationsublevels   
                            (OrganizationLevelId,   
                             LevelName)   
                SELECT DISTINCT b.OrganizationLevelId,   
                               ISNULL(b.LevelName, programs.ProgramName) AS   --Added by Revathi 13/oct/2015
											LevelName  
                FROM   OrganizationLevels a   
                       RIGHT JOIN OrganizationLevels b   
                               ON a.ParentLevelId = b.OrganizationLevelId   
                                  AND ISNULL(a.RecordDeleted, 'N') = 'N'  
                                  LEFT JOIN Programs   
												ON b.ProgramId =Programs.ProgramId   
												AND ISNULL(Programs.RecordDeleted, 'N') = 'N'      
                WHERE  b.ParentLevelId = @OrganizationLevel   
                       AND ISNULL(b.RecordDeleted, 'N') = 'N'   
  
                INSERT INTO #organisationsublevelstaffs   
                            (StaffId,   
                             OrganizationLevelId)   
                SELECT DISTINCT Staff.StaffId,   
                                b.OrganizationLevelId   
                FROM   OrganizationLevels a   
                       RIGHT JOIN OrganizationLevels b   
                               ON a.ParentLevelId = b.OrganizationLevelId   
                                  AND ISNULL(a.RecordDeleted, 'N') = 'N'   
                       INNER JOIN Staff   
                               ON ( Staff.PrimaryProgramId = a.ProgramId   
                                     OR Staff.PrimaryProgramId = b.ProgramId )   
                WHERE  b.ParentLevelId = @OrganizationLevel   
                       AND ISNULL(a.RecordDeleted, 'N') = 'N'   
            END   
          ELSE IF @levelNumber = 1   
            BEGIN   
                INSERT INTO #organisationsublevels   
                            (OrganizationLevelId,   
                             LevelName)   
                SELECT DISTINCT c.OrganizationLevelId,   
                               ISNULL(c.LevelName, programs.ProgramName) AS   --Added by Revathi 13/oct/2015
											LevelName  
                FROM   OrganizationLevels a   
                       RIGHT JOIN OrganizationLevels b   
                               ON a.ParentLevelId = b.OrganizationLevelId   
                                  AND ISNULL(a.RecordDeleted, 'N') = 'N'   
                       RIGHT JOIN OrganizationLevels c   
                               ON b.ParentLevelId = c.OrganizationLevelId   
                                  AND ISNULL(b.RecordDeleted, 'N') = 'N'   
                              LEFT JOIN Programs   --Added by Revathi 13/oct/2015
												ON c.ProgramId =   
												Programs.ProgramId   
												AND ISNULL(Programs.RecordDeleted, 'N') = 'N'        
                WHERE  c.ParentLevelId = @OrganizationLevel   
                       AND ISNULL(c.RecordDeleted, 'N') = 'N'   
  
                INSERT INTO #organisationsublevelstaffs   
                            (StaffId,   
                   OrganizationLevelId)   
                SELECT DISTINCT Staff.StaffId,   
                                c.OrganizationLevelId   
                FROM   OrganizationLevels a   
                       RIGHT JOIN OrganizationLevels b   
                               ON a.ParentLevelId = b.OrganizationLevelId   
                                  AND ISNULL(a.RecordDeleted, 'N') = 'N'   
                       RIGHT JOIN OrganizationLevels c   
                               ON b.ParentLevelId = c.OrganizationLevelId   
                                  AND ISNULL(b.RecordDeleted, 'N') = 'N'   
                       INNER JOIN Staff   
                               ON ( Staff.PrimaryProgramId = a.ProgramId   
                                     OR Staff.PrimaryProgramId = b.ProgramId   
                                     OR Staff.PrimaryProgramId = c.ProgramId )   
                                  AND ISNULL(Staff.RecordDeleted, 'N') = 'N'   
                WHERE  c.ParentLevelId = @OrganizationLevel   
                       AND ISNULL(c.RecordDeleted, 'N') = 'N'   
            END   
  END
          -- All documents that need to be co-signed     
          IF @SupervisionDocStatus IN ( 6131, 6136 )  -- 6131 - Not Signed, Not Completed, Not Co-Signed  
            BEGIN   
                INSERT INTO #tocosign   
                            (DocumentId,   
                             StaffId)   
                SELECT DISTINCT d.DocumentId,   
                                dss.StaffId   
                FROM   Documents d   
                       JOIN DocumentSignatures dss   
                         ON d.DocumentId = dss.DocumentId   
                            AND dss.signaturedate IS NULL   
                            AND ISNULL(dss.RecordDeleted, 'N') = 'N'   
                            AND d.AuthorId <> dss.StaffId   
                            AND ISNULL(dss.declinedsignature, 'N') = 'N'   
                WHERE  d.CurrentVersionStatus = 21   
                       AND ISNULL(d.RecordDeleted, 'N') = 'N'   
            END   
  
          -- To Do documents      
          IF @SupervisionDocStatus IN ( 6131, 6132 )   
            BEGIN   
                INSERT INTO #mydocuments   
                            (DocumentId,   
                             ClientId,   
                             LevelName,   
                             LevelId)   
                SELECT DISTINCT d.DocumentId,   
                                d.ClientId,   
                                a.LevelName,   
                                a.OrganizationLevelId   
                FROM   Documents d   
                       JOIN #documentcodefilters dcf   
                         ON dcf.DocumentCodeId = d.DocumentCodeId   
                       JOIN #organisationsublevelstaffs OSLS   
                         ON ( d.AuthorId = OSLS.StaffId )   
                       JOIN #organisationsublevels a   
                         ON OSLS.OrganizationLevelId = a.OrganizationLevelId   
                WHERE  d.CurrentVersionStatus = 20   
                       AND ISNULL(d.RecordDeleted, 'N') = 'N'   
                       AND @SupervisionDocStatus IN ( 6131, 6132 )   
                       -- 6131 - Not Signed, Not Completed, Not Co-Signed; 6132 - To Do                     
                       AND ( @DueDaysFilter IN ( 0, 122 )   
                              OR -- All                     
                             ( @DueDaysFilter = 123   
                               AND d.DueDate < @today )   
                              OR -- Past Due                                     
                             ( @DueDaysFilter = 124   
                               AND d.DueDate < DATEADD(dd, 8, @today) )   
                              OR   
                             --Due within 1 week and Past Due                                     
                             ( @DueDaysFilter = 125   
                               AND (d.DueDate >= @today and d.DueDate < dateadd(dd, 15, @today)))    
                              OR   
                             -- Due within 14 days                                     
                             ( @DueDaysFilter = 126   
                               AND d.DueDate < DATEADD(dd, 15, @today) )   
                              OR   
                             -- Due within 14 days and Past Due                  
                             ( @DueDaysFilter = 127   
                               AND ( d.DueDate >= @today   
                                     AND d.DueDate < DATEADD(dd, 36, @today) ) )   
                              OR   
                             -- ? Due in 1 to 5 weeks                                    
                             ( @DueDaysFilter = 128   
                               AND ( d.DueDate >= @today   
                                     AND d.DueDate <= DATEADD(mm, 3, @today) ) )   
                              OR   
                             -- ? Due in 1 to 3 months                                     
                             ( @DueDaysFilter = 129   
                               AND d.DueDate > DATEADD(mm, 3, @today) )   
                              OR -- ? Due greater than 3 months               
                             ( @DueDaysCodeName = 'DT'   
                               AND d.DueDate <= @today ) )   
            -- Due Today and Past Due     
            END   
  
          -- In Progress documents    
          IF @SupervisionDocStatus IN ( 6131, 6133, 6137 )   
            BEGIN   
                INSERT INTO #mydocuments   
                            (DocumentId,   
                             ClientId,   
                             LevelName,   
                             LevelId)   
                SELECT DISTINCT d.DocumentId,   
                                d.ClientId,   
                                a.LevelName,   
                                a.OrganizationLevelId   
                FROM   Documents d   
                       JOIN #documentcodefilters dcf   
                         ON dcf.DocumentCodeId = d.DocumentCodeId   
                       JOIN #organisationsublevelstaffs OSLS   
                         ON ( d.AuthorId = OSLS.StaffId   
                               OR d.ProxyId = OSLS.StaffId )   
                       JOIN #organisationsublevels a   
                         ON OSLS.OrganizationLevelId = a.OrganizationLevelId   
                WHERE  (d.CurrentVersionStatus = 21 or d.CurrentVersionStatus = 25) 
                       AND ISNULL(d.RecordDeleted, 'N') = 'N'   
                       AND ( @SupervisionDocStatus IN ( 6131, 6133 )   
                              OR   
                             -- 6131 - Not Signed, Not Completed, Not Co-Signed; 6133 - In Progress                     
                             ( @SupervisionDocStatus = 6137   
                               AND d.ToSign = 'Y'   
                               AND EXISTS(--6137(To Sign)     
                                         SELECT DS.SignatureId   
                                          FROM   DocumentSignatures DS   
                                          WHERE  DS.DocumentId = D.DocumentId   
                                                 AND ds.StaffID = OSLS.StaffId   
                                                 AND ds.StaffId = d.AuthorId) )   
                           )   
                       -- To Sign                     
                       AND @DueDaysFilter IN ( 0, 122 )   
            END   
  
          -- Signed documents    
          IF @SupervisionDocStatus IN ( 6134, 6135 )   
            BEGIN   
                INSERT INTO #mydocuments   
                            (DocumentId,   
                             ClientId,   
                             LevelName,   
                             LevelId)   
                SELECT DISTINCT d.DocumentId,   
                                d.ClientId,   
                                a.LevelName,   
                                a.OrganizationLevelId   
          FROM   Documents d   
                       JOIN #documentcodefilters dcf   
                         ON dcf.DocumentCodeId = d.DocumentCodeId   
                       JOIN #organisationsublevelstaffs OSLS   
                         ON ( d.AuthorId = OSLS.StaffId   
                               OR d.ReviewerId = OSLS.StaffId )   
                       JOIN #organisationsublevels a   
                         ON OSLS.OrganizationLevelId = a.OrganizationLevelId   
                WHERE  d.CurrentVersionStatus = 22   
                       AND ISNULL(d.RecordDeleted, 'N') = 'N'   
                       AND (a.OrganizationLevelId = @OrganizationSubLevel or @OrganizationSubLevel=0)
                       AND ( ( @SupervisionDocStatus = 6134   
                               AND d.SignedByAuthor = 'Y' )   
                              OR -- Signed 
							 ( @SupervisionDocStatus = 6141
                               AND d.SignedByAuthor = 'Y' 
							   AND EXISTS (SELECT * 
											FROM DocumentSignatures ids
											WHERE ids.IsClient = 'Y' AND 
											ids.SignatureDate IS NULL AND 
											ISNULL(ids.RecordDeleted,'N') = 'N' AND
											ids.DocumentId = d.DocumentId)
							 )
							 OR -- Signed by author but not signed be client       
                             ( @SupervisionDocStatus = 6135   
                               AND ISNULL(d.SignedByAuthor, 'N') = 'N' ) )   
                       -- Completed                                    
                       AND @DueDaysFilter IN ( 0, 122 )   
            END   
  
          -- To Co-sign documents    
          IF @SupervisionDocStatus IN ( 6131, 6136 )   
            BEGIN   
                INSERT INTO #mydocuments   
                            (DocumentId,   
                             ClientId,   
                             LevelName,   
                             LevelId)   
                SELECT DISTINCT d.DocumentId,   
                                d.ClientId,   
                                a.LevelName,   
                                a.OrganizationLevelId   
                FROM   Documents d   
                       JOIN #tocosign tcs   
                         ON tcs.DocumentId = d.DocumentId   
                       JOIN #organisationsublevelstaffs OSLS   
                         ON ( d.AuthorId = OSLS.StaffId OR d.ProxyId = OSLS.StaffId)   
                       JOIN #organisationsublevels a   
                         ON OSLS.OrganizationLevelId = a.OrganizationLevelId   
                WHERE  EXISTS(SELECT 1   
                              FROM   #documentcodefilters DCF   
                              WHERE  DCF.DocumentCodeId = d.DocumentCodeId)   
                       AND @SupervisionDocStatus IN ( 6131, 6136 )   
                       -- 6131 - Not Signed, Not Completed, Not Co-Signed; 6136 - To Co-sign     
                        AND @DueDaysFilter IN ( 0, 122 )                   
            END   
  
          -- To Acknowledge documents           
          IF @SupervisionDocStatus = 6138   
            BEGIN   
                INSERT INTO #mydocuments   
                            (DocumentId,   
                             ClientId,   
                             LevelName,   
                             LevelId)   
                SELECT DISTINCT da.DocumentId,   
                                d.ClientId,   
                                a.LevelName,   
                                a.OrganizationLevelId   
                FROM   DocumentsAcknowledgements da   
                       JOIN Documents d   
                         ON da.DocumentId = d.DocumentId   
                            AND ISNULL(d.RecordDeleted, 'N') = 'N'   
                       JOIN #documentcodefilters dcf   
                         ON dcf.DocumentCodeId = d.DocumentCodeId   
                       JOIN #organisationsublevelstaffs OSLS   
                         ON ( da.AcknowledgedByStaffId = OSLS.StaffId )   
                       JOIN #organisationsublevels a   
                         ON OSLS.OrganizationLevelId = a.OrganizationLevelId   
                WHERE  @SupervisionDocStatus IN ( 6138 )   
                       -- 6138 - To Acknowledge;                     
                       AND @DueDaysFilter IN ( 0, 122 )   
                       AND ISNULL(da.RecordDeleted, 'N') = 'N'   
                       --and da.AcknowledgedByStaffId=@LoggedInStaffId                   
                       AND da.DateAcknowledged IS NULL   
                         
           END   
  
          --To be Reviewed documents   
          IF @SupervisionDocStatus = 6139   
            BEGIN   
                INSERT INTO #mydocuments   
                            (DocumentId,   
                             ClientId,   
                             LevelName,   
                             LevelId)   
                SELECT DISTINCT d.DocumentId,   
                                d.ClientId,   
                                a.LevelName,   
                                a.OrganizationLevelId   
                FROM   Documents d   
                       JOIN #documentcodefilters dcf   
                         ON dcf.DocumentCodeId = d.DocumentCodeId   
                       JOIN #organisationsublevelstaffs OSLS   
                         ON ( d.AuthorId = OSLS.StaffId   
                               OR d.ProxyId = OSLS.StaffId   
                               OR d.ReviewerId = OSLS.StaffId )   
                       JOIN #organisationsublevels a   
                         ON OSLS.OrganizationLevelId = a.OrganizationLevelId   
                WHERE  d.CurrentVersionStatus = 25   
                       AND ISNULL(d.RecordDeleted, 'N') = 'N'   
                       AND ( @SupervisionDocStatus IN ( 6139 ) )   
                        AND @DueDaysFilter IN ( 0, 122 )   
                       -- 6139 - To Be Reviewed Status             
                       --AND ( @DueDaysFilter IN ( 0, 122 )   
                       --       OR -- All               
                       --      ( @DueDaysFilter = 123   
                       --        AND d.DueDate < @today )   
                       --       OR -- Past Due                               
                       --      ( @DueDaysFilter = 124   
                       --        AND d.DueDate < DATEADD(dd, 8, @today) )   
                       --       OR   
                       --      --Due within 1 week and Past Due                            
                       --      ( @DueDaysFilter = 125   
                       --        AND ( d.DueDate >= @today   
                       --              AND d.DueDate < DATEADD(dd, 15, @today) ) )   
                       --       OR -- Due within 14 days              
                       --      ( @DueDaysFilter = 126   
                       --        AND d.DueDate < DATEADD(dd, 15, @today) )   
                       --       OR   
                       --      -- Due within 14 days and Past Due                               
                       --      ( @DueDaysFilter = 127   
                       --        AND ( d.DueDate >= @today   
                       --              AND d.DueDate < DATEADD(dd, 36, @today) ) )   
                       --       OR   
                       --      -- Due within 5 weeks                               
                       --      ( @DueDaysFilter = 128   
                       --        AND ( d.DueDate >= @today   
                       --              AND d.DueDate <= DATEADD(mm, 3, @today) ) )   
                       --       OR   
                       --      -- Due within 3 months                               
                       --      ( @DueDaysFilter = 129   
                       --        AND d.DueDate > DATEADD(mm, 3, @today) )   
                       --       OR -- Due greater than 3 months            
                       --      ( @DueDaysCodeName = 'DT'   
                       --        AND d.DueDate <= @today ) )   
            -- Due Today and Past Due    
            END   
  
          -- To Assigned documents       
          IF @SupervisionDocStatus = 6140   
            BEGIN   
                INSERT INTO #mydocuments   
                            (DocumentId,   
                             ClientId,   
                             LevelName,   
                             LevelId)   
                SELECT D.DocumentId,   
                       D.ClientId,   
                       a.LevelName,   
                       a.OrganizationLevelId   
               FROM   Documents AS D   
                       JOIN #organisationsublevelstaffs OSLS   
                         ON ( d.AuthorId = OSLS.StaffId   
                               OR d.ProxyId = OSLS.StaffId )   
                       JOIN #organisationsublevels a   
                         ON OSLS.OrganizationLevelId = a.OrganizationLevelId   
                       JOIN StaffClients sc   
                         ON sc.ClientId = d.ClientId   
                            AND sc.StaffId = @LoggedInStaffId   
                       JOIN DocumentAssignedTasks AS DAT   
                         ON   
                D.InProgressDocumentVersionId = DAT.DocumentVersionId   
                AND ISNULL(DAT.RecordDeleted, 'N') = 'N'   
                WHERE  EXISTS(SELECT 1   
                              FROM   #documentcodefilters DCF   
                              WHERE  DCF.DocumentCodeId = d.DocumentCodeId)   
                       AND DAT.AssignmentStatus <> 6822   
                       AND d.CurrentVersionStatus IN ( 20, 21, 25 )   
                       AND d.EffectiveDate IS NOT NULL   
                       AND ISNULL(D.RecordDeleted, 'N') = 'N'   
                       AND @SupervisionDocStatus = 6140   
                       AND @DueDaysFilter IN ( 0, 122 )   
                       -- 6140(Assigned)           
                       --AND ( @DueDaysFilter IN ( 0, 122 )   
                       --       OR -- All               
                       --      ( @DueDaysFilter = 123   
                       --        AND d.DueDate < @today )   
                       --       OR -- Past Due                               
                       --      ( @DueDaysFilter = 124   
                       --        AND d.DueDate < DATEADD(dd, 8, @today) )   
                       --       OR   
                       --      --Due within 1 week and Past Due                            
                       --      ( @DueDaysFilter = 125   
                       --        AND ( d.DueDate >= @today   
                       --              AND d.DueDate < DATEADD(dd, 15, @today) ) )   
                       --       OR   
                       --      -- Due within 14 days                               
                       --      ( @DueDaysFilter = 126   
                       --        AND d.DueDate < DATEADD(dd, 15, @today) )   
                       --       OR   
                       --      -- Due within 14 days and Past Due                               
                       --      ( @DueDaysFilter = 127   
                       --        AND ( d.DueDate >= @today   
                       --              AND d.DueDate < DATEADD(dd, 36, @today) ) )   
                       --       OR   
                       --      -- Due within 5 weeks                               
                       --      ( @DueDaysFilter = 128   
                       --        AND ( d.DueDate >= @today   
                       --              AND d.DueDate <= DATEADD(mm, 3, @today) ) )   
                       --       OR   
                       --      -- Due within 3 months                               
                       --      ( @DueDaysFilter = 129   
                       --        AND d.DueDate > DATEADD(mm, 3, @today) )   
                       --       OR -- Due greater than 3 months            
                       --      ( @DueDaysCodeName = 'DT'   
                       --        AND d.DueDate <= @today ) )   
            -- Due Today and Past Due     
            END   
  
          INSERT INTO #resultset   
                      (ClientId,   
                       ClientName,   
                       DocumentId,   
                       ServiceId,   
                       DocumentCodeId,   
                       ScreenId,   
                       DocumentName,   
                       EffectiveDate,   
                       [Status],   
                       StatusName,   
                       OrganizationLevelId,   
            LevelName,   
                       ScreenType,   
                       OrganizationLevelScreenId,   
                       OrganizationLevelScreenType,   
                       IsOrganizationLevelLink,   
                       Author)   
          SELECT DISTINCT c.ClientId,   
                          ISNULL(c.LastName + ', ', '') + c.FirstName + '(' + CONVERT( VARCHAR, c.ClientId) + ')' AS ClientName,   
                          d.DocumentId,   
                          ISNULL((SELECT ServiceId FROM   [Services] WHERE  ServiceId = d.ServiceId AND ISNULL(RecordDeleted, 'N') = 'N'), 0) AS ServiceId,   --Added by Chita Ranjan 10/Nov/2016
                          d.DocumentCodeId,   
                          ISNULL(sr.ScreenId, 0) AS ScreenId,   
                          dc.DocumentName,   
                          ( CASE WHEN gcs.GlobalCodeId = 20 THEN   
                              CONVERT(DATETIME, CONVERT(VARCHAR(20),   
                          ISNULL( d.DueDate, d.EffectiveDate), 101))   
                          ELSE CONVERT(DATETIME, CONVERT(VARCHAR(20),d.EffectiveDate, 101 ))   
                          END )   
                          AS   
                          EffectiveDate,   
                          gcs.GlobalCodeId   
                          AS   
                          [Status],   
                          ( CASE   
                              WHEN ISNULL(d.SignedByAuthor, 'N') = 'N'   
                                   AND gcs.GlobalCodeId = 22 THEN 'Completed'   
                              WHEN d.SignedByAuthor = 'Y'   
                                   AND gcs.GlobalCodeId = 22 THEN 'Signed'   
                              ELSE gcs.CodeName   
                            END )   
                          AS   
                          StatusName,   
                          MD.LevelId,   
                          MD.LevelName,   
                          ISNULL(sr.ScreenType, 0) AS ScreenType,   
                          313 AS OrganizationLevelScreenId,   
                          5761 AS OrganizationLevelScreenType,   
                          '' AS IsOrganizationLevelLink,   
                          st.LastName + ', ' + st.FirstName AS Author   
          FROM   Documents d   
                 INNER JOIN #mydocuments md   
                         ON md.DocumentId = d.DocumentId   
                 INNER JOIN StaffClients SC   
                         ON sc.ClientId = d.ClientId AND sc.StaffId = @LoggedInStaffId   
                 INNER JOIN Clients c   
                         ON c.ClientId = sc.ClientId   
                            AND c.ClientId = CASE WHEN ISNULL(@ClientFilter, 0) = 0 THEN c.ClientId   
                                               ELSE @ClientFilter   
                                             END   
                 INNER JOIN DocumentCodes dc   
                         ON dc.DocumentCodeId = d.DocumentCodeId AND ISNULL(dc.RecordDeleted, 'N') = 'N'   
                 LEFT JOIN Screens sr   
                        ON sr.DocumentCodeId = d.DocumentCodeId   
                           AND ISNULL(sr.RecordDeleted, 'N') = 'N'   
                 INNER JOIN GlobalCodes gcs   
                         ON gcs.GlobalCodeId = d.CurrentVersionStatus ---.Status    Changed by Venkatesh for task 454 in Core bugs   
                 INNER JOIN dbo.Staff st   
                         ON st.StaffId = d.AuthorId 
                            AND ISNULL(st.RecordDeleted, 'N') = 'N'   
          WHERE  ISNULL(d.RecordDeleted, 'N') = 'N'   
                 AND ISNULL(gcs.RecordDeleted, 'N') = 'N'   
                 AND (md.LevelId = @OrganizationSubLevel or @OrganizationSubLevel=0) 
                 -- Added by Md Hussain on 07/Mar/2014 for task #441 Threshold Support 
                 AND (ISNULL(@AuthorId,0)=0 or st.StaffId=@AuthorId)
                 AND ISNULL(C.Active,'N')='Y' -- Added by Prateek 30/Nov/2016 
                 -- 29/SEP/2016	Akwinasss
				 AND (d.ServiceId is null OR EXISTS(SELECT ServiceId FROM [Services] WHERE  ServiceId = d.ServiceId AND Status!=76 AND ISNULL(RecordDeleted, 'N') = 'N')) --Added by Chita Ranjan 10/Nov/2016
				 
          ;WITH counts   
               AS (SELECT COUNT(*) AS totalrows   
                   FROM   #resultset),   
               rankresultset   
               AS (SELECT ClientId,   
                          ClientName,   
                          DocumentId,   
                          ServiceId,   
                          DocumentCodeId,   
                          ScreenId,   
                          DocumentName,   
                          EffectiveDate,   
                          [Status],   
                          StatusName,   
                          OrganizationLevelId,   
                          LevelName,   
                          ScreenType,   
                          OrganizationLevelScreenId,   
                          OrganizationLevelScreenType,   
                          IsOrganizationLevelLink,   
                          Author,   
                          COUNT(*)   
                            OVER ( )     AS TotalCount,   
                          RANK()   
                            OVER (   
                              ORDER BY CASE WHEN @SortExpression= 'ClientName' THEN ClientName END   
                            , CASE WHEN @SortExpression= 'ClientName desc' THEN ClientName END DESC,   
                            CASE WHEN @SortExpression= 'DocumentName' THEN DocumentName END,   
                            CASE WHEN @SortExpression= 'DocumentName desc' THEN DocumentName END DESC,   
                            CASE WHEN @SortExpression= 'EffectiveDate' THEN EffectiveDate END,   
                            CASE WHEN @SortExpression= 'EffectiveDate desc' THEN EffectiveDate END DESC,   
                            CASE WHEN @SortExpression= 'LevelName' THEN LevelName END,   
                            CASE WHEN @SortExpression= 'LevelName desc' THEN LevelName END DESC,   
                            CASE WHEN @SortExpression = 'Author' THEN Author END,  
                             CASE WHEN @SortExpression= 'Author desc' THEN Author END DESC   
                            , DocumentId ) AS RowNumber   
                   FROM   #resultset)   
          SELECT TOP ( CASE WHEN (@PageNumber = -1) THEN (SELECT ISNULL(totalrows,0) FROM counts ) ELSE (@PageSize) END)   
         ClientId,   
                                  ClientName,   
                                  DocumentId,   
                                  ServiceId,   
                                  DocumentCodeId,   
                                  ScreenId,   
                                  DocumentName,   
                                  EffectiveDate,   
                                  [Status],   
                                  StatusName,   
                                  OrganizationLevelId,   
                                  LevelName,   
                                  ScreenType,   
                                  OrganizationLevelScreenId,   
                                  OrganizationLevelScreenType,   
                                  IsOrganizationLevelLink,   
                                  Author,   
                                  TotalCount,   
                                  RowNumber   
          INTO   #finalresultset   
          FROM   RankResultSet   
          WHERE  RowNumber > ( ( @PageNumber - 1 ) * @PageSize )   
                 --AND EffectiveDate IS NOT NULL   
  
          IF (SELECT ISNULL(COUNT(*), 0)   
              FROM   #finalresultset) < 1   
            BEGIN   
                SELECT 0 AS PageNumber,   
                       0 AS NumberOfPages,   
                       0 NumberOfRows   
            END   
          ELSE   
            BEGIN   
                SELECT TOP 1 @PageNumber           AS PageNumber,   
                             CASE ( TotalCount % @PageSize )   
                               WHEN 0 THEN ISNULL(( TotalCount / @PageSize ), 0)   
                               ELSE ISNULL(( TotalCount / @PageSize ), 0) + 1   
                             END                   AS NumberOfPages,   
                             ISNULL(TotalCount, 0) AS NumberOfRows   
                FROM   #finalresultset   
            END   
  
          SELECT @SessionId      AS SessionId,   
                 @InstanceId     AS InstanceId,   
                 RowNumber,   
                 @PageNumber     AS PageNumber,   
                 @SortExpression AS SortExpression,   
                 ClientId,   
				 ClientName,   
                 DocumentId,   
                 DocumentCodeId,   
                 ScreenId,   
                 DocumentName,   
                 EffectiveDate,   
                 ServiceId,   
                 [Status],   
                 CONVERT(VARCHAR(20),EffectiveDate, 101 )  + '(' + StatusName + ')' AS StatusName, -- Added by Venkatesh for task 453 in Allegan    
                 OrganizationLevelId,   
                 LevelName,   
                 ScreenType,   
                 OrganizationLevelScreenId,   
                 OrganizationLevelScreenType,   
                 IsOrganizationLevelLink,   
                 Author   
          FROM   #finalresultset   
      END try   
  
      BEGIN catch   
          DECLARE @Error VARCHAR(8000)   
  
          SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'   
                      + CONVERT(VARCHAR(4000), ERROR_MESSAGE())   
                      + '*****'   
                      + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),   
                      'ssp_SCListPageSupervisionReport')   
                      + '*****' + CONVERT(VARCHAR, ERROR_LINE())   
                      + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY())   
                      + '*****' + CONVERT(VARCHAR, ERROR_STATE())   
  
          RAISERROR ( @Error,-- Message text.               
                      16,-- Severity.               
                      1 -- State.               
          );   
      END catch   
  END 