IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetUMAuthorizationRequestedWidgetData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetUMAuthorizationRequestedWidgetData]
GO
/****** Object:  StoredProcedure [dbo].[ssp_SCGetUMAuthorizationRequestedWidgetData]    Script Date: 01/20/2014 12:44:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

    
CREATE PROCEDURE [dbo].[ssp_SCGetUMAuthorizationRequestedWidgetData]
    (
     @StaffId INT
    ,@LoggedInStaffId INT
    ,@OrganizationId INT
    ,@RefreshData CHAR(1) = NULL                          
    )
AS /*********************************************************************/                                          
/* Stored Procedure: ssp_SCGetUMAuthorizationRequestedWidgetData     */                                          
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                          
/* Creation Date:   5/10/2010                                        */                                          
/*                                                                   */                                          
/* Purpose:  It is used to return the messages or Alerts list which  */                                   
/*           we show on the UM Tab dashboard for the loged user      */                                         
/*                                                                   */                                        
/* Input Parameters: @varStaffId                                     */                                        
/*                                                                   */                                          
/* Output Parameters:   None                                         */                                          
/*                                                                   */                                          
/* Return:  0=success, otherwise an error number                     */                                          
/*                                                                   */                                          
/* Updates:                                                          */                                          
/*  Date         Author       Purpose                                    */                                          
/* 12/01/2006    Vikas Vyas   Created                                    */                                      
/* 06/29/2007    Sony John    Modified - To optimise sp performance      */                                      
/* 03/07/2008    SFarber      Modified to improve performance    */                      
/* 19thJan-2011  Rakesh       For UM Part 2 Get New Status Clinician and Consumer Appeal */    
/* 6/Jan/2011    Mamta Gupta  To show document summary accroding to roles ref Task No. 527*/    
/* 12/Jan/2012   Mamta Gupta  To add record deleted contion in staffRoles table and systemadministration condition in Staff table */ 
/*	25/06/2012   anil         add PartiallyApproved  ref.. Task778	Venture Central Support */ 
/* 12/15/2013    jwheeler     rewrote without temp table to cut run time */
/* 12/15/2013    jwheeler     rewrote without temp table to cut run time */
/* 08/11/2014    Kirtee       Use Left Join instead of Inner join with Screen Table as its not increasing the count of newly created Auth. records wrf Customization Bugs Task # 286 */
/* 15 oct 2015   Hemant       Modified Left join with Inner join (screens table) to retrieve the proper count and added record deleted conditions. 
                              and Changed to match widget logic with Recodes
*/
/*********************************************************************/                                           
                          
                           
                          
    --CREATE TABLE #AuthorizedSummary
    --    (
    --     TeamId INT
    --    ,GlobalCodeXAUTHTEAM VARCHAR(250)
    --    ,Requested INT
    --    ,Pended INT
    --    ,PartiallyApproved INT
    --    ,ClinicianAppealed INT
    --    ,ConsumerAppeal INT
    --    ,Total INT
    --    ,OrganizationId INT
    --    )                                      
                                  
    --INSERT  INTO #AuthorizedSummary
    --        (TeamId
    --        ,GlobalCodeXAUTHTEAM 
    --        )
    --        SELECT  GlobalCodeId AS TeamId
    --               ,CodeName AS GlobalCodeXAUTHTEAM
    --        FROM    GlobalCodes
    --        WHERE   Category = 'AUTHORIZATIONTEAM'
    --                AND Active = 'Y'
    --                AND ISNULL(RecordDeleted, 'N') = 'N'
    --        ORDER BY CodeName                         
  
--6/Jan/2011 Mamta Gupta To show document summary accroding to roles ref Task No. 527  
    DECLARE @LCMRoles INT  
    DECLARE @CCMRoles INT  
    DECLARE @ReviewLevel INT  
   
 --SystemAdministrator condition applied  
    IF EXISTS ( SELECT  systemAdministrator
                FROM    staff
                WHERE   staffid = @StaffId
                        AND ISNULL(systemAdministrator, 'N') = 'Y'
                        AND ISNULL(recorddeleted, 'N') <> 'Y' ) 
        BEGIN  
            SET @LCMRoles = 0  
            SET @CCMRoles = 0  
        END  
    ELSE 
        BEGIN  
   --RecordDeleted condtion applied  
            SELECT  @LCMRoles = COUNT(roleid)
            FROM    staffroles
            WHERE   staffid = @StaffId
                    AND roleid = 4013
                    AND ISNULL(recordDeleted, 'N') <> 'Y'  
            SELECT  @CCMRoles = COUNT(roleid)
            FROM    staffroles
            WHERE   staffid = @StaffId
                    AND roleid = 4014
                    AND ISNULL(recordDeleted, 'N') <> 'Y'  
        END  
   
    SELECT  @ReviewLevel = CASE WHEN @LCMRoles > 0
                                     AND @CCMRoles > 0 THEN 0
                                WHEN @LCMRoles = 0
                                     AND @CCMRoles = 0 THEN 0
                                WHEN @LCMRoles > 0
                                     AND @CCMRoles = 0 THEN 6681
                                WHEN @CCMRoles > 0
                                     AND @LCMRoles = 0 THEN 6682
                           END                                
                           
                           
  --End 6/Jan/2011 Mamta Gupta To show document summary accroding to roles ref Task No. 527              
    --UPDATE  asum
    --SET     Requested = c.Requested
    --       ,Pended = c.Pended
    --       ,PartiallyApproved = c.PartiallyApproved
    --       ,ClinicianAppealed = c.ClinicianAppealed
    --       ,ConsumerAppeal = c.ConsumerAppeal
    --       ,Total = c.Total
           
    SELECT  c.TeamId
           ,GlobalCodeXAUTHTEAM
           ,c.requested
           ,c.pended
           ,c.PartiallyApproved
           ,c.ClinicianAppealed
           ,c.ConsumerAppeal
           ,c.Total
           ,@OrganizationId AS OrganizationId
    FROM    (SELECT GlobalCodeId AS TeamId
                   ,CodeName AS GlobalCodeXAUTHTEAM
             FROM   GlobalCodes
             WHERE  Category = 'AUTHORIZATIONTEAM'
                    AND Active = 'Y'
                    AND ISNULL(RecordDeleted, 'N') = 'N'
            ) asum
            JOIN (SELECT    q.TeamId
                           ,COUNT(DISTINCT CASE WHEN a.Status = 4242 THEN a.AuthorizationId
                                                ELSE NULL
                                           END) AS Requested
                           ,COUNT(DISTINCT CASE WHEN a.Status = 4245 THEN a.AuthorizationId
                                                ELSE NULL
                                           END) AS Pended
                           , 
       /*	25/06/2012 anil add PartiallyApproved  ref.. Task778	Venture Central Support */COUNT(DISTINCT CASE WHEN a.Status = 305 THEN a.AuthorizationId
                                                                                                               ELSE NULL
                                                                                                          END) AS PartiallyApproved
                           , 
       /*end*/COUNT(DISTINCT CASE WHEN a.Status = 6044 THEN a.AuthorizationId
                                  ELSE NULL
                             END) AS ClinicianAppealed
                           ,COUNT(DISTINCT CASE WHEN a.Status = 6045 THEN a.AuthorizationId
                                                ELSE NULL
                                           END) AS ConsumerAppeal
                           ,COUNT(DISTINCT CASE WHEN a.Status IN (4242, 4245, 6044, 6045, 305) THEN a.AuthorizationId
                                                ELSE NULL
                                           END) AS Total
                  FROM      (SELECT GlobalCodeId AS TeamId
                                   ,CodeName AS GlobalCodeXAUTHTEAM
                             FROM   GlobalCodes
                             WHERE  Category = 'AUTHORIZATIONTEAM'
                                    AND Active = 'Y'
                                    AND ISNULL(RecordDeleted, 'N') = 'N'
                            ) q
                            JOIN AuthorizationDocuments ad ON ad.Assigned = q.TeamId
                           --Added by Hemant on 15 Oct 2015 for Customization Bugs #222 
                            AND ISNULL(ad.RecordDeleted, 'N') = 'N'
                            JOIN Authorizations a ON a.AuthorizationDocumentId = ad.AuthorizationDocumentId
                            AND ISNULL(a.RecordDeleted, 'N') = 'N' 
                            JOIN ClientCoverageplans ccp ON ccp.ClientCoveragePlanId = ad.ClientCoveragePlanId
                                                            AND ISNULL(ccp.RecordDeleted, 'N') = 'N'
                            JOIN Coverageplans cp ON cp.coverageplanid = ccp.coverageplanid
                                                     AND ISNULL(cp.RecordDeleted, 'N') = 'N'
                            LEFT JOIN Staff s ON s.StaffId = ad.StaffId
                                                 AND ISNULL(s.RecordDeleted, 'N') = 'N'
                            LEFT JOIN Documents d ON d.DocumentId = ad.DocumentId
                                                     AND ISNULL(d.RecordDeleted, 'N') = 'N'
                            LEFT JOIN DocumentCodes dc ON dc.DocumentCodeId = d.DocumentCodeId
                                                          AND ISNULL(dc.RecordDeleted, 'N') = 'N'
                            JOIN Clients c ON c.ClientId = ccp.ClientId
                                              AND ISNULL(c.RecordDeleted, 'N') = 'N' 
                            LEFT JOIN Providers p ON p.ProviderId = a.ProviderId
                                                     AND ISNULL(p.RecordDeleted, 'N') = 'N' 
                            LEFT JOIN Sites si ON si.SiteId = a.SiteId
                                                  AND ISNULL(si.RecordDeleted, 'N') = 'N'
                            join dbo.ssf_RecodeValuesCurrent('RECODECAPCOVERAGEPLANID') CAPCP on cp.CoveragePlanId = CAPCP.IntegerCodeId                                            
                            --08/11/2014    Kirtee wrf Customization Bugs Task# 286
                            Inner JOIN Screens sr ON sr.DocumentCodeId = d.DocumentCodeId
                                                     AND ISNULL(sr.RecordDeleted, 'N') = 'N'
                            JOIN staffClients sc ON sc.clientId = c.ClientId
                                                    AND sc.StaffId = @StaffId
                  WHERE     cp.Capitated = 'Y'
                            AND (a.Status IN (4242, 4245, 6044, 6045, 305))     -- or a.Appealed = 'Y' or a.Modified = 'Y')                                  
                            AND ISNULL(ad.RecordDeleted, 'N') = 'N'
                            AND ISNULL(a.RecordDeleted, 'N') = 'N'  
   --6/Jan/2011 Mamta Gupta To show document summary accroding to roles ref Task No. 527  
                            AND (@ReviewLevel = 0
                                 OR (@ReviewLevel = 6681
                                     AND a.ReviewLevel = @ReviewLevel
                                    )
                                 OR (@ReviewLevel = 6682
                                     AND a.ReviewLevel = @ReviewLevel
                                    )
                                )                                   
  --End Ref Task No. 527  
                  GROUP BY  q.TeamId
                 ) c ON c.TeamId = asum.TeamId                  
                                 ORDER BY asum.GlobalCodeXAUTHTEAM asc
                              
    --SELECT  TeamId
    --       ,GlobalCodeXAUTHTEAM
    --       ,ISNULL(Requested, '0') AS Requested
    --       ,ISNULL(Pended, '0') AS Pended
    --       ,ISNULL(PartiallyApproved, '0') AS PartiallyApproved
    --       ,ISNULL(ClinicianAppealed, '0') AS ClinicianAppealed
    --       ,ISNULL(ConsumerAppeal, '0') AS ConsumerAppeal
    --       ,ISNULL(Total, '0') AS Total
    --       ,@OrganizationId AS OrganizationId
    --FROM    #AuthorizedSummary                                    
--select case TeamId                        
--    when 10488 then 55                        
--    when 10490 then 56                        
--    when 10491 then 57                        
--    when 10492 then 58                        
--    when 10493 then 59                        
--    when 10494 then 60                        
--    when 11045 then 61                        
--    when 11233 then 62                        
--    END as 'TeamId',                                  
--       GlobalCodeXAUTHTEAM,                                  
--       isnull(Requested, '0') as Requested,                                   
--       isnull(Pended, '0') as Pended,                                  
--       isnull(ClinicianAppealed, '0') as ClinicianAppealed,                                  
--       isnull(ConsumerAppeal, '0') as ConsumerAppeal,                                  
--isnull(Total, '0') as Total,      
--@OrganizationId as OrganizationId         
-- from #AuthorizedSummary                                      
                          
    RETURN(0)   

