/****** Object:  StoredProcedure [dbo].[ssp_SCWebGetHRMTPClientNeeds]    Script Date: 11/18/2011 16:26:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebGetHRMTPClientNeeds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWebGetHRMTPClientNeeds]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCWebGetHRMTPClientNeeds]                                        
                                                 
@ClientId int,                                              
@DocumentId int,                                              
@ForInitialization char(1),          
@DocumentVersionId int                                                  
                                                   
AS                                                  
/******************************************************************************                                                        
**  File:                                                         
**  Name: [ssp_SCGetHRMTPClientNeeds]                                                        
**  Desc:  called by ssp_SCGetTreatmentPlanHRM                                                      
**                                                        
**  This template can be customized:                                                        
**                                                                      
**  Return values:                                                        
**                                                         
**  Called by: ssp_SCGetTreatmentPlanHRM                                                           
**                                                                      
**  Parameters:                                                        
**  Input    Output                                                        
**  @ClientId                                                   
**                                                  
**                                                    
**                                                  
**  Auth:  Sonia Dhamija                                                       
**  Date:  09/07/2008                                                       
*******************************************************************************                                                        
**  Change History                                                        
*******************************************************************************                                                        
**  Date:  Author:    Description:                                                        
**  27/08/2008 Sonia Modified                                 
**With Reference to Task #260                                 
**For new needs added in the context of the current treatment plan/version, the radio buttons and check box and delete options should always be available.                                
                                 
**--------  --------    ----------------------------------------------------                                                        
/* 09/April/09 Priya Modified the table Clientneeds to CustomClientNeeds and TPNeedsClientNeeds to  CustomTPNeedsClientNeeds */                                                 
     May 28,2009:updated by munish singla in lieu of task 3108 to comment the print statement       
/* 29/Jan/15 Md Hussain Khusro  Uncommented the Record Delete check condition and Added Inner Join with Documents table to filter the records from deleted documents 
								w.r.t to task #141 Customiztion Bugs */ 
/*7/4/2016   Hemant             Removed the check  "AND C.SourceDocumentVersionId = @DocumentVersionId".Why:Newaygo - Support #541*/
/*08/08/2016 Suneel N.			Modified code for getting ClientEpisodeId by passing clientId. Why: #647.6 Network180 Environment Issues Tracking.*/
/*01/10/2018 Hemant             What?Changed the CurrentDocumentVersionId to InprogressDocumentVersionId 
                                Why? To avoid the dataloss. Project:WMU - Support Go Live #424

*/								                         
*******************************************************************************/                                                      
BEGIN 
    BEGIN TRY 
        DECLARE @CurrentEpisodeNumber INT 
        DECLARE @ClientEpisodeId INT 
		SET @ClientEpisodeId=0      
		SELECT top 1 @ClientEpisodeId =Isnull(ClientEpisodeId,0) from ClientEpisodes where ISNull(RecordDeleted,'N')='N' and ClientId=@ClientId          
		order by  EpisodeNumber desc        
		
        SELECT DISTINCT 'CustomClientNeeds' AS TableName, 
                        C.ClientNeedId,
                        C.ClientEpisodeId,
                        C.NeedName,
                        C.NeedDescription,
                        C.NeedStatus,
                        C.AssociatedHRMNeedId,
                        C.SourceDocumentVersionId,
                        C.AssessmentUpdateType,
                        C.DiagnosisUpdateRequired,
                        C.NeedCreatedByName,
                        C.RowIdentifier,
                        C.CreatedBy,
                        C.CreatedDate, 
                        C.CreatedDate AS 'NeedDate',
                        C.ModifiedBy,
                        C.ModifiedDate,
                        C.RecordDeleted,
                        C.DeletedDate,
                        C.DeletedBy
        FROM   CustomClientNeeds C 
			-- Added by Hussain Khusro on 01/29/2015--------
			-- Modified by Hemant on 01/10/2018 
               INNER JOIN Documents D ON D.InprogressDocumentVersionId = C.SourceDocumentVersionId AND Isnull(D.RecordDeleted, 'N') <> 'Y' 
            -- Changes End---------------------------------   
        WHERE  C.ClientEpisodeId = @ClientEpisodeId 
               --Commented By Vikas Vyas       
               AND Isnull(C.RecordDeleted, 'N') <> 'Y' -- Uncommented by Hussain Khusro on 01/29/2015
    END TRY 

    BEGIN catch 
        DECLARE @Error VARCHAR(8000) 

        SET @Error= CONVERT(VARCHAR, Error_number()) + '*****' 
                    + CONVERT(VARCHAR(4000), Error_message()) 
                    + '*****' 
                    + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                    'ssp_SCWebGetHRMTPClientNeeds') 
                    + '*****' + CONVERT(VARCHAR, Error_line()) 
                    + '*****' + CONVERT(VARCHAR, Error_severity()) 
                    + '*****' + CONVERT(VARCHAR, Error_state()) 


        RAISERROR ( @Error, -- Message text.                                                       
                    16, -- Severity.                                                       
                    1 -- State.                                                       
        ); 
    END catch 
END 