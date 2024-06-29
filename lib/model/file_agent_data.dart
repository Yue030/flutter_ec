class FileAgentData {
  final String fileAgentDataId;
  final String mimeType;
  final String url;

  FileAgentData(this.fileAgentDataId, this.mimeType, this.url);

  FileAgentData.fromJson(Map<String, dynamic> json)
    : fileAgentDataId = json["file_agent_data_id"],
  mimeType = json["mime_type"],
  url = json["url"];

  Map<String, dynamic> toJson() => {};
}