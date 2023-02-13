public without sharing class CaseTriggerHelper extends TriggerHandler {
  private List<Case> caseList;

  public CaseTriggerHelper() {
    caseList = (List<Case>) Trigger.new;
  }

  public override void afterUpdate() {
    registerAttendees(caseList);
  }

  public override void beforeInsert() {
    handleCaseValidation(CaseList);
  }
  private static void registerAttendees(List<Case> caseList) {
    for (Case resRequest : CaseList) {
      if (resRequest.Status == 'CLOSED') {
        List<Contact> attendees = ContactService.getContactsByAccountId(
          resRequest.AccountId
        );
        for (Contact attendee : attendees) {
          System.enqueueJob(new RegistrationHelper(attendee));

          String message =
            '{"name":"' +
            attendee.Name +
            '-' +
            attendee.Email +
            '}';

          // ExternalSystemService.broadcastMessage(message);

          //   notifyAttendeeByEmail(attendee);
          //  EmailService.notifyAttendee();
        }
      }
    }
  }

  public void handleCaseValidation(List<Case> caseList) {
    for (Case caseBeforeInsert : caseList) {
      //limit!
      if (caseBeforeInsert.AccountId != null) {
        Account accounts = AccountService.getAccountById(
          caseBeforeInsert.AccountId
        );
        // Todo select count instead of .size
        Integer contactsSize = AccountService.getCountContact();

        // Retrieve the value of a custom labels
        String contactsSizeEqualZeroError = System.Label.Contacts_Size_Equal_Zero_Error;
        String phoneRequestSizeError = System.Label.Phone_Request_Size_Error;
        String requestWithoutAccountError = System.Label.Request_Without_Account_Error;
        String webRequestSizeError = System.Label.Web_Request_Size_Error;

        // Use the custom label value in Apex code
        System.debug(myCustomLabel);

        if (contactsSize == 0) {
          caseBeforeInsert.addError(Contacts_Size_Equal_Zero_Error);
        } else if (caseBeforeInsert.Origin == 'Web' && contactsSize != 1) {
          caseBeforeInsert.addError(Web_Request_Size_Error);
        } else if (caseBeforeInsert.Origin == 'Phone' && contactsSize > 3) {
          caseBeforeInsert.addError(Phone_Request_Size_Error);
        }
      } else {
        caseBeforeInsert.addError(Request_Without_Account_Error);
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
