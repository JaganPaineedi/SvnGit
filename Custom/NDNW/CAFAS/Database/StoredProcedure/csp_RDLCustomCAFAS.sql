/****** Object:  StoredProcedure [dbo].[csp_RDLCustomCAFAS]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomCAFAS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomCAFAS]
GO


/****** Object:  StoredProcedure [dbo].[csp_RDLCustomCAFAS]    ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE   [dbo].[csp_RDLCustomCAFAS]
(        
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010 
)            
AS            
      
Begin      
/************************************************************************/                                            
/* Stored Procedure: [csp_RDLCustomCAFAS]								*/                                                                    
/* Copyright: 2006 Streamline SmartCare									*/                                                                              
/* Creation Date:  Dec 08 ,2007											*/                                            
/*																		*/                                            
/* Purpose: Gets Data from CustomCAFAS,SystemConfigurations,Staff,		*/
/*			Documents													*/                                           
/*																		*/                                          
/* Input Parameters: DocumentID,Version									*/                                          
/* Output Parameters:													*/                                            
/* Purpose Use For Rdl Report											*/                                  
/* Calls:																*/                                            
/*																		*/                                            
/* Author: Vikas Vyas													*/                                            
/*********************************************************************/              
SELECT	SystemConfig.OrganizationName
		,C.LastName + ', ' + C.FirstName as ClientName
		,Documents.ClientID
		,Documents.EffectiveDate
		,S.FirstName + ' ' + S.LastName  as ClinicianName  
		,[CAFASDate]  
		,S2.FirstName + ' ' + S2.LastName as [RaterClinician]  
		,GCInterval.CodeName as [CAFASInterval]  
		,[SchoolPerformance]  
		,[HomePerformance]  
		,[CommunityPerformance]  
		,[BehaviourTowardsOther]  
		,[MoodsEmotion]  
		,[SelfHarmfulBehavoiur]  
		,[SubstanceUse]  
		,[Thinkng]  
		,[PrimaryFamilyMaterialNeeds]  
		,[PrimaryFamilySocialSupport]  
		,[NonCustodialMaterialNeeds]  
		,[NonCustodialSocialSupport]  
		,[SurrogateMaterialNeeds]  
		,[SurrogateSocialSupport]  
--FROM [CustomCAFAS] CCAFAS join Documents ON  CCAFAS.DocumentId = Documents.DocumentId    
FROM [CustomCAFAS] CCAFAS 
join DocumentVersions dv with (nolock) on dv.DocumentVersionId = CCAFAS.DocumentVersionId and isnull(dv.RecordDeleted,'N')<>'Y'  
join Documents with (nolock) ON  dv.DocumentId = Documents.DocumentId  and isnull(documents.RecordDeleted,'N')<>'Y'               
join Staff S on Documents.AuthorId= S.StaffId and isnull(S.RecordDeleted,'N')<>'Y'   
left join Staff s2 on s2.StaffId = CCAFAS.RaterClinician   
join Clients C on Documents.ClientId= C.ClientId and isnull(C.RecordDeleted,'N')<>'Y'  
Left Join GlobalCodes GC On S.Degree=GC.GlobalCodeId and isNull(GC.RecordDeleted,'N')<>'Y'        
Left Join GlobalCodes GCInterval On CCAFAS.CAFASInterval=GCInterval.GlobalCodeId
Cross Join SystemConfigurations as SystemConfig  
--where CCAFAS .DocumentId=@DocumentId  
--and CCAFAS.Version=@Version 
where CCAFAS .DocumentVersionId=@DocumentVersionId  --Modified by Anuj Dated 03-May-2010
    
--Checking For Errors                                            
If (@@error!=0)                                            
	Begin                                            
		RAISERROR  20006   '[csp_RDLCustomCAFAS] : An Error Occured'                                             
		Return                                            
	End                                                           
End

GO


