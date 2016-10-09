import React, { PropTypes } from 'react';
import { Map, Marker, Popup, TileLayer,Polyline } from 'react-leaflet';
import axios  from 'axios';
import polyUtil from 'polyline-encoded'
import ChartWidget from '../components/ChartWidget';

export default class LikeButton extends React.Component {
  static propTypes = {
      current_user:PropTypes.object,
    voted: PropTypes.boolean,
    votes: PropTypes.integer,
      meet_id:PropTypes.integer
  };

  constructor(props, context) {
    super(props, context);
      this.state = {
          current_user:this.props.current_user,
          voted:this.props.voted,
          votes:this.props.votes,
          meet_id:this.props.meet_id
      };

  }
  
  componentDidMount(){
       console.log("componentDidMount");
 }

    handleLike(){

        const csrfToken = ReactOnRails.authenticityToken();

        axios.get('/api/like/vote?meet_id='+this.state.current_user.id+'&meet_id='+ this.state.meet_id
            ,{headers: {'X-CSRF-Token': csrfToken}})
            .then((resp)=>{
                let votes = this.state.votes + 1;
                this.setState({voted:true,votes:votes});
            })
            .catch((err)=>{
                console.log(err)
            });
    }

    handleDisLike(){
        const csrfToken = ReactOnRails.authenticityToken();

        axios.get('/api/unlike/vote?meet_id='+this.state.current_user.id+'&meet_id='+ this.state.meet_id,
            {headers: {'X-CSRF-Token': csrfToken}})
            .then((resp)=>{
                let votes = this.state.votes - 1;
                this.setState({voted:false,votes:votes});
            })
            .catch((err)=>{
                console.log(err)
            });
    }

  render() {

      const {votes} = this.state;
      let btn="";
    if(!this.state.voted){
        btn = <button onClick={()=>this.handleLike()} className="btn btn-sm btn-success" >{votes} Like</button>
    }else{
        btn = <button onClick={()=>this.handleDisLike()} className="btn btn-sm btn-danger" >{votes} Unlike</button>
    }

    return (
      <div>
       {btn}
      </div>
    );
  }
}
