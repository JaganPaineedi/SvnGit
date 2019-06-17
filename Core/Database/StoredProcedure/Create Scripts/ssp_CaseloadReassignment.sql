
/****** Object:  StoredProcedure [dbo].[ssp_CaseloadReassignment]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CaseloadReassignment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CaseloadReassignment]
GO


/****** Object:  UserDefinedTableType [dbo].[CaseloadReassign]    Script Date: 05/30/2017 19:32:59 ******/
IF  EXISTS (SELECT * FROM sys.types st JOIN sys.schemas ss ON st.schema_id = ss.schema_id WHERE st.name = N'CaseloadReassign' AND ss.name = N'dbo')
DROP TYPE [dbo].[CaseloadReassign]
GO


/****** Object:  UserDefinedTableType [dbo].[CaseloadReassign]    Script Date: 05/30/2017 19:32:59 ******/
CREATE TYPE [dbo].[CaseloadReassign] AS TABLE(
	[ClientId] [int] NULL,
	[StaffId] [int] NULL,
	[AssignmentTypeId] [int] NULL,
	[AssignmentSubTypeId] [int] NULL,
	[IsOrdersAssignedTo] nvarchar(10),
	[DocumentStaffAssignPKId] [int] NULL
)
GO


/****** Object:  StoredProcedure [dbo].[ssp_CaseloadReassignment]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
/******************************************************************************                                                
**  File: ssp_CaseloadReassignment                                            
**  Name: ssp_CaseloadReassignment                        
**  Desc: To Get ReAssignment SubTypes                                           
**  Called by:                                                 
**  Parameters:                            
**  Auth:  Ponnin selvan                              
**  Date:  May 30 2017
*******************************************************************************                                                
**  Change History                                          
*******************************************************************************                                          
10 Aug 2017  kavya    1. Differentiate ORDERS with ORDERASSIGNED and ORDERSAUTHOR  #Thresholds - Support: #825.1
16 Jan 2018  Ponnin	   If any customer needs different calculation, then new Stored Procedure is created and the name of the new SP will be updated as a value for systemconfigurationkeys table for the key = 'CaseLoadReAssignStoredProcedure'. Thresholds - Support #1087
26 Mar 2018  Lakshmi   The issue has been fixed. 
					   What: If the newly reassigned author signs the document, their signature is not acknowledged on the document and is						   not captured in the database as well. Why: Harbor – Support #1649

--*******************************************************************************/                                   
CREATE PROCEDURE  [dbo].[ssp_CaseloadReassignment]                                                                   
(                                                                                                                                                           
 -- which accepts one table value parameter.     
-- It should be noted that the parameter is readonly    
@ReassignDataTable As [dbo].[CaseloadReassign] Readonly  ,  
@StaffId int,
@loggedInUserId int = NULL                                                       
)                                                                              
As                                                                          
BEGIN                                                            
   BEGIN TRY  
   
   DECLARE @StaffName Varchar(200)
   DECLARE @StaffLastFirstName Varchar(200)
   DECLARE @UserCode Varchar(30)
   SELECT @UserCode = UserCode,  
   @StaffName =  rtrim(ltrim(s.LastName)) + ', ' + rtrim(s.FirstName) from Staff s where s.StaffId= @StaffId AND isnull(s.RecordDeleted, 'N') = 'N'
   
   DECLARE @loggedInUserName Varchar(30)
   SET @loggedInUserName = (Select Top 1 UserCode from Staff where StaffId= @loggedInUserId AND isnull(RecordDeleted, 'N') = 'N')
   
   Create Table #TempCaseloadReassign
	( RowId Int identity(1,1),  
    [ClientId] [int] NULL,
	[StaffId] [int] NULL,
	[AssignmentTypeId] [int] NULL,
	[AssignmentTypeCode] Varchar(100) NULL,
	[AssignmentSubTypeId] [int] NULL,
	[IsOrdersAssignedTo] nvarchar(10),
	[DocumentStaffAssignPKId] [int] NULL)
  
  
    Create Table #TempUnchangedAssignment
	(ClientName Varchar(200) NULL,
	[Description] Varchar(1000) NULL)
  
  Insert Into #TempCaseloadReassign(  
    [ClientId],
	[StaffId],
	[AssignmentTypeId],
	[AssignmentTypeCode],
	[AssignmentSubTypeId],
	[IsOrdersAssignedTo],
	[DocumentStaffAssignPKId]
	)
	
	SELECT  [ClientId],
	[StaffId],
	[AssignmentTypeId],
	 GC.Code,
	[AssignmentSubTypeId],
	[IsOrdersAssignedTo],
	[DocumentStaffAssignPKId] From @ReassignDataTable RD LEFT JOIN GlobalCodes GC on GC.GlobalCodeId = RD.AssignmentTypeId AND  isnull(GC.RecordDeleted,'N')  ='N'   


--SELECT * from #TempCaseloadReassign


--*************************************************************************	
-- To update Primary Clinician
--*************************************************************************
BEGIN
-- To get the count of assigning Primary Clinicans
DECLARE @TempPrimaryClinicianCount int = 0
DECLARE @CurrentPrimaryClinicianCount int = 0

SET @TempPrimaryClinicianCount = (Select count (*) from #TempCaseloadReassign where AssignmentTypeCode = 'PRIMARYCLINICIAN')
IF(@TempPrimaryClinicianCount > 0)
BEGIN
SET @CurrentPrimaryClinicianCount = (Select count (*) from Clients C
INNER JOIN #TempCaseloadReassign TCR
    ON C.ClientId = TCR.AssignmentSubTypeId AND  isnull(C.RecordDeleted, 'N') = 'N' AND C.PrimaryClinicianId = TCR.StaffId
   WHERE TCR.AssignmentTypeCode = 'PRIMARYCLINICIAN' AND EXISTS (SELECT * FROM Staff S where
						S.StaffId = @StaffId  AND  isnull(S.RecordDeleted, 'N') = 'N' AND (isnull(S.Clinician, 'N') = 'Y' AND  isnull(S.Active, 'N') = 'Y' )
						))


--print @TempPrimaryClinicianCount
--Print @CurrentPrimaryClinicianCount

IF(@TempPrimaryClinicianCount > @CurrentPrimaryClinicianCount)
BEGIN 
INSERT INTO #TempUnchangedAssignment (ClientName,[Description])
 Select ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, ''), 
 'Description - Primary Clinician is no longer selected Clinician or Selected Staff is not an Clinician' +  CHAR(13) +
'Reason – Primary Clinician has been changed from the selected clinician or Selected Staff is not an Clinician' 
FROM Clients C
INNER JOIN #TempCaseloadReassign TCR
    ON C.ClientId = TCR.AssignmentSubTypeId AND  isnull(C.RecordDeleted, 'N') = 'N' 
    WHERE TCR.AssignmentTypeCode = 'PRIMARYCLINICIAN' 
AND (C.PrimaryClinicianId <> TCR.StaffId OR EXISTS (SELECT * FROM Staff S where
						S.StaffId = @StaffId  AND  isnull(S.RecordDeleted, 'N') = 'N' AND (isnull(S.Clinician, 'N') <> 'Y' OR  isnull(S.Active, 'N') <> 'Y' )
						))
END

UPDATE C
SET C.PrimaryClinicianId = @StaffId, C.ModifiedDate = getdate(), C.ModifiedBy = @loggedInUserName
FROM Clients C
INNER JOIN #TempCaseloadReassign TCR
    ON C.ClientId = TCR.AssignmentSubTypeId AND  isnull(C.RecordDeleted, 'N') = 'N' AND C.PrimaryClinicianId = TCR.StaffId
   WHERE TCR.AssignmentTypeCode = 'PRIMARYCLINICIAN'
AND EXISTS (SELECT * FROM Staff S where
						S.StaffId = @StaffId  AND  isnull(S.RecordDeleted, 'N') = 'N' AND (isnull(S.Clinician, 'N') = 'Y' AND  isnull(S.Active, 'N') = 'Y' )
						)
END

END


--*************************************************************************	
-- To update Primary Physician
--*************************************************************************
BEGIN
-- To get the count of assigning Primary Physician
DECLARE @TempPrimaryPhysicianCount int = 0
DECLARE @CurrentPrimaryPhysicianCount int = 0

SET @TempPrimaryPhysicianCount = (Select count (*) from #TempCaseloadReassign where AssignmentTypeCode = 'PRIMARYPHYSICIAN')
IF(@TempPrimaryPhysicianCount > 0)
BEGIN
SET @CurrentPrimaryPhysicianCount = (Select count (*) from Clients C
INNER JOIN #TempCaseloadReassign TCR
    ON C.ClientId = TCR.AssignmentSubTypeId AND  isnull(C.RecordDeleted, 'N') = 'N' AND C.PrimaryPhysicianId = TCR.StaffId
    INNER JOIN Staff S on S.StaffId = TCR.StaffId  AND  isnull(S.RecordDeleted, 'N') = 'N' AND isnull(S.Attending, 'N') <> 'Y' AND S.Active='Y'
WHERE TCR.AssignmentTypeCode = 'PRIMARYPHYSICIAN' AND EXISTS (SELECT * FROM Staff S where
						S.StaffId = @StaffId  AND  isnull(S.RecordDeleted, 'N') = 'N' AND (isnull(S.Attending, 'N') = 'Y' AND  isnull(S.Active, 'N') = 'Y' )
						))


IF(@TempPrimaryPhysicianCount > @CurrentPrimaryPhysicianCount)
BEGIN 
INSERT INTO #TempUnchangedAssignment (ClientName,[Description])
 Select ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, ''), 
 'Description - Primary Physician is no longer selected Physician or Selected Staff is not an Attending Physician' +  CHAR(13) +
'Reason – Primary Physician has been changed from the selected Physician or Selected Staff is not an Attending Physician' 
FROM Clients C
INNER JOIN #TempCaseloadReassign TCR
    ON C.ClientId = TCR.AssignmentSubTypeId AND  isnull(C.RecordDeleted, 'N') = 'N'
WHERE TCR.AssignmentTypeCode = 'PRIMARYPHYSICIAN' 
AND (C.PrimaryPhysicianId <> TCR.StaffId OR EXISTS (SELECT * FROM Staff S where
						S.StaffId = @StaffId  AND  isnull(S.RecordDeleted, 'N') = 'N' AND (isnull(S.Attending, 'N') <> 'Y' OR  isnull(S.Active, 'N') <> 'Y' )
						))
END

UPDATE C
SET C.PrimaryPhysicianId = @StaffId, C.ModifiedDate = getdate(), C.ModifiedBy = @loggedInUserName
FROM Clients C
INNER JOIN #TempCaseloadReassign TCR
    ON C.ClientId = TCR.AssignmentSubTypeId AND  isnull(C.RecordDeleted, 'N') = 'N' AND C.PrimaryPhysicianId = TCR.StaffId
WHERE TCR.AssignmentTypeCode = 'PRIMARYPHYSICIAN'
AND EXISTS (SELECT * FROM Staff S where
						S.StaffId = @StaffId  AND  isnull(S.RecordDeleted, 'N') = 'N' AND (isnull(S.Attending, 'N') = 'Y' AND  isnull(S.Active, 'N') = 'Y' )
						)
END
END


--*************************************************************************	
-- To update Client Flag
--*************************************************************************
BEGIN
-- To get the count of Client Flag
DECLARE @TempClientFlagCount int = 0
DECLARE @ClientFlagActiveCount int = 0
DECLARE @ClientFlagAssignedCount int = 0


SET @TempClientFlagCount = (Select count (*) from #TempCaseloadReassign where AssignmentTypeCode = 'FLAG')
IF(@TempClientFlagCount > 0)
BEGIN

SET @ClientFlagActiveCount = (Select count (*) from ClientNotes CN
INNER JOIN #TempCaseloadReassign TCR
    ON CN.ClientNoteId = TCR.AssignmentSubTypeId AND  isnull(CN.RecordDeleted, 'N') = 'N' AND CN.Active = 'Y'
WHERE TCR.AssignmentTypeCode = 'FLAG')

SET @ClientFlagAssignedCount = (Select count (*) from ClientNotes CN
INNER JOIN #TempCaseloadReassign TCR
    ON CN.ClientNoteId = TCR.AssignmentSubTypeId AND  isnull(CN.RecordDeleted, 'N') = 'N' AND CN.AssignedTo = TCR.StaffId
WHERE TCR.AssignmentTypeCode = 'FLAG')

IF(@TempClientFlagCount > @ClientFlagActiveCount)
BEGIN 
INSERT INTO #TempUnchangedAssignment (ClientName,[Description])
 Select ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, ''), 
 'Description - Flag is no longer active' +  CHAR(13) +
'Reason – Flag was changed from active to inactive' 
FROM ClientNotes CN
INNER JOIN #TempCaseloadReassign TCR
    ON CN.ClientNoteId = TCR.AssignmentSubTypeId AND  isnull(CN.RecordDeleted, 'N') = 'N' AND isnull(CN.Active, 'N') <> 'Y'
    INNER JOIN Clients C ON C.ClientId = CN.ClientId  AND  isnull(C.RecordDeleted, 'N') = 'N'
WHERE TCR.AssignmentTypeCode = 'FLAG' 
END

IF(@TempClientFlagCount > @ClientFlagAssignedCount)
BEGIN 
INSERT INTO #TempUnchangedAssignment (ClientName,[Description])
 Select ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, ''), 
 'Description - Flag is no longer assigned to selected staff' +  CHAR(13) +
'Reason – Flag has been changed from the selected staff' 
FROM ClientNotes CN
INNER JOIN #TempCaseloadReassign TCR
    ON CN.ClientNoteId = TCR.AssignmentSubTypeId AND  isnull(CN.RecordDeleted, 'N') = 'N' AND CN.AssignedTo <> TCR.StaffId
    INNER JOIN Clients C ON C.ClientId = CN.ClientId  AND  isnull(C.RecordDeleted, 'N') = 'N'
WHERE TCR.AssignmentTypeCode = 'FLAG' 
END

-- Update Client notes 
UPDATE CN
SET CN.AssignedTo = @StaffId, CN.ModifiedDate = getdate(), CN.ModifiedBy = @loggedInUserName
FROM ClientNotes CN
INNER JOIN #TempCaseloadReassign TCR
    ON CN.ClientNoteId = TCR.AssignmentSubTypeId AND  isnull(CN.RecordDeleted, 'N') = 'N' AND CN.AssignedTo = TCR.StaffId AND isnull(CN.Active, 'N') = 'Y'
WHERE TCR.AssignmentTypeCode = 'FLAG'
END
END

--*************************************************************************	
-- To update Client Program
--*************************************************************************
BEGIN
-- To get the count of Client Program
DECLARE @TempClientProgramCount int = 0
DECLARE @ClientProgramActiveCount int = 0
DECLARE @ClientProgramAssignedCount int = 0


SET @TempClientProgramCount = (Select count (*) from #TempCaseloadReassign where AssignmentTypeCode = 'PROGRAM')
IF(@TempClientProgramCount > 0)
BEGIN

SET @ClientProgramActiveCount = (Select count (*) from ClientPrograms CP
INNER JOIN #TempCaseloadReassign TCR
    ON CP.ClientProgramId = TCR.AssignmentSubTypeId AND  isnull(CP.RecordDeleted, 'N') = 'N' 
    INNER JOIN Programs P on P.ProgramId= CP.ProgramId AND  isnull(P.RecordDeleted, 'N') = 'N' AND isnull(P.Active, 'N') = 'Y'
WHERE TCR.AssignmentTypeCode = 'PROGRAM')

SET @ClientProgramAssignedCount = (Select count (*) from ClientPrograms CP
INNER JOIN #TempCaseloadReassign TCR
    ON CP.ClientProgramId = TCR.AssignmentSubTypeId AND isnull(CP.RecordDeleted, 'N') = 'N' AND CP.AssignedStaffId = TCR.StaffId
WHERE TCR.AssignmentTypeCode = 'PROGRAM')


IF(@TempClientProgramCount > @ClientProgramActiveCount)
BEGIN 
INSERT INTO #TempUnchangedAssignment (ClientName,[Description])
 Select ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, ''), 
 'Description - Program is no longer active' +  CHAR(13) +
'Reason – Program was changed from active to inactive' 
FROM ClientPrograms CP
INNER JOIN #TempCaseloadReassign TCR
    ON CP.ClientProgramId = TCR.AssignmentSubTypeId AND  isnull(CP.RecordDeleted, 'N') = 'N' 
     INNER JOIN Programs P on P.ProgramId= CP.ProgramId AND  isnull(P.RecordDeleted, 'N') = 'N' AND isnull(P.Active, 'N') <> 'Y'
    INNER JOIN Clients C ON C.ClientId = CP.ClientId  AND  isnull(C.RecordDeleted, 'N') = 'N'
WHERE TCR.AssignmentTypeCode = 'PROGRAM' 
END

IF(@TempClientProgramCount > @ClientProgramAssignedCount)
BEGIN 
INSERT INTO #TempUnchangedAssignment (ClientName,[Description])
 Select ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, ''), 
 'Description - Program is no longer assigned to selected staff' +  CHAR(13) +
'Reason – Program has been changed from the selected staff' 
FROM ClientPrograms CP
INNER JOIN #TempCaseloadReassign TCR
    ON CP.ClientProgramId = TCR.AssignmentSubTypeId AND  isnull(CP.RecordDeleted, 'N') = 'N' AND CP.AssignedStaffId <> TCR.StaffId
    INNER JOIN Clients C ON C.ClientId = CP.ClientId  AND  isnull(C.RecordDeleted, 'N') = 'N'
WHERE TCR.AssignmentTypeCode = 'PROGRAM' 
END

-- Update Client Programs 
UPDATE CP
SET CP.AssignedStaffId = @StaffId, CP.ModifiedDate = getdate(), CP.ModifiedBy = @loggedInUserName
FROM ClientPrograms CP
INNER JOIN #TempCaseloadReassign TCR
    ON CP.ClientProgramId = TCR.AssignmentSubTypeId AND  isnull(CP.RecordDeleted, 'N') = 'N' AND CP.AssignedStaffId = TCR.StaffId 
    INNER JOIN Programs P on P.ProgramId= CP.ProgramId AND  isnull(P.RecordDeleted, 'N') = 'N' AND isnull(P.Active, 'N') = 'Y'
WHERE TCR.AssignmentTypeCode = 'PROGRAM'
END
END

--*************************************************************************	
-- To update Documents Author
--*************************************************************************

BEGIN
-- To get the count of assigned Documents
DECLARE @TempDocumentCount int = 0
DECLARE @CurrentDocumentCount int = 0

SET @TempDocumentCount = (Select count (*) from #TempCaseloadReassign where AssignmentTypeCode in ('DOCUMENTS',
'DOCUMENTSINPROGRESS',
'DOCUMENTSTODO',
'DOCUMENTSTOSIGN',
'DOCUMENTSTOCOSIGN',
'DOCUMENTSTOACKNOWLEDGE',
'DOCUMENTSTOBEREVIEWED'))
IF(@TempDocumentCount > 0)
BEGIN
SET @CurrentDocumentCount = (Select count (*) from Documents D
INNER JOIN #TempCaseloadReassign TCR
    ON D.DocumentId = TCR.AssignmentSubTypeId AND  isnull(D.RecordDeleted, 'N') = 'N' AND D.Status in (20, 21)
WHERE TCR.AssignmentTypeCode = 'DOCUMENTS')


IF(@TempDocumentCount > @CurrentDocumentCount)
BEGIN 
INSERT INTO #TempUnchangedAssignment (ClientName,[Description])
 Select ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, ''), 
 'Description - Document status has changed to signed' +  CHAR(13) +
'Reason – Document status has changed to signed' 
FROM Documents D
INNER JOIN #TempCaseloadReassign TCR
    ON D.DocumentId = TCR.AssignmentSubTypeId AND  isnull(D.RecordDeleted, 'N') = 'N' AND D.Status = 22
    INNER JOIN Clients C ON C.ClientId = TCR.ClientId  AND  isnull(C.RecordDeleted, 'N') = 'N'
WHERE TCR.AssignmentTypeCode = 'DOCUMENTS' 
END


UPDATE D
SET D.AuthorId = @StaffId, D.ModifiedDate = getdate(), D.ModifiedBy = @loggedInUserName
FROM Documents D
INNER JOIN #TempCaseloadReassign TCR
    ON D.DocumentId = TCR.AssignmentSubTypeId AND  isnull(D.RecordDeleted, 'N') = 'N'
WHERE TCR.AssignmentTypeCode in ('DOCUMENTSINPROGRESS',
'DOCUMENTSTODO')

UPDATE D
SET D.StaffId = @StaffId, D.ModifiedDate = getdate(), D.ModifiedBy = @loggedInUserName
FROM DocumentSignatures D
INNER JOIN #TempCaseloadReassign TCR
    ON D.DocumentId = TCR.AssignmentSubTypeId AND D.StaffId is not null and isnull(D.ISClient, 'N') = 'N'  
    AND isnull(D.RecordDeleted, 'N') = 'N' WHERE TCR.AssignmentTypeCode in ('DOCUMENTSINPROGRESS','DOCUMENTSTODO')

UPDATE D
SET D.ReviewerId = @StaffId, D.ModifiedDate = getdate(), D.ModifiedBy = @loggedInUserName
FROM Documents D
INNER JOIN #TempCaseloadReassign TCR
    ON D.DocumentId = TCR.AssignmentSubTypeId AND  isnull(D.RecordDeleted, 'N') = 'N'
WHERE TCR.AssignmentTypeCode in ('DOCUMENTSTOBEREVIEWED')

UPDATE DAK
SET DAK.AcknowledgedByStaffId  = @StaffId, DAK.ModifiedDate = getdate(), DAK.ModifiedBy = @loggedInUserName
FROM DocumentsAcknowledgements DAK
INNER JOIN #TempCaseloadReassign TCR
    ON DAK.DocumentsAcknowledgementId = TCR.DocumentStaffAssignPKId AND  isnull(DAK.RecordDeleted, 'N') = 'N' 
WHERE TCR.AssignmentTypeCode in ('DOCUMENTSTOACKNOWLEDGE')

UPDATE DS
SET DS.StaffId  = @StaffId, DS.ModifiedDate = getdate(), DS.ModifiedBy = @loggedInUserName
FROM DocumentSignatures DS
INNER JOIN #TempCaseloadReassign TCR
    ON DS.SignatureId = TCR.DocumentStaffAssignPKId AND  isnull(DS.RecordDeleted, 'N') = 'N' 
WHERE TCR.AssignmentTypeCode in ('DOCUMENTSTOSIGN','DOCUMENTSTOCOSIGN')


END
END

--*************************************************************************	
-- To update Events Author
--*************************************************************************

BEGIN
-- To get the count of assigned Documents
DECLARE @TempEventCount int = 0
DECLARE @CurrentEventCount int = 0

SET @TempEventCount = (Select count (*) from #TempCaseloadReassign where AssignmentTypeCode = 'EVENTS')
IF(@TempEventCount > 0)
BEGIN
SET @CurrentEventCount = (Select count (*) from Documents D
INNER JOIN #TempCaseloadReassign TCR
    ON D.DocumentId = TCR.AssignmentSubTypeId AND  isnull(D.RecordDeleted, 'N') = 'N' AND D.Status in (20, 21)
WHERE TCR.AssignmentTypeCode = 'EVENTS')


IF(@TempEventCount > @CurrentEventCount)
BEGIN 
INSERT INTO #TempUnchangedAssignment (ClientName,[Description])
 Select ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, ''), 
 'Description - Event status has changed to signed' + CHAR(13) +
'Reason – Event status has changed to signed' 
FROM Documents D
INNER JOIN #TempCaseloadReassign TCR
    ON D.DocumentId = TCR.AssignmentSubTypeId AND  isnull(D.RecordDeleted, 'N') = 'N' AND D.Status = 22
    INNER JOIN Clients C ON C.ClientId = TCR.ClientId  AND  isnull(C.RecordDeleted, 'N') = 'N'
WHERE TCR.AssignmentTypeCode = 'EVENTS' 
END


UPDATE D
SET D.AuthorId = @StaffId, D.ModifiedDate = getdate(), D.ModifiedBy = @loggedInUserName
FROM Documents D
INNER JOIN #TempCaseloadReassign TCR
    ON D.DocumentId = TCR.AssignmentSubTypeId AND  isnull(D.RecordDeleted, 'N') = 'N' AND D.Status in (20, 21)
WHERE TCR.AssignmentTypeCode = 'EVENTS'
END
END

--*************************************************************************	
-- To update Client Orders
--*************************************************************************
--Differentiate ORDERS with ORDERASSIGNED and ORDERSAUTHOR #Thresholds - Support: #825.1 by Kavya
BEGIN
-- To get the count of Client Orders
DECLARE @TempClientOrderCount int = 0
DECLARE @TempClientOrderAssignedCount int = 0
DECLARE @TempClientOrderAuthorCount int = 0



SET @TempClientOrderCount = (Select count (*) from #TempCaseloadReassign where AssignmentTypeCode in ('ORDERSASSIGNED','ORDERSAUTHOR'))
SET @TempClientOrderAssignedCount = (Select count (*) from #TempCaseloadReassign where AssignmentTypeCode = 'ORDERSASSIGNED' AND IsOrdersAssignedTo = 'Y')
SET @TempClientOrderAuthorCount = (Select count (*) from #TempCaseloadReassign where AssignmentTypeCode = 'ORDERSAUTHOR' AND  isnull(IsOrdersAssignedTo, 'N') <> 'Y')

IF(@TempClientOrderCount > 0)
BEGIN

DECLARE @ClientOrderStatusCount int = 0
DECLARE @ClientOrderAuthorCount int = 0
DECLARE @ClientOrderAssignedCount int = 0


SET @ClientOrderStatusCount = (Select count (*) from Documents D
INNER JOIN #TempCaseloadReassign TCR
    ON D.DocumentId = TCR.AssignmentSubTypeId AND  isnull(D.RecordDeleted, 'N') = 'N' AND D.Status in (20, 21)
WHERE TCR.AssignmentTypeCode in ('ORDERSASSIGNED','ORDERSAUTHOR'))

SET @ClientOrderAuthorCount = (Select count (*) from Documents D
INNER JOIN #TempCaseloadReassign TCR
    ON D.DocumentId = TCR.AssignmentSubTypeId AND  isnull(D.RecordDeleted, 'N') = 'N' AND D.AuthorId = TCR.StaffId
WHERE TCR.AssignmentTypeCode = 'ORDERSAUTHOR' AND  isnull(TCR.IsOrdersAssignedTo, 'N') <> 'Y')

SET @ClientOrderAssignedCount = (Select count (*) from ClientOrders CO
INNER JOIN #TempCaseloadReassign TCR
    ON CO.ClientOrderId = TCR.AssignmentSubTypeId AND  isnull(CO.RecordDeleted, 'N') = 'N' AND CO.AssignedTo = TCR.StaffId
WHERE TCR.AssignmentTypeCode = 'ORDERSASSIGNED' AND TCR.IsOrdersAssignedTo = 'Y')

IF(@TempClientOrderCount > @ClientOrderStatusCount)
BEGIN 
INSERT INTO #TempUnchangedAssignment (ClientName,[Description])
 Select ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, ''), 
 'Description - Order status has changed to signed' + CHAR(13) +
'Reason – Order status has changed to signed' 
FROM Documents D
INNER JOIN #TempCaseloadReassign TCR
    ON D.DocumentId = TCR.AssignmentSubTypeId AND  isnull(D.RecordDeleted, 'N') = 'N' AND D.Status = 22
    INNER JOIN Clients C ON C.ClientId = TCR.ClientId  AND  isnull(C.RecordDeleted, 'N') = 'N'
WHERE TCR.AssignmentTypeCode in ('ORDERSASSIGNED','ORDERSAUTHOR')
END

IF(@TempClientOrderAuthorCount > @ClientOrderAuthorCount)
BEGIN 
INSERT INTO #TempUnchangedAssignment (ClientName,[Description])
 Select ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, ''), 
 'Description - Order is no longer assigned to selected staff(Author)' + CHAR(13) +
'Reason – Order has been changed from selected staff' 
FROM Documents D
INNER JOIN #TempCaseloadReassign TCR
    ON D.DocumentId = TCR.AssignmentSubTypeId AND  isnull(D.RecordDeleted, 'N') = 'N' AND D.AuthorId <> TCR.StaffId
    INNER JOIN Clients C ON C.ClientId = TCR.ClientId  AND  isnull(C.RecordDeleted, 'N') = 'N'
WHERE TCR.AssignmentTypeCode = 'ORDERSAUTHOR' AND  isnull(TCR.IsOrdersAssignedTo, 'N') <> 'Y'
END


IF(@TempClientOrderAssignedCount > @ClientOrderAssignedCount)
BEGIN 
INSERT INTO #TempUnchangedAssignment (ClientName,[Description])
 Select ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, ''), 
 'Description - Order is no longer assigned to selected staff(Assigned)' +  CHAR(13) +
'Reason – Order has been changed from selected staff' 
FROM ClientOrders CO
INNER JOIN #TempCaseloadReassign TCR
    ON  CO.ClientOrderId = TCR.AssignmentSubTypeId AND  isnull(CO.RecordDeleted, 'N') = 'N' AND CO.AssignedTo <> TCR.StaffId
    INNER JOIN Clients C ON C.ClientId = CO.ClientId  AND  isnull(C.RecordDeleted, 'N') = 'N'
WHERE TCR.AssignmentTypeCode = 'ORDERSASSIGNED' AND TCR.IsOrdersAssignedTo = 'Y'
END

-- Update Orders Assigned To (staff)
UPDATE CO
SET CO.AssignedTo = @StaffId, CO.ModifiedDate = getdate(), CO.ModifiedBy = @loggedInUserName
FROM ClientOrders CO
INNER JOIN #TempCaseloadReassign TCR
    ON CO.ClientOrderId = TCR.AssignmentSubTypeId AND  isnull(CO.RecordDeleted, 'N') = 'N' AND CO.AssignedTo = TCR.StaffId 
INNER JOIN Documents D on D.ClientId = CO.ClientId AND  isnull(D.RecordDeleted, 'N') = 'N' AND D.Status in (20, 21)
WHERE TCR.AssignmentTypeCode = 'ORDERSASSIGNED'  AND TCR.IsOrdersAssignedTo = 'Y'

-- Update Orders Author (staff)
UPDATE D
SET D.AuthorId = @StaffId, D.ModifiedDate = getdate(), D.ModifiedBy = @loggedInUserName
FROM Documents D
INNER JOIN #TempCaseloadReassign TCR
    ON D.DocumentId = TCR.AssignmentSubTypeId AND  isnull(D.RecordDeleted, 'N') = 'N' AND D.AuthorId = TCR.StaffId AND D.Status in (20, 21)
WHERE TCR.AssignmentTypeCode = 'ORDERSAUTHOR'  AND  isnull(TCR.IsOrdersAssignedTo, 'N') <> 'Y'
END
END


--*************************************************************************	
-- To update Client Inquiries
--*************************************************************************
  DECLARE @SQLQuery AS NVARCHAR(max)
   
  BEGIN
 IF ((COL_LENGTH('CustomInquiries','ClientId') IS NOT NULL AND COL_LENGTH('CustomInquiries','AssignedToStaffId') IS NOT NULL AND COL_LENGTH('CustomInquiries','InquiryId') IS NOT NULL AND COL_LENGTH('CustomInquiries','InquiryStartDateTime') IS NOT NULL AND COL_LENGTH('CustomInquiries','InquiryStatus') IS NOT NULL ))
 BEGIN

  SET @SQLQuery = N'DECLARE @TempClientInquiryCount int = 0
DECLARE @ClientInquiryStatusCount int = 0
DECLARE @ClientInquiryAssignedCount int = 0


SET @TempClientInquiryCount = (Select count (*) from #TempCaseloadReassign where AssignmentTypeCode = ''INQUIRY'')
IF(@TempClientInquiryCount > 0)
BEGIN
SET @ClientInquiryStatusCount = (Select count (*) from CustomInquiries CI 
INNER JOIN #TempCaseloadReassign TCR
    ON CI.InquiryId = TCR.AssignmentSubTypeId AND  isnull(CI.RecordDeleted, ''N'') = ''N''  AND EXISTS (
						SELECT *
						FROM dbo.ssf_RecodeValuesCurrent(''REASSIGNMENTINQUIRYSTATUS'') AS RC
						WHERE RC.IntegerCodeId = CI.InquiryStatus AND RC.CodeName <> ''COMPLETED''	
						)
WHERE TCR.AssignmentTypeCode = ''INQUIRY'')

SET @ClientInquiryAssignedCount = (Select count (*) from CustomInquiries CI 
INNER JOIN #TempCaseloadReassign TCR
    ON CI.InquiryId = TCR.AssignmentSubTypeId AND isnull(CI.RecordDeleted, ''N'') = ''N'' AND CI.AssignedToStaffId = TCR.StaffId
WHERE TCR.AssignmentTypeCode = ''INQUIRY'')

IF(@TempClientInquiryCount > @ClientInquiryStatusCount)
BEGIN 
INSERT INTO #TempUnchangedAssignment (ClientName,[Description])
 Select ISNULL(C.LastName, '''') + '', '' + ISNULL(C.FirstName, ''''), 
 ''Description - Inquiry status has changed to completed'' +  CHAR(13) +
''Reason – Inquiry status has changed to completed'' 
FROM CustomInquiries CI
INNER JOIN #TempCaseloadReassign TCR
    ON CI.InquiryId  = TCR.AssignmentSubTypeId AND  isnull(CI.RecordDeleted, ''N'') = ''N'' 
     AND EXISTS (SELECT *
						FROM dbo.ssf_RecodeValuesCurrent(''REASSIGNMENTINQUIRYSTATUS'') AS RC
						WHERE RC.IntegerCodeId = CI.InquiryStatus AND RC.CodeName = ''COMPLETED''	
						)
    INNER JOIN Clients C ON C.ClientId = CI.ClientId  AND  isnull(C.RecordDeleted, ''N'') = ''N''
WHERE TCR.AssignmentTypeCode = ''INQUIRY'' 
END

IF(@TempClientInquiryCount > @ClientInquiryAssignedCount)
BEGIN 
INSERT INTO #TempUnchangedAssignment (ClientName,[Description])
 Select ISNULL(C.LastName, '''') + '', '' + ISNULL(C.FirstName, ''''), 
 ''Description - Inquiry is no longer assigned to selected staff'' +  CHAR(13) +
''Reason – Inquiry has been changed from selected staff'' 
FROM CustomInquiries CI 
INNER JOIN #TempCaseloadReassign TCR
    ON CI.InquiryId = TCR.AssignmentSubTypeId AND  isnull(CI.RecordDeleted, ''N'') = ''N'' AND CI.AssignedToStaffId <> TCR.StaffId
    INNER JOIN Clients C ON C.ClientId = CI.ClientId  AND  isnull(C.RecordDeleted, ''N'') = ''N''
WHERE TCR.AssignmentTypeCode = ''INQUIRY'' 
END

UPDATE CI
SET CI.AssignedToStaffId =  '''+ CAST(@StaffId AS VARCHAR)+''', CI.ModifiedDate = getdate(), CI.ModifiedBy =   '''+ CAST(@loggedInUserName AS VARCHAR)+''' 
FROM CustomInquiries CI
INNER JOIN #TempCaseloadReassign TCR
    ON CI.InquiryId = TCR.AssignmentSubTypeId AND  isnull(CI.RecordDeleted, ''N'') = ''N'' AND CI.AssignedToStaffId = TCR.StaffId 
WHERE TCR.AssignmentTypeCode = ''INQUIRY''
 AND EXISTS (
						SELECT *
						FROM dbo.ssf_RecodeValuesCurrent(''REASSIGNMENTINQUIRYSTATUS'') AS RC
						WHERE RC.IntegerCodeId = CI.InquiryStatus AND RC.CodeName = ''INPROGRESS''	
						)
END'
exec (@SQLQuery)
END

END

--*************************************************************************	
-- To update Financial Assignment
--*************************************************************************
BEGIN
-- To get the count of Financial Assignment
DECLARE @TempFinancialAssignmentCount int = 0
DECLARE @FinancialAssignmentActiveCount int = 0
DECLARE @FinancialAssignmentAssignedCount int = 0


SET @TempFinancialAssignmentCount = (Select count (*) from #TempCaseloadReassign where AssignmentTypeCode = 'FINANCIALASSIGNMENTS')
IF(@TempFinancialAssignmentCount > 0)
BEGIN

SET @FinancialAssignmentActiveCount = (Select count (*) from FinancialAssignments FA
INNER JOIN #TempCaseloadReassign TCR
    ON FA.FinancialAssignmentId = TCR.AssignmentSubTypeId AND  isnull(FA.RecordDeleted, 'N') = 'N'  AND  isnull(FA.Active, 'N') = 'Y'
WHERE TCR.AssignmentTypeCode = 'FINANCIALASSIGNMENTS')

SET @FinancialAssignmentAssignedCount = (Select count (*) from FinancialAssignments FA
INNER JOIN #TempCaseloadReassign TCR
    ON FA.FinancialAssignmentId = TCR.AssignmentSubTypeId AND isnull(FA.RecordDeleted, 'N') = 'N' --AND CP.AssignedStaffId = TCR.StaffId
    INNER JOIN Staff S on S.FinancialAssignmentId = FA.FinancialAssignmentId AND S.StaffId = TCR.StaffId  AND isnull(S.RecordDeleted, 'N') = 'N'
WHERE TCR.AssignmentTypeCode = 'FINANCIALASSIGNMENTS')

IF(@TempFinancialAssignmentCount > @FinancialAssignmentActiveCount)
BEGIN 
INSERT INTO #TempUnchangedAssignment (ClientName,[Description])
 Select '', 
 'Description - Financial Assignment is no longer active' +  CHAR(13) +
'Reason – Financial Assignment was changed from active to inactive' 
FROM FinancialAssignments FA
INNER JOIN #TempCaseloadReassign TCR
    ON FA.FinancialAssignmentId = TCR.AssignmentSubTypeId AND  isnull(FA.RecordDeleted, 'N') = 'N' AND isnull(FA.Active, 'N') <> 'Y'
    --INNER JOIN Clients C ON C.ClientId = CN.ClientId  AND  isnull(C.RecordDeleted, 'N') = 'N'
WHERE TCR.AssignmentTypeCode = 'FINANCIALASSIGNMENTS' 
END

IF(@TempFinancialAssignmentCount > @FinancialAssignmentAssignedCount)
BEGIN 
INSERT INTO #TempUnchangedAssignment (ClientName,[Description])
 Select '', 
 'Description - Financial Assignment is no longer assigned to selected staff' +  CHAR(13) +
'Reason – Financial Assignment has been changed from the selected staff' 
FROM FinancialAssignments FA
INNER JOIN #TempCaseloadReassign TCR
    ON FA.FinancialAssignmentId = TCR.AssignmentSubTypeId AND  isnull(FA.RecordDeleted, 'N') = 'N' -- AND CP.AssignedStaffId <> TCR.StaffId
     INNER JOIN Staff S on S.FinancialAssignmentId = FA.FinancialAssignmentId AND S.StaffId <> TCR.StaffId  AND isnull(S.RecordDeleted, 'N') = 'N'
   -- INNER JOIN Clients C ON C.ClientId = CN.ClientId  AND  isnull(C.RecordDeleted, 'N') = 'N'
WHERE TCR.AssignmentTypeCode = 'FINANCIALASSIGNMENTS' 
END

-- Update Financial Assignments in staff table
UPDATE S
SET S.FinancialAssignmentId = (Select Top 1 AssignmentSubTypeId from #TempCaseloadReassign where AssignmentTypeCode = 'FINANCIALASSIGNMENTS'), S.ModifiedDate = getdate(), S.ModifiedBy = @loggedInUserName
FROM Staff S
WHERE S.StaffId = @StaffId AND  isnull(S.RecordDeleted, 'N') = 'N' 
AND Exists (Select 1 from #TempCaseloadReassign TCR INNER JOIN FinancialAssignments FA ON FA.FinancialAssignmentId = TCR.AssignmentSubTypeId AND  isnull(FA.RecordDeleted, 'N') = 'N'
 INNER JOIN Staff S on S.FinancialAssignmentId = FA.FinancialAssignmentId AND S.StaffId = TCR.StaffId  AND isnull(S.RecordDeleted, 'N') = 'N'
 WHERE TCR.AssignmentTypeCode = 'FINANCIALASSIGNMENTS' AND  isnull(FA.Active, 'N') = 'Y')


UPDATE S
SET S.FinancialAssignmentId = NULL, S.ModifiedDate = getdate(), S.ModifiedBy = @loggedInUserName
FROM Staff S
WHERE S.StaffId = (Select Top 1 StaffId from #TempCaseloadReassign where AssignmentTypeCode = 'FINANCIALASSIGNMENTS') AND  isnull(S.RecordDeleted, 'N') = 'N' 
AND Exists (Select 1 from #TempCaseloadReassign TCR INNER JOIN FinancialAssignments FA ON FA.FinancialAssignmentId = TCR.AssignmentSubTypeId AND  isnull(FA.RecordDeleted, 'N') = 'N'
 INNER JOIN Staff S1 on S1.FinancialAssignmentId = FA.FinancialAssignmentId AND S1.StaffId = TCR.StaffId  AND isnull(S1.RecordDeleted, 'N') = 'N'
 WHERE TCR.AssignmentTypeCode = 'FINANCIALASSIGNMENTS' AND  isnull(FA.Active, 'N') = 'Y')

END
END

--*************************************************************************	
-- To update CONTACT NOTES
--*************************************************************************
BEGIN
-- To get the count of CONTACT NOTES
DECLARE @TempContactNoteCount int = 0
DECLARE @ContactNoteStatusCount int = 0
DECLARE @ContactNoteAssignedCount int = 0


SET @TempContactNoteCount = (Select count (*) from #TempCaseloadReassign where AssignmentTypeCode = 'CONTACTNOTES')
IF(@TempContactNoteCount > 0)
BEGIN
SET @ContactNoteStatusCount = (Select count (*) from ClientContactNotes CCN 
INNER JOIN #TempCaseloadReassign TCR
    ON CCN.ClientContactNoteId = TCR.AssignmentSubTypeId AND  isnull(CCN.RecordDeleted, 'N') = 'N'  AND EXISTS (
						SELECT *
						FROM dbo.ssf_RecodeValuesCurrent('REASSIGNMENTCONTACTNOTESTATUS') AS RC
						WHERE RC.IntegerCodeId = CCN.ContactStatus AND RC.CodeName <> 'COMPLETED'	
						)
WHERE TCR.AssignmentTypeCode = 'CONTACTNOTES')

SET @ContactNoteAssignedCount = (Select count (*) from ClientContactNotes CCN 
INNER JOIN #TempCaseloadReassign TCR
    ON CCN.ClientContactNoteId = TCR.AssignmentSubTypeId AND isnull(CCN.RecordDeleted, 'N') = 'N' AND CCN.AssignedTo = TCR.StaffId
WHERE TCR.AssignmentTypeCode = 'CONTACTNOTES')

IF(@TempContactNoteCount > @ContactNoteStatusCount)
BEGIN 
INSERT INTO #TempUnchangedAssignment (ClientName,[Description])
 Select ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, ''), 
 'Description - Contact Note status has changed to completed' +  CHAR(13) +
'Reason – Contact Note status has changed to completed' 
FROM ClientContactNotes CCN 
INNER JOIN #TempCaseloadReassign TCR
    ON CCN.ClientContactNoteId = TCR.AssignmentSubTypeId AND  isnull(CCN.RecordDeleted, 'N') = 'N' 
     AND EXISTS (SELECT *
						FROM dbo.ssf_RecodeValuesCurrent('REASSIGNMENTCONTACTNOTESTATUS') AS RC
						WHERE RC.IntegerCodeId = CCN.ContactStatus AND RC.CodeName = 'COMPLETED'	
						)
    INNER JOIN Clients C ON C.ClientId = CCN.ClientId  AND  isnull(C.RecordDeleted, 'N') = 'N'
WHERE TCR.AssignmentTypeCode = 'CONTACTNOTES' 
END

IF(@TempContactNoteCount > @ContactNoteAssignedCount)
BEGIN 
INSERT INTO #TempUnchangedAssignment (ClientName,[Description])
 Select ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, ''), 
 'Description - Contact Note is no longer assigned to selected staff' +  CHAR(13) +
'Reason – Contact Note has been changed from selected staff' 
FROM ClientContactNotes CCN 
INNER JOIN #TempCaseloadReassign TCR
    ON CCN.ClientContactNoteId = TCR.AssignmentSubTypeId AND  isnull(CCN.RecordDeleted, 'N') = 'N' AND CCN.AssignedTo <> TCR.StaffId
    INNER JOIN Clients C ON C.ClientId = CCN.ClientId  AND  isnull(C.RecordDeleted, 'N') = 'N'
WHERE TCR.AssignmentTypeCode = 'CONTACTNOTES' 
END

-- Update CONTACT TNOTES
UPDATE CCN
SET CCN.AssignedTo = @StaffId, CCN.ModifiedDate = getdate(), CCN.ModifiedBy = @loggedInUserName
FROM ClientContactNotes CCN 
INNER JOIN #TempCaseloadReassign TCR
    ON CCN.ClientContactNoteId = TCR.AssignmentSubTypeId AND  isnull(CCN.RecordDeleted, 'N') = 'N' AND CCN.AssignedTo = TCR.StaffId 
     AND EXISTS (
						SELECT *
						FROM dbo.ssf_RecodeValuesCurrent('REASSIGNMENTCONTACTNOTESTATUS') AS RC
						WHERE RC.IntegerCodeId = CCN.ContactStatus AND RC.CodeName <> 'COMPLETED'	
						)
WHERE TCR.AssignmentTypeCode = 'CONTACTNOTES'
END
END


--*************************************************************************	
-- To update DISCLOSURES
--*************************************************************************

BEGIN
-- To get the count of DISCLOSURES
DECLARE @TempDisclosuresCount int = 0
DECLARE @DisclosureStatusCount int = 0
DECLARE @DisclosureAssignedCount int = 0


SET @TempDisclosuresCount = (Select count (*) from #TempCaseloadReassign where AssignmentTypeCode = 'DISCLOSURES')
IF(@TempDisclosuresCount > 0)
BEGIN

SET @DisclosureStatusCount = (Select count (*) from ClientDisclosures CD
INNER JOIN #TempCaseloadReassign TCR
    ON CD.ClientDisclosureId = TCR.AssignmentSubTypeId AND  isnull(CD.RecordDeleted, 'N') = 'N' 
     AND EXISTS (
						SELECT *
						FROM dbo.ssf_RecodeValuesCurrent('REASSIGNMENTDISCLOSURESTATUS') AS RC
						WHERE RC.IntegerCodeId = CD.DisclosureStatus AND RC.CodeName <> 'COMPLETED'	
						)
WHERE TCR.AssignmentTypeCode = 'DISCLOSURES')

SET @DisclosureAssignedCount = (Select count (*) from ClientDisclosures CD
INNER JOIN #TempCaseloadReassign TCR
    ON CD.ClientDisclosureId  = TCR.AssignmentSubTypeId AND isnull(CD.RecordDeleted, 'N') = 'N' AND CD.AssignedToStaffId = TCR.StaffId
WHERE TCR.AssignmentTypeCode = 'DISCLOSURES')

IF(@TempDisclosuresCount > @DisclosureStatusCount)
BEGIN 
INSERT INTO #TempUnchangedAssignment (ClientName,[Description])
 Select ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, ''), 
 'Description - Disclosure status has changed to completed' +  CHAR(13) +
'Reason – Disclosure status has changed to completed' 
FROM ClientDisclosures CD
INNER JOIN #TempCaseloadReassign TCR
    ON CD.ClientDisclosureId = TCR.AssignmentSubTypeId AND  isnull(CD.RecordDeleted, 'N') = 'N'
     AND EXISTS (
						SELECT *
						FROM dbo.ssf_RecodeValuesCurrent('REASSIGNMENTDISCLOSURESTATUS') AS RC
						WHERE RC.IntegerCodeId = CD.DisclosureStatus AND RC.CodeName = 'COMPLETED'	
						)
    INNER JOIN Clients C ON C.ClientId = CD.ClientId  AND  isnull(C.RecordDeleted, 'N') = 'N'
WHERE TCR.AssignmentTypeCode = 'DISCLOSURES' 
END

IF(@TempDisclosuresCount > @DisclosureAssignedCount)
BEGIN 
INSERT INTO #TempUnchangedAssignment (ClientName,[Description])
 Select ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, ''), 
 'Description - Disclosure is no longer assigned to selected staff' +  CHAR(13) +
'Reason – Disclosure has been changed from selected staff' 
FROM ClientDisclosures CD
INNER JOIN #TempCaseloadReassign TCR
    ON CD.ClientDisclosureId = TCR.AssignmentSubTypeId AND  isnull(CD.RecordDeleted, 'N') = 'N' AND CD.AssignedToStaffId <> TCR.StaffId
    INNER JOIN Clients C ON C.ClientId = CD.ClientId  AND  isnull(C.RecordDeleted, 'N') = 'N'
WHERE TCR.AssignmentTypeCode = 'DISCLOSURES' 
END

-- Update DISCLOSURES
UPDATE CD
SET CD.AssignedToStaffId = @StaffId, CD.ModifiedDate = getdate(), CD.ModifiedBy = @loggedInUserName
FROM ClientDisclosures CD
INNER JOIN #TempCaseloadReassign TCR
    ON CD.ClientDisclosureId = TCR.AssignmentSubTypeId AND  isnull(CD.RecordDeleted, 'N') = 'N' AND CD.AssignedToStaffId = TCR.StaffId 
     AND EXISTS (
						SELECT *
						FROM dbo.ssf_RecodeValuesCurrent('REASSIGNMENTDISCLOSURESTATUS') AS RC
						WHERE RC.IntegerCodeId = CD.DisclosureStatus AND RC.CodeName <> 'COMPLETED'	
						)
WHERE TCR.AssignmentTypeCode = 'DISCLOSURES'
END
END


--*************************************************************************	
-- To update Grievances
--*************************************************************************
BEGIN
-- To get the count of Grievances
DECLARE @TempGrievancesCount int = 0
DECLARE @GrievancesAssignedCount int = 0


SET @TempGrievancesCount = (Select count (*) from #TempCaseloadReassign where AssignmentTypeCode = 'GRIEVANCES/APPEALS')
IF(@TempGrievancesCount > 0)
BEGIN
SET @GrievancesAssignedCount = (Select count (*) from Grievances G
INNER JOIN #TempCaseloadReassign TCR
    ON G.GrievanceId  = TCR.AssignmentSubTypeId AND isnull(G.RecordDeleted, 'N') = 'N' AND G.GrievanceAboutStaffId = TCR.StaffId
WHERE TCR.AssignmentTypeCode = 'GRIEVANCES/APPEALS')


IF(@TempGrievancesCount > @GrievancesAssignedCount)
BEGIN 
INSERT INTO #TempUnchangedAssignment (ClientName,[Description])
 Select ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, ''), 
 'Description - Grievance/Appeals is no longer assigned to selected staff' +  CHAR(13) +
'Reason – Grievance/Appeals has been changed from selected staff' 
FROM Grievances G
INNER JOIN #TempCaseloadReassign TCR
    ON G.GrievanceId = TCR.AssignmentSubTypeId AND  isnull(G.RecordDeleted, 'N') = 'N' AND G.GrievanceAboutStaffId <> TCR.StaffId
    INNER JOIN Clients C ON C.ClientId = G.ClientId  AND  isnull(C.RecordDeleted, 'N') = 'N'
WHERE TCR.AssignmentTypeCode = 'GRIEVANCES/APPEALS' 
END

-- Update Grievances
UPDATE G
SET G.GrievanceAboutStaffId = @StaffId, G.GrievanceAboutName = @StaffName, G.ModifiedDate = getdate(), G.ModifiedBy = @loggedInUserName
FROM Grievances G
INNER JOIN #TempCaseloadReassign TCR
    ON G.GrievanceId = TCR.AssignmentSubTypeId AND  isnull(G.RecordDeleted, 'N') = 'N' AND G.GrievanceAboutStaffId = TCR.StaffId
WHERE TCR.AssignmentTypeCode = 'GRIEVANCES/APPEALS'
END
END

--*************************************************************************	
-- To update Peer Record Reviews
--*************************************************************************
BEGIN
-- To get the count of Peer Record Reviews
DECLARE @TempPeerRecordReviewCount int = 0
DECLARE @PeerRecordReviewAssignedCount int = 0
DECLARE @PeerRecordReviewActiveCount int = 0


SET @TempPeerRecordReviewCount = (Select count (*) from #TempCaseloadReassign where AssignmentTypeCode = 'PEERRECORDREVIEWS')
IF(@TempPeerRecordReviewCount > 0)
BEGIN

SET @PeerRecordReviewAssignedCount = (Select count (*) from RecordReviews RR
INNER JOIN #TempCaseloadReassign TCR
    ON  RR.RecordReviewId  = TCR.AssignmentSubTypeId AND isnull(RR.RecordDeleted, 'N') = 'N' AND  RR.ReviewingStaff = TCR.StaffId
WHERE TCR.AssignmentTypeCode = 'PEERRECORDREVIEWS')


IF(@TempPeerRecordReviewCount > @PeerRecordReviewAssignedCount)
BEGIN 
INSERT INTO #TempUnchangedAssignment (ClientName,[Description])
 Select ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, ''), 
 'Description - Peer Record Review is no longer assigned to selected staff' +  CHAR(13) +
'Reason – Peer Record Review has been changed from selected staff' 
FROM RecordReviews RR
INNER JOIN #TempCaseloadReassign TCR
    ON  RR.RecordReviewId = TCR.AssignmentSubTypeId AND  isnull(RR.RecordDeleted, 'N') = 'N' AND RR.ReviewingStaff <> TCR.StaffId
    INNER JOIN Clients C ON C.ClientId = RR.ClientId  AND  isnull(C.RecordDeleted, 'N') = 'N'
WHERE TCR.AssignmentTypeCode = 'PEERRECORDREVIEWS' 
END

-- Update Peer Record Reviews
UPDATE RR
SET RR.ReviewingStaff = @StaffId, RR.ModifiedDate = getdate(), RR.ModifiedBy = @loggedInUserName
FROM RecordReviews RR
INNER JOIN #TempCaseloadReassign TCR
    ON RR.RecordReviewId = TCR.AssignmentSubTypeId AND  isnull(RR.RecordDeleted, 'N') = 'N' AND RR.ReviewingStaff  = TCR.StaffId 
WHERE TCR.AssignmentTypeCode = 'PEERRECORDREVIEWS'
END
END


--*************************************************************************	
-- Update Rx Verbal and Queued Orders
--*************************************************************************
BEGIN
-- To get the count Rx Verbal and Queued Orders
DECLARE @TempRXCount int = 0
DECLARE @RXAssignedCount int = 0

SET @TempRXCount = (Select count (*) from #TempCaseloadReassign where AssignmentTypeCode = 'RX')
IF(@TempRXCount > 0)
BEGIN

Create Table #TempClientMedicationOrders
	([ClientMedicationScriptId] [int] NULL,
	[ClientMedicationId] [int] NULL,
	[OrderingPrescriberId] [int] NULL,
	[PrescriberId] [int] NULL,
	[OrderType] nvarchar(10))


--select * from #TempCaseloadReassign WHERE AssignmentTypeCode = 'RX'
-- Verbal orders list
INSERT INTO #TempClientMedicationOrders (ClientMedicationScriptId,ClientMedicationId,OrderingPrescriberId,PrescriberId, OrderType)
SELECT CMS.ClientMedicationScriptId, CM.ClientMedicationId, TCR.StaffId,TCR.StaffId, 'V'
FROM ClientMedicationScripts  CMS
INNER JOIN #TempCaseloadReassign TCR
    ON CMS.ClientMedicationScriptId = TCR.AssignmentSubTypeId AND  isnull(CMS.RecordDeleted, 'N') = 'N' --AND CMS.OrderingPrescriberId  = TCR.StaffId
    INNER JOIN ClientMedicationScriptDrugs CMSD on CMS.ClientMedicationScriptId = CMSD.ClientMedicationScriptId                                                      
 inner join ClientMedicationInstructions CMI on CMSD.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId  --AND ISNULL(CMI.Active, 'Y') = 'Y'                                                
 inner join ClientMedications CM on CM.ClientMedicationId = CMI.ClientMedicationId and isnull(CM.Discontinued,'N')<>'Y'   
WHERE TCR.AssignmentTypeCode = 'RX' and ISNULL(CMS.VerbalOrderApproved,'N')='N' and  ISNULL(CMS.WaitingPrescriberApproval,'N')='N' and CMS.CreatedBy <> @UserCode   

			
-- Queue orders list			
INSERT INTO #TempClientMedicationOrders (ClientMedicationScriptId,ClientMedicationId,OrderingPrescriberId,PrescriberId, OrderType)
SELECT CMS.ClientMedicationScriptId, CM.ClientMedicationId,TCR.StaffId,TCR.StaffId, 'Q'
FROM ClientMedicationScripts  CMS
INNER JOIN #TempCaseloadReassign TCR
    ON CMS.ClientMedicationScriptId = TCR.AssignmentSubTypeId AND  isnull(CMS.RecordDeleted, 'N') = 'N' --AND CMS.OrderingPrescriberId  = TCR.StaffId
    INNER JOIN ClientMedicationScriptDrugs CMSD on CMS.ClientMedicationScriptId = CMSD.ClientMedicationScriptId                                                      
 inner join ClientMedicationInstructions CMI on CMSD.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId  --AND ISNULL(CMI.Active, 'Y') = 'Y'                                                
 inner join ClientMedications CM on CM.ClientMedicationId = CMI.ClientMedicationId and isnull(CM.Discontinued,'N')<>'Y'   
WHERE TCR.AssignmentTypeCode = 'RX' and CMS.WaitingPrescriberApproval= 'Y'


--select * from #TempClientMedicationOrders
--IF Not exists (SELECT * from #TempClientMedicationOrders)
--BEGIN
--INSERT INTO #TempUnchangedAssignment (ClientName,[Description])
-- Select ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, ''), 
-- 'Description - Rx Verbal/Queued Order is no longer assigned to selected staff' +  CHAR(13) +
--'Reason – Verbal/Queued Order has been changed from selected staff' 
--From #TempCaseloadReassign  TCR  INNER JOIN Clients C ON C.ClientId = TCR.ClientId  AND  isnull(C.RecordDeleted, 'N') = 'N'
--END


--Discrepancy message for Verbal orders.
BEGIN 
INSERT INTO #TempUnchangedAssignment (ClientName,[Description])
 Select ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, ''), 
 'Description - Rx Verbal Order is no longer assigned to selected staff or not a Prescriber' +  CHAR(13) +
'Reason – Verbal Order has been changed from selected staff or not a Prescriber' 
FROM ClientMedicationScripts CMS
INNER JOIN #TempClientMedicationOrders TCM
    ON  CMS.ClientMedicationScriptId = TCM.ClientMedicationScriptId AND  isnull(CMS.RecordDeleted, 'N') = 'N' 
    INNER JOIN Clients C ON C.ClientId = CMS.ClientId  AND  isnull(C.RecordDeleted, 'N') = 'N'
    Where TCM.OrderType = 'V' AND (CMS.OrderingPrescriberId <> TCM.OrderingPrescriberId
    OR EXISTS (SELECT *
				FROM Staff S
				WHERE S.StaffId = @StaffId AND  isnull(s.Prescriber, 'N') = 'N' AND isnull(s.RecordDeleted, 'N') = 'N'  AND s.Active = 'Y'
			))
    
 UNION
    
  Select ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, ''), 
 'Description - Rx Verbal Order is no longer assigned to selected staff or not a Prescriber' +  CHAR(13) +
'Reason – Verbal Order has been changed from selected staff or not a Prescriber' 
FROM ClientMedications CM
INNER JOIN #TempClientMedicationOrders TCM
    ON  CM.ClientMedicationId = TCM.ClientMedicationId AND  isnull(CM.RecordDeleted, 'N') = 'N' 
    INNER JOIN Clients C ON C.ClientId = CM.ClientId  AND  isnull(C.RecordDeleted, 'N') = 'N' 
     Where TCM.OrderType = 'V' AND (TCM.PrescriberId <> CM.PrescriberId
      OR EXISTS (SELECT *
				FROM Staff S
				WHERE S.StaffId = @StaffId AND  isnull(s.Prescriber, 'N') = 'N' AND isnull(s.RecordDeleted, 'N') = 'N'  AND s.Active = 'Y'
			))
END


--Discrepancy message for Queued orders.
BEGIN 
INSERT INTO #TempUnchangedAssignment (ClientName,[Description])
 Select ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, ''), 
 'Description - Rx Queued Order has been changed from selected staff or not a Prescriber' +  CHAR(13) +
'Reason – Queued Order has been changed from selected staff or not a Prescriber' 
FROM ClientMedicationScripts CMS
INNER JOIN #TempClientMedicationOrders TCM
    ON  CMS.ClientMedicationScriptId = TCM.ClientMedicationScriptId AND  isnull(CMS.RecordDeleted, 'N') = 'N' --
    INNER JOIN Clients C ON C.ClientId = CMS.ClientId  AND  isnull(C.RecordDeleted, 'N') = 'N'
    Where TCM.OrderType = 'Q' AND (CMS.OrderingPrescriberId <> TCM.OrderingPrescriberId
     OR EXISTS (SELECT *
				FROM Staff S
				WHERE S.StaffId = @StaffId AND  isnull(s.Prescriber, 'N') = 'N' AND isnull(s.RecordDeleted, 'N') = 'N'  AND s.Active = 'Y'
			))
    
 UNION
   
  Select ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, ''), 
 'Description - Rx Queued Order has been changed from selected staff or not a Prescriber' +  CHAR(13) +
'Reason – Queued Order has been changed from selected staff or not a Prescriber' 
FROM ClientMedications CM
INNER JOIN #TempClientMedicationOrders TCM
    ON  CM.ClientMedicationId = TCM.ClientMedicationId AND  isnull(CM.RecordDeleted, 'N') = 'N'
    INNER JOIN Clients C ON C.ClientId = CM.ClientId  AND  isnull(C.RecordDeleted, 'N') = 'N' 
     Where TCM.OrderType = 'Q'  AND (TCM.PrescriberId <> CM.PrescriberId
      OR EXISTS (SELECT *
				FROM Staff S
				WHERE S.StaffId = @StaffId AND  isnull(s.Prescriber, 'N') = 'N' AND isnull(s.RecordDeleted, 'N') = 'N'  AND s.Active = 'Y'
			))
END
 --SELECT * from #TempClientMedicationOrders
			
UPDATE 	CMS
SET CMS.OrderingPrescriberId = @StaffId, CMS.ModifiedDate = getdate(), CMS.ModifiedBy = @loggedInUserName, CMS.OrderingPrescriberName = @StaffName
FROM ClientMedicationScripts  CMS	
INNER JOIN #TempClientMedicationOrders CMO
ON CMS.ClientMedicationScriptId = CMO.ClientMedicationScriptId AND  isnull(CMS.RecordDeleted, 'N') = 'N' 
AND EXISTS (SELECT *
				FROM Staff S
				WHERE S.StaffId = @StaffId AND  isnull(s.Prescriber, 'N') = 'Y' AND isnull(s.RecordDeleted, 'N') = 'N'  AND s.Active = 'Y'
			)	


UPDATE 	CM
SET CM.PrescriberId = @StaffId, CM.ModifiedDate = getdate(), CM.ModifiedBy = @loggedInUserName, CM.PrescriberName = @StaffName
FROM ClientMedications CM	
INNER JOIN #TempClientMedicationOrders CMO
ON CM.ClientMedicationId = CMO.ClientMedicationId AND  isnull(CM.RecordDeleted, 'N') = 'N' 
AND EXISTS (SELECT *
				FROM Staff S
				WHERE S.StaffId = @StaffId AND  isnull(s.Prescriber, 'N') = 'Y' AND isnull(s.RecordDeleted, 'N') = 'N'  AND s.Active = 'Y'
			)	
		
END
END

SELECT ClientName,[Description] from #TempUnchangedAssignment



-- Added by Ponnin : For task Thresholds - Support #1087
DECLARE @StoreProcedureName varchar(200)

SET @StoreProcedureName = (SELECT TOP 1 Value  FROM SystemConfigurationKeys WHERE [Key] = 'CaseLoadReAssignStoredProcedure' AND isnull(RecordDeleted, 'N') = 'N')
DECLARE @sqlCommand varchar(500)

IF(isnull(@StoreProcedureName, '') <> '')
BEGIN
SET @sqlCommand = @StoreProcedureName + ' ' + CAST( @StaffId as varchar(20) )  + ', ' + CAST( @loggedInUserId as varchar(20) )
EXEC (@sqlCommand)
END
-- Ponnin : For task Thresholds - Support #1087
	
 END TRY                                        
                                                           
 BEGIN CATCH                                                            
   DECLARE @Error varchar(8000)                                                                                               
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                              
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[ssp_CaseloadReassignment]')                                                                                               
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                                              
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                              
   RAISERROR (@Error /* Message text*/,  16 /*Severity*/,   1/*State*/   )                                                            
 END CATCH                                          
End 

GO


