# 약쏙

![약쏙 썸네일](https://github.com/user-attachments/assets/c98d1c6f-54db-4cd2-8f0a-baab44b8148a)

### 영양제 잊지 말고 약쏙하세요!

> 영양제 복용을 손쉽게 관리하고, 섭취 습관을 개선할 수 있도록 캘린더, 차트, 알림, 검색 기능 등을 제공하는 스마트 헬스케어 앱입니다.
> 

[약쏙 앱스토어 다운로드](https://apps.apple.com/kr/app/%EC%95%BD%EC%8F%99/id6479728847)

---

# 📚 목차

1. [⭐️ 주요 기능](#features)
2. [📸 스크린샷](#screenshots)
3. [💻 개발 환경](#development-environment)
4. [📋 설계 패턴](#design-patterns)
   - [Input-Output Custom Reactive MVVM](#input-output-custom-reactive-mvvm)
   - [싱글턴 패턴](#singleton-pattern)
5. [🛠️ 기술 스택](#tech-stack)
6. [🚀 트러블 슈팅](#troubleshooting)
   - [iOS 알림 제한 문제 해결: 영양제 등록 로직 최적화](#notification-limit-issue)
   - [Realm 데이터 삭제 안정화: 영양제 체크 해제 문제 해결](#realm-delete-issue)
7. [🗂️ 파일 디렉토리 구조](#file-structure)
8. [🛣️ 향후 계획](#future-plans)

---

<h1 id="features">⭐️ 주요 기능</h1>

**1. 영양제 등록 및 수정**

- **등록**: 사용자가 섭취 중인 영양제를 간편하게 등록할 수 있습니다.
- **수정**: 등록된 영양제의 이름, 복용 요일, 시간 등을 언제든지 수정할 수 있습니다.

**2. 캘린더로 영양제 섭취 스케줄 확인**

- **요일별 캘린더 뷰**: 영양제 섭취 요일과 시간을 캘린더에서 한눈에 확인할 수 있습니다.
- **주간 및 월간 뷰 지원**: 일주일 또는 한 달 단위로 섭취 스케줄을 효율적으로 관리할 수 있습니다.

**3. 차트로 보는 영양제 섭취율**

- **섭취율 차트 제공**: 사용자가 얼마나 규칙적으로 영양제를 섭취했는지, 섭취율을 시각적으로 볼 수 있습니다.
- **분석 데이터 제공**: 요일별, 시간별 섭취 패턴을 확인하여 복용 습관을 개선할 수 있도록 도움을 줍니다.

**4. 로컬 알림 기능**

- **복용 시간 알림**: 사용자가 설정한 요일과 시간에 맞춰 영양제 복용 알림을 받을 수 있습니다.
- **반복 알림 지원**: 주기적으로 알림을 받을 수 있어 복용을 놓치지 않도록 관리합니다.
- **맞춤 알림 메시지**: 각 영양제에 대한 개별 알림 메시지를 전송합니다.

**5. 네트워크 기반 영양제 검색 기능**

- **영양제 데이터베이스 검색**: 네트워크를 통해 원하는 영양제를 검색할 수 있습니다.
- **자동 완성 지원**: 검색어 입력 시 유사한 영양제 목록을 자동으로 추천합니다.
- **추가 정보 확인**: 검색한 영양제의 상세 정보(성분, 효능 등)를 확인 후 등록 가능합니다.

---

<h1 id="screenshots">📸 스크린샷</h1>

| 영양제 등록 | 총 보유량 | 복용 요일 | 복용 시간 | 복용 시간 디테일 |
|-------------|---------------|----------------|----------------|----------------|
| <img src="https://github.com/user-attachments/assets/c2a59c88-67cf-44ed-b87c-9aa0bcceba39" width="200"> | <img src="https://github.com/user-attachments/assets/73f6a1ac-a451-4a68-9e73-8b6729fa4906" width="200"> | <img src="https://github.com/user-attachments/assets/f3c2a770-5ad0-42ca-95fa-b20530d42bac" width="200"> | <img src="https://github.com/user-attachments/assets/1a0dcfef-3a88-4ffb-a450-5d658a34b857" width="200"> | <img src="https://github.com/user-attachments/assets/59093516-c070-4d5a-b735-1ec56f523be8" width="200"> |

| 영양제 검색 | 영양제 관리 | 내 영양제 | 섭취 알림 | 보유량 알림 |
|-------------|-------------|-------------|-------------|-------------|
| <img src="https://github.com/user-attachments/assets/f590f42d-4538-4ec4-adf4-c93d4afbc825" width="200"> | <img src="https://github.com/user-attachments/assets/53246c77-48b6-42e3-8fd4-0654361097ae" width="200"> |  <img src="https://github.com/user-attachments/assets/7e8e2b7f-82f1-4adf-a0d7-80ac2bae14ed" width="200"> | <img src="https://github.com/user-attachments/assets/5a296577-3131-4b90-a124-600158d04c0e" width="200"> | <img src="https://github.com/user-attachments/assets/855e0e7c-7e58-4072-8557-17e1ee79b1d3" width="200"> |

---

<h1 id="development-environment">💻 개발 환경</h1>

- **개발 기간**:
- **앱 지원 iOS SDK**: iOS 16.0 이상
- **위젯 지원 iOS SDK**: iOS 17.0 이상
- **Xcode**: 15.0 이상
- **Swift 버전**: 5.8 이상

---

<h1 id="design-patterns">📋 설계 패턴</h1>

- **Input-Output Custom Reactive MVVM**: UI와 비즈니스 로직 분리
- **싱글턴 패턴**: 전역적으로 관리가 필요한 객체를 재사용하기 위해 사용

<h2 id="input-output-custom-reactive-mvvm">Input-Output Custom Reactive MVVM</h2>

UI와 비즈니스 로직의 명확한 분리를 위해 **Custom Observable 기반의 Input-Output Reactive MVVM**을 적용하였습니다. 외부 라이브러리를 따로 사용하지 않고, 직접 프로젝트 요구사항에 맞춘 경량화된 데이터 바인딩 구조를 구현했습니다.

### **적용 이유**

- **UI와 로직의 분리:** View는 UI 렌더링과 사용자 이벤트를 전달하는 역할만 담당하며, 비즈니스 로직은 ViewModel에 집중합니다.
- **경량화된 데이터 바인딩:** 외부 라이브러리(RxSwift, Combine)를 사용하지 않고, Custom Observable을 구현하여 데이터 바인딩과 상태 관리를 효율적으로 처리했습니다.
- **명확한 데이터 흐름:** Input-Output 구조를 통해 View와 ViewModel 간의 데이터 흐름을 명확히 정의하고, 유지보수성을 높였습니다.
- **유연성과 확장성:** Custom Observable을 통해 경량화된 반응형 프로그래밍이 가능하며, 프로젝트의 특성에 맞는 유연한 확장을 지원합니다.

### **구현 방식 (예제 코드)**

1. **Custom Observable 정의**
    - 데이터 변경을 감지하고 이를 구독자(뷰)에게 전달하는 `Observable` 클래스를 직접 구현
    
    ```swift
    final class Observable<T> {
        private var closure: ((T) -> Void)?
    
        var value: T {
            didSet {
                closure?(value)
            }
        }
    
        init(_ value: T) {
            self.value = value
        }
    
        func bind(_ closure: @escaping (T) -> Void) {
            closure(value)
            self.closure = closure
        }
    }
    ```
    
2. **ViewModel의 Input-Output 구조**
    - **Input**: View에서 발생하는 사용자 이벤트를 ViewModel로 전달
    - **Output**: ViewModel에서 처리된 데이터를 View에 전달
    
    ```swift
    final class CalendarViewModel {
        // Input
        let inputSelectedDate: Observable<Date> = Observable(FSCalendar().today!)
        let inputCheck: Observable<(Date?, ObjectId?)> = Observable((nil, nil))
        let inputCombinedCheck: Observable<(Date, Date?, ObjectId?)> = Observable((FSCalendar().today!, nil, nil))
    
        // Output
        let outputData: Observable<[(key: Date, value: [MySupplement])]> = Observable([])
        let outputCheckData: Observable<[CheckSupplement]> = Observable([])
        let outputCheckStatus: Observable<(CheckStatus, CheckSupplement?, MySupplement?)> = Observable((.unchecked, nil, nil))
    
        init() {
            bindInputs()
        }
    
        private func bindInputs() {
            inputSelectedDate.bind { [weak self] date in
                // 날짜 선택에 따른 데이터 업데이트
            }
    
            inputCheck.bind { [weak self] (time, pk) in
                // 체크 액션 처리
            }
    
            inputCombinedCheck.bind { [weak self] (date, time, pk) in
                // Combined 체크 상태 관리
            }
        }
    }
    ```
    
3. **View에서의 데이터 바인딩**
    - View는 `bind` 메서드를 통해 ViewModel의 Output을 구독하고, 상태 변화에 따라 UI를 업데이트
    
    ```swift
    private func bindData() {
        viewModel.outputData.bind { [weak self] value in
            self?.tableView.reloadData()
        }
    
        viewModel.outputCheckStatus.bind { [weak self] (status, checkData, data) in
            guard let self = self else { return }
            self.handleCheckStatus(status, checkData, data)
        }
    }
    
    private func handleCheckStatus(_ status: CheckStatus, _ checkData: CheckSupplement?, _ data: MySupplement?) {
        switch status {
        case .checked:
            viewModel.repository.deleteCheckItem(checkData!)
        case .uncheckedAndNotDue:
            present(AlertManager.shared.showAlert(...))
        case .unchecked:
            viewModel.repository.createCheckItem(checkData!)
        }
        tableView.reloadData()
    }
    ```
    

### **향후 계획**

- **테스트 강화**: ViewModel에서 정의된 Output을 기반으로 단위 테스트 작성
- **DI(Dependency Injection) 적용**: ViewModel과 Repository 간의 의존성을 명확히 관리
- **Combine 도입 검토**: Swift에서 기본으로 제공하는 Combine 프레임워크를 활용하여 더 효율적인 Reactive 프로그래밍 구현 가능성 탐색

<h2 id="singleton-pattern">싱글턴 패턴</h2>

전역적으로 관리가 필요한 객체들에 대해 **싱글턴 패턴**을 적용하여 일관성과 성능 최적화를 도모했습니다.

### **적용 이유**

- **일관된 전역 관리**: 동일한 인스턴스를 재사용하여 코드 일관성 유지
- **성능 최적화**: `DateFormatter`와 같은 비용이 큰 객체의 재사용을 통해 성능 향상
- **중복 방지**: 반복적인 리소스 초기화 방지 및 전역 접근 보장

---

<h1 id="tech-stack">🛠️ 기술 스택</h1>

### **기본 구성**

- **UIKit**: iOS 사용자 인터페이스 구현
- **SnapKit**: 간결한 Auto Layout 코드 작성
- **Codebase UI**: 코드 기반으로 UI를 설계하여 Storyboard 의존성 제거
- **DiffableDataSource**: 리스트 및 컬렉션 뷰의 데이터 소스 관리
- **Pagination**: 효율적인 데이터 로드 및 무한 스크롤 구현

### **비동기 처리 및 데이터 관리**

- **Codable**: 네트워크 응답 데이터의 디코딩 및 인코딩을 통해 JSON 데이터 처리
- **Alamofire**: 네트워크 요청 및 응답 관리
- **Firebase**: 백엔드 통합 (Crashlytics, Analytics 등)

### **데이터 관리**

- **Realm**: 경량 데이터베이스로 로컬 데이터 관리

### **UI 및 사용자 경험**

- **LocalNotification**: 로컬 알림을 통한 사용자 리마인더 및 알림
- **Kingfisher**: 네트워크 이미지를 간편하게 로드 및 캐싱
- **Toast-Swift**: 사용자 알림 메시지 표시
- **FSCalendar**: 커스터마이징 가능한 캘린더 UI
- **DGCharts**: 데이터 시각화를 위한 다양한 차트 지원
- **Lottie**: JSON 기반 애니메이션을 통해 사용자 경험 강화

---

<h1 id="troubleshooting">🚀 트러블 슈팅</h1>

<h2 id="notification-limit-issue">iOS 알림 제한 문제 해결: 영양제 등록 로직 최적화</h2>

### **1. 문제 요약**

- **이슈 제목:** Realm에 영양제 등록 시 알림 수 초과로 인한 문제 발생
- **발생 위치:** 영양제 등록 및 알림 설정 로직
- **관련 컴포넌트:**`UNUserNotificationCenter`, `MySupplement` 객체, Realm 데이터베이스

### **2. 문제 상세**

- **현상 설명:**
    - 사용자가 설정한 영양제 복용 시간 및 요일에 따라 Realm에 객체를 저장하고 알림을 등록하는 과정에서 문제가 발생.
    - iOS 알림 시스템에는 횟수 제한이 있어, 64개를 초과하는 경우 알림이 울리지 않는 문제가 발생.
    - 예시: A 영양제가 매일 오전 9시와 오후 2시에 섭취되도록 설정하고 복용 기간이 1개월이라면, Realm에 약 60개의 객체가 저장됨. 동일한 형태의 영양제를 10개만 추가해도 Realm에 600개의 객체가 추가되며, 이로 인해 600개의 알림이 등록됨.
- **기존 해결 방법의 문제점:**
    - `ViewDidLoad` 시점마다 가장 가까운 시일의 64개 알림을 새로 등록하는 방법을 사용했으나, 사용자가 앱에 접속하지 않으면 알림이 울리지 않는 문제가 발생함.

### **3. 기존 코드 및 원인 분석**

- **기존 코드:**
    
    ```swift
    createTrigger.bind { [weak self] value in
        guard let self = self else { return }
        guard let _ = value else { return }
        
        // 이전 코드 생략
            
        let data = MySupplement(name: outputName.value, amout: outputAmount.value, startDay: outputStartDay.value, period: outputPeriod.value, endDay: outputEndDay.value, cycleArray: outputCycle.value, timeArray: outputTimeList.value)
        
        if outputImage.value != ImageStyle.supplement {
            ImageDocumentManager.shared.saveImageToDocument(image: outputImage.value, fileName: "\\(data.pk)")
        }
        
        repository.createItem(data)
        
        generateScheduledSupplements(startDay: outputStartDay.value)
        
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        NotificationManager.shared.scheduleNotificationsFromSchedule(createGroupDataDict())
    }
    ```
    
- **원인 분석:**
    - 영양제 등록 시 각 요일과 시간에 대해 객체를 개별적으로 저장하다 보니, 객체 수와 이에 따른 알림 수가 급격히 증가하여 64개의 알림 제한을 초과하게 됨. 이는 알림이 울리지 않는 원인이 됨.

### **4. 해결 방법 및 수정된 코드**

- **해결 방법:**
    - **데이터 구조 변경:**
        - 요일과 시간 별로 각각 저장하는 대신, 하나의 객체로 저장하고 알림 갯수를 시뮬레이션하여 64개를 초과할 경우 사용자에게 경고 메시지를 전달.
    - **알림 최적화:**
        - 앱에서 사용자 알림을 효율적으로 관리하기 위해 기존 데이터에 임시 데이터를 추가하여 알림 수를 시뮬레이션하고, 64개를 초과하지 않도록 조정.
- **수정된 코드:**
    - **영양제 등록 로직:**
    
    ```swift
    createTrigger.bind { [weak self] value in
        guard let self = self else { return }
        guard let _ = value else { return }
    
        // 이전 코드 생략
    
        // 임시 데이터
        let temporaryData = MySupplement(name: outputName.value, amount: outputAmount.value, stock: outputStock.value, startDay: outputStartDay.value, cycleArray: outputCycle.value, timeArray: outputTimeList.value)
    
        // 기존 데이터에 임시 데이터를 추가하여 알림 갯수를 시뮬레이션
        var allSupplements = repository.fetchItem()
        allSupplements.append(temporaryData)
    
        if totalTimesCount(from: convertToDictionary(supplements: allSupplements)) >= 64 {
            outputRegistrationStatus.value = .limitExceeded
            return
        }
    
        let data = MySupplement(name: outputName.value, amount: outputAmount.value, stock: outputStock.value, startDay: outputStartDay.value, cycleArray: outputCycle.value, timeArray: outputTimeList.value)
    
        if outputImage.value != ImageStyle.supplement {
            ImageDocumentManager.shared.saveImageToDocument(image: outputImage.value, fileName: "\\(data.pk)")
        }
    
        repository.createItem(data)
    
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        NotificationManager.shared.scheduleLocalNotifications(for: convertToDictionary(supplements: repository.fetchItem()))
    }
    ```
    
    - **데이터 변환 로직:**
    
    ```swift
    private func convertToDictionary(supplements: [MySupplement]) -> [(Int, [Date])] {
        var resultDict: [Int: [Date]] = [:]
    
        for supplement in supplements {
            for day in supplement.cycle {
                let dayNumber = DateFormatterManager.shared.dayOfWeekToNumber(day)
                for time in supplement.time {
                    resultDict.append(value: time, forKey: dayNumber)
                }
            }
        }
    
        let sortedDict = resultDict.sorted { $0.key < $1.key }
        return sortedDict
    }
    
    private func totalTimesCount(from dictionary: [(Int, [Date])]) -> Int {
        return dictionary.reduce(0) { $0 + $1.1.count }
    }
    ```
    
    - **알림 등록 로직:**
    
    ```swift
    func scheduleLocalNotifications(for schedule: [(Int, [Date])]) {
        let center = UNUserNotificationCenter.current()
    
        for (weekday, times) in schedule {
            for time in times {
                var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
                dateComponents.weekday = weekday
    
                let content = UNMutableNotificationContent()
                content.title = "영양제 드시기로 약속한 시간입니다💜"
                content.body = "영양제 챙겨 드시고, 약속에서 기록하세요!"
                content.sound = UNNotificationSound.default
    
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
                center.add(request) { error in
                    if let error = error {
                        print("알림 등록 실패: \\(error)")
                    } else {
                        print("알림 등록 성공")
                    }
                }
            }
        }
    }
    ```

### **5. 결론**

- **알림 관리 최적화:**
    - 데이터를 효율적으로 관리하고, 알림 수를 제한하여 Realm과 알림 시스템의 과부하를 방지.
- **사용자 경험 개선:**
    - 알림 수 초과로 인한 오류를 방지함으로써 앱의 안정성을 높임.
- **최종 결과:**
    - 알림 등록 및 관리가 정상적으로 이루어지며, 64개 제한 문제도 해결됨.

<h2 id="realm-delete-issue">Realm 데이터 삭제 안정화: 영양제 체크 해제 문제 해결</h2>

### **1. 문제 요약**

- **이슈 제목:** Realm에서 객체 삭제 시 런타임 오류 발생
- **발생 위치:** 사용자가 영양제 체크를 해제할 때
- **관련 컴포넌트:** `CheckSupplement` 객체, Realm 데이터베이스

### **2. 문제 상세**

- **현상 설명:**
    - 사용자가 영양제 체크를 해제할 때, `CheckSupplement` 객체를 Realm에서 삭제하려고 시도하면 런타임 오류가 발생.
- **에러 메시지:**
    
    ```swift
    *** Terminating app due to uncaught exception 'RLMException', reason: 'Can only delete an object from the Realm it belongs to.'
    ```
    
- **에러 분석:**
    - Realm 인스턴스에서 관리되지 않는 객체를 삭제하려고 할 때 발생. 삭제 대상 객체가 현재 Realm 인스턴스에 속해 있지 않으면 문제가 발생.

### **3. 기존 코드 및 원인 분석**

- **기존 코드:**
    
    ```swift
    inputCombinedCheck.bind { [weak self] (date, time, pk) in
        guard let self = self else { return }
        guard let time = time, let pk = pk else { return }
    
        let data = CheckSupplement(date: date, time: time, fk: pk)
    
        if repository.fetchCheckItemBySelectedDate(selectedDate: date).contains(where: {
            DateFormatterManager.shared.makeHeaderDateFormatter2(date: $0.time) == DateFormatterManager.shared.makeHeaderDateFormatter2(date: time)
            && $0.fk == pk
        }) {
            outputCheckStatus.value = (.checked, data)
        } else if date > FSCalendar().today! && !repository.fetchCheckItemBySelectedDate(selectedDate: date).contains(where: { $0 == data })  {
            outputCheckStatus.value = (.uncheckedAndNotDue, data)
        } else {
            outputCheckStatus.value = (.unchecked, data)
        }
    }
    ```
    
- **원인 분석:**
    - Realm 객체를 삭제할 때 문제가 되는 이유는, 새로 생성한 `CheckSupplement` 객체가 현재 Realm 인스턴스에 속하지 않기 때문임. Realm은 인스턴스에 속하지 않은 객체의 삭제를 허용하지 않음.

### **4. 해결 방법 및 수정된 코드**

- **해결 방법:**
    - **기존 객체 사용:**
        - Realm에서 객체를 직접 삭제하려면 해당 객체가 Realm 인스턴스에서 관리되고 있어야 함. 따라서 객체를 새로 생성하지 않고, 기존 객체를 fetch하여 사용함으로써 문제를 해결.
- **수정된 코드:**
    
    ```swift
    inputCombinedCheck.bind { [weak self] (date, time, pk) in
        guard let self = self else { return }
        guard let time = time, let pk = pk else { return }
    
        let existingCheckItems = repository.fetchCheckItemBySelectedDate(selectedDate: date)
        if let existingData = existingCheckItems.first(where: {
            DateFormatterManager.shared.makeHeaderDateFormatter2(date: $0.time) == DateFormatterManager.shared.makeHeaderDateFormatter2(date: time)
            && $0.fk == pk
        }) {
            outputCheckStatus.value = (.checked, existingData)
        } else {
            let newData = CheckSupplement(date: date, time: time, fk: pk)
            if date > FSCalendar().today! && !existingCheckItems.contains(where: { $0 == newData })  {
                outputCheckStatus.value = (.uncheckedAndNotDue, newData)
            } else {
                outputCheckStatus.value = (.unchecked, newData)
            }
        }
    }
    ```

### **5. 결론**

- **Realm 객체의 일관성 유지:**
    - 기존 Realm 인스턴스에서 관리되는 객체를 사용하여 오류를 방지.
- **데이터 무결성 확보:**
    - Realm의 관리 범위 내에서 안전하게 객체를 삭제함으로써 데이터 무결성을 유지.
- **최종 결과:**
    - 문제가 해결되어, 사용자가 영양제 체크를 해제할 때 런타임 오류가 발생하지 않음.

---

<h1 id="file-structure">🗂️ 파일 디렉토리 구조</h1>

```
Yakssok
 ┣ Add
 ┃ ┣ Cycle
 ┃ ┃ ┣ .DS_Store
 ┃ ┃ ┣ CycleCollectionViewCell.swift
 ┃ ┃ ┣ CycleViewController.swift
 ┃ ┃ ┗ CycleViewModel.swift
 ┃ ┣ Image
 ┃ ┃ ┣ ImageCollectionViewCell.swift
 ┃ ┃ ┣ ImageTypeSelectTableViewCell.swift
 ┃ ┃ ┣ ImageTypeSelectViewController.swift
 ┃ ┃ ┗ ImageTypeSelectViewModel.swift
 ┃ ┣ Period
 ┃ ┃ ┣ PeriodViewController.swift
 ┃ ┃ ┗ PeriodViewModel.swift
 ┃ ┣ StartDay
 ┃ ┃ ┣ StartDayViewController.swift
 ┃ ┃ ┗ StartDayViewModel.swift
 ┃ ┣ Stock
 ┃ ┃ ┣ StockViewController.swift
 ┃ ┃ ┗ StockViewModel.swift
 ┃ ┣ Time
 ┃ ┃ ┣ TimePickerViewController.swift
 ┃ ┃ ┣ TimePickerViewModel.swift
 ┃ ┃ ┣ TimeTableViewCell.swift
 ┃ ┃ ┣ TimeViewController.swift
 ┃ ┃ ┗ TimeViewModel.swift
 ┃ ┣ .DS_Store
 ┃ ┣ AddViewController.swift
 ┃ ┣ AddViewModel.swift
 ┃ ┣ AmountCollectionViewCell.swift
 ┃ ┣ CommonCollectionViewCell.swift
 ┃ ┗ NameCollectionViewCell.swift
 ┣ Assets.xcassets
 ┃ ┣ AccentColor.colorset
 ┃ ┃ ┗ Contents.json
 ┃ ┣ AppIcon.appiconset
 ┃ ┃ ┣ Contents.json
 ┃ ┃ ┗ 제목을 입력해주세요_-001 (3).jpg
 ┃ ┣ logo.imageset
 ┃ ┃ ┣ Contents.json
 ┃ ┃ ┣ 제목을_입력해주세요__복사본-001-removebg-preview.png
 ┃ ┃ ┣ 제목을_입력해주세요__복사본-001-removebg-preview@2x.png
 ┃ ┃ ┗ 제목을_입력해주세요__복사본-001-removebg-preview@3x.png
 ┃ ┣ pill.imageset
 ┃ ┃ ┣ Contents.json
 ┃ ┃ ┣ icons8-medicine-100 (1).png
 ┃ ┃ ┣ icons8-medicine-100 (1)@2x.png
 ┃ ┃ ┗ icons8-medicine-100 (1)@3x.png
 ┃ ┗ Contents.json
 ┣ Base
 ┃ ┣ BaseCollectionReusableView.swift
 ┃ ┣ BaseCollectionViewCell.swift
 ┃ ┣ BaseTableViewCell.swift
 ┃ ┣ BaseView.swift
 ┃ ┗ BaseViewController.swift
 ┣ Base.lproj
 ┃ ┣ LaunchScreen.storyboard
 ┃ ┗ Main.storyboard
 ┣ Calendar
 ┃ ┣ Cell
 ┃ ┃ ┣ CalendarTableViewCell.swift
 ┃ ┃ ┣ ChartTableViewCell.swift
 ┃ ┃ ┣ EmptyTableViewCell.swift
 ┃ ┃ ┗ ScheduleTableViewCell.swift
 ┃ ┣ CalendarViewController.swift
 ┃ ┣ CalendarViewModel.swift
 ┃ ┗ ScheduleHeaderView.swift
 ┣ Custom
 ┃ ┣ CustomCalendar.swift
 ┃ ┣ CustomChartView.swift
 ┃ ┣ CustomImageView.swift
 ┃ ┣ CustomLabel.swift
 ┃ ┣ CustomTextField.swift
 ┃ ┣ LogoView.swift
 ┃ ┗ SplashView.swift
 ┣ DesignSystem
 ┃ ┣ ColorStyle.swift
 ┃ ┣ FontStyle.swift
 ┃ ┗ ImageStyle.swift
 ┣ Extension
 ┃ ┣ Dictionary+Extension.swift
 ┃ ┣ Notification.Name+Extension.swift
 ┃ ┣ UIButton.Configuration+Extension.swift
 ┃ ┣ UIColor+Extension.swift
 ┃ ┣ UISheetPresentationController.Detent+Extension.swift
 ┃ ┣ UITextField+Extension.swift
 ┃ ┗ UIView+Extension.swift
 ┣ Lottie
 ┃ ┣ congratulation.json
 ┃ ┗ splash.json
 ┣ Manager
 ┃ ┣ AlertManager.swift
 ┃ ┣ DateFormatterManager.swift
 ┃ ┣ ImageDocumentManager.swift
 ┃ ┣ NotificationManager.swift
 ┃ ┣ NumberFormatterManager.swift
 ┃ ┣ SearchManger.swift
 ┃ ┗ ToastManager.swift
 ┣ My
 ┃ ┣ Cell
 ┃ ┃ ┗ MyCollectionViewCell.swift
 ┃ ┣ .DS_Store
 ┃ ┣ MyViewController.swift
 ┃ ┗ MyViewModel.swift
 ┣ Network
 ┃ ┣ APIKey.swift
 ┃ ┣ APIService.swift
 ┃ ┣ Supplement.swift
 ┃ ┗ SupplementAPI.swift
 ┣ Realm
 ┃ ┣ MySupplement.swift
 ┃ ┣ MySupplements.swift
 ┃ ┗ SupplementRepository.swift
 ┣ Search
 ┃ ┣ SearchResultTableViewCell.swift
 ┃ ┣ SearchViewController.swift
 ┃ ┗ SearchViewModel.swift
 ┣ .DS_Store
 ┣ AppDelegate.swift
 ┣ Info.plist
 ┣ Observable.swift
 ┣ SceneDelegate.swift
 ┗ ViewController.swift
```

---

<h1 id="future-plans">🛣️ 향후 계획</h1>

- 한 달 영양제 섭취 완료율 차트 제공
