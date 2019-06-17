IF EXISTS ( SELECT  *
            FROM    sys.procedures
            WHERE   name = 'scsp_CreateClientPlans' )
    DROP PROCEDURE scsp_CreateClientPlans
GO

SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[scsp_CreateClientPlans]  
/********************************************************************************                                                    
-- Stored Procedure: [scsp_CreateClientPlan]  
--  
-- Copyright: Streamline Healthcate Solutions  
--  
-- Author:  Venkatesh MR  
-- Date:    24 May 2016  
--  
-- *****History****  
    /*24 May 2016 Venkatesh  Create a Client Plan with GR plan once we create a client in Inquiry - Ref Task - 136 in Camino Environment Issue Tracking*/    

*********************************************************************************/  
  
 @ClientID    INT  
AS  
BEGIN  
  IF EXISTS (SELECT  *  
            FROM    sys.objects  
            WHERE   OBJECT_ID = OBJECT_ID(N'[csp_CreateClientPlans]')  
                    AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1 )  
   BEGIN 
		DECLARE @IsGRAssociationRequired CHAR(10)
		SELECT @IsGRAssociationRequired=Value FROM SystemConfigurationKeys Where [Key]='GenerateGRCoveragePlan'
		IF @IsGRAssociationRequired = 'REG,CC' OR @IsGRAssociationRequired = 'CC'
		BEGIN
			EXEC csp_CreateClientPlans @ClientID 
		END 
   END
   
RETURN  
END