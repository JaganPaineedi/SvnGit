/****** Object:  StoredProcedure [dbo].[ssp_GetHistoryOfProceduresXMLString]    Script Date: 09/22/2017 18:51:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetHistoryOfProceduresXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetHistoryOfProceduresXMLString]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetHistoryOfProceduresXMLString]    Script Date: 09/22/2017 18:51:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetHistoryOfProceduresXMLString] @ClientId INT = NULL    
 ,@Type VARCHAR(10) = NULL    
 ,@DocumentVersionId INT = NULL    
 ,@FromDate DATETIME = NULL    
 ,@ToDate DATETIME = NULL   
 ,@OutputComponentXML VARCHAR(MAX) OUTPUT 
-- =============================================                             
/*                  
 Author   Added Date   Reason   Task                  
 Vijay    05/09/2017   Initial  MUS3 - Task#25.4 Transition of Care - CCDA Generation    
*/ 
AS  
BEGIN  
 DECLARE @DefaultComponentXML VARCHAR(MAX) =   
   '<component>
		<section>
			<!-- Procedures Section (entries required) (V2) -->
			<templateId root="2.16.840.1.113883.10.20.22.2.7.1" extension="2014-06-09"/>
			<templateId root="2.16.840.1.113883.10.20.22.2.7.1"/>
			<code code="47519-4" codeSystem="2.16.840.1.113883.6.1" codeSystemName="LOINC" displayName="HISTORY OF PROCEDURES"/>
			<title>PROCEDURES</title>
			<text>
				<paragraph ID="Proc1">No Procedure information</paragraph>
			</text>
			<entry>
				<procedure classCode="PROC" moodCode="EVN" negationInd="true">
					<!-- Procedure Activity Procedure (V2)-->
					<templateId root="2.16.840.1.113883.10.20.22.4.14" extension="2014-06-09"/>
					<templateId root="2.16.840.1.113883.10.20.22.4.14"/>
					<id root="d5b614bd-01ce-410d-8727-e1fd01dcc72a" />
					<code code="71388002" codeSystem="2.16.840.1.113883.6.96" displayName="Procedure">
						<originalText>
							<reference value="#Proc1" />
						</originalText>
					</code>
					<statusCode code="completed" />
					<effectiveTime nullFlavor="NA" />
					<participant typeCode="DEV">
						<participantRole classCode="MANU">
							<templateId root="2.16.840.1.113883.10.20.22.4.37"/>
							<id nullFlavor="NA" root="2.16.840.1.113883.3.3719"/>
							<playingDevice>
								<code code="40388003" codeSystem="2.16.840.1.113883.6.96" displayName="Implant"/>
							</playingDevice>
							<scopingEntity>
								<id root="2.16.840.1.113883.3.3719"/>
							</scopingEntity>
						</participantRole>
					</participant>
				</procedure>
			</entry>
		</section>
	</component>'  
   
  SET @OutputComponentXML = NULL
  IF EXISTS (  
  SELECT *  
  FROM sys.objects  
  WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetSOCFunctionalCognitiveDetails]')  
   AND type IN (  
    N'P'  
    ,N'PC'  
    )  
  )  
  BEGIN  
   EXEC csp_GetHistoryOfProceduresXMLString @ClientId  
    ,@Type  
    ,@DocumentVersionId  
    ,@FromDate  
    ,@ToDate  
    ,@OutputComponentXML OUTPUT 
  END  
  
  IF @OutputComponentXML IS NULL OR @OutputComponentXML = '' 
  BEGIN  
   SET @OutputComponentXML = @DefaultComponentXML  
  END
  
END  
  
GO


