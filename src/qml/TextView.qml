import QtQuick 1.1

MaskableItem {
    id : root
    property alias model : listView.model
    property color textColor : "black"
    property Item listView : listView
    property real maskOffset : 0
    property real maskTop : maskRect.y - maskTopRect.height
    property real maskBottom : maskRect.y + maskBottomRect.height
    property real maskHeight : root.height / 2.25
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

    Item {
        id : maskRect
        anchors.horizontalCenter : parent.horizontalCenter
        height : 1
        width : parent.width 
        y : maskOffset
        /*Behavior on y { SmoothedAnimation { velocity : 500 } }*/
        Rectangle {
            id : maskTopRect
            anchors.horizontalCenter : parent.horizontalCenter
            width : parent.width
            anchors.bottom : parent.top
            transformOrigin : Item.Bottom
            height : maskOffset
            color : "#AAFF4444"
        }
        Rectangle {
            id : maskBottomRect
            anchors.horizontalCenter : parent.horizontalCenter
            width : parent.width
            anchors.top : parent.top
            transformOrigin : Item.Top
            height : root.height - maskOffset
            color : "#AAFF4444"
        }
    }
    ListView {
        id : listView
        cacheBuffer : 8
        anchors.fill : parent
        delegate : delegate
    }

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
            PropertyChanges { target : maskTopRect ; height : maskHeight / 2 }
            PropertyChanges { target : maskBottomRect ; height : maskHeight / 2 }
        }
    ]

    transitions : [
        Transition {
            to : "SEEKING"
            reversible : true
            ParallelAnimation {
                NumberAnimation { target : maskTopRect ; property : "height" ; from : maskOffset ; duration : 180 }
                NumberAnimation { target : maskBottomRect ; property : "height" ; from : root.height - maskOffset ; duration : 180 }
                ColorAnimation { target : root ; property : "textColor" ; from : "#AA888888" ; duration : 180 }
            }
        }
    ]

    function topIndex() {
        var pos = listView.mapToItem( listView.contentItem, 0, 0 )
        return listView.indexAt( pos.x, pos.y )
    }
    function remapMask() {
        maskOffset = maskHeight / 2 + topIndex() / model.count * ( root.height - maskHeight )
    }
}
