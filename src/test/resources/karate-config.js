function fn() {
    var env     = karate.env || 'local';
    var baseUrl = karate.properties['baseUrl'] || 'http://localhost:9966/petclinic/api';

    // prepare auth header if credentials are provided
    var user = karate.properties['apiUser'];
    var pass = karate.properties['apiPass'];
    var headers = { 'Content-Type': 'application/json' };
    if (user && pass) {
        var creds = user + ':' + pass;
        var encoded = java.util.Base64.getEncoder()
            .encodeToString(java.lang.String(creds).getBytes());
        headers.Authorization = 'Basic ' + encoded;
    }

    // apply these headers as defaults for every request
    karate.configure('headers', headers);

    // return everything you want available in your features
    return {
        baseUrl: baseUrl,
        headers: headers
    };
}
