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

    handleLeaveMeeting(toremove){

        console.log(toremove);

        const csrfToken = ReactOnRails.authenticityToken();
        axios.delete('/participations/'+toremove.id+'.json',{headers: {'X-CSRF-Token': csrfToken}})
            .then((resp)=>{
                console.log(resp.data);

                let partecipants = this.state.participations;
                partecipants.splice(partecipants.indexOf(toremove),1)
                ;
                this.setState({
                    participations:partecipants
                })
            })
            .catch((err)=>{
                console.log(err)
            });

    }

  render() {
        let signed = "";
        let button ="";
        let found=false;
        let toremove={};

        if(this.state.participations != null){
            signed  = this.state.participations.map((p)=>{

            return <li key={p.id} >{p.user.email}</li>
        });

        this.state.participations.forEach((a)=>{
               if(a.user.id == this.state.current_user.id){
                   found=true;
                   toremove= a;
               }
            });
        }

        if(found){
            button = <button onClick={()=>this.handleLeaveMeeting(toremove)}className="btn btn-danger">Signout!</button>

        }else{
            button = <button onClick={()=>this.handleJoinMeeting()}className="btn btn-success">Signup!</button>
        }




    return (
      <div>
        <h4>{this.state.participations.length} Signed people</h4>
        <ul>
          {signed}
        </ul>
        {button}
      </div>
    );
  }
}
