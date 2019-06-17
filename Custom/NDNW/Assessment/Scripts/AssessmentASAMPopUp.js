function SetScreenSpecificValues(dom, action) {
    //Below code is added for Disabled Save button if Document is signed
    if (parent.AutoSaveXMLDom != undefined && parent.AutoSaveXMLDom[0].xml != "") {
        var getDocumentStatus = GetFielValueFromXMLDom(parent.AutoSaveXMLDom[0], "Documents", "Status");
        if (getDocumentStatus == "22") {
            $('#Button_ASAM_Save').attr('disabled', true);
        }
    }

}

function CloseASAMPopUp() {
    parent.CloaseModalPopupWindow();
}

function SaveASAMPopUpData() {
  if (AutoSaveXMLDom != undefined && AutoSaveXMLDom[0].xml != undefined) {

      var _CustomASAMRow = AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomASAMPlacements");
      //Initialize table values in parent DOM XML
      var data = {}
      $(AutoSaveXMLDom[0].childNodes[0].selectNodes("CustomASAMPlacements")).each(function() {
          $(this).children().each(function() {
              data[this.tagName] = $(this).text();


              var parentTableObject = $("CustomASAMPlacements", parent.AutoSaveXMLDom);
              var parentColumnObject = $(this.tagName, parentTableObject);

              if ($(this.tagName, parentTableObject).length == 0) {
                  parentTableObject[0].appendChild(parent.AutoSaveXMLDom[0].createElement(this.tagName));
                  parentColumnObject = $(this.tagName, parentTableObject);
                  //Handle Null value
                  if ($(this).text() == "") {
                      parentColumnObject.attr("xsi:nil", 'true');
                  }
                  parentColumnObject.text($(this).text());
              }
              else {
                  //Handle Null value
                  if ($(this).text() == "") {
                      parentColumnObject.attr("xsi:nil", 'true');
                  }
                  if (parentColumnObject.text() != $(this).text()) {
                      parentColumnObject.text($(this).text());
                  }
                  else {
                      return;
                  }
              }


          })
      });
        
        if (_CustomASAMRow.length > 0) {
            OpenPage(5761, 10690, 'ASAMPopUpData=' + encodeTextSymbol(_CustomASAMRow[0].xml) + '^Flag=SaveASAMPopup', null, GetRelativePath(), null, null, pageActionEnum.CustomAjaxCall, null, null, null);
        }
    }
}

function encodeTextSymbol(TextToEncode) {
    try {
        var encodedHtml = TextToEncode.replace(/\+/g, "%PL");
        return encodedHtml;
    }
    catch (ex) {   
    }
}

function GetXMLDomOnTabClick() {
    objectPageResponse.ScreenDataSetXml = AutoSaveXMLDom[0].xml;
    return AutoSaveXMLDom;
}