#include <QApplication>
#include <QPalette>
#include <QColor>
#include <QStyleFactory>
#include "MainWindow.h"

/**
 * @brief Apply Hardware Pipeline v2 dark theme.
 *
 * Colour tokens:
 *   #0f1423  deep navy  (Window background)
 *   #1a2235  panel      (Base, Button)
 *   #00c6a7  teal       (Highlight, Link)
 */
static void applyDarkTheme(QApplication &app)
{
    app.setStyle(QStyleFactory::create("Fusion"));

    QPalette p;
    p.setColor(QPalette::Window,          QColor(15,  20,  35));
    p.setColor(QPalette::WindowText,      QColor(226, 232, 240));
    p.setColor(QPalette::Base,            QColor(26,  34,  53));
    p.setColor(QPalette::AlternateBase,   QColor(42,  58,  80));
    p.setColor(QPalette::ToolTipBase,     QColor(0,   198, 167));
    p.setColor(QPalette::ToolTipText,     QColor(15,  20,  35));
    p.setColor(QPalette::Text,            QColor(226, 232, 240));
    p.setColor(QPalette::Button,          QColor(26,  34,  53));
    p.setColor(QPalette::ButtonText,      QColor(226, 232, 240));
    p.setColor(QPalette::BrightText,      QColor(0,   198, 167));
    p.setColor(QPalette::Highlight,       QColor(0,   198, 167));
    p.setColor(QPalette::HighlightedText, QColor(15,  20,  35));
    p.setColor(QPalette::Link,            QColor(0,   198, 167));
    p.setColor(QPalette::LinkVisited,     QColor(139, 92,  246));
    app.setPalette(p);

    app.setStyleSheet(
        /* Buttons */
        "QPushButton{"
        "  background:#1a2235; color:#e2e8f0;"
        "  border:1px solid #2a3a50; border-radius:4px; padding:5px 14px;}"
        "QPushButton:hover{background:#2a3a50;}"
        "QPushButton:pressed{background:#00c6a7;color:#0f1423;}"
        "QPushButton:disabled{background:#0f1423;color:#475569;border-color:#1a2235;}"
        "QPushButton#connectButton{background:#00c6a7;color:#0f1423;font-weight:bold;}"
        "QPushButton#connectButton:hover{background:#00e5be;}"
        "QPushButton#disconnectButton{background:#dc2626;color:#fff;font-weight:bold;}"
        "QPushButton#disconnectButton:disabled{background:#0f1423;color:#475569;}"
        "QPushButton#sendButton{background:#00c6a7;color:#0f1423;font-weight:bold;}"
        /* Tabs */
        "QTabBar::tab{background:#1a2235;color:#94a3b8;padding:8px 20px;"
        "  border:none;margin-right:2px;}"
        "QTabBar::tab:selected{color:#00c6a7;border-bottom:2px solid #00c6a7;}"
        "QTabBar::tab:hover{color:#e2e8f0;}"
        "QTabWidget::pane{border:1px solid #2a3a50;}"
        /* Table */
        "QTableWidget{gridline-color:#2a3a50;border:1px solid #2a3a50;}"
        "QHeaderView::section{background:#1a2235;color:#94a3b8;"
        "  padding:4px;border:1px solid #2a3a50;}"
        /* Inputs */
        "QComboBox{background:#1a2235;color:#e2e8f0;"
        "  border:1px solid #2a3a50;border-radius:4px;padding:3px 8px;}"
        "QComboBox QAbstractItemView{background:#1a2235;color:#e2e8f0;"
        "  selection-background-color:#00c6a7;selection-color:#0f1423;}"
        "QLineEdit{background:#1a2235;color:#e2e8f0;"
        "  border:1px solid #2a3a50;border-radius:4px;padding:4px 8px;}"
        "QLineEdit:focus{border-color:#00c6a7;}"
        /* Log */
        "QTextEdit#logEdit{background:#0a0e1a;color:#94a3b8;"
        "  font-family:'Courier New',monospace;font-size:10pt;"
        "  border:1px solid #2a3a50;}"
        /* GroupBox */
        "QGroupBox{color:#94a3b8;border:1px solid #2a3a50;"
        "  border-radius:6px;margin-top:8px;padding:8px;}"
        "QGroupBox::title{subcontrol-origin:margin;left:10px;padding:0 4px;}"
        /* ProgressBar */
        "QProgressBar{border:1px solid #2a3a50;border-radius:4px;"
        "  text-align:center;color:#e2e8f0;}"
        "QProgressBar::chunk{background:#00c6a7;border-radius:4px;}"
        /* ListWidget */
        "QListWidget{background:#1a2235;color:#e2e8f0;border:1px solid #2a3a50;}"
        /* ScrollBar */
        "QScrollBar:vertical{background:#0f1423;width:8px;margin:0;}"
        "QScrollBar::handle:vertical{background:#2a3a50;border-radius:4px;}"
        "QScrollBar::add-line:vertical,QScrollBar::sub-line:vertical{height:0;}"
        /* StatusBar */
        "QStatusBar{background:#0f1423;color:#94a3b8;}"
    );
}

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    app.setApplicationName("fjxm");
    app.setApplicationVersion("1.0");
    app.setOrganizationName("Hardware Pipeline v2");

    applyDarkTheme(app);

    MainWindow w;
    w.setWindowTitle("fjxm — Hardware Pipeline v2");
    w.resize(1280, 800);
    w.show();

    return app.exec();
}
