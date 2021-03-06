/****** Object:  StoredProcedure [dbo].[ssp_CCRGetClientInfo]    Script Date: 06/09/2015 03:48:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CCRGetClientInfo]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[ssp_CCRGetClientInfo] ( @ClientId INT )
AS /******************************************************************************                                              
**  File: [ssp_CCRGetClientInfo]                                          
**  Name: [ssp_CCRGetClientInfo]                     
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
  
  
    BEGIN                                                            
                  
        BEGIN TRY   
 
 
 --
 -- Get patient info
 --


            DECLARE @AddressType VARCHAR(50) ,
                @Line1 VARCHAR(200) ,
                @City VARCHAR(100) ,
                @StateProvince VARCHAR(2) ,
                @PostalCode VARCHAR(20) ,
                @Telephone VARCHAR(MAX) ,
                @TelephoneType VARCHAR(30)


            SELECT TOP 1
                    @AddressType = ''Home'' ,
                    @Line1 = ca.Address ,
                    @City = ca.City ,
                    @StateProvince = ca.State ,
                    @PostalCode = ca.Zip
            FROM    ClientAddresses ca
            WHERE   ca.ClientId = @ClientId
                    AND ca.AddressType = 90--Home
                    AND ISNULL(ca.RecordDeleted, ''N'') = ''N''
	
            SELECT TOP 1
                    @TelephoneType = ''Home'' ,
                    @Telephone = cp.PhoneNumber
            FROM    ClientPhones cp
            WHERE   cp.ClientId = @ClientId
                    AND cp.PhoneType = 30--Home
                    AND ISNULL(cp.RecordDeleted, ''N'') = ''N''
	
				


            SELECT 
	--<CurrentName>
                    ISNULL(FirstName,'''') AS Current_Given ,
                    ISNULL(MiddleName,'''') AS Current_Middle ,
                    ISNULL(LastName,'''') AS Current_Family ,
                    ISNULL(Suffix,'''') AS Current_Suffix ,
                    ISNULL(Prefix,'''') AS Current_Title,
                    ISNULL(FirstName,'''') + '' '' + ISNULL(LastName,'''') AS Current_DisplayName
	--<DateOfBirth>
                    ,
                    CONVERT(VARCHAR(10), DOB, 21) AS DOB_ExactDateTime
	--<Gender>
                    ,
                    CASE WHEN c.Sex = ''F'' THEN ''Female''
                         WHEN c.Sex = ''M'' THEN ''Male''
                         ELSE ''Unknown''
                    END AS Gender
	 --<ID>		  
                    ,
                    ''Patient.'' + CAST(ClientId AS VARCHAR(100)) AS ActorID,
                    --ClientId AS ID ,
                    ClientId AS ID1_ActorID,
                    ''Patient ID'' AS ID1_IDType,
                    ''SmartcareWeb'' AS ID1_Source_ActorID,
                    ''SmartcareWeb'' AS SLRCGroup_Source_ActorID
	--<Address>
                    ,
                    @AddressType AS A1_Address_Type ,
                    @Line1 AS A1_Address_Line1 ,
                    @City AS A1_Address_City ,
                    @StateProvince AS A1_Address_State ,
                    @PostalCode AS A1_Address_PostalCode
	--<Telephone>
                    ,
                    @Telephone AS CT1_Telephone_Value ,
                    @TelephoneType AS CT1_Telephone_Type
            FROM    Clients c
            WHERE   c.ClientId = @ClientId
                    AND ISNULL(c.RecordDeleted, ''N'') = ''N''


              
        END TRY                                                            
                                                                                            
        BEGIN CATCH                
              
            DECLARE @Error VARCHAR(8000)                                                             
            SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + ''*****''
                + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + ''*****''
                + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                         ''[ssp_CCRGetFooter]'') + ''*****''
                + CONVERT(VARCHAR, ERROR_LINE()) + ''*****''
                + CONVERT(VARCHAR, ERROR_SEVERITY()) + ''*****''
                + CONVERT(VARCHAR, ERROR_STATE())
            RAISERROR                                                                                           
 (                                                             
  @Error, -- Message text.                                                                                          
  16, -- Severity.                                                                                          
  1 -- State.                                                                                          
 ) ;                                                                                       
        END CATCH                                      
    END                 
              
              
              
        
  

' 
END
GO
