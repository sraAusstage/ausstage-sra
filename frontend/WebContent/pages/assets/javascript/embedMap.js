/*
 * This file is part of the AusStage Mapping Service
 *
 * The AusStage Mapping Service is free software: you can redistribute
 * it and/or modify it under the terms of the GNU General Public License 
 * as published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * The AusStage Mapping Service is distributed in the hope that it will 
 * be useful, but WITHOUT ANY WARRANTY; without even the implied warranty 
 * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * This file contains all of the specific javascript required to embed an ausstage map into an external site.
 ***/
 


	var EMBEDED_BASE_URL = 'https://www.ausstage.edu.au/opencms/'
	var UPDATE_DELAY = 500;
	/**Common stuff**/
	var mapEmbedIconography = { pointer:      'http://ausstage.edu.au/pages/assets/images/iconography/pointer.png',
                                           contributor:  'http://ausstage.edu.au/pages/assets/images/iconography/contributor.png',
                                           organisation: 'http://ausstage.edu.au/pages/assets/images/iconography/organisation.png',
                                           venue:        'http://ausstage.edu.au/pages/assets/images/iconography/venue-arch.png',
                                           event:        'http://ausstage.edu.au/pages/assets/images/iconography/event.png',
                                           work:         'http://ausstage.edu.au/pages/assets/images/iconography/work.png',                                           
                                           iconWidth:    '32',
                                           iconHeight:   '32',
                                           contributorColours:  ['b-112', 'b-113', 'b-114', 'b-115', 'b-116'],
                                           organisationColours: ['b-127', 'b-128', 'b-129', 'b-130', 'b-131'],
                                           venueColours:        ['b-142', 'b-143', 'b-144', 'b-145', 'b-146'],
                                           eventColours:        ['b-97', 'b-98', 'b-99', 'b-100', 'b-101'],
                                           workColours:  	['b-157', 'b-158', 'b-159', 'b-160', 'b-161'],
                                           individualContributors:  ['b-50', 'b-49', 'b-48', 'b-47', 'b-46', 'b-45', 'b-44', 'b-43', 'b-42', 'b-41', 'b-40', 'b-39', 'b-86', 'b-85', 'b-84', 'b-83', 'b-82', 'b-81', 'b-80', 'b-79', 'b-78', 'b-77', 'b-76', 'b-75', 'b-74', 'b-73', 'b-72', 'b-71', 'b-70', 'b-69', 'b-68', 'b-67', 'b-66', 'b-65', 'b-64', 'b-63', 'b-62', 'b-61', 'b-60', 'b-59', 'b-58', 'b-57', 'b-56', 'b-55', 'b-54', 'b-53', 'b-52', 'b-51'],
                                           individualOrganisations: ['b-66', 'b-67', 'b-68', 'b-69', 'b-70', 'b-71', 'b-72', 'b-73', 'b-74', 'b-75', 'b-76', 'b-77', 'b-78', 'b-79', 'b-80', 'b-81', 'b-82', 'b-83', 'b-84', 'b-85', 'b-86', 'b-60', 'b-61', 'b-62', 'b-63', 'b-64', 'b-65', 'b-59', 'b-58', 'b-57', 'b-56', 'b-55', 'b-54', 'b-53', 'b-52', 'b-51', 'b-50', 'b-49', 'b-48', 'b-47', 'b-46', 'b-45', 'b-44', 'b-43', 'b-42', 'b-41', 'b-40', 'b-39'],
                                           individualWorks:  	['b-73', 'b-74', 'b-75', 'b-76', 'b-77', 'b-78', 'b-79', 'b-80', 'b-81', 'b-82', 'b-83', 'b-84', 'b-85', 'b-86', 'b-39', 'b-40', 'b-41', 'b-42', 'b-43', 'b-44', 'b-45', 'b-46', 'b-47', 'b-48', 'b-49', 'b-50', 'b-51', 'b-52', 'b-53', 'b-54', 'b-55', 'b-56', 'b-57', 'b-58', 'b-59', 'b-60', 'b-61', 'b-62', 'b-63', 'b-64', 'b-65', 'b-66', 'b-67', 'b-68', 'b-69', 'b-70', 'b-71', 'b-72']
                                         };

var clusterEmbedIconography = [{url: 'http://ausstage.edu.au/pages/assets/images/iconography/cluster.png',
                                                        height: 96,
                                                        width: 96,
                                                        anchor: [40, 45],
                                                        textColor: '#000000',
                                                        textSize: 9
                                                   },
                                                   {url: 'http://ausstage.edu.au/pages/assets/images/iconography/cluster.png',
                                                        height: 96,
                                                        width: 96,
                                                        anchor: [40, 42],
                                                        textColor: '#000000',
                                                        textSize: 9
                                                   },
                                                   {url: 'http://ausstage.edu.au/pages/assets/images/iconography/cluster.png',
                                                        height: 96,
                                                        width: 96,
                                                        anchor: [40, 39],
                                                        textColor: '#000000',
                                                        textSize: 9
                                                   },
                                                   {url: 'http://ausstage.edu.au/pages/assets/images/iconography/cluster.png',
                                                        height: 96,
                                                        width: 96,
                                                        anchor: [40, 36],
                                                        textColor: '#000000',
                                                        textSize: 9
                                                   }
                                                   ,
                                                   {url: 'http://ausstage.edu.au/pages/assets/images/iconography/cluster.png',
                                                        height: 96,
                                                        width: 96,
                                                        anchor: [40, 33],
                                                        textColor: '#000000',
                                                        textSize: 9
                                                   }
                                                  ];

	
	
	
	function loadMap(c, o, v, e, w){
	console.log("******************************************");
		bookmarkObj   = new BookmarkClass();
		
		bookmarkObj.initForEmbed();
		
		mappingObj   = new MappingClass();
		
		mappingObj.initForEmbed();
		
		mappingObj.doEmbeddedMap(c, o, v, e, w);
		
		mappingObj.resetEmbedMap();
		
	}
	
	/******************************************************************
	doEmbedMap
	*/
	MappingClass.prototype.doEmbeddedMap = function(c, o, v, e, w) {
        console.log("Do Embed Map ");
                        
                        if(typeof(c) == 'undefined') {
                                c = null;
                        }
                        
                        if(typeof(o) == 'undefined') {
                                o = null;
                        }
                        
                        if(typeof(v) == 'undefined') {
                                v = null;
                        }
                        
                        if(typeof(e) == 'undefined') {
                                e = null;
                        }

                        if(typeof(w) == 'undefined') {
                                w = null;
                        }
                        // build the map
                        bookmarkObj.doComplexEmbedMapFromLink(c, o, v, e, w);
    }
        
	
	
	// build a complex map from the link
	BookmarkClass.prototype.doComplexEmbedMapFromLink = function (c, o, v, e, w) {
		
        // keep the user informed
        //$("#map_bookmark_loading_div").dialog('open');

        // create a queue
        var ajaxQueue = $.manageAjax.create("mappingBookmarkGatherDataAjaxQueue", {
                queue: true
        });
        // create an event listener so we know when it has stopped
        $("#load_messages").bind('mappingBookmarkGatherDataAjaxQueue' + 'AjaxStop', bookmarkObj.addDataToEmbedMap);
		
        // break up the attributes into arrays
        if(c != "") {
                if(c.indexOf('-') != -1) {
                        c = c.split('-');
                        // search for the data on each of the items in turn
                        for(var i = 0; i < c.length; i++) {
                                // build the url
                                var url  = EMBEDED_BASE_URL + 'markers?type=contributor&id=' + c[i];
                                ajaxQueue.add({
										dataType:'jsonp',
                                        success: function(data){bookmarkObj.processAjaxData1(data); console.log( bookmarkObj.data.contributors )},
										//success: function(data){console.log(data)},
                                        url: url
                                });
                        }
                } else {
                
                        // build the url
                        var url  = EMBEDED_BASE_URL + 'markers?type=contributor&id=' + c;

                        ajaxQueue.add({
								dataType:'jsonp',
                                success: function(data){bookmarkObj.processAjaxData1(data);},
                                url: url
                        });
                }
        }
        if(o != "") {
                if(o.indexOf('-') != -1) {
                        o = o.split('-');
                        for(var i = 0; i < o.length; i++) {
                                // build the url
                                var url  = EMBEDED_BASE_URL + 'markers?type=organisation&id=' + o[i];
                                ajaxQueue.add({
										dataType:'jsonp',
                                        success: function(data){bookmarkObj.processAjaxData2(data);},
                                        url: url
                                });
                        }
                } else {
                        // build the url
                        var url  = EMBEDED_BASE_URL + 'markers?type=organisation&id=' + o; 
                        ajaxQueue.add({
								dataType:'jsonp',
                                success: function(data){bookmarkObj.processAjaxData2(data);},
                                url: url
                        });
                }
        }
        if(v != "") {
                if(v.indexOf('-') != -1) {
                        v = v.split('-');       
                        for(var i = 0; i < v.length; i++) {
                                // build the url
                                var url  = EMBEDED_BASE_URL + 'markers?type=venue&id=' + v[i];
                
                                ajaxQueue.add({
										dataType:'jsonp',
                                        success: function(data){bookmarkObj.processAjaxData3(data);},
                                        url: url
                                });
                        }
                } else {
                        // build the url
                        var url  = EMBEDED_BASE_URL + 'markers?type=venue&id=' + v;
        
                        ajaxQueue.add({
								dataType:'jsonp',
                                success: function(data){bookmarkObj.processAjaxData3(data);},
                                url: url
                        });
                }
        }
        if(e != "") {
                if(e.indexOf('-') != -1) {
                        e = e.split('-');
                        for(var i = 0; i < e.length; i++) {
                                // build the url
                                var url  = EMBEDED_BASE_URL + 'markers?type=event&id=' + e[i];
                                ajaxQueue.add({
										dataType:'jsonp',
                                        success: function(data){bookmarkObj.processAjaxData4(data);},
                                        url: url
                                });
                        }
                } else {
                        // build the url
                        var url  = EMBEDED_BASE_URL + 'markers?type=event&id=' + e;
                        ajaxQueue.add({
								dataType:'jsonp',
                                success: function(data){bookmarkObj.processAjaxData4(data);},
                                url: url
                        });
                }
        }
        if(w != "") {
                if(w.indexOf('-') != -1) {
                        w = w.split('-');
                        for(var i = 0; i < w.length; i++) {
                                // build the url
                                var url  = EMBEDED_BASE_URL + 'markers?type=work&id=' + w[i];
                                ajaxQueue.add({
										dataType:'jsonp',
                                        success: function(data){bookmarkObj.processAjaxData5(data);},
                                        url: url
                                });
                        }
                } else {
                        // build the url
                        var url  = EMBEDED_BASE_URL + 'markers?type=work&id=' + w;
                        ajaxQueue.add({
								dataType:'jsonp',
                                success: function(data){bookmarkObj.processAjaxData5(data);},
                                url: url
                        });
                }
        }
	}
	
	
	/*****************************
	Update Embed Map
	*/
	
	// function to update the map
	MappingClass.prototype.updateEmbedMap = function() {

        // do we need to reset or initialise the map
        if(mappingObj.map == null) {
                // initialise the map
                mappingObj.initEmbedMap();
                mappingObj.resizeEmbedMap();
        } else {

                // reset the map and associated objects
                
                // reset the marker clusterer
                if(mappingObj.markerClusterer != null) {
                        mappingObj.markerClusterer.clearMarkers();
                }
        
                // remove any existing markers
                for(var i = 0; i < mappingObj.mapMarkers.objects.length; i++) {
                        // remove the marker from the map
                        mappingObj.mapMarkers.objects[i].setMap(null);
                
                        // null this object
                        mappingObj.mapMarkers.objects[i] = null;
                }
        
                // reset the array
                mappingObj.mapMarkers.objects = [];
                mappingObj.mapMarkers.hashes = [];
        }

        // check to see if clustering should be enabled
        if(mappingObj.markerData.objects.length >= mappingObj.applyClusterLimit) {
                mappingObj.clusteringEnabled = true;
        }
        
        // declare helper variables
        var title = null;
        
        // add the markers to the map
        var objects = mappingObj.markerData.objects;
		console.log("----------------------");
		console.log(mappingObj.markerData);
        var iconography = null;
        var offset = 0;

        for(var i = 0; i < objects.length; i++) {
                
                // build the iconography
                iconography = mappingObj.buildEmbedIconography(objects[i]);
                
                if(iconography != null) {
                
                        if(mappingObj.clusteringEnabled == false) {
                
								/*var marker = new google.maps.Marker({
								        position:     new google.maps.LatLng(objects[i].latitude, objects[i].longitude),
                                        map:          mappingObj.map,
										labelContent: iconography.table,
                                        labelClass:   'mapIconContainer',
                                        labelAnchor:  new google.maps.Point(mappingObj.POINTER_X_OFFSET * iconography.offset, mappingObj.POINTER_Y_OFFSET),
                                        icon:         mapEmbedIconography.pointer
								});*/
                                // create a marker with a label and add it to the map
                                var marker = new MarkerWithLabel({
                                        position:     new google.maps.LatLng(objects[i].latitude, objects[i].longitude),
                                        map:          mappingObj.map,
                                        draggable:    false,
                                        labelContent: iconography.table,
                                        labelClass:   'mapIconContainer',
                                        labelAnchor:  new google.maps.Point(mappingObj.POINTER_X_OFFSET * iconography.offset, mappingObj.POINTER_Y_OFFSET),
                                        icon:         mapEmbedIconography.pointer
                                });
                        } else {
                        
                                // create a marker with a label and do not add it to the map
                                var marker = new MarkerWithLabel({
                                        position:     new google.maps.LatLng(objects[i].latitude, objects[i].longitude),
                                        //map:          mappingObj.map,
                                        draggable:    false,
                                        labelContent: iconography.table,
                                        labelClass:   'mapIconContainer',
                                        labelAnchor:  new google.maps.Point(mappingObj.POINTER_X_OFFSET * iconography.offset, mappingObj.POINTER_Y_OFFSET),
                                        icon:         mapEmbedIconography.pointer
                                });
                        }
                
                        mappingObj.mapMarkers.objects.push(marker);
                        mappingObj.mapMarkers.hashes.push(mappingObj.computeLatLngHash(objects[i].latitude, objects[i].longitude));
                }
        }
        
        // add markers using clustering
        if(mappingObj.clusteringEnabled == true) {
                mappingObj.markerClusterer = new MarkerClusterer(mappingObj.map);
                mappingObj.markerClusterer.setStyles(clusterEmbedIconography);
                mappingObj.markerClusterer.setMaxZoom(mappingObj.clusterMaxZoomLevel);
                mappingObj.markerClusterer.addMarkers(mappingObj.mapMarkers.objects);
        } else {
                mappingObj.markerClusterer = null;
        }
        
        // finalise the map updates
        mappingObj.resizeEmbedMap();
    
	}
	
	/**********
	reset embed map
	**/
	// function to reset the map
	MappingClass.prototype.resetEmbedMap = function() {

        // delete all of the markers if necessary
        if(mappingObj.map == null) {

                // initialise the map
				
                mappingObj.initEmbedMap();
                mappingObj.resizeEmbedMap();
				
        } else {

                // reset the map and associated objects
                
                // reset the marker clusterer
                if(mappingObj.markerClusterer != null) {
                        mappingObj.markerClusterer.clearMarkers();
                }
        
                // remove any existing markers
                for(var i = 0; i < mappingObj.mapMarkers.objects.length; i++) {
                        // remove the marker from the map
                        mappingObj.mapMarkers.objects[i].setMap(null);
                
                        // null this object
                        mappingObj.mapMarkers.objects[i] = null;
                }
        
                // reset the array
                mappingObj.mapMarkers.objects = [];
                mappingObj.mapMarkers.hashes = [];
                
                // reset the data array
                mappingObj.markerData.hashes = [];
                mappingObj.markerData.objects = [];
                
               
                
                //recentre the map
                mappingObj.map.setCenter(new google.maps.LatLng(mappingObj.commonLocales.unknown.lat, mappingObj.commonLocales.unknown.lng)); 
        }
        
        // update the map
        mappingObj.updateEmbedMap();

	}
	
	
	/***
	resize the embeded map? is this the key to its display? */
	// a function to resize the map
	MappingClass.prototype.resizeEmbedMap = function() {

        if(mappingObj.map != null) {
                //var mapDiv = $(mappingObj.map.getDiv());
                var mapDiv = $('#map_container_div');
                mapDiv.height(500);
                google.maps.event.trigger(mappingObj.map, 'resize');
                // manually trigger an idle event
                var zoom = mappingObj.map.getZoom();
                mappingObj.map.setZoom(zoom - 1);
                mappingObj.map.setZoom(zoom);
                //mappingObj.map.setCenter(new google.maps.LatLng(mappingObj.commonLocales.unknown.lat, mappingObj.commonLocales.unknown.lng)); 
        } else {
                mappingObj.initEmbedMap();
        }
	}
	
	
	MappingClass.prototype.initEmbedMap = function() {
	if (this.mapsAvailable){
	        // initialise the map
        	mappingObj.options = {zoom:   mappingObj.commonLocales.unknown.zoom,
                                                  center: new google.maps.LatLng(mappingObj.commonLocales.unknown.lat, mappingObj.commonLocales.unknown.lng),
                                                  mapTypeControl: true,
                                                  mapTypeControlOptions: {
                                                   mapTypeIds: [google.maps.MapTypeId.ROADMAP, 
                                                                        google.maps.MapTypeId.SATELLITE, 
                                                                        google.maps.MapTypeId.HYBRID, 
                                                                        google.maps.MapTypeId.TERRAIN, 
                                                                        'ausstage']
                                                  }
                                         };     
        
	        mappingObj.map = new google.maps.Map(document.getElementById("map_div"), mappingObj.options);
        
        	// style the map
	        var styledMapOptions = {map: mappingObj.map, 
                                                        name: "AusStage",
                                                        alt: 'Show AusStage styled map'
                                                   };
        	var ausstageStyle    = new google.maps.StyledMapType(mappingObj.mapStyle, styledMapOptions);
        
	        mappingObj.map.mapTypes.set('ausstage', ausstageStyle);
        	mappingObj.map.setMapTypeId('ausstage');
        
	        // add a function to various events to ensure markers get events added to them
        	google.maps.event.addListener(mappingObj.map, 'idle', mappingObj.addEmbedMarkerClickEvent);
	        google.maps.event.addListener(mappingObj.map, 'zoom_changed', mappingObj.addEmbedMarkerClickEvent2);

		} 
		else {
			$("#map_div").empty().append("<p><i>Google Maps currently unavailable on AusStage, please try again later</i></p>");
		}
	}
	
	
	// function to add the data to the map
BookmarkClass.prototype.addDataToEmbedMap = function() {

        if(bookmarkObj.data.contributors.length > 0) {
                mappingObj.addEmbedContributorData(bookmarkObj.data.contributors, false);
        }
        
        if(bookmarkObj.data.organisations.length > 0) {
                mappingObj.addEmbedOrganisationData(bookmarkObj.data.organisations, false);
        }
        
        if(bookmarkObj.data.venues.length > 0) {
                mappingObj.addEmbedVenueBrowseData(bookmarkObj.data.venues, false);
        }
        
        if(bookmarkObj.data.events.length > 0) {
        
                mappingObj.addEmbedEventData(bookmarkObj.data.events, false);
        }
        
        if(bookmarkObj.data.works.length > 0) {
        
                mappingObj.addEmbedWorkData(bookmarkObj.data.works, false);
        }
        
        // keep the user informed
        $("#load_messages").hide();
        
        // update map display with data
        mappingObj.updateEmbedMap();
}
	  /*function initMap() {
        var uluru = {lat: -25.363, lng: 131.044};
        var map = new google.maps.Map(document.getElementById('map'), {
          zoom: 4,
          center: uluru
        });
        var marker = new google.maps.Marker({
          position: uluru,
          map: map
        });
      }*/
	  
	  
	  // convenience function for the adding of venue data
MappingClass.prototype.addEmbedVenueData = function(data) {
        mappingObj.addEmbedVenueBrowseData(data);
}

// function to update the list of venues with data from the browse interface
MappingClass.prototype.addEmbedVenueBrowseData = function(data) {

        // declare helper variables
        var hash  = null;
        var idx   = null;
        var obj   = null;
        var id    = null;
        var found = false;

        // loop through the data
        for(var i = 0; i < data.length; i++) {
        
                // compute a hash
                hash = mappingObj.computeLatLngHash(data[i].latitude, data[i].longitude);
                
                // check to see if we have this venue already
                idx = $.inArray(hash, mappingObj.markerData.hashes);
                if(idx == -1) {
                        // not seen this lat / lng before
                        obj = new MarkerData();
                        obj.venues.push(data[i]);
                        obj.latitude  = data[i].latitude;
                        obj.longitude = data[i].longitude
                        
                        mappingObj.markerData.hashes.push(hash);
                        mappingObj.markerData.objects.push(obj);
                } else {
                        // have seen this lat / lng before
                        // check to see if the venue is already added
                        obj = mappingObj.markerData.objects[idx];
                        id = data[i].id;
                        found = false;
                        
                        for(var x = 0; x < obj.venues.length; x++) {
                                if(id == obj.venues[x].id) {
                                        found = true;
                                        x = obj.venues.length + 1;
                                }
                        } 
                        
                        if(found == false) {
                                obj.venues.push(data[i]);       
                        }       
                }
        }
}

// function to update the list of contributors with data from the search interface
MappingClass.prototype.addEmbedContributorData = function(data) {


        // declare helper variables
        var hash  = null;
        var idx   = null;
        var obj   = null;
        var id    = null;
        var found = false;
        var contributor = null;
        var venues      = null;
        var objCopy     = null;

        // loop through the data
        for(var i = 0; i < data.length; i++) {
        
                // get the contributor information and list of venues
                contributor = data[i].extra[0];
                venues      = data[i].venues;
                
                // have we assigned a colour to this contributor before?
                idx = $.inArray(contributor.id, mappingObj.contributorColours.ids);
                
                if(idx == -1) {
                        // no we haven't
                        var count = mappingObj.contributorColours.ids.length;
                        
                        while(count > mapEmbedIconography.individualContributors.length) {
                                count = count - mapEmbedIconography.individualContributors.length;
                        }
                        
                        mappingObj.contributorColours.ids.push(contributor.id);
                        mappingObj.contributorColours.colours.push(mapEmbedIconography.individualContributors[count]);
                }
                
                // loop through the list of venues
                for(var x = 0; x < venues.length; x++) {
                        
                        // compute a hash
                        hash = mappingObj.computeLatLngHash(venues[x].latitude, venues[x].longitude);
                        
                        // check to see if we have this venue already
                        idx = $.inArray(hash, mappingObj.markerData.hashes);
                        
                        if(idx == -1) {
                                // not seen this lat / lng before
                                obj = new MarkerData();
                                
                                // make a copy of this contributor and add a venue
                                objCopy = jQuery.extend(true, {}, contributor);
                                objCopy.venue = venues[x].id;
                                objCopy.venueObj = venues[x];
                                
                                obj.contributors.push(objCopy);
                                obj.latitude  = venues[x].latitude;
                                obj.longitude = venues[x].longitude
                                
                                mappingObj.markerData.hashes.push(hash);
                                mappingObj.markerData.objects.push(obj);
                        } else {
                                // have seen this lat / lng before
                                // check to see if the contributor has already been added
                                obj   = mappingObj.markerData.objects[idx];
                                id    = contributor.id;
                                found = false;
                                
                                for(var y = 0; y < obj.contributors.length; y++) {
                                        if(id == obj.contributors[y].id) {
                                                found = true;
                                                y = obj.contributors.length + 1;
                                        }
                                }
                                
                                if(found == false) {
                                        // make a copy of this contributor and add a venue
                                        objCopy = jQuery.extend(true, {}, contributor);
                                        objCopy.venue = venues[x].id;
                                        objCopy.venueObj = venues[x];                   
                                        obj.contributors.push(objCopy);
                                }
                        }
                }
        }
}

// function to update the list of contributors with data from the search interface
MappingClass.prototype.addEmbedOrganisationData = function(data) {

        // declare helper variables
        var hash  = null;
        var idx   = null;
        var obj   = null;
        var id    = null;
        var found = false;
        var organisation = null;
        var venues       = null;
        var objCopy      = null;

        // loop through the data
        for(var i = 0; i < data.length; i++) {
        
                // get the contributor information and list of venes
                organisation = data[i].extra[0];
                venues       = data[i].venues;
                
                // have we assigned a colour to this contributor before?
                idx = $.inArray(organisation.id, mappingObj.organisationColours.ids);
                
                if(idx == -1) {
                        // no we haven't
                        var count = mappingObj.organisationColours.ids.length;
                        
                        while(count > mapEmbedIconography.individualOrganisations.length) {
                                count = count - mapEmbedIconography.individualOrganisations.length;
                        }
                        
                        mappingObj.organisationColours.ids.push(organisation.id);
                        mappingObj.organisationColours.colours.push(mapEmbedIconography.individualOrganisations[count]);
                }
                
                // loop through the list of venues
                for(var x = 0; x < venues.length; x++) {
                        
                        // compute a hash
                        hash = mappingObj.computeLatLngHash(venues[x].latitude, venues[x].longitude);
                        
                        // check to see if we have this venue already
                        idx = $.inArray(hash, mappingObj.markerData.hashes);
                        
                        if(idx == -1) {
                                // not see this lat / lng before
                                obj = new MarkerData();
                                
                                // make a copy of this contributor and add a venue
                                objCopy = jQuery.extend(true, {}, organisation);
                                objCopy.venue = venues[x].id;
                                objCopy.venueObj = venues[x];
                                
                                obj.organisations.push(objCopy);
                                obj.latitude  = venues[x].latitude;
                                obj.longitude = venues[x].longitude
                                
                                mappingObj.markerData.hashes.push(hash);
                                mappingObj.markerData.objects.push(obj);
                        } else {
                                // have seen this lat / lng before
                                // check to see if the organisation has already been added
                                obj   = mappingObj.markerData.objects[idx];
                                id    = organisation.id;
                                found = false;
                                
                                for(var y = 0; y < obj.organisations.length; y++) {
                                        if(id == obj.organisations[y].id) {
                                                found = true;
                                                y = obj.organisations.length + 1;
                                        }
                                }
                                
                                if(found == false) {
                                        // make a copy of this contributor and add a venue
                                        objCopy = jQuery.extend(true, {}, organisation);
                                        objCopy.venue = venues[x].id;
                                        objCopy.venueObj = venues[x];
                                
                                        obj.organisations.push(objCopy);
                                }
                        }
                }
        }
        
       
}

// function to update the list of events with data from the search interface
MappingClass.prototype.addEmbedEventData = function(data) {

        // declare helper variables
        var hash  = null;
        var idx   = null;
        var obj   = null;
        var id    = null;
        var found = false;
        var event = null;
        var venues = null;

        // loop through the data
        for(var i = 0; i < data.length; i++) {
        
                // get the event information and list of venes
                event  = data[i].extra[0];
                venues = data[i].venues;
              
                
                // loop through the list of venues
                for(var x = 0; x < venues.length; x++) {
                        
                        // compute a hash
                        hash = mappingObj.computeLatLngHash(venues[x].latitude, venues[x].longitude);
                        
                        // check to see if we have this venue already
                        idx = $.inArray(hash, mappingObj.markerData.hashes);
                        
                        if(idx == -1) {
                                // not see this lat / lng before
                                obj = new MarkerData();
                                obj.events.push(event);
                                obj.latitude  = venues[x].latitude;
                                obj.longitude = venues[x].longitude
                                
                                mappingObj.markerData.hashes.push(hash);
                                mappingObj.markerData.objects.push(obj);
                        } else {
                                // have seen this lat / lng before
                                // check to see if the event has already been added
                                obj   = mappingObj.markerData.objects[idx];
                                id    = event.id;
                                found = false;
                                
                                for(var y = 0; y < obj.events.length; y++) {
                                        if(id == obj.events[y].id) {
                                                found = true;
                                                y = obj.events.length + 1;
                                        }
                                }
                                
                                if(found == false) {
                                        obj.events.push(event);

                                }
                        }
                }
        }
        
      
}

/*****/
// function to update the list of works with data from the search interface
MappingClass.prototype.addEmbedWorkData = function(data) {
		
        // declare helper variables
        var hash  = null;
        var idx   = null;
        var obj   = null;
        var id    = null;
        var found = false;
        var work  = null;
        var venues       = null;
        var objCopy      = null;

        // loop through the data
        for(var i = 0; i < data.length; i++) {
        
                // get the contributor information and list of venes
                work = data[i].extra[0];
                venues       = data[i].venues;
                
                // have we assigned a colour to this contributor before?
                idx = $.inArray(work.id, mappingObj.workColours.ids);
                
                if(idx == -1) {
                        // no we haven't
                        var count = mappingObj.workColours.ids.length;
                        
                        while(count > mapEmbedIconography.individualWorks.length) {
                                count = count - mapEmbedIconography.individualWorks.length;
                        }
                        
                        mappingObj.workColours.ids.push(work.id);
                        mappingObj.workColours.colours.push(mapEmbedIconography.individualWorks[count]);
                }
                
                // loop through the list of venues
                for(var x = 0; x < venues.length; x++) {
                        
                        // compute a hash
                        hash = mappingObj.computeLatLngHash(venues[x].latitude, venues[x].longitude);
                        
                        // check to see if we have this venue already
                        idx = $.inArray(hash, mappingObj.markerData.hashes);
                        
                        if(idx == -1) {
                                // not see this lat / lng before
                                obj = new MarkerData();
                                
                                // make a copy of this contributor and add a venue
                                objCopy = jQuery.extend(true, {}, work);
                                objCopy.venue = venues[x].id;
                                objCopy.venueObj = venues[x];
                                
                                obj.works.push(objCopy);
                                obj.latitude  = venues[x].latitude;
                                obj.longitude = venues[x].longitude
                                
                                mappingObj.markerData.hashes.push(hash);
                                mappingObj.markerData.objects.push(obj);
                        } else {
                                // have seen this lat / lng before
                                // check to see if the work has already been added
                                obj   = mappingObj.markerData.objects[idx];
                                id    = work.id;
                                found = false;
                                
                                for(var y = 0; y < obj.works.length; y++) {
                                        if(id == obj.works[y].id) {
                                                found = true;
                                                y = obj.works.length + 1;
                                        }
                                }
                                
                                if(found == false) {
                                        // make a copy of this contributor and add a venue
                                        objCopy = jQuery.extend(true, {}, work);
                                        objCopy.venue = venues[x].id;
                                        objCopy.venueObj = venues[x];
                                
                                        obj.works.push(objCopy);
                                }
                        }
                }
        }
        
}
/*****/

// function to build the table for the iconography layout
MappingClass.prototype.buildEmbedIconography = function(data) {

        // determine the colour to use 
        var cellColour;
        
        // build the table cells
        var cells = '';
        var footerCells = '';
        
        // declare other helper variables
        var objArray = [];
        var obj;
        var idx;
        var offset = 0;
        
        // make a copy of the contributors array,
        objArray = data.contributors;
        
        if(objArray.length > 0) {
                // we need to add a contributor icon
                if(objArray.length == 1) {
                        //cellColour = mapEmbedIconography.contributorColours[0];
                        obj = objArray[0];
                        idx = $.inArray(obj.id, mappingObj.contributorColours.ids);
                        cellColour = mappingObj.contributorColours.colours[idx];
                } else {
                        cellColour = mappingObj.lookupCellColour(objArray.length, mapEmbedIconography.contributorColours);
                }
                
                cells += '<td class="' + cellColour + ' mapIconImg"><img class="mapIconImgImg" id="mapIcon-contributor-' + mappingObj.computeLatLngHash(data.latitude, data.longitude) +'" src="' + mapEmbedIconography.contributor + '" width="' + mapEmbedIconography.iconWidth + '" height="' + mapEmbedIconography.iconHeight + '"/></td>';
                footerCells += '<td class="mapIconNum b-184">' + objArray.length + '</td>';
                offset ++;
        }
        
        // reset variables
        objArray = [];
        obj = null;
        
        // make a copy of the organisations array
        objArray = data.organisations;
        
        if(objArray.length > 0) {
                // we need to add an organisation icon
                if(objArray.length == 1) {
                        //cellColour = mapEmbedIconography.organisationColours[0];
                        obj = data.organisations[0];
                        idx = $.inArray(obj.id, mappingObj.organisationColours.ids);
                        cellColour = mappingObj.organisationColours.colours[idx];
                } else {
                        cellColour = mappingObj.lookupCellColour(objArray.length, mapEmbedIconography.organisationColours);
                }
                
                cells += '<td class="' + cellColour + ' mapIconImg"><img class="mapIconImgImg" id="mapIcon-organisation-' + mappingObj.computeLatLngHash(data.latitude, data.longitude) +'" src="' + mapEmbedIconography.organisation + '" width="' + mapEmbedIconography.iconWidth + '" height="' + mapEmbedIconography.iconHeight + '"/></td>';
                footerCells += '<td class="mapIconNum b-184">' + objArray.length + '</td>';
                offset ++;
        }
        
        // reset variables
        objArray = [];
        obj = null;
        
        // make a copy of the venues array,
        objArray = data.venues;
        
        if(objArray.length > 0) {
        
                // we need to add a venue icon
                cellColour = mappingObj.lookupCellColour(objArray.length, mapEmbedIconography.venueColours);
                
                cells += '<td class="' + cellColour + ' mapIconImg"><img class="mapIconImgImg" id="mapIcon-venue-' + mappingObj.computeLatLngHash(data.latitude, data.longitude) +'" src="' + mapEmbedIconography.venue + '" width="' + mapEmbedIconography.iconWidth + '" height="' + mapEmbedIconography.iconHeight + '"/></td>';
                footerCells += '<td class="mapIconNum b-184">' + objArray.length + '</td>';
                offset ++;
        }
        
        // reset variables
        objArray = [];
        obj = null;
        
		// make a copy of the works array
        objArray = data.works;
        
        if(objArray.length > 0) {
                // we need to add an work icon
                if(objArray.length == 1) {
                        //cellColour = mapEmbedIconography.organisationColours[0];
                        obj = data.works[0];
                        idx = $.inArray(obj.id, mappingObj.workColours.ids);
                        cellColour = mappingObj.workColours.colours[idx];
                } else {
                        cellColour = mappingObj.lookupCellColour(objArray.length, mapEmbedIconography.workColours);
                }
                
                cells += '<td class="' + cellColour + ' mapIconImg"><img class="mapIconImgImg" id="mapIcon-work-' + mappingObj.computeLatLngHash(data.latitude, data.longitude) +'" src="' + mapEmbedIconography.work + '" width="' + mapEmbedIconography.iconWidth + '" height="' + mapEmbedIconography.iconHeight + '"/></td>';
                footerCells += '<td class="mapIconNum b-184">' + objArray.length + '</td>';
                offset ++;
        }
        
        // reset variables
        objArray = [];
        obj = null;
		
        // make a copy of the events array,
        objArray = data.events;
        
        if(objArray.length > 0) {
        
                //we need to add an event icon  
                cellColour = mappingObj.lookupCellColour(objArray.length, mapEmbedIconography.eventColours);
                
                cells += '<td class="' + cellColour + ' mapIconImg"><img class="mapIconImgImg" id="mapIcon-event-' + mappingObj.computeLatLngHash(data.latitude, data.longitude) +'" src="' + mapEmbedIconography.event + '" width="' + mapEmbedIconography.iconWidth + '" height="' + mapEmbedIconography.iconHeight + '"/></td>';
                footerCells += '<td class="mapIconNum b-184">' + objArray.length + '</td>';
                offset ++;
        }
        
        // return the iconography table
        if(cells == '') {
                return null;
        } else {
                return  {table: '<table class="mapIcon"><tr>' + cells + '</tr><tr>' + footerCells + '</tr></table>',
                         offset: offset
                        }
        }
}

// respond to click events on icons
MappingClass.prototype.iconClickEmbed = function(event) {

        // split the id of this icon into it's component parts
        var tokens = this.id.split('-');
        
        // get the markerData object for this location
        var idx = $.inArray(tokens[2], mappingObj.markerData.hashes);
        var data = mappingObj.markerData.objects[idx];
        var objArray = [];
        
        // reset the infoWindowData variable
        mappingObj.infoWindowData = [];
        
        if(mappingObj.infoWindowReference != null) {
                mappingObj.infoWindowReference.close();
                mappingObj.infoWindowReference = null;
        }
        
        // determine what type of icon this is
        if(tokens[1] == 'contributor') {
                // this is a contributor icon
                
                // create a queue
                var ajaxQueue = $.manageAjax.create("mappingMapGatherContributorInfo", {
                        queue: true
                });

                // define a basic marker                        
                var marker = new google.maps.Marker({
                        position: new google.maps.LatLng(data.latitude, data.longitude),
                        map:      mappingObj.map,
                        visible:  false
                });
                
                // define placeholder content           
                var content = '<div class="infoWindowContent">' + buildInfoMsgBox('Loading contributor information, please wait...') + '</div>';
                
                // build and so the infoWindow
                mappingObj.infoWindowReference = new google.maps.InfoWindow({
                        content:  content,
                        maxWidth: mappingObj.INFO_WINDOW_MAX_WIDTH
                });
                
                mappingObj.infoWindowReference.open(mappingObj.map, marker);
                
                // get a filtered data array
                objArray = data.contributors;
                
                // use the queue to get the data
                for(var i = 0; i < objArray.length; i++) {
        
                        // build the url
                        var url  = EMBEDED_BASE_URL + 'events?task=contributor&id=' + objArray[i].id +'&venue=' + objArray[i].venue;
                
                        ajaxQueue.add({
				dataType: 'jsonp',
                                success: function(data){mappingObj.processInfoWindowDataEmbed(data); console.log(data)},
                                url: url
                        });
                }
                
                
        } else if(tokens[1] == 'organisation') {
                // this is a organisation icon
                
                // create a queue
                var ajaxQueue = $.manageAjax.create("mappingMapGatherOrganisationInfo", {
                        queue: true
                });

                // define a basic marker                        
                var marker = new google.maps.Marker({
                        position: new google.maps.LatLng(data.latitude, data.longitude),
                        map:      mappingObj.map,
                        visible:  false
                });
                
                // define placeholder content           
                var content = '<div class="infoWindowContent">' + buildInfoMsgBox('Loading organisation information, please wait...') + '</div>';
                
                // build and so the infoWindow
                mappingObj.infoWindowReference = new google.maps.InfoWindow({
                        content:  content,
                        maxWidth: mappingObj.INFO_WINDOW_MAX_WIDTH
                });
                
                mappingObj.infoWindowReference.open(mappingObj.map, marker);
                
                // get a filtered data array
                objArray = data.organisations;
                
                // use the queue to get the data
                for(var i = 0; i < objArray.length; i++) {
        
                        // build the url
                        var url  = EMBEDED_BASE_URL + 'events?task=organisation&id=' + objArray[i].id +'&venue=' + objArray[i].venue;
                
                        ajaxQueue.add({
								dataType: 'jsonp',
                                success: mappingObj.processInfoWindowDataEmbed,
                                url: url
                        });
                }
                
        } else if(tokens[1] == 'venue') {
                // this is a venue icon
                
                // create a queue
                var ajaxQueue = $.manageAjax.create("mappingMapGatherVenueInfo", {
                        queue: true
                });

                // define a basic marker                        
                var marker = new google.maps.Marker({
                        position: new google.maps.LatLng(data.latitude, data.longitude),
                        map:      mappingObj.map,
                        visible:  false
                });
                
                // define placeholder content           
                var content = '<div class="infoWindowContent">' + buildInfoMsgBox('Loading venue information, please wait...') + '</div>';
                
                // build and so the infoWindow
                mappingObj.infoWindowReference = new google.maps.InfoWindow({
                        content:  content,
                        maxWidth: mappingObj.INFO_WINDOW_MAX_WIDTH
                });
                
                mappingObj.infoWindowReference.open(mappingObj.map, marker);
                
                // get a filtered data array
                objArray = data.venues;
                
                // use the queue to get the data
                for(var i = 0; i < objArray.length; i++) {
        
                        // build the url
                        var url  = EMBEDED_BASE_URL + 'events?task=venue&id=' + objArray[i].id;
             
                        ajaxQueue.add({
								dataType: 'jsonp',
                                success: mappingObj.processInfoWindowDataEmbed,
                                url: url
                        });
                }
        } else if(tokens[1] == 'work') {
                // this is a work icon
                
                // create a queue
                var ajaxQueue = $.manageAjax.create("mappingMapGatherWorkInfo", {
                        queue: true
                });
				
                // define a basic marker                        
                var marker = new google.maps.Marker({
                        position: new google.maps.LatLng(data.latitude, data.longitude),
                        map:      mappingObj.map,
                        visible:  false
                });
                
                // define placeholder content           
                var content = '<div class="infoWindowContent">' + buildInfoMsgBox('Loading work information, please wait...') + '</div>';
                
                // build and so the infoWindow
                mappingObj.infoWindowReference = new google.maps.InfoWindow({
                        content:  content,
                        maxWidth: mappingObj.INFO_WINDOW_MAX_WIDTH
                });
                
                mappingObj.infoWindowReference.open(mappingObj.map, marker);
                
                // get a filtered data array
                objArray = data.works;
                
                // use the queue to get the data
                for(var i = 0; i < objArray.length; i++) {
        
                        // build the url
                        var url  = EMBEDED_BASE_URL + 'events?task=work&id=' + objArray[i].id +'&venue=' + objArray[i].venue;
                
                        ajaxQueue.add({
								dataType: 'jsonp',
                                success: mappingObj.processInfoWindowDataEmbed,
                                url: url
                        });
                }
                
        } else {
                // this is an event icon

                // define a basic marker                        
                var marker = new google.maps.Marker({
                        position: new google.maps.LatLng(data.latitude, data.longitude),
                        map:      mappingObj.map,
                        visible:  false
                });
                
                // define placeholder content           
                var content = '<div class="infoWindowContent">' + buildInfoMsgBox('Loading event information, please wait...') + '</div>';
                
                // build and so the infoWindow
                mappingObj.infoWindowReference = new google.maps.InfoWindow({
                        content:  content,
                        maxWidth: mappingObj.INFO_WINDOW_MAX_WIDTH
                });
                
                mappingObj.infoWindowReference.open(mappingObj.map, marker);
                
                // get a filtered data array
                objArray = data.events;
                
                // build the event data for the infoWindow
                mappingObj.buildEventInfoWindowEmbed(objArray);
        }
}

// define a function to add the click event to the marker components 
MappingClass.prototype.addEmbedMarkerClickEvent = function() {

        // get all of the individual icons by class
        $('.mapIconImgImg').each(function() {
                var icon = $(this);
                
                if(icon.hasClass('mapIconImgImgEvnt') == false) {
                        icon.click(mappingObj.iconClickEmbed);
                        icon.addClass('mapIconImgImgEvnt');
                }
        });
}

MappingClass.prototype.addEmbedMarkerClickEvent2 = function() {
		
        setTimeout("mappingObj.addEmbedMarkerClickEvent()", UPDATE_DELAY * 3);
}

// function to process the results of the ajax infoWindow data lookups
MappingClass.prototype.processInfoWindowDataEmbed = function(data) {
		
        mappingObj.infoWindowData = mappingObj.infoWindowData.concat(data);
}

// define a function to initialise the mapping page elements
MappingClass.prototype.initForEmbed = function() {

	if (typeof google !== 'undefined') this.mapsAvailable = true;
	
	
        // set up the iconography help dialog
        /*$("#help_map_icons_div").dialog({ 
                autoOpen: false,
                height: 600,
                width: 600,
                modal: true,
                buttons: {
                        Close: function() {
                                $(this).dialog('close');
                        }
                },
                open: function() {
                        // build the legend table rows
                        mappingObj.buildIconographyHelp();                      
                },
                close: function() {
                        
                }
        });
        
        $('.map-icon-help').click(function() {
                $('#help_map_icons_div').dialog('open');
        });


        // resize the map when the tab is shown
        $('#tabs').bind('tabsshow', function(event, ui) {
                if (ui.panel.id == "tabs-3") { // tabs-3 == the map tab
                        // update the map
                        mappingObj.updateMap();
                }
        });
        */
        // resize the map when the window is resized
        /*$(window).resize(function() {
                mappingObj.resizeMap();
        });*/
        
        // bind to the ajax stop event so we know we've got the data
        $("#load_messages").bind('mappingMapGatherVenueInfo' + 'AjaxStop', mappingObj.buildEmbedVenueInfoWindow);
        $("#load_messages").bind('mappingMapGatherContributorInfo' + 'AjaxStop', mappingObj.buildEmbedContributorInfoWindow);
        $("#load_messages").bind('mappingMapGatherOrganisationInfo' + 'AjaxStop', mappingObj.buildEmbedOrganisationInfoWindow);
		$("#load_messages").bind('mappingMapGatherWorkInfo' + 'AjaxStop', mappingObj.buildEmbedWorkInfoWindow);
        
        // setup the live bind for scrolling in infoWindows
        $('.infoWindowHeaderItem').live('click', mappingObj.scrollInfoWindow);
        
        // setup the live bind for scrolling to the top of infoWindows
        $('.infoWindowToTop').live('click', mappingObj.scrollInfoWindowToTop);

}

// funtion to build the infoWindow for contributors
MappingClass.prototype.buildEmbedContributorInfoWindow = function() {

        if(mappingObj.infoWindowData.length == 0) {
                mappingObj.infoWindowReference.setContent('<div class="infoWindowContent">' + buildErrorMsgBox('the request for contributor information') + '</div>');
                return;
        }
console.log("*******************");
        // define a variable to store the infoWindow content
        var content = '<div class="infoWindowContent">';
        var header  = '<div class="infoWindowContentHeader b-187 f-184"><div class="infoWindowContentHeaderItems">';
        var list    = '<div class="infoWindowContentList">';
        var idx     = null;
        var colour  = null;
        var tmp = null;
        
        // sort the array
        mappingObj.infoWindowData.sort(sortContributorArray);
        console.log(mappingObj.infoWindowData.length)
        // build the content
        for(var i = 0; i < mappingObj.infoWindowData.length; i++) {
        
                var data = mappingObj.infoWindowData[i];
                
                // add the venue to the header
                tmp = data.contributor.firstName + ' ' + data.contributor.lastName;
                header += '<span class="infoWindowHeaderItem clickable" id="infoWindowScroll-' + data.contributor.id + '">' + tmp.replace(/\s/g, '&nbsp;') + '</span> | ';
                
                list += '<div class="infoWindowListHeader b-186 f-184" id="infoWindowScrollTo-' + data.contributor.id + '">';
                
                idx = $.inArray(data.contributor.id, mappingObj.contributorColours.ids);
                colour = mappingObj.contributorColours.colours[idx];
                
                list += '<table class="infoWindowListHeaderLayout"><tr><td class="mapLegendIcon"><span class="infoWindowListIcon ' + colour + '"><img src="'+ mapEmbedIconography.contributor + '" width="' + mapEmbedIconography.iconWidth + '" height="' + mapEmbedIconography.iconHeight + '"/></span></td>';
                list += '<td><span class="infoWindowListTitle"><a href="' + data.contributor.url + '" target="_ausstage">' + data.contributor.firstName + ' ' + data.contributor.lastName + '</a>';
                
                //list += '<span class="infoWindowListIcon ' + colour + '"><img src="'+ mapEmbedIconography.contributor + '" width="' + mapEmbedIconography.iconWidth + '" height="' + mapEmbedIconography.iconHeight + '"/></span>';
                //list += '<span class="infoWindowListTitle"><a href="' + data.contributor.url + '" target="_ausstage">' + data.contributor.firstName + ' ' + data.contributor.lastName + '</a>';
                
                if(i > 0) {
                        list +=  ' <span class="infoWindowToTop clickable">[top]</span><br/>';
                } else {
                        list += '<br/>';
                }
                
                // add the functions
                for(var y = 0; y < data.contributor.functions.length; y++ ){
                        list += data.contributor.functions[y] + ', ';
                }
                
                if(data.contributor.functions.length != 0) {
                        list = list.substr(0, list.length -2);
                }
                
                // finalise the link and start of the content
                list += '</span></td></tr></table></div><ul class="infoWindowEventList">';
                
                // add the events
                for(var x = 0; x < data.events.length; x++) {
                
                                if(x % 2 == 1) {
                                        list += '<li class="b-185">';
                                } else {
                                        list += '<li>';
                                }
                
                                list += '<a href="' + data.events[x].url + '" target="_ausstage">' + data.events[x].name + '</a>, ';
                                list += data.name + ', ' + mappingObj.buildAddressAlt(data.suburb, data.state, data.country);
                                list += ', ' + data.events[x].firstDate.replace(/\s/g, '&nbsp;') + '</li>';
                        
                }
                
                // finalise the list of events
                list += '</ul>';
                
        }
        
        // finish the content
        header = header.substr(0, header.length - 10);
        header += '</span></div></div>';
        list   += '</div>';
        
        if(mappingObj.infoWindowData.length > 1) {
                content += header + list + '</div>';
        } else {
                content += list + '</div>';
        }
        
        // replace the content of the infoWindow
        mappingObj.infoWindowReference.setContent(content);
        
        // add a function to the domready event to adjust the infoWindow
        google.maps.event.addListener(mappingObj.infoWindowReference, 'domready', function() {
        
                // check to see if scrollbars are present
                var divOfInterest = $('.infoWindowContent').parent().parent();
                
                if(divOfInterest.get(0).scrollHeight > divOfInterest.height()) {
                        // scroll bars are found so adjust
                        divOfInterest.css("margin-top", "15px");
                        var height = divOfInterest.height();
                        height = height - 15;
                        divOfInterest.height(height);
                }
        });
}

// funtion to build the infoWindow for organisations
MappingClass.prototype.buildEmbedOrganisationInfoWindow = function() {

        if(mappingObj.infoWindowData.length == 0) {
                mappingObj.infoWindowReference.setContent('<div class="infoWindowContent">' + buildErrorMsgBox('the request for organisation information') + '</div>');
                return;
        }

        // define a variable to store the infoWindow content
        var content = '<div class="infoWindowContent">';
        var header  = '<div class="infoWindowContentHeader b-187 f-184"><div class="infoWindowContentHeaderItems">';
        var list    = '<div class="infoWindowContentList">';
        var idx     = null;
        var colour  = null;
        
        // sort the array
        mappingObj.infoWindowData.sort(sortOrganisationArray);
        
        // build the content
        for(var i = 0; i < mappingObj.infoWindowData.length; i++) {
        
                var data = mappingObj.infoWindowData[i];
                
                // add the venue to the header
                header += '<span class="infoWindowHeaderItem clickable" id="infoWindowScroll-' + data.organisation.id + '">' + data.organisation.name.replace(/\s/g, '&nbsp;') + '</span> | ';
                
                list += '<div class="infoWindowListHeader b-186 f-184" id="infoWindowScrollTo-' + data.organisation.id + '">';
                
                idx = $.inArray(data.organisation.id, mappingObj.organisationColours.ids);
                colour = mappingObj.organisationColours.colours[idx];
                
                list += '<table class="infoWindowListHeaderLayout"><tr><td class="mapLegendIcon"><span class="infoWindowListIcon ' + colour + '"><img src="'+ mapEmbedIconography.organisation + '" width="' + mapEmbedIconography.iconWidth + '" height="' + mapEmbedIconography.iconHeight + '"/></span></td>';
                list += '<td><span class="infoWindowListTitle"><a href="' + data.organisation.url + '" target="_ausstage">' + data.organisation.name + '</a>';
                
                //list += '<span class="infoWindowListIcon ' + colour + '"><img src="'+ mapEmbedIconography.organisation + '" width="' + mapEmbedIconography.iconWidth + '" height="' + mapEmbedIconography.iconHeight + '"/></span>';
                
                //list += '<span class="infoWindowListTitle"><a href="' + data.organisation.url + '" target="_ausstage">' + data.organisation.name + '</a>';
                
                if(i > 0) {
                        list +=  ' <span class="infoWindowToTop clickable">[top]</span><br/>';
                } else {
                        list += '<br/>';
                }
                
                // add the address
                list += mappingObj.buildAddressAlt(data.organisation.suburb, data.organisation.state, data.organisation.country);
                
                // finalise the link and start of the content
                list += '</span></td></tr></table></div><ul class="infoWindowEventList">';
                
                // add the events
                for(var x = 0; x < data.events.length; x++) {
                
                                if(x % 2 == 1) {
                                        list += '<li class="b-185">';
                                } else {
                                        list += '<li>';
                                }
                
                                list += '<a href="' + data.events[x].url + '" target="_ausstage">' + data.events[x].name + '</a>, ';
                                list += data.name + ', ' + mappingObj.buildAddressAlt(data.suburb, data.state, data.country);
                                list += ', ' + data.events[x].firstDate.replace(/\s/g, '&nbsp;') + '</li>';
                }
                
                // finalise the list of events
                list += '</ul>';
                
        }
        
        // finish the content
        header = header.substr(0, header.length - 10);
        header += '</span></div></div>';
        list   += '</div>';
        
        if(mappingObj.infoWindowData.length > 1) {
                content += header + list + '</div>';
        } else {
                content += list + '</div>';
        }
        
        // replace the content of the infoWindow
        mappingObj.infoWindowReference.setContent(content);
        
        // add a function to the domready event to adjust the infoWindow
        google.maps.event.addListener(mappingObj.infoWindowReference, 'domready', function() {
        
                // check to see if scrollbars are present
                var divOfInterest = $('.infoWindowContent').parent().parent();
                
                if(divOfInterest.get(0).scrollHeight > divOfInterest.height()) {
                        // scroll bars are found so adjust
                        divOfInterest.css("margin-top", "15px");
                        var height = divOfInterest.height();
                        height = height - 15;
                        divOfInterest.height(height);
                }
        });
}

/*****/
// funtion to build the infoWindow for works
MappingClass.prototype.buildEmbedWorkInfoWindow = function() {
		
        if(mappingObj.infoWindowData.length == 0) {
                mappingObj.infoWindowReference.setContent('<div class="infoWindowContent">' + buildErrorMsgBox('the request for work information') + '</div>');
                return;
        }

        // define a variable to store the infoWindow content
        var content = '<div class="infoWindowContent">';
        var header  = '<div class="infoWindowContentHeader b-187 f-184"><div class="infoWindowContentHeaderItems">';
        var list    = '<div class="infoWindowContentList">';
        var idx     = null;
        var colour  = null;
        
        // sort the array
        mappingObj.infoWindowData.sort(sortWorkArray);
        
        // build the content
        for(var i = 0; i < mappingObj.infoWindowData.length; i++) {
        
                var data = mappingObj.infoWindowData[i];
                
                // add the venue to the header
                header += '<span class="infoWindowHeaderItem clickable" id="infoWindowScroll-' + data.work.id + '">' + data.work.name.replace(/\s/g, '&nbsp;') + '</span> | ';
                
                list += '<div class="infoWindowListHeader b-186 f-184" id="infoWindowScrollTo-' + data.work.id + '">';
                
                idx = $.inArray(data.work.id, mappingObj.workColours.ids);
                colour = mappingObj.workColours.colours[idx];
                
                list += '<table class="infoWindowListHeaderLayout"><tr><td class="mapLegendIcon"><span class="infoWindowListIcon ' + colour + '"><img src="'+ mapEmbedIconography.work + '" width="' + mapEmbedIconography.iconWidth + '" height="' + mapEmbedIconography.iconHeight + '"/></span></td>';
                list += '<td><span class="infoWindowListTitle"><a href="' + data.work.url + '" target="_ausstage">' + data.work.name + '</a>';

                if(i > 0) {
                        list +=  ' <span class="infoWindowToTop clickable">[top]</span><br/>';
                } else {
                        list += '<br/>';
                }
                
                // add the address
                list += mappingObj.buildAddressAlt(data.work.suburb, data.work.state, data.work.country);
                
                // finalise the link and start of the content
                list += '</span></td></tr></table></div><ul class="infoWindowEventList">';
                
                // add the events
                for(var x = 0; x < data.events.length; x++) {
                                if(x % 2 == 1) {
                                        list += '<li class="b-185">';
                                } else {
                                        list += '<li>';
                                }
                
                                list += '<a href="' + data.events[x].url + '" target="_ausstage">' + data.events[x].name + '</a>, ';
                                list += data.name + ', ' + mappingObj.buildAddressAlt(data.suburb, data.state, data.country);
                                list += ', ' + data.events[x].firstDate.replace(/\s/g, '&nbsp;') + '</li>';
                }
                
                // finalise the list of events
                list += '</ul>';
                
        }
        
        // finish the content
        header = header.substr(0, header.length - 10);
        header += '</span></div></div>';
        list   += '</div>';
        
        if(mappingObj.infoWindowData.length > 1) {
                content += header + list + '</div>';
        } else {
                content += list + '</div>';
        }
        
        // replace the content of the infoWindow
        mappingObj.infoWindowReference.setContent(content);
        
        // add a function to the domready event to adjust the infoWindow
        google.maps.event.addListener(mappingObj.infoWindowReference, 'domready', function() {
        
                // check to see if scrollbars are present
                var divOfInterest = $('.infoWindowContent').parent().parent();
                
                if(divOfInterest.get(0).scrollHeight > divOfInterest.height()) {
                        // scroll bars are found so adjust
                        divOfInterest.css("margin-top", "15px");
                        var height = divOfInterest.height();
                        height = height - 15;
                        divOfInterest.height(height);
                }
        });
		
}
/*****/

// function to buld the infoWindow for venues
MappingClass.prototype.buildEmbedVenueInfoWindow = function() {

        if(mappingObj.infoWindowData.length == 0) {
                mappingObj.infoWindowReference.setContent('<div class="infoWindowContent">' + buildErrorMsgBox('the request for venue information') + '</div>');
                return;
        }

        // define a variable to store the infoWindow content
        var content = '<div class="infoWindowContent">';
        var header  = '<div class="infoWindowContentHeader b-187 f-184"><div class="infoWindowContentHeaderItems">';
        var list    = '<div class="infoWindowContentList">';
        
        // sort the array
        mappingObj.infoWindowData.sort(sortVenueArray);
        
        // build the content
        for(var i = 0; i < mappingObj.infoWindowData.length; i++) {
        
                var data = mappingObj.infoWindowData[i];
                
                // add the venue to the header
                header += '<span class="infoWindowHeaderItem clickable" id="infoWindowScroll-' + data.id + '">' + data.name.replace(/\s/g, '&nbsp;') + '</span> | ';
                
                list += '<div class="infoWindowListHeader b-186 f-184" id="infoWindowScrollTo-' + data.id + '">';
                list += '<table class="infoWindowListHeaderLayout"><tr><td class="mapLegendIcon"><span class="infoWindowListIcon ' + mapEmbedIconography.venueColours[0] + '"><img src="'+ mapEmbedIconography.venue + '" width="' + mapEmbedIconography.iconWidth + '" height="' + mapEmbedIconography.iconHeight + '"/></span></td>';
                list += '<td><span class="infoWindowListTitle"><a href="' + data.url + '" target="_ausstage">' + data.name + '</a>';
                
                //list += '<span class="infoWindowListIcon ' + mapEmbedIconography.venueColours[0] + '"><img src="'+ mapEmbedIconography.venue + '" width="' + mapEmbedIconography.iconWidth + '" height="' + mapEmbedIconography.iconHeight + '"/></span>';
                //list += '<span class="infoWindowListTitle"><a href="' + data.url + '" target="_ausstage">' + data.name + '</a>';
                
                // add the venue content
                if(i > 0) {
                        list +=  ' <span class="infoWindowToTop clickable">[top]</span><br/>';
                } else {
                        list += '<br/>';
                }
                
                // add the address
                list += mappingObj.buildAddress(data.street, data.suburb, data.state, data.country) + '</span></td></tr></table>';
                
                // finalise the link and start of the content
                list += '</div><ul class="infoWindowEventList">';
                
                // add the events
                for(var x = 0; x < data.events.length; x++) {
                
                                if(x % 2 == 1) {
                                        list += '<li class="b-185">';
                                } else {
                                        list += '<li>';
                                }
                
                                list += '<a href="' + data.events[x].url + '" target="_ausstage">' + data.events[x].name + '</a>, ' + data.events[x].firstDate.replace(/\s/g, '&nbsp;') + '</li>';
                
                        
                }
                
                // finalise the list of events
                list += '</ul>';
                
        }
        
        // finish the content
        header = header.substr(0, header.length - 10);
        header += '</span></div></div>';
        list   += '</div>';
        
        if(mappingObj.infoWindowData.length > 1) {
                content += header + list + '</div>';
        } else {
                content += list + '</div>';
        }
        
        // replace the content of the infoWindow
        mappingObj.infoWindowReference.setContent(content);
        
        // add a function to the domready event to adjust the infoWindow
        google.maps.event.addListener(mappingObj.infoWindowReference, 'domready', function() {
        
                // check to see if scrollbars are present
                var divOfInterest = $('.infoWindowContent').parent().parent();
                
                if(divOfInterest.get(0).scrollHeight > divOfInterest.height()) {
                        // scroll bars are found so adjust
                        divOfInterest.css("margin-top", "15px");
                        var height = divOfInterest.height();
                        height = height - 15;
                        divOfInterest.height(height);
                }
        });
}

// function to buld the infoWindow for venues
MappingClass.prototype.buildEmbedEventInfoWindow = function(data) {

        // define a variable to store the infoWindow content
        var list;
        var idx;
        var event;
        
        list = '<div class="infoWindowContent"><div class="infoWindowListHeader b-186 f-184">';
        list += '<table class="infoWindowListHeaderLayout"><tr><td class="mapLegendIcon"><span class="infoWindowListIcon ' + mapEmbedIconography.eventColours[0] + '"><img src="'+ mapEmbedIconography.event + '" width="' + mapEmbedIconography.iconWidth + '" height="' + mapEmbedIconography.iconHeight + '"/></span></td>';
        list += '<td><span class="infoWindowListTitle"><a href="' + data[0].venue.url + '" target="_ausstage">' + data[0].venue.name + '</a><br/>' + mappingObj.buildAddressAlt(data[0].venue.suburb, data[0].venue.state, data[0].venue.country) + '</span></td></tr></table></div>';
        list += '<div class="infoWindowContentList"><ul class="infoWindowEventList">';
        
        // sort the array
        data.sort(sortEventArray);
        
        // build the content
        for(var i = 0; i < data.length; i++) {
        
                // check to see if this event is hidden
                event = data[i];
                idx = $.inArray(event.id, mappingObj.hiddenMarkers.events);
                
                if(idx == -1) {
                
                        if(i % 2 == 1) {
                                list += '<li class="b-185">';
                        } else {
                                list += '<li>';
                        }
                
                        list += '<a href="' + event.url + '" target="_ausstage">' + event.name + '</a> ' + event.venue.name;
                
                        list += ', ' + mappingObj.buildAddressAlt(event.venue.suburb, event.venue.state, event.venue.country);
                
                        // output the date
                        list += ', ' + event.firstDisplayDate.replace(/\s/g, '&nbsp;') + '</li>';
                }
        }
        
                        
        // finalise the list of events
        list += '</ul></div></div>';
        
        // replace the content of the infoWindow
        mappingObj.infoWindowReference.setContent(list);
        
        // add a function to the domready event to adjust the infoWindow
        google.maps.event.addListener(mappingObj.infoWindowReference, 'domready', function() {
        
                // check to see if scrollbars are present
                var divOfInterest = $('.infoWindowContent').parent().parent();
                
                if(divOfInterest.get(0).scrollHeight > divOfInterest.height()) {
                        // scroll bars are found so adjust
                        divOfInterest.css("margin-top", "15px");
                        var height = divOfInterest.height();
                        height = height - 15;
                        divOfInterest.height(height);
                }
        });
        
}

BookmarkClass.prototype.initForEmbed = function() {

}

// define a function to build an info message box
function buildInfoMsgBox(text) {
        return '<div class="ui-state-highlight ui-corner-all search-status-messages" id="status_message"><p><span class="ui-icon ui-icon-info status-icon"></span>' + text + '</p></div>';
}

// define a function used to sort an array of contributor objects on name
function sortContributorArray(a, b) {

        if(a.contributor.lastName == b.contributor.lastName) {
                if((a.contributor.lastName + a.contributor.firstName) == (a.contributor.lastName + a.contributor.firstName)) {
                        return 0;
                } else if((a.contributor.lastName + a.contributor.firstName) < (a.contributor.lastName + a.contributor.firstName)) {
                        return -1;
                } else {
                        return 1;
                }
        } else if(a.contributor.lastName < b.contributor.lastName) {
                return -1;
        } else {
                return 1;
        }
}

// define a function used to sort an array of organisation objects on name
function sortOrganisationArray(a, b) {
        console.log("org a:");
	console.log(a);
	console.log("org b:");	
	console.log(b);
        if(a.organisation.name == b.organisation.name) {
                return 0;
        } else if(a.organisation.name < b.organisation.name) {
                return -1;
        } else {
                return 1;
        }
}

// define a function used to sort an array of work objects on name
function sortWorkArray(a, b) {

        if(a.name == b.name) {
                return 0;
        } else if(a.name < b.name) {
                return -1;
        } else {
                return 1;
        }
}

// define a function used to sort an array of contributor objects on name
function sortContributorArrayAlt(a, b) {

        if(a.lastName == b.lastName) {
                if((a.lastName + a.firstName) == (b.lastName + b.firstName)) {
                        return 0;
                } else if((a.lastName + a.firstName) < (b.lastName + b.firstName)) {
                        return -1;
                } else {
                        return 1;
                }
        } else if(a.lastName < b.lastName) {
                return -1;
        } else {
                return 1;
        }
}

// define a function used to sort an array of organisation objects on name
function sortOrganisationArrayAlt(a, b) {

        if(a.name == b.name) {
                return 0;
        } else if(a.name < b.name) {
                return -1;
        } else {
                return 1;
        }
}


// define a function used to sort an array of venue objects on name
function sortVenueArray(a, b) {

        if(a.name == b.name) {  
                return 0;
        } else if(a.name < b.name) {
                return -1;
        } else {
                return 1;
        }
}

// define a function used to sort an array of venue objects on name
function sortEventArray(a, b) {

        if(a.firstDate == b.firstDate) {        
                return 0;
        } else if(a.firstDate < b.firstDate) {
                return 1;
        } else {
                return -1;
        }
}

// function to buld the infoWindow for venues
MappingClass.prototype.buildEventInfoWindowEmbed = function(data) {

        // define a variable to store the infoWindow content
        var list;
        var idx;
        var event;
        
        list = '<div class="infoWindowContent"><div class="infoWindowListHeader b-186 f-184">';
        list += '<table class="infoWindowListHeaderLayout"><tr><td class="mapLegendIcon"><span class="infoWindowListIcon ' + mapEmbedIconography.eventColours[0] + '"><img src="'+ mapEmbedIconography.event + '" width="' + mapEmbedIconography.iconWidth + '" height="' + mapEmbedIconography.iconHeight + '"/></span></td>';
        list += '<td><span class="infoWindowListTitle"><a href="' + data[0].venue.url + '" target="_ausstage">' + data[0].venue.name + '</a><br/>' + mappingObj.buildAddressAlt(data[0].venue.suburb, data[0].venue.state, data[0].venue.country) + '</span></td></tr></table></div>';
        list += '<div class="infoWindowContentList"><ul class="infoWindowEventList">';
        
        // sort the array
        data.sort(sortEventArray);
        
        // build the content
        for(var i = 0; i < data.length; i++) {
        
                // check to see if this event is hidden
                event = data[i];
                idx = $.inArray(event.id, mappingObj.hiddenMarkers.events);
                
                if(idx == -1) {
                
                        if(i % 2 == 1) {
                                list += '<li class="b-185">';
                        } else {
                                list += '<li>';
                        }
                
                        list += '<a href="' + event.url + '" target="_ausstage">' + event.name + '</a> ' + event.venue.name;
                
                        list += ', ' + mappingObj.buildAddressAlt(event.venue.suburb, event.venue.state, event.venue.country);
                
                        // output the date
                        list += ', ' + event.firstDisplayDate.replace(/\s/g, '&nbsp;') + '</li>';
                }
        }
        
                        
        // finalise the list of events
        list += '</ul></div></div>';
        
        // replace the content of the infoWindow
        mappingObj.infoWindowReference.setContent(list);
        
        // add a function to the domready event to adjust the infoWindow
        google.maps.event.addListener(mappingObj.infoWindowReference, 'domready', function() {
        
                // check to see if scrollbars are present
                var divOfInterest = $('.infoWindowContent').parent().parent();
                
                if(divOfInterest.get(0).scrollHeight > divOfInterest.height()) {
                        // scroll bars are found so adjust
                        divOfInterest.css("margin-top", "15px");
                        var height = divOfInterest.height();
                        height = height - 15;
                        divOfInterest.height(height);
                }
        });
        
}