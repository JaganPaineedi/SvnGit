/****** Object:  StoredProcedure [dbo].[ssp_GetClientCoveragePlanNotes]    Script Date: 06/11/2018 03:53:09 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetClientCoveragePlanNotes]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetClientCoveragePlanNotes]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetClientCoveragePlanNotes]   Script Date: 06/11/2018 03:53:09 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE proc [dbo].[ssp_GetClientCoveragePlanNotes]  @ClientId int 
as                  
/*********************************************************************/                                                                            
/* Stored Procedure: dbo.csp_CreateMemberRecord               */                                                                            
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                                                            
/* Creation Date:    22/Sep/2011                                         */                                                                            
/* Created By :   Alok Kumar Meher                                                             */                                                                            
/* Purpose:  Used in creating new Member Record for Member Inquiry Detail Page  */                                                                           
/*                                                                   */                                                                          
/* Input Parameters:  @Active   */                                                                          
/*       @LastName */          
/*       @FirstName */          
/*       @SSN  */          
/*       @DOB  */          
/*       @FinanciallyResponsible */          
/*       @DoesNotSpeakEnglish */                 
/*                                                      */                                                                            
/* Output Parameters:   Dataset of Newly added Member's Details                */                                                                            
/*                                                                   */                                                                           
/*                                                                   */                                                                            
/*  Date				Author						Purpose                             */                                                                            
/*  26/June/2018		Alok Kumar Meher			Created       */            
/************3*******************************************************************************************************************************************/                                                                                 
BEGIN                                                             
 BEGIN TRY      
 
		--Select * From ClientCoveragePlanNotes Where ClientId = @ClientId  And ISNULL(RecordDeleted, 'N') = 'N'
		
			Select Top 1 * 
				From ClientCoveragePlanNotes Where ClientId = @ClientId  And ISNULL(RecordDeleted, 'N') = 'N'
				order by ClientCoveragePlanNoteId desc
		
 END TRY                                                
 BEGIN CATCH                             
 DECLARE @Error varchar(8000)                                                                              
    SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                        
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_GetClientCoveragePlanNotes')                                                    
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                
    + '*****' + Convert(varchar,ERROR_STATE())                                                                              
                                                            
    RAISERROR                                                                               
    (                                             
  @Error, -- Message text.                                                                              
  16, -- Severity.                                                                              
  1 -- State.                                                                              
    );                                                               
 End CATCH                                                                                                                     
                                                         
End
GO 