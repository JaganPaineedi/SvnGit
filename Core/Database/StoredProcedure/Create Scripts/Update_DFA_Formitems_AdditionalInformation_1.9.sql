/********************************************************************************************
Author		:	Vinay K S
CreatedDate	:	24 Jan 2019
Purpose		:	DFA forms update script to allign 'Have you ever or are you currently serving' label at Registration Document
*********************************************************************************************/

UPDATE Formitems 
SET ItemLabel='<span style="padding-left:10px">Have you ever or are you currently serving  &nbsp;&nbsp;&nbsp;in the military?</span>'
WHERE ItemLabel ='<span style=''padding-left:10px''>Have you ever or are you currently serving in the military?</span>' and sortorder=9