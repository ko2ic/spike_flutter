import 'package:spike_flutter/domains/valueobjects/dto/permission_dto.dart';


class RepoEntity {

  const RepoEntity({
    this.name,
    this.fullName,
    this.stars,
    this.permissions
  });

  final String name;
  final String fullName;
  final int stars;
  final PermissionDto permissions;

  factory RepoEntity.fromJson(Map<String, dynamic> json) {

    var permissions = json['permissions'];
    PermissionDto dto = new PermissionDto();
    if (permissions != null){
      dto.haveAdmin = permissions['admin'] ?? false;
      dto.havePushAuthorizetion = permissions['push'] ?? false;
      dto.havePullAuthorizetion = permissions['pull'] ?? false;
    }

    return new RepoEntity(
      name: json['name'],
      fullName: json['full_name'],
      stars: json['stargazers_count'],
      permissions:dto,
    );
  }
}