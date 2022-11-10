
enum FilterOption { none, continent, timeZone }
class FilterResponse {

  final List<String> flags;
  final FilterOption option;
  FilterResponse({
    required this.flags,
    required this.option,
  });
}
