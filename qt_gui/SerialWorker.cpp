#include "SerialWorker.h"

SerialWorker::SerialWorker(QObject *parent)
    : QObject(parent)
    , m_port(new QSerialPort(this))
{
    connect(m_port, &QSerialPort::readyRead,
            this,   &SerialWorker::onReadyRead);
    connect(m_port, &QSerialPort::errorOccurred,
            this,   &SerialWorker::onErrorOccurred);
}

SerialWorker::~SerialWorker()
{
    disconnectPort();
}

void SerialWorker::connectPort(const QString &portName, int baudRate)
{
    if (m_port->isOpen())
        m_port->close();

    m_port->setPortName(portName);
    m_port->setBaudRate(static_cast<QSerialPort::BaudRate>(baudRate));
    m_port->setDataBits(QSerialPort::Data8);
    m_port->setParity(QSerialPort::NoParity);
    m_port->setStopBits(QSerialPort::OneStop);
    m_port->setFlowControl(QSerialPort::NoFlowControl);

    if (!m_port->open(QIODevice::ReadWrite))
        emit errorOccurred(QString("Cannot open %1: %2")
                           .arg(portName, m_port->errorString()));
}

void SerialWorker::disconnectPort()
{
    if (m_port && m_port->isOpen()) {
        m_port->flush();
        m_port->close();
    }
    m_buffer.clear();
}

void SerialWorker::sendData(const QByteArray &data)
{
    if (m_port && m_port->isOpen())
        m_port->write(data);
}

void SerialWorker::onReadyRead()
{
    m_buffer.append(m_port->readAll());
    int idx;
    while ((idx = m_buffer.indexOf('\n')) != -1) {
        const QByteArray pkt = m_buffer.left(idx + 1);
        m_buffer.remove(0, idx + 1);
        if (!pkt.trimmed().isEmpty())
            emit dataReceived(pkt);
    }
}

void SerialWorker::onErrorOccurred(QSerialPort::SerialPortError error)
{
    if (error != QSerialPort::NoError)
        emit errorOccurred(m_port->errorString());
}
