//
//  HomeViewModel.swift
//  SmartMovie
//
//  Created by Hoang Viet on 29/03/2023.
//

import Foundation
import Alamofire

public enum APIError: Error {
    case unknowError
    case serverError
    case encodeParamsFailed
    case decodeDataFailed
}

final class HomeViewModel {
}

extension HomeViewModel: HomeViewModelProtocol {
    func getMoviesByCategory(category: String, page: Int, result: @escaping (Result<[Movie], APIError>) -> Void) {
        let url = "\(ServerConstant.URLBase.baseURL)\(category)?api_key=d5b97a6fad46348136d87b78895a0c06&page=\(page)"

        AF.request(url).responseDecodable(of: ResponseMoviesEntity.self) { response in
            switch response.result {
            case .success(let popularMoviesEntity):
                let movies = popularMoviesEntity.results
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
