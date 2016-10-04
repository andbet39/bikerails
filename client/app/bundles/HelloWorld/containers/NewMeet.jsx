import React, { PropTypes } from 'react';
import { Map, Marker, Popup, TileLayer,Polyline } from 'react-leaflet';
import axios  from 'axios';
import Geosuggest from 'react-geosuggest';

export default class NewMeet extends React.Component {
  static propTypes = {

  };

  constructor(props, context) {
    super(props, context);
    this.state = { 
        start_position : [42.0,13.0],
        start_isset:false,
        init_position :[42.0,13.0]
    };
  }
  
  componentDidMount(){
       console.log("componentDidMount");

 }
  
    handleMapClick(e){
        console.log(e);
        this.setState({
            start_position:e.latlng,
            start_isset:true
        })
    }

    onSuggestSelect(e){
        console.log(e);
        this.setState({
            init_position:[e.location.lat,e.location.lng],
            start_position:e.location,
            start_isset:true
        })
    }

  render() {

      let position = this.state.init_position;
      let mapzoom = 12;
      let marker = "";
      if(this.state.start_isset){
           marker = <Marker position={this.state.start_position}>
                        <Popup>
                            <span>A pretty CSS3 popup.<br/>Easily customizable.</span>
                        </Popup>
                    </Marker>
      }

      if(this.state.start_isset){
          mapzoom=17
      }


    return (
      <div>
          <Geosuggest           onSuggestSelect={(e)=>this.onSuggestSelect(e)}/>

          <Map ref={(ref) => this.map = ref} center={position} zoom={mapzoom} onclick={(e)=>this.handleMapClick(e)}>
          <TileLayer
            url='https://api.mapbox.com/styles/v1/andbet39/cit8fipzr00422xoaofa3l9jd/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiYW5kYmV0MzkiLCJhIjoiWjdrTG56QSJ9.MgWMjnaY4NPHqq8iauqEVw'
            attribution='&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
          />
            {marker}

        </Map>

    </div>
    );
  }
}
