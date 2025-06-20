import QtQuick
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami

QQC2.Pane {
    id: root

    property alias cfg_City: cityField.text
    property alias cfg_Command: commandField.text
    property alias cfg_FontFamily: fontFamilyField.text
    property alias cfg_Interval: intervalField.value

    Kirigami.FormLayout {
        anchors.fill: parent

        QQC2.TextField {
            id: fontFamilyField
            text: plasmoid.configuration.FontFamily
            Kirigami.FormData.label: i18nc("@label", "Font Family")
            onTextChanged: plasmoid.configuration.FontFamily = text
        }
        QQC2.TextField {
            id: commandField
            text: plasmoid.configuration.Command
            Kirigami.FormData.label: i18nc("@label", "Weather Script/Command")
            onTextChanged: plasmoid.configuration.Command = text
        }
        QQC2.TextField {
            id: cityField
            text: plasmoid.configuration.City
            Kirigami.FormData.label: i18nc("@label", "City Name")
            onTextChanged: plasmoid.configuration.City = text
        }
        QQC2.SpinBox {
            id: intervalField
            value: plasmoid.configuration.Interval
            from: 1
            Kirigami.FormData.label: i18nc("@label", "Interval (in Minute)")
            onValueChanged: plasmoid.configuration.Interval = value
        }
    }
}
