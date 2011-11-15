import QtQuick 1.1
import com.nokia.meego 1.0

Slider {
    property ListView listView 

    minimumValue : 0.0
    maximumValue : 1.0
    inverted : true
    orientation : Qt.Vertical
    valueIndicatorVisible : true
    onValueChanged : {
        if ( value <= 0.0 )
            listView.positionViewAtBeginning()
        if ( value >= 1.0 )
            listView.positionViewAtEnd()
        else {
            var index = listView.count * ( value / maximumValue )
            listView.positionViewAtIndex( index, ListView.Contain )
        }
    }
}
