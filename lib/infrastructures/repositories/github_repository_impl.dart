import 'dart:async';

import 'package:spike_flutter/domains/valueobjects/dto/search_result_dto.dart';
import 'package:spike_flutter/infrastructures/repositories/http/github_http_client.dart';


class GithubRepositoryImpl {

  Future<SearchResultDto> fetch(String freeword){
    GithubHttpClient client = new GithubHttpClient();
    return client.fetch(freeword);
  }
}