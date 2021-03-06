/****** Object:  StoredProcedure [dbo].[csp_RDLCustomMedicalNoteROS]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomMedicalNoteROS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomMedicalNoteROS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomMedicalNoteROS]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_RDLCustomMedicalNoteROS]                  
(                                    
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010
)                                    
As                                    
                                            
Begin                                            
/*********************************************************************/                                              
/* Stored Procedure: csp_RDLCustomMedicalNoteROS    */                                     
                                    
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
select  GC.CodeName,GSC.SubCodeName,ROS.ROSValue ,ROS.ROSComment,ROSA.AbnormalAreaValue 
from CustomMedicalNoteReviewsOfSystems ROS         
right join  globalcodes GC on ROS.ROSType=GC.GlobalCodeId    
								and ISNull(GC.RecordDeleted,''N'')=''N''         
left join CustomMedicalNoteROSAbnormalAreas ROSA on ROS.ROSId=ROSA.ROSId   
								and ISNull(ROSA.RecordDeleted,''N'')=''N''   
								and isnull(ROSA.AbnormalAreaValue, ''N'')= ''Y''
left join  globalsubcodes GSC on ROSA.AbnormalAreaType=GSC.GlobalSubCodeId  
								and GSC.GlobalCodeid=GC.GlobalCodeId     
								and ISNull(GSC.RecordDeleted,''N'')=''N''    
--where ROS.DocumentId=@DocumentId 
--and ROS.Version=@Version 
where ROS.DocumentVersionId= @DocumentVersionId   --Modified by Anuj Dated 03-May-2010
and ISNull(ROS.RecordDeleted,''N'')=''N''    
                                    
  --Checking For Errors                                    
  If (@@error!=0)                                    
  Begin                                    
   RAISERROR  20006   ''csp_RDLCustomMedicalNoteROS : An Error Occured''                                     
   Return                                    
   End                                             
                                    
End
' 
END
GO
