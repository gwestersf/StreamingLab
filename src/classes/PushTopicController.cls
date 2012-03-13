public with sharing class PushTopicController {

    public PushTopic newPushTopic {get; set;}
    public String deleteTopicId {get; set;}
    public final List<PushTopic> activePushTopics {get; set;}
    public final List<PushTopic> inactivePushTopics {get; set;}
    
    public PushTopicController() {
        newPushTopic = new PushTopic();
        activePushTopics = [SELECT id, name, query, apiversion, isactive, notifyForFields, notifyForOperations FROM PushTopic WHERE isactive=true];
        inactivePushTopics = [SELECT id, name, query, apiversion, isactive, notifyForFields, notifyForOperations FROM PushTopic WHERE isactive=false];
    }

    public PageReference save() {
        newPushTopic.apiversion = 24.0;
        newPushTopic.isactive = true;
        insert newPushTopic;
        return null;
    }
    
    public PageReference deleteTopic() {
        List<PushTopic> deleteTopic = [SELECT id FROM PushTopic WHERE id = :deleteTopicId];
        delete deleteTopic;
        return null;
    }
}