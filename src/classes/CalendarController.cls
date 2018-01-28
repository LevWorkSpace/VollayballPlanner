public class CalendarController {
    public List<DayEvents> days { get; set; }
    public Date startOfWeekDate { get; set; }
    public Id playerId { get; set; }
    public String playerName { get; set; }
    private String password;

    public Id cancelChoice { get; set; }
    public Id eventChoiceId { get; set; }
    public String eventChoiceResult { get; set; }

    public CalendarController() {
        try {
            if (startOfWeekDate == null && ApexPages.currentPage().getCookies().get('date') != null
                    && String.isNotBlank(ApexPages.currentPage().getCookies().get('date').getValue())) {
                startOfWeekDate = Date.valueOf(ApexPages.currentPage().getCookies().get('date').getValue());
            } else {
                startOfWeekDate = Date.today().toStartOfWeek();
            }
            playerId = (String) ApexPages.currentPage().getCookies().get('playerId').getValue();
            playerName = (String) ApexPages.currentPage().getCookies().get('playerName').getValue();
            password = (String) ApexPages.currentPage().getCookies().get('pass').getValue();

            initWeek();
        } catch (Exception e) {
            Logger.log(e);
        }
    }

    public PageReference generateTrainings() {
        try {
            Time defaultTime = Volleyball__c.getOrgDefaults().Default_Time__c.time();
            insert new Volleyball_Event__c[]{
                    new Volleyball_Event__c(
                            Location__c = Volleyball__c.getOrgDefaults().Default_Location__c,
                            Time__c = defaultTime,
                            Event_Type__c = 'Training',
                            Date__c = startOfWeekDate
                    ),
                    new Volleyball_Event__c(
                            Location__c = Volleyball__c.getOrgDefaults().Default_Location__c,
                            Time__c = defaultTime,
                            Event_Type__c = 'Training',
                            Date__c = startOfWeekDate.addDays(4)
                    )
            };
            initWeek();
            return null;
        } catch (Exception e) {
            return Logger.log(e);
        }
    }

    public PageReference deleteEvent() {
        try {
            delete new Volleyball_Event__c(Id = eventChoiceId);
            return null;
        } catch (Exception e) {
            return Logger.log(e);
        }
    }

    public Boolean getIsAuthorized() {
        return password == Volleyball__c.getOrgDefaults().Password__c;
    }

    public PageReference nextWeek() {
        try {
            startOfWeekDate = startOfWeekDate.addDays(7);
            initWeek();
            return null;
        } catch (Exception e) {
            return Logger.log(e);
        }
    }

    public PageReference prevWeek() {
        try {
            startOfWeekDate = startOfWeekDate.addDays(-7);
            initWeek();
            return null;
        } catch (Exception e) {
            return Logger.log(e);
        }
    }

    public PageReference currentWeek() {
        try {
            startOfWeekDate = Date.today().toStartOfWeek();
            initWeek();
            return null;
        } catch (Exception e) {
            return Logger.log(e);
        }
    }

    public PageReference viewEvent() {
        try {
            PageReference pg = Page.ViewEvent;
            pg.getParameters().put('Id', eventChoiceId);
            Cookie playerId = new Cookie('playerId', playerId, null, -1, false);
            Cookie playerName = new Cookie('playerName', playerName, null, -1, false);
            Cookie pass = new Cookie('pass', password, null, -1, false);
            pg.setCookies(new Cookie[]{
                    playerId, playerName, pass
            });
            pg.setRedirect(true);
            return pg;
        } catch (Exception e) {
            return Logger.log(e);
        }
    }

    public PageReference cancelChoice() {
        try {
            delete new Player_Presence__c(Id = cancelChoice);
            return null;
        } catch (Exception e) {
            return Logger.log(e);
        }
    }

    public PageReference makeChoice() {
        try {
            insert new Player_Presence__c(Player__c = playerId,
                    Event__c = eventChoiceId,
                    Choice_Status__c = eventChoiceResult);
            return null;
        } catch (Exception e) {
            return Logger.log(e);
        }
    }

    private void initWeek() {
        PageReference calendar = ApexPages.currentPage();
        Cookie evtDate = new Cookie('date', String.valueOf(startOfWeekDate), null, -1, false);
        calendar.setCookies(new Cookie[]{
                evtDate
        });
        days = DayEventsFactory.getInstance(playerId).getDays(startOfWeekDate);
    }
}