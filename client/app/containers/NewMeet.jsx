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
import TinyMCE from 'react-tinymce';
import SweetAlert from 'react-swal';

// Be sure to include styles at some point, probably during your bootstrapping
import 'react-select/dist/react-select.css';
import 'sweetalert/dist/sweetalert.css';

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
        ride_type:null,
        start_date:null,
        description:"",
        successopen:false,
        enableOk:false,
        swal_message:"Uploading your meeting track...",
        swal_title:"Uploading...",
        meet_id:null
    };
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

    handleChangeStart(newdate){
        this.setState({
           start_date: newdate
        });
    }

    handleSave(e){

        console.log("Handle Save");


        let err="";
        if(this.state.ride_type == null)
            err+=<li>Ride Type must be set</li>;
        if(this.state.ride_level == null)
            err+=<li>Ride level must be set</li>;
        if(this.title.value == "")
            err+=<li>Title must be set</li>;
        if(this.state.start_date == null)
            err+=<li>Start date must be set</li>;

        if(err == ""){
            this.setState({
                error:"",
                successopen:true,
                swal_message:"Uploading your meeting track...",
                swal_title:"Uploading..."
            });
            const newmeet = {
                title: this.title.value,
                description:this.state.description,
                start_lat:this.state.start_position.lat,
                start_lng:this.state.start_position.lng,
                ride_type_id:this.state.ride_type.value,
                ride_level_id:this.state.ride_level.value,
                duration:this.duration.value,
                start_time:this.state.start_date.format("YYYY-MM-DD HH:mm:ss"),
                track_id:null
            };

            const csrfToken = ReactOnRails.authenticityToken();
            var data = new FormData();
            data.append('file', this.state.file);

            var config = {
                onUploadProgress: (progressEvent) =>{
                    var percentCompleted = progressEvent.loaded / progressEvent.total;
                    console.log(percentCompleted);
                },
                headers: {'X-CSRF-Token': csrfToken}
            };

            axios.post('/api/track/import.json',data,config)
                .then((resp)=>{

                    newmeet.track_id=resp.data.track.id;

                    axios.post('/meetings.json',newmeet,{headers: {'X-CSRF-Token': csrfToken}})
                        .then((resp)=>{
                            console.log(resp.data);
                            this.setState({
                                enableOk:true,
                                swal_message:"Your meeting is ready!",
                                swal_title:"Saved!",
                                meet_id:resp.data.id
                            });
                        })
                        .catch((err)=>{
                            console.log(err);
                            this.setState({
                                enableOk:true,
                                swal_message:"There was some errors... Retry!",
                                swal_title:"Error!"
                            })
                        });
                })
                .catch((err)=>{
                    console.log(err)
                })
        }else{
            this.setState({
                error:err
            });
        }
    }
    handleEditorChange(e    ){
        this.setState({
            description:e.target.getContent()
        })
    }
    handleSuccess(){
        this.setState(
            {successopen:false}
        );
        window.location.href= "/my_meeting/view?meet_id="+this.state.meet_id;
    }

    handleTest(){
        this.setState({
            error:"",
            successopen:true
        });
        setTimeout(()=>{
            this.setState({
                enableOk:true,
                swal_message:"Your meeting is ready!",
                swal_title:"Saved!"
            });
        },1000)
    }

  render() {

      let position = this.state.init_position;
      let mapzoom = 12;
      let marker = "";
      let polyline=[];
      let pline="";
      let err="";

      let geojsonlayer = "";
      let bounds  = this.state.bounds;
      
      let ride_level_options = [];
      this.props.ride_level.forEach((l)=>{
         ride_level_options.push({value:l.id, label:l.name});
      });
      
      let ride_type_options =[];
      this.props.ride_type.forEach((l)=>{
         ride_type_options.push({value:l.id, label:l.name});
      });
      
      const { geojson } = this.state;

      if(this.state.error != "" && this.state.error !=null){
          err= <div>There is some errors</div>
      }
      
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
                    <div>Drag a GPX file here</div>
                </Dropzone>
      }else{
          dropzone =<div>{ this.state.file.name }  <button className="btn btn-sm btn-danger" onClick={()=>this.resetTrack()}>Reset</button></div>;
      }

  
      if(this.state.start_isset){
          mapzoom=17;
      }


    return (
      <div>
          <h2>New Ride</h2>
          <div className="row">
            <div className="col-md-12">
                <Map ref={(ref) => this.map = ref} center={position} zoom={mapzoom} bounds={bounds} onclick={(e)=>this.handleMapClick(e)}>
                    <TileLayer
                    url='https://api.mapbox.com/styles/v1/andbet39/ciucihy7500742iodhxtxvoew/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiYW5kYmV0MzkiLCJhIjoiWjdrTG56QSJ9.MgWMjnaY4NPHqq8iauqEVw'
                    attribution='&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
                    />
                    {marker}
                    {geojsonlayer}
                </Map>
            </div>
          </div>

              <div className="row">
                  <div className="form-group col-md-6">
                      <label >Title</label>
                      <input ref={(ref) => this.title = ref} type="text" className="form-control" id="title" placeholder="Ride Title"/>
                  </div>
                  <div className="form-group col-md-3">
                      <label >Start address</label>
                      <Geosuggest  inputClassName="form-control" className="mysuggest" id="address" placeholder={"Search address or click on the map"} onSuggestSelect={(e)=>this.onSuggestSelect(e)}/>
                  </div>
                  <div className="form-group col-md-3">
                      <label >Start Date</label>
                      <Datetime ref={(ref) => this.start = ref}  onChange={(e)=>this.handleChangeStart(e)} dateFormat={"D-M-Y"} />
                  </div>
              </div>

                <div className="row">   
                  <div className="form-group col-md-4">
                      <label >Duration</label>
                      <input ref={(ref) => this.duration = ref}  type="text" className="form-control" id="title" placeholder="Ride duration"/>
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
                      <TinyMCE
                          content="<p>A brief description of the ride</p>"
                          config={{
                              plugins: 'link',
                              toolbar: 'undo redo | bold italic | alignleft aligncenter alignright | code'
                          }}
                          onChange={(e)=>this.handleEditorChange(e)}
                      />
                  </div>
                  <div className="form-group col-md-4">
                    <label >GPX Track</label>
                    {dropzone}
                   </div>
              </div>
              
              
              <div className="row">
                <div className="col-md-12">
                    {err}
                    <button onClick={(e)=>this.handleSave(e)} className="btn btn-success">Save</button>
                    <button onClick={(e)=>this.handleTest(e)} className="btn btn-success">Test</button>
                </div>
              </div>

          <SweetAlert isOpen={this.state.successopen}
                      type="success"
                      showCancelButton={false}
                      showConfirmButton={this.state.enableOk}
                      title={this.state.swal_title}
                      text={this.state.swal_message}
                      confirmButtonText="Ok"
                      callback={()=>this.handleSuccess()} />
    </div>
    );
  }
}
