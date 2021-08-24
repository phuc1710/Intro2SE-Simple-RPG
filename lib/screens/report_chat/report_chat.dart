import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:simple_rpg/models/report.dart';
import 'package:simple_rpg/models/user.dart';

class ReportChat extends StatefulWidget {
  const ReportChat({Key? key, this.args}) : super(key: key);
  final args;
  @override
  _ReportChatState createState() => _ReportChatState();
}

class _ReportChatState extends State<ReportChat> {
  bool isSearch = false;
  bool isInit = true;
  var reportGeneral;
  var totalReports;
  var page = 0;
  var lastPage;
  var showReports;
  final searchController = TextEditingController();
  var isInDetail = false;
  var allReportRef;
  static const reportPerPage = 5;
  static const topElePadding = 10.0;
  @override
  void initState() {
    super.initState();
    allReportRef = Report.getAllReportRef();
    allReportRef?.onChildAdded.listen(_onReportAdded);
    allReportRef?.onChildRemoved.listen(_onReportRemoved);
    reportGeneral = getReportGeneral(Report.getListReport());
  }

  _onReportAdded(event) {
    if (this.mounted) {
      setState(() {
        var newReport = Report.fromDB(event.snapshot.value);
        try {
          totalReports.add(newReport);
          showReports = totalReports;
          reportGeneral = getReportGeneral(totalReports);
        } catch (e) {}
      });
    }
  }

  _onReportRemoved(event) {
    if (this.mounted) {
      setState(() {
        var removedReport = Report.fromDB(event.snapshot.value);
        removeAndUpdate(removedReport);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return reportGeneral;
  }

  Column getReportGeneral(dynamic list) {
    return Column(
      children: [
        Expanded(
          child: searchBar(),
        ),
        Expanded(
          flex: 6,
          child: isInit ? getAsync(list) : getSync(list),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      page--;
                      if (page >= 0)
                        reportGeneral = getReportGeneral(getPageUsers());
                      else
                        page = 0;
                    });
                  },
                  child: Text('Trang trước'),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      page++;
                      if (page <= getLastPage())
                        reportGeneral = getReportGeneral(getPageUsers());
                      else
                        page = getLastPage();
                    });
                  },
                  child: Text('Trang tiếp theo'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Padding searchBar({backButton}) {
    return Padding(
      padding: EdgeInsets.all(topElePadding),
      child: Row(children: [
        Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Card(
                child: TextField(
                  enabled: !isSearch,
                  controller: searchController,
                ),
              ),
            ),
            flex: 7),
        Expanded(
          child: TextButton(
            child: Icon(
              isSearch ? Icons.close : Icons.search,
              color: Colors.white,
            ),
            style: ButtonStyle(
              backgroundColor: isSearch
                  ? MaterialStateProperty.all(Colors.red[400])
                  : MaterialStateProperty.all(Colors.blue),
              splashFactory: NoSplash.splashFactory,
            ),
            onPressed: () {
              setState(() {
                if (!isSearch) {
                  if (searchController.text != '') {
                    isSearch = !isSearch;
                    final searchKey = searchController.text.toLowerCase();
                    var matchReports = [];
                    var fromCon, chatCon;
                    for (var rp in totalReports) {
                      fromCon = rp.fromUsername
                          .toLowerCase()
                          .contains(searchKey.toLowerCase());
                      chatCon = rp.chat
                          .toLowerCase()
                          .contains(searchKey.toLowerCase());
                      if (fromCon || chatCon) {
                        matchReports.add(rp);
                      }
                    }
                    showReports = matchReports;
                    page = 0;
                    reportGeneral = getReportGeneral(getPageUsers());
                  }
                } else {
                  searchController.clear();
                  isSearch = !isSearch;
                  page = 0;
                  showReports = totalReports;
                  reportGeneral = getReportGeneral(getPageUsers());
                }
              });
            },
          ),
          flex: 1,
        ),
      ]),
    );
  }

  FutureBuilder<List<dynamic>> getAsync(Future<List<dynamic>> list) {
    return FutureBuilder<List>(
      future: list,
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          totalReports = snapshot.data;
          showReports = totalReports;
          isInit = false;
          return getSync(getPageUsers());
        }
        return SpinKitRing(
          color: Colors.blue,
        );
      },
    );
  }

  removeAndUpdate(listReport) {
    removeReport(listReport);
    reportGeneral = getReportGeneral(totalReports);
  }

  removeReport(listReport) {
    for (var i = 0; i < totalReports.length; ++i) {
      if (listReport.compare(totalReports[i])) {
        totalReports.removeAt(i);
        break;
      }
    }
  }

  Widget getSync(List<dynamic> list) {
    return list.length == 0
        ? Center(
            child: Text('KHÔNG CÓ BÁO CÁO NÀO'),
          )
        : ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, index) {
              Report listReport = list[index];
              return Card(
                child: ListTile(
                  leading: Icon(
                    listReport.isRequest ? Icons.article : Icons.feedback,
                    color:
                        listReport.isRequest ? Colors.green : Colors.amber[700],
                    size: 40.0,
                  ),
                  title: Text(
                    listReport.isRequest
                        ? listReport.fromUsername
                        : listReport.toUsername,
                    style: TextStyle(color: Colors.indigo),
                  ),
                  subtitle: Text(
                    listReport.chat,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  trailing: listReport.isRequest
                      ? requestMenu(listReport, context)
                      : reportMenu(listReport, context),
                ),
              );
            },
          );
  }

  PopupMenuButton<String> reportMenu(Report listReport, BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'normal-ban',
          child: Text(
            'CẤM',
            style: TextStyle(color: Colors.amber),
          ),
        ),
        PopupMenuItem<String>(
          value: 'custom-ban',
          child: Text(
            'CẤM TÙY CHỈNH',
            style: TextStyle(color: Colors.red),
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Text(
            'XÓA',
            style: TextStyle(color: Colors.grey),
          ),
        )
      ],
      onSelected: (result) {
        setState(() {
          var invalidValue = -1;
          switch (result) {
            case 'normal-ban':
              User.banByUsername(listReport.toUsername);
              listReport.remove();
              break;
            case 'custom-ban':
              Future<int?> rs = showDialog<int>(
                context: context,
                builder: (BuildContext context) {
                  var banInputController = TextEditingController();
                  return AlertDialog(
                    title: Text('ĐỊNH THỜI GIAN CẤM'),
                    content: TextField(
                      controller: banInputController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Day',
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          var value;
                          try {
                            value = int.parse(banInputController.text);
                            if (value <= 0)
                              Navigator.pop(context, invalidValue);
                            else
                              Navigator.pop(context, value);
                          } catch (e) {
                            Navigator.pop(context, invalidValue);
                          }
                        },
                        child: Text(
                          'CẤM',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              );
              rs.then((value) {
                if (value == -1) {
                  showInvalidAlert();
                } else if (value != null) {
                  User.banByUsername(listReport.toUsername, value);
                  listReport.remove();
                }
              });
              break;
            case 'delete':
              listReport.remove();
              break;
          }
        });
      },
    );
  }

  PopupMenuButton<String> requestMenu(Report listReport, BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'remove',
          child: Text(
            'GỠ',
            style: TextStyle(color: Colors.green),
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          child: Text(
            'XÓA',
            style: TextStyle(color: Colors.grey),
          ),
        )
      ],
      onSelected: (result) {
        setState(() {
          switch (result) {
            case 'remove':
              User.unbanByUsername(listReport.fromUsername);
              listReport.remove();
              break;
            case 'delete':
              listReport.remove();
              break;
          }
        });
      },
    );
  }

  showInvalidAlert() {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.only(top: 20),
          content: Column(
            children: [
              Icon(
                Icons.warning_amber,
                color: Colors.red,
                size: 50,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'THỜI GIAN NHẬP KHÔNG HỢP LỆ',
                style: TextStyle(fontWeight: FontWeight.w700),
              )
            ],
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List getPageUsers() {
    if (showReports.length == 0) return showReports;
    if (page == getLastPage()) return showReports.sublist(page * reportPerPage);
    return showReports.sublist(
        page * reportPerPage, (page + 1) * reportPerPage);
  }

  int getLastPage() {
    return (showReports.length / reportPerPage).ceil() - 1;
  }
}
