import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    Rectangle {
        anchors.fill : parent
        color : "white"
    }
    TextView { 
        id : textView
        anchors.centerIn : parent
        height : parent.height
        width : parent.width - 20
    }
    TextViewSlider {
        id : textViewSlider
        listView : textView
        anchors.fill : parent
    }
    /*FileView {*/
        /*anchors.centerIn : parent*/
        /*height : parent.height*/
        /*width : parent.width - 20*/
    /*}*/
    
    Component.onCompleted : {
        textView.fileCodec = "gb18030"
        textView.filePath = "/home/l11/downloads/《步步惊心》完结.txt"
    }
}
