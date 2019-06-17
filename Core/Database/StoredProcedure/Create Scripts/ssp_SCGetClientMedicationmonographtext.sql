IF  EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'[ssp_SCGetClientMedicationmonographtext]') AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1)
	DROP PROCEDURE [dbo].[ssp_SCGetClientMedicationmonographtext]
GO

CREATE PROCEDURE [dbo].[ssp_SCGetClientMedicationmonographtext]
    (
      @druginteractionmonographid INT                       
    )
AS 
    BEGIN TRY                                       
/*********************************************************************/                                                    
/* Stored Procedure: dbo.[ssp_SCGetClientMedicationmonographtext]                */                                                    
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */                                                    
/* Creation Date:    6/Dec/07                                      */                                                   
/*                                                                   */                                                    
/* Purpose:  To retrieve monographtext from MDDrugDrugInteractionMonographText */                                                    
/*                                                                   */                                                  
/* Input Parameters: none        @druginteractionmonographid */                                                  
/*                                                                   */                                                    
/* Output Parameters:   None                           */                                                    
/*                                                                   */                                                    
/* Return:  0=success, otherwise an error number                     */                                                    
/*                                                                   */                                                    
/* Called By:                                                        */                                                    
/*                                                                   */                                                    
/* Calls:                                                            */                                                    
/*                                                                   */                                                    
/* Data Modifications:                                               */                                                    
/*                                                                   */                                                    
/* Updates:                                                          */                                                    
/*   Date     Author       Purpose                                    */                                                    
/*  6/Dec/07    Rishu    Created                                    */                                                    
/*  March 05    Wasif Butt    Modified - MU requirement to display drug database developer name */                                                    
/*********************************************************************/                                                   
      
        --SELECT  monographtext ,
        --        LineIdentifier
        --FROM    MDDrugDrugInteractionMonographText
        --WHERE   druginteractionmonographid = @druginteractionmonographid
        --ORDER BY textsequencenumber    
      
	  
	  			declare @Num int 
					SELECT @Num  = max(TextSequenceNumber)
        FROM MDDrugDrugInteractionMonographText  
        WHERE   druginteractionmonographid = @druginteractionmonographid

;with cte_monograph as (
		SELECT monographtext,
        LineIdentifier , TextSequenceNumber
        FROM MDDrugDrugInteractionMonographText  
        WHERE   druginteractionmonographid = @druginteractionmonographid

		union all 
		select '', 'B', @Num + 1
		union all
		select 'DEVELOPER:', 'Z', @Num + 2
		union all
		select '', 'B', @Num + 3
		union all 
        select 'First DataBank', 'Z', @Num + 4 	
)
select monographtext,
        LineIdentifier
		from cte_monograph
		order by TextSequenceNumber

        
    END TRY        
        
    BEGIN CATCH                
        DECLARE @Error VARCHAR(8000)                
        SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
            + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
            + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                     'ssp_SCGetClientMedicationmonographtext') + '*****'
            + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
            + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
            + CONVERT(VARCHAR, ERROR_STATE())                
                  
        RAISERROR                 
 (                
  @Error, -- Message text.                
  16, -- Severity.                
  1 -- State.                
 ) ;       
                
    END CATCH


GO


