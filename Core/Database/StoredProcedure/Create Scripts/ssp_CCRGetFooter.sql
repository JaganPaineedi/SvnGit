/****** Object:  StoredProcedure [dbo].[ssp_CCRGetFooter]    Script Date: 06/09/2015 03:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CCRGetFooter]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ssp_CCRGetFooter] 

(@ClientId Int
)
as              
/******************************************************************************                                              
**  File: [ssp_CCRGetFooter]                                          
**  Name: [ssp_CCRGetFooter]                     
**  Desc:    
**  Return values:                                          
**  Called by:                                               
**  Parameters:                          
**  Auth:  srf
**  Date:  12/13/2011                                         
*******************************************************************************                                              
**  Change History                                              
*******************************************************************************                                              
**  Date:       Author:       Description:                            
**  
**  -------------------------------------------------------------------------            
*******************************************************************************/                                            
  
  
Begin                                                            
                  
 Begin try   
 
 
 --
 -- Get patient info
 --


Declare @AddressType varchar(50) 
	,@Line1 varchar(200)
	,@City varchar(100)
	,@StateProvince varchar(2)
	,@PostalCode varchar(20)
	,@Telephone varchar(max)
	,@TelephoneType varchar(30)


 Select top 1 
	 @AddressType = ''Home''
	,@Line1 = ca.Address
	,@City = ca.City
	,@StateProvince = ca.State
	,@PostalCode = ca.Zip
	From ClientAddresses ca
	Where ca.ClientId = @ClientId
	and ca.AddressType = 90--Home
	and ISNULL(ca.RecordDeleted, ''N'')= ''N''
	
Select top 1 
	@TelephoneType = ''Home''
	,@Telephone = cp.PhoneNumber
	From ClientPhones cp
	Where cp.ClientId = @ClientId
	and cp.PhoneType = 30--Home
	and ISNULL(cp.RecordDeleted, ''N'')= ''N''
	
				


	Select 
	--<CurrentName>
	 FirstName as CurrentNameGiven
	,MiddleName as CurrentNameMiddle
	,LastName as CurrentNameFamily
	,Suffix as CurrentNameSuffix
	,Prefix as CurrentNameTitle
	--<DateOfBirth>
	,DOB as DateOfBirth
	--<Gender>
	,case when c.Sex = ''F'' then ''Female''
		  when c.Sex = ''M'' then ''Male''
		  else c.Sex 
	 end as Gender
	 --<ID>		  
	,ClientId as ID
	,''Client ID'' as IDType
	--<Address>
	,@AddressType as AddressType
	,@Line1 as Line1
	,@City as City
	,@StateProvince as StateProvince
	,@PostalCode as PostalCode
	--<Telephone>
	,@Telephone as Telephone
	,@TelephoneType as TelephoneType
	From Clients c
	Where c.ClientId = @ClientId
	and ISNULL(c.RecordDeleted, ''N'')= ''N''


              
end try                                                            
                                                                                            
BEGIN CATCH                
              
DECLARE @Error varchar(8000)                                                             
SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                           
    + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''[ssp_CCRGetFooter]'')                                                                                           
    + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())                                                                                            
    + ''*****'' + Convert(varchar,ERROR_STATE())                                  RAISERROR                                                                                           
 (                                                             
  @Error, -- Message text.                                                                                          
  16, -- Severity.                                                                                          
  1 -- State.                                                                                          
 );                                                                                       
END CATCH                                      
END
' 
END
GO
