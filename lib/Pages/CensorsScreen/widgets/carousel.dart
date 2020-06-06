// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:clubscouts/models/places.dart';
// import 'package:flutter/material.dart';

// class CarouselMap extends StatelessWidget {
//   final List<Places> places;
//   final dynamic onItemChanged;

//   CarouselMap({this.places, this.onItemChanged});

//   _onChange(int page) {
//     onItemChanged(page, places[page]);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CarouselSlider(
//       onPageChanged: _onChange,
//       autoPlay: false,
//       height: 120.0,
//       items: places.map((i) {
//         return Builder(
//           builder: (BuildContext context) {
//             return GestureDetector(
//               onTap: () {
//                 //To Each Places Social Page By Id 
//               },
//               child: Container(
//                   width: MediaQuery.of(context).size.width,
//                   margin: EdgeInsets.symmetric(horizontal: 7.0),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(8.0),
//                     ),
//                     gradient: LinearGradient(
//                       colors: [
//                         Color(0xFF626487),
//                         Color(0xFF393A51),
//                       ],
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       tileMode: TileMode.clamp,
//                     ),
//                   ),
//                   child: _buildCard(i)),
//             );
//           },
//         );
//       }).toList(),
//     );
//   }

//   _buildCard(Places place) {
//     return Row(
//       children: <Widget>[
//         Padding(
//           padding: EdgeInsets.only(left: 12.0),
//           child: CircleAvatar(
//             backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
//             radius: 32.0,
//             child: Text(
//               place.description.substring(0, 1).toUpperCase(),
//               style: TextStyle(color: Colors.deepPurple, fontSize: 35.0),
//             ),
//           ),
//         ),
//         Expanded(
//             child: Padding(
//           padding: EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Padding(
//                 padding: EdgeInsets.only(bottom: 4),
//                 child: Text(
//                   place.description,
//                   style: TextStyle(color: Colors.white, fontSize: 16.0),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(bottom: 4),
//                 child: Text(
//                   place.address,
//                   style: TextStyle(color: Colors.white, fontSize: 12.0),
//                   maxLines: 2,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(top: 4.0),
//                 child: LinearProgressIndicator(
//                   backgroundColor: Color.fromRGBO(0, 0, 0, 0.3),
//                   valueColor: AlwaysStoppedAnimation(Colors.deepPurple),
//                   value: place.rating / 5,
//                 ),
//               ),
//               Text(
//                 'Rating: ${place.rating * 20.0}/100',
//                 style: TextStyle(color: Colors.white, fontSize: 12.0),
//               ),
//             ],
//           ),
//         )),
//       ],
//     );
//   }
// }
