/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomBehaviorTxPlan]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomBehaviorTxPlan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomBehaviorTxPlan]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomBehaviorTxPlan]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE  [dbo].[csp_SCGetCustomBehaviorTxPlan]                                    
  @DocumentVersionId INT                                     
AS                                    
 /****************************************************************************/                                                  
 /* Stored Procedure:csp_SCGetCustomBehaviorTxPlan                           */                                         
 /* Copyright: 2006 Streamlin Healthcare Solutions                           */       
 /* Author: Pradeep                                                          */                                                 
 /* Creation Date:  Aug 20,2009                                              */                                                  
 /* Purpose: Gets Data for Custom BehaviorTxPlan Document                    */                                                 
 /* Input Parameters: @DocumentId, @DocumentVersionId                        */                                                
 /* Output Parameters:None                                                   */                                                  
 /* Return:                                                                  */                                                  
 /* Calls:                                                                   */      
 /* Called From:                                                             */                                                  
 /* Data Modifications:                                                      */                                                  
 /*-------------Modification History--------------------------               */  
 /*-------Date----Author-------Purpose---------------------------------------*/   
 /* 11 Sept,2009  Pradeep      Made changes as per dataModel Venture3.0      */  
 /* 03/04/2010 Vikas Monga              */    
 /* -- Remove [Documents] and [DocumentVersions]        */                          
 /****************************************************************************/                                                   
BEGIN                      
    BEGIN TRY                          
    -- For CustomBehaviorTxPlan table                   
 SELECT     DocumentVersionId, Type, CustomBehaviorTxPlan.DOB, Age, PrimaryClinician,Staff.LastName + '','' + Staff.FirstName AS PrimaryClinicianName,
		Psychologist, Diagnosis, IdentifyingInformation, MedType1, MedDosage1, MedPurpose1, MedPhysician1,   
       MedType2, MedDosage2, MedPurpose2, MedPhysician2, MedType3, MedDosage3, MedPurpose3, MedPhysician3, MedType4, MedDosage4, MedPurpose4,   
       MedPhysician4, MedType5, MedDosage5, MedPurpose5, MedPhysician5, MedType6, MedDosage6, MedPurpose6, MedPhysician6, MedType7, MedDosage7,   
       MedPurpose7, MedPhysician7, MedType8, MedDosage8, MedPurpose8, MedPhysician8, MedType9, MedDosage9, MedPurpose9, MedPhysician9,   
       BackgroundInformation, GoalDetail, ChallengingBehaviors, CurrentLevel, Objective, RecordingMethod, TPPreventative, TPProactive, TPIntervention, CustomBehaviorTxPlan.CreatedBy,   
       CustomBehaviorTxPlan.CreatedDate, CustomBehaviorTxPlan.ModifiedBy, CustomBehaviorTxPlan.ModifiedDate, 
       CustomBehaviorTxPlan.RecordDeleted, CustomBehaviorTxPlan.DeletedDate, CustomBehaviorTxPlan.DeletedBy  
 FROM         CustomBehaviorTxPlan  
  LEFT OUTER JOIN Staff on Staff.StaffId=CustomBehaviorTxPlan.PrimaryClinician
 WHERE     (ISNULL(CustomBehaviorTxPlan.RecordDeleted, ''N'') = ''N'') AND (DocumentVersionId = @DocumentVersionId)                                                 
 END TRY                      
 BEGIN CATCH                      
   DECLARE @Error varchar(8000)                                                         
   SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                        
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''[csp_SCGetCustomBehaviorTxPlan]'')                                                         
   + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****ERROR_SEVERITY='' + Convert(varchar,ERROR_SEVERITY())                                                        
   + ''*****ERROR_STATE='' + Convert(varchar,ERROR_STATE())                                                        
   RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );                                                    
 END CATCH                                    
End
' 
END
GO
