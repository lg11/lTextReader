import QtQuick 1.1

MaskableItem {
    id : root
    property alias model : listView.model
    property color textColor : "black"
    property Item listView : listView
    property real maskOffset : 0
    state : "SHOW"

    Component {
        id : delegate
        Item {
            width : parent.width
            height : delegateText.paintedHeight
            Text {
                id : delegateText
                text : content
                anchors.centerIn : parent
                width : parent.width - 30
                wrapMode : Text.Wrap
                font.pixelSize : 26
                color : textColor
            }
        }
    }

    Rectangle {
        id : maskRect
        anchors.centerIn : parent
        anchors.verticalCenterOffset : maskOffset
        height : maskOffset > 0 ? root.height + maskOffset * 2 : root.height - maskOffset * 2
        width : root.width
        transformOrigin : Item.Center
        color : "#AA444444"
    }
    ListView {
        id : listView
        cacheBuffer : 8
        anchors.fill : parent
        delegate : delegate
    }

    mask : maskRect

    states : [
        State {
            name : "SHOW"
            StateChangeScript { 
                script : { remapMask() }
            }
            PropertyChanges { target : root ; textColor : "black" }
        } ,
        State {
            name : "SEEKING"
            StateChangeScript { 
                script : { remapMask() }
            }
            PropertyChanges { target : root ; textColor : "white" }
            PropertyChanges { target : maskRect ; height : root.height / 2 }
        }
    ]

    transitions : [
        Transition {
            to : "SEEKING"
            reversible : true
            ParallelAnimation {
                NumberAnimation { target : maskRect ; property : "height" ; duration : 800 }
                ColorAnimation { target : root ; property : "textColor" ; duration : 800 }
            }
        }
    ]

    function topIndex() {
        var pos = listView.mapToItem( listView.contentItem, 0, 0 )
        return listView.indexAt( pos.x, pos.y )
    }
    function remapMask() {
        maskOffset = topIndex() / model.count * root.height
        maskOffset = ( maskOffset - root.height / 2 ) / 2
    }
}
