
/****** Object:  View [dbo].[ViewMUIPPatientPortal]    Script Date: 04/11/2018 19:10:51 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ViewMUIPPatientPortal]'))
DROP VIEW [dbo].[ViewMUIPPatientPortal]
GO

/****** Object:  View [dbo].[ViewMUIPPatientPortal]    Script Date: 04/11/2018 19:11:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


 
CREATE view [dbo].[ViewMUIPPatientPortal] as        
/********************************************************************************        
-- View: dbo.ViewClientServices          
--        
-- Copyright: Streamline Healthcate Solutions        
--        
-- Purpose: returns all Patient portal
-- Updates:                                                               
-- Date        Author      Purpose        
-- 21.10.2017  Gautam     Created.   Why:Meaningful Use - Stage 3 > Tasks #46 > Stage 3 Reports           
*********************************************************************************/    
    
 SELECT   S.ClientId     ,
 D.DocumentId,
 S.ClinicianId,
 cast(S.DischargedDate AS DATE)  as DischargedDate   ,
 CP.AssignedStaffId      ,    
 S.AdmitDate, 
   RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName    
        FROM dbo.ClientInpatientVisits S                                        
        INNER JOIN [dbo].ssf_MUPOSAdmitTypeValues() POS ON POS.GlobalCodeId = S.AdmissionType                                        
        INNER JOIN dbo.BedAssignments BA ON BA.ClientInpatientVisitId = S.ClientInpatientVisitId                                        
        INNER JOIN dbo.ClientPrograms CP ON CP.ProgramId = BA.ProgramId                                        
         AND CP.ClientId = S.ClientId                                        
        INNER JOIN dbo.Clients C ON S.ClientId = C.ClientId                                        
        INNER JOIN dbo.DOCUMENTS D ON D.ClientId = S.ClientId                                        
      AND D.DocumentCodeId = 1611                                        
        INNER JOIN dbo.TransitionOfCareDocuments CS ON CS.DocumentVersionId = D.CurrentDocumentVersionId                                                                      
                                                                          
        WHERE S.STATUS <> 4981 --   4981 (Schedule)                                                              
         AND isnull(S.RecordDeleted, 'N') = 'N'                                        
         AND isnull(BA.RecordDeleted, 'N') = 'N'                                        
         AND isnull(CP.RecordDeleted, 'N') = 'N'                                        
    AND isnull(C.RecordDeleted, 'N') = 'N'                                        
         AND isnull(D.RecordDeleted, 'N') = 'N'                                     
         AND isnull(CS.RecordDeleted, 'N') = 'N'     
         --AND CP.AssignedStaffId= @StaffId                                                        
         AND S.DischargedDate IS NOT NULL                                                                         
                                        


GO


