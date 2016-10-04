// HelloWorldWidget is an arbitrary name for any "dumb" component. We do not recommend suffixing
// all your dump component names with Widget.

import React, { PropTypes } from 'react';
import {LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, Legend} from 'recharts';
export default class ChartWidget extends React.Component {
  static propTypes = {
    points: PropTypes.array.isRequired,
  };
    

  render() {

        
    const {points } = this.props;
    
      return(
          <div>
            <LineChart width={1000} height={300} data={points}
            margin={{top: 5, right: 30, left: 20, bottom: 5}}>
       <XAxis dataKey="distance"/>
       <YAxis />
       <CartesianGrid strokeDasharray="5000 100"/>
       <Line type="monotone" dataKey="elevation" stroke="#8884d8" dot={false} />
      </LineChart>      
        
      </div>
      )
  }
}
