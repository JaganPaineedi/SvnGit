IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClientHealthData]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].ssp_GetClientHealthData
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetClientHealthData] (
	@ClientId INT
	,@HealthDataTemplateId INT
	,
	--3/Jan/2013 Mamta Gupta  Ref Task 59 - Primary Care - Summit Pointe              
	@StartDate DATETIME = NULL
	,@EndDate DATETIME = NULL
	)
	/********************************************************************************                                                                        
-- Stored Procedure: dbo.ssp_GetClientHealthData.sql                                                                          
--                                                                        
-- Copyright: Streamline Healthcate Solutions                                                                        
--                                                                        
-- Purpose: used to get client HealthData and Graph details              
--                                                                        
-- Updates:                                                                                                                               
-- Date   Author   Purpose                                                                        
-- Aug 17,2012 Varinder Verma Created.               
-- Sep 14,2012 Varinder Verma Modified all queries to filtered by ClientId and TemplateId              
-- Sep 18,2012 Varinder Verma Added query to fetch selected attribute details and get record date in descending order              
-- Sep 19,2012 Varinder Verma Added check to fetch Selected Attribute Details              
-- Sep 20,2012 Varinder Verma Made changes to show datetime and added validation of deleted records              
-- Sep 24,2012 Varinder Verma Made changes to show CodeName in place of Value.              
-- Oct 04,2012 Varinder Verma Set 'Order By' as mentioned into "HealthDataSubTemplateAttributes" table              
-- Oct 13,2012 Varinder Verma Cast ClientHealthDataAttributes.value to int call "csf_GetGlobalCodeNameById" function              
-- Oct 25,2012 Varinder Verma Made change into query to get 'SelectedAttributeDetails' in a row rather than multiple rows as per task #35("PrimaryCare Bugs/Features")              
-- Oct 29,2012 Varinder Verma Shows only those attribures in the Graph page's dropdown list which has the value for this client and AttributeType may be (Decimal,Numeric or Formula).              
--11/23/2012    VISHANT GARG    WHAT--ADD ORDER BY TO SORT THE DATA ACCORDING TO TEMPLATE NAME              
                                WHY--WITH REF TASK#116 PRIMARY CARE BUGS/FEATURES.              
--3/Jan/2013 Mamta Gupta  Ref Task 59 - Primary Care - Summit Pointe - StartDate and EndDate filter added  
--25/Feb/2013 Jagdeep      What: Added record deleted checks within date range  to maintain history.  
                           Why:Ref Task 44 - Primary Care Bugs/Features - as per comment kholtzman - 1/23/2013 11:58:33 AM.             
--3/march/2013   Vishant Garg    ref task#56 primary care summit pointe   --Added check for flowsheetspecifictoclient  
--                               previous changes was reverted by John Sudhakar.     
--26/march/2013  Rahul Aneja    ref task#264 in PRimary Care Bugs And Featurers    
--23/may/2013  Gayathri Naik  Task #1 in Philhaven Development.Datatype 50069 is repleced with 8088 Globalcodeid   
--05/June/2013   Gayathri Naik Task #24 in Core Bugs and Features.Flow sheet entry needs to use the 'Description'(Display name) instead of 'Name'  
        So adding the Description field to the tables.  
--05/Jan/2014    Bernrdin       Added GROUP BY HealthDataSubTemplateAttributes.OrderInFlowSheet ORDER BY HealthDataSubTemplateAttributes.OrderInFlowSheet to sort by flow shet order.  
--11/jan/2014    Bernardin      Reverted Previous changes and added HealthDataTemplateAttributes.EntryDisplayOrder  to display in flow sheet based on Sub template order  
--12/Jan/2014    Bernardin      Modified record deleted check for table HealthDataTemplateAttributes.RecordDeleted to avoid displaying deleted records.  
--Jun 23 2014  PradeepA  Modified to retrive HealthDataSubTemplateId from ClientHealthDataAttributes table.  
--Feb 25 2015    Aravind        Modified to filter the FlowSheet Data Based on ClientHealthDataAttributes.HealthDataTemplateId  
           Task #6.1 in WMU - Customization Issues Tracking - Support logs are pulling in from other flow sheet  
--june 9 2015    Hemant         Added column PatientPortal in the table HealthDataTemplates why:Flow Sheet #60 Macon County Design   
--June 6 2016  Chethan N	What : Retrieving Staff.DisplayAs to display in the header.   
--							Why : Keystone Environment Issues Tracking task# 84.  
--Aug 4 2016  Chethan N		What : Ignoring seconds in HealthRecordDate.   
--							Why : KCMHSAS - Support task# 600.  
--Oct 18 2016  Gautam       What: Added code to handle duplicate data migration for HealthRecordDate on same client
							why : Throwing error in .net code due to duplicate entry.KCMHSAS - Support #636
--25 12 2016   Lakshmi		What: Retrieving Staff.DisplayAs with 10 charecter 
							Why:  Woods - Support Go Live #442
--Feb 03 2017  Chethan N	What : Retrieving 9 characters of Staff.DisplayAs when Staff.DisplayAs length is more than 11 characters.     
--							Why : Woods - Support Go Live #442. 
--Mar 08 2017  Chethan N	What : Merged Changes made by Network180.
--							Why : Network180 Support Go Live #153.  
--June 01 2017  Manjunath K	What : Added DefaultDateRange column from HealthDataTemplates Table.
--							Why : Engineering Improvement Initiatives- NBL(I) #525.    
-- 09/08/2017  jcarlson     Keystone SGL 105: Performance Improvements.. reduced time from 56 seconds to 5 seconds in prod for 52460 records
											  wasif: add HealthDataTemplates the client has in addition to templates in the ClientTemplates table
-- 10/12/2018  MD			Reverted the logic of replacing DisplayAsAll with StaffId added by Jacob because Group By StaffId is displaying duplicate records on Flow Sheet.
							Why: 	Allegan - Support #1423											  
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		CREATE TABLE #FilteredAttributes (HealthDataAttributeId INT)

		CREATE TABLE #ClientHTAttributes (
			id INT identity(1, 1)
			,OldHealthRecordDate DATETIME
			,HealthRecordDate DATETIME
			,DisplayAs VARCHAR(120)
			,DisplayAsAll VARCHAR(120)    
			,DRank INT
			)

		IF EXISTS (
				SELECT 1
				FROM SystemConfigurations
				WHERE ISNULL(FlowSheetSpecificToClient, 'N') <> 'N'
				)
		BEGIN
			SELECT HDT.HealthDataTemplateId
				,HDT.TemplateName
				,HDT.Active
				,HDT.NumberOfColumns
				,HDT.CreatedBy
				,HDT.CreatedDate
				,HDT.ModifiedBy
				,HDT.ModifiedDate
				,HDT.RecordDeleted
				,HDT.DeletedDate
				,HDT.DeletedBy
				,HDT.PatientPortal
				,HDT.DefaultDateRange--June 01 2017  Manjunath K
			FROM HealthDataTemplates HDT
				where ISNULL(HDT.RecordDeleted, 'N') = 'N'
				AND HDT.Active = 'Y'
				and 
				(
				exists (select * from ClientTemplates CT where CT.HealthDataTemplateId = HDT.HealthDataTemplateId
				AND CT.ClientId = @ClientId
				AND ISNULL(CT.RecordDeleted, 'N') = 'N'
				AND ISNULL(CT.Active, 'N') <> 'N'
				)
				or  
				exists (select * from dbo.ClientHealthDataAttributes as chda where chda.HealthDataTemplateId = HDT.HealthDataTemplateId
							and chda.ClientId = @ClientId
						    and isnull(chda.RecordDeleted,
							'N') = 'N')
							)
			ORDER BY TemplateName		
		END
		ELSE
		BEGIN
			SELECT HealthDataTemplateId
				,TemplateName
				,Active
				,NumberOfColumns
				,CreatedBy
				,CreatedDate
				,ModifiedBy
				,ModifiedDate
				,RecordDeleted
				,DeletedDate
				,DeletedBy
				,PatientPortal
				,DefaultDateRange
			FROM HealthDataTemplates
			WHERE ISNULL(RecordDeleted, 'N') = 'N'
				AND Active = 'Y'
			ORDER BY TemplateName
		END

		-- Inserting filterd and unique Attributes into temp table for further filteration              
		INSERT INTO #FilteredAttributes
		SELECT HDSTA.HealthDataAttributeId
		FROM HealthDataTemplateAttributes HDTA
		INNER JOIN HealthDataTemplates HDT ON HDT.HealthDataTemplateId = HDTA.HealthDataTemplateId
		INNER JOIN HealthDataSubTemplateAttributes HDSTA ON HDSTA.HealthDataSubTemplateId = HDTA.HealthDataSubTemplateId
		INNER JOIN HealthDataSubTemplates HDST ON HDST.HealthDataSubTemplateId = HDSTA.HealthDataSubTemplateId
		INNER JOIN ClientHealthDataAttributes CHDA ON (
				CHDA.HealthDataSubTemplateId = HDST.HealthDataSubTemplateId
				AND CHDA.HealthDataAttributeId = HDSTA.HealthDataAttributeId
				AND (
					HDT.HealthDataTemplateId = CHDA.HealthDataTemplateId
					OR CHDA.HealthDataTemplateId IS NULL
					)
				)
		INNER JOIN HealthDataAttributes HDA ON HDa.HealthDataAttributeId = CHDA.HealthDataAttributeId
		WHERE HDT.HealthDataTemplateId = @HealthDataTemplateId
			AND CHDA.ClientId = @ClientId
			--AND ISNULL(HDSTA.DisplayInFlowSheet,'N') = 'Y' (This line is commented as per Task #44 - FlowSheet - Primary Care Bugs/Features)       
			AND ISNULL(HDT.RecordDeleted, 'N') = CASE 
				WHEN CAST(HDT.DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)
					AND CAST(HDT.DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)
					THEN 'Y'
				ELSE 'N'
				END
			AND HDT.Active = 'Y'
			AND ISNULL(HDTA.RecordDeleted, 'N') = CASE 
				WHEN CAST(HDTA.DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)
					AND CAST(HDTA.DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)
					THEN 'Y'
				ELSE 'N'
				END
			AND ISNULL(HDSTA.RecordDeleted, 'N') = CASE 
				WHEN CAST(HDSTA.DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)
					AND CAST(HDSTA.DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)
					THEN 'Y'
				ELSE 'N'
				END
			AND ISNULL(HDST.RecordDeleted, 'N') = CASE 
				WHEN CAST(HDST.DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)
					AND CAST(HDST.DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)
					THEN 'Y'
				ELSE 'N'
				END
			AND HDST.Active = 'Y'
			AND ISNULL(CHDA.RecordDeleted, 'N') = 'N'
			AND ISNULL(HDA.RecordDeleted, 'N') = CASE 
				WHEN CAST(HDA.DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)
					AND CAST(HDA.DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)
					THEN 'Y'
				ELSE 'N'
				END
			--3/Jan/2013 Mamta Gupta  Ref Task 59 - Primary Care - Summit Pointe              
			AND CAST(CHDA.HealthRecordDate AS DATE) BETWEEN CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)
				AND CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)
		GROUP BY HDSTA.HealthDataAttributeId

		-- Changes ends           
		--HealthDataAttributes with Graph Criteria              
		SELECT HDA.HealthDataAttributeId
			,hda.NAME
			,hda.Description
		FROM HealthDataAttributes HDA
		INNER JOIN HealthDataGraphCriteria HDGC ON HDGC.HealthDataAttributeId = HDA.HealthDataAttributeId
		INNER JOIN ClientHealthDataAttributes CHDA ON CHDA.HealthDataAttributeId = HDA.HealthDataAttributeId
		WHERE CHDA.ClientId = @ClientId
			AND HDA.DataType IN (
				8082
				,8083
				,8086
				) -- 8082=Decimal, 8083=Numeric, 8086=Formula              
			AND ISNULL(HDA.RecordDeleted, 'N') = CASE 
				WHEN CAST(HDA.DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)
					AND CAST(HDA.DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)
					THEN 'Y'
				ELSE 'N'
				END
			AND ISNULL(HDGC.RecordDeleted, 'N') = CASE 
				WHEN CAST(HDGC.DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)
					AND CAST(HDGC.DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)
					THEN 'Y'
				ELSE 'N'
				END
			--3/Jan/2013 Mamta Gupta  Ref Task 59 - Primary Care - Summit Pointe              
			AND CAST(CHDA.HealthRecordDate AS DATE) BETWEEN CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)
				AND CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)
		GROUP BY HDA.HealthDataAttributeId
			,hda.NAME
			,hda.Description

		INSERT INTO #ClientHTAttributes (
			OldHealthRecordDate
			,HealthRecordDate
			,DisplayAs
			,DisplayAsAll
			,DRank
			)
		SELECT CAST(CONVERT(VARCHAR(17), CHDA.HealthRecordDate, 121) + '00.000' AS DATETIME)
			,CAST(CONVERT(VARCHAR(17), CHDA.HealthRecordDate, 121) + '00.000' AS DATETIME) AS HealthRecordDate
			,CASE 
				WHEN LEN(S.DisplayAs) >= 12
					THEN SUBSTRING(S.DisplayAs, 0, 10) + '...'
				ELSE S.DisplayAs
				END AS 'DisplayAs'
			,s.DisplayAs
			,ROW_NUMBER() OVER (
				PARTITION BY CHDA.HealthRecordDate ORDER BY CHDA.HealthRecordDate
				)
		FROM ClientHealthDataAttributes CHDA
		INNER JOIN #FilteredAttributes FA ON CHDA.HealthDataAttributeId = FA.HealthDataAttributeId
		INNER JOIN HealthDataTemplateAttributes HDTA ON HDTA.HealthDataSubTemplateId = CHDA.HealthDataSubTemplateId
		--network180 temporary hot fix to correct duplicate table error on flowsheet - CASE WHEN CHDA.ModifiedBy != CHDA.CreatedBy THEN CHDA.CreatedBy ELSE CHDA.ModifiedBy END
		LEFT JOIN STAFF S ON S.UserCode = CASE WHEN CHDA.ModifiedBy != CHDA.CreatedBy THEN CHDA.CreatedBy ELSE CHDA.ModifiedBy END --CHDA.ModifiedBy
		WHERE CHDA.ClientId = @ClientId
			AND ISNULL(CHDA.RecordDeleted, 'N') = 'N'
			AND HDTA.HealthDataTemplateId = @HealthDataTemplateId
			AND (
				CHDA.HealthDataTemplateId = @HealthDataTemplateId
				OR CHDA.HealthDataTemplateId IS NULL
				)
			--3/Jan/2013 Mamta Gupta  Ref Task 59 - Primary Care - Summit Pointe              
			AND CAST(CHDA.HealthRecordDate AS DATE) BETWEEN CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)
				AND CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)
		GROUP BY CHDA.HealthRecordDate
			,S.DisplayAs
		ORDER BY CHDA.HealthRecordDate DESC

		UPDATE c
		SET c.HealthRecordDate = DATEADD(MINUTE, c.DRank, c.HealthRecordDate)
		FROM #ClientHTAttributes c
		WHERE c.Drank >= 2

		SELECT HealthRecordDate
			,DisplayAs
		FROM #ClientHTAttributes

		-- Flow Sheet display   
		-- Modified By Bernardin for Venture Region 3.5 Implementation task # 450, Added HealthDataTemplateAttributes.EntryDisplayOrder  to display in flow sheet based on Sub template order           
		SELECT HDSTA.HealthDataSubTemplateId
			,HDST.NAME AS HealthDataSubTemplateName
			,ISNULL(HDST.IsHeading, 'N') AS IsHeading
			,HDSTA.HealthDataAttributeId
			,HDSTA.OrderInFlowSheet
			,HDA.NAME
			,HDA.Description
			,HDTA.EntryDisplayOrder
		FROM HealthDataTemplateAttributes HDTA
		INNER JOIN HealthDataSubTemplates HDST ON HDST.HealthDataSubTemplateId = HDTA.HealthDataSubTemplateId
		INNER JOIN HealthDataSubTemplateAttributes HDSTA ON Hdsta.HealthDataSubTemplateId = HDTA.HealthDataSubTemplateId
		INNER JOIN HealthDataAttributes HDA ON HDA.HealthDataAttributeId = HDSTA.HealthDataAttributeId
		INNER JOIN ClientHealthDataAttributes CHDA ON (
				CHDA.HealthDataAttributeId = HDSTA.HealthDataAttributeId
				AND CHDA.HealthDataSubTemplateId = HDSTA.HealthDataSubTemplateId
				)
		WHERE HDTA.HealthDataTemplateId = @HealthDataTemplateId
			AND (
				CHDA.HealthDataTemplateId = @HealthDataTemplateId
				OR CHDA.HealthDataTemplateId IS NULL
				)
			AND HDST.Active = 'Y'
			AND CHDA.ClientId = @ClientId
			--AND ISNULL(HDSTA.DisplayInFlowSheet,'N') = 'Y' (This line is commented as per Task #44 - FlowSheet - Primary Care Bugs/Features)     
			AND ISNULL(HDTA.RecordDeleted, 'N') = 'N'
			AND ISNULL(HDST.RecordDeleted, 'N') = CASE 
				WHEN CAST(HDST.DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)
					AND CAST(HDST.DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)
					THEN 'Y'
				ELSE 'N'
				END
			--AND ISNULL(HDSTA.RecordDeleted,'N')='N'  
			AND ISNULL(HDSTA.RecordDeleted, 'N') = CASE 
				WHEN CAST(HDSTA.DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)
					AND CAST(HDSTA.DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)
					THEN 'Y'
				ELSE 'N'
				END
			AND ISNULL(HDA.RecordDeleted, 'N') = CASE 
				WHEN CAST(HDA.DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)
					AND CAST(HDA.DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)
					THEN 'Y'
				ELSE 'N'
				END
			AND ISNULL(CHDA.RecordDeleted, 'N') = 'N'
			--3/Jan/2013 Mamta Gupta  Ref Task 59 - Primary Care - Summit Pointe              
			AND CAST(CHDA.HealthRecordDate AS DATE) BETWEEN CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)
				AND CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)
		GROUP BY HDSTA.HealthDataSubTemplateId
			,HDSTA.HealthDataAttributeId
			,HDTA.EntryDisplayOrder
			,HDSTA.OrderInFlowSheet
			,HDA.NAME
			,HDST.NAME
			,HDST.IsHeading
			,HDA.Description
		ORDER BY HDTA.EntryDisplayOrder
			,HDSTA.OrderInFlowSheet         

		SELECT DISTINCT CHDA.ClientHealthDataAttributeId
			,CHDA.HealthDataAttributeId
			,HDA.NAME
			,HDA.Description
			, ISNULL(gcValue.CodeName,CHDA.Value) AS 'Value'  
			,CASE 
				WHEN CH.DRank >= 2
					AND CHDA.HealthRecordDate = CH.OldHealthRecordDate
					THEN CH.HealthRecordDate
				ELSE CHDA.HealthRecordDate
				END AS HealthRecordDate
			,CHDA.CreatedBy
			,CHDA.CreatedDate
			,CHDA.ModifiedBy
			,CHDA.ModifiedDate
			,CHDA.RecordDeleted
			,CHDA.DeletedDate
			,CHDA.DeletedBy
			,CHDA.HealthDataSubTemplateId
		FROM ClientHealthDataAttributes CHDA
		INNER JOIN #FilteredAttributes FA ON FA.HealthDataAttributeId = CHDA.HealthDataAttributeId
		INNER JOIN HealthDataAttributes HDA ON HDa.HealthDataAttributeId = FA.HealthDataAttributeId
		INNER JOIN HealthDataTemplateAttributes HDTA ON HDTA.HealthDataSubTemplateId = CHDA.HealthDataSubTemplateId
		LEFT JOIN STAFF S ON S.UserCode = CHDA.ModifiedBy
  LEFT JOIN #ClientHTAttributes CH ON ch.DisplayAsAll = s.DisplayAs
						AND ch.DRank >= 2      
						AND CH.OldHealthRecordDate = CHDA.HealthRecordDate
  LEFT JOIN GlobalCodes AS gcValue ON CASE WHEN hda.DataType IN ( 8081,8088) THEN FLOOR(CHDA.Value) ELSE 0 END= gcValue.GlobalCodeId 
		WHERE CHDA.ClientId = @ClientId
			AND ISNULL(CHDA.RecordDeleted, 'N') = 'N'
			AND HDTA.HealthDataTemplateId = @HealthDataTemplateId
			AND (
				CHDA.HealthDataTemplateId = @HealthDataTemplateId
				OR CHDA.HealthDataTemplateId IS NULL
				)
			--3/Jan/2013 Mamta Gupta  Ref Task 59 - Primary Care - Summit Pointe   and CAST(CHDA.HealthRecordDate as DATE) between CAST(ISNULL(@StartDate,'01/01/1753') as Date)  and CAST(ISNULL(@EndDate,'01/01/2999') AS Date)              
			AND ISNULL(CHDA.RecordDeleted, 'N') = 'N'              
			AND ISNULL(HDA.RecordDeleted, 'N') = CASE 
				WHEN CAST(HDA.DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)
					AND CAST(HDA.DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)
					THEN 'Y'
				ELSE 'N'
				END
			AND ISNULL(HDTA.RecordDeleted, 'N') = CASE 
				WHEN CAST(HDTA.DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)
					AND CAST(HDTA.DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)
					THEN 'Y'
				ELSE 'N'
				END

		--SelectedAttributeDetails              
		SELECT DISTINCT OCHDA.HealthdataAttributeId
			,CASE 
				WHEN CH.DRank >= 2
					AND OCHDA.HealthRecordDate = CH.OldHealthRecordDate
					THEN CH.HealthRecordDate
				ELSE OCHDA.HealthRecordDate
				END AS HealthRecordDate
			,OHDA.Description
			,OCHDA.Value
			,OCHDA.SubTemplateCompleted
			,OHDST.NAME
			,S.DisplayAs
			,CH.DRank
			,MAX(OHDA.DataType) as [DataType]
		INTO #SelectedAttributeDetails
		FROM ClientHealthDataAttributes OCHDA
		INNER JOIN #FilteredAttributes FA ON FA.HealthdataAttributeId = OCHDA.HealthDataAttributeId
		INNER JOIN HealthDataAttributes OHDA ON OHDA.HealthDataAttributeId = OCHDA.HealthDataAttributeId
		INNER JOIN HealthDataSubTemplates OHDST ON OHDST.HealthDataSubTemplateId = OCHDA.HealthDataSubTemplateId
		LEFT JOIN STAFF S ON S.UserCode = OCHDA.ModifiedBy
		LEFT JOIN #ClientHTAttributes CH ON ch.DisplayAsAll = s.DisplayAs
						AND ch.DRank >= 2      
						AND CH.OldHealthRecordDate = OCHDA.HealthRecordDate
		WHERE OCHDA.ClientId = @ClientId
			AND ISNULL(OCHDA.RecordDeleted, 'N') = 'N'
			AND ISNULL(OHDA.RecordDeleted, 'N') = CASE 
				WHEN CAST(OHDA.DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)
					AND CAST(OHDA.DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)
					THEN 'Y'
				ELSE 'N'
				END             
			AND ISNULL(OHDST.RecordDeleted, 'N') = CASE 
				WHEN CAST(OHDST.DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)
					AND CAST(OHDST.DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)
					THEN 'Y'
				ELSE 'N'
				END
			--3/Jan/2013 Mamta Gupta  Ref Task 59 - Primary Care - Summit Pointe              
			AND CAST(OCHDA.HealthRecordDate AS DATE) BETWEEN CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)
				AND CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)
		GROUP BY OCHDA.HealthdataAttributeId
			,OCHDA.HealthRecordDate
			,OHDA.Description
			,OCHDA.Value
			,OCHDA.SubTemplateCompleted
			,OHDST.NAME
			,S.DisplayAs
			,CH.HealthRecordDate
			,CH.OldHealthRecordDate
			,CH.DRank
			


		SELECT 
		HealthdataAttributeId,
		HealthRecordDate,
		CONVERT(VARCHAR(20), OCHDA.HealthRecordDate, 101) + '  ' + CONVERT(VARCHAR(20), CAST(OCHDA.HealthRecordDate AS TIME), 100) + ' Entered By : ' + DisplayAs + ' ' + Description + ': ' + CASE 

				WHEN (
						OCHDA.DataType = 8081
						OR OCHDA.DataType = 8088
						)
					THEN dbo.csf_GetGlobalCodeNameById(FLOOR(OCHDA.Value))
				ELSE OCHDA.Value
				END + -- 8081 ='DropDown', 8088="RadioButton'             
			' (' + OCHDA.NAME + ':' + SUBSTRING((
					SELECT ', (' + HDA.Description + ' ' + CASE 
							WHEN (
									MAX(HDA.DataType) = 8081
									OR MAX(HDA.DataType) = 8088
									)
								THEN dbo.csf_GetGlobalCodeNameById(FLOOR(CHDA.Value))
							ELSE CHDA.Value
							END + ')' -- 8081 ='DropDown', 8088="RadioButton'         
					FROM ClientHealthDataAttributes CHDA
					INNER JOIN HealthDataSubTemplates HDST ON HDST.HealthDataSubTemplateId = CHDA.HealthDataSubTemplateId
					INNER JOIN HealthDataAttributes HDA ON HDA.HealthDataAttributeId = CHDA.HealthDataAttributeId
					WHERE CHDA.HealthDataSubTemplateId IN (
							SELECT HealthDataSubTemplateId
							FROM HealthDataSubTemplateAttributes
							WHERE HealthDataAttributeId = OCHDA.HealthDataAttributeId
								AND ISNULL(RecordDeleted, 'N') = CASE 
									WHEN CAST(DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)
										AND CAST(DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)
										THEN 'Y'
									ELSE 'N'
									END
							GROUP BY HealthDataSubTemplateId
							)
						AND CHDA.ClientId = @ClientId
						AND ISNULL(CHDA.RecordDeleted, 'N') = 'N'
						AND CHDA.HealthRecordDate = OCHDA.HealthRecordDate  
						AND ISNULL(HDST.RecordDeleted, 'N') = CASE 
							WHEN CAST(HDST.DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)
								AND CAST(HDST.DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)
								THEN 'Y'
							ELSE 'N'
							END
						AND ISNULL(HDA.RecordDeleted, 'N') = CASE 
							WHEN CAST(HDA.DeletedDate AS DATE) >= CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)
								AND CAST(HDA.DeletedDate AS DATE) <= CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)
								THEN 'Y'
							ELSE 'N'
							END
						AND CHDA.Value NOT IN (
							'Y'
							,'N'
							)
						--3/Jan/2013 Mamta Gupta  Ref Task 59 - Primary Care - Summit Pointe              
						AND CAST(CHDA.HealthRecordDate AS DATE) BETWEEN CAST(ISNULL(@StartDate, '01/01/1753') AS DATE)
							AND CAST(ISNULL(@EndDate, '01/01/2999') AS DATE)
					GROUP BY HDST.NAME
						,HDA.Description
						,CHDA.Value
						,CHDA.HealthRecordDate
						,CHDA.SubTemplateCompleted
					FOR XML PATH('')
					), 2, 2500) + + ') ' + CASE 
				WHEN OCHDA.SubTemplateCompleted = 'Y'
					THEN ' Completed'
				ELSE ''
				END 'SelectedAttributeDetails'
		FROM #SelectedAttributeDetails OCHDA

		------------------------Added By Rahul Aneja ref task#264 in PRimary Care Bugs And Featurers------------  
		DECLARE @Gender CHAR(1)
			,@AGE INT
			,@FilterGraphCriteriaId INT

		SELECT @Gender = Sex
			,@AGE = DATEDIFF(day, DOB, GETDATE()) / 30
		FROM Clients
		WHERE ClientId = @clientId

		CREATE TABLE #HDGCriteira (
			HealthDataGraphCriteriaId INT
			,HealthDataAttributeId INT
			,NAME VARCHAR(200)
			,Description VARCHAR(200)
			,MaximumValue DECIMAL(18, 2)
			,MinimumValue DECIMAL(18, 2)
			,Priority INT
			);

		WITH HDGCriteira
		AS (
			SELECT HDGC.HealthDataGraphCriteriaId
				,HDGC.HealthDataAttributeId
				,HDA.NAME
				,HDA.Description
				,HDGC.MinimumValue
				,HDGC.MaximumValue
				,HDGC.AllAge
				,HDGC.AgeFrom
				,HDGC.AgeTo
				,HDGC.Priority
			FROM healthdatagraphcriteria HDGC
			LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = HDGC.Sex
			INNER JOIN #FilteredAttributes FA ON FA.HealthdataAttributeId = HDGC.HealthDataAttributeId
			INNER JOIN HealthDataAttributes HDA ON HDa.HealthDataAttributeId = HDGC.HealthDataAttributeId
			WHERE ISNULL(HDGC.RecordDeleted, 'N') = 'N'
				AND (
					HDGC.Sex = CASE 
						WHEN @Gender = 'M'
							THEN 8142
						WHEN @Gender = 'F'
							THEN 8143
						ELSE 8144
						END -- Both    
					OR HDGC.Sex = 8144
					) --  
				AND (
					@AGE BETWEEN HDGC.AgeFrom
						AND HDGC.AgeTo
					OR HDGC.AllAge = 'Y'
					)
				AND HDGC.MinimumValue >= 0
				AND HDGC.MaximumValue > 0
			)
			,MinPriority
		AS (
			SELECT MIN(Priority) Priority
				,HealthDataAttributeId
			FROM HDGCriteira
			GROUP BY HealthDataAttributeId
			)
		INSERT INTO #HDGCriteira
		SELECT HC.HealthDataGraphCriteriaId
			,hc.HealthDataAttributeId
			,HC.NAME
			,HC.Description
			,hc.MaximumValue
			,hc.MinimumValue
			,hc.Priority
		FROM HDGCriteira HC
		INNER JOIN MinPriority MP ON MP.Priority = HC.Priority
			AND MP.HealthDataAttributeId = HC.HealthDataAttributeId

		SELECT *
		FROM #HDGCriteira

		SELECT HDGCR.HealthDataGraphCriteriaRangeId
			,HDGCR.HealthDataGraphCriteriaId
			,HDGCR.LEVEL
			,HDGCR.MinimumValue
			,HDGCR.MaximumValue
			,GC.Color
		FROM HealthDataGraphCriteriaRanges HDGCR
		LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = HDGCR.LEVEL
		INNER JOIN #HDGCriteira HC ON HDGCR.HealthDataGraphCriteriaId = HC.HealthDataGraphCriteriaId
		WHERE ISNULL(HDGCR.RecordDeleted, 'N') = 'N'

		DROP TABLE #HDGCriteira
			--------------end Rahul Aneja here ----------------------------------------------------    
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetClientHealthData.sql') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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

