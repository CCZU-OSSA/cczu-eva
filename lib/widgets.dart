import 'package:cczu_eva/type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

var alertPattern = RegExp(r"(?<=alert\(')\S+(?='\))");

class EvaluationPanl extends StatefulWidget {
  final Function(Rating rating, PartRatings parts, String comment) onSave;
  const EvaluationPanl({super.key, required this.onSave});

  @override
  State<StatefulWidget> createState() => EvaluationPanlState();
}

class EvaluationPanlState extends State<EvaluationPanl> {
  RatingBar buildRatingbar({required Function(Rating rating) onUpdate}) {
    return RatingBar.builder(
      initialRating: 1,
      minRating: 0,
      direction: Axis.horizontal,
      itemCount: 3,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => const Icon(
        Icons.thumb_up,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        onUpdate(Rating.values[rating.toInt()]);
      },
    );
  }

  Rating rating1 = Rating.normal;
  Rating rating2 = Rating.normal;
  Rating rating3 = Rating.normal;
  Rating rating4 = Rating.normal;
  Rating rating5 = Rating.normal;
  Rating rating6 = Rating.normal;
  Rating rating = Rating.normal;
  late TextEditingController comment;
  @override
  void initState() {
    super.initState();
    comment = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    comment.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: const Text("德育素材"),
          trailing: buildRatingbar(
            onUpdate: (rating) => rating1 = rating,
          ),
        ),
        ListTile(
          title: const Text("教学方法"),
          trailing: buildRatingbar(
            onUpdate: (rating) => rating2 = rating,
          ),
        ),
        ListTile(
          title: const Text("课堂氛围"),
          trailing: buildRatingbar(
            onUpdate: (rating) => rating3 = rating,
          ),
        ),
        ListTile(
          title: const Text("授课内容"),
          trailing: buildRatingbar(
            onUpdate: (rating) => rating4 = rating,
          ),
        ),
        ListTile(
          title: const Text("交流互动"),
          trailing: buildRatingbar(
            onUpdate: (rating) => rating5 = rating,
          ),
        ),
        ListTile(
          title: const Text("课后作业"),
          trailing: buildRatingbar(
            onUpdate: (rating) => rating6 = rating,
          ),
        ),
        ListTile(
          title: const Text("总体评价"),
          trailing: buildRatingbar(
            onUpdate: (rating) => this.rating = rating,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        TextField(
          maxLines: null,
          controller: comment,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), labelText: "意见建议"),
        ),
        const SizedBox(
          height: 8,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton(
              onPressed: () {
                widget.onSave(
                    rating,
                    (rating1, rating2, rating3, rating4, rating5, rating6),
                    comment.text);
              },
              child: const Text("保存")),
        ),
      ],
    );
  }
}
