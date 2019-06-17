/****** Object:  StoredProcedure [dbo].[ssp_CMListPageProviderSearch]    Script Date: 11/18/2011 16:25:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CMListPageProviderSearch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_CMListPageProviderSearch]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO  
CREATE  Procedure [dbo].[ssp_CMListPageProviderSearch]        
( 
  @PageNumber            INT 
 ,@PageSize              INT 
 ,@SortExpression varchar(50) 
 ,@ProviderType  varchar(3)
 ,@ProviderName varchar(max)
 ,@Sites int
 ,@CredentialType int
 ,@Status int
 ,@PerformedBy int
 ,@InsurerId int
 ,@Accreditation int
 ,@Duals int
 ,@SiteInfo varchar(max)
 ,@Cultural int
 ,@AgeGroup varchar(max)
 ,@Languages varchar(max)
 ,@Sex int
 ,@Degree int
 ,@LicenseType int
 ,@Speciality int
 ,@LicenseNumber varchar(max)
 ,@Service int
 ,@Others1 int
 ,@Others2 int
 ,@Open varchar(max)
 ,@Close varchar(max)
 ,@AnyWeekday varchar(10)
 ,@Monday varchar(10)
 ,@Tuesday varchar(10)
 ,@Wednesday varchar(10)
 ,@Thursday varchar(10)
 ,@Friday varchar(10)
 ,@Saturday varchar(10)
 ,@Sunday varchar(10)
 ,@CurrentOpening varchar(10)
 ,@HandicapAccessible varchar(10)
 ,@CredentialingEffectiveDate varchar(10)
 ,@CredentialingEffectiveToDate varchar(10)
 ,@AsofDate varchar(10)
 ,@Hospital int
 ,@LoggedInStaffId      INT
)      
 AS
   BEGIN 
     BEGIN TRY     
/*********************************************************************/                                            
-- Stored Procedure: dbo.ssp_CMListPageProviderSearch                                                            
-- Copyright: 2005 Provider Claim Management System                                                        
-- Creation Date:  22/06/2006                                                                                
--                                                                                                               
-- Purpose: It will get the Provider Search Data                                                        
--                                                                                                             
-- Input Parameters:                                                   
--                                                                                                             
-- Output Parameters:                                                                           
--                                                                                                              
-- Return:  */                                            
--                                                                                                               
-- Called By:                                                                                                   
--                                                                                                               
-- Calls:                                                                                                        
--                                                                                                               
-- Data Modifications:                                                                                          
--                                                                                                               
-- Updates:                                                                                                      
--  Date        Author       Purpose                                                                             
-- 22/06/2016   Shruthi.S    Created Ref #401  Aspen Pointe-Customizations.                   
-- 03/08/2016	Gautam		 what: Added code to show record based on multiple selection of SiteInfo,AgeGroup and Languages
--							 why : AspenPointe-Customizations > Tasks #401.1 > Provider Search - Issues 
/*********************************************************************/    

--To set staffprovider related variables

Declare @AllStaffProvider char(1)
SELECT  @AllStaffProvider = ISNULL(AllProviders, 'Y') From Staff where staffid=@LoggedInStaffId

--Set default filters
if(@AsofDate is Null)
set @AsofDate = ''
if(@CredentialingEffectiveDate is Null)
set @CredentialingEffectiveDate =''
if(@CredentialingEffectiveToDate is Null)
set @CredentialingEffectiveToDate =''
if(@ProviderType = '')
set @ProviderType = 'B'
	-- 03/08/2016	Gautam
	CREATE TABLE #SiteInfo ( SiteInfo INT)
	CREATE TABLE #AgeGroup ( AgeGroupId INT)
	CREATE TABLE #Languages ( LanguageId INT)
			  
	Insert into #SiteInfo(SiteInfo) select * from dbo.fnsplit(@SiteInfo,',')  
	Insert into #AgeGroup(AgeGroupId) select * from dbo.fnsplit(@AgeGroup,',')  
	Insert into #Languages(LanguageId) select * from dbo.fnsplit(@Languages,',')   
	
--Temp table to insert records for Provider Search List page
	     CREATE TABLE #ResultSet 
         ( 
			  ProvidrId INT,
			  Provider varchar(100),
			  AssociatedProvider varchar(100),
			  SiteName varchar(100),
			  [Address] varchar(300),
			  Phone  varchar(200),
			  SiteId Int
         )  
         
          --Insert data in to temp table which is fetched below by appling filter.     
          
          --Logic for insertion if search type is selected as Provider
      
			 INSERT INTO #ResultSet
			 (
			 ProvidrId,
			 Provider,
			 AssociatedProvider,
			 SiteName ,
			 [Address] ,
			 Phone  ,
			 SiteId
			 )
			   Select
			   distinct P.ProviderId,
			  P.ProviderName,
			  P1.ProviderName as AssociatedProvider,
			  S.SiteName ,
			  SA.Display ,
			  SP.PhoneNumber ,
			  S.SiteId
			   From Providers P 
			   join Sites S on P.ProviderId = S.ProviderId 
			   and ISNULL(P.RecordDeleted,'N') <>'Y' and ISNULL(S.RecordDeleted,'N') <>'Y'
			   left join SiteAddressess SA on SA.SiteId = S.SiteId and ISNULL(SA.RecordDeleted,'N') <>'Y'
			   left join SitePhones SP on SP.SiteId = S.SiteId and ISNULL(SP.RecordDeleted,'N') <>'Y'
			   left join Credentialing C on C.ProviderId = P.ProviderId  and ISNULL(C.RecordDeleted,'N') <>'Y'
			   left join CredentailingAccreditation CA on CA.CredentialingId = C.CredentialingId and ISNULL(CA.RecordDeleted,'N') <>'Y'
			   left join CredentialingSites CS on CS.CredentialingId = C.CredentialingId and ISNULL(CS.RecordDeleted,'N') <>'Y'
			   left join CredentialingCulturalConsiderations CCC on CCC.CredentialingId = C.CredentialingId and ISNULL(CCC.RecordDeleted,'N') <>'Y'
			   left join CredentialingLanguages CL on CL.CredentialingId = C.CredentialingId and ISNULL(CL.RecordDeleted,'N') <>'Y'
			   left join CredentialingEducations CE on CE.CredentialingId = C.CredentialingId and ISNULL(CE.RecordDeleted,'N') <>'Y'
			   left join CredentialingLicense CLT on CLT.CredentialingId = C.CredentialingId and ISNULL(CLT.RecordDeleted,'N') <>'Y'
			   left join CredentialingSpecialty CSS on CSS.CredentialingId = C.CredentialingId and ISNULL(CSS.RecordDeleted,'N') <>'Y'
			   left join CredentialingHospitals CH on CH.CredentialingId = C.CredentialingId and ISNULL(CH.RecordDeleted,'N') <>'Y'
			   left join Contracts CR on CR.ProviderId = P.ProviderId and ISNULL(CR.RecordDeleted,'N') <>'Y'
			   left join Insurers I on I.InsurerId = CR.InsurerId and  ISNULL(I.RecordDeleted,'N') <>'Y'
			   left join CredentialingAgeGroupServed CAS on CAS.CredentialingId = C.CredentialingId and ISNULL(CAS.RecordDeleted,'N') <>'Y'
			   left join ProviderAffiliates PA  on PA.ProviderId = P.ProviderId and ISNULL(PA.RecordDeleted,'N') <>'Y'
               left join Providers P1 on P1.ProviderId = PA.AffiliateProviderId and ISNULL(P1.RecordDeleted,'N') <>'Y'
			   WHERE
							( @ProviderType='P' AND P.ProviderName   like ( '%'+ @ProviderName + '%')--For Provider Search type 
							OR (@ProviderType='S' AND S.SiteName   like ( '%'+@ProviderName + '%')) --For Site Search type
							OR (@ProviderType='B' AND ((P.ProviderName   like ('%'+ @ProviderName+ '%')) 
							                            OR (S.SiteName   like ('%'+@ProviderName + '%'))))) --For Both Search type
							
							AND 
							 (P.ProviderId 
								 in(
									SELECT SP.ProviderId 
									FROM StaffProviders SP
									WHERE ISNULL(RecordDeleted,'N') <> 'Y'
									AND SP.StaffId = @LoggedInStaffId
									AND SP.ProviderId =   P.ProviderId
									AND @AllStaffProvider = 'N'
								)
								OR EXISTS (
									SELECT ProviderId P
									FROM Providers P
									WHERE ISNULL(RecordDeleted, 'N') <> 'Y'
									AND @AllStaffProvider = 'Y'
								)      
							
							) 
							--For Checkboxes
							AND (@HandicapAccessible = '' OR @HandicapAccessible='N'  OR S.HandicapAccess = @HandicapAccessible)
							AND (@CurrentOpening = '' OR  @CurrentOpening='N' OR (S.CurrentOpenings > 0 OR  Isnull(S.CurrentOpenings,'') = ''))
							--For Date fields conditions
							AND (@AsofDate = '' OR cast(S.OpeningsAsOf as date) >= cast(@AsofDate as Date))
							AND (@CredentialingEffectiveDate = '' OR cast(C.EffectiveFrom as date) >= cast(@CredentialingEffectiveDate as Date)) 
							AND (@CredentialingEffectiveToDate = '' OR cast(C.ExpirationDate as date) <= cast(@CredentialingEffectiveToDate as Date))
							--For Dropdowns conditions
							AND (@Sites = -1 OR S.SiteId = @Sites)
							AND (@CredentialType = -1 OR C.CredentialingType = @CredentialType)
							AND (@Status = -1 OR C.[Status] = @Status)
							AND (@Accreditation = -1 OR CA.AccreditationType = @Accreditation)
							AND (@Duals = -1 OR C.GeneralDualsProvider = @Duals)
							-- 03/08/2016	Gautam
							AND (@SiteInfo IS NULL OR exists (Select 1 from #SiteInfo SI where CS.SiteInformation = SI.SiteInfo))
							AND (@AgeGroup IS NULL OR exists (Select 1 from #AgeGroup AG where AG.AgeGroupId = CAS.AgeGroupServed))
							AND (@Languages  IS NULL OR exists (Select 1 from #Languages LA where LA.LanguageId = CL.CredentialLanguage)) 
							AND (@Cultural = -1 OR CCC.CulturalConsiderations= @Cultural)
							AND (@Sex = -1 OR C.GeneralSex = @Sex)
							AND (@Degree = -1 OR CE.DegreeType = @Degree)
							AND (@LicenseNumber = '' OR CLT.LicenseNumber = @LicenseNumber)
							AND (@LicenseType = -1 OR CLT.LicenseType = @LicenseType)
							AND (@Speciality = -1 OR CSS.Specialty = @Speciality)
							AND (@Hospital = -1 OR CH.Hospital = @Hospital)
							AND (@Service = -1 OR (CR.InsurerId = @InsurerId AND I.ServiceAreaId = @Service))
							AND (@InsurerId = -1 OR CR.InsurerId = @InsurerId)
							AND (@Others1 = -1 )
							AND (@Others2 = -1 )
							--For Checkbox and Open, Close conditions
							AND (@Monday = 'N' OR (@Monday='Yes' OR @AnyWeekday = 'Yes' AND (ISNULL(@Open,'') ='' OR s.MondayOpen like '% '+ @Open+' %' ) OR  (ISNULL(@Close,'') ='' OR s.MondayClose like '% '+@Close+' %')))
						    AND (@Tuesday = 'N' OR (@Tuesday='Yes' OR @AnyWeekday = 'Yes' AND (ISNULL(@Open,'') ='' OR s.TuesdayOpen like '% '+ @Open+' %') OR  (ISNULL(@Close,'') ='' OR s.TuesdayClose like '% '+@Close+' %')))
						    AND (@Wednesday = 'N' OR (@Wednesday='Yes' OR @AnyWeekday = 'Yes' AND (ISNULL(@Open,'') ='' OR s.WednesdayOpen like '% '+ @Open+' %' ) OR  (ISNULL(@Close,'') ='' OR s.WednesdayClose like '% '+@Close+' %')))
						    AND (@Thursday = 'N' OR (@Thursday='Yes' OR @AnyWeekday = 'Yes' AND (ISNULL(@Open,'') ='' OR s.ThursdayOpen like '% '+ @Open+' %') OR  (ISNULL(@Close,'') ='' OR s.ThursdayClose like '% '+@Close+' %')))
						    AND (@Friday = 'N' OR (@Friday='Yes' OR @AnyWeekday = 'Yes' AND (ISNULL(@Open,'') ='' OR s.FridayOpen like '% '+ @Open+' %' ) OR (ISNULL(@Close,'') ='' OR  s.FridayClose like '% '+@Close+' %')))
						    AND (@Saturday = 'N' OR (@Saturday='Yes'  AND (ISNULL(@Open,'') ='' OR s.SaturdayOpen like '% '+ @Open+' %' ) OR  (ISNULL(@Close,'') ='' OR s.SaturdayClose like '% '+@Close+' %')))
						    AND (@Sunday = 'N' OR (@Sunday='Yes'  AND (ISNULL(@Open,'') ='' OR s.SaturdayOpen like '% '+ @Open+' %' ) OR  (ISNULL(@Close,'') ='' OR s.SaturdayClose like '% '+@Close+' %')))
						    AND (@AnyWeekday = 'N' OR (@AnyWeekday ='Yes' AND (( (ISNULL(@Open,'') ='' OR s.MondayOpen like '% '+ @Open+' %' ) OR (ISNULL(@Close,'') ='' OR s.MondayClose like '% '+@Close+' %' )) 
						                                                 OR ( (ISNULL(@Open,'') ='' OR s.TuesdayOpen like '% '+ @Open+' %' ) OR  (ISNULL(@Close,'') ='' OR s.TuesdayClose like '% '+@Close+' %')) 
						                                                 OR ((ISNULL(@Open,'') ='' OR s.WednesdayOpen like '% '+ @Open+' %') OR  (ISNULL(@Close,'') ='' OR s.WednesdayClose like '% '+@Close+' %' )) 
						                                                 OR ((ISNULL(@Open,'') ='' OR s.ThursdayOpen like '% '+ @Open+' %') OR  (ISNULL(@Close,'') ='' OR s.ThursdayClose like '% '+@Close+' %'))
						                                                 OR ((ISNULL(@Open,'') ='' OR s.FridayOpen like '% '+ @Open+' %') OR  (ISNULL(@Close,'') ='' OR s.FridayClose like '% '+@Close+' %')))))
             ORDER BY P.ProviderName						                                                 

         
         
             ;
                WITH    Counts
                          AS ( SELECT   COUNT(*) AS TotalRows
                               FROM     #ResultSet
                             ) ,
                        ListBanners
                          AS ( SELECT DISTINCT
                                         ProvidrId,
										 Provider,
										 AssociatedProvider,
										 SiteName ,
										 [Address] ,
										 Phone ,
										 SiteId,
                                        COUNT(*) OVER ( ) AS TotalCount ,
                                                        RANK() OVER ( ORDER BY CASE WHEN @SortExpression= 'Provider' THEN Provider  END, 
																	  CASE WHEN @SortExpression= 'Provider desc' THEN Provider END DESC, 
																	  CASE WHEN @SortExpression= 'AssociatedProvider' THEN AssociatedProvider END, 
																	  CASE WHEN @SortExpression= 'AssociatedProvider desc' THEN AssociatedProvider END DESC,
																	  CASE WHEN @SortExpression= 'SiteName' THEN SiteName END, 
																	  CASE WHEN @SortExpression= 'SiteName desc' THEN SiteName END DESC, 
																	  CASE WHEN @SortExpression= 'Address' THEN [Address] END,
																	  CASE WHEN @SortExpression= 'Address desc' THEN [Address] END DESC,
																	  CASE WHEN @SortExpression= 'Phone' THEN Phone END, 
																	  CASE WHEN @SortExpression= 'Phone desc' THEN Phone END DESC,
						                                              ProvidrId  ) AS RowNumber
                                                                      FROM    #ResultSet
                                                                     )
                
                
                SELECT TOP ( CASE WHEN ( @PageNumber = -1 ) THEN ( SELECT   ISNULL(TotalRows, 0)
                                                                   FROM     Counts
                                                                 )
                                  ELSE ( @PageSize )
                             END )
                         ProvidrId,
						 Provider,
						 AssociatedProvider,
						 SiteName ,
						 [Address] ,
						 Phone ,
						 SiteId,
                         TotalCount ,
                         RowNumber
                INTO    #FinalResultSet
                FROM    ListBanners
                WHERE   RowNumber > ( ( @PageNumber - 1 ) * @PageSize ) 

            IF ( SELECT ISNULL(COUNT(*), 0)
                 FROM   #FinalResultSet
               ) < 1 
                BEGIN 
                    SELECT  0 AS PageNumber ,
                            0 AS NumberOfPages ,
                            0 NumberOfRows 
                END 
            ELSE 
                BEGIN 
                    SELECT TOP 1
                            @PageNumber AS PageNumber ,
                            CASE ( TotalCount % @PageSize )
                              WHEN 0 THEN ISNULL(( TotalCount / @PageSize ), 0)
                              ELSE ISNULL(( TotalCount / @PageSize ), 0) + 1
                            END AS NumberOfPages ,
                            ISNULL(totalcount, 0) AS NumberOfRows
                    FROM    #FinalResultSet 
                END 

            SELECT   ProvidrId,
					 Provider,
					 AssociatedProvider,
					 SiteName ,
					 [Address] ,
					 Phone ,
					 SiteId
            FROM    #FinalResultSet
            ORDER BY RowNumber 
         
    END TRY
  BEGIN CATCH
         

IF (@@error != 0)
BEGIN
      RAISERROR ('ssp_CMListPageProviderSearch: An Error Occured While Updating ',16,1);
END

 END CATCH
END		
GO     