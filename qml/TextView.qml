import QtQuick 1.1

ListView {
    TextViewModel {
        id : textViewModel
        filePath : "/home/l11/downloads/《步步惊心》完结.txt"
        fileCodec : "gb18030"
    }
    model : textViewModel
    delegate : Text { text : content ; wrapMode : Text.Wrap ; width : parent.width }
}
