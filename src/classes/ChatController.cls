public class ChatController {
    public Chat_Message__c chatMessage {get ;set;}
    public List<Chat_Message__c> chatMessages {
        get {
            if(chatMessages == null) {
                retrieveMessages();
            }
            return chatMessages;
        }
        set;
    }
    public String playerName {get;set;}
    public Id eventId {get;set;}
    public Id playerId {get;set;}

    public void sendChatMessage() {
        chatMessage.Text__c = chatMessage.Text__c.replace('\n', '<br>');
        insert chatMessage;
        retrieveMessages();
    }

    private void retrieveMessages() {
        chatMessages = [SELECT Text__c, Player__r.Name, CreatedDate FROM Chat_Message__c
        WHERE Volleyball_Event__c = :eventId ORDER BY CreatedDate];
        chatMessage = new Chat_Message__c(Player__c = playerId, Volleyball_Event__c = eventId);
    }
}