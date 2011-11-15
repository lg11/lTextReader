import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    clip : true
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
    
    function setFilePath( filePath ) {
        textView.filePath = filePath
    }
    /*function setFileCodec( fileCodec ) {*/
        /*textView.fileCodec = fileCodec*/
    /*}*/
    function reset() {
        textView.positionViewAtBeginning()
    }
}
