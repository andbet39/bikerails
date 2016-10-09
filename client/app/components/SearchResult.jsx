// HelloWorldWidget is an arbitrary name for any "dumb" component. We do not recommend suffixing
// all your dump component names with Widget.

import React, { PropTypes } from 'react';
import Select from 'react-select';
import axios  from 'axios';
import Geosuggest from 'react-geosuggest';
import Datetime from 'react-datetime';


export default class SearchResult extends React.Component {
  static propTypes = {
        meeting:PropTypes.object,
  };
    constructor(props, context) {
        super(props, context);
        this.state = {
            meeting:this.props.meeting
        };
    }

    componentDidMount(){

    }


  render() {
      let meet = this.state.meeting;
      return(

          <div className="col-md-6">
              <a href={'/my_meeting/view?meet_id='+ meet.id } ><h4>{meet.title}<small> by {meet.user.email}</small></h4></a>
              <p>Starting: {meet.start_time } People :{meet.participations.length}</p>
              <p>{meet.track.length} - Asc: {meet.track.ascention} - Des. {meet.track.descent}</p>
          </div>

      )
  }
}
