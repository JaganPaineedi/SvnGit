/****** Object:  StoredProcedure [dbo].[ssp_SCBedCensusGetClientNameAndInpatientStatus]    Script Date: 11/18/2011 16:25:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCBedCensusGetClientNameAndInpatientStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCBedCensusGetClientNameAndInpatientStatus]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCBedCensusGetClientNameAndInpatientStatus]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure [dbo].[ssp_SCBedCensusGetClientNameAndInpatientStatus]    
(@ClientId int)  
AS                    
/****************************************************************************/                                                                        
/* Stored Procedure: ssp_SCBedCensusGetClientNameAndInpatientStatus                              */                                                               
/* Copyright: 2006 Streamlin Healthcare Solutions                           */                             
/* Author: anil gautam                                                  */                                                                       
/* Creation Date:  Dec 29 2010            */                                                                        
/* Purpose: To Retrive ClientName, Status & Check InpatientStatus */                                                                       
/* Input Parameters:  @ClientId int                                      */                                                                      
/* Output Parameters:None                                                   */                                                                        
/* Return:                                                                  */                                                                        
/* Calls:                                                                   */                            
/* Called From:                                                             */                                                                        
/* Data Modifications:                                                      */                                                                        
/*                                                                          */                    
/*-------------Modification History--------------------------               */                    
/*-------Date----Author-------Purpose---------------------------------------*/                   
 /*	20 Oct 2015	Revathi			what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.*/             
/*								why:task #609, Network180 Customization */
              
/****************************************************************************/                    
BEGIN                          
 BEGIN TRY                 
  Declare @IsAlreadyEnrolled int  
  set @IsAlreadyEnrolled = (select count(ClientInpatientVisitId) from ClientInpatientVisits where ClientId=@ClientId and [Status] <> 4984 and ISNULL(RecordDeleted,''N'')=''N'')  
    
  --select (Clients.LastName+ '', '' + Clients.FirstName) as ClientName, ISNULL(Clients.Active,''Y'') as Active,ClientInpatientVisits.[Status]  from Clients  
  --left join ClientInpatientVisits on Clients.ClientId=ClientInpatientVisits.ClientId and ISNULL(ClientInpatientVisits.RecordDeleted,''N'')=''N''  
  --where Clients.ClientId=@ClientId and @IsAlreadyEnrolled=0 and ISNULL(Clients.RecordDeleted,''N'')=''N''  
  
  select 
	-- Modified by Revathi 20 Oct 2015
  case when  ISNULL(Clients.ClientType,''I'')=''I'' then (ISNULL(Clients.LastName,'''')+ '', '' + ISNULL(Clients.FirstName,'''')) else ISNULL(Clients.OrganizationName,'''') end  as ClientName,
  ISNULL(Clients.Active,''Y'') as Active, 
  ISNULL(GlobalCodes.CodeName,''Discharged'') as InpatientStatus  
  from Clients  
  left join ClientInpatientVisits on Clients.ClientId=ClientInpatientVisits.ClientId and ISNULL(ClientInpatientVisits.RecordDeleted,''N'')=''N'' and ClientInpatientVisits.[Status]<> 4984  
  left join GlobalCodes on GlobalCodes.GlobalCodeId=ClientInpatientVisits.[Status] and ISNULL(GlobalCodes.RecordDeleted,''N'')=''N''  
  where Clients.ClientId=@ClientId  and ISNULL(Clients.RecordDeleted,''N'')=''N''  
    
 END TRY                  
 BEGIN CATCH                              
   If (@@error!=0)                    
   Begin  RAISERROR  20006  ''ssp_SCBedCensusGetClientNameAndInpatientStatus: An Error Occured''     Return  End                            
 END CATCH           
END
' 
END
GO
