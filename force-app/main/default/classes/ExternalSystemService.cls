public class ExternalSystemService {
  //////// DEPRECATED ///////////
  private String webServiceURL;

  private static String webServiceURL = 'https://th-apex-http-callout.herokuapp.com/animals';

  @future(callout=true) // todo
  public static void broadcastMessage(String message) {
    HttpResponse response = createRegistration(message);

    // Parse the JSON response
    if (response.getStatusCode() != 201) {
      System.debug(
        'The status code returned was not expected: ' +
          response.getStatusCode() +
          ' ' +
          response.getStatus()
      );
    }
  }

  public static HttpResponse createRegistration(String messageBody) {
    // send registration request
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(webServiceURL);
    // request.setEndpoint('callout:webService_Registration/animals');
    request.setMethod('POST');
    request.setHeader('Content-Type', 'application/json;charset=UTF-8');
    request.setBody(messageBody);
    // callout exception
    return http.send(request);
  }
}
