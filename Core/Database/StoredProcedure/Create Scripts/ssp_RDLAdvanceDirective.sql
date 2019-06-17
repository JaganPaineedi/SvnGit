

/****** Object:  StoredProcedure [dbo].[ssp_RDLAdvanceDirective]    Script Date: 06/13/2015 18:11:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLAdvanceDirective]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLAdvanceDirective]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLAdvanceDirective]    Script Date: 06/13/2015 18:11:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

Create Procedure [dbo].[ssp_RDLAdvanceDirective]         
 @DocumentVersionId int                                   
AS                                    
BEGIN TRY                      

select  ad.DocumentVersionId ,
        ad.ClientName ,
        ad.ClientAddress ,
        ad.Attorney1 as Attorney,
        gc.Description as AnatomicalGift,
        ad.AnatomicalGiftComment ,
        ad.RuleLimitationComment ,
        gc2.Description as ProlongedLife ,
        convert(varchar(10),ad.PowerEffectiveDate, 101) as PowerEffectiveDate ,
        ad.PowerEffectiveComment ,
        convert(varchar(10),ad.PowerTerminateDate, 101) as PowerTerminateDate ,
        ad.PowerTerminateComment ,
        ad.SuccessorsToAgentName1 ,
        ad.SuccessorsToAgentAddress1 ,
        ad.SuccessorsToAgentPhone1 ,
        ad.SuccessorsToAgentName2 ,
        ad.SuccessorsToAgentAddress2 ,
        ad.SuccessorsToAgentPhone2 ,
        ad.OtherInstructions,		
		case when dsc.SignatureDate is null then '' else dsc.SignerName end as ClientSignature,
		dsc.SignatureDate as ClientSignatureDate,
		case when ds.SignatureDate is null then '' else ds.SignerName end as WitnessSignature,
		ds.SignatureDate as WitnessSignatureDate
		from dbo.DocumentVersions dv 
		join dbo.Documents d on dv.DocumentVersionId = d.CurrentDocumentVersionId
		left join dbo.DocumentSignatures dsc on d.DocumentId = dsc.DocumentId and isnull(dsc.IsClient, 'N') = 'Y'
		left join dbo.DocumentSignatures ds on d.DocumentId = ds.DocumentId and isnull(ds.IsClient, 'Y') = 'N' and ds.RelationToClient = 50480 --Witness
		join dbo.AdvanceDirective ad on dv.DocumentVersionId = ad.DocumentVersionId 
		left join globalcodes gc on ad.AnatomicalGift = gc.GlobalCodeId
		left join globalcodes gc2 on ad.ProlongedLife = gc2.GlobalCodeId
where dv.DocumentVersionId = @DocumentVersionId
and isnull(dv.RecordDeleted, 'N')= 'N'
and isnull(ad.RecordDeleted, 'N')= 'N'
and isnull(d.RecordDeleted, 'N')= 'N'
and isnull(dsc.RecordDeleted, 'N')= 'N'
and isnull(ds.RecordDeleted, 'N')= 'N'
and isnull(gc.RecordDeleted, 'N')= 'N'
and isnull(gc2.RecordDeleted, 'N')= 'N'


  
END TRY                      
BEGIN CATCH                          
 declare @Error varchar(8000)                          
 set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                           
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_RDLAdvanceDirective')                           
    + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                            
    + '*****' + Convert(varchar,ERROR_STATE())                          
                            
 RAISERROR                           
 (                          
  @Error, -- Message text.                          
  16, -- Severity.                          
  1 -- State.                          
 );                          
                          
END CATCH

GO

