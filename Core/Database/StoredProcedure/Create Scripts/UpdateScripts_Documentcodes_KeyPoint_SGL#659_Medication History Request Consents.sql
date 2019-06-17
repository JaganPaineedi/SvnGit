/*******************************************************************************************************/

/*** Added By: Ajay    Dated: 04-May-2017   What: Fixed issue. On signature of the document, client will be added automatically and after Client signature, PDF will be refreshed automatically so that all signer will be displayed in PDF.
                                            Why: Client is not automatically added to sign and when client signs it does not appear on PDF
                                            Key Point - Support Go Live:Task#659

***/

/*******************************************************************************************************/
Update DocumentCodes 
Set RecreatePDFOnClientSignature='Y' , RegenerateRDLOnCoSignature='Y' , DefaultCoSigner='Y' 
Where DocumentCodeId=1630
AND ISNULL(RecordDeleted,'N')='N'
 