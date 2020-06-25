import 'package:app_recipes/viewmodal/newsArticleViewModalList.dart';
import 'package:app_recipes/viewmodal/newsarticleViewModel.dart';
import 'package:app_recipes/widgets/dataSharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ListNews extends StatefulWidget {
  final List<NewsarticleViewModal> articles;
  final Function(NewsarticleViewModal article) onSelected;
  ListNews({this.articles, this.onSelected});

  @override
  _ListNewsState createState() => _ListNewsState();
}

class _ListNewsState extends State<ListNews> {
  Future<Null> getRefresh() async {
    await Future.delayed(Duration(seconds: 3));
  }

  String data;
  String savedString = '';

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<NewsArticleViewModelList>(context);
    Future<void> _onRefresh() async {
      // monitor network fetch
      await Future.delayed(Duration(milliseconds: 1000)).then((value) => vm.fetchlinesNews());
      // if failed,use refreshFailed()
    }

    return RefreshIndicator(
      onRefresh:_onRefresh ,
      backgroundColor: Colors.indigo,
      color: Colors.white,
      child: ListView.builder(
          itemCount: widget.articles.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => this.widget.onSelected(widget.articles[index]),
              child: Card(
                elevation: 7,
                color: Colors.grey[50],
                child: Container(
                  height: 250.0,
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 250,
                        width: 200,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 2, 0, 15),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.fromLTRB(7, 8, 7, 7),
                                child: Text(
                                  widget.articles[index].title,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 16, 10),
                                child: Container(
                                  width: 200,
                                  child: Expanded(
                                    child: Text(
                                      widget.articles[index].description == null
                                          ? "there is no description "
                                          : widget.articles[index].description,
                                      textAlign: TextAlign.justify,
                                      maxLines: 4,
                                      style: TextStyle(
                                          fontFamily: "Poppins", fontSize: 13),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: FlatButton(
                                      color: Colors.transparent,
                                      textColor: Colors.white,
                                      disabledColor: Colors.grey,
                                      disabledTextColor: Colors.black,
                                      padding: EdgeInsets.all(5),
                                      splashColor: Colors.blueAccent,
                                      onPressed: () {
                                        setState(() {
                                          StorageUtil.putString(
                                              "myString", "ya atfal y hilwin");
                                        });
                                      },
                                    ))
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                                child: Stack(
                              children: <Widget>[
                                Container(
                                    width: 200,
                                    height: 300,
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(20, 10, 16, 10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(0),
                                        child: widget.articles[index].imgUrl ==
                                                null
                                            ? Image.asset(
                                                "assets/newsplaceholder.png",
                                                fit: BoxFit.cover,
                                              )
                                            : Image.network(
                                                widget.articles[index].imgUrl,
                                                fit: BoxFit.fill),
                                      ),
                                    ),
                                    decoration: new BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blueGrey[100],
                                          blurRadius: 25.0, // soften the shadow
                                          spreadRadius: 1.0, //extend the shadow
                                          offset: Offset(
                                            1.0, // Move to right 10  horizontally
                                            1, // Move to bottom 10 Vertically
                                          ),
                                        )
                                      ],
                                    )),
                              ],
                            )),
                          ])
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
