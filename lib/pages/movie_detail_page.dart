import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_booking_app/data/models/movie_cinema_model.dart';
import 'package:movie_booking_app/data/models/movie_cinema_model_impl.dart';
import 'package:movie_booking_app/data/vos/actor_vo.dart';
import 'package:movie_booking_app/data/vos/movie_vo.dart';
import 'package:movie_booking_app/network/api_constants.dart';
import 'package:movie_booking_app/pages/movie_choose_time_page.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';
import 'package:movie_booking_app/resources/strings.dart';
import 'package:movie_booking_app/widgets/main_button_view.dart';
import 'package:movie_booking_app/widgets/subtitle_text.dart';
import 'package:movie_booking_app/widgets/title_text.dart';
import 'package:movie_booking_app/widgets/user_image_icon.dart';

class MovieDetailPage extends StatefulWidget {
  final int movieId;

  MovieDetailPage({@required this.movieId});

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final List<String> genreList = [
    "Comedy",
    "Drama",
  ];


  MovieCinemaModel mMovieModel = MovieCinemaModelImpl();
  MovieVO mMovie;
  List<ActorVO> actorList;

  @override
  void initState() {
    super.initState();

    /// Network
    // mMovieModel.getMovieDetail(widget.movieId).then((movie) {
    //   setState(() {
    //     mMovie = movie;
    //     actorList = movie.casts;
    //   });
    // });

    /// Database
    mMovieModel.getMovieDetailFromDatabase(widget.movieId).then((movie) {
      setState(() {
        mMovie = movie;
        actorList = movie.casts;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:(mMovie != null) ?  Container(
        child: CustomScrollView(
          slivers: [
            MovieDetailSliverAppBarView(
              () => Navigator.pop(context),
              mMovie.posterPath
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: MARGIN_MEDIUM_2),
                              child: TitleText(mMovie.originalTitle),
                            ),
                            SizedBox(
                              height: MARGIN_MEDIUM,
                            ),
                            MovieInfoAndRatingBarView(mMovie),
                            SizedBox(
                              height: MARGIN_MEDIUM_2,
                            ),
                            GenreSectionView(mMovie.genres),
                            SizedBox(
                              height: MARGIN_MEDIUM_3,
                            ),
                            MovieSummarySectionView(mMovie.overview),
                            SizedBox(
                              height: MARGIN_MEDIUM_3,
                            ),
                            CastSectionView(actorList),
                            SizedBox(
                              height: MARGIN_XXLARGE * 2,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ): Center(child: CircularProgressIndicator(),),
      floatingActionButton: MainButtonView(
        GET_YOUR_TICKET_TITLE,
        () => _navigateToChooseTimeScreen(context, mMovie.id),
      ),
    );
  }

  Future _navigateToChooseTimeScreen(BuildContext context, int movieId) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MovieChooseTimePage(movieId: movieId,);
        },
      ),
    );
  }
}

class CastSectionView extends StatelessWidget {
  final List<ActorVO> actorList;

  CastSectionView(this.actorList);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: MARGIN_MEDIUM_2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubtitleText(MOVIE_DETAIL_CAST_TITLE),
          SizedBox(
            height: MARGIN_MEDIUM_2,
          ),
          (actorList != null) ? Container(
            height: MOVIE_DETAIL_ACTOR_IMAGE_ICON_SIZE + MARGIN_XXLARGE + MARGIN_MEDIUM_2,
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: MOVIE_DETAIL_ACTOR_IMAGE_ICON_SIZE,
                  margin: EdgeInsets.only(right: MARGIN_MEDIUM_2),
                  child: Column(
                    children: [
                      UserImageIcon(
                        actorList[index].profilePath,
                        iconSize: MOVIE_DETAIL_ACTOR_IMAGE_ICON_SIZE,
                      ),
                      SizedBox(
                        height: MARGIN_MEDIUM,
                      ),
                      Text(
                        actorList[index].name,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
              itemCount: actorList.length,
            ),
          ): Center(child: CircularProgressIndicator(),),
        ],
      ),
    );
  }
}

class MovieSummarySectionView extends StatelessWidget {
  final String overview;

  MovieSummarySectionView(this.overview);

  @override
  Widget build(BuildContext context) {
    return (overview != null) ? Container(
      padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SubtitleText(MOVIE_DETAIL_PLOT_SUMMARY_TITLE),
          SizedBox(
            height: MARGIN_MEDIUM,
          ),
          Text(
            overview,
            style: TextStyle(
              fontSize: TEXT_REGULAR_2X,
              fontWeight: FontWeight.w300,
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    ): Center(child: CircularProgressIndicator(),);
  }
}

class GenreSectionView extends StatelessWidget {
  final List<String> genreList;

  GenreSectionView(this.genreList);

  List<Widget> _createGenreWidget() {
    List<Widget> widgets = [];

    widgets.addAll(genreList.map((genre) => GenreChipView(genre)).toList());

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
      child: Wrap(
        spacing: MARGIN_MEDIUM,
        runSpacing: MARGIN_MEDIUM,
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: _createGenreWidget(),
      ),
    );
  }
}

class GenreChipView extends StatelessWidget {
  final String genre;

  GenreChipView(this.genre);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: GENRE_CHIP_HEIGHT,
      padding: EdgeInsets.symmetric(
        horizontal: MARGIN_MEDIUM_2,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: SECONDARY_TEXT_COLOR,
        ),
        borderRadius: BorderRadius.circular(GENRE_CHIP_HEIGHT / 2),
      ),
      child: Center(widthFactor: 1,child: Text(genre)),

    );
  }
}

class MovieInfoAndRatingBarView extends StatelessWidget {
  final MovieVO mMovie;

  MovieInfoAndRatingBarView(this.mMovie);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "${mMovie.runtime} min",
            style: TextStyle(fontSize: TEXT_REGULAR_2X),
          ),
          SizedBox(
            width: MARGIN_MEDIUM,
          ),
          RatingBar.builder(
              initialRating: 4.5,
              minRating: 1,
              allowHalfRating: true,
              direction: Axis.horizontal,
              itemSize: TEXT_HEADING_1X,
              itemPadding: EdgeInsets.symmetric(horizontal: 4),
              itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: RATING_STAR_COLOR,
                  ),
              onRatingUpdate: (rating) {}),
          SizedBox(
            width: MARGIN_MEDIUM,
          ),
          Text(
            "IMDb ${mMovie.rating}",
            style: TextStyle(fontSize: TEXT_REGULAR_2X),
          ),
        ],
      ),
    );
  }
}

class MovieDetailSliverAppBarView extends StatelessWidget {
  final Function onTapBack;
  final String imageUrl;

  MovieDetailSliverAppBarView(this.onTapBack, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: PRIMARY_COLOR,
      expandedHeight: MOVIE_DETAIL_SLIVER_APPBAR_HEIGHT,
      automaticallyImplyLeading: false,
      flexibleSpace: Stack(
        children: [
          FlexibleSpaceBar(
            background: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    "$IMAGE_BASE_URL$imageUrl",
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: PlayButtonView(),
                ),
                Align(
                  alignment: Alignment.center,
                  child: PlayButtonBackgroundContainerView(),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: MARGIN_XLARGE,
                      left: MARGIN_MEDIUM,
                    ),
                    child: BackButtonView(
                      () => onTapBack(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(MARGIN_LARGE),
                  topRight: Radius.circular(MARGIN_LARGE),
                ),
              ),
              child: SizedBox(
                height: MARGIN_LARGE,
              ),
            ),
            bottom: -1,
            left: 0,
            right: 0,
          ),
        ],
      ),
    );
  }
}

class BackButtonView extends StatelessWidget {
  final Function onTapBack;

  BackButtonView(this.onTapBack);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapBack,
      child: Icon(
        Icons.chevron_left,
        color: Colors.white,
        size: ICON_MEDIUM_2,
      ),
    );
  }
}

class PlayButtonBackgroundContainerView extends StatelessWidget {
  const PlayButtonBackgroundContainerView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: PLAY_BUTTON_ICON_BACKGROUND_CONTAINER_SIZE,
      height: PLAY_BUTTON_ICON_BACKGROUND_CONTAINER_SIZE,
      decoration: BoxDecoration(
        color: Colors.white54,
        shape: BoxShape.circle,
      ),
    );
  }
}

class PlayButtonView extends StatelessWidget {
  const PlayButtonView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.play_circle_outline,
      color: Colors.white,
      size: ICON_LARGE,
    );
  }
}
