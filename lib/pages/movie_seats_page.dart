import 'package:flutter/material.dart';
import 'package:movie_booking_app/data/models/movie_cinema_model.dart';
import 'package:movie_booking_app/data/models/movie_cinema_model_impl.dart';
import 'package:movie_booking_app/data/vos/cinema_vo.dart';
import 'package:movie_booking_app/data/vos/date_vo.dart';
import 'package:movie_booking_app/data/vos/movie_seat_vo.dart';
import 'package:movie_booking_app/data/vos/movie_vo.dart';
import 'package:movie_booking_app/data/vos/receipt_vo.dart';
import 'package:movie_booking_app/data/vos/seat_vo.dart';
import 'package:movie_booking_app/pages/buy_snack_page.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';
import 'package:movie_booking_app/resources/strings.dart';
import 'package:movie_booking_app/widgets/label_title.dart';
import 'package:movie_booking_app/widgets/main_button_view.dart';
import 'package:movie_booking_app/widgets/my_separator.dart';
import '../dummy/dummy_data.dart';

class MovieSeatsPage extends StatefulWidget {
  final DateVO selectedDate;
  final CinemaVO selectedCinema;
  final int movieId;
  final ReceiptVO receipt;

  MovieSeatsPage(
      {@required this.selectedDate,
      @required this.selectedCinema,
      @required this.movieId,
      @required this.receipt,
      });

  @override
  _MovieSeatsPageState createState() => _MovieSeatsPageState();
}

class _MovieSeatsPageState extends State<MovieSeatsPage> {
  final List<MovieSeatVO> movieSeats = dummyMovieSeats;

  MovieCinemaModel mMovieCinemaModel = MovieCinemaModelImpl();

  MovieVO mMovie;
  List<SeatVO> completeSeatList;
  List<SeatVO> selectedSeats = [];
  int numberOfSeatsInARow;
  double amountPrice = 0.0;

  @override
  void initState() {
    super.initState();

    debugPrint("Receipt ===> ${widget.receipt}");

    mMovieCinemaModel.getMovieDetailFromDatabase(widget.movieId).then((movie) {
      setState(() {
        mMovie = movie;
      });
    });

    /// Get Cinema Seating Plan
    int timeId = widget.selectedCinema.timeslots
        .firstWhere((timeslot) => timeslot.isSelected == true)
        .cinemaDayTimeslotId;

    String date = widget.selectedDate.yMd;

    mMovieCinemaModel.getCinemaSeatingPlan(timeId, date).then((seatRows) {
      debugPrint("Seats ===> $seatRows");

      setState(() {
        numberOfSeatsInARow = seatRows.first.length;

        List<SeatVO> allSeats = [];

        for (int i = 0; i < seatRows.length; i++) {
          List<SeatVO> seats = [...seatRows[i]];
          seats.forEach((seat) => allSeats.add(seat));
        }

        completeSeatList = allSeats;
      });
    });
  }

  void _selectSeat(SeatVO wSeat) {
    setState(() {
      if (wSeat.seatName != "" && wSeat.type == "available") {
        SeatVO sSeat = completeSeatList
            .firstWhere((seat) => seat.seatName == wSeat.seatName);

        if (!sSeat.isSelected) {
          sSeat.isSelected = true;
          amountPrice += sSeat.price;
          selectedSeats.add(sSeat);
        } else if (sSeat.isSelected) {
          sSeat.isSelected = false;
          amountPrice -= sSeat.price;
          selectedSeats.removeWhere((seat) => seat.seatName == sSeat.seatName);
        }

      }
    });
  }

  Future _navigateToBuySnacksScreen(BuildContext context, double amount) {
    String seats = selectedSeats.map((seat) => seat.seatName).join(",");

    // widget.receipt.seatNumber = seats;
    mMovieCinemaModel.checkoutRequest.seatNumber = seats;

    debugPrint("Receipt ===> ${widget.receipt}}");

    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BuySnackPage(amount, widget.receipt),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Icon(
            Icons.chevron_left,
            color: Colors.black,
            size: ICON_MEDIUM_2,
          ),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              MovieTitleAndInfoSectionView(
                  mMovie, widget.selectedCinema, widget.selectedDate),
              SizedBox(
                height: MARGIN_LARGE,
              ),
              MovieSeatSectionView(
                movieSeats: completeSeatList,
                selectSeatFunc: (seat) => _selectSeat(seat),
                seatsInARow: numberOfSeatsInARow,
              ),
              SizedBox(
                height: MARGIN_MEDIUM_2,
              ),
              MovieSeatGlossarySectionView(),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: MARGIN_MEDIUM_2, vertical: MARGIN_LARGE),
                child: MySeparator(),
              ),
              NumberOfTicketsAndSeatsSectionView(selectedSeats),
              SizedBox(
                height: MARGIN_LARGE,
              ),
              MainButtonView(
                "Buy Ticket for \$ ${amountPrice.toString()}",
                () => _navigateToBuySnacksScreen(context, amountPrice),
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

class NumberOfTicketsAndSeatsSectionView extends StatelessWidget {
  final List<SeatVO> selectedSeats;

  NumberOfTicketsAndSeatsSectionView(this.selectedSeats);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
      child: Column(
        children: [
          NumberOfTicketsAndSeatsView(
            title: TICKETS_LABEL,
            info: "${selectedSeats.length}",
          ),
          SizedBox(
            height: MARGIN_MEDIUM,
          ),
          NumberOfTicketsAndSeatsView(
            title: SEATS_LABEL,
            info: selectedSeats.map((seat) => seat.seatName).toList().join(", "),
          ),
        ],
      ),
    );
  }
}

class NumberOfTicketsAndSeatsView extends StatelessWidget {
  final String title;
  final String info;

  NumberOfTicketsAndSeatsView({this.title, this.info});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        LabelTitle(title),
        Spacer(),
        LabelTitle(info),
      ],
    );
  }
}

class MovieSeatGlossarySectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: MovieSeatGlossaryView(
              SEAT_TYPE_AVAILABLE,
              MOVIE_SEAT_AVAILABLE_COLOR,
            ),
          ),
          Expanded(
            flex: 1,
            child: MovieSeatGlossaryView(
              SEAT_TYPE_TAKEN,
              PAYMENT_CARD_ICON_COLOR,
            ),
          ),
          Expanded(
            flex: 1,
            child: MovieSeatGlossaryView(
              YOUR_SELECTION_TITLE,
              PRIMARY_COLOR,
            ),
          ),
        ],
      ),
    );
  }
}

class MovieSeatGlossaryView extends StatelessWidget {
  final String title;
  final Color color;

  MovieSeatGlossaryView(this.title, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            width: MARGIN_LARGE,
            height: MARGIN_LARGE,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(
            width: MARGIN_MEDIUM,
          ),
          Text(
            title,
            style: TextStyle(color: SECONDARY_TEXT_COLOR),
          ),
        ],
      ),
    );
  }
}

class MovieSeatSectionView extends StatelessWidget {
  final List<SeatVO> movieSeats;
  final int seatsInARow;
  final Function(SeatVO) selectSeatFunc;

  MovieSeatSectionView(
      {@required this.movieSeats,
      @required this.selectSeatFunc,
      @required this.seatsInARow});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (movieSeats != null)
          ? GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: movieSeats.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 4,
                crossAxisCount: seatsInARow,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return MovieSeatItemView(
                    movieSeats[index], (seat) => selectSeatFunc(seat));
              })
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class MovieSeatItemView extends StatelessWidget {
  final SeatVO seatVO;
  final Function(SeatVO) selectSeatFunc;

  MovieSeatItemView(this.seatVO, this.selectSeatFunc);

  @override
  Widget build(BuildContext context) {
    Color _getSeatColor(SeatVO movieSeat) {
      if(movieSeat.type == "available" && movieSeat.isSelected){
        return PRIMARY_COLOR;
      } else if(movieSeat.type == "available" && movieSeat.isSelected == false){
        return MOVIE_SEAT_AVAILABLE_COLOR;
      } else if(movieSeat.type == "taken") {
        return PAYMENT_CARD_ICON_COLOR;
      } else {
        return Colors.white;
      }
    }

    String _getSeatLabel(SeatVO movieSeat) {
      if (movieSeat.isSelected == true && movieSeat.type == "available")
        return movieSeat.seatName.split("-").last;
      else if (movieSeat.isSelected == false && movieSeat.type == "available")
        return "";
      else if (movieSeat.type == "space" || movieSeat.type == "taken")
        return "";
      else
        return movieSeat.symbol;
    }

    return GestureDetector(
      onTap: () => selectSeatFunc(seatVO),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
        decoration: BoxDecoration(
          color: _getSeatColor(seatVO),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(MARGIN_MEDIUM),
            topLeft: Radius.circular(MARGIN_MEDIUM),
          ),
        ),
        child: Center(
          child: Text(_getSeatLabel(seatVO), style: TextStyle(
            color: (seatVO.isSelected == true) ? Colors.white : Colors.black,
          ),),
        ),
      ),
    );
  }
}

class MovieTitleAndInfoSectionView extends StatelessWidget {
  final MovieVO movie;
  final CinemaVO cinema;
  final DateVO date;

  MovieTitleAndInfoSectionView(this.movie, this.cinema, this.date);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        (movie != null) ? Text(
          movie.originalTitle,
          style: TextStyle(
            fontSize: TEXT_REGULAR_3X,
            fontWeight: FontWeight.w700,
          ),
        ) : CircularProgressIndicator(),
        Text(
          cinema.cinema,
          style: TextStyle(
            color: SECONDARY_TEXT_COLOR,
            fontSize: TEXT_REGULAR_2X,
          ),
        ),
        Text(
          "${date.dayMonthDate}, ${cinema.timeslots.firstWhere((timeslot) => timeslot.isSelected == true).startTime}",
          style: TextStyle(
            color: SECONDARY_TEXT_COLOR,
            fontSize: TEXT_REGULAR_2X,
          ),
        ),
      ],
    );
  }
}
