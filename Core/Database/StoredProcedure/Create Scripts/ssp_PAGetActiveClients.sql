IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PAGetActiveClients]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_PAGetActiveClients]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[ssp_PAGetActiveClients]  
    @ProviderId INT ,  
    @FilterId INT ,  
    @Type VARCHAR(25) ,  
    @Count INT OUTPUT  
AS /******************************************************************************                                                
**  File: csp_PAGetActiveClients                                            
**  Name: csp_PAGetActiveClients                        
**  Desc: Unify logic for determining "Active Clients" in multiple interfaces  
**  Return values: Table of "Active" client records                                           
**  Called by:  ssp_PAGetClientsList, ssp_PADashBoardGetWidgets  
**  Parameters:                            
**  Auth:  RNoble  
**  Date:  Nov 21 2011  
*******************************************************************************                                                
**  Change History                                                
*******************************************************************************                                                
**  Date:       Author:       Description:                              
**  -------------------------------------------------------------------------       
-- 31 Aug 2016	Vithobha		Moved CustomSUDischarges to scsp_GetCustomSUDischargeDetails, AspenPointe-Environment Issues: #45            
*******************************************************************************/     
  
    IF OBJECT_ID('tempdb..#ActiveClients') IS NULL   
        BEGIN  
            CREATE TABLE #ActiveClients  
                (  
                  ClientId INT ,  
                  MasterClientId INT ,  
                  LastName VARCHAR(50) ,  
                  FirstName VARCHAR(50) ,  
                  SSN VARCHAR(4) ,  
                  Sex CHAR(1) ,  
                  DOB DATETIME ,  
                  Email VARCHAR(50) ,  
                  PhoneNumber VARCHAR(80) ,  
                  InTreatment VARCHAR(1) ,  
                  Seen VARCHAR(1) ,  
                  NotSeen VARCHAR(1) ,  
                  IncompleteInformation VARCHAR(1)  
                )    
        END  
        
    CREATE TABLE #CustomSUDischarges (AdmissionDocumentId INT)   
	INSERT INTO #CustomSUDischarges (AdmissionDocumentId)    
	EXEC scsp_GetCustomSUDischargeDetails          
        
    IF ( SELECT COUNT(*)  
         FROM   #ActiveClients  
       ) < 1   
        BEGIN  
            IF dbo.PAGetProviderType(@ProviderId) = 'MH'   
                BEGIN  
                    INSERT  INTO #ActiveClients  
                            ( ClientId ,  
                              MasterClientId ,  
                              LastName ,  
                              FirstName ,  
                              SSN ,  
                              Sex ,  
                              DOB ,  
                              Email ,  
                              PhoneNumber ,  
                              InTreatment ,  
                              Seen ,  
                              NotSeen ,  
                              IncompleteInformation  
                            )  
                            SELECT  c.ClientId ,  
                                    pc.MasterClientId ,  
                                    c.LastName ,  
                                    c.FirstName ,  
                                    SUBSTRING(c.ssn, 6, 4) AS SSN ,  
                                    c.sex ,  
                                    c.dob ,  
                                    c.email ,  
                                    cp.PhoneNumber ,  
                                    'Y' ,  
                                    NULL ,  
                                    NULL ,  
                                    NULL  
                            FROM    Clients c  
                                    LEFT JOIN ( SELECT  ClientId ,  
                                                        MAX(PhoneNumber) AS PhoneNumber  
                                                FROM    CLientPhones  
                                                WHERE   IsPrimary = 'Y'  
                                                        AND ISNULL(RecordDeleted,  
                                                              'N') = 'N'  
                                                GROUP BY ClientId  
                                   ) AS cp ON cp.ClientId = c.ClientId  
                                    JOIN ProviderClients pc ON pc.ClientId = c.ClientId  
                            WHERE   pc.ProviderId = @ProviderId  
                                    AND c.Active = 'Y'  
                                    AND pc.Active = 'Y'  
                                    AND ISNULL(c.RecordDeleted, 'N') = 'N'  
                                    AND ISNULL(pc.RecordDeleted, 'N') = 'N'  
                                    AND EXISTS ( SELECT *  
                                                 FROM   ProviderAuthorizations pa  
                                                 WHERE  pa.ClientId = c.ClientId  
                                                        AND pa.ProviderId = pc.ProviderId  
                                                        AND pa.Status = 2042 -- Approved            
                                                        AND pa.StartDate <= GETDATE()  
                                                        AND DATEADD(dd, 1,  
                                                              pa.EndDate) > GETDATE()  
                                                        AND ISNULL(pa.RecordDeleted,  
                                                              'N') = 'N' )  
                            ORDER BY c.LastName ,  
                                    c.FirstName            
                END            
            ELSE   
                BEGIN    
                    INSERT  INTO #ActiveClients  
                            ( ClientId ,  
                              MasterClientId ,  
                              LastName ,  
                              FirstName ,  
                              SSN ,  
                              Sex ,  
                              DOB ,  
                              Email ,  
                              PhoneNumber ,  
                              InTreatment ,  
                              Seen ,  
                              NotSeen ,  
                              IncompleteInformation  
                            )  
                            SELECT  c.ClientId ,  
                                    pc.MasterClientId ,  
                                    c.LastName ,  
                                    c.FirstName ,  
                                    SUBSTRING(c.ssn, 6, 4) AS SSN ,  
                                    c.Sex ,  
                                    c.DOB ,  
                                    c.Email ,  
                                    cp.PhoneNumber ,  
                                    'Y' ,  
                                    NULL ,  
                                    NULL ,  
                                    NULL  
                            FROM    Clients c  
                                    LEFT JOIN ( SELECT  ClientId ,  
                                                        MAX(PhoneNumber) AS PhoneNumber  
                                                FROM    ClientPhones  
                                                WHERE   IsPrimary = 'Y'  
                                                        AND ISNULL(RecordDeleted,  
                                                              'N') = 'N'  
                                                GROUP BY ClientId  
                                              ) AS cp ON cp.ClientId = c.ClientId  
                                    JOIN ProviderClients pc ON pc.ClientId = c.ClientId  
                            WHERE   pc.ProviderId = @ProviderId  
                                    AND c.Active = 'Y'  
                                    AND pc.Active = 'Y'  
                                    AND ISNULL(c.RecordDeleted, 'N') = 'N'  
                                    AND ISNULL(pc.RecordDeleted, 'N') = 'N'  
                                    AND EXISTS ( SELECT e.ClientId  
                                                 FROM   Events e  
                                    JOIN documents doc ON doc.eventId = e.EventId  
                                                        JOIN ProviderClients pc ON pc.ProviderId = e.ProviderId  
                                                              AND pc.ClientId = e.ClientId  
                                                 WHERE  e.ClientId = c.ClientId  
                                                        AND e.ProviderId = pc.ProviderId  
                                                        AND e.EventTypeId = 1010  
                                                        AND NOT EXISTS ( SELECT  
                                                              *  
                                                              FROM  
                                                              #CustomSUDischarges d  
                                                              WHERE  
                                                              d.AdmissionDocumentId = doc.DocumentId )  
                                                        AND ISNULL(e.RecordDeleted,  
                                                              'N') = 'N'  
                                                        AND ISNULL(doc.RecordDeleted,  
                                                              'N') <> 'Y' )  
                            ORDER BY c.LastName ,  
                                    c.FirstName   
                END  
        END  
     
     IF @FilterId = 1 -- In Treatment  
        BEGIN  
            IF @Type = 'Detail'   
                BEGIN  
                    SELECT  c.ClientId ,  
                            c.MasterClientId ,  
                            c.LastName ,  
                            c.FirstName ,  
                            c.SSN ,  
                            c.Sex ,  
                            c.DOB ,  
                            c.Email ,  
                            c.PhoneNumber  
                    FROM    #ActiveClients c  
                    WHERE   c.InTreatment = 'Y'  
                    ORDER BY c.LastName ,  
                            c.FirstName   
                END  
            ELSE   
                BEGIN  
                    SELECT  @Count = COUNT(*)  
                    FROM    #ActiveClients c  
                    WHERE   c.InTreatment = 'Y'  
                END  
         
        END  
    IF @FilterId = 2 -- Seen in 3 months  
        BEGIN  
            UPDATE  c  
            SET     c.Seen = 'Y'  
            FROM    #ActiveClients c  
            WHERE   EXISTS ( SELECT *  
                             FROM   Claims cm  
                                    JOIN ClaimLines cl ON cl.ClaimId = cm.ClaimId  
                                    JOIN Sites s ON s.SiteId = cm.SiteId  
                             WHERE  cm.ClientId = c.ClientId  
                                    AND s.ProviderId = @ProviderId  
                                    AND DATEDIFF(dd, cl.ToDate, GETDATE()) <= 90  
                                    AND ISNULL(cm.RecordDeleted, 'N') = 'N'  
                                    AND ISNULL(cl.RecordDeleted, 'N') = 'N' )  
            IF @Type = 'Detail'   
                BEGIN  
                    SELECT  c.ClientId ,  
                            c.MasterClientId ,  
                            c.LastName ,  
                            c.FirstName ,  
                            c.SSN ,  
                            c.Sex ,  
                            c.DOB ,  
                            c.Email ,  
                            c.PhoneNumber  
                    FROM    #ActiveClients c  
                    WHERE   c.Seen = 'Y'  
                    ORDER BY c.LastName ,  
                            c.FirstName   
                END  
            ELSE   
                BEGIN  
                    SELECT  @Count = COUNT(*)  
                    FROM    #ActiveClients c  
                    WHERE   c.Seen = 'Y'  
                END  
              
        END  
    IF @FilterId = 3 -- Not seen in 30 days  
        BEGIN  
            UPDATE  c  
            SET     c.NotSeen = 'Y'  
            FROM    #ActiveClients c  
            WHERE   NOT EXISTS ( SELECT *  
                                 FROM   Claims cm  
                                        JOIN ClaimLines cl ON cl.ClaimId = cm.ClaimId  
                                        JOIN Sites s ON s.SiteId = cm.SiteId  
                                 WHERE  cm.ClientId = c.ClientId  
                                        AND s.ProviderId = @ProviderId  
                                        AND DATEDIFF(dd, cl.ToDate, GETDATE()) <= 30  
                                        AND ISNULL(cm.RecordDeleted, 'N') = 'N'  
                                        AND ISNULL(cl.RecordDeleted, 'N') = 'N' )  
            IF @Type = 'Detail'   
                BEGIN  
                    SELECT  c.ClientId ,  
                            c.MasterClientId ,  
                            c.LastName ,  
                            c.FirstName ,  
                            c.SSN ,  
                            c.Sex ,  
                            c.DOB ,  
                            c.Email ,  
                            c.PhoneNumber  
                    FROM    #ActiveClients c  
                    WHERE   c.NotSeen = 'Y'  
                    ORDER BY c.LastName ,  
                            c.FirstName   
                END  
            ELSE   
                BEGIN  
                    SELECT  @Count = COUNT(*)  
                    FROM    #ActiveClients c  
                    WHERE   c.NotSeen = 'Y'  
                END  
        END  
    IF @FilterId = 4 -- Incomplete Information  
        BEGIN  
            IF @Type = 'Detail'   
                BEGIN  
                    SELECT  c.ClientId ,  
                            c.MasterClientId ,  
                            c.LastName ,  
                            c.FirstName ,  
                            c.SSN ,  
                            c.Sex ,  
                            c.DOB ,  
                            c.Email ,  
                            c.PhoneNumber  
                    FROM    #ActiveClients c  
                    WHERE   c.IncompleteInformation = 'Y'  
                END  
            ELSE   
                BEGIN  
                    SELECT  @Count = COUNT(*)  
                    FROM    #ActiveClients c  
                    WHERE   c.IncompleteInformation = 'Y'  
                END  
        END  
      
GO


