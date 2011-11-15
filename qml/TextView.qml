import QtQuick 1.1

ListView {
    id : textView
    property alias filePath : textViewModel.filePath
    property alias fileCodec : textViewModel.fileCodec
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
}
