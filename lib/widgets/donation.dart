import 'package:flutter/material.dart';
import 'package:petfinder/commons/styles.dart';

class Donation extends StatefulWidget {
  @override
  _DonationState createState() => _DonationState();
}

class _DonationState extends State<Donation>
    with AutomaticKeepAliveClientMixin<Donation> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  child: Text('Donate 5 €'),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  child: Text('Donate 10 €'),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: 100,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(

                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: 'amount €'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  child: Text('Donate!'),
                  onPressed: () {},
                ),
              )
            ],
          ),
          Expanded(
            child: Center(
              child: Container(
                margin: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5)),
                padding: EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.payment,
                      size: 40,
                    ),
                    Text(
                      'Payment method',
                      style: sectionText,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
