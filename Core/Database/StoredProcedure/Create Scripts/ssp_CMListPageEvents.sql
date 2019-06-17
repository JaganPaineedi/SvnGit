
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMListPageEvents]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMListPageEvents]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
  

CREATE PROCEDURE [dbo].[ssp_CMListPageEvents]        
 /*********************************************************************/        
        
 /*                                                                   */        
 /* Data Modifications:                                               */        
 /*                                                                   */        
 /* Updates:                                                          */        
 /*   Date        Author            Purpose                           */        
 /*  09 May 2014  SuryaBalan        created                           */   
 /*  26 Dec 2014  Venkatesh MR		Change the logic as if event id exist show the Event Name else ''Image Records'' in listpage
									For task 295 in Care Management to SmartCare Env. Issues Tracking.  */    
 /*  30 Jan 2015  Kiran Kumar N     For task Care Management to SmartCare Env. Issues Tracking #397         */  									 
 /*  For Listing CM EVENTS                                            */  
 /*  06-02-2015   Shruthi.S         Added distinct and filtered based on documenttype.Since, all the events are of type 10 to avoid multiple duplicate events.Ref #457 Env issues.
     20-03-2015   Shruthi.S         Added documenttype 17 as per discussion with Katie.Ref #554 Env Issues.*/ 
--	 03.Sep.2015  Rohith Uppin		RecordDeleted Check added for Screens table. Task#643 - SWMBH Support     
--	 21.Jan.2016  Rohith Uppin		Logic modified for filter Assoicated Insurers & Providers. #813 SWMBH Support
--	 16.March.2016  Soujanya		Modified for filtering EventTypes. #2269 Core Bugs
--   28-Dec-2016 Sachin Borgave     Given the space between Lastname and FirstName for Staff Column in Events Listpage. Core Bugs #2341 
--   02-Aug-2017 Sachin Borgave     What : When Document is signed, In List Page Status should show as Completed. Why : Offshore QA Bugs #583    
								                  
 /*********************************************************************/        
 -- Add the parameters for the stored procedure here          
 @SessionId VARCHAR(30)        
 ,@InstanceId INT        
 ,@PageNumber INT        
 ,@PageSize INT        
 ,@SortExpression VARCHAR(100)        
 ,@EventType INT        
 ,@EventStatus INT        
 ,@StaffId INT        
 ,@InsurerId INT        
 ,@ProviderId INT        
 ,@EventName VARCHAR(100)        
 ,@ClientId INT        
 ,@LoggedinStaffId INT        
 ,@otherFilter INT        
AS        
BEGIN        
 BEGIN TRY        
  DECLARE @MasterClientId INT        
  CREATE TABLE #Insurers (InsurerId INT)        
  CREATE TABLE #Clients  (ClientId INT) 
  CREATE TABLE #EventTypes  (Id INT)           
  DECLARE @MasterRecord CHAR(1)        
        
  INSERT INTO #Clients (ClientId) values (@ClientId)
  SELECT @MasterRecord = MasterRecord from Clients where ClientId = @ClientId  
     
  Insert into #EventTypes(Id)
  values( 5773),(5774)
  IF @MasterRecord = 'Y'
	BEGIN
	  INSERT INTO #Clients (ClientId)
	  SELECT pc.ClientId from ProviderClients pc
	  INNER JOIN StaffClients sc ON pc.ClientID = sc.ClientID and sc.StaffId=@LoggedinStaffId
	  Where pc.MasterClientId = @ClientId and isnull(pc.RecordDeleted, 'N') = 'N' 
	  
	  Insert into #EventTypes
      Select 5771 -- MH Client 
	END
     ELSE
 BEGIN 
	Insert into #EventTypes
   Select 5772  -- SU Client      
 END    
      
   -- select * from #Clients    
  DECLARE @AllStaffInsurer CHAR(1)
  SELECT @AllStaffInsurer = isnull(AllInsurers, 'N') FROM staff WHERE staffid = @LoggedinStaffId 
  
  If(@InsurerId  < 0)
	  BEGIN
		IF(@AllStaffInsurer = 'N')
			BEGIN
			  INSERT INTO #Insurers (InsurerId)   
			  SELECT I.InsurerId        
			  FROM Insurers I        
				INNER JOIN StaffInsurers SI ON SI.InsurerId = I.InsurerId        
			  WHERE SI.StaffId = @LoggedinStaffId        
			   AND isnull(I.RecordDeleted, 'N') = 'N'        
			   AND isnull(SI.RecordDeleted, 'N') = 'N' 
			   AND ISNULL(I.Active,'N') = 'Y'
			END
		ELSE
			BEGIN
				  INSERT INTO #Insurers (InsurerId)        
				  SELECT I.InsurerId        
				  FROM Insurers I				  
				  WHERE ISNULL(I.RecordDeleted, 'N') = 'N'  AND ISNULL(I.Active,'N') = 'Y'
			END
	  END
     
  
	--Associated Providers
  DECLARE @AllStaffProvider CHAR(1)
  
  SELECT @AllStaffProvider = isnull(AllProviders, 'N') From Staff where staffid = @LoggedinStaffId
  
  CREATE TABLE #Provider  (Providerid INT)  
   
   If(@ProviderId  < 0)
	  BEGIN
		IF(@AllStaffProvider = 'N')
			BEGIN
				 Insert into #Provider(ProviderId)
				   SELECT P.ProviderId  
				   FROM Providers  P  
					INNER JOIN StaffProviders SP ON SP.ProviderId = P.ProviderId     
				   WHERE  ISNULL(P.RecordDeleted,'N')='N'  AND ISNULL(Active,'N') = 'Y'   
					AND ISNULL(SP.RecordDeleted,'N') ='N'  
					AND SP.StaffId = @LoggedinStaffId  
					AND P.ProviderId > 0   
				   ORDER BY ProviderName    
			END
		ELSE
			BEGIN
				Insert into #Provider(ProviderId) 
					SELECT ProviderId 
					FROM Providers P
					WHERE isnull(P.RecordDeleted, 'N') <> 'Y' AND ISNULL(p.Active,'N') = 'Y'			
			END
	END
	       
  CREATE TABLE #CustomFilters (EventId INT NOT NULL)        
        
  DECLARE @ApplyFilterClicked CHAR(1)        
  DECLARE @CustomFiltersApplied CHAR(1)        
        
  SET @SortExpression = RTRIM(LTRIM(@SortExpression))        
        
  IF isnull(@SortExpression, '') = ''        
   SET @SortExpression = 'EventName'        
  --           
  -- New retrieve - the request came by clicking on the Apply Filter button                             
  --          
  SET @ApplyFilterClicked = 'Y'        
  SET @CustomFiltersApplied = 'N'        
        
  --SET @PageNumber = 1          
  IF @otherFilter > 10000        
  BEGIN        
   SET @CustomFiltersApplied = 'Y'        
        
   INSERT INTO #CustomFilters (EventId)        
   EXEC ssp_CMListPageEvents @EventType = @EventType        
    ,@EventStatus = @EventStatus        
    ,@StaffId = @StaffId        
    ,@InsurerId = @InsurerId        
    ,@ProviderId = @ProviderId        
    ,@otherFilter = @otherFilter        
  END;        
        
  WITH CMEVENTS        
  AS (        
   --BEGIN        
   SELECT distinct e.EventId        
    ,e.StaffId        
    ,e.ClientId        
    ,e.EventTypeId        
    ,e.EventDateTime 
    --Added by Venkatesh on 26/12/2014    
    --,CASE isnull(ir.EventId, 0)        
     --WHEN 0        
      --THEN et.EventName        
     --ELSE ''Image Records''        
     --END AS Event    
    ,et.EventName  AS Event    
    ,e.EventDateTime AS DATE        
   -- ,gc.CodeName AS STATUS  
    , CASE WHEN gc.CodeName='Signed' then 'Completed' else gc.CodeName end AS Status  -- Sachin      
    ,e.FollowUpEventId        
    ,RTRIM(ISNULL(u.LastName, '')) + ', ' + RTRIM(ISNULL(u.FirstName, '')) AS Staff         -- By Sachin -Given Space After comma. 
    ,e.RowIdentifier        
    ,e.CreatedBy        
    ,e.CreatedDate        
    ,e.ModifiedBy        
    ,e.ModifiedDate        
    ,e.RecordDeleted        
    ,e.DeletedDate        
    ,e.DeletedBy        
    ,SC.ScreenId        
    ,D.DocumentId
    ,DC.DocumentType        
    ,et.AssociatedDocumentCodeId        
    ,                                                              
    CASE P.ProviderType        
     WHEN 'I'        
      THEN P.ProviderName + ', ' + P.FirstName        
     WHEN 'F'        
      THEN P.ProviderName        
     END AS 'Provider'       
    ,P.ProviderId        
    ,I.InsurerId        
    ,        
                                                     
    ir.ImageRecordId        
    ,ir.ImageServerId --,D.AuthorId,e.StaffId as Staff1,D.Status as Status1,D.ProxyId,D.DocumentShared                
    ,CanEdit = CASE         
     WHEN D.STATUS NOT IN (        
       22        
       ,23        
       )        
      THEN CASE         
        WHEN D.AuthorId = @LoggedinStaffId        
         THEN 'Y'        
        ELSE CASE         
          WHEN D.ProxyId = @LoggedinStaffId        
           THEN 'Y'        
          ELSE CASE         
            WHEN D.DocumentShared = 'Y'        
             THEN 'Y'        
            ELSE 'N'        
            END        
          END        
        END        
     ELSE 'Y'        
     END        
   FROM Events e        
   INNER JOIN Documents D ON D.EventId = E.EventId        
	INNER JOIN DocumentCodes DC ON DC.DocumentCodeId = D.DocumentCodeId                                 
   INNER JOIN Staff u ON e.StaffId = u.StaffId       
   INNER JOIN EventTypes et ON e.EventTypeId = et.EventTypeId        
                                                                                       
   INNER JOIN Screens SC ON et.AssociatedDocumentCodeId = SC.DocumentCodeId        
    AND ISNULL(SC.RecordDeleted, 'N') = 'N'        
                                                                    
   --INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = e.STATUS        
    INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = D.CurrentVersionStatus  
                          
   LEFT JOIN Providers AS p ON p.ProviderId = e.ProviderId        
   LEFT JOIN Insurers AS I ON I.InsurerId = e.InsurerId        
                                                              
   LEFT JOIN ImageRecords ir ON ir.EventId = e.EventId        
   INNER JOIN #Clients c ON c.ClientId = e.ClientId        
   WHERE ISNULL(e.RecordDeleted, 'N') = 'N'        
    AND ISNULL(u.RecordDeleted, 'N') = 'N'        
    AND ISNULL(gc.RecordDeleted, 'N') = 'N'        
    AND ISNULL(et.RecordDeleted, 'N') = 'N'        
    AND ISNULL(ir.RecordDeleted, 'N') = 'N'   
    AND ISNULL(SC.RecordDeleted, 'N') = 'N' 
    AND SC.ScreenType <> 5761        
    AND (DC.Documenttype = 10 OR DC.Documenttype =17)       
    AND (        
     (        
      @CustomFiltersApplied = 'Y'        
      AND EXISTS (        
       SELECT *        
       FROM #CustomFilters cf        
       WHERE cf.EventId = e.EventId       
       )        
      )        
     OR (        
      @CustomFiltersApplied = 'N'        
      AND (        
      (@EventType = - 1 and  exists(Select 1 from #EventTypes e1 where e1.Id = et.EventType))
       OR e.EventTypeId = @EventType        
       )        
      AND (        
       @EventStatus = - 1        
       OR e.[Status] = @EventStatus        
       )        
      AND (        
       @StaffId = - 1        
       OR e.StaffId = @StaffId        
       )        
      AND (        
       (@InsurerId = - 1 and (e.InsurerId in (select InsurerId FROM  #Insurers ) or ( @AllStaffInsurer ='Y' and  e.InsurerId is null)))
		OR e.InsurerId = @InsurerId        
       )        
      AND (        
		   (@ProviderId =-1 and  (e.ProviderId in (select ProviderId FROM  #Provider ) or ( @AllStaffProvider ='Y' and  e.ProviderId is null)))
			OR e.ProviderId = @ProviderId         
		   )        
      )        
     )        
             
            
   )        
   ,counts        
  AS (        
   SELECT count(*) AS totalrows        
   FROM CMEVENTS        
   )        
   ,RankResultSet        
  AS (        
   SELECT EventId        
    ,StaffId        
    ,ClientId        
    ,EventTypeId        
    ,EventDateTime        
    ,[Event]        
    ,[Date]        
    ,[Status]        
    ,FollowUpEventId        
    ,Staff        
    ,RowIdentifier        
    ,CreatedBy        
    ,CreatedDate        
    ,ModifiedBy        
    ,ModifiedDate        
    ,RecordDeleted        
    ,DeletedBy        
    ,ScreenId        
    ,DocumentId
    ,DocumentType        
    ,AssociatedDocumentCodeId        
    ,Provider        
    ,ProviderId        
    ,InsurerId        
    ,ImageRecordId        
    ,ImageServerId        
    ,CanEdit        
    ,COUNT(*) OVER () AS TotalCount        
    ,RANK() OVER (        
     ORDER BY CASE         
       WHEN @SortExpression = 'EventId'        
        THEN ISNULL(EventId, '')        
       END        
      ,CASE         
       WHEN @SortExpression = 'EventId DESC'       
        THEN ISNULL(EventId, '')        
       END DESC        
      ,CASE         
       WHEN @SortExpression = 'Event'        
        THEN ISNULL([Event], '')        
       END        
      ,CASE         
       WHEN @SortExpression = 'Event DESC'       
        THEN ISNULL([Event], '')        
       END DESC        
      ,CASE         
       WHEN @SortExpression = 'EventDateTime'        
        THEN ISNULL([Date], '')        
       END        
      ,CASE         
       WHEN @SortExpression = 'EventDateTime DESC'        
        THEN ISNULL([Date], '')        
       END DESC        
      ,CASE         
       WHEN @SortExpression = 'Status'        
        THEN ISNULL([Status], '')        
       END        
      ,CASE         
       WHEN @SortExpression = 'Status DESC'        
        THEN ISNULL([Status], '')        
       END DESC        
      ,CASE         
       WHEN @SortExpression = 'Staff'        
        THEN ISNULL(Staff, '')        
       END        
      ,CASE         
       WHEN @SortExpression = 'Staff DESC'        
        THEN ISNULL(Staff, '')        
       END DESC        
      ,CASE         
       WHEN @SortExpression = 'Provider'        
        THEN ISNULL(Provider, '')        
       END        
      ,CASE         
       WHEN @SortExpression = 'Provider DESC'        
        THEN ISNULL(Provider, '')        
       END DESC        
     , EventId) AS RowNumber        
   FROM CMEVENTS        
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
    ) EventId        
   ,StaffId        
   ,ClientId        
   ,EventTypeId        
   ,EventDateTime        
   ,[Event]        
   ,[Date]        
   ,[Status]        
   ,FollowUpEventId        
   ,Staff        
   ,RowIdentifier        
   ,CreatedBy        
   ,CreatedDate        
   ,ModifiedBy        
   ,ModifiedDate        
   ,RecordDeleted        
   ,DeletedBy        
   ,ScreenId        
   ,DocumentId
   ,DocumentType       
   ,AssociatedDocumentCodeId        
   ,Provider        
   ,ProviderId        
   ,InsurerId        
   ,ImageRecordId        
   ,ImageServerId        
   ,CanEdit        
   ,TotalCount        
   ,RowNumber        
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
        
  SELECT EventId        
   ,StaffId        
   ,ClientId        
   ,EventTypeId        
   ,  convert(varchar(19), EventDateTime, 101)+ ' '+    
  ltrim(substring(convert(varchar(19), EventDateTime, 100), 12, 6) )+ ' ' +   
  ltrim(substring(convert(varchar(19), EventDateTime, 100), 18, 2) ) AS EventDateTime   
   ,[Event]        
   ,[Date]        
   ,[Status]        
   ,FollowUpEventId        
   ,Staff        
   ,RowIdentifier        
   ,CreatedBy        
   ,CreatedDate        
   ,ModifiedBy        
   ,ModifiedDate        
   ,RecordDeleted        
   ,DeletedBy        
   ,ScreenId        
   ,DocumentId
   ,DocumentType        
   ,AssociatedDocumentCodeId        
   ,Provider        
   ,ProviderId        
   ,InsurerId        
   ,ImageRecordId        
   ,ImageServerId        
   ,CanEdit        
  FROM #FinalResultSet        
  ORDER BY RowNumber        
        
  DROP TABLE #CustomFilters  
  DROP TABLE #EventTypes     
 END TRY        
        
 BEGIN CATCH        
  DECLARE @Error VARCHAR(8000)        
        
  SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_CMListPageEvents') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())        
        
  RAISERROR (        
    @Error        
    ,-- Message text.                                                                           
    16        
    ,-- Severity.                                                                                              
    1 -- State.                                                                                              
    );        
 END CATCH        
END

