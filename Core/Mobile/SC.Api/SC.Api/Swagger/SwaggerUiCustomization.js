(function () {
    function addApiKeyAuthorization() {
        var key = $('#input_apiKey')[0].value;
        if (key && key.trim() !== "") {
            key = 'Bearer ' + key;
            var apiKeyAuth = new SwaggerClient.ApiKeyAuthorization(swashbuckleConfig.apiKeyName, key, swashbuckleConfig.apiKeyIn);
            window.swaggerUi.api.clientAuthorizations.add("api_key", apiKeyAuth);
        }
    }
    $('#input_apiKey').attr('placeholder', 'access_token');
    $('#input_apiKey').change(addApiKeyAuthorization);
   
    var baseUrl = window.location.href.substring(0, window.location.href.toLowerCase().indexOf('swagger/'));
    $.ajax({
        type: "GET",
        url: baseUrl + "/api/Common/GetApiDetails",
        success: function (obj) {
            if (obj) {
                $('.info_description').text(obj.description)
                $('.footer h4').append('[<a href="' + baseUrl + obj.documentationUrl + '" target="_blank">API Documentation</a>')
                $('.footer h4').append('&nbsp;,&nbsp;&nbsp;<a href="' + baseUrl + obj.termsofUseUrl + '" target="_blank">Terms of Use</a>]')
            }
        },
        error: function () { console.log('Failed to get Api details from /api/Common/GetApiDetails'); }
    });
})();