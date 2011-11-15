#include "textviewmodel.h"

#include <QStringList>
#include <QHash>
#include <QByteArray>
#include <QFile>
#include <QTextStream>

//#include <QDebug>

class TextViewModelPrivate {
public :
    QStringList list ;
    QString filePath ;
    QString fileCodec ;
    int count ;
    TextViewModelPrivate() :
        list(),
        filePath(),
        fileCodec( "utf-8" ),
        count( 0 )
    {
    }
    ~TextViewModelPrivate() {}
    void loadFile() {
        this->list.clear() ;
        QFile file( this->filePath ) ;
        if ( file.open( QIODevice::ReadOnly | QIODevice::Text ) ) {
            QTextStream in( &file ) ;
            in.setCodec( this->fileCodec.toLatin1() ) ;
            while( !in.atEnd() )
                this->list.append( in.readLine() ) ;
        }
    }
} ;


TextViewModel::TextViewModel( QObject* parent ) : 
    QAbstractListModel( parent ) ,
    d_ptr( new TextViewModelPrivate() )
{
    QHash<int, QByteArray> roles ;
    roles[ContentRole] = "content" ;
    this->setRoleNames( roles ) ;
}

TextViewModel::~TextViewModel() {
    delete this->d_ptr ;
}

int TextViewModel::rowCount( const QModelIndex& parent ) const {
    Q_UNUSED( parent ) ;
    Q_D( const TextViewModel ) ;
    return d->count ;
}

QVariant TextViewModel::data( const QModelIndex& index, int role ) const {
    Q_D( const TextViewModel ) ;
    if ( !index.isValid() )
        return QVariant() ;

    if ( index.row() < 0 || index.row() > d->list.length() )
        return QVariant() ;

    //qDebug() << "data" << index.row() << role ;
    if ( role == ContentRole )
        return d->list.at( index.row() ) ;
    else if ( role == Qt::DisplayRole )
        return d->list.at( index.row() ) ;
    else
        return QVariant() ;
}

const QString& TextViewModel::getFilePath() const {
    Q_D( const TextViewModel ) ;
    return d->filePath ;
}

void TextViewModel::setFilePath( const QString& filePath ) {
    Q_D( TextViewModel ) ;
    if ( d->filePath != filePath ) {
        d->filePath = filePath ;
        emit this->filePathChanged( d->filePath ) ;
        d->loadFile() ;
        this->setCount( d->list.length() ) ;
        emit itemsChanged() ;
    }
}

const QString& TextViewModel::getFileCodec() const {
    Q_D( const TextViewModel ) ;
    return d->fileCodec ;
}

void TextViewModel::setFileCodec( const QString& fileCodec ) {
    Q_D( TextViewModel ) ;
    if ( fileCodec == "utf-8" || fileCodec == "gb18030" ) {
        if ( d->fileCodec != fileCodec ) {
            d->fileCodec = fileCodec ;
            emit this->fileCodecChanged( d->fileCodec ) ;
            d->loadFile() ;
            this->setCount( d->list.length() ) ;
            emit itemsChanged() ;
        }
    }
}

int TextViewModel::getCount() const {
    Q_D( const TextViewModel ) ;
    return d->count ;
}

void TextViewModel::setCount( int count ) {
    Q_D( TextViewModel ) ;
    if ( d->count != count ) {
        d->count = count ;
        emit this->countChanged( d->count ) ;
    }
}

QString TextViewModel::lineAt( int index ) const {
    Q_D( const TextViewModel ) ;
    if ( index >= 0 && index < d->count )
        return d->list.at( index ) ;
        //return d->list.at( index ).trimmed() ;
    else
        return "" ;
}

