#ifndef LOGPANEL_H
#define LOGPANEL_H

#include <QWidget>

namespace Ui { class LogPanel; }

/**
 * @class LogPanel
 * @brief Colour-coded scrolling serial log.
 * Layout defined in LogPanel.ui.
 */
class LogPanel : public QWidget
{
    Q_OBJECT
public:
    explicit LogPanel(QWidget *parent = nullptr);
    ~LogPanel();

    /**
     * Append a colour-coded entry.
     * @param timestamp  hh:mm:ss.zzz string
     * @param type       "RX" | "TX" | "ERR" | "INF"
     * @param message    payload text
     */
    void appendEntry(const QString &timestamp,
                     const QString &type,
                     const QString &message);

private slots:
    void onClearClicked();

private:
    Ui::LogPanel *ui;
};

#endif // LOGPANEL_H
