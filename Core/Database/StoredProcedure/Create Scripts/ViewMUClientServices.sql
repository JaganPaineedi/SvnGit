
/****** Object:  View [dbo].[ViewMUClientServices]    Script Date: 04/11/2018 19:04:44 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ViewMUClientServices]'))
DROP VIEW [dbo].[ViewMUClientServices]
GO



/****** Object:  View [dbo].[ViewMUClientServices]    Script Date: 04/11/2018 19:04:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

      
      
CREATE view [dbo].[ViewMUClientServices] as          
/********************************************************************************          
-- View: dbo.ViewClientServices            
--          
-- Copyright: Streamline Healthcate Solutions          
--          
-- Purpose: returns all Client Services    
-- Updates:                                                                 
-- Date        Author      Purpose          
-- 21.10.2017  Gautam     Created.   Why:Meaningful Use - Stage 3 > Tasks #46 > Stage 3 Reports             
*********************************************************************************/      
      
 SELECT S.ClinicianId,    
 S.ClientId,    
 S.ProcedureCodeId,    
 S.DateOfService as DateOfService,    
 S.DateOfService as DateOfServiceActual,    
   L.TaxIdentificationNumber            
  ,S.LocationId     
  ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName      
  ,P.ProcedureCodeName    
  ,S.ServiceId         
  FROM dbo.Services S                   
       INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                    
        AND ISNULL(C.RecordDeleted, 'N') = 'N'         
            INNER JOIN ProcedureCodes P ON P.ProcedureCodeId = s.ProcedureCodeId        
       INNER JOIN Locations L On S.LocationId=L.LocationId                      
       WHERE S.STATUS IN (                    
         71                    
         ,75                    
         ) -- 71 (Show), 75(complete)                                            
        AND isnull(S.RecordDeleted, 'N') = 'N' 
GO


