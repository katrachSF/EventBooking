
public without sharing class CaseTriggerHelper extends TriggerHandler{
   
    /**
     * @description Handling before update on Case
     */
    public override void beforeUpdate() {
        Case caseBeforeUpdate = (Case) Trigger.new.get(0);
        if(!Schema.sObjectType.Case.isQueryable()){
            return;
        }
        Case fullCase = [SELECT AccountId, Status FROM Case where id=:caseBeforeUpdate.ID];
        if(fullCase.Status == 'Closed'){
            ExternalSystemService service = new ExternalSystemService();
            service.registerAttendees(fullCase);
        }
    }
    /**
     * @description Handling before insert on Case
     */
    public override void beforeInsert() {
        Case caseBeforeInsert = (Case) Trigger.new.get(0);
        if(caseBeforeInsert != null && caseBeforeInsert.AccountId != null){
            if(!Schema.sObjectType.Account.isQueryable()){
                return;
            }
            Account accounts =  [SELECT ID, (select id from contacts) FROM Account where id = :caseBeforeInsert.AccountId LIMIT 1];
            Integer contactsSize = accounts.Contacts.size();
            handleCaseErrors(caseBeforeInsert,contactsSize);
        } else {
            caseBeforeInsert.addError('You cannot create a request without attaching an account');
        }
    }
    /**
     * @description Handling Case error by contacts size & Case origin
     * @param caseBeforeInsert case object
     * @param contactsSize contacts size
     */
    public void handleCaseErrors(Case caseBeforeInsert, Integer contactsSize) {
        if(contactsSize == 0) {
            caseBeforeInsert.addError('You cannot create a request for accounts without contacts');
        } else if(caseBeforeInsert.Origin == 'Web' && contactsSize >= 2) {
            caseBeforeInsert.addError('Web request are only allowed to have one attendee');
        } else if(caseBeforeInsert.Origin == 'Phone' && contactsSize >= 4) {
            caseBeforeInsert.addError('Phone request are only allowed to have three attendee');
        }
    }
}
    
