@IsTest
public class EnsurePushTopicExistsTriggerTest {

    static testMethod void testNoTopicPreExistsOnShipment() {
        List<PushTopic> topics = [SELECT id FROM pushtopic WHERE name = 'shipment'];
        
        //If fails, was expecting no topic
        System.assertEquals(0, topics.size());
    }

    static testMethod void testTriggerCreatesNewPushTopic() {
        insertShipment();
        List<PushTopic> topics = [SELECT id FROM pushtopic WHERE name = 'shipment'];
        
        //If fails, was expecting a topic would be created after insert
        System.assertEquals(1, topics.size());
    }
    
    static testMethod void testTriggerCreatesOnlyOneNewPushTopic() {
        insertShipment();
        insertShipment();
        List<PushTopic> topics = [SELECT id FROM pushtopic WHERE name = 'shipment'];
        
        //If fails, was expecting just ONE topic would be created after insert
        System.assertEquals(1, topics.size());
    }
    
    
    static testMethod void testTriggerCreatesShipmentTopic() {
        insertShipment();
        PushTopic shipmentTopic = [SELECT id FROM pushtopic WHERE name = 'shipment'];
        
        //If fails, was expecting a topic would be created after insert
        System.assertNotEquals(null, shipmentTopic);
    }
    
    static testMethod void testTriggerDoesNotCreateTopicOverExisting() {
        PushTopic newTopic = new PushTopic();
        newTopic.name = 'shipment';
        newTopic.query = 'SELECT id, name FROM gwestr__Shipment__c';
        newTopic.apiversion = 23.0d;
        
        insert newTopic;
        
        //If fails, our test setup is wrong (topic should have made it in)
        PushTopic shipmentTopic = [SELECT id, query FROM pushtopic WHERE name = 'shipment'];
        System.assertNotEquals(null, shipmentTopic);
        
        insertShipment();
        
        PushTopic sameTopic = [SELECT id, query FROM pushtopic WHERE name = 'shipment'];
        
        //If fails, our topic was overwritten
        System.assertEquals(sameTopic.id, shipmentTopic.id);
        System.assertEquals(sameTopic.query, shipmentTopic.query);
    }
    
    private static String insertShipment() {
        Shipment__c shipment = new Shipment__c();  
          
        shipment.gwestr__ContactEmail__c = 'labs@salesforce.com';
        shipment.gwestr__Contact_Phone__c = '415-800-5555';
        shipment.gwestr__Insurance__c = 5000;
        shipment.gwestr__OverWeight__c = 0;
        shipment.gwestr__Rush__c = FALSE;
        shipment.gwestr__Scheduled_Delivery__c = Date.newInstance(2012, 11, 25);
        shipment.gwestr__Status__c = 'Shipped';
        shipment.gwestr__TrackingExtId__c = '1234567890qwertyuiop';
        shipment.gwestr__Tracking_URL__c = 'http://postalservice.fake';
        shipment.gwestr__Warnings__c = 'Heavy';
        shipment.gwestr__Weight__c = 250;
    
        insert shipment;
        
        return shipment.id;
    }
}