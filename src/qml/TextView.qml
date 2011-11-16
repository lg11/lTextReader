import QtQuick 1.1

ListView {
    id : textView
    /*property alias filePath : textViewModel.filePath*/
    /*property alias fileCodec : textViewModel.fileCodec*/
    property alias fileSource : textViewModel.fileSource
    property alias count : textViewModel.count

    TextViewModel {
        id : textViewModel
    }

    Component {
        id : textViewDelegate
        MouseArea {
            height : textViewDelegateText.paintedHeight
            width : parent.width
            Text {
                id : textViewDelegateText
                text : content
                anchors.centerIn : parent
                width : parent.width - 30
                wrapMode : Text.Wrap
                font.pixelSize : 26
            }
        }
    }

    model : textViewModel
    delegate : textViewDelegate
}
