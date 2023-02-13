public with sharing class RegistrationHelper implements Queueable {
  private Contact attendee;

  public RegistrationHelper(Contact registrationAttendee) {
    attendee = registrationAttendee;
  }

  public void execute(QueueableContext context) {
    HttpRequestBody httpRequestBody = new httpRequestBody(
      attendee.name,
      attendee.email
    );
    String message = JSON.serialize(httpRequestBody);
    createRegistration(message);
  }

  @Future(callout=true)
  public static void createRegistration(String message) {
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    HttpResponse response;
    request.setEndpoint('https://th-apex-http-callout.herokuapp.com/animals');
    // request.setEndpoint('callout:webService_Registration/animals');
    request.setMethod('POST');
    request.setHeader('Content-Type', 'application/json;charset=UTF-8');
    request.setBody(message);
    // callout exception
    try {
      response = http.send(request);
    } catch (CalloutException excp) {
      System.debug(
        'The status code returned was not expected: ' + excp.getMessage()
      );
    }
  }

  public class HttpRequestBody {
    public String name { get; set; }
    public String email { get; set; }

    public HttpRequestBody(String name, String email) {
      this.name = name;
      this.email = email;
    }
  }
}
