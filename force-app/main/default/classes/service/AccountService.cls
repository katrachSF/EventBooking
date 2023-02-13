public class AccountService {
  public static Account getAccountById(Id accId) {
    return [
      SELECT Id, (SELECT Id FROM Contacts)
      FROM Account
      WHERE Id = :accId
      LIMIT 1
    ];
  }

  public static Integer getCountContact(Id accId) {
    return [SELECT COUNT(Id) FROM Contact WHERE AccountId = :accId];
  }
}
