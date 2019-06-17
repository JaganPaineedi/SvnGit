/*
DocumentValidations Update script for Release Of Information - Validation Messgae
Author : PREM
Task:Aspen Point Build Cycle Tasks #84
*/



Update documentvalidations set ValidationDescription='Release To/Obtain From – Type - At least one Checkbox is required.',
                                ErrorMessage='Release To/Obtain From – Type - At least one Checkbox is required.'
Where ValidationLogic='FROM DocumentReleaseOfInformations WHERE DocumentVersionId=@DocumentVersionId AND (ISNULL(ReleaseTo, ''N'') = ''N'' AND ISNULL(ObtainFrom, ''N'') = ''N'')' and DocumentCodeId=1648
