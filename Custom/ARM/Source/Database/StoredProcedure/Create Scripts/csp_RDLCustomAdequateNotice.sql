/****** Object:  StoredProcedure [dbo].[csp_RDLCustomAdequateNotice]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomAdequateNotice]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomAdequateNotice]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomAdequateNotice]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE   [dbo].[csp_RDLCustomAdequateNotice] 
(
--@DocumentId int,             
--@Version int  
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010          
)            
AS            
      
Begin      
/************************************************************************/                                            
/* Stored Procedure: [csp_RDLCustomAdequateNotice]						*/                                   
/* Copyright: 2006 Streamline SmartCare									*/                                            
/* Creation Date:  May 11th ,2008										*/                                            
/*																		*/                                            
/* Purpose: Gets Data from CustomAdequateNotice,SystemConfigurations,	*/
/*			Staff,Documents												*/                                           
/*																		*/                                          
/* Input Parameters: DocumentID,Version									*/                                          
/* Output Parameters:													*/                                            
/* Purpose: Use For Rdl Report											*/                                  
/* Calls:																*/                                            
/* Author: Rupali Patil													*/                                            
/*********************************************************************/              
SELECT	SystemConfig.OrganizationName,    
		C.LastName + '', '' + C.FirstName as ClientName,       
		Documents.ClientID,    
		Documents.EffectiveDate      
		,S.FirstName + '' '' + S.LastName + '',  '' + ISNull(GC.CodeName,'''') as ClinicianName  
		,[GuardianName]
		,rtrim(CAN.[Address]) as [Address]
		,CAN.[City] as [City]
		,CAN.[State] as [State]
		,CAN.[Zip] as [Zip]
		,[DateOfNotice]
		,[PrimaryStaffId]
		,[StaffPosition]
		,GCDirector.CodeName as [Director]
		,[MedicaidCustomer]
		,[MedicaidID]
		,[ReasonForNotice]
		,[DischargeFromAgency]
		,[ServiceDenied]
		,[ServiceDeniedReason]
		,[PersonCenteredPlan]		
		,[AlertSent]
		,[PrimaryStaffDisplayAs]
		,C.FirstName as ClientFirstName
FROM [CustomAdequateNotice] CAN 
join DocumentVersions as dv on dv.DocumentVersionId = CAN.DocumentVersionId
join Documents ON  Documents.DocumentId = dv.DocumentId
join Staff S on Documents.AuthorId= S.StaffId and isnull(S.RecordDeleted,''N'')<>''Y''      
join Clients C on Documents.ClientId= C.ClientId and isnull(C.RecordDeleted,''N'')<>''Y''  
Left Join GlobalCodes GC On GC.GlobalCodeId = S.Degree and isNull(GC.RecordDeleted,''N'')<>''Y''
Left Join GlobalCodes GCDirector On GCDirector.GlobalCodeId=CAN.Director and isNull(GC.RecordDeleted,''N'')<>''Y''        
Cross Join SystemConfigurations as SystemConfig  
--where CAN.DocumentId = @DocumentId  
--and CAN.Version = @Version      
where CAN.DocumentVersionId=@DocumentVersionId    --Modified by Anuj Dated 03-May-2010  

--Checking For Errors                                            
If (@@error!=0)                                            
	Begin                                            
		RAISERROR  20006   ''[csp_RDLCustomAdequateNotice] : An Error Occured''                                             
		Return                                            
	End                                                     
End
' 
END
GO
