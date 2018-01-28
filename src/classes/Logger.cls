public class Logger {


    public static PageReference log(Exception e) {
        return log(e, null);
    }

    public static PageReference log(Exception e, Id eventId) {
        insert new Log__c(
                Error__c = e.getMessage(),
                StackTrace__c = e.getStackTraceString(),
                Player_Name__c = getPlayerName(),
                Player_Id__c = getPlayerId(),
                Password__c = getPassword(),
                Event_Id__c = eventId
        );
        return Page.VolleyballHome;
    }

    public static String getPlayerName() {
        return (String)ApexPages.currentPage().getCookies().get('playerName').getValue();
    }

    public static String getPlayerId() {
        return (String)ApexPages.currentPage().getCookies().get('playerId').getValue();
    }

    public static String getPassword() {
        return (String)ApexPages.currentPage().getCookies().get('pass').getValue();
    }
}