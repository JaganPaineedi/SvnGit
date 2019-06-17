
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetAdvanceDirectiveData]    Script Date: 06/13/2015 18:10:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetAdvanceDirectiveData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetAdvanceDirectiveData]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_GetAdvanceDirectiveData]    Script Date: 06/13/2015 18:10:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


  
  
CREATE procedure [dbo].[ssp_GetAdvanceDirectiveData]
    (
      @DocumentVersionId int    
                              
    )
as 
    begin    
          
        begin try      

            select   DocumentVersionId ,
                    CreatedBy ,
                    CreatedDate ,
                    ModifiedBy ,
                    ModifiedDate ,
                    RecordDeleted ,
                    DeletedDate ,
                    DeletedBy ,
                    ClientName ,
                    ClientAddress ,
                    Attorney1 ,
                    Attorney2 ,
                    Attorney3 ,
                    AnatomicalGift ,
                    AnatomicalGiftComment ,
                    RuleLimitationComment ,
                    ProlongedLife ,
                    PowerEffectiveDate ,
                    PowerEffectiveComment ,
                    PowerTerminateDate ,
                    PowerTerminateComment ,
                    SuccessorsToAgentName1 ,
                    SuccessorsToAgentAddress1 ,
                    SuccessorsToAgentPhone1 ,
                    SuccessorsToAgentName2 ,
                    SuccessorsToAgentAddress2 ,
                    SuccessorsToAgentPhone2 ,
                    OtherInstructions
            from    dbo.AdvanceDirective
            where   DocumentVersionId = @DocumentVersionId

      
        end try                                                    
                                                                                             
        begin catch        
            declare @Error varchar(8000)                                                     
            set @Error = convert(varchar, error_number()) + '*****'
                + convert(varchar(4000), error_message()) + '*****'
                + isnull(convert(varchar, error_procedure()),
                         'ssp_GetClientActionPlans') + '*****'
                + convert(varchar, error_line()) + '*****'
                + convert(varchar, error_severity()) + '*****'
                + convert(varchar, error_state())                                
            raiserror                                                                                   
 (                                                     
  @Error, -- Message text.                                                                                  
  16, -- Severity.                                                                                  
  1 -- State.                                                                                  
 );                                                                                
        end catch                               
    end     


GO

