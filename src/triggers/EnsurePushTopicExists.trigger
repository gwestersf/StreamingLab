trigger EnsurePushTopicExists on Shipment__c (before insert) {
    List<PushTopic> topics = [SELECT id FROM pushtopic WHERE name ='shipment'];
    
    if(topics.size() == 0) {
        PushTopic newTopic = new PushTopic();
        newTopic.name = 'shipment';
        newTopic.query = 'SELECT id, name, gwestr__ContactEmail__c, gwestr__Contact_Phone__c, gwestr__Insurance__c, gwestr__OverWeight__c, gwestr__Rush__c, gwestr__Scheduled_Delivery__c, gwestr__Status__c, gwestr__TrackingExtId__c, gwestr__Tracking_URL__c, gwestr__Warnings__c, gwestr__Weight__c FROM gwestr__Shipment__c';
        newTopic.apiversion = 24.0d;
        newTopic.notifyForFields = 'All';
        newTopic.notifyForOperations = 'All';
        insert newTopic;
    }
}