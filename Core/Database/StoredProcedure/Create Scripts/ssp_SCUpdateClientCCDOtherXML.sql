
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCUpdateClientCCDOtherXML]    Script Date: 06/09/2015 01:27:39 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCUpdateClientCCDOtherXML]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCUpdateClientCCDOtherXML]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_SCUpdateClientCCDOtherXML]    Script Date: 06/09/2015 01:27:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[ssp_SCUpdateClientCCDOtherXML]  
    @DocumentVersionId int  
as /*********************************************************************/       
/* Stored Procedure: dbo.ssp_SCUpdateClientCCDOtherXML            */       
/* Creation Date:    07/JAN/2015                  */       
/* Purpose:  Used to update ClientCCD Allergy, Medication and Problem from XML data                */       
/*    Exec ssp_SCUpdateClientCCDOtherXML                                              */      
/* Input Parameters:                           */       
/* Date			Author   Purpose              */       
/* 07/JAN/2015  Gautam   Created           Task #57,Certification 2014   */                          
  /*********************************************************************/       
    begin       
        begin try    
        
            declare @XMLData as xml      
            declare @ClientCCDId as int      
            declare @listAllergy varchar(max)      
            declare @listMedication varchar(max)      
            declare @listProblems varchar(max)      
            declare @XMLTempdata varchar(max)      
    
         
            select  @XMLData = convert(xml, XMLData)  
                  , @ClientCCDId = ClientCCDId  
            from    ClientCCDs  
            where   DocumentVersionId = @DocumentVersionId       
     
            select  @XMLTempdata = replace(cast(@XMLData as varchar(max)),  
                                           'xmlns:ccr="urn:astm-org:CCR"',  
                                           '')      
            select  @XMLTempdata = replace(@XMLTempdata,  
                                           'xmlns:sdtc="urn:hl7-org:sdtc"', '')      
            select  @XMLTempdata = replace(@XMLTempdata,  
                                           'xmlns="urn:hl7-org:v3"', '') 
                                            
            select  @XMLTempdata = replace(@XMLTempdata,  
                                           'ccr:', '')    
  
            select  @XMLData = cast (@XMLTempdata as xml)      
      
        
            create table #AllergyData  
                (  
                  AllergyDesc varchar(max)  
                )      
             
            create table #MedicationData  
                (  
                  MedicationDesc varchar(max)  
                )      
      
            create table #ProblemData  
                (  
                  ProblemDesc varchar(max)  
                )      
         
            insert  into #AllergyData  
                    ( AllergyDesc  
                    )  
                    select   isnull(ltrim(rtrim(m.c.value('data((./Description/Text)[1])',  
                                                              'varchar(MAX)'))),  
                                           '') 
                          + '-'  
                            + isnull(ltrim(rtrim(m.c.value('data((./Status/Text)[1])',  
                         'varchar(MAX)'))) 
                                     ,'') 
                                     + '-'
						+ isnull(ltrim(rtrim(m.c.value('data((./DateTime/ApproximateDateTime/Text)[1])',  
                                                         'varchar(MAX)'))), '') 

                    from    @XMLData.nodes('ContinuityOfCareRecord/Body/Alerts/Alert')  
                            as m ( c )        
        
            insert  into #MedicationData  
                    ( MedicationDesc  
                    )  
                    select  isnull(ltrim(rtrim(m.c.value('./Text[1]',  
                                                         'varchar(MAX)'))), '')  
                                + '-' + isnull(ltrim(rtrim(m.c.value('data((../Strength/Value)[1])',  
                                                              'varchar(MAX)'))),  
                                           '') 
                            + ' ' + isnull(ltrim(rtrim(m.c.value('data((../Strength/Units/Unit)[1])',  
                                                              'varchar(MAX)'))),  
                                           '') 
                          + '-'  
                            + isnull(ltrim(rtrim(m.c.value('data((../../PatientInstructions/Instruction/Text)[1])',  
                         'varchar(MAX)'))) 
                                     ,'') 

                    from    @XMLData.nodes('ContinuityOfCareRecord/Body/Medications/Medication/Product/ProductName')  
                            as m ( c )         
        
        
            insert  into #ProblemData  
                    ( ProblemDesc  
                    )  
                    select   isnull(ltrim(rtrim(m.c.value('data((./Description/Text)[1])',  
                                                              'varchar(MAX)'))),  
                                           '') 
                          + '-'  
                            + isnull(ltrim(rtrim(m.c.value('data((./Status/Text)[1])',  
                         'varchar(MAX)'))) 
                                     ,'') 
                            + '-' + isnull(ltrim(rtrim(m.c.value('data((./DateTime/ApproximateDateTime/Text)[1])',  
                                                         'varchar(MAX)'))), '')  
                           

                    from    @XMLData.nodes('ContinuityOfCareRecord/Body/Problems/Problem')  
                            as m ( c )     
     
     
            select  @listAllergy = coalesce(@listAllergy + '<br>', '')  
                    + AllergyDesc  
            from    #AllergyData      
     
            select  @listMedication = coalesce(@listMedication + '<br>', '')  
                    + MedicationDesc  
            from    #MedicationData      
     
            select  @listProblems = coalesce(@listProblems + '<br>', '')  
                    + ProblemDesc  
            from    #ProblemData      
      
             
            update  ccd  
            set     ccd.Allergies = @listAllergy  
                  , ccd.Medications = @listMedication  
                  , ccd.Problems = @listProblems  
            from    ClientCCDs ccd  
            where   ClientCCDId = @ClientCCDId      
        
  
            declare @ReconceliationDocument int   
  
            select  @ReconceliationDocument = DocumentVersionId  
            from    dbo.ClinicalInformationReconciliation as cir  
            where   cir.DocumentVersionId = @DocumentVersionId  
  
            if ( @ReconceliationDocument is not null )  
                begin  
                    update  dbo.ClinicalInformationReconciliation  
                    set     Allergies = @listAllergy  
                          , Medications = @listMedication  
                          , Diagnoses = @listProblems  
                    where   DocumentVersionId = @DocumentVersionId  
                end  
            else  
                begin  
                    insert  into dbo.ClinicalInformationReconciliation  
                            ( DocumentVersionId  
                            , CreatedBy  
                            , CreatedDate  
                            , ModifiedBy  
                            , ModifiedDate  
                            , Medications  
                            , Allergies  
                            , Diagnoses  
                         )  
                            select  @DocumentVersionId  -- DocumentVersionId - int  
                                  , ccd.CreatedBy  -- CreatedBy - type_CurrentUser  
                    , ccd.CreatedDate  -- CreatedDate - type_CurrentDatetime  
                                  , ccd.ModifiedBy -- ModifiedBy - type_CurrentUser  
                                  , ccd.ModifiedDate  -- ModifiedDate - type_CurrentDatetime  
                                  , @listMedication  -- Medications - varchar(max)  
                                  , @listAllergy  -- Allergies - varchar(max)  
                                  , @listProblems  -- Diagnoses - varchar(max)  
                            from    dbo.ClientCCDs as ccd  
                            where   ccd.DocumentVersionId = @DocumentVersionId  
                end  
        end try       
      
        begin catch       
            declare @Error varchar(max)       
      
            set @Error = convert(varchar, error_number()) + '*****'  
                + convert(varchar(4000), error_message()) + '*****'  
                + isnull(convert(varchar, error_procedure()),  
                         'ssp_SCUpdateClientCCDOtherXML') + '*****'  
                + convert(varchar, error_line()) + '*****'  
                + convert(varchar, error_severity()) + '*****'  
                + convert(varchar, error_state())       
      
            raiserror ( @Error,       
                      -- Message text.                                                                                       
                      16,       
                      -- Severity.                                                                                       
                      1       
          -- State.                                                                                       
          );       
        end catch       
    end 
GO

