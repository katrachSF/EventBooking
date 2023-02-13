@isTest
global class ExternalSystemServiceMock implements HttpCalloutMock {
  global HTTPResponse respond(HTTPRequest request) {
    // Create a fake response
    HttpResponse response = new HttpResponse();
    response.setHeader('Content-Type', 'application/json');
    response.setStatusCode(201);
    return response;
  }
}
