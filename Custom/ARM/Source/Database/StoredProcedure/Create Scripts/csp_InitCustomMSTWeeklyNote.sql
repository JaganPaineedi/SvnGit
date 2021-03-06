/****** Object:  StoredProcedure [dbo].[csp_InitCustomMSTWeeklyNote]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomMSTWeeklyNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomMSTWeeklyNote]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomMSTWeeklyNote]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_InitCustomMSTWeeklyNote]                             
(      
@ClientID int      
)                              
As                                
  
                                       
 Begin                                        
 /*********************************************************************/                                          
 /* Stored Procedure: [csp_InitCustomMSTWeeklyNote]               */                                 
                                 
 /* Copyright: 2006 Streamline SmartCare*/                                          
                                 
 /* Creation Date:  20/Aug/2007                                    */                                          
 /*                                                                   */                                          
 /* Purpose: Gets ChildsAge, */                                         
 /*                                                                   */                                        
 /* Input Parameters:  */                                        
 /*                                                                   */                                           
 /* Output Parameters:                                */                                          
 /*                                                                   */                                          
 /* Return:   */                                          
 /*                                                                   */                                          
 /* Called By:CustomDocuments Class Of DataService    */                                
 /*      */                                
                                 
 /*                                                                   */                                          
 /* Calls:                                                            */                                          
 /*                                                                   */                                          
 /* Data Modifications:                                               */                                          
 /*                                                                   */                                          
 /*   Updates:                                                          */                                          
                                 
 /*       Date              Author                  Purpose                                    */                                          
 /*       20/Aug/2007        Sonia Dhamija          To Retrieve Data      */              
 /*       1/21/2007         avoss					corrected to display actual data rather than dummy data     */                                                       
 /*********************************************************************/                                           
/*
declare @ClientId int
set @ClientId = 104496
*/   

Select 
dbo.GetAge(c.DOB,getdate()) as ChildsAge, 
	(select max(s.DateOfService) from services as s 
	where s.ClientId = @ClientId and s.Status=75 
	and s.ProcedureCodeId = 70 and isnull(s.RecordDeleted,''N'')<>''Y'' ) 
as IntakeDate,  
	(select count(s2.ServiceId)	from services as s2
	join procedureCodes as pc on pc.ProcedureCodeId = s2.ProcedureCodeId
		and isnull(pc.RecordDeleted,''N'')<>''Y''
		and isnull(pc.FaceToFace, ''N'') = ''Y''	
	where s2.ClientId = @ClientId and s2.Status=75
	and isnull(s2.RecordDeleted,''N'')<>''Y'' )
as FaceToFaceContacts, 
null as  FaceToFaceCollateralContacts,
	(select count(s3.ServiceId)	from services as s3
	join procedureCodes as pc2 on pc2.ProcedureCodeId = s3.ProcedureCodeId
		and isnull(pc2.RecordDeleted,''N'')<>''Y''
		and pc2.ProcedureCodeId = 145	--phone contact
	where s3.ClientId = @ClientId and s3.Status=75
	and isnull(s3.RecordDeleted,''N'')<>''Y'' )
as  PhoneContacts,
null as PhoneCollateralContacts,
	(select count(s4.ServiceId)	from services as s4
	where s4.ClientId = @ClientId and s4.Status in (72,73)
	and isnull(s4.RecordDeleted,''N'')<>''Y'' )
as SessionsCancelledOrMissed  
from Clients as c
where clientId = @ClientId      
               
 END                    
--Checking For Errors   
  
If (@@error!=0)   
  
Begin   
  
RAISERROR 20006 ''csp_InitCustomMSTWeeklyNote : An Error Occured''   
  
Return   
  
End
' 
END
GO
