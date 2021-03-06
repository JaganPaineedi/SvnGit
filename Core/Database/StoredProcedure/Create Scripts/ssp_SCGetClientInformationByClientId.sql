IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetClientInformationByClientId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetClientInformationByClientId]
GO
           
create PROCEDURE [dbo].[ssp_SCGetClientInformationByClientId]         
 -- Add the parameters for the stored procedure here              
 @ClientId int=0              
AS              
/*********************************************************************/                  
/* Stored Procedure:ssp_SCGetClientInformationByClientId                */                  
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */                  
/* Creation Date:   08/11/2010                                       */                  
/*                                                                   */                  
/* Purpose:  Get Client information */                
/*                                                                   */                
/* Input Parameters:              */                
/*                                                                   */                  
/* Output Parameters:   None                   */                  
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
/*   Date        Author           Purpose                            */                  
/*  08/11/2010   Vikas Monga      Created                            */                  
/*  01/20/2012   Sudhir Singh     Updated                            */                  
/*  03/20/2012   Sudhir Singh     Updated                            */ 
/*10.19.2015      Vichee          Modified the ssp to add logic for Organization in Client Information Network- 180 Customizations - #609*/                 
/*12-01-2016      Basudev Sahu    Modified the ssp to get ClientType  Network- 180 Customizations - #609     */
/*03-Feb-2016     Seema Thakur    Modified the ssp to get PrimaryPhysicianId  Philhaven Development - #369   */
/*********************************************************************/         
BEGIN           
 BEGIN TRY            
	 select clientid,       
	 case when  ISNULL(C.ClientType,'I')='I' then RTRIM(ISNULL(C.LastName,'')) + ', ' + RTRIM(ISNULL(C.FirstName,'')) else RTRIM(ISNULL(C.OrganizationName,'')) end AS ClientName,    
	     
	 ClientType,FirstName,LastName,Active, CustomFieldsData.ColumnGlobalCode7 AS AssignedPopulation 
	 ,[dbo].[GetMedicaidId](clientid) as MedicaidId 
	 ,c.PrimaryPhysicianId 
	 from Clients c
	 LEFT OUTER JOIN CustomFieldsData 
	 ON CustomFieldsData.PrimaryKey1 = c.clientid 
	 AND  ISNULL(CustomFieldsData.RecordDeleted,'N') = 'N' 
	 AND CustomFieldsData.DocumentType = 4941 
	  
	 where c.ClientId=@ClientId       
	 and ISNULL(c.RecordDeleted,'N')<>'Y'  
  END TRY  
  
 BEGIN CATCH    
	DECLARE @Error AS VARCHAR(8000);  
		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + 
		isnull(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetClientInformationByClientId') + '*****' +
		CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' +
		CONVERT(VARCHAR, ERROR_STATE());  
		RAISERROR (  
			@Error  
			,16  
			,1  
		);-- Message text.
    END CATCH          
END         
  
