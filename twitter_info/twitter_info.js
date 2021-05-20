import { LightningElement ,track,api} from 'lwc';
import getTweet from "@salesforce/apex/TwitterIntegration.getTweet";

export default class Twitter_info extends LightningElement {

    @track cardTitle = 'Get your tweet here with just Id !! Hurray';
    @track tweetId;
    tweetObj ={} ;
    @track tweetDesc;

    changeHandler(event){
        this.tweetId = event.target.value;
    }

    handleClick(event){ 
        console.log('hand');
        getTweet({
            tweetid : this.tweetId
        }).then((result) => {
            console.log('result=>'+result);
           this.tweetObj = JSON.parse(result);
           console.log('Text => '+ this.tweetObj.data.text); 
           this.tweetDesc =  this.tweetObj.data.text;
        }).catch((error) => {
            this.tweetid = error;
        });

    }
}