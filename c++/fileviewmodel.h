#ifndef FILEVIEWMODEL_H
#define FILEVIEWMODEL_H

#include <QAbstractListModel>

class FileViewModelPrivate ;

class FileViewModel : public QAbstractListModel {
    Q_OBJECT
    Q_PROPERTY( QString path READ getPath WRITE setPath NOTIFY pathChanged ) 

signals :
    void pathChanged( const QString& path ) ;

public:
    enum ViewRoles {
        FileNameRole = Qt::UserRole + 1 ,
        FullPathRole
    } ;
    explicit FileViewModel( QObject* parent = NULL ) ;
    ~FileViewModel() ;

    virtual int rowCount( const QModelIndex& parent = QModelIndex() ) const ;
    virtual QVariant data( const QModelIndex& index, int role = Qt::DisplayRole ) const ;

    const QString& getPath() const ;
    void setPath( const QString& path ) ;
private :
    Q_DISABLE_COPY( FileViewModel ) ;
    Q_DECLARE_PRIVATE( FileViewModel ) ;
    FileViewModelPrivate* d_ptr ;
} ;

//QML_DECLARE_TYPE( FileViewModel )

#endif // FILEVIEWMODEL_H

