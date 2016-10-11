import QtQuick 2.0
import CSI 1.0
import Traktor.Gui 1.0 as Traktor
import './../Definitions' as Definitions
import './../Widgets' as Widgets 
import '../../../Defines'


//------------------------------------------------------------------------------------------------------------------
//  LIST ITEM - DEFINES THE INFORMATION CONTAINED IN ONE LIST ITEM
//------------------------------------------------------------------------------------------------------------------
Rectangle {
  id: footer

  property string propertiesPath: ""
  property real  sortingKnobValue: 0.0
  property bool  isContentList:    qmlBrowser.isContentList
  
  // the given numbers are determined by the EContentListColumns in Traktor
  readonly property variant sortIds:          [0 ,  2     ,   3     ,  5   ,  28  ,  22     ,  27          ]
  readonly property variant sortNames:        ["Sort By #", "Title", "Artist", "BPM", "Key", "Rating", "Import Date"]
  readonly property int     selectedFooterId: (selectedFooterItem.value === undefined) ? 0 : ( ( selectedFooterItem.value % 2 === 1 ) ? 1 : 4 ) // selectedFooterItem.value takes values from 1 to 4.
  
  property          real    preSortingKnobValue: 0.0

  //--------------------------------------------------------------------------------------------------------------------  

  AppProperty { id: previewIsLoaded;     path : "app.traktor.browser.preview_player.is_loaded" }
  AppProperty { id: previewTrackLenght;  path : "app.traktor.browser.preview_content.track_length" }
  AppProperty { id: previewTrackElapsed; path : "app.traktor.browser.preview_player.elapsed_time" }

  MappingProperty { id: overlayState;      path: propertiesPath + ".overlay" }
  MappingProperty { id: isContentListProp; path: propertiesPath + ".browser.is_content_list" }
  MappingProperty { id: selectedFooterItem;      path: propertiesPath + ".selected_footer_item" }


  //beats to cue implementaion
  	property int deckCode: screen.focusDeckId>1?screen.focusDeckId-2:screen.focusDeckId;
	AppProperty { id: propTrackBpm_AB;	path: "app.traktor.decks." + (deckCode+1) + ".content.bpm"; } 
	AppProperty { id: propElapsedTime_AB; path: "app.traktor.decks." + (deckCode+1) + ".track.player.elapsed_time"; } 
	AppProperty { id: propNextCuePoint_AB; path: "app.traktor.decks." + (deckCode+1) + ".track.player.next_cue_point"; }
	AppProperty { id: propTrackLength_AB; path: "app.traktor.decks." + (deckCode+1) + ".track.content.track_length"; }
	AppProperty { id: propTrackBpm_CD;	path: "app.traktor.decks." + (deckCode+3) + ".content.bpm"; } 
	AppProperty { id: propElapsedTime_CD; path: "app.traktor.decks." + (deckCode+3) + ".track.player.elapsed_time"; } 
	AppProperty { id: propNextCuePoint_CD; path: "app.traktor.decks." + (deckCode+3) + ".track.player.next_cue_point"; }
	AppProperty { id: propTrackLength_CD; path: "app.traktor.decks." + (deckCode+3) + ".track.content.track_length"; }
	readonly property double cuePos_AB: (propNextCuePoint_AB.value >= 0) ? propNextCuePoint_AB.value : propTrackLength_AB.value*1000
	readonly property double cuePos_CD: (propNextCuePoint_CD.value >= 0) ? propNextCuePoint_CD.value : propTrackLength_CD.value*1000
	readonly property int phraseLength: 4
	readonly property int beatLength: 4
	readonly property int yellowPhraseWarning: 12 //threshold for yellow beats to cue warning
	readonly property int redPhraseWarning: 8 //threshold for red beats to cue warning

  	function nextCueBeat_stringCalc_browser(column) {  		
  		if(column==1)
  		{	
  			var deckLetter=deckCode==0?"A: ":"B: ";  		
			var beat = ((propElapsedTime_AB.value*1000-cuePos_AB)*propTrackBpm_AB.value)/60000.0
		}
		else
		{
			var deckLetter=deckCode==0?"C: ":"D: ";
			var beat = ((propElapsedTime_CD.value*1000-cuePos_CD)*propTrackBpm_CD.value)/60000.0
		}
		var curBeat  = parseInt(beat);
		if (beat < 0.0) { curBeat = curBeat*-1; }
		var value1 = parseInt(((curBeat/beatLength)/phraseLength)+1);
		var value2 = parseInt(((curBeat/beatLength)%phraseLength)+1);
		var value3 = parseInt( (curBeat%beatLength)+1);
		if (beat < 0.0) { return deckLetter + "-" + value1.toString() + ":" + value2.toString() + "." + value3.toString(); }
		return deckLetter + value1.toString() + "." + value2.toString() + "." + value3.toString();	
	}

	function nextCueBeat_colorCalc_browser(column) {  
		if(column==1)			 		
			var beat = ((propElapsedTime_AB.value*1000-cuePos_AB)*propTrackBpm_AB.value)/60000.0
		else
			var beat = ((propElapsedTime_CD.value*1000-cuePos_CD)*propTrackBpm_CD.value)/60000.0
		var curBeat  = parseInt(beat);
		if (beat < 0.0) { curBeat = curBeat*-1; }
		var value1 = parseInt(((curBeat/beatLength)/phraseLength)+1);
		return (value1<redPhraseWarning + 1 && beat < 0.0) ? "red" : ((value1 < yellowPhraseWarning + 1 && beat < 0.0) ? "yellow" : colors.colorFontBrowserHeader);
	}
	//end beats to cue implementation
	

  //--------------------------------------------------------------------------------------------------------------------  
  // Behavior on Sorting Chnages (show/hide sorting widget, select next allowed sorting)
  //--------------------------------------------------------------------------------------------------------------------  

  onIsContentListChanged: { 
    // We need this to be able do disable mappings (e.g. sorting ascend/descend) 
    isContentListProp.value = isContentList; 
  }

  onSortingKnobValueChanged: { 
    if (!footer.isContentList)
    return;

    overlayState.value = Overlay.sorting;
    sortingOverlayTimer.restart();

    var val = clamp(footer.sortingKnobValue - footer.preSortingKnobValue, -1, 1);
    val     = parseInt(val);
    if (val != 0) {
      qmlBrowser.sortingId   = getSortingIdWithDelta( val );
      footer.preSortingKnobValue = footer.sortingKnobValue;   
    }
  }


  Timer {
    id: sortingOverlayTimer
    interval: 800  // duration of the scrollbar opacity
    repeat:   false

    onTriggered: overlayState.value = Overlay.none;
  }


  //--------------------------------------------------------------------------------------------------------------------  
  // View
  //--------------------------------------------------------------------------------------------------------------------  

  clip: true
  anchors.left:   parent.left
  anchors.right:  parent.right
  anchors.bottom: parent.bottom
  height:         21 // set in state
  color:  				colors.rgba (255, 255, 255, 32)


  // background color
  Rectangle {
    id: browserFooterBg
    anchors.left:   parent.left
    anchors.right:  parent.right
    anchors.bottom: parent.bottom
    height:         21
    color:          colors.colorBrowserHeader // footer background color
  }

  Row {
    id: sortingRow
    anchors.left:   browserFooterBg.left
    anchors.leftMargin: 1
    anchors.top:  browserFooterBg.top

    Item {
      width:  120
      height: 21

      Text {
        font.pixelSize: fonts.scale(12) 
        anchors.left: parent.left
        anchors.leftMargin:     3
        font.capitalization: Font.AllUppercase
        color: selectedFooterId == 1 ? "white" : colors.colorFontBrowserHeader
        text:  getSortingNameForSortId(qmlBrowser.sortingId)
        visible: qmlBrowser.isContentList
      }
      // Arrow (Sorting Direction Indicator)
      Widgets.Triangle { 
        id : sortDirArrow
        width:  8
        height: 4
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin:  6
        anchors.rightMargin: 6
        antialiasing: false
        visible: (qmlBrowser.isContentList && qmlBrowser.sortingId > 0)
        color: colors.colorGrey80
        rotation: ((qmlBrowser.sortingDirection == 1) ? 0 : 180) 
      }
      Rectangle {
        id: divider
        height: 21
        width: 1
        color: colors.colorGrey40 // footer divider color
        anchors.right: parent.right
      }
    }

    Item { //Beats to cue for Deck A or B
        width:  120
        height: 21
        Text {
          font.pixelSize: fonts.scale(12) 
          anchors.left:   parent.left
          anchors.leftMargin: 3
          font.capitalization: Font.AllUppercase
          color: nextCueBeat_colorCalc_browser(1)
		  text: nextCueBeat_stringCalc_browser(1) 
        }

        Rectangle {
          id: dividerA
          height: 21
          width: 1
          color: colors.colorGrey40 // footer divider color
          anchors.right: parent.right
        }
    }


    Item { //Beats to cue for Deck C or D
        width:  120
        height: 21
        Text {
          font.pixelSize: fonts.scale(12) 
          anchors.left:   parent.left
          anchors.leftMargin: 3
          font.capitalization: Font.AllUppercase
          color: nextCueBeat_colorCalc_browser(2)
		  text: nextCueBeat_stringCalc_browser(2)
        }

        Rectangle {
          id: dividerB
          height: 21
          width: 1
          color: colors.colorGrey40 // footer divider color
          anchors.right: parent.right
        }
    } 

    // Preview Player footer
    Item {
      width:  120
      height: 21

      Text {
        font.pixelSize: fonts.scale(12) 
        anchors.left: parent.left
        anchors.leftMargin: 5
        font.capitalization: Font.AllUppercase
        color: selectedFooterId == 4 ? "white" : colors.colorFontBrowserHeader
        text: "Preview"
      }

      Image {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin:     2
        anchors.rightMargin:  45
        visible: previewIsLoaded.value
        antialiasing: false
        source: "./../images/PreviewIcon_Small.png"
        fillMode: Image.Pad
        clip: true
        cache: false
        sourceSize.width: width
        sourceSize.height: height
      }
      Text {
        width: 40
        clip: true
        horizontalAlignment: Text.AlignRight
        visible: previewIsLoaded.value
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin:     2
        anchors.rightMargin:  7
        font.pixelSize: fonts.scale(12)
        font.capitalization: Font.AllUppercase
        font.family: "Pragmatica"
        color: colors.browser.prelisten
        text: utils.convertToTimeString(previewTrackElapsed.value)
      }
    }
  }

  //--------------------------------------------------------------------------------------------------------------------  
  // black border & shadow
  //--------------------------------------------------------------------------------------------------------------------  

  Rectangle {    
    id: browserHeaderBottomGradient
    height:         3
    anchors.left:   parent.left
    anchors.right:  parent.right
    anchors.bottom: browserHeaderBlackBottomLine.top
    gradient: Gradient {
      GradientStop { position: 0.0; color: colors.colorBlack0 }
      GradientStop { position: 1.0; color: colors.colorBlack38 }
    }
  }

  Rectangle {
    id: browserHeaderBlackBottomLine
    height:         2
    color:          colors.colorBlack
    anchors.left:   parent.left
    anchors.right:  parent.right
    anchors.bottom: browserFooterBg.top
  }

  //------------------------------------------------------------------------------------------------------------------

  state: "show"  
  states: [
  State {
    name: "show"
    PropertyChanges{ target: footer; height: 21 }
    },
    State {
      name: "hide"
      PropertyChanges{ target: footer; height: 0 }
    }
    ]


    //--------------------------------------------------------------------------------------------------------------------  
    // Necessary Functions
    //--------------------------------------------------------------------------------------------------------------------  

    function getSortingIdWithDelta( delta ) 
    {
      var curPos = getPosForSortId( qmlBrowser.sortingId );
      var pos    = curPos + delta;
      var count  = sortIds.length;

      pos = (pos < 0)      ? count-1 : pos;
      pos = (pos >= count) ? 0       : pos;

      return sortIds[pos];
    }


    function getPosForSortId(id) {
      if (id == -1) return 0; // -1 is a special case which should be interpreted as "0"
      for (var i=0; i<sortIds.length; i++) {
        if (sortIds[i] == id) return i;
      }
      return -1;
    }


    function getSortingNameForSortId(id) {
      var pos = getPosForSortId(id);
      if (pos >= 0 && pos < sortNames.length)
      return sortNames[pos];
      return "SORTED";
    }


    function clamp(val, min, max){
      return Math.max( Math.min(val, max) , min );
    }

  }
