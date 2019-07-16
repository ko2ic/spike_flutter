import 'dart:async';

import 'package:spike_flutter/domains/valueobjects/dto/search_result_dto.dart';
import 'package:spike_flutter/infrastructures/repositories/github_repository_impl.dart';


class Github {

  Future<SearchResultDto> fetch(String freeword){
    // TODO ここはインターフェイスにする
    var repository = GithubRepositoryImpl();
    return repository.fetch(freeword);
  }
}