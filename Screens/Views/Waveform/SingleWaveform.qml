import CSI 1.0
import QtQuick 2.0
import QtGraphicalEffects 1.0
import './../Definitions' as Definitions
import Traktor.Gui 1.0 as T


Item {
  id: view

  property int deckId:          0
  property int streamId:        0 
  property int sampleWidth:     0  
  property var waveformColors:  colors.getDefaultWaveformColors()
  property var waveformPosition

  readonly property variant textColors:         [colors.colorGrey232,  colors.colorGrey232,   colors.colorGrey232,  colors.colorGrey232 ]
  readonly property variant darkerTextColors:   [colors.colorGrey72,    colors.colorGrey72,     colors.colorGrey72,   colors.colorGrey72  ]
  property string headerState:      "large" // this property is used to set the state of the header (large/small)

  readonly property bool   isLoaded:    top_left_text.isLoaded
  readonly property int    deckType:    deckTypeProperty.value
  readonly property int    isInSync:    top_left_text.isInSync
  readonly property int    isMaster:    top_left_text.isMaster
  readonly property double syncPhase:   (headerPropertySyncPhase.value*2.0).toFixed(2)

  readonly property var audioStreamKey: (primaryKey.value == 0) ? ["MixerDeckKey", view.deckId] 
                                                                : ["PrimaryKey", primaryKey.value, streamId]
  //--------------------------------------------------------------------------------------------------------------------

  AppProperty { id: primaryKey; 		path: "app.traktor.decks." + (deckId + 1) + ".track.content.primary_key" }
  AppProperty { id: propRemixBeatPos;     path: "app.traktor.decks." + (deckId+1) + ".remix.current_beat_pos"; }
  AppProperty { id: propElapsedTime;    path: "app.traktor.decks." + (deckId+1) + ".track.player.elapsed_time"; } 
  AppProperty { id: propGridOffset;     path: "app.traktor.decks." + (deckId+1) + ".content.grid_offset" }
  AppProperty { id: propMixerBpm;         path: "app.traktor.decks." + (deckId+1) + ".tempo.base_bpm" }
  AppProperty { id: propNextCuePoint;   path: "app.traktor.decks." + (deckId+1) + ".track.player.next_cue_point"; }
  AppProperty { id: propTrackLength;    path: "app.traktor.decks." + (deckId+1) + ".track.content.track_length"; }
  //--------------------------------------------------------------------------------------------------------------------

  readonly property double  cuePos:    (propNextCuePoint.value >= 0) ? propNextCuePoint.value : propTrackLength.value*1000

  T.Waveform {
    id: waveform
    anchors.fill:     parent
    deckId:           view.deckId
    waveformPosition: view.waveformPosition
    
    colorMatrix.high1: waveformColors.high1
    colorMatrix.high2: waveformColors.high2
    colorMatrix.mid1 : waveformColors.mid1
    colorMatrix.mid2 : waveformColors.mid2
    colorMatrix.low1 : waveformColors.low1
    colorMatrix.low2 : waveformColors.low2

    audioStreamKey:  (!view.visible) ? ["PrimaryKey", 0] : view.audioStreamKey
  }

  //--------------------------------------------------------------------------------------------------------------------

  WaveformColorize { 
    id: waveformColorize
    anchors.fill:  parent
    loop_start:    waveformCues.cueStart
    loop_length:   waveformCues.loop_length
    visible:       waveformCues.is_looping

    waveform:         waveform
    waveformPosition: view.waveformPosition
  }


}
