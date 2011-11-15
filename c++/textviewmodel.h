#ifndef TEXTVIEWMODEL_H
#define TEXTVIEWMODEL_H

#include <QAbstractListModel>

class TextViewModelPrivate ;

class TextViewModel : public QAbstractListModel {
    Q_OBJECT
    Q_PROPERTY( QString filePath READ getFilePath WRITE setFilePath NOTIFY filePathChanged ) 
    Q_PROPERTY( QString fileCodec READ getFileCodec WRITE setFileCodec NOTIFY fileCodecChanged ) 
    Q_PROPERTY( int count READ getCount NOTIFY countChanged )

signals :
    void filePathChanged( const QString& filePath ) ;
    void fileCodecChanged( const QString& fileCodec ) ;
    void countChanged( int count ) ;
    void itemsChanged() ;

public:
    enum ViewRoles {
        ContentRole = Qt::UserRole + 1
    } ;
    explicit TextViewModel( QObject* parent = NULL ) ;
    ~TextViewModel() ;

    virtual int rowCount( const QModelIndex& parent = QModelIndex() ) const ;
    virtual QVariant data( const QModelIndex& index, int role = Qt::DisplayRole ) const ;

    const QString& getFilePath() const ;
    void setFilePath( const QString& filePath ) ;
    const QString& getFileCodec() const ;
    void setFileCodec( const QString& fileCodec ) ;
    int getCount() const ;
    void setCount( int count ) ;
private :
    Q_DISABLE_COPY( TextViewModel ) ;
    Q_DECLARE_PRIVATE( TextViewModel ) ;
    TextViewModelPrivate* d_ptr ;
} ;

//QML_DECLARE_TYPE( TextViewModel )

#endif // TEXTVIEWMODEL_H

