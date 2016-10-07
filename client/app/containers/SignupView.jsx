import React, { PropTypes } from 'react';

export default class TrackView extends React.Component {
  static propTypes = {
    current_user: PropTypes.object,
    meeting: PropTypes.object
  };

  constructor(props, context) {
    super(props, context);
    this.state = { 
      meeting: this.props.meeting,
      current_user:this.props.current_user
    };
    

  }
  
  componentDidMount(){
       console.log("componentDidMount");

 }

  render() {
    let signed = "";
    let button ="";
    if(this.state.meeting.participants != null){
      signed  = this.state.meeting.participants.map((p)=>{
        return <li>{p.user.email}</li>
      });
    }

    button = <button className="btn btn-success">Signup!</button>



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
