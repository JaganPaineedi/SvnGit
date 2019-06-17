
/****** Object:  View [dbo].[ViewMUCPOELabRadio]    Script Date: 04/11/2018 19:03:33 ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ViewMUCPOELabRadio]'))
DROP VIEW [dbo].[ViewMUCPOELabRadio]
GO



/****** Object:  View [dbo].[ViewMUCPOELabRadio]    Script Date: 04/11/2018 19:03:41 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
  
CREATE view [dbo].[ViewMUCPOELabRadio] as      
/********************************************************************************      
-- View: dbo.ViewMUCPOE        
--      
-- Copyright: Streamline Healthcate Solutions      
--      
-- Purpose: returns all CPOE Lab & Radio  
-- Updates:                                                             
-- Date        Author      Purpose      
-- 11.10.2017  Gautam     Created.   Why:Meaningful Use - Stage 3 > Tasks #46 > Stage 3 Reports         
*********************************************************************************/  
  
 SELECT CO.ClientOrderId,   
  OS.OrderType,  
  CO.OrderingPhysician,  
  cast(CO.OrderStartDateTime AS DATE)  as OrderStartDateTime ,  
  OS.OrderName  ,
    C.ClientId ,
  CONVERT(VARCHAR, CO.FlowSheetDateTime, 101) as  FlowSheetDateTime       
 ,RTRIM(c.LastName + ', ' + c.FirstName) AS ClientName      
        FROM dbo.ClientOrders CO            
        INNER JOIN dbo.Orders OS ON CO.OrderId = OS.OrderId            
         AND isnull(OS.RecordDeleted, 'N') = 'N'            
             INNER JOIN Clients C ON CO.ClientId=C.ClientId AND isnull(C.RecordDeleted, 'N') = 'N'    
        WHERE isnull(CO.RecordDeleted, 'N') = 'N' 
GO


