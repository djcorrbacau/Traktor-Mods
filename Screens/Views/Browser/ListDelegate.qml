import CSI 1.0
import QtQuick 2.0
import QtGraphicalEffects 1.0

import './../Definitions' as Definitions
import './../Widgets' as Widgets

//  dataType, nodeIconId, nodeName, nrOfSubnodes, coverUrl, artistName, trackName, bpm, key, keyIndex, rating, loadedInDeck, prevPlayed, prelisten

Item {
  	id: contactDelegate

   	property int           screenFocus:           0
  	property bool          isCurrentItem :        ListView.isCurrentItem
  readonly property bool isLoaded:              (model.dataType == BrowserDataType.Track) ? model.loadedInDeck.length > 0 : false

  	height: 21
  	anchors.left: parent.left
  	anchors.right: parent.right

  
  	Rectangle {
		color:  				"transparent"
		anchors.left: 			parent.left
		anchors.right: 			parent.right
		anchors.leftMargin: 	2
		anchors.rightMargin: 	2
		height: 				parent.height  

    	// ##################
    	// ### TRACK NAME ###
    	// ##################

		Rectangle {
			id: 					trackName_bckgnd
			anchors.left: 			parent.left
			anchors.top: 			parent.top
			anchors.topMargin: 		2
			anchors.leftMargin: 	2
			width: 					200
			visible: 				(model.dataType == BrowserDataType.Track)

		  //! Dummy text to measure maximum text lenght dynamically and adjust icons behind it.
			Text {
				id: 				textLengthDummy
				visible: 			false
				font.pixelSize: 	fonts.scale(12)
				text: 				(model.dataType == BrowserDataType.Track) ? model.trackName  : ( (model.dataType == BrowserDataType.Folder) ? model.nodeName : "")
			}

			Text {
				id: 				trackName_text
				width: 				(textLengthDummy.width) > 200 ? 195 : textLengthDummy.width
				elide: 				Text.ElideRight
				text: 				textLengthDummy.text
				font.pixelSize: 	fonts.scale(12)
				color: 				isCurrentItem == false ? ((model.prevPlayed && !model.prelisten) ? colors.rgba (255, 255, 255, 32) : colors.rgba (255, 255, 255, 64)) : ((model.prevPlayed && !model.prelisten) ? colors.rgba (255, 255, 255, 32) : colors.rgba (255, 255, 255, 232))
			}
		}   

    	// ###################
    	// ### FOLDER NAME ###
    	// ###################

		Text {
			id: 					folderName_text
			anchors.left: 			parent.left
			anchors.top: 			parent.top
			anchors.topMargin: 		2
			anchors.leftMargin: 	32
	      	color: 					isCurrentItem == false ? colors.rgba (255, 255, 255, 64) : colors.rgba (255, 255, 255, 232)
			clip: 					true
			text: 					(model.dataType == BrowserDataType.Folder) ? model.nodeName : ""
			font.pixelSize: 		fonts.scale(12)
			elide: 					Text.ElideRight
			visible: 				(model.dataType != BrowserDataType.Track)
			width: 					250
		}
    

    	// ###################
    	// ### ARTIST NAME ###
    	// ###################

		Text {
			id: 					artistNameField
			anchors.left: 			(model.dataType == BrowserDataType.Track) ? trackName_bckgnd.right : folderName_text.right
			anchors.top: 			parent.top
			anchors.topMargin: 		2
			width: 					165
			color: 					isCurrentItem == false ? ((model.prevPlayed && !model.prelisten) ? colors.rgba (255, 255, 255, 32) : colors.rgba (255, 255, 255, 64)) : ((model.prevPlayed && !model.prelisten) ? colors.rgba (255, 255, 255, 32) : colors.rgba (255, 255, 255, 232))
			clip: 					true
			text: 					(model.dataType == BrowserDataType.Track) ? model.artistName: ""
			font.pixelSize: 		fonts.scale(12)
			elide: 					Text.ElideRight
		}  

		// ###########
    	// ### BPM ###
    	// ###########

		Text {
			id: 					bpmField
			anchors.left: 			(model.dataType == BrowserDataType.Track) ? artistNameField.right : folderName_text.right
			anchors.top: 			parent.top
			anchors.topMargin: 		2
			width: 					30
			color: 					isCurrentItem == false ? ((model.prevPlayed && !model.prelisten) ? colors.rgba (255, 255, 255, 32) : colors.rgba (255, 255, 255, 64)) : ((model.prevPlayed && !model.prelisten) ? colors.rgba (255, 255, 255, 32) : colors.rgba (255, 255, 255, 232))
			clip: 					true
			text: 					(model.dataType == BrowserDataType.Track) ? model.bpm.toFixed(0): ""
			font.pixelSize: 		fonts.scale(12)
			elide: 					Text.ElideRight
		}  

		// ###########
    	// ### KEY ###
    	// ###########

		Text {
			id: 					keyField
			anchors.left: 			(model.dataType == BrowserDataType.Track) ? bpmField.right : folderName_text.right
			anchors.top: 			parent.top
			anchors.topMargin: 		2
			width: 					30
			color: 					isCurrentItem == false ? ((model.prevPlayed && !model.prelisten) ? colors.rgba (255, 255, 255, 32) : colors.rgba (255, 255, 255, 64)) : ((model.prevPlayed && !model.prelisten) ? colors.rgba (255, 255, 255, 32) : colors.rgba (255, 255, 255, 232))
			clip: 					true
			text: 					(model.dataType == BrowserDataType.Track) ? (model.key.length == 2? "0" + model.key : model.key): ""
			font.pixelSize: 		fonts.scale(12)
			elide: 					Text.ElideRight
		}  
  	}

	// #################################
	// ### LOADED IN DECKS INDICATOR ###
	// #################################

	Rectangle {
		id: loadedInDecks_bckgnd
		anchors.top: 			parent.top
		anchors.topMargin: 	1
		anchors.bottom: 		parent.bottom
		anchors.bottomMargin: 	1
		anchors.right: 			parent.right
		anchors.rightMargin: 	3
		
		function loadInDecks_width () {
			var totalWidth = 0;
			
			if (loadedInDeckA_bckgnd.width != 0) { totalWidth = totalWidth + 13; }
			if (loadedInDeckB_bckgnd.width != 0) { totalWidth = totalWidth + 13; }
			if (loadedInDeckC_bckgnd.width != 0) { totalWidth = totalWidth + 13; }
			if (loadedInDeckD_bckgnd.width != 0) { totalWidth = totalWidth + 13; }
			if (prelisten_bckgnd.width != 0) {  totalWidth = totalWidth + 18; }
			if (prepared_bckgnd.width != 0) { totalWidth = totalWidth + 13; }
			
			return (totalWidth + 1);
		}
		
		width:					loadInDecks_width()
		visible:				loadedInDecks_bckgnd.width != 1 ? true : false
		color: 					colors.rgba (0, 0, 0, 232)
	}

	Rectangle {
		id:						loadedInDeckD_bckgnd			
		anchors.top: 			loadedInDecks_bckgnd.top
		anchors.topMargin:		1
		anchors.bottom: 		loadedInDecks_bckgnd.bottom
		anchors.bottomMargin:	1
		anchors.right: 			loadedInDecks_bckgnd.right
		anchors.rightMargin: 	(model.dataType == BrowserDataType.Track && isLoadedInDeck("D")) ? 1  : 0
		width:					(model.dataType == BrowserDataType.Track && isLoadedInDeck("D")) ? 12 : 0
		color: 					colors.rgba (255, 255, 255, 232)

		Text {
			id: 						loadedInDeckD_text
			anchors.horizontalCenter: 	loadedInDeckD_bckgnd.horizontalCenter
			anchors.verticalCenter: 	loadedInDeckD_bckgnd.verticalCenter
			color: 						colors.rgba (0, 0, 0, 232)
			font.pixelSize: 			fonts.scale(12)
			text:						"D"
			visible: 					(model.dataType == BrowserDataType.Track && isLoadedInDeck("D"))
		}
	}

	Rectangle {
		id:						loadedInDeckC_bckgnd			
		anchors.top: 			loadedInDecks_bckgnd.top
		anchors.topMargin:		1
		anchors.bottom: 		loadedInDecks_bckgnd.bottom
		anchors.bottomMargin:	1
		anchors.right: 			loadedInDeckD_bckgnd.left
		anchors.rightMargin: 	(model.dataType == BrowserDataType.Track && isLoadedInDeck("C")) ? 1  : 0
		width:					(model.dataType == BrowserDataType.Track && isLoadedInDeck("C")) ? 12 : 0
		color: 					colors.rgba (255, 255, 255, 232)

		Text {
			id: 						loadedInDeckC_text
			anchors.horizontalCenter: 	loadedInDeckC_bckgnd.horizontalCenter
			anchors.verticalCenter: 	loadedInDeckC_bckgnd.verticalCenter
			color: 						colors.rgba (0, 0, 0, 232)
			font.pixelSize: 			fonts.scale(12)
			text:						"C"
			visible: 					(model.dataType == BrowserDataType.Track && isLoadedInDeck("C"))
		}
	}

	Rectangle {
		id:						loadedInDeckB_bckgnd			
		anchors.top: 			loadedInDecks_bckgnd.top
		anchors.topMargin:		1
		anchors.bottom: 		loadedInDecks_bckgnd.bottom
		anchors.bottomMargin:	1
		anchors.right: 			loadedInDeckC_bckgnd.left
		anchors.rightMargin: 	(model.dataType == BrowserDataType.Track && isLoadedInDeck("B")) ? 1  : 0
		width:					(model.dataType == BrowserDataType.Track && isLoadedInDeck("B")) ? 12 : 0
		color: 					colors.rgba (0, 0, 255, 232)

		Text {
			id: 						loadedInDeckB_text
			anchors.horizontalCenter: 	loadedInDeckB_bckgnd.horizontalCenter
			anchors.verticalCenter: 	loadedInDeckB_bckgnd.verticalCenter
			color: 						colors.rgba (255, 255, 255, 232)
			font.pixelSize: 			fonts.scale(12)
			text:						"B"
			visible: 				(model.dataType == BrowserDataType.Track && isLoadedInDeck("B"))
		}
	}

	Rectangle {
		id:						loadedInDeckA_bckgnd			
		anchors.top: 			loadedInDecks_bckgnd.top
		anchors.topMargin:		1
		anchors.bottom: 		loadedInDecks_bckgnd.bottom
		anchors.bottomMargin:	1
		anchors.right: 			loadedInDeckB_bckgnd.left
		anchors.rightMargin: 	(model.dataType == BrowserDataType.Track && isLoadedInDeck("A")) ? 1  : 0
		width:					(model.dataType == BrowserDataType.Track && isLoadedInDeck("A")) ? 12 : 0
		color: 					colors.rgba (0, 0, 255, 232)

		Text {
			id: 						loadedInDeckA_text
			anchors.horizontalCenter: 	loadedInDeckA_bckgnd.horizontalCenter
			anchors.verticalCenter: 	loadedInDeckA_bckgnd.verticalCenter
			color: 						colors.rgba (255, 255, 255, 232)
			font.pixelSize: 			fonts.scale(12)
			text:						"A"
			visible: 					(model.dataType == BrowserDataType.Track && isLoadedInDeck("A"))
		}
	}

	Rectangle {
		id:						prelisten_bckgnd			
		anchors.top: 			loadedInDecks_bckgnd.top
		anchors.topMargin:		1
		anchors.bottom: 		loadedInDecks_bckgnd.bottom
		anchors.bottomMargin:	1
		anchors.right: 			loadedInDeckA_bckgnd.left
		anchors.rightMargin: 	(model.dataType == BrowserDataType.Track && model.prelisten) ? 1  : 0
		width:					(model.dataType == BrowserDataType.Track && model.prelisten) ? 17 : 0
		color: 					colors.rgba (255, 255, 255, 64)

		Image {
			anchors.centerIn: prelisten_bckgnd
			width: 12
			height: 17
			source: "./../images/PreviewIcon_Big.png"
			fillMode: Image.Pad
			clip: true
			cache: false
			sourceSize.width: width
			sourceSize.height: height
			visible: (model.dataType == BrowserDataType.Track && model.prelisten) ? true : false
		}
	}

	Rectangle {
		id:						prepared_bckgnd			
		anchors.top: 			loadedInDecks_bckgnd.top
		anchors.topMargin:		1
		anchors.bottom: 		loadedInDecks_bckgnd.bottom
		anchors.bottomMargin:	1
		anchors.right: 			prelisten_bckgnd.left
		anchors.rightMargin: 	(model.dataType == BrowserDataType.Track && model.prepared) ? 1  : 0
		width:					(model.dataType == BrowserDataType.Track && model.prepared) ? 12 : 0
		color: 					isCurrentItem == false ? colors.rgba (0, 0, 0, 232) : colors.rgba (255, 255, 255, 64)

		Image {
			anchors.centerIn: trackImage
			width: 					prepared_bckgnd.width
			height: 				prepared_bckgnd.height
			source: 				isCurrentItem == false ? "./../Images/PrepListIconGrey.png" : "./../Images/PrepListIconWhite.png"
			fillMode: 				Image.Pad
			clip: 					true
			cache: 					false
			sourceSize.width: 		width
			sourceSize.height: 		height
			visible: 				(model.dataType == BrowserDataType.Track && model.prepared) ? true : false
		}
    }

	function isLoadedInDeck(deckLetter)	{
	  	return model.loadedInDeck.indexOf(deckLetter) != -1;
	}

	// ###################
	// ### FOLDER ICON ###
	// ###################

	Image {
		id:       				folderIcon
		source:   				(model.dataType == BrowserDataType.Folder) ? ("image://icons/" + model.nodeIconId ) : ""
		width:    				26
		height:   				26
		fillMode: 				Image.PreserveAspectFit
		anchors.top: 			parent.top
		anchors.topMargin: 		-3
		anchors.left: 			parent.left
		anchors.leftMargin: 	0
		clip:     				true
		cache:    				false
		visible:  				false
	}

	ColorOverlay {
		id: 				folderIconColorOverlay
		color: 				isCurrentItem == false ? colors.rgba (255, 255, 255, 64) : colors.rgba (255, 255, 255, 128)
		anchors.fill: 		folderIcon
		source: 			folderIcon
	}
}
