import QtQuick 1.1

MaskableItem {
    id : root
    property alias model : listView.model
    property color textColor : "black"
    property color maskColor : "transparent"
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
            color : maskColor
        }
        Rectangle {
            id : maskBottomRect
            anchors.horizontalCenter : parent.horizontalCenter
            width : parent.width
            anchors.top : parent.top
            transformOrigin : Item.Top
            height : root.height - maskOffset
            color : maskColor
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
        } ,
        State {
            name : "SEEKING"
            StateChangeScript { 
                script : { remapMask() }
            }
            /*PropertyChanges { target : root ; textColor : "white" }*/
            PropertyChanges { target : root ; maskColor : "#BBFFFFFF" }
            PropertyChanges { target : maskTopRect ; height : maskHeight / 2 }
            PropertyChanges { target : maskBottomRect ; height : maskHeight / 2 }
        }
    ]

    transitions : [
        Transition {
            to : "SEEKING"
            reversible : true
            ParallelAnimation {
                NumberAnimation { target : maskTopRect ; property : "height" ; duration : 180 }
                NumberAnimation { target : maskBottomRect ; property : "height" ; duration : 180 }
                ColorAnimation { target : root ; properties : "maskColor" ; duration : 180 }
            }
        }
    ]

    function topIndex() {
        var pos = listView.mapToItem( listView.contentItem, 0, 0 )
        return listView.indexAt( pos.x, pos.y )
    }
    function centerIndex() {
        var pos = listView.mapToItem( listView.contentItem, 0, listView.height / 2 )
        return listView.indexAt( pos.x, pos.y )
    }
    function remapMask() {
        maskOffset = maskHeight / 2 + topIndex() / model.count * ( root.height - maskHeight )
    }

    function startSeek() {
        remapMask()
        state = "SEEKING"
    }
    function seek( index ) {
        listView.positionViewAtIndex( index, ListView.Beginning )
        remapMask()
    }
    function seeked( index ) {
        remapMask()
        state = "SHOW"
    }

    function sync( target ) {
        var index = target.topIndex()
        /*console.log( "sync start" )*/
        var oldContentY = target.listView.contentY
        /*console.log( target.listView.contentHeight, target.listView.contentY, listView.contentHeight, listView.contentY )*/
        
        target.listView.positionViewAtIndex( index, ListView.Beginning )
        var newContentY = target.listView.contentY
        /*console.log( target.listView.contentHeight, target.listView.contentY, listView.contentHeight, listView.contentY )*/

        var dy = newContentY - oldContentY
        /*console.log( dy )*/
        target.listView.contentY = target.listView.contentY - dy

        listView.positionViewAtIndex( index, ListView.Beginning )
        listView.contentY = listView.contentY - dy
        /*console.log( "sync end" )*/
    }
}
