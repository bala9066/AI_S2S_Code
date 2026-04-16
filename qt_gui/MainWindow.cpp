#include "MainWindow.h"
#include "ui_MainWindow.h"
#include "DashboardPanel.h"
#include "ControlPanel.h"
#include "LogPanel.h"
#include "SettingsPanel.h"
#include <QDateTime>
#include <QStatusBar>

// ======================================================================
// Construction / Destruction
// ======================================================================

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
    , m_worker(new SerialWorker)
    , m_workerThread(new QThread(this))
{
    ui->setupUi(this);

    m_worker->moveToThread(m_workerThread);
    connect(m_workerThread, &QThread::finished, m_worker, &QObject::deleteLater);
    m_workerThread->start();

    initConnections();

    statusBar()->showMessage(tr("rx receiver (rf) — Ready"));
}

MainWindow::~MainWindow()
{
    m_workerThread->quit();
    m_workerThread->wait(3000);
    delete ui;
}

// ======================================================================
// Signal wiring — connect() calls only; zero widget creation
// ======================================================================

void MainWindow::initConnections()
{
    // SerialWorker -> MainWindow
    connect(m_worker, &SerialWorker::dataReceived,
            this,     &MainWindow::onDataReceived);
    connect(m_worker, &SerialWorker::errorOccurred,
            this,     &MainWindow::onSerialError);

    // SettingsPanel -> MainWindow
    connect(ui->settingsPage, &SettingsPanel::connectRequested,
            this,             &MainWindow::onConnectRequested);
    connect(ui->settingsPage, &SettingsPanel::disconnectRequested,
            this,             &MainWindow::onDisconnectRequested);

    // ControlPanel -> MainWindow
    connect(ui->controlPage, &ControlPanel::commandSend,
            this,            &MainWindow::onCommandSend);
}

// ======================================================================
// Slots
// ======================================================================

void MainWindow::onDataReceived(const QByteArray &data)
{
    ui->dashboardPage->handleIncomingData(data);
    ui->logPage->appendEntry(
        QDateTime::currentDateTime().toString("hh:mm:ss.zzz"),
        "RX",
        QString::fromLatin1(data.toHex(' ').toUpper())
    );
}

void MainWindow::onSerialError(const QString &error)
{
    ui->logPage->appendEntry(
        QDateTime::currentDateTime().toString("hh:mm:ss"), "ERR", error);
    ui->settingsPage->setConnectedState(false);
    statusBar()->showMessage(tr("Serial error: %1").arg(error));
}

void MainWindow::onConnectRequested(const QString &port, int baud)
{
    QMetaObject::invokeMethod(
        m_worker, "connectPort", Qt::QueuedConnection,
        Q_ARG(QString, port), Q_ARG(int, baud));
    statusBar()->showMessage(tr("Connecting to %1 @ %2 baudâ¦").arg(port).arg(baud));
    ui->logPage->appendEntry(
        QDateTime::currentDateTime().toString("hh:mm:ss"),
        "INF", tr("Connecting to %1 @ %2").arg(port).arg(baud));
}

void MainWindow::onDisconnectRequested()
{
    QMetaObject::invokeMethod(m_worker, "disconnectPort", Qt::QueuedConnection);
    statusBar()->showMessage(tr("Disconnected"));
    ui->settingsPage->setConnectedState(false);
    ui->logPage->appendEntry(
        QDateTime::currentDateTime().toString("hh:mm:ss"), "INF", tr("Disconnected"));
}

void MainWindow::onCommandSend(const QString &command)
{
    const QByteArray payload = (command + "\r\n").toLatin1();
    QMetaObject::invokeMethod(
        m_worker, "sendData", Qt::QueuedConnection,
        Q_ARG(QByteArray, payload));
    ui->logPage->appendEntry(
        QDateTime::currentDateTime().toString("hh:mm:ss"), "TX", command);
}
