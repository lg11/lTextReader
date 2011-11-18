import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id : textViewPage
    clip : true
    property bool swapFlag : false

    property Item surface : surface
    property Item backface : backface
    property QtObject model : textViewModel

    TextViewModel { id : textViewModel }

    Item {
        states : [
            State {
                name : "SWAP"
                when : swapFlag
                StateChangeScript { script : { console.log("swap") } }
                PropertyChanges { target : surface ; textView : textView_2 }
                PropertyChanges { target : backface ; textView : textView_1 }
                ParentChange { target : textView_1 ; parent : backface }
                ParentChange { target : textView_2 ; parent : surface }
            } 
        ]
    }

    Item {
        id : backface
        property Item textView : textView_2
        property bool fadeFlag : false
        property bool hideFlag : false
        anchors.centerIn : parent
        height : parent.height
        width : parent.width
        transformOrigin : Item.Center
        visible : false
        TextView { 
            id : textView_2
            model : textViewModel
            anchors.fill : parent
        }
        states : [
            State {
                name : "FADED"
                when : backface.fadeFlag && !backface.hideFlag
                PropertyChanges { target : backface ; scale : 0.95 ; opacity : 0.45 ; visible : true }
                PropertyChanges { target : fadeShadow ; opacity : 0.45 } 
            } ,
            State {
                name : "HIDED"
                when : backface.hideFlag
                PropertyChanges { target : backface ; scale : 0.5 ; opacity : 0.0 ; visible : false }
                PropertyChanges { target : fadeShadow ; opacity : 0 } 
            }
        ]
        transitions : [
            Transition {
                to : "FADED"
                reversible : true
                SequentialAnimation {
                    PropertyAction { target : backface ; property : "visible" }
                    ParallelAnimation {
                        NumberAnimation { target : backface ; properties : "scale,opacity" ; duration : 220 }
                        NumberAnimation { target : fadeShadow ; property : "opacity" }
                    }
                }
            } ,
            Transition {
                from : "FADED"
                to : "HIDED"
                reversible : false
                SequentialAnimation {
                    ParallelAnimation {
                        NumberAnimation { target : backface ; properties : "scale,opacity" ; duration : 150 }
                        NumberAnimation { target : fadeShadow ; property : "opacity" }
                    }
                    PropertyAction { target : backface ; property : "visible" }
                }
            }
        ]
    }
    Rectangle {
        id : fadeShadow
        anchors.fill : parent
        color : "white"
        Rectangle {
            anchors.fill : parent
            color : "black"
        }
        opacity : 0.0
    }
    Item {
        id : surface
        property Item textView : textView_1
        anchors.centerIn : parent
        height : parent.height
        width : parent.width
        transformOrigin : Item.Center
        TextView { 
            id : textView_1
            model : textViewModel
            anchors.fill : parent
        }
    }

    TextViewSlider {
        id : textViewSlider
        anchors.fill : parent
    }
    
    function setFileSource( fileSource ) {
        textViewModel.fileSource = fileSource
    }
    function reset() {
        surface.textView.listView.positionViewAtBeginning()
        surface.textView.activeEffect()
        surface.textView.remapMask()
    }

    states : [
        State {
            name : "FADE"
            /*when : true*/
            PropertyChanges { target : textView_1 ; scale : 0.85 }
            PropertyChanges { target : shadow ; visible : true }
            PropertyChanges { target : shadow ; opacity : 0.1 }
        }
    ]

    transitions : [
        Transition {
            from : ""
            to : "FADE"
            reversible : true
            NumberAnimation { target : textView_1 ; property : "scale" ; duration : 120 }
            SequentialAnimation {
                PropertyAction { target : shadow ; property : "visible" }
                NumberAnimation { target : shadow ; property : "opacity" ; duration : 120 }
            }
        }
    ]
}
