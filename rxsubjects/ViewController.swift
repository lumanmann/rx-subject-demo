//
//  ViewController.swift
//  rxsubjects
//
//  Created by Goons on 2020/10/12.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    enum Subjects: String, CaseIterable {
        case All
        case PublishSubject
        case BehaviorSubject
        case ReplaySubject
        case AsyncSubject
        case PublishRelay
        case BehaviorRelay
    }

    var selectedSubject: Subjects = .All {
        didSet {
            title = selectedSubject.rawValue
        }
    }
    
    var value = 0 {
        didSet {
            valueLabel.text = "value: \(value)"
        }
    }
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet var subjectsLabels: [UILabel]!
    
    let publishSubject = PublishSubject<Int>()
    let behaviorSubject = BehaviorSubject<Int>(value: -1)
    let replaySubject = ReplaySubject<Int>.create(bufferSize: 3)
    let asyncSubject = AsyncSubject<Int>()
    let publishRelay = PublishRelay<Int>()
    let behaviorRelay = BehaviorRelay<Int>(value: -1)
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedSubject = .All
        value = 0
        observeStream()
    }
    
    func observeStream() {
        
//        publishSubject.subscribe {[unowned self] (value) in
//            print("🍎 PublishSubject Event:", value)
//
//            self.subjectsLabels[0].text! += "-\(value)"
//        } onError: {[unowned self] (error) in
//            self.subjectsLabels[0].text! += "X"
//        } onCompleted: { [unowned self] in
//            self.subjectsLabels[0].text! += "-|"
//        } onDisposed: {
//            print("PublishSubject disposed")
//        }.disposed(by: disposeBag)


        publishSubject
          .subscribe {[unowned self] event in
            print("🍎 PublishSubject Event:", event)

            if event.isCompleted {
                self.subjectsLabels[0].text! += "-|"
            }

            guard let value = event.element else { return }
            self.subjectsLabels[0].text! += "-\(value)"

          }
          .disposed(by: disposeBag)

        
        
        behaviorSubject
          .subscribe {[unowned self] in
            print("🌲 BehaviorSubject Event:", $0)
            guard let value = $0.element else { return }
            self.subjectsLabels[1].text! += "-\(value)"
          }
          .disposed(by: disposeBag)
        
        replaySubject
          .subscribe {[unowned self] in
            print("🌝 ReplaySubject Event:", $0)
            guard let value = $0.element else { return }
            self.subjectsLabels[2].text! += "-\(value)"
          }
          .disposed(by: disposeBag)
        
        asyncSubject
          .subscribe {[unowned self] in
            print("🍄 AsyncSubject Event:", $0)
            guard let value = $0.element else { return }
            self.subjectsLabels[3].text! += "-\(value)"
          }
          .disposed(by: disposeBag)
        
        publishRelay
            .subscribe {[unowned self] in
              print("☘️ PublishRelay Event:", $0)
              guard let value = $0.element else { return }
              self.subjectsLabels[4].text! += "-\(value)"
            }
            .disposed(by: disposeBag)
        
        behaviorRelay
            .subscribe {[unowned self] in
              print("⭐️ BehaviorRelay Event:", $0)
              guard let value = $0.element else { return }
              self.subjectsLabels[5].text! += "-\(value)"
            }
            .disposed(by: disposeBag)
    }

    @IBAction func playClicked(_ sender: UIBarButtonItem) {
        value += 1
        switch selectedSubject {
        case .PublishSubject:
            publishSubject.onNext(value)
        case .BehaviorSubject:
            behaviorSubject.onNext(value)
        case .ReplaySubject:
            replaySubject.onNext(value)
        case .AsyncSubject:
            asyncSubject.onNext(value)
        case .PublishRelay:
            publishRelay.accept(value)
        case .BehaviorRelay:
            behaviorRelay.accept(value)
        default:
            publishSubject.onNext(value)
            behaviorSubject.onNext(value)
            replaySubject.onNext(value)
            asyncSubject.onNext(value)
            publishRelay.accept(value)
            behaviorRelay.accept(value)
        }
    }
    
    @IBAction func doneClicked(_ sender: UIBarButtonItem) {
        publishSubject.onCompleted()
        behaviorSubject.onCompleted()
        replaySubject.onCompleted()
        asyncSubject.onCompleted()
    }
    
    @IBAction func subscribeClicked(_ sender: UIBarButtonItem) {
        replaySubject
          .subscribe {[unowned self] in
            print("🌕 ReplaySubject 2 Event:", $0)
            guard let value = $0.element else { return }
            self.subjectsLabels[6].text! += "- \(value)"
          }
          .disposed(by: disposeBag)
    }
    
    @IBAction func editClicked(_ sender: UIBarButtonItem) {
        value = 0
        
        let controller = UIAlertController(title: "Choose subject", message: nil, preferredStyle: .actionSheet)
       
        for subject in Subjects.allCases {
            let action = UIAlertAction(title: subject.rawValue, style: .default) { [unowned self](action) in
                self.selectedSubject = Subjects(rawValue: action.title!)!
           }
           controller.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        present(controller, animated: true, completion: nil)
    }
}

