import QtQuick 1.1
import com.nokia.meego 1.0

Slider {
    id : textViewSlider
    property ListView listView 

    minimumValue : 0.0
    maximumValue : 1.0
    inverted : true
    orientation : Qt.Vertical
    valueIndicatorVisible : true
    /*valueIndicatorMargin : 50*/
    onValueChanged : {
        if ( value <= 0.0 )
            listView.positionViewAtBeginning()
        if ( value >= 1.0 )
            listView.positionViewAtEnd()
        else {
            var index = parseInt( listView.count * ( value / maximumValue ) )
            listView.positionViewAtIndex( index, ListView.Center )
        }
    }

    states : [
        State {
            name : "SHOW"
            when : pressed
            PropertyChanges { target : textViewSlider ; opacity : 0.850 }
        } ,
        State {
            name : "HIDE"
            when : !pressed
            PropertyChanges { target : textViewSlider ; opacity : 0.001 }
        }
    ]

    function formatValue( v ) {
        var str = ""
        if ( listView && listView.count > 0 ) {
            var index = parseInt( listView.count * v / maximumValue )
            if ( listView.model.lineAt ) {
                var line = listView.model.lineAt( index )
                if ( line.length < 1 && index > 0 ) 
                    line = listView.model.lineAt( index - 1 )
                if ( line.length > 0 ) {
                    if ( line.length > 20 )
                        str += line.slice( 0, 20 ) + "......"
                    else
                        str += line
                        str += " : "
                }
            }
            str += index
        }
        return str
    }
}
