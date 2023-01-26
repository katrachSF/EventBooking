public class ExternalSystemService {
  private String webServiceURL;

  public static void registerAttendees(Case r) {
    for (Account a : [
      SELECT id, (SELECT id, name, email FROM Contacts)
      FROM Account
      WHERE id = :r.AccountId
    ]) {
      for (Contact c : a.Contacts) {
        HttpResponse response = WebServiceHelper.createRegistration(c);

        // Parse the JSON response
        if (response.getStatusCode() != 201) {
          System.debug(
            'The status code returned was not expected: ' +
              response.getStatusCode() +
              ' ' +
              response.getStatus()
          );
        } else {
          // Everything went as expected.
          notifyAttendeeByEmail(c);
        }
      }
    }
  }

  public static void notifyAttendeeByEmail(Contact account) {
    Task tk = new Task();
    tk.Subject = 'Send Email To' + account.name;
    tk.Status = 'Open';
    tk.Priority = 'Normal';
    tk.WhatId = account.ID;
    insert tk;
  }
}
