import UIKit

protocol TextEditor: class {
    var nextFormResponder: UIView? { get }

    var inputAccessoryView: UIView? { get set }

    @discardableResult func resignFirstResponder() -> Bool

    func reloadInputViews()
}

extension UITextField: TextEditor {}
extension UITextView: TextEditor {}

func presentToolbar(with editor: TextEditor, configuration: TextEditorConfiguration) {
    let toolbar = AccessoryViewToolbar(
        frame: .zero,
        doneButtonCustomTitle: configuration.doneButtonCustomTitle
    )
    toolbar.callbacks = AccessoryViewToolbarCallbacks(
        nextAction: { [weak editor] in
            editor?.nextFormResponder?.becomeFirstResponder()
            configuration.textEditorAction?(.next)
        },
        doneAction: { [weak editor] in
            editor?.resignFirstResponder()
            configuration.textEditorAction?(.done)
        }
    )
    toolbar.sizeToFit()
    editor.inputAccessoryView = toolbar
    editor.reloadInputViews()

    // Hide next button when nextFormResponder == nil.
    if editor.nextFormResponder == nil {
        toolbar.nextButtonItem.isEnabled = false
        toolbar.nextButtonItem.title = ""
    }
}
