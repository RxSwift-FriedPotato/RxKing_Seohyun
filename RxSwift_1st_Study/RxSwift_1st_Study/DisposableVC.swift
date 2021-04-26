//
//  DisposableVC.swift
//  RxSwift_1st_Study
//
//  Created by 장서현 on 2021/04/23.
//

import UIKit
import RxSwift

class DisposableVC: UIViewController {

    // MARK : - IBOutlet
    
    @IBOutlet weak var secLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var secondSecLabel: UILabel!
    
    // MARK : - 변수
    
    var count = 0.0 /// 50000000까지 카운트 할 변수
    var timer : Timer? /// 타이머 변수
    var disposable : Disposable? /// Disposable
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTimer() /// 타이머 시작하기
        isCompletedCount() /// 50000000까지 카운트하면 라벨 텍스트 바꾸는 함수
    }
    
    // MARK: - 카운트와 타이머 시작하는 함수
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    @objc func update() {
        count += 0.1
        secLabel.text = String(format: "%.1f", count) + String("초가 걸렸어요")
        secondSecLabel.text = String(format: "%.1f", count) + String("초가 걸렸어요")
    }
    
    // MARK: - 카운트가 끝나면 라벨 텍스트 바꾸는 함수
    
    func isCompletedCount() {
        disposable = rxCountNumber()
            .observe(on: MainScheduler.instance)
            .subscribe({[weak self] _ in
                self?.completedLabel.text = "Completed!"
            })
    }
    
    func countNumber(completed: @escaping (Bool?) -> Void) {
        DispatchQueue.global().async {
            for _ in 0...50000000 {
            } /// 카운트 끝나면
            self.timer?.invalidate() /// 타이머 끝내기
            completed(true)
        }
    }
    
    // MARK: - Observable 생성
    
    func rxCountNumber() -> Observable<Bool> {
        return Observable.create { [weak self] o in
            self?.countNumber{ (result) in
                // 데이터가 발생했을 때
                o.onNext(result ?? false)
                // 모든 이벤트가 완료되었을 때
                o.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    // MARK: - stop 버튼
    
    @IBAction func stopBtn(_ sender: Any) {
        disposable?.dispose()
        timer?.invalidate()
        completedLabel.text = "취소되었습니다"
    }
}
