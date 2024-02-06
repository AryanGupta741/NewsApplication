import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:newsapp/models/categories_new_model.dart';
import 'package:newsapp/models/news_channel_headlines_modle.dart';
import 'package:newsapp/view/authentication.dart';
import 'package:newsapp/view/news_detail_screen.dart';
import 'package:newsapp/view_model/news_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'cateogires_screen.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({super.key});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

enum FilterList { bbcNews, aryNews, politico, reuters, cnn, alJazeera }

class _Home_ScreenState extends State<Home_Screen> {
  NewsViewModel newsViewModel = NewsViewModel();
  FilterList? selectedMenu;
  String name = 'bbc-news';
  // if data format give an error that time import intl packages. it also define the formate of a data and time
  final format = DateFormat('MMMM dd yyyy');
  @override
  Widget build(BuildContext context) {
/* the MediaQuery is used because the size of screen is different for every mobile then mediaQuery is used to automaticaly change the size of hight and width according to the screen and with the help of all the component change the size 

================= by defult the size of the screen is --------- 1 ===================
*/

    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CategoriesScreen(),
              ),
            );
          },
          iconSize: 10,
          icon: Image.asset('assets/images/category_icon.png'),
        ),
        title: Text(
          'News',
          style: GoogleFonts.poppins(
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const authForm()));
              },
              icon: const Icon(Icons.logout_outlined)),
          PopupMenuButton<FilterList>(
              initialValue: selectedMenu,
              onSelected: (FilterList item) {
                if (FilterList.bbcNews.name == item.name) {
                  name = 'bbc-news';
                }
                if (FilterList.aryNews.name == item.name) {
                  name = 'ary-news';
                }
                if (FilterList.politico.name == item.name) {
                  name = 'politico';
                }
                if (FilterList.reuters.name == item.name) {
                  name = 'reuters';
                }
                if (FilterList.cnn.name == item.name) {
                  name = 'CNN';
                }
                if (FilterList.alJazeera.name == item.name) {
                  name = 'al-jazeera-english';
                }
                setState(() {
                  selectedMenu = item;
                });
              },
              itemBuilder: (BuildContext context) =>
                  //<<>> these means the value in popmenu enter the filterlist values.
                  <PopupMenuEntry<FilterList>>[
                    PopupMenuItem<FilterList>(
//popupbutton is used because fittering the news easly
                        value: FilterList.bbcNews,
                        child: Text('BBC-NEWS')),
                    PopupMenuItem<FilterList>(
                        value: FilterList.aryNews, child: Text('ARY-NEWS')),
                    PopupMenuItem(
                        value: FilterList.politico, child: Text('POLITICO')),
                    PopupMenuItem(
                        value: FilterList.reuters, child: Text('REUTERS')),
                    PopupMenuItem(value: FilterList.cnn, child: Text('CNN')),
                    PopupMenuItem(
                        value: FilterList.alJazeera, child: Text('ALJAZEERA')),
                  ])
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * .55,
            width: width,
            child: FutureBuilder<NewsChannelsHeadlinesModel>(
                future: newsViewModel.fetchNewChannelHeadlinesApi(name),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.blue,
                      ),
                    );
                  } else {
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.articles!.length,
                        itemBuilder: (context, index) {
                          //convert the date and time to json formate to normal readalble

                          // Datetime object give me an Datetime values and store in datetime variable
                          DateTime dateTime = DateTime.parse(snapshot
                              .data!
                              .articles!
                                  //Returns a string representation of (some of) the elements of this
                                  [index]
                              .publishedAt
                              .toString());
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewsDetailScreen(
                                          newsImage: snapshot
                                              .data!.articles![index].urlToImage
                                              .toString(),
                                          newsAuthor: snapshot
                                              .data!.articles![index].author
                                              .toString(),
                                          newsContent: snapshot
                                              .data!.articles![index].content
                                              .toString(),
                                          newsDate: format.format(dateTime),
                                          newsDesc: snapshot.data!
                                              .articles![index].description
                                              .toString(),
                                          newsSource: snapshot
                                              .data!.articles![index].source
                                              .toString(),
                                          newsTitle: snapshot
                                              .data!.articles![index].title
                                              .toString(),
                                        )),
                              );
                            },
                            child: SizedBox(
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: height * 0.6,
                                    width: width * .9,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: height * .02),

                                    /* sometimes it gives the error because you do not put the import the package or file of the cachenetworkImage */
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot
                                            .data!.articles![index].urlToImage
                                            .toString(),
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Container(
                                          child: SpinKitFadingCircle(
                                            color: Colors.blue,
                                            size: 50,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error_outline,
                                                color: Colors.red),
                                      ),
                                    ),
                                  ),
                                  // the positoned is used to which contant container/box come in bottom.
                                  Positioned(
                                    //represents a curved rectangular container with
                                    //rounded edges
                                    bottom: 5,
                                    child: Card(
                                      elevation: 5,
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Container(
                                          alignment: Alignment.bottomCenter,
                                          padding: EdgeInsets.all(15),
                                          height: height * .22,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: width * 0.7,
                                                child: Text(
                                                    snapshot.data!
                                                        .articles![index].title
                                                        .toString(),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w700)),
                                              ),
                                              //create the two button in white container first is source and  date & time.
                                              Spacer(),
                                              Container(
                                                width: width * 0.7,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      snapshot
                                                          .data!
                                                          .articles![index]
                                                          .source!
                                                          .name
                                                          .toString(),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                    ),
                                                    Text
                                                        // DateTime object datetime is created to get the values of the date, and a format varible is used to format it as a string with the pattern 'yyyy-MM-dd HH:mm:ss'. and then
                                                        //format function calling is access the date time values and set the values according to the format.
                                                        // In otherWords Use the format.format() method to format the DateTime object using the format pattern:
                                                        (
                                                      format.format(dateTime),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: FutureBuilder<CategoriesNewsModel>(
                future: newsViewModel.fetchCategoriesNewsApi('Entertainment'),
                builder: (BuildContext context, snapshot) {
                  //snapshot.connectionState == ConnectionState.waiting is means It's used to check the current state of a data fetch or computation and take actions accordingly,,,
                  //the line snapshot.connectionState == ConnectionState.waiting, it's checking if the asynchronous operation represented by snapshot is still in the "waiting" state, meaning it's still ongoing and hasn't yet completed.
                  if (snapshot.connectionState == ConnectionState.waiting)
                  // snapshot is means It can be used to track the progress of the operation and access the data once it's available.
                  {
                    return const Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.blue,
                      ),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: snapshot.data!.articles!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          DateTime dateTime = DateTime.parse(snapshot
                              .data!.articles![index].publishedAt
                              .toString());

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewsDetailScreen(
                                        newsImage: snapshot
                                            .data!.articles![index].urlToImage
                                            .toString(),
                                        newsTitle: snapshot.data!.articles![index].title
                                            .toString(),
                                        newsDate: format.format(dateTime),
                                        newsAuthor: snapshot
                                            .data!.articles![index].author
                                            .toString(),
                                        newsDesc: snapshot
                                            .data!.articles![index].description
                                            .toString(),
                                        newsContent: snapshot
                                            .data!.articles![index].content
                                            .toString(),
                                        newsSource: snapshot
                                            .data!.articles![index].source
                                            .toString())),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot
                                          .data!.articles![index].urlToImage
                                          .toString(),
                                      fit: BoxFit.cover,
                                      height: height * .18,
                                      width: width * .3,
                                      placeholder: (context, url) => Container(
                                          child: Center(
                                        child: SpinKitCircle(
                                          size: 50,
                                          color: Colors.blue,
                                        ),
                                      )),
                                      errorWidget: (context, url, error) =>
                                          Icon(
                                        Icons.error_outline,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                  // this is the container that holddown all these element that present in the container
                                  Expanded(
                                      child: Container(
                                    height: height * .18,
                                    padding: EdgeInsets.only(left: 15),
                                    child: Column(
                                      children: [
                                        Text(
                                          snapshot.data!.articles![index].title
                                              .toString(),
                                          maxLines: 3,
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Spacer(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                snapshot.data!.articles![index]
                                                    .source!.name
                                                    .toString(),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              format.format(dateTime),
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ))
                                ],
                              ),
                            ),
                          );
                        });
                  }
                }),
          )
        ],
      ),
    );
  }
}
