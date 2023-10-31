# iOS 개발 사전 과제
## 소개
- 요구 사항에 맞춰 메일플러그 게시판 화면을 만들기
- MVVM, Combine, SnapKit
- Deployment Target : iOS 14.0
- 진행 기간 : 2023.10.23 ~ 2023.10.28

## 요구사항

메일플러그 메일앱 게시판 화면 구현

- 게시글 리스트 화면
    - 네비게이션 바에 선택된 게시판 이름을 노출시켜주세요.
    - 선택된 게시판 게시글 목록을 노출시켜주세요.
    - 리스트 item 설명입니다 (설명되지 않은 부분은 디자인파일을 참고해주세요)
        - 날짜는 YY-MM-DD로 표기합니다.
    - 리스트 화면은 페이징으로 구현합니다.
        - 30개씩 로딩될 수 있도록 구현해주세요.
- 검색화면
    - 검색창이 포커싱된다면 다음과 같은 화면을 노출시킵니다.
        - 검색 내역 유/무에 따른 화면을 노출시켜주세요.
    - 검색어 입력시 전체 / 제목 / 내용 / 작성자 키워드 + 입력한 검색 내용을 보여주는 화면을 노출시킵니다.
        - (키워드 + 검색내용)을 클릭하면 검색 요청
    - 요청 응답을 전체 로딩합니다.
        - 검색 결과 유/무에 따른 화면을 노출시켜주세요.
    - 검색한 결과를 저장해, 검색 내역을 보여줍니다.
        - 검색 내역은 최신순으로 정렬해주세요.
        - 검색 내역에는 키워드, 검색어가 노출되도록 구현해주세요.
        - 검색 내역을 클릭하면 검색 되도록 구현해주세요.
        - 검색 내역은 중복되지 않게 구현해주세요.

## 주요 화면 및 기능

|게시판 조회|검색 기능|무한 스크롤|
|-|-|-|
|<img width="180" src="https://github.com/ijs1103/Cinexandria/assets/42196410/138428fe-1e04-44f8-9f99-2ac11be6b5ec">|<img width="180" src="https://github.com/ijs1103/Cinexandria/assets/42196410/a053fcf0-5053-4a17-84a3-927c4d61f887">|<img width="180" src="https://github.com/ijs1103/Cinexandria/assets/42196410/94b29370-36c9-4c2a-9713-390268ef2b91">


## STEP별 학습내용 
- [STEP1 : 게시판 구현](##STEP1-게시판-구현)
    + [키워드](#1-1-키워드)
    + [구현 내용](#1-2-구현-내용)
    + [아쉬운점](#1-3-아쉬운점)
- [STEP2 : 검색 구현](##STEP2-검색-구현)
    + [키워드](#2-1-키워드)
    + [구현 내용](#2-2-구현-내용)
- [STEP3 : 무한스크롤 구현](##STEP3-무한스크롤-구현)
    + [키워드](#3-1-키워드)
    + [구현 내용](#3-2-구현-내용)

## STEP1 모델/네트워킹 타입 구현
### 1-1 키워드
* 네트워크 : URLSession, HTTP Request/Response, 서버 API
* 비동기 작업 : completionHandler, escaping closure

### 1-2 구현 내용
* Parsing한 JSON 데이터를 Mapping할 Model 타입을 설계했습니다.  
* 서버와 통신하기 위해 URLSession을 활용했습니다. 
* 5종류의 게시판을 하나의 VC 및 VM으로 구현하였습니다.
* 메뉴화면의 게시판을 boardNo대로 정렬하였습니다.  
* 디자인 시안대로 커스텀폰트 및 색상을 구현하였습니다.  
* 네비게이션바에서 기본 생성되는 bottom border를 제거하였습니다. 

### 1-3 아쉬운점 
**메뉴화면을 FullScreen 화면으로 구현**

디자인 시안대로라면 햄버거 메뉴 버튼을 누르면 게시판 목록이 보이는 modal이 구현되어야 합니다. 하지만, 이대로 구현하다보니 게시판을 선택하여 이동할때마다
navigationbar의 title이 변경되지 않는 이슈가 발생하였습니다. 
메뉴화면을 게시판 화면 보다 상위의 UINavigationController로 설정하여 발생하는 이슈였습니다. 

```swift
// 변경 전 코드
@objc func didTapLeftBarButtonItem() {
        let vc = MenuVC()
        let navi = UINavigationController(rootViewController: vc)
        present(navi, animated: true)
    }

// 변경 후 코드
@objc func didTapLeftBarButtonItem() {
        let vc = MenuVC()
        navigationController?.pushViewController(vc, animated: true)
    }
```

비록, 메뉴화면을 modal이 아닌 full screen으로 구현하였지만 게시판이 변경 될때마다 게시판 제목은 변경할 수 있었습니다. 

## STEP2 검색 구현
### 2-1 키워드
* UITableView : Custom Cell, backgroundView
* View : UISearchController

   
### 2-2 구현 내용
* 게시판 화면에서 검색버튼을 누르면 검색 화면으로 전환합니다.
* 검색 화면에서 취소 버튼을 누르면 게시판 화면으로 돌아갑니다.
* 검색 기능은 요구사항 대로 모두 구현하였습니다.
* 검색 내역은 삭제가 가능하고 중복되지 않으며 최신순으로 정렬하였습니다.
* 검색 내역, 검색 결과가 없을경우에 해당되는 empty view도 구현하였습니다.
* 검색 창의 x버튼(지우기 버튼)을 클릭하면 검색 내역이 다시 보이도록 구현하였습니다.

**검색 내역 구현** 

UserDefaults에 검색 내역을 저장하였습니다.
검색 내역의 키워드와 검색어를 Composite key(복합키)로 설정하여 중복제거와 삭제기능 구현하는데 도움이 되었습니다. 검색 내역을 최신순으로 정렬하는 기능은 
검색 내역이 저장될때 배열의 첫번째에 삽입 하는것으로 구현하였습니다.
```swift
// datas: 검색내역이 저장되는 배열 
datas.insert(data, at: 0)
```

## 무한스크롤 구현
### 3-1 키워드
* UITableView : scrollViewDidScroll, tableFooterView
* Component : Spinner 

### 3-2 구현 내용

**유저가 스크롤시 게시판 글을 추가적으로 불러오기**

* 스크롤이 발생할때마다 게시판 화면의 UITableView가 끝에 도달하면 
게시판 글들을 추가로 fetch 하였습니다. 

* UX를 향상시키기 위하여 네트워킹 중에는 UITableView의 footerView에 spinner를 추가함으로써 로딩 상태를 표시해주었습니다. 

* 불필요한 네트워킹을 방지하기 위하여 스크롤을 빠르게 지속적으로 할경우  fetch가 실행될때 중복적인 fetching이 일어날 수 있는데 이를 방지하였습니다.

* 서버에 저장된 모든 게시판글을 불러왔다면 더이상 네트워킹을 하지 않도록 구현하였습니다. 


```swift
// ***************************
func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > tableView.contentSize.height - scrollView.frame.height {
            viewModel.fetchPosts(boardId: boardId)
        }
    }
}
// ***************************
viewModel.isLoading
            .receive(on: RunLoop.main)
            .sink { [unowned self] isLoading in
                self.tableView.tableFooterView = isLoading ? self.showSpinnerInFooter() : nil
            }.store(in: &subscriptions)
// ***************************
if res.limit >= res.total {
   self.isEnd = true
   print("게시판 끝 도달")
}
```



