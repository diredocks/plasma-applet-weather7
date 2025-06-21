import QtQuick
import QtQuick.Controls as QQC2
import org.kde.kcmutils as KCM
import org.kde.kirigami as Kirigami

KCM.SimpleKCM {
  id: generalConfigPage

  property alias cfg_City: cityField.text
  property alias cfg_Command: commandField.text
  property alias cfg_FontFamily: fontFamilyField.text
  property alias cfg_Interval: updateIntervalSpin.value

  Kirigami.FormLayout {
    QQC2.TextField {
      id: fontFamilyField
      text: plasmoid.configuration.FontFamily
      Kirigami.FormData.label: i18nc("@label", "Font Family:")
    }
    QQC2.TextField {
      id: commandField
      text: plasmoid.configuration.Command
      Kirigami.FormData.label: i18nc("@label", "Weather Script/Command:")
    }
    QQC2.TextField {
      id: cityField
      text: plasmoid.configuration.City
      Kirigami.FormData.label: i18nc("@label", "City Name:")
    }
    QQC2.SpinBox {
      id: updateIntervalSpin
      value: plasmoid.configuration.Interval
      Kirigami.FormData.label: i18nc("@label:spinbox", "Update every:")

      from: 30
      to: 3600
      editable: true

      textFromValue: function(value) {
        return (i18np("%1 minute", "%1 minutes", value));
      }
      valueFromText: function(text) {
        return parseInt(text);
      }
    }
  }
}
