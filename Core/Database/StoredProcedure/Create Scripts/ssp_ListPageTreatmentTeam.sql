IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_ListPageTreatmentTeam]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_ListPageTreatmentTeam]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_ListPageTreatmentTeam]    
 @PageNumber     INT,     
 @PageSize       INT,     
 @SortExpression VARCHAR(100),  
 @TreatmentRole  INT,  
 @Status		 INT,      
 @ClientId       INT,
 @OtherFilter    INT     
AS     
  /************************************************************************************************                                    
  -- Stored Procedure: dbo.ssp_ListPageTreatmentTeam          
  -- Copyright: Streamline Healthcate Solutions           
  -- Purpose: Used by Document Assignment list page           
  -- Updates:           
  -- Date          Author            Purpose           
  -- 05 Dec 2016  Arjun KR         List Page SP for Treatment Team. Task #447 Aspen Pointe Customizations  
  -- 15 May 2017  Bibhu            Modified logic for PhoneNumber to insert ', ' after Every PhoneNumber
                                   Task #239 AspenPointe-Environment Issue            
  -- 14 Mar 2018  Venkatesh        Modified the logic to get the data, from inner join to Left Join. Because if the Team member is null system was not returning the data
                                   Task #187 Texas Go Live Build Issues   
  -- 09/Sep/2018 Dasari Sunil       What: Modified code to display phone number with out trimming last value.
									Why: When you add a contact to the Treatment Team screen using the contacts radio button, it initializes the phone number for the contact, but after it saves, the last number in the phone number disappears.       
									Porter Starke-Environment Issues Tracking #19
 -- 20 02 2019  Venkatesh        When we are getting the TreatmentRole we should map with ClientTreatmentTeamMember table not the StaffPreferences table.
								Task #2718 Core Bugs   
 -- 07/MAR/2019  Vijay        What:Formatting Treatment Team Member as [LastName, FirstName]
							  Why:Engineering Improvement Initiatives- NBL(I) #590.1     
  *************************************************************************************************/    
  BEGIN     
      BEGIN TRY     
          SET nocount ON;     
    
          --DECLATE TABLE TO GET DATA IF OTHER FILTER EXISTS -------                
          DECLARE @CustomFiltersApplied CHAR(1)     
          CREATE TABLE #CustomFilters (InsurersID int)     
             
          SET @CustomFiltersApplied = 'N'        
              
    
          CREATE TABLE #ClientTreatmentTeamMembers   
            (     
              ClientTreatmentTeamMemberId INT,
              TreatmentTeamMember VARCHAR(100),
              TreatmentTeamRole   VARCHAR(100),
              PhoneNumber    VARChAR(max),
              StartDate datetime,
              EndDate   datetime,
              Active   VARCHAR(100)
            )     
    
          --GET CUSTOM FILTERS                
          IF @OtherFilter > 10000     
            BEGIN    
                SET @CustomFiltersApplied = 'Y'     
                INSERT INTO #CustomFilters (InsurersID)     
                EXEC scsp_ListPageDocumentAssignment  @TreatmentRole,@Status,@OtherFilter     
            END     
    
          --INSERT DATE INTO TEMP TABLE WHICH IS FETCHED BELOW BY APPLYING FILTER.             
          IF @CustomFiltersApplied = 'N'     
				BEGIN 
					INSERT INTO #ClientTreatmentTeamMembers
					 SELECT TT.ClientTreatmentTeamMemberId 
						   ,ISNULL(LastName,'')+' '+ISNULL(FirstName,'') AS TreatmentTeamMember
						   ,GC.CodeName AS TreatmentTeamRole 
								 ,(SELECT ISNULL(STUFF((SELECT case when isnull(p.PhoneNumber,'')='' then '' else ',' end + ISNULL(cast(p.PhoneNumber as varchar), '')
								  FROM ClientTreatmentTeamPhones p  
								  WHERE P.ClientTreatmentTeamMemberId=TT.ClientTreatmentTeamMemberId     
								  FOR XML PATH('')
								  ,type ).value('.', 'nvarchar(max)'), 1, 1, ' '), '') ) AS PhoneNumber
						  -- ,TTP.PhoneNumberText AS PhoneNumber
						   ,TT.StartDate
						   ,TT.EndDate
						   ,CASE WHEN ISNULL(TT.Active,'Y')='Y' THEN 'Active' ELSE 'InActive' END AS Active
					FROM   ClientTreatmentTeamMembers TT
					LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId=TT.TreatmentTeamRole
				--	LEFT JOIN ClientTreatmentTeamPhones TTP ON TTP.ClientTreatmentTeamMemberId=TT.ClientTreatmentTeamMemberId
					WHERE  Isnull(TT.RecordDeleted, 'N') = 'N'
					       AND (TT.MemberType='E')
					       AND ((TreatmentTeamRole=@TreatmentRole) or @TreatmentRole=0)
						   AND (( @Status = 1 AND ISNULL(TT.Active,'Y') = 'Y' ) 					
						   OR ( @Status = 2 AND TT.Active = 'N' ) 
						   OR ( @Status = -1 ) )
						   AND TT.ClientId=@ClientId
						   
				   UNION
				   SELECT TT.ClientTreatmentTeamMemberId
				          ,ISNULL(S.LastName,'')+', '+ISNULL(S.FirstName,'')
				          ,GC.CodeName AS TreatmentTeamRole 
				          ,ISNULL(S.OfficePhone1+', ','')+case when ISNULL(S.OfficePhone1,'')='' OR ISNULL(S.OfficePhone2,'')=''  then '' else  '' end +ISNULL(S.OfficePhone2+', ','')+ case when ISNULL(S.OfficePhone2,'')='' OR ISNULL(S.PhoneNumber,'')='' THEN '' ELSE '' end 
                           +ISNULL(S.PhoneNumber+', ','')+ case when ISNULL(S.PhoneNumber,'')='' OR ISNULL(S.HomePhone,'')='' then '' else '' end +ISNULL(S.HomePhone+', ','') AS PhoneNumber 
				          ,TT.StartDate
				          ,TT.EndDate
				          ,CASE WHEN ISNULL(TT.Active,'Y')='Y' THEN 'Active' ELSE 'InActive' END AS Active
				   FROM ClientTreatmentTeamMembers TT
				   LEFT JOIN Staff S ON S.StaffId=TT.StaffId
				   LEFT JOIN StaffPreferences SP ON SP.StaffId=S.StaffId
				   LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId=TT.TreatmentTeamRole
				   WHERE  Isnull(TT.RecordDeleted, 'N') = 'N'
					       AND (TT.MemberType='S')
					       AND ((TT.TreatmentTeamRole=@TreatmentRole) or @TreatmentRole=0)
						   AND (( @Status = 1 AND ISNULL(TT.Active,'Y') = 'Y' ) 					
						   OR ( @Status = 2 AND TT.Active= 'N' ) 
						   OR ( @Status = -1 ) )
						   AND TT.ClientId=@ClientId
						   
				   UNION
				   SELECT TT.ClientTreatmentTeamMemberId
						  ,CC.LastName+' '+CC.FirstName
						  ,GC.CodeName AS TreatmentTeamRole 
						 -- ,CCP.PhoneNumber
						  ,(SELECT ISNULL(STUFF((SELECT case when isnull(p.PhoneNumber,'')='' then '' else ',' end + ISNULL(cast(p.PhoneNumber as varchar), '')
								  FROM ClientContacts CC 
								  INNER JOIN ClientContactPhones P on CC.ClientContactId=p.ClientContactId
								  WHERE CC.ClientContactId=TT.ClientContactId     
								  FOR XML PATH('')
								  ,type ).value('.', 'nvarchar(max)'), 1, 1, ' '), '') ) AS PhoneNumber
						  ,TT.StartDate
				          ,TT.EndDate
				          ,CASE WHEN ISNULL(TT.Active,'Y')='Y' THEN 'Active' ELSE 'InActive' END AS Active
				   FROM ClientTreatmentTeamMembers TT
				   LEFT JOIN ClientContacts CC ON CC.ClientContactId=TT.ClientContactId
				   LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId=TT.TreatmentTeamRole
				   LEFT JOIN ClientContactPhones CCP ON CCP.ClientContactId=CC.ClientContactId
				   		   WHERE  Isnull(TT.RecordDeleted, 'N') = 'N'
					       AND (TT.MemberType='C')
					       AND (CCP.PhoneType=30 OR 1=1)
					       AND ((TT.TreatmentTeamRole=@TreatmentRole) or @TreatmentRole=0)
						   AND (( @Status = 1 AND ISNULL(TT.Active,'Y') = 'Y' )
						    					
						   OR ( @Status = 2 AND TT.Active = 'N' ) 
						   OR ( @Status = -1 ) )
						   AND TT.ClientId=@ClientId		         
						   
			  END;
					       
    
    WITH Counts     
         AS (SELECT COUNT(*) AS TotalRows     
             FROM   #ClientTreatmentTeamMembers),     
         ListBanners     
         AS (SELECT			 ClientTreatmentTeamMemberId,          
							 TreatmentTeamMember,  
							 TreatmentTeamRole,
							 PhoneNumber,
							 StartDate,
							 EndDate,
                             Active,         
                             COUNT(*)     
                             OVER ()   AS     
                             TotalCount,     
                             RANK()     
                               OVER (  ORDER BY     
                                          CASE WHEN @SortExpression='ClientTreatmentTeamMemberId' THEN ClientTreatmentTeamMemberId  END,     
                                          CASE WHEN @SortExpression='ClientTreatmentTeamMemberId desc' THEN ClientTreatmentTeamMemberId END DESC,    
                                          CASE WHEN @SortExpression='TreatmentTeamMember' THEN TreatmentTeamMember END,     
                                          CASE WHEN @SortExpression='TreatmentTeamMember desc' THEN TreatmentTeamMember END DESC, 
                                          CASE WHEN @SortExpression='TreatmentTeamRole' THEN TreatmentTeamRole END,     
                                          CASE WHEN @SortExpression='TreatmentTeamRole desc' THEN TreatmentTeamRole END DESC,
                                          CASE WHEN @SortExpression='PhoneNumber' THEN PhoneNumber END,     
                                          CASE WHEN @SortExpression='PhoneNumber desc' THEN PhoneNumber END DESC,
                                          CASE WHEN @SortExpression='StartDate' THEN StartDate END,     
                                          CASE WHEN @SortExpression='StartDate desc' THEN StartDate END DESC,
                                          CASE WHEN @SortExpression='EndDate' THEN EndDate END,     
                                          CASE WHEN @SortExpression='EndDate desc' THEN EndDate END DESC,    
                                          CASE WHEN @SortExpression='Active' THEN Active END,     
                                          CASE WHEN @SortExpression='Active desc' THEN Active END DESC,ClientTreatmentTeamMemberId) AS  RowNumber    
              FROM  #ClientTreatmentTeamMembers)     
    SELECT TOP (CASE WHEN (@PageNumber = -1) THEN (SELECT ISNULL( totalrows, 0)     
    FROM     
    Counts ) ELSE (@PageSize) END) ClientTreatmentTeamMemberId,
								   TreatmentTeamMember,  
								   TreatmentTeamRole,
								   PhoneNumber,
								   StartDate,
								   EndDate,
								   Active,  
                                   TotalCount,     
                                   RowNumber     
    INTO   #FinalResultSet     
    FROM   ListBanners     
    WHERE  RowNumber > ((@PageNumber - 1 ) * @PageSize )     
    
    IF (SELECT ISNULL(COUNT(*), 0)     
        FROM   #finalresultset) < 1     
      BEGIN     
          SELECT 0 AS PageNumber,     
                 0 AS NumberOfPages,     
                 0 NumberOfRows     
      END     
    ELSE     
      BEGIN     
          SELECT TOP 1 @PageNumber           AS PageNumber,     
                       CASE ( TotalCount % @PageSize )     
                       WHEN 0 THEN ISNULL(( TotalCount / @PageSize ), 0)     
                       ELSE ISNULL(( TotalCount / @PageSize ), 0) + 1     
                       END  AS NumberOfPages,     
                       ISNULL(totalcount, 0) AS NumberOfRows     
          FROM   #FinalResultSet     
      END     
    
    SELECT ClientTreatmentTeamMemberId,     
           TreatmentTeamMember,
           TreatmentTeamRole,
          PhoneNumber = 
     CASE PhoneNumber WHEN null THEN null 
     ELSE (
         CASE LEN(PhoneNumber) WHEN 0 THEN PhoneNumber 
            ELSE LEFT(PhoneNumber, LEN(PhoneNumber)) 
         END 
     ) END,
           convert(varchar,StartDate,101) as StartDate,
           convert(varchar,EndDate,101) as EndDate,      
           Active         
    FROM   #FinalResultSet     
    ORDER  BY RowNumber     
     

END TRY     
    
    BEGIN CATCH     
        DECLARE @Error VARCHAR(8000)     
    
        SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'     
                    + CONVERT(VARCHAR(4000), ERROR_MESSAGE())     
                    + '*****'     
                    + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),     
                    'ssp_ListPageTreatmentTeam')     
                    + '*****' + CONVERT(VARCHAR, ERROR_LINE())     
                    + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY())     
                    + '*****' + CONVERT(VARCHAR, ERROR_STATE())     
    
        RAISERROR ( @Error,     
                    -- Message text.                                                                                                
                    16,     
                    -- Severity.                                                                                                
                    1     
                   -- State.                                                                                                
                    );     
     END CATCH     
END 

GO


