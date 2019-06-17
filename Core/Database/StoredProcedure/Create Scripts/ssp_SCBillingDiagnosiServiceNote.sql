 IF EXISTS ( SELECT *
             FROM   sys.objects
             WHERE  object_id = OBJECT_ID(N'[dbo].[ssp_SCBillingDiagnosiServiceNote]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].[ssp_SCBillingDiagnosiServiceNote]
GO

 CREATE PROCEDURE [dbo].[ssp_SCBillingDiagnosiServiceNote]  --42103,'4/28/2012 1:30:40 PM'
    @varClientId INT ,
    @varDate DATETIME = NULL ,
    @varProgramId INT = NULL		-- Added by Avi Goyal on 23 April 2014
 AS /*********************************************************************/            
/* Stored Procedure: dbo.ssp_BillingDiagnosiServiceNote                */            
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */            
/* Creation Date:    7/24/05                                         */            
/*                                                                   */            
/* Purpose:  it will return the biling diagnosis for the service note  */            
/*                                                                   */          
/* Input Parameters: @varClientId             */          
/*                                                                   */            
/* Output Parameters:   None                   */            
/*                                                                   */            
/* Return:  0=success, otherwise an error number                     */            
/*                                                                   */            
/* Called By:                                                        */            
/*                                                                   */            
/* Calls:                                                            */            
/*                                                                   */            
/* Data Modifications:                                               */            
/*                                                                   */            
/* Updates:                                                          */            
/*  Date			Author			Purpose																							*/ 
/*  --------------------------------------------------------------------------------------------------------------------------------*/           
/*  7/24/05			Vikas			Created																							*/ 
/*  13 March 2014	SuryaBalan		wrf 376 Customization Bugs. Added Columns [Version],DiagnosisOrder in Select Query				*/ 
/*	22 Apr 2014		Avi Goyal		Added an optional parameter @varProgramId (Logic to be added later) (Task# 1455 in Core Bugs)	*/    
/*  26 May 2014		Vithobha		Added an Logic to Pull data from ICD10	Diagnosis Engineering Improvement Initiatives- NBL(I): #1419 8 Diagnosis Codes*/         
/*	01 Oct 2014		Akwinass		Order column Included in #BillingDiagnoses table (Task# 1419 in Engineering Improvement Initiatives- NBL(I))	*/             
/*	05 Nov 2014		Akwinass		Order Logic Implemented (Task# 1419 in Engineering Improvement Initiatives- NBL(I))	*/             
/*	07 Nov 2014		Akwinass		Included Condition to check Client Problem List and Diagnosis Catagories (Task# 1419 in Engineering Improvement Initiatives- NBL(I))	*/             
/*	31 Dec 2014     Akwinass        Used 'DiagnosisICD10Codes' table instead DiagnosisDSMVCodes as per new ICD10 logic to avoid build error (Task #1419.09 in Engineering Improvement Initiatives- NBL(I)) */
/*	01 April 2015   Akwinass        Default Order for Billable Diagnosis when "All Diagnosis Category" is selected (Task #1419 in Engineering Improvement Initiatives- NBL(I)) */
/*	07 April 2015   Akwinass        Order initialization logic is modified based on System Configuration Key(INITIALIZEDIAGNOSISORDER) (Task #1419 in Engineering Improvement Initiatives- NBL(I)) */
/*	17 April 2015   Akwinass        Blank order initialization is Implmented using Key (INITIALIZEDIAGNOSISORDER)(Task #1419 in Engineering Improvement Initiatives- NBL(I)) */
/*  31 July 2015    Bernardin       Modified "DSMVCodeId" column to ICD10CodeId*/
/*  19 Aug  2015	NJain			Updated to Get latest diagnoses on or before the date of service
									Update to always initialize Primary Diagnosis as Order = 1							*/
/*	29 Oct 2015		T.Remisoski		Update to allow documents that now host DSMV still initalize order > 1 into ServiceDiagnosis.  Task ARM - Suppport #373 */
/*  15 DEC 2015		Akwinass		Included RuleOut Condition based on System Configuration Key 'INCLUDEBILLINGDIAGNOSISRULEOUT' (Task #384 in A Renewed Mind - Support) */
/*  22 DEC 2015		Akwinass		Updated [Order] = NULL when INITIALIZEDIAGNOSISORDER = 'B' (Task #277 in Engineering Improvement Initiatives- NBL(I)) */
/*  15 Sep 2016		Vamsi     		Added condition to check Billable or not  wrt MFS - Customization Issue Tracking#955  */
/*  28 June 2017    Bernardin       Customized as per Camino requirement.Camino wants to select both billable on non billable diagnosis.If the System Configuration Key 'BILLABLEDIAGNOSISONLY" value='Y' then select only billable values else select both. Camino - Support Go Live# 454*/
/*
Lakshmi     - 17/10/2017 -         What: Added upadte statement to avoid to insert negative DSMVCodeId into service diagnisis table.
								   Why:  Thresholds - Support #1050
/*  02 Nov 2017		Sunil.D		   Removed new parameter @varServiceId added by ponnin on 11 Nov 2015. 
                                   Why: Specialty Psych Progress Note-Billing diagnosis issue.For task : #2050.8 - Renaissance - Dev Items*/
*/
/*  12 MAR 2018		Akwinass	   Added code to skip diagnosis documents when "NoteReplacement" column value is "Y" in Services table (Task #589.1 in Engineering Improvement Initiatives- NBL(I)) */
/*  23 MAY 2018		Rajeshwari S   Converting datetime to date format to get latest signed diagnosis. (Task #631 - MHP-Support Go Live).*/
/*  13 Dec 2018		Irfan		   What: Corrected the condition where these parameters '@UseDiagnosisDocument','@DiagnosisDocumentCategory' are being used to initialize the diagnosis.
								   Why:  Type missing in the conditions where these parameters '@UseDiagnosisDocument','@DiagnosisDocumentCategory' are being used due to this the logic was not
										 executing and not initializing the diagnosis into the ServiceNote as per the task Unison - EIT-#516	  */
/************************************************************************************************************************************/  
    BEGIN          
    
        DECLARE @DiagnosisDocumentCodeID INT   
        DECLARE @CurDiagnosisDocumentCodeID INT 
        DECLARE @LatestDiagnosisDocumentVersionId INT        
		DECLARE @RuleOut CHAR(1)
		
		-- Added by Bernardin on 28 June 2017
		DECLARE @BillableOnly CHAR(1) 
		
		SELECT TOP 1 @BillableOnly = CASE WHEN ISNULL(Value, 'N') = 'N' THEN 'N' ELSE 'Y' END
		FROM SystemConfigurationKeys
		WHERE [key] = 'BILLABLEDIAGNOSISONLY'
			AND ISNULL(RecordDeleted, 'N') = 'N'
       -- Changes end here
		SELECT TOP 1 @RuleOut = CASE WHEN ISNULL(Value, 'N') = 'N' THEN 'N' ELSE 'Y' END
		FROM SystemConfigurationKeys
		WHERE [key] = 'INCLUDEBILLINGDIAGNOSISRULEOUT'
			AND ISNULL(RecordDeleted, 'N') = 'N'
          
        CREATE TABLE #BillingDiagnoses
            (
              DocumentId INT ,
              DSMCode CHAR(6) ,
              DSMNumber INT ,
              Version INT ,
              EffectiveDate DATETIME ,
              DiagnosisOrder INT ,
              SortOrder INT ,
              ICD10Code VARCHAR(20) ,
              ICD9Code VARCHAR(20) ,
              DSMVCodeId INT ,
              Description VARCHAR(500) ,
 --	01 Oct 2014		Akwinass
              [Order] INT ,
 --	05 Nov 2014		Akwinass
              [Billable] CHAR(1)
            )          
          
        DECLARE @varDocumentid INT ,
            @varVersion INT ,
            --@varVersion10 INT ,
            @varEffectiveDate DATETIME                
        IF ( @varDate IS NULL )
            SET @varDate = GETDATE()                
                
--get document,version from diagnosis  according to Date                
--Select top 1 @varDocumentid = a.DocumentId, @varVersion = a.CurrentVersion         
--SELECT TOP 1 @varVersion =CurrentDocumentVersionId from DiagnosesIAndII DI,Documents Doc                                                                                       
--  where DI.DocumentVersionId=Doc.CurrentDocumentVersionId and Doc.ClientId=@varClientId                     
-- and Doc.Status=22  and IsNull(DI.RecordDeleted,'N')='N' and IsNull(Doc.RecordDeleted,'N')='N'AND       
--  Doc.EffectiveDate <= convert(datetime, convert(varchar, @varDate,101))                         
-- ORDER BY Doc.EffectiveDate DESC,Doc.ModifiedDate desc       
     
        --SELECT TOP 1
        --        @varVersion10 = CurrentDocumentVersionId
        --FROM    DocumentDiagnosisCodes DI ,
        --        Documents Doc
        --WHERE   DI.DocumentVersionId = Doc.CurrentDocumentVersionId
        --        AND Doc.ClientId = @varClientId
        --        AND Doc.Status = 22
        --        AND ISNULL(DI.RecordDeleted, 'N') = 'N'
        --        AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
        --        AND Doc.EffectiveDate <= CONVERT(DATETIME, CONVERT(VARCHAR, @varDate, 101))
        --ORDER BY Doc.EffectiveDate DESC ,
        --        Doc.ModifiedDate DESC       
              
--Select top 1 @varDocumentid = a.DocumentId, @varVersion = a.CurrentDocumentVersionId        
--from Documents a                
--where a.ClientId = @varClientId                
--and a.EffectiveDate <= convert(datetime, convert(varchar, @varDate,101))                
--and a.Status = 22                
--and a.DocumentCodeId =5           
--and isNull(a.RecordDeleted,'N')<>'Y'                
--order by a.EffectiveDate desc, a.ModifiedDate desc   

--05 Nov 2014 Akwinass Added Below Logic for Task #1419 in Engineering Improvement Initiatives- NBL(I)
        DECLARE @UseProblemListForDiagnosis CHAR(1) ,
            @UseDiagnosisDocument CHAR(1) ,
            @DiagnosisDocumentCategory CHAR(1) ,
            @ProgramId INT

        SET @ProgramId = @varProgramId
        IF @ProgramId = NULL
            BEGIN
                SET @ProgramId = 0
            END 

        IF @ProgramId > 0
            BEGIN
                SELECT  @UseProblemListForDiagnosis = UseProblemListForDiagnosis ,
                        @UseDiagnosisDocument = UseDiagnosisDocument ,
                        @DiagnosisDocumentCategory = DiagnosisDocumentCategoryAll
                FROM    Programs
                WHERE   ProgramId = @ProgramId
            END  

--26 May 2014		Vithobha added below logic Suggested by Wasif for ICD10 Diagnosis    
        SET @LatestDiagnosisDocumentVersionId = ( SELECT TOP 1
                                                            CurrentDocumentVersionId
                                                  FROM      Documents a
                                                            INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeid = a.DocumentCodeid
                                                  WHERE     a.ClientId = @varClientId
                                                            AND a.Status = 22
                                                            AND Dc.DiagnosisDocument = 'Y'
                                                            AND CAST(a.EffectiveDate AS DATE) <= CAST(@varDate AS DATE)     --Rajeshwari S
                                                            AND ISNULL(a.RecordDeleted, 'N') <> 'Y'
                                                            AND ISNULL(Dc.RecordDeleted, 'N') <> 'Y'
                                                            --12 MAR 2018		Akwinass
                                                            AND NOT EXISTS(SELECT 1 FROM Services S WHERE S.ServiceId = a.ServiceId AND ISNULL(S.RecordDeleted, 'N') = 'N' AND ISNULL(S.NoteReplacement, 'N') = 'Y')
                                                  ORDER BY  a.EffectiveDate DESC ,
                                                            a.ModifiedDate DESC
                                                )        
      
--26 May 2014		Vithobha added else part for ICD10	Diagnosis       
        SET @DiagnosisDocumentCodeID = ( SELECT TOP 1
                                                DocumentCodeId
                                         FROM   Documents
                                         WHERE  CurrentDocumentVersionId = @LatestDiagnosisDocumentVersionId
                                       )      
        SET @CurDiagnosisDocumentCodeID = ( SELECT TOP 1
                                                    DocumentCodeId
                                            FROM    DocumentCodes
                                            WHERE   DocumentCodeId = @DiagnosisDocumentCodeID
                                                    AND DSMV = 'Y'
                                          )
        IF ( @CurDiagnosisDocumentCodeID IS NULL )
            BEGIN 
	    --07 Nov 2014 Akwinass
                IF ( ISNULL(@UseDiagnosisDocument, 'N') = 'N'
                     AND ISNULL(@UseProblemListForDiagnosis, 'N') = 'N'
                   )
                    OR ISNULL(@UseDiagnosisDocument, 'N') = 'Y'
                    OR @ProgramId <= 0
                    BEGIN           
                        INSERT  INTO #BillingDiagnoses
                                ( DSMCode ,
                                  DsmNumber ,
                                  SortOrder ,
                                  DiagnosisOrder ,
                                  Description ,
                                  Billable
                                )
                                SELECT  D.DSMCode ,
                                        D.DSMNumber ,
                                        CASE WHEN DiagnosisType = 140 THEN 1
                                             ELSE 2
                                        END AS SortOrder ,
                                        DiagnosisOrder ,
                                        DD.DSMDescription ,
                                        ISNULL(D.Billable, 'N')
                                FROM    dbo.DiagnosesIAndII D
                                        JOIN DiagnosisDSMDescriptions DD ON DD.DSMCode = D.DSMCode
                                                                            AND DD.DSMNumber = D.DSMNumber
                                WHERE   DocumentVersionId = @LatestDiagnosisDocumentVersionId
                                        AND ISNULL(D.RecordDeleted, 'N') = 'N' 
                                        AND (ISNULL(D.RuleOut, 'N') = @RuleOut OR @RuleOut = 'Y')
                    END     
              
                IF ISNULL(@UseProblemListForDiagnosis, 'N') = 'Y'
                    BEGIN
			
                        INSERT  INTO #BillingDiagnoses
                                ( DSMCode ,
                                  DsmNumber ,
                                  Description ,
                                  Billable
                                )
                                SELECT  CP.DSMCode ,
                                        NULL ,
                                        DC.ICDDescription ,
                                        'N'
                                FROM    ClientProblems CP
                                        JOIN DiagnosisICDCodes DC ON CP.DSMCode = DC.ICDCode
                                                                     AND ISNULL(CP.RecordDeleted, 'N') = 'N'
                                WHERE   CP.ClientId = @varClientId
                                        AND CP.DSMCode NOT IN ( SELECT DISTINCT
                                                                        DSMCode
                                                                FROM    #BillingDiagnoses )
                    END
        
            END     
        ELSE
            BEGIN 
		--07 Nov 2014 Akwinass
                IF ( ISNULL(@UseDiagnosisDocument, 'N') = 'N'
                     AND ISNULL(@UseProblemListForDiagnosis, 'N') = 'N'
                   )
                    OR ISNULL(@UseDiagnosisDocument, 'N') = 'Y'
                    OR @ProgramId <= 0
                    BEGIN		
                        INSERT  INTO #BillingDiagnoses
                                ( DSMVCodeId ,
                                  ICD10Code ,
                                  ICD9Code ,
                                  DiagnosisOrder ,
                                  Description ,
                                  Billable
                                )
                                SELECT  D.ICD10CodeId ,
                                        D.ICD10Code ,
                                        D.ICD9Code ,
                                        D.DiagnosisOrder ,
                                        DD.ICDDescription AS DSMDescription ,
                                        ISNULL(D.Billable, 'N')
                                FROM    DocumentDiagnosisCodes D
                                        JOIN DiagnosisICD10Codes DD ON D.ICD10CodeId = DD.ICD10CodeId
                                                                       AND D.ICD10Code = DD.ICD10Code
                                WHERE   DocumentVersionId = @LatestDiagnosisDocumentVersionId
                                        AND ISNULL(D.RecordDeleted, 'N') = 'N'
                                        AND (ISNULL(D.RuleOut, 'N') = @RuleOut OR @RuleOut = 'Y')
                                        -- Added by Bernardin on 28 June 2017
                                         AND ( D.Billable='Y' or (@BillableOnly = 'N' and ISNULL(D.Billable,'N') in ('Y','N')))
                                        -- Changes end here
                                        
                          if not exists ( select  1
                                        from    #BillingDiagnoses ) and @VarDate < '10/1/15'
                            begin
								--
								-- 10/29/2015 - 
								-- This will alllow a match when the source document code is DSMV='Y'
								-- but the underlying data still lives in DiagnosesIandII
								--
                                INSERT  INTO #BillingDiagnoses
                                (DSMVCodeId	-- added by T.Remisoski
                                ,DSMCode
                                ,DsmNumber
                                ,SortOrder
                                ,DiagnosisOrder
                                ,Description
                                ,Billable
                                )
                                SELECT  -(ROW_NUMBER() over(order by d.dsmcode))	-- Generate a pseudo-id
										,D.DSMCode
                                       ,D.DSMNumber
                                       ,CASE WHEN DiagnosisType = 140 THEN 1
                                             ELSE 2
                                        END AS SortOrder
                                       ,DiagnosisOrder
                                       ,DD.DSMDescription
                                       ,ISNULL(D.Billable, 'N')
                                FROM    dbo.DiagnosesIAndII D
                                        JOIN DiagnosisDSMDescriptions DD ON DD.DSMCode = D.DSMCode
                                                                            AND DD.DSMNumber = D.DSMNumber
                                WHERE   DocumentVersionId = @LatestDiagnosisDocumentVersionId
                                        AND ISNULL(D.RecordDeleted, 'N') = 'N'
                                        AND (ISNULL(D.RuleOut, 'N') = @RuleOut OR @RuleOut = 'Y')
                            end
                    END
		
                IF ISNULL(@UseProblemListForDiagnosis, 'N') = 'Y'
                    BEGIN
                        IF ( SELECT COUNT(*)
                             FROM   #BillingDiagnoses
                           ) = 0
                            BEGIN
                                INSERT  INTO #BillingDiagnoses
                                        ( DSMCode ,
                                          DsmNumber ,
                                          Description ,
                                          Billable
                                        )
                                        SELECT  CP.DSMCode ,
                                                NULL ,
                                                DC.ICDDescription ,
                                                'N'
                                        FROM    ClientProblems CP
                                                JOIN DiagnosisICDCodes DC ON CP.DSMCode = DC.ICDCode
                                                                             AND ISNULL(CP.RecordDeleted, 'N') = 'N'
                                        WHERE   CP.ClientId = @varClientId
                            END
                    END   
            END   

/********************Order Automation Logic*************************************************************************/ 
         UPDATE  #BillingDiagnoses
        SET     [Order] = 1 ,
                DiagnosisOrder = 1
        WHERE   SortOrder = 1
		
		
        UPDATE  #BillingDiagnoses
        SET     DiagnosisOrder = 8
        WHERE   SortOrder <> 1
                AND DiagnosisOrder = 1
                
		-- clear pseudo-identifiers
	    UPDATE #BillingDiagnoses SET DSMVCodeId = NULL WHERE DSMVCodeId <= 0 --Added by Lakshmi on 17/10/2017
 
        DECLARE @InitializeDiagnosisOrder CHAR(1)
        SELECT TOP 1
                @InitializeDiagnosisOrder = Value
        FROM    SystemConfigurationKeys
        WHERE   [key] = 'INITIALIZEDIAGNOSISORDER'

        IF ISNULL(@InitializeDiagnosisOrder, 'N') = 'Y'
            BEGIN
                IF ( @CurDiagnosisDocumentCodeID IS NULL )
                    BEGIN
                        CREATE TABLE #BillingDiagnosesDiagnosisOrder
                            (
                              DSMCode CHAR(6) ,
                              DSMNumber INT ,
                              SortOrder INT ,
                              DiagnosisOrder INT ,
                              [Description] VARCHAR(500) ,
                              [Billable] CHAR(1)
                            )
	   
                        INSERT  INTO #BillingDiagnosesDiagnosisOrder
                                ( DSMCode ,
                                  DsmNumber ,
                                  SortOrder ,
                                  DiagnosisOrder ,
                                  [Description] ,
                                  Billable
                                )
                                SELECT  DSMCode ,
                                        DsmNumber ,
                                        SortOrder ,
                                        DiagnosisOrder ,
                                        [Description] ,
                                        Billable
                                FROM    ( SELECT    * ,
                                                    ( ROW_NUMBER() OVER ( ORDER BY DiagnosisOrder ASC ) + 1 ) tn
                                          FROM      #BillingDiagnoses
                                          WHERE     SortOrder <> 1
                                        ) AS BD
                                WHERE   --tn = 1 AND
                                        ISNULL(DiagnosisOrder, 0) <= 8
		
                        UPDATE  BD
                        SET     BD.[Order] = BDDO.DiagnosisOrder
                        FROM    #BillingDiagnoses BD
                                INNER JOIN #BillingDiagnosesDiagnosisOrder BDDO ON BD.DSMCode = BDDO.DSMCode
                                                                                   AND BD.DsmNumber = BDDO.DsmNumber
                                                                                   AND BD.SortOrder = BDDO.SortOrder
                                                                                   --AND BD.DiagnosisOrder = BDDO.DiagnosisOrder
                                                                                   AND BD.[Description] = BDDO.[Description]
                                                                                   AND BD.Billable = BDDO.Billable
						WHERE   BD.SortOrder <> 1
						
                        DROP TABLE #BillingDiagnosesDiagnosisOrder
                    END
                ELSE
                    BEGIN
                        CREATE TABLE #BillingDiagnosesICD10DiagnosisOrder
                            (
                             DSMVCodeId INT
                            ,ICD10Code VARCHAR(20)
                            ,ICD9Code VARCHAR(20)
                            ,DiagnosisOrder INT
                            ,[Description] VARCHAR(500)
                            ,[Billable] CHAR(1)
                            )
		
                        INSERT  INTO #BillingDiagnosesICD10DiagnosisOrder
                                (DSMVCodeId
                                ,ICD10Code
                                ,ICD9Code
                                ,DiagnosisOrder
                                ,[Description]
                                ,Billable
                                )
                                SELECT  DSMVCodeId
                                       ,ICD10Code
                                       ,ICD9Code
                                       ,DiagnosisOrder
                                       ,[Description]
                                       ,Billable
                                FROM    (SELECT *
                                               ,ROW_NUMBER() OVER (PARTITION BY [DiagnosisOrder] ORDER BY DiagnosisOrder ASC) tn
                                         FROM   #BillingDiagnoses
                                        ) AS BD
                                WHERE   --tn = 1 AND
                                        ISNULL(DiagnosisOrder, 0) <= 8

                        UPDATE  BD
                        SET     BD.[Order] = BDDO.DiagnosisOrder
                        FROM    #BillingDiagnoses BD
                                INNER JOIN #BillingDiagnosesICD10DiagnosisOrder BDDO ON BD.DSMVCodeId = BDDO.DSMVCodeId
                                                                                        AND isnull(BD.ICD10Code, '') = isnull(BDDO.ICD10Code, '')	-- this can be empty in some cases
                                                                                        AND isnull(BD.ICD9Code, '') = isnull(BDDO.ICD9Code, '')		-- this can be empty in some cases
                                                                                        AND BD.DiagnosisOrder = BDDO.DiagnosisOrder
                                                                                        AND BD.[Description] = BDDO.[Description]
                                                                                        AND BD.Billable = BDDO.Billable
		
						-- clear pseudo-identifiers
						update #BillingDiagnoses set DSMVCodeId = null where DSMVCodeId <= 0
		
                        DROP TABLE #BillingDiagnosesICD10DiagnosisOrder
                    END
            END
        ELSE
            IF ISNULL(@InitializeDiagnosisOrder, 'N') = 'N'
                BEGIN
	--05 Nov 2014 Akwinass Added Below Logic for Task #1419 in Engineering Improvement Initiatives- NBL(I)	
                    IF @ProgramId > 0
                        BEGIN
                            IF ( @CurDiagnosisDocumentCodeID IS NULL )
                                BEGIN
                                    DECLARE @DiagnosisDSMDescriptionCategories TABLE
                                        (
                                          OrderId INT IDENTITY(1, 1) ,
                                          DSMCode VARCHAR(10) ,
                                          DSMNumber INT
                                        )
				
                                    IF ISNULL(@UseDiagnosisDocument, 'N') = 'Y'
                                        BEGIN
                                            IF ISNULL(@DiagnosisDocumentCategory, 'N') = 'Y'
                                                BEGIN						
                                                    INSERT  INTO @DiagnosisDSMDescriptionCategories
                                                            ( DSMCode ,
                                                              DSMNumber
                                                            )
                                                            SELECT  BD.DSMCode ,
                                                                    BD.DSMNumber
                                                            FROM    #BillingDiagnoses BD
                                                            WHERE   BD.Billable = 'Y'
                                                            ORDER BY DiagnosisOrder ASC
                                                END
                                            ELSE
                                                IF ISNULL(@DiagnosisDocumentCategory, 'N') = 'N'
                                                    BEGIN
                                                        INSERT  INTO @DiagnosisDSMDescriptionCategories
                                                                ( DSMCode ,
                                                                  DSMNumber
                                                                )
                                                                SELECT  DDC.DSMCode ,
                                                                        ISNULL(DDC.DSMNumber, 1)
                                                                FROM    DiagnosisDSMDescriptionCategories DDC
                                                                        INNER JOIN #BillingDiagnoses BD ON DDC.DSMCode = BD.DSMCode
                                                                                                           AND DDC.DSMNumber = BD.DSMNumber
                                                                                                           AND BD.Billable = 'Y'
                                                                        LEFT JOIN ( SELECT  PDC.DiagnosisCategory
                                                                                    FROM    ProgramDiagnosisCategories PDC
                                                                                            INNER JOIN GlobalCodes GC ON PDC.DiagnosisCategory = GC.GlobalCodeId
                                                                                                                         AND ISNULL(PDC.RecordDeleted, 'N') = 'N'
                                                                                                                         AND ISNULL(GC.RecordDeleted, 'N') = 'N'
                                                                                    WHERE   ProgramId = @ProgramId
                                                                                  ) B ON DDC.DiagnosisCategory = B.DiagnosisCategory
                                                                                         AND ISNULL(DDC.RecordDeleted, 'N') = 'N'
                                                                                         AND DDC.DiagnosisCategory IS NOT NULL
                                                                WHERE   B.DiagnosisCategory IS NOT NULL
                                                    END
                                        END
			
                                    UPDATE  A
                                    SET     [Order] = B.OrderId
                                    FROM    #BillingDiagnoses A
                                            JOIN @DiagnosisDSMDescriptionCategories B ON A.DSMCode = B.DSMCode
                                                                                         AND A.DSMNumber = B.DSMNumber
                                    WHERE   B.OrderId <= 8
                                END
                            ELSE
                                BEGIN
                                    DECLARE @DiagnosisDSMVCodeCategories TABLE
                                        (
                                          OrderId INT IDENTITY(1, 1) ,
                                          ICD10Code VARCHAR(20)
                                        )

                                    IF ISNULL(@UseDiagnosisDocument, 'N') = 'Y'
                                        BEGIN
                                            IF ISNULL(@DiagnosisDocumentCategory, 'N') = 'Y'
                                                BEGIN
                                                    INSERT  INTO @DiagnosisDSMVCodeCategories
                                                            ( ICD10Code
                                                            )
                                                            SELECT DISTINCT
                                                                    BD.ICD10Code
                                                            FROM    #BillingDiagnoses BD
                                                            WHERE   BD.Billable = 'Y'
                                                END
                                            ELSE
                                                IF ISNULL(@DiagnosisDocumentCategory, 'N') = 'N'
                                                    BEGIN
                                                        INSERT  INTO @DiagnosisDSMVCodeCategories
                                                                ( ICD10Code
                                                                )
                                                                SELECT DISTINCT
                                                                        DDC.ICD10Code
                                                                FROM    DiagnosisDSMVCodeCategories DDC
                                                                        INNER JOIN #BillingDiagnoses BD ON DDC.ICD10Code = BD.ICD10Code
                                                                                                           AND BD.Billable = 'Y'
                                                                        LEFT JOIN ( SELECT  PDC.DiagnosisCategory
                                                                                    FROM    ProgramDiagnosisCategories PDC
                                                                                            INNER JOIN GlobalCodes GC ON PDC.DiagnosisCategory = GC.GlobalCodeId
                                                                                                                         AND ISNULL(PDC.RecordDeleted, 'N') = 'N'
                                                                                                                         AND ISNULL(GC.RecordDeleted, 'N') = 'N'
                                                                                    WHERE   ProgramId = @ProgramId
                                                                                  ) B ON DDC.DiagnosisCategory = B.DiagnosisCategory
                                                                                         AND ISNULL(DDC.RecordDeleted, 'N') = 'N'
                                                                                         AND DDC.DiagnosisCategory IS NOT NULL
                                                                WHERE   B.DiagnosisCategory IS NOT NULL
                                                    END
                                        END

                                    UPDATE  A
                                    SET     [Order] = B.OrderId
                                    FROM    #BillingDiagnoses A
                                            JOIN @DiagnosisDSMVCodeCategories B ON A.ICD10Code = B.ICD10Code
                                    WHERE   B.OrderId <= 8
                                END
                        END
                END
        ELSE IF ISNULL(@InitializeDiagnosisOrder, 'N') = 'B'
		   BEGIN
			  --22 DEC 2015		Akwinass
			  update #BillingDiagnoses set DSMVCodeId = null where DSMVCodeId <= 0
			  update #BillingDiagnoses set [Order] = NULL
		   END

--*******************Order Automation Logic END**********************************************************************
  
--          
-- This proc possibly alters the records in the #BillingDiagnoses table          
--          
-- Added @varProgramId by Avi Goyal on 23 April 2014      
        EXEC scsp_GetBillingDiagnosesByDate @varClientId, @varDate, @varProgramId          
          
        IF @@error <> 0
            GOTO error_csp_call          
 --Added Version and DiagnosisOrder Columns by SuryaBalan      
 -- 01 Oct 2014 Akwinass (Order column Included)
        SELECT  DSMCode ,
                DSMNumber ,
                SortOrder ,
                [Version] ,
                DiagnosisOrder ,
                DSMVCodeId ,
                ICD10Code ,
                ICD9Code ,
                Description ,
                [Order]
        FROM    #BillingDiagnoses
        ORDER BY SortOrder ,
                DiagnosisOrder               
         
        IF ( @@error != 0 )
            BEGIN                
               -- RAISERROR  20002  'ssp_SCBillingDiagnosiServiceNote: An Error Occured'                
                RAISERROR('ssp_SCBillingDiagnosiServiceNote: An Error Occured', 16, 1)          
                RETURN(1)                
            END                
        RETURN(0)                
                
    END           
          
    error_csp_call:          
    RAISERROR('Error calling scsp_GetBillingDiagnosesByDate for ClientId: %d', 16, 1, @varClientId)          
    RETURN -1 
GO


