import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movie_booking_app/data/models/auth_model.dart';
import 'package:movie_booking_app/data/models/auth_model.impl.dart';
import 'package:movie_booking_app/data/models/movie_cinema_model.dart';
import 'package:movie_booking_app/data/models/movie_cinema_model_impl.dart';
import 'package:movie_booking_app/data/vos/card_vo.dart';
import 'package:movie_booking_app/data/vos/receipt_vo.dart';
import 'package:movie_booking_app/pages/voucher_page.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';
import 'package:movie_booking_app/resources/strings.dart';
import 'package:movie_booking_app/utility_functions.dart';
import 'package:movie_booking_app/widgets/add_new_card_title.dart';
import 'package:movie_booking_app/widgets/back_button_view.dart';
import 'package:movie_booking_app/widgets/label_title.dart';
import 'package:movie_booking_app/widgets/main_button_view.dart';

import 'add_new_card_page.dart';

class PaymentPage extends StatefulWidget {
  final double paymentAmount;
  final ReceiptVO receipt;

  PaymentPage(this.paymentAmount, this.receipt);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  MovieCinemaModel mMovieCinemaModel = MovieCinemaModelImpl();
  AuthModel authModel = AuthModelImpl();
  List<CardVO> cardList = [];
  CardVO selectedCard;

  @override
  void initState() {
    super.initState();

    debugPrint("Receipt ===> ${widget.receipt}");

    authModel.getUserFromDatabase().then((user) {
      setState(() {
        cardList = user.cards;
        if(cardList.isNotEmpty) selectedCard = cardList.first;
        debugPrint("Selected Card ===> ${selectedCard.toString()}");
      });
    });
  }

  void _startAddNewCard(BuildContext context, Function addNewCard) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddNewCardPage(addNewCard),
      ),
    );
  }

  void addNewCardFunc(String number, String holder, String date, String cvc) {
    mMovieCinemaModel
        .postCreateCard(number, holder, date, cvc)
        .then((cardList) {
      setState(() {
        this.cardList = cardList;
      });
    });

  }

  void selectCard(CardVO card) {
    setState(() {
      selectedCard = card;

      print(selectedCard);
    });
  }

  Future _navigateToVoucherScreen(BuildContext context) {
    // widget.receipt.cardId = selectedCard.id;

    mMovieCinemaModel.checkoutRequest.cardId = selectedCard.id;

    debugPrint("Checkout Request ===> ${mMovieCinemaModel.checkoutRequest.toString()}");

    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return VoucherPage(widget.receipt);
        },
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: MARGIN_MEDIUM_2),
          child: BackButtonView(
            () => Navigator.pop(context),
          ),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PaymentAmountSectionView(widget.paymentAmount),
              SizedBox(
                height: MARGIN_MEDIUM_2,
              ),
              HorizontalCardScrollSection(
                cardList: cardList,
                selectCard: (card) => selectCard(card),
              ),
              SizedBox(
                height: MARGIN_MEDIUM_3,
              ),
              TextButton(
                onPressed: () => _startAddNewCard(
                  context,
                  (number, holder, date, cvc) =>
                      addNewCardFunc(number, holder, date, cvc),
                ),
                child: AddNewCardTitle(),
              ),
              SizedBox(
                height: MARGIN_XXLARGE * 2,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: MainButtonView(
        CONFIRM_TITLE,
        () => _navigateToVoucherScreen(context),
      ),
    );
  }

}

class HorizontalCardScrollSection extends StatelessWidget {
  final List<CardVO> cardList;
  final Function(CardVO) selectCard;

  HorizontalCardScrollSection(
      {@required this.cardList, @required this.selectCard});

  @override
  Widget build(BuildContext context) {
    return (cardList.isNotEmpty)
        ? CarouselSlider.builder(
            itemCount: cardList.length,
            itemBuilder: (context, index) => CardView(cardList[index]),
            options: CarouselOptions(
                height: 200,
                viewportFraction: 0.75,
                enlargeCenterPage: true,
                initialPage: 0,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  selectCard(cardList[index]);
                }),
          )
        : Container(
            height: 200,
            child: Center(
              child: Text("There is no card available!"),
            ),
          );
  }
}

class CardView extends StatelessWidget {
  final CardVO mCard;

  CardView(this.mCard);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CardBackgroundGradientView(),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(MARGIN_MEDIUM_2),
            child: CardTypeTitleView(mCard.cardType),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(MARGIN_MEDIUM_2),
            child: MoreIconView(),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: CardNumberView(mCard.cardNumber),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(MARGIN_MEDIUM_2),
            child: UserInfoView(
              cardHolder: mCard.cardHolder,
              expireDate: mCard.expirationDate,
            ),
          ),
        )
      ],
    );
  }
}

class UserInfoView extends StatelessWidget {
  final String cardHolder;
  final String expireDate;

  UserInfoView({@required this.cardHolder, @required this.expireDate});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        UserInfo("CARD HOLDER", cardHolder),
        Spacer(),
        UserInfo("EXPIRES", expireDate),
      ],
    );
  }
}

class UserInfo extends StatelessWidget {
  final String title;
  final String info;

  UserInfo(this.title, this.info);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: TEXT_REGULAR,
            fontWeight: FontWeight.w200,
          ),
        ),
        SizedBox(
          height: MARGIN_SMALL,
        ),
        Text(
          info,
          style: TextStyle(
            color: Colors.white,
            fontSize: TEXT_REGULAR_3X,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class CardNumberView extends StatelessWidget {
  final String number;

  CardNumberView(this.number);

  @override
  Widget build(BuildContext context) {
    return Text(
      UtilityFunctions.coverCreditCardNumber(number),
      style: TextStyle(
        color: Colors.white,
        fontSize: TEXT_LARGE,
        wordSpacing: 3,
        letterSpacing: 2,
      ),
    );
  }
}

class MoreIconView extends StatelessWidget {
  const MoreIconView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.more_horiz,
      color: Colors.white,
      size: TEXT_HEADING_2X,
    );
  }
}

class CardTypeTitleView extends StatelessWidget {
  final String title;

  CardTypeTitleView(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: TEXT_REGULAR_3X,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class CardBackgroundGradientView extends StatelessWidget {
  const CardBackgroundGradientView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: PAYMENT_CARD_WIDTH,
      decoration: BoxDecoration(
        color: CARD_COLOR,
        borderRadius: BorderRadius.circular(MARGIN_MEDIUM),
        gradient: LinearGradient(
          colors: [CARD_COLOR, CARD_COLOR_085],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
}

class PaymentAmountSectionView extends StatelessWidget {
  final double amount;

  PaymentAmountSectionView(this.amount);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabelTitle(PAYMENT_AMOUNT_TITLE),
          SizedBox(
            height: MARGIN_MEDIUM,
          ),
          Text(
            "\$ $amount",
            style: TextStyle(
              fontSize: TEXT_HEADING_2X,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
