#ifndef DASHBOARDPANEL_H
#define DASHBOARDPANEL_H

#include <QWidget>

namespace Ui { class DashboardPanel; }

/**
 * @class DashboardPanel
 * @brief Live-data dashboard: stat cards, data table, progress bar.
 * Layout defined entirely in DashboardPanel.ui (Qt Designer).
 */
class DashboardPanel : public QWidget
{
    Q_OBJECT
public:
    explicit DashboardPanel(QWidget *parent = nullptr);
    ~DashboardPanel();

    /** Called by MainWindow on every incoming serial packet. */
    void handleIncomingData(const QByteArray &data);

private:
    Ui::DashboardPanel *ui;
    int m_packetCount;
};

#endif // DASHBOARDPANEL_H
