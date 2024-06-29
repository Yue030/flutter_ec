import 'file_agent_data.dart';

class AccountInformation {
  final String accountId;
  final String email;
  final String name;
  final String roleType;
  final FileAgentData? avatar;
  final DateTime createDateTime;
  final DateTime? updateDateTime;

  AccountInformation(this.accountId, this.email, this.name, this.roleType, this.avatar,
      this.createDateTime, this.updateDateTime);

  AccountInformation.fromJson(Map<String, dynamic> json)
      : accountId = json["account_id"],
        email = json["email"],
        name = json["name"],
        roleType = json["role_type"],
        avatar = json["avatar"] == null ? null : FileAgentData.fromJson(json["avatar"]),
        createDateTime = DateTime.parse(json["create_date_time"]),
        updateDateTime = DateTime.tryParse(json["update_date_time"] ?? "");


  Map<String, dynamic> toJson() => {};
}