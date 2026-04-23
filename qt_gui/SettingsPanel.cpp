#include "SettingsPanel.h"
#include "ui_SettingsPanel.h"
#include <QSerialPortInfo>

SettingsPanel::SettingsPanel(QWidget *parent)
    : QWidget(parent)
    , ui(new Ui::SettingsPanel)
{
    ui->setupUi(this);

    populatePorts();

    /* Set default baud rate — existing widget, data-only change */
    ui->baudCombo->setCurrentText("115200");

    connect(ui->connectButton,    &QPushButton::clicked,
            this,                 &SettingsPanel::onConnectClicked);
    connect(ui->disconnectButton, &QPushButton::clicked,
            this,                 &SettingsPanel::onDisconnectClicked);
    connect(ui->refreshButton,    &QPushButton::clicked,
            this,                 &SettingsPanel::onRefreshClicked);

    ui->disconnectButton->setEnabled(false);
    ui->statusLabel->setText(tr("Not connected"));
    ui->statusLabel->setStyleSheet("color:#dc2626; font-weight:bold;");
}

SettingsPanel::~SettingsPanel()
{
    delete ui;
}

void SettingsPanel::setConnectedState(bool connected)
{
    ui->connectButton->setEnabled(!connected);
    ui->disconnectButton->setEnabled(connected);
    ui->portCombo->setEnabled(!connected);
    ui->baudCombo->setEnabled(!connected);

    if (connected) {
        ui->statusLabel->setText(
            tr("Connected: %1").arg(ui->portCombo->currentText()));
        ui->statusLabel->setStyleSheet("color:#00c6a7; font-weight:bold;");
    } else {
        ui->statusLabel->setText(tr("Not connected"));
        ui->statusLabel->setStyleSheet("color:#dc2626; font-weight:bold;");
    }
}

void SettingsPanel::onConnectClicked()
{
    emit connectRequested(
        ui->portCombo->currentText(),
        ui->baudCombo->currentText().toInt());
}

void SettingsPanel::onDisconnectClicked()
{
    emit disconnectRequested();
}

void SettingsPanel::onRefreshClicked()
{
    populatePorts();
}

void SettingsPanel::populatePorts()
{
    const QString prev = ui->portCombo->currentText();
    ui->portCombo->clear();

    /* Populate from QSerialPortInfo — data only, no new widgets */
    const QList<QSerialPortInfo> ports = QSerialPortInfo::availablePorts();
    for (const QSerialPortInfo &info : ports)
        ui->portCombo->addItem(info.portName());

    if (ui->portCombo->count() == 0)
        ui->portCombo->addItem(tr("No ports found"));

    const int idx = ui->portCombo->findText(prev);
    if (idx >= 0)
        ui->portCombo->setCurrentIndex(idx);
}
