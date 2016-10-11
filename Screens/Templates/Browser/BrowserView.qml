import CSI 1.0
import QtQuick 2.0
import Traktor.Gui 1.0 as Traktor

import './../' as Templates
import './../../Views/Browser' as BrowserView
import './../../Views/Widgets' as Widgets

//----------------------------------------------------------------------------------------------------------------------
//                                            BROWSER VIEW
//
//  The Browser View is connected to traktors QBrowser from which it receives its data model. The navigation through the
//  data is done by calling funcrtions invoked from QBrowser.
//----------------------------------------------------------------------------------------------------------------------

Templates.View {
	id: qmlBrowser

	property string propertiesPath: 		""
	property bool  isActive:      			false
	property bool  enterNode:     			false
	property bool  exitNode:      			false
	property int   increment:     			0
	property color focusColor:    			(screen.focusDeckId < 2) ? colors.colorDeckBlueBright : "white" 
	property int   speed:         			150
	property real  sortingKnobValue:  		0
	property int   pageSize:          		7
	property int   fastScrollCenter:  		3

	readonly property int maxItemsOnScreen: 9

	// This is used by the footer to change/display the sorting!
	property alias sortingId:         		browser.sorting
	property alias sortingDirection:  		browser.sortingDirection
	property alias isContentList:     		browser.isContentList

	anchors.fill: parent

	// #######################
	// ### SCROLL FUNCTION ###
	// #######################

	onIncrementChanged: {
		if (qmlBrowser.increment != 0) {
			var newValue = clamp(browser.currentIndex + qmlBrowser.increment, 0, contentList.count - 1);

			// Center Selection when scrolling holding SHIFT key (Fast scrolling)
			if (qmlBrowser.increment >= pageSize) {
				var centerTop = fastScrollCenter;
				if(browser.currentIndex < centerTop) { newValue = centerTop; }
			}

			if (qmlBrowser.increment <= (-pageSize)) {
				var centerBottom = contentList.count - 1 - fastScrollCenter;
				if (browser.currentIndex > centerBottom) { newValue = centerBottom; }
			}

			browser.changeCurrentIndex(newValue);
			qmlBrowser.increment = 0;
			doScrolling();
		}      
	}

	// Clamp function used in onIncrementChanged
	function clamp(val, min, max){
		return Math.max(min, Math.min(val, max));
	}

	onExitNodeChanged: {
		if (qmlBrowser.exitNode) {  browser.exitNode() }
		qmlBrowser.exitNode = false;
	}

	onEnterNodeChanged: {
		if (qmlBrowser.enterNode) {
			var movedDown = browser.enterNode(screen.focusDeckId, contentList.currentIndex);
			if (movedDown) { browser.relocateCurrentIndex() }
		}
		qmlBrowser.enterNode = false;
	}

	// ###############
	// ### BROWSER ###
	// ###############

	Traktor.Browser	{
		id: 						browser
		isActive: 					qmlBrowser.isActive
	}
 
	// ######################
	// ### BROWSER HEADER ###
	// ######################

	BrowserView.BrowserHeader {
		id: 						browserHeader
		nodeIconId:     			browser.dataSet.iconId
		currentDeck:    			screen.focusDeckId
		state:          			"show"
		pathStrings:    			browser.currentPath 
	}


	// #########################
	// ### BROWSER LIST VIEW ###
	// #########################

	ListView {
		id: 						contentList
		verticalLayoutDirection: 	ListView.TopToBottom
		anchors.left:   			parent.left
		anchors.right:  			contentList_lineMiddleVer.right
		anchors.rightMargin:		0
		anchors.top: 				browserHeader.bottom
		anchors.topMargin:       	0
		anchors.bottom: 			detailsList.top
		anchors.bottomMargin:    	1

		delegate:                	BrowserView.ListDelegate  {id: listDelegate; screenFocus: screen.focusDeckId; }
		model:                   	browser.dataSet
		currentIndex:            	browser.currentIndex 

		clip:                    	true
		cacheBuffer:             	0
		spacing:                 	0
		preferredHighlightBegin: 	84
		preferredHighlightEnd  : 	105

		highlightRangeMode :     	ListView.ApplyRange
		highlightMoveDuration:   	0
		focus:                   	true 
		interactive: 				true
		
		highlight: 					contentList_highlightBar
        highlightFollowsCurrentItem: 	true
	}

 	Component {
        id: contentList_highlightBar

        Rectangle {
			anchors.left:   			parent.left
			anchors.leftMargin:			2
			anchors.right:  			parent.right
			anchors.rightMargin:		2
            height: 					21
            color: 						colors.rgba (255, 255, 255, 64)
            y: 							listView.currentItem.y;
		}
    }
 
 	Rectangle {
 		id: 						contentList_lineLeftVer
 		anchors.left: 				parent.left
 		anchors.top: 				browserHeader.bottom
 		anchors.topMargin:       	-1
 		anchors.bottom: 			detailsList.top
 		anchors.bottomMargin:    	0
 		width:						1
     	color:  					colors.rgba (255, 255, 255, 32)
 	}
 
 	Rectangle {
 		id: 						contentList_lineMiddleVer
 		anchors.right: 				parent.right
 		anchors.rightMargin:       	19
 		anchors.top: 				browserHeader.bottom
 		anchors.topMargin:       	-1
 		anchors.bottom: 			detailsList.top
 		anchors.bottomMargin:    	0
 		width:						1
     	color:  					colors.rgba (255, 255, 255, 32)
 	}

 	Rectangle {
 		id: 						contentList_lineRightVer
 		anchors.right: 				parent.right
 		anchors.rightMargin:       	0
 		anchors.top: 				browserHeader.bottom
 		anchors.topMargin:       	-1
 		anchors.bottom: 			detailsList.top
 		anchors.bottomMargin:    	0
 		width:						1
     	color:  					colors.rgba (255, 255, 255, 32)
 	}

	// #######################################
	// ### SELECTED TRACK - DETAILS FOOTER ###
	// #######################################

  	ListView {
		id: 						detailsList
    	verticalLayoutDirection: 	ListView.TopToBottom
		anchors.left:   			parent.left
		anchors.right:  			parent.right
		anchors.bottom: 			parent.bottom
		anchors.bottomMargin: 		22
		height:						39

		delegate:              		BrowserView.DetailsFooter {id: detailsDelegate; screenFocus: screen.focusDeckId;}
		model:                  	browser.dataSet 
		currentIndex:           	contentList.currentIndex 

    	clip:						true
    	cacheBuffer:            	0
		spacing:                 	0
		preferredHighlightBegin: 	0
		preferredHighlightEnd  : 	39

		highlightRangeMode :     	ListView.ApplyRange
  		highlightMoveDuration : 	0
		focus:                   	true 
		interactive: 				false
	}

	// #################
	// ### SCROLLBAR ###
	// #################

	Rectangle {
		id: scrollBar

		readonly property real handlePos: contentList.contentY * scrollBar_handle.maximumY / (contentList.contentHeight - contentList.height)
		visible: (contentList.visibleArea.heightRatio < 1.0)

		color:                		colors.rgba (255, 255, 255, 16)
		anchors.left:   			contentList_lineMiddleVer.right
		anchors.leftMargin:			1
		anchors.right:  			contentList_lineRightVer.left
		anchors.rightMargin:		1
		anchors.top: 				browserHeader.bottom
		anchors.topMargin:       	0
		anchors.bottom: 			detailsList.top
		anchors.bottomMargin:    	1

		Rectangle {
			id: scrollBar_handle

			readonly property int  margin:   0
			readonly property real minimumY: margin
			readonly property real maximumY: parent.height - height - margin

			y:               Math.max( minimumY , Math.min( maximumY , scrollBar.handlePos ) )
			height:          Math.max(20, (contentList.visibleArea.heightRatio * scrollBar.height))
			anchors.left:    parent.left
			anchors.right:   parent.right
			anchors.margins: margin
			color:           colors.rgba (255, 255, 255, 32)
		}
	}


  BrowserView.BrowserFooter {
    id: 				browserFooter
    state:        		"show"
    propertiesPath: 	qmlBrowser.propertiesPath
    sortingKnobValue: 	qmlBrowser.sortingKnobValue
  }
 }