IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[csp_RdlSubReportUrinalysisHeader]') AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[csp_RdlSubReportUrinalysisHeader]
GO

SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO

Create Procedure [dbo].[csp_RdlSubReportUrinalysisHeader]    
(              
    @DocumentVersionId int  
)  
/**************************************************************************************/                                
/*  Stored Procedure: csp_RdlSubReportUrinalysisHeader                                */                         
/*  Creation Date:  19 jul 2013                                                        */                                       
/*  Purpose:    To retrieve Document Header data                                      */                                      
/*  Input Parameters: @DocumentVersionId                                              */                                 
/*  Updates:                                                                          */  
/*  Date            :   19/Jul/2013                                                   */  
/*  Author          :   Manju Padmanabhan                                             */   
/*  Purpose         :   Created                                                       */  
/*  Description     :                                                                 */  
/*	Modified By: Gayathri Naik		29/08/2012		Added  DiagnosisCode2,DiagnosisCode3
													column to display in the RDLCustomDocumentUrinalysisNote*/
/* Modified: Jan/16/2015 RCaffrey  To Comply with Service Diagnosis Data Model        */
/* Nov/13/2015     Hemant Kumar    Added Ser.OtherPersonsPresent to show the Other persons present on PDFs 
                                   (A Renewed Mind - Support #386)
   20th Dec 201 Kavya   Removing comma from clientName(FirstName LastName) and staffanme(FirstName LastName) as per task A Renewed Mind - Support: #764                               
*/												
/**************************************************************************************/                            
AS    
BEGIN    
  
 BEGIN TRY    
   
 SELECT   
            top 1 DC.DocumentName,  
            Doc.DocumentId,                
            (select AgencyName from Agency) as OrganizationName,                
            ISNULL(client.FirstName, '') + ' ' + ISNULL(client.LastName, '') AS ClientName,  
            client.ClientId as ClientId,    
            --isnull(pc.MasterClientId,Clients.ClientId) as ClientId,      
            GC.CodeName AS Status,                 
            ISNULL(st.FirstName, '') + ' ' + ISNULL(st.LastName, '') AS StaffName,                 
            CONVERT(varchar(12),Doc.EffectiveDate,101) as EffectiveDate,              
            --RIGHT(CONVERT(VARCHAR,Doc.EffectiveDate, 100),7) as EffectiveTime  
            Doc.EffectiveDate  as EffectiveTime,  
            Ser.DateOfService,  
            Ser.Unit,  
            Pcode.ProcedureCodeName,  
            Loc.LocationName,  
            sd1.DSMCode, 
            sd2.DSMCode,
            sd3.DSMCode, 
            dbo.csf_GetGlobalCodeNameById(Ser.UnitType) AS UnitType,
            Ser.OtherPersonsPresent 
        FROM  Documents Doc               
        INNER JOIN Clients client ON Doc.ClientId = client.ClientId               
        Inner join DocumentCodes DC on DC.DocumentCodeid= Doc.DocumentCodeId                  
        INNER JOIN Staff st ON Doc.AuthorId = st.StaffId                 
        INNER JOIN DocumentVersions DV ON Doc.DocumentId=DV.DocumentId  
        INNER JOIN GlobalCodes GC ON GC.GlobalCodeId = Doc.[Status]  
        INNER JOIN Services Ser ON Doc.ServiceId = Ser.ServiceId
        LEFT JOIN dbo.ServiceDiagnosis sd1 ON sd1.ServiceId = ser.ServiceId AND sd1.[Order] = 1 AND ISNULL(sd1.RecordDeleted, 'N') <> 'Y'
        LEFT JOIN dbo.ServiceDiagnosis sd2 ON sd2.ServiceId = ser.ServiceId AND sd2.[Order] = 2 AND ISNULL(sd2.RecordDeleted, 'N') <> 'Y'
        LEFT JOIN dbo.ServiceDiagnosis sd3 ON sd3.ServiceId = ser.ServiceId AND sd3.[Order] = 3 AND ISNULL(sd3.RecordDeleted, 'N') <> 'Y'  
        INNER JOIN Locations Loc ON Loc.LocationId = Ser.LocationId  
        INNER JOIN ProcedureCodes Pcode ON Pcode.ProcedureCodeId = Ser.ProcedureCodeId  
        Where DV.DocumentVersionId = @DocumentVersionID  
        AND ISNULL(Doc.RecordDeleted,'N')='N'  
        AND ISNULL(client.RecordDeleted,'N')='N'  
        AND ISNULL(DC.RecordDeleted,'N')='N'  
        AND ISNULL(st.RecordDeleted,'N')='N'  
        AND ISNULL(DV.RecordDeleted,'N')='N'  
        AND ISNULL(GC.RecordDeleted,'N')='N'  
 END TRY      

 BEGIN CATCH      
  DECLARE @Error VARCHAR(8000)      
   SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())      
    + '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'csp_RdlSubReportUrinalysisHeader')      
    + '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())      
    + '*****' + CONVERT(VARCHAR,ERROR_STATE())      
   RAISERROR      
   (      
    @Error, -- Message text.      
    16,  -- Severity.      
    1  -- State.      
   );      
 END CATCH      
END    
   
   

