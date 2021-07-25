import 'package:flutter/material.dart';
import 'package:movie_booking_app/data/models/movie_cinema_model.dart';
import 'package:movie_booking_app/data/models/movie_cinema_model_impl.dart';
import 'package:movie_booking_app/data/vos/payment_method_vo.dart';
import 'package:movie_booking_app/data/vos/receipt_vo.dart';
import 'package:movie_booking_app/data/vos/snack_vo.dart';
import 'package:movie_booking_app/network/requests/snack_request.dart';
import 'package:movie_booking_app/pages/payment_page.dart';
import 'package:movie_booking_app/resources/colors.dart';
import 'package:movie_booking_app/resources/dimens.dart';
import 'package:movie_booking_app/resources/strings.dart';
import 'package:movie_booking_app/widgets/back_button_view.dart';
import 'package:movie_booking_app/widgets/label_title.dart';
import 'package:movie_booking_app/widgets/main_button_view.dart';
import 'package:movie_booking_app/widgets/subtitle_text.dart';

class BuySnackPage extends StatefulWidget {
  final double ticketPrice;
  final ReceiptVO receipt;

  BuySnackPage(this.ticketPrice, this.receipt);

  @override
  _BuySnackPageState createState() => _BuySnackPageState();
}

class _BuySnackPageState extends State<BuySnackPage> {
  MovieCinemaModel mMovieCinemaModel = MovieCinemaModelImpl();
  List<SnackVO> snackList;
  List<PaymentMethodVO> paymentList;
  double subTotal;
  List<SnackVO> selectedSnacks = [];

  @override
  void initState() {
    // mMovieCinemaModel.getSnackList().then((snacks) {
    //   setState(() {
    //     snackList = snacks;
    //   });
    //   debugPrint("Snacks ===> $snackList");
    // });

    subTotal = widget.ticketPrice;
    super.initState();

    mMovieCinemaModel.getPaymentMethodList().then((payments) {
      setState(() {
        paymentList = payments;
      });
    });

    /// Database
    mMovieCinemaModel.getSnacksFromDatabase().then((snacks) {
      setState(() {
        snackList = snacks;
      });
    });
  }

  void plusQty(int id) {
    SnackVO snack = snackList.firstWhere((snack) => snack.id == id);

    if (!selectedSnacks.contains(snack)) selectedSnacks.add(snack);

    setState(() {
      snack.qty += 1;
      snack.totalAmount = snack.qty * snack.price;
      subTotal = subTotal + snack.price;
    });
  }

  void minusQty(int id) {
    SnackVO snack = snackList.firstWhere((snack) => snack.id == id);
    setState(() {
      if (snack.qty == 0) {
        return;
      } else {
        if (snack.qty == 1)
          selectedSnacks.removeWhere((snack) => snack.id == id);
        snack.qty -= 1;
        snack.totalAmount = snack.qty * snack.price;
        subTotal = subTotal - snack.price;
      }
    });
  }

  Future _navigateToPaymentScreen(BuildContext context, double subTotal) {
    // widget.receipt.snacks =
    //     selectedSnacks.map((snack) => snack.toJson()).toList();

    List<SnackRequest> snackList = selectedSnacks.map(
      (snack) {
        SnackRequest snackRequest =
            SnackRequest(snack.id, snack.qty);

        return snackRequest;
      },
    ).toList();

    mMovieCinemaModel.checkoutRequest.snacks = snackList;

    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return PaymentPage(subTotal, widget.receipt);
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
        padding: EdgeInsets.symmetric(
            horizontal: MARGIN_MEDIUM_2, vertical: MARGIN_MEDIUM),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SnackListSectionView(
                snackList,
                (id) => plusQty(id),
                (id) => minusQty(id),
              ),
              SizedBox(
                height: MARGIN_MEDIUM_2,
              ),
              PromoCodeSectionView(),
              SizedBox(
                height: MARGIN_LARGE,
              ),
              SubTotalSection(subTotal),
              SizedBox(
                height: MARGIN_LARGE,
              ),
              PaymentSectionView(paymentList),
              SizedBox(
                height: MARGIN_XXLARGE * 2,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: PaymentButtonView(
        subTotal,
        () => _navigateToPaymentScreen(context, subTotal),
      ),
    );
  }
}

class SnackListSectionView extends StatelessWidget {
  final List<SnackVO> snackList;
  final Function plusFunc;
  final Function minusFunc;

  SnackListSectionView(this.snackList, this.plusFunc, this.minusFunc);

  @override
  Widget build(BuildContext context) {
    return (snackList != null)
        ? Container(
            height: MOVIE_SNACK_SECTION_HEIGHT,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                SnackVO snack = snackList[index];
                return MovieSnackTitleAndQtyView(
                  snack.name,
                  snack.description,
                  plusFunc: () => plusFunc(snack.id),
                  minusFunc: () => minusFunc(snack.id),
                  quantity: snack.qty,
                  totalAmount: snack.totalAmount,
                );
              },
              itemCount: snackList.length,
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}

class MovieSnackTitleAndQtyView extends StatelessWidget {
  final String snackTitle;
  final String snackInfo;
  final Function plusFunc;
  final Function minusFunc;
  final int quantity;
  final double totalAmount;

  MovieSnackTitleAndQtyView(
    this.snackTitle,
    this.snackInfo, {
    this.plusFunc,
    this.minusFunc,
    this.quantity,
    this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: MARGIN_LARGE),
      child: Row(
        children: [
          TitleAndInfoView(title: snackTitle, info: snackInfo),
          Spacer(),
          Column(
            children: [
              Text(
                "$totalAmount\$",
                style: TextStyle(
                  fontSize: TEXT_MEDIUM,
                ),
              ),
              SizedBox(
                height: MARGIN_MEDIUM,
              ),
              Row(
                children: [
                  MinusButtonView(minusFunc),
                  QuantityContainerView(quantity),
                  PlusButtonView(plusFunc),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class MinusButtonView extends StatelessWidget {
  final Function minusFunc;

  MinusButtonView(this.minusFunc);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: minusFunc,
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          border: Border.all(
            color: SECONDARY_TEXT_COLOR,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            bottomLeft: Radius.circular(8),
          ),
        ),
        child: Center(
          child: Text(
            "-",
            style: TextStyle(fontSize: TEXT_REGULAR_3X),
          ),
        ),
      ),
    );
  }
}

class PlusButtonView extends StatelessWidget {
  final Function plusFunc;

  PlusButtonView(this.plusFunc);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => plusFunc(),
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          border: Border.all(
            color: SECONDARY_TEXT_COLOR,
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        child: Center(
          child: Text(
            "+",
            style: TextStyle(fontSize: TEXT_REGULAR_3X),
          ),
        ),
      ),
    );
  }
}

class QuantityContainerView extends StatelessWidget {
  final int quantity;

  QuantityContainerView(this.quantity);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
        border: Border.all(
          color: SECONDARY_TEXT_COLOR,
        ),
      ),
      child: Center(
        child: Text(
          "$quantity",
          style: TextStyle(
            fontSize: TEXT_MEDIUM,
          ),
        ),
      ),
    );
  }
}

class PromoCodeSectionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          cursorColor: PRIMARY_COLOR,
          cursorHeight: MARGIN_LARGE,
          decoration: InputDecoration(
            labelText: ENTER_PROMO_CODE_TITLE,
            labelStyle: TextStyle(
              fontSize: TEXT_MEDIUM,
              color: SECONDARY_TEXT_COLOR,
              fontStyle: FontStyle.italic,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: SECONDARY_TEXT_COLOR,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: PRIMARY_COLOR,
              ),
            ),
          ),
        ),
        SizedBox(
          height: MARGIN_MEDIUM,
        ),
        Row(
          children: [
            LabelTitle(DONT_HAVE_ANY_PROMO_CODE_TITLE),
            Text(GET_IT_NOW_TITLE),
          ],
        ),
      ],
    );
  }
}

class SubTotalSection extends StatelessWidget {
  final double total;

  SubTotalSection(this.total);

  @override
  Widget build(BuildContext context) {
    return Text(
      "Sub total : $total\$",
      style: TextStyle(
          fontSize: TEXT_MEDIUM,
          fontWeight: FontWeight.w600,
          color: SUB_TOTAL_TITLE_COLOR),
    );
  }
}

class TitleAndInfoView extends StatelessWidget {
  const TitleAndInfoView({
    @required this.title,
    @required this.info,
  });

  final String title;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: TEXT_MEDIUM,
            ),
          ),
          SizedBox(
            height: MARGIN_SMALL,
          ),
          LabelTitle(info),
        ],
      ),
    );
  }
}

class PaymentSectionView extends StatelessWidget {
  final List<PaymentMethodVO> paymentList;

  PaymentSectionView(this.paymentList);

  @override
  Widget build(BuildContext context) {
    return (paymentList != null)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SubtitleText(PAYMENT_METHOD_TITLE),
              SizedBox(
                height: MARGIN_MEDIUM_2,
              ),
              PaymentOptionView(
                icon: Icons.credit_card,
                cardTitle: paymentList[0].name,
                cardInfo: paymentList[0].description,
              ),
              SizedBox(
                height: MARGIN_MEDIUM_2,
              ),
              PaymentOptionView(
                icon: Icons.card_travel,
                cardTitle: paymentList[1].name,
                cardInfo: paymentList[1].description,
              ),
              SizedBox(
                height: MARGIN_MEDIUM_2,
              ),
              PaymentOptionView(
                icon: Icons.account_balance_wallet,
                cardTitle: paymentList[2].name,
                cardInfo: paymentList[2].description,
              ),
            ],
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}

class PaymentOptionView extends StatelessWidget {
  final IconData icon;
  final String cardTitle;
  final String cardInfo;

  PaymentOptionView({
    @required this.icon,
    @required this.cardTitle,
    @required this.cardInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: ICON_MEDIUM,
          color: PAYMENT_CARD_ICON_COLOR,
        ),
        SizedBox(
          width: MARGIN_LARGE,
        ),
        TitleAndInfoView(
          title: cardTitle,
          info: cardInfo,
        ),
      ],
    );
  }
}

class PaymentButtonView extends StatelessWidget {
  final double price;
  final Function onTapButton;

  PaymentButtonView(this.price, this.onTapButton);

  @override
  Widget build(BuildContext context) {
    return MainButtonView(
        "Pay \$${price.toStringAsFixed(2)}", () => onTapButton());
  }
}
