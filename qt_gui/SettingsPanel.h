#ifndef SETTINGSPANEL_H
#define SETTINGSPANEL_H

#include <QWidget>

namespace Ui { class SettingsPanel; }

/**
 * @class SettingsPanel
 * @brief Serial port configuration (port, baud, data bits, parity, stop bits).
 * Layout defined in SettingsPanel.ui.
 */
class SettingsPanel : public QWidget
{
    Q_OBJECT
public:
    explicit SettingsPanel(QWidget *parent = nullptr);
    ~SettingsPanel();

    /** Reflect connected/disconnected state in UI (buttons, status label). */
    void setConnectedState(bool connected);

signals:
    void connectRequested(const QString &port, int baud);
    void disconnectRequested();

private slots:
    void onConnectClicked();
    void onDisconnectClicked();
    void onRefreshClicked();

private:
    void populatePorts();
    Ui::SettingsPanel *ui;
};

#endif // SETTINGSPANEL_H
