import QtQuick 1.1

ListView {
    id : fileView
    FileViewModel {
        id : fileViewModel
        path : "./"
    }
    Component {
        id : fileViewDelegate
        Text {
            text : filename
            width : parent.width
            font.pixelSize : 26
        }
    }
    model : fileViewModel
    delegate : fileViewDelegate
}
