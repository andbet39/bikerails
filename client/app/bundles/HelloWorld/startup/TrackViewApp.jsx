import React from 'react';
import ReactOnRails from 'react-on-rails';

import TrackView from '../containers/TrackView';

const TrackViewApp = (props) => (
  <TrackView {...props} />
);

ReactOnRails.register({ TrackViewApp });
