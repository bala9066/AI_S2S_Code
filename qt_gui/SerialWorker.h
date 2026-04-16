#ifndef SERIALWORKER_H
#define SERIALWORKER_H

#include <QObject>
#include <QSerialPort>

/**
 * @class SerialWorker
 * @brief QThread-based QSerialPort I/O worker.
 *
 * Move to a QThread, then call slots via QMetaObject::invokeMethod with
 * Qt::QueuedConnection to ensure thread-safe access.
 *
 * Newline-framed packet protocol: emits dataReceived() for each '\n'-
 * terminated packet received. Adapt framing logic for your hardware protocol.
 */
class SerialWorker : public QObject
{
    Q_OBJECT

public:
    explicit SerialWorker(QObject *parent = nullptr);
    ~SerialWorker() Q_DECL_OVERRIDE;

public slots:
    void connectPort(const QString &portName, int baudRate);
    void disconnectPort();
    void sendData(const QByteArray &data);

signals:
    void dataReceived(const QByteArray &packet);
    void errorOccurred(const QString &message);

private slots:
    void onReadyRead();
    void onErrorOccurred(QSerialPort::SerialPortError error);

private:
    QSerialPort *m_port;
    QByteArray   m_buffer;
};

#endif // SERIALWORKER_H
