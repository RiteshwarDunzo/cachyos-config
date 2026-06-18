import QtQuick
import Quickshell
import qs.Commons
import qs.Services.UI
import qs.Widgets

Item {
    id: root

    // Injected properties
    property var pluginApi: null
    property ShellScreen screen
    property string widgetId: ""
    property string section: ""
    property int sectionWidgetIndex: -1
    property int sectionWidgetsCount: 0

    // Bar layout
    readonly property string screenName: screen?.name ?? ""
    readonly property string barPosition: Settings.getBarPositionForScreen(screenName)
    readonly property bool isVertical: barPosition === "left" || barPosition === "right"
    readonly property real capsuleHeight: Style.getCapsuleHeightForScreen(screenName)

    // Settings
    readonly property var cfg: pluginApi?.pluginSettings || ({})
    readonly property var defaults: pluginApi?.manifest?.metadata?.defaultSettings || ({})

    // State from Main.qml
    readonly property var mainInstance: pluginApi?.mainInstance
    readonly property var controllers: mainInstance?.controllers ?? ({})
    readonly property int controllerCount: Object.keys(controllers).length
    readonly property bool isApplying: mainInstance?.isApplying ?? false

    readonly property string currentColor: cfg.color ?? defaults.color ?? "#0000ff"
    readonly property bool colorIcon: cfg.colorIcon ?? defaults.colorIcon ?? false
    readonly property bool hideOnEmpty: cfg.hideOnEmpty ?? defaults.hideOnEmpty ?? false

    // Battery from first controller
    readonly property var firstController: controllerCount > 0
        ? controllers[Object.keys(controllers)[0]]
        : null
    readonly property int batteryLevel: firstController?.batteryLevel ?? -1

    visible: !hideOnEmpty || controllerCount > 0

    implicitWidth: isVertical ? capsuleHeight : contentWidth
    implicitHeight: isVertical ? contentHeight : capsuleHeight

    readonly property real iconSize: Style.toOdd(capsuleHeight * 0.55)
    readonly property real contentWidth: Style.marginM * 2 + (batteryLevel >= 0 ? batteryIcon.implicitWidth : iconSize)
    readonly property real contentHeight: isVertical ? capsuleHeight * 2 : capsuleHeight

    Rectangle {
        id: capsule
        x: Style.pixelAlignCenter(parent.width, width)
        y: Style.pixelAlignCenter(parent.height, height)
        width: root.contentWidth
        height: root.contentHeight
        radius: Style.radiusL
        color: Style.capsuleColor
        border.color: Style.capsuleBorderColor
        border.width: Style.capsuleBorderWidth

        NIcon {
            id: mainIcon
            visible: batteryLevel < 0
            anchors.centerIn: parent
            icon: controllerCount === 0 ? "bluetooth-off" : "device-gamepad"
            pointSize: root.iconSize
            color: controllerCount === 0 ? Color.mOnSurfaceVariant : (colorIcon ? Qt.color(currentColor) : Color.mPrimary)
        }

        NBattery {
            id: batteryIcon
            visible: batteryLevel >= 0
            anchors.centerIn: parent
            vertical: root.isVertical
            percentage: batteryLevel >= 0 ? batteryLevel : 0
            ready: true
            charging: false
            pluggedIn: false
            low: batteryLevel <= 20
            critical: batteryLevel <= 10
            baseSize: Style.fontSizeM
            
            baseColor: colorIcon ? Qt.color(currentColor) : Color.mPrimary
            chargingColor: baseColor
            lowColor: Color.mError
            textColor: Color.mSurface
        }

        NBusyIndicator {
            visible: isApplying
            running: isApplying
            anchors.centerIn: parent
            implicitWidth: root.iconSize
            implicitHeight: root.iconSize
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onClicked: mouse => {
                if (mouse.button === Qt.LeftButton) {
                    BarService.openPluginSettings(root.screen, pluginApi.manifest)
                } else if (mouse.button === Qt.RightButton) {
                    PanelService.showContextMenu(contextMenu, root, screen)
                }
            }

            onEntered: {
                let text = controllerCount > 0
                    ? pluginApi?.tr("bar.controllers.count", { count: controllerCount })
                    : pluginApi?.tr("bar.controllers.none")
                if (batteryLevel >= 0) text += "\n" + pluginApi?.tr("bar.battery", { level: batteryLevel })
                if (mainInstance?.lastError) text += "\n" + pluginApi?.tr("bar.error", { msg: mainInstance.lastError })
                TooltipService.show(root, text, BarService.getTooltipDirection(root.screen?.name))
            }
            onExited: TooltipService.hide()
        }
    }

    NPopupContextMenu {
        id: contextMenu
        model: [
            { "label": pluginApi?.tr("menu.settings"), "action": "settings", "icon": "settings" },
            { "label": pluginApi?.tr("menu.scan"), "action": "scan", "icon": "refresh" }
        ]
        onTriggered: action => {
            contextMenu.close()
            PanelService.closeContextMenu(screen)
            if (action === "settings") {
                BarService.openPluginSettings(root.screen, pluginApi.manifest)
            } else if (action === "scan") {
                mainInstance?.scanControllers()
            }
        }
    }
}
