public with sharing class TriggerDispatcher {
    public static void run(ITriggerHandler handler) {
        if (Trigger.isBefore && Trigger.isInsert) {
            handler.beforeInsert(Trigger.new);
        } else if (Trigger.isAfter && Trigger.isInsert) {
            handler.afterInsert(Trigger.new);
        } else if (Trigger.isBefore && Trigger.isUpdate) {
            handler.beforeUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}