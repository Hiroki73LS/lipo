import SwiftUI
import Combine

class KeyboardObserver: ObservableObject {

  @Published var keyboardHeight: CGFloat = 0.0

  /// Observerの追加
  func addObserver() {
    NotificationCenter
      .default
      .addObserver(self,
                   selector: #selector(self.keyboardWillChangeFrame(_:)),
                   name: UIResponder.keyboardWillChangeFrameNotification,
                   object: nil)
  }

  /// Observerの削除
  func removeObserver() {
    NotificationCenter
      .default
      .removeObserver(self,
                      name: UIResponder.keyboardWillChangeFrameNotification,
                      object: nil)
  }

  /// キーボードのフレーム検知処理
  /// - Parameter notification: Notification
  @objc func keyboardWillChangeFrame(_ notification: Notification) {
    if let endFrame = notification
      .userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
    let beginFrame = notification
      .userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue {
      let endFrameMinY: CGFloat = endFrame.cgRectValue.minY
      let beginFrameMinY: CGFloat = beginFrame.cgRectValue.minY

      self.keyboardHeight = beginFrameMinY - endFrameMinY
      if self.keyboardHeight < 0 {
        self.keyboardHeight = 0
      }
    }
  }

}

