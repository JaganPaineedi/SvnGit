 /****** Object:  StoredProcedure [dbo].[scsp_ListPageSCAuthorizationDocument]    Script Date: 02/18/2014 15:40:34 ******/
if exists ( select  *
            from    sys.objects
            where   object_id = object_id(N'[dbo].[ssp_GetClientContactsList]')
                    and type in (N'P', N'PC') ) 
    drop procedure [dbo].[ssp_GetClientContactsList]
GO
 
 create PROCEDURE [dbo].[ssp_GetClientContactsList] @ClientId INT = NULL  
 ,@Letters VARCHAR(max)  
AS  
/*************************************************************************/                  
/* Stored Procedure: dbo.ssp_GetClientContactsList 226,tes            */                  
/* Copyright: DisclosureTo Details      */                  
/* Creation Date:  25/03/2016            */                  
/*                                                                       */                  
/* Purpose: retuns the details of NamAddress               */                 
/*                                                                       */                
/* Input Parameters: @ClientId,@Letters                                     */                
/*                   */                  
/* Output Parameters:              */                  
/*                                                                       */                  
/* Return:                                                               */                  
/*                                                                       */                  
/* Called By:                                                            */                  
/*                                                                       */                  
/* Calls:                                                                */                  
/*                                                                       */                  
/* Data Modifications:                                                   */                  
/*                                                                       */                  
/* Updates:                                                              */                  
/*  Date            Author    Purpose                  */    

/*************************************************************************/   
BEGIN TRY  
BEGIN  
 DECLARE @LettersSearch VARCHAR(50)  
 SET @LettersSearch = '%' + @Letters + '%'   
   
 SELECT DISTINCT CAST(CC.ClientContactId AS VARCHAR(12))  AS ClientContactId , 
   --,CC.ListAs  ,
   (CC.LastName + ', ' + CC.FirstName ) AS NAME  
  FROM ClientContacts AS CC  
  WHERE CC.ClientId = @ClientId  
   AND (  
    CC.FirstName LIKE @LettersSearch  
    OR CC.LastName LIKE @LettersSearch  
    OR CC.ListAs LIKE @LettersSearch  
    )  
   AND ISNULL(CC.RecordDeleted, 'N') = 'N'  
   AND Active = 'Y'      
 
END  
END TRY  
 BEGIN CATCH                                   
        DECLARE @Error VARCHAR(8000)                                    
        SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'  
            + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'  
            + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),  
                     '[ssp_GetClientContactsList]') + '*****'  
            + CONVERT(VARCHAR, ERROR_LINE()) + '*****'  
          + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'  
            + CONVERT(VARCHAR, ERROR_STATE())                                    
                        
--set @result=0                                                      
                                
        RAISERROR                                     
 (                                    
  @Error, -- Message text.                                    
  16,                                    
  1                                   
 ) ;                                    
                                    
    END CATCH      
    
  