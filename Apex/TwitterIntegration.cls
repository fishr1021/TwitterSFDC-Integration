public without sharing class TwitterIntegration {

    public  Static String retrieveAccessToken(){
       
        String API_Key=EncodingUtil.urlEncode(Twitter_API_Settings__c.getInstance( 'API Key' ).value__c, 'UTF-8');
        String API_Secret_Key=EncodingUtil.urlEncode(Twitter_API_Settings__c.getInstance( 'API Secret Key' ).value__c, 'UTF-8');      
        
		String Consumer_API_key=API_Key + ':' + API_Secret_Key;
        
		Blob httpRequestHeader=Blob.valueOf(Consumer_API_key);
        System.debug('Twitter HeaderBlob ' + httpRequestHeader);        
        
		HttpRequest req=new HttpRequest();
        req.setEndpoint('https://api.twitter.com/oauth2/token');
        req.setMethod('POST');        
        
		string basicAuthorizationHeader='Basic ' + EncodingUtil.base64Encode(httpRequestHeader);
        req.setHeader('Authorization',basicAuthorizationHeader);
        req.setBody('grant_type=client_credentials');        
        System.debug('Twitter Http request ' + req);        
        
		Http http=new Http();        
        HttpResponse res=http.send(req);
        String accessToken;        
        if(res.getStatusCode()==200)
        {
            JSONParser parser=JSON.createParser(res.getBody());
            System.debug('Twitter JSON response ' + parser);
            while(parser.nextToken()!=null)
            {
                if(parser.getCurrentToken()==JSONToken.FIELD_NAME && parser.getText() == 'access_token')
                {
                    parser.nextToken();
                    accessToken=parser.getText();
                }
            }
        }
        System.debug('Twitter accessToken ' + accessToken); 
        return accessToken;
    }
    
    
    
    public static String  getTwitterInfo(string twitterId)
    {
        HttpRequest req=new HttpRequest();
        req.setEndpoint(' https://api.twitter.com/2/tweets/'+twitterId);
        req.setMethod('GET');
        String bearerAuthorizationHeader='Bearer '  + retrieveAccessToken();
        req.setHeader('Authorization',bearerAuthorizationHeader);
        
        Http http=new Http();
        System.debug('Twitter Request :- ' + req);
        HttpResponse res=http.send(req);
        if(res.getStatusCode()!=200)
        {
            System.debug('Twitter Response :- ' + res.getBody());
            return null;
        }
        String sBody=res.getBody();
        return sBody;
        
    }

    @AuraEnabled
    public static String getTweet(String tweetid){
        try{

           String tweetObj = TwitterIntegration.getTwitterInfo(tweetid);  
           return  tweetObj;
        }catch(Exception e){
            throw new AuraException(e.getMessage());
        }
    }

}