import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id : textViewSlider
    clip : true

    MouseArea {
        id :mouseArea
        anchors.right : parent.right
        anchors.verticalCenter : parent.verticalCenter
        height : parent.height
        width : screen.rotation > 0 ? 100 : 150
        /*Rectangle {*/
            /*anchors.fill : parent*/
            /*color : "#66FF0000"*/
        /*}*/
        function calcIndex( dy ) {
            var scale = parseInt ( dy / ( height * 0.85 ) * textViewPage.model.count )
            var index =  internal.seekStartIndex + scale
            if ( index < 0 )
                index = 0
            else if ( index >= textViewPage.model.count )
                index = textViewPage.model.count - 1
            return index
        }
        onPressed : {
            textViewPage.backface.fadeFlag = false
            textViewPage.backface.hideFlag = false
            internal.seekStartY = mouse.y
            internal.seekStartIndex = textViewPage.surface.textView.topIndex()
            textViewPage.surface.textView.startSeek()
            textViewPage.backface.textView.sync( textViewPage.surface.textView )
            textViewPage.backface.fadeFlag = true
        }
        onPositionChanged : {
            var index = calcIndex( mouse.y - internal.seekStartY )
            textViewPage.surface.textView.seek( index )
        }
        onReleased : {
            var index = calcIndex( mouse.y - internal.seekStartY )
            textViewPage.surface.textView.seeked( index )
            textViewPage.backface.textView.sync( textViewPage.surface.textView )
            textViewPage.backface.hideFlag = true
        }
    }

    QtObject {
        id : internal
        property int seekStartY
        property int seekStartIndex
    }
}
