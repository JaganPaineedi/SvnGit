/****** Object:  StoredProcedure [dbo].[csp_RdlCustomNotes]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlCustomNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlCustomNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlCustomNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE  [dbo].[csp_RdlCustomNotes]  

(              

--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010                 

)              

As              

                      

Begin                      

/************************************************************************/                        

/* Stored Procedure: csp_RdlCustomNotes                                                   */               

/* Copyright: 2006 Streamline SmartCare                                                   */                                      

/* Creation Date:  Oct 25th ,2007                                                         */                        

/*                                                                                                          */                        

/* Purpose: Gets Data for Notes                                                                 */                       

/* Input Parameters: DocumentID,Version                                                   */                      

/* Output Parameters:                                                                           */                        

/* Purpose: Use For Rdl Report                                                                  */              

/* Calls:                                                                                             */                        

/* Author: Ranjeetb                                                                                   */                        

/* Modified by: Rupali Patil                                                              */                        

/* Modified date: 6/4/2008                                              */                        

/* Modified: Added ClientID to the select list                                      */

/************************************************************************/                         

                    

SELECT      Documents.ClientID

            ,Notes.PurposeAssessing

            ,Notes.PurposePrePlanning

            ,Notes.PurposeImplementingPCP

            ,Notes.PurposeLinking

            ,Notes.PurposeCrisisIntervention

            ,Notes.PurposeConsultation

            ,Notes.PurposePersonCenteredPlanning

            ,Notes.PurposeMonitoring

            ,Notes.PurposeOther

            ,Notes.PurposeOtherDescription

            ,Notes.GoalsAddressed

            ,Notes.NoteData

            ,Notes.NotePlan

            ,Notes.ClientResponseToIntervention

            ,Notes.AxisV

            ,Notes.ChangesToPlanNeeded

            ,Notes.ReferralNeeded

            ,Staff1.LastName + '', '' + Staff1.FirstName as [NotifyStaffId1]          

            ,Staff2.LastName + '', '' + Staff2.FirstName as[NotifyStaffId2]          

            ,Staff3.LastName + '', '' + Staff3.FirstName as[NotifyStaffId3]          

            ,Staff4.LastName + '', '' + Staff4.FirstName as [NotifyStaffId4]

            ,Notes.NotificationMessage

            ,Notes.Diagnosis

            ,Notes.CurrentTreatmentPlan

            ,GCServiceType.CodeName as ServiceType

            ,Notes.DBT

            ,Notes.CBT

            ,Notes.MET

            ,Notes.Nureobiofeedback

            ,Notes.Family

            ,Notes.InsightOriented

            ,Loc.LocationName

            ,Services.DiagnosisCode1

            ,Services.DiagnosisCode2

            ,Services.DiagnosisCode3

            ,Services.OtherPersonsPresent  

FROM  Documents
Join DocumentVersions dv on dv.DocumentId=Documents.DocumentId and isnull(dv.RecordDeleted,''N'')=''N''
INNER JOIN Services ON Documents.ServiceId = Services.ServiceId 
  
left JOIN Notes ON Notes.DocumentVersionId = dv.DocumentVersionId      --Modified by Anuj Dated 03-May-2010 

LEFT JOIN Locations Loc On Services.LocationId = Loc.LocationId 

LEFT JOIN GlobalCodes GCServiceType ON  Notes.ServiceType = GCServiceType.GlobalCodeId

LEFT JOIN Staff Staff1 On Notes.NotifyStaffId1 = Staff1.StaffId       

LEFT JOIN Staff Staff2 On Notes.NotifyStaffId2 = Staff2.StaffId       

LEFT JOIN Staff Staff3 On Notes.NotifyStaffId3 = Staff3.StaffId      

LEFT JOIN Staff Staff4 On Notes.NotifyStaffId4 = Staff4.StaffId   

where ISNull(Notes.RecordDeleted,''N'') = ''N'' 


and dv.DocumentVersionId = @DocumentVersionId   --Modified by Anuj Dated 03-May-2010 
   

              

                       

--Checking For Errors              

If (@@error!=0)              

      Begin              

            RAISERROR  20006   ''csp_RdlCustomNotes : An Error Occured''               

            Return              

      End                                 

End
' 
END
GO
