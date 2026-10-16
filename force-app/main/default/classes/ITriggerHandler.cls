public interface ITriggerHandler {
    void beforeInsert(List<SObject> newList);
    void afterInsert(List<SObject> newList);
    void beforeUpdate(List<SObject> newList, Map<Id, SObject> oldMap);
}