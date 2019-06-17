'use strict';

app.factory("stacktraceService", function () {
    // "printStackTrace" is a global object.
    return ({
        print: printStackTrace
    });
});