trigger CaseTrigger on Case (before update, before insert) {
    new CaseTriggerHelper().run();
}