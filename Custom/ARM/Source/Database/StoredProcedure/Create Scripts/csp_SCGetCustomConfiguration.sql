/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomConfiguration]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomConfiguration]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomConfiguration]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomConfiguration]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'  
Create procedure [dbo].[csp_SCGetCustomConfiguration]                    
/*********************************************************************                                                                                        
-- Stored Procedure: dbo.csp_SCGetCustomConfiguration                                                                                                                           
-- Copyright: 2005 Streamline Healthcare Solutions,  LLC                                                                                         
-- Creation Date:    06/25/2011                                                                                        
--                                                                                         
-- Purpose:  Return Tables for CustomConfiguration and fill the type Dataset                                                                                        
--                                                                                        
-- Updates:                                                                                        
--   Date         Author            Purpose                                                                                        
--  25.06.2011   Damanpreet         Created                                                                                      
*********************************************************************/                                                                                                                             
as    
 --CustomConfigurations                
 SELECT  top 1  QITabEnableHealthMeasures=''Y'', QITabEnableDDMeasures=''Y''                
 FROM dbo.CustomConfigurations                
                                                      
IF (@@error!=0)                                                                                                            
BEGIN                                                                                         
 RAISERROR  20002  ''csp_SCGetCustomConfiguration: An Error Occured''                                                                                                                            
 RETURN(1)                                                                                                                            
END                                                                                                
RETURN(0)   ' 
END
GO
