/****** Object:  StoredProcedure [dbo].[csp_RDLCustomMedicalNotePhysicalExamAreas]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomMedicalNotePhysicalExamAreas]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomMedicalNotePhysicalExamAreas]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomMedicalNotePhysicalExamAreas]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_RDLCustomMedicalNotePhysicalExamAreas]                           
(                              
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010
)                              
As                              
                                      
Begin                                      
/*********************************************************************/                                        
/* Stored Procedure: csp_RDLCustomMedicalNotePhysicalExamAreas    */                               
                              
/* Copyright: 2006 Streamline SmartCare*/                                        
                              
/* Creation Date:  Oct 15 ,2007                                  */                                        
/*                                                                   */                                        
/* Purpose: Gets Data for CrisisInterventions  */                                       
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
      
select GC.CodeName,GSC.SubCodeName,PhyExam.PEAreaValue ,PhyExam.ExamAreaNormal,PhyExam.ExamAreaComment,PhyExamSubAreas.PESubAreaValue 
from CustomMedicalNotePhysicalExamAreas PhyExam      
right join  globalcodes GC on PhyExam.PEAreaType=GC.GlobalCodeId      
left join CustomMedicalNotePhysicalExamSubAreas PhyExamSubAreas on PhyExam.PEAreaId=PhyExamSubAreas.PEAreaId   
																and ISNull(PhyExamSubAreas.RecordDeleted,''N'')=''N''	
																and isnull(PESubAreaValue, ''N'')= ''Y''     
left join  globalsubcodes GSC on PhyExamSubAreas.PESubAreaType=GSC.GlobalSubCodeId      
--where PhyExam.DocumentId=@DocumentId and PhyExam.Version=@Version 
where PhyExam.DocumentVersionId=@DocumentVersionId   --Modified by Anuj Dated 03-May-2010
and ISNull(PhyExam.RecordDeleted,''N'')=''N'' 
and isnull(PEAreaValue, ''N'')= ''Y''
                   
  --Checking For Errors                              
  If (@@error!=0)                              
  Begin                              
   RAISERROR  20006   ''csp_RDLCustomMedicalNotePhysicalExamAreas : An Error Occured''                               
   Return                              
   End                                       
                              
End
' 
END
GO
