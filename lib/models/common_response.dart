class CommonResponse<T> {
  final String status;
  final int totalResults;
  List<T> data;

  CommonResponse(this.status, this.totalResults, this.data);
}
