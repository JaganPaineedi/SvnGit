
/****** Object:  StoredProcedure [dbo].[csp_InitializeMedicationsForAssessment]    Script Date: 01/16/2015 18:46:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitializeMedicationsForAssessment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitializeMedicationsForAssessment]
GO


/****** Object:  StoredProcedure [dbo].[csp_InitializeMedicationsForAssessment]    Script Date: 01/16/2015 18:46:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure  [dbo].[csp_InitializeMedicationsForAssessment]       
  (@ClientId int)                                                     
As                                                    
 /****************************************************************************/                                                                  
 /* Stored Procedure:csp_InitializeMedicationsForAssessment                            */                                                         
 /* Copyright: 2006 Streamlin Healthcare Solutions                           */                       
 /* Author: Loveena                                                      */                                                                 
 /* Creation Date:  July 14,2010                                              */                                                                  
 /* Purpose: Gets Data for Initalize Medications                                 */                                                                 
 /* Input Parameters: @ClientId                     */                                                                
 /* Output Parameters:None                                                   */                                                                  
 /* Return:                                                                  */                                                                  
 /* Calls:                                                                   */                      
 /* Called From: HRMAssessment on click of Initialize Medications Button    */   
 /* Updates:                   */          
/*  Date    Author             Purpose            */       
/*  23/Nov/2012     Rachna Singh     Pull this sp from Allegan database from 3.xMerged with ref to task  #5(NursingAssessment) in interactDevelopmentImplementation */           
           
                       
                                                                   
BEGIN                                      
    BEGIN TRY                                          
         
         
         
--  
--Declare Variables for Loops  
--  
Declare @TempList Varchar(1000)  
Declare @TempId   int  
Declare @MaxTempId int  
  
  
Set @TempId = 1  
  
            Create table #Temp1  
            (TempId int identity,  
             TempValue varchar(200)  
            )  
   
            Insert into #Temp1  
            (TempValue)  
   select   
   mn.MedicationName  
   from ClientMedications as cm  
   join MDMedicationNames as mn on mn.MedicationNameId = cm.MedicationNameId  
    and isnull(mn.RecordDeleted,'N') <> 'Y'  
   where isnull(cm.RecordDeleted,'N') <> 'Y'  
   and isnull(cm.Discontinued,'N') <> 'Y'   
   and @ClientId = cm.ClientId  
   order by mn.MedicationName     
  
  
  
            --Find Diangosis in temp table for while loop  
            Set @MaxTempId = (Select Max(TempId) From #Temp1)  
  
            --Begin Loop to create Allergy List  
            While @TempId <= @MaxTempId  
            Begin  
                  Set @TempList = isnull(@TempList, '') +   
                        case when @TempId <> 1 then ', ' else '' end +   
                        (select isnull(TempValue, '')  
                        From #Temp1 t  
                        Where t.TempId = @TempId)  
                  Set @TempId = @TempId + 1  
            End   
            --End Loop  
  
   drop table #temp1  
     
     
   Select @TempList  
            
                                   
  
       
       
 END TRY                                      
 BEGIN CATCH                                      
    DECLARE @Error varchar(8000)                                                                         
   set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                        
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[csp_InitializeMedicationsForAssessment]')                                   
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                        
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                        
   RAISERROR                                                                         
   (                                   
   @Error, -- Message text.                                                                         
   16, -- Severity.                                      
   1 -- State.                                                                         
   )                                      
 END CATCH                                                    
End  
GO


