import QtQuick 1.1

Item {
    id : root
    property alias fileSource : textViewModel.fileSource
    property alias count : textViewModel.count
    property alias model : listView.model
    property color textColor : "black"
    property Item listView : listView
    property real offset : 0
    state : "SHOW"

    TextViewModel { id : textViewModel }

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

    ListView {
        id : listView
        cacheBuffer : 8
        anchors.centerIn : parent
        height : root.height
        width : root.width
        model : textViewModel
        delegate : delegate
        /*Behavior on contentY { SmoothedAnimation { velocity : 500 } }*/
    }

    Rectangle {
        id : maskRect
        clip : false
        color : "#96000000"
        anchors.centerIn : parent
        height : offset > 0 ? root.height + offset * 2 : root.height - offset * 2
        width : root.width
        transformOrigin : Item.Center
    }

    states : [
        State {
            name : "SHOW"
            StateChangeScript { 
                script : { remapMaskRect() ; listView.anchors.verticalCenterOffset = 0 }
            }
            ParentChange { target : listView ; parent : root }
            PropertyChanges { target : root ; textColor : "black" }
        } ,
        State {
            name : "SEEKING"
            StateChangeScript { 
                script : { remapMaskRect() ; listView.anchors.verticalCenterOffset = -offset }
            }
            ParentChange { target : listView ; parent : maskRect }
            PropertyChanges { target : root ; textColor : "white" }
            PropertyChanges { target : maskRect ; clip : true ; height : root.height / 2 }
        }
    ]

    transitions : [
        Transition {
            to : "SEEKING"
            reversible : true
            ParallelAnimation {
                NumberAnimation { target : maskRect ; property : "height" ; duration : 180 }
                ColorAnimation { target : root ; property : "textColor" ; duration : 180 }
            }
        }
    ]

    function topIndex() {
        var pos = listView.mapToItem( listView.contentItem, 0, 0 )
        return listView.indexAt( pos.x, pos.y )
    }
    function remapMaskRect() {
        offset = topIndex() / model.count * root.height
        offset = ( offset - root.height / 2 ) / 2
        maskRect.anchors.verticalCenterOffset = offset
    }
}
