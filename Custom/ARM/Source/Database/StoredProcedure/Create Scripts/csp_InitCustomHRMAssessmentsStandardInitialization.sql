/****** Object:  StoredProcedure [dbo].[csp_InitCustomHRMAssessmentsStandardInitialization]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomHRMAssessmentsStandardInitialization]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomHRMAssessmentsStandardInitialization]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomHRMAssessmentsStandardInitialization]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitCustomHRMAssessmentsStandardInitialization]                                    
(                                                                                                                                                                                                                
 @ClientID int,                                                                                                                                                                                          
 @StaffID int,                                                                                                                                                                                        
 @CustomParameters xml                                                                                                                                                                                                                
)                                                                                                                                                                                                                                        
As                                                                                                                                                                                                                                                
 /*********************************************************************/                                                                                                                                                                                       
  
    
                
 /* Stored Procedure: [[csp_InitCustomHRMAssessmentsStandardInitialization]]                */                                                                                                                                                                 
  
    
                                
 /* Copyright: 2006 Streamline SmartCare*/                                                                                                                                                                                                                     
  
    
 /* Creation Date:  24/Feb/2010                                    */                                                                                                                                                                                          
  
    
 /*                                                                   */                                                                                                                                                                                       
  
    
 /* Purpose: To Initialize CustomPAAssessments Documents*/                                                                                                                                                                                                     
  
    
 /*                                                                   */                                                                                                                                                                                       
  
    
 /* Input Parameters: @ClientID, @StaffID, @CustomParameters    eg:- 14309,92,''N'' */                                                                       
 /*    */                                                             
 /* Output Parameters: */                                        
 /*  */                                                                            
 /* Return:                                                                                                             
 /* Called By:CustomDocuments Class Of DataService    */                   
 /* Calls:   */                        
 /*                                         */   
 /* Data Modifications:                                   */                                                                                                                                                                                          
 /*   Updates:                                        */                                                                                                                                                                     
 /*       Date              Author                Purpose  */                                                                                                                                                                    
                              
 /*       Sandeep Singh   */                                                                                                                                                                      
 /*********************************************************************/                                                                                                                                                                                      
  
     
      
    */    
          
            
              
BEGIN                                                                                                                                                                                                                                                 
Begin try                                                                            
                                                                           
--Declare Default Variables                                    
                                           
declare @later datetime                       
set @later= GETDATE()                                                                                                                                                             
declare @LatestDocumentVersionID int                                                                                                                                                               
declare @clientName varchar(100)                                                                                                                                                              
declare @clientDOB varchar(50)                                                                                                                                                              
declare @clientAge varchar(50)                 
declare @InitialRequestDate datetime                                                                          
                                                                          
set @clientName = (Select C.LastName + '', '' + C.FirstName as ClientName from Clients C                                                                                                                                                                         
  
    
      
    where C.ClientId=@ClientID and IsNull(C.RecordDeleted,''N'')=''N'')                                                               
set @clientDOB = (Select CONVERT(VARCHAR(10), DOB, 101)  from Clients                                                                                     
    where ClientId=@ClientID and IsNull(RecordDeleted,''N'')=''N'')                                                                          
--set @clientAge = (Select Cast(DateDIFF(yy,DOB,@later)-CASE WHEN @later>=DateAdd(yy,DateDIFF(yy,DOB,@later), DOB) THEN 0 ELSE 1 END as varchar(10))  AS Age from Clients C                                             
--where C.ClientId=@ClientID and IsNull(C.RecordDeleted,''N'')=''N'')
Exec csp_CalculateAge @ClientID, @clientAge out                                                                                                                                          
                
set @InitialRequestDate=(Select Top 1 InitialRequestDate from ClientEpisodes CP where CP.ClientId=@ClientID            
      and IsNull(Cp.RecordDeleted,''N'')=''N'' and IsNull(CP.RecordDeleted,''N'')=''N'' order by CP.InitialRequestDate desc)                 
                                                                             
--Get AxisI and AxisII for Initial Tab                                                                                         
                                                                         
DECLARE @AxisIAxisIIOut nvarchar(1100)                                                                                                                                                      
                                                                                                                          
EXEC [dbo].[csp_HRMGetAxisIAxisII]                                                                                                                                                      
  @ClientID,                                                                                                                                                      
  @AxisIAxisIIOut OUTPUT                                        
                                           
                                           
--End declaration of Default variables                                    
SET ARITHABORT ON                                                                             
declare @AssessmentTypeCheck varchar(10)       
declare @CurrentAuthorId int                                   
set @AssessmentTypeCheck = @CustomParameters.value(''(/Root/Parameters/@ScreenType)[1]'', ''varchar(10)'' )                                                                
set @CurrentAuthorId = @CustomParameters.value(''(/Root/Parameters/@CurrentAuthorId)[1]'', ''int'' )                                                                
    
    
                                                             
                                
set @LatestDocumentVersionID=-1                              
 SET @LatestDocumentVersionID =(SELECT TOP 1 CurrentDocumentVersionId from CustomHRMAssessments C,Documents D                                                                              
  where C.DocumentVersionId=D.CurrentDocumentVersionId and D.ClientId=@ClientID                                                                                        
 and D.Status=22 and IsNull(C.RecordDeleted,''N'')=''N'' and IsNull(D.RecordDeleted,''N'')=''N''         
 and DocumentCodeId in (1469, 349)              
 ORDER BY D.EffectiveDate DESC,D.ModifiedDate desc              
               
 )           
                                            
                                           
IF( (@AssessmentTypeCheck=''U'' OR @AssessmentTypeCheck=''I'' OR @AssessmentTypeCheck=''A'' AND @AssessmentTypeCheck !='''') AND @LatestDocumentVersionID>0 )                                        
--Execute Store Procedure based on Assessment Type                                    
 BEGIN                                                                          
     exec scsp_SCHRMGetRecentSignedAssessment   @ClientId,@AssessmentTypeCheck,@LatestDocumentVersionID,@clientAge,@AxisIAxisIIOut,@InitialRequestDate,@clientDOB,@CurrentAuthorId                                                           
     return                                     
                                                                        
 END                                         
 ELSE                                                                  
 Begin                                    
                
    exec  csp_InitCustomHRMAssessmentDefaultIntialization @ClientID,@AxisIAxisIIOut,@clientAge,@AssessmentTypeCheck,@InitialRequestDate,@LatestDocumentVersionID,@clientDOB,@CurrentAuthorId                                                                  
   
                     
      
        
         
              
  END                                       
                                              
                    
End try                                   
                                 
                                    
BEGIN CATCH                                            
DECLARE @Error varchar(8000)                                
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                               
                                        
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitCustomHRMAssessmentsStandardInitialization'')                                                                             
 + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                                                          
   + ''*****'' + Convert(varchar,ERROR_STATE())                                                                             
 RAISERROR                                                                                               
 (                                                               
  @Error, -- Message text.                                                                                                                                    
16, -- Severity.                                                                                                                                                                                                                         
  1 -- State.                                                                                                                                                                                                                                             
 );                                                                                                                                                    
END CATCH                                                                                                                                                                                                          
END
' 
END
GO
