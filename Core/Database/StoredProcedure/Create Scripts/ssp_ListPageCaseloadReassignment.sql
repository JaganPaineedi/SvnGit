IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageCaseloadReassignment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPageCaseloadReassignment]
GO

/****** Object:  StoredProcedure [dbo].[ssp_ListPageCaseloadReassignment]    Script Date:  ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_ListPageCaseloadReassignment]  --0,100,N'',0,-1,0,-1,-1,-1,-1,null,null  
 @PageNumber     INT,     
 @PageSize       INT,     
 @SortExpression VARCHAR(100),    
 @StaffId   INT = NULL ,  
 @ClientId   INT = NULL ,
 @AssignmentType INT = NULL ,  
 @AssignmentSubType INT = NULL ,
 @LogInStaffId INT = NULL
 
 
AS     
  /************************************************************************************************                                    
  -- Stored Procedure: dbo.[ssp_ListPageCaseloadReassignment]          
  -- Copyright: Streamline Healthcate Solutions           
  -- Purpose: Used by Insurers list page           
  -- Updates:           
  -- Date        Author            Purpose           
  -- 15 May 2016  Ponnin           Created    
  -- 10 JULY 2017  Chita Ranjan       Replaced 'None' with ''(empty)  for  AssignmentSubTypeText for task Thresholds - Support # 825.1  
  -- 10 Aug 2017 Kavya  1. Differentiate ORDERS with ORDERASSIGNED and ORDERSAUTHOR , 2. Rx verbal and Queued Orders condition added #Thresholds - Support: #825.1   
  -- 27 July 2018	Bibhu     what:Added join with staffclients table to display associated clients for login staff  
          					  why:Engineering Improvement Initiatives- NBL(I) task #77   
  *************************************************************************************************/    
  BEGIN     
      BEGIN TRY   
      
    DECLARE @AssignmentTypeCode varchar (100) 
    DECLARE @AssignmentTypeCodeName varchar (250) 
	Select Top 1 @AssignmentTypeCode =  Code, @AssignmentTypeCodeName = CodeName from GlobalCodes Where globalcodeid = @AssignmentType AND Category = 'ASSIGNMENTTYPES' AND isnull(RecordDeleted, 'N') = 'N' AND Active = 'Y'

 -- RX (To get verbal order approval)

Declare @VerbalOrdersRequireApproval char                                      
select @VerbalOrdersRequireApproval= VerbalOrdersRequireApproval from SystemConfigurations  

-- SET 0 as null for the parameter values
IF(@ClientId = 0 or @ClientId = -1) set @ClientId = null
IF(@StaffId = 0 or @StaffId = -1) set @StaffId = null
IF(@AssignmentSubType = 0) SET @AssignmentSubType = -1
      
    --  select top 10 ClientId,AuthorId,[Status],DocumentShared,InitializedXML,10 as TotalCount,10 as NumberOfRows, 1 as NumberOfPages from documents
          
          create table #ResultSet (                                                      
				RowNumber       int,                                                      
				PageNumber      int,    
				ClientId       int,    
				ClientName     varchar(250),    
				StaffId			int,  
				StaffName       varchar(250), 
				AssignmentTypeId       int,    
				AssignmentCode  varchar(250), 
				AssignmentSubTypeId	 int null,
				AssignmentSubTypeText  Varchar(250),
				AssignmentTypeDescription  varchar(1000),
				IsSelected BIT,
				TotalCount  int null,
				IsOrdersAssignedTo varchar(1),
				ScreenId int,
				ScreenType int, 
				ScreenParameter Varchar(200),
				DocumentStaffAssignPKId int)  
				
				CREATE TABLE #GCASSIGNMENTTYPES (
				GlobalCodeId int,
				CodeName varchar(250),
				Code varchar(100)
				)
				
				INSERT INTO #GCASSIGNMENTTYPES (GlobalCodeId,CodeName,Code)
				SELECT GlobalCodeId,CodeName,Code  from GlobalCodes Where Category = 'ASSIGNMENTTYPES' AND isnull(RecordDeleted, 'N') = 'N' AND Active = 'Y'
         
         
          IF(@ClientId is not null or @StaffId is not null)  
          BEGIN
          -- To get Primary Clinician
          IF(isnull(@AssignmentTypeCode, '') = 'PRIMARYCLINICIAN' OR isnull(@AssignmentTypeCode, '') = '' )
          BEGIN
          INSERT INTO #ResultSet (ClientId,ClientName,StaffId,StaffName,AssignmentTypeId,AssignmentCode,AssignmentSubTypeId,AssignmentSubTypeText,AssignmentTypeDescription,IsOrdersAssignedTo,ScreenId,ScreenType,ScreenParameter,DocumentStaffAssignPKId)

          Select c.ClientId, 
          ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '') AS ClientName,
          C.PrimaryClinicianId as StaffId,
           rtrim(ltrim(s.LastName)) + ', ' + rtrim(s.FirstName)   AS StaffName, 
          (SELECT TOP 1 GlobalCodeId from #GCASSIGNMENTTYPES where Code = 'PRIMARYCLINICIAN')  as AssignmentTypeId,
          (SELECT TOP 1 CodeName from #GCASSIGNMENTTYPES where Code = 'PRIMARYCLINICIAN') as AssignmentCode,
          c.ClientId as AssignmentSubTypeId,
          '' as AssignmentSubTypeText,--Chita Ranjan
          'Primary Clinician: ' +   ISNULL(s.LastName, '') + ', ' + ISNULL(s.FirstName, '') AS AssignmentTypeDescription,
           NULL,
           969,
           5761,
          'ClientId=' + convert(varchar(100), c.ClientId),
          0
           from clients c 
           INNER JOIN Staff s on s.StaffId = c.PrimaryClinicianId           
           where (isnull(@StaffId, -1) = -1 or c.PrimaryClinicianId = @StaffId) and (isnull(@ClientId, -1) = -1 or c.ClientId = @ClientId)
        -- and (isnull(@AssignmentTypeCode, '') = '' or isnull(@AssignmentTypeCode, '') = 'PRIMARYCLINICIAN')
          AND isnull(c.RecordDeleted, 'N') = 'N' AND c.Active = 'Y' AND isnull(s.RecordDeleted, 'N') = 'N' 
          AND Exists (Select 1 From  StaffClients SC Where  SC.ClientId=C.ClientId AND SC.StaffId=@LogInStaffId)  --- 30-July-2018		Bibhu
		END
      
      
      -- To get Primary Physician
      IF (isnull(@AssignmentTypeCode, '') = 'PRIMARYPHYSICIAN' OR isnull(@AssignmentTypeCode, '') = '')
      BEGIN
          INSERT INTO #ResultSet (ClientId,ClientName,StaffId,StaffName,AssignmentTypeId,AssignmentCode,AssignmentSubTypeId,AssignmentSubTypeText,AssignmentTypeDescription,IsOrdersAssignedTo,ScreenId,ScreenType,ScreenParameter,DocumentStaffAssignPKId)
      Select c.ClientId, 
          ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '') AS ClientName,
          C.PrimaryPhysicianId as StaffId,
           rtrim(ltrim(s.LastName)) + ', ' + rtrim(s.FirstName)   AS StaffName, 
          (SELECT TOP 1 GlobalCodeId from #GCASSIGNMENTTYPES where Code = 'PRIMARYPHYSICIAN')  as AssignmentTypeId,
          (SELECT TOP 1 CodeName from #GCASSIGNMENTTYPES where Code = 'PRIMARYPHYSICIAN') as AssignmentCode,
          c.ClientId as AssignmentSubTypeId,
          '' as AssignmentSubTypeText, --Chita Ranjan
          'Primary Physician: ' +   ISNULL(s.LastName, '') + ', ' + ISNULL(s.FirstName, '') AS AssignmentTypeDescription,
           NULL,
           969,
           5761,
           'ClientId=' + convert(varchar(100), c.ClientId),
           0
           from clients c 
           INNER JOIN Staff s on s.StaffId = c.PrimaryPhysicianId AND s.Active = 'Y'
           where (isnull(@StaffId, -1) = -1 or c.PrimaryPhysicianId = @StaffId) and (isnull(@ClientId, -1) = -1 or c.ClientId = @ClientId)
         --and (isnull(@AssignmentTypeCode, '') = '' or isnull(@AssignmentTypeCode, '') = 'PRIMARYPHYSICIAN')
          AND isnull(c.RecordDeleted, 'N') = 'N' AND c.Active = 'Y' AND isnull(s.RecordDeleted, 'N') = 'N' 
          AND Exists (Select 1 From  StaffClients SC Where  SC.ClientId=C.ClientId AND SC.StaffId=@LogInStaffId)  --- 30-July-2018		Bibhu
     END
     

     
     -- To get Client Flag
     IF(isnull(@AssignmentTypeCode, '') = 'FLAG' OR isnull(@AssignmentTypeCode, '') = '' )
     BEGIN
     INSERT INTO #ResultSet (ClientId,ClientName,StaffId,StaffName,AssignmentTypeId,AssignmentCode,AssignmentSubTypeId,AssignmentSubTypeText,AssignmentTypeDescription,IsOrdersAssignedTo,ScreenId,ScreenType,ScreenParameter,DocumentStaffAssignPKId)
       Select CN.ClientId, 
        ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')  AS ClientName,
          CN.AssignedTo as StaffId,
           rtrim(ltrim(s.LastName)) + ', ' + rtrim(s.FirstName)   AS StaffName, 
        (SELECT TOP 1 GlobalCodeId from #GCASSIGNMENTTYPES where Code = 'FLAG')  as AssignmentTypeId,
          (SELECT TOP 1 CodeName from #GCASSIGNMENTTYPES where Code = 'FLAG') as AssignmentCode,
          CN.ClientNoteId as AssignmentSubTypeId,
          FT.FlagType as AssignmentSubTypeText,
          'Flag: ' +   FT.FlagType + ' - Assigned: '  +   ISNULL(s.LastName, '') + ', ' + ISNULL(s.FirstName, '') AS AssignmentTypeDescription,
           NULL,
           373,
           5761,
           -- 'ClientId=' + convert(varchar(10), c.ClientId)
           'ClientNoteId=' + convert(varchar(10),CN.ClientNoteId) +'^ClientId=' + convert(varchar(10),CN.ClientId)+ '^NoteType=' + convert(varchar(10),CN.NoteType) + '^NoteLevel=' + convert(varchar(10),CN.NoteLevel) + '^CreatedBy=' + CN.CreatedBy,
           0
           from ClientNotes CN
           INNER JOIN Clients C ON C.ClientId = CN.ClientId AND isnull(C.RecordDeleted, 'N') = 'N' AND C.Active = 'Y'
           INNER JOIN FlagTypes FT on FT.FlagTypeId = CN.NoteType AND isnull(FT.RecordDeleted, 'N') = 'N' 
           INNER JOIN Staff s on s.StaffId = CN.AssignedTo  AND s.Active = 'Y'
           where (isnull(@StaffId, -1) = -1 or CN.AssignedTo = @StaffId) and (isnull(@ClientId, -1) = -1 or CN.ClientId = @ClientId)
           and (isnull(@AssignmentSubType, -1) = -1 or FT.FlagTypeId = @AssignmentSubType)
          -- and (isnull(@AssignmentTypeCode, '') = '' or isnull(@AssignmentTypeCode, '') = 'FLAG')
          AND isnull(CN.RecordDeleted, 'N') = 'N' AND CN.Active = 'Y' AND isnull(s.RecordDeleted, 'N') = 'N'  
          AND Exists (Select 1 From  StaffClients SC Where  SC.ClientId=CN.ClientId AND SC.StaffId=@LogInStaffId)  --- 30-July-2018		Bibhu
          END
          
          
            -- To get Client Programs (recode setup logic need to add for program status) --select * from globalcodes where category = 'PROGRAMSTATUS'
      IF(isnull(@AssignmentTypeCode, '') = 'PROGRAM' OR isnull(@AssignmentTypeCode, '') = '')
       BEGIN
		INSERT INTO #ResultSet (ClientId,ClientName,StaffId,StaffName,AssignmentTypeId,AssignmentCode,AssignmentSubTypeId,AssignmentSubTypeText,AssignmentTypeDescription,IsOrdersAssignedTo,ScreenId,ScreenType,ScreenParameter,DocumentStaffAssignPKId)
        Select CP.ClientId, 
        ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')  AS ClientName,
          CP.AssignedStaffId as StaffId,
           rtrim(ltrim(s.LastName)) + ', ' + rtrim(s.FirstName)   AS StaffName, 
         (SELECT TOP 1 GlobalCodeId from #GCASSIGNMENTTYPES where Code = 'PROGRAM')  as AssignmentTypeId,
          (SELECT TOP 1 CodeName from #GCASSIGNMENTTYPES where Code = 'PROGRAM') as AssignmentCode,
          CP.ClientProgramId as AssignmentSubTypeId,
          P.ProgramName as AssignmentSubTypeText,
          'Program: ' +   P.ProgramName + ' - Assigned: '  +   ISNULL(s.LastName, '') + ', ' + ISNULL(s.FirstName, '') AS AssignmentTypeDescription,
           NULL,
           302,
           5761,
           'ClientProgramId=' + convert(varchar(10),CP.ClientProgramId) +'^ClientId=' + convert(varchar(10),CP.ClientId),
           0
           from PROGRAMS P
           INNER JOIN ClientPrograms CP ON CP.ProgramId = P.ProgramId AND isnull(CP.RecordDeleted, 'N') = 'N'
           INNER JOIN Clients C  on C.ClientId = CP.ClientId AND isnull(C.RecordDeleted, 'N') = 'N' AND C.Active = 'Y'
           INNER JOIN Staff s on s.StaffId = CP.AssignedStaffId  AND s.Active = 'Y'
           where (isnull(@StaffId, -1) = -1 or CP.AssignedStaffId = @StaffId) and (isnull(@ClientId, -1) = -1 or CP.ClientId = @ClientId)
           and (isnull(@AssignmentSubType, -1) = -1 or P.ProgramId = @AssignmentSubType)
           --and (isnull(@AssignmentTypeCode, '') = '' or isnull(@AssignmentTypeCode, '') = 'PROGRAM')
          AND isnull(P.RecordDeleted, 'N') = 'N' AND P.Active = 'Y' AND isnull(s.RecordDeleted, 'N') = 'N'  
          AND EXISTS (
						SELECT *
						FROM dbo.ssf_RecodeValuesCurrent('REASSIGNMENTPROGRAMSTATUS') AS RC
						WHERE RC.IntegerCodeId = CP.[Status]
						)
		  AND Exists (Select 1 From  StaffClients SC Where  SC.ClientId=CP.ClientId AND SC.StaffId=@LogInStaffId)  --- 30-July-2018		Bibhu
          END
          
          -- To get All active documents
          IF (isnull(@AssignmentTypeCode, '') = 'DOCUMENTS' OR isnull(@AssignmentTypeCode, '') = '' OR isnull(@AssignmentTypeCode, '') = 'DOCUMENTSINPROGRESS' OR isnull(@AssignmentTypeCode, '') = 'DOCUMENTSTODO' OR isnull(@AssignmentTypeCode, '') = 'DOCUMENTSTOBEREVIEWED' OR isnull(@AssignmentTypeCode, '') = 'DOCUMENTSTOACKNOWLEDGE' OR isnull(@AssignmentTypeCode, '') = 'DOCUMENTSTOSIGN' OR isnull(@AssignmentTypeCode, '') = 'DOCUMENTSTOCOSIGN')
          BEGIN
          EXEC [ssp_ListDocumentCaseloadReassignment] @AssignmentTypeCode, @StaffId, @ClientId, @AssignmentSubType,@LogInStaffId
		  END
          
          
          
         -- To get All active Events
          IF(isnull(@AssignmentTypeCode, '') = 'EVENTS' OR isnull(@AssignmentTypeCode, '') = '')
         BEGIN
         INSERT INTO #ResultSet (ClientId,ClientName,StaffId,StaffName,AssignmentTypeId,AssignmentCode,AssignmentSubTypeId,AssignmentSubTypeText,AssignmentTypeDescription,IsOrdersAssignedTo,ScreenId,ScreenType,ScreenParameter,DocumentStaffAssignPKId)
           Select D.ClientId, 
        ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')  AS ClientName,
          D.AuthorId as StaffId,
           rtrim(ltrim(s.LastName)) + ', ' + rtrim(s.FirstName)   AS StaffName, 
         (SELECT TOP 1 GlobalCodeId from #GCASSIGNMENTTYPES where Code = 'EVENTS')  as AssignmentTypeId,
          (SELECT TOP 1 CodeName from #GCASSIGNMENTTYPES where Code = 'EVENTS') as AssignmentCode,
          D.DocumentId as AssignmentSubTypeId,
          ET.EventName as AssignmentSubTypeText,
          'Event: ' +   ET.EventName +  ' - ' + CASE WHEN D.EffectiveDate IS NULL THEN '' ELSE  CONVERT(VARCHAR(10), D.EffectiveDate, 101) END + ' - ' + dbo.ssf_GetGlobalCodeNameById(D.Status) + ' - '  +   ISNULL(s.LastName, '') + ', ' + ISNULL(s.FirstName, '') AS AssignmentTypeDescription,
            NULL,
           SC.ScreenId,
           5763,
           convert(varchar(10),D.ClientId) + ',' + convert(varchar(10),E.EventId) + ',' + convert(varchar(10),E.EventId) +  ','+ convert(varchar(10),D.DocumentId) + ',' + convert(varchar(10),SC.ScreenId) +  ',' + convert(varchar(10),D.DocumentCodeId) + ',''' + ET.EventName + ''',' + convert(varchar(10),DC.DocumentType),
           0
           from DocumentCodes DC
           INNER JOIN Documents D ON DC.DocumentCodeId = D.DocumentCodeId AND isnull(DC.RecordDeleted, 'N') = 'N' AND isnull(D.RecordDeleted, 'N') = 'N'
           INNER JOIN Clients C  on C.ClientId = D.ClientId AND isnull(C.RecordDeleted, 'N') = 'N' AND C.Active = 'Y'
           INNER JOIN  EventTypes ET on ET.AssociatedDocumentCodeId = DC.DocumentCodeId   AND isnull(ET.RecordDeleted, 'N') = 'N'
           INNER JOIN [Events] E on E.EventTypeId = ET.EventTypeId AND isnull(E.RecordDeleted, 'N') = 'N' and E.ClientId = D.ClientId and E.EventId = D.EventId
           INNER JOIN Staff s on s.StaffId = D.AuthorId AND s.Active = 'Y'
           INNER JOIN Screens SC on SC.DocumentCodeId = DC.DocumentCodeId AND isnull(SC.RecordDeleted, 'N') = 'N' 
           where (isnull(@StaffId, -1) = -1 or D.AuthorId = @StaffId) and (isnull(@ClientId, -1) = -1 or D.ClientId = @ClientId)
           and (isnull(@AssignmentSubType, -1) = -1 or DC.DocumentCodeId = @AssignmentSubType)
          -- and (isnull(@AssignmentTypeCode, '') = '' or isnull(@AssignmentTypeCode, '') = 'EVENTS')
           AND DC.Active = 'Y' AND D.Status in (20,21) AND isnull(s.RecordDeleted, 'N') = 'N' --AND DC.DocumentCodeId IN (SELECT ISNULL(AssociatedDocumentCodeId, -1) from EventTypes ET Where isnull(ET.RecordDeleted, 'N') = 'N')
           AND Exists (Select 1 From  StaffClients SC Where  SC.ClientId=D.ClientId AND SC.StaffId=@LogInStaffId)  --- 30-July-2018		Bibhu
		 END
          
            -- To get All active Orders with Assigned To staff.
            
          IF(isnull(@AssignmentTypeCode, '') = 'ORDERSASSIGNED' OR isnull(@AssignmentTypeCode, '') = '')
          BEGIN  
		INSERT INTO #ResultSet (ClientId,ClientName,StaffId,StaffName,AssignmentTypeId,AssignmentCode,AssignmentSubTypeId,AssignmentSubTypeText,AssignmentTypeDescription,IsOrdersAssignedTo,ScreenId,ScreenType,ScreenParameter,DocumentStaffAssignPKId)
           Select D.ClientId, 
        ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')  AS ClientName,
          CO.AssignedTo as StaffId,
           rtrim(ltrim(s.LastName)) + ', ' + rtrim(s.FirstName)   AS StaffName, 
         (SELECT TOP 1 GlobalCodeId from #GCASSIGNMENTTYPES where Code = 'ORDERSASSIGNED')  as AssignmentTypeId,
          (SELECT TOP 1 CodeName from #GCASSIGNMENTTYPES where Code = 'ORDERSASSIGNED') as AssignmentCode,
          CO.ClientOrderId as AssignmentSubTypeId,
          O.OrderName as AssignmentSubTypeText,
          'Order: ' +   O.OrderName + ' - ' + CASE WHEN D.EffectiveDate IS NULL THEN '' ELSE  CONVERT(VARCHAR(10), D.EffectiveDate, 101) END +  ' - Assigned: '  +   ISNULL(s.LastName, '') + ', ' + ISNULL(s.FirstName, '') AS AssignmentTypeDescription,
           'Y',
           778,
           5761,
           'ClientOrderId=' + convert(varchar(10),CO.ClientOrderId),
           0
           from DocumentCodes DC
           INNER JOIN Documents D ON DC.DocumentCodeId = D.DocumentCodeId AND isnull(DC.RecordDeleted, 'N') = 'N' AND isnull(D.RecordDeleted, 'N') = 'N'
           INNER JOIN Clients C  on C.ClientId = D.ClientId AND isnull(C.RecordDeleted, 'N') = 'N' AND C.Active = 'Y'
           INNER JOIN  ClientOrders CO on CO.DocumentId = D.DocumentId   AND isnull(CO.RecordDeleted, 'N') = 'N' AND CO.Active = 'Y'
           INNER JOIN Orders O on O.OrderId = CO.OrderId  AND isnull(O.RecordDeleted, 'N') = 'N' AND O.Active = 'Y'
           INNER JOIN Staff s on s.StaffId = CO.AssignedTo AND s.Active = 'Y'
           where (isnull(@StaffId, -1) = -1 or CO.AssignedTo = @StaffId) and (isnull(@ClientId, -1) = -1 or D.ClientId = @ClientId)
           and (isnull(@AssignmentSubType, -1) = -1 or O.OrderType = @AssignmentSubType)
           --and (isnull(@AssignmentTypeCode, '') = '' or isnull(@AssignmentTypeCode, '') = 'ORDERS')
           AND DC.Active = 'Y'  AND D.Status in (20,21)   AND isnull(s.RecordDeleted, 'N') = 'N' 
           AND Exists (Select 1 From  StaffClients SC Where  SC.ClientId=D.ClientId AND SC.StaffId=@LogInStaffId)  --- 30-July-2018		Bibhu
END
          -- To get All active Orders with Author.
  IF(isnull(@AssignmentTypeCode, '') = 'ORDERSAUTHOR' OR isnull(@AssignmentTypeCode, '') = '')
          BEGIN  
       INSERT INTO #ResultSet (ClientId,ClientName,StaffId,StaffName,AssignmentTypeId,AssignmentCode,AssignmentSubTypeId,AssignmentSubTypeText,AssignmentTypeDescription,IsOrdersAssignedTo,ScreenId,ScreenType,ScreenParameter,DocumentStaffAssignPKId)
           Select D.ClientId, 
        ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')  AS ClientName,
          D.AuthorId as StaffId,
           rtrim(ltrim(s.LastName)) + ', ' + rtrim(s.FirstName)   AS StaffName, 
         (SELECT TOP 1 GlobalCodeId from #GCASSIGNMENTTYPES where Code = 'ORDERSAUTHOR')  as AssignmentTypeId,
          (SELECT TOP 1 CodeName from #GCASSIGNMENTTYPES where Code = 'ORDERSAUTHOR') as AssignmentCode,
          D.DocumentId  as AssignmentSubTypeId,
          O.OrderName as AssignmentSubTypeText,
          'Order: ' +   O.OrderName + ' - ' + CASE WHEN D.EffectiveDate IS NULL THEN '' ELSE  CONVERT(VARCHAR(10), D.EffectiveDate, 101) END + ' - Author: '  +   ISNULL(s.LastName, '') + ', ' + ISNULL(s.FirstName, '') AS AssignmentTypeDescription,
           'N',
            778,
           5761,
           'ClientOrderId=' + convert(varchar(10),CO.ClientOrderId),
           0
           from DocumentCodes DC
           INNER JOIN Documents D ON DC.DocumentCodeId = D.DocumentCodeId AND isnull(DC.RecordDeleted, 'N') = 'N' AND isnull(D.RecordDeleted, 'N') = 'N'
           INNER JOIN Clients C  on C.ClientId = D.ClientId AND isnull(C.RecordDeleted, 'N') = 'N' AND C.Active = 'Y'
           INNER JOIN  ClientOrders CO on CO.DocumentId = D.DocumentId   AND isnull(CO.RecordDeleted, 'N') = 'N' AND CO.Active = 'Y'
           INNER JOIN Orders O on O.OrderId = CO.OrderId  AND isnull(O.RecordDeleted, 'N') = 'N' AND O.Active = 'Y'
           INNER JOIN Staff s on s.StaffId = D.AuthorId  AND s.Active = 'Y'
           where (isnull(@StaffId, -1) = -1 or D.AuthorId = @StaffId) and (isnull(@ClientId, -1) = -1 or D.ClientId = @ClientId)
           and (isnull(@AssignmentSubType, -1) = -1 or O.OrderType = @AssignmentSubType)
           --and (isnull(@AssignmentTypeCode, '') = '' or isnull(@AssignmentTypeCode, '') = 'ORDERS')
           AND DC.Active = 'Y'  AND D.Status in (20,21)  AND isnull(s.RecordDeleted, 'N') = 'N'
           AND Exists (Select 1 From  StaffClients SC Where  SC.ClientId=D.ClientId AND SC.StaffId=@LogInStaffId)  --- 30-July-2018		Bibhu
           END
           
           
            -- To get Client Inquires (change logic to pull only InProgress inquiries) 
    IF (((isnull(@AssignmentTypeCode, '') = '' or isnull(@AssignmentTypeCode, '') = 'INQUIRY')) AND (COL_LENGTH('CustomInquiries','ClientId') IS NOT NULL AND COL_LENGTH('CustomInquiries','AssignedToStaffId') IS NOT NULL AND COL_LENGTH('CustomInquiries','InquiryId') IS NOT NULL AND COL_LENGTH('CustomInquiries','InquiryStartDateTime') IS NOT NULL AND COL_LENGTH('CustomInquiries','InquiryStatus') IS NOT NULL ))
       BEGIN
		DECLARE @SQLQuery AS NVARCHAR(max)
		 if (@StaffId is null) set @StaffId = -1
		 if (@ClientId is null) set @ClientId = -1
         SET @SQLQuery =  
         N'INSERT INTO #ResultSet (ClientId,ClientName,StaffId,StaffName,AssignmentTypeId,AssignmentCode,AssignmentSubTypeId,AssignmentSubTypeText,AssignmentTypeDescription,IsOrdersAssignedTo,ScreenId,ScreenType,ScreenParameter,DocumentStaffAssignPKId)
         Select CI.ClientId, 
        ISNULL(C.LastName, '''') + '', '' + ISNULL(C.FirstName, '''')  AS ClientName,
          CI.AssignedToStaffId as StaffId,
           rtrim(ltrim(s.LastName)) + '', '' + rtrim(s.FirstName)   AS StaffName, 
          (SELECT TOP 1 GlobalCodeId from #GCASSIGNMENTTYPES where Code = ''INQUIRY'')  as AssignmentTypeId,
          (SELECT TOP 1 CodeName from #GCASSIGNMENTTYPES where Code = ''INQUIRY'') as AssignmentCode,
          CI.InquiryId as AssignmentSubTypeId,
           '''' as AssignmentSubTypeText, --Chita Ranjan
          ''Inquiry: '' + CASE WHEN CI.InquiryStartDateTime IS NULL THEN '''' ELSE  CONVERT(VARCHAR(10), CI.InquiryStartDateTime, 101) END + '' - Assigned: ''  +   ISNULL(s.LastName, '''') + '', '' + ISNULL(s.FirstName, '''') AS AssignmentTypeDescription,
           NULL,
           (select top 1 ScreenId from Screens where Screenname like ''Inquiry'' and ScreenType = 5761 and ScreenId > 10000  AND isnull(RecordDeleted, ''N'') = ''N''),
           5761,
           ''InquiryId='' + convert(varchar(10),CI.InquiryId),
           0
           from CustomInquiries CI
           INNER JOIN Clients C  on C.ClientId = CI.ClientId AND isnull(C.RecordDeleted, ''N'') = ''N'' AND C.Active = ''Y''
           INNER JOIN Staff s on s.StaffId = CI.AssignedToStaffId AND s.Active = ''Y''
           where  ( '''+ CAST(@StaffId AS VARCHAR)+''' =-1 or CI.AssignedToStaffId ='''+ CAST(@StaffId AS VARCHAR)+''') and ( '''+ CAST(@ClientId AS VARCHAR)+''' =-1 or CI.ClientId ='''+ CAST(@ClientId AS VARCHAR)+''') and
           isnull(CI.RecordDeleted, ''N'') = ''N'' AND isnull(s.RecordDeleted, ''N'') = ''N'' 
            AND EXISTS (
						SELECT *
						FROM dbo.ssf_RecodeValuesCurrent(''REASSIGNMENTINQUIRYSTATUS'') AS RC
						WHERE RC.IntegerCodeId = CI.InquiryStatus AND RC.CodeName = ''INPROGRESS''	
						)
			AND Exists (Select 1 From  StaffClients SC Where  SC.ClientId=CI.ClientId AND  SC.StaffId='''+CAST(@LogInStaffId AS VARCHAR)+''')'  --- 30-July-2018		Bibhu
						
	--print @SQLQuery
	exec (@SQLQuery)
          END
         

          
            -- To get Client Financial Assignments
            IF(isnull(@AssignmentTypeCode, '') = 'FINANCIALASSIGNMENTS' OR isnull(@AssignmentTypeCode, '') = '')
            BEGIN
            INSERT INTO #ResultSet (ClientId,ClientName,StaffId,StaffName,AssignmentTypeId,AssignmentCode,AssignmentSubTypeId,AssignmentSubTypeText,AssignmentTypeDescription,IsOrdersAssignedTo,ScreenId,ScreenType,ScreenParameter,DocumentStaffAssignPKId)
           Select null as ClientId, 
          ''  AS ClientName,
          s.StaffId as StaffId,
           rtrim(ltrim(s.LastName)) + ', ' + rtrim(s.FirstName)   AS StaffName, 
         (SELECT TOP 1 GlobalCodeId from #GCASSIGNMENTTYPES where Code = 'FINANCIALASSIGNMENTS')  as AssignmentTypeId,
          (SELECT TOP 1 CodeName from #GCASSIGNMENTTYPES where Code = 'FINANCIALASSIGNMENTS') as AssignmentCode,
          FA.FinancialAssignmentId as AssignmentSubTypeId,
           ''  as AssignmentSubTypeText,
          'Financial Assignment: ' +   FA.AssignmentName + ' - Assigned:'  +   ISNULL(s.LastName, '') + ', ' + ISNULL(s.FirstName, '') AS AssignmentTypeDescription,
           NULL,
           1119,
           5761,
           'FinancialAssignmentId=' + convert(varchar(10),FA.FinancialAssignmentId),
           0
           from FinancialAssignments FA
           INNER JOIN Staff s on s.FinancialAssignmentId = FA.FinancialAssignmentId 
           where (S.StaffId = @StaffId) AND s.Active = 'Y'
           --and (isnull(@AssignmentTypeCode, '') = '' or isnull(@AssignmentTypeCode, '') = 'FINANCIALASSIGNMENTS')
          AND isnull(FA.RecordDeleted, 'N') = 'N' AND FA.Active = 'Y' AND isnull(s.RecordDeleted, 'N') = 'N' 
          END
          
              -- To get Client Contact Notes (recode setup logic need to add for status) --select * from globalcodes where category = 'CONTACTNOTESTATUS'
             IF(isnull(@AssignmentTypeCode, '') = 'CONTACTNOTES' OR isnull(@AssignmentTypeCode, '') = '')
             BEGIN 
           INSERT INTO #ResultSet (ClientId,ClientName,StaffId,StaffName,AssignmentTypeId,AssignmentCode,AssignmentSubTypeId,AssignmentSubTypeText,AssignmentTypeDescription,IsOrdersAssignedTo,ScreenId,ScreenType,ScreenParameter,DocumentStaffAssignPKId)
           Select CCN.ClientId, 
        ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')  AS ClientName,
          CCN.AssignedTo as StaffId,
           rtrim(ltrim(s.LastName)) + ', ' + rtrim(s.FirstName)   AS StaffName, 
         (SELECT TOP 1 GlobalCodeId from #GCASSIGNMENTTYPES where Code = 'CONTACTNOTES')  as AssignmentTypeId,
          (SELECT TOP 1 CodeName from #GCASSIGNMENTTYPES where Code = 'CONTACTNOTES') as AssignmentCode,
          CCN.ClientContactNoteId as AssignmentSubTypeId,
           --CASE WHEN CCN.ContactDateTime IS NULL THEN '' ELSE  CONVERT(VARCHAR(10), CCN.ContactDateTime, 101) +' '+LEFT(RIGHT(CONVERT(VARCHAR, CCN.ContactDateTime, 100), 7),5)+' '+Right(RIGHT(CONVERT(VARCHAR, CCN.ContactDateTime, 100), 7),2) END as AssignmentSubTypeText,
           '' as AssignmentSubTypeText,--Chita Ranjan
          'Contact Note: ' +   CASE WHEN CCN.ContactDateTime IS NULL THEN '' ELSE  CONVERT(VARCHAR(10), CCN.ContactDateTime, 101) +' '+LEFT(RIGHT(CONVERT(VARCHAR, CCN.ContactDateTime, 100), 7),5)+' '+Right(RIGHT(CONVERT(VARCHAR, CCN.ContactDateTime, 100), 7),2) END + ' - ' + dbo.ssf_GetGlobalCodeNameById(CCN.ContactReason) + ' - Assigned:'  +   ISNULL(s.LastName, '') + ', ' + ISNULL(s.FirstName, '') AS AssignmentTypeDescription,
           NULL,
           924,
           5761,
          'ClientId=' + convert(varchar(10),CCN.ClientId) + '^ClientContactNoteId=' + convert(varchar(10),CCN.ClientContactNoteId),
          0
           from ClientContactNotes CCN
           INNER JOIN Clients C  on C.ClientId = CCN.ClientId AND isnull(C.RecordDeleted, 'N') = 'N' AND C.Active = 'Y'
           INNER JOIN Staff s on s.StaffId = CCN.AssignedTo  AND s.Active = 'Y'
           where (isnull(@StaffId, -1) = -1 or  CCN.AssignedTo = @StaffId) and (isnull(@ClientId, -1) = -1 or CCN.ClientId = @ClientId)
           --and (isnull(@AssignmentTypeCode, '') = '' or isnull(@AssignmentTypeCode, '') = 'CONTACTNOTES')
          AND isnull(CCN.RecordDeleted, 'N') = 'N' AND isnull(s.RecordDeleted, 'N') = 'N' 
           AND EXISTS (
						SELECT *
						FROM dbo.ssf_RecodeValuesCurrent('REASSIGNMENTCONTACTNOTESTATUS') AS RC
						WHERE RC.IntegerCodeId = CCN.ContactStatus AND RC.CodeName <> 'COMPLETED'	
						)
		  AND Exists (Select 1 From  StaffClients SC Where  SC.ClientId=CCN.ClientId AND SC.StaffId=@LogInStaffId)  --- 30-July-2018		Bibhu
          END
          
              -- To get Client Disclosures (recode setup logic need to add for status) --select * from globalcodes where category = 'DISCLOSURESTATUS'
          IF(isnull(@AssignmentTypeCode, '') = 'DISCLOSURES' OR isnull(@AssignmentTypeCode, '') = '')
          BEGIN
          INSERT INTO #ResultSet (ClientId,ClientName,StaffId,StaffName,AssignmentTypeId,AssignmentCode,AssignmentSubTypeId,AssignmentSubTypeText,AssignmentTypeDescription,IsOrdersAssignedTo,ScreenId,ScreenType,ScreenParameter,DocumentStaffAssignPKId)
           Select CD.ClientId, 
        ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')  AS ClientName,
          CD.AssignedToStaffId as StaffId,
           rtrim(ltrim(s.LastName)) + ', ' + rtrim(s.FirstName)   AS StaffName, 
        (SELECT TOP 1 GlobalCodeId from #GCASSIGNMENTTYPES where Code = 'DISCLOSURES')  as AssignmentTypeId,
          (SELECT TOP 1 CodeName from #GCASSIGNMENTTYPES where Code = 'DISCLOSURES') as AssignmentCode,
          CD.ClientDisclosureId as AssignmentSubTypeId,
          --CASE WHEN CD.RequestDate IS NULL THEN '' ELSE  CONVERT(VARCHAR(10), CD.RequestDate, 101) END as AssignmentSubTypeText,
           '' as AssignmentSubTypeText,
          'Disclosures: ' +   CASE WHEN CD.RequestDate IS NULL THEN '' ELSE  CONVERT(VARCHAR(10), CD.RequestDate, 101) END + ' - Assigned:'  +   ISNULL(s.LastName, '') + ', ' + ISNULL(s.FirstName, '') AS AssignmentTypeDescription,
           NULL,
           26,
           5761,
          'ClientDisclosureId=' + convert(varchar(10),CD.ClientDisclosureId),
          0
           from ClientDisclosures CD
           INNER JOIN Clients C  on C.ClientId = CD.ClientId AND isnull(C.RecordDeleted, 'N') = 'N' AND C.Active = 'Y'
           INNER JOIN Staff s on s.StaffId = CD.AssignedToStaffId AND s.Active = 'Y'
           where (isnull(@StaffId, -1) = -1 or  CD.AssignedToStaffId = @StaffId) and (isnull(@ClientId, -1) = -1 or CD.ClientId = @ClientId)
           --and (isnull(@AssignmentTypeCode, '') = '' or isnull(@AssignmentTypeCode, '') = 'DISCLOSURES')
          AND isnull(CD.RecordDeleted, 'N') = 'N' AND isnull(s.RecordDeleted, 'N') = 'N' 
           AND EXISTS (
						SELECT *
						FROM dbo.ssf_RecodeValuesCurrent('REASSIGNMENTDISCLOSURESTATUS') AS RC
						WHERE RC.IntegerCodeId = CD.DisclosureStatus AND RC.CodeName <> 'COMPLETED'	
						)
		   AND Exists (Select 1 From  StaffClients SC Where  SC.ClientId=CD.ClientId AND SC.StaffId=@LogInStaffId)  --- 30-July-2018		Bibhu
          END
          
           -- To get GRIEVANCES/APPEALS 
           IF(isnull(@AssignmentTypeCode, '') = 'GRIEVANCES/APPEALS' OR isnull(@AssignmentTypeCode, '') = '')
           BEGIN
           INSERT INTO #ResultSet (ClientId,ClientName,StaffId,StaffName,AssignmentTypeId,AssignmentCode,AssignmentSubTypeId,AssignmentSubTypeText,AssignmentTypeDescription,IsOrdersAssignedTo,ScreenId,ScreenType,ScreenParameter,DocumentStaffAssignPKId)
           Select G.ClientId, 
        ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')  AS ClientName,
          G.GrievanceAboutStaffId as StaffId,
           rtrim(ltrim(s.LastName)) + ', ' + rtrim(s.FirstName)   AS StaffName, 
        (SELECT TOP 1 GlobalCodeId from #GCASSIGNMENTTYPES where Code = 'GRIEVANCES/APPEALS')  as AssignmentTypeId,
          (SELECT TOP 1 CodeName from #GCASSIGNMENTTYPES where Code = 'GRIEVANCES/APPEALS') as AssignmentCode,
          G.GrievanceId as AssignmentSubTypeId,
          --CASE WHEN G.DateReceived IS NULL THEN '' ELSE  CONVERT(VARCHAR(10), G.DateReceived, 101) END as AssignmentSubTypeText,
          '' as AssignmentSubTypeText,--Chita Ranjan
          'Grievance/Appeal: ' +   CASE WHEN G.DateReceived IS NULL THEN '' ELSE  CONVERT(VARCHAR(10), G.DateReceived, 101) END  + ' - Assigned:'  +   ISNULL(s.LastName, '') + ', ' + ISNULL(s.FirstName, '') AS AssignmentTypeDescription,
           NULL,
           71,
           5761,
           CASE When  ISNULL(C.ClientType,'I')='I' Then
            'grievanceId=' + convert(varchar(10),G.GrievanceId) + '^TabId=1^GClientId=' + convert(varchar(10),G.ClientId) + '^GClientName=' +  ISNULL(C.LastName,'') + ', ' + ISNULL(C.FirstName,'') + '^accessOrganizationId=' + convert(varchar(10),(select TOP 1 SystemDatabaseId from SystemDatabases where isnull(RecordDeleted, 'N') = 'N')) + '^accessOrganizationName=' + (select TOP 1 OrganizationName from SystemDatabases where isnull(RecordDeleted, 'N') = 'N')
            ELSE 
             'grievanceId=' + convert(varchar(10),G.GrievanceId) + '^TabId=1^GClientId=' + convert(varchar(10),G.ClientId) + '^GClientName=' +  ISNULL(C.OrganizationName,'') + '^accessOrganizationId=' + convert(varchar(10),(select TOP 1 SystemDatabaseId from SystemDatabases where isnull(RecordDeleted, 'N') = 'N')) + '^accessOrganizationName=' + (select TOP 1 OrganizationName from SystemDatabases where isnull(RecordDeleted, 'N') = 'N')
            END,
            0                                                                 
      
          --'grievanceId=' + convert(varchar(10),G.GrievanceId) + '^TabId=1^GClientId=' + convert(varchar(10),G.ClientId) + '^accessOrganizationId=' + convert(varchar(10),(select TOP 1 SystemDatabaseId from SystemDatabases where isnull(RecordDeleted, 'N') = 'N')) + '^accessOrganizationName=' + (select TOP 1 OrganizationName from SystemDatabases where isnull(RecordDeleted, 'N') = 'N')
           from Grievances G
           INNER JOIN Clients C  on C.ClientId = G.ClientId AND isnull(C.RecordDeleted, 'N') = 'N' AND C.Active = 'Y'
           INNER JOIN Staff s on s.StaffId = G.GrievanceAboutStaffId  AND s.Active = 'Y'
           where (isnull(@StaffId, -1) = -1 or  G.GrievanceAboutStaffId = @StaffId) and (isnull(@ClientId, -1) = -1 or G.ClientId = @ClientId)
           --and (isnull(@AssignmentTypeCode, '') = '' or isnull(@AssignmentTypeCode, '') = 'GRIEVANCES/APPEALS')
          AND isnull(G.RecordDeleted, 'N') = 'N' AND isnull(s.RecordDeleted, 'N') = 'N'
          AND Exists (Select 1 From  StaffClients SC Where  SC.ClientId=G.ClientId AND SC.StaffId=@LogInStaffId)  --- 30-July-2018		Bibhu
          END
           
           
           -- To get Peer Record Review 
           IF(isnull(@AssignmentTypeCode, '') = 'PEERRECORDREVIEWS' OR isnull(@AssignmentTypeCode, '') = '')
           BEGIN
           INSERT INTO #ResultSet (ClientId,ClientName,StaffId,StaffName,AssignmentTypeId,AssignmentCode,AssignmentSubTypeId,AssignmentSubTypeText,AssignmentTypeDescription,IsOrdersAssignedTo,ScreenId,ScreenType,ScreenParameter,DocumentStaffAssignPKId)
           Select RR.ClientId, 
        ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')  AS ClientName,
          RR.ReviewingStaff as StaffId,
           rtrim(ltrim(s.LastName)) + ', ' + rtrim(s.FirstName)   AS StaffName, 
           (SELECT TOP 1 GlobalCodeId from #GCASSIGNMENTTYPES where Code = 'PEERRECORDREVIEWS')  as AssignmentTypeId,
          (SELECT TOP 1 CodeName from #GCASSIGNMENTTYPES where Code = 'PEERRECORDREVIEWS') as AssignmentCode,
          RR.RecordReviewId as AssignmentSubTypeId,
           --CASE WHEN  RR.AssignedDate IS NULL THEN '' ELSE  CONVERT(VARCHAR(10),  RR.AssignedDate, 101) END as AssignmentSubTypeText,
          '' as AssignmentSubTypeText,--Chita Ranjan
          'Peer Record Review: ' +  CASE WHEN  RR.AssignedDate IS NULL THEN '' ELSE  CONVERT(VARCHAR(10),  RR.AssignedDate, 101) END +  ' - Assigned:'  +   ISNULL(s.LastName, '') + ', ' + ISNULL(s.FirstName, '') AS AssignmentTypeDescription,
           NULL,
           932,
           5761,
          'RecordReviewId=' + convert(varchar(10),RR.RecordReviewId),
          0
           from RecordReviews RR
           INNER JOIN Clients C  on C.ClientId = RR.ClientId AND isnull(C.RecordDeleted, 'N') = 'N' AND C.Active = 'Y'
           INNER JOIN Staff s on s.StaffId = RR.ReviewingStaff AND s.Active = 'Y'
           where (isnull(@StaffId, -1) = -1 or   RR.ReviewingStaff  = @StaffId) and (isnull(@ClientId, -1) = -1 or RR.ClientId = @ClientId)
           --and (isnull(@AssignmentTypeCode, '') = '' or isnull(@AssignmentTypeCode, '') = 'PEERRECORDREVIEWS')
          AND isnull(RR.RecordDeleted, 'N') = 'N' AND isnull(s.RecordDeleted, 'N') = 'N' 
          AND Exists (Select 1 From  StaffClients SC Where  SC.ClientId=RR.ClientId AND SC.StaffId=@LogInStaffId)  --- 30-July-2018		Bibhu
          END
           
        -- To get Rx (Verbal Orders)
        
        IF(@AssignmentSubType=1 OR @AssignmentSubType=-1)
        BEGIN
  IF(isnull(@AssignmentTypeCode, '') = 'RX' OR isnull(@AssignmentTypeCode, '') = '')    
  BEGIN
 INSERT INTO #ResultSet (ClientId,ClientName,StaffId,StaffName,AssignmentTypeId,AssignmentCode,AssignmentSubTypeId,AssignmentSubTypeText,AssignmentTypeDescription,IsOrdersAssignedTo,ScreenId,ScreenType,ScreenParameter,DocumentStaffAssignPKId)
  Select Distinct CMS.ClientId, 
        ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')  AS ClientName,
          CMS.OrderingPrescriberId as StaffId,
           rtrim(ltrim(s.LastName)) + ', ' + rtrim(s.FirstName)   AS StaffName, 
          (SELECT TOP 1 GlobalCodeId from #GCASSIGNMENTTYPES where Code = 'RX')  as AssignmentTypeId,
          (SELECT TOP 1 CodeName from #GCASSIGNMENTTYPES where Code = 'RX') as AssignmentCode,
          CMS.ClientMedicationScriptId as AssignmentSubTypeId,
           'Verbal Orders' as AssignmentSubTypeText,
          'RX: Verbal Orders - Drug Name: ' +  MMN.MedicationName + ' ' + MDMedications.StrengthDescription AS AssignmentTypeDescription,
           NULL,
           969,
           5761,
          'ClientId=' + convert(varchar(10),C.ClientId),
          0
 from ClientMedicationScripts  CMS                      
 inner join Clients C on C.ClientId = CMS.ClientId and   ISNULL(C.RecordDeleted,'N')<>'Y' AND C.Active = 'Y'                 
 inner Join Staff S on S.StaffId = CMS.OrderingPrescriberId AND s.Active = 'Y'                                                     
 INNER JOIN ClientMedicationScriptDrugs CMSD on CMS.ClientMedicationScriptId = CMSD.ClientMedicationScriptId                                                        
 inner join ClientMedicationInstructions CMI on CMSD.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId      
 AND ISNULL(CMI.Active, 'Y') = 'Y'                                                  
 inner Join Staff ST on ST.UserCode = CMS.CreatedBy                                                      
 inner join ClientMedications CM on CM.ClientMedicationId = CMI.ClientMedicationId and isnull(CM.Discontinued,'N')<>'Y'                                                            
 left outer JOIN  MDMedications on MDMedications.MedicationId = CMI.StrengthId AND ISNULL(CMI.RecordDeleted, 'N') <> 'Y' and ISNULL(dbo.MDMedications.RecordDeleted, 'N') <> 'Y'                                                   
 left outer JOIN  MDDrugs ON MDMedications.ClinicalFormulationId = MDDrugs.ClinicalFormulationId  AND ISNULL(dbo.MDDrugs.RecordDeleted, 'N') <> 'Y'                                                       
 inner join Locations LOC on LOC.LocationId=CMS.LocationId                                                         
 left outer join Pharmacies Ph on Ph.PharmacyId= CMS.PharmacyId   
 inner join MDMedicationNames MMN on MMN.MedicationNameId = MDMedications.MedicationNameId AND ISNULL(MMN.RecordDeleted, 'N') <> 'Y'                                        
                                                     
 where (isnull(@StaffId, -1) = -1 or    CMS.OrderingPrescriberId  = @StaffId) and (isnull(@ClientId, -1) = -1 or CMS.ClientId = @ClientId)   and                                                      
  CMS.CreatedBy <> S.UserCode                             
 and  ISNULL(CMS.VerbalOrderApproved,'N')='N' and  ISNULL(CMS.WaitingPrescriberApproval,'N')='N'      
 and @VerbalOrdersRequireApproval='Y'                 
 and ISNULL(CMS.RecordDeleted,'N')='N'  
 AND ISNULL(CMS.Voided, 'N') = 'N'   
 AND ISNULL(CMI.Active, 'Y') = 'Y'  
 AND Exists (Select 1 From  StaffClients SC Where  SC.ClientId=CMS.ClientId AND SC.StaffId=@LogInStaffId)  --- 30-July-2018		Bibhu
 --AND (isnull(@AssignmentTypeCode, '') = '' or isnull(@AssignmentTypeCode, '') = 'RX')
     END
     END
     IF(@AssignmentSubType=2 OR @AssignmentSubType=-1)
        BEGIN  
         IF(isnull(@AssignmentTypeCode, '') = 'RX' OR isnull(@AssignmentTypeCode, '') = '')    
  BEGIN    
    -- To get Rx (Queued Orders)         
INSERT INTO #ResultSet (ClientId,ClientName,StaffId,StaffName,AssignmentTypeId,AssignmentCode,AssignmentSubTypeId,AssignmentSubTypeText,AssignmentTypeDescription,IsOrdersAssignedTo,ScreenId,ScreenType,ScreenParameter,DocumentStaffAssignPKId)
  Select Distinct CMS.ClientId, 
        ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')  AS ClientName,
          CMS.OrderingPrescriberId as StaffId,
           rtrim(ltrim(s.LastName)) + ', ' + rtrim(s.FirstName)   AS StaffName, 
         (SELECT TOP 1 GlobalCodeId from #GCASSIGNMENTTYPES where Code = 'RX')  as AssignmentTypeId,
          (SELECT TOP 1 CodeName from #GCASSIGNMENTTYPES where Code = 'RX') as AssignmentCode,
          CMS.ClientMedicationScriptId as AssignmentSubTypeId,
           'Queued Orders' as AssignmentSubTypeText,
          'RX: Queued Orders - Drug Name: ' +  MMN.MedicationName + ' ' + MDMedications.StrengthDescription AS AssignmentTypeDescription,
           NULL,
            969,
           5761,
          'ClientId=' + convert(varchar(10),C.ClientId),
          0                    
 from ClientMedicationScripts  CMS                                                      
 inner join Clients C on C.ClientId = CMS.ClientId  and ISNULL(C.RecordDeleted,'N')<>'Y' AND C.Active = 'Y'                                                   
 inner Join Staff S on S.StaffId = CMS.OrderingPrescriberId AND s.Active = 'Y'                                               
 inner Join Staff ST on ST.UserCode = CMS.CreatedBy                            
 INNER JOIN ClientMedicationScriptDrugs CMSD on CMS.ClientMedicationScriptId = CMSD.ClientMedicationScriptId                                                      
 inner join ClientMedicationInstructions CMI on CMSD.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId         
  AND ISNULL(CMI.Active, 'Y') = 'Y'                                                
 inner join ClientMedications CM on CM.ClientMedicationId = CMI.ClientMedicationId and isnull(CM.Discontinued,'N')<>'Y'                                                 
 left outer JOIN  MDMedications on MDMedications.MedicationId = CMI.StrengthId AND ISNULL(CMI.RecordDeleted, 'N') <> 'Y' and ISNULL(dbo.MDMedications.RecordDeleted, 'N') <> 'Y'                                                 
 left outer JOIN  MDDrugs ON MDMedications.ClinicalFormulationId = MDDrugs.ClinicalFormulationId  AND ISNULL(dbo.MDDrugs.RecordDeleted, 'N') <> 'Y'                                                                     
 inner join Locations LOC on LOC.LocationId=CMS.LocationId                                                       
 left outer join Pharmacies Ph on Ph.PharmacyId= CMS.PharmacyId  
 inner join MDMedicationNames MMN on MMN.MedicationNameId = MDMedications.MedicationNameId AND ISNULL(MMN.RecordDeleted, 'N') <> 'Y'                                                     
                    
 where (isnull(@StaffId, -1) = -1 or    CMS.OrderingPrescriberId  = @StaffId) and (isnull(@ClientId, -1) = -1 or CMS.ClientId = @ClientId) and             
CMS.WaitingPrescriberApproval= 'Y' --and ISNULL(CMS.VerbalOrderApproved,'N')='Y'            
 and ISNULL(CMS.RecordDeleted,'N')='N'                                                      
 AND ISNULL(CMS.Voided, 'N') = 'N'                      
  AND ISNULL(CMI.Active, 'Y') = 'Y'   
  AND Exists (Select 1 From  StaffClients SC Where  SC.ClientId=CMS.ClientId AND SC.StaffId=@LogInStaffId)  --- 30-July-2018		Bibhu     
  END
   END  
   
END
 
  ;WITH Counts
		AS (SELECT Count(*) AS TotalRows
			FROM #ResultSet)
			,RankResultSet
			AS (SELECT ClientId,
						ClientName,
						StaffId,
						StaffName,
						AssignmentTypeId,
						AssignmentCode,
						AssignmentSubTypeId,
						AssignmentSubTypeText,
						AssignmentTypeDescription,
						IsSelected,
						IsOrdersAssignedTo,
						ScreenId,
						ScreenType,
						ScreenParameter,
						DocumentStaffAssignPKId
					,Count(*) OVER () AS TotalCount
					,row_number() over (ORDER BY 
												                                                               
												CASE WHEN @SortExpression= 'ClientName'			THEN ClientName END,                                                                      
												CASE WHEN @SortExpression= 'ClientName desc'		THEN ClientName END DESC,     
												CASE WHEN @SortExpression= 'Staff'		THEN StaffName END,                                                            
												CASE WHEN @SortExpression= 'Staff desc'	THEN StaffName END DESC ,  
												CASE WHEN @SortExpression= 'AssignmentType'			THEN AssignmentCode END,                                                                      
												CASE WHEN @SortExpression= 'AssignmentType desc'		THEN AssignmentCode END DESC,     
												CASE WHEN @SortExpression= 'AssignmentSubType'		THEN AssignmentSubTypeText END,                                                            
												CASE WHEN @SortExpression= 'AssignmentSubType desc'	THEN AssignmentSubTypeText END DESC , 
												CASE WHEN @SortExpression= 'Description'		THEN AssignmentTypeDescription END,                                                            
												CASE WHEN @SortExpression= 'Description desc'	THEN AssignmentTypeDescription END DESC ,                                                                                                                         
												ClientId) as RowNumber     
							FROM #ResultSet	)
		SELECT TOP (CASE WHEN (@PageNumber = - 1)
						THEN (SELECT ISNULL(TotalRows, 0) FROM Counts)
					ELSE (@PageSize)
					END
				)ClientId,
						ClientName,
						StaffId,
						StaffName,
						AssignmentTypeId,
						AssignmentCode,
						AssignmentSubTypeId,
						AssignmentSubTypeText,
						AssignmentTypeDescription,
						IsSelected,
						IsOrdersAssignedTo,
						ScreenId,
						ScreenType,
						ScreenParameter,
						DocumentStaffAssignPKId
			,TotalCount
			,RowNumber
		INTO #FinalResultSet
		FROM RankResultSet
		WHERE RowNumber > ((@PageNumber - 1) * @PageSize)

		IF (SELECT ISNULL(Count(*), 0)	FROM #FinalResultSet) < 1
		BEGIN
			SELECT 0 AS PageNumber
				,0 AS NumberOfPages
				,0 NumberofRows
		END
		ELSE
		BEGIN
			SELECT TOP 1 @PageNumber AS PageNumber
				,CASE (Totalcount % @PageSize)
					WHEN 0
						THEN ISNULL((Totalcount / @PageSize), 0)
					ELSE ISNULL((Totalcount / @PageSize), 0) + 1
					END AS NumberOfPages
				,ISNULL(Totalcount, 0) AS NumberofRows
			FROM #FinalResultSet
		END

		SELECT ClientId,
						ClientName,
						StaffId,
						StaffName,
						AssignmentTypeId,
						AssignmentCode,
						AssignmentSubTypeId,
						AssignmentSubTypeText,
						AssignmentTypeDescription,
						IsOrdersAssignedTo,
						ScreenId,
						ScreenType,
						ScreenParameter,
						DocumentStaffAssignPKId
		FROM #FinalResultSet
		ORDER BY RowNumber
					
	
      
      END TRY     
    
    BEGIN CATCH     
        DECLARE @Error VARCHAR(8000)     
    
        SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'     
                    + CONVERT(VARCHAR(4000), ERROR_MESSAGE())     
                    + '*****'     
                    + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),     
                    'ssp_ListPageCaseloadReassignment')     
                    + '*****' + CONVERT(VARCHAR, ERROR_LINE())     
                    + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY())     
                    + '*****' + CONVERT(VARCHAR, ERROR_STATE())     
    
        RAISERROR ( @Error,     
                    -- Message text.                                                                                                
                    16,     
                    -- Severity.                                                                                                
                    1     
                   -- State.                                                                                                
                    );     
     END CATCH     
END 
GO