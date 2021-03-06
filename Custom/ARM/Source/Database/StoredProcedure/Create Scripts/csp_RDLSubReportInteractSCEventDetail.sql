/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportInteractSCEventDetail]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportInteractSCEventDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportInteractSCEventDetail]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportInteractSCEventDetail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE Procedure [dbo].[csp_RDLSubReportInteractSCEventDetail]
(
    @DocumentVersionId int 
)
/**************************************************************************************/                              
/*  Stored Procedure: csp_RDLSubReportInteractSCEventDetail                                */                       
/*  Creation Date:  3 Jan 2013                                                        */                                     
/*  Purpose:    To retrieve Event detail data                                      */                                    
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
			CDEI.DocumentVersionId,
			--CONVERT(varchar(12),CDEI.EventDateTime,110) AS ''EventDate'',            
			CDEI.EventDateTime AS ''EventDate'', 
			CDEI.EventDateTime AS ''EventTime'',
			CDEI.InsurerId,
			GC.CodeName AS ''InsurerName''	
		FROM CustomDocumentEventInformations CDEI
		INNER JOIN GlobalCodes GC ON GC.GlobalCodeId=CDEI.InsurerId
		INNER JOIN DocumentVersions DV ON DV.DocumentVersionId=CDEI.DocumentVersionId
		WHERE CDEI.DocumentVersionId=@DocumentVersionId
    END TRY
    BEGIN CATCH
        declare @Error varchar(8000)                            
		set @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                             
		+ ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_RDLSubReportInteractSCEventDetail'')                             
		+ ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                              
		+ ''*****'' + Convert(varchar,ERROR_STATE())                                                   
		RAISERROR(@Error,16,1); 
    END CATCH
END


' 
END
GO
