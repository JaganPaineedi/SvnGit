/****************************************************************************/                                                    
/*  
 Stored Procedure:csp_SCGetPrePlanningChecklistTest                                                                  
 Copyright: 2006 Streamlin Healthcare Solutions                                    
 Author: Pradeep                                                                                                             
 Creation Date:  Aug 20,2009                                                                                                  
 Purpose: Gets Data for PrePlanning CheckList Document                                                                       
 Input Parameters: @DocumentId, @DocumentVersionId                                                                          
 Output Parameters:None                                                                                                       
 Return:                                                                                                                      
 Calls:                                                                           
 Called From:                                                                                                                 
 Data Modifications:                                                                                                          
  
 -------------Modification History--------------------------                   
 -------Date----Author-------Purpose---------------------------------------     
 11 Sept,2009  Pradeep      Made changes as per dataModel Venture3.0     
 03/04/2010 Vikas Monga          
 Remove [Documents] and [DocumentVersions]                                 
  
 */                                                        
/****************************************************************************/                                                     
 
/****** Object:  StoredProcedure [dbo].[csp_SCGetPrePlanningChecklist]    Script Date: 11/13/2013 17:13:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetPrePlanningChecklist]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetPrePlanningChecklist]
GO



/****** Object:  StoredProcedure [dbo].[csp_SCGetPrePlanningChecklist]    Script Date: 11/13/2013 17:13:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO                                                   
  
CREATE PROCEDURE  [dbo].[csp_SCGetPrePlanningChecklist]                                     
  @DocumentVersionId INT                                       
AS                                          
BEGIN                        
   BEGIN TRY     
                                                          
   --For CustomPrePlanningChecklists Table                     
 SELECT     DocumentVersionId, Residential, OccupationalCommunityParticpation, Safety, Legal, Health, NaturalSupports, Other, Participants, Facilitator, Assessments,   
       TimeLocation, ISsuesToAvoid, CommunicationAccomodations, WishToDiscuss, SourceOfPrePlanningInformation, SelfDetermination, FiscalIntermediary,   
       PCPInformationPamphletGiven, PCPInformationDiscussed, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy  ,PrePlanIndependentFacilitatorDiscussed,
PrePlanIndependentFacilitatorDesired
 FROM         CustomPrePlanningChecklists  
 WHERE     (ISNULL(RecordDeleted, 'N') = 'N') AND (DocumentVersionId = @DocumentVersionId)                                                    
   
 END TRY   
                        
 BEGIN CATCH                        
   DECLARE @Error varchar(8000)                                                           
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                          
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[csp_SCGetPrePlanningChecklistTest]')                                                           
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                          
   + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                          
   RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );                                                    
 END CATCH                                      
End  