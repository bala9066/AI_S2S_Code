#include "DashboardPanel.h"
#include "ui_DashboardPanel.h"
#include <QDateTime>
#include <QTableWidgetItem>
#include <QHeaderView>

DashboardPanel::DashboardPanel(QWidget *parent)
    : QWidget(parent)
    , ui(new Ui::DashboardPanel)
    , m_packetCount(0)
{
    ui->setupUi(this);

    /* Configure table — column sizing only, no new widgets */
    ui->dataTable->horizontalHeader()->setStretchLastSection(true);
    ui->dataTable->horizontalHeader()->setSectionResizeMode(QHeaderView::Stretch);
    ui->dataTable->setEditTriggers(QAbstractItemView::NoEditTriggers);
    ui->dataTable->setSelectionBehavior(QAbstractItemView::SelectRows);
    ui->dataTable->setAlternatingRowColors(true);

    ui->progressBar->setRange(0, 100);
    ui->progressBar->setValue(0);
    ui->progressBar->setFormat("%p%  buffer");

    ui->headerLabel->setText(tr("<b>hh &amp;mdash; Live Dashboard</b>"));
}

DashboardPanel::~DashboardPanel()
{
    delete ui;
}

void DashboardPanel::handleIncomingData(const QByteArray &data)
{
    ++m_packetCount;

    /* Update stat cards via ui-> (no new widgets) */
    ui->stat1Value->setText(QString::number(m_packetCount));
    ui->progressBar->setValue(m_packetCount % 101);

    /* Append table row; cap at 200 rows */
    if (ui->dataTable->rowCount() >= 200)
        ui->dataTable->removeRow(0);

    const int row = ui->dataTable->rowCount();
    ui->dataTable->insertRow(row);
    ui->dataTable->setItem(row, 0, new QTableWidgetItem(
        QDateTime::currentDateTime().toString("hh:mm:ss.zzz")));
    ui->dataTable->setItem(row, 1, new QTableWidgetItem("CH0"));
    ui->dataTable->setItem(row, 2, new QTableWidgetItem(
        QString::fromLatin1(data.toHex(' ').toUpper()).left(64)));
    ui->dataTable->setItem(row, 3, new QTableWidgetItem("raw"));
    ui->dataTable->scrollToBottom();
}
