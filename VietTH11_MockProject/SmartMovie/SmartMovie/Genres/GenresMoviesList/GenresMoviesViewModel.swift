//
//  GenresMoviesViewModel.swift
//  SmartMovie
//
//  Created by Hoang Viet on 05/04/2023.
//

import Foundation
import Alamofire

final class GenresMoviesViewModel {

}

extension GenresMoviesViewModel: GenresMoviesViewModelProtocol {
    func requestMoviesByGenre(genreId: Int, result: @escaping (Result<[Movie], APIError>) -> Void) {
        let url =
        "https://api.themoviedb.org/3/discover/movie?api_key=d5b97a6fad46348136d87b78895a0c06&with_genres=\(genreId)"
        AF.request(url).responseDecodable(of: ResponseMoviesEntity.self) { response in
            switch response.result {
            case .success(let data):
                result(.success(data.results))
            case .failure(let error):
                print(error)
                result(.failure(.decodeDataFailed))
            }
        }
    }

    func getMovieDetail(movieId: Int, result: @escaping (Result<ResponseEntityMovieDetail, APIError>) -> Void) {
        let url = "https://api.themoviedb.org/3/movie/\(movieId)?api_key=d5b97a6fad46348136d87b78895a0c06"

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
