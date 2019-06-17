/****** Object:  StoredProcedure [dbo].[ssp_GetComponentOfXMLString]    Script Date: 09/22/2017 17:51:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetComponentOfXMLString]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetComponentOfXMLString]
GO


/****** Object:  StoredProcedure [dbo].[ssp_GetComponentOfXMLString]    Script Date: 09/22/2017 17:51:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
CREATE PROCEDURE [dbo].[ssp_GetComponentOfXMLString] @ClientId INT = NULL      
 ,@Type VARCHAR(10) = NULL      
 ,@DocumentVersionId INT = NULL      
 ,@FromDate DATETIME = NULL      
 ,@ToDate DATETIME = NULL     
 ,@OutputComponentXML VARCHAR(MAX) OUTPUT    
  -- =============================================                                 
/*                      
 Author   Added Date   Reason   Task                      
 Gautam   05/09/2017   Initial  MUS3 - Task#25.4 Transition of Care - CCDA Generation        
*/  
AS    
BEGIN    
 DECLARE @DefaultComponentXML VARCHAR(MAX) =     
  '  <componentOf>  
      <encompassingEncounter>  
         <id extension="1" root="2.16.840.1.113883.4.6"/>  
         <code  
            code="233604007"  
            codeSystem="2.16.840.1.113883.6.96"  
            codeSystemName="SNOMED-CT"  
            displayName="Pnuemonia"/>  
         <effectiveTime>  
            <low  
               value="201208060028+0500"/>  
            <high  
               value="201208060058+0500"/>  
         </effectiveTime>  
         <responsibleParty>  
            <assignedEntity>  
               <id root="2.16.840.1.113883.4.6"/>  
               <assignedPerson>  
                  <name>  
                     <prefix>Dr</prefix>  
                     <given>Henry</given>  
                     <family>Seven</family>  
                  </name>  
               </assignedPerson>  
            </assignedEntity>  
         </responsibleParty>  
         <encounterParticipant typeCode="ATND">  
            <assignedEntity>  
               <id root="2.16.840.1.113883.4.6"/>  
               <assignedPerson>  
                  <name>  
                     <prefix>Dr</prefix>  
                     <given>Henry</given>  
                     <family>Seven</family>  
                  </name>  
               </assignedPerson>  
            </assignedEntity>  
         </encounterParticipant>  
         <location>  
            <healthCareFacility>  
               <id root="2.16.840.1.113883.4.6"/>  
            </healthCareFacility>  
         </location>  
      </encompassingEncounter>  
   </componentOf>'    
 DECLARE @FinalComponentXML VARCHAR(MAX)    
 DECLARE @PLACEHOLDERXML VARCHAR(MAX) = '<componentOf>
		<encompassingEncounter>
			<id extension="1" root="2.16.840.1.113883.4.6"/>
			###componentOfText###
			<location>
				<healthCareFacility>
					<id root="2.16.840.1.113883.4.6"/>
				</healthCareFacility>
			</location>
		</encompassingEncounter>
	</componentOf>'    
     
 DECLARE @entryXML VARCHAR(MAX) =
		'<code code="##SNOMEDCTCode##" codeSystem="2.16.840.1.113883.6.96" codeSystemName="SNOMED-CT" displayName="##SNOMEDDesc##"/>
		<effectiveTime>
			<low value="##EffectiveDate##"/>
			<high value="##EffectiveDate##"/>
		</effectiveTime>
		<responsibleParty>
			<assignedEntity>
				<id root="2.16.840.1.113883.4.6"/>
				<assignedPerson>
					<name>
						<prefix>Dr</prefix>
						<given>##FirstName##</given>
						<family>##LastName##</family>
					</name>
				</assignedPerson>
			</assignedEntity>
		</responsibleParty>
		<encounterParticipant typeCode="ATND">
			<assignedEntity>
				<id root="2.16.840.1.113883.4.6"/>
				<assignedPerson>
					<name>
						<prefix>Dr</prefix>
						<given>##FirstName##</given>
						<family>##LastName##</family>
					</name>
				</assignedPerson>
			</assignedEntity>
		</encounterParticipant>'
    
 DECLARE @finalEntry VARCHAR(MAX)    
 SET @finalEntry = ''    
    
 DECLARE @loopCOUNT INT = 0    
 DECLARE @tResults TABLE (    
   ClientId int,  
   ICD9Code varchar(100),  
   ICD10Code varchar(100),  
   SNOMED varchar(20),  
   SNOMEDDesc varchar(max),  
   EffectiveDate datetime,  
   LastName varchar(50),  
   FirstName varchar(30))  
    
 INSERT INTO @tResults    
  EXEC ssp_GetComponentOf @ClientId    
   ,@Type     
   ,@DocumentVersionId     
   ,@FromDate     
   ,@ToDate
   
 DECLARE @SNOMED varchar(20) = ''    
 DECLARE  @SNOMEDDesc varchar(max)= ''   
 DECLARE  @EffectiveDate datetime= ''   
 DECLARE   @LastName varchar(50)= ''   
  DECLARE  @FirstName varchar(30)= ''   
     
 IF EXISTS (    
   SELECT *    
   FROM @tResults    
   )    
 BEGIN    
  DECLARE tCursor CURSOR FAST_FORWARD    
  FOR    
  SELECT SNOMED,SNOMEDDesc ,EffectiveDate , LastName,FirstName  
  FROM @tResults TDS    
    
  OPEN tCursor    
    
  FETCH NEXT    
  FROM tCursor    
  INTO @SNOMED,@SNOMEDDesc ,@EffectiveDate ,@LastName,@FirstName   
    
  WHILE (@@FETCH_STATUS = 0)    
  BEGIN    
   SET @finalEntry = @finalEntry + @entryXML    
   SET @finalEntry = REPLACE(@finalEntry, '##SNOMEDCTCode##', ISNULL(@SNOMED, 'UNK'))    
   SET @finalEntry = REPLACE(@finalEntry, '##SNOMEDDesc##', ISNULL(@SNOMEDDesc, 'UNK'))    
   SET @finalEntry = REPLACE(@finalEntry, '##EffectiveDate##', ISNULL(@EffectiveDate, 'UNK'))    
   SET @finalEntry = REPLACE(@finalEntry, '##FirstName##', ISNULL(@FirstName, 'UNK'))    
   SET @finalEntry = REPLACE(@finalEntry, '##LastName##', ISNULL(@LastName, 'UNK'))       
   SET @loopCOUNT = @loopCOUNT + 1    
    
   PRINT @finalEntry    
    
   FETCH NEXT    
   FROM tCursor    
   INTO @SNOMED,@SNOMEDDesc ,@EffectiveDate  ,@LastName,@FirstName   
  END    
    
  CLOSE tCursor    
    
  DEALLOCATE tCursor    
    
  SET @FinalComponentXML = REPLACE(@PLACEHOLDERXML, '###componentOfText###', @finalEntry)    
  SET @OutputComponentXML = @FinalComponentXML    
 END    
     
END    
GO


