//
//  SearchViewModel.swift
//  SmartMovie
//
//  Created by Hoang Viet on 03/04/2023.
//

import Foundation
import Alamofire

final class SearchViewModel {

}

extension SearchViewModel: SearchViewModelProtocol {
    func requestMoviesBySearch(searchText: String, result: @escaping (Result<[Movie], APIError>) -> Void) {
    let url = "https://api.themoviedb.org/3/search/movie?api_key=d5b97a6fad46348136d87b78895a0c06&query=\(searchText)"
        AF.request(url).responseDecodable(of: ResponseMoviesEntity.self) { response in
            switch response.result {
            case .success(let responseMoviesEntity):
                let movies = responseMoviesEntity.results
                result(.success(movies))
            case .failure(let error):
                print(error)
                result(.failure(.decodeDataFailed))
            }
        }
    }

    func getMovieDetail(movieId: Int, result: @escaping (Result<ResponseEntityMovieDetail, APIError>) -> Void) {
        let url = "\(ServerConstant.URLBase.baseURL)\(movieId)?api_key=d5b97a6fad46348136d87b78895a0c06"

        AF.request(url).responseDecodable(of: ResponseEntityMovieDetail.self) { response in
            switch response.result {
            case .success(let movieDetailEntity):
                result(.success(movieDetailEntity))
            case .failure(let error):
                print(error)
                result(.failure(.decodeDataFailed))
            }
        }
    }
}
