//
//  DemoViewController.swift
//  rxsubjects
//
//  Created by Goons on 2020/10/12.
//

import UIKit
import RxCocoa
import RxSwift

class DemoViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    let viewModel = DemoViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeStream()
        
    }
    
    func observeStream()  {
        
        button.rx.tap
            .subscribe(onNext: { [unowned self]  _ in
                self.viewModel.callAPI()
            }).disposed(by: disposeBag)
        
        viewModel.numberSubject
            .subscribe { [unowned self] event in
                self.label.text = "\(event.element)"
            }
            .disposed(by: disposeBag)
    }
    
    
}
