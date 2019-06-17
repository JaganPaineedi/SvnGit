

/****** Object:  View [dbo].[ViewMUClientCCDs]    Script Date: 04/11/2018 19:05:51 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ViewMUClientCCDs]'))
DROP VIEW [dbo].[ViewMUClientCCDs]
GO


/****** Object:  View [dbo].[ViewMUClientCCDs]    Script Date: 04/11/2018 19:06:00 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

        
CREATE view [dbo].[ViewMUClientCCDs] as              
/********************************************************************************              
-- View: dbo.ViewClientServices                
--              
-- Copyright: Streamline Healthcate Solutions              
--              
-- Purpose: returns Client CCD data        
-- Updates:                                                                     
-- Date        Author      Purpose              
-- 06.11.2017  Gautam     Created.   Why:Meaningful Use - Stage 3 > Tasks #46 > Stage 3 Reports                 
*********************************************************************************/          
       
  SELECT C.ClientId        
  ,S.ClientCCDId                      
   ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName                     
     ,S.TransferDate AS ActualTransitionDate        
     ,CAST(S.TransferDate AS DATE)  as TransferDate           
     ,S.RecipientPhysicianId      
     ,S.LocationId                               
     ,S.Incorporated    
     ,S.CCDType    
     ,S.DocumentVersionId  
  FROM dbo.ClientCCDs S                                          
    INNER JOIN dbo.Clients C ON C.ClientId = S.ClientId                                          
     AND isnull(C.RecordDeleted, 'N') = 'N'                                                                      
  WHERE S.FileType = 8805 --Summary of care                                                                        
     AND isnull(S.RecordDeleted, 'N') = 'N' 
GO


