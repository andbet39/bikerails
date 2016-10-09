// HelloWorldWidget is an arbitrary name for any "dumb" component. We do not recommend suffixing
// all your dump component names with Widget.

import React, { PropTypes } from 'react';
import Select from 'react-select';
import axios  from 'axios';
import Geosuggest from 'react-geosuggest';
import Datetime from 'react-datetime';


export default class SearchBar extends React.Component {
  static propTypes = {
        onAddressSelect:PropTypes.function,
        onSearch:PropTypes.function
  };
    constructor(props, context) {
        super(props, context);
        this.state = {
            ride_types:[],
            selectedType:null,
            ride_levels:[],
            selectedLevel:null,
            selectedStart:null,
            selectedAddress:null
        };
    }


    handleRideTypeChange(e){
        this.setState({
            selectedType:e
        })
    }
    handleRideLevelChange(e){
        this.setState({
            selectedLevel:e
        })
    }
    handleChangeStart(e){
        this.setState({
            selectedStart:e
        });
    }
    handleSuggestSelect(e){
        this.setState({
            selectedAddress:e
        });
        this.props.onAddressSelect(e);
    }

    handleSearch(e){
        e.preventDefault();
        let searchStr="";

        if(this.state.selectedStart != null && this.state.selectedStart !=''){
            searchStr+="&startdate="+this.state.selectedStart.format("YYYY-MM-DD");
        }

        if(this.state.selectedLevel != null ){
            searchStr+="&ride_level="+this.state.selectedLevel.value;
        }

        if(this.state.selectedType != null ){
            searchStr+="&ride_type="+this.state.selectedType.value;
        }
        if(this.state.selectedAddress != null){
            searchStr+="&origin_lat="+this.state.selectedAddress.location.lat+"&origin_lng="+this.state.selectedAddress.location.lng
        }

        console.log(searchStr);
        this.props.onSearch(searchStr);

    }
    componentDidMount(){

        axios(`/ride_types.json`)
            .then((response) => {
                let ride_type_options=[];
                response.data.forEach((l)=>{
                    console.log(l);
                    ride_type_options.push({value:l.id, label:l.name});
                });
                this.setState({
                    ride_types:ride_type_options
                });
            })
            .catch((err)=>{
               console.log(err);
            });

        axios(`/ride_levels.json`)
            .then((response) => {
                let ride_levels_options=[];
                response.data.forEach((l)=>{
                    console.log(l);
                    ride_levels_options.push({value:l.id, label:l.name});
                });
                this.setState({
                    ride_levels:ride_levels_options
                });
            })
            .catch((err)=>{
                console.log(err);
            });
    }

    getOptions(input){
        return
    }

  render() {
    const {points } = this.props;
    
      return(
          <div>
              <form  className="form-inline">
                  <div className="row">
                      <div className="form-group col-md-2">
                          <Datetime placeholder="Start date" ref={(ref) => this.start = ref}  onChange={(e)=>this.handleChangeStart(e)} dateFormat={"D-M-Y"} />
                      </div>
                      <div className="form-group col-md-3">
                          <Geosuggest  inputClassName="form-control" className="mysuggest" id="address" placeholder={"Search address"} onSuggestSelect={(e)=>this.handleSuggestSelect(e)}/>
                      </div>
                      <div className="form-group col-md-2">
                          <Select
                              name="ride_type"
                              value={this.state.selectedType}
                              options={this.state.ride_types}
                              onChange={(e)=>this.handleRideTypeChange(e)}
                          />
                      </div>
                      <div className="form-group col-md-2">
                          <Select
                              name="ride_level"
                              value={this.state.selectedLevel}
                              options={this.state.ride_levels}
                              onChange={(e)=>this.handleRideLevelChange(e)}
                          />
                      </div>
                      <div className="form-group col-md-3">
                          <button onClick={(e)=>this.handleSearch(e)} className="btn btn-success">Search</button>
                      </div>
                  </div>

              </form>

          </div>
      )
  }
}
