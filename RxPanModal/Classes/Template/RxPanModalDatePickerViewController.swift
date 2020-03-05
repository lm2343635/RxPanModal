//
//  RxPanModalDatePickerViewController.swift
//  PanModal
//
//  Created by Meng Li on 2020/03/05.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import SnapKit
import PanModal

private enum Const {
    
    static let height: CGFloat = 291
    
    enum Drag {
        static let size = CGSize(width: 35, height: 6)
        static let marginTop = 6
    }
    
    enum Picker {
        static let marginTop = 15
    }
    
    enum Done {
        static let marginRight = 16
    }
    
}

public struct RxPanModalDatePickerItem: RxPanModalItem {
    
    public struct Date {
        public let year: Int
        public let month: Int
        public let day: Int
    }
    
    public static let controllerType: RxPanModalPresentable.Type = RxPanModalDatePickerViewController.self
    
    public typealias DidSelectItem = (Date) -> Void
    
    let theme: RxPanModalPickerTheme
    let title: String
    let done: String
    let didSelectItemAt: DidSelectItem?
    let doneAt: DidSelectItem?
    
    public init(
        theme: RxPanModalPickerTheme = .dark,
        title: String,
        done: String,
        didSelectItemAt: DidSelectItem? = nil,
        doneAt: DidSelectItem? = nil
    ) {
        self.theme = theme
        self.title = title
        self.done = done
        self.didSelectItemAt = didSelectItemAt
        self.doneAt = doneAt
    }
    
}

class RxPanModalDatePickerViewController: UIViewController {
    
    private lazy var blurView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.effect = item.theme.blurEffect
        view.alpha = item.theme.blurAlpha
        return view
    }()
    
    private lazy var dragView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0x5e5e5e)
        view.layer.cornerRadius = Const.Drag.size.height / 2
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = item.theme.titleColor
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.text = item.title
        return label
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle(item.done, for: .normal)
        button.addTarget(self, action: #selector(done), for: .touchUpInside)
        button.setTitleColor(item.theme.doneColor, for: .normal)
        button.setTitleColor(item.theme.doneColor?.lighter(), for: .highlighted)
        return button
    }()
    
    private lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.dataSource = self
        pickerView.delegate = self
        return pickerView
    }()
    
    private let years = Array(1970...2100)
    private let months = Array(1...12)
    private var days = Array(1...31)
    
    private var year = 1970
    private var month = 1
    private var day = 1
    
    private let item: RxPanModalDatePickerItem
    
    required public init(item: RxPanModalDatePickerItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = item.theme.backgroundColor
        view.addSubview(blurView)
        view.addSubview(dragView)
        view.addSubview(titleLabel)
        view.addSubview(doneButton)
        view.addSubview(pickerView)
        createConstraints()
        
        // Init date
        let date = Date()
        let calendar = Calendar.current
        year = calendar.component(.year, from: date)
        month = calendar.component(.month, from: date)
        day = calendar.component(.day, from: date)
        days = Array(1...daysCount(month: month, year: year))
        pickerView.reloadAllComponents()
        pickerView.selectRow(years.firstIndex(of: year) ?? 0, inComponent: 0, animated: false)
        pickerView.selectRow(months.firstIndex(of: month) ?? 0, inComponent: 1, animated: false)
        pickerView.selectRow(days.firstIndex(of: day) ?? 0, inComponent: 2, animated: false)
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Update the background color of picker seperator lines.
        pickerView.subviews.filter { $0.frame.height == 0.5 }.forEach {
            $0.backgroundColor = item.theme.pickerSeperatorColor
        }
    }
    
    open override var shouldAutorotate: Bool {
        return false
    }
    
    private func createConstraints() {
        
        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        dragView.snp.makeConstraints {
            $0.size.equalTo(Const.Drag.size)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(Const.Drag.marginTop)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(dragView.snp.bottom)
            $0.bottom.equalTo(pickerView.snp.top)
        }
        
        doneButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            
            if #available(iOS 11.0, *) {
                $0.right.equalTo(view.safeAreaLayoutGuide.snp.right).offset(-Const.Done.marginRight)
            } else {
                $0.right.equalToSuperview().offset(-Const.Done.marginRight)
            }
        }
        
        pickerView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
        }
        
    }
    
    @objc private func done() {
        dismiss(animated: true)
        item.doneAt?(.init(year: year, month: month, day: day))
    }
    
    private func daysCount(month: Int, year: Int) -> Int {
        if [1, 3, 5, 7, 8, 10, 12].contains(month) {
            return 31
        } else if month == 2 {
            if year % 4 == 0 && year % 100 != 0 {
                return 29
            } else if year % 400 == 0 {
                return 29
            } else {
                return 28
            }
        } else {
            return 30
        }
    }
    
}

extension RxPanModalDatePickerViewController: UIPickerViewDataSource {
    
    private var components: [[Int]] {
        [years, months, days]
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        3
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        components[component].count
    }
    
    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let data = components[component][row]
        var string = data.description
        if data < 10 {
            string = "0" + string
        }
        return NSAttributedString(string: string, attributes: item.theme.pickerTitleAttributes)
    }
    
}

extension RxPanModalDatePickerViewController: UIPickerViewDelegate {
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        guard 0..<components.count ~= component, 0..<components[component].count ~= row else {
            return
        }
        switch component {
        case 0:
            year = components[component][row]
            days = Array(1...daysCount(month: month, year: year))
            pickerView.reloadComponent(2)
        case 1:
            month = components[component][row]
            days = Array(1...daysCount(month: month, year: year))
            pickerView.reloadComponent(2)
        case 2:
            day = components[component][row]
        default:
            break
        }
        
        item.didSelectItemAt?(.init(year: year, month: month, day: day))
    }
    
}

extension RxPanModalDatePickerViewController: RxPanModalPresentable {
    
    public static func create(item: RxPanModalItem) -> Self? {
        guard let item = item as? RxPanModalDatePickerItem else {
            return nil
        }
        return self.init(item: item)
    }
    
    public var panScrollable: UIScrollView? {
        return nil
    }
    
    public var longFormHeight: PanModalHeight {
        return .contentHeightIgnoringSafeArea(Const.height)
    }
    
    public var showDragIndicator: Bool {
        return false
    }
    
}
