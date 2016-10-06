import React, { PropTypes } from 'react';
import { Map, Marker, Popup, TileLayer,Polyline ,GeoJson} from 'react-leaflet';
import axios  from 'axios';
import Geosuggest from 'react-geosuggest';
import Datetime from 'react-datetime';
import Dropzone from 'react-dropzone';
import ReactOnRails from 'react-on-rails';
import request from 'superagent';
import toGeoJSON from 'togeojson';
import Select from 'react-select';

// Be sure to include styles at some point, probably during your bootstrapping
import 'react-select/dist/react-select.css';

var bbox = require('geojson-bbox');

export default class NewMeet extends React.Component {
  static propTypes = {

  };

  constructor(props, context) {
    super(props, context);
    this.state = { 
        start_position : [42.0,13.0],
        start_isset:false,
        init_position :[42.0,13.0],
        track:null,
        track_loading:false,
        bounds:[[41.0,10.0],[42.0,13.0]],
        file:null,
        ride_level:null,
        ride_type:null
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
    
    resetTrack(){
        this.setState({
                geojson:null
            });
    }
    
    onDrop(files){
        
        console.log("onDrop");
        var reader = new FileReader();
    
        reader.onload = (e)=>{
            let result = new DOMParser().parseFromString(e.target.result, 'text/xml');
            var geojson = toGeoJSON.gpx(result);
    
            var b = bbox(geojson);
            console.log(b);
            this.setState({
                geojson:geojson,
                bounds:[ [ b[1], b[0] ],[ b[3], b[2] ]]
            });
            
        };
        
        reader.readAsText(files[0]);
        this.setState({
            file:files[0]
        });
        console.log(files[0]);
          
    }
    
    ride_type_change(e){
        console.log(e);
        this.setState({
            ride_type: e
        });
    }
    
     ride_level_change(e){
        console.log(e);
        this.setState({
            ride_level: e
        });
    }
    

  render() {

      let position = this.state.init_position;
      let mapzoom = 12;
      let marker = "";
      let polyline=[];
      let pline="";

      let geojsonlayer = "";
      let bounds  = this.state.bounds;
      
      let ride_level_options = [];
      this.props.ride_level.forEach((l)=>{
         ride_level_options.push({value:l.val, label:l.name});
      });
      
      let ride_type_options =[];
      this.props.ride_type.forEach((l)=>{
         ride_type_options.push({value:l.val, label:l.name});
      });
      
      const { geojson } = this.state;
      
      if(geojson != null){
        geojsonlayer = <GeoJson data={geojson} ></GeoJson>
      }
      
      if(this.state.start_isset){
           marker = <Marker position={this.state.start_position}>
                        <Popup>
                            <span>Ride meet point</span>
                        </Popup>
                    </Marker>
      }
      
      let dropzone =""; 
      if(!this.state.geojson){
        dropzone = <Dropzone ref={(node) => { this.dropzone = node; }} onDrop={(files)=>{this.onDrop(files)}}>
                    <div>DRag a GPX file here</div>
                </Dropzone>
      }else{
          dropzone =<div>{ this.state.file.name }  <button className="btn btn-sm btn-danger" onClick={()=>this.resetTrack()}>Reset</button></div>;
      }

  
      if(this.state.start_isset){
          mapzoom=17
      }


    return (
      <div>
          <h2>New Ride Information</h2>
          <div className="row">
            <div className="col-md-12">
                <Map ref={(ref) => this.map = ref} center={position} zoom={mapzoom} bounds={bounds} onclick={(e)=>this.handleMapClick(e)}>
                    <TileLayer
                    url='https://api.mapbox.com/styles/v1/andbet39/cit8fipzr00422xoaofa3l9jd/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiYW5kYmV0MzkiLCJhIjoiWjdrTG56QSJ9.MgWMjnaY4NPHqq8iauqEVw'
                    attribution='&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
                    />
                    {marker}
                    {geojsonlayer}
                </Map>
            </div>
          </div>
          <form>
              <div className="row">
                  <div className="form-group col-md-6">
                      <label >Title</label>
                      <input type="text" className="form-control" id="title" placeholder="Ride Title"/>
                  </div>
                  <div className="form-group col-md-3">
                      <label >Start address</label>
                      <Geosuggest  inputClassName="form-control" className="mysuggest" id="address" placeholder={"Search address or click on the map"} onSuggestSelect={(e)=>this.onSuggestSelect(e)}/>
                  </div>
                  <div className="form-group col-md-3">
                      <label >Start Date</label>
                      <Datetime dateFormat={"D-M-Y"} />
                  </div>
              </div>

                <div className="row">   
                  <div className="form-group col-md-4">
                      <label >Duration</label>
                      <input type="text" className="form-control" id="title" placeholder="Ride duration"/>
                  </div>
                  <div className="form-group col-md-4">
                      <label>Type</label>
                     <Select
                            name="ride_type"
                            value={this.state.ride_type}
                            options={ride_type_options}
                            onChange={(e)=>this.ride_type_change(e)}
                        />
                  </div>
                  <div className="form-group col-md-4">
                      <label >Level</label>
                      <Select
                            name="ride_level"
                            value={this.state.ride_level}
                            options={ride_level_options}
                            onChange={(e)=>this.ride_level_change(e)}
                        />
                  </div>
              </div>

              <div className="row">
                  <div className="form-group col-md-8">
                      <label >Description</label>
                      <textarea className="form-control" id="title" placeholder="Ride Description"/>
                  </div>
                  <div className="form-group col-md-4">
                    <label >GPX Track</label>
                    {dropzone}
                   </div>
              </div>
              
              
              <div className="row">
                <div className="col-md-12">
                    <button className="btn btn-success">Save</button>
                </div>
              </div>


          </form>

         


    </div>
    );
  }
}
