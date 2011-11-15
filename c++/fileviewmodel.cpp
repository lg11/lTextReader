#include "fileviewmodel.h"

#include <QDir>
#include <QStringList>

//#include <QDebug>

class FileViewModelPrivate {
public :
    QString path ;
    QDir dir ;
    QStringList entryList ;
    FileViewModelPrivate() : path( "./" ), dir( "./" ), entryList() {
        this->cd() ;
    }
    ~FileViewModelPrivate() {}
    void cd() {
        this->dir.cd( this->path ) ;
        this->entryList = this->dir.entryList() ;
    }
} ;


FileViewModel::FileViewModel( QObject* parent ) : 
    QAbstractListModel( parent ) ,
    d_ptr( new FileViewModelPrivate() )
{
    QHash<int, QByteArray> roles ;
    roles[FileNameRole] = "filename" ;
    roles[FullPathRole] = "fullpath" ;
    this->setRoleNames( roles ) ;
}

FileViewModel::~FileViewModel() {
    delete this->d_ptr ;
}

int FileViewModel::rowCount( const QModelIndex& parent ) const {
    Q_UNUSED( parent ) ;
    Q_D( const FileViewModel ) ;
    return d->entryList.length() - 2 ;
}

QVariant FileViewModel::data( const QModelIndex& index, int role ) const {
    Q_D( const FileViewModel ) ;
    if ( !index.isValid() )
        return QVariant() ;

    if ( index.row() < 0 || index.row() > d->entryList.length() - 2 )
        return QVariant() ;

    if ( role == FileNameRole ) 
        return d->entryList.at( index.row() + 2 ) ;
    else if ( role == FullPathRole )
        return d->dir.absoluteFilePath( d->entryList.at( index.row() + 2 ) ) ;
    else if ( role == Qt::DisplayRole )
        return d->entryList.at( index.row() ) ;
    else
        return QVariant() ;
}

const QString& FileViewModel::getPath() const {
    Q_D( const FileViewModel ) ;
    return d->path ;
}

void FileViewModel::setPath( const QString& path ) {
    Q_D( FileViewModel ) ;
    if ( d->dir.exists( path ) && d->path != path ) {
        d->path = path ;
        d->cd() ;
        emit this->pathChanged( d->path ) ;
    }
}
