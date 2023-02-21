import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  String photoUrl = "";
  String productName = "";
  String productDescription = "";
  String minBidPrice = "";
  String auctionEndTime = "";
  ProductDetailScreen({
    Key? key,
    required this.photoUrl,
    required this.productName,
    required this.productDescription,
    required this.minBidPrice,
    required this.auctionEndTime,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.all(0),
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 50, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.network(widget.photoUrl,height: 300,),
                  ),

                  SizedBox(height: 20,),

                  Text("Product Name: ${widget.productName}",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),

                  SizedBox(height: 10,),

                  Text("${widget.productDescription}",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),

                  SizedBox(height: 40,),

                  Text("Minimum Bidding Price: ${widget.minBidPrice}",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),

                  SizedBox(height: 10,),

                  Text("Auction End Time: ${widget.auctionEndTime}",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),

                  SizedBox(height: 20,),

                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.purple,
                        onPrimary: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0)
                        ),
                        //minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () async {
                        // _submit();
                      },
                      child: const Text(
                        'Place Bid',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
