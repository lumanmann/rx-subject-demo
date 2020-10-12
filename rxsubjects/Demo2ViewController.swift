//
//  Demo2ViewController.swift
//  rxsubjects
//
//  Created by Goons on 2020/10/12.
//

import UIKit
import RxSwift

class Demo2ViewController: UIViewController {
    @IBOutlet weak var observableLabel1: UILabel!
    @IBOutlet weak var subjectLabel1: UILabel!
    @IBOutlet weak var observableLabel2: UILabel!
    @IBOutlet weak var subjectLabel2: UILabel!
    
    let observable = Observable<Int>.create { observer -> Disposable in
        
        observer.onNext(0)
        observer.onNext(1)
        observer.onNext(2)
        observer.onNext(3)
        observer.onNext(4)
        observer.onNext(5)
        observer.onNext(6)
        observer.onNext(7)
        observer.onNext(8)
        observer.onNext(9)
        observer.onCompleted()

        return Disposables.create()
    }
    let subject = PublishSubject<Int>()
    let disposeBag = DisposeBag()
    
    var value = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    
    @IBAction func playClicked(_ sender: Any) {
        value += 1
        subject.onNext(value)
    }
    
    @IBAction func subscribe1(_ sender: Any) {
        observable
            .subscribe(onNext: { [unowned self] num in
                print("1️⃣ observable:", num)
                self.observableLabel1.text! +=  "-\(num)"
            }, onError: { error in
                print("Error: \(error.localizedDescription)")
            }, onCompleted: {
                print("1️⃣ observable: complete")
            })
            .disposed(by: disposeBag)
        
        
        subject
            .subscribe {[unowned self] in
                print("1️⃣ subject:", $0)
                guard let value = $0.element else { return }
                self.subjectLabel1.text! += "-\(value)"
            }
            .disposed(by: disposeBag)
        
    }
    
    @IBAction func subscribe2(_ sender: Any) {
        observable
            .subscribe(onNext: { [unowned self] num in
                print("2️⃣ observable:", num)
                self.observableLabel2.text! +=  "-\(num)"
            }, onError: { error in
                print("Error: \(error.localizedDescription)")
            }, onCompleted: {
                print("2️⃣ observable: complete")
            })
            .disposed(by: disposeBag)
        
        
        subject
            .subscribe {[unowned self] in
                print("2️⃣ subject:", $0)
                guard let value = $0.element else { return }
                self.subjectLabel2.text! += "-\(value)"
            }
            .disposed(by: disposeBag)
    }
}
