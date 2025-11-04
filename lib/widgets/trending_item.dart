import 'package:flutter/material.dart';
import 'package:Flutter_Project_Sori/util/const.dart';

class TrendingItem extends StatefulWidget {
  final String img;
  final String title;
  final String rating;
  final String price;

  const TrendingItem({
    required Key key,
    required this.img,
    required this.title,
    required this.rating,
    required this.price,
  }) : super(key: key);

  @override
  _TrendingItemState createState() => _TrendingItemState();
}

class _TrendingItemState extends State<TrendingItem> {
  @override
  Widget build(BuildContext context) {
    double ratingValue = double.tryParse(widget.rating) ?? 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        height: MediaQuery.of(context).size.height / 2.5,
        width: MediaQuery.of(context).size.width,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          elevation: 3.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    child: Image.asset(
                      widget.img,
                      height: MediaQuery.of(context).size.height / 3.5,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 6.0,
                    left: 6.0,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text(
                          " AVAILABLE ",
                          style: TextStyle(
                            fontSize: 10.0,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),

              // Tên sản phẩm
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              const SizedBox(height: 6.0),

              // Rating bằng sao ⭐ + điểm
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    // Hiển thị các ngôi sao
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < ratingValue.round()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 18.0,
                        );
                      }),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      widget.rating,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6.0),

              // Giá sản phẩm 💰
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  "${widget.price}₫",
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
