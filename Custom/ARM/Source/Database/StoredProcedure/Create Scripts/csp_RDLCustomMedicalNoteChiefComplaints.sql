/****** Object:  StoredProcedure [dbo].[csp_RDLCustomMedicalNoteChiefComplaints]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomMedicalNoteChiefComplaints]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomMedicalNoteChiefComplaints]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomMedicalNoteChiefComplaints]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_RDLCustomMedicalNoteChiefComplaints]                       
(                          
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010
)                          
As                          
                                  
Begin                                  
/*********************************************************************/                                    
/* Stored Procedure: csp_RDLCustomMedicalNoteChiefComplaints    */                           
                          
/* Copyright: 2006 Streamline SmartCare*/                                    
                          
/* Creation Date:  Oct 30 ,2007                                  */                                    
/*                                                                   */                                    
/* Purpose: Gets Data for diagnosesIII,DiagnosisICDCodes  */                                   
/*                                                                   */                                  
/* Input Parameters: DocumentID,Version */                                  
/*                                                                   */                                     
/* Output Parameters:                                */                                    
/*                                                                   */                                    
/*    */                                    
/*                                                                   */                                    
/* Purpose Use For Rdl Report  */                          
/*      */                          
                          
/*                                                                   */                                    
/* Calls:                                                            */                                    
/*                                                                   */                                    
/* Author Rishu Chopra                                            */                                    
/*                                                                   */                                    
/*                                                             */                                    
                          
/*                                        */                                    
/*           */                                    
/*********************************************************************/     
SELECT Convert(varchar,GC.CodeName) as ChiefComplaint FROM CustomMedicalNote CMN  
Left Join  CustomMedicalNoteChiefComplaints CMNCC  on   
--(CMN.Documentid=CMNCC.DocumentId and CMN.Version=CMNCC.Version)  
(CMN.DocumentVersionId=CMNCC.DocumentVersionId)  --Modified by Anuj Dated 03-May-2010
left JOIN GlobalCodes GC on (GC.GlobalCodeID = CMNCC.ChiefComplaint)   
--where ISNull(CMN.RecordDeleted,''N'')=''N'' and ISNull(CMNCC.RecordDeleted,''N'')=''N'' and CMN.Documentid=@DocumentId and CMN.Version=@Version      
where ISNull(CMN.RecordDeleted,''N'')=''N'' and ISNull(CMNCC.RecordDeleted,''N'')=''N'' and CMN.DocumentVersionId= @DocumentVersionId    --Modified by Anuj Dated 03-May-2010 
 --Checking For Errors                          
  If (@@error!=0)                          
  Begin                          
   RAISERROR  20006   ''csp_RDLCustomMedicalNoteChiefComplaints : An Error Occured''                           
   Return                          
   End                                   
                          
End
' 
END
GO
