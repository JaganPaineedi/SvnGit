/****** Object:  StoredProcedure [dbo].[ssp_GetRelationCodeNameByGlobalCodeId]    ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetRelationCodeNameByGlobalCodeId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetRelationCodeNameByGlobalCodeId]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetRelationCodeNameByGlobalCodeId]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE  PROCEDURE [dbo].[ssp_GetRelationCodeNameByGlobalCodeId] 
@GlobalCodeId AS INT = NULL
AS /********************************************************************************                                                    
-- Stored Procedure: ssp_PMGetClientInformation  
--  
-- Copyright: Streamline Healthcate Solutions  
--  
-- Purpose: Procedure to get the RelationShip CodeName Depends on GlobalCodeId.  
--  
-- Author:  Vichee Humane  
-- Date:    05 Nov 2015
*********************************************************************************/   
--ClientPhones                                                                                                                         
    SELECT  
            GlobalCodes.CodeName  
    FROM    GlobalCodes             
    WHERE   ( GlobalCodes.GlobalCodeId = @GlobalCodeId )  
            AND ( ISNULL(GlobalCodes.RecordDeleted, 'N') = 'N' )  
            AND ( GlobalCodes.Active = 'Y' )  
            AND ( ISNULL(GlobalCodes.RecordDeleted, 'N') = 'N' )    
            
              IF ( @@error != 0 )   
        BEGIN                                                                                         
            RAISERROR  20002  'ssp_GetRelationCodeNameByGlobalCodeId: An Error Occured'                                                                                                                            
            RETURN(1)                                                                                                                            
        END                                                                                                
    RETURN(0)   
GO


