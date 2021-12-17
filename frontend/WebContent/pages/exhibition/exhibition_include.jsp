<%@ page pageEncoding="UTF-8"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%
admin.AppConstants appConstants = new admin.AppConstants(request);
%>
<!--
Google Maps libraries
libraries and script to display the maps for venues is here. 
This is to avoid duplicating the download of multiple google maps libraries etc.
Each Venue.jsp will call the loadMap function if Lat and Long fields exist - loading the map for each venue. 
-->
<script type="text/javascript" src="//maps.google.com/maps/api/js?key=<%=appConstants.GOOGLE_KEY%>"></script>
<script type="text/javascript" language="javascript">
	function loadMap(mapId, lattitude, longitude) {
		var myLatlng = new google.maps.LatLng( lattitude, longitude);
		var myOptions = {
			zoom: 14,
			center: myLatlng,
			mapTypeControl: true,
	                mapTypeControlOptions: {
		                mapTypeIds: [google.maps.MapTypeId.ROADMAP, 
		                             google.maps.MapTypeId.SATELLITE, 
                			     google.maps.MapTypeId.HYBRID, 
		                             google.maps.MapTypeId.TERRAIN, 
			                     'ausstage']
                 		}
		}				
		var map = new google.maps.Map(document.getElementById(mapId), myOptions);
								
		mapStyle = [ { featureType: "all", elementType: "all", stylers: [ { visibility: "off" } ]},
			{ featureType: "water", elementType: "geometry", stylers: [ { visibility: "on" }, { lightness: 40 }, { saturation: 0 } ] },
			{ featureType: "landscape", elementType: "geometry", stylers: [ { visibility: "on" }, { saturation: -100 } ]},
			{ featureType: "road", elementType: "geometry", stylers: [ { visibility: "on" }, { saturation: -100 }, { lightness: 40 } ] },
			{ featureType: "transit", elementType: "geometry", stylers: [ { saturation: -100 }, { lightness: 40 } ] } 
		];
								
		var styledMapOptions = {map: map, name: "AusStage",	alt: 'Show AusStage styled map' };
		var ausstageStyle    = new google.maps.StyledMapType(mapStyle, styledMapOptions);
							
		map.mapTypes.set('ausstage', ausstageStyle);
		map.setMapTypeId('ausstage');
								
		var marker = new google.maps.Marker({
			position: myLatlng,
			map: map,
			title:  'this should be venue name',
			icon: '/pages/assets/images/iconography/venue-arch-134-pointer.png'
		});
								
	};

</script>	



