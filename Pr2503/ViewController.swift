import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var brutedPasswordLabel: UILabel!
    @IBOutlet weak var passwordLabel: UITextField! {
        didSet {
            if brutedPasswordLabel.text == password {
                passwordLabel.isSecureTextEntry = false
            }
        }
    }
    private var password = "0012" {
        didSet {
            passwordLabel.text = password
        }
    }
    
    var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .black
            } else {
                self.view.backgroundColor = .white
            }
        }
    }
    
    @IBAction func onBut(_ sender: Any) {
        isBlack.toggle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bruteForce(passwordToUnlock: password)
        self.generateButton.addTarget(self, action: #selector(generatePassword), for: .touchUpInside)
        self.passwordLabel.isSecureTextEntry = true
        self.passwordLabel.text = password
        
        // Do any additional setup after loading the view.
    }
    
    func bruteForce(passwordToUnlock: String) {
        let ALLOWED_CHARACTERS: [String] = String().printable.map { String($0) }

        var password: String = ""

        // Will strangely ends at 0000 instead of ~~~
        while password != passwordToUnlock { // Increase MAXIMUM_PASSWORD_SIZE value for more
            password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)
//             Your stuff here
            print(password)
            brutedPasswordLabel.text = password
            // Your stuff here
        }
        
        print(password)
        brutedPasswordLabel.text = password
    }
    
    @objc func generatePassword() {
        var newPassword = String()
        let charecters: [String] = String().printable.map { String($0) }
        for _ in 0..<4 {
            newPassword.append(charecters[Int.random(in: 0..<charecters.count)])
        }
        password = newPassword
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

