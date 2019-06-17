
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetPlanOfCareComponentXMLString]    Script Date: 06/09/2015 00:52:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetPlanOfCareComponentXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetPlanOfCareComponentXMLString]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_GetPlanOfCareComponentXMLString]    Script Date: 06/09/2015 00:52:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================          
-- Author:  Naveen P.          
-- Create date: Nov 07, 2014         
-- Description: Retrieves CCD Component XML for Plan of Care    
/*          
 Author   Modified Date   Reason          
 Naveen        11/07/2014              Initial    
*/
-- =============================================           
CREATE PROCEDURE [dbo].[ssp_GetPlanOfCareComponentXMLString] @ServiceId INT = NULL
	,@ClientId INT = NULL
	,@DocumentVersionId INT = NULL
	,@OutputComponentXML VARCHAR(MAX) OUTPUT
AS
BEGIN
	DECLARE @DefaultComponentXML VARCHAR(MAX) = 
		'<component>  
        <section>  
          <templateId root="2.16.840.1.113883.10.20.22.2.10"/>  
          <id root="2.201" extension="PlanOfCare"/>  
          <code code="18776-5" displayName="Plan of Care" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>  
          <title>Plan Of Care</title>  
          <text>  
            <table border="1" width="100%">  
              <thead>  
                <tr>  
                  <th>Type</th>  
                  <th>Target Date</th>  
                </tr>  
              </thead>  
              <tbody>  
                <tr>  
                  <td colspan="2">No Information Available</td>  
                </tr>  
              </tbody>  
            </table>  
          </text>  
          <entry>  
            <encounter moodCode="INT" classCode="ENC">  
              <templateId root="2.16.840.1.113883.10.20.22.4.40"/>  
              <id root="a8dae350-f295-4c89-aa07-9dcc3c036444"/>  
              <statusCode code="active"/>  
              <effectiveTime>  
                <center value="20141107"/>  
              </effectiveTime>  
            </encounter>  
          </entry>  
        </section>  
      </component>'
	DECLARE @COMPONENTXML VARCHAR(MAX) = '<component>    
   <section>    
    <templateId root="2.16.840.1.113883.10.20.22.2.10"/>    
    <id root="2.201" extension="PlanOfCare"/>    
    <code code="18776-5" displayName="Plan of Care" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC"/>    
    <title>Plan Of Care</title>    
    <text>    
     <table border="1" width="100%">    
      <thead>    
       <tr>    
        <th>Type</th>  
        <th>Target Date</th>             
       </tr>    
      </thead>    
      <tbody>###tr###</tbody>    
     </table>    
    </text>    
    ###ENTRY###    
   </section>    
  </component>'
	DECLARE @TRXML VARCHAR(MAX) = ''
	DECLARE @ENTRYXML VARCHAR(MAX) = ''
	DECLARE @ENTRYXMLTEMPLATE VARCHAR(MAX) = ''
	DECLARE @ENTRYXMLTEMPLATEMASTER VARCHAR(MAX) = '<entry>  
            <encounter moodCode="INT" classCode="ENC">  
              <templateId root="2.16.840.1.113883.10.20.22.4.40"/>  
              <id root="a8dae350-f295-4c89-aa07-9dcc3c036444"/>  
              <statusCode code="active"/>  
              <effectiveTime>  
                <center value="###TARGETDATE###"/>  
              </effectiveTime>  
			  <entryRelationship typeCode="SUBJ" inversionInd="true">
				<act
				   classCode="ACT"
				   moodCode="INT">
				   <templateId
					  root="2.16.840.1.113883.10.20.22.4.20"/>					   
					<code xsi:type="CE" code="##SNOMED##" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED-CT" displayName="##OBJECTIVETEXT##"/>  
				   <text></text>
				   <statusCode code="completed"/>
				</act>
			   </entryRelationship>
             </encounter>              
          </entry>'
	DECLARE @tResults TABLE (
		NeedID INT
		,GoalNumber INT
		,GoalText VARCHAR(MAX)
		,GoalStatus VARCHAR(MAX)
		,GoalStartDate VARCHAR(23)
		,ObjectiveNumber INT
		,ObjectiveText VARCHAR(MAX)
		)
	DECLARE @tGoals TABLE (
		GoalID INT
		,DocumentVersionId INT
		,GoalNumber INT
		,GoalText VARCHAR(MAX)
		,GoalStatus VARCHAR(MAX)
		,NeedID INT
		,GoalStartDate DATETIME
		)
	DECLARE @tObjectives TABLE (
		ObjectiveID INT
		,GoalId INT
		,ObjectiveNumber INT
		,ObjectiveText VARCHAR(MAX)
		,NeedID INT
		)
	DECLARE @APPT TABLE (
		ProcedureName VARCHAR(MAX)
		,AppointmentDate VARCHAR(max)
		,AppointmentTime VARCHAR(max)
		,Location VARCHAR(max)
		,Provider VARCHAR(max)
		)
	DECLARE @FutureTests TABLE (
		OrderDate VARCHAR(max)
		,OrderName VARCHAR(max)
		,Physician VARCHAR(max)
		,CPT VARCHAR(max)
		,LOINC VARCHAR(max)
		)
	DECLARE @FutureOrders TABLE (
		OrderDate VARCHAR(max)
		,OrderName VARCHAR(max)
		,Physician VARCHAR(max)
		,CPT VARCHAR(max)
		,LOINC VARCHAR(max)
		)
	DECLARE @EDUCATION TABLE (
		InfoType VARCHAR(max)
		,InfoValue VARCHAR(max)
		,EDUDesc VARCHAR(max)
		,EDUDoctype VARCHAR(max)
		,EduURL VARCHAR(max)
		,EduResID VARCHAR(max)
		)
	DECLARE @ProcedureName VARCHAR(MAX)
	DECLARE @AppointmentDate VARCHAR(max)
	DECLARE @AppointmentTime VARCHAR(max)
	DECLARE @Location VARCHAR(max)
	DECLARE @Provider VARCHAR(max)
	DECLARE @OrderDate VARCHAR(max)
	DECLARE @OrderName VARCHAR(max)
	DECLARE @Physician VARCHAR(max)
	DECLARE @LOINC VARCHAR(max)
	DECLARE @OrderDate1 VARCHAR(max)
	DECLARE @OrderName1 VARCHAR(max)
	DECLARE @Physician1 VARCHAR(max)
	DECLARE @LOINC1 VARCHAR(max)
	DECLARE @EDUDesc VARCHAR(max)
	DECLARE @EduURL VARCHAR(max)
	DECLARE @FilterString VARCHAR(MAX) = ''
		

	IF @ServiceId IS NULL
	BEGIN
		INSERT INTO @tGoals
		EXEC ssp_RDLClinicalSummaryGoals NULL
			,@ClientId
			,@DocumentVersionId
	END
	ELSE
	BEGIN
		INSERT INTO @tGoals
		EXEC ssp_RDLClinicalSummaryGoals @ServiceId
			,@ClientId
			,@DocumentVersionId
	END
	
	IF @ServiceId > 0
	BEGIN
		SELECT @FilterString = FilterString
		FROM CSFilterData
		WHERE ServiceId = @ServiceId
	END
		
	DECLARE @GoalNumber VARCHAR(MAX)
	DECLARE @GoalText VARCHAR(MAX)
	DECLARE @GoalStatus VARCHAR(MAX)
	DECLARE @NeedID INT
	DECLARE @GoalStartDate VARCHAR(25)

	IF (
			(
				SELECT TOP 1 GoalId
				FROM @tGoals
				) <> 0
			)
	BEGIN
		DECLARE tCursor CURSOR FAST_FORWARD
		FOR
		SELECT GoalNumber
			,GoalText
			,GoalStatus
			,NeedID
			,GoalStartDate
		FROM @tGoals TDS

		OPEN tCursor

		FETCH NEXT
		FROM tCursor
		INTO @GoalNumber
			,@GoalText
			,@GoalStatus
			,@NeedID
			,@GoalStartDate

		WHILE (@@FETCH_STATUS = 0)
		BEGIN
			IF @ServiceId IS NULL
			BEGIN
				INSERT INTO @tObjectives
				EXEC ssp_RDLClinicalSummaryObjectives NULL
					,@ClientId
					,@DocumentVersionId
					,@NeedID
			END
			ELSE
			BEGIN
				INSERT INTO @tObjectives
				EXEC ssp_RDLClinicalSummaryObjectives @ServiceId
					,@ClientId
					,@DocumentVersionId
					,@NeedID
			END

			--PRINT 'NO ERROR'   
			FETCH NEXT
			FROM tCursor
			INTO @GoalNumber
				,@GoalText
				,@GoalStatus
				,@NeedID
				,@GoalStartDate
		END

		CLOSE tCursor

		DEALLOCATE tCursor

		--SELECT *
		--FROM @tGoals
		--SELECT *
		--FROM @tObjectives
		INSERT INTO @tResults
		SELECT T.NEEDID
			,T.GoalNumber
			,T.GoalText
			,CASE T.GoalStatus
				WHEN 'Y'
					THEN 'Active'
				WHEN 'N'
					THEN 'Inactive'
				ELSE ''
				END AS GoalStatus
			,isnull(CONVERT(VARCHAR(25), T.GoalStartDate, 112), '') AS GoalStartDate
			,O.ObjectiveNumber
			,O.ObjectiveText
		FROM @tGoals AS T
		LEFT JOIN @tObjectives AS O ON O.NeedID = T.NeedID

		DECLARE @tNeedID INT
		DECLARE @tGoalNumber INT
		DECLARE @tGoalText VARCHAR(MAX)
		DECLARE @tGoalStatus VARCHAR(MAX)
		DECLARE @tGoalStartDate VARCHAR(MAX)
		DECLARE @tObjectiveNumber INT
		DECLARE @tObjectiveText VARCHAR(MAX)
		DECLARE @tFinalPlanOfCare VARCHAR(MAX)
		DECLARE @loopCOUNT INT = 0

		DECLARE tCursor CURSOR FAST_FORWARD
		FOR
		SELECT NeedID
			,GoalNumber
			,GoalText
			,GoalStatus
			,GoalStartDate
			,ObjectiveNumber
			,ObjectiveText
		FROM @tResults TDS

		OPEN tCursor

		FETCH NEXT
		FROM tCursor
		INTO @tNeedID
			,@tGoalNumber
			,@tGoalText
			,@tGoalStatus
			,@tGoalStartDate
			,@tObjectiveNumber
			,@tObjectiveText

		WHILE (@@FETCH_STATUS = 0)
		BEGIN
			
			SET @tFinalPlanOfCare = 'Goal: ' + convert(VARCHAR(2), @tGoalNumber) + ' - ' + @tGoalText + '<br/>Objective: ' + Convert(VARCHAR(2), @tObjectiveNumber) + ' - ' + @tObjectiveText
			SET @TRXML = @TRXML + '<tr>'
			SET @TRXML = @TRXML + '<td>' + isnull(@tFinalPlanOfCare, '') + '</td>'
			SET @TRXML = @TRXML + '<td>' + convert(VARCHAR(23), @tGoalStartDate) + '</td>'
			SET @TRXML = @TRXML + '</tr>'
			SET @ENTRYXMLTEMPLATE = @ENTRYXMLTEMPLATEMASTER
			SET @ENTRYXMLTEMPLATE = REPLACE(@ENTRYXMLTEMPLATE, '###TARGETDATE###', ISNULL(convert(VARCHAR(23), @tGoalStartDate), ''))
			SET @ENTRYXMLTEMPLATE = REPLACE(@ENTRYXMLTEMPLATE, '##OBJECTIVETEXT##', @tGoalText + ' - ' + @tObjectiveText)

			IF (@tObjectiveText LIKE '%Diet%') OR (@tObjectiveText LIKE '%Weight%')
			BEGIN
				SET @ENTRYXMLTEMPLATE = REPLACE(@ENTRYXMLTEMPLATE, '##SNOMED##', '289169006')
			END
			ELSE IF @tGoalText LIKE '%smoking%'
			BEGIN
				SET @ENTRYXMLTEMPLATE = REPLACE(@ENTRYXMLTEMPLATE, '##SNOMED##', '225323000')
			END
			ELSE IF (@tObjectiveText LIKE '%resources%') or (@tGoalText LIKE 'asthma%')
			BEGIN
				SET @ENTRYXMLTEMPLATE = REPLACE(@ENTRYXMLTEMPLATE, '##SNOMED##', '406162001')
			END
			ELSE IF @tObjectiveText LIKE '%counseling%'
			BEGIN
				SET @ENTRYXMLTEMPLATE = REPLACE(@ENTRYXMLTEMPLATE, '##SNOMED##', '410418004')
			END
			ELSE
			BEGIN
				SET @ENTRYXMLTEMPLATE = REPLACE(@ENTRYXMLTEMPLATE, '##SNOMED##', 'UNK')
			END
			print @tGoalText
			print @tObjectiveText
			print @ENTRYXMLTEMPLATE
			
			SET @ENTRYXML = @ENTRYXML + @ENTRYXMLTEMPLATE
			
			IF @ServiceId > 0
			BEGIN
				IF EXISTS (
						SELECT *
						FROM dbo.fnSplit(@FilterString, ',') AS fs
						WHERE ITEM LIKE '%PlanofCare=N%'
						)
				BEGIN
					SET @TRXML = '<tr><th colspan="2">Plan of Care - No Information Available</th></tr>'					
					
					SET @ENTRYXML = '<entry>  
            <encounter moodCode="INT" classCode="ENC">  
              <templateId root="2.16.840.1.113883.10.20.22.4.40"/>  
              <id root="a8dae350-f295-4c89-aa07-9dcc3c036444"/>  
              <statusCode code="active"/>  
              <effectiveTime>  
                <center value="20141107"/>  
              </effectiveTime>  
            </encounter>  
          </entry>  '
				END			
			END
			FETCH NEXT
			FROM tCursor
			INTO @tNeedID
				,@tGoalNumber
				,@tGoalText
				,@tGoalStatus
				,@tGoalStartDate
				,@tObjectiveNumber
				,@tObjectiveText
		END

		CLOSE tCursor

		DEALLOCATE tCursor

		-- ADDITIONAL
		IF @ServiceId > 0 AND ISNULL(@FilterString,'') <> ''
		BEGIN
			
			IF EXISTS (
					SELECT *
					FROM dbo.fnSplit(@FilterString, ',') AS fs
					WHERE ITEM LIKE '%FutureOrders=Y%'
					)
			BEGIN
				-- Future Orders/Tests Initiated/Pending During Visit
				INSERT INTO @FutureTests
				EXEC ssp_RDLClinicalSummaryFutureOrdersTests @ServiceId
					,@ClientId
					,@DocumentVersionId

				DECLARE tCursor CURSOR FAST_FORWARD
				FOR
				SELECT OrderDate
					,OrderName
					,Physician
					,LOINC
				FROM @FutureTests TDS

				OPEN tCursor

				FETCH NEXT
				FROM tCursor
				INTO @OrderDate
					,@OrderName
					,@Physician
					,@LOINC

				WHILE (@@FETCH_STATUS = 0)
				BEGIN
					PRINT @OrderDate
					PRINT @OrderName
					PRINT @Physician
					PRINT @LOINC

					IF @loopCOUNT = 0
					BEGIN
						SET @TRXML = @TRXML + '<tr>'
						SET @TRXML = @TRXML + '<th colspan="2">Future Orders/Tests Initiated/Pending During Visit</th>'
						SET @TRXML = @TRXML + '</tr>'
					END

					SET @TRXML = @TRXML + '<tr>'
					SET @TRXML = @TRXML + '<td>' + isnull(@OrderDate + ' - ' + @Physician, '') + '</td>'
					SET @TRXML = @TRXML + '<td>' + isnull(@OrderName, '')

					IF @OrderName LIKE 'Chest%'
						SET @TRXML = @TRXML + ' (SNOMED - 168731009)'
					ELSE IF @OrderName LIKE 'HGB%'
						SET @TRXML = @TRXML + ' (LOINC - 30313-1)'
					ELSE IF @OrderName LIKE 'Colonoscopy%'
						SET @TRXML = @TRXML + ' (CPT - 45378)'
					SET @TRXML = @TRXML + '</td></tr>'
					SET @loopCOUNT = @loopCOUNT + 1

					FETCH NEXT
					FROM tCursor
					INTO @OrderDate
						,@OrderName
						,@Physician
						,@LOINC
				END

				CLOSE tCursor

				DEALLOCATE tCursor
			END
			ELSE
			BEGIN
				SET @TRXML = @TRXML + '<tr><th colspan="2">Future Orders/Tests Initiated/Pending During Visit - No Information Available</th></tr>'				
			END

			-- Orders/Tests Initiated/Pending During Visit
			IF EXISTS (
					SELECT *
					FROM dbo.fnSplit(@FilterString, ',') AS fs
					WHERE ITEM LIKE '%OrdersTests=Y%'
					)
			BEGIN
				INSERT INTO @FutureOrders
				EXEC ssp_RDLClinicalSummaryOrdersTests @ServiceId
					,@ClientId
					,@DocumentVersionId

				SET @loopCount = 0

				DECLARE tCursor CURSOR FAST_FORWARD
				FOR
				SELECT OrderDate
					,OrderName
					,Physician
					,LOINC
				FROM @FutureOrders TDS

				OPEN tCursor

				FETCH NEXT
				FROM tCursor
				INTO @OrderDate1
					,@OrderName1
					,@Physician1
					,@LOINC1

				PRINT @TRXML
				PRINT @OrderName1

				WHILE (@@FETCH_STATUS = 0)
				BEGIN
					IF @loopCOUNT = 0
					BEGIN
						SET @TRXML = @TRXML + '<tr>'
						SET @TRXML = @TRXML + '<th colspan="2">Orders/Tests Initiated/Pending During Visit</th>'
						SET @TRXML = @TRXML + '</tr>'
					END

					SET @TRXML = @TRXML + '<tr>'
					SET @TRXML = @TRXML + '<td>' + isnull(@OrderDate1 + ' - ' + @Physician1, '') + '</td>'
					SET @TRXML = @TRXML + '<td>' + isnull(@OrderName1, '')

					PRINT @OrderName
					PRINT @TRXML
					PRINT @LOINC1

					IF @OrderName1 LIKE 'Chest%'
						SET @TRXML = @TRXML + ' (SNOMED - 168731009)'
					ELSE IF @OrderName1 LIKE 'HGB%'
						SET @TRXML = @TRXML + ' (LOINC - 30313-1)'
					ELSE IF @OrderName1 LIKE 'SPUTUM%'
						SET @TRXML = @TRXML + ' (LOINC - 6460-0)'
					ELSE IF @OrderName1 LIKE 'Colonoscopy%'
						SET @TRXML = @TRXML + ' (CPT - 45378)'
						
						
					SET @TRXML = @TRXML + '</td></tr>'
					SET @loopCOUNT = @loopCOUNT + 1

					FETCH NEXT
					FROM tCursor
					INTO @OrderDate1
						,@OrderName1
						,@Physician1
						,@LOINC1
				END

				CLOSE tCursor

				DEALLOCATE tCursor
			END
			ELSE
			BEGIN
				SET @TRXML = @TRXML + '<tr><th colspan="2">Orders/Tests Initiated/Pending During Visit - No Information Available</th></tr>'				
			END

			-- Up Coming Appointments
			IF EXISTS (
					SELECT *
					FROM dbo.fnSplit(@FilterString, ',') AS fs
					WHERE ITEM LIKE '%UpComingAppointments=Y%'
					)
			BEGIN
				INSERT INTO @APPT
				EXEC ssp_RDLClinicalSummaryAppointments @ServiceId
					,@ClientId
					,@DocumentVersionId

				IF EXISTS (
						SELECT *
						FROM @APPT
						)
				BEGIN
					SET @loopCount = 0

					DECLARE tCursor CURSOR FAST_FORWARD
					FOR
					SELECT ProcedureName
						,AppointmentDate
						,AppointmentTime
						,LOCATION
						,Provider
					FROM @APPT TDS

					OPEN tCursor

					FETCH NEXT
					FROM tCursor
					INTO @ProcedureName
						,@AppointmentDate
						,@AppointmentTime
						,@LOCATION
						,@Provider

					WHILE (@@FETCH_STATUS = 0)
					BEGIN
						IF @loopCOUNT = 0
						BEGIN
							SET @TRXML = @TRXML + '<tr>'
							SET @TRXML = @TRXML + '<th colspan="2">Up Coming Appointments</th>'
							SET @TRXML = @TRXML + '</tr>'
						END

						SET @TRXML = @TRXML + '<tr>'
						SET @TRXML = @TRXML + '<td>' + isnull(@AppointmentDate + ' ' + @AppointmentTime + ' : ' + @ProcedureName, '') + '</td>'
						SET @TRXML = @TRXML + '<td>' + isnull(@Provider + ' - ' + @LOCATION, '')
						SET @TRXML = @TRXML + '</td></tr>'
						SET @loopCOUNT = @loopCOUNT + 1

						FETCH NEXT
						FROM tCursor
						INTO @ProcedureName
							,@AppointmentDate
							,@AppointmentTime
							,@LOCATION
							,@Provider
					END

					CLOSE tCursor

					DEALLOCATE tCursor
				END
				ELSE
				BEGIN
					SET @TRXML = @TRXML + '<tr><th colspan="2">Up Coming Appointments - No Information Available</th></tr>'					
				END
			END
			ELSE
			BEGIN
				SET @TRXML = @TRXML + '<tr><th colspan="2">Up Coming Appointments - No Information Available</th></tr>'				
			END

			-- Patient Education/Decision Aides
			IF EXISTS (
					SELECT *
					FROM dbo.fnSplit(@FilterString, ',') AS fs
					WHERE ITEM LIKE '%UpComingAppointments=Y%'
					)
			BEGIN
				INSERT INTO @EDUCATION
				EXEC ssp_RDLClinicalSummaryEducationResource @ServiceId
					,@ClientId
					,@DocumentVersionId

				IF EXISTS (
						SELECT *
						FROM @EDUCATION
						)
				BEGIN
					SET @loopCount = 0

					DECLARE tCursor CURSOR FAST_FORWARD
					FOR
					SELECT EDUDesc
						,EduURL
					FROM @EDUCATION TDS

					OPEN tCursor

					FETCH NEXT
					FROM tCursor
					INTO @EDUDesc
						,@EduURL

					WHILE (@@FETCH_STATUS = 0)
					BEGIN
						IF @loopCOUNT = 0
						BEGIN
							SET @TRXML = @TRXML + '<tr>'
							SET @TRXML = @TRXML + '<th colspan="2">Patient Education/Decision Aides</th>'
							SET @TRXML = @TRXML + '</tr>'
						END

						SET @TRXML = @TRXML + '<tr>'
						SET @TRXML = @TRXML + '<td>' + isnull(@EDUDesc + ' ' + @EduURL, '') + '</td>'
						SET @TRXML = @TRXML + '</tr>'
						SET @loopCOUNT = @loopCOUNT + 1

						FETCH NEXT
						FROM tCursor
						INTO @EDUDesc
							,@EduURL
					END

					CLOSE tCursor

					DEALLOCATE tCursor
				END
				ELSE
				BEGIN
					SET @TRXML = @TRXML + '<tr><th colspan="2">Patient Education/Decision Aides - No Information Available</th></tr>'					
				END
			END
			ELSE
			BEGIN
				SET @TRXML = @TRXML + '<tr><th colspan="2">Patient Education/Decision Aides - No Information Available</th></tr>'				
			END
		END

		SET @COMPONENTXML = REPLACE(@COMPONENTXML, '###tr###', @TRXML)
		SET @COMPONENTXML = REPLACE(@COMPONENTXML, '###ENTRY###', @ENTRYXML)
		SET @OutputComponentXML = @COMPONENTXML
	END
	ELSE
	BEGIN
		SET @OutputComponentXML = @DefaultComponentXML
	END
END


GO

