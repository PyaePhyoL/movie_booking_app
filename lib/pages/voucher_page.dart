import 'package:flutter/material.dart';
import 'package:movie_booking_app/data/models/movie_cinema_model.dart';
import 'package:movie_booking_app/data/models/movie_cinema_model_impl.dart';
import 'package:movie_booking_app/data/vos/movie_vo.dart';
import 'package:movie_booking_app/data/vos/receipt_vo.dart';
import 'package:movie_booking_app/data/vos/snack_vo.dart';
import 'package:movie_booking_app/data/vos/voucher_vo.dart';
import 'package:movie_booking_app/network/api_constants.dart';
import 'package:movie_booking_app/pages/home_page.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';
import 'package:movie_booking_app/resources/strings.dart';
import 'package:movie_booking_app/utility_functions.dart';
import 'package:movie_booking_app/widgets/label_title.dart';
import 'package:movie_booking_app/widgets/my_separator.dart';
import 'package:movie_booking_app/widgets/title_text.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';

class VoucherPage extends StatefulWidget {
  final ReceiptVO receipt;

  VoucherPage(this.receipt);

  @override
  _VoucherPageState createState() => _VoucherPageState();
}

class _VoucherPageState extends State<VoucherPage> {
  MovieCinemaModel mMovieCinemaModel = MovieCinemaModelImpl();
  VoucherVO voucher;
  MovieVO mMovie;

  @override
  void initState() {
    super.initState();

    mMovieCinemaModel.checkOut(mMovieCinemaModel.checkoutRequest).then((voucher) {
      setState(() {
        debugPrint("Voucher ===> $voucher");
        this.voucher = voucher;
      });

      mMovieCinemaModel
          .getMovieDetailFromDatabase(voucher?.movieId)
          .then((movie) {
        setState(() {
          mMovie = movie;
          debugPrint("Movie ===> $mMovie");
        });
      });

    }).catchError((error) => handleError(context, error));

    // mMovieCinemaModel.postCheckout(widget.receipt).then((voucher) {
    //   setState(() {
    //     debugPrint("Voucher ===> $voucher");
    //     this.voucher = voucher;
    //   });
    //
    //   mMovieCinemaModel
    //       .getMovieDetailFromDatabase(voucher?.movieId)
    //       .then((movie) {
    //     setState(() {
    //       mMovie = movie;
    //       debugPrint("Movie ===> $mMovie");
    //     });
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: MARGIN_MEDIUM_2),
          child: CloseButtonView(
            () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: (voucher != null)
            ? Column(
                children: [
                  AwesomeTitleView(),
                  SizedBox(
                    height: MARGIN_MEDIUM,
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                      left: MARGIN_XLARGE,
                      right: MARGIN_XLARGE,
                      bottom: MARGIN_LARGE,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 5,
                          blurRadius: 5,
                          offset: Offset(0, 5),
                        ),
                      ],
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 160,
                          width: double.infinity,
                          child: MovieImageView(mMovie.posterPath),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: MARGIN_MEDIUM_2,
                            vertical: MARGIN_MEDIUM,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: MovieTicketInfo(mMovie),
                          ),
                        ),
                        MySeparator(),
                        MovieTicketDetailInfoSectionView(voucher),
                        MySeparator(),
                        Container(
                          height: 100,
                          padding:
                              EdgeInsets.symmetric(vertical: MARGIN_MEDIUM_2),
                          child: SfBarcodeGenerator(
                            value: voucher.bookingNo,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

class AwesomeTitleView extends StatelessWidget {
  const AwesomeTitleView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleText(AWESOME_TITLE),
        Text(
          THIS_IS_YOUR_TICKET_TITLE,
          style: TextStyle(
            fontSize: TEXT_REGULAR_2X,
            color: SECONDARY_TEXT_COLOR,
          ),
        ),
      ],
    );
  }
}

class MovieImageView extends StatelessWidget {
  final String imageUrl;

  MovieImageView(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(10),
        topLeft: Radius.circular(10),
      ),
      child: Image.network(
        "$IMAGE_BASE_URL$imageUrl",
        fit: BoxFit.cover,
      ),
    );
  }
}

class CloseButtonView extends StatelessWidget {
  final Function onTapBack;

  CloseButtonView(this.onTapBack);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapBack,
      child: Icon(
        Icons.close,
        size: ICON_MEDIUM,
        color: Colors.black,
      ),
    );
  }
}

class MovieTicketDetailInfoSectionView extends StatelessWidget {
  final VoucherVO voucher;

  MovieTicketDetailInfoSectionView(this.voucher);

  String getSnacks(List<SnackVO> snacks) {
    List<String> snackList =
        snacks.map((snack) => "${snack.qty} x ${snack.name}").toList();

    return snackList.join("\n");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MovieTicketDetailInfoView(
          "Booking no",
          "${voucher.bookingNo}",
        ),
        MovieTicketDetailInfoView(
          "Show time - Date",
          "${voucher.timeslot.startTime} / ${voucher.bookingDate}",
        ),
        MovieTicketDetailInfoView(
          "Theater",
          "${voucher.bookingNo.split("-").first}",
        ),
        MovieTicketDetailInfoView(
          "Row",
          "${voucher.row}",
        ),
        MovieTicketDetailInfoView(
          "Seats",
          "${voucher.seat}",
        ),
        MovieTicketDetailInfoView(
          "Snacks",
          getSnacks(voucher.snacks),
        ),
        MovieTicketDetailInfoView(
          "Price",
          "${voucher.total}",
        ),
      ],
    );
  }
}

class MovieTicketDetailInfoView extends StatelessWidget {
  final String detailTitle;
  final String detailInfo;

  MovieTicketDetailInfoView(
    this.detailTitle,
    this.detailInfo,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(MARGIN_MEDIUM_2),
      child: Row(
        children: [
          LabelTitle(detailTitle),
          Spacer(),
          Text(
            detailInfo,
          ),
        ],
      ),
    );
  }
}

class MovieTicketInfo extends StatelessWidget {
  final MovieVO movie;

  MovieTicketInfo(this.movie);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          movie.originalTitle,
          style: TextStyle(
            fontSize: TEXT_REGULAR_3X,
          ),
        ),
        Text(
          "${movie.runtime.toString()} min",
          style:
              TextStyle(fontSize: TEXT_REGULAR_2X, color: SECONDARY_TEXT_COLOR),
        ),
      ],
    );
  }
}
