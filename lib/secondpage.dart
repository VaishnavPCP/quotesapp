
import 'package:flutter/material.dart';
import 'package:quotesapp/utils.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;


class Secondpage extends StatefulWidget {

  String Category;
  Secondpage(this.Category);

  @override
  State<Secondpage> createState() => _SecondpageState();
}

class _SecondpageState extends State<Secondpage> {
  List quotes=[];
  List author=[];
  bool isdata=false;
  void initState(){
    super.initState();
    getquotes();
  }
  void getquotes()async{
    String url="https://quotes.toscrape.com/tag/${widget.Category}/";
    Uri uri=Uri.parse(url);
    http.Response response=await http.get(uri);
    dom.Document document=parser.parse(response.body);
    final quotesclass=document.getElementsByClassName("quote");
    print(quotesclass);
    quotes=quotesclass.map((element) => element.getElementsByClassName("text")[0].innerHtml).toList();
    author=quotesclass.map((element) => element.getElementsByClassName("author")[0].innerHtml).toList();
    setState(() {
      isdata=true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Quotes",
          style: textStyle(20, Colors.white, FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xcffAAB6AA),
      ),
      backgroundColor: Color(0xcff39FBA9F,),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(left: 8,right: 8),
          child: Column(
            children: [
              SizedBox(height: 10,),
              Center(
                  child: Text(
                "${widget.Category} Quotes".toUpperCase(),
                style: textStyle(20, Colors.white, FontWeight.bold),
              )),
              SizedBox(height: 10,),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: quotes.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white70),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                 quotes[index],
                                style: textStyle(18, Colors.black, FontWeight.bold),
                              ),
                            ),
                            Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                              "- ${author[index]}",
                              style: textStyle(
                                  20,
                                  Colors.black,
                                FontWeight.bold
                              ),
                            ),
                                )),
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }

}
