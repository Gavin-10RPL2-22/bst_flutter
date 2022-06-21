import 'dart:convert';

import 'package:bst/header/HeaderNavigation.dart';
import 'package:bst/model/CategoryModel.dart';

import 'package:bst/view/infomakanan/PorsiMakanan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../model/FoodModel.dart';
import '../reuse/MyRadioListTile.dart';

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? dropdownCategory;
  List? categoryList;
  String? dropdownType;
  List? typeList;
  String? dropdownTambahMenu;
  String? dropdownUbahWaktu;
  bool porsiPageMakanan = false;
  bool mainPageShown = true;
  bool listPageShown = false;
  bool inputPageShown = false;
  bool isLoading = false;
  bool _showButton = false;
  bool _requiredFilter = false;
  TextEditingController makananController = TextEditingController();
  TextEditingController porsiController = TextEditingController();
  TextEditingController inputController = TextEditingController();
  TextEditingController porsiControl = TextEditingController();
  TextEditingController controller = TextEditingController();
  int pageIndicator = 0;
  int foodIndex = 0;
  CategoryModel? firstPageList1;
  List<Datum> items = [];
  List<FoodModel> firstPageList = [
    FoodModel('Bubur Ayam Spesial Plus Lengkap dengan Telor Puyuh', 430, 1, 3.2,
        1.2, 3.5, 2.2, 6.7),
    FoodModel('Bubur Ayam Spesial Plus Lengkap dengan Telor Puyuh', 202, 2, 3.2,
        1.2, 3.5, 2.2, 6.7),
    FoodModel('Bubur Ayam Spesial Plus Lengkap dengan Telor Puyuh', 221, 3, 3.2,
        1.2, 3.5, 2.2, 6.7),
    FoodModel('Bubur Ayam Spesial Plus Lengkap dengan Telor Puyuh', 301, 1, 3.2,
        1.2, 3.5, 2.2, 6.7),
    FoodModel('Bubur Ayam Spesial Plus Lengkap dengan Telor Puyuh', 220, 5, 3.2,
        1.2, 3.5, 2.2, 6.7),
    FoodModel('Bubur Ayam Spesial Plus Lengkap dengan Telor Puyuh', 100, 3, 3.2,
        1.2, 3.5, 2.2, 6.7),
  ];
  List<FoodModel> dropdownItems = [
    FoodModel('Bubur Ayam Spesial Plus Lengkap dengan Telor Puyuh', 430, 1, 3.2,
        1.2, 3.5, 2.2, 6.7),
    FoodModel('Sate Maranggi', 202, 2, 3.2, 1.2, 3.5, 2.2, 6.7),
    FoodModel('Sate Kambing', 221, 3, 3.2, 1.2, 3.5, 2.2, 6.7),
    FoodModel('Sop Betawi', 301, 1, 3.2, 1.2, 3.5, 2.2, 6.7),
    FoodModel('Capcay', 220, 5, 3.2, 1.2, 3.5, 2.2, 6.7),
    FoodModel('Udeh', 100, 3, 3.2, 1.2, 3.5, 2.2, 6.7),
    FoodModel('Udang tepung', 100, 3, 3.2, 1.2, 3.5, 2.2, 6.7),
    FoodModel('Mi Goreng', 100, 3, 3.2, 1.2, 3.5, 2.2, 6.7),
  ];

  getList_PilihanMakanan() async {
    final getUrl = "https://www.zeroone.co.id/bst/food.php";
    print(getUrl);
    Map<String, dynamic> data = {
      "apikey": "bstapp2022",
      "action": "list_food_by_category",
      "FoodCategory": dropdownCategory,
      "UserId": "1",
    };
    var dataUtf = utf8.encode(json.encode(data));
    var dataBase64 = base64.encode(dataUtf);
    final res = await http.post(
      Uri.parse(getUrl),
      body: {'data': dataBase64},
    );
    if (res.statusCode == 200) {
      setState(() {
        isLoading = true;
      });
      firstPageList1 = CategoryModel.fromJson(json.decode(res.body.toString()));
      items = firstPageList1!.data;
      setState(() {
        isLoading = false;
      });
    } else {
      Map<String, dynamic> body = jsonDecode(res.body);
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
        msg: body['message'],
      );
    }
  }

  Future<String> getCategory() async {
    Map<String, dynamic> body = {
      "action": "list_food_category",
      "apikey": "bstapp2022",
    };
    var dataUtf = utf8.encode(json.encode(body));
    var dataBase64 = base64.encode(dataUtf);
    String url = "https://www.zeroone.co.id/bst/list.php";
    var res = await http.post(Uri.parse(url), body: {'data': dataBase64});
    var resBody = json.decode(res.body);
    setState(() {
      categoryList = resBody['Data'];
    });
    print(resBody);
    return "Success";
  }

  Future<String> getType() async {
    Map<String, dynamic> body = {
      "action": "list_food_type",
      "apikey": "bstapp2022",
    };
    var dataUtf = utf8.encode(json.encode(body));
    var dataBase64 = base64.encode(dataUtf);
    String url = "https://www.zeroone.co.id/bst/list.php";
    var res = await http.post(Uri.parse(url), body: {'data': dataBase64});
    var resBody = json.decode(res.body);
    setState(() {
      typeList = resBody['Data'];
    });
    print(resBody);
    return "Success";
  }

  void initState() {
    _requiredFilter = true;
    getType();
    getCategory();
    mainPageShown = true;
    porsiPageMakanan = false;
    inputPageShown = false;
    listPageShown = false;
    FoodModel food = firstPageList[foodIndex];
    // TODO: implement initState
    makananController.text = food.getName;
    porsiController.text = food.portion.toString();
  }

  List<FoodModel> getSuggestions(String query) =>
      List.of(dropdownItems).where((item) {
        final items = item.getName;
        final queries = query;
        return items.contains(queries);
      }).toList();

  Widget nutritionTable(Color color, String name, double gr) {
    return Container(
      width: 160,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(color: color),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500, color: Color(0xFF818181)),
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            gr.toString(),
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600, color: Color(0xFF4CAF50)),
          ),
          Text(
            '\ngr',
            style:
                GoogleFonts.montserrat(color: Color(0xFFC4C4C4), fontSize: 10),
          )
        ],
      ),
    );
  }

  Widget inputFoodPage(FoodModel model) {
    int kalori = 0;
    double karbohidrat = 0.0;
    double lemak = 0.0;
    double protein = 0.0;
    double gula = 0.0;
    double serat = 0.0;
    return Builder(builder: (context) {
      return SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Input Menu Makanan Baru',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4CAF50),
                    fontSize: 16),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              TypeAheadField<FoodModel>(
                  textFieldConfiguration: TextFieldConfiguration(
                      controller: inputController,
                      decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(left: 18, top: 12, bottom: 12),
                          isDense: true,
                          filled: true,
                          suffixIcon: Icon(Icons.arrow_drop_down),
                          fillColor: Colors.transparent,
                          hintStyle: GoogleFonts.openSans(color: Colors.black),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 0.5),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 1),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          hintText: "Choose your Food")),
                  itemBuilder: (BuildContext context, FoodModel suggestion) {
                    final food = suggestion;
                    return Container(
                        margin: EdgeInsets.all(10),
                        child: Text(
                          food.getName,
                          style: GoogleFonts.openSans(),
                        ));
                  },
                  onSuggestionSelected: (FoodModel? suggestion) {
                    final food = suggestion!;
                    setState(() {
                      inputController.text = food.getName;
                      kalori = food.getkal;
                      karbohidrat = food.getK;
                      lemak = food.getL;
                      protein = food.getP;
                      gula = food.getG;
                      serat = food.getS;
                    });
                  },
                  suggestionsCallback: getSuggestions),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 173,
                    child: TextField(
                      controller: porsiController,
                      style: TextStyle(fontSize: 15),
                      textCapitalization: TextCapitalization.sentences,
                      autocorrect: true,
                      enableSuggestions: true,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(left: 18, top: 12, bottom: 12),
                        isDense: true,
                        filled: true,
                        fillColor: Colors.transparent,
                        hintText: 'Porsi',
                        hintStyle: GoogleFonts.openSans(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 0.5),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 18, top: 12, bottom: 12),
                    decoration: BoxDecoration(
                        border: Border.all(width: 0.5),
                        borderRadius: BorderRadius.circular(25)),
                    width: 173,
                    child: Text('Makanan',
                        style: GoogleFonts.openSans(color: Colors.grey)),
                  )
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Container(
                  height: 40,
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.black),
                      borderRadius: BorderRadius.circular(50)),
                  child: DropdownButton<String>(
                    iconSize: 20,
                    isExpanded: true,
                    hint: Text("Pilih waktu makan"),
                    value: dropdownTambahMenu,
                    icon: Icon(Icons.keyboard_arrow_down,
                        color: Color(0xFF99CB57)),
                    underline: SizedBox.shrink(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownTambahMenu = newValue!;
                      });
                    },
                    items: <String>[
                      'Sarapan',
                      'Makan Siang',
                      'Makan Malam',
                      'Snack'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  )),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Text(
                'Informasi Gizi',
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4CAF50),
                    fontSize: 16),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(kalori.toString(),
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF99CB57),
                              fontSize: 58,
                            )),
                        Text(
                          'Kalori',
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF818181),
                              fontSize: 18),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        nutritionTable(
                            Colors.grey.shade200, 'Karbohidrat', karbohidrat),
                        nutritionTable(Colors.transparent, 'Lemak', lemak),
                        nutritionTable(
                            Colors.grey.shade200, 'Protein', protein),
                        nutritionTable(Colors.transparent, 'Gula', gula),
                        nutritionTable(Colors.grey.shade200, 'Serat', serat)
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.240,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/inputimage.png'))),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10, right: 60),
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.04,
                    child: ElevatedButton(
                        child: Text(
                          'UPGRADE NOW',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(fontSize: 12),
                        ),
                        onPressed: () {},
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16))),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFF4CAF50)))),
                  )
                ],
              )
            ],
          ),
        ),
      );
    });
  }

  Widget foodListPage() {
    return Builder(builder: (context) {
      return SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Informasi Makanan",
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4CAF50),
                    fontSize: 16),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyRadioListTile<int>(
                    value: 1,
                    groupValue: pageIndicator,
                    leading: 'Pilihan \n Makanan',
                    // title: Text('One'),
                    onChanged: (value) => setState(() {
                      pageIndicator = value;
                    }),
                  ),
                  MyRadioListTile<int>(
                    value: 2,
                    groupValue: pageIndicator,
                    leading: 'Makanan \n Terakhir',
                    // title: Text('Two'),
                    onChanged: (value) => setState(() {
                      pageIndicator = value;
                    }),
                  ),
                  MyRadioListTile<int>(
                    value: 3,
                    groupValue: pageIndicator,
                    leading: 'Makanan \n Favorit',
                    // title: Text('Three'),
                    onChanged: (value) => setState(() {
                      pageIndicator = value;
                    }),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              pageIndicator == 1
                  ? firstPage()
                  : pageIndicator == 2
                      ? secondPage()
                      : pageIndicator == 3
                          ? thirdPage()
                          : Center(
                              child: Container(
                                margin: EdgeInsets.only(top: 180),
                                width: MediaQuery.of(context).size.width * 0.3,
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/mainlogo.png'))),
                              ),
                            ),
            ],
          ),
        ),
      );
    });
  }

  Future _refresh() async {
    setState(() {
      isLoading = true;
      Future.delayed(Duration(seconds: 2), () {
        getList_PilihanMakanan();
        isLoading = false;
      });
    });
  }

  void addData() {
    setState(() {
      for (int i = firstPageList.length; i < 5; i++) {
        firstPageList.add(FoodModel(
            'Bubur Ayam Spesial Plus Lengkap dengan Telor Puyuh',
            100,
            2,
            3.2,
            1.2,
            3.5,
            2.2,
            6.7));
      }
    });
  }

  void pageSwitcher() {}

  Widget lineSeparator() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 2.0;
        final dashHeight = 1.0;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.grey),
              ),
            );
          }),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }

  Widget foodItem1(FoodModel model, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                model.getName,
                style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700, color: Color(0xFF5C5C60)),
              ),
            ),
            Text(
              model.getkal.toString(),
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w700, fontSize: 12),
            ),
            SizedBox(
              width: 2,
            ),
            Text(
              'Kal',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: Color(0xFF5C5C60)),
            ),
            SizedBox(
              width: 8,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.1,
              height: MediaQuery.of(context).size.height * 0.02,
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      foodIndex = index;
                      mainPageShown = false;
                      inputPageShown = false;
                      porsiPageMakanan = true;
                      listPageShown = false;
                      porsiControl.text = model.getportion.toString();
                    });
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16))),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF99CB57))),
                  child: Text(
                    '+',
                    textAlign: TextAlign.center,
                  )),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          model.getportion.toString() + ' Mangkok',
          style: GoogleFonts.openSans(),
        ),
        SizedBox(
          height: 6,
        ),
        Text(
          'K : ' +
              model.getK.toString() +
              ' |  L : ' +
              model.getL.toString() +
              '  |   P : ' +
              model.getP.toString() +
              '   |   G : ' +
              model.getG.toString() +
              '   |   S :  ' +
              model.getS.toString() +
              '  ',
          style: GoogleFonts.openSans(fontSize: 13),
        ),
        SizedBox(
          height: 11,
        )
      ],
    );
  }

  Widget firstPage() {
    return Builder(builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.724,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: TextField(
                controller: controller,
                style: TextStyle(fontSize: 15),
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(12),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.transparent,
                  hintText: 'Cari nama makanan...',
                  hintStyle: GoogleFonts.openSans(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 0.5),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: Colors.black),
                    borderRadius: BorderRadius.circular(50)),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: dropdownCategory,
                  iconSize: 20,
                  icon: Icon(Icons.arrow_drop_down),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownCategory = newValue!;
                      _requiredFilter = false;
                      if (dropdownCategory != null) {
                        getList_PilihanMakanan();
                      } else {}
                    });
                  },
                  isDense: true,
                  underline: SizedBox.shrink(),
                  items: categoryList?.map((item) {
                        return DropdownMenuItem(
                          child: Text(
                            item['name'],
                            style: GoogleFonts.openSans(color: Colors.grey),
                          ),
                          value: item['id'].toString(),
                        );
                      }).toList() ??
                      [],
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            lineSeparator(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.43,
              child: RefreshIndicator(
                  onRefresh: _refresh,
                  child: _requiredFilter
                      ? Center(child: Text("Masukkan kategori makanan"))
                      : isLoading
                          ? Center(child: CircularProgressIndicator())
                          : ListView.separated(
                              itemBuilder: ((context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            items[index].foodName,
                                            style: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF5C5C60)),
                                          ),
                                        ),
                                        Text(
                                          items[index].calories,
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12),
                                        ),
                                        SizedBox(
                                          width: 2,
                                        ),
                                        Text(
                                          'Kal',
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              color: Color(0xFF5C5C60)),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Container(
                                          width: 28,
                                          height: 18,
                                          child: ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  foodIndex = index;
                                                  mainPageShown = false;
                                                  inputPageShown = false;
                                                  porsiPageMakanan = true;
                                                  listPageShown = false;
                                                  porsiControl.text =
                                                      items[index].portion;
                                                });
                                              },
                                              style: ButtonStyle(
                                                  shape: MaterialStateProperty
                                                      .all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16))),
                                                  backgroundColor:
                                                      MaterialStateProperty.all<
                                                              Color>(
                                                          Color(0xFF99CB57))),
                                              child: Text(
                                                '+',
                                                textAlign: TextAlign.center,
                                              )),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      items[index].portion + ' Mangkok',
                                      style: GoogleFonts.openSans(),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      'K : ' +
                                          items[index].carbohydrate +
                                          ' |  L : ' +
                                          items[index].fat +
                                          '  |   P : ' +
                                          items[index].protein +
                                          '   |   G : ' +
                                          items[index].sugar +
                                          '   |   S :  ' +
                                          items[index].fiber +
                                          '  ',
                                      style: GoogleFonts.openSans(fontSize: 13),
                                    ),
                                    SizedBox(
                                      height: 11,
                                    )
                                  ],
                                );
                              }),
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                return lineSeparator();
                              },
                              itemCount: items.length)),
            ),
            Container(
              height: 45,
              width: 280,
              child: ElevatedButton(
                child: Text('TAMBAH MENU MAKANAN'),
                onPressed: () {
                  setState(() {
                    mainPageShown = false;
                    porsiPageMakanan = false;
                    inputPageShown = true;
                    listPageShown = false;
                  });
                },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24))),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xFF99CB57))),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget secondPage() {
    return Builder(builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.724,
        child: Column(
          children: [
            Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: Colors.black),
                    borderRadius: BorderRadius.circular(50)),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: dropdownType,
                  iconSize: 20,
                  icon: Icon(Icons.arrow_drop_down),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownType = newValue!;
                    });
                  },
                  isDense: true,
                  underline: SizedBox.shrink(),
                  items: typeList?.map((item) {
                        return DropdownMenuItem(
                          child: Text(
                            item['text'],
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                          value: item['id'].toString(),
                        );
                      }).toList() ??
                      [],
                )),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            lineSeparator(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView.separated(
                          itemBuilder: ((context, index) {
                            return foodItem1(
                              firstPageList[index],
                              index,
                            );
                          }),
                          separatorBuilder: (BuildContext context, int index) {
                            return lineSeparator();
                          },
                          itemCount: firstPageList.length),
                    ),
            ),
          ],
        ),
      );
    });
  }

  Widget thirdPage() {
    return Builder(builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.724,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              child: TextField(
                controller: controller,
                style: TextStyle(fontSize: 15),
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(12),
                  isDense: true,
                  filled: true,
                  fillColor: Colors.transparent,
                  hintText: 'Cari nama makanan...',
                  hintStyle: GoogleFonts.openSans(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(width: 0.5)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            lineSeparator(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView.separated(
                          itemBuilder: ((context, index) {
                            return foodItem1(
                              firstPageList[index],
                              index,
                            );
                          }),
                          separatorBuilder: (BuildContext context, int index) {
                            return lineSeparator();
                          },
                          itemCount: firstPageList.length),
                    ),
            ),
          ],
        ),
      );
    });
  }

  Widget porsiMakanan(FoodModel model) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.getName,
              textAlign: TextAlign.start,
              style: GoogleFonts.montserrat(
                  fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              height: MediaQuery.of(context).size.height * 0.23,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tambah makanan",
                    style: GoogleFonts.montserrat(),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  TextField(
                    controller: porsiControl,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    autocorrect: true,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(left: 18, top: 10, bottom: 12),
                      isDense: true,
                      filled: true,
                      fillColor: Colors.transparent,
                      hintText: 'Edit Porsi',
                      hintStyle: GoogleFonts.openSans(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.5, color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      child: DropdownButton<String>(
                        iconSize: 20,
                        isExpanded: true,
                        hint: Text("Ubah waktu"),
                        value: dropdownUbahWaktu,
                        icon: Icon(Icons.keyboard_arrow_down,
                            color: Color(0xFF99CB57)),
                        underline: SizedBox.shrink(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownUbahWaktu = newValue!;
                          });
                        },
                        items: <String>[
                          'Sarapan',
                          'Makan Siang',
                          'Makan Malam',
                          'Snack'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              height: MediaQuery.of(context).size.height * 0.34,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Informasi Nutrisi",
                    style: GoogleFonts.montserrat(),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Kalori",
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF818181)),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.01,
                      ),
                      Text(
                        model.getkal.toString() + " Kalori",
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4CAF50)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  tableNutrisi("Karbo", model.getK),
                  tableNutrisi("Lemak", model.getL),
                  tableNutrisi("Protein", model.getP),
                  tableNutrisi("Gula", model.getG),
                  tableNutrisi("Serat", model.getS),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 275),
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      mainPageShown = true;
                      porsiPageMakanan = false;
                      inputPageShown = false;
                      listPageShown = false;
                    });
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xFF99CB57))),
                  child: Text(
                    'Simpan',
                    textAlign: TextAlign.center,
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget tableNutrisi(String name, double gr) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500, color: Color(0xFF818181)),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.01,
            ),
            Text(
              gr.toString() + " gr",
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600, color: Color(0xFF4CAF50)),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
      ],
    );
  }

  Widget mainPage() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            inputPageShown = false;
            mainPageShown = false;
            listPageShown = true;
          });
        },
        child: Text('Pindah'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          title: HeaderNavigation(
            title: '',
          ),
        ),
        body: mainPageShown
            ? mainPage()
            : listPageShown
                ? foodListPage()
                : porsiPageMakanan
                    ? porsiMakanan(firstPageList[foodIndex])
                    : inputPageShown
                        ? inputFoodPage(firstPageList[foodIndex])
                        : Container());
  }
}
