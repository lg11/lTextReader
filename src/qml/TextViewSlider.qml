import QtQuick 1.1
import com.nokia.meego 1.0

Item {
    id : textViewSlider
    property ListView listView 
    property alias indicatorString : indicatorText.text
    clip : true

    MouseArea {
        id :mouseArea
        anchors.right : parent.right
        anchors.verticalCenter : parent.verticalCenter
        height : parent.height
        width : screen.rotation > 0 ? 100 : 150
        Rectangle {
            anchors.fill : parent
            color : "#66FF0000"
        }
        function calcIndex( dy ) {
            var scale = parseInt ( dy / ( height * 0.85 ) * listView.count )
            var index =  internal.seekStartIndex + scale
            if ( index < 0 )
                index = 0
            else if ( index >= listView.count )
                index = listView.count - 1
            return index
        }
        function calcY( index ) {
            var y = parseInt( index / listView.count * ( parent.height - indicator.height ) )
            return y
        }
        onPressed : {
            internal.seekStartY = mouse.y
            var pos = listView.mapToItem( listView.contentItem, 0, listView.height / 2 ) 
            internal.seekStartIndex = listView.indexAt( pos.x, pos.y )
            indicatorString = calcIndicatorString( internal.seekStartIndex )
            indicator.y = calcY( internal.seekStartIndex )
        }
        onPositionChanged : {
            var index = calcIndex( mouse.y - internal.seekStartY )
            indicatorString = calcIndicatorString( index )
            indicator.y = calcY( index )
        }
        onReleased : {
            var index = calcIndex( mouse.y - internal.seekStartY )
            if ( index <= 0 )
                listView.positionViewAtBeginning()
            else if ( index >= listView.count )
                listView.positionViewAtEnd()
            else
                listView.positionViewAtIndex( index, ListView.Center )
        }
    }

    Item {
        id : indicator
        anchors.horizontalCenter : parent.horizontalCenter
        height : screen.rotation > 0 ? parent.height / 4 : parent.height / 3
        width : parent.width
        visible : false
        opacity : 0.8
        clip : true
        Rectangle {
            id : indicatorPlat
            color : "black"
            anchors.centerIn : parent
            height : parent.height
            width : parent.width
            transformOrigin : Item.Center
            clip : true
            Text {
                id : indicatorText
                anchors.centerIn : parent
                width : parent.width - 30
                verticalAlignment : Text.AlignVCenter
                font.pixelSize : 26
                wrapMode : Text.Wrap
                text : "test string"
                color : "white"
            }
        }
    }

    QtObject {
        id : internal
        property int seekStartY
        property int seekStartIndex
    }

    states : [
        State {
            name : "SHOW"
            when : mouseArea.pressed
            PropertyChanges { target : indicator ; visible : true }
            /*PropertyChanges { target : indicator ; opacity : 0.85  }*/
            PropertyChanges { target : textViewPage ; state : "FADE" }
        } ,
        State {
            name : "HIDE"
            when : !mouseArea.pressed
            PropertyChanges { target : indicator ; visible : false }
            /*PropertyChanges { target : indicator ; opacity : 0.0  }*/
            PropertyChanges { target : textViewPage ; state : "" }
            PropertyChanges { target : indicatorPlat ; height : 0 }
        }
    ]

    transitions : [
        Transition {
            from : "HIDE"
            to : "SHOW"
            reversible : true
            SequentialAnimation {
                PropertyAction { target : indicator ; property : "visible" }
                NumberAnimation { target : indicatorPlat ; property : "height" ; duration : 120 }
                /*NumberAnimation { target : indicator ; property : "opacity" ; duration : 100 }*/
            }
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
            else ( listView.count >= 2 ) 
                str = str.concat( listView.model.lineAt( index - 1 ), "\n", listView.model.lineAt( index ) )
        }
        else {
            str = str.concat( listView.model.lineAt( index - 1 ), "\n", listView.model.lineAt( index ), "\n", listView.model.lineAt( index + 1 ) )
        }
        return str
    }
}
