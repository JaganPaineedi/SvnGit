AddEventHandlers = (function() {
    try {
        var DocumentVersionId = AutoSaveXMLDom.find("CustomDocumentClientDemographics:first DocumentVersionId").text();
        var Span_Address = $('[id$=Span_Address]').text();
        var Span_City = $('[id$=Span_City]').text();
        var Span_State = $('[id$=Span_State]').text();
        var Span_Zip = $('[id$=Span_Zip]').text();
        if (!Span_Address)
            Span_Address = '';
        if (!Span_City)
            Span_City = '';
        if (!Span_State)
            Span_State = '';
        if (!Span_Zip)
            Span_Zip = '';

        if (Span_Address != '')
            Span_Address = Span_Address.trim();
        if (Span_City != '') {
            if (Span_City.indexOf(',') != -1) {
                Span_City = Span_City.trim();
                var lastChar = Span_City.substr(Span_City.length - 1);
                if (lastChar == ',') {
                    Span_City = Span_City.substring(0, Span_City.length - 1)
                }
            }
        }
        if (Span_State != '')
            Span_State = Span_State.trim();
        if (Span_Zip != '')
            Span_Zip = Span_Zip.trim();

        SetColumnValueInXMLNodeByKeyValue("CustomDocumentClientDemographics", "DocumentVersionId", DocumentVersionId, "Address", Span_Address, AutoSaveXMLDom[0]);
        SetColumnValueInXMLNodeByKeyValue("CustomDocumentClientDemographics", "DocumentVersionId", DocumentVersionId, "City", Span_City, AutoSaveXMLDom[0]);
        SetColumnValueInXMLNodeByKeyValue("CustomDocumentClientDemographics", "DocumentVersionId", DocumentVersionId, "State", Span_State, AutoSaveXMLDom[0]);
        SetColumnValueInXMLNodeByKeyValue("CustomDocumentClientDemographics", "DocumentVersionId", DocumentVersionId, "Zip", Span_Zip, AutoSaveXMLDom[0]);
    }
    catch (ex) {

    }
});