/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportServiceNoteFooter]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportServiceNoteFooter]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlSubReportServiceNoteFooter]
GO

/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportServiceNoteFooter]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_RdlSubReportServiceNoteFooter]             
@DocumentVersionId int        
as              
/*              
** Object Name:  [csp_ViewModeCustomActEntranceStayCriteriaFooter]              
**              
**              
** Notes:  Accepts two parameters (DocumentId & Version) and returns a record set               
**    which matches those parameters. This procedure is used for displaying the              
**    footer information.              
**              
** Programmers Log:              
** Date  Programmer  Description              
**------------------------------------------------------------------------------------------              
** 19/07/2007 ETECH   Procedure Created.              
*/              
Select               
 SignerName,               
 SignatureDate,              
 SignatureOrder ,             
case  when DV.Version > 1 then            
d.ModifiedBy             
else            
''            
End            
 AmmendedBy,           
          
case when DV.Version > 1 then            
d.ModifiedDate             
else            
''            
end AmmendedDate            
            
from Documents d            
join DocumentSignatures ds  on ds.documentid = d.documentid            
join DocumentVersions DV on DV.DocumentId = d.DocumentId and isnull(DV.RecordDeleted,'N')<>'Y'                         
where  DV.DocumentVersionId = @DocumentVersionId            
and isnull(d.RecordDeleted,'N')<>'Y'            
and ds.signatureorder = 1               
and isnull(ds.RecordDeleted,'N')<>'Y'               
order by SignatureOrder

GO


