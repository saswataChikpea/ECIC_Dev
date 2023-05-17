import { LightningElement,track } from 'lwc';
import makePostCallout from '@salesforce/apex/callChatGPT_API.makePostCallout2'

export default class ChatSectionLwc extends LightningElement {
    @track messages = [
        { id: 1, content: 'Hi there!', sender: 'Chat GPT', timestamp: '' },
      ];
      @track messageInput = '';
    
      handleInputChange(event) {
        this.messageInput = event.target.value;
      }
    
      handleSendMessage() {
        if (this.messageInput) {
          this.messages.push({
            id: this.messages.length + 1,
            content: this.messageInput,
            sender: 'User1',
            timestamp: new Date().toLocaleTimeString()
          });
          //calling apex
          makePostCallout({searchString : this.messageInput})
          .then((result)=>{
            this.messages.push({
                id: this.messages.length + 1,
                content: result[0],
                sender: 'Chat GPT',
                timestamp: new Date().toLocaleTimeString()
              });
              console.log('result==',result);
          })
          this.messageInput = '';
        }
      }
}