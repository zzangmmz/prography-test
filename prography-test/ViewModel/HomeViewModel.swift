//
//  HomeViewModel.swift
//  prography-test
//
//  Created by 이명지 on 2/20/25.
//

import RxSwift
import RxCocoa

final class HomeViewModel {
   private var disposeBag = DisposeBag()
   private let movieRepository: MovieRepositoryProtocol
   
   // 현재 페이지 상태 관리
   private var currentPage = BehaviorRelay<Int>(value: 1)
   private var isLoading = BehaviorRelay<Bool>(value: false)
   private var hasNextPage = BehaviorRelay<Bool>(value: true)
   
   private(set) var nowPlayingMovies = BehaviorRelay<[Movie]>(value: [])
   private(set) var popularMovies = BehaviorRelay<[Movie]>(value: [])
   private(set) var topRatedMovies = BehaviorRelay<[Movie]>(value: [])
   private(set) var selectedCategory = BehaviorRelay<MovieCategory>(value: .nowPlaying)
   
   init(movieRepository: MovieRepositoryProtocol = MovieRepository()) {
       self.movieRepository = movieRepository
       
       // 카테고리가 변경될 때마다 페이지 상태 초기화
       selectedCategory
           .distinctUntilChanged()
           .subscribe(onNext: { [weak self] _ in
               self?.resetPaginationState()
           })
           .disposed(by: disposeBag)
   }
   
   private func resetPaginationState() {
       currentPage.accept(1)
       isLoading.accept(false)
       hasNextPage.accept(true)
       
       // 현재 카테고리의 데이터 초기화
       switch selectedCategory.value {
       case .nowPlaying:
           nowPlayingMovies.accept([])
       case .popular:
           popularMovies.accept([])
       case .topRated:
           topRatedMovies.accept([])
       }
       
       // 첫 페이지 로드
       loadMoreMovies()
   }
   
   func loadMoreMovies() {
       // 이미 로딩 중이거나 다음 페이지가 없으면 중단
       guard !isLoading.value && hasNextPage.value else { return }
       
       isLoading.accept(true)
       
       let page = currentPage.value
       
       switch selectedCategory.value {
       case .nowPlaying:
           fetchNowPlayingMovies(page: page)
       case .popular:
           fetchPopularMovies(page: page)
       case .topRated:
           fetchTopRatedMovies(page: page)
       }
   }
   
   func fetchNowPlayingMovies(page: Int = 1) {
       movieRepository.fetchMovies(of: .nowPlaying, page: page)
           .observe(on: MainScheduler.instance)
           .subscribe(
               onSuccess: { [weak self] response in
                   guard let self = self else { return }
                   
                   let currentMovies = self.nowPlayingMovies.value
                   let newMovies = currentMovies + response.results
                   
                   self.nowPlayingMovies.accept(newMovies)
                   self.currentPage.accept(page + 1)
                   self.hasNextPage.accept(response.page < response.totalPages)
                   self.isLoading.accept(false)
               },
               onFailure: { [weak self] error in
                   print("🚨 now playing 불러오기 오류:", error)
                   self?.isLoading.accept(false)
               }
           )
           .disposed(by: disposeBag)
   }
   
   func fetchPopularMovies(page: Int = 1) {
       movieRepository.fetchMovies(of: .popular, page: page)
           .observe(on: MainScheduler.instance)
           .subscribe(
               onSuccess: { [weak self] response in
                   guard let self = self else { return }
                   
                   let currentMovies = self.popularMovies.value
                   let newMovies = currentMovies + response.results
                   
                   self.popularMovies.accept(newMovies)
                   self.currentPage.accept(page + 1)
                   self.hasNextPage.accept(response.page < response.totalPages)
                   self.isLoading.accept(false)
               },
               onFailure: { [weak self] error in
                   print("🚨 popular 불러오기 오류:", error)
                   self?.isLoading.accept(false)
               }
           )
           .disposed(by: disposeBag)
   }
   
   func fetchTopRatedMovies(page: Int = 1) {
       movieRepository.fetchMovies(of: .topRated, page: page)
           .observe(on: MainScheduler.instance)
           .subscribe(
               onSuccess: { [weak self] response in
                   guard let self = self else { return }
                   
                   let currentMovies = self.topRatedMovies.value
                   let newMovies = currentMovies + response.results
                   
                   self.topRatedMovies.accept(newMovies)
                   self.currentPage.accept(page + 1)
                   self.hasNextPage.accept(response.page < response.totalPages)
                   self.isLoading.accept(false)
               },
               onFailure: { [weak self] error in
                   print("🚨 topRated 불러오기 오류:", error)
                   self?.isLoading.accept(false)
               }
           )
           .disposed(by: disposeBag)
   }
   
   func updateSelectedCategory(_ category: MovieCategory) {
       selectedCategory.accept(category)
   }
}
