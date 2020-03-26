import UIKit

protocol TextEditor: UIView {
    var inputAccessoryView: UIView? { get set }

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
            editor?.resolvedNextFormResponder?.becomeFirstResponder()
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

    // Hide next button when resolvedNextFormResponder == nil.
    if editor.resolvedNextFormResponder == nil {
        toolbar.nextButtonItem.isEnabled = false
        toolbar.nextButtonItem.title = ""
    }
}
