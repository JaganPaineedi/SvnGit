/****** Object:  StoredProcedure [dbo].[csp_RDLCustomMedicationAdministrations]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomMedicationAdministrations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomMedicationAdministrations]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomMedicationAdministrations]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE  [dbo].[csp_RDLCustomMedicationAdministrations]  
(                                  
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010  
)                                  
As                                  
                                          
Begin                                          
/************************************************************************/                                            
/* Stored Procedure: csp_RDLCustomMedicationAdministrations				*/                                   
/* Copyright: 2006 Streamline SmartCare									*/                                            
/* Creation Date:  Oct 26, 2007											*/                                            
/*																		*/                                            
/* Purpose: Gets Data for CustomMedicationAdministrations				*/                                           
/*																		*/                                          
/* Input Parameters: DocumentID,Version									*/                                          
/* Output Parameters:													*/                                            
/* Purpose: Use For Rdl Report											*/                                  
/* Calls:																*/                                            
/* Author: Rishu Chopra													*/                                            
/* Modified by: Rupali Patil											*/
/*********************************************************************/                         
          
SELECT	Documents.ClientID
		,BloodPressure
		,Pulse
		,Respiratory
		,Weight
		,Intervention
		,ResponseToIntervention,AxisV
FROM CustomMedicationAdministrations CMA
--Join Documents on Documents.DocumentId = CMA.DocumentID
Join DocumentVersions dv on dv.DocumentVersionId=CMA.DocumentVersionId and ISNULL(dv.RecordDeleted,''N'')=''N''
Join Documents on Documents.DocumentId = dv.DocumentId   --Modified by Anuj Dated 03-May-2010
--where CMA.DocumentId = @DocumentId 
--and CMA.Version = @Version 
where CMA.DocumentVersionId = @DocumentVersionId   --Modified by Anuj Dated 03-May-2010
and ISNull(CMA.RecordDeleted,''N'') = ''N''          
                
--Checking For Errors                                  
If (@@error!=0)                                  
	Begin                                  
		RAISERROR  20006   ''csp_RDLCustomMedicationAdministrations : An Error Occured''                                   
		Return                                  
	End
End
' 
END
GO
