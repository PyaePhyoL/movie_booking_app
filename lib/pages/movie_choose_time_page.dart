import 'package:flutter/material.dart';
import 'package:movie_booking_app/data/models/auth_model.dart';
import 'package:movie_booking_app/data/models/auth_model.impl.dart';
import 'package:movie_booking_app/data/models/movie_cinema_model.dart';
import 'package:movie_booking_app/data/models/movie_cinema_model_impl.dart';
import 'package:movie_booking_app/data/vos/cinema_vo.dart';
import 'package:movie_booking_app/data/vos/date_vo.dart';
import 'package:movie_booking_app/data/vos/receipt_vo.dart';
import 'package:movie_booking_app/data/vos/timeslot_vo.dart';
import 'package:movie_booking_app/pages/movie_seats_page.dart';
import 'package:movie_booking_app/persistence/daos/cinema_dao.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';
import 'package:movie_booking_app/resources/strings.dart';
import 'package:movie_booking_app/utility_functions.dart';
import 'package:movie_booking_app/widgets/main_button_view.dart';

class MovieChooseTimePage extends StatefulWidget {
  final int movieId;

  MovieChooseTimePage({@required this.movieId});

  @override
  _MovieChooseTimePageState createState() => _MovieChooseTimePageState();
}

class _MovieChooseTimePageState extends State<MovieChooseTimePage> {
  MovieCinemaModel mMovieCinemaModel = MovieCinemaModelImpl();
  AuthModel authModel = AuthModelImpl();

  List<DateVO> dateList;
  List<CinemaVO> mCinemaList;
  ReceiptVO receipt = ReceiptVO();
  CinemaDao mCinemaDao = CinemaDao();

  /// Send data to another screen
  DateVO selectedDate;
  CinemaVO selectedCinemaTime;

  @override
  void initState() {
    super.initState();

    debugPrint("Receipt ===> $receipt");

    dateList = mMovieCinemaModel.getDates();

    selectedDate = dateList.first;
    selectedDate.isSelected = true;

    mMovieCinemaModel
        .getCinemasByDateFromDatabase(selectedDate.yMd.toString())
        .then((cinemaList) {
      setState(() {
        mCinemaList = cinemaList;
      });

      selectedCinemaTime = mCinemaList.first;
      selectedCinemaTime.timeslots.first.isSelected = true;
    });


  }

  void _selectDate(int dateId) {
    setState(() {
      selectedDate = dateList.firstWhere((date) => date.id == dateId);

      /// reset all selected date
      dateList.forEach((date) => date.isSelected = false);

      selectedDate.isSelected = true;

      mMovieCinemaModel
          .getCinemasByDateFromDatabase(selectedDate.yMd.toString())
          .then((cinemaList) {
            setState(() {
              mCinemaList = cinemaList;
            });
      });
    });
  }

  void _selectCinemaTime(int timeslotId, int cinemaId) {
    setState(() {
      /// reset all selected time
      mCinemaList.forEach((cinema) {
        cinema.timeslots.forEach((time) {
          time.isSelected = false;
        });
      });

      selectedCinemaTime =
          mCinemaList.firstWhere((cinema) => cinema.cinemaId == cinemaId);

      selectedCinemaTime.timeslots
          .firstWhere((timeslot) => timeslot.cinemaDayTimeslotId == timeslotId)
          .isSelected = true;
    });
  }

  Future _navigateToMovieSeatScreen(
      BuildContext context, DateVO date, CinemaVO cinema, int movieId) {

    // receipt.movieId = movieId;
    // receipt.cinemaDayTimeslotId = cinema.timeslots
    //     .firstWhere((time) => time.isSelected)
    //     .cinemaDayTimeslotId;
    // receipt.bookingDate = UtilityFunctions.formatDate(date.yMd);

    mMovieCinemaModel.checkoutRequest.movieId = movieId;
    mMovieCinemaModel.checkoutRequest.bookingDate = UtilityFunctions.formatDate(date.yMd);
    mMovieCinemaModel.checkoutRequest.cinemaDayTimeslotId = cinema.timeslots.firstWhere((time) => time.isSelected).cinemaDayTimeslotId;

    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MovieSeatsPage(
          selectedDate: date,
          selectedCinema: cinema,
          movieId: movieId,
          receipt: receipt,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PRIMARY_COLOR,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.chevron_left,
            color: Colors.white,
            size: ICON_MEDIUM_2,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              MovieChooseDateView(dateList, (dateId) => _selectDate(dateId)),
              ChooseItemGridSectionView(
                  mCinemaList,
                  (timeslotId, cinemaId) =>
                      _selectCinemaTime(timeslotId, cinemaId)),
              SizedBox(
                height: MARGIN_MEDIUM_2,
              ),
              SizedBox(
                height: MARGIN_LARGE,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: MainButtonView(
        NEXT,
        () => _navigateToMovieSeatScreen(
            context, selectedDate, selectedCinemaTime, widget.movieId),
      ),
    );
  }
}

class ChooseItemGridSectionView extends StatelessWidget {
  final List<CinemaVO> cinemaList;
  final Function(int, int) selectCinemaTime;

  ChooseItemGridSectionView(this.cinemaList, this.selectCinemaTime);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MARGIN_MEDIUM_2,
        left: MARGIN_MEDIUM_2,
        right: MARGIN_MEDIUM_2,
      ),
      child: (cinemaList != null)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: cinemaList
                  .map(
                    (cinema) => ChooseItemGridView(
                        cinema,
                        (timeId, cinemaId) =>
                            selectCinemaTime(timeId, cinemaId)),
                  )
                  .toList(),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class ChooseItemGridView extends StatelessWidget {
  final CinemaVO mCinema;
  final Function(int, int) selectCinemaTime;

  ChooseItemGridView(this.mCinema, this.selectCinemaTime);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          mCinema.cinema,
          style: TextStyle(
            fontSize: TEXT_REGULAR_3X,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(
          height: MARGIN_MEDIUM_2,
        ),
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.5,
          ),
          itemCount: mCinema.timeslots.length,
          itemBuilder: (context, index) {
            return TimeGridView(mCinema.timeslots[index], mCinema.cinemaId,
                (timeId, cinemaId) => selectCinemaTime(timeId, cinemaId));
          },
        ),
        SizedBox(
          height: MARGIN_LARGE,
        ),
      ],
    );
  }
}

class TimeGridView extends StatelessWidget {
  final TimeslotVO timeslot;
  final int cinemaId;
  final Function(int, int) selectCinemaTime;

  TimeGridView(this.timeslot, this.cinemaId, this.selectCinemaTime);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => selectCinemaTime(timeslot.cinemaDayTimeslotId, cinemaId),
      child: Container(
        margin: EdgeInsets.only(
          left: MARGIN_MEDIUM_2,
          right: MARGIN_MEDIUM_2,
          top: MARGIN_MEDIUM,
        ),
        decoration: BoxDecoration(
          color: (timeslot.isSelected ?? true) ? PRIMARY_COLOR : null,
          border: (timeslot.isSelected ?? true)
              ? null
              : Border.all(
                  color: Colors.grey,
                ),
          borderRadius: BorderRadius.circular(MARGIN_MEDIUM),
        ),
        child: Center(
          child: Text(
            timeslot.startTime,
            style: TextStyle(
                fontSize: TEXT_REGULAR_2X,
                color: (timeslot.isSelected) ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}

class MovieChooseDateView extends StatefulWidget {
  final List<DateVO> mDates;
  final Function(int) selectDate;

  MovieChooseDateView(this.mDates, this.selectDate);

  @override
  _MovieChooseDateViewState createState() => _MovieChooseDateViewState();
}

class _MovieChooseDateViewState extends State<MovieChooseDateView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MOVIE_TIME_LIST_HEIGHT,
      color: PRIMARY_COLOR,
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM),
        scrollDirection: Axis.horizontal,
        children: widget.mDates
            .map(
              (date) => DateView(date, (dateId) => widget.selectDate(dateId)),
            )
            .toList(),
      ),
    );
  }
}
//
// ListView.separated(
// padding: EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
// scrollDirection: Axis.horizontal,
// itemBuilder: (context, index) {
// return GestureDetector(
// onTap: () {},
// child: DateView(),
// );
// },
// separatorBuilder: (context, index) {
// return SizedBox(width: MARGIN_MEDIUM_2);
// },
// itemCount: 7,
// ),

class DateView extends StatelessWidget {
  final DateVO date;
  final Function(int) selectDate;

  DateView(this.date, this.selectDate);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: MARGIN_CARD_MEDIUM),
      child: GestureDetector(
        onTap: () => selectDate(date.id),
        child: Column(
          children: [
            Text(
              date.day,
              style: TextStyle(
                color:
                    (date.isSelected) ? Colors.white : SOCIAL_LOGIN_TEXT_COLOR,
                fontSize: TEXT_REGULAR_3X,
              ),
            ),
            SizedBox(
              height: MARGIN_MEDIUM,
            ),
            Text(
              date.date,
              style: TextStyle(
                color:
                    (date.isSelected) ? Colors.white : SOCIAL_LOGIN_TEXT_COLOR,
                fontSize: (date.isSelected) ? TEXT_HEADING_2X : TEXT_REGULAR_3X,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
