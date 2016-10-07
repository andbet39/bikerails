import React, { PropTypes } from 'react';
import axios  from 'axios';


export default class SignupView extends React.Component {
  static propTypes = {
    current_user: PropTypes.object,
    meeting: PropTypes.object,
      participations:PropTypes.array
  };

  constructor(props, context) {
    super(props, context);
    this.state = { 
        meeting: this.props.meeting,
        current_user:this.props.current_user,
        participations:this.props.participations
    };
  }
  
  componentDidMount(){
       console.log("componentDidMount");

 }

  handleJoinMeeting(){
    const part = {
        user_id:this.state.current_user.id,
        meeting_id:this.state.meeting.id
    }

      const csrfToken = ReactOnRails.authenticityToken();
      axios.post('/participations.json',part,{headers: {'X-CSRF-Token': csrfToken}})
          .then((resp)=>{
              console.log(resp.data);
              let partecipants = this.state.participations;
              partecipants.push(resp.data);
              this.setState({
                  participations:partecipants
              })
          })
          .catch((err)=>{
              console.log(err)
          });

  }

    handleLeaveMeeting(){


    }

  render() {
        let signed = "";
        let button ="";
        let found=false;

        if(this.state.participations != null){
            signed  = this.state.participations.map((p)=>{

            return <li>{p.user.email}</li>
        });

        this.state.participations.forEach((a)=>{
               if(a.user.id == this.state.current_user.id){
                   found=true;
               }
            });
        }

        if(found){
            button = <button onClick={()=>this.handleLeaveMeeting()}className="btn btn-danger">Signout!</button>

        }else{
            button = <button onClick={()=>this.handleJoinMeeting()}className="btn btn-success">Signup!</button>
        }




    return (
      <div>
        <h4>Signed people</h4>
        <ul>
          {signed}
        </ul>
        {button}
      </div>
    );
  }
}
