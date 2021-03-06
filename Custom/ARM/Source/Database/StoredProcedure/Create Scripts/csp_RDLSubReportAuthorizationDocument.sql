/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportAuthorizationDocument]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportAuthorizationDocument]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportAuthorizationDocument]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportAuthorizationDocument]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE	PROCEDURE  [dbo].[csp_RDLSubReportAuthorizationDocument]  
(  
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010
)  
As  
          
Begin          
/************************************************************************/            
/* Stored Procedure: dbo.csp_RDLSubReportAuthorizationDocument			*/   
/* Copyright: 2006 Streamline SmartCare									*/            
/* Creation Date: June 19, 2008											*/
/*																		*/            
/* Purpose: Populates data for Custom Authorization Documents RDL		*/           
/* Input Parameters: DocumentID,Version									*/          
/* Output Parameters:													*/            
/* Return:																*/            
/* Calls:																*/
/* Author: Rupali Patil													*/
/************************************************************************/             
        
Select	case isnull(P.ProviderName ,''N'')    
			when ''N'' then ''''    
			else P.ProviderName     
		 end       
		 +    
		 case isnull(Tp.ProviderId,''0'')    
			when ''0'' then Ag.AgencyName    
			else ''''    
		 end AS ProviderName
		,A.AuthorizationCodeName
		,TP.Units
		,TP.StartDate
		,TP.EndDate
		,TP.TotalUnits
		,GCFreq.CodeName as Frequency
		,CAD.AuthorizationRequestorComment
From Agency Ag, TpProcedures TP
Left Join Providers P on P.ProviderID = TP.ProviderID 
--Join CustomAuthorizationDocuments CAD on CAD.DocumentId = Tp.DocumentId and CAD.Version = Tp.Version
Join CustomAuthorizationDocuments CAD on CAD.DocumentVersionId = Tp.DocumentVersionId  --Modified by Anuj Dated 03-May-2010
inner join AuthorizationCodes A on TP.AuthorizationCodeID = A.AuthorizationCodeID and isnull(A.RecordDeleted, ''N'') = ''N''
left join GlobalCodes GCFreq on GCFreq.GlobalCodeId = Tp.FrequencyType  and isnull(GCFreq.RecordDeleted, ''N'') =''N''
--where Tp.DocumentID = @DocumentId 
--and TP.Version = @Version
where Tp.DocumentVersionId = @DocumentVersionId  --Modified by Anuj Dated 03-May-2010

and isnull(P.RecordDeleted, ''N'') = ''N'' 
and isnull(TP.RecordDeleted,''N'') =''N''

--Checking For Errors  
If (@@error!=0)  
	Begin  
		RAISERROR  20006   ''csp_RDLSubReportAuthorizationDocument: An Error Occured''   
		Return  
	End  
End
' 
END
GO
