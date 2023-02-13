@isTest
global class RegistrationHelperMock implements HttpCalloutMock {
  private Integer statusCode;

  /**
   * param constructor
   * @param statusCode http status code to be returned
   */
  public RegistrationHelperMock(Integer statusCode) {
    this.statusCode = statusCode;
  }

  global HTTPResponse respond(HTTPRequest request) {
    // Create a fake response
    HttpResponse response = new HttpResponse();
    response.setHeader('Content-Type', 'application/json');
    response.setStatusCode(this.statusCode);
    return response;
  }
}
