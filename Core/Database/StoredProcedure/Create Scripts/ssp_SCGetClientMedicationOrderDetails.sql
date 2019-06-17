IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientMedicationOrderDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetClientMedicationOrderDetails]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
    
CREATE PROCEDURE [dbo].[ssp_SCGetClientMedicationOrderDetails]    
    (    
      @ClientMedicationId INT = 0 ,    
      @ClientMedicationScriptId INT = -1      --A new Parameter added by Sonia so that order details can be feteched according to ScriptId if its being passed                                        
    )    
AS /*********************************************************************/                                                      
/* Stored Procedure: dbo.ssp_SCGetMedicationOrderDetails                */                                                      
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                                      
/* Creation Date:    12/Sep/07                                         */                                                     
/*                                                                   */                                                      
/* Purpose:  To retrieve ClientMedicationOrderDetails   */                                                      
/*                                                                   */                                                    
/* Input Parameters: none        @ClientMedicationId */                                                    
/*                                                                   */                                                      
/* Output Parameters:   None                           */                                                      
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
/*   Date      Author               Purpose                                  */                                                      
--  11/04/07    Sonia            Created                                    */                
-- 05/26y/08     Sonia           Modified the logic of fetching data from ClientMedicationScriptDrugs,
                                 /*AS in case ScriptId is being passed OrderDetails should be fetched accordingly*/            
                                 /*Otherwise latest Details from  ClientMedicationScriptDrugs*/             
-- 05/28/08     Sonia            Modified /*Task # 49 MM1.5.2 Non Ordered Medication:Order details are not displaying for some fields.  */       
                                 /*Records need not to be fetched from ClientMedicationScriptDrugs in case Medication is a non -ordered Medication*/        
                                 /*Reference Task #67 1.6.1 - Special Instructions Changes.*/    
                                 /*Changes made to retrive SpecialInstructions value from ClientMedicationScriptDrugs.*/    
-- 08/2/2012    Kneale           Added the column PharmacyText and created a new calculated field PharmacyAmount */    
-- 01/23/2014   Kalpers          added the list of fields from clientmedications and checked for null values */    
-- 3/25/2015   Steczynski        Format Quantity to drop trailing zeros, applied dbo.ssf_RemoveTrailingZeros, Task 215 */    
-- 12/212015   Vithobha	         Added VerbalOrderReadBack columns for Summit Pointe - Support: #703
-- 10/3/2016	Malathi Shiva	 Added User defined Medication tables used in the process of creating ClientMedications from Reconciliation for non-matching NDC codes. */	
-- 10/18/2018   Pranay Bodhu      Added isnull(cmi.Active,'Y')='Y' w.r.t boundless Task# 265	, Removed journey task #99	and KCMHSAS- SGL-1176					
/*********************************************************************/                                                 
    BEGIN                                              
                                       
        DECLARE @MedicationId INT              
        DECLARE @ClientMedicationOrdered CHAR(1)     
        DECLARE @VerbalOrderReadBack CHAR(1)  
          
        select @VerbalOrderReadBack = ISNULL(VerbalOrderReadBack, 'N') from ClientMedicationScripts  where ClientMedicationScriptId= @ClientMedicationScriptId                 
              
        SELECT  @ClientMedicationOrdered = ISNULL(Ordered, 'N')    
        FROM    ClientMedications    
        WHERE   Clientmedicationid = @ClientMedicationId        
      
        SELECT   CM.ClientMedicationId ,    
                CM.ClientId ,    
                CM.Ordered ,    
                CM.MedicationNameId ,    
                CM.MedicationStartDate ,    
                CM.MedicationEndDate ,    
                CM.DrugPurpose ,    
                CM.DSMCode ,    
                CM.DSMNumber ,    
                CM.NewDiagnosis ,    
                CM.PrescriberId ,    
                CM.PrescriberName ,    
                CM.ExternalPrescriberName ,    
                CM.SpecialInstructions ,    
                CM.DAW ,    
                CM.OffLabel ,    
                ISNULL(CM.DesiredOutcomes,'') AS DesiredOutcomes ,    
                CM.Comments ,    
                CM.IncludeCommentOnPrescription ,    
                CM.Discontinued ,    
                CM.DiscontinuedReasonCode ,    
                CASE WHEN ISNULL(CM.DiscontinuedReason,'') = 'NULL' THEN '' ELSE ISNULL(CM.DiscontinuedReason,'') END AS DiscontinuedReason ,    
                CM.DiscontinueDate ,    
                CM.DEACode ,    
                CM.TitrationType ,    
                CM.DateTerminated ,    
                CM.PermitChangesByOtherUsers ,    
                CM.RXSource ,    
                CM.RowIdentifier ,    
                CM.CreatedBy ,    
                CM.CreatedDate ,    
                CM.ModifiedBy ,    
                CM.ModifiedDate ,    
                CM.RecordDeleted ,    
                CM.DeletedDate ,    
                CM.DeletedBy ,    
                ISNULL(DSMCode, '0') + '_' + ISNULL(CAST(DSMNumber AS VARCHAR),    
                                                    '0') AS DxId ,    
                MDN.MedicationName AS MedicationName ,  
                @VerbalOrderReadBack as VerbalOrderReadBack   
        FROM    clientmedications CM    
                LEFT JOIN MDMedicationNames MDN ON ( CM.MedicationNameId = MDN.MedicationNameId )    
                                              AND ISNULL(MDN.RecordDeleted,    
                                                         'N') = 'N' 
                 LEFT JOIN UserDefinedMedicationNames UDMN 
					   ON ( UDMN.UserDefinedMedicationNameId = CM.UserDefinedMedicationNameId
					   AND ISNULL(UDMN.RecordDeleted, 'N') <> 'Y' )   
        WHERE   clientmedicationid = @ClientMedicationId    
                AND ISNULL(CM.RecordDeleted, 'N') = 'N'                                        
                                        
-----Case of Non-Ordered Medication-------        
--If condition added by Sonia        
--Ref Task # 49 MM1.5.2 Non Ordered Medication:Order details are not displaying for some fields        
--Case of Non Ordered Medication           
        IF ( ( @ClientMedicationScriptId = -1 )    
             AND ( @ClientMedicationOrdered = 'N' )    
           )     
            BEGIN            
--ScriptId also needs to be retrieved                                         
                SELECT  ISNULL(M.StrengthDescription,UDM.StrengthDescription) AS StrengthDescription ,    
                        CMI.* ,    
                        CMSD.StartDate ,    
                        CMSD.Days ,    
                        CMSD.Pharmacy ,    
                        cmsd.PharmacyText ,    
                        CASE WHEN cmsd.PharmacyText IS NULL    
                             THEN CAST(cmsd.Pharmacy AS VARCHAR(100))    
                             ELSE cmsd.PharmacyText    
                        END AS PharmacyAmount ,    
                        CMSD.Sample ,    
                        CMSD.Stock ,    
                        CMSD.Refills ,    
                        CMSD.EndDate ,    
                        ( dbo.ssf_RemoveTrailingZeros(CMI.Quantity) + ' '    
                          + CONVERT(VARCHAR, GC.CodeName) + ' '    
                          + CONVERT(VARCHAR, GC1.CodeName) ) AS Instruction ,    
                        ISNULL(MN.MedicationName,UDMN.MedicationName) AS MedicationName ,    
                        CMSD.ClientMedicationScriptId ,    
   CM.SpecialInstructions ,    
                        CM.OffLabel ,    
                        isnull(CM.DesiredOutcomes,'') as DesiredOutcomes ,    
                        CM.Comments ,    
                        CM.DiscontinuedReasonCode    
                FROM    clientmedicationinstructions CMI    
                        INNER JOIN ClientMedications CM ON ( CMI.clientmedicationid = CM.clientmedicationid    
                                                             AND ISNULL(CMI.RecordDeleted,    
                                                              'N') = 'N'    AND ISNULL(CMI.Active,'Y')='Y'
                                                           )    
                        LEFT JOIN ClientMedicationScriptDrugs CMSD ON ( CMSD.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId    
                                                              AND ISNULL(CMSD.RecordDeleted,    
                                                              'N') = 'N'    
                                                              )    
                        LEFT JOIN MDMedications M ON ( M.MedicationNameId = CM.MedicationNameId    
                                                  AND M.MedicationId = CMI.StrengthId    
                                                  AND ISNULL(M.RecordDeleted, 'N') = 'N')    
                        LEFT JOIN UserDefinedMedications UDM 
								ON ( UDM.UserDefinedMedicationNameId = CMI.UserDefinedMedicationId
								AND ISNULL(UDM.RecordDeleted, 'N') <> 'Y')                           
                        LEFT JOIN MDMedicationNames MN ON ( MN.MedicationNameId = M.MedicationNameId    
                                                       AND ISNULL(MN.RecordDeleted,    
                                                              'N') = 'N'    
                                                     )  
                         LEFT JOIN UserDefinedMedicationNames UDMN 
							   ON ( UDMN.UserDefinedMedicationNameId = CM.UserDefinedMedicationNameId
							   AND ISNULL(UDMN.RecordDeleted, 'N') <> 'Y' )  
                        LEFT JOIN GlobalCodes GC ON ( GC.GlobalCodeID = CMI.Unit )    
                        LEFT JOIN GlobalCodes GC1 ON ( GC1.GlobalCodeId = CMI.Schedule )    
                WHERE   CM.clientmedicationid = @ClientMedicationId    
                        AND ISNULL(CM.RecordDeleted, 'N') = 'N'    
                        AND ISNULL(CMI.RecordDeleted, 'N') = 'N'   AND ISNULL(CMI.Active,'Y')='Y'               
            END --Case of Non Ordered Medication           
        
--Case of Ordered Medication and ScriptId as -1  needs to fetch latest script Drugs records ends over here          
        ELSE     
            IF ( ( @ClientMedicationScriptId = -1 )    
                 AND ( @ClientMedicationOrdered = 'Y' )    
               )     
                BEGIN            
--ScriptId also needs to be retrieved                                         
                    SELECT  ISNULL(M.StrengthDescription,UDM.StrengthDescription) AS StrengthDescription ,    
                            CMI.* ,    
                            CMSD.StartDate ,    
                            CMSD.Days ,    
                            CMSD.Pharmacy ,    
                            cmsd.PharmacyText ,    
                            CASE WHEN cmsd.PharmacyText IS NULL    
                                 THEN CAST(cmsd.Pharmacy AS VARCHAR(30))    
                                 ELSE cmsd.PharmacyText    
                            END AS PharmacyAmount ,    
                            CMSD.Sample ,    
                            CMSD.Stock ,    
                            CMSD.Refills ,    
                            CMSD.EndDate ,    
                            ( dbo.ssf_RemoveTrailingZeros(CMI.Quantity) + ' '    
                              + CONVERT(VARCHAR, GC.CodeName) + ' '    
                              + CONVERT(VARCHAR, GC1.CodeName) ) AS Instruction ,    
                            ISNULL(MN.MedicationName,UDMN.MedicationName) AS MedicationName,    
                            CMSD.ClientMedicationScriptId ,    
                            CMSD.SpecialInstructions ,    
                            CM.OffLabel ,    
                            isnull(CM.DesiredOutcomes,'') as DesiredOutcomes ,    
                            CM.Comments ,    
                            CM.DiscontinuedReasonCode    
                    FROM    clientmedicationinstructions CMI    
                            INNER JOIN ClientMedications CM ON ( CMI.clientmedicationid = CM.clientmedicationid    
                                                              AND ISNULL(CMI.RecordDeleted,    
                                                              'N') = 'N'    AND ISNULL(CMI.Active,'Y')='Y'
                                                              )    
                            JOIN ClientMedicationScriptDrugs CMSD ON ( CMSD.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId    
                                                              AND ISNULL(CMSD.RecordDeleted,    
                                                              'N') = 'N'    
                                                              )    
                            LEFT JOIN MDMedications M ON ( M.MedicationNameId = CM.MedicationNameId    
                                                      AND M.MedicationId = CMI.StrengthId    
                                                      AND ISNULL(M.RecordDeleted, 'N') = 'N' ) 
                            LEFT JOIN UserDefinedMedications UDM 
								ON ( UDM.UserDefinedMedicationNameId = CMI.UserDefinedMedicationId
								AND ISNULL(UDM.RecordDeleted, 'N') <> 'Y')     
                            LEFT JOIN MDMedicationNames MN ON ( MN.MedicationNameId = M.MedicationNameId    
                                                           AND ISNULL(MN.RecordDeleted,    
                                                              'N') = 'N' )   
							LEFT JOIN UserDefinedMedicationNames UDMN 
							   ON ( UDMN.UserDefinedMedicationNameId = CM.UserDefinedMedicationNameId
							   AND ISNULL(UDMN.RecordDeleted, 'N') <> 'Y' )    
                            LEFT JOIN GlobalCodes GC ON ( GC.GlobalCodeID = CMI.Unit )    
                            LEFT JOIN GlobalCodes GC1 ON ( GC1.GlobalCodeId = CMI.Schedule )    
                    WHERE   CM.clientmedicationid = @ClientMedicationId    
                            AND ISNULL(CM.RecordDeleted, 'N') = 'N'                  
--New Logic of feteching Data  as per Task #38 and Task #39        
                            AND NOT EXISTS ( SELECT *    
                                             FROM   ClientMedicationScriptDrugs CMSD1    
                                             WHERE  CMSD1.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId    
                                                    AND ISNULL(cmsd1.RecordDeleted,    
                                                              'N') <> 'Y'    
                                                    AND ( ( cmsd1.StartDate > cmsd.startdate )    
                                                          OR ( cmsd1.StartDate = cmsd.StartDate    
                                                              AND cmsd1.ModifiedDate > cmsd.ModifiedDate    
                                                             )    
                                                          OR ( cmsd1.StartDate = cmsd.StartDate    
                                                              AND cmsd1.ModifiedDate = cmsd.ModifiedDate    
                                                              AND cmsd1.ClientMedicationScriptId > cmsd.ClientMedicationScriptId    
                                                             )    
                                                        ) )    
                            AND ISNULL(CMI.RecordDeleted, 'N') = 'N'                  
              
                END--Case of Ordered Medication and ScriptId as -1  needs to fetch latest script Drugs records ends over here          
        
            ELSE --In case its a Ordered Medication Case        
        BEGIN             
--ScriptId also needs to be retrieved              
                    SELECT  ISNULL(M.StrengthDescription,UDM.StrengthDescription) AS StrengthDescription ,    
                            CMI.* ,    
                            CMSD.StartDate ,    
                            CMSD.Days ,    
                            CMSD.Pharmacy ,    
                            cmsd.PharmacyText ,    
                            CASE WHEN cmsd.PharmacyText IS NULL    
                                 THEN CAST(cmsd.Pharmacy AS VARCHAR(30))    
                                 ELSE cmsd.PharmacyText    
                            END AS PharmacyAmount ,    
                            CMSD.Sample ,    
                            CMSD.Stock ,    
                            CMSD.Refills ,    
                            CMSD.EndDate ,    
                            ( dbo.ssf_RemoveTrailingZeros(CMI.Quantity) + ' '    
                              + CONVERT(VARCHAR, GC.CodeName) + ' '    
                              + CONVERT(VARCHAR, GC1.CodeName) ) AS Instruction ,    
                            ISNULL(MN.MedicationName,UDMN.MedicationName) AS MedicationName ,    
                            CMSD.ClientMedicationScriptId ,    
                            CMSD.SpecialInstructions ,    
                            CM.OffLabel ,    
                            isnull(CM.DesiredOutcomes,'') as DesiredOutcomes ,    
                            CM.Comments ,    
                            CM.DiscontinuedReasonCode    
                    FROM    clientmedicationinstructions CMI    
                            INNER JOIN ClientMedications CM ON ( CMI.clientmedicationid = CM.clientmedicationid    
                                                              AND ISNULL(CMI.RecordDeleted,    
                                                              'N') = 'N'    AND ISNULL(CMI.Active,'Y')='Y'
                                                              )    
                            JOIN ClientMedicationScriptDrugs CMSD ON ( CMSD.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId    
                                                              AND ISNULL(CMSD.RecordDeleted,    
                                                              'N') = 'N'    
                                                              )    
                            LEFT JOIN MDMedications M ON ( M.MedicationNameId = CM.MedicationNameId    
                                                      AND M.MedicationId = CMI.StrengthId    
                                                      AND ISNULL(M.RecordDeleted,    
                                                              'N') = 'N'    
                                                    )
                             LEFT JOIN UserDefinedMedications UDM 
								ON ( UDM.UserDefinedMedicationNameId = CMI.UserDefinedMedicationId
								AND ISNULL(UDM.RecordDeleted, 'N') <> 'Y')      
                            LEFT JOIN MDMedicationNames MN ON ( MN.MedicationNameId = M.MedicationNameId    
                                                           AND ISNULL(MN.RecordDeleted,    
                                                              'N') = 'N'    
                                                         )   
                            LEFT JOIN UserDefinedMedicationNames UDMN 
								   ON ( UDMN.UserDefinedMedicationNameId = CM.UserDefinedMedicationNameId
								   AND ISNULL(UDMN.RecordDeleted, 'N') <> 'Y' ) 
                            LEFT JOIN GlobalCodes GC ON ( GC.GlobalCodeID = CMI.Unit )    
                            LEFT JOIN GlobalCodes GC1 ON ( GC1.GlobalCodeId = CMI.Schedule )    
                    WHERE   CM.clientmedicationid = @ClientMedicationId    
                            AND ISNULL(CM.RecordDeleted, 'N') = 'N'    
                            AND CMSD.ClientMedicationScriptId = @ClientMedicationScriptId    
                            AND ISNULL(CMI.RecordDeleted, 'N') = 'N'  AND ISNULL(cmi.Active,'Y')='Y'        
              
              
                END              
              
              
                          
                      
        SELECT TOP 1    
                @MedicationId = strengthId    
        FROM    ClientMedicationInstructions    
        WHERE   ClientMedicationId = @ClientMedicationId                      
                       
        EXEC ssp_SCClientMedicationC2C5Drugs @MedicationId                          
                                             
              
                          
        IF ( @@error != 0 )     
            BEGIN                                                
                                                                    
              RAISERROR('ssp_SCGetVerbalOrderReviewData : An error  occured', 16, 1);          
                RETURN(1)                                                      
                
            END                                               
                                                    
    END     
    
    
    
    
GO


