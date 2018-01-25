public with sharing class DayEventsFactory {
    private Map<Date, DayEvents> weekDays;
    private Date weekDate;
    private Id playerId;

    private DayEventsFactory(Id playerId) {
        this.playerId = playerId;
        weekDays = new Map<Date, DayEvents>();
    }

    public List<DayEvents> getDays(Date startDate) {
        setWeekDate(startDate);

        for (Volleyball_Event__c event : [SELECT Id, Date__c, Event_Type__c, Location__c, Time__c, Note__c,
                                (SELECT Id, Choice_Status__c FROM Player_Presences__r WHERE Player__c = :playerId)
                                          FROM Volleyball_Event__c
                                          WHERE Date__c >= :startDate
                                          AND Date__c <= :startDate.addDays(6)
                                          ORDER BY Date__c, Time__c]) {
            weekDays.get(event.Date__c).events.add(event);
        }

        return weekDays.values();
    }

    private void setWeekDate(Date startDate) {
        if (weekDate == null || weekDate != startDate) {
            weekDays.clear();
            for (Integer i=0; i<7; i++) {
                weekDays.put(startDate.addDays(i), new DayEvents(startDate.addDays(i)));
            }
            weekDate = startDate;
        } else {
            for (DayEvents day : weekDays.values()) {
                day.events.clear();
            }
        }
    }

    private static DayEventsFactory instance;
    public static DayEventsFactory getInstance(Id playerId) {
        if (instance == null || playerId != instance.playerId) {
            instance = new DayEventsFactory(playerId);
        }
        return instance;
    }
}