import Formalist

class FormViewController: Formalist.FormViewController {
    init() {
        super.init(
            elements: [
                .inset(.init(top: 15, left: 15, bottom: 15, right: 15), elements: [
                    .staticText(
                        "This is an example of a Formalist.FormViewController subclass",
                        viewConfigurator: {
                            $0.textAlignment = .center
                            $0.font = .preferredFont(forTextStyle: .footnote)
                        }
                    ),
                ]),
            ]
        )
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
