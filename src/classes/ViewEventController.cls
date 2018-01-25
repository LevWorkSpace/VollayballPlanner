public class ViewEventController {
    public List<Player_Presence__c> players {get;set;}
    public String playerName {get;set;}

    private Id eventId;
    private Volleyball_Event__c event;
    private Id playerId;
    private String password;

    public ViewEventController(ApexPages.StandardController sc) {
        event = (Volleyball_Event__c)sc.getRecord();
        playerId = (String)ApexPages.currentPage().getCookies().get('playerId').getValue();
        playerName = (String)ApexPages.currentPage().getCookies().get('playerName').getValue();
        players = [SELECT Player__r.Name, Is_Going__c FROM Player_Presence__c WHERE Event__c = :event.Id
                   ORDER BY Is_Going__c DESC, Player__r.Name];
        password = (String)ApexPages.currentPage().getCookies().get('pass').getValue();
    }

    public Boolean getIsAuthorized() {
        return password == Volleyball__c.getOrgDefaults().Password__c;
    }

    public PageReference toCalendar() {
        PageReference calendar = Page.Calendar;
        Cookie player = new Cookie('playerId', playerId, null, -1, false);
        Cookie pass = new Cookie('pass', password, null, -1, false);
        Cookie evtDate = new Cookie('date', String.valueOf(event.Date__c.toStartOfWeek()), null, -1, false);
        calendar.setCookies(new Cookie[] {player, pass, evtDate});
        return calendar;
    }

    public PageReference saveEvent() {
        update event;
        return toCalendar();
    }

    public PageReference deleteEvent() {
        delete new Volleyball_Event__c (Id = event.Id);
        return toCalendar();
    }

    public PageReference cloneEvent() {
        Volleyball_Event__c clone = event.clone();
        insert clone;
        return redirectToEvent(clone.Id, true);
    }

    public PageReference addMessage() {
        if (ApexPages.currentPage().getParameters().get('clone') != null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Cloned successfully!'));
        }
        return null;
    }

    private PageReference redirectToEvent(Id eventId, Boolean clone) {
        PageReference pg = Page.ViewEvent;
        Cookie player = new Cookie('playerId', playerId, null, -1, false);
        Cookie pass = new Cookie('pass', password, null, -1, false);
        pg.setCookies(new Cookie[] {player, pass});
        pg.getParameters().put('id', eventId);
        pg.setRedirect(true);
        if (clone) {
            pg.getParameters().put('clone', '1');
        }
        return pg;
    }
}