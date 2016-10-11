import QtQuick 2.0
import CSI 1.0
import Traktor.Gui 1.0 as Traktor
import './../Definitions' as Definitions
import './../Widgets' as Widgets 
import '../../../Defines'

//------------------------------------------------------------------------------------------------------------------
//  LIST ITEM - DEFINES THE INFORMATION CONTAINED IN ONE LIST ITEM
//------------------------------------------------------------------------------------------------------------------
Item {
	id: detailsDelegate
	
  	property int        screenFocus:           	0

	property string		propArtistName:			model.artistName
	property string		propTrackName:			model.trackName
	property string		propTrackBPM:			model.bpm.toFixed(2)

	readonly property variant ratingMap:      	{ '-1' : 0, '0' : 0, '51': 1, '102': 2, '153' : 3, '204' : 4, '255': 5 }
	readonly property int nrRatings: 			5
	property int trackRating:					model.rating

	anchors.left:   							parent.left
	anchors.right:  							parent.right
	height:										39

	AppProperty { id: loadPreviewPlayer;  	path: "app.traktor.browser.preview_player.load_or_play" }
  	AppProperty { id: previewTrackLenght;  	path: "app.traktor.browser.preview_content.track_length" }

	AppProperty { id: propLegacyKey_DeckA; 	path: "app.traktor.decks.1.content.legacy_key" }
	AppProperty { id: propLegacyKey_DeckB; 	path: "app.traktor.decks.2.content.legacy_key" }
	AppProperty { id: propLegacyKey_DeckC; 	path: "app.traktor.decks.3.content.legacy_key" }
	AppProperty { id: propLegacyKey_DeckD; 	path: "app.traktor.decks.4.content.legacy_key" }


	// ######################
	// ### FUNCTIONS USED ###
	// ######################

	// ### Convert NI & camelot Keys to CAMELOT key format
	function convertToCamelot(inputKey) {
		// Minor Keys
		
		//  CAMELOT WITH 0			CAMELOT					OPEN KEY	 			MUSICAL KEY				MUSICAL KEY SHARP			DISPLAY VALUE
		if (inputKey == "01A" || 	inputKey ==  "1A" || 	inputKey ==  "6m" || 	inputKey ==  "Abm" || 	inputKey ==  "G#m") 	{	return "01A"; }
		if (inputKey == "02A" || 	inputKey ==  "2A" || 	inputKey ==  "7m" || 	inputKey ==  "Ebm" || 	inputKey ==  "D#m") 	{	return "02A"; }
		if (inputKey == "03A" || 	inputKey ==  "3A" || 	inputKey ==  "8m" || 	inputKey ==  "Bbm" || 	inputKey ==  "A#m") 	{	return "03A"; }
		if (inputKey == "04A" || 	inputKey ==  "4A" || 	inputKey ==  "9m" || 	inputKey ==  "Fm"  || 	inputKey ==  "Fm" ) 	{	return "04A"; }
		if (inputKey == "05A" || 	inputKey ==  "5A" || 	inputKey == "10m" || 	inputKey ==  "Cm"  || 	inputKey ==  "Cm" ) 	{	return "05A"; }
		if (inputKey == "06A" || 	inputKey ==  "6A" || 	inputKey == "11m" || 	inputKey ==  "Gm"  || 	inputKey ==  "Gm" ) 	{	return "06A"; }
		if (inputKey == "07A" || 	inputKey ==  "7A" || 	inputKey == "12m" || 	inputKey ==  "Dm"  || 	inputKey ==  "Dm" ) 	{	return "07A"; }
		if (inputKey == "08A" || 	inputKey ==  "8A" || 	inputKey ==  "1m" || 	inputKey ==  "Am"  || 	inputKey ==  "Am" ) 	{	return "08A"; }
		if (inputKey == "09A" || 	inputKey ==  "9A" || 	inputKey ==  "2m" || 	inputKey ==  "Em"  || 	inputKey ==  "Em" ) 	{	return "09A"; }
		if (inputKey == "10A" || 	inputKey == "10A" || 	inputKey ==  "3m" || 	inputKey ==  "Bm"  || 	inputKey ==  "Bm" ) 	{	return "10A"; }
		if (inputKey == "11A" || 	inputKey == "11A" || 	inputKey ==  "4m" || 	inputKey ==  "Gbm" || 	inputKey ==  "F#m") 	{	return "11A"; }
		if (inputKey == "12A" || 	inputKey == "12A" || 	inputKey ==  "5m" || 	inputKey ==  "Dbm" || 	inputKey ==  "C#m")		{	return "12A"; }

		// Major Keys
		
		//  CAMELOT WITH 0			CAMELOT					OPEN KEY	 			MUSICAL KEY				MUSICAL KEY SHARP			DISPLAY VALUE
		if (inputKey == "01B" || 	inputKey ==  "1B" || 	inputKey ==  "6d" || 	inputKey ==  "B"   || 	inputKey ==  "B"  ) 	{	return "01B"; }
		if (inputKey == "02B" || 	inputKey ==  "2B" || 	inputKey ==  "7d" || 	inputKey ==  "Gb"  || 	inputKey ==  "F#" ) 	{	return "02B"; }
		if (inputKey == "03B" || 	inputKey ==  "3B" || 	inputKey ==  "8d" || 	inputKey ==  "Db"  || 	inputKey ==  "C#" ) 	{	return "03B"; }
		if (inputKey == "04B" || 	inputKey ==  "4B" || 	inputKey ==  "9d" || 	inputKey ==  "Ab"  || 	inputKey ==  "G#" ) 	{	return "04B"; }
		if (inputKey == "05B" || 	inputKey ==  "5B" || 	inputKey == "10d" || 	inputKey ==  "Eb"  || 	inputKey ==  "D#" ) 	{	return "05B"; }
		if (inputKey == "06B" || 	inputKey ==  "6B" || 	inputKey == "11d" || 	inputKey ==  "Bb"  || 	inputKey ==  "A#" ) 	{	return "06B"; }
		if (inputKey == "07B" || 	inputKey ==  "7B" || 	inputKey == "12d" || 	inputKey ==  "F"   || 	inputKey ==  "F"  ) 	{	return "07B"; }
		if (inputKey == "08B" || 	inputKey ==  "8B" || 	inputKey ==  "1d" || 	inputKey ==  "C"   || 	inputKey ==  "C"  ) 	{	return "08B"; }
		if (inputKey == "09B" || 	inputKey ==  "9B" || 	inputKey ==  "2d" || 	inputKey ==  "G"   || 	inputKey ==  "G"  ) 	{	return "09B"; }
		if (inputKey == "10B" || 	inputKey == "10B" || 	inputKey ==  "3d" || 	inputKey ==  "D"   || 	inputKey ==  "D"  ) 	{	return "10B"; }
		if (inputKey == "11B" || 	inputKey == "11B" || 	inputKey ==  "4d" || 	inputKey ==  "A"   || 	inputKey ==  "A"  ) 	{	return "11B"; }
		if (inputKey == "12B" || 	inputKey == "12B" || 	inputKey ==  "5d" || 	inputKey ==  "E"   || 	inputKey ==  "E"  )		{	return "12B"; }

		// No Key Found
		return "N.A.";
	}

	// ### Convert keys to numeric values (used in matchCamelot function)
	function convertCamelot(inputKey) {
		if (inputKey == "01A") {	return  1; }
		if (inputKey == "02A") {	return  2; }
		if (inputKey == "03A") {	return  3; }
		if (inputKey == "04A") {	return  4; }
		if (inputKey == "05A") {	return  5; }
		if (inputKey == "06A") {	return  6; }
		if (inputKey == "07A") {	return  7; }
		if (inputKey == "08A") {	return  8; }
		if (inputKey == "09A") {	return  9; }
		if (inputKey == "10A") {	return 10; }
		if (inputKey == "11A") {	return 11; }
		if (inputKey == "12A") {	return 12; }
		if (inputKey == "01B") {	return 21; }
		if (inputKey == "02B") {	return 22; }
		if (inputKey == "03B") {	return 23; }
		if (inputKey == "04B") {	return 24; }
		if (inputKey == "05B") {	return 25; }
		if (inputKey == "06B") {	return 26; }
		if (inputKey == "07B") {	return 27; }
		if (inputKey == "08B") {	return 28; }
		if (inputKey == "09B") {	return 29; }
		if (inputKey == "10B") {	return 30; }
		if (inputKey == "11B") {	return 31; }
		if (inputKey == "12B") {	return 32; }
	}

	// ### Convert keys to numeric values (used in matching)
	function matchCamelot(inputKey, deckKey) {
		// 0 : no match
		// 1 : two semitone energy jump match
		// 2 : full match
		// 3 : energy swap match
		// 4 : one semitone energy jump match

		// Energy Swap
		if (inputKey.charAt(2)=="A" && (parseInt(inputKey.substring(0,2)) + 3) % 12 == parseInt(deckKey.substring(0,2)) % 12 && deckKey.charAt(2)=="B")
			return 3;
		if (inputKey.charAt(2)=="B" && (parseInt(inputKey.substring(0,2)) + 9) % 12 == parseInt(deckKey.substring(0,2)) % 12 && deckKey.charAt(2)=="A")
			return 3;

		if (inputKey.charAt(2)==deckKey.charAt(2) && (((parseInt(inputKey.substring(0,2)) + 7) % 12 == parseInt(deckKey.substring(0,2)) % 12) || 
													  ((parseInt(inputKey.substring(0,2)) + 5) % 12 == parseInt(deckKey.substring(0,2)) % 12)))
			return 4;

		// Minor Keys
		if (convertCamelot(inputKey) == 1)
		{	if (convertCamelot(deckKey) == 1 || convertCamelot(deckKey) == 2 || convertCamelot(deckKey) == 12 || convertCamelot(deckKey) == 21)	{	return 2;}	 
			if (convertCamelot(deckKey) == 3 || convertCamelot(deckKey) == 11)	{	return 1;} 
		}
		if (convertCamelot(inputKey) == 2)
		{	if (convertCamelot(deckKey) == 2 || convertCamelot(deckKey) == 3 || convertCamelot(deckKey) == 1  || convertCamelot(deckKey) == 22)	{	return 2;}	 
			if (convertCamelot(deckKey) == 4 || convertCamelot(deckKey) == 12)	{	return 1;} 
		}
		if (convertCamelot(inputKey) > 2 && convertCamelot(inputKey) < 11)
		{	if (convertCamelot(deckKey) == convertCamelot(inputKey) || convertCamelot(deckKey) == convertCamelot(inputKey)+1 || convertCamelot(deckKey) == convertCamelot(inputKey)-1  || convertCamelot(deckKey) == convertCamelot(inputKey)+20)	{	return 2;}	 
			if (convertCamelot(deckKey) == convertCamelot(inputKey)+2 || convertCamelot(deckKey) == convertCamelot(inputKey)-2)	{	return 1;} 
		}
		if (convertCamelot(inputKey) == 11)
		{	if (convertCamelot(deckKey) == 11 || convertCamelot(deckKey) == 12 || convertCamelot(deckKey) == 10  || convertCamelot(deckKey) == 31)	{	return 2;}	 
			if (convertCamelot(deckKey) == 1 || convertCamelot(deckKey) == 9)	{	return 1;} 
		}
		if (convertCamelot(inputKey) == 12)
		{	if (convertCamelot(deckKey) == 12 || convertCamelot(deckKey) == 1 || convertCamelot(deckKey) == 11  || convertCamelot(deckKey) == 32)	{	return 2;}	 
			if (convertCamelot(deckKey) == 2 || convertCamelot(deckKey) == 10)	{	return 1;} 
		}
	
		// Major Keys
		if (convertCamelot(inputKey) == 21)
		{	if (convertCamelot(deckKey) == 21 || convertCamelot(deckKey) == 22 || convertCamelot(deckKey) == 32 || convertCamelot(deckKey) == 1)	{	return 2;}	 
			if (convertCamelot(deckKey) == 23 || convertCamelot(deckKey) == 31)	{	return 1;} 
		}
		if (convertCamelot(inputKey) == 22)
		{	if (convertCamelot(deckKey) == 22 || convertCamelot(deckKey) == 23 || convertCamelot(deckKey) == 21  || convertCamelot(deckKey) == 2)	{	return 2;}	 
			if (convertCamelot(deckKey) == 24 || convertCamelot(deckKey) == 12)	{	return 1;} 
		}
		if (convertCamelot(inputKey) > 22 && convertCamelot(inputKey) < 31)
		{	if (convertCamelot(deckKey) == convertCamelot(inputKey) || convertCamelot(deckKey) == convertCamelot(inputKey)+1 || convertCamelot(deckKey) == convertCamelot(inputKey)-1  || convertCamelot(deckKey) == convertCamelot(inputKey)-20)	{	return 2;}	 
			if (convertCamelot(deckKey) == convertCamelot(inputKey)+2 || convertCamelot(deckKey) == convertCamelot(inputKey)-2)	{	return 1;} 
		}
		if (convertCamelot(inputKey) == 31)
		{	if (convertCamelot(deckKey) == 31 || convertCamelot(deckKey) == 32 || convertCamelot(deckKey) == 30  || convertCamelot(deckKey) == 11)	{	return 2;}	 
			if (convertCamelot(deckKey) == 21 || convertCamelot(deckKey) == 29)	{	return 1;}	
		}
		if (convertCamelot(inputKey) == 32)
		{	if (convertCamelot(deckKey) == 32 || convertCamelot(deckKey) == 21 || convertCamelot(deckKey) == 31  || convertCamelot(deckKey) == 12)	{	return 2;}	 
			if (convertCamelot(deckKey) == 22 || convertCamelot(deckKey) == 30)	{	return 1;}	
		}
	
		return 0;
	}

	// ### Defines Deck Keys Text color
	function camelotTextColor(inputKey, deckKey) {
		//	when matched or energy matched
		if ((matchCamelot(inputKey, deckKey) == 2) || (matchCamelot(inputKey, deckKey) == 1) || (matchCamelot(inputKey, deckKey) == 3) || (matchCamelot(inputKey, deckKey) == 4)) {	return colors.rgba (255, 255, 255, 175); }
		
		//	when not applicable
		if (deckKey == "N.A.") { return colors.rgba (255, 255, 255, 16);}
		
		//	when not matched
		return colors.rgba (255, 255, 255, 64);
	}

	// ### Defines Deck Keys Background color
	function camelotBckgndColor(inputKey, deckKey, deckIndex) {
		//	when matched & not current browser deck
		if ((matchCamelot(inputKey, deckKey) == 2) && (screenFocus != deckIndex)) {	return colors.rgba (0, 220, 0, 128); }

		//	when two semitone energy matched & not current browser deck
		if ((matchCamelot(inputKey, deckKey) == 1) && (screenFocus != deckIndex)) {	return colors.rgba (255, 128, 0, 120); }

		//	when energy swap matched & not current browser deck
		if ((matchCamelot(inputKey, deckKey) == 3) && (screenFocus != deckIndex)) {	return colors.rgba (255, 0, 0, 120); }

		//	when one semitone energy matched & not current browser deck
		if ((matchCamelot(inputKey, deckKey) == 4) && (screenFocus != deckIndex)) {	return colors.rgba (255, 128, 0, 60); }
		
		//	when not matched
		return colors.rgba (255, 255, 255, 16);
	}


	// ##################
	// ### DRAW FRAME ###
	// ##################

	// Top Horizontal Line (full width)
	Rectangle {
		id: 					detailsFooter_topFull_horLine
		anchors.left: 			parent.left
    	anchors.leftMargin: 	1
		anchors.right: 			parent.right
		anchors.rightMargin: 	1
		anchors.top: 			parent.top
		anchors.topMargin: 		0
		width:					parent.width
		height:        			1
    	color:  				colors.rgba (255, 255, 255, 32)
	}

	// Bottom Horizontal Line (full width)
	Rectangle {
		id: 					detailsFooter_bottomFull_horLine
		anchors.left:  			parent.left
		anchors.leftMargin: 	1
		anchors.right: 			parent.right
		anchors.rightMargin: 	1
		anchors.bottom: 		parent.bottom
		anchors.bottomMargin: 	0
		width:					parent.width
		height:        			1
    	color:  				colors.rgba (255, 255, 255, 32)
	}

	// Vertical Line (full height) - Left of cover Image
	Rectangle {
		id: 					detailsFooter_coverLeft_verLine
		anchors.left: 			parent.left
		anchors.top: 			parent.top
		width:					1
		height:        			39
    	color:  				colors.rgba (255, 255, 255, 32)
    	visible:				true
	}

	// Vertical Line (full height) - Right of cover Image - Left of Artist/Title Field
	Rectangle {
		id: 					detailsFooter_coverRight_verLine
		anchors.left: 			detailsFooter_cover_bckgnd.right
    	anchors.leftMargin: 	1
		anchors.top: 			detailsFooter_topFull_horLine.bottom
		anchors.bottom:			detailsFooter_bottomFull_horLine.top
		width:					1
    	color:  				colors.rgba (255, 255, 255, 32)
		visible: 				(model.dataType == BrowserDataType.Track)
	}

	// Vertical Line (full height) - Right Artist/Title Field
	Rectangle {
		id: 					detailsFooter_artistRight_verLine
		anchors.left: 			detailsFooter_artist_bckgnd.right
    	anchors.leftMargin: 	1
		anchors.top: 			detailsFooter_topFull_horLine.bottom
		anchors.bottom:			detailsFooter_bottomFull_horLine.top
		width:					1
    	color:  				colors.rgba (255, 255, 255, 32)
		visible: 				(model.dataType == BrowserDataType.Track)
	}

	// Horizontal Line - Between BPM & Track Length
	Rectangle {
		id: 					detailsFooter_BPMtrackLength_HorLine
		anchors.left: 			detailsFooter_artistRight_verLine.right
		anchors.right: 			detailsFooter_BMPRight_verLine.left
		anchors.top: 			detailsFooter_BPM_bckgnd.bottom
    	anchors.topMargin: 		1
		height:					1
    	color:  				colors.rgba (255, 255, 255, 32)
		visible: 				(model.dataType == BrowserDataType.Track)
	}

	// Vertical Line (full height) - Right BMP/TrackLength Field
	Rectangle {
		id: 					detailsFooter_BMPRight_verLine
		anchors.left: 			detailsFooter_BPM_bckgnd.right
    	anchors.leftMargin: 	1
		anchors.top: 			detailsFooter_topFull_horLine.bottom
		anchors.bottom:			detailsFooter_bottomFull_horLine.top
		width:					1
    	color:  				colors.rgba (255, 255, 255, 32)
		visible: 				(model.dataType == BrowserDataType.Track)
	}

	// Horizontal Line - Track Key & Rating Length
	Rectangle {
		id: 					detailsFooter_trackKeyRating_HorLine
		anchors.left: 			detailsFooter_BMPRight_verLine.right
		anchors.right: 			detailsFooter_keysLeft_verLine.left
		anchors.top: 			detailsFooter_trackKey_bckgnd.bottom
    	anchors.topMargin: 		1
		height:					1
    	color:  				colors.rgba (255, 255, 255, 32)
		visible: 				(model.dataType == BrowserDataType.Track)
	}

	// Vertical Line (full height) - Left of Deck Keys
	Rectangle {
		id: 					detailsFooter_keysLeft_verLine
		anchors.right: 			detailsFooter_keyDeckA_bckgnd.left
    	anchors.rightMargin: 	1
		anchors.top: 			detailsFooter_topFull_horLine.bottom
		anchors.bottom:			detailsFooter_bottomFull_horLine.top
		width:					1
    	color:  				colors.rgba (255, 255, 255, 32)
		visible: 				(model.dataType == BrowserDataType.Track)
	}

	// Horizontal Line - Key Deck A & Key Deck C
	Rectangle {
		id: 					detailsFooter_keyDeckAkeyDeckC_HorLine
		anchors.left: 			detailsFooter_keysLeft_verLine.right
		anchors.right: 			detailsFooter_keysMiddle_verLine.left
		anchors.top: 			detailsFooter_keyDeckA_bckgnd.bottom
    	anchors.topMargin: 		1
		height:					1
    	color:  				colors.rgba (255, 255, 255, 16)
		visible: 				(model.dataType == BrowserDataType.Track)
	}

	// Vertical Line (full height) - Middle of Deck Keys
	Rectangle {
		id: 					detailsFooter_keysMiddle_verLine
		anchors.right: 			detailsFooter_keyDeckB_bckgnd.left
    	anchors.rightMargin: 	1
		anchors.top: 			detailsFooter_topFull_horLine.bottom
		anchors.bottom:			detailsFooter_bottomFull_horLine.top
		width:					1
    	color:  				colors.rgba (255, 255, 255, 16)
		visible: 				(model.dataType == BrowserDataType.Track)
	}

	// Horizontal Line - Key Deck B & Key Deck D
	Rectangle {
		id: 					detailsFooter_keyDeckBkeyDeckD_HorLine
		anchors.left: 			detailsFooter_keysMiddle_verLine.right
		anchors.right: 			detailsFooter_keysRight_verLine.left
		anchors.top: 			detailsFooter_keyDeckB_bckgnd.bottom
    	anchors.topMargin: 		1
		height:					1
    	color:  				colors.rgba (255, 255, 255, 16)
		visible: 				(model.dataType == BrowserDataType.Track)
	}

	// Vertical Line (full height) - Right of Keys
	Rectangle {
		id: 					detailsFooter_keysRight_verLine
		anchors.right: 			parent.right
		anchors.top: 			parent.top
		width:					1
		height:        			39
    	color:  				colors.rgba (255, 255, 255, 32)
	}

	// #######################
	// ### ADD COVER IMAGE ###
	// #######################

  	Rectangle {
    	id: 						detailsFooter_cover_bckgnd
    	anchors.top: 				parent.top
    	anchors.left: 				parent.left
    	anchors.topMargin: 			2
    	anchors.leftMargin: 		2
    	width:  					35
    	height: 					35
    	color:  					colors.rgba (255, 255, 255, 32)
		visible: 					(model.dataType == BrowserDataType.Track)
    	
    	// ### DRAW SYMBOL WHEN NO TRACK IS LOADED OR COVER IMAGE IS EMPTY
    	Rectangle {
      		id: 						detailsFooterCover_EmptyCircle
      		height: 					10
      		width: 						parent.width
      		radius: 					parent.height * 0.5
      		anchors.centerIn: 			parent
      		color: 						colors.rgba (255, 255, 255, 32)
    	}

    	Rectangle {
      		id: 						detailsFooterCover_EmptyCover
      		height: 					4
      		width: 						parent.width
      		radius: 					parent.height * 0.2
      		anchors.centerIn: 			parent
      		color:   					colors.rgba (255, 255, 255, 32)
    	}
		
		// ### LOAD COVER IMAGE WHEN TRACK/STEM AND COVER IMAGE IS NOT EMPTY
    	Image {
      		id: 						detailsFooterCover_Image
      		source: 					(model.dataType == BrowserDataType.Track) ? ("image://covers/" + model.coverUrl ) : ""
      		anchors.fill: 				parent
      		sourceSize.height: 			parent.height
      		sourceSize.width: 			parent.width
      		fillMode: 					Image.PreserveAspectCrop
    	}
  	}

	// ##############################
	// ### ADD ARTIST & SONGTITLE ###
	// ##############################

	Rectangle {
    	id:						detailsFooter_artist_bckgnd
    	width:					276
    	anchors.left: 			detailsFooter_coverRight_verLine.right
    	anchors.leftMargin: 	1
    	anchors.top:       		detailsFooter_topFull_horLine.bottom
    	anchors.topMargin: 		1
    	anchors.bottom:       	detailsFooter_bottomFull_horLine.top
    	anchors.bottomMargin: 	1
    	color:  				colors.rgba (255, 255, 255, 16)
		visible: 				(model.dataType == BrowserDataType.Track)

		Text {
			id: 					detailsFooter_songTitle_text
			text: 					propTrackName
			color:     				colors.rgba (255, 255, 255, 232)
			font.pixelSize:     	fonts.scale(13)
			anchors.left: 			detailsFooter_artist_bckgnd.left
			anchors.leftMargin: 	3
			anchors.top:    		detailsFooter_artist_bckgnd.top
			anchors.topMargin:  	0
			elide:      			Text.ElideRight
			width: 					detailsFooter_artist_bckgnd.width - 6
			clip: true
		}

		Text {
			id: 					detailsFooter_artist_text
			text: 					propArtistName
			color:     				colors.rgba (255, 255, 255, 64)
			font.pixelSize:     	fonts.scale(12)
			anchors.left: 			detailsFooter_artist_bckgnd.left
			anchors.leftMargin: 	3
			anchors.top:    		detailsFooter_artist_bckgnd.top
			anchors.topMargin:  	19
			elide:      			Text.ElideRight
			width: 					detailsFooter_artist_bckgnd.width - 6
			clip: true
		}
	}

	// ##############################
	// ### ADD BPM & TRACK LENGTH ###
	// ##############################

	// BPM
	Rectangle {
    	id:						detailsFooter_BPM_bckgnd
    	width:					50
    	anchors.left: 			detailsFooter_artistRight_verLine.right
    	anchors.leftMargin: 	1
    	anchors.top:       		detailsFooter_topFull_horLine.bottom
    	anchors.topMargin: 		1
		height:					16
    	color:  				colors.rgba (255, 255, 255, 16)
		visible: 				(model.dataType == BrowserDataType.Track)

		Text {
			id: 					detailsFooter_BPM_text
			text: 					propTrackBPM
			color:     				colors.rgba (255, 255, 255, 64)
			font.pixelSize:     	fonts.scale(12)
			anchors.horizontalCenter: detailsFooter_BPM_bckgnd.horizontalCenter
			anchors.top:    		detailsFooter_BPM_bckgnd.top
			anchors.topMargin:  	1
		}
	}

	// TRACK LENGTH
	Rectangle {
    	id:						detailsFooter_trackLength_bckgnd
    	width:					50
    	anchors.left: 			detailsFooter_artistRight_verLine.right
    	anchors.leftMargin: 	1
    	anchors.bottom:       	detailsFooter_bottomFull_horLine.top
    	anchors.bottomMargin: 	1
		height:					16
    	color:  				colors.rgba (255, 255, 255, 16)
		visible: 				(model.dataType == BrowserDataType.Track)

		Text {
			id: 					detailsFooter_trackLength_text
			text: 					utils.convertToTimeString(previewTrackLenght.value)
			color:     				colors.rgba (255, 255, 255, 64)
			font.pixelSize:     	fonts.scale(12)
			anchors.horizontalCenter: detailsFooter_trackLength_bckgnd.horizontalCenter
			anchors.top:    		detailsFooter_trackLength_bckgnd.top
			anchors.topMargin:  	1
		}
	}

	// ########################
	// ### ADD KEY & RATING ###
	// ########################

	// TRACK KEY
	Rectangle {
    	id:						detailsFooter_trackKey_bckgnd
    	width:					40
    	anchors.left: 			detailsFooter_BMPRight_verLine.right
    	anchors.leftMargin: 	1
    	anchors.top:       		detailsFooter_topFull_horLine.bottom
    	anchors.topMargin: 		1
		height:					16
    	color:  				colors.rgba (255, 255, 255, 16)
		visible: 				(model.dataType == BrowserDataType.Track)

		Text {
			id: 					detailsFooter_trackKey_text
			text: 					convertToCamelot(model.key)
			color:     				colors.rgba (255, 255, 255, 232)
			font.pixelSize:     	fonts.scale(12)
			anchors.horizontalCenter: detailsFooter_trackKey_bckgnd.horizontalCenter
			anchors.top:    		detailsFooter_trackKey_bckgnd.top
			anchors.topMargin:  	1
		}
	}

	// RATING
	Rectangle {
    	id:						detailsFooter_rating_bckgnd
    	width:					40
    	anchors.left: 			detailsFooter_BMPRight_verLine.right
    	anchors.leftMargin: 	1
    	anchors.bottom:       	detailsFooter_bottomFull_horLine.top
    	anchors.bottomMargin: 	1
		height:					16
    	color:  				colors.rgba (255, 255, 255, 16)
		visible: 				(model.dataType == BrowserDataType.Track)

		Rectangle {
			id: 						detailsFooter_rating_large
			anchors.left: 				detailsFooter_rating_bckgnd.left
			anchors.verticalCenter: 	detailsFooter_rating_bckgnd.verticalCenter
    		anchors.leftMargin: 		3
			height:                 	14
			width:                  	rowLarge.width + 2
			color:                  	colors.rgba (0, 0, 0, 16)
			visible:                	trackRating > 0 // -1 is also possible if rating has never been set!

			Row {
				id: 				rowLarge
				anchors.left:       parent.left
				anchors.top:        parent.top
				anchors.leftMargin: 1
				height:             parent.height
				spacing:            3

				Repeater {
					model: (ratingMap[trackRating] == undefined) ? 0 : ratingMap[trackRating]
					Rectangle {
						width:                  	4
						height:                 	detailsFooter_rating_large.height - 2
						anchors.verticalCenter: 	rowLarge.verticalCenter
						color:                  	colors.rgba (255, 255, 255, 64)
					}
				}
			}
		}

		Rectangle {
			id: 					detailsFooter_rating_small
			anchors.left: 			detailsFooter_rating_large.right
			anchors.verticalCenter: detailsFooter_rating_bckgnd.verticalCenter
			height:                 detailsFooter_rating_bckgnd.height  - 10
			width:                  rowSmall.width + 2
			color:                  colors.rgba (0, 0, 0, 16)
			visible:                ratingMap[trackRating] < nrRatings

			Row {
				id: 				rowSmall
				anchors.left:       parent.left
				anchors.top:        parent.top
				anchors.leftMargin: 1
				height:             parent.height
				spacing:            2

				Repeater {
					model: (ratingMap[trackRating] == undefined) ? nrRatings : (nrRatings - ratingMap[trackRating])
					Rectangle {
						width:                  4
						height:                 detailsFooter_rating_small.height - 2
						anchors.verticalCenter: rowSmall.verticalCenter
						color:                  colors.rgba (255, 255, 255, 64)
					}
				}
			}
		}
	}

	// #####################
	// ### KEY DETECTION ###
	// #####################

	// DECK A KEY DETECTION
	Rectangle {
    	id:						detailsFooter_keyDeckA_bckgnd
    	width:					30
    	anchors.right: 			detailsFooter_keysMiddle_verLine.left
    	anchors.rightMargin: 	1
    	anchors.top:       		detailsFooter_topFull_horLine.bottom
    	anchors.topMargin: 		1
		height:					16
    	color:  				camelotBckgndColor(detailsFooter_trackKey_text.text, detailsFooterKeyDeckA_text.text, 0)
		visible: 				(model.dataType == BrowserDataType.Track)

		Text {
			id: 					detailsFooterKeyDeckA_text
			text: 					convertToCamelot(propLegacyKey_DeckA.value)
			color:  				camelotTextColor(detailsFooter_trackKey_text.text, detailsFooterKeyDeckA_text.text)
			font.pixelSize:     	fonts.scale(12)
			anchors.horizontalCenter: detailsFooter_keyDeckA_bckgnd.horizontalCenter
			anchors.top:    		detailsFooter_keyDeckA_bckgnd.top
			anchors.topMargin:  	1
			visible:     			screenFocus != 0
		}
	}

	// DECK B KEY DETECTION
	Rectangle {
    	id:						detailsFooter_keyDeckB_bckgnd
    	width:					30
    	anchors.right: 			detailsFooter_keysRight_verLine.left
    	anchors.rightMargin: 	1
    	anchors.top:       		detailsFooter_topFull_horLine.bottom
    	anchors.topMargin: 		1
		height:					16
    	color:  				camelotBckgndColor(detailsFooter_trackKey_text.text, detailsFooterKeyDeckB_text.text, 1)
		visible: 				(model.dataType == BrowserDataType.Track)

		Text {
			id: 					detailsFooterKeyDeckB_text
			text: 					convertToCamelot(propLegacyKey_DeckB.value)
			color:  				camelotTextColor(detailsFooter_trackKey_text.text, detailsFooterKeyDeckB_text.text)
			font.pixelSize:     	fonts.scale(12)
			anchors.horizontalCenter: detailsFooter_keyDeckB_bckgnd.horizontalCenter
			anchors.top:    		detailsFooter_keyDeckB_bckgnd.top
			anchors.topMargin:  	1
			visible:     			screenFocus != 1
		}
	}

	// DECK C KEY DETECTION
	Rectangle {
    	id:						detailsFooter_keyDeckC_bckgnd
    	width:					30
    	anchors.right: 			detailsFooter_keysMiddle_verLine.left
    	anchors.rightMargin: 	1
    	anchors.bottom:       	detailsFooter_bottomFull_horLine.top
    	anchors.bottomMargin: 	1
		height:					16
    	color:  				camelotBckgndColor(detailsFooter_trackKey_text.text, detailsFooterKeyDeckC_text.text, 2)
		visible: 				(model.dataType == BrowserDataType.Track)

		Text {
			id: 					detailsFooterKeyDeckC_text
			text: 					convertToCamelot(propLegacyKey_DeckC.value)
			color:  				camelotTextColor(detailsFooter_trackKey_text.text, detailsFooterKeyDeckC_text.text)
			font.pixelSize:     	fonts.scale(12)
			anchors.horizontalCenter: detailsFooter_keyDeckC_bckgnd.horizontalCenter
			anchors.top:    		detailsFooter_keyDeckC_bckgnd.top
			anchors.topMargin:  	1
			visible:     			screenFocus != 2
		}
	}

	// DECK D KEY DETECTION
	Rectangle {
    	id:						detailsFooter_keyDeckD_bckgnd
    	width:					30
    	anchors.right: 			detailsFooter_keysRight_verLine.left
    	anchors.rightMargin: 	1
    	anchors.bottom:       	detailsFooter_bottomFull_horLine.top
    	anchors.bottomMargin: 	1
		height:					16
    	color:  				camelotBckgndColor(detailsFooter_trackKey_text.text, detailsFooterKeyDeckD_text.text, 3)
		visible: 				(model.dataType == BrowserDataType.Track)

		Text {
			id: 					detailsFooterKeyDeckD_text
			text: 					convertToCamelot(propLegacyKey_DeckD.value)
			color:  				camelotTextColor(detailsFooter_trackKey_text.text, detailsFooterKeyDeckD_text.text)
			font.pixelSize:     	fonts.scale(12)
			anchors.horizontalCenter: detailsFooter_keyDeckD_bckgnd.horizontalCenter
			anchors.top:    		detailsFooter_keyDeckD_bckgnd.top
			anchors.topMargin:  	1
			visible:     			screenFocus != 3
		}
	}
}