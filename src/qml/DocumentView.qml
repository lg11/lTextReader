import QtQuick 1.1
import QtMobility.gallery 1.1

ListView {
    id : documentView
    DocumentGalleryModel {
        id : documentViewModel
        rootType : DocumentGallery.Text
        properties : [ "url", "fileName" ]
        filter : GalleryWildcardFilter {
            property : "url"
            value : "file:///home/*.txt"
        }
    }
    Component {
        id : documentViewDelegate
        Rectangle {
            id : documentViewModelRectangle
            width : parent.width
            height : documentViewDelegateText.paintedHeight + 20
            color : "transparent"
            Text {
                id : documentViewDelegateText
                text : fileName
                anchors.centerIn : parent
                width : parent.width - 30
                font.pixelSize : 26
            }
            MouseArea {
                id : documentViewDelegateMouseArea
                anchors.fill : parent
                onReleased : {
                    /*console.log( "released" )*/
                    textViewPage.reset()
                    textViewPage.setFileSource( url )
                    window.goToTextViewPage()
                }
            }
            states : [
                State {
                    name : "DOWN"
                    when : documentViewDelegateMouseArea.pressed
                    PropertyChanges { target : documentViewModelRectangle ; color : "#AA4444FF" }
                }
            ]
        }
    }
    model : documentViewModel
    delegate : documentViewDelegate
}
