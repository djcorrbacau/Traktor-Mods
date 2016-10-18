# Traktor-Mods
Display mods for Traktor Kontrol S8/S5/D2

**Initial commit based on [Sydes's](https://www.native-instruments.com/forum/members/sydes.331475/) mods.**

**Changes:**

  - Added beats to cue counter to browser footer, the two middle columns were empty and needed a purpose.
    - Turns yellow when less than 12 phrases remain, red when less than 8 phrases remain. (Customizable by changing the values of lines 49-52 in BrowserFooter.qml)
  - Added key matches for energy swap and one semitone energy jump to browser detail.
  - Added bpm and key to browser
  - Replaced Master/Sync indicator in deck header with comment or key tag, up to 11 characters.
    - Useful for MixedInKey users who have energy level written to comments and for tracks containing multiple keys.
    - If comments tag is empty, shows key tag.
    - Toggle to always show key tag instead of comment tag. (Line 590 in DeckHeader.qml)
  - Replaced key indicatior with gain indicator.
    - Key now shown as part of comments in place of Master/Sync indicator.

![Deck](http://i.imgur.com/zv18mLM.png)
![Browser](http://i.imgur.com/YGLwJjZ.png)
