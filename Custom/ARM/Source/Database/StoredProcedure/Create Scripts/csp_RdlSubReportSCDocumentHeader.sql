/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportSCDocumentHeader]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportSCDocumentHeader]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlSubReportSCDocumentHeader]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportSCDocumentHeader]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE [dbo].[csp_RdlSubReportSCDocumentHeader]    
(            
    @DocumentVersionId int
)
/**************************************************************************************/                              
/*  Stored Procedure: csp_RdlSubReportSCDocumentHeader                                */                       
/*  Creation Date:  3 Jan 2013                                                        */                                     
/*  Purpose:    To retrieve Document Header data                                      */                                    
/*  Input Parameters: @DocumentVersionId                                              */                               
/*  Updates:                                                                          */
/*  Date            :   03/Jan/2013                                                   */
/*  Author          :   SWAPAN MOHAN                                                  */ 
/*  Purpose         :   Created                                                       */
/*  Description     :                                                                 */
/**************************************************************************************/                          
AS  
BEGIN               
    BEGIN TRY
        SELECT 
            top 1 DC.DocumentName,
            Doc.DocumentId,              
            (select OrganizationName from SystemConfigurations ) as OrganizationName,              
            ISNULL(client.FirstName, '''') + '' '' + ISNULL(client.LastName, '''') AS ClientName,
            client.ClientId as ClientId,  
            --isnull(pc.MasterClientId,Clients.ClientId) as ClientId,    
            GC.CodeName AS Status,               
            ISNULL(st.FirstName, '''') + '' '' + ISNULL(st.LastName, '''') AS StaffName,               
            CONVERT(varchar(12),Doc.EffectiveDate,101) as EffectiveDate,            
            --RIGHT(CONVERT(VARCHAR,Doc.EffectiveDate, 100),7) as EffectiveTime
            Doc.EffectiveDate  as EffectiveTime
        FROM  Documents Doc             
        INNER JOIN Clients client ON Doc.ClientId = client.ClientId             
        Inner join DocumentCodes DC on DC.DocumentCodeid= Doc.DocumentCodeId                
        INNER JOIN Staff st ON Doc.AuthorId = st.StaffId               
        INNER JOIN DocumentVersions DV ON Doc.DocumentId=DV.DocumentId
        INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = Doc.[Status]
        Where DV.DocumentVersionId = @DocumentVersionID
        AND ISNULL(Doc.RecordDeleted,''N'')=''N''
        AND ISNULL(client.RecordDeleted,''N'')=''N''
        AND ISNULL(DC.RecordDeleted,''N'')=''N''
        AND ISNULL(st.RecordDeleted,''N'')=''N''
        AND ISNULL(DV.RecordDeleted,''N'')=''N''
        AND ISNULL(GC.RecordDeleted,''N'')=''N''
    END TRY
    BEGIN CATCH
		declare @Error varchar(8000)                            
		set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                             
		+ ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_RdlSubReportSCDocumentHeader'')                             
		+ ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                              
		+ ''*****'' + Convert(varchar,ERROR_STATE())                                                   
		RAISERROR(@Error,16,1); 
    END CATCH
END


' 
END
GO
