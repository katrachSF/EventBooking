public class ContactService {
  public static List<Contact> getContactsByAccountId(Id accId) {
    return [
      SELECT Id, Name, Email
      FROM Contact
      WHERE accountid = :accId
      LIMIT 1
    ];
  }
}
