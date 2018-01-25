public class VolleyBallHomeController {
    public Id playerId {get; set;}
    public String playerName {get; set;}
    public List<Player__c> players;
    public String password {get; set;}

    public List<Player__c> getPlayers() {
        if(players == null) {
            players = [SELECT Id, Name FROM Player__c ORDER BY Name LIMIT 50];
        }
        return players;
    }

    public PageReference checkAuthorization() {
        if (ApexPages.currentPage().getCookies().get('playerId') == null
                || ApexPages.currentPage().getCookies().get('playerName') == null) {
            //No cookies - should pass authorization
            return null;
        }
        String playerId = (String)ApexPages.currentPage().getCookies().get('playerId').getValue();
        String playerName = (String)ApexPages.currentPage().getCookies().get('playerName').getValue();
        if (String.isNotBlank(playerId) && String.isNotBlank(playerName)) {
            Cookie pass = ApexPages.currentPage().getCookies().get('pass');
            return login(playerName, playerId, (pass == null) ? '' : (String)pass.getValue());
        }
        //User logged out - should pass authorization
        return null;
    }

    public PageReference login() {
        return login(playerName, playerId, password);
    }

    private PageReference login(String pName, String pId, String pass) {
        PageReference pg = Page.Calendar;
        Cookie playerName = new Cookie('playerName', pName, null, -1, false);
        Cookie playerId = new Cookie('playerId', pId, null, -1, false);
        Cookie passCookie = new Cookie('pass', pass, null, -1, false);
        pg.setCookies(new Cookie[] {playerId, playerName, passCookie});
        pg.setRedirect(true);
        return pg;
    }

    public PageReference logout() {
        PageReference pg = Page.VolleyballHome;
        Cookie playerId = new Cookie('playerId', '', null, -1, false);
        Cookie playerName = new Cookie('playerName', '', null, -1, false);
        Cookie pass = new Cookie('pass', '', null, -1, false);
        Cookie evtDate = new Cookie('date', '', null, -1, false);
        pg.setCookies(new Cookie[] {playerId, playerName, pass, evtDate});
        pg.setRedirect(true);
        return pg;
    }
}