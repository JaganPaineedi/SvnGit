USE [BradfordSmartcareTrain]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLCarePlanReview]    Script Date: 3/2/2017 10:16:30 AM ******/
DROP PROCEDURE [dbo].[ssp_RDLCarePlanReview]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLCarePlanReview]    Script Date: 3/2/2017 10:16:30 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO



CREATE PROCEDURE [dbo].[ssp_RDLCarePlanReview]
    (
      @DocumentVersionId AS INT  
    )
AS /************************************************************************/                                                          
/* Stored Procedure: ssp_RDLCarePlanReview        */                                                 
/*        */                                                          
/* Creation Date:  03/07/2015                            */                                                          
/*                                                        */                                                          
/* Purpose: Gets Data for ssp_RDLCarePlanReview       */                                                         
/* Input Parameters: DocumentVersionId        */                                                        
/* Output Parameters:             */                                                          
/* Purpose: Use For Rdl Report           */                                                
/* Calls:                */                                                          
/*                  */                                                          
/* Author: Veena S Mani             */                                                          
/*********************************************************************/      
    BEGIN      
        SELECT  dv.DocumentVersionId AS DocumentVersionId ,
                d.EffectiveDate ,
                d.ClientId
        FROM    Documents d
                JOIN DocumentVersions dv ON d.DocumentId = dv.DocumentId
        WHERE   dv.DocumentVersionId = @DocumentVersionId
                AND ISNULL(d.RecordDeleted, 'N') <> 'Y';   
	
    END;


GO


