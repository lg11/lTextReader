import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    id : textViewPage
    clip : true

    Rectangle {
        anchors.fill : parent
        color : "#AA808080"
    }
    TextViewModel { id : textViewModel }

    TextView { 
        id : textView
        model : textViewModel
        anchors.centerIn : parent
        height : parent.height 
        width : parent.width
    }
    Rectangle {
        id : shadow
        anchors.fill : parent
        Rectangle {
            anchors.fill : parent
            color : "white"
        }
        color : "black"
        visible : false
        opacity : 0.0
    }
    MouseArea {
        anchors.centerIn : parent
        height : parent.height
        width : parent.width / 3
        onPressed : {
            textView.state = "SEEKING"
        }
        onReleased : {
            textView.state = "SHOW"
        }
    }
    TextViewSlider {
        id : textViewSlider
        listView : textView.listView
        anchors.fill : parent
    }
    
    function setFileSource( fileSource ) {
        textViewModel.fileSource = fileSource
    }
    function reset() {
        /*textView.positionViewAtBeginning()*/
        textView.remapMask()
    }

    states : [
        State {
            name : "FADE"
            /*when : true*/
            PropertyChanges { target : textView ; scale : 0.85 }
            PropertyChanges { target : shadow ; visible : true }
            PropertyChanges { target : shadow ; opacity : 0.1 }
        }
    ]

    transitions : [
        Transition {
            from : ""
            to : "FADE"
            reversible : true
            NumberAnimation { target : textView ; property : "scale" ; duration : 120 }
            SequentialAnimation {
                PropertyAction { target : shadow ; property : "visible" }
                NumberAnimation { target : shadow ; property : "opacity" ; duration : 120 }
            }
        }
    ]
}
