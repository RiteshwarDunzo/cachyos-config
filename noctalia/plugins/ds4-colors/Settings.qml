import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
    id: root
    property var pluginApi: null

    readonly property var cfg: pluginApi?.pluginSettings || ({})
    readonly property var defaults: pluginApi?.manifest?.metadata?.defaultSettings || ({})

    property string valueColor: cfg.color ?? defaults.color ?? "#0064ff"
    property bool valueColorIcon: cfg.colorIcon ?? defaults.colorIcon ?? false
    property bool valueHideOnEmpty: cfg.hideOnEmpty ?? defaults.hideOnEmpty ?? false
    property var valueRecentColors: cfg.recentColors ?? defaults.recentColors ?? []

    spacing: Style.marginL

    NText {
        text: pluginApi?.tr("settings.lightbar_color")
        pointSize: Style.fontSizeM
        font.weight: Font.Bold
        color: Color.mOnSurface
    }

    NColorPicker {
        Layout.fillWidth: true
        selectedColor: root.valueColor
        onColorSelected: color => root.valueColor = color
    }

    // Recent colors swatches — only shown when there is history
    ColumnLayout {
        Layout.fillWidth: true
        spacing: Style.marginS
        visible: root.valueRecentColors.length > 0

        NText {
            text: pluginApi?.tr("settings.recent_colors")
            pointSize: Style.fontSizeS
            font.weight: Font.Bold
            color: Color.mOnSurface
        }

        GridLayout {
            Layout.fillWidth: true
            columns: 8
            rowSpacing: Style.marginS
            columnSpacing: Style.marginS

            Repeater {
                model: root.valueRecentColors
                delegate: Rectangle {
                    required property string modelData
                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 32
                    radius: Style.radiusS
                    color: modelData
                    border.color: root.valueColor === modelData ? Color.mPrimary : Color.mOutline
                    border.width: root.valueColor === modelData ? Style.borderS * 2 : Style.borderS

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.valueColor = modelData
                    }
                }
            }
        }
    }

    NDivider {
        Layout.fillWidth: true
    }

    NText {
        text: pluginApi?.tr("settings.widget_settings")
        pointSize: Style.fontSizeM
        font.weight: Font.Bold
        color: Color.mOnSurface
    }

    NToggle {
        Layout.fillWidth: true
        label: pluginApi?.tr("settings.color_icon.label")
        description: pluginApi?.tr("settings.color_icon.desc")
        checked: root.valueColorIcon
        onToggled: checked => root.valueColorIcon = checked
    }

    NToggle {
        Layout.fillWidth: true
        label: pluginApi?.tr("settings.hide_empty.label")
        description: pluginApi?.tr("settings.hide_empty.desc")
        checked: root.valueHideOnEmpty
        onToggled: checked => root.valueHideOnEmpty = checked
    }

    NDivider {
        Layout.fillWidth: true
    }

    NText {
        text: pluginApi?.tr("settings.info")
        pointSize: Style.fontSizeM
        font.weight: Font.Bold
        color: Color.mOnSurface
    }

    NBox {
        Layout.fillWidth: true
        implicitHeight: infoColumn.implicitHeight + Style.marginXL

        ColumnLayout {
            id: infoColumn

            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: Style.marginM
            spacing: Style.marginS

            NText {
                text: pluginApi?.tr("settings.info_desc1")
                pointSize: Style.fontSizeS
                color: Color.mOnSurface
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }

            NText {
                text: pluginApi?.tr("settings.info_desc2")
                pointSize: Style.fontSizeS
                color: Color.mSecondary
                wrapMode: Text.Wrap
                Layout.fillWidth: true
            }
        }
    }

    // Called by the shell when the user clicks "Save"
    function saveSettings() {
        if (!pluginApi) return

        // Prepend the new color and keep the last 8 unique entries
        const next = [root.valueColor]
            .concat((root.valueRecentColors || []).filter(c => c !== root.valueColor))
            .slice(0, 8)

        pluginApi.pluginSettings.color = root.valueColor
        pluginApi.pluginSettings.colorIcon = root.valueColorIcon
        pluginApi.pluginSettings.hideOnEmpty = root.valueHideOnEmpty
        pluginApi.pluginSettings.recentColors = next
        root.valueRecentColors = next
        pluginApi.saveSettings()

        // Apply the new color to the controller immediately
        pluginApi.mainInstance?.applyColors()
    }
}
