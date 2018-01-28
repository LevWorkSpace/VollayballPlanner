public class ViewEventController {
    public List<Player_Presence__c> players { get; set; }
    public String playerName { get; set; }
    public Volleyball_Event__c event { get; set; }
    public Id playerId { get; set; }

    private String password;

    public ViewEventController(ApexPages.StandardController sc) {
        try {
            event = (Volleyball_Event__c) sc.getRecord();
            playerId = Logger.getPlayerId();
            playerName = Logger.getPlayerName();
            players = [
                    SELECT Player__r.Name, Is_Going__c
                    FROM Player_Presence__c
                    WHERE Event__c = :event.Id
                    ORDER BY Is_Going__c DESC, Player__r.Name
            ];
            password = Logger.getPassword();
        } catch (Exception e) {
            Logger.log(e, event.Id);
        }
    }

    public Boolean getIsAuthorized() {
        return password == Volleyball__c.getOrgDefaults().Password__c;
    }

    public PageReference toCalendar() {
        try {
            PageReference calendar = Page.Calendar;
            Cookie player = new Cookie('playerId', playerId, null, -1, false);
            Cookie pass = new Cookie('pass', password, null, -1, false);
            Cookie evtDate = new Cookie('date', String.valueOf(event.Date__c.toStartOfWeek()), null, -1, false);
            calendar.setCookies(new Cookie[]{
                    player, pass, evtDate
            });
            return calendar;
        } catch (Exception e) {
            return Logger.log(e, event.Id);
        }
    }

    public PageReference saveEvent() {
        try {
            update event;
            return toCalendar();
        } catch (Exception e) {
            return Logger.log(e, event.Id);
        }
    }

    public PageReference deleteEvent() {
        try {
            delete new Volleyball_Event__c(Id = event.Id);
            return toCalendar();
        } catch (Exception e) {
            return Logger.log(e, event.Id);
        }
    }

    public PageReference cloneEvent() {
        try {
            Volleyball_Event__c clone = event.clone();
            insert clone;
            return redirectToEvent(clone.Id, true);
        } catch (Exception e) {
            return Logger.log(e, event.Id);
        }
    }

    public PageReference addMessage() {
        try {
            if (ApexPages.currentPage().getParameters().get('clone') != null) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Cloned successfully!'));
            }
            return null;
        } catch (Exception e) {
            return Logger.log(e, event.Id);
        }
    }

    private PageReference redirectToEvent(Id eventId, Boolean clone) {
        try {
            PageReference pg = Page.ViewEvent;
            Cookie player = new Cookie('playerId', playerId, null, -1, false);
            Cookie pass = new Cookie('pass', password, null, -1, false);
            pg.setCookies(new Cookie[]{
                    player, pass
            });
            pg.getParameters().put('id', eventId);
            pg.setRedirect(true);
            if (clone) {
                pg.getParameters().put('clone', '1');
            }
            return pg;
        } catch (Exception e) {
            return Logger.log(e, event.Id);
        }
    }
}