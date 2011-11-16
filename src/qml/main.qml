import QtQuick 1.1
import com.nokia.meego 1.0
/*import QtMobility.gallery 1.1*/

PageStackWindow {
    id : window
    property bool showDocumentViewPage : true

    initialPage : documentViewPage
    /*initialPage : textViewPage*/

    TextViewPage {
        id : textViewPage
        tools : commonTools
    }

    DocumentViewPage {
        id : documentViewPage
        tools : commonTools
    }

    ToolBarLayout {
        id : commonTools
        visible : true
        ToolIcon {
            platformIconId : "toolbar-view-menu"
            anchors.left : parent.left
            onClicked : {
                if ( showDocumentViewPage ) 
                    goToTextViewPage()
                else 
                    goToDocumentViewPage()
            }
        }
    }

    function goToDocumentViewPage() {
        pageStack.pop()
        showDocumentViewPage = true
    }
    function goToTextViewPage() {
        pageStack.push( textViewPage )
        showDocumentViewPage = false
    }

}

