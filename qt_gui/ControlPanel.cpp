#include "ControlPanel.h"
#include "ui_ControlPanel.h"

ControlPanel::ControlPanel(QWidget *parent)
    : QWidget(parent)
    , ui(new Ui::ControlPanel)
{
    ui->setupUi(this);
    connect(ui->sendButton,  &QPushButton::clicked,
            this,            &ControlPanel::onSendClicked);
    connect(ui->commandEdit, &QLineEdit::returnPressed,
            this,            &ControlPanel::onSendClicked);
}

ControlPanel::~ControlPanel()
{
    delete ui;
}

void ControlPanel::onSendClicked()
{
    const QString cmd = ui->commandEdit->text().trimmed();
    if (cmd.isEmpty())
        return;

    /* Prepend to history list — existing widget, no new widget created */
    ui->historyList->insertItem(0, cmd);
    if (ui->historyList->count() > 50)
        delete ui->historyList->takeItem(ui->historyList->count() - 1);

    ui->commandEdit->clear();
    emit commandSend(cmd);
}
