  
IF EXISTS (
		SELECT *
		FROM SYS.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPagePAClientsList]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_ListPagePAClientsList]
GO
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE ssp_ListPagePAClientsList @PageNumber INT  
 ,@PageSize INT  
 ,@SortExpression VARCHAR(100)  
 ,@OtherFilter INT  
 ,@ProviderId INT  
 ,@TreamentId INT  
AS  
/************************************************************************************************                                      
  -- Stored Procedure: dbo.ssp_ListPagePAClientsList             
  -- Copyright: Streamline Healthcate Solutions             
  -- Purpose: Used by PA Clients list page             
  -- Updates:             
  -- Date			Author    Purpose             
  -- 14.Oct.2014 SuryaBalan   Created  Task#125 CM to SC       
  -- 16.Oct.2014 SuryaBalan   Modified Admission EventTypeId 1010 to 1127     
  -- 16.Oct.2014 SuryaBalan   Modified where condition to get All providers     
  -- 17.Oct.2014 SuryaBalan   Added Race and Living Arrangement Columns    
  --17-DEC-2015  Basudev Sahu Modified For Task #609 Network180 Customization to  Get Organisation  As ClientName		
  --31 Aug 2016	 Vithobha	  Moved CustomSUDischarges to scsp_GetCustomSUDischargeDetails, AspenPointe-Environment Issues: #45 
  --30 March 2017 PradeepT    What: Joining the clients with  result set of top 1 ClientRaces group by ClientId instead of 
									joining Clients with clientRaces directly. Join of Clients with  ClientRaces return 
									multiple row corresponding to clients which cause duplicate row returned.
							  Why: Allegan Support - #899
     	
  *************************************************************************************************/  
BEGIN  
 BEGIN TRY  
  SET NOCOUNT ON;  
  
  --DECLATE TABLE TO GET DATA IF OTHER FILTER EXISTS -------                  
  DECLARE @CustomFiltersApplied CHAR(1)  
  
  CREATE TABLE #CustomFilters (ClientID INT) 
  CREATE TABLE #CustomSUDischarges (AdmissionDocumentId INT)   
  
  DECLARE @EventType INT  
  DECLARE @HospitalizeStatus INT  
  
  SET @CustomFiltersApplied = 'N'  
  SET @HospitalizeStatus = 2181  
  
  CREATE TABLE #Clients (  
   ClientId INT  
   ,MasterClientId INT  
   ,LastName VARCHAR(50)  
   ,FirstName VARCHAR(50)  
   ,ClientName VARCHAR(500)  
   ,Age VARCHAR(15)  
   ,SSN VARCHAR(4)  
   ,Sex CHAR(1)  
   ,DOB DATETIME  
   ,Email VARCHAR(50)  
   ,PhoneNumber VARCHAR(80)  
   ,InTreatment VARCHAR(1)  
   ,Seen VARCHAR(1)  
   ,NotSeen VARCHAR(1)  
   ,IncompleteInformation VARCHAR(1)  
   ,Race VARCHAR(100)  
   ,LivingArrangement VARCHAR(500)  
   ,ProviderId INT
   ,ProviderName VARCHAR(500)  
   )  
  
  CREATE TABLE #ResultSet (  
   ClientId INT  
   ,MasterClientId INT  
   ,LastName VARCHAR(50)  
   ,FirstName VARCHAR(50)  
   ,ClientName VARCHAR(500)  
   ,Age VARCHAR(15)  
   ,SSN VARCHAR(4)  
   ,Sex CHAR(1)  
   ,DOB DATETIME  
   ,Email VARCHAR(50)  
   ,PhoneNumber VARCHAR(80)  
   ,Race VARCHAR(100)  
   ,LivingArrangement VARCHAR(500) 
   ,ProviderId INT,
   ProviderName VARCHAR(500)  
   )  
  
  --GET CUSTOM FILTERS                  
  IF @OtherFilter > 10000  
  BEGIN  
   SET @CustomFiltersApplied = 'Y'  
  
   INSERT INTO #CustomFilters (ClientID)  
   EXEC scsp_ListPagePAClientsList @SortExpression  
    ,@OtherFilter  
    ,@ProviderId  
    ,@TreamentId  
  END  
  
  INSERT INTO #CustomSUDischarges (AdmissionDocumentId)    
  EXEC scsp_GetCustomSUDischargeDetails  
  
  --INSERT DATE INTO TEMP TABLE WHICH IS FETCHED BELOW BY APPLYING FILTER.               
  IF @CustomFiltersApplied = 'N'  
  BEGIN  
   IF dbo.PAGetProviderType(@ProviderId) = 'MH'  
   BEGIN  
    INSERT INTO #Clients (  
     ClientId  
     ,MasterClientId  
     ,LastName  
     ,FirstName  
     ,ClientName  
     ,Age  
     ,SSN  
     ,Sex  
     ,DOB  
     ,Email  
     ,PhoneNumber  
     ,InTreatment  
     ,Seen  
     ,NotSeen  
     ,IncompleteInformation  
     ,Race  
     ,LivingArrangement 
     ,ProviderId
     ,ProviderName 
     )  
    SELECT c.ClientId  
     ,pc.MasterClientId  
     ,c.LastName  
     ,c.FirstName  
     ,CASE     
		WHEN ISNULL(C.ClientType, 'I') = 'I'
		 THEN ISNULL(C.LastName, '') + ' ,' + ISNULL(C.FirstName, '')
		ELSE ISNULL(C.OrganizationName, '')
		END AS ClientName
     --c.LastName + ', ' + c.FirstName AS ClientName  
     ,Cast(dbo.GetAge(c.DOB, GetDate()) AS VARCHAR(5)) + ' Years' AS Age  
     ,SUBSTRING(c.ssn, 6, 4) AS SSN  
     ,c.sex  
     ,c.dob  
     ,c.email  
     ,cp.PhoneNumber  
     ,'Y'  
     ,NULL  
     ,NULL  
     ,NULL  
     ,CASE   
      WHEN (  
        SELECT count(ClientId)  
        FROM ClientRaces  
        WHERE ClientRaces.ClientId = c.ClientId  
         AND IsNull(ClientRaces.RecordDeleted, 'N') = 'N'  
        ) > 1  
       THEN 'Multi-Racial'  
      ELSE ltrim(rtrim(g1.CodeName))  
      END AS 'Race'  
     ,g2.CodeName AS 'LivingArrangement' 
     ,pc.ProviderId,
     P.ProviderName  
    FROM Clients c 
    --Modified by Pradeep T on 30-March-2017 
    LEFT JOIN (Select MAX( cr1.RaceId) as RaceId ,cr1.ClientId from ClientRaces cr1 where 
      IsNull(cr1.RecordDeleted, 'N') = 'N' Group By cr1.ClientId )  cr on cr.ClientId = c.ClientId 
    LEFT JOIN (  
     SELECT ClientId  
      ,MAX(PhoneNumber) AS PhoneNumber  
     FROM CLientPhones  
     WHERE IsPrimary = 'Y'  
      AND ISNULL(RecordDeleted, 'N') = 'N'  
     GROUP BY ClientId  
     ) AS cp ON cp.ClientId = c.ClientId  
    INNER JOIN ProviderClients pc ON pc.ClientId = c.ClientId 
    LEFT JOIN  Providers P on P.ProviderId=pc.ProviderId
    LEFT JOIN GlobalCodes g1 ON cr.RaceId = g1.GlobalCodeId  
     AND IsNull(g1.RecordDeleted, 'N') = 'N'  
    LEFT JOIN GlobalCodes g2 ON c.LivingArrangement = g2.GlobalCodeId  
     AND IsNull(g2.RecordDeleted, 'N') = 'N'  
    WHERE (  
      pc.ProviderId = @ProviderId  
      --OR @ProviderId = - 1  
      )  
     AND c.Active = 'Y'  
     AND pc.Active = 'Y'  
     AND ISNULL(c.RecordDeleted, 'N') = 'N'  
     AND ISNULL(pc.RecordDeleted, 'N') = 'N'  
     AND EXISTS (  
      SELECT *  
      FROM ProviderAuthorizations pa  
      WHERE pa.ClientId = c.ClientId  
       AND pa.ProviderId = pc.ProviderId  
       AND pa.STATUS = 2042 -- Approved                  
       AND pa.StartDate <= GETDATE()  
       AND DATEADD(dd, 1, pa.EndDate) > GETDATE()  
       AND ISNULL(pa.RecordDeleted, 'N') = 'N'  
      )  
   END  
   ELSE  
   BEGIN  
    INSERT INTO #Clients (  
     ClientId  
     ,MasterClientId  
     ,LastName  
     ,FirstName  
     ,ClientName  
     ,Age  
     ,SSN  
     ,Sex  
     ,DOB  
     ,Email  
     ,PhoneNumber  
     ,InTreatment  
     ,Seen  
     ,NotSeen  
     ,IncompleteInformation  
     ,Race  
     ,LivingArrangement
     ,ProviderId
     ,ProviderName  
     )  
    SELECT c.ClientId  
     ,pc.MasterClientId  
     ,c.LastName  
     ,c.FirstName  
     ,c.LastName + ', ' + c.FirstName AS ClientName  
     ,Cast(dbo.GetAge(c.DOB, GetDate()) AS VARCHAR(5)) + ' Years' AS Age  
     ,SUBSTRING(c.ssn, 6, 4) AS SSN  
     ,c.Sex  
     ,c.DOB  
     ,c.Email  
     ,cp.PhoneNumber  
     ,'Y'  
     ,NULL  
     ,NULL  
     ,NULL  
     ,CASE   
      WHEN (  
        SELECT count(ClientId)  
        FROM ClientRaces  
        WHERE ClientRaces.ClientId = c.ClientId  
         AND IsNull(ClientRaces.RecordDeleted, 'N') = 'N'  
        ) > 1  
       THEN 'Multi-Racial'  
      ELSE ltrim(rtrim(g1.CodeName))  
      END AS 'Race'  
     ,g2.CodeName AS 'LivingArrangement' ,
     pc.ProviderId,
     P.ProviderName 
    FROM Clients c 
    --Modified by Pradeep T on 30-March-2017  
    LEFT JOIN (Select MAX( cr1.RaceId) as RaceId ,cr1.ClientId from ClientRaces cr1 where 
      IsNull(cr1.RecordDeleted, 'N') = 'N' Group By cr1.ClientId )  cr on cr.ClientId = c.ClientId
    LEFT JOIN (  
     SELECT ClientId  
      ,MAX(PhoneNumber) AS PhoneNumber  
     FROM ClientPhones  
     WHERE IsPrimary = 'Y'  
      AND ISNULL(RecordDeleted, 'N') = 'N'  
     GROUP BY ClientId  
     ) AS cp ON cp.ClientId = c.ClientId  
    INNER JOIN ProviderClients pc ON pc.ClientId = c.ClientId  
    LEFT JOIN Providers P on P.ProviderId=pc.ProviderId
    LEFT JOIN GlobalCodes g1 ON cr.RaceId = g1.GlobalCodeId  
     AND IsNull(g1.RecordDeleted, 'N') = 'N'  
    LEFT JOIN GlobalCodes g2 ON c.LivingArrangement = g2.GlobalCodeId  
     AND IsNull(g2.RecordDeleted, 'N') = 'N'  
    WHERE (  
      pc.ProviderId = @ProviderId  
      --OR @ProviderId = - 1  
      )  
     AND c.Active = 'Y'  
     AND pc.Active = 'Y'  
     AND ISNULL(c.RecordDeleted, 'N') = 'N'  
     AND ISNULL(pc.RecordDeleted, 'N') = 'N'  
     AND EXISTS (  
      SELECT e.ClientId  
      FROM Events e  
      INNER JOIN documents doc ON doc.eventId = e.EventId  
      INNER JOIN EventTypes ET ON ET.EventTypeId = e.EventTypeId      
      INNER JOIN ProviderClients pc ON pc.ProviderId = e.ProviderId  
       AND pc.ClientId = e.ClientId  
      WHERE e.ClientId = c.ClientId  
       AND e.ProviderId = pc.ProviderId  
        AND (ET.EventName like 'Admission')    
       AND NOT EXISTS (  
        SELECT *  
        FROM #CustomSUDischarges d  
        WHERE d.AdmissionDocumentId = doc.DocumentId  
        )  
       AND ISNULL(e.RecordDeleted, 'N') = 'N'  
       AND ISNULL(doc.RecordDeleted, 'N') <> 'Y'  
      )  
    ORDER BY c.LastName  
     ,c.FirstName  
   END  
  END  
  
  -- In Treatment       
  IF @TreamentId = 1  
  BEGIN  
   --IF @Type = ''Detail''         
   --    BEGIN       
   INSERT INTO #ResultSet  
   SELECT c.ClientId  
    ,c.MasterClientId  
    ,c.LastName  
    ,c.FirstName  
    ,c.ClientName  
    ,c.Age  
    ,c.SSN  
    ,c.Sex  
    ,c.DOB  
    ,c.Email  
    ,c.PhoneNumber  
    ,c.Race  
    ,c.LivingArrangement
    ,c.ProviderId
    ,c.ProviderName  
   FROM #Clients c  
   WHERE c.InTreatment = 'Y'  
   ORDER BY c.LastName  
    ,c.FirstName  
  
   -- END        
   --ELSE         
   --    BEGIN        
   --        SELECT  @Count = COUNT(*)        
   --        FROM    #Clients c        
   --        WHERE   c.InTreatment = ''Y''        
   --    END    
  END  
  
  -- Seen in 3 months        
  IF @TreamentId = 2  
  BEGIN  
   UPDATE c  
   SET c.Seen = 'Y'  
   FROM #Clients c  
   WHERE EXISTS (  
     SELECT *  
     FROM Claims cm  
     INNER JOIN ClaimLines cl ON cl.ClaimId = cm.ClaimId  
     INNER JOIN Sites s ON s.SiteId = cm.SiteId  
     WHERE cm.ClientId = c.ClientId  
      AND (  
       s.ProviderId = @ProviderId  
       --OR @ProviderId = - 1  
       )  
      AND DATEDIFF(dd, cl.ToDate, GETDATE()) <= 90  
      AND ISNULL(cm.RecordDeleted, 'N') = 'N'  
      AND ISNULL(cl.RecordDeleted, 'N') = 'N'  
     )  
  
   --IF @Type = ''Detail''         
   --    BEGIN      
   INSERT INTO #ResultSet  
   SELECT c.ClientId  
    ,c.MasterClientId  
    ,c.LastName  
    ,c.FirstName  
    ,c.ClientName  
    ,c.Age  
    ,c.SSN  
    ,c.Sex  
    ,c.DOB  
    ,c.Email  
    ,c.PhoneNumber  
    ,c.Race  
    ,c.LivingArrangement
    ,c.ProviderId
    ,c.ProviderName    
   FROM #Clients c  
   WHERE c.Seen = 'Y'  
   ORDER BY c.LastName  
    ,c.FirstName  
    --    END        
    --ELSE         
    --    BEGIN        
    --        SELECT  @Count = COUNT(*)        
    --        FROM    #Clients c        
    --        WHERE   c.Seen = ''Y''        
    --    END        
  END  
  
  -- Not seen in 30 days        
  IF @TreamentId = 3  
  BEGIN  
   UPDATE c  
   SET c.NotSeen = 'Y'  
   FROM #Clients c  
   WHERE NOT EXISTS (  
     SELECT *  
     FROM Claims cm  
     INNER JOIN ClaimLines cl ON cl.ClaimId = cm.ClaimId  
     INNER JOIN Sites s ON s.SiteId = cm.SiteId  
     WHERE cm.ClientId = c.ClientId  
      AND (  
       s.ProviderId = @ProviderId  
       --OR @ProviderId = - 1  
       )  
      AND DATEDIFF(dd, cl.ToDate, GETDATE()) <= 30  
      AND ISNULL(cm.RecordDeleted, 'N') = 'N'  
      AND ISNULL(cl.RecordDeleted, 'N') = 'N'  
     )  
  
   --IF @Type = ''Detail''         
   --    BEGIN        
   INSERT INTO #ResultSet  
   SELECT c.ClientId  
    ,c.MasterClientId  
    ,c.LastName  
    ,c.FirstName  
    ,c.ClientName  
    ,c.Age  
    ,c.SSN  
    ,c.Sex  
    ,c.DOB  
    ,c.Email  
    ,c.PhoneNumber  
    ,c.Race  
    ,c.LivingArrangement
    ,c.ProviderId
    ,c.ProviderName    
   FROM #Clients c  
   WHERE c.NotSeen = 'Y'  
   ORDER BY c.LastName  
    ,c.FirstName  
    --    END        
    --ELSE         
    --    BEGIN        
    --        SELECT  @Count = COUNT(*)        
    --        FROM    #Clients c        
    --        WHERE   c.NotSeen = ''Y''        
    --    END        
  END  
  
  -- Incomplete Information        
  IF @TreamentId = 4  
  BEGIN  
   --IF @Type = ''Detail''         
   --    BEGIN     
   INSERT INTO #ResultSet  
   SELECT c.ClientId  
    ,c.MasterClientId  
    ,c.LastName  
    ,c.FirstName  
    ,c.ClientName  
    ,c.Age  
    ,c.SSN  
    ,c.Sex  
    ,c.DOB  
    ,c.Email  
    ,c.PhoneNumber  
    ,c.Race  
    ,c.LivingArrangement
    ,c.ProviderId
    ,c.ProviderName    
   FROM #Clients c  
   WHERE c.IncompleteInformation = 'Y'  
    --    END        
    --ELSE         
    --    BEGIN        
    --        SELECT  @Count = COUNT(*)        
    --        FROM    #Clients c        
    --        WHERE   c.IncompleteInformation = ''Y''        
    --    END        
  END  
  
  UPDATE #ResultSet  
  SET PhoneNumber = (  
    SELECT TOP 1 CP.PhoneNumber  
    FROM ClientPhones CP  
     ,GlobalCodes GC  
    WHERE GC.GlobalCodeID = CP.PhoneType  
     AND #ResultSet.ClientID = CP.ClientID  
     AND CP.PhoneNumber <> ''  
     AND CP.PhoneNumber IS NOT NULL  
     AND ISNULL(CP.RecordDeleted, 'N') = 'N'  
    ORDER BY GC.GlobalCodeID  
    );  
  
  WITH Counts  
  AS (  
   SELECT COUNT(*) AS TotalRows  
   FROM #ResultSet  
   )  
   ,ListBanners  
  AS (  
   SELECT ClientId  
    ,MasterClientId  
    ,LastName  
    ,FirstName  
    ,ClientName  
    ,Age  
    ,SSN  
    ,Sex  
    ,DOB  
    ,Email  
    ,PhoneNumber  
    ,Race  
    ,LivingArrangement
    ,ProviderId
    ,ProviderName    
    ,COUNT(*) OVER () AS TotalCount  
    ,RANK() OVER (  
     ORDER BY CASE   
       WHEN @SortExpression = 'ClientId'  
        THEN ClientId  
       END  
      ,CASE   
       WHEN @SortExpression = 'ClientId desc'  
        THEN ClientId  
       END DESC  
      ,CASE   
       WHEN @SortExpression = 'ClientName'  
        THEN ClientName  
       END  
      ,CASE   
       WHEN @SortExpression = 'ClientName desc'  
        THEN ClientName  
       END DESC  
      ,CASE   
       WHEN @SortExpression = 'Age'  
        THEN Age  
       END  
      ,CASE   
       WHEN @SortExpression = 'Age desc'  
        THEN Age  
       END DESC  
      ,CASE   
       WHEN @SortExpression = 'Sex'  
        THEN Sex  
       END  
      ,CASE   
       WHEN @SortExpression = 'Sex desc'  
        THEN Sex  
       END DESC  
      ,CASE   
       WHEN @SortExpression = 'Race'  
        THEN Race  
       END  
      ,CASE   
       WHEN @SortExpression = 'Race desc'  
        THEN Race  
       END DESC  
      ,CASE   
       WHEN @SortExpression = 'LivingArrangement'  
        THEN LivingArrangement  
       END  
      ,CASE   
       WHEN @SortExpression = 'LivingArrangement desc'  
        THEN LivingArrangement  
       END DESC  
      ,CASE   
       WHEN @SortExpression = 'PhoneNumber'  
        THEN PhoneNumber  
       END  
      ,CASE   
       WHEN @SortExpression = 'PhoneNumber desc'  
        THEN PhoneNumber  
       END DESC  
      ,ClientId  
     ) AS RowNumber  
   FROM #ResultSet  
   )  
  SELECT TOP (  
    CASE   
     WHEN (@PageNumber = - 1)  
      THEN (  
        SELECT ISNULL(totalrows, 0)  
        FROM Counts  
        )  
     ELSE (@PageSize)  
     END  
    ) ClientId  
   ,MasterClientId  
   ,LastName  
   ,FirstName  
   ,ClientName  
   ,Age  
   ,SSN  
   ,Sex  
   ,DOB  
   ,Email  
   ,PhoneNumber  
   ,Race  
   ,LivingArrangement
   ,ProviderId
   ,ProviderName    
   ,TotalCount  
   ,RowNumber  
  INTO #FinalResultSet  
  FROM ListBanners  
  WHERE RowNumber > ((@PageNumber - 1) * @PageSize)  
  
  IF (  
    SELECT ISNULL(COUNT(*), 0)  
    FROM #finalresultset  
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
    ,ISNULL(totalcount, 0) AS NumberOfRows  
   FROM #FinalResultSet  
  END  
  
  SELECT ClientId  
   ,MasterClientId  
   ,LastName  
   ,FirstName  
   ,ClientName  
   ,Age  
   ,SSN  
   ,Sex  
   ,DOB  
   ,Email  
   ,PhoneNumber  
   ,Race  
   ,LivingArrangement
   ,ProviderId
   ,ProviderName    
  FROM #FinalResultSet  
  ORDER BY RowNumber  
 END TRY  
  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_ListPagePAClientsList') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,  
    -- Message text.                                                                                                  
    16  
    ,  
    -- Severity.                                                                                                  
    1  
    -- State.                                                                                                  
    );  
 END CATCH  
END