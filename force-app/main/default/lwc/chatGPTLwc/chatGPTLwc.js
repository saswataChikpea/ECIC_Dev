import { LightningElement,track } from 'lwc';
import makePostCallout from '@salesforce/apex/callChatGPT_API.makePostCalloutLWC'

export default class ChatGPTLwc extends LightningElement {
    showChat=false
    showChatButtton=true
    showReply=false
    
    @track messages = [
        { id: 1, content: 'Hi there!', sender: 'Chat GPT', timestamp: '' ,type: false},
      ];
    @track messageInput = '';

    renderedCallback() {
      this.scrollToBottom();
    }

    scrollToBottom() {
      const messagesDiv = this.template.querySelector('.chatbox-message-content');
      if (messagesDiv) {
        messagesDiv.scrollTop = messagesDiv.scrollHeight;
      }
    }

      handleChatNav(){
        console.log('handleChatNav clicked');
        this.showChat=true
        this.showChatButtton=false
    }

    handleClose(){
        this.showChat=false
        this.showChatButtton=true
    }
    handleFormSubmit(e){
        e.preventDefault()
    }
    
      handleInputChange(event) {
        this.messageInput = event.target.value;
      }
    
      handleSendMessage() {
        if (this.messageInput) {
          this.messages.push({
            id: this.messages.length + 1,
            content: this.messageInput,
            sender: 'User1',
            timestamp: new Date().toLocaleTimeString(),
            type : true
          });
          //calling apex
          makePostCallout({searchString : this.messageInput})
          .then((result)=>{
            this.messages.push({
                id: this.messages.length + 1,
                content: result,
                sender: 'Chat GPT',
                timestamp: new Date().toLocaleTimeString(),
                type : false
              });
              this.showReply=true
              console.log('result==',result);
          })
          .catch((err)=>{
            console.log('Error ->',err);
            this.messages.push({
              id: this.messages.length + 1,
              content: "Something went wrong",
              sender: 'Chat GPT',
              timestamp: new Date().toLocaleTimeString(),
              type : false
            });
          })
          this.messageInput = '';
        }
      }
}