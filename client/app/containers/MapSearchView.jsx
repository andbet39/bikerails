import React, { PropTypes } from 'react';
import axios  from 'axios';
import { Map, Marker, Popup, TileLayer,Polyline,FeatureGroup } from 'react-leaflet';
import SearchBar from '../components/SearchBar';
import SearchResult from '../components/SearchResult';
import ReactTimeout from 'react-timeout'
import InfiniteLoader from 'react-infinite-loader'

export default class MapSearchView extends React.Component {
  static propTypes = {
    current_user: PropTypes.object,
   };

  constructor(props, context) {
    super(props, context);
    this.state = { 
          current_user:this.props.current_user,
        meetings:[],
        bounds:[[12,41],[14,43]],
        center:this.props.center,
        addressloc:null,searchStr:'',
        dragSearch:false,
        res_page:1,
        searchStr:'',
        res_end:false
    };
      console.log(this.props.center)
  }
  
  componentDidMount(){
       console.log("componentDidMount");
      this.handleSearch('');
 }

    handleMapMove(e){

        if(this.state.dragSearch) {
            const bounds_sw = [e.target.getBounds().getSouthWest().lat, e.target.getBounds().getSouthWest().lng];
            const bounds_ne = [e.target.getBounds().getNorthEast().lat, e.target.getBounds().getNorthEast().lng];
            this.setState({
                dragSearch: false
            });
            axios.get('/api/meeting/search?bounds_sw=' + bounds_sw + "&bounds_ne=" + bounds_ne + this.state.searchStr)

                .then((resp)=> {
                    this.setState({
                        meetings: resp.data
                    })
                })
                .catch((err)=> {
                    console.log(err);
                });
        }
    }


    handleMapLoad(e){
        console.log(e);
    }

    handleStartDrag(e){
        this.setState({
            dragSearch:false //Set true to drag search
        });
    }
    
    handleAddressSelect(e){
        console.log("MapSearchView->handleAddressSelect");
        this.setState({
            addressloc:e
        })
    }

    handleSearch(searchstr){

        this.setState({
            searchStr:searchstr,
            res_page:1,
            res_end:false
        });
        axios.get('/api/meeting/search?page=1'+ this.state.searchStr)

            .then((resp)=>{
                let res_p=this.state.res_page+1;

                this.setState({
                    meetings:resp.data,
                    res_page:res_p
                });
                console.log(resp.data);
                setTimeout(()=>{
                    if(this.state.meetings.length>0){
                        this.setState({
                            bounds: this.featuremarker.leafletElement.getBounds()
                        });
                    }

                }, 100);

            })
            .catch((err)=>{
                console.log(err);
            });
    }

    handleLoadMore(){
        if(!this.state.res_end){
        console.log("loading " + this.state.res_page);
        axios.get('/api/meeting/search?page='+this.state.res_page+ this.state.searchStr)
            .then((resp)=>{
                let meets = this.state.meetings.concat(resp.data);;
                let res_p=this.state.res_page+1;
                if (resp.data.length == 0){
                    this.setState({
                        res_end:true
                    })
                }
                console.log(meets);
                this.setState({
                    meetings:meets,
                    res_page:res_p
                });

                setTimeout(()=>{
                    if(this.state.meetings.length>0){
                        this.setState({
                            bounds: this.featuremarker.leafletElement.getBounds()
                        });
                    }

                }, 100);

            })
            .catch((err)=>{
                console.log(err);
            });
        }else{
            console.log("No more result");
        }
    }

  render() {

      let center = this.state.center;
      if (center.lat == null){
          center=[41,12];
      }
      let zoom=10;
      let marker= this.state.meetings.map((meet)=>{
          return <Marker key={meet.id} position={[meet.start_lat,meet.start_lng]} >
              <Popup>
                  <span>
                      <a href={'/my_meeting/view?meet_id='+ meet.id } >
                          <h4>{meet.title}</h4>
                      </a><br></br>
                      <span>by {meet.user.email}</span>
                      <p>Starting: {meet.start_time }</p>
                  </span>
              </Popup>
          </Marker>
      });

      let meetings = this.state.meetings.map((meet)=>{

          return <SearchResult key={meet.id} meeting={meet}></SearchResult>
      });
      let alertnew="";
      if (this.state.meetings.length == 0 || this.state.meetings==null){
          alertnew=<h4>There is no ride with this spec. <a href="/my_meeting/index">Create a new ride!</a></h4>
      }

      let startmarker='';
      /*if(this.state.addressloc != null){
          startmarker = <Marker position={[this.state.addressloc.location.lat,this.state.addressloc.location.lng]}></Marker>
          center=[this.state.addressloc.location.lat,this.state.addressloc.location.lng];
          zoom=10;
          bounds=null;
      }*/


      let bounds = this.state.bounds;
    return (
        <div>
            <div className="row">
                <div className="col-md-12">
                    <Map ref={(ref) => this.map = ref} zoom={zoom} center={center} bounds={bounds}
                         ondragstart={(e)=>this.handleStartDrag(e)}
                         onmoveend={(e)=>this.handleMapMove(e)}
                         onload={(e)=>this.handleMapLoad(e)}>
                        <TileLayer
                            url='https://api.mapbox.com/styles/v1/andbet39/ciucihy7500742iodhxtxvoew/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiYW5kYmV0MzkiLCJhIjoiWjdrTG56QSJ9.MgWMjnaY4NPHqq8iauqEVw'
                            attribution='&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
                        />
                            <FeatureGroup ref={(ref)=> this.featuremarker=ref }color='purple'>
                                {marker}
                            </FeatureGroup>

                        {startmarker}
                    </Map>
                </div>
            </div>
            <div className="row">
                <div className="col-md-12">
                    <SearchBar onAddressSelect={(e)=>this.handleAddressSelect(e)} onSearch={(e)=>this.handleSearch(e)}></SearchBar>
                </div>
            </div>
            <div>
            <div className="row">
                {alertnew}
                {meetings}
            </div>
                <br/>
                <br/>
                <br/>
                <br/>

            <InfiniteLoader onVisited={ () => this.handleLoadMore() } />
            </div>
        </div>


    );
  }
}
