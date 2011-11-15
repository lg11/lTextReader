import QtQuick 1.1

ListView {
    id : textView
    /*property alias filePath : textViewModel.filePath*/
    property alias fileSource : textViewModel.fileSource
    /*property alias fileCodec : textViewModel.fileCodec*/
    property alias count : textViewModel.count
    TextViewModel {
        id : textViewModel
    }
    Component {
        id : textViewDelegate
        Text {
            text : content
            wrapMode : Text.Wrap
            width : parent.width
            font.pixelSize : 26
        }
    }
    model : textViewModel
    delegate : textViewDelegate

    function calcIndex( x, y ) {
        var pos = mapToItem( contentItem, x, y )
        return indexAt( pos.x, pos.y )
    }
}
