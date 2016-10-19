import React, { PropTypes } from 'react';
import { Map, Marker, Popup, TileLayer,Polyline } from 'react-leaflet';
import axios  from 'axios';
import polyUtil from 'polyline-encoded'
import ChartWidget from '../components/ChartWidget';

export default class TrackView extends React.Component {
  static propTypes = {
    track: PropTypes.object,
    points: PropTypes.array
  };

  constructor(props, context) {
    super(props, context);
    this.state = { 
      track: this.props.track,
      points:this.props.points,
      bounds:this.props.bounds,
    };
    if(this.props.points[0]){
      this.setState({
            position:[this.props.points[0].lng,this.props.points[0].lat]
          });
    }else{
      this.setState({
        position:[42,13]
      });
    }

        console.log(this.props.bounds);
  }
  
  componentDidMount(){
       console.log("componentDidMount");

 }

  render() {

    const lbound = [
      [this.state.bounds.max_lat, this.state.bounds.max_lon],
      [this.state.bounds.min_lat, this.state.bounds.min_lon]
    ];
    const {position} = this.state;
    let polyline=[];
    
    this.state.points.forEach((p)=>{
      polyline.push({lat: p.lat, lng:p.lng});
    });

    return (
      <div>
        <Map ref={(ref) => this.map = ref} bounds={lbound} >
          <TileLayer
            url='https://api.mapbox.com/styles/v1/andbet39/ciucihy7500742iodhxtxvoew/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiYW5kYmV0MzkiLCJhIjoiWjdrTG56QSJ9.MgWMjnaY4NPHqq8iauqEVw'
            attribution='&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
          />
  
          <Polyline ref={(ref) => this.refpline = ref } color='lime' positions={polyline} />

        </Map>
    </div>
    );
  }
}
