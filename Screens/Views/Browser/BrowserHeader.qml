import CSI 1.0
import QtQuick 2.0
import Traktor.Gui 1.0 as Traktor

import './../Widgets' as Widgets
import './../Definitions' as Definitions
import './../../Views/Browser' as BrowserView

//------------------------------------------------------------------------------------------------------------------
// BROWSER HEADER - SHOWS THE CURRENT BROWSER PATH
//------------------------------------------------------------------------------------------------------------------
Item {
	id: header

	property int            currentDeck:    0
	property int            nodeIconId:     0

	readonly property color itemColor: colors.colorWhite19
	property int            highlightIndex: 0

	property string         pathStrings:    ""      // the complete path in one string given by QBrowser with separator " | "
	property var            stringList:    [""]     // list of separated path elements (calculated in "updateStringList")
	property var	        stringLength:  []     // list of separated path elements (calculated in "updateStringList")

	property string propertiesPath: ""
	
	clip:          true
	anchors.left:  parent.left
	anchors.right: parent.right
	anchors.top:   parent.top
	height:        21 // set in state


	// #######################################
	// ### ADD HEADER BACKGROUND & BOARDER ###
	// #######################################

	// Add boarder and background, including track deck letter with colouring
	
	Rectangle {
		id: 					browserHeader_backgnd
		anchors.left:  			parent.left
	    anchors.leftMargin:   	2
		anchors.right: 			browserHeaderSeperation_line.left
	    anchors.rightMargin:   	1
		anchors.top:   			parent.top
		anchors.topMargin: 		2
		height:        			16
    	color:  				colors.rgba (255, 255, 255, 16)
		clip:     				true
	}

	Rectangle {
		id: 					browserHeaderTop_line
		anchors.left:  			parent.left
		anchors.right: 			parent.right
		anchors.top:   			parent.top
		width:					parent.width
		height:        			1
    	color:  				colors.rgba (255, 255, 255, 32)
	}

	Rectangle {
		id: 					browserHeaderLeft_line
		anchors.left:  			parent.left
		anchors.top:   			parent.top
		anchors.topMargin: 		1
		width:					1
		height:        			18
    	color:  				colors.rgba (255, 255, 255, 32)
	}

	Rectangle {
		id: 					browserHeaderRight_line
		anchors.right: 			parent.right
		anchors.top:   			parent.top
		anchors.topMargin: 		1
		width:					1
		height:        			18
    	color:  				colors.rgba (255, 255, 255, 32)
	}

	Rectangle {
		id: 					browserHeaderBottom_line
		anchors.left:  			parent.left
		anchors.right: 			parent.right
		anchors.top:   			parent.top
		anchors.topMargin: 		19
		width:					parent.width
		height:        			1
    	color:  				colors.rgba (255, 255, 255, 32)
	}

	Rectangle {
		id: 					browserHeaderSeperation_line
		anchors.right: 			browserHeaderDeckletter_backgnd.left
		anchors.rightMargin:	1
		anchors.top:   			parent.top
		anchors.topMargin: 		1
		width:					1
		height:        			18
    	color:  				colors.rgba (255, 255, 255, 32)
	}

	Rectangle {
		id: 					browserHeaderDeckletter_backgnd
		height: 				16
		width: 					16
		anchors.right: 			browserHeaderRight_line.left
		anchors.rightMargin: 	1	
		anchors.top:       		browserHeaderTop_line.bottom
		anchors.topMargin:  	1
		
		function colorDeckLetterBackgnd() {
			if (header.currentDeck == 0) {	return colors.rgba (0, 0, 255, 255); }
			if (header.currentDeck == 1) {	return colors.rgba (0, 0, 255, 255); }
			if (header.currentDeck == 2) {	return colors.rgba (255, 255, 255, 255); }
			if (header.currentDeck == 3) {	return colors.rgba (255, 255, 255, 255); }
		}
		color:     				colorDeckLetterBackgnd()

		Text {
			id: 					browserHeaderDeckletter_text

			function textDeckLetter() {
				if (header.currentDeck == 0) {	return "A"; }
				if (header.currentDeck == 1) {	return "B"; }
				if (header.currentDeck == 2) {	return "C"; }
				if (header.currentDeck == 3) {	return "D"; }
			}
			text: 					textDeckLetter()

			function colorDeckLetter() {
				if (header.currentDeck == 0) {	return colors.rgba (255, 255, 255, 175); }
				if (header.currentDeck == 1) {	return colors.rgba (255, 255, 255, 175); }
				if (header.currentDeck == 2) {	return colors.rgba (0, 0, 0, 255); }
				if (header.currentDeck == 3) {	return colors.rgba (0, 0, 0, 255); }
			}
			color:     				colorDeckLetter()

			font.pixelSize:     	fonts.scale(14)
			anchors.top:       		parent.top
			anchors.topMargin:  	-1
			anchors.horizontalCenter: browserHeaderDeckletter_backgnd.horizontalCenter
		}
	}

	// #######################
	// ### ADD HEADER TEXT ###
	// #######################
	
  //--------------------------------------------------------------------------------------------------------------------
  // NOTE: text item used within the 'updateStringList' function to determine how many of the stringList items can be fit 
  //       in the header!
  // IMPORTANT EXTRA NOTE: all texts in the header should have the same Capitalization and font size settings as the "dummy"
  //                       as the dummy is used to calculate the number of text blocks fitting into the header.
  //--------------------------------------------------------------------------------------------------------------------
	onPathStringsChanged: { defineStringLengths(textLengthDummy) }

	Text {
		id: 					textLengthDummy
		visible: 				false
		font.capitalization: 	Font.Capitalize
		font.pixelSize:     	fonts.scale(13)
	}

  	// Define for each string length to be displayed
	function defineStringLengths(dummy) {
		var t = new Array(0); 	// Define empty .js array 

		var totalWidth = 0;	
		var maximumWidth = 450;
		var currentWidth = 0;
		var widthExcess = 0;
		
		totalWidth = 28;	//	Offset for BrowserIcon
		stringList = pathStrings.split(" | ");

		for (var i = 2; i < stringList.length; i++) 
		{	dummy.text = stringList[i];
			totalWidth = totalWidth + dummy.width + 18;
		}

		t.push(0); // Add dummy item - Browser is not visible but is in list
		t.push(0); // Add dummy item - BrowserType (Track Collection, iTunes...) is not visible but is in list

		for (var i = 2; i < stringList.length; i++) 
		{	dummy.text = stringList[i];
			currentWidth = dummy.width;
			
			if ( totalWidth <= maximumWidth ) {
				t.push(currentWidth); 
			} 
			
			if ( totalWidth > maximumWidth ) {	
				widthExcess = totalWidth - maximumWidth;

				if ( currentWidth > widthExcess)	{	
					t.push(currentWidth - widthExcess); 
					totalWidth = maximumWidth;
				}

				if ( currentWidth < widthExcess)	{	
					t.push(16); 
					totalWidth = totalWidth - currentWidth + 16;
				}
			} 
		}
		
		stringLength = t;  // Copy .js array into qml array
	}

	Image {
		id:       				browserIcon

		function defineBrowserIcon() {
			stringList = pathStrings.split(" | ");
			if ( stringList[1] == "Track Collection" )	{	return "./../Images/BrowserIcons/Browser_Icon_TrackCollection.png";	}
			if ( stringList[1] == "Playlist" )			{	return "./../Images/BrowserIcons/Browser_Icon_Playlist.png";	}
			if ( stringList[1] == "Explorer" )			{	
//				if ( model.nodeIconId == 6 ) 	{	return "./../Images/BrowserIcons/Browser_Icon_HDD.png";	}
//				if ( model.nodeIconId == 14 ) 	{	return "./../Images/BrowserIcons/Browser_Icon_Home.png";	}
//				if ( model.nodeIconId == 15 ) 	{	return "./../Images/BrowserIcons/Browser_Icon_MusicFolder.png";	}
				return "./../Images/BrowserIcons/Browser_Icon_Explorer.png";	
			}
			if ( stringList[1] == "iTunes" )			{	return "./../Images/BrowserIcons/Browser_Icon_iTunes.png";	}
			if ( stringList[1] == "History" )			{	return "./../Images/BrowserIcons/Browser_Icon_History.png";	}
			if ( stringList[1] == "Favorites" )			{	return "./../Images/BrowserIcons/Browser_Icon_Favorites.png";	}
		}
		source:   				defineBrowserIcon()

		width:    				28
		height:   				28
		x: 						0

		function defineBrowserOffset() {
			stringList = pathStrings.split(" | ");
			if ( stringList[1] == "Track Collection" )	{	return -5;	}
			if ( stringList[1] == "Playlist" )			{	return -4;	}
			if ( stringList[1] == "Explorer" )			{	return -4;	}
			if ( stringList[1] == "iTunes" )			{	return -4;	}
			if ( stringList[1] == "History" )			{	return -4;	}
			if ( stringList[1] == "Favorites" )			{	return -4;	}
		}
		y: 						defineBrowserOffset()

		fillMode: 				Image.PreserveAspectFit
		clip:     				false
		cache:    				false
		visible:  				stringList.length == 1 ? false : true
	}

	Item {
		id: 					browserHeader_textContainer
		anchors.top:         	browserHeader_backgnd.top
		anchors.bottom:      	browserHeader_backgnd.bottom
		anchors.left:        	browserHeader_backgnd.left
		anchors.leftMargin:   	20

		// the text flow
		Flow {
			id: 					header_textFlow
			layoutDirection: 		Qt.LeftToRight 

			anchors.top:         	browserHeader_backgnd.top
			anchors.bottom:      	browserHeader_backgnd.bottom
			anchors.left:        	browserHeader_backgnd.left

			Repeater {
				model: 				stringList.length

				Item {
					id: textContainer
					height: 20
					// arrows
					// the graphical separator between texts anchors on the left side of each text block. The space of "arrowContainerWidth" is reserved for that
					

					Text {
						id:						flowDir_dummy			
						text:                	headerPath_text.text
						visible: 				false
						font.capitalization: 	Font.Capitalize
						font.pixelSize:      	fonts.scale(13)
					} 

					width: index < 1 ? headerPath_text.width : headerPath_text.width + 16

					Text {
						id: 					headerPath_text
						width:               	index < 2 ? 0  : stringLength[index]
						text:                	index < 2 ? "" : stringList[index]
						visible:             	true
						font.capitalization: 	Font.Capitalize
						font.pixelSize:      	fonts.scale(13)
						color:					colors.rgba (255, 255, 255, 48)					
						elide:               	Text.ElideRight
					}

					Widgets.TextSeparatorArrow {
						color:               	colors.rgba (255, 255, 255, 48)
						visible:             	index < 1 ? false : true
						anchors.top:         	parent.top
						anchors.left:       	headerPath_text.right
						anchors.topMargin:   	5
						anchors.leftMargin: 	5 // left margin is set via "arrowContainerWidth"
					}

				}
			} 
		}
	}

 //--------------------------------------------------------------------------------------------------------------------
  state: "show"  
  states: [
    State {
      name: "show"
      PropertyChanges{target: header; height: 21}
    },
    State {
      name: "hide"
      PropertyChanges{target: header; height: 0}
    }
  ]

}
