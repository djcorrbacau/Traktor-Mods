import CSI 1.0
import QtQuick 2.0
import QtGraphicalEffects 1.0

import '../../../Defines'
import './../Waveform' as WF

Item {
	id: trackDeck
	property int    deckId:          0
	property string deckSizeState:   "large"
	property color  deckColor:       colors.colorBgEmpty // transparent blue not possible for logo due to low bit depth of displays. was: // (deckId < 2) ? colors.colorDeckBlueBright12Full : colors.colorBgEmpty
	property bool   trackIsLoaded:   (primaryKey.value > 0)
	readonly property bool    isLoaded:  (primaryKey.value > 0) || (deckType == DeckType.Remix)

	readonly property int waveformHeight: deckSizeState == "medium" ? 71 : (deckSizeState == "large" ? 154 : 0)

	property bool showLoopSize: false
	property int  zoomLevel:    1
	property bool isInEditMode: false
	property int    stemStyle:    StemStyle.track
	property string propertiesPath: ""

	readonly property int minSampleWidth: 0x800
	readonly property int sampleWidth: minSampleWidth << zoomLevel

	//--------------------------------------------------------------------------------------------------------------------

	AppProperty   { id: deckType;          path: "app.traktor.decks." + (deckId + 1) + ".type"                         }
	AppProperty   { id: primaryKey;        path: "app.traktor.decks." + (deckId + 1) + ".track.content.primary_key" }

	// ####################
	// ### ADD WAVEFORM ###
	// ####################

	Rectangle {
		id: 					waveborderleft_line
		width:					1
		anchors.left:   		parent.left
		anchors.top:	 		parent.top
		height:         		waveformHeight+2
      	color:  				deckSizeState == "small" ? colors.rgba (20, 20, 20, 255) : (deckSizeState == "large" ? colors.rgba (40, 40, 40, 255) : colors.rgba (255, 255, 255, 255))
		visible:        		isLoaded
	}

	Rectangle {
		id: 					waveborderright_line
		width:					1
		anchors.right:  		parent.right
		anchors.top:	 		parent.top
		height:         		waveformHeight+2
      	color:  				deckSizeState == "small" ? colors.rgba (20, 20, 20, 255) : (deckSizeState == "large" ? colors.rgba (40, 40, 40, 255) : colors.rgba (255, 255, 255, 255))
		visible:        		isLoaded
	}

	WF.WaveformContainer {
		id: waveformContainer

		deckId:         		trackDeck.deckId
		deckSizeState:  		trackDeck.deckSizeState
		sampleWidth:    		trackDeck.sampleWidth
		propertiesPath: 		trackDeck.propertiesPath

		anchors.top:          	trackDeck.top
		anchors.topMargin:    	1
		anchors.left:         	waveborderleft_line.left
		anchors.leftMargin: 	0
		anchors.right:        	waveborderright_line.right
		anchors.rightMargin: 	0
		showLoopSize:         	trackDeck.showLoopSize
		isInEditMode:         	trackDeck.isInEditMode
		stemStyle:            	trackDeck.stemStyle
		height:  				waveformHeight
		visible: 				(trackIsLoaded && deckSizeState != "small") ? 1 : 0
	}

	// #######################################
	// ### ADD SEPERATION WAVE-STRIPE LINE ### - OK
	// #######################################

	Rectangle {
    	id:						seperationWaveStripe_line
    	width:  				trackDeck.width -2
    	height: 				1
    	anchors.top:       		trackDeck.top
    	anchors.topMargin: 		waveformHeight + 2
    	anchors.right: 			trackDeck.right
		anchors.rightMargin: 	1
    	anchors.left: 			trackDeck.left
		anchors.leftMargin: 	1
    	color:  				colors.rgba (40, 40, 40, 255)
   		visible:				(trackIsLoaded && deckSizeState != "small") ? 1 : 0
  	}
  
	// #######################
	// ### ADD STRIPE VIEW ### - OK
	// #######################

	Rectangle {
		id: 					stripeborderleft_line
		anchors.left:   		parent.left
		width:					1
		anchors.bottom: 		stripe.bottom
		anchors.bottomMargin: 	-1
		height:         		stripe.height + 2
      	color:  				deckSizeState == "small" ? colors.rgba (20, 20, 20, 255) : (deckSizeState == "large" ? colors.rgba (40, 40, 40, 255) : colors.rgba (255, 255, 255, 255))
		visible:        		isLoaded
	}

	Rectangle {
		id: 					stripeborderright_line
		width:					1
		anchors.right:  		parent.right
		anchors.bottom: 		stripe.bottom
		anchors.bottomMargin: 	-1
		height:         		stripe.height + 2
      	color:  				deckSizeState == "small" ? colors.rgba (20, 20, 20, 255) : (deckSizeState == "large" ? colors.rgba (40, 40, 40, 255) : colors.rgba (255, 255, 255, 255))
		visible:        		isLoaded
	}

	WF.Stripe {
		id: stripe
		anchors.left:           stripeborderleft_line.right
		anchors.right:          stripeborderright_line.left
		anchors.top:        	deckSizeState == "small" ? parent.top : seperationWaveStripe_line.bottom
		anchors.topMargin:  	deckSizeState == "small" ? 3 : 0
		anchors.leftMargin:     1
		anchors.rightMargin:    1
		height:                 31
		deckId:                 trackDeck.deckId
		windowSampleWidth:      trackDeck.sampleWidth
		
//		deckSizeState:			trackdeck.deckSizeState

		audioStreamKey: deckTypeValid(deckType.value) ? ["PrimaryKey", primaryKey.value] : ["PrimaryKey", 0]
		function deckTypeValid(deckType)      { return (deckType == DeckType.Track || deckType == DeckType.Stem);  }
		Behavior on anchors.bottomMargin { PropertyAnimation {  duration: durations.deckTransition } }
		opacity : deckSizeState == "small" ? 0.35 : 1
	}


	// ###########################################
	// ### ADD SEPERATION LINE BELOW-STRIPE    ###
	// ###########################################
	Rectangle {
    	id:						seperationStripe_line
    	width:  				parent.width
    	height: 				1
    	anchors.right: 			parent.right
    	anchors.left: 			parent.left
    	anchors.top:       		stripe.bottom
    	anchors.topMargin: 		1
    	
      	color:  				deckSizeState == "small" ? colors.rgba (20, 20, 20, 255) : (deckSizeState == "large" ? colors.rgba (40, 40, 40, 255) : colors.rgba (255, 255, 255, 255))
   		visible:				isLoaded	// MAKE VISIBLE WHEN TRACK/STEM LOADED
  	}

  //--------------------------------------------------------------------------------------------------------------------
  // Empty Deck
  //--------------------------------------------------------------------------------------------------------------------

  // Image (Logo) for empty Track Deck  --------------------------------------------------------------------------------

  Image {
    id: emptyTrackDeckImage
    anchors.fill:         parent
    anchors.bottomMargin: 18
    anchors.topMargin:    5
    visible:              false // visibility is handled through the emptyTrackDeckImageColorOverlay
    source:               "./../images/EmptyDeck.png"
    fillMode:             Image.PreserveAspectFit
  }

  // Deck color for empty deck image  ----------------------------------------------------------------------------------

  ColorOverlay {
    id: emptyTrackDeckImageColorOverlay
    anchors.fill: emptyTrackDeckImage
    color:        deckColor
    visible:      (!trackIsLoaded && deckSizeState != "small")
    source:       emptyTrackDeckImage
  }

}
