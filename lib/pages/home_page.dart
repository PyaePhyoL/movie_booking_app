import 'package:flutter/material.dart';
import 'package:movie_booking_app/data/models/auth_model.dart';
import 'package:movie_booking_app/data/models/auth_model.impl.dart';
import 'package:movie_booking_app/data/models/movie_cinema_model.dart';
import 'package:movie_booking_app/data/models/movie_cinema_model_impl.dart';
import 'package:movie_booking_app/data/vos/movie_vo.dart';
import 'package:movie_booking_app/data/vos/user_vo.dart';
import 'package:movie_booking_app/network/api_constants.dart';
import 'package:movie_booking_app/pages/login_register_page.dart';
import 'package:movie_booking_app/pages/movie_detail_page.dart';
import 'package:movie_booking_app/persistence/daos/profile_dao.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';
import 'package:movie_booking_app/resources/strings.dart';
import 'package:movie_booking_app/widgets/subtitle_text.dart';
import 'package:movie_booking_app/widgets/title_text.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  void _openDrawer() {
    _drawerKey.currentState.openDrawer();
  }

  final List<String> menuList = [
    "Promotion Code",
    "Select Language",
    "Terms of Service",
    "Help",
    "Rate us",
  ];

  UserVO mUser;

  MovieCinemaModel mMovieCinemaModel = MovieCinemaModelImpl();
  AuthModel authModel = AuthModelImpl();

  List<MovieVO> mComingSoonMovieList;
  List<MovieVO> mNowShowingMovieList;
  String bearerToken;
  String photoUrl;

  @override
  void initState() {
    /// Network
    // mMovieCinemaModel.getMovieList(COMING_SOON).then((movieList) {
    //   setState(() {
    //     mComingSoonMovieList = movieList;
    //   });
    // });
    //
    // mMovieCinemaModel.getMovieList(CURRENT).then((movieList) {
    //   setState(() {
    //     mNowShowingMovieList = movieList;
    //   });
    // });

    /// Database
    authModel.getUserFromDatabase().then((user) {
      setState(() {
        mUser = user;
      });
    });

    authModel.getTokenFromDatabase().then((token) {
      setState(() {
        this.bearerToken = token;
      });
    });

    mMovieCinemaModel.getComingSoonMoviesFromDatabase().then((movieList) {
      setState(() {
        mComingSoonMovieList = movieList;
      });
    }).catchError((error) => debugPrint(error.toString()));

    mMovieCinemaModel.getCurrentMoviesFromDatabase().then((movieList) {
      setState(() {
        mNowShowingMovieList = movieList;
      });
    }).catchError((error) => debugPrint(error.toString()));

    photoUrl = ProfileDao().getProfile();

    super.initState();
  } //initState

  void _logout(BuildContext context, String token) {
    authModel.postLogout(token).then((message) {

      ProfileDao().deleteProfile();

      authModel.facebookUser
          .logOut()
          .then((value) => debugPrint("Facebook logout successfully"));

      authModel.googleUser
          .disconnect()
          .then((value) => debugPrint("Google logout successfully"));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginRegisterPage(),
        ),
      );
    }).catchError((error) => debugPrint("Error ===> ${error.toString()}"));
  }

  Future _navigateToMovieDetailScreen(BuildContext context, int movieId) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MovieDetailPage(
            movieId: movieId,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      backgroundColor: Colors.white,
      drawer: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Drawer(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM),
          color: PRIMARY_COLOR,
          child: Column(
            children: [
              SizedBox(
                height: DRAWER_TOP_SPACE_HEIGHT,
              ),
              DrawerHeaderSectionView(
                mUser,
                widgetUrl: photoUrl,
              ),
              SizedBox(
                height: MARGIN_XXLARGE,
              ),
              MenuListSectionView(menuList: menuList),
              Spacer(),
              LogoutButton(
                (token) => _logout(context, token),
                bearerToken,
              ),
              SizedBox(
                height: MARGIN_LARGE,
              ),
            ],
          ),
        )),
      ),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: MenuIcon(_openDrawer),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: MARGIN_MEDIUM),
            child: SearchIcon(),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(
          left: MARGIN_MEDIUM_2,
          top: MARGIN_MEDIUM,
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserInfoView(
                mUser,
                widgetUrl: photoUrl,
              ),
              SizedBox(
                height: MARGIN_MEDIUM_3,
              ),
              NowShowingSectionView(
                mNowShowingMovieList,
                (movieId) => _navigateToMovieDetailScreen(context, movieId),
              ),
              SizedBox(
                height: MARGIN_LARGE,
              ),
              ComingSoonSectionView(
                mComingSoonMovieList,
                (movieId) => _navigateToMovieDetailScreen(context, movieId),
              ),
              SizedBox(
                height: MARGIN_LARGE,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  final Function(String) logoutFunc;
  final String token;

  LogoutButton(this.logoutFunc, this.token);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => logoutFunc(token),
      child: ListTile(
        leading: Icon(
          Icons.logout,
          color: Colors.white,
          size: MARGIN_XLARGE,
        ),
        title: Text(
          LOG_OUT,
          style: TextStyle(
            color: Colors.white,
            fontSize: TEXT_REGULAR_3X,
          ),
        ),
      ),
    );
  }
}

class MenuListSectionView extends StatelessWidget {
  const MenuListSectionView({
    Key key,
    @required this.menuList,
  }) : super(key: key);

  final List<String> menuList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: menuList
          .map(
            (menu) => Container(
              margin: EdgeInsets.only(top: MARGIN_MEDIUM_2),
              child: ListTile(
                leading: Icon(
                  Icons.help,
                  color: Colors.white,
                  size: MARGIN_XLARGE,
                ),
                title: Text(
                  menu,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: TEXT_REGULAR_3X,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class DrawerHeaderSectionView extends StatelessWidget {
  final UserVO mUser;
  final String widgetUrl;

  DrawerHeaderSectionView(this.mUser, {this.widgetUrl});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: CIRCLE_AVATAR_ICON_SIZE,
          height: CIRCLE_AVATAR_ICON_SIZE,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                (widgetUrl != null)
                    ? "$widgetUrl"
                    : "$BASE_URL_DIO${mUser.profileImage}",
              ),
            ),
          ),
        ),
        SizedBox(
          width: MARGIN_MEDIUM_2,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              mUser.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: TEXT_LARGE,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: MARGIN_MEDIUM,
            ),
            Row(
              children: [
                Text(
                  mUser.email,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: MARGIN_LARGE,
                ),
                Text(
                  "Edit",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}

class ComingSoonSectionView extends StatelessWidget {
  final List<MovieVO> movieList;
  final Function(int) onTapMovie;

  ComingSoonSectionView(this.movieList, this.onTapMovie);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubtitleText(COMING_SOON_TITLE),
        SizedBox(
          height: MARGIN_MEDIUM_3,
        ),
        HorizontalMovieListView(
          (movieId) => onTapMovie(movieId),
          movieList: movieList,
        ),
      ],
    );
  }
}

class NowShowingSectionView extends StatelessWidget {
  final List<MovieVO> movieList;
  final Function(int) onTapMovie;

  NowShowingSectionView(this.movieList, this.onTapMovie);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubtitleText(NOW_SHOWING_TITLE),
        SizedBox(
          height: MARGIN_MEDIUM_3,
        ),
        HorizontalMovieListView(
          (movieId) => onTapMovie(movieId),
          movieList: movieList,
        ),
      ],
    );
  }
}

class HorizontalMovieListView extends StatelessWidget {
  final List<MovieVO> movieList;
  final Function(int) onTapMovie;

  HorizontalMovieListView(this.onTapMovie, {this.movieList});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: HORIZONTAL_MOVIE_LIST_HEIGHT,
      child: (movieList != null)
          ? ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return MovieItem(
                    movieList[index], (movieId) => onTapMovie(movieId));
              },
              itemCount: 10,
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class MovieItem extends StatelessWidget {
  final MovieVO mMovie;
  final Function(int) onTapMovie;

  MovieItem(this.mMovie, this.onTapMovie);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: MARGIN_MEDIUM_3),
      width: MOVIE_ITEM_WIDTH,
      child: Column(
        children: [
          Container(
            height: MOVIE_ITEM_HEIGHT,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: PRIMARY_SHADOW_COLOR,
                  blurRadius: 10,
                  offset: Offset(5, 5),
                  spreadRadius: 3,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              child: GestureDetector(
                onTap: () => onTapMovie(mMovie.id),
                child: Image.network(
                  "$IMAGE_BASE_URL${mMovie.posterPath}",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(
            height: MARGIN_MEDIUM_2,
          ),
          Text(
            mMovie.originalTitle,
            style: TextStyle(
                fontSize: TEXT_REGULAR_2X, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: MARGIN_SMALL,
          ),
          Text(
            "Comedy/Drama . 1h 40min",
            style: TextStyle(fontSize: TEXT_SMALL, color: SECONDARY_TEXT_COLOR),
          ),
        ],
      ),
    );
  }
}

class UserInfoView extends StatelessWidget {
  final UserVO mUser;
  final String widgetUrl;

  UserInfoView(this.mUser, {this.widgetUrl});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: CIRCLE_AVATAR_ICON_SIZE,
          width: CIRCLE_AVATAR_ICON_SIZE,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(CIRCLE_AVATAR_ICON_SIZE / 2),
            child: Image.network(
              (widgetUrl != null)
                  ? "$widgetUrl"
                  : "$BASE_URL_DIO${mUser.profileImage}",
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          width: MARGIN_MEDIUM_2,
        ),
        TitleText("Hi ${mUser.name}!"),
      ],
    );
  }
}

class SearchIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.search,
      size: ICON_MEDIUM,
      color: Colors.black,
    );
  }
}

class MenuIcon extends StatelessWidget {
  final Function openDrawer;

  MenuIcon(this.openDrawer);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openDrawer,
      child: Icon(
        Icons.menu,
        size: ICON_MEDIUM,
        color: Colors.black,
      ),
    );
  }
}
