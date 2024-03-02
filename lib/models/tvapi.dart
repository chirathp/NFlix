
class TvSeries{

  String name;
  String backdropPath;
  String originalName;
  String overView;
  String posterPath;
  String firstAirDate;
  //double popularity;
  double voteAverage;

  TvSeries({

  required this.name,
  required this.backdropPath,
  required this.originalName,
  required this.overView,
  required this.posterPath,
  required this.firstAirDate,
  //required this.popularity,
  required this.voteAverage,

  });

  factory TvSeries.fromJson(Map<String, dynamic> json) {

    return TvSeries(

      name: json["name"],
      backdropPath: json["backdrop_path"].toString(),
      originalName: json["original_name"],
      overView: json["overview"],
      posterPath: json["poster_path"],
      firstAirDate: json["first_air_date"],
      //popularity: json["popularity"].toDouble(),
      voteAverage: json["vote_average"].toDouble(),
    
    );
  }
}
