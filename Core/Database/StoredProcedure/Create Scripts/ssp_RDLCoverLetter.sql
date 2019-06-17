
IF EXISTS ( SELECT  *
            FROM    sys.objects
            WHERE   object_id = OBJECT_ID(N'[dbo].[ssp_RDLCoverLetter]')
                    AND type IN ( N'P', N'PC' ) )
    DROP PROCEDURE [dbo].[ssp_RDLCoverLetter];
GO


SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

CREATE PROCEDURE [dbo].ssp_RDLCoverLetter
    (
      @ClientDisclosureId INT
    )
AS
    BEGIN                      
/* =============================================      
-- Author:  Pranay Bodhu  
-- Create date: 05/12/2018 
-- Description:   Returns Table for CoverLetter.
      
 Author			Modified Date			Reason      
   
 PranayB         07/23/2018             Added Subject,Coverletter note     

 ============================================= */                      
    
        SET NOCOUNT ON;    
    
        SELECT  ofax.FaxTo ,
                s.LastName + ',' + s.FirstName AS FaxFrom ,
                ofax.FaxNumber AS FaxNumberTo ,
                a.FaxNumber AS FaxNumberFrom ,
                cd.NameAddress AS ToAddress ,
                a.AddressDisplay AS FromAddress,
				ofax.Subject,
				ofax.CoverLetterNote
        FROM    dbo.OutgoingFaxes ofax
                JOIN dbo.Staff s ON s.StaffId = ofax.FromStaffId
                CROSS JOIN dbo.Agency a
                LEFT JOIN dbo.ClientDisclosures cd ON cd.ClientDisclosureId = ofax.ClientDisclosureId
        WHERE   ofax.ClientDisclosureId = @ClientDisclosureId
                AND ISNULL(ofax.RecordDeleted, 'N') = 'N'
                AND ISNULL(s.RecordDeleted, 'N') = 'N';

        IF ( @@error != 0 )
            BEGIN              
                RAISERROR('[ssp_RDLCoverLetter] : An Error Occured', 16, 1);                           
                RETURN;              
            END;    
    END;    


GO
