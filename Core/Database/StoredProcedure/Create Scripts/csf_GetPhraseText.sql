IF EXISTS (SELECT * FROM sysobjects WHERE type = 'FN' AND name = 'csf_GetPhraseText')
	BEGIN
		DROP  Function  csf_GetPhraseText
	END

GO
 CREATE FUNCTION dbo.csf_GetPhraseText
(
	 @KeyPhraseText Varchar(max)
	,@KeyPhraseCategory int
	,@ScreenId int
	,@PrimaryKeyName Varchar(250)
	,@ClientId int
)
RETURNS varchar(Max)

/* Copyright: 2005 Streamline Healthcare Solutions,  LLC          */ 
/* Purpose : to retrieve the Text of phrases corresponds to tags  and returns the complete phrase text*/
/* Inputs :- PhraseText , ScreenId, PrimaryKeyName,ClientId*/
/* Output :- Returns the Phrase Text coresspond to value of Tags in Phrase Text*/
/* Author:		Devi Dayal*/
/* Create date: 06 Dec 2011*/
/*Date        Modified By      Purpose*/
/*07/08/2018  Lakshmi          Replaced single quotes with respective html code since it was breaking tool tip feature in key phrase. MFS Build Cycle Tasks #27*/

AS
 BEGIN								       
 	-- Declare the return variable here
	  Declare @KeyPhraseTextTags as Varchar(max)
  Set @KeyPhraseTextTags=Replace(@KeyPhraseText,'&lt;memberName&gt;','Streamline')
  --Set @KeyPhraseTextTags=Replace(@KeyPhraseTextTags,'''','&#39') //Changes reverted due to someother issues.
  RETURN @KeyPhraseTextTags

END
GO