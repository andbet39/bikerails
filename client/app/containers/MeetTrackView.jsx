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
      segments:[],
      position:[this.props.points[0].lng,this.props.points[0].lat],
      bounds:this.props.bounds,
      selectedSeg:null
    };
    
    console.log(this.props.bounds);
  }
  
  componentDidMount(){
       console.log("componentDidMount");
       
    axios.get('/api/strava_segment/getForTrack',{
        params: {
          id: this.state.track.id
        }
      })
    .then( (response)=> {
      console.log(response);
      this.setState({
        segments:response.data
      });
      
  
    })
    .catch((error) =>{
      console.log(error);
    });
 }
    
    
  
  
  
  handleClick(e)
  {
    this.setState({
      selectedSeg:e.target.options.segment
    });
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
   
    let segpline="";
    
    if(this.state.selectedSeg !=null){
      
      segpline = <Polyline  color='red' positions={polyUtil.decode(this.state.selectedSeg.points)} />
    }
    
    let seg = this.state.segments.map((s)=>{
      
       
      return <Marker key={s.id} onClick={(e)=>this.handleClick(e)} position={s.start_latlng} segment={s}  >
                <Popup>
                  <span>{s.name}</span>
                </Popup>
             </Marker>
    });
  
    return (
      <div>
        <Map ref={(ref) => this.map = ref} bounds={lbound} >
          <TileLayer
            url='https://api.mapbox.com/styles/v1/andbet39/cit8fipzr00422xoaofa3l9jd/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiYW5kYmV0MzkiLCJhIjoiWjdrTG56QSJ9.MgWMjnaY4NPHqq8iauqEVw'
            attribution='&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
          />
  
          <Polyline ref={(ref) => this.refpline = ref } color='red' positions={polyline} />
           {seg}
           {segpline}
        
        </Map>
        <ChartWidget points={this.state.points} ></ChartWidget>
    </div>
    );
  }
}
