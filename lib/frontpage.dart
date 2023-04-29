import 'package:flutter/material.dart';
import 'package:quotesapp/secondpage.dart';
import 'package:quotesapp/utils.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
class Frontpage extends StatefulWidget {
const Frontpage({Key? key}) : super(key: key);
  @override
  State<Frontpage> createState() => _FrontpageState();

}

class _FrontpageState extends State<Frontpage> {
  List authors = [];
  List quotes = [];
  List category = ["love", "inspirational", "life", "books"];
  bool isdata=false;

  void initState(){
    super.initState();
    getquotes();
  }
  void getquotes()async {
    String url = "https://quotes.toscrape.com/";
    Uri uri = Uri.parse(url);
    http.Response response = await http.get(uri);
    dom.Document document = parser.parse(response.body);
    final quotesclass = document.getElementsByClassName("quote");
    print(quotesclass);
    quotes =
        quotesclass.map((element) => element.getElementsByClassName("text")[0]
            .innerHtml).toList();
    authors =
        quotesclass.map((element) => element.getElementsByClassName("author")[0]
            .innerHtml).toList();
    setState(() {
      isdata = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "QUOTES",
          style: textStyle(20, Colors.white, FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xcffAAB6AA),
      ),
      backgroundColor: Color(0xcff39FBA9F),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 7,
                mainAxisSpacing: 7,
                childAspectRatio: 6 / 4,
                children: category.map((category) {
                  return InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Secondpage(category)));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.black45),
                      child: Center(
                        child: Text(
                          category.toUpperCase(),
                          style: textStyle(20, Colors.white, FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
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
                                    "- ${authors[index]}",
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
