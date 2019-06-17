
GO

/****** Object:  StoredProcedure [dbo].[csp_SCGetDiagnosisForClient]    Script Date: 07/02/2015 16:25:21 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetDiagnosisForClient]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetDiagnosisForClient]
GO



/****** Object:  StoredProcedure [dbo].[csp_SCGetDiagnosisForClient]    Script Date: 07/02/2015 16:25:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/************************************************************************/                        
/* Stored Procedure: dbo.csp_SCGetDiagnosisForClient      */               
/* Copyright: 2009 Streamlin Healthcare Solutions      */                        
/* Creation Date:  6/11/2009           */                        
/* Purpose: Gets Top 3 data for  Diagnosis             */                       
/* Input Parameters: @ClientId     */                      
/* Output Parameters:             */                        
/* Return:                */                        
/* Called By:  Method in Documents Class Of DataService  in "Always Online Application"    */                        
/* Calls:                */                        
/* Data Modifications:             */                        
/*   Updates:               */                        
              
/*       Date              Author                  Purpose                                    */                        
/* 6/11/2009    Umesh Sharma              Created      */                        
/* 03/04/2010 Vikas Monga            */            
/* -- Remove [Documents] and [DocumentVersions]       */   
/* 07/02/2015 Arjun  Passing StaffId to SSP_SCGetClientNotes */                               
/************************************************************************/                         
CREATE PROCEDURE  [dbo].[csp_SCGetDiagnosisForClient]              
  @ClientId int,
  @StaffId int            
AS              
BEGIN                      
                    
  BEGIN TRY            
 SELECT Top 3 Dig.DSMCode,Dig.DiagnosisOrder from Documents D           
 left outer join DocumentVersions Dv on D.CurrentDocumentVersionId = Dv.DocumentVersionId           
 left outer join DiagnosesIAndII Dig on Dv.DocumentVersionId = Dig.DocumentVersionId           
 Where D.DocumentCodeId = 5          
 AND D.Status = 22 AND D.ClientId = @ClientId          
 AND ISNULL(D.RecordDeleted,'N')='N'          
 AND ISNULL(Dv.RecordDeleted,'N')='N'          
 AND ISNULL(Dig.RecordDeleted,'N')='N'          
 order by Dig.DiagnosisId  desc  
       
 exec SSP_SCGetClientNotes @ClientId=@ClientId,@StaffId=@StaffId   
  END TRY            
              
  BEGIN CATCH                                  
           
  DECLARE @Error varchar(8000)                                                                     
            
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                    
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[csp_SCGetDiagnosisForClient]')                                                                     
  + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                                    
  + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                    
            
  RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );                                                            
                                 
 END CATCH            
End 

GO


