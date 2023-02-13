trigger CaseTrigger on Case(after update, before insert) {
  new CaseTriggerHelper().run();
}
