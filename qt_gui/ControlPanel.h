#ifndef CONTROLPANEL_H
#define CONTROLPANEL_H

#include <QWidget>

namespace Ui { class ControlPanel; }

/**
 * @class ControlPanel
 * @brief Manual command-entry panel with history list.
 * Layout defined in ControlPanel.ui.
 */
class ControlPanel : public QWidget
{
    Q_OBJECT
public:
    explicit ControlPanel(QWidget *parent = nullptr);
    ~ControlPanel();

signals:
    void commandSend(const QString &command);

private slots:
    void onSendClicked();

private:
    Ui::ControlPanel *ui;
};

#endif // CONTROLPANEL_H
