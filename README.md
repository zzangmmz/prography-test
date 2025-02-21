# 🦾 프로그라피 10기 iOS 과제전형
---
TMDB API를 활용한 영화 리뷰 iOS 애플리케이션입니다. 
현재 상영작, 인기 영화, 평점 높은순의 영화들을 둘러보고 리뷰를 남길 수 있습니다.

---

## 🔧 요구사항
- Xcode 버전: 16.1 이상
- iOS 지원 버전: iOS 16.0 이상
- Swift 버전: Swift 5 이상

---

## 🛠️ 기술 스택
#### 최소 지원 버전: iOS 16.0
#### 아키텍처: MVVM
#### UI 프레임워크
  - UIKit: iOS UI 개발의 기본 프레임워크
#### 사용 라이브러리
  - SnapKit: 코드 기반 오토레이아웃 설정
  - RxSwift/RxCocoa: 반응형 프로그래밍 및 데이터 바인딩
  - Moya: 네트워크 추상화 레이어
  - Kingfisher: 이미지 캐싱 및 로딩

#### API
  - TMDB API: 영화 데이터 제공

---
## 💫 주요 기능
### 카테고리별 영화 목록 보기
| Now Playing | Popular | Top Rated |
| --- | --- | --- |
| <img width="300" alt="image" src="https://github.com/user-attachments/assets/ffa5b630-77bb-41a5-bfc3-9cb482c809d1"> | <img width="300" alt="image" src="https://github.com/user-attachments/assets/322d5a58-2a16-439b-9b17-bc144a69c6cc"> | <img width="300" alt="image" src="https://github.com/user-attachments/assets/6d0ac00d-acf9-40f2-b3ff-7c1b07e71b3e">|

- 현재 상영작 Now Playing, 인기 영화 Popular, 평점 높은순 Top Rated 카테고리에 해당하는 영화 목록을 확인할 수 있습니다.
- 무한스크롤로 더 많은 영화를 구경할 수 있습니다.

### 내가 리뷰 남긴 영화 모아보기

| 내가 리뷰 남긴 영화 모두 모아보기 | 리뷰 확인 or 리뷰 작성하기 |
| --- | --- |
| <img width="300" alt="image" src="https://github.com/user-attachments/assets/71470c87-4d9f-4be7-af7c-2b047f4bc481" /> | <img width="300" alt="image" src="https://github.com/user-attachments/assets/e94639c9-a0d3-4953-90dd-1f54fb1ccf22" /> |


- 내가 평점과 코멘트를 남긴 영화들을 모아볼 수 있습니다.
- 리뷰 수정/삭제가 가능합니다.

## 📝 커밋 컨벤션 & 브랜치 전략

### 커밋 컨벤션
| 태그 | 설명 |
|:---:|---|
| **[feat]** | 새로운 기능 추가 |
| **[fix]** | 버그 수정 |
| **[docs]** | 문서 수정 |
| **[style]** | 코드 포맷팅, 세미콜론 누락, 코드 변경이 없는 경우 |
| **[refactor]** | 코드 리팩토링 |
| **[test]** | 테스트 코드, 리팩토링 테스트 코드 추가 |
| **[chore]** | 빌드 업무 수정, 패키지 매니저 수정, 파일 이동, 에셋 추가 등 |
| **[rename]** | 파일 혹은 폴더명을 수정 |

### 브랜치 전략
1. **main 브랜치**: 프로젝트 기본 세팅
2. **develop 브랜치**: 메인 브랜치를 기준으로 생성
3. **feat 브랜치**:  
   - 브랜치 이름 형식: `작업번호-작업-제목` (예: `1-feat/detail`)
4. **작업 관리**:
   - 작업을 깃허브 프로젝트 칸반보드에 [ToDo → In Progress → PR → Done] 로 관리

