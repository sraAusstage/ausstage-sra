/**************************************************************************
	Copyright (c) 2001 Geir Landrö (drop@destroydrop.com)
	JavaScript Tree - www.destroydrop.com/hugi/javascript/tree/
	Version 0.96	

	This script can be used freely as long as all copyright messages are
	intact.
**************************************************************************/

/*
Note: changed some script for the public side
	  to make the tree open and show the
	  children as default
	  
changed	  : 2/5/03
developer : J. Bongar
*/


// Arrays for nodes and icons
var nodes		= new Array();;
var openNodes	= new Array();
var icons		= new Array(6);
var joinPages   = "";

// Loads all icons that are used in the tree
function preloadIcons() {
	
	icons[0] = new Image();
	icons[1] = new Image();
	icons[2] = new Image();
	icons[3] = new Image();
	
	if(joinPages == "true"){
		
		icons[0].src = "./admin/images/line.gif";
		icons[1].src = "./admin/images/join.gif";
		icons[2].src = "./admin/images/joinbottom.gif";
		icons[3].src = "./admin/images/join.gif";
		
	}else{
	
		icons[0].src = "./admin/images/empty.gif";
		icons[1].src = "./admin/images/empty.gif";
		icons[2].src = "./admin/images/empty.gif";
		icons[3].src = "./admin/images/empty.gif";	
	}
}
// Create the tree
// overridePageImage -Added by Justin. If not empty string this value will
//                    override all page images (icons). Used for adding page,
//                    or displaying sitemap on public side (not tested)
//function createTree(arrName, overridePageImage, startNode, openNode) {

function createTree(arrName, overridePageImage, addpagejoints) {

	startNode = null
	openNode  = null
	nodes = arrName;
	
	// sets the true if page joins requires else false
//addpagejoints = "true";
	joinPages = addpagejoints;
	
	if (nodes.length > 0) {
		preloadIcons();
		if (startNode == null) startNode = 0;
		if (openNode != 0 || openNode != null) setOpenNodes(openNode);
	
		if (startNode !=0) {
			var nodeValues = nodes[getArrayId(startNode)].split("|");

      if (nodeValues[3] != "")
  			document.write("<a href=\"" + nodeValues[3] + "\">");

      // Check to see if the override image is set
      if (overridePageImage != "")
        nodeValues[4] = overridePageImage;      
      document.write("<img src=\"./admin/images/" + nodeValues[4] + "\" align=\"absbottom\" border=\"0\" alt=\"\" />" + nodeValues[2]);

      if (nodeValues[3] != "")
        document.write("</a>");
        
      document.write("<br />");
		}
    else
    { 
			document.write("<br />");
		}

		var recursedNodes = new Array();
		addNode(startNode, recursedNodes, overridePageImage);
	}
}
// Returns the position of a node in the array
function getArrayId(node) {
	for (i=0; i<nodes.length; i++) {
		var nodeValues = nodes[i].split("|");
		if (nodeValues[0]==node) return i;
	}
}
// Puts in array nodes that will be open
function setOpenNodes(openNode) {
	for (i=0; i<nodes.length; i++) {
		var nodeValues = nodes[i].split("|");
		if (nodeValues[0]==openNode) {
			openNodes.push(nodeValues[0]);
			setOpenNodes(nodeValues[1]);
		}
	} 
}
// Checks if a node is open
function isNodeOpen(node) {
	
	for (i=0; i<openNodes.length; i++)
		if (openNodes[i]==node) 
			return false;
	return true;
}
// Checks if a node has any children
function hasChildNode(parentNode) {
	for (i=0; i< nodes.length; i++) {
		var nodeValues = nodes[i].split("|");
		if (nodeValues[1] == parentNode) return true;
	}
	return false;
}
// Checks if a node is the last sibling
function lastSibling (node, parentNode) {
	var lastChild = 0;
	for (i=0; i< nodes.length; i++) {
		var nodeValues = nodes[i].split("|");
		if (nodeValues[1] == parentNode)
			lastChild = nodeValues[0];
	}
	if (lastChild==node) return true;
	return false;
}
// Adds a new node in the tree
function addNode(parentNode, recursedNodes, overridePageImage) {
	for (var i = 0; i < nodes.length; i++) {

		var nodeValues = nodes[i].split("|");
		if (nodeValues[1] == parentNode) {
			
			var ls	= lastSibling(nodeValues[0], nodeValues[1]);
			var hcn	= hasChildNode(nodeValues[0]);
			var ino = isNodeOpen(nodeValues[0]);
			


			// Write out line & empty icons
			for (g=0; g<recursedNodes.length; g++) {
				if (recursedNodes[g] == 1) {
					if(joinPages == "true")
						document.write("<img src=\"./admin/images/line.gif\" border=\"0\" align=\"absbottom\" alt=\"\" />");
					else
						document.write("<img src=\"./admin/images/empty.gif\" border=\"0\" align=\"absbottom\" alt=\"\" />");
				}else{
					//document.write("<img src=\"./admin/images/line.gif\" border=\"0\" align=\"absbottom\" alt=\"\" />");
					document.write("<img src=\"./admin/images/empty.gif\" border=\"0\" align=\"absbottom\" alt=\"\" />");
				}
			}

			// put in array line & empty icons
			if (ls) recursedNodes.push(0);
			else recursedNodes.push(1);

			// Write out join icons
			if (hcn) {
				if (ls) {	
					if(joinPages == "true")									
						document.write("<img id=\"join" + nodeValues[0] + "\" border=\"0\" src=\"./admin/images/join.gif\" align=\"absbottom\">");					
					else
						document.write("<img id=\"join" + nodeValues[0] + "\" border=\"0\" src=\"./admin/images/empty.gif\" align=\"absbottom\">");					
				} else {
					if(joinPages == "true")	
						document.write("<img id=\"join" + nodeValues[0] + "\" border=\"0\" src=\"./admin/images/joinbottom.gif\" align=\"absbottom\">");					
					else
						document.write("<img id=\"join" + nodeValues[0] + "\" border=\"0\" src=\"./admin/images/empty.gif\" align=\"absbottom\">");					
				}
			} else {
				if (ls) {
					if(joinPages == "true")
						document.write("<img src=\"./admin/images/join.gif\" border=\"0\" align=\"absbottom\" alt=\"\" />");
					else
						document.write("<img src=\"./admin/images/empty.gif\" border=\"0\" align=\"absbottom\" alt=\"\" />");
				}else{ 
					if(joinPages == "true")
						document.write("<img src=\"./admin/images/joinbottom.gif\" border=\"0\" align=\"absbottom\" alt=\"\" />");
					else
						document.write("<img src=\"./admin/images/empty.gif\" border=\"0\" align=\"absbottom\" alt=\"\" />");
				}
			}

			// Start link
      if (nodeValues[3] != "")
  			document.write("<a href=\"" + nodeValues[3] + "\">");
			
      // Check to see if the override image is set
      if (overridePageImage != "")
        nodeValues[4] = overridePageImage;

      // Write out page icons
      document.write("<img id=\"icon" + nodeValues[0] + "\" border=\"0\" src=\"./admin/images/" + nodeValues[4] + "\" align=\"absbottom\" alt=\"Page\" />");
			
			// Write out node name
			document.write("<font class='link_general'>" + nodeValues[2] + "</font>");

			// End link
      if (nodeValues[3] != "")
  			document.write("</a>");
      document.write("<br />");
			
			// If node has children write out divs and go deeper
			if (hcn) {
				document.write("<div id=\"div" + nodeValues[0] + "\"");
					if (!ino) document.write(" style=\"display: none;\"");
				document.write(">");
				addNode(nodeValues[0], recursedNodes, overridePageImage);
				document.write("</div>");
			}
			
			// remove last line or empty icon 
			recursedNodes.pop();
		}
	}
}


// Opens or closes a node
function oc(node, bottom) {

	var theDiv = document.getElementById("div" + node);
	var theJoin	= document.getElementById("join" + node);
	var theIcon = document.getElementById("icon" + node);

	if (theDiv.style.display == 'none') {
		if (bottom==1) theJoin.src = icons[3].src;
		else theJoin.src = icons[2].src;
		theDiv.style.display = '';
	} else {
		if (bottom==1) theJoin.src = icons[1].src;
		else theJoin.src = icons[0].src;
		theDiv.style.display = 'none';
	}
}
// Push and pop not implemented in IE(crap!    don´t know about NS though)
if(!Array.prototype.push) {
	function array_push() {
		for(var i=0;i<arguments.length;i++)
			this[this.length]=arguments[i];
		return this.length;
	}
	Array.prototype.push = array_push;
}
if(!Array.prototype.pop) {
	function array_pop(){
		lastElement = this[this.length-1];
		this.length = Math.max(this.length-1,0);
		return lastElement;
	}
	Array.prototype.pop = array_pop;
}
