import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var brutedPasswordLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var password = "bB51" {
        didSet {
            passwordLabel.text = password
        }
    }
    
    private var correctSymbols = [String]()
    var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .black
                self.brutedPasswordLabel.textColor = .white
            } else {
                self.view.backgroundColor = .white
                self.brutedPasswordLabel.textColor = .black
            }
        }
    }
    
    @IBAction func onBut(_ sender: Any) {
        isBlack.toggle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordLabel.isSecureTextEntry = true
        self.passwordLabel.text = password
    }
    
    func bruteForce(passwordToUnlock: String) {
        let ALLOWED_CHARACTERS: [String] = String().printable.map { String($0) }

        var password: String = ""

        // Will strangely ends at 0000 instead of ~~~
        while password != passwordToUnlock { // Increase MAXIMUM_PASSWORD_SIZE value for more
            password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
            // Your stuff here
            print(password)
            // Your stuff here
            DispatchQueue.main.async {
                if  self.correctSymbols.joined() == self.password {
                    self.brutedPasswordLabel.text = self.password
                    self.passwordLabel.isSecureTextEntry = false
                    self.generateButton.isEnabled = true
                    self.activityIndicator.stopAnimating()
                }
            }
        }
        print(password)
        correctSymbols.append(password)
    }
    
    @IBAction func generatePassword(_ sender: Any) {
        let queue = DispatchQueue(label: "queue", qos: .background, attributes: .concurrent)
        generateButton.isEnabled = false
        passwordLabel.isSecureTextEntry = true
        activityIndicator.startAnimating()
        correctSymbols = []
        var newPassword = String()
        let charecters: [String] = String().printable.map { String($0) }
        for _ in 0..<25 {
            newPassword.append(charecters[Int.random(in: 0..<charecters.count)])
        }
        password = newPassword
        for i in self.password {
            let dispatchWorkItem = DispatchWorkItem {
                self.bruteForce(passwordToUnlock: String(i))
            }
            queue.asyncAndWait(execute: dispatchWorkItem)
        }
    }
}

extension String {
    var digits:      String { return "0123456789" }
    var lowercase:   String { return "abcdefghijklmnopqrstuvwxyz" }
    var uppercase:   String { return "ABCDEFGHIJKLMNOPQRSTUVWXYZ" }
    var punctuation: String { return "!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~" }
    var letters:     String { return lowercase + uppercase }
    var printable:   String { return digits + letters + punctuation }

    mutating func replace(at index: Int, with character: Character) {
        var stringArray = Array(self)
        stringArray[index] = character
        self = String(stringArray)
    }
}

func indexOf(character: Character, _ array: [String]) -> Int {
    return array.firstIndex(of: String(character))!
}

func characterAt(index: Int, _ array: [String]) -> Character {
    return index < array.count ? Character(array[index])
                               : Character("")
}

func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
    var str: String = string

    if str.count <= 0 {
        str.append(characterAt(index: 0, array))
    }
    else {
        str.replace(at: str.count - 1,
                    with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))

        if indexOf(character: str.last!, array) == 0 {
            str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
        }
    }
    return str
}
