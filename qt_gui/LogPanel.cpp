#include "LogPanel.h"
#include "ui_LogPanel.h"

LogPanel::LogPanel(QWidget *parent)
    : QWidget(parent)
    , ui(new Ui::LogPanel)
{
    ui->setupUi(this);
    connect(ui->clearButton, &QPushButton::clicked,
            this,            &LogPanel::onClearClicked);
}

LogPanel::~LogPanel()
{
    delete ui;
}

void LogPanel::appendEntry(const QString &timestamp,
                            const QString &type,
                            const QString &message)
{
    /* Colour per type — using existing ui->logEdit; no new widget */
    QString colour = "#94a3b8";
    if      (type == "RX")  colour = "#00c6a7";
    else if (type == "TX")  colour = "#3b82f6";
    else if (type == "ERR") colour = "#dc2626";
    else if (type == "INF") colour = "#f59e0b";

    const QString html = QString(
        "<span style=\"color:#64748b\">[%1]</span> "
        "<span style=\"color:%2;font-weight:bold\">[%3]</span> "
        "<span style=\"color:#e2e8f0\">%4</span>"
    ).arg(timestamp, colour, type, message.toHtmlEscaped());

    ui->logEdit->append(html);
}

void LogPanel::onClearClicked()
{
    ui->logEdit->clear();
}
