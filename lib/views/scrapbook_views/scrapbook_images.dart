import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
import 'package:scrap_real/widgets/scrapbook_widgets/custom_scrapimage.dart';
import 'package:scrap_real/widgets/text_widgets/custom_header.dart';
import 'package:scrap_real/widgets/text_widgets/custom_text.dart';

class ScrapbookImagesPage extends StatefulWidget {
  final String scrapbookId;
  const ScrapbookImagesPage({
    Key? key,
    required this.scrapbookId,
  }) : super(key: key);
  @override
  State<ScrapbookImagesPage> createState() => _ScrapbookImagesPageState();
}

class _ScrapbookImagesPageState extends State<ScrapbookImagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 40,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CustomBackButton(buttonFunction: () {
                  Navigator.of(context).pop();
                }),
                CustomHeader(headerText: "Scrapbook Images"),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:scrap_real/widgets/button_widgets/custom_backbutton.dart';
// import 'package:scrap_real/widgets/scrapbook_widgets/custom_scrapimage.dart';
// import 'package:scrap_real/widgets/text_widgets/custom_header.dart';
// import 'package:scrap_real/widgets/text_widgets/custom_text.dart';

// class ScrapbookImagesPage extends StatefulWidget {
//   final String scrapbookId;
//   const ScrapbookImagesPage({
//     Key? key,
//     required this.scrapbookId,
//   }) : super(key: key);
//   @override
//   State<ScrapbookImagesPage> createState() => _ScrapbookImagesPageState();
// }

// class _ScrapbookImagesPageState extends State<ScrapbookImagesPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: AnnotatedRegion<SystemUiOverlayStyle>(
//         value: SystemUiOverlayStyle.light,
//         child: GestureDetector(
//           child: SingleChildScrollView(
//             physics: const AlwaysScrollableScrollPhysics(),
//             padding: const EdgeInsets.symmetric(
//               horizontal: 10,
//               vertical: 40,
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 CustomBackButton(buttonFunction: () {
//                   Navigator.of(context).pop();
//                 }),
//                 CustomHeader(headerText: "Scrapbook Images"),
//                 const SizedBox(height: 15),
//                 imgContainer3(),
//                 const SizedBox(height: 30),
//                 InkWell(
//                   onTap: () {},
//                   child: const Icon(
//                     Icons.add,
//                     color: Colors.blue,
//                     size: 50,
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 CustomText(
//                   text: "Add an image to this scrapbook!",
//                   textSize: 15,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // Widget imgContainer2() {
//   //   return GridView.builder(
//   //     itemCount: 19,
//   //     physics: const NeverScrollableScrollPhysics(),
//   //     shrinkWrap: true,
//   //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//   //       crossAxisCount: 3,
//   //       childAspectRatio: 1,
//   //       mainAxisSpacing: 10,
//   //       crossAxisSpacing: 10,
//   //     ),
//   //     itemBuilder: (BuildContext context, int index) {
//   //       return scrapImg();
//   //     },
//   //   );
//   // }

//   // Widget scrapImg() {
//   //   return Container(
//   //     width: 100,
//   //     height: 100,
//   //     decoration: BoxDecoration(
//   //       borderRadius: BorderRadius.circular(5),
//   //       color: Colors.grey.shade300,
//   //     ),
//   //     child: InkWell(
//   //       onTap: () {
//   //         Navigator.push(
//   //           context,
//   //           MaterialPageRoute(builder: (context) => const ExpandedImagePage()),
//   //         );
//   //       },
//   //     ),
//   //   );
//   // }

//   Widget imgContainer3() {
//     var postsStream = FirebaseFirestore.instance
//         .collection('posts')
//         .where('scrapbookId', isEqualTo: widget.scrapbookId)
//         .snapshots();
//     return StreamBuilder<QuerySnapshot>(
//       stream: postsStream,
//       builder: (context, snapshots) {
//         if (!snapshots.hasData) {
//           return const Center(
//             child: CircularProgressIndicator(color: Color(0xFF918EF4)),
//           );
//         }
//         return (snapshots.connectionState == ConnectionState.waiting)
//             ? const Center(
//                 child: CircularProgressIndicator(color: Color(0xFF918EF4)),
//               )
//             : snapshots.data!.docs.isEmpty
//                 ? const SizedBox()
//                 : GridView.builder(
//                     itemCount: snapshots.data!.docs.length,
//                     physics: const NeverScrollableScrollPhysics(),
//                     shrinkWrap: true,
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 3,
//                       childAspectRatio: 1,
//                       mainAxisSpacing: 10,
//                       crossAxisSpacing: 10,
//                     ),
//                     itemBuilder: (BuildContext context, int index) {
//                       var data = snapshots.data!.docs[index].data()
//                           as Map<String, dynamic>;

//                       return CustomScrapbookImage(
//                         postId: data['postId'],
//                       );
//                     },
//                   );
//       },
//     );
//   }
// }
