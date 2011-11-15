import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id : textViewSlider
    property ListView listView 
    property alias indicatorString : indicatorText.text

    MouseArea {
        id :mouseArea
        anchors.right : parent.right
        anchors.verticalCenter : parent.verticalCenter
        height : parent.height
        width : 100
        /*Rectangle {*/
            /*anchors.fill : parent*/
            /*color : "#66FF0000"*/
        /*}*/
        function calcIndex( dy ) {
            var scale = parseInt ( dy / ( height * 0.85 ) * listView.count )
            var index =  internal.pressStartIndex + scale
            if ( index < 0 )
                index = 0
            else if ( index >= listView.count )
                index = listView.count - 1
            return index
        }
        function calcY( index ) {
            var scale = index / listView.count * parent.height
            var y = parseInt( scale - indicator.height / 2 )
            y = y < 0 ? 0 : y
            y = y + indicator.height > parent.height ? parent.height - indicator.height : y
            return y
        }
        onPressed : {
            internal.pressStartY = mouse.y
            internal.pressStartIndex = listView.calcIndex( 0, height / 2 )
            indicatorString = calcIndicatorString( internal.pressStartIndex )
            indicator.y = calcY( internal.pressStartIndex )
        }
        onPositionChanged : {
            var index = calcIndex( mouse.y - internal.pressStartY )
            indicatorString = calcIndicatorString( index )
            indicator.y = calcY( index )
        }
        onReleased : {
            var index = calcIndex( mouse.y - internal.pressStartY )
            if ( index <= 0 )
                listView.positionViewAtBeginning()
            else if ( index >= listView.count )
                listView.positionViewAtEnd()
            else
                listView.positionViewAtIndex( index, ListView.Center )
        }
    }

    Rectangle {
        id : indicator
        anchors.horizontalCenter : parent.horizontalCenter
        width : parent.width
        color : "#CC444444"
        height : indicatorText.paintedHeight > parent.height / 3 ? parent.height / 3 : indicatorText.paintedHeight
        clip : true
        Text {
            id : indicatorText
            anchors.centerIn : parent
            width : parent.width - 30
            verticalAlignment : Text.AlignVCenter
            font.pixelSize : 22
            wrapMode : Text.Wrap
            text : "test string"
            color : "#CCFFFFFF"
        }
    }

    QtObject {
        id : internal
        property int pressStartY
        property int pressStartIndex
    }

    states : [
        State {
            name : "SHOW"
            when : mouseArea.pressed
            PropertyChanges { target : indicator ; visible : true }
        } ,
        State {
            name : "HIDE"
            when : !mouseArea.pressed
            PropertyChanges { target : indicator ; visible : false }
        }
    ]

    function calcIndicatorString( index ) {
        var str = ""
        if ( index == 0 ) {
            if ( listView.count >= 3 ) 
                str = str.concat( listView.model.lineAt( index ), "\n", listView.model.lineAt( index + 1 ), "\n", listView.model.lineAt( index + 2 ) )
            else if ( listView.count >= 2 ) 
                str = str.concat( listView.model.lineAt( index ), "\n", listView.model.lineAt( index + 1 ) )
            else if ( listView.count >= 1 ) 
                str = listView.model.lineAt( index )
        }
        else if ( index >= listView.count ) {
            if ( listView.count >= 3 ) 
                str = str.concat( listView.model.lineAt( index - 2 ), "\n", listView.model.lineAt( index - 1 ), "\n", listView.model.lineAt( index ) )
            else if ( listView.count >= 2 ) 
                str = str.concat( listView.model.lineAt( index - 1 ), "\n", listView.model.lineAt( index ) )
            else if ( listView.count >= 1 ) 
                str = listView.model.lineAt( index )
        }
        else {
            str = str.concat( listView.model.lineAt( index - 1 ), "\n", listView.model.lineAt( index ), "\n", listView.model.lineAt( index + 1 ) )
        }
        return str
    }
}
