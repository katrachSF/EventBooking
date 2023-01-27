public with sharing class WebServiceHelper {
  private static String webServiceURL = 'https://th-apex-http-callout.herokuapp.com/animals';

  public static HttpResponse createRegistration(Contact attendee) {
    // send registration request
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint('callout:webService_Registration/animals');
    request.setMethod('POST');
    request.setHeader('Content-Type', 'application/json;charset=UTF-8');
    request.setBody('{"name":"' + attendee.Name + '-' + attendee.Email + '}');

    return http.send(request);
  }
}
