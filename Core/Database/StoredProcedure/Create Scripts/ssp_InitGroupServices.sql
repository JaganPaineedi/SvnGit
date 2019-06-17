IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitGroupServices]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_InitGroupServices]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_InitGroupServices] (
	@ClientID INT
	,@StaffID INT
	,@CustomParameters XML
	)
AS
/*********************************************************************/
/* Stored Procedure: ssp_InitGroupServices               */
/* Copyright: 2007 Streamline SmartCare*/
/* Creation Date:  7/May/2010                                    */
/*                                                                   */
/* Purpose: Get Infromation related to GroupService */
/*                                                                   */
/* Input Parameters: GroupID  */
/*                                                                   */
/* Output Parameters:                                */
/*                                                                   */
/* Return:   */
/*                                                                   */
/* Called By:Detail Class Of DataService    */
/*      */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:            *//*                                                                   *//*   Updates:                             */
/*       Date                Author                  Purpose     */
/*   7/May/2010             Mohit Madan     Createded in SP*/
/*   15/May/2012           Rakesh-II       Modify  SP, if block contain the actual code, added else block to implement copy service functionality*/
/*   20/July/2012          Maninder        Modify  SP, Used @billable for initializing 'Services' */
/*   25/SEP/2012          Jagdeep          Added updated version for threshold    */
/*   27/OCT/2012			Rachna Singh	Added updated version from Custom To Core with ref task#77 in 3.5x issues*/
/*   18/Feb/2013			Maninder	    Added case for NotBillable: When ProcedureCodes.NotBillable='Y' then @billable='N' else ProcedureCodes.NotBillable='N' then @billable='Y' */
/*   6/March/2013          Maninder        Commented code to retrieve Services.NoteAuthorId w.r.t Task 2724 in Thresholds Bugs/Feature       */
/*	  29/May/2013			Bernardin		Included CopyServiceId in the result set to include the custom fields while copying the group service note.	*/
/*   31/May/2013           Bernardin       csp converted to ssp as it core sp.*/
/* 02.25.2014				Ponnin		    Removed ‘RowIdentifier’ and added ‘StartTime’ column according to Core data model change 'Upgrade script core 13.39 to 13.40.sql' for task  #155 of Philhaven Development. */
--  OCT-07-2014           Akwinass        Removed columns 'DiagnosisCode1,DiagnosisCode2,DiagnosisCode3' from Services table (Task #134 in Engineering Improvement Initiatives- NBL(I)).
-- Nov-05-2014			Vithobha		Added PlaceOfServiceId task #16 in  MFS - Setup.
/*	  16 Jan 2015		    Avi Goyal	    What : Changed NoteType Join to FlagTypes    */
/*								            Why : Task # 600 Securiry Alerts ; Project : Network-180 Customizations   */
-- July-02-2015			MD Khusro		Change the logic to fetch Date Of Service w.r.t Core Bugs #1746
-- Sep-09-2015			Chethan N		What : Retriving Group.StartTime
--										Why : Philhaven - Customization Issues Tracking task # 1372
/*  16-Oct-2015				Revathi			 what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName. */
/*											 why:task #609, Network180 Customization      */
/*  13-APRIL-2016           Akwinass	 What:Included GroupNoteType Column.          
							             Why:task #167.1 Valley - Support Go Live*/
/*  09-AUG-2016           Akwinass	     What: Changed Status & DateOfService column name as per in Table.         
							             Why:task #377 Engineering Improvement Initiatives- NBL(I)*/
/*  19-OCT-2016           Pabitra        what: Added the scsp_InitGroupServiceDetailCustomFields to initalize the custom fields
                                         Why : Camino Support Go Live #171  */	
/* 07-NOV-2017            Chita Ranjan   What:Modified scsp_InitGroupServiceDetailCustomFields, changed input parameter to @ClientList from @GroupId
                                         Why : Camino Support Go Live #567  */ 
/* 13-April-2018          Chita Ranjan   What: Added condition before calling scsp_InitGroupServiceDetailCustomFields to check the input parameter, 
                                               If the input parameter is @GroupID then it will pass the parameter as @GroupID, if the parameter is @ClientList then it will pass the input parameter as @ClientList
                                         Why : MHP SGL #417 */    
/* 27-April-2018          Chita Ranjan   What: Added ClassroomId column to Groups table for initialization, as there is a new field added in Group Detail page called Classroom
                                         Why : PEP - Customizations #10005 
   08-Aug-2018            Gautam         What: converted Time to Datetime while adding with Date datatype.
                                         Why: Throwing error : The data types datetime and time are incompatible in the add operator. SQL 2016 syntax error*/                         						             
/***********************************************************************************************/
BEGIN
	BEGIN TRY
		--Following option is reqd for xml operations                                  
		SET ARITHABORT ON

		DECLARE @ClientPagePreferences VARCHAR(100)
		DECLARE @GroupID INT
		DECLARE @GroupStatus VARCHAR(500)
		DECLARE @ClientList AS VARCHAR(max)
		DECLARE @DateOfService AS DATETIME
		DECLARE @CopyService AS VARCHAR(max)
		DECLARE @GroupServiceId AS VARCHAR(max)
		DECLARE @CodeName VARCHAR(100)

		SET @DateOfService = @CustomParameters.value('(/Root/Parameters/@DateOfService)[1]', 'datetime')
		SET @ClientList = @CustomParameters.value('(/Root/Parameters/@ClientIdList)[1]', 'varchar(max)')
		--Below added By Rakesh-II Dated 15 May,2012  Task 9 in Threshold Phase III    
		SET @CopyService = @CustomParameters.value('(/Root/Parameters/@CopyService)[1]', 'varchar(max)')
		SET @GroupServiceId = @CustomParameters.value('(/Root/Parameters/@CopyFromGroupServiceId)[1]', 'varchar(max)')

		DECLARE @billable CHAR(1)

		SET @GroupID = @CustomParameters.value('(/Root/Parameters/@GroupID)[1]', 'int')

		SELECT @ClientPagePreferences = isnull(ClientPagePreferences, '')
		FROM Staff
		WHERE StaffId = @StaffID
			AND isnull(RecordDeleted, 'N') = 'N'

		SET @GroupStatus = (
				SELECT [dbo].[GetGroupStatus](@GroupId)
				)

		--creating temp table   
		IF object_id('tempdb..#Notes') IS NOT NULL
			DROP TABLE #Notes

		CREATE TABLE #Notes (
			NoteId INT identity NOT NULL
			,ClientId INT NULL
			,ClientNoteId INT NULL
			,GlobalCodeId INT NULL
			,NoteType INT NULL
			,Bitmap VARCHAR(200) NULL
			,NoteNumber INT NULL
			,Note VARCHAR(100) NULL
			,CodeName VARCHAR(250) NULL
			)

		DECLARE @ClientSplitTable AS TABLE (ClientId INT)

		INSERT INTO @ClientSplitTable
		SELECT item
		FROM dbo.fnSplit(@ClientList, ',')

		--- end here  
		--Note  common code in both conditoin like temp table are created at top  
		IF @CopyService != 'Y'
		BEGIN
			--#region IF Simple imitialization process  
			PRINT 'IF'

			---- Group -----                                                                                                                                         
			SELECT 'Groups' AS TableName
				,G.GroupId
				,G.GroupName
				,G.GroupCode
				,G.GroupType
				,G.Comment
				,G.ProcedureCodeId
				,G.LocationId
				,G.ProgramId
				,G.ClinicianId
				,G.Unit
				,G.UnitType
				,G.Active
				,G.GroupNoteDocumentCodeId
				,G.CreatedBy
				,G.CreatedDate
				,G.ModifiedBy
				,G.ModifiedDate
				,G.RecordDeleted
				,G.DeletedDate
				,G.DeletedBy
				,'Scheduled' AS GroupStatusName
				,70 AS GroupStatus
				,GNDC.GroupNoteCodeId
				,GNDC.ServiceNoteCodeId
				,PC.EnteredAs AS UnitCode
				,GC.CodeName AS UnitCodeName
				,SC.ScreenId
				,SC.ScreenURL
				,LTRIM(RTRIM(@ClientPagePreferences)) AS ClientPagePreferences
				,'N' AS IsInitialize
				,G.AddClientsFromRoster
				,G.PlaceOfServiceId
				,G.StartTime
				--13-APRIL-2016 Akwinass
				,G.GroupNoteType
				--27-APRIL-2016 Chita Ranjan
				,G.ClassroomId
			FROM Groups G
			LEFT JOIN GroupNoteDocumentCodes GNDC ON G.GroupNoteDocumentCodeId = GNDC.GroupNoteDocumentCodeId
			LEFT JOIN ProcedureCodes PC ON G.ProcedureCodeId = PC.ProcedureCodeId
			LEFT JOIN GlobalCodes GC ON PC.EnteredAs = GC.GlobalCodeId
			--LEFT OUTER JOIN Screens SC ON PC.AssociatedNoteId = SC.DocumentCodeId                                      
			LEFT JOIN Screens SC ON GNDC.ServiceNoteCodeId = SC.DocumentCodeId
			WHERE G.GroupId = @GroupId
				AND isnull(G.RecordDeleted, 'N') = 'N'
				AND isnull(GNDC.RecordDeleted, 'N') = 'N'
				AND isnull(PC.RecordDeleted, 'N') = 'N'
				AND isnull(GC.RecordDeleted, 'N') = 'N'

			SELECT @billable = CASE 
					WHEN NotBillable = 'Y'
						THEN 'N'
					ELSE 'Y'
					END
			FROM Groups
			INNER JOIN ProcedureCodes ON Groups.ProcedureCodeId = ProcedureCodes.ProcedureCodeId
				AND GroupId = @GroupID
				AND isnull(ProcedureCodes.RecordDeleted, 'N') = 'N'
				AND isnull(Groups.RecordDeleted, 'N') = 'N'

			---- Group Services-----                                  
			SELECT 'GroupServices' AS TableName
				--, -1 as GroupServiceId  -- New Added By Rakesh   
				,@DateOfService AS DateOfService
				,GroupId
				,G.ProcedureCodeId
				,Unit
				,UnitType
				,ClinicianId
				,ProgramId
				,LocationId
				,Comment
				,@billable AS Billable
				,G.CreatedBy
				,G.CreatedDate
				,G.ModifiedBy
				,G.ModifiedDate
				,70 AS [Status]
				,PC.MaxUnits
				,PC.MinUnits
				,'' AS SpecificLocation
				,G.PlaceOfServiceId
			FROM Groups G
			LEFT JOIN ProcedureCodes PC ON PC.ProcedureCodeId = G.ProcedureCodeId
			WHERE G.GroupId = @GroupID
				AND isnull(G.RecordDeleted, 'N') = 'N'

			---- Services-----                    
			--IF object_id('tempdb..#Notes') IS NOT NULL  
			--DROP TABLE #Notes                    
			--create table #Notes (                                                    
			--NoteId       int identity not null,                                                    
			--ClientId     int          null,                                                    
			--ClientNoteId int          null,                                      
			--GlobalCodeId int          null,                                          
			--NoteType     int          null,                                                    
			--Bitmap       varchar(200) null,                                       
			--NoteNumber   int          null,                                                    
			--Note         varchar(100) null,                    
			--CodeName     varchar(250) null,                    
			--Diagnosis1   char(6)      null,                    
			--Diagnosis2   char(6)      null,                    
			--Diagnosis3   char(6)      null                    
			--)  
			INSERT INTO #Notes (
				ClientId
				,ClientNoteId
				,GlobalCodeId
				,NoteType
				,Bitmap
				,Note
				,CodeName
				)
			SELECT DISTINCT cn.ClientId
				,cn.ClientNoteId
				--, gc.GlobalCodeId  						-- Commented by Avi Goyal, on 16 Jan 2015 
				,FT.FlagTypeId AS GlobalCodeId -- Added by Avi Goyal, on 16 Jan 2015  
				,cn.NoteType
				--, gc.Bitmap  						-- Commented by Avi Goyal, on 16 Jan 2015 
				,FT.Bitmap -- Added by Avi Goyal, on 16 Jan 2015  
				,cn.Note
				--, gc.CodeName  						-- Commented by Avi Goyal, on 16 Jan 2015 
				,FT.FlagType AS CodeName -- Added by Avi Goyal, on 16 Jan 2015  
			FROM GroupClients gcl
			INNER JOIN @ClientSplitTable cst ON gcl.ClientId = cst.ClientId
			INNER JOIN ClientNotes cn ON gcl.clientid = cn.clientid
			--LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = cn.NoteType    -- Commented by Avi Goyal, on 16 Jan 2015
			LEFT JOIN FlagTypes FT ON CN.NoteType = FT.FlagTypeId -- Added by Avi Goyal, on 16 Jan 2015    
				--join StaffClients sc on sc.ClientId = cn.ClientId                            
			WHERE gcl.GroupId = @GroupID
				AND isnull(gcl.RecordDeleted, 'N') = 'N'
				AND isnull(cn.RecordDeleted, 'N') = 'N'
				AND cn.Active = 'Y'
				AND (
					datediff(dd, cn.EndDate, getdate()) <= 0
					OR cn.EndDate IS NULL
					)
			--AND gc.Category = 'ClientNoteType'						-- Commented by Avi Goyal, on 16 Jan 2015
			ORDER BY cn.clientid
				,cn.ClientNoteId DESC

			--order by cn.ClientNoteId desc                    
			UPDATE n
			SET NoteNumber = n.NoteId - fn.FirstNoteId + 1
			FROM #Notes n
			INNER JOIN (
				SELECT ClientId
					,min(NoteId) AS FirstNoteId
				FROM #Notes
				GROUP BY ClientId
				) fn ON fn.ClientId = n.ClientId

			--IF object_id('tempdb..#TempDiagnosis') IS NOT NULL                    
			-- drop table #TempDiagnosis                    
			--create table #TempDiagnosis (                                                    
			--DiagnosisId  int identity not null,                         
			--ClientId     int          null,                                                    
			--DSMCode      char(6)      null,                                      
			--NoteNumber   int          null                    
			--)                                        
			--INSERT INTO #TempDiagnosis                    
			--(                    
			-- ClientId,                    
			-- DSMCode                    
			--)                    
			--SELECT  GC.ClientId ,Dig.DSMCode from GroupClients GC                     
			-- left outer join Documents D on GC.ClientId = D.ClientId                        
			-- left outer join DocumentVersions Dv on D.CurrentDocumentVersionId = Dv.DocumentVersionId                             
			-- left outer join DiagnosesIAndII Dig on Dv.DocumentVersionId = Dig.DocumentVersionId                             
			-- Where D.DocumentCodeId = 5  AND GC.GroupId = @GroupID                           
			-- AND D.Status = 22  AND DSMCode IS NOT NULL                      
			-- AND ISNULL(D.RecordDeleted,'N')='N'                            
			-- AND ISNULL(Dv.RecordDeleted,'N')='N'                            
			-- AND ISNULL(Dig.RecordDeleted,'N')='N'                            
			-- order by Dig.DiagnosisId desc                    
			-- update T                                                    
			--   set NoteNumber = T.DiagnosisId - fn.FirstNoteId + 1                                                    
			--  from #TempDiagnosis T                                             
			--       join (select ClientId,                                                    
			--                    min(DiagnosisId) as FirstNoteId                                                     
			--               from #TempDiagnosis                                                    
			--   group by ClientId) fn on fn.ClientId = T.ClientId                        
			--select 'Services' as TableName,                          
			--GC.ClientId,                          
			---1 as GroupServiceId,                          
			--G.ProcedureCodeId,                  
			--PC.RequiresTimeInTimeOut,                  
			----GETDATE() as DateofService,                          
			--G.Unit,                                 
			--G.UnitType,                          
			--70 as  Status,                          
			----G.ClinicianId as ProviderID,                          
			--G.ClinicianId ,                       
			--@StaffID AS NoteAuthorId ,                        
			--G.ProgramId,                          
			--G.LocationId,                          
			--'Y' as Billable                                  
			--,GC.CreatedBy,                          
			--GC.CreatedDate,                          
			--GC.ModifiedBy,              
			--GC.ModifiedDate,                          
			--GC.RowIdentifier                           
			--,Clients.LastName + ', ' + Clients.FirstName as [ClientName]                                     
			--,'N' AS IsServiceError                               
			--,0 AS DocumentId                      
			--,n.ClientId as NoteClient                    
			--      ,n.BitmapNo                    
			--      ,n.BitmapId1,n.Note1,                                                    
			--      n.BitmapId2,n.Note2,                                                     
			--      n.BitmapId3,n.Note3,                       
			--      n.BitmapId4,n.Note4,                                                     
			--      n.BitmapId5,n.Note5,                    
			--      DiagnosisCode1,                    
			--      DiagnosisCode2,                    
			--      DiagnosisCode3,        
			--      --added by shifali in ref to enable/disable service information/note tab based on saved service && doc status        
			--     70 as  SavedServiceStatus,        
			--     0 as SavedDocumentStatus,    
			--     PC.MaxUnits,    
			--     PC.MinUnits                                   
			----,SC.ScreenId                            
			----,SC.ScreenURL                             
			----,PC.ProcedureCodeId                  
			--from GroupClients GC join                                  
			--Groups G on G.GroupId=GC.Groupid                            
			----added by shifali                  
			--LEFT OUTER JOIN ProcedureCodes PC                  
			--on G.ProcedureCodeId=PC.ProcedureCodeId                  
			----modification by shifali ends here                  
			--LEFT OUTER JOIN Clients on GC.ClientId = Clients.ClientId                                         
			----LEFT OUTER JOIN ProcedureCodes PC ON G.ProcedureCodeId =PC.ProcedureCodeId                             
			----LEFT OUTER JOIN Screens SC ON PC.AssociatedNoteId = SC.DocumentCodeId                                 
			-- left join (select ClientId,                    
			--     max(NoteNumber) as BitmapNo,                                                    
			--                         max(case NoteNumber when 1 then GlobalCodeId else null end) as BitmapId1,                                                    
			--                         max(case NoteNumber when 1 then CodeName+' : '+Note else null end) as Note1,                                    
			--                         max(case NoteNumber when 2 then GlobalCodeId else null end) as BitmapId2,                                                    
			--       max(case NoteNumber when 2 then CodeName+' : '+Note else null end) as Note2,                                    
			--                         max(case NoteNumber when 3 then GlobalCodeId else null end) as BitmapId3,                                                    
			--       max(case NoteNumber when 3 then CodeName+' : '+Note else null end) as Note3,                                    
			--       max(case NoteNumber when 4 then GlobalCodeId else null end) as BitmapId4,                                                    
			--       max(case NoteNumber when 4 then CodeName+' : '+Note else null end) as Note4,                                    
			--                         max(case NoteNumber when 5 then GlobalCodeId else null end) as BitmapId5,                                                    
			--       max(case NoteNumber when 5 then CodeName+' : '+Note else null end) as Note5                                    
			--                    from #Notes                                                    
			--                   where NoteNumber <= 5                                                    
			--                   group by ClientId) n on n.ClientId = GC.ClientId                     
			--   left join (                    
			--   select CLientId,                    
			--   max(NoteNumber) as DiagnosisNo,                    
			--   max(case NoteNumber when 1 then DSMCode else null end) as DiagnosisCode1,                    
			--   max(case NoteNumber when 2 then DSMCode else null end) as DiagnosisCode2,                    
			--   max(case NoteNumber when 3 then DSMCode else null end) as DiagnosisCode3        
			--    from #TempDiagnosis                     
			--   where NoteNumber <=3 group By ClientId                     
			--   ) T on T.ClientId =GC.ClientId                      
			--where G.GroupId=@GroupID AND GC.GroupId = @GroupID                        
			--and ISNULL(G.RecordDeleted,'N')='N'                                   
			--and ISNULL(GC.RecordDeleted,'N')='N'                            
			--AND ISNULL(GC.RecordDeleted,'N')='N'                                  
			--AND ISNULL(Clients.RecordDeleted,'N')='N'            
			SELECT 'Services' AS TableName
				,GC.ClientId
				,- 1 AS GroupServiceId
				,G.ProcedureCodeId
				,PC.RequiresTimeInTimeOut
				--,G.StartTime AS DateofService
				,cast(CAST(@DateOfService AS DATE) AS DATETIME) + CAST(CAST(G.StartTime AS TIME(0)) AS DATETIME) AS DateOfService -- Added on 07/02/2015  
				,--GETDATE() as DateofService,                          
				G.Unit
				,G.UnitType
				,70 AS [Status]
				,--G.ClinicianId as ProviderID,                          
				G.ClinicianId
				--, @StaffID AS NoteAuthorId  
				,G.ProgramId
				,G.LocationId
				--, 'Y' AS Billable  
				,@billable AS Billable
				,GC.CreatedBy
				,GC.CreatedDate
				,GC.ModifiedBy
				,GC.ModifiedDate
				--, GC.RowIdentifier  
				--Added by Revathi	 16-Oct-2015
				,CASE 
					WHEN ISNULL(Clients.ClientType, 'I') = 'I'
						THEN ISNULL(Clients.LastName, '') + ', ' + ISNULL(Clients.FirstName, '')
					ELSE ISNULL(Clients.OrganizationName, '')
					END AS [ClientName]
				,'N' AS IsServiceError
				,0 AS DocumentId
				,n.ClientId AS NoteClient
				,n.BitmapNo
				,n.BitmapId1
				,n.Note1
				,n.BitmapId2
				,n.Note2
				,n.BitmapId3
				,n.Note3
				,n.BitmapId4
				,n.Note4
				,n.BitmapId5
				,n.Note5
				,--DiagnosisCode1,                    
				--DiagnosisCode2,                    
				--DiagnosisCode3,        
				--added by shifali in ref to enable/disable service information/note tab based on saved service && doc status        
				70 AS SavedServiceStatus
				,0 AS SavedDocumentStatus
				,PC.MaxUnits
				,PC.MinUnits
				,--,SC.ScreenId                            
				--,SC.ScreenURL                             
				--,PC.ProcedureCodeId                  
				'' AS SpecificLocation
			FROM GroupClients GC
			INNER JOIN Groups G ON G.GroupId = GC.Groupid
			--added by shifali                  
			LEFT JOIN ProcedureCodes PC ON G.ProcedureCodeId = PC.ProcedureCodeId
			--modification by shifali ends here                  
			LEFT JOIN Clients ON GC.ClientId = Clients.ClientId
			--LEFT OUTER JOIN ProcedureCodes PC ON G.ProcedureCodeId =PC.ProcedureCodeId                             
			--LEFT OUTER JOIN Screens SC ON PC.AssociatedNoteId = SC.DocumentCodeId                                 
			LEFT JOIN (
				SELECT ClientId
					,max(NoteNumber) AS BitmapNo
					,max(CASE NoteNumber
							WHEN 1
								THEN GlobalCodeId
							ELSE NULL
							END) AS BitmapId1
					,max(CASE NoteNumber
							WHEN 1
								THEN CodeName + ' : ' + Note
							ELSE NULL
							END) AS Note1
					,max(CASE NoteNumber
							WHEN 2
								THEN GlobalCodeId
							ELSE NULL
							END) AS BitmapId2
					,max(CASE NoteNumber
							WHEN 2
								THEN CodeName + ' : ' + Note
							ELSE NULL
							END) AS Note2
					,max(CASE NoteNumber
							WHEN 3
								THEN GlobalCodeId
							ELSE NULL
							END) AS BitmapId3
					,max(CASE NoteNumber
							WHEN 3
								THEN CodeName + ' : ' + Note
							ELSE NULL
							END) AS Note3
					,max(CASE NoteNumber
							WHEN 4
								THEN GlobalCodeId
							ELSE NULL
							END) AS BitmapId4
					,max(CASE NoteNumber
							WHEN 4
								THEN CodeName + ' : ' + Note
							ELSE NULL
							END) AS Note4
					,max(CASE NoteNumber
							WHEN 5
								THEN GlobalCodeId
							ELSE NULL
							END) AS BitmapId5
					,max(CASE NoteNumber
							WHEN 5
								THEN CodeName + ' : ' + Note
							ELSE NULL
							END) AS Note5
				FROM #Notes
				WHERE NoteNumber <= 5
				GROUP BY ClientId
				) n ON n.ClientId = GC.ClientId
			--left join (                    
			--select CLientId,                    
			--max(NoteNumber) as DiagnosisNo,                    
			--max(case NoteNumber when 1 then DSMCode else null end) as DiagnosisCode1,                    
			--max(case NoteNumber when 2 then DSMCode else null end) as DiagnosisCode2,                    
			--max(case NoteNumber when 3 then DSMCode else null end) as DiagnosisCode3        
			-- from #TempDiagnosis                     
			--where NoteNumber <=3 group By ClientId                     
			--) T on T.ClientId =GC.ClientId                      
			INNER JOIN @ClientSplitTable cst ON cst.ClientId = GC.ClientId
			WHERE G.GroupId = @GroupID
				AND GC.GroupId = @GroupID
				AND isnull(G.RecordDeleted, 'N') = 'N'
				AND isnull(GC.RecordDeleted, 'N') = 'N'
				AND isnull(GC.RecordDeleted, 'N') = 'N'
				AND isnull(Clients.RecordDeleted, 'N') = 'N'
			ORDER BY [ClientName]

			---GroupServiceStaff---                                  
			--declare @CodeName varchar(100)  
			SELECT @CodeName = CodeName
			FROM Groups G
			INNER JOIN GlobalCodes GC ON G.UnitType = GC.GlobalCodeId
			WHERE GroupId = @GroupID
				AND isnull(G.RecordDeleted, 'N') = 'N'
				AND isnull(GC.RecordDeleted, 'N') = 'N'

			SELECT 'GroupServiceStaff' AS TableName
				,- 1 AS GroupServiceId
				,GS.StaffId
				,G.Unit
				,G.UnitType
				--,GETDATE() as DateOfService                                              
				,GS.RowIdentifier
				,GS.CreatedBy
				,GS.CreatedDate
				,GS.ModifiedBy
				,GS.ModifiedDate
				,GS.RecordDeleted
				,GS.DeletedDate
				,GS.DeletedBy
				,S.LastName + ', ' + S.FirstName AS [StaffName]
				,@CodeName AS CodeName
			--,GS.CreatedBy,GS.CreatedDate,GS.ModifiedBy,GS.ModifiedDate,GS.RowIdentifier                                   
			FROM GroupStaff GS
			INNER JOIN Groups G ON GS.GroupId = G.GroupId
			INNER JOIN Staff S ON GS.StaffId = S.StaffId
			WHERE isnull(GS.RecordDeleted, 'N') = 'N'
				AND isnull(S.RecordDeleted, 'N') = 'N'
				AND isnull(G.RecordDeleted, 'N') = 'N'
				AND G.Groupid = @GroupID

			--SELECT 'GroupStaff' as TableName,                                  
			-- GS.GroupStaffId,                                  
			-- @GroupID as GroupId                                              
			-- ,GS.StaffId                                              
			-- ,GS.CreatedBy,GS.CreatedDate,GS.ModifiedBy,GS.ModifiedDate,GS.RowIdentifier                                  
			-- , 'N' as IsInitialize                                    
			-- FROM GroupStaff GS                                   
			-- where ISNULL(GS.RecordDeleted,'N')='N'                                  
			-- and GS.Groupid=@GroupID                                   
			SELECT 'GroupClients' AS TableName
				,GC.GroupClientId
				,GC.GroupId
				,GC.ClientId
				,GC.RowIdentifier
				,GC.CreatedBy
				,GC.CreatedDate
				,GC.ModifiedBy
				,GC.ModifiedDate
				,GC.RecordDeleted
				,GC.DeletedDate
				,GC.DeletedBy
				--Added by Revathi	 16-Oct-2015
				,CASE 
					WHEN ISNULL(Clients.ClientType, 'I') = 'I'
						THEN ISNULL(Clients.LastName,'') + ', ' + ISNULL(Clients.FirstName,'')
					ELSE ISNULL(Clients.OrganizationName,'')
					END AS [ClientName]
				,'N' AS IsServiceError
				,'N' AS IsInitialize
				,0 AS DocumentId
				--,SC.ScreenId                            
				--,SC.ScreenURL                             
				--,PC.ProcedureCodeId                             
				,- 1 AS GroupServiceId
				,G.ProcedureCodeId
			FROM [GroupClients] GC
			LEFT JOIN Clients ON GC.ClientId = Clients.ClientId
			LEFT JOIN Groups G ON GC.GroupId = G.GroupId
			--LEFT OUTER JOIN ProcedureCodes PC ON G.ProcedureCodeId =PC.ProcedureCodeId                             
			--LEFT OUTER JOIN Screens SC ON PC.AssociatedNoteId = SC.DocumentCodeId                             
			WHERE GC.GroupId = @GroupId
				AND isnull(GC.RecordDeleted, 'N') = 'N'
				AND isnull(Clients.RecordDeleted, 'N') = 'N'

			DROP TABLE #Notes
				--#endregion      
		END
		ELSE
		BEGIN
			--#region in case of copy service do again imitialization process  
			SELECT @GroupId = GroupId
				,@DateOfService = DateOfService
			FROM groupServices
			WHERE GroupServiceId = @GroupServiceId

			-- PRINT @GroupID  
			PRINT 'Else'

			---- Group -----                                                                                                                                         
			SELECT 'Groups' AS TableName
				,G.GroupId
				,G.GroupName
				,G.GroupCode
				,G.GroupType
				,G.Comment
				,G.ProcedureCodeId
				,G.LocationId
				,G.ProgramId
				,G.ClinicianId
				,G.Unit
				,G.UnitType
				,G.Active
				,G.GroupNoteDocumentCodeId
				,G.CreatedBy
				,G.CreatedDate
				,G.ModifiedBy
				,G.ModifiedDate
				,G.RecordDeleted
				,G.DeletedDate
				,G.DeletedBy
				,'Scheduled' AS GroupStatusName
				,70 AS GroupStatus
				,GNDC.GroupNoteCodeId
				,GNDC.ServiceNoteCodeId
				,PC.EnteredAs AS UnitCode
				,GC.CodeName AS UnitCodeName
				,SC.ScreenId
				,SC.ScreenURL
				,LTRIM(RTRIM(@ClientPagePreferences)) AS ClientPagePreferences
				,'N' AS IsInitialize
				,G.AddClientsFromRoster
				,G.StartTime
				--13-APRIL-2016  Akwinass
				,G.GroupNoteType
			FROM Groups G
			LEFT JOIN GroupNoteDocumentCodes GNDC ON G.GroupNoteDocumentCodeId = GNDC.GroupNoteDocumentCodeId
			LEFT JOIN ProcedureCodes PC ON G.ProcedureCodeId = PC.ProcedureCodeId
			LEFT JOIN GlobalCodes GC ON PC.EnteredAs = GC.GlobalCodeId
			--LEFT OUTER JOIN Screens SC ON PC.AssociatedNoteId = SC.DocumentCodeId                                      
			LEFT JOIN Screens SC ON GNDC.ServiceNoteCodeId = SC.DocumentCodeId
			WHERE G.GroupId = @GroupId
				AND isnull(G.RecordDeleted, 'N') = 'N'
				AND isnull(GNDC.RecordDeleted, 'N') = 'N'
				AND isnull(PC.RecordDeleted, 'N') = 'N'
				AND isnull(GC.RecordDeleted, 'N') = 'N'

			SELECT @billable = CASE 
					WHEN NotBillable = 'Y'
						THEN 'N'
					ELSE 'Y'
					END
			FROM Groups
			INNER JOIN ProcedureCodes ON Groups.ProcedureCodeId = ProcedureCodes.ProcedureCodeId
				AND GroupId = @GroupID
				AND isnull(ProcedureCodes.RecordDeleted, 'N') = 'N'
				AND isnull(Groups.RecordDeleted, 'N') = 'N'

			---- Group Services-----                                  
			SELECT TOP 1 'GroupServices' AS TableName
				,GS.DateOfService
				,GS.EndDateOfService
				,GS.GroupId
				,GS.ProcedureCodeId
				,GS.Unit
				,GS.UnitType
				,GS.ClinicianId
				,GS.AttendingId
				,GS.ProgramId
				,
				-----commeneted By Rakesh -II   on 24 MAy 2102  
				--, S.LocationId    
				--, S.Comment  
				------- end of commented Fields  
				GS.Billable
				,GS.CreatedBy
				,GS.CreatedDate
				,GS.ModifiedBy
				,GS.ModifiedDate
				,GS.STATUS
				,GS.CancelReason
				,GS.Billable
				,
				--, S.RowIdentifier  
				PC.MaxUnits
				,PC.MinUnits
				,
				--, '' AS SpecificLocation,  
				--Below new fields added BY Rakesh-II as to implement the copy service on 24 May,2012  
				GS.DateTimeIn
				,GS.DateTimeOut
				,GS.Comment
				,GS.NoteAuthorId
				,GS.LocationId
				,
				--D.DocumentId,                  
				RGSPL.RecurringGroupServiceId
				,GS.SpecificLocation
			--end   
			FROM dbo.RecurringGroupServices AS RGS
			INNER JOIN dbo.RecurringGroupServicesProcessLog AS RGSPL ON RGS.RecurringGroupServiceId = RGSPL.RecurringGroupServiceId
				AND ISNULL(RGS.Processed, 'N') = 'N'
			RIGHT JOIN dbo.GroupServices AS GS ON RGSPL.GroupServiceId = GS.GroupServiceId
			--LEFT OUTER JOIN  dbo.Documents AS D ON GS.GroupServiceId = D.GroupServiceId AND D.ServiceId IS NULL AND D.ClientId IS NULL --AND D.AuthorId = @StaffId                        
			LEFT JOIN ProcedureCodes PC ON PC.ProcedureCodeId = GS.ProcedureCodeId
			WHERE (GS.GroupId = @GroupID)
				AND (GS.GroupServiceId = @GroupServiceId)
				AND (ISNULL(GS.RecordDeleted, 'N') = 'N')
				AND --(ISNULL(D.RecordDeleted, 'N') = 'N') AND                         
				(ISNULL(RGSPL.RecordDeleted, 'N') = 'N')
				AND (ISNULL(RGS.RecordDeleted, 'N') = 'N')

			---  below lines commented by Rakesh-II On 24 May, 2012 For copy service  
			--     Services  S  
			-- LEFT JOIN ProcedureCodes PC  
			--  ON PC.ProcedureCodeId = S.ProcedureCodeId  
			-- WHERE  
			-- S.GroupServiceId = @GroupServiceId  
			INSERT INTO #Notes (
				ClientId
				,ClientNoteId
				,GlobalCodeId
				,NoteType
				,Bitmap
				,Note
				,CodeName
				)
			SELECT DISTINCT cn.ClientId
				,cn.ClientNoteId
				--, gc.GlobalCodeId					-- Commented by Avi Goyal, on 16 Jan 2015 
				,FT.FlagTypeId AS GlobalCodeId -- Added by Avi Goyal, on 16 Jan 2015 
				,cn.NoteType
				--, gc.Bitmap							-- Commented by Avi Goyal, on 16 Jan 2015 
				,FT.Bitmap -- Added by Avi Goyal, on 16 Jan 2015 
				,cn.Note
				--, gc.CodeName						-- Commented by Avi Goyal, on 16 Jan 2015 
				,FT.FlagType AS CodeName -- Added by Avi Goyal, on 16 Jan 2015  
			FROM GroupClients gcl
			INNER JOIN @ClientSplitTable cst ON gcl.ClientId = cst.ClientId
			INNER JOIN ClientNotes cn ON gcl.clientid = cn.clientid
			--LEFT JOIN GlobalCodes gc ON gc.GlobalCodeId = cn.NoteType    -- Commented by Avi Goyal, on 16 Jan 2015
			LEFT JOIN FlagTypes FT ON CN.NoteType = FT.FlagTypeId -- Added by Avi Goyal, on 16 Jan 2015 
				--join StaffClients sc on sc.ClientId = cn.ClientId                            
			WHERE gcl.GroupId = @GroupID
				AND isnull(gcl.RecordDeleted, 'N') = 'N'
				AND isnull(cn.RecordDeleted, 'N') = 'N'
				AND cn.Active = 'Y'
				AND (
					datediff(dd, cn.EndDate, getdate()) <= 0
					OR cn.EndDate IS NULL
					)
			--AND gc.Category = 'ClientNoteType'							-- Commented by Avi Goyal, on 16 Jan 2015 
			ORDER BY cn.clientid
				,cn.ClientNoteId DESC

			--order by cn.ClientNoteId desc                    
			UPDATE n
			SET NoteNumber = n.NoteId - fn.FirstNoteId + 1
			FROM #Notes n
			INNER JOIN (
				SELECT ClientId
					,min(NoteId) AS FirstNoteId
				FROM #Notes
				GROUP BY ClientId
				) fn ON fn.ClientId = n.ClientId

			--  Services --  
			SELECT DISTINCT 'Services' AS TableName
				,GC.ClientId
				,- 1 AS GroupServiceId
				,S.ProcedureCodeId
				,PC.RequiresTimeInTimeOut
				,--GETDATE() as DateofService,                          
				S.Unit
				,S.UnitType
				,70 AS STATUS
				,--G.ClinicianId as ProviderID,                          
				S.ClinicianId
				--, s.NoteAuthorId --92 AS NoteAuthorId   
				,S.ProgramId
				,S.LocationId
				,S.Billable
				,S.CreatedBy
				,S.CreatedDate
				,S.ModifiedBy
				,S.ModifiedDate
				--, S.RowIdentifier  
				,CASE 
					WHEN ISNULL(Clients.ClientType, 'I') = 'I'
						THEN Clients.LastName + ', ' + Clients.FirstName
					ELSE Clients.OrganizationName
					END AS [ClientName]
				,'N' AS IsServiceError
				,0 AS DocumentId
				,0 AS NoteClient
				,0 AS BitmapNo
				,0 AS BitmapId1
				,'' AS Note1
				,0 AS BitmapId2
				,'' AS Note2
				,0 AS BitmapId3
				,'' AS Note3
				,0 AS BitmapId4
				,'' AS Note4
				,0 AS BitmapId5
				,'' AS Note5
				,--DiagnosisCode1,                    
				--DiagnosisCode2,                    
				--DiagnosisCode3,        
				--added by shifali in ref to enable/disable service information/note tab based on saved service && doc status        
				70 AS SavedServiceStatus
				,0 AS SavedDocumentStatus
				,PC.MaxUnits
				,PC.MinUnits
				,--,SC.ScreenId                            
				--,SC.ScreenURL                             
				--,PC.ProcedureCodeId                  
				'' AS SpecificLocation
				,
				--Below new fields added BY Rakesh-II as to implement the copy service on 24 May,2012  
				s.DateOfService
				,s.EndDateOfService
				,s.DateTimeIn
				,s.DateTimeOut
				,s.AttendingId
				,s.ServiceId AS CopyServieId
			--end the  new column addition  
			FROM GroupClients GC
			INNER JOIN services s
				--Groups G  
				ON s.ClientId = GC.ClientId
			--added by shifali                  
			LEFT JOIN ProcedureCodes PC ON S.ProcedureCodeId = PC.ProcedureCodeId
			--modification by shifali ends here                  
			LEFT JOIN Clients ON GC.ClientId = Clients.ClientId
			WHERE
				--G.GroupId=@GroupID   
				S.GroupServiceId = @GroupServiceId
				AND isnull(s.RecordDeleted, 'N') = 'N'
				AND isnull(Clients.RecordDeleted, 'N') = 'N'
				AND isnull(GC.RecordDeleted, 'N') = 'N'
			ORDER BY [ClientName]

			---GroupServiceStaff---                                  
			--declare @CodeName varchar(100)  
			SELECT @CodeName = CodeName
			FROM Groups G
			INNER JOIN GlobalCodes GC ON G.UnitType = GC.GlobalCodeId
			WHERE GroupId = @GroupID
				AND isnull(G.RecordDeleted, 'N') = 'N'
				AND isnull(GC.RecordDeleted, 'N') = 'N'

			SELECT 'GroupServiceStaff' AS TableName
				,- 1 AS GroupServiceId
				,GSS.StaffId
				,GSS.Unit
				,GSS.UnitType
				--,GETDATE() as DateOfService     
				,GSS.EndDateOfService
				,GSS.DateOfService
				,GSS.RowIdentifier
				,GSS.CreatedBy
				,GSS.CreatedDate
				,GSS.ModifiedBy
				,GSS.ModifiedDate
				,GSS.RecordDeleted
				,GSS.DeletedDate
				,GSS.DeletedBy
				,Staff.LastName + ', ' + Staff.FirstName AS [StaffName]
				,GlobalCodes.CodeName
			FROM GroupServiceStaff GSS
			LEFT JOIN Staff ON GSS.StaffId = Staff.StaffId
			LEFT JOIN GlobalCodes ON GSS.UnitType = GlobalCodes.GlobalCodeId
			LEFT JOIN Documents D ON GSS.StaffId = D.AuthorId
				AND D.ClientId IS NULL
				AND D.ServiceId IS NULL
				AND D.GroupServiceId = @GroupServiceId
				AND ISNULL(D.RecordDeleted, 'N') = 'N'
			WHERE GSS.GroupServiceId = @GroupServiceId
				AND ISNULL(GSS.RecordDeleted, 'N') = 'N'

			----below code commented BY Rakesh-II on 24 May 2012 for copy Service                            
			--FROM  
			-- GroupStaff GS  
			-- JOIN Groups G  
			--  ON GS.GroupId = G.GroupId  
			-- JOIN Staff S  
			--  ON GS.StaffId = S.StaffId  
			--WHERE  
			-- isnull(GS.RecordDeleted, 'N') = 'N'  
			-- AND isnull(S.RecordDeleted, 'N') = 'N'  
			-- AND isnull(G.RecordDeleted, 'N') = 'N'  
			-- AND G.Groupid = @GroupID  
			SELECT 'GroupClients' AS TableName
				,GC.GroupClientId
				,GC.GroupId
				,GC.ClientId
				,GC.RowIdentifier
				,GC.CreatedBy
				,GC.CreatedDate
				,GC.ModifiedBy
				,GC.ModifiedDate
				,GC.RecordDeleted
				,GC.DeletedDate
				,GC.DeletedBy
				,CASE 
					WHEN ISNULL(Clients.ClientType, 'I') = 'I'
						THEN Clients.LastName + ', ' + Clients.FirstName
					ELSE Clients.OrganizationName
					END AS [ClientName]
				,'N' AS IsServiceError
				,'N' AS IsInitialize
				,0 AS DocumentId
				--,SC.ScreenId                            
				--,SC.ScreenURL                             
				--,PC.ProcedureCodeId                             
				,- 1 AS GroupServiceId
				,G.ProcedureCodeId
			FROM [GroupClients] GC
			LEFT JOIN Clients ON GC.ClientId = Clients.ClientId
			LEFT JOIN Groups G ON GC.GroupId = G.GroupId
			WHERE GC.GroupId = @GroupId
				AND isnull(GC.RecordDeleted, 'N') = 'N'
				AND isnull(Clients.RecordDeleted, 'N') = 'N'

			DROP TABLE #Notes
				--#endregion    
		END

		EXEC SSP_SCInitializeGroupServicesDSMCodes @GroupID
		
	

	--#region Pabitra 19 0ct 2016
	IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[scsp_InitGroupServiceDetailCustomFields]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
		BEGIN
  
	IF EXISTS(Select 1  FROM  sys.parameters WHERE object_id = object_id('scsp_InitGroupServiceDetailCustomFields') AND Name='@ClientList')
	BEGIN
	EXEC scsp_InitGroupServiceDetailCustomFields @ClientList  --- This line will be executed for Camino as @ClientList is the input parameter.
	END
	ELSE 
	IF EXISTS(Select 1  FROM  sys.parameters WHERE object_id = object_id('scsp_InitGroupServiceDetailCustomFields') AND Name='@GroupID')
	BEGIN
	 EXEC scsp_InitGroupServiceDetailCustomFields @GroupID    --- This line will be executed for MHP as @GroupID is the input parameter. 
	END	
END
--#endregion
	
			             
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = convert(VARCHAR, ERROR_NUMBER()) + '*****' 
		+ convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' 
		+ isnull(convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_InitGroupServices')
		 + '*****' + convert(VARCHAR, ERROR_LINE())
		  + '*****' + convert(VARCHAR, ERROR_SEVERITY()) 
		  + '*****' + convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                                                    
				16
				,-- Severity.                                                                                                                      
				1 -- State.                                                                                                                      
				);
	END CATCH
END
GO

