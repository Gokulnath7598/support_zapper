class ProjectDetails {
  ProjectDetails({
    required this.versionControl,
    required this.organization,
    required this.project,
    required this.token,
  });
  VersionControl versionControl;
  String organization;
  String project;
  String token;
}

enum VersionControl {
  azureDevops,
}
