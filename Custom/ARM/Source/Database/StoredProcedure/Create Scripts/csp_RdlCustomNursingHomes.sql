/****** Object:  StoredProcedure [dbo].[csp_RdlCustomNursingHomes]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlCustomNursingHomes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlCustomNursingHomes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlCustomNursingHomes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE  [dbo].[csp_RdlCustomNursingHomes]    
(                
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010                
)                
As                
                        
Begin                        
/********************************************************************/                          
/* Stored Procedure: csp_RdlCustomNursingHomes						*/                                 
/* Copyright: 2006 Streamline SmartCare								*/                                          
/* Creation Date:  Oct 26th ,2007									*/                          
/*                                                                  */                          
/* Purpose: Gets Data from CustomNursingHomes						*/                         
/*                                                                  */                        
/* Input Parameters: DocumentID,Version								*/                        
/* Output Parameters:												*/                          
/* Purpose Use For Rdl Report										*/                
/* Calls:                                                           */                          
/*                                                                  */                          
/* Author: Ranjeetb													*/                          
/* Modified by: Rupali Patil										*/
/* Modified date: 6/4/2008											*/
/* Modified: Added ClientID in the select list                      */        
/* Modified: av corrected joins                      */                                            
/********************************************************************/                           

SELECT	Documents.ClientID
		,CustomNursingHomes.GoalsAddressed
		,CustomNursingHomes.CurrentDiagnosis
		,CustomNursingHomes.CurrentTreatmentPlan
        ,CustomNursingHomes.StaffConsultation
		,CustomNursingHomes.ChartReview
		,CustomNursingHomes.VisitNoted
		,CustomNursingHomes.VisitNotedNote
		,CustomNursingHomes.Intervention
		,CustomNursingHomes.AxisV
		,CustomNursingHomes.MedicationInformation
		,DiagnosisAxisVRanges.LevelDescription
		,Services.DiagnosisCode1
		,Services.DiagnosisCode2
		,Services.DiagnosisCode3
FROM  Documents
Join DocumentVersions dv on dv.DocumentId=Documents.DocumentId and isnull(dv.RecordDeleted,''N'')=''N''
--left Join CustomNursingHomes  ON  CustomNursingHomes.DocumentID = Documents.DocumentID and CustomNursingHomes.Version = @Version   
left Join CustomNursingHomes  ON  CustomNursingHomes.DocumentVersionId = dv.DocumentVersionId   --Modified by Anuj Dated 03-May-2010     
Left JOIN DiagnosisAxisVLevels ON DiagnosisAxisVLevels.LevelNumber = CustomNursingHomes.AxisV
Left JOIN DiagnosisAxisVRanges ON DiagnosisAxisVRanges.LevelStart = DiagnosisAxisVLevels.LevelStart
INNER JOIN  Services ON Documents.ServiceId = Services.ServiceId
Where ISNull(CustomNursingHomes.RecordDeleted,''N'') = ''N'' 
--and Documents.Documentid = @DocumentId 
and dv.DocumentVersionId = @DocumentVersionId  --Modified by Anuj Dated 03-May-2010     
                
                         
  --Checking For Errors                
If (@@error!=0)                
	Begin                
		RAISERROR  20006   ''csp_RdlCustomNursingHomes : An Error Occured''                 
		Return                
	End                                     
End
' 
END
GO
