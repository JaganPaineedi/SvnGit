IF EXISTS ( SELECT	*
			FROM	sys.objects
			WHERE	object_id = OBJECT_ID(N'[dbo].[ssp_MMGetClientPharmacies]')
					AND type IN ( N'P', N'PC' ) ) 
	DROP PROCEDURE ssp_MMGetClientPharmacies
GO


/****** Object:  StoredProcedure [dbo].[ssp_MMGetClientPharmacies]    Script Date: 2/3/2014 10:47:01 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


          
CREATE PROCEDURE [dbo].[ssp_MMGetClientPharmacies]
	@ClientId INT,
	@RequirePharamcies INT = 1,
	@PreferredPharmacy1 INT = -1,
	@PreferredPharmacy2 INT = -1,
	 --25-May-2017  K.Soujanya
	@PreferredPharmacy3 INT = -1
AS /**********************************************************************/                                      
/* Stored Procedure: dbo.ssp_MMGetClientPharmacies            */                                      
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC              */                                      
/* Creation Date:    23-Dec-2008                                       */                                      
/*                                                                    */                                      
/* Purpose:Used to get ClientPharmacies                  */                                     
/*                                                                    */                                    
/* Input Parameters: @ClientId                    */                                    
/*                                                                    */                                      
/* Output Parameters:   None                                          */                                      
/*                                                                    */                                      
/* Return:  0=success, otherwise an error number                      */                                      
/*                                                                    */                                      
/* Called By: ClientMedications.cs               */                                      
/*                                                                    */                                      
/* Calls:                                                             */                                      
/*                                                                    */                                      
/* Data Modifications:                                                */                                      
/*                                                                    */                                      
/* Updates:                                                           */                                      
/*    Date        Author       Purpose                                */                                      
/* 23-Dec-2008   Loveena    Created                                   */                  
/*                   */                                  
/*                   */          
/* Oct 8, 2013 Kneale Alpers added the parameter @RequirePharamcies to keep the pharamcy list from being pulled when not needed */
/* Feb 2, 2014 Kneale Alpers added two parameters; perferred 1 and preferred 2 */
/* July 11, 2017 K.Soujanya added  PreferredPharmacy3 parameter.ref to Network180-Enhancements #79 */
/* Nov 2nd 2017 N.Kavya added Order by SequenceNumber , prefered pharmacied should come orderby sequenceNumber */
/**********************************************************************/                                       
                                  
	BEGIN                                    
		DECLARE	@PharmacyId INT          
		SELECT	@PharmacyId = PharmacyId
		FROM	ClientPharmacies
		WHERE	ClientId = @ClientId
				AND ISNULL(RecordDeleted, 'N') = 'N'      
		SELECT	ClientPharmacyId,
				ClientId,
				SequenceNumber,
				PharmacyId,
				RowIdentifier,
				ExternalReferenceId,
				CreatedBy,
				CreatedDate,
				ModifiedBy,
				ModifiedDate,
				RecordDeleted,
				DeletedDate,
				DeletedBy
		FROM	ClientPharmacies
		WHERE	ClientId = @ClientId
				AND ISNULL(RecordDeleted, 'N') = 'N'
				Order by SequenceNumber
  
    
      
		SELECT	p.[PharmacyId],
				p.[PharmacyName],
				p.[Active],
				p.[PreferredPharmacy],
				p.[PhoneNumber],
				p.[FaxNumber],
				p.[Address],
				p.[City],
				p.[State],
				p.[ZipCode],
				p.[AddressDisplay],
				p.[Email],
				p.[NumberOfTimesFaxed],
				p.[SureScriptsPharmacyIdentifier],
				p.[RowIdentifier],
				p.[ExternalReferenceId],
				p.[CreatedBy],
				p.[CreatedDate],
				p.[ModifiedBy],
				p.[ModifiedDate],
				p.[RecordDeleted],
				p.[DeletedDate],
				p.[DeletedBy],
				p.[Specialty]
		FROM	[Pharmacies] AS p
				JOIN dbo.ClientPharmacies AS cp ON cp.PharmacyId = p.PharmacyId
		WHERE	ISNULL(p.RecordDeleted, 'N') = 'N'
				AND cp.ClientId = @ClientId
				AND ( @RequirePharamcies = 1
					  OR ( @RequirePharamcies = 0
						   AND ( p.Pharmacyid IN ( @PreferredPharmacy1,
												   @PreferredPharmacy2,@PreferredPharmacy3 ) )--Added @PreferredPharmacy3 -25-May-2017  K.Soujanya
						 )
					)                                                                
                        
          
		IF ( @@error != 0 ) 
			BEGIN       
				RAISERROR  20002 'Client Pharmacies : An Error Occured '                                    
				RETURN(1)                          
			END                                    
		RETURN(0)                                    
	END 


GO


