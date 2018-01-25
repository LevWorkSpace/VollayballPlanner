public class DayEvents {
    public String dayName{get; set;}
    public List<Volleyball_Event__c> events{get; set;}
    private Date day;

    public DayEvents(Date dayDate) {
        day = dayDate;
        dayName = getDayName(dayDate);
        events = new List<Volleyball_Event__c> ();
    }

    public Boolean getToday() {
        return Date.today() == day;
    }

    private String getDayName(Date dayDate) {
        Datetime dt = DateTime.newInstance(dayDate, Time.newInstance(0, 0, 0, 0));
        String name = dt.format('EEEE') + ' - ' + dayDate.format();
        if (Date.today() == dayDate) {
            name += ' - TODAY';
        }
        return name;
    }
}