import 'package:flutter/material.dart';
import 'package:news_app/model/article.dart';

class ClickedArticle extends StatefulWidget {
  Article article;

  ClickedArticle(this.article);

  @override
  _ClickedArticleState createState() => _ClickedArticleState();
}

class _ClickedArticleState extends State<ClickedArticle> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "India",
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                padding: EdgeInsets.all(5),
                child: Text(
                  widget.article.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                )),
            SizedBox(
              height: 10,
            ),
            Image.network(widget.article.urlToImage),
            SizedBox(
              height: 5,
            ),
            Container(
                padding: EdgeInsets.all(5),
                child: Text(
                    "Publish at : ${widget.article.publishedAt.substring(0, widget.article.publishedAt.indexOf('T'))}")),
            SizedBox(
              height: 5,
            ),
            Container(
              padding: EdgeInsets.all(8),
              child: InkWell(
                onLongPress: () {

                  showMenu(context: context, position: RelativeRect.fromLTRB(0.0, 300.0, 300.0, 0.0), items: [
                    PopupMenuItem(
                      child:Row(
                        children: <Widget>[

                        ],
                      )
                    )


              /*      PopupMenuItem(
                      child: Row(
                        children: <Widget>[
                          // TODO: Dynamic items / handle click
                          PopupMenuItem(
                            child: Text(
                              "Paste",
                              style: Theme.of(context)
                                  .textTheme
                                  .body2
                                  .copyWith(color: Colors.red),
                            ),
                          ),
                          PopupMenuItem(
                            child: Text("Select All"),
                          ),
                        ],
                      ),
                    ),*/
                  ],);
                },
                child: SelectableText(
                  widget.article.content
                      .substring(0, widget.article.content.indexOf('[')),
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontFamily: "Roboto Slab",
                    fontSize: 17,
                  ),

                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
